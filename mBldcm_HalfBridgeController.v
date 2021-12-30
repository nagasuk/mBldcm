`ifndef M_BLDCM_HALFBRIDGECONTROLLER_V
`define M_BLDCM_HALFBRIDGECONTROLLER_V

`include "mBldcm_OnDelay.v"

`default_nettype none

module mBldcm_HalfBridgeController #(
	parameter [2:0]  pPhaseDiff          = 3'd0, // This parameter should be 0, 2, or 4.
	parameter [31:0] pDeadTimeClockCycle = 32'd10
) (
	// Common
	input  wire iClock,
	input  wire iReset_n,

	// Phase input
	input  wire [2:0] iPhase,

	// Pwm input
	input  wire iPwm,

	output wire oHighSide,
	output wire oLowSide
);
	// Wires
	wire wHighPwm;
	wire wLowPwm;
	wire wHighSide;
	wire wLowSide;

	// High side signal
	assign wHighPwm = iPwm;
	assign wHighSide = fHighSideMux(iPhase, wHighPwm);

	function fHighSideMux(
		input [2:0] phase,
		input       pwm
	);
		case (phase)
			pPhaseDiff       : fHighSideMux = pwm;
			pPhaseDiff + 3'd1: fHighSideMux = pwm;
			default          : fHighSideMux = 1'b0;
		endcase
	endfunction

	// Low side signal
	assign wLowPwm = ~iPwm;
	generate
		if (pPhaseDiff == 3'd0) begin
			assign wLowSide = fLowSideMux(iPhase, wLowPwm);

			function fLowSideMux(
				input [2:0] phase,
				input pwm
			);
				case (phase)
					3'd0   : fLowSideMux = pwm;
					3'd1   : fLowSideMux = pwm;
					3'd3   : fLowSideMux = 1'b1;
					3'd4   : fLowSideMux = 1'b1;
					default: fLowSideMux = 1'b0;
				endcase
			endfunction

		end else if (pPhaseDiff == 3'd2) begin
			assign wLowSide = fLowSideMux(iPhase, wLowPwm);

			function fLowSideMux(
				input [2:0] phase,
				input pwm
			);
				case (phase)
					3'd2   : fLowSideMux = pwm;
					3'd3   : fLowSideMux = pwm;
					3'd5   : fLowSideMux = 1'b1;
					3'd0   : fLowSideMux = 1'b1;
					default: fLowSideMux = 1'b0;
				endcase
			endfunction

		end else if (pPhaseDiff == 3'd4) begin
			assign wLowSide = fLowSideMux(iPhase, wLowPwm);

			function fLowSideMux(
				input [2:0] phase,
				input pwm
			);
				case (phase)
					3'd4   : fLowSideMux = pwm;
					3'd5   : fLowSideMux = pwm;
					3'd1   : fLowSideMux = 1'b1;
					3'd2   : fLowSideMux = 1'b1;
					default: fLowSideMux = 1'b0;
				endcase
			endfunction

		end else begin
			// Generate nothing.
		end
	endgenerate

	// Insert dead time
	mBldcm_OnDelay #(
		.pDelayClockCycle(pDeadTimeClockCycle)
	) uBldcm_OnDelayHighSideSignal (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iSig(wHighSide),
		.oSig(oHighSide)
	);

	mBldcm_OnDelay #(
		.pDelayClockCycle(pDeadTimeClockCycle)
	) uBldcm_OnDelayLowSideSignal (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iSig(wLowSide),
		.oSig(oLowSide)
	);

endmodule

`default_nettype wire

`endif

