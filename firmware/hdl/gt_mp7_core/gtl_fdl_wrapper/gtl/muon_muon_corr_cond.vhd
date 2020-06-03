
-- Description:
-- Correlation condition for muons.

-- Version history:
-- HB 2020-06-03: first design with new cuts structure (cuts_comp.vhd).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_muon_corr_cond is
    generic(

        same_bx: boolean; 

        deta_cut: boolean;
        dphi_cut: boolean;
        dr_cut: boolean;
        mass_cut: boolean;
        mass_type : natural;
        twobody_pt_cut: boolean;

        muon1_object_low: natural;
        muon1_object_high: natural;
        pt_ge_mode_muon1: boolean;
        pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_muon1 : natural;
        eta_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon1: boolean;
        phi_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon1: boolean;
        phi_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon1: string(1 to 3);
        qual_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

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

        requested_charge_correlation: string(1 to 2);

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
        
        mass_width: positive;
        mass_div_dr_width: positive;
        tbpt_width: positive

   );
    port(
        lhc_clk: in std_logic;
        muon1_data_i: in muon_objects_array;
        muon2_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array;
        os_charcorr_double: in muon_charcorr_double_array;
        deta : in deta_dphi_vector_array := (others => others => others => '0')));
        dphi : in deta_dphi_vector_array := (others => others => others => '0')));
        dr : in dr_vector_array := (others => others => others => '0')));
        mass_inv : in mu_mu_mass_inv_vector_array := (others => others => others => '0')));
        mass_div_dr : in mu_mu_mass_div_dr_vector_array := (others => others => others => '0')));
        tbpt : in mu_mu_mass_tbpt_vector_array := (others => others => others => '0')));
        condition_o: out std_logic
    );
end muon_muon_corr_cond; 

architecture rtl of muon_muon_corr_cond is

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
    signal mass_trv_comp_t, mass_trv_comp, mass_trv_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));
    signal tbpt_comp_t, tbpt_comp, tbpt_comp_pipe : std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) :=
    (others => (others => '1'));

    signal condition_and_or : std_logic;
    
begin

    -- Comparison with limits.
    mass_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        mass_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
            comp_l1: if (same_bx = true) and j>i generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut, dphi_cut, dr_cut, mass_cut, mass_type, twobody_pt_cut,
                        deta_upper_limit, deta_lower_limit, dphi_upper_limit, dphi_lower_limit
                        dr_upper_limit, dr_lower_limit, mass_upper_limit, mass_lower_limit
                        mass_div_dr_upper_limit, mass_div_dr_lower_limit, tbpt_threshold,
                        MU_MU_MASS_INV_VECTOR_WIDTH, MU_MU_MASS_DIV_DR_VECTOR_WIDTH, MU_MU_TBPT_VECTOR_WIDTH
                    )
                    port map(
                        deta(i,j), dphi(i,j), dr(i,j), mass_inv(i,j), mass_trv(i,j), mass_div_dr(i,j), tbpt(i,j),
                        deta_comp_t(i,j), dphi_comp_t(i,j), dr_comp_t(i,j), mass_inv_comp_t(i,j), mass_trv_comp_t(i,j),
                        mass_div_dr_comp_t(i,j), tbpt_comp_t(i,j)
                    );
                deta_comp(i,j) <= deta_comp_t(i,j);
                deta_comp(j,i) <= deta_comp_t(i,j);
                dphi_comp(i,j) <= dphi_comp_t(i,j);
                dphi_comp(j,i) <= dphi_comp_t(i,j);
                dr_comp(i,j) <= dr_comp_t(i,j);
                dr_comp(j,i) <= dr_comp_t(i,j);
                mass_inv_comp(i,j) <= mass_inv_comp_t(i,j);
                mass_inv_comp(j,i) <= mass_inv_comp_t(i,j);
                mass_trv_comp(i,j) <= mass_trv_comp_t(i,j);
                mass_trv_comp(j,i) <= mass_trv_comp_t(i,j);                
                mass_div_dr_comp_pipe(i,j) <= mass_div_dr_comp_t(i,j);
                mass_div_dr_comp_pipe(j,i) <= mass_div_dr_comp_t(i,j);
                tbpt_comp(i,j) <= tbpt_comp_t(i,j);
                tbpt_comp(j,i) <= tbpt_comp_t(i,j);                
            comp_l2: if same_bx = false generate
                comp_i: entity work.cuts_comp
                    generic map(
                        deta_cut, dphi_cut, dr_cut, mass_cut, mass_type, twobody_pt_cut,
                        deta_upper_limit, deta_lower_limit, dphi_upper_limit, dphi_lower_limit
                        dr_upper_limit, dr_lower_limit, mass_upper_limit, mass_lower_limit
                        mass_div_dr_upper_limit, mass_div_dr_lower_limit, tbpt_threshold,
                        MU_MU_MASS_INV_VECTOR_WIDTH, MU_MU_MASS_DIV_DR_VECTOR_WIDTH, MU_MU_TBPT_VECTOR_WIDTH
                    )
                    port map(
                        deta(i,j), dphi(i,j), dr(i,j), mass_inv(i,j), mass_trv(i,j), mass_div_dr(i,j), tbpt(i,j),
                        deta_comp(i,j), dphi_comp(i,j), dr_comp(i,j), mass_inv_comp(i,j), mass_trv_comp(i,j),
                        mass_div_dr_comp_pipe(i,j), tbpt_comp(i,j)
                    );
            end generate comp_l2;
        end generate mass_l_2;
    end generate mass_l_1;
    
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
    cuts_pipeline_p: process(lhc_clk, charge_comp_double)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_inv_comp_pipe <= mass_inv_comp;
            mass_trv_comp_pipe <= mass_trv_comp;
-- mass_div_dr_comp_pipe: 1 bx pipeline done with ROMs for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd
            tbpt_comp_pipe <= tbpt_comp;
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
                iso_lut_muon1
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
                iso_lut_muon2
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
    matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, charge_comp_double_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_inv_comp_pipe, mass_trv_comp_pipe, mass_div_dr_comp_pipe, tbpt_comp_pipe)
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
                        obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_trv_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and tbpt_comp_pipe(i,j);
                    end if;
                else
                    index := index + 1;
                    obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and      charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_inv_comp_pipe(i,j) and mass_trv_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and tbpt_comp_pipe(i,j);
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
