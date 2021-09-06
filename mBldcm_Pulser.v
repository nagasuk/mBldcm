`ifndef M_BLDCM_PULSER_V
`define M_BLDCM_PULSER_V

`default_nettype none

module mBldcm_Pulser #(
	parameter [3:0] pPhaseDiff = 4'd0
) (
	input  wire [3:0] iPhase,
	output wire       oPulse
);
	// Parameters
	localparam [3:0] pTotalPhaseStages = 4'd12;

	// Wires
	wire [3:0] wLocalPhase;

	// Body
	assign wLocalPhase = (iPhase < pPhaseDiff) ?
	                     (pTotalPhaseStages - pPhaseDiff + iPhase) :
	                     (iPhase - pPhaseDiff);
	assign oPulse = fPhase2Pulse(wLocalPhase);

	// Functions
	function fPhase2Pulse (
		input [3:0] phase
	);
		case (phase)
			4'd0   : fPhase2Pulse = 1'b1;
			4'd1   : fPhase2Pulse = 1'b1;
			4'd6   : fPhase2Pulse = 1'b1;
			4'd7   : fPhase2Pulse = 1'b1;
			default: fPhase2Pulse = 1'b0;
		endcase
	endfunction

endmodule

`default_nettype wire

`endif

