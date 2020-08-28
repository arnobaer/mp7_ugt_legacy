
-- Desription:
-- Correlation Condition module for muon objects.

-- Version history:
-- HB 2020-08-28: new design => all correlation conditions in one file.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity correlation_conditions is
    generic(
        same_bx: boolean; 

        nr_obj1 : natural := 12;
        type_obj1: natural := EG_TYPE;
        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := 12;
        pt_ge_mode_obj1: boolean := true;
        pt_threshold_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj1: natural := 0;
        eta_w1_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_obj1: boolean := true;
        phi_w1_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_obj1: boolean := true;
        phi_w2_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        calo_iso_lut_obj1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');
        muon_requested_charge_obj1: string(1 to 3) := "ign";
        muon_qual_lut_obj1: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0) := (others => '1');
        muon_iso_lut_obj1: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0) := (others => '1');
        muon_upt_cut_obj1 : boolean := false;
        muon_upt_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        muon_upt_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        muon_ip_lut_obj1: std_logic_vector(2**(D_S_I_MUON_V2.ip_high-D_S_I_MUON_V2.ip_low+1)-1 downto 0) := (others => '1');

        nr_obj2 : natural := 12;
        type_obj2: natural := EG_TYPE;
        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := 12;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2: natural := 0;
        eta_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_obj2: boolean := true;
        phi_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_obj2: boolean := true;
        phi_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        calo_iso_lut_obj1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');
        muon_requested_charge_obj2: string(1 to 3) := "ign";
        muon_qual_lut_obj2: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0) := (others => '1');
        muon_iso_lut_obj2: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0) := (others => '1');
        muon_upt_cut_obj2 : boolean := false;
        muon_upt_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        muon_upt_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        muon_ip_lut_obj2: std_logic_vector(2**(D_S_I_MUON_V2.ip_high-D_S_I_MUON_V2.ip_low+1)-1 downto 0) := (others => '1');

        sel_esums: boolean := false;
        nr_esums : natural := 1;
        obj_type_esums: natural := ETM_TYPE;
        et_ge_mode_esums: boolean := true;
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_full_range_esums: boolean := true;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_ignore_esums: boolean := true;
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');

        muon_requested_charge_correlation: string(1 to 2) := "ig";

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
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        twobody_pt_cut: boolean := false;
        tbpt_width: positive := MAX_WIDTH_TBPT_LIMIT_VECTOR;
        tbpt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
--         tbupt_threshold: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0')
        
   );
    port(
        lhc_clk: in std_logic;
        calo1_data_i: in calo_objects_array;
        calo2_data_i: in calo_objects_array;
        esums_data_i: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        muon1_data_i: in muon_objects_array;
        muon2_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        deta : in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi : in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dr : in delta_r_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv : in mass_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_upt : in mass_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_trv : in mass_vector_array(0 to nr_obj1-1, 0 to nr_esums-1) := (others => (others => (others => '0')));
        mass_div_dr : in mass_div_dr_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbpt : in tbpt_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
--         tbupt : in tbpt_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end correlation_conditions; 

architecture rtl of correlation_conditions is

-- fixed pipeline structure, 2 stages total
--     constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
-- obj_vs_templ_pipeline_stage not used, because of 1 bx pipeline of ROMs (for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd)

    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal obj1_vs_templ, obj1_vs_templ_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1);
    signal obj2_vs_templ, obj2_vs_templ_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1);
    signal esums_comp, esums_comp_pipe : std_logic;

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
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal tbpt_comp_t, tbpt_comp, tbpt_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
--     signal tbupt_comp_t, tbupt_comp, tbupt_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
--     (others => (others => '1'));

    signal condition_and_or : std_logic;
    
begin

    not_esums_i: if not sel_esums generate
    -- Correlation cuts comparison with limits.
        cuts_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
            cuts_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                same_i: if (same_bx = true) and j>i generate
                    comp_i: entity work.cuts_comp
                        generic map(
                            deta_cut => deta_cut, dphi_cut => dphi_cut, dr_cut => dr_cut, mass_cut => mass_cut, mass_type => mass_type, twobody_pt_cut => twobody_pt_cut,
                            deta_upper_limit => deta_upper_limit, deta_lower_limit => deta_lower_limit, dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                            dr_upper_limit => dr_upper_limit, dr_lower_limit => dr_lower_limit, mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                            mass_div_dr_threshold => mass_div_dr_threshold, tbpt_threshold => tbpt_threshold,
                            mass_width => mass_width, mass_div_dr_width => mass_div_dr_width, tbpt_width => tbpt_width
                        )
                        port map(
                            deta => deta(i,j), dphi => dphi(i,j), dr => dr(i,j), mass_inv => mass_inv(i,j), mass_inv_upt => mass_inv_upt(i,j), mass_div_dr => mass_div_dr(i,j), tbpt => tbpt(i,j),
                            deta_comp => deta_comp_t(i,j), dphi_comp => dphi_comp_t(i,j), dr_comp => dr_comp_t(i,j), mass_inv_comp => mass_inv_comp_t(i,j), 
                            mass_inv_upt_comp => mass_inv_upt_comp_t(i,j), mass_div_dr_comp => mass_div_dr_comp_t(i,j), twobody_pt_comp => tbpt_comp_t(i,j)
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
                            mass_div_dr_threshold => mass_div_dr_threshold, tbpt_threshold => tbpt_threshold,
                            mass_width => mass_width, mass_div_dr_width => mass_div_dr_width, tbpt_width => tbpt_width
                        )
                        port map(
                            deta => deta(i,j), dphi => dphi(i,j), dr => dr(i,j), mass_inv => mass_inv(i,j), mass_inv_upt => mass_inv_upt(i,j), mass_div_dr => mass_div_dr(i,j), tbpt => tbpt(i,j),
                            deta_comp => deta_comp(i,j), dphi_comp => dphi_comp(i,j), dr_comp => dr_comp(i,j), mass_inv_comp => mass_inv_comp(i,j), 
                            mass_inv_upt_comp => mass_inv_upt_comp(i,j), mass_div_dr_comp => mass_div_dr_comp_pipe(i,j),twobody_pt_comp => tbpt_comp(i,j)
                        );
                end generate not_same_i;
            end generate cuts_l_2;
        end generate cuts_l_1;
        
       -- Charge correlation comparison
        mu_mu_corr_i: if type_obj1 == MU_TYPE and type_obj2 == MU_TYPE generate
            charge_double_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
                charge_double_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
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
        end generate mu_mu_corr_i;

        -- Pipeline stage for charge correlation comparison
        cuts_pipeline_p: process(lhc_clk, deta_comp, dphi_comp, dr_comp, mass_inv_comp, mass_inv_upt_comp, mass_trv_comp, tbpt_comp, charge_comp_double)
            begin
            if (lhc_clk'event and lhc_clk = '1') then
                deta_comp_pipe <= deta_comp;
                dphi_comp_pipe <= dphi_comp;
                dr_comp_pipe <= dr_comp;
                mass_inv_comp_pipe <= mass_inv_comp;
                mass_inv_upt_comp_pipe <= mass_inv_upt_comp;
                tbpt_comp_pipe <= tbpt_comp;
    --             tbupt_comp_pipe <= tbupt_comp;
                charge_comp_double_pipe <= charge_comp_double;
            end if;
        end process;
        
        -- Instance of comparators for calorimeter objects.
        obj1_calo_sel_i: if type_obj1 /= MU_TYPE generate
            calo1_obj_l: for i in slice_low_obj1 to slice_high_obj1 generate
                calo1_comp_i: entity work.calo_comparators
                    generic map(et_ge_mode_obj1, obj_type_obj1,
                        et_threshold_obj1,
                        nr_eta_windows_obj1,
                        eta_w1_upper_limit_obj1,
                        eta_w1_lower_limit_obj1,
                        eta_w2_upper_limit_obj1,
                        eta_w2_lower_limit_obj1,
                        eta_w3_upper_limit_obj1,
                        eta_w3_lower_limit_obj1,
                        eta_w4_upper_limit_obj1,
                        eta_w4_lower_limit_obj1,
                        eta_w5_upper_limit_obj1,
                        eta_w5_lower_limit_obj1,
                        phi_full_range_obj1,
                        phi_w1_upper_limit_obj1,
                        phi_w1_lower_limit_obj1,
                        phi_w2_ignore_obj1,
                        phi_w2_upper_limit_obj1,
                        phi_w2_lower_limit_obj1,
                        iso_lut_obj1
                    )
                    port map(calo1_data_i(i), obj1_vs_templ(i,1));
            end generate calo1_obj_l;
        end generate obj1_calo_sel_i;

        obj2_calo_sel_i: if type_obj2 /= MU_TYPE generate
            calo2_obj_l: for i in slice_low_obj2 to slice_high_obj2 generate
                calo2_comp_i: entity work.calo_comparators
                    generic map(et_ge_mode_obj2, obj_type_obj2,
                        et_threshold_obj2,
                        nr_eta_windows_obj2,
                        eta_w1_upper_limit_obj2,
                        eta_w1_lower_limit_obj2,
                        eta_w2_upper_limit_obj2,
                        eta_w2_lower_limit_obj2,
                        eta_w3_upper_limit_obj2,
                        eta_w3_lower_limit_obj2,
                        eta_w4_upper_limit_obj2,
                        eta_w4_lower_limit_obj2,
                        eta_w5_upper_limit_obj2,
                        eta_w5_lower_limit_obj2,
                        phi_full_range_obj2,
                        phi_w1_upper_limit_obj2,
                        phi_w1_lower_limit_obj2,
                        phi_w2_ignore_obj2,
                        phi_w2_upper_limit_obj2,
                        phi_w2_lower_limit_obj2,
                        iso_lut_obj2
                    )
                    port map(calo2_data_i(i), obj2_vs_templ(i,1));
            end generate calo2_obj_l;
        end generate obj2_calo_sel_i;
        
        -- Instance of comparators for muon objects.
        obj1_mu_sel_i: if type_obj1 == MU_TYPE generate
            obj_templ1_l: for i in slice_low_obj1 to slice_high_obj1 generate
                obj_templ1_comp_i: entity work.muon_comparators
                    generic map(pt_ge_mode_obj1,
                        pt_threshold_obj1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                        nr_eta_windows_obj1,
                        eta_w1_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w1_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w2_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w2_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w3_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w3_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w4_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w4_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w5_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w5_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        phi_full_range_obj1,
                        phi_w1_upper_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w1_lower_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w2_ignore_obj1,
                        phi_w2_upper_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w2_lower_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        requested_charge_obj1,
                        qual_lut_obj1,
                        iso_lut_obj1,
                        upt_cut_obj1,
                        upt_upper_limit_obj1(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                        upt_lower_limit_obj1(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                        ip_lut_obj1
                    )
                    port map(muon1_data_i(i), obj1_vs_templ(i,1));
            end generate obj_templ1_l;
        end generate obj1_mu_sel_i;

        obj2_mu_sel_i: if type_obj2 == MU_TYPE generate
            obj_templ2_l_l: for i in slice_low_obj2 to slice_high_obj2 generate
                obj_templ2_comp_i: entity work.muon_comparators
                    generic map(pt_ge_mode_obj2,
                        pt_threshold_obj2(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                        nr_eta_windows_obj2,
                        eta_w1_upper_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w1_lower_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w2_upper_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w2_lower_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w3_upper_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w3_lower_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w4_upper_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w4_lower_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w5_upper_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w5_lower_limit_obj2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        phi_full_range_obj2,
                        phi_w1_upper_limit_obj2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w1_lower_limit_obj2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w2_ignore_obj2,
                        phi_w2_upper_limit_obj2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w2_lower_limit_obj2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        requested_charge_obj2,
                        qual_lut_obj2,
                        iso_lut_obj2,
                        upt_cut_obj2,
                        upt_upper_limit_obj2(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                        upt_lower_limit_obj2(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                        ip_lut_obj2
                    )
                    port map(muon2_data_i(i), obj2_vs_templ(i,1));
            end generate obj_templ2_l_l;
        end generate obj2_mu_sel_i;

        -- Pipeline stage for obj_vs_templ
        obj_vs_templ_pipeline_p: process(lhc_clk, obj1_vs_templ, obj2_vs_templ)
            begin
            if (lhc_clk'event and lhc_clk = '1') then
                obj1_vs_templ_pipe <= obj1_vs_templ;
                obj2_vs_templ_pipe <= obj2_vs_templ;
            end if;
        end process;

        -- "Matrix" of permutations in an and-or-structure.
        matrix_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, charge_comp_double_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_inv_comp_pipe, mass_inv_upt_comp_pipe, mass_trv_comp_pipe, mass_div_dr_comp_pipe, tbpt_comp_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop 
                for j in slice_low_obj2 to slice_high_obj2 loop
                    if same_bx = true then
                        if j/=i then
                            index := index + 1;
                            obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_inv_upt_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and tbpt_comp_pipe(i,j);
                        end if;
                    else
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and 
                        dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_inv_upt_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and 
                        tbpt_comp_pipe(i,j);
                    end if;
                end loop;
            end loop;
            for i in 1 to index loop 
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_p;
    end generate not_esums_i;
    
    sel_esums_i: if sel_esums generate
        cuts_l: for i in slice_low_obj1 to slice_high_obj1 generate
            comp_i: entity work.cuts_comp
                generic map(
                    dphi_cut => dphi_cut, 
                    mass_cut => mass_cut, 
                    mass_type => TRANSVERSE_MASS_TYPE, 
                    twobody_pt_cut => twobody_pt_cut,
                    dphi_upper_limit => dphi_upper_limit, dphi_lower_limit => dphi_lower_limit,
                    mass_upper_limit => mass_upper_limit, mass_lower_limit => mass_lower_limit,
                    tbpt_threshold => tbpt_threshold,
                    mass_width => mass_width, 
                    tbpt_width => tbpt_width
                )
                port map(
                    dphi => dphi(i,0), 
                    mass_trv => mass_trv(i,0), 
                    tbpt => tbpt(i,0),
                    dphi_comp => dphi_comp(i,0), 
                    mass_trv_comp => mass_trv_comp(i,0),
                    twobody_pt_comp => tbpt_comp(i,0)
                );
        end generate cuts_l;
        
        -- Pipeline stage for cut comps
        diff_pipeline_p: process(lhc_clk, dphi_comp, mass_trv_comp, tbpt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                dphi_comp_pipe <= dphi_comp;
                mass_trv_comp_pipe <= mass_trv_comp;
                tbpt_comp_pipe <= tbpt_comp;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    dphi_comp_pipe <= dphi_comp;
                    mass_trv_comp_pipe <= mass_trv_comp;
                    tbpt_comp_pipe <= tbpt_comp;
                end if;
            end if;
        end process;

        -- Instance of comparators for calorimeter objects.
        obj1_calo_sel_i: if type_obj1 /= MU_TYPE generate
            calo1_obj_l: for i in slice_low_obj1 to slice_high_obj1 generate
                calo1_comp_i: entity work.calo_comparators
                    generic map(et_ge_mode_obj1, obj_type_obj1,
                        et_threshold_obj1,
                        nr_eta_windows_obj1,
                        eta_w1_upper_limit_obj1,
                        eta_w1_lower_limit_obj1,
                        eta_w2_upper_limit_obj1,
                        eta_w2_lower_limit_obj1,
                        eta_w3_upper_limit_obj1,
                        eta_w3_lower_limit_obj1,
                        eta_w4_upper_limit_obj1,
                        eta_w4_lower_limit_obj1,
                        eta_w5_upper_limit_obj1,
                        eta_w5_lower_limit_obj1,
                        phi_full_range_obj1,
                        phi_w1_upper_limit_obj1,
                        phi_w1_lower_limit_obj1,
                        phi_w2_ignore_obj1,
                        phi_w2_upper_limit_obj1,
                        phi_w2_lower_limit_obj1,
                        iso_lut_obj1
                    )
                    port map(calo1_data_i(i), obj1_vs_templ(i,1));
            end generate calo1_obj_l;
        end generate obj1_calo_sel_i;

        -- Instance of comparators for muon objects.
        obj1_mu_sel_i: if type_obj1 == MU_TYPE generate
            obj_templ1_l: for i in slice_low_obj1 to slice_high_obj1 generate
                obj_templ1_comp_i: entity work.muon_comparators
                    generic map(pt_ge_mode_obj1,
                        pt_threshold_obj1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                        nr_eta_windows_obj1,
                        eta_w1_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w1_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w2_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w2_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w3_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w3_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w4_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w4_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w5_upper_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        eta_w5_lower_limit_obj1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                        phi_full_range_obj1,
                        phi_w1_upper_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w1_lower_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w2_ignore_obj1,
                        phi_w2_upper_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        phi_w2_lower_limit_obj1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                        requested_charge_obj1,
                        qual_lut_obj1,
                        iso_lut_obj1,
                        upt_cut_obj1,
                        upt_upper_limit_obj1(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                        upt_lower_limit_obj1(D_S_I_MUON_V2.upt_high-D_S_I_MUON_V2.upt_low downto 0),
                        ip_lut_obj1
                    )
                    port map(muon1_data_i(i), obj1_vs_templ(i,1));
            end generate obj_templ1_l;
        end generate obj1_mu_sel_i;

        esums_comparators_i: entity work.esums_comparators
            generic map(
                et_ge_mode => et_ge_mode_esums,
                obj_type => obj_type_esums,
                et_threshold => et_threshold_esums,
                phi_full_range => phi_full_range_esums,
                phi_w1_upper_limit => phi_w1_upper_limit_esums,
                phi_w1_lower_limit => phi_w1_lower_limit_esums,
                phi_w2_ignore => phi_w2_ignore_esums,
                phi_w2_upper_limit => phi_w2_upper_limit_esums,
                phi_w2_lower_limit => phi_w2_lower_limit_esums
            )
            port map(
                data_i => esums_data_i,
                comp_o => esums_comp
            );

        -- Pipeline stage
        obj_vs_templ_pipeline_p: process(lhc_clk, obj1_vs_templ, esums_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj1_vs_templ_pipe <= obj1_vs_templ;
                esums_comp_pipe <= esums_comp;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    obj1_vs_templ_pipe <= obj1_vs_templ;
                    esums_comp_pipe <= esums_comp;
                end if;
            end if;
        end process;

        -- "Matrix" of permutations in an and-or-structure.
        matrix_dphi_mass_p: process(obj1_vs_templ_pipe, esums_comp_pipe, dphi_comp_pipe, mass_trv_comp_pipe, tbpt_comp_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((slice_high_obj1-slice_low_obj1+1) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop
                    index := index + 1;
                    obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and esums_comp_pipe and dphi_comp_pipe(i,0) and mass_trv_comp_pipe(i,0) and tbpt_comp_pipe(i,0);
            end loop;
            for i in 1 to index loop
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_dphi_mass_p;
    end generate sel_esums_i;

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
