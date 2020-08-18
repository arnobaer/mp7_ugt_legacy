
-- Description:
-- Condition module for calorimeter object types (eg, jet and tau) conditions with "overlap removal (orm)".

-- Version history:
-- HB 2020-08-14: reordered generic, added default values.
-- HB 2019-10-17: cleaned up.
-- HB 2019-10-16: bug fix in cond_matrix_i (calo2_obj_vs_templ_pipe).
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-03: used instances "calo_cuts" and "calo_cond_matrix_orm" to reduce resources. Inserted instance for twobody_pt.
-- HB 2017-10-04: added limit vectors for correlation cuts.
-- HB 2017-09-07: splitted vector in "matrix_quad_p" 3x 4096.
-- HB 2017-09-06: based on calo_conditions_orm_v2, but only for quad condition.
-- HB 2017-09-05: based on calo_conditions_orm, but updated for correct use of object slices.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-10: improved orm-and-structure of "obj_vs_templ_vec".
-- HB 2017-05-10: inserted "twobody_pt" cut for double condition.
-- HB 2017-04-24: inserted "calo2_obj_vs_templ" in and-structure.
-- HB 2017-04-21: wrong typo fixed.
-- HB 2017-04-20: removed "orm mask" (roll back to version from 2017-04-05).
-- HB 2017-04-10: inserted "orm mask" for use in "and structure" of "obj_vs_templ_vec".
-- HB 2017-04-06: max. 6 objects for nr_templates = 3 and nr_templates = 4 are allowed, because of length of "obj_vs_templ_vec".
-- HB 2017-04-05: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_orm is
     generic(
        obj_type_calo1 : natural := EG_TYPE; -- eg=0, jet=1, tau=2
        nr_obj_calo1: natural := NR_EG_OBJECTS;        
        calo1_object_slice_1_low: natural := 0;
        calo1_object_slice_1_high: natural := 0;
        calo1_object_slice_2_low: natural := 0;
        calo1_object_slice_2_high: natural := 0;
        calo1_object_slice_3_low: natural := 0;
        calo1_object_slice_3_high: natural := 0;
        calo1_object_slice_4_low: natural := 0;
        calo1_object_slice_4_high: natural := 0;
        nr_templates: positive := 4;
        pt_ge_mode_calo1: boolean := true;
        pt_thresholds_calo1: calo_templates_array := (others => (others => '0'));
        nr_eta_windows_calo1 : calo_templates_natural_array := (others => 0);
        eta_w1_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w1_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w2_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w2_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w3_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w3_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w4_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w4_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w5_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        eta_w5_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        phi_full_range_calo1 : calo_templates_boolean_array := (others => true);
        phi_w1_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        phi_w1_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        phi_w2_ignore_calo1 : calo_templates_boolean_array := (others => true);
        phi_w2_upper_limits_calo1: calo_templates_array := (others => (others => '0'));
        phi_w2_lower_limits_calo1: calo_templates_array := (others => (others => '0'));
        iso_luts_calo1: calo_templates_iso_array := (others => X"F");

        obj_type_calo2: natural := TAU_TYPE;
        nr_obj_calo2: natural := NR_TAU_OBJECTS;        
        calo2_object_low: natural := 0;
        calo2_object_high: natural := 11;
        pt_ge_mode_calo2: boolean := true;
        pt_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_calo2 : natural := 0;
        eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_calo2: boolean := true;
        phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_calo2: boolean := true;
        phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        deta_orm_cut: boolean := false;
        deta_orm_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_orm_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_orm_cut: boolean := false;
        dphi_orm_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_orm_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_orm_cut: boolean := false;
        dr_orm_upper_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_orm_lower_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        twobody_pt_cut: boolean := false;
        tbpt_width: positive := 50;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
    );
    port(
        clk: in std_logic;
        calo1: in calo_objects_array;
        calo2: in calo_objects_array;
        deta_orm : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        dphi_orm : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        dr_orm: in delta_r_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        tbpt : in tbpt_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo1-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end calo_conditions_orm;

architecture rtl of calo_conditions_orm is

    constant nr_objects_slice_1_int: natural := calo1_object_slice_1_high-calo1_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo1_object_slice_2_high-calo1_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo1_object_slice_3_high-calo1_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := calo1_object_slice_4_high-calo1_object_slice_4_low+1;

    constant nr_calo2_objects_int: natural := calo2_object_high-calo2_object_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal calo1_obj_slice_1_vs_templ, calo1_obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(calo1_object_slice_1_low to calo1_object_slice_1_high, 1 to 1);
    signal calo1_obj_slice_2_vs_templ, calo1_obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(calo1_object_slice_2_low to calo1_object_slice_2_high, 1 to 1);
    signal calo1_obj_slice_3_vs_templ, calo1_obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(calo1_object_slice_3_low to calo1_object_slice_3_high, 1 to 1);
    signal calo1_obj_slice_4_vs_templ, calo1_obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(calo1_object_slice_4_low to calo1_object_slice_4_high, 1 to 1);
    
    signal deta_orm_comp, deta_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal dphi_orm_comp, dphi_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal dr_orm_comp, dr_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1) := (others => (others => '0'));

    signal condition_and_or : std_logic;
    
    signal twobody_pt_comp, twobody_pt_comp_pipe : 
    std_logic_2dim_array(calo1_object_slice_1_low to calo1_object_slice_1_high, calo1_object_slice_2_low to calo1_object_slice_2_high) := (others => (others => '1'));

begin

-- Comparison with limits.
    orm_l_1: for i in 0 to nr_obj_calo1-1 generate 
        orm_l_2: for j in 0 to nr_obj_calo2-1 generate
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
        tbpt_l_1: for i in 0 to nr_obj_calo1-1 generate 
            tbpt_l_2: for j in 0 to nr_obj_calo1-1 generate
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
        
-- Instantiation of object cuts for calo1.
    calo1_obj_cuts_i: entity work.calo_obj_cuts
        generic map(
            calo1_object_slice_1_low, calo1_object_slice_1_high,
            calo1_object_slice_2_low, calo1_object_slice_2_high,
            calo1_object_slice_3_low, calo1_object_slice_3_high,
            calo1_object_slice_4_low, calo1_object_slice_4_high,
            nr_templates, pt_ge_mode_calo1, obj_type_calo1,
            pt_thresholds_calo1,
            nr_eta_windows_calo1, 
            eta_w1_upper_limits_calo1, eta_w1_lower_limits_calo1,
            eta_w2_upper_limits_calo1, eta_w2_lower_limits_calo1,
            eta_w3_upper_limits_calo1, eta_w3_lower_limits_calo1,
            eta_w4_upper_limits_calo1, eta_w4_lower_limits_calo1,
            eta_w5_upper_limits_calo1, eta_w5_lower_limits_calo1,
            phi_full_range_calo1, phi_w1_upper_limits_calo1, phi_w1_lower_limits_calo1,
            phi_w2_ignore_calo1, phi_w2_upper_limits_calo1, phi_w2_lower_limits_calo1,
            iso_luts_calo1
        )
        port map(
            calo1, calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo1_obj_slice_3_vs_templ, calo1_obj_slice_4_vs_templ
        );

-- Instantiation of object cuts for calo2.
    calo2_obj_l: for i in calo2_object_low to calo2_object_high generate
        calo2_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_calo2, obj_type_calo2,
                pt_threshold_calo2,
                nr_eta_windows_calo2,
                eta_w1_upper_limit_calo2, eta_w1_lower_limit_calo2,
                eta_w2_upper_limit_calo2, eta_w2_lower_limit_calo2,
                eta_w3_upper_limit_calo2, eta_w3_lower_limit_calo2,
                eta_w4_upper_limit_calo2, eta_w4_lower_limit_calo2,
                eta_w5_upper_limit_calo2, eta_w5_lower_limit_calo2,
                phi_full_range_calo2,
                phi_w1_upper_limit_calo2,
                phi_w1_lower_limit_calo2,
                phi_w2_ignore_calo2,
                phi_w2_upper_limit_calo2,
                phi_w2_lower_limit_calo2,
                iso_lut_calo2
            )
            port map(
                calo2(i), calo2_obj_vs_templ(i,1)
            );
    end generate calo2_obj_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(clk, calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo1_obj_slice_3_vs_templ, calo1_obj_slice_4_vs_templ, calo2_obj_vs_templ, deta_orm_comp, dphi_orm_comp, dr_orm_comp, twobody_pt_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then
            calo1_obj_slice_1_vs_templ_pipe <= calo1_obj_slice_1_vs_templ;
            calo1_obj_slice_2_vs_templ_pipe <= calo1_obj_slice_2_vs_templ;
            calo1_obj_slice_3_vs_templ_pipe <= calo1_obj_slice_3_vs_templ;
            calo1_obj_slice_4_vs_templ_pipe <= calo1_obj_slice_4_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            deta_orm_comp_pipe <= deta_orm_comp;
            dphi_orm_comp_pipe <= dphi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        elsif (clk'event and clk = '1') then
            calo1_obj_slice_1_vs_templ_pipe <= calo1_obj_slice_1_vs_templ;
            calo1_obj_slice_2_vs_templ_pipe <= calo1_obj_slice_2_vs_templ;
            calo1_obj_slice_3_vs_templ_pipe <= calo1_obj_slice_3_vs_templ;
            calo1_obj_slice_4_vs_templ_pipe <= calo1_obj_slice_4_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            deta_orm_comp_pipe <= deta_orm_comp;
            dphi_orm_comp_pipe <= dphi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.calo_cond_matrix_orm
        generic map(
            calo1_object_slice_1_low, calo1_object_slice_1_high,
            calo1_object_slice_2_low, calo1_object_slice_2_high,
            calo1_object_slice_3_low, calo1_object_slice_3_high,
            calo1_object_slice_4_low, calo1_object_slice_4_high,
            nr_templates,
            calo2_object_low, calo2_object_high
        )
        port map(clk,
            calo1_obj_slice_1_vs_templ_pipe, calo1_obj_slice_2_vs_templ_pipe, calo1_obj_slice_3_vs_templ_pipe, calo1_obj_slice_4_vs_templ_pipe, 
            calo2_obj_vs_templ_pipe,
            twobody_pt_comp_pipe, 
            deta_orm_comp_pipe, dphi_orm_comp_pipe, dr_orm_comp_pipe,
            condition_o
        );

end architecture rtl;
