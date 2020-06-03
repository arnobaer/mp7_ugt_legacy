
-- Description:
-- Calculation of Delta-R 

-- Version history:
-- HB 2020-06-03: first design (based on dr_calculator.vhd)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity delta_r_calc is
    port(
        diff_eta : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        diff_phi : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        dr_squared : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0)
    );
end delta_r_calc;

architecture rtl of delta_r_calc is
    signal diff_eta_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal diff_phi_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);

    attribute use_dsp : string;
    attribute use_dsp of diff_eta_squared : signal is "yes";
    attribute use_dsp of diff_phi_squared : signal is "yes";
    attribute use_dsp of dr_squared : signal is "yes";

begin

-- HB 2015-11-26: calculation of ΔR**2 with formular ΔR**2 = (eta1-eta2)**2+(phi1-phi2)**2
    diff_eta_squared <= diff_eta*diff_eta;
    diff_phi_squared <= diff_phi*diff_phi;
    dr_squared <= diff_eta_squared+diff_phi_squared;

end architecture rtl;
