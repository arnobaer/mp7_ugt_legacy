
-- Description:
-- Condition for invariant mass with 3 muon objects.

-- Version history:
-- HB 2020-08-19: bug fix isolation LUT default value.
-- HB 2020-08-14: reordered generic, added default values.
-- HB 2020-07-02: changed for new cuts structure (calculation outside of conditions). New name.
-- HB 2020-04-27: reverted to former version.
-- HB 2020-04-24: update instance of mass_calculator.
-- HB 2020-02-25: separated sum and comp.
-- HB 2020-02-24: changed mass calculation and loop indices for sum.
-- HB 2020-02-20: cleaned up code.
-- HB 2020-02-19: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_muon_mass_3_obj_condition is
     generic(

        muon1_object_low: natural := 0;
        muon1_object_high: natural := 7;
        pt_ge_mode_muon1: boolean := true;
        pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_muon1: natural := 0;
        eta_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_muon1: boolean := true;
        phi_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_muon1: boolean := true;
        phi_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        requested_charge_muon1: string(1 to 3) := "ign";
        qual_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0) := (others => '1');
        iso_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0) := (others => '1');
        upt_cut_muon1 : boolean := false;
        upt_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.ip_high-D_S_I_MUON_V2.ip_low+1)-1 downto 0) := (others => '1');

        muon2_object_low: natural := 0;
        muon2_object_high: natural := 7;
        pt_ge_mode_muon2: boolean := true;
        pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_muon2: natural := 0;
        eta_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_muon2: boolean := true;
        phi_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_muon2: boolean := true;
        phi_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        requested_charge_muon2: string(1 to 3) := "ign";
        qual_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0) := (others => '1');
        iso_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0) := (others => '1');
        upt_cut_muon2 : boolean := false;
        upt_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.ip_high-D_S_I_MUON_V2.ip_low+1)-1 downto 0) := (others => '1');

        muon3_object_low: natural := 0;
        muon3_object_high: natural := 7;
        pt_ge_mode_muon3: boolean := true;
        pt_threshold_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_muon3: natural := 0;
        eta_w1_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_muon3: boolean := true;
        phi_w1_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_muon3: boolean := true;
        phi_w2_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        requested_charge_muon3: string(1 to 3) := "ign";
        qual_lut_muon3: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0) := (others => '1');
        iso_lut_muon3: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0) := (others => '1');
        upt_cut_muon3 : boolean := false;
        upt_upper_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_muon3: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_muon3: std_logic_vector(2**(D_S_I_MUON_V2.ip_high-D_S_I_MUON_V2.ip_low+1)-1 downto 0) := (others => '1');

        requested_charge_correlation: string(1 to 2);

        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_width: positive := MAX_WIDTH_MASS_LIMIT_VECTOR

    );
    port(
        lhc_clk: in std_logic;
        muon_data_i: in muon_objects_array;
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        mass_inv : in mass_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end muon_muon_mass_3_obj_condition; 

architecture rtl of muon_muon_mass_3_obj_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type muon1_object_vs_template_array is array (muon1_object_low to muon1_object_high, 1 to 1) of std_logic;
    type muon2_object_vs_template_array is array (muon2_object_low to muon2_object_high, 1 to 1) of std_logic;
    type muon3_object_vs_template_array is array (muon3_object_low to muon3_object_high, 1 to 1) of std_logic;

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
--***************************************************************

    signal muon1_obj_vs_templ, muon1_obj_vs_templ_pipe : muon1_object_vs_template_array;
    signal muon2_obj_vs_templ, muon2_obj_vs_templ_pipe : muon2_object_vs_template_array;
    signal muon3_obj_vs_templ, muon3_obj_vs_templ_pipe : muon3_object_vs_template_array;

    signal mass_comp, mass_comp_pipe : 
        std_logic_3dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) := (others => (others => (others => '0')));

    type sum_mass_array is array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic_vector(mass_width+1 downto 0);
    signal sum_mass, sum_mass_temp : sum_mass_array := (others => (others => (others => (others => '0'))));   

    signal condition_and_or : std_logic;

begin

    -- *** section: CUTs - begin ***************************************************************************************

    l1_sum: for i in 0 to NR_MUON_OBJECTS-1 generate
        l2_sum: for j in 0 to NR_MUON_OBJECTS-1 generate
            l3_sum: for k in 0 to NR_MUON_OBJECTS-1 generate
                sum_mass_l: if j>i and k>i and k>j generate
                    sum_mass_calc_i: entity work.sum_mass_calc
                        generic map(mass_width)  
                        port map(mass_inv(i,j), mass_inv(i,k), mass_inv(j,k), sum_mass_temp(i,j,k));
                    sum_mass(i,j,k) <= sum_mass_temp(i,j,k);
                    sum_mass(i,k,j) <= sum_mass_temp(i,j,k);
                    sum_mass(j,i,k) <= sum_mass_temp(i,j,k);
                    sum_mass(j,k,i) <= sum_mass_temp(i,j,k);
                    sum_mass(k,i,j) <= sum_mass_temp(i,j,k);
                    sum_mass(k,j,i) <= sum_mass_temp(i,j,k);
                end generate sum_mass_l;
            end generate l3_sum;    
        end generate l2_sum;
    end generate l1_sum;
    
    l1_comp: for i in muon1_object_low to muon1_object_high generate
        l2_comp: for j in muon2_object_low to muon2_object_high generate
            l3_comp: for k in muon3_object_low to muon3_object_high generate
                mass_comp(i,j,k) <= '1' when sum_mass(i,j,k) >= mass_lower_limit_vector(mass_width-1 downto 0) and
                    sum_mass(i,j,k) <= mass_upper_limit_vector(mass_width-1 downto 0) else '0';
            end generate l3_comp;    
        end generate l2_comp;
    end generate l1_comp;

    -- *** section: CUTs - end ***************************************************************************************

    obj_templ1_l: for i in muon1_object_low to muon1_object_high generate
        obj_templ1_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon1,
                pt_threshold_muon1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                nr_eta_windows_muon1,
                eta_w1_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w1_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                phi_full_range_muon1,
                phi_w1_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon1,
                phi_w2_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon1,
                qual_lut_muon1,
                iso_lut_muon1,
                upt_cut_muon1,
                upt_upper_limit_muon1(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                upt_lower_limit_muon1(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                ip_lut_muon1
            )
            port map(muon_data_i(i), muon1_obj_vs_templ(i,1));
    end generate obj_templ1_l;

    obj_templ2_l_l: for i in muon2_object_low to muon2_object_high generate
        obj_templ2_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon2,
                pt_threshold_muon2(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                nr_eta_windows_muon2,
                eta_w1_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w1_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                phi_full_range_muon2,
                phi_w1_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon2,
                phi_w2_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon2,
                qual_lut_muon2,
                iso_lut_muon2,
                upt_cut_muon2,
                upt_upper_limit_muon2(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                upt_lower_limit_muon2(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                ip_lut_muon2
            )
            port map(muon_data_i(i), muon2_obj_vs_templ(i,1));
    end generate obj_templ2_l_l;

    obj_templ3_l_l: for i in muon3_object_low to muon3_object_high generate
        obj_templ3_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon3,
                pt_threshold_muon3(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                nr_eta_windows_muon3,
                eta_w1_upper_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w1_lower_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_upper_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_lower_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_upper_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_lower_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_upper_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_lower_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_upper_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_lower_limit_muon3(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                phi_full_range_muon3,
                phi_w1_upper_limit_muon3(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon3(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon3,
                phi_w2_upper_limit_muon3(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon3(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon3,
                qual_lut_muon3,
                iso_lut_muon3,
                upt_cut_muon3,
                upt_upper_limit_muon3(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                upt_lower_limit_muon3(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                ip_lut_muon3
            )
            port map(muon_data_i(i), muon3_obj_vs_templ(i,1));
    end generate obj_templ3_l_l;

    -- Charge correlation comparison
    charge_triple_l_1: for i in muon1_object_low to muon1_object_high generate
        charge_triple_l_2: for j in muon2_object_low to muon2_object_high generate
            charge_triple_l_3: for k in muon3_object_low to muon3_object_high generate
                charge_triple_if: if (j/=i and k/=i and k/=j) generate
                    charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                                                '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                                                '1' when requested_charge_correlation = "ig" else
                                                '0';
                end generate charge_triple_if;
            end generate charge_triple_l_3;
        end generate charge_triple_l_2;
    end generate charge_triple_l_1;

    -- Pipeline stage for obj_vs_templ and mass_comp
    pipeline_p: process(lhc_clk, muon1_obj_vs_templ, muon2_obj_vs_templ, muon3_obj_vs_templ, mass_comp, charge_comp_triple)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
            muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
            muon3_obj_vs_templ_pipe <= muon3_obj_vs_templ;
            mass_comp_pipe <= mass_comp;
            charge_comp_triple_pipe <= charge_comp_triple;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
                muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
                muon3_obj_vs_templ_pipe <= muon3_obj_vs_templ;
                mass_comp_pipe <= mass_comp;
                charge_comp_triple_pipe <= charge_comp_triple;
            end if;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, muon3_obj_vs_templ_pipe, charge_comp_triple_pipe, mass_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((muon1_object_high-muon1_object_low+1)*(muon2_object_high-muon2_object_low+1)*(muon3_object_high-muon3_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in muon1_object_low to muon1_object_high loop 
            for j in muon2_object_low to muon2_object_high loop
                for k in muon3_object_low to muon3_object_high loop
                    if j/=i and i/=k and j/=k then
                        index := index + 1;
                        obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and muon3_obj_vs_templ_pipe(k,1) and 
                            charge_comp_triple_pipe(i,j,k) and mass_comp_pipe(i,j,k);
                    end if;
                end loop;
            end loop;
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_p;

    -- Pipeline stage for condition output.
    condition_o_pipeline_p: process(lhc_clk, condition_and_or)
        begin
            if conditions_pipeline_stage = false then 
                condition_o <= condition_and_or;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;
    
end architecture rtl;
    
    
    
    
    
    
    
    
    
    
