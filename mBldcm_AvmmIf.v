`ifndef M_BLDCM_AVMM_IF_V
`define M_BLDCM_AVMM_IF_V

`include "mBldcm_Version.v"

`default_nettype none

module mBldcm_AvmmIf (
	// Common
	input wire iClock,
	input wire iReset_n,

	// Avalon-MM Slave I/F
	input  wire [1:0]  iAddr, // Word select
	input  wire        iRead,
	output wire [31:0] oRdata,
	input  wire        iWrite,
	input  wire [31:0] iWdata,
	output wire [1:0]  oResp,

	// Data input/output
	// [Freq_target (in/out)]
	inout  wire [31:0] ioFreqTarget,
	output wire        oLatchFreqTarget,

	// [PWM Compare (out)]
	output reg  [16:0] oPwmCmp,

	// [Control (in/out)]
	// [Sub: Phase (in/out)]
	input  wire [2:0]  iPhase,
	output wire [2:0]  oPhaseUpdate,
	output wire        oLatchPhaseUpdate,
	// [Sub: Enable (out)]
	output reg         oEnable,
	// [Sub: PWM (out)]
	output reg  [5:0]  oPwmPrsc,
	output reg  [15:0] oPwmMaxCnt,

	// [Status (in)]
	input  wire        iFreqReflected,
	input  wire        iStop
);

	// Parameters
	// [Address]
	localparam [1:0] pAddrFreqTarget = 2'h0;
	localparam [1:0] pAddrPwmCmp     = 2'h1;
	localparam [1:0] pAddrControl    = 2'h2;
	localparam [1:0] pAddrStatus     = 2'h3;
	// [Responce]
	localparam [1:0] pRespOkey        = 2'b00;
	localparam [1:0] pRespReserved    = 2'b01;
	localparam [1:0] pRespSlaveError  = 2'b10;
	localparam [1:0] pRespDecodeError = 2'b11;

	// [For PwmCmp Register]
	localparam [16:0] pPwmCmpRegResetVal = 17'h00000;
	localparam        pPwmCmpRegBitPos   = 0;
	localparam        pPwmCmpRegMsb      = 16;

	// [For Control Register]
	localparam [0:0]  pEnableRegResetVal    = 1'b0;
	localparam        pEnableBitPos         = 0;
	localparam        pPhaseRegBitPos       = 2;
	localparam        pPhaseRegMsb          = 4;
	localparam        pWPhaseFlgBitPos      = 5;
	localparam [5:0]  pPwmPrscRegResetVal   = 6'h00;
	localparam        pPwmPrscRegBitPos     = 6;
	localparam        pPwmPrscRegMsb        = 11;
	localparam [15:0] pPwmMaxCntRegResetVal = 16'hFFFF;
	localparam        pPwmMaxCntRegBitPos   = 12;
	localparam        pPwmMaxCntRegMsb      = 27;

	// Wires
	wire        wLatchPwmCmpReg;
	wire [31:0] wStatus;
	wire        wLatchControlReg;
	wire [31:0] wControl;

	// Registers

	// Responce
	assign oResp =  fResp(iAddr);

	function [1:0] fResp (
		input [1:0] iAddr
	);
		case (iAddr)
			pAddrFreqTarget: fResp = pRespOkey;
			pAddrPwmCmp    : fResp = pRespOkey;
			pAddrControl   : fResp = pRespOkey;
			pAddrStatus    : fResp = pRespOkey;
			default        : fResp = pRespDecodeError;
		endcase
	endfunction
	
	// Read control
	// [Main]
	assign oRdata =  (iAddr == pAddrFreqTarget) ? ioFreqTarget        :
	                ((iAddr == pAddrPwmCmp)     ? {15'h0000, oPwmCmp} :
	                ((iAddr == pAddrControl)    ? wControl            :
			((iAddr == pAddrStatus)     ? wStatus             : 32'hFFFFFFFF)));
	// [Sub: Control]
	assign wControl = {4'h00, oPwmMaxCnt, oPwmPrsc, 1'b0, iPhase, 1'b0, oEnable};
	// [Sub: Status]
	assign wStatus = {`M_BLDCM_REL_CNT, 22'h000000, iFreqReflected, iStop};

	// Write control
	// [Freq_target]
	assign oLatchFreqTarget = iWrite & ((iAddr == pAddrFreqTarget) ? 1'b1 : 1'b0);
	assign ioFreqTarget     = (oLatchFreqTarget == 1'b1) ? iWdata : 32'hZZZZZZZZ;

	// [PWM Compare]
	assign wLatchPwmCmpReg = iWrite & ((iAddr == pAddrPwmCmp) ? 1'b1 : 1'b0);

	always @(posedge iClock) begin : PwmCmpRegister
		if (iReset_n == 1'b0) begin
			oPwmCmp <= pPwmCmpRegResetVal;
		end else if (wLatchPwmCmpReg == 1'b1) begin
			oPwmCmp <= iWdata[pPwmCmpRegMsb:pPwmCmpRegBitPos];
		end else begin
			oPwmCmp <= oPwmCmp;
		end
	end

	// [Control]
	// [Sub: Phase]
	assign oLatchPhaseUpdate = wLatchControlReg & iWdata[pWPhaseFlgBitPos];
	assign oPhaseUpdate      = iWdata[pPhaseRegMsb:pPhaseRegBitPos];

	// [Sub: Others]
	assign wLatchControlReg = iWrite & ((iAddr == pAddrControl) ? 1'b1 : 1'b0);

	always @(posedge iClock) begin : ControlRegister
		if (iReset_n == 1'b0) begin
			oEnable    <= pEnableRegResetVal;
			oPwmPrsc   <= pPwmPrscRegResetVal;
			oPwmMaxCnt <= pPwmMaxCntRegResetVal;
		end else if (wLatchControlReg == 1'b1) begin
			oEnable    <= iWdata[pEnableBitPos];
			oPwmPrsc   <= iWdata[pPwmPrscRegMsb:pPwmPrscRegBitPos];
			oPwmMaxCnt <= iWdata[pPwmMaxCntRegMsb:pPwmMaxCntRegBitPos];
		end else begin
			oEnable    <= oEnable;
			oPwmPrsc   <= oPwmPrsc;
			oPwmMaxCnt <= oPwmMaxCnt;
		end
	end

endmodule

`default_nettype wire

`endif

