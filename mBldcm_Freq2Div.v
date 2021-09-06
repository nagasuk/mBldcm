`ifndef M_BLDCM_FREQ2DIV_V
`define M_BLDCM_FREQ2DIV_V

`include "mBldcm_Arithmetic.v"

`default_nettype none

module mBldcm_Freq2Div #(
	parameter [31:0] pFreqClock        = 32'd50000000,
	parameter [3:0]  pTotalPhaseStages = 4'd12
) (
	input  wire        iClock,
	input  wire        iReset_n,

	input  wire        iLatchFreqTarget,
	inout  wire [31:0] ioFreqTarget,
	output wire        oFreqReflected,

	output wire [31:0] oDiv,
	output wire        oStop
);

	// Parameters
	localparam pDivPipelineDepth = 7;
	localparam pWidthNumDivPipelineDepth = `MF_BLDCM_CLOG2(pDivPipelineDepth + 1);
	localparam pWidthUsedByUDiv = `MF_BLDCM_CLOG2(pFreqClock / pTotalPhaseStages + 1);

	// Wires
	wire [31:0] wDivTmp;
	wire        wFreqNotSnk;

	// Registers
	reg [31:0] rFreqTarget;
	reg [(pDivPipelineDepth-1):0] rStopShiftReg;
	reg [(pWidthNumDivPipelineDepth-1):0] rFreqSnkCnt;

	// Latch target frequency
	always @(posedge iClock) begin : LatchFreqTarget
		if (iReset_n == 1'b0) begin
			rFreqTarget <= 32'd0;
		end else if (iLatchFreqTarget == 1'b1) begin
			rFreqTarget <= ioFreqTarget;
		end else begin
			rFreqTarget <= rFreqTarget;
		end
	end

	// Request read FreqTarget
	assign ioFreqTarget = (iLatchFreqTarget == 1'b0) ? rFreqTarget : 32'hZZZZZZZZ;

	// Signal to indicate that the frequency is reflected.
	assign wFreqNotSnk = (rFreqSnkCnt < pDivPipelineDepth) ? 1'b1 : 1'b0; 
	assign oFreqReflected = ~wFreqNotSnk;

	always @(posedge iClock) begin : FreqSnkCnt
		if (iReset_n == 1'b0) begin
			rFreqSnkCnt <= pDivPipelineDepth;
		end else if (iLatchFreqTarget == 1'b1) begin
			rFreqSnkCnt <= {(pWidthNumDivPipelineDepth){1'b0}};
		end else if (wFreqNotSnk == 1'b1) begin
			rFreqSnkCnt <= rFreqSnkCnt + {{(pWidthNumDivPipelineDepth-1){1'b0}}, 1'b1};
		end else begin
			rFreqSnkCnt <= rFreqSnkCnt;
		end
	end

	// Stop Signal (Sync with FreqTarget)
	assign oStop = rStopShiftReg[pDivPipelineDepth-1];

	always @(posedge iClock) begin : StopSigSyncFirst
		if (iReset_n == 1'b0) begin
			rStopShiftReg[0] <= 1'b1;
		end else begin
			rStopShiftReg[0] <= (rFreqTarget == 32'd0) ? 1'b1 : 1'b0;
		end
	end

	generate
		genvar i;
		for (i = 1; i < pDivPipelineDepth; i = i+1) begin : StopSigSyncFollowings
			always @(posedge iClock) begin
				if (iReset_n == 1'b0) begin
					rStopShiftReg[i] <= 1'b1;
				end else begin
					rStopShiftReg[i] <= rStopShiftReg[i-1];
				end
			end
		end
	endgenerate

	// Calc Div
	assign oDiv = (oStop == 1'b0) ? wDivTmp : 32'd1;
	assign wDivTmp[31:pWidthUsedByUDiv] = {(32-pWidthUsedByUDiv){1'b0}};

	mBldcm_UDiv #(
		.pWidthDenom(pWidthUsedByUDiv),
		.pWidthNumer(pWidthUsedByUDiv),
		.pPipelineDepth(pDivPipelineDepth)
	) uBldcm_Udiv (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iEnable(1'b1),
		.iDenom(rFreqTarget[pWidthUsedByUDiv-1:0]),
		.iNumer(pFreqClock / pTotalPhaseStages),
		.oQuotient(wDivTmp[pWidthUsedByUDiv-1:0]),
		.oRemain()
	);

	/*
	alt_udiv_32_32 alt_udiv_32_32_inst(
		.aclr(~iReset_n),
		.clken(1'b1),
		.clock(iClock),
		.denom(rFreqTarget),
		.numer(pFreqClock / pTotalPhaseStages),
		.quotient(wDivTmp),
		.remain()
	);
	*/

endmodule

`default_nettype wire

`endif

