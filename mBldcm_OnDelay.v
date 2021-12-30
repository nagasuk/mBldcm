`ifndef M_BLDCM_ONDELAY_V
`define M_BLDCM_ONDELAY_V

`include "mBldcm_Arithmetic.v"

`default_nettype none

// [Main module]
module mBldcm_OnDelay #(
	parameter [31:0] pDelayClockCycle = 32'd10
) (
	input wire iClock,
	input wire iReset_n,

	input  wire iSig,
	output wire oSig
);

	generate
		if (pDelayClockCycle == 32'd0) begin
			mBldcm_OnDelay0Cycle
			uBldcm_OnDelay0Cycle (
				.iSig(iSig),
				.oSig(oSig)
			);
		end else if (pDelayClockCycle == 32'd1) begin
			mBldcm_OnDelay1Cycle
			uBldcm_OnDelay1Cycle (
				.iClock(iClock),
				.iReset_n(iReset_n),
				.iSig(iSig),
				.oSig(oSig)
			);
		end else if (pDelayClockCycle >= 32'd2) begin
			mBldcm_OnDelayGE2Cycles #(
				.pDelayClockCycle(pDelayClockCycle)
			) uBldcm_OnDelayGE2Cycles (
				.iClock(iClock),
				.iReset_n(iReset_n),
				.iSig(iSig),
				.oSig(oSig)
			);
		end
	endgenerate

endmodule

// [Sub Modules]
module mBldcm_OnDelay0Cycle (
	input  wire iSig,
	output wire oSig
);
	assign oSig = iSig;
endmodule

module mBldcm_OnDelay1Cycle (
	input wire iClock,
	input wire iReset_n,

	input  wire iSig,
	output wire oSig
);

	// Registers
	reg rPrevSig;

	// Capture previous signal
	always @(posedge iClock) begin : PrevSignal
		if (iReset_n == 1'b0) begin
			rPrevSig <= 1'b0;
		end else begin
			rPrevSig <= iSig;
		end
	end

	// Output signal on-delayed by 1 cycle
	assign oSig = iSig & rPrevSig;

endmodule


module mBldcm_OnDelayGE2Cycles #(
	parameter [31:0] pDelayClockCycle = 32'd10
)(
	input wire iClock,
	input wire iReset_n,

	input  wire iSig,
	output wire oSig
);

	localparam        pNumStates = 3;
	localparam        pWidthNumStates = `MF_BLDCM_CLOG2(pNumStates + 1);
	localparam [31:0] pCountCycle  = pDelayClockCycle - 32'd2;
	localparam        pWidthCntCyc = `MF_BLDCM_CLOG2(pCountCycle + 32'd1);

	localparam [(pWidthNumStates-1):0] pStateOff           = 0;
	localparam [(pWidthNumStates-1):0] pStateDelayCounting = 1;
	localparam [(pWidthNumStates-1):0] pStateOnDelayed     = 2;

	// Registers
	reg [(pWidthNumStates-1):0] rState;
	reg [(pWidthCntCyc-1):0]    rCnt;

	// Wires
	wire wSigCountExpired;

	// State machine
	always @(posedge iClock) begin : StateMachine
		if (iReset_n == 1'b0) begin
			rState <= pStateOff;
		end else begin
			case (rState)
				pStateOff:
					if (iSig == 1'b1) begin
						rState <= pStateDelayCounting;
					end else begin
						rState <= rState;
					end
				pStateDelayCounting:
					if (iSig == 1'b0) begin
						rState <= pStateOff;
					end else if (wSigCountExpired == 1'b1) begin
						rState <= pStateOnDelayed;
					end else begin
						rState <= rState;
					end
				pStateOnDelayed:
					if (iSig == 1'b0) begin
						rState <= pStateOff;
					end else begin
						rState <= rState;
					end
				default:
					rState <= rState;
			endcase
		end
	end

	// Delay Counting
	assign wSigCountExpired = (rCnt >= pCountCycle[(pWidthCntCyc-1):0]) ? 1'b1 : 1'b0;

	always @(posedge iClock) begin : DelayCount
		if (iReset_n == 1'b0) begin
			rCnt <= {(pWidthCntCyc){1'b0}};
		end else if (rState == pStateDelayCounting) begin
			if (wSigCountExpired == 1'b0) begin
				rCnt <= rCnt + {{(pWidthCntCyc-1){1'b0}},1'b1};
			end else begin
				rCnt <= rCnt;
			end
		end else begin
			rCnt <= {(pWidthCntCyc){1'b0}};
		end
	end

	// Signal output
	assign oSig = ((rState == pStateOnDelayed) && (iSig == 1'b1)) ? 1'b1 : 1'b0;

endmodule

`default_nettype wire

`endif

