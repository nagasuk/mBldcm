`ifndef M_BLDCM_CORE_V
`define M_BLDCM_CORE_V

`include "mBldcm_PhaseController.v"
`include "mBldcm_Pulser.v"
`include "mBldcm_OutputMux.v"

`default_nettype none

module mBldcm_Core #(
	parameter [2:0] pTotalPhaseStages = 3'd6,
	parameter [0:0] pInvertUh = 1'b0,
	parameter [0:0] pInvertUl = 1'b0,
	parameter [0:0] pInvertVh = 1'b0,
	parameter [0:0] pInvertVl = 1'b0,
	parameter [0:0] pInvertWh = 1'b0,
	parameter [0:0] pInvertWl = 1'b0
) (
	// Common
	input  wire iClock,
	input  wire iReset_n,

	// Input signals to control
	input  wire        iEnable,
	input  wire [31:0] iDiv,
	input  wire        iStop,
	input  wire [2:0]  iPhaseUpdate,
	input  wire        iLatchPhaseUpdate,

	// Output signals to monitor
	output wire [2:0] oPhase,

	// Signal to control motor
	output wire oUh,
	output wire oUl,
	output wire oVh,
	output wire oVl,
	output wire oWh,
	output wire oWl
);

	// Wires
	wire [2:0]  wPhase;
	wire        wUhTmp;
	wire        wUlTmp;
	wire        wVhTmp;
	wire        wVlTmp;
	wire        wWhTmp;
	wire        wWlTmp;

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
		.pPhaseDiff(3'd0),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Pulser_Uh (
		.iPhase(wPhase),
		.oPulse(wUhTmp)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(3'd2),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Pulser_Vh (
		.iPhase(wPhase),
		.oPulse(wVhTmp)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(3'd4),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Pulser_Wh (
		.iPhase(wPhase),
		.oPulse(wWhTmp)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(3'd3),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Pulser_Ul (
		.iPhase(wPhase),
		.oPulse(wUlTmp)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(3'd5),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Pulser_Vl (
		.iPhase(wPhase),
		.oPulse(wVlTmp)
	);

	mBldcm_Pulser #(
		.pPhaseDiff(3'd1),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Pulser_Wl (
		.iPhase(wPhase),
		.oPulse(wWlTmp)
	);

	// Output
	mBldcm_OutputMux #(
		.pInvertUh(pInvertUh),
		.pInvertUl(pInvertUl),
		.pInvertVh(pInvertVh),
		.pInvertVl(pInvertVl),
		.pInvertWh(pInvertWh),
		.pInvertWl(pInvertWl)
	) uMbldcm_OutputMux (
		.iEnable(iEnable),
		.iUh(wUhTmp),
		.iUl(wUlTmp),
		.iVh(wVhTmp),
		.iVl(wVlTmp),
		.iWh(wWhTmp),
		.iWl(wWlTmp),
		.oUh(oUh),
		.oUl(oUl),
		.oVh(oVh),
		.oVl(oVl),
		.oWh(oWh),
		.oWl(oWl)
	);

endmodule


`default_nettype wire

`endif

