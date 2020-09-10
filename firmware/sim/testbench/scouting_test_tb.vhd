
-- Desription:
-- Testbench for testing the outputs for scouting.
-- Therefore VHDL modules rb_pkg_sim, tcm_sim, output_mux_sim and mux_sim used (no simulation for IPBus).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.rb_pkg.all;

entity scouting_test_TB is
end scouting_test_TB;

architecture rtl of scouting_test_TB is

    constant LHC_CLK_PERIOD : time := 24.0 ns;
    constant clk240_PERIOD : time := 4.0 ns;
    constant NR_LANES : positive := 28;

    signal clk240, lhc_clk, lhc_rst, ec0, oc0, l1a, local_finor_in, local_veto_in, local_finor_veto_in, start, cntr_rst, bcres, bcres_FDL : std_logic := '0';
    signal ctrs : ttc_stuff_array(0 to 6) := (others => (X"00", '0', X"000", "000"));
    signal prescale_factor : std_logic_vector(7 downto 0) := (others => '0');
    signal algo_after_gtLogic_rop, algo_after_bxomask_rop, algo_after_prescaler_rop : std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '0');
    signal sw_reg_in : sw_reg_tcm_in_t := ('0', '0', "0000", '0', X"00000000", X"00040000");
    signal bx_nr, bx_nr_FDL : bx_nr_t := (others => '0');
    signal orbit_nr : orbit_nr_t := (others => '0');
    signal lane_out : ldata(NR_LANES-1 downto 0);
   
    constant  mux_ctrl : ipb_regs_array(0 to 15) := (0 => X"00000bb8", 1 => X"00000c80", 2 => X"00000000", 3 => X"00000001", others => X"00000000"); -- bb8 =^ 3000, c80 =^ 3200
--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
        clk240  <=  '1';
        wait for clk240_PERIOD/2;
        clk240  <=  '0';
        wait for clk240_PERIOD/2;
    end process;

    process
    begin
        wait for 5 * LHC_CLK_PERIOD; 
        lhc_rst <= '1';
        cntr_rst <= '1';
        wait for LHC_CLK_PERIOD; 
        lhc_rst <= '0';
        cntr_rst <= '0';
        wait for 2 * LHC_CLK_PERIOD; 
        oc0 <= '1';
        wait for LHC_CLK_PERIOD; 
        oc0 <= '0';
        wait for 2 * LHC_CLK_PERIOD; 
        start <= '1';
        wait for LHC_CLK_PERIOD; 
        start <= '0';
        wait for 2 * LHC_CLK_PERIOD; 
        ec0 <= '1';
        wait for LHC_CLK_PERIOD; 
        ec0 <= '0';
        wait for 2 * LHC_CLK_PERIOD; 
        bcres <= '1';
        wait for LHC_CLK_PERIOD; 
        bcres <= '0';
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

    tcm_inst: entity work.tcm
        port map(
            lhc_clk           => lhc_clk,
            lhc_rst           => lhc_rst,
            cntr_rst          => cntr_rst,
-- HB 2017-09-11: all bgos from sync_proc_i instead of dm.vhd
            ec0               => ec0,
            oc0               => oc0,
            start             => start,
            l1a_sync          => l1a,
            bcres_d           => bcres,
            bcres_d_FDL       => bcres_FDL,
            sw_reg_in         => sw_reg_in,
            sw_reg_out        => open,
            bx_nr             => bx_nr,
            bx_nr_d_FDL       => bx_nr_FDL,
            event_nr          => open,
            trigger_nr        => open,
            orbit_nr          => orbit_nr,
            luminosity_seg_nr => open,
            start_lumisection => open
        );

    dut: entity work.output_mux
        generic map(
            NR_LANES => NR_LANES
        )
        port map(
            lhc_clk => lhc_clk,
            lhc_rst => lhc_rst,
            clk240 => clk240,
            ctrs => ctrs,
            bx_nr => bx_nr,
            bx_nr_fdl => bx_nr_fdl,
            orbit_nr => orbit_nr,
            algo_after_gtLogic => algo_after_gtLogic_rop,
            algo_after_bxomask => algo_after_bxomask_rop,
            algo_after_prescaler => algo_after_prescaler_rop,
            local_finor_in => local_finor_in,
            local_veto_in => local_veto_in,
            local_finor_veto_in => local_finor_veto_in,
            prescale_factor => prescale_factor,
            valid_lo => mux_ctrl(0)(15 downto 0),
            valid_hi => mux_ctrl(1)(15 downto 0),
            start => mux_ctrl(2)(0),
            strobe => mux_ctrl(3)(0),
            lane_out => lane_out
        );

end rtl;

