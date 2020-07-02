
-- Description:
-- Calculation of invariant mass based on LUTs.

-- Version history:
-- HB 2020-06-03: first design (based on mass_calculator.vhd)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_invariant_calc is
    generic (
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28
    );
    port(
        pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        invariant_mass_sq_div2 : out std_logic_vector(MAX_MASS_VECTOR_WIDTH-1 downto 0) := (others => '0')
    );
end mass_invariant_calc;

architecture rtl of mass_invariant_calc is

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    constant MASS_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;

    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";

begin

-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    invariant_mass_sq_div2(MASS_VECTOR_WIDTH-1 downto 0) <= pt1 * pt2 * (cosh_deta - cos_dphi);
    
end architecture rtl;
