`ifndef M_BLDCM_PULSER_V
`define M_BLDCM_PULSER_V

`default_nettype none

module mBldcm_Pulser #(
	parameter [2:0] pPhaseDiff = 3'd0,
	parameter [2:0] pTotalPhaseStages = 3'd6
) (
	input  wire [2:0] iPhase,
	output wire       oPulse
);
	generate
		if ((pPhaseDiff + 3'd1) < pTotalPhaseStages) begin
			assign oPulse = fPhase2Pulse(iPhase);

			function fPhase2Pulse(
				input [2:0] phase
			);
				case (phase)
					pPhaseDiff       : fPhase2Pulse = 1'b1;
					pPhaseDiff + 3'd1: fPhase2Pulse = 1'b1;
					default          : fPhase2Pulse = 1'b0;
				endcase
			endfunction

		end else begin
			assign oPulse = fPhase2Pulse(iPhase);

			function fPhase2Pulse(
				input [2:0] phase
			);
				case (phase)
					pPhaseDiff       : fPhase2Pulse = 1'b1;
					3'd0             : fPhase2Pulse = 1'b1;
					default          : fPhase2Pulse = 1'b0;
				endcase
			endfunction
		end
	endgenerate

endmodule

`default_nettype wire

`endif

