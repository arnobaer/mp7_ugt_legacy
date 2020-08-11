
-- Desription:
-- Condition module for muon objects.
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.
-- Charge correlation selection implemented with "LS" and "OS" (charge correlation calculated in muon_charge_correlations.vhd)

-- Version history:
-- HB 2020-08-11: inserted "twobody unconstraint pt".
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" [upt] and "impact parameter" [ip].
-- HB 2019-06-14: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from muon_conditions_v7 to muon_conditions.
-- HB 2017-10-04: based on muon_conditions_v6 - used limit vector for pt_sq_threshold.
-- HB 2017-09-05: based on muon_conditions_v5, but inserted slice ranges in generic for correct use of object slices.
-- HB 2017-06-20: changed order in port for charge correlation signals.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-25: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "muon_object_low" and "muon_object_high" in generic (and replaced NR_MUON_OBJECTS by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_conditions is
    generic (
        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        pt_ge_mode : boolean;
        pt_thresholds: muon_templates_array;
        nr_eta_windows : muon_templates_natural_array;
        eta_w1_upper_limits: muon_templates_array;
        eta_w1_lower_limits: muon_templates_array;
        eta_w2_upper_limits: muon_templates_array;
        eta_w2_lower_limits: muon_templates_array;
        eta_w3_upper_limits: muon_templates_array;
        eta_w3_lower_limits: muon_templates_array;
        eta_w4_upper_limits: muon_templates_array;
        eta_w4_lower_limits: muon_templates_array;
        eta_w5_upper_limits: muon_templates_array;
        eta_w5_lower_limits: muon_templates_array;
        phi_full_range : muon_templates_boolean_array;
        phi_w1_upper_limits: muon_templates_array;
        phi_w1_lower_limits: muon_templates_array;
        phi_w2_ignore : muon_templates_boolean_array;
        phi_w2_upper_limits: muon_templates_array;
        phi_w2_lower_limits: muon_templates_array;
        requested_charges: muon_templates_string_array;
        qual_luts: muon_templates_quality_array;
        iso_luts: muon_templates_iso_array;
        upt_cuts: muon_templates_boolean_array;
        upt_upper_limits: muon_templates_array;
        upt_lower_limits: muon_templates_array;
        ip_luts: muon_templates_ip_array;
        requested_charge_correlation: string(1 to 2);
        
        twobody_pt_cut: boolean := false;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        tbupt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
        
    );
    port(
        lhc_clk : in std_logic;
        data_i : in muon_objects_array;
        condition_o : out std_logic;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        tbpt : in tbpt_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        tbupt : in tbpt_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')))
    );
end muon_conditions;

architecture rtl of muon_conditions is

    constant nr_objects_slice_1_int: natural := muon_object_slice_1_high-muon_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := muon_object_slice_2_high-muon_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := muon_object_slice_3_high-muon_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := muon_object_slice_4_high-muon_object_slice_4_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(muon_object_slice_1_low to muon_object_slice_1_high, 1 to 1);
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(muon_object_slice_2_low to muon_object_slice_2_high, 1 to 1);
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(muon_object_slice_3_low to muon_object_slice_3_high, 1 to 1);
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(muon_object_slice_4_low to muon_object_slice_4_high, 1 to 1);
    
--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
    signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
    signal charge_comp_quad : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

    signal condition_and_or : std_logic;

    signal twobody_pt_comp, twobody_pt_comp_t, twobody_pt_comp_pipe : 
        std_logic_2dim_array(0 to NR_MUON_OBJECTS, 0 to NR_MUON_OBJECTS) := (others => (others => '1'));

--     signal twobody_upt_comp, twobody_upt_comp_t, twobody_upt_comp_pipe : 
--         std_logic_2dim_array(0 to NR_MUON_OBJECTS, 0 to NR_MUON_OBJECTS) := (others => (others => '1'));

begin

-- HB 2017-05-16: TBPT only for Double condition
    check_tbpt_i: if twobody_pt_cut generate
        assert (nr_templates = 2) report 
            "two-body pt cut only for Double condition - nr_templates = " & integer'image(nr_templates) 
        severity failure;        
    end generate check_tbpt_i;
    
--     check_tbupt_i: if twobody_upt_cut generate
--         assert (nr_templates = 2) report 
--             "two-body unconstraint pt cut only for Double condition - nr_templates = " & integer'image(nr_templates) 
--         severity failure;        
--     end generate check_tbupt_i;
    
    -- Comparison with limits for twobody pt and twobody unconstraint pt.
    twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
        cuts_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
            cuts_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
                cuts_comp_i: if j>i generate
                    comp_i: entity work.cuts_comp
                        generic map(
                            twobody_pt_cut => twobody_pt_cut, 
--                             twobody_upt_cut => twobody_upt_cut,
                            tbpt_width => MU_MU_TBPT_VECTOR_WIDTH 
--                             tbupt_width => MU_MU_TBUPT_VECTOR_WIDTH
                        )
                        port map(
                            tbpt => tbpt(i,j), 
--                             tbupt => tbupt(i,j),
                            twobody_pt_comp_t(i,j)
--                             tbupt_comp_t(i,j)
                        );
                    twobody_pt_comp(i,j) <= twobody_pt_comp_t(i,j);
                    twobody_pt_comp(j,i) <= twobody_pt_comp_t(i,j);                
--                     tbupt_comp(i,j) <= tbupt_comp_t(i,j);
--                     tbupt_comp(j,i) <= tbupt_comp_t(i,j);                
                end generate cuts_comp_i;
            end generate cuts_l_2;
        end generate cuts_l_1;
    end generate twobody_pt_cut_i;

-- Instantiation of object cuts.
    obj_cuts_i: entity work.muon_obj_cuts
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates, pt_ge_mode,
            pt_thresholds,
            nr_eta_windows,
            eta_w1_upper_limits, eta_w1_lower_limits,
            eta_w2_upper_limits, eta_w2_lower_limits,
            eta_w3_upper_limits, eta_w3_lower_limits,
            eta_w4_upper_limits, eta_w4_lower_limits,
            eta_w5_upper_limits, eta_w5_lower_limits,
            phi_full_range, phi_w1_upper_limits, phi_w1_lower_limits,
            phi_w2_ignore, phi_w2_upper_limits, phi_w2_lower_limits,
            requested_charges, qual_luts, iso_luts,
            upt_cuts, upt_upper_limits, upt_lower_limits,
            ip_luts            
        )
        port map(
            data_i, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ
        );

-- Pipeline stage for obj_vs_templ and twobody_pt_comp
    obj_vs_templ_pipeline_p: process(lhc_clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ, twobody_pt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                    obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                    obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                    obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                    twobody_pt_comp_pipe <= twobody_pt_comp;
                end if;
            end if;
    end process;

-- Instantiation of charge correlation matrix.
    charge_corr_matrix_i: entity work.muon_charge_corr_matrix
        generic map(
            obj_vs_templ_pipeline_stage,
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates,
            requested_charge_correlation
        )
        port map(lhc_clk,
            ls_charcorr_double, os_charcorr_double,
            ls_charcorr_triple, os_charcorr_triple,
            ls_charcorr_quad, os_charcorr_quad,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe
        );

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.muon_cond_matrix
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates
        )
        port map(lhc_clk,
            obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe, twobody_pt_comp_pipe,
            condition_o
        );

end architecture rtl;
