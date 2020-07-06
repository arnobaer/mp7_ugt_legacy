
-- Description:
-- Calculation of invariant mass divided by deltaR based on LUTs (ROMs).

-- Version history:
-- HB 2020-05-29: moved comparison to mass_div_dr_comp.vhd.
-- HB 2020-05-14: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_invariant_div_dr_calc is
    generic (
        rom_sel : natural := CALO_CALO_ROM;
        deta_bins_width : natural := 8;
        dphi_bins_width : natural := 8;
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        inv_dr_sq_width: positive := 26
    );
    port(
        clk : in std_logic;
        deta_bin : in std_logic_vector(deta_bins_width-1 downto 0) := (others => '0');
        dphi_bin : in std_logic_vector(dphi_bins_width-1 downto 0) := (others => '0');
        invariant_mass_sq_div2 : in std_logic_vector(MAX_MASS_VECTOR_WIDTH-1 downto 0);        
        mass_div_dr : out std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0')
    );
end mass_invariant_div_dr_calc;

architecture rtl of mass_invariant_div_dr_calc is

    COMPONENT rom_lut_calo_inv_dr_sq_all
    PORT (
        clk : IN STD_LOGIC;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(25 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_muon_inv_dr_sq_all
    PORT (
        clk : IN STD_LOGIC;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(27 DOWNTO 0)
    );
    END COMPONENT;
    
    constant mass_div_dr_vector_width : positive := pt1_width+pt2_width+cosh_cos_width+inv_dr_sq_width;

    constant max_mass_div_dr : std_logic_vector(mass_div_dr_vector_width-1 downto 0) := (others => '1');
    signal invariant_mass_sq_div2_int : std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0);
    signal inv_dr_sq : std_logic_vector(inv_dr_sq_width-1 downto 0);
    
    attribute use_dsp : string;
    attribute use_dsp of mass_div_dr : signal is "yes";

begin

    invariant_mass_sq_div2_int <= invariant_mass_sq_div2(pt1_width+pt2_width+cosh_cos_width-1 downto 0);

-- one clk for ROM
    rom_lut_calo_sel: if rom_sel = CALO_CALO_ROM generate
        rom_lut_i : rom_lut_calo_inv_dr_sq_all
            port map (
                clk => clk,
                deta => deta_bin,
                dphi => dphi_bin,
                dout => inv_dr_sq
            );
    end generate rom_lut_calo_sel;

    rom_lut_muon_sel: if rom_sel = MU_MU_ROM generate
        rom_lut_i : rom_lut_muon_inv_dr_sq_all
            port map (
                clk => clk,
                deta => deta_bin,
                dphi => dphi_bin,
                dout => inv_dr_sq
            );
    end generate rom_lut_muon_sel;

-- LUT value for deta=0 and dphi=0 (dR=0, 1/dR=undefined) => 0, which means mass_div_dr is on it's maximum
    mass_div_dr(mass_div_dr_vector_width-1 downto 0) <= (invariant_mass_sq_div2_int * inv_dr_sq) when (inv_dr_sq > 0) else max_mass_div_dr;
    
end architecture rtl;
