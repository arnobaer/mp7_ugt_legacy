
-- Description:
-- Collection of cuts comparators for correlations

-- Version history:
-- HB 2020-08-10: inserted twobody unconstraint pt.
-- HB 2020-08-07: inserted invariant mass for unconstraint pt.
-- HB 2020-06-03: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity cuts_comp is
     generic(
        deta_cut: boolean := false;
        dphi_cut: boolean := false;
        dr_cut: boolean := false;
        mass_cut: boolean := false;
        mass_type: natural := 1;
        twobody_pt_cut: boolean := false;
        twobody_upt_cut: boolean := false;

        deta_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_upper_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_upper_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_div_dr_upper_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_div_dr_lower_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        tbupt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_width: positive := 56;
        mass_div_dr_width: positive := 83;
        tbpt_width: positive := 50;
        tbupt_width: positive := 50

    );
    port(
        deta: in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        dphi: in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        dr: in std_logic_vector(2*DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        mass_inv: in std_logic_vector(MAX_MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
        mass_inv_upt: in std_logic_vector(MAX_MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
        mass_trv: in std_logic_vector(MAX_MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
        mass_div_dr: in std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        tbpt: in std_logic_vector(MAX_TBPT_VECTOR_WIDTH-1 downto 0) := (others => '0');
        tbupt: in std_logic_vector(MAX_TBPT_VECTOR_WIDTH-1 downto 0) := (others => '0');
        deta_comp: out std_logic := '1';
        dphi_comp: out std_logic := '1';
        dr_comp: out std_logic := '1';
        mass_inv_comp: out std_logic := '1';
        mass_inv_upt_comp: out std_logic := '1';
        mass_trv_comp: out std_logic := '1';
        mass_div_dr_comp: out std_logic := '1';
        twobody_pt_comp: out std_logic := '1';
        twobody_upt_comp: out std_logic := '1'
    );
end cuts_comp; 

architecture rtl of cuts_comp is

    signal deta_upper_limit_t: std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal deta_lower_limit_t: std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal dphi_upper_limit_t: std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal dphi_lower_limit_t: std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal dr_upper_limit_t: std_logic_vector(2*DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal dr_lower_limit_t: std_logic_vector(2*DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal mass_upper_limit_t: std_logic_vector(mass_width-1 downto 0);
    signal mass_lower_limit_t: std_logic_vector(mass_width-1 downto 0);
    signal mass_div_dr_upper_limit_t: std_logic_vector(mass_div_dr_width-1 downto 0);
    signal mass_div_dr_lower_limit_t: std_logic_vector(mass_div_dr_width-1 downto 0);
    signal tbpt_threshold_t: std_logic_vector(tbpt_width-1 downto 0);
    signal tbupt_threshold_t: std_logic_vector(tbupt_width-1 downto 0);
    
begin

    deta_upper_limit_t <= deta_upper_limit(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    deta_lower_limit_t <= deta_lower_limit(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    
    dphi_upper_limit_t <= dphi_upper_limit(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    dphi_lower_limit_t <= dphi_lower_limit(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    
    dr_upper_limit_t <= dr_upper_limit(2*DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    dr_lower_limit_t <= dr_lower_limit(2*DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    
    mass_upper_limit_t <= mass_upper_limit(mass_width-1 downto 0);
    mass_lower_limit_t <= mass_lower_limit(mass_width-1 downto 0);
    
    mass_div_dr_upper_limit_t <= mass_div_dr_upper_limit(mass_div_dr_width-1 downto 0);
    mass_div_dr_lower_limit_t <= mass_div_dr_lower_limit(mass_div_dr_width-1 downto 0);
    
    tbpt_threshold_t <= tbpt_threshold(tbpt_width-1 downto 0);
    tbupt_threshold_t <= tbupt_threshold(tbupt_width-1 downto 0);
    
                -- DETA
                deta_i: if deta_cut = true generate
                    deta_comp <= '1' when deta >= deta_lower_limit_t and deta <= deta_upper_limit_t else '0';
                end generate deta_i;
                -- DPHI
                dphi_i: if dphi_cut = true generate
                    dphi_comp <= '1' when dphi >= dphi_lower_limit_t and dphi <= dphi_upper_limit_t else '0';
                end generate dphi_i;
                -- DR
                dr_i: if dr_cut = true generate
                    dr_comp <= '1' when dr >= dr_lower_limit_t and dr <= dr_upper_limit_t else '0';
                end generate dr_i;
                -- MASS INV
                mass_inv_i: if mass_cut = true and mass_type = INVARIANT_MASS_TYPE generate
                    mass_inv_comp <= '1' when mass_inv(mass_width-1 downto 0) >= mass_lower_limit_t and mass_inv(mass_width-1 downto 0) <= mass_upper_limit_t else '0';
                end generate mass_inv_i;
                -- MASS INV UPT
                mass_inv_upt_i: if mass_cut = true and mass_type = INVARIANT_MASS_UPT_TYPE generate
                    mass_inv_upt_comp <= '1' when mass_inv_upt(mass_width-1 downto 0) >= mass_lower_limit_t and mass_inv_upt(mass_width-1 downto 0) <= mass_upper_limit_t else '0';
                end generate mass_inv_upt_i;
                -- MASS TRV
                mass_trv_i: if mass_cut = true and mass_type = TRANSVERSE_MASS_TYPE generate
                    mass_trv_comp <= '1' when mass_trv(mass_width-1 downto 0) >= mass_lower_limit_t and mass_trv(mass_width-1 downto 0) <= mass_upper_limit_t else '0';
                end generate mass_trv_i;
                -- MASS DIV DR
                mass_div_dr_i: if mass_cut = true and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
                    mass_div_dr_comp <= '1' when mass_div_dr(mass_div_dr_width-1 downto 0) >= mass_div_dr_lower_limit_t and mass_div_dr(mass_div_dr_width-1 downto 0) <= mass_div_dr_upper_limit_t else '0';
                end generate mass_div_dr_i;
                -- TWO BODY PT
                tbpt_i: if twobody_pt_cut = true  generate
                    twobody_pt_comp <= '1' when tbpt(tbpt_width-1 downto 0) >= tbpt_threshold_t else '0';
                end generate tbpt_i;
                -- TWO BODY PT
                tbupt_i: if twobody_upt_cut = true  generate
                    twobody_upt_comp <= '1' when tbupt(tbupt_width-1 downto 0) >= tbupt_threshold_t else '0';
                end generate tbpt_i;
    
end architecture rtl;
