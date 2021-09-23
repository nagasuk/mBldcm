`ifndef M_BLDCM_V
`define M_BLDCM_V

`include "mBldcm_Freq2Div.v"
`include "mBldcm_AvmmIf.v"
`include "mBldcm_Core.v"

`default_nettype none

module mBldcm #(
	parameter [31:0] pFreqClock = 32'd50000000,
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

	// Avalon-MM Slave I/F
	input  wire [1:0]  iAddr, // Word select
	input  wire        iRead,
	output wire [31:0] oRdata,
	input  wire        iWrite,
	input  wire [31:0] iWdata,
	output wire [1:0]  oResp,

	// Signal to control motor
	output wire oUh,
	output wire oUl,
	output wire oVh,
	output wire oVl,
	output wire oWh,
	output wire oWl
);

	//Parameters
	localparam [3:0] pTotalPhaseStages = 4'd12;

	// Wire
	wire        wFreqReflected;
	wire [31:0] wFreqTarget;
	wire        wLatchFreqTarget;
	wire        wEnable;
	wire [31:0] wDiv;
	wire        wStop;
	wire [3:0]  wPhase;
	wire [3:0]  wPhaseUpdate;
	wire        wLatchPhaseUpdate;

	// Avalon-MM I/F
	mBldcm_AvmmIf uBldcm_AvmmIf (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iAddr(iAddr),
		.iRead(iRead),
		.oRdata(oRdata),
		.iWrite(iWrite),
		.iWdata(iWdata),
		.oResp(oResp),
		.oEnable(wEnable),
		.iFreqReflected(wFreqReflected),
		.iStop(wStop),
		.ioFreqTarget(wFreqTarget),
		.oLatchFreqTarget(wLatchFreqTarget),
		.iPhase(wPhase),
		.oPhaseUpdate(wPhaseUpdate),
		.oLatchPhaseUpdate(wLatchPhaseUpdate)
	);

	// Frequency to Divider num Convertor
	mBldcm_Freq2Div #(
		.pFreqClock(pFreqClock),
		.pTotalPhaseStages(pTotalPhaseStages)
	) uBldcm_Freq2Div (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iLatchFreqTarget(wLatchFreqTarget),
		.ioFreqTarget(wFreqTarget),
		.oFreqReflected(wFreqReflected),
		.oDiv(wDiv),
		.oStop(wStop)
	);

	// Generate Drive Signal
	mBldcm_Core #(
		.pTotalPhaseStages(pTotalPhaseStages),
		.pInvertUh(pInvertUh),
		.pInvertUl(pInvertUl),
		.pInvertVh(pInvertVh),
		.pInvertVl(pInvertVl),
		.pInvertWh(pInvertWh),
		.pInvertWl(pInvertWl)
	) uBldcm_Core (
		.iClock(iClock),
		.iReset_n(iReset_n),
		.iEnable(wEnable),
		.iDiv(wDiv),
		.iStop(wStop),
		.iPhaseUpdate(wPhaseUpdate),
		.iLatchPhaseUpdate(wLatchPhaseUpdate),
		.oPhase(wPhase),
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

