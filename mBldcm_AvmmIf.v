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
	// [Freq_target]
	input  wire        iFreqReflected,
	input  wire        iStop,
	inout  wire [31:0] ioFreqTarget,
	output wire        oLatchFreqTarget,

	// [Phase (has outside)]
	input  wire [3:0]  iPhase,
	output wire [3:0]  oPhaseUpdate,
	output wire        oLatchPhaseUpdate
);

	// Parameters
	// [Address]
	localparam [1:0] pAddrFreqTarget = 2'h0;
	localparam [1:0] pAddrPhase      = 2'h1;
	localparam [1:0] pAddrControl    = 2'h2; // Reserved
	localparam [1:0] pAddrStatus     = 2'h3;
	// [Responce]
	localparam [1:0] pRespOkey        = 2'b00;
	localparam [1:0] pRespReserved    = 2'b01;
	localparam [1:0] pRespSlaveError  = 2'b10;
	localparam [1:0] pRespDecodeError = 2'b11;

	// Wires
	wire [31:0] wStatus;

	// Responce
	assign oResp =  fResp(iAddr);

	function [1:0] fResp (
		input [1:0] iAddr
	);
		case (iAddr)
			pAddrFreqTarget: fResp = pRespOkey;
			pAddrPhase     : fResp = pRespOkey;
			pAddrControl   : fResp = pRespReserved;
			pAddrStatus    : fResp = pRespOkey;
			default        : fResp = pRespDecodeError;
		endcase
	endfunction
	
	// Read control
	// [Main]
	assign oRdata =  (iAddr == pAddrFreqTarget) ? ioFreqTarget         :
	                ((iAddr == pAddrPhase)      ? {28'h000000, iPhase} :
			((iAddr == pAddrStatus)     ? wStatus              : 32'hFFFFFFFF));
	// [Sub: Status]
	assign wStatus = {30'h00000000, iFreqReflected, iStop};

	// Write control
	// [Freq_target]
	assign oLatchFreqTarget = iWrite & ((iAddr == pAddrFreqTarget) ? 1'b1 : 1'b0);
	assign ioFreqTarget     = (oLatchFreqTarget == 1'b1) ? iWdata : 32'hZZZZZZZZ;

	// [Phase]
	assign oLatchPhaseUpdate = iWrite & ((iAddr == pAddrPhase) ? 1'b1 : 1'b0);
	assign oPhaseUpdate      = iWdata;

endmodule

`default_nettype wire

`endif

