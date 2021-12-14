`ifndef M_BLDCM_HALFBRIDGECONTROLLER_V
`define M_BLDCM_HALFBRIDGECONTROLLER_V

`default_nettype none

module mBldcm_HalfBridgeController #(
	parameter [2:0] pPhaseDiff = 3'd0 // This parameter should be 0, 2, or 4.
) (
	input  wire [2:0] iPhase,

	input  wire iHighPwm,
	input  wire iLowPwm,

	output wire oHighSide,
	output wire oLowSide
);

	// High side output
	assign oHighSide = fHighSideMux(iPhase, iHighPwm);

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

	// Low side output
	generate
		if (pPhaseDiff == 3'd0) begin
			assign oLowSide = fLowSideMux(iPhase, iLowPwm);

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
			assign oLowSide = fLowSideMux(iPhase, iLowPwm);

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
			assign oLowSide = fLowSideMux(iPhase, iLowPwm);

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
endmodule

`default_nettype wire

`endif

