`ifndef M_BLDCM_CORE_V
`define M_BLDCM_CORE_V

`include "mBldcm_PhaseController.v"
`include "mBldcm_HalfBridgeController.v"
`include "mBldcm_GenPwm.v"
`include "mBldcm_OutputMux.v"

`default_nettype none

module mBldcm_Core #(
	parameter [2:0]  pTotalPhaseStages = 3'd6,
	parameter        pPwmCounterWidth = 32,
	parameter        pPwmNumPrescaler = 32,
	parameter [31:0] pDeadTimeClockCycle = 32'd10,
	parameter [0:0]  pInvertUh = 1'b0,
	parameter [0:0]  pInvertUl = 1'b0,
	parameter [0:0]  pInvertVh = 1'b0,
	parameter [0:0]  pInvertVl = 1'b0,
	parameter [0:0]  pInvertWh = 1'b0,
	parameter [0:0]  pInvertWl = 1'b0
) (
	// Common
	input  wire iClock,
	input  wire iReset_n,

	// Input signals to control
	input  wire                          iEnable,
	input  wire [31:0]                   iDiv,
	input  wire                          iStop,
	input  wire [2:0]                    iPhaseUpdate,
	input  wire                          iLatchPhaseUpdate,
	input  wire [(pPwmCounterWidth-1):0] iPwmCtrlMaxCnt,
	input  wire [pPwmCounterWidth:0]     iPwmCtrlCmpCnt,
	input  wire [5:0]                    iPwmCtrlPrscSel,

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
	wire        wPwm;
	wire        wHighPwmOnDelayed;
	wire        wLowPwmOnDelayed;
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

	// Generate PWM and insert dead time
	mBldcm_GenPwm #(
		.pCounterWidth(pPwmCounterWidth),
		.pNumPrescaler(pPwmNumPrescaler)
	) uBldcm_GenPwm (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iMaxCnt(iPwmCtrlMaxCnt),
		.iCmpCnt(iPwmCtrlCmpCnt),
		.iPrscSel(iPwmCtrlPrscSel),
		.oPwm(wPwm)
	);

	// Generate signal to excite motor
	mBldcm_HalfBridgeController #(
		.pPhaseDiff(3'd0),
		.pDeadTimeClockCycle(pDeadTimeClockCycle)
	) uBldcm_HBCtrl_U (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iPhase(wPhase),
		.iPwm(wPwm),
		.oHighSide(wUhTmp),
		.oLowSide(wUlTmp)
	);

	mBldcm_HalfBridgeController #(
		.pPhaseDiff(3'd2),
		.pDeadTimeClockCycle(pDeadTimeClockCycle)
	) uBldcm_HBCtrl_V (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iPhase(wPhase),
		.iPwm(wPwm),
		.oHighSide(wVhTmp),
		.oLowSide(wVlTmp)
	);

	mBldcm_HalfBridgeController #(
		.pPhaseDiff(3'd4),
		.pDeadTimeClockCycle(pDeadTimeClockCycle)
	) uBldcm_HBCtrl_W (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iPhase(wPhase),
		.iPwm(wPwm),
		.oHighSide(wWhTmp),
		.oLowSide(wWlTmp)
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

