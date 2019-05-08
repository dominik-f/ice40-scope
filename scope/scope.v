module scope(
	iCLK,

	iADC_Byte,
	oADC_CLK,
	oADC_nOE
);

input iCLK;				//input 100Mhz clock
input [7:0] iADC_Byte;
output oADC_CLK;
output oADC_nOE;

reg rAdcClk = 0;
assign oADC_CLK = rAdcClk;


always @ (posedge iCLK) begin
	// generate 10kHz ADC clock
	if (strobe == 1)
	begin
		if (rAdcClk == 0)
			rAdcClk <= 1;
		else
			rAdcClk <= 0;
	end
end


//   1 sec      = 1Hz
//   1 millisec = 1kHz
// 100 nanosec  = 10kHz
//   1 nanosec  = 1MHz
localparam integer pStrobeCycleFrequency = 'd20_000;
localparam integer pClkFrequency = 'd100_000_000;
localparam integer pClkCycPerStrobeCyc = 'd20_000;	// pClkFrequency / pStrobeCycleFrequency
localparam integer pCntBits = 15;										// log2(20_000) = 14.29

reg [pCntBits-1:0] ClkCounter = 0;
reg strobe = 0;

always @ (posedge iCLK) begin
    if (ClkCounter == pClkCycPerStrobeCyc-1) begin
      ClkCounter <= 0;
      strobe     <= 1;
    end
    else begin
			strobe     <= 0;
			ClkCounter <= ClkCounter+1;
    end
end


endmodule // scope
