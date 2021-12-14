`timescale 1ns / 100ps

`default_nettype none

module mBldcm_sim();

	// Common Signals
	reg rClock;
	reg rReset_n;

	// Avalon-MM I/F
	reg  [1:0]  rAddr; // Word seelect
	reg         rRead;
	wire [31:0] wRdata;
	reg         rWrite;
	reg  [31:0] rWdata;
	wire [1:0]  wResp;

	// Signal for BLDCM
	wire wUh;
	wire wUl;
	wire wVh;
	wire wVl;
	wire wWh;
	wire wWl;

	// test target
	mBldcm #(
		.pFreqClock(32'd50000000),
		.pPwmDeadTimeClockCycle(5),
		.pInvertUh(0),
		.pInvertUl(1),
		.pInvertVh(0),
		.pInvertVl(1),
		.pInvertWh(0),
		.pInvertWl(1)
	) uBldcm (
		.iClock(rClock),
		.iReset_n(rReset_n),

		// Avalon-MM Slave I/F
		.iAddr(rAddr), // Word seelect
		.iRead(rRead),
		.oRdata(wRdata),
		.iWrite(rWrite),
		.iWdata(rWdata),
		.oResp(wResp),

		// Signal to control motor
		.oUh(wUh),
		.oUl(wUl),
		.oVh(wVh),
		.oVl(wVl),
		.oWh(wWh),
		.oWl(wWl)
	);

	// Clock
	initial rClock <= 1'b1;
	always #10 rClock <= ~rClock;

	// Sequence
	initial begin
		rReset_n <= 1'b0;
		rAddr <= 2'b0;
		rRead <= 1'b0;
		rWrite <= 1'b0;
		rWdata <= 32'd0;
		#100
		// Reset Release
		rReset_n <= 1'b1;
		#1000
		// Read status
		rRead  <= 1'b1;
		rAddr  <= 2'h3;
		#20
		rRead  <= 1'b0;
		rAddr  <= 2'h0;
		#200
		// Read control (Check phase value)
		rRead <= 1'b1;
		rAddr <= 2'h2;
		#20
		rRead <= 1'b0;
		rAddr <= 2'h0;
		#200
		// Write phase settings w/o W_PHASE and set enable
		rWrite <= 1'b1;
		rAddr  <= 2'h2;
		rWdata <= {4'h000, 16'hFFFF, 6'h00, 1'b0, 3'h3, 1'b0, 1'b1};
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'h0;
		#200
		// Read control (Check phase value)
		rRead <= 1'b1;
		rAddr <= 2'h2;
		#20
		rRead <= 1'b0;
		rAddr <= 2'h0;
		#200
		// Write phase settings w/ W_PHASE
		rWrite <= 1'b1;
		rAddr  <= 2'h2;
		rWdata <= {4'h000, 16'hFFFF, 6'h00, 1'b1, 3'h3, 1'b0, 1'b1};
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'h0;
		#200
		// Read control (Check phase value)
		rRead <= 1'b1;
		rAddr <= 2'h2;
		#20
		rRead <= 1'b0;
		rAddr <= 2'h0;
		#200
		// Write freq
		rWrite <= 1'b1;
		rAddr  <= 2'b0;
		rWdata <= 32'd3472;
		//rWdata <= 32'd2083333;
		//rWdata <= 32'd1;
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'd0;
		#40
		// Read status
		rRead  <= 1'b1;
		rAddr  <= 2'h3;
		#20
		rRead  <= 1'b0;
		rAddr  <= 2'h0;
		#200
		// Read freq
		rRead <= 1'b1;
		rAddr <= 2'h0;
		#20
		rRead <= 1'b0;
		rAddr <= 2'h0;
		#200
		// Read status
		rRead  <= 1'b1;
		rAddr  <= 2'h3;
		#20
		rRead  <= 1'b0;
		rAddr  <= 2'h0;
		#200
		// Write PWM settings and reset enable
		rWrite <= 1'b1;
		rAddr  <= 2'h2;
		rWdata <= {4'h000, 16'h000F, 6'h03, 1'b0, 3'h0, 1'b0, 1'b0};
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'h0;
		#200
		// Write enable
		rWrite <= 1'b1;
		rAddr  <= 2'h2;
		rWdata <= {4'h000, 16'h000F, 6'h03, 1'b0, 3'h0, 1'b0, 1'b1};
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'h0;
		#200
		// Read enable
		rRead <= 1'b1;
		rAddr <= 2'h2;
		#20
		rRead <= 1'b0;
		rAddr <= 2'h0;
		#200
		// Write PWM compare
		rWrite <= 1'b1;
		rAddr  <= 2'h1;
		rWdata <= 32'h0000000C;
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'h0;
		#10000
		// Update PWM compare
		rWrite <= 1'b1;
		rAddr  <= 2'h1;
		rWdata <= 32'h00000003;
		#20
		rWrite <= 1'b0;
		rAddr  <= 2'h0;
		rWdata <= 32'h0;
	end

endmodule

`default_nettype wire

