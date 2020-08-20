
-- Description:
-- Condition module for muon objects conditions with "overlap removal (orm)".

-- Version history:
-- HB 2020-08-20: inserted new comparator for overlap removal and twobody pt cuts.
-- HB 2019-10-16: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_conditions_orm is
     generic(
        deta_orm_cut: boolean := false;
        dphi_orm_cut: boolean := false;
        dr_orm_cut: boolean := true;

        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        et_ge_mode_muon: boolean;
        et_thresholds_muon: muon_templates_array;
        nr_eta_windows_muon : muon_templates_natural_array;
        eta_w1_upper_limits_muon: muon_templates_array;
        eta_w1_lower_limits_muon: muon_templates_array;
        eta_w2_upper_limits_muon: muon_templates_array;
        eta_w2_lower_limits_muon: muon_templates_array;
        eta_w3_upper_limits_muon: muon_templates_array;
        eta_w3_lower_limits_muon: muon_templates_array;
        eta_w4_upper_limits_muon: muon_templates_array;
        eta_w4_lower_limits_muon: muon_templates_array;
        eta_w5_upper_limits_muon: muon_templates_array;
        eta_w5_lower_limits_muon: muon_templates_array;
        phi_full_range_muon : muon_templates_boolean_array;
        phi_w1_upper_limits_muon: muon_templates_array;
        phi_w1_lower_limits_muon: muon_templates_array;
        phi_w2_ignore_muon : muon_templates_boolean_array;
        phi_w2_upper_limits_muon: muon_templates_array;
        phi_w2_lower_limits_muon: muon_templates_array;
        requested_charges_muon: muon_templates_string_array;
        qual_luts_muon: muon_templates_quality_array;
        iso_luts_muon: muon_templates_iso_array;
        ptu_cuts_muon: muon_templates_boolean_array;
        ptu_upper_limits_muon: muon_templates_array;
        ptu_lower_limits_muon: muon_templates_array;
        ip_luts_muon: muon_templates_ip_array;
        requested_charge_correlation: string(1 to 2);

        nr_obj_calo: natural := NR_EG_OBJECTS;        
        calo_object_low: natural;
        calo_object_high: natural;
        et_ge_mode_calo: boolean;
        obj_type_calo: natural := TAU_TYPE;
        et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo : natural;
        eta_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo: boolean;
        phi_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo: boolean;
        phi_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        deta_orm_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        deta_orm_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dphi_orm_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        dphi_orm_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dr_orm_upper_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);
        dr_orm_lower_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);

        twobody_pt_cut: boolean := false;
        tbpt_width: positive := MAX_WIDTH_TBPT_LIMIT_VECTOR;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
    );
    port(
        clk: in std_logic;
        muon: in muon_objects_array;
        calo: in calo_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        deta_orm : in deta_dphi_vector_array(0 to NR_MUON_OBJECTS-1, 0 to nr_obj_calo-1) := (others => (others => (others => '0')));
        dphi_orm : in deta_dphi_vector_array(0 to NR_MUON_OBJECTS-1, 0 to nr_obj_calo-1) := (others => (others => (others => '0')));
        dr_orm: in delta_r_vector_array(0 to NR_MUON_OBJECTS-1, 0 to nr_obj_calo-1) := (others => (others => (others => '0')));
        tbpt : in tbpt_vector_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end muon_conditions_orm;

architecture rtl of muon_conditions_orm is

    constant nr_objects_slice_1_int: natural := muon_object_slice_1_high-muon_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := muon_object_slice_2_high-muon_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := muon_object_slice_3_high-muon_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := muon_object_slice_4_high-muon_object_slice_4_low+1;

    constant nr_calo_objects_int: natural := calo_object_high-calo_object_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal muon_obj_slice_1_vs_templ, muon_obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(muon_object_slice_1_low to muon_object_slice_1_high, 1 to 1);
    signal muon_obj_slice_2_vs_templ, muon_obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(muon_object_slice_2_low to muon_object_slice_2_high, 1 to 1);
    signal muon_obj_slice_3_vs_templ, muon_obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(muon_object_slice_3_low to muon_object_slice_3_high, 1 to 1);
    signal muon_obj_slice_4_vs_templ, muon_obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(muon_object_slice_4_low to muon_object_slice_4_high, 1 to 1);
    
    signal deta_orm_comp, deta_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo_object_low to calo_object_high) := (others => (others => '0'));
    signal dphi_orm_comp, dphi_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo_object_low to calo_object_high) := (others => (others => '0'));
    signal dr_orm_comp, dr_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo_object_low to calo_object_high) := (others => (others => '0'));
    signal calo_obj_vs_templ, calo_obj_vs_templ_pipe : std_logic_2dim_array(calo_object_low to calo_object_high, 1 to 1) := (others => (others => '0'));

--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
--     signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--     signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
--     signal charge_comp_quad : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

    signal condition_and_or : std_logic;
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;

    signal twobody_pt_comp, twobody_pt_comp_pipe : 
    std_logic_2dim_array(muon_object_slice_1_low to muon_object_slice_1_low, muon_object_slice_2_low to muon_object_slice_2_high) := (others => (others => '1'));

begin

-- Comparison with limits.
    orm_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        orm_l_2: for j in 0 to nr_obj_calo-1 generate
            comp_if: if j>i generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_orm_cut, dphi_cut => dphi_orm_cut, dr_cut => dr_orm_cut,
                        deta_upper_limit => deta_orm_upper_limit, deta_lower_limit => deta_orm_lower_limit, 
                        dphi_upper_limit => dphi_orm_upper_limit, dphi_lower_limit => dphi_orm_lower_limit,
                        dr_upper_limit => dr_orm_upper_limit, dr_lower_limit => dr_orm_lower_limit
                    )
                    port map(
                        deta => deta_orm(i,j), dphi => dphi_orm(i,j), dr => dr_orm(i,j),
                        deta_comp => deta_orm_comp(i,j), dphi_comp => dphi_orm_comp(i,j), dr_comp => dr_orm_comp(i,j)
                    );
            end generate comp_if;
        end generate orm_l_2;
    end generate orm_l_1;
    
    tbpt_sel: if twobody_pt_cut generate
        tbpt_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
            tbpt_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
                comp_if: if j>i generate
                    comp_i: entity work.cuts_comp
                        generic map(
                            twobody_pt_cut => twobody_pt_cut,
                            tbpt_width => tbpt_width
                        )
                        port map(
                            tbpt => tbpt(i,j),
                            twobody_pt_comp => twobody_pt_comp(i,j)
                        );
                end generate comp_if;
            end generate tbpt_l_2;
        end generate tbpt_l_1;
    end generate tbpt_sel;
        
-- Instantiation of object cuts for muon.
    muon_obj_cuts_i: entity work.muon_obj_cuts
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates, et_ge_mode_muon,
            et_thresholds_muon,
            nr_eta_windows_muon, 
            eta_w1_upper_limits_muon, eta_w1_lower_limits_muon,
            eta_w2_upper_limits_muon, eta_w2_lower_limits_muon,
            eta_w3_upper_limits_muon, eta_w3_lower_limits_muon,
            eta_w4_upper_limits_muon, eta_w4_lower_limits_muon,
            eta_w5_upper_limits_muon, eta_w5_lower_limits_muon,
            phi_full_range_muon, phi_w1_upper_limits_muon, phi_w1_lower_limits_muon,
            phi_w2_ignore_muon, phi_w2_upper_limits_muon, phi_w2_lower_limits_muon,
            requested_charges_muon, qual_luts_muon, iso_luts_muon,
            ptu_cuts_muon, ptu_upper_limits_muon, ptu_lower_limits_muon,
            ip_luts_muon            
        )
        port map(
            muon, muon_obj_slice_1_vs_templ, muon_obj_slice_2_vs_templ, muon_obj_slice_3_vs_templ, muon_obj_slice_4_vs_templ
        );

-- Instantiation of object cuts for calo.
    calo_obj_l: for i in calo_object_low to calo_object_high generate
        calo_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo, obj_type_calo,
                et_threshold_calo,
                nr_eta_windows_calo,
                eta_w1_upper_limit_calo, eta_w1_lower_limit_calo,
                eta_w2_upper_limit_calo, eta_w2_lower_limit_calo,
                eta_w3_upper_limit_calo, eta_w3_lower_limit_calo,
                eta_w4_upper_limit_calo, eta_w4_lower_limit_calo,
                eta_w5_upper_limit_calo, eta_w5_lower_limit_calo,
                phi_full_range_calo,
                phi_w1_upper_limit_calo,
                phi_w1_lower_limit_calo,
                phi_w2_ignore_calo,
                phi_w2_upper_limit_calo,
                phi_w2_lower_limit_calo,
                iso_lut_calo
            )
            port map(
                calo(i), calo_obj_vs_templ(i,1)
            );
    end generate calo_obj_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(clk, muon_obj_slice_1_vs_templ, muon_obj_slice_2_vs_templ, muon_obj_slice_3_vs_templ, muon_obj_slice_4_vs_templ, calo_obj_vs_templ,           deta_orm_comp, dphi_orm_comp, dr_orm_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then
            muon_obj_slice_1_vs_templ_pipe <= muon_obj_slice_1_vs_templ;
            muon_obj_slice_2_vs_templ_pipe <= muon_obj_slice_2_vs_templ;
            muon_obj_slice_3_vs_templ_pipe <= muon_obj_slice_3_vs_templ;
            muon_obj_slice_4_vs_templ_pipe <= muon_obj_slice_4_vs_templ;
            calo_obj_vs_templ_pipe <= calo_obj_vs_templ;
            deta_orm_comp_pipe <= deta_orm_comp;
            dphi_orm_comp_pipe <= dphi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        elsif (clk'event and clk = '1') then
            muon_obj_slice_1_vs_templ_pipe <= muon_obj_slice_1_vs_templ;
            muon_obj_slice_2_vs_templ_pipe <= muon_obj_slice_2_vs_templ;
            muon_obj_slice_3_vs_templ_pipe <= muon_obj_slice_3_vs_templ;
            muon_obj_slice_4_vs_templ_pipe <= muon_obj_slice_4_vs_templ;
            calo_obj_vs_templ_pipe <= calo_obj_vs_templ;
            deta_orm_comp_pipe <= deta_orm_comp;
            dphi_orm_comp_pipe <= dphi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
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
        port map(clk,
            ls_charcorr_double, os_charcorr_double,
            ls_charcorr_triple, os_charcorr_triple,
            ls_charcorr_quad, os_charcorr_quad,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe
        );

-- "Matrix" of permutations in an and-or-structure.
-- Selection of muon condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.muon_cond_matrix_orm
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates,
            calo_object_low, calo_object_high
        )
        port map(clk,
            muon_obj_slice_1_vs_templ_pipe, muon_obj_slice_2_vs_templ_pipe, muon_obj_slice_3_vs_templ_pipe, muon_obj_slice_4_vs_templ_pipe, 
            calo_obj_vs_templ_pipe,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe, twobody_pt_comp_pipe, 
            deta_orm_comp_pipe, dphi_orm_comp_pipe, dr_orm_comp_pipe,
            condition_o
        );

end architecture rtl;
