
-- Description:
-- Condition module for calorimeter object types (eg, jet and tau) conditions.

-- Version history:
-- HB 2020-08-14: reordered generic, added default values.
-- HB 2019-10-21: bug fix input ports.
-- HB 2019-06-14: updated for "five eta cuts".
-- HB 2019-05-03: used instances "calo_cuts" and "calo_cond_matrix" (proposal Dinyar/Hannes) to reduce resources. Inserted instance for twobody_pt.
-- HB 2017-09-05: inserted slice ranges in generic for correct use of object slices.
-- HB 2017-08-28: increased length of vector signals (to 4096).
-- HB 2017-06-13: module for quad condition only.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-20: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "calo_object_low" and "calo_object_high" in generic (and replaced "nr_objects" by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions is
     generic(
        obj_type : natural := EG_TYPE;
        nr_obj: natural := NR_EG_OBJECTS;
        calo_object_slice_1_low: natural := 0;
        calo_object_slice_1_high: natural := 0;
        calo_object_slice_2_low: natural := 0;
        calo_object_slice_2_high: natural := 0;
        calo_object_slice_3_low: natural := 0;
        calo_object_slice_3_high: natural := 0;
        calo_object_slice_4_low: natural := 0;
        calo_object_slice_4_high: natural := 0;
        nr_templates: positive := 4;
        pt_ge_mode: boolean := true;
        pt_thresholds: calo_templates_array := (others => (others => '0'));
        nr_eta_windows : calo_templates_natural_array := (others => 0);
        eta_w1_upper_limits: calo_templates_array := (others => (others => '0'));
        eta_w1_lower_limits: calo_templates_array := (others => (others => '0'));
        eta_w2_upper_limits: calo_templates_array := (others => (others => '0'));
        eta_w2_lower_limits: calo_templates_array := (others => (others => '0'));
        eta_w3_upper_limits: calo_templates_array := (others => (others => '0'));
        eta_w3_lower_limits: calo_templates_array := (others => (others => '0'));
        eta_w4_upper_limits: calo_templates_array := (others => (others => '0'));
        eta_w4_lower_limits: calo_templates_array := (others => (others => '0'));
        eta_w5_upper_limits: calo_templates_array := (others => (others => '0'));
        eta_w5_lower_limits: calo_templates_array := (others => (others => '0'));
        phi_full_range : calo_templates_boolean_array := (others => true);
        phi_w1_upper_limits: calo_templates_array := (others => (others => '0'));
        phi_w1_lower_limits: calo_templates_array := (others => (others => '0'));
        phi_w2_ignore : calo_templates_boolean_array := (others => true);
        phi_w2_upper_limits: calo_templates_array := (others => (others => '0'));
        phi_w2_lower_limits: calo_templates_array := (others => (others => '0'));
        iso_luts: calo_templates_iso_array := (others => X"F");
        
        twobody_pt_cut: boolean := false;
        tbpt_width: positive := MAX_WIDTH_TBPT_LIMIT_VECTOR;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        tbpt : in tbpt_vector_array(0 to nr_obj-1, 0 to nr_obj-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end calo_conditions;

architecture rtl of calo_conditions is

    constant nr_objects_slice_1_int: natural := calo_object_slice_1_high-calo_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo_object_slice_2_high-calo_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo_object_slice_3_high-calo_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := calo_object_slice_4_high-calo_object_slice_4_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(calo_object_slice_1_low to calo_object_slice_1_high, 1 to 1);
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(calo_object_slice_2_low to calo_object_slice_2_high, 1 to 1);
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(calo_object_slice_3_low to calo_object_slice_3_high, 1 to 1);
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(calo_object_slice_4_low to calo_object_slice_4_high, 1 to 1);
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    signal condition_and_or : std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;

    signal twobody_pt_comp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, calo_object_slice_2_low to calo_object_slice_2_high) := (others => (others => '1'));

begin

-- Comparison with limits.
    tbpt_sel: if twobody_pt_cut generate
        tbpt_l_1: for i in 0 to nr_obj-1 generate 
            tbpt_l_2: for j in 0 to nr_obj-1 generate
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

-- Instantiation of object cuts.
    obj_cuts_i: entity work.calo_obj_cuts
        generic map(
            calo_object_slice_1_low, calo_object_slice_1_high,
            calo_object_slice_2_low, calo_object_slice_2_high,
            calo_object_slice_3_low, calo_object_slice_3_high,
            calo_object_slice_4_low, calo_object_slice_4_high,
            nr_templates, pt_ge_mode, obj_type,
            pt_thresholds,
            nr_eta_windows,
            eta_w1_upper_limits, eta_w1_lower_limits,
            eta_w2_upper_limits, eta_w2_lower_limits,
            eta_w3_upper_limits, eta_w3_lower_limits,
            eta_w4_upper_limits, eta_w4_lower_limits,
            eta_w5_upper_limits, eta_w5_lower_limits,
            phi_full_range, phi_w1_upper_limits, phi_w1_lower_limits,
            phi_w2_ignore, phi_w2_upper_limits, phi_w2_lower_limits,
            iso_luts
        )
        port map(
            data_i, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ
        );

-- Pipeline stage for obj_vs_templ and twobody_pt_comp
    obj_vs_templ_pipeline_p: process(clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, twobody_pt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            elsif (clk'event and clk = '1') then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.calo_cond_matrix
        generic map(
            calo_object_slice_1_low, calo_object_slice_1_high,
            calo_object_slice_2_low, calo_object_slice_2_high,
            calo_object_slice_3_low, calo_object_slice_3_high,
            calo_object_slice_4_low, calo_object_slice_4_high,
            nr_templates
        )
        port map(clk,
            obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe,
            twobody_pt_comp_pipe,
            condition_o
        );

end architecture rtl;
