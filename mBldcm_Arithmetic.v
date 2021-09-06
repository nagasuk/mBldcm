`ifndef M_BLDCM_ARITHMETIC_V
`define M_BLDCM_ARITHMETIC_V

`default_nettype none

// Macro function utilities
`define MF_BLDCM_CLOG2(x) \
(x <= 32'h000000002) ?  1 : \
(x <= 32'h000000004) ?  2 : \
(x <= 32'h000000008) ?  3 : \
(x <= 32'h000000010) ?  4 : \
(x <= 32'h000000020) ?  5 : \
(x <= 32'h000000040) ?  6 : \
(x <= 32'h000000080) ?  7 : \
(x <= 32'h000000100) ?  8 : \
(x <= 32'h000000200) ?  9 : \
(x <= 32'h000000400) ? 10 : \
(x <= 32'h000000800) ? 11 : \
(x <= 32'h000001000) ? 12 : \
(x <= 32'h000002000) ? 13 : \
(x <= 32'h000004000) ? 14 : \
(x <= 32'h000008000) ? 15 : \
(x <= 32'h000010000) ? 16 : \
(x <= 32'h000020000) ? 17 : \
(x <= 32'h000040000) ? 18 : \
(x <= 32'h000080000) ? 19 : \
(x <= 32'h000100000) ? 20 : \
(x <= 32'h000200000) ? 21 : \
(x <= 32'h000400000) ? 22 : \
(x <= 32'h000800000) ? 23 : \
(x <= 32'h001000000) ? 24 : \
(x <= 32'h002000000) ? 25 : \
(x <= 32'h004000000) ? 26 : \
(x <= 32'h008000000) ? 27 : \
(x <= 32'h010000000) ? 28 : \
(x <= 32'h020000000) ? 29 : \
(x <= 32'h040000000) ? 30 : \
(x <= 32'h080000000) ? 31 : \
(x <= 32'h100000000) ? 32 : \
0


module mBldcm_UDiv #(
	parameter pWidthDenom = 32,
	parameter pWidthNumer = 32,
	parameter pPipelineDepth = 7
) (
	input  wire                   iClock,
	input  wire                   iReset_n,
	input  wire                   iEnable,

	input  wire [pWidthDenom-1:0] iDenom,
	input  wire [pWidthNumer-1:0] iNumer,

	output wire [pWidthNumer-1:0] oQuotient,
	output wire [pWidthNumer-1:0] oRemain
);

	lpm_divide #(
		.lpm_drepresentation("UNSIGNED"),
		.lpm_hint("MAXIMIZE_SPEED=6,LPM_REMAINDERPOSITIVE=TRUE"),
		.lpm_nrepresentation("UNSIGNED"),
		.lpm_pipeline(pPipelineDepth),
		.lpm_type("LPM_DIVIDE"),
		.lpm_widthd(pWidthDenom),
		.lpm_widthn(pWidthNumer)
	) lpm_divide_inst (
		.aclr (~iReset_n),
		.clken (iEnable),
		.clock (iClock),
		.denom (iDenom),
		.numer (iNumer),
		.quotient (oQuotient),
		.remain (oRemain)
	);

endmodule

`default_nettype wire

`endif

