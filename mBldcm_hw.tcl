# TCL File Generated by Component Editor 20.1
# Sat Dec 25 18:32:37 JST 2021
# DO NOT MODIFY


# 
# mBldcm "mBldcm" v2.1
# Kohei Nagasu <kohei@lcarsnet.pgw.jp> 2021.12.25.18:32:37
# Brushless DC Motor Controller
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module mBldcm
# 
set_module_property DESCRIPTION "Brushless DC Motor Controller"
set_module_property NAME mBldcm
set_module_property VERSION 2.10
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Actuator/Motor
set_module_property AUTHOR "Kohei Nagasu <kohei@lcarsnet.pgw.jp>"
set_module_property DISPLAY_NAME mBldcm
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL mBldcm
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file mBldcm.v VERILOG PATH mBldcm.v TOP_LEVEL_FILE
add_fileset_file mBldcm_AvmmIf.v VERILOG PATH mBldcm_AvmmIf.v
add_fileset_file mBldcm_Freq2Div.v VERILOG PATH mBldcm_Freq2Div.v
add_fileset_file mBldcm_Core.v VERILOG PATH mBldcm_Core.v
add_fileset_file mBldcm_PhaseController.v VERILOG PATH mBldcm_PhaseController.v
add_fileset_file mBldcm_OutputMux.v VERILOG PATH mBldcm_OutputMux.v
add_fileset_file mBldcm_Arithmetic.v VERILOG PATH mBldcm_Arithmetic.v
add_fileset_file mBldcm_GenPwm.v VERILOG PATH mBldcm_GenPwm.v
add_fileset_file mBldcm_HalfBridgeController.v VERILOG PATH mBldcm_HalfBridgeController.v
add_fileset_file mBldcm_OnDelay.v VERILOG PATH mBldcm_OnDelay.v
add_fileset_file mBldcm_Version.v VERILOG PATH mBldcm_Version.v

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL mBldcm
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file mBldcm.v VERILOG PATH mBldcm.v
add_fileset_file mBldcm_AvmmIf.v VERILOG PATH mBldcm_AvmmIf.v
add_fileset_file mBldcm_Freq2Div.v VERILOG PATH mBldcm_Freq2Div.v
add_fileset_file mBldcm_Core.v VERILOG PATH mBldcm_Core.v
add_fileset_file mBldcm_PhaseController.v VERILOG PATH mBldcm_PhaseController.v
add_fileset_file mBldcm_OutputMux.v VERILOG PATH mBldcm_OutputMux.v
add_fileset_file mBldcm_Arithmetic.v VERILOG PATH mBldcm_Arithmetic.v
add_fileset_file mBldcm_GenPwm.v VERILOG PATH mBldcm_GenPwm.v
add_fileset_file mBldcm_HalfBridgeController.v VERILOG PATH mBldcm_HalfBridgeController.v
add_fileset_file mBldcm_OnDelay.v VERILOG PATH mBldcm_OnDelay.v
add_fileset_file mBldcm_Version.v VERILOG PATH mBldcm_Version.v


# 
# parameters
# 
add_parameter pFreqClock INTEGER 50000000 ""
set_parameter_property pFreqClock DEFAULT_VALUE 50000000
set_parameter_property pFreqClock DISPLAY_NAME pFreqClock
set_parameter_property pFreqClock WIDTH ""
set_parameter_property pFreqClock TYPE INTEGER
set_parameter_property pFreqClock UNITS None
set_parameter_property pFreqClock ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pFreqClock DESCRIPTION ""
set_parameter_property pFreqClock HDL_PARAMETER true
add_parameter pDeadTimeClockCycle INTEGER 10
set_parameter_property pDeadTimeClockCycle DEFAULT_VALUE 10
set_parameter_property pDeadTimeClockCycle DISPLAY_NAME pDeadTimeClockCycle
set_parameter_property pDeadTimeClockCycle TYPE INTEGER
set_parameter_property pDeadTimeClockCycle UNITS None
set_parameter_property pDeadTimeClockCycle ALLOWED_RANGES -2147483648:2147483647
set_parameter_property pDeadTimeClockCycle HDL_PARAMETER true
add_parameter pInvertUh BOOLEAN false ""
set_parameter_property pInvertUh DEFAULT_VALUE false
set_parameter_property pInvertUh DISPLAY_NAME pInvertUh
set_parameter_property pInvertUh WIDTH ""
set_parameter_property pInvertUh TYPE BOOLEAN
set_parameter_property pInvertUh UNITS None
set_parameter_property pInvertUh DESCRIPTION ""
set_parameter_property pInvertUh HDL_PARAMETER true
add_parameter pInvertUl BOOLEAN false ""
set_parameter_property pInvertUl DEFAULT_VALUE false
set_parameter_property pInvertUl DISPLAY_NAME pInvertUl
set_parameter_property pInvertUl WIDTH ""
set_parameter_property pInvertUl TYPE BOOLEAN
set_parameter_property pInvertUl UNITS None
set_parameter_property pInvertUl DESCRIPTION ""
set_parameter_property pInvertUl HDL_PARAMETER true
add_parameter pInvertVh BOOLEAN false ""
set_parameter_property pInvertVh DEFAULT_VALUE false
set_parameter_property pInvertVh DISPLAY_NAME pInvertVh
set_parameter_property pInvertVh WIDTH ""
set_parameter_property pInvertVh TYPE BOOLEAN
set_parameter_property pInvertVh UNITS None
set_parameter_property pInvertVh DESCRIPTION ""
set_parameter_property pInvertVh HDL_PARAMETER true
add_parameter pInvertVl BOOLEAN false ""
set_parameter_property pInvertVl DEFAULT_VALUE false
set_parameter_property pInvertVl DISPLAY_NAME pInvertVl
set_parameter_property pInvertVl WIDTH ""
set_parameter_property pInvertVl TYPE BOOLEAN
set_parameter_property pInvertVl UNITS None
set_parameter_property pInvertVl DESCRIPTION ""
set_parameter_property pInvertVl HDL_PARAMETER true
add_parameter pInvertWh BOOLEAN false ""
set_parameter_property pInvertWh DEFAULT_VALUE false
set_parameter_property pInvertWh DISPLAY_NAME pInvertWh
set_parameter_property pInvertWh WIDTH ""
set_parameter_property pInvertWh TYPE BOOLEAN
set_parameter_property pInvertWh UNITS None
set_parameter_property pInvertWh DESCRIPTION ""
set_parameter_property pInvertWh HDL_PARAMETER true
add_parameter pInvertWl BOOLEAN false ""
set_parameter_property pInvertWl DEFAULT_VALUE false
set_parameter_property pInvertWl DISPLAY_NAME pInvertWl
set_parameter_property pInvertWl WIDTH ""
set_parameter_property pInvertWl TYPE BOOLEAN
set_parameter_property pInvertWl UNITS None
set_parameter_property pInvertWl DESCRIPTION ""
set_parameter_property pInvertWl HDL_PARAMETER true


# 
# display items
# 
add_display_item "" Common GROUP ""
add_display_item Common pFreqClock PARAMETER ""
add_display_item Common pDeadTimeClockCycle PARAMETER ""
add_display_item "" "Output Signal" GROUP ""
add_display_item "Output Signal" pInvertUh PARAMETER ""
add_display_item "Output Signal" pInvertUl PARAMETER ""
add_display_item "Output Signal" pInvertVh PARAMETER ""
add_display_item "Output Signal" pInvertVl PARAMETER ""
add_display_item "Output Signal" pInvertWh PARAMETER ""
add_display_item "Output Signal" pInvertWl PARAMETER ""


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 50000000
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink iClock clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink iReset_n reset_n Input 1


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock_sink
set_interface_property avalon_slave associatedReset reset_sink
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitStates 0
set_interface_property avalon_slave readWaitTime 0
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave iAddr address Input 2
add_interface_port avalon_slave iRead read Input 1
add_interface_port avalon_slave oRdata readdata Output 32
add_interface_port avalon_slave iWrite write Input 1
add_interface_port avalon_slave iWdata writedata Input 32
add_interface_port avalon_slave oResp response Output 2
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point phase_drive
# 
add_interface phase_drive conduit end
set_interface_property phase_drive associatedClock ""
set_interface_property phase_drive associatedReset ""
set_interface_property phase_drive ENABLED true
set_interface_property phase_drive EXPORT_OF ""
set_interface_property phase_drive PORT_NAME_MAP ""
set_interface_property phase_drive CMSIS_SVD_VARIABLES ""
set_interface_property phase_drive SVD_ADDRESS_GROUP ""

add_interface_port phase_drive oUh u_phase_highside Output 1
add_interface_port phase_drive oUl u_phase_lowside Output 1
add_interface_port phase_drive oVh v_phase_highside Output 1
add_interface_port phase_drive oVl v_phase_lowside Output 1
add_interface_port phase_drive oWh w_phase_highside Output 1
add_interface_port phase_drive oWl w_phase_lowside Output 1

