
-- Desription:
-- Correlation Condition module for muon objects.

-- Version history:
-- HB 2020-08-19: bug fix isolation LUT default value.
-- HB 2020-08-14: reordered generic, added default values.
-- HB 2020-08-10: inserted twobody unconstraint pt.
-- HB 2020-08-07: inserted invariant mass for unconstraint pt.
-- HB 2020-07-02: changed for new cuts structure (calculation outside of conditions).
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" and "impact parameter".
-- HB 2020-06-04: updated process cuts_pipeline_p.
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from muon_muon_correlation_condition_v4 to muon_muon_correlation_condition.
-- HB 2017-10-02: based on muon_muon_correlation_condition_v3 - used limit vectors for correlation cuts.
-- HB 2017-09-06: inserted port muon2_data_i again - bug fix.
-- HB 2017-09-05: removed port muon2_data_i, used muon1_data_i instead in logic.
-- HB 2017-08-18: improved cuts_instances loops.
-- HB 2017-07-03: changed to muon_muon_correlation_condition_v3 for correct use of different object slices.
-- HB 2017-06-28: charge correlation comparison inserted for different bx data (bug fix).
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DR). Using integer for cos and sin phi inputs.
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations only for one half of permutations, second half by assignment of "mirrored" indices
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-01: used "muon_object_low" and "muon_object_high" for object ranges.
-- HB 2017-01-20: used only "pt_width" generic parameter instead of "pt_width_1" and "pt_width_2".
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2017-01-18: first design of version 2 - replaced "invariant_mass" with "mass_cuts".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_muon_correlation_condition is
    generic(
        same_bx: boolean; 

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

        requested_charge_correlation: string(1 to 2) := "ig";

        deta_cut: boolean := false;
        deta_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_cut: boolean := false;
        dphi_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_cut: boolean := false;
        dr_upper_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_cut: boolean := false;
        mass_type: natural := INVARIANT_MASS_TYPE;
        mass_width: positive := MAX_WIDTH_MASS_LIMIT_VECTOR;
        mass_upper_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_div_dr_width: positive := MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR;
        mass_div_dr_upper_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_div_dr_lower_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        twobody_pt_cut: boolean := false;
        tbpt_width: positive := MAX_WIDTH_TBPT_LIMIT_VECTOR;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
--         tbupt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
        
   );
    port(
        lhc_clk: in std_logic;
        muon1_data_i: in muon_objects_array;
        muon2_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        deta : in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        dphi : in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        dr : in delta_r_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_inv : in mass_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_inv_upt : in mass_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_trv : in mass_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_div_dr : in mass_div_dr_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        tbpt : in tbpt_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
--         tbupt : in tbpt_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end muon_muon_correlation_condition; 

architecture rtl of muon_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
--     constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
-- obj_vs_templ_pipeline_stage not used, because of 1 bx pipeline of ROMs (for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd)

    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal muon1_obj_vs_templ, muon1_obj_vs_templ_pipe : std_logic_2dim_array(muon1_object_low to muon1_object_high, 1 to 1);
    signal muon2_obj_vs_templ, muon2_obj_vs_templ_pipe : std_logic_2dim_array(muon2_object_low to muon2_object_high, 1 to 1);

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--***************************************************************

    signal deta_comp_t, deta_comp, deta_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal dphi_comp_t, dphi_comp, dphi_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal dr_comp_t, dr_comp, dr_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_inv_comp_t, mass_inv_comp, mass_inv_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_inv_upt_comp_t, mass_inv_upt_comp, mass_inv_upt_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_trv_comp_t, mass_trv_comp, mass_trv_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal tbpt_comp_t, tbpt_comp, tbpt_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
--     signal tbupt_comp_t, tbupt_comp, tbupt_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
--     (others => (others => '1'));

    signal condition_and_or : std_logic;
    
begin

    -- Comparison with limits.
    cuts_l_1: for i in muon1_object_low to muon1_object_high generate 
        cuts_l_2: for j in muon2_object_low to muon2_object_high generate
            same_i: if (same_bx = true) and j>i generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_cut, dphi_cut => dphi_cut, dr_cut => dr_cut, mass_cut => mass_cut, mass_type => mass_type, twobody_pt_cut => twobody_pt_cut,
                        deta_upper_limit => deta_upper_limit, deta_lower_limit => deta_lower_limit, dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                        dr_upper_limit => dr_upper_limit, dr_lower_limit => dr_lower_limit, mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                        mass_div_dr_upper_limit => mass_div_dr_upper_limit, mass_div_dr_lower_limit => mass_div_dr_lower_limit, tbpt_threshold => tbpt_threshold,
                        mass_width => mass_width, mass_div_dr_width => mass_div_dr_width, tbpt_width => tbpt_width
                    )
                    port map(
                        deta => deta(i,j), dphi => dphi(i,j), dr => dr(i,j), mass_inv => mass_inv(i,j), mass_inv_upt => mass_inv_upt(i,j), mass_trv => mass_trv(i,j),
                        mass_div_dr => mass_div_dr(i,j), tbpt => tbpt(i,j),
                        deta_comp => deta_comp_t(i,j), dphi_comp => dphi_comp_t(i,j), dr_comp => dr_comp_t(i,j), mass_inv_comp => mass_inv_comp_t(i,j), 
                        mass_inv_upt_comp => mass_inv_upt_comp_t(i,j), mass_div_dr_comp => mass_div_dr_comp_t(i,j), mass_trv_comp => mass_trv_comp_t(i,j), twobody_pt_comp => tbpt_comp_t(i,j)
                    );
                deta_comp(i,j) <= deta_comp_t(i,j);
                deta_comp(j,i) <= deta_comp_t(i,j);
                dphi_comp(i,j) <= dphi_comp_t(i,j);
                dphi_comp(j,i) <= dphi_comp_t(i,j);
                dr_comp(i,j) <= dr_comp_t(i,j);
                dr_comp(j,i) <= dr_comp_t(i,j);
                mass_inv_comp(i,j) <= mass_inv_comp_t(i,j);
                mass_inv_comp(j,i) <= mass_inv_comp_t(i,j);
                mass_inv_upt_comp(i,j) <= mass_inv_upt_comp_t(i,j);
                mass_inv_upt_comp(j,i) <= mass_inv_upt_comp_t(i,j);
                mass_trv_comp(i,j) <= mass_trv_comp_t(i,j);
                mass_trv_comp(j,i) <= mass_trv_comp_t(i,j);                
                mass_div_dr_comp_pipe(i,j) <= mass_div_dr_comp_t(i,j);
                mass_div_dr_comp_pipe(j,i) <= mass_div_dr_comp_t(i,j);
                tbpt_comp(i,j) <= tbpt_comp_t(i,j);
                tbpt_comp(j,i) <= tbpt_comp_t(i,j);                
--                 tbupt_comp(i,j) <= tbupt_comp_t(i,j);
--                 tbupt_comp(j,i) <= tbupt_comp_t(i,j);                
            end generate same_i;
            not_same_i: if same_bx = false generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_cut, dphi_cut => dphi_cut, dr_cut => dr_cut, mass_cut => mass_cut, mass_type => mass_type, twobody_pt_cut => twobody_pt_cut,
                        deta_upper_limit => deta_upper_limit, deta_lower_limit => deta_lower_limit, dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                        dr_upper_limit => dr_upper_limit, dr_lower_limit => dr_lower_limit, mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                        mass_div_dr_upper_limit => mass_div_dr_upper_limit, mass_div_dr_lower_limit => mass_div_dr_lower_limit, tbpt_threshold => tbpt_threshold,
                        mass_width => MU_MU_MASS_VECTOR_WIDTH, mass_div_dr_width => MU_MU_MASS_DIV_DR_VECTOR_WIDTH, tbpt_width => MU_MU_TBPT_VECTOR_WIDTH
                    )
                    port map(
                        deta => deta(i,j), dphi => dphi(i,j), dr => dr(i,j), mass_inv => mass_inv(i,j), mass_inv_upt => mass_inv_upt(i,j), mass_trv => mass_trv(i,j),
                        mass_div_dr => mass_div_dr(i,j), tbpt => tbpt(i,j),
                        deta_comp => deta_comp(i,j), dphi_comp => dphi_comp(i,j), dr_comp => dr_comp(i,j), mass_inv_comp => mass_inv_comp(i,j), 
                        mass_inv_upt_comp => mass_inv_upt_comp(i,j), mass_div_dr_comp => mass_div_dr_comp_pipe(i,j), mass_trv_comp => mass_trv_comp(i,j), twobody_pt_comp => tbpt_comp(i,j)
                    );
            end generate not_same_i;
        end generate cuts_l_2;
    end generate cuts_l_1;
    
--  ***************************************************************************************
    -- Charge correlation comparison
    charge_double_l_1: for i in muon1_object_low to muon1_object_high generate 
        charge_double_l_2: for j in muon2_object_low to muon2_object_high generate
            obj_same_bx_l: if same_bx = true generate
                charge_double_if: if j/=i generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                               '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                               '1' when requested_charge_correlation = "ig" else
                                               '0';
                end generate charge_double_if;
            end generate obj_same_bx_l;
            obj_different_bx_l: if same_bx = false generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                               '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                               '1' when requested_charge_correlation = "ig" else
                                               '0';
            end generate obj_different_bx_l;
        end generate charge_double_l_2;
    end generate charge_double_l_1;

--  ***************************************************************************************

    -- Pipeline stage for charge correlation comparison
    cuts_pipeline_p: process(lhc_clk, deta_comp, dphi_comp, dr_comp, mass_inv_comp, mass_inv_upt_comp, mass_trv_comp, tbpt_comp, charge_comp_double)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_inv_comp_pipe <= mass_inv_comp;
            mass_inv_upt_comp_pipe <= mass_inv_upt_comp;
            mass_trv_comp_pipe <= mass_trv_comp;
            tbpt_comp_pipe <= tbpt_comp;
--             tbupt_comp_pipe <= tbupt_comp;
            charge_comp_double_pipe <= charge_comp_double;
        end if;
    end process;
    
--  ***************************************************************************************

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
            port map(muon1_data_i(i), muon1_obj_vs_templ(i,1));
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
            port map(muon2_data_i(i), muon2_obj_vs_templ(i,1));
    end generate obj_templ2_l_l;

    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, muon1_obj_vs_templ, muon2_obj_vs_templ)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
            muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, charge_comp_double_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_inv_comp_pipe, mass_inv_upt_comp_pipe, mass_trv_comp_pipe, mass_div_dr_comp_pipe, tbpt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((muon1_object_high-muon1_object_low+1)*(muon2_object_high-muon2_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in muon1_object_low to muon1_object_high loop 
            for j in muon2_object_low to muon2_object_high loop
                if same_bx = true then
                    if j/=i then
                        index := index + 1;
                        obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_inv_upt_comp_pipe(i,j) and mass_trv_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and tbpt_comp_pipe(i,j);
                    end if;
                else
                    index := index + 1;
                    obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_inv_upt_comp_pipe(i,j) and mass_trv_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and tbpt_comp_pipe(i,j);
                end if;
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
