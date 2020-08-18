
-- Description:
-- Correlation Condition module with overlap removal for calorimeter object types (eg, jet and tau). Calo object 3 is used for overlap removal.

-- Version history:
-- HB 2020-08-14: reordered generic, added default values.
-- HB 2020-07-02: changed for new cuts structure (calculation outside of conditions).
-- HB 2020-01-21: inserted port calo2 (bug fix).
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from calo_calo_calo_correlation_orm_condition_v3 to calo_calo_calo_correlation_orm_condition.
-- HB 2017-07-04: changed from calo_calo_calo_correlation_orm_condition to calo_calo_calo_correlation_orm_condition_v2 for correct use of different object slices. Object types and bx of calo1 and calo2 are the same. Only one collection of input data (port "calo1") for calo1 and calo2.
-- HB 2017-05-18: updated and-structure for correct use with orm.
-- HB 2017-05-03: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_calo_calo_correlation_orm_condition is
     generic(

        obj_2plus1: boolean;

        nr_obj_calo1 : natural := 12;
        calo1_object_low: natural := 0;
        calo1_object_high: natural := 11;
        et_ge_mode_calo1: boolean := true;
        obj_type_calo1: natural := EG_TYPE;
        et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_calo1 : natural := 0;
        eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_calo1: boolean := true;
        phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_calo1: boolean := true;
        phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '0');

        nr_obj_calo2 : natural := 11;        
        calo2_object_low: natural := 0;
        calo2_object_high: natural := 11;
        et_ge_mode_calo2: boolean := true;
        obj_type_calo2: natural := EG_TYPE;
        et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
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
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '0');

        nr_obj_calo3 : natural := 12;
        calo3_object_low: natural := 0;
        calo3_object_high: natural := 11;
        et_ge_mode_calo3: boolean := true;
        obj_type_calo3: natural := JET_TYPE;
        et_threshold_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_calo3 : natural := 0;
        eta_w1_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_calo3: boolean := true;
        phi_w1_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_calo3: boolean := true;
        phi_w2_upper_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_calo3: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '0');

        deta_orm_cut: boolean := false;
        deta_orm_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_orm_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_orm_cut: boolean := false;
        dphi_orm_upper_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_orm_lower_limit: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_orm_cut: boolean := false;
        dr_orm_upper_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_orm_lower_limit: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

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
        mass_type : natural;
        mass_width: positive := 56;
        mass_upper_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        twobody_pt_cut: boolean := false;
        tbpt_width: positive := 50;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')

    );
    port(
        lhc_clk: in std_logic;
        calo1: in calo_objects_array;
        calo2: in calo_objects_array(0 to nr_obj_calo2-1) := (others => (others => '0'));
        calo3: in calo_objects_array;
        deta_orm : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        dphi_orm : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        dr_orm: in delta_r_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        deta_12 : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        dphi_12 : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        dr_12 : in delta_r_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        mass_inv_12 : in mass_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        tbpt_12 : in tbpt_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo2-1) := (others => (others => (others => '0')));
        deta_13 : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        dphi_13 : in deta_dphi_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        dr_13 : in delta_r_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        mass_inv_13 : in mass_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        tbpt_13 : in tbpt_vector_array(0 to nr_obj_calo1-1, 0 to nr_obj_calo3-1) := (others => (others => (others => '0')));
        condition_o: out std_logic;
        sim_orm_vec: out std_logic_3dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high, calo3_object_low to calo3_object_high) := (others => (others => (others => '0')));
        sim_orm_vec_or_tmp: out std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'));
        sim_obj_vs_templ_vec: out std_logic_3dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high, calo3_object_low to calo3_object_high) := (others => (others => (others => '0')));
        sim_obj_vs_templ_or_tmp: out std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'));
        sim_obj_vs_templ_orm_vec: out std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'))
    );
end calo_calo_calo_correlation_orm_condition; 

architecture rtl of calo_calo_calo_correlation_orm_condition is

-- fixed pipeline structure
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal deta_orm_comp_13, deta_orm_comp_13_pipe, deta_orm_comp_13_t : std_logic_2dim_array(calo1_object_low to calo1_object_high, calo3_object_low to calo3_object_high) := (others => (others => '0'));
    signal deta_orm_comp_23, deta_orm_comp_23_pipe, deta_orm_comp_23_t : std_logic_2dim_array(calo2_object_low to calo2_object_high, calo3_object_low to calo3_object_high) := (others => (others => '0'));
    signal dphi_orm_comp_13, dphi_orm_comp_13_pipe, dphi_orm_comp_13_t : std_logic_2dim_array(calo1_object_low to calo1_object_high, calo3_object_low to calo3_object_high) := (others => (others => '0'));
    signal dphi_orm_comp_23, dphi_orm_comp_23_pipe, dphi_orm_comp_23_t : std_logic_2dim_array(calo2_object_low to calo2_object_high, calo3_object_low to calo3_object_high) := (others => (others => '0'));
    signal dr_orm_comp_13, dr_orm_comp_13_pipe, dr_orm_comp_13_t : std_logic_2dim_array(calo1_object_low to calo1_object_high, calo3_object_low to calo3_object_high) := (others => (others => '0'));
    signal dr_orm_comp_23, dr_orm_comp_23_pipe, dr_orm_comp_23_t : std_logic_2dim_array(calo2_object_low to calo2_object_high, calo3_object_low to calo3_object_high) := (others => (others => '0'));
    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, 1 to 1) := (others => (others => '0'));
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1) := (others => (others => '0'));
    signal calo3_obj_vs_templ, calo3_obj_vs_templ_pipe : std_logic_2dim_array(calo3_object_low to calo3_object_high, 1 to 1) := (others => (others => '0'));
-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of obj_vs_templ_vec
    signal deta_comp_12, deta_comp_12_temp, deta_comp_12_pipe, dphi_comp_12, dphi_comp_12_temp, dphi_comp_12_pipe, dr_comp_12, dr_comp_12_temp, dr_comp_12_pipe, mass_comp_12, mass_comp_12_temp, mass_comp_12_pipe, tbpt_comp_12, tbpt_comp_12_temp, tbpt_comp_12_pipe : 
        std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '1'));
    signal deta_comp_13, deta_comp_13_temp, deta_comp_13_pipe, dphi_comp_13, dphi_comp_13_temp, dphi_comp_13_pipe, dr_comp_13, dr_comp_13_temp, dr_comp_13_pipe, mass_comp_13, mass_comp_13_temp, mass_comp_13_pipe, tbpt_comp_13, tbpt_comp_13_temp, tbpt_comp_13_pipe : 
        std_logic_2dim_array(calo1_object_low to calo1_object_high, calo3_object_low to calo3_object_high) := (others => (others => '1'));
    signal condition_and_or : std_logic;
    
begin

    cuts_orm_13_l_1: for i in calo1_object_low to calo1_object_high generate 
        cuts_orm_13_l_2: for k in calo3_object_low to calo3_object_high generate
            comp_i: entity work.cuts_comp
                generic map(
                    deta_cut => deta_orm_cut, dphi_cut => dphi_orm_cut, dr_cut => dr_orm_cut,
                    deta_upper_limit => deta_orm_upper_limit, deta_lower_limit => deta_orm_lower_limit, 
                    dphi_upper_limit => dphi_orm_upper_limit, dphi_lower_limit => dphi_orm_lower_limit,
                    dr_upper_limit => dr_orm_upper_limit, dr_lower_limit => dr_orm_lower_limit
                )
                port map(
                    deta => deta_orm(i,k), dphi => dphi_orm(i,k), dr => dr_orm(i,k), 
                    deta_comp => deta_orm_comp_13_t(i,k), dphi_comp => dphi_orm_comp_13_t(i,k), dr_comp => dr_orm_comp_13_t(i,k)
                );
            orm_cuts_sel_p: process(deta_orm_comp_13_t, dphi_orm_comp_13_t, dr_orm_comp_13_t)
                begin
                if deta_orm_cut then 
                    deta_orm_comp_13(i,k) <= deta_orm_comp_13_t(i,k);
                else
                    deta_orm_comp_13(i,k) <= '0';
                end if;
                if dphi_orm_cut then 
                    dphi_orm_comp_13(i,k) <= dphi_orm_comp_13_t(i,k);
                else
                    dphi_orm_comp_13(i,k) <= '0';
                end if;
                if dr_orm_cut then 
                    dr_orm_comp_13(i,k) <= dr_orm_comp_13_t(i,k);
                else
                    dr_orm_comp_13(i,k) <= '0';
                end if;
            end process;
        end generate cuts_orm_13_l_2;
    end generate cuts_orm_13_l_1;

-- HB 2020-07-03: for different slices for object 2
    cuts_orm_2plus1_true_i: if obj_2plus1 = true generate
        cuts_orm_23_l_1: for i in calo2_object_low to calo2_object_high generate 
            cuts_orm_23_l_2: for k in calo3_object_low to calo3_object_high generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_orm_cut, dphi_cut => dphi_orm_cut, dr_cut => dr_orm_cut,
                        deta_upper_limit => deta_orm_upper_limit, deta_lower_limit => deta_orm_lower_limit, 
                        dphi_upper_limit => dphi_orm_upper_limit, dphi_lower_limit => dphi_orm_lower_limit,
                        dr_upper_limit => dr_orm_upper_limit, dr_lower_limit => dr_orm_lower_limit
                    )
                    port map(
                        deta => deta_orm(i,k), dphi => dphi_orm(i,k), dr => dr_orm(i,k), 
                        deta_comp => deta_orm_comp_23_t(i,k), dphi_comp => dphi_orm_comp_23_t(i,k), dr_comp => dr_orm_comp_23_t(i,k)
                    );
                orm_cuts_sel_p: process(deta_orm_comp_23_t, dphi_orm_comp_23_t, dr_orm_comp_23_t)
                    begin
                    if deta_orm_cut then 
                        deta_orm_comp_23(i,k) <= deta_orm_comp_23_t(i,k);
                    else
                        deta_orm_comp_23(i,k) <= '0';
                    end if;
                    if dphi_orm_cut then 
                        dphi_orm_comp_23(i,k) <= dphi_orm_comp_23_t(i,k);
                    else
                        dphi_orm_comp_23(i,k) <= '0';
                    end if;
                    if dr_orm_cut then 
                        dr_orm_comp_23(i,k) <= dr_orm_comp_23_t(i,k);
                    else
                        dr_orm_comp_23(i,k) <= '0';
                    end if;
                end process;
            end generate cuts_orm_23_l_2;
        end generate cuts_orm_23_l_1;
    end generate cuts_orm_2plus1_true_i;

    obj_2plus1_true_cuts_i: if obj_2plus1 = true generate
        cuts_l_1: for i in calo1_object_low to calo1_object_high generate 
            cuts_l_2: for j in calo2_object_low to calo2_object_high generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_cut, dphi_cut => dphi_cut, dr_cut => dr_cut, mass_cut => mass_cut, mass_type => mass_type, twobody_pt_cut => twobody_pt_cut,
                        deta_upper_limit => deta_upper_limit, deta_lower_limit => deta_lower_limit, dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                        dr_upper_limit => dr_upper_limit, dr_lower_limit => dr_lower_limit, mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                        tbpt_threshold => tbpt_threshold, tbpt_width => tbpt_width
                    )
                    port map(
                        deta => deta_12(i,j), dphi => dphi_12(i,j), dr => dr_12(i,j), mass_inv => mass_inv_12(i,j), tbpt => tbpt_12(i,j),
                        deta_comp => deta_comp_12(i,j), dphi_comp => dphi_comp_12(i,j), dr_comp => dr_comp_12(i,j), 
                        mass_inv_comp => mass_comp_12(i,j), twobody_pt_comp => tbpt_comp_12(i,j)
                    );
            end generate cuts_l_2;
        end generate cuts_l_1;
    end generate obj_2plus1_true_cuts_i;

    obj_2plus1_false_cuts_i: if obj_2plus1 = false generate
        cuts_l_1: for i in calo1_object_low to calo1_object_high generate 
            cuts_l_2: for j in calo3_object_low to calo3_object_high generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut => deta_cut, dphi_cut => dphi_cut, dr_cut => dr_cut, mass_cut => mass_cut, mass_type => mass_type, twobody_pt_cut => twobody_pt_cut,
                        deta_upper_limit => deta_upper_limit, deta_lower_limit => deta_lower_limit, dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                        dr_upper_limit => dr_upper_limit, dr_lower_limit => dr_lower_limit, mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                        tbpt_threshold => tbpt_threshold, tbpt_width => tbpt_width
                    )
                    port map(
                        deta => deta_13(i,j), dphi => dphi_13(i,j), dr => dr_13(i,j), mass_inv => mass_inv_13(i,j), tbpt => tbpt_13(i,j),
                        deta_comp => deta_comp_13(i,j), dphi_comp => dphi_comp_13(i,j), dr_comp => dr_comp_13(i,j), mass_inv_comp => mass_comp_13(i,j), twobody_pt_comp => tbpt_comp_13(i,j)
                    );
            end generate cuts_l_2;
        end generate cuts_l_1;
    end generate obj_2plus1_false_cuts_i;
    
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
            port map(calo1(i), calo1_obj_vs_templ(i,1));
    end generate calo1_obj_l;

    obj_2plus1_true_comb_i: if obj_2plus1 = true generate
        calo2_obj_l: for i in calo2_object_low to calo2_object_high generate
            calo2_comp_i: entity work.calo_comparators
                generic map(et_ge_mode_calo2, obj_type_calo2,
                    et_threshold_calo2,
                    nr_eta_windows_calo2,
                    eta_w1_upper_limit_calo2,
                    eta_w1_lower_limit_calo2,
                    eta_w2_upper_limit_calo2,
                    eta_w2_lower_limit_calo2,
                    eta_w3_upper_limit_calo2,
                    eta_w3_lower_limit_calo2,
                    eta_w4_upper_limit_calo2,
                    eta_w4_lower_limit_calo2,
                    eta_w5_upper_limit_calo2,
                    eta_w5_lower_limit_calo2,
                    phi_full_range_calo2,
                    phi_w1_upper_limit_calo2,
                    phi_w1_lower_limit_calo2,
                    phi_w2_ignore_calo2,
                    phi_w2_upper_limit_calo2,
                    phi_w2_lower_limit_calo2,
                    iso_lut_calo2
                )
                port map(calo2(i), calo2_obj_vs_templ(i,1));
        end generate calo2_obj_l;
    end generate obj_2plus1_true_comb_i;

    calo3_obj_l: for i in calo3_object_low to calo3_object_high generate
        calo3_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo3, obj_type_calo3,
                et_threshold_calo3,
                nr_eta_windows_calo3,
                eta_w1_upper_limit_calo3,
                eta_w1_lower_limit_calo3,
                eta_w2_upper_limit_calo3,
                eta_w2_lower_limit_calo3,
                eta_w3_upper_limit_calo3,
                eta_w3_lower_limit_calo3,
                eta_w4_upper_limit_calo3,
                eta_w4_lower_limit_calo3,
                eta_w5_upper_limit_calo3,
                eta_w5_lower_limit_calo3,
                phi_full_range_calo3,
                phi_w1_upper_limit_calo3,
                phi_w1_lower_limit_calo3,
                phi_w2_ignore_calo3,
                phi_w2_upper_limit_calo3,
                phi_w2_lower_limit_calo3,
                iso_lut_calo3
            )
            port map(calo3(i), calo3_obj_vs_templ(i,1));
    end generate calo3_obj_l;

    comb_cuts_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, calo2_obj_vs_templ, calo3_obj_vs_templ, deta_orm_comp_13, dphi_orm_comp_13, dr_orm_comp_13, deta_orm_comp_23, dphi_orm_comp_23, dr_orm_comp_23, deta_comp_12, dphi_comp_12, dr_comp_12, mass_comp_12, tbpt_comp_12, deta_comp_13, dphi_comp_13, dr_comp_13, mass_comp_13, tbpt_comp_13)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            calo3_obj_vs_templ_pipe <= calo3_obj_vs_templ;
            deta_orm_comp_13_pipe <= deta_orm_comp_13;
            dphi_orm_comp_13_pipe <= dphi_orm_comp_13;
            dr_orm_comp_13_pipe <= dr_orm_comp_13;
            deta_orm_comp_23_pipe <= deta_orm_comp_23;
            dphi_orm_comp_23_pipe <= dphi_orm_comp_23;
            dr_orm_comp_23_pipe <= dr_orm_comp_23;
            deta_comp_12_pipe <= deta_comp_12;
            dphi_comp_12_pipe <= dphi_comp_12;
            dr_comp_12_pipe <= dr_comp_12;
            mass_comp_12_pipe <= mass_comp_12;
            tbpt_comp_12_pipe <= tbpt_comp_12;
            deta_comp_13_pipe <= deta_comp_13;
            dphi_comp_13_pipe <= dphi_comp_13;
            dr_comp_13_pipe <= dr_comp_13;
            mass_comp_13_pipe <= mass_comp_13;
            tbpt_comp_13_pipe <= tbpt_comp_13;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
                calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
                calo3_obj_vs_templ_pipe <= calo3_obj_vs_templ;
                deta_orm_comp_13_pipe <= deta_orm_comp_13;
                dphi_orm_comp_13_pipe <= dphi_orm_comp_13;
                dr_orm_comp_13_pipe <= dr_orm_comp_13;
                deta_orm_comp_23_pipe <= deta_orm_comp_23;
                dphi_orm_comp_23_pipe <= dphi_orm_comp_23;
                dr_orm_comp_23_pipe <= dr_orm_comp_23;
                deta_comp_12_pipe <= deta_comp_12;
                dphi_comp_12_pipe <= dphi_comp_12;
                dr_comp_12_pipe <= dr_comp_12;
                mass_comp_12_pipe <= mass_comp_12;
                tbpt_comp_12_pipe <= tbpt_comp_12;
                deta_comp_13_pipe <= deta_comp_13;
                dphi_comp_13_pipe <= dphi_comp_13;
                dr_comp_13_pipe <= dr_comp_13;
                mass_comp_13_pipe <= mass_comp_13;
                tbpt_comp_13_pipe <= tbpt_comp_13;
            end if;
        end if;
    end process;
    
-- HB 2017-03-27: values of orm cuts between orm limits -> removal !!!
    obj_2plus1_true_matrix_i: if obj_2plus1 = true generate
        matrix_and_or_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, calo3_obj_vs_templ_pipe, deta_orm_comp_13_pipe, dphi_orm_comp_13_pipe, dr_orm_comp_13_pipe, deta_orm_comp_23_pipe, dphi_orm_comp_23_pipe, dr_orm_comp_23_pipe, deta_comp_12_pipe, dphi_comp_12_pipe, dr_comp_12_pipe, mass_comp_12_pipe, tbpt_comp_12_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec, orm_vec: std_logic_3dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high, calo3_object_low to calo3_object_high) :=
                (others => (others => (others => '0')));
            variable obj_vs_templ_or_tmp, obj_vs_templ_orm_vec, orm_vec_or_tmp: std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'));
            variable obj_vs_templ_orm_idx_vec : std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo2_object_high-calo2_object_low+1)) downto 1) := 
                (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => (others => (others => '0')));
            obj_vs_templ_or_tmp := (others => (others => '0'));
            obj_vs_templ_orm_vec := (others => (others => '0'));
            obj_vs_templ_orm_idx_vec := (others => '0');
            orm_vec := (others => (others => (others => '0')));
            orm_vec_or_tmp := (others => (others => '0'));
            condition_and_or_tmp := '0';
            for i in calo1_object_low to calo1_object_high loop 
                for j in calo2_object_low to calo2_object_high loop
                    if j/=i then
                        for k in calo3_object_low to calo3_object_high loop
                            obj_vs_templ_vec(i,j,k) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and calo3_obj_vs_templ_pipe(k,1) and
                                                      mass_comp_12_pipe(i,j) and dr_comp_12_pipe(i,j) and dphi_comp_12_pipe(i,j) and 
                                                      deta_comp_12_pipe(i,j) and tbpt_comp_12_pipe(i,j);
                            sim_obj_vs_templ_vec(i,j,k) <= obj_vs_templ_vec(i,j,k);
                            orm_vec(i,j,k) := (dr_orm_comp_13_pipe(i,k) or dr_orm_comp_23_pipe(j,k) or dphi_orm_comp_13_pipe(i,k) or
                                              dphi_orm_comp_23_pipe(j,k) or deta_orm_comp_13_pipe(i,k) or deta_orm_comp_23_pipe(j,k)) and
                                              calo3_obj_vs_templ_pipe(k,1);
                            sim_orm_vec(i,j,k) <= orm_vec(i,j,k);                          
                            orm_vec_or_tmp(i,j) := orm_vec_or_tmp(i,j) or orm_vec(i,j,k);
                            obj_vs_templ_or_tmp(i,j) := obj_vs_templ_or_tmp(i,j) or obj_vs_templ_vec(i,j,k);
                            sim_orm_vec_or_tmp(i,j) <= orm_vec_or_tmp(i,j);
                            sim_obj_vs_templ_or_tmp(i,j) <= obj_vs_templ_or_tmp(i,j);
                        end loop;
                        index := index + 1;
                        obj_vs_templ_orm_vec(i,j) := obj_vs_templ_or_tmp(i,j) and not orm_vec_or_tmp(i,j);
                        sim_obj_vs_templ_orm_vec(i,j) <= obj_vs_templ_orm_vec(i,j);
                        obj_vs_templ_orm_idx_vec(index) := obj_vs_templ_orm_vec(i,j);
                    end if;
                end loop;
            end loop;        
            for i in 1 to index loop 
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_orm_idx_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process;
    end generate obj_2plus1_true_matrix_i;

    obj_2plus1_false_matrix_i: if obj_2plus1 = false generate
        matrix_and_or_p: process(calo1_obj_vs_templ_pipe, calo3_obj_vs_templ_pipe, deta_orm_comp_13_pipe, dphi_orm_comp_13_pipe, dr_orm_comp_13_pipe, deta_comp_13_pipe, dphi_comp_13_pipe, dr_comp_13_pipe, mass_comp_13_pipe, tbpt_comp_13_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo3_object_high-calo3_object_low+1)) downto 1) := 
                (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in calo1_object_low to calo1_object_high loop 
                for j in calo3_object_low to calo3_object_high loop
                    index := index + 1;
                    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo3_obj_vs_templ_pipe(j,1) and
                                              mass_comp_13_pipe(i,j) and dr_comp_13_pipe(i,j) and dphi_comp_13_pipe(i,j) and deta_comp_13_pipe(i,j) and tbpt_comp_13_pipe(i,j) and
                                              not ((dr_orm_comp_13_pipe(i,j) or dphi_orm_comp_13_pipe(i,j) or deta_orm_comp_13_pipe(i,j)) and calo3_obj_vs_templ_pipe(j,1));
                end loop;
            end loop;        
            for i in 1 to index loop 
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process;
    end generate obj_2plus1_false_matrix_i;

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
