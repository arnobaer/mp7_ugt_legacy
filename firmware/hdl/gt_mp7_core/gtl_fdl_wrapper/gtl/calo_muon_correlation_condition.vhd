
-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and muon.

-- Version history:
-- HB 2020-07-02: changed for new cuts structure (calculation outside of conditions).
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" and "impact parameter".
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from calo_muon_correlation_condition_v3 to calo_muon_correlation_condition.
-- HB 2017-10-02: based on calo_muon_correlation_condition_v2 - used limit vectors for correlation cuts.
-- HB 2017-04-25: "twobody_pt" detached from "mass fixation". Used "mass_calculator.vhd" and "twobody_pt_calculator.vhd" in "cuts_instances" module.
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DR). Using integer for cos and sin phi inputs.
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-01: used "xxx_object_low" and "xxx_object_high" for object ranges.
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2017-01-18: first design of version 2 - replaced "invariant_mass" with "mass_cuts".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_muon_correlation_condition is
    generic(

        deta_cut: boolean;
        dphi_cut: boolean;
        dr_cut: boolean;
        mass_cut: boolean;
        mass_type : natural;
        twobody_pt_cut: boolean;

        nr_obj_calo1 : natural;
        calo1_object_low: natural;
        calo1_object_high: natural;
        et_ge_mode_calo1: boolean;
        obj_type_calo1: natural := EG_TYPE;
        et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo1 : natural;
        eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo1: boolean;
        phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo1: boolean;
        phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        muon2_object_low: natural;
        muon2_object_high: natural;
        pt_ge_mode_muon2: boolean;
        pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_muon2 : natural;
        eta_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon2: boolean;
        phi_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon2: boolean;
        phi_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon2: string(1 to 3);
        qual_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);
        upt_cut_muon2 : boolean;
        upt_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        upt_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        ip_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.ip_high-D_S_I_MUON_V2.ip_low+1)-1 downto 0);

        deta_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        deta_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dphi_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        dphi_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dr_upper_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);
        dr_lower_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);

        mass_upper_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        mass_lower_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);

        mass_div_dr_upper_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0);
        mass_div_dr_lower_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0);

        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0);
        
        mass_width: positive := 56;
        mass_div_dr_width: positive := 83;
        tbpt_width: positive := 50

   );
    port(
        lhc_clk: in std_logic;
        calo1_data_i: in calo_objects_array;
        muon2_data_i: in muon_objects_array;
        deta : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        dphi : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        dr : in delta_r_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_inv : in mass_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_trv : in mass_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        mass_div_dr : in mass_div_dr_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        tbpt : in tbpt_vector_array(0 to nr_obj_calo1-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end calo_muon_correlation_condition; 

architecture rtl of calo_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
--     constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
-- obj_vs_templ_pipeline_stage not used, because of 1 bx pipeline of ROMs (for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd)

    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, 1 to 1);
    signal muon2_obj_vs_templ, muon2_obj_vs_templ_pipe : std_logic_2dim_array(muon2_object_low to muon2_object_high, 1 to 1);

    signal deta_comp_t, deta_comp, deta_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal dphi_comp_t, dphi_comp, dphi_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal dr_comp_t, dr_comp, dr_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_inv_comp_t, mass_inv_comp, mass_inv_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_trv_comp_t, mass_trv_comp, mass_trv_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal tbpt_comp_t, tbpt_comp, tbpt_comp_pipe : std_logic_2dim_array(0 to nr_obj_calo1-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));

    signal condition_and_or : std_logic;
    
begin

    -- Comparison with limits.
    cuts_l_1: for i in 0 to nr_obj_calo1-1 generate 
        cuts_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_cut, dphi_cut => dphi_cut, dr_cut => dr_cut, mass_cut => mass_cut, mass_type => mass_type, twobody_pt_cut => twobody_pt_cut,
                        deta_upper_limit => deta_upper_limit, deta_lower_limit => deta_lower_limit, dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                        dr_upper_limit => dr_upper_limit, dr_lower_limit => dr_lower_limit, mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                        mass_div_dr_upper_limit => mass_div_dr_upper_limit, mass_div_dr_lower_limit => mass_div_dr_lower_limit, tbpt_threshold => tbpt_threshold,
                        mass_width => MU_MU_MASS_VECTOR_WIDTH, mass_div_dr_width => MU_MU_MASS_DIV_DR_VECTOR_WIDTH, tbpt_width => MU_MU_TBPT_VECTOR_WIDTH
                    )
                    port map(
                        deta => deta(i,j), dphi => dphi(i,j), dr => dr(i,j), mass_inv => mass_inv(i,j), mass_trv => mass_trv(i,j), tbpt => tbpt(i,j),
                        deta_comp => deta_comp(i,j), dphi_comp => dphi_comp(i,j), dr_comp => dr_comp(i,j), mass_inv_comp => mass_inv_comp(i,j),
                        mass_div_dr_comp => mass_div_dr_comp_pipe(i,j), mass_trv_comp => mass_trv_comp(i,j), tbpt_comp => tbpt_comp(i,j)
                    );
        end generate cuts_l_2;
    end generate cuts_l_1;
    
-- Pipeline stage for charge correlation comparison
    cuts_pipeline_p: process(lhc_clk, deta_comp, dphi_comp, dr_comp, mass_inv_comp, mass_trv_comp, tbpt_comp)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_inv_comp_pipe <= mass_inv_comp;
            mass_trv_comp_pipe <= mass_trv_comp;
-- mass_div_dr_comp_pipe: 1 bx pipeline done with ROMs for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd
            tbpt_comp_pipe <= tbpt_comp;
        end if;
    end process;
    
--  ***************************************************************************************

    -- Instance of comparators for calorimeter objects.
    calo1_obj_l: for i in calo1_object_low to calo1_object_high generate
        calo1_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo1, obj_type_calo1,
                et_threshold_calo1,
                nr_eta_windows_calo1,
                eta_w1_upper_limit_calo1,
                eta_w1_lower_limit_calo1,
                eta_w2_upper_limit_calo1,
                eta_w2_lower_limit_calo1,
                eta_w3_upper_limit_calo1,
                eta_w3_lower_limit_calo1,
                eta_w4_upper_limit_calo1,
                eta_w4_lower_limit_calo1,
                eta_w5_upper_limit_calo1,
                eta_w5_lower_limit_calo1,
                phi_full_range_calo1,
                phi_w1_upper_limit_calo1,
                phi_w1_lower_limit_calo1,
                phi_w2_ignore_calo1,
                phi_w2_upper_limit_calo1,
                phi_w2_lower_limit_calo1,
                iso_lut_calo1
            )
            port map(calo1_data_i(i), calo1_obj_vs_templ(i,1));
    end generate calo1_obj_l;

    muon2_obj_l: for i in muon2_object_low to muon2_object_high generate
        muon2_comp_i: entity work.muon_comparators
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
    end generate muon2_obj_l;

    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, muon2_obj_vs_templ)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
            muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_p: process(calo1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_inv_comp_pipe, mass_trv_comp_pipe, mass_div_dr_comp_pipe, tbpt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((calo1_object_high-calo1_object_low+1)*(muon2_object_high-muon2_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo1_object_low to calo1_object_high loop 
            for j in muon2_object_low to muon2_object_high loop
                    index := index + 1;
                    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_trv_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and tbpt_comp_pipe(i,j);
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
