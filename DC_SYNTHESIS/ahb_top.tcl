# ================================================================
# ahb_top.tcl (Design Compiler)
# ================================================================

# ------------------------------------------------
# STEP 0 : Clean Previous Database
# ------------------------------------------------

remove_design -all

# ------------------------------------------------
# STEP 1 : Search Path
# ------------------------------------------------

set search_path [list \
    /home/gaurav/gaurav/amba_ahb \
    . \
]

# ------------------------------------------------
# STEP 2 : Library Setup
# ------------------------------------------------

set target_library "/mnt/c2s/cadence/Analog_tools/FOUNDRY/scl_pdk/stdlib/fs120/spc/liberty/lib_flow_ss/tsl18fs120_scl_ss.db"

set link_library "* $target_library"

# ------------------------------------------------
# STEP 3 : Read RTL
# ------------------------------------------------

analyze -format verilog {
    ahb_master.v
    ahb_slave.v
    ahb_decoder.v
    ahb_mux.v
    ahb_top.v
}

elaborate ahb_top

current_design ahb_top

link

check_design

# ------------------------------------------------
# STEP 4 : VERIFY HIERARCHY BEFORE COMPILE
# ------------------------------------------------

echo "========================================"
echo " HIERARCHY BEFORE COMPILE "
echo "========================================"

report_hierarchy

# ------------------------------------------------
# STEP 5 : Constraints
# ------------------------------------------------

create_clock \
    -name HCLK \
    -period 10 \
    [get_ports HCLK]

set_input_delay 1.0 \
    -clock HCLK \
    [remove_from_collection [all_inputs] [get_ports HCLK]]

set_output_delay 1.0 \
    -clock HCLK \
    [all_outputs]

set_load 0.1 [all_outputs]

# ------------------------------------------------
# STEP 6 : Preserve Hierarchy
# ------------------------------------------------

set_ungroup [get_designs ahb_master]  false
set_ungroup [get_designs ahb_decoder] false
set_ungroup [get_designs ahb_mux]     false
set_ungroup [get_designs ahb_slave]   false

# ------------------------------------------------
# STEP 7 : Compile
# ------------------------------------------------

compile_ultra -no_autoungroup

# ------------------------------------------------
# STEP 8 : VERIFY HIERARCHY AFTER COMPILE
# ------------------------------------------------

echo "========================================"
echo " HIERARCHY AFTER COMPILE "
echo "========================================"

report_hierarchy

# ------------------------------------------------
# STEP 9 : Reports
# ------------------------------------------------

sh mkdir -p reports
sh mkdir -p netlists

report_qor                               > reports/qor.rpt
report_area                              > reports/area.rpt
report_area -hierarchy                   > reports/area_hier.rpt
report_power                             > reports/power.rpt
report_timing                            > reports/timing.rpt
report_timing -max_paths 20              > reports/timing_top20.rpt
report_constraint -all_violators         > reports/constraints.rpt
report_reference                         > reports/reference.rpt
report_hierarchy                         > reports/hierarchy.rpt

# ------------------------------------------------
# STEP 10 : Netlist Output
# ------------------------------------------------

write -format verilog \
      -hierarchy \
      -output netlists/ahb_top_netlist.v

write_sdc netlists/ahb_top.sdc

write_file \
    -format ddc \
    -hierarchy \
    -output netlists/ahb_top.ddc

# ------------------------------------------------
# STEP 11 : Final Summary
# ------------------------------------------------

echo "========================================"
echo " SYNTHESIS COMPLETED "
echo "========================================"

report_qor
