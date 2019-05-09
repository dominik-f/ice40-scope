module scope(
	iClk,

	iADC_Data,
	oADC_Data,
	oData_Valid,

	oADC_CLK,
	oADC_nOE
);

input iClk;				//input 100Mhz clock
input [7:0] iADC_Data;
output [7:0] oADC_Data;
output oData_Valid;
output oADC_CLK;
output oADC_nOE;

reg rAdcClk = 0;
reg rAdcnOE = 0;
reg [7:0] rAdcData = 0;
reg rDataValid = 0;
assign oADC_Data = rAdcData;
assign oData_Valid = rDataValid;
assign oADC_CLK = rAdcClk;
assign oADC_nOE = rAdcnOE;


always @ (posedge iClk) begin
	rAdcnOE <= 0;
	rDataValid <= 0;
	// generate 10MHz ADC clock and sample data at falling edge
	if (rStrobe == 1)
	begin
		if (rAdcClk == 0) begin
			rAdcClk <= 1;
		end
		else begin
			rAdcClk <= 0;
			rAdcData <= iADC_Data;
			rDataValid <= 1;
		end
	end
end


//   1 sec      = 1Hz
//   1 millisec = 1kHz
// 100 nanosec  = 10kHz
//   1 nanosec  = 1MHz
localparam integer prStrobeCycleFrequency = 'd20_000_000;
localparam integer pClkFrequency = 'd100_000_000;
// log2(5)      = 2.32
// log2(5_000)  = 12.29
// log2(10_000) = 13.29
// log2(20_000) = 14.29
localparam integer pClkCycPerStrobeCyc = 'd5; 	// pClkFrequency / prStrobeCycleFrequency
localparam integer pCntBits = 3;

reg [pCntBits-1:0] rStrobeCounter = 0;
reg rStrobe = 0;

// generate rStrobe
always @ (posedge iClk) begin
	if (rStrobeCounter == pClkCycPerStrobeCyc-1) begin
		rStrobeCounter <= 0;
		rStrobe <= 1;
	end
	else begin
		rStrobeCounter <= rStrobeCounter+1;
		rStrobe <= 0;
 	end
end


endmodule // scope
