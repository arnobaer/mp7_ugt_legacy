----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2019 05:44:08 PM
-- Design Name: 
-- Module Name: calo_conditions_v1_quad_240MHz - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.mp7_data_types.all;

use work.gtl_pkg.all;
use work.lhc_data_pkg.all;

entity calo_condition_v1_quad_240MHz is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        calo_object_slice_4_low: natural;
        calo_object_slice_4_high: natural;
        nr_templates: positive;
        et_ge_mode: boolean;
        obj_type : natural := EG_TYPE;
        et_thresholds: calo_templates_array;
        eta_full_range : calo_templates_boolean_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_ignore : calo_templates_boolean_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_iso_array;
        NR_LANES : positive
    );
    Port ( clk240 : in STD_LOGIC;
           lhc_clk : in STD_LOGIC;
           lane_data : in ldata(NR_LANES-1 downto 0);
           condition_o : out STD_LOGIC);
end calo_condition_v1_quad_240MHz;
        
architecture Behavioral of calo_condition_v1_quad_240MHz is

  -- type TLinkList is array(natural range<>) of positive;
  -- signal sLinkList : TLinkList;

  type TCutList is array(natural range <>) of std_logic_vector(4 downto 1);
  signal cuts_passed : TCutList(1 downto 0);
  signal temp_1, temp_2, temp_3, temp_4, temp_5 : TCutList(1 downto 0);

  signal obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array;
  signal obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array;
  signal obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array;
  signal obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array;

begin
  -- First try applying all cuts with 240 MHz and then do "matrix" as before.
  -- Going this way we shouldn't delay line data, but use it as it comes from the GTHs.

  -- Need to make two loops here, one over the two (or more) links and one over the number of conditions (four)
  link_loop : for l in cuts_passed'range generate
    cond_loop : for c in cuts_passed(0)'range generate
      comp_i: entity work.calo_comparators_v2
        generic map(et_ge_mode, obj_type,
          et_thresholds(c),
          eta_full_range(c),
          eta_w1_upper_limits(c),
          eta_w1_lower_limits(c),
          eta_w2_ignore(c),
          eta_w2_upper_limits(c),
          eta_w2_lower_limits(c),
          phi_full_range(c),
          phi_w1_upper_limits(c),
          phi_w1_lower_limits(c),
          phi_w2_ignore(c),
          phi_w2_upper_limits(c),
          phi_w2_lower_limits(c),
          iso_luts(c)
          )
        port map(std_logic_vector(lane_data(OFFSET_EG_LANES+l).data), -- TODO: Taking lanes for EG objects here, need to make more generic!! 
                 cuts_passed(l)(c));
    end generate cond_loop;
  end generate link_loop;

  -- Deserialise cut vector. (Make it the obj_slice_1_vs_templ_pipe objects)
  pipeline_240mhz_p: process(clk240)
    begin
      if (clk240'event and clk240 = '1') then
        temp_1 <= cuts_passed;
        temp_2 <= temp_1;
        temp_3 <= temp_2;
        temp_4 <= temp_3;
        temp_5 <= temp_4;
      end if;
  end process;
  
  data_40mhz_p: process(lhc_clk)
    begin
      if lhc_clk'event and lhc_clk = '1' then
        -- TODO: Need to check the ordering (currently the last object coming in has lowest index)
        obj_slice_1_vs_templ_pipe(0, 1) <= cuts_passed(0)(1);
        obj_slice_1_vs_templ_pipe(1, 1) <= temp_1(0)(1);
        obj_slice_1_vs_templ_pipe(2, 1) <= temp_2(0)(1);
        obj_slice_1_vs_templ_pipe(3, 1) <= temp_3(0)(1);
        obj_slice_1_vs_templ_pipe(4, 1) <= temp_4(0)(1);
        obj_slice_1_vs_templ_pipe(5, 1) <= temp_5(0)(1);
        obj_slice_1_vs_templ_pipe(6, 1) <= cuts_passed(1)(1);
        obj_slice_1_vs_templ_pipe(7, 1) <= temp_1(1)(1);
        obj_slice_1_vs_templ_pipe(8, 1) <= temp_2(1)(1);
        obj_slice_1_vs_templ_pipe(9, 1) <= temp_3(1)(1);
        obj_slice_1_vs_templ_pipe(10, 1) <= temp_4(1)(1);
        obj_slice_1_vs_templ_pipe(11, 1) <= temp_5(1)(1);

        obj_slice_2_vs_templ_pipe(0, 1) <= cuts_passed(0)(2);
        obj_slice_2_vs_templ_pipe(1, 1) <= temp_1(0)(2);
        obj_slice_2_vs_templ_pipe(2, 1) <= temp_2(0)(2);
        obj_slice_2_vs_templ_pipe(3, 1) <= temp_3(0)(2);
        obj_slice_2_vs_templ_pipe(4, 1) <= temp_4(0)(2);
        obj_slice_2_vs_templ_pipe(5, 1) <= temp_5(0)(2);
        obj_slice_2_vs_templ_pipe(6, 1) <= cuts_passed(1)(2);
        obj_slice_2_vs_templ_pipe(7, 1) <= temp_1(1)(2);
        obj_slice_2_vs_templ_pipe(8, 1) <= temp_2(1)(2);
        obj_slice_2_vs_templ_pipe(9, 1) <= temp_3(1)(2);
        obj_slice_2_vs_templ_pipe(10, 1) <= temp_4(1)(2);
        obj_slice_2_vs_templ_pipe(11, 1) <= temp_5(1)(2);

        obj_slice_3_vs_templ_pipe(0, 1) <= cuts_passed(0)(3);
        obj_slice_3_vs_templ_pipe(1, 1) <= temp_1(0)(3);
        obj_slice_3_vs_templ_pipe(2, 1) <= temp_2(0)(3);
        obj_slice_3_vs_templ_pipe(3, 1) <= temp_3(0)(3);
        obj_slice_3_vs_templ_pipe(4, 1) <= temp_4(0)(3);
        obj_slice_3_vs_templ_pipe(5, 1) <= temp_5(0)(3);
        obj_slice_3_vs_templ_pipe(6, 1) <= cuts_passed(1)(3);
        obj_slice_3_vs_templ_pipe(7, 1) <= temp_1(1)(3);
        obj_slice_3_vs_templ_pipe(8, 1) <= temp_2(1)(3);
        obj_slice_3_vs_templ_pipe(9, 1) <= temp_3(1)(3);
        obj_slice_3_vs_templ_pipe(10, 1) <= temp_4(1)(3);
        obj_slice_3_vs_templ_pipe(11, 1) <= temp_5(1)(3);

        obj_slice_4_vs_templ_pipe(0, 1) <= cuts_passed(0)(4);
        obj_slice_4_vs_templ_pipe(1, 1) <= temp_1(0)(4);
        obj_slice_4_vs_templ_pipe(2, 1) <= temp_2(0)(4);
        obj_slice_4_vs_templ_pipe(3, 1) <= temp_3(0)(4);
        obj_slice_4_vs_templ_pipe(4, 1) <= temp_4(0)(4);
        obj_slice_4_vs_templ_pipe(5, 1) <= temp_5(0)(4);
        obj_slice_4_vs_templ_pipe(6, 1) <= cuts_passed(1)(4);
        obj_slice_4_vs_templ_pipe(7, 1) <= temp_1(1)(4);
        obj_slice_4_vs_templ_pipe(8, 1) <= temp_2(1)(4);
        obj_slice_4_vs_templ_pipe(9, 1) <= temp_3(1)(4);
        obj_slice_4_vs_templ_pipe(10, 1) <= temp_4(1)(4);
        obj_slice_4_vs_templ_pipe(11, 1) <= temp_5(1)(4);
    end if;
  end process;

  -- "Matrix" of permutations in an and-or-structure.
  -- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

  cond_matrix: entity work.quad_cond_matrix
    generic map(
        nr_templates => nr_templates
    )
    port map( clk => lhc_clk,
           obj_slice_1_vs_templ_pipe => obj_slice_1_vs_templ_pipe,
           obj_slice_2_vs_templ_pipe => obj_slice_2_vs_templ_pipe,
           obj_slice_3_vs_templ_pipe => obj_slice_3_vs_templ_pipe,
           obj_slice_4_vs_templ_pipe => obj_slice_4_vs_templ_pipe,
           condition_o => condition_o);

-- In second step we should try running the "matrix" with 240 MHz too.

end Behavioral;
