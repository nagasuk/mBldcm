`ifndef M_BLDCM_VERSION_V
`define M_BLDCM_VERSION_V

`default_nettype none

`define M_BLDCM_VERSION_2_10 // Version "2.10"

/******** REL_CNT vs Release Version Table ********/

`ifdef M_BLDCM_VERSION_2_10 // Version 2.10
	`define M_BLDCM_REL_CNT 8'h01
`else
	`define M_BLDCM_REL_CNT 8'h00
`endif

`default_nettype wire

`endif

