`ifndef M_BLDCM_GENPWM_V
`define M_BLDCM_GENPWM_V

`include "mBldcm_Arithmetic.v"

`default_nettype none

module mBldcm_GenPwm #(
	parameter pCounterWidth = 32,
	parameter pNumPrescaler = 32,
	parameter pPrscSelWidth = `MF_BLDCM_CLOG2(pNumPrescaler + 1)
) (
	input wire iClock,
	input wire iReset_n,

	input wire [(pCounterWidth-1):0] iMaxCnt,
	input wire [pCounterWidth:0]     iCmpCnt,
	input wire [(pPrscSelWidth-1):0] iPrscSel,

	output wire oPwm
);

	localparam [0:0] pStatCnt_Up   = 1'b0;
	localparam [0:0] pStatCnt_Down = 1'b1;

	// Registers
	reg [(pNumPrescaler-1):0] rPrsc;    // For prescaler
	reg                       rPrePrsc; // Previous signal of wPrsc
	reg [(pCounterWidth-1):0] rCnt;     // For counter
	reg                       rStatCnt; // Indicate status of count

	// Wires
	wire wPrsc;
	wire wSigCntUd;      // Signal to count up
	wire wSigOver;       // Signal to indicate that the counter is over max.

	// Prescaler
	assign wPrsc = (iPrscSel > {(pPrscSelWidth){1'b0}}) ?
	               rPrsc[iPrscSel-{{(pPrscSelWidth-1){1'b0}},1'b1}] :
	               1'b0;

	always @(posedge iClock) begin : Prescaler
		if (iReset_n == 1'b0) begin
			rPrsc <= {(pNumPrescaler){1'b0}};
		end else begin
			rPrsc <= rPrsc + {{(pNumPrescaler-1){1'b0}},1'b1};
		end
	end

	// Generate signal to count up/down
	assign wSigCntUd = (iPrscSel > {(pPrscSelWidth){1'b0}}) ?
	                   (wPrsc & ~rPrePrsc) :
	                   1'b1;

	always @(posedge iClock) begin : PrePrescalor
		if (iReset_n == 1'b0) begin
			rPrePrsc <= 1'b0;
		end else begin
			rPrePrsc <= wPrsc;
		end
	end

	// Counter
	assign wSigOver = (rCnt > iMaxCnt) ? 1'b1 : 1'b0;

	always @(posedge iClock) begin : StateOfCount
		if (iReset_n == 1'b0) begin
			rStatCnt <= pStatCnt_Up;
		end else if (wSigOver == 1'b1) begin
			rStatCnt <= pStatCnt_Up;
		end else if (wSigCntUd == 1'b1) begin
			if (
				(rStatCnt == pStatCnt_Up) &&
				(rCnt == (iMaxCnt - {{(pCounterWidth-1){1'b0}},1'b1}))
			) begin
				rStatCnt <= pStatCnt_Down;
			end else if (
				(rStatCnt == pStatCnt_Down) &&
				(rCnt == {{(pCounterWidth-1){1'b0}},1'b1})
			) begin
				rStatCnt <= pStatCnt_Up;
			end else begin
				rStatCnt <= rStatCnt;
			end
		end else begin
			rStatCnt <= rStatCnt;
		end
	end

	always @(posedge iClock) begin : Counter
		if (iReset_n == 1'b0) begin
			rCnt <= {(pCounterWidth){1'b0}};
		end else if (wSigOver == 1'b1) begin
			rCnt <= {(pCounterWidth){1'b0}};
		end else if (wSigCntUd == 1'b1) begin
			if (rStatCnt == pStatCnt_Up) begin
				rCnt <= rCnt + {{(pCounterWidth-1){1'b0}},1'b1};
			end else begin // This means (rStatCnt == pStatCnt_Down).
				rCnt <= rCnt - {{(pCounterWidth-1){1'b0}},1'b1};
			end
		end else begin
			rCnt <= rCnt;
		end
	end

	// PWM output
	assign oPwm = (iCmpCnt > {1'b0,rCnt}) ? 1'b1 : 1'b0;

endmodule

`default_nettype wire

`endif

