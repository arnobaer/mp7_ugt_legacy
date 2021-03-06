
##***************************** Beginning of Script ***************************

## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

## HB 2019-04-12: setting of XILINX not clear! Not needed, removed!
#set XILINX   $env(XILINX)

if [info exists env(MTI_LIBS)] {
    set MTI_LIBS $env(MTI_LIBS)
    vlib UNISIM
    vlib SECUREIP
    vmap UNISIM $MTI_LIBS/unisim
    vmap SECUREIP $MTI_LIBS/secureip
}

## set your src files directory for your design

set MP7_COMPONENTS {{MP7_TAG}}/components
set VIEW_WAVE {{VIEW_WAVE}}

set HDL_DIR {{SIM_DIR}}/../hdl
set NGC_DIR {{SIM_DIR}}/../ngc
set TB_DIR {{SIM_DIR}}/testbench
set MENU_DIR {{MENU_DIR}}
set MOD_TB_DIR {{MOD_TB_DIR}}
set FILE_NAME {{MENU_DIR}}/../running.lock

## Create and map work directory
vlib work
vmap work work

##Design files
vcom -93 -work work $MP7_COMPONENTS/mp7_datapath/firmware/hdl/mp7_data_types.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_package.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_trans_decl.vhd
vcom -93 -work work $HDL_DIR/lhc_data_pkg.vhd
vcom -93 -work work $HDL_DIR/math_pkg.vhd
## HB 2016-12-05: used gt_mp7_core_pkg_sim.vhd for simulation without other MP7 packages
vcom -93 -work work $HDL_DIR/gt_mp7_core/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $MENU_DIR/gtl_pkg.vhd
vcom -93 -work work $TB_DIR/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $TB_DIR/txt_util_pkg.vhd

vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/p_m_2_bx_pipeline.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/phi_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_comp_signed.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/twobody_pt_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/twobody_pt.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_cond_matrix.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_cond_matrix_orm.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_obj_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/min_bias_hf_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_cond_matrix.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_obj_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_charge_correlations.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_charge_corr_matrix.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/dr_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/cuts_instances.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/towercount_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_muon_correlation_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_muon_correlation_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_esums_correlation_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_esums_correlation_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_orm.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_cond_matrix_orm.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions_orm.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_calo_correlation_orm_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sum_mass_calc.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_mass_3_obj_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_mass_3_obj_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_div_dr_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_div_dr_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_mass_div_dr_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_muon_mass_div_dr_condition.vhd

vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_1/synth/rom_lut_calo_inv_dr_sq_1.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_2/synth/rom_lut_calo_inv_dr_sq_2.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_3/synth/rom_lut_calo_inv_dr_sq_3.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_4/synth/rom_lut_calo_inv_dr_sq_4.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_5/synth/rom_lut_calo_inv_dr_sq_5.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_6/synth/rom_lut_calo_inv_dr_sq_6.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_7/synth/rom_lut_calo_inv_dr_sq_7.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_8/synth/rom_lut_calo_inv_dr_sq_8.vhd
vcom -93 -work work $NGC_DIR/rom_lut_calo_inv_dr_sq_9/synth/rom_lut_calo_inv_dr_sq_9.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_1/synth/rom_lut_muon_inv_dr_sq_1.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_2/synth/rom_lut_muon_inv_dr_sq_2.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_3/synth/rom_lut_muon_inv_dr_sq_3.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_4/synth/rom_lut_muon_inv_dr_sq_4.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_5/synth/rom_lut_muon_inv_dr_sq_5.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_6/synth/rom_lut_muon_inv_dr_sq_6.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_7/synth/rom_lut_muon_inv_dr_sq_7.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_8/synth/rom_lut_muon_inv_dr_sq_8.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_9/synth/rom_lut_muon_inv_dr_sq_9.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/rom_lut_calo_inv_dr_sq_all.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/rom_lut_muon_inv_dr_sq_all.vhd
vcom -93 -work work $MENU_DIR/gtl_module.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/frame/dm/delay_element.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/update_process.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/pulse_converter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_addr_decode.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_fabric.vhd
#vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_pkg_prescale_float.vhd
#vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_pkg_prescale_num_denom.vhd
#vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler_fractional_pkg.vhd
#vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler_fractional.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler_fractional_float.vhd
#vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler_fractional_num_denom.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_rate_counter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_post_dead_time_counter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_slice.vhd
#vcom -93 -work work $NGC_DIR/dp_mem_4096x32/dp_mem_4096x32.vhd
vcom -93 -work work $NGC_DIR/dp_mem_4096x32_blk_mem_gen_v8_4_2/synth/dp_mem_4096x32.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_dpmem_4096_32.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_read_regs.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_write_regs.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_pulse_regs.vhd
vcom -93 -work work $MENU_DIR/algo_mapping_rop.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_module.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl_fdl_wrapper.vhd

##TB_DIR
vcom -93 -work work $MOD_TB_DIR/gtl_fdl_wrapper_tb.vhd

##Load Design
vsim -t 1ps work.gtl_fdl_wrapper_TB

if {$VIEW_WAVE} {
  #Load signals in wave window
  view wave
  do $TB_DIR/../scripts/gtl_fdl_wrapper_test_wave.do
}
set fileId [open $FILE_NAME "w"]
close $fileId
##Run simulation
run 91000 ns

# eof
