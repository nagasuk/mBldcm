`ifndef M_BLDCM_CORE_V
`define M_BLDCM_CORE_V

`include "mBldcm_PhaseController.v"
`include "mBldcm_Pulser.v"

`default_nettype none

module mBldcm_Core #(
	parameter [3:0]  pTotalPhaseStages = 4'd12
) (
	// Common
	input  wire iClock,
	input  wire iReset_n,

	// Input signals to control
	input  wire [31:0] iDiv,
	input  wire        iStop,
	input  wire [3:0]  iPhaseUpdate,
	input  wire        iLatchPhaseUpdate,

	// Output signals to monitor
	output wire [3:0] oPhase,

	// Signal to control motor
	output wire oUh,
	output wire oUl,
	output wire oVh,
	output wire oVl,
	output wire oWh,
	output wire oWl
);

	// Wires
	wire [3:0]  wPhase;

	// Phase Controller
	assign oPhase = wPhase;

	mBldcm_PhaseController #(
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_PhaseController (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iDiv(iDiv),
		.iStop(iStop),
		.iPhaseUpdate(iPhaseUpdate),
		.iLatchPhaseUpdate(iLatchPhaseUpdate),
		.oPhase(wPhase)
	);

	// Generate Pulse
	mBldcm_Pulser #(
		.pPhaseDiff(4'd0)
	) uBldcm_Pulser_Uh (
		.iPhase(wPhase),
		.oPulse(oUh)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(4'd2)
	) uBldcm_Pulser_Vh (
		.iPhase(wPhase),
		.oPulse(oVh)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(4'd4)
	) uBldcm_Pulser_Wh (
		.iPhase(wPhase),
		.oPulse(oWh)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(4'd3)
	) uBldcm_Pulser_Ul (
		.iPhase(wPhase),
		.oPulse(oUl)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(4'd5)
	) uBldcm_Pulser_Vl (
		.iPhase(wPhase),
		.oPulse(oVl)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(4'd1)
	) uBldcm_Pulser_Wl (
		.iPhase(wPhase),
		.oPulse(oWl)
	);

endmodule


`default_nettype wire

`endif

