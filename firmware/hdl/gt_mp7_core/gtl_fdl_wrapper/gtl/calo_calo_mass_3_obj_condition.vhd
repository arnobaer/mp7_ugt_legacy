
-- Description:
-- Condition for invariant mass with 3 calo objects.

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

entity calo_calo_mass_3_obj_condition is
     generic(

        nr_obj: natural := NR_EG_OBJECTS;
        obj_type: natural := EG_TYPE;

        calo1_object_low: natural := 0;
        calo1_object_high: natural := 11;
        pt_ge_mode_calo1: boolean := true;
        pt_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_calo1: natural := 0;
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
        iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        calo2_object_low: natural := 0;
        calo2_object_high: natural := 11;
        pt_ge_mode_calo2: boolean := true;
        pt_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_calo2: natural := 0;
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
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        calo3_object_low: natural := 0;
        calo3_object_high: natural := 11;
        pt_ge_mode_calo3: boolean := true;
        pt_threshold_calo3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_calo3: natural := 0;
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
        iso_lut_calo3: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_width: positive := MAX_WIDTH_MASS_LIMIT_VECTOR
        
    );
    port(
        lhc_clk: in std_logic;
        calo_data_i: in calo_objects_array;
        mass_inv : in mass_vector_array(0 to nr_obj-1, 0 to nr_obj-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end calo_calo_mass_3_obj_condition; 

architecture rtl of calo_calo_mass_3_obj_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type calo1_object_vs_template_array is array (calo1_object_low to calo1_object_high, 1 to 1) of std_logic;
    type calo2_object_vs_template_array is array (calo2_object_low to calo2_object_high, 1 to 1) of std_logic;
    type calo3_object_vs_template_array is array (calo3_object_low to calo3_object_high, 1 to 1) of std_logic;

    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : calo1_object_vs_template_array;
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : calo2_object_vs_template_array;
    signal calo3_obj_vs_templ, calo3_obj_vs_templ_pipe : calo3_object_vs_template_array;

    signal mass_comp, mass_comp_pipe : 
        std_logic_3dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) := (others => (others => (others => '0')));

    type sum_mass_array is array(0 to nr_obj-1, 0 to nr_obj-1, 0 to nr_obj-1) of std_logic_vector(mass_width+1 downto 0);
    signal sum_mass, sum_mass_temp : sum_mass_array := (others => (others => (others => (others => '0'))));   

    signal condition_and_or : std_logic;

begin

    -- *** section: CUTs - begin ***************************************************************************************

    l1_sum: for i in 0 to nr_obj-1 generate
        l2_sum: for j in 0 to nr_obj-1 generate
            l3_sum: for k in 0 to nr_obj-1 generate
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
    
    l1_comp: for i in calo1_object_low to calo1_object_high generate
        l2_comp: for j in calo2_object_low to calo2_object_high generate
            l3_comp: for k in calo3_object_low to calo3_object_high generate
                mass_comp(i,j,k) <= '1' when sum_mass(i,j,k) >= mass_lower_limit_vector(mass_width-1 downto 0) and
                    sum_mass(i,j,k) <= mass_upper_limit_vector(mass_width-1 downto 0) else '0';
            end generate l3_comp;    
        end generate l2_comp;
    end generate l1_comp;

    -- *** section: CUTs - end ***************************************************************************************

    obj_templ1_l: for i in calo1_object_low to calo1_object_high generate
        obj_templ1_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_calo1, obj_type,
                pt_threshold_calo1,
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
            port map(calo_data_i(i), calo1_obj_vs_templ(i,1));
    end generate obj_templ1_l;

    obj_templ2_l_l: for i in calo2_object_low to calo2_object_high generate
        obj_templ2_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_calo2, obj_type,
                pt_threshold_calo2,
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
            port map(calo_data_i(i), calo2_obj_vs_templ(i,1));
    end generate obj_templ2_l_l;

    obj_templ3_l_l: for i in calo3_object_low to calo3_object_high generate
        obj_templ3_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_calo3, obj_type,
                pt_threshold_calo3,
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
            port map(calo_data_i(i), calo3_obj_vs_templ(i,1));
    end generate obj_templ3_l_l;

    -- Pipeline stage for obj_vs_templ and mass_comp
    pipeline_p: process(lhc_clk, calo1_obj_vs_templ, calo2_obj_vs_templ, calo3_obj_vs_templ, mass_comp)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            calo3_obj_vs_templ_pipe <= calo3_obj_vs_templ;
            mass_comp_pipe <= mass_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
                calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
                calo3_obj_vs_templ_pipe <= calo3_obj_vs_templ;
                mass_comp_pipe <= mass_comp;
            end if;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, calo3_obj_vs_templ_pipe, mass_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((calo1_object_high-calo1_object_low+1)*(calo2_object_high-calo2_object_low+1)*(calo3_object_high-calo3_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo1_object_low to calo1_object_high loop 
            for j in calo2_object_low to calo2_object_high loop
                for k in calo3_object_low to calo3_object_high loop
                    if j/=i and i/=k and j/=k then
                        index := index + 1;
                        obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and calo3_obj_vs_templ_pipe(k,1) and 
                            mass_comp_pipe(i,j,k);
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
    
    
    
    
    
    
    
    
    
    
