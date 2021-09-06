`ifndef M_BLDCM_PHASE_CONTROLLER_V
`define M_BLDCM_PHASE_CONTROLLER_V

`default_nettype none

module mBldcm_PhaseController #(
	parameter [3:0]  pTotalPhaseStages = 4'd12
) (
	input  wire        iClock,
	input  wire        iReset_n,

	input  wire [31:0] iDiv,
	input  wire        iStop,

	input  wire [3:0]  iPhaseUpdate,
	input  wire        iLatchPhaseUpdate,

	output reg  [3:0]  oPhase
);

	// Wires
	wire        wResetDivCnt;
	wire        wIncPhase;
	wire [3:0]  wPhaseUpdateUse;
	wire        wClearPhase;

	// Registers
	reg [31:0] rDivCnt;

	// Counter for divider
	assign wResetDivCnt = (rDivCnt == 32'd0) ? 1'b1 : 1'b0;

	always @(posedge iClock) begin : DivCountDown
		if (iReset_n == 1'b0) begin
			rDivCnt <= 32'd0;
		end else if (wResetDivCnt == 1'b1) begin
			rDivCnt <= iDiv - 32'd1;
		end else begin
			rDivCnt <= rDivCnt - 32'd1;
		end
	end

	// Phase Counter
	assign wPhaseUpdateUse = (iPhaseUpdate < pTotalPhaseStages) ? iPhaseUpdate : (pTotalPhaseStages - 4'd1);

	assign wIncPhase = wResetDivCnt & (~iStop);
	assign wClearPhase = ((oPhase == (pTotalPhaseStages - 4'd1)) ? 1'b1 : 1'b0) & wIncPhase;

	always @(posedge iClock) begin : PhaseCounter
		if (iReset_n == 1'b0) begin
			oPhase <= 4'd0;
		end else if (iLatchPhaseUpdate == 1'b1) begin
			oPhase <= wPhaseUpdateUse;
		end else if (wClearPhase == 1'b1) begin
			oPhase <= 4'd0;
		end else if (wIncPhase == 1'b1) begin
			oPhase <= oPhase + 4'd1;
		end else begin
			oPhase <= oPhase;
		end
	end

endmodule

`default_nettype wire

`endif

