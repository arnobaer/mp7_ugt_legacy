
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_calo_calo_correlation_orm_condition_TB is
end calo_calo_calo_correlation_orm_condition_TB;

architecture rtl of calo_calo_calo_correlation_orm_condition_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    signal jet_bx_0: calo_objects_array(0 to 11);
    signal tau_bx_0: calo_objects_array(0 to 11);
    signal jet_tau_bx_0_bx_0_delta_r_vector: delta_r_vector_array(0 to 11, 0 to 11);
    signal jet_jet_bx_0_bx_0_mass_inv_vector: mass_vector_array(0 to 11, 0 to 11);

    signal invariant_mass_ov_rm_i286: std_logic;

--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
        wait for 3 * LHC_CLK_PERIOD; 
        wait for 7 ns; 
        jet_bx_0 <= (("00000"&X"00"&X"00"&("000"&X"50")), ("00000"&X"00"&X"00"&("000"&X"60")), others => X"00000000");
        tau_bx_0 <= (("00000"&"01"&X"00"&X"00"&('0'&X"5B")), others => X"00000000");
        jet_tau_bx_0_bx_0_delta_r_vector <= (others => (others => X"000B000"));
        jet_jet_bx_0_bx_0_mass_inv_vector <= ((X"0000125B7F3D40", X"0000125B7F3D40", others => X"00000000000000"), others => (others => X"00000000000000"));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&X"00"&X"00"&("000"&X"50")), ("00000"&X"00"&X"00"&("000"&X"60")), others => X"00000000");
        tau_bx_0 <= (("00000"&"01"&X"00"&X"00"&('0'&X"5B")), others => X"00000000");
        jet_tau_bx_0_bx_0_delta_r_vector <= ((X"0000034", X"0000028", others => X"0000000"), others => (others => X"0000000"));
        jet_jet_bx_0_bx_0_mass_inv_vector <= ((X"0000125B7F3D40", X"0000125B7F3D40", others => X"00000000000000"), others => (others => X"00000000000000"));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&X"00"&X"00"&("000"&X"30")), ("00000"&X"00"&X"00"&("000"&X"20")), others => X"00000000");
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"5B")), others => X"00000000");
        jet_tau_bx_0_bx_0_delta_r_vector <= (others => (others => X"1000000"));
        jet_jet_bx_0_bx_0_mass_inv_vector <= (others => (others => X"10000000000000"));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (others => X"00000000");
        tau_bx_0 <= (others => X"00000000");
        jet_tau_bx_0_bx_0_delta_r_vector <= (others => (others => X"1000000"));
        jet_jet_bx_0_bx_0_mass_inv_vector <= (others => (others => X"10000000000000"));
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------

invariant_mass_ov_rm_i286_i: entity work.calo_calo_calo_correlation_orm_condition
    generic map(
        true,
        false, false, true,
        false, false, false, true, 0, false,
        NR_JET_OBJECTS,        
        0, 11, true, JET_TYPE,
        X"0046",
        0,
        X"0000", X"0000",
        X"0000", X"0000",
        X"0000", X"0000",
        X"0000", X"0000",
        X"0000", X"0000",
        true, X"0000", X"0000",
        true, X"0000", X"0000",
        X"F",
        NR_TAU_OBJECTS,        
        0, 11, true, TAU_TYPE,
        X"005A",
        0, 
        X"0000", X"0000",
        X"0000", X"0000",
        X"0000", X"0000",
        X"0000", X"0000",
        X"0000", X"0000",
        true, X"0000", X"0000",
        true, X"0000", X"0000",
        X"E",
        X"00000000", X"00000000",
        X"00000000", X"00000000",
        X"000000000000A028", X"0000000000000000",
        X"00000000", X"00000000",
        X"00000000", X"00000000",
        X"0000000000000000", X"0000000000000000",
        X"00041A6642C78140", X"000000025B7F3D40",
        X"0000000000000000",        
        JET_JET_MASS_VECTOR_WIDTH,
        nr_obj_calo2 => NR_JET_OBJECTS,        
        calo2_object_low => 0, calo2_object_high => 11, et_ge_mode_calo2 => true, obj_type_calo2 => JET_TYPE,
        et_threshold_calo2 => X"0046",
        nr_eta_windows_calo2 => 0, 
        eta_w1_upper_limit_calo2 => X"0000", eta_w1_lower_limit_calo2 => X"0000",
        eta_w2_upper_limit_calo2 => X"0000", eta_w2_lower_limit_calo2 => X"0000",
        eta_w3_upper_limit_calo2 => X"0000", eta_w3_lower_limit_calo2 => X"0000",
        eta_w4_upper_limit_calo2 => X"0000", eta_w4_lower_limit_calo2 => X"0000",
        eta_w5_upper_limit_calo2 => X"0000", eta_w5_lower_limit_calo2 => X"0000",
        phi_full_range_calo2 => true, 
        phi_w1_upper_limit_calo2 => X"0000", phi_w1_lower_limit_calo2 => X"0000",
        phi_w2_ignore_calo2 => true, 
        phi_w2_upper_limit_calo2 => X"0000", phi_w2_lower_limit_calo2 => X"0000",
        iso_lut_calo2 => X"F"
    )
    port map(lhc_clk, jet_bx_0, jet_bx_0, tau_bx_0,    
        dr_orm => jet_tau_bx_0_bx_0_delta_r_vector,    
        mass_inv_12 => jet_jet_bx_0_bx_0_mass_inv_vector,
        condition_o => invariant_mass_ov_rm_i286);

end rtl;

