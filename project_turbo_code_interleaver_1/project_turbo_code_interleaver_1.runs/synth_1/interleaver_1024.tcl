# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.cache/wt [current_project]
set_property parent.project_path C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/DFF.vhd
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/DFF_N.vhdl
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/DFF_en.vhd
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/counter.vhd
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/full_adder.vhd
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/interleaver.vhd
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/ripple_carry_adder.vhd
  C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/sources_1/imports/src/interleaver_1024.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/constrs_1/new/timing_contraint.xdc
set_property used_in_implementation false [get_files C:/Users/clari/Desktop/turbo_coding_interleaver/project_turbo_code_interleaver_1/project_turbo_code_interleaver_1.srcs/constrs_1/new/timing_contraint.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top interleaver_1024 -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef interleaver_1024.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file interleaver_1024_utilization_synth.rpt -pb interleaver_1024_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
