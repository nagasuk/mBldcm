`ifndef M_BLDCM_OUTPUTMUX_V
`define M_BLDCM_OUTPUTMUX_V

`default_nettype none

module mBldcm_OutputMux #(
	parameter [0:0] pInvertUh = 1'b0,
	parameter [0:0] pInvertUl = 1'b0,
	parameter [0:0] pInvertVh = 1'b0,
	parameter [0:0] pInvertVl = 1'b0,
	parameter [0:0] pInvertWh = 1'b0,
	parameter [0:0] pInvertWl = 1'b0
) (
	// Control signals
	input  wire iEnable,

	// Drive input  signals
	input  wire iUh,
	input  wire iUl,
	input  wire iVh,
	input  wire iVl,
	input  wire iWh,
	input  wire iWl,

	// Selected Drive output signals
	output wire oUh,
	output wire oUl,
	output wire oVh,
	output wire oVl,
	output wire oWh,
	output wire oWl
);

	// Parameters
	localparam pNumDriveSig = 6;
	localparam [(pNumDriveSig-1):0] pIsInvertArry = {pInvertUh, pInvertUl,
	                                                 pInvertVh, pInvertVl,
	                                                 pInvertWh, pInvertWl};
	localparam pGateClose = 1'b0;

	// Wires
	wire [(pNumDriveSig-1):0] wSelectedSigs;
	wire [(pNumDriveSig-1):0] wOutputSigs;

	// Output
	assign oUh = wOutputSigs[5];
	assign oUl = wOutputSigs[4];
	assign oVh = wOutputSigs[3];
	assign oVl = wOutputSigs[2];
	assign oWh = wOutputSigs[1];
	assign oWl = wOutputSigs[0];

	// Invert option
	generate
		genvar i;
		for (i = 0; i < pNumDriveSig; i = i + 1) begin : InvertOption
			if (pIsInvertArry[i] == 1) begin
				assign wOutputSigs[i] = ~wSelectedSigs[i];
			end else begin
				assign wOutputSigs[i] = wSelectedSigs[i];
			end
		end
	endgenerate

	// Signal enablation
	assign wSelectedSigs = (iEnable == 1'b1) ? {iUh, iUl, iVh, iVl, iWh, iWl} :
	                                           {(pNumDriveSig){pGateClose}};

endmodule

`default_nettype wire

`endif

