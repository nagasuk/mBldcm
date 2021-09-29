`ifndef M_BLDCM_AVMM_IF_V
`define M_BLDCM_AVMM_IF_V

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

	// [Phase (in/out)]
	input  wire [2:0]  iPhase,
	output wire [2:0]  oPhaseUpdate,
	output wire        oLatchPhaseUpdate,

	// [Control (out)]
	output wire        oEnable,

	// [Status (in)]
	input  wire        iFreqReflected,
	input  wire        iStop
);

	// Parameters
	// [Address]
	localparam [1:0] pAddrFreqTarget = 2'h0;
	localparam [1:0] pAddrPhase      = 2'h1;
	localparam [1:0] pAddrControl    = 2'h2;
	localparam [1:0] pAddrStatus     = 2'h3;
	// [Responce]
	localparam [1:0] pRespOkey        = 2'b00;
	localparam [1:0] pRespReserved    = 2'b01;
	localparam [1:0] pRespSlaveError  = 2'b10;
	localparam [1:0] pRespDecodeError = 2'b11;

	// [For rControl]
	localparam [31:0] pControlRegResetVal = 31'h00000000;
	localparam [31:0] pControlRegMask     = 31'h00000001;

	// Wires
	wire [31:0] wStatus;
	wire wLatchControlReg;

	// Registers
	reg  [31:0] rControl;

	// Responce
	assign oResp =  fResp(iAddr);

	function [1:0] fResp (
		input [1:0] iAddr
	);
		case (iAddr)
			pAddrFreqTarget: fResp = pRespOkey;
			pAddrPhase     : fResp = pRespOkey;
			pAddrControl   : fResp = pRespOkey;
			pAddrStatus    : fResp = pRespOkey;
			default        : fResp = pRespDecodeError;
		endcase
	endfunction
	
	// Read control
	// [Main]
	assign oRdata =  (iAddr == pAddrFreqTarget) ? ioFreqTarget         :
	                ((iAddr == pAddrPhase)      ? {29'h000000, iPhase} :
	                ((iAddr == pAddrControl)    ? rControl             :
			((iAddr == pAddrStatus)     ? wStatus              : 32'hFFFFFFFF)));
	// [Sub: Status]
	assign wStatus = {30'h00000000, iFreqReflected, iStop};

	// Write control
	// [Freq_target]
	assign oLatchFreqTarget = iWrite & ((iAddr == pAddrFreqTarget) ? 1'b1 : 1'b0);
	assign ioFreqTarget     = (oLatchFreqTarget == 1'b1) ? iWdata : 32'hZZZZZZZZ;

	// [Phase]
	assign oLatchPhaseUpdate = iWrite & ((iAddr == pAddrPhase) ? 1'b1 : 1'b0);
	assign oPhaseUpdate      = iWdata;

	// [Control]
	assign wLatchControlReg = iWrite & ((iAddr == pAddrControl) ? 1'b1 : 1'b0);
	always @(posedge iClock) begin : ControlRegister
		if (iReset_n == 1'b0) begin
			rControl <= pControlRegResetVal;
		end else if (wLatchControlReg == 1'b1) begin
			rControl <= pControlRegMask & iWdata;
		end else begin
			rControl <= rControl;
		end
	end

	assign oEnable = rControl[0]; // Distribute control signals

endmodule

`default_nettype wire

`endif

