module top(
	CLK,
	BUT1,
	BUT2,
	LED1,
	LED2,
	
	ADC_D0,
	ADC_D1,
	ADC_D2,
	ADC_D3,
	ADC_D4,
	ADC_D5,
	ADC_D6,
	ADC_D7,
	
	ADC_CLK,
	ADC_nOE,
	
	TEST_SIG1,
	TEST_SIG2
);

input CLK;				//input 100Mhz clock
input BUT1;				//input signal from button 1
input BUT2;				//input signal from button 2
output LED1;			//output signal to LED1
output LED2;			//output signal to LED2

input ADC_D0;
input ADC_D1;
input ADC_D2;
input ADC_D3;
input ADC_D4;
input ADC_D5;
input ADC_D6;
input ADC_D7;

output ADC_CLK;
output ADC_nOE;

output TEST_SIG1;
output TEST_SIG2;


reg rBUT1;				//register to keep button 1 state
reg rBUT2;				//register to keep button 2 state
reg rLED1;				//LED1 value
reg rLED2;				//LED2 value
reg rTestSig1;
reg rTestSig2;
reg rAdcClk = 0;

parameter size = 16;
reg [size-1:0] counter; // Signals assigned


//assign ADC_CLK = rAdcClk;

assign LED1 = rLED1;
assign LED2 = rLED2;
assign TEST_SIG1 = rTestSig1;
assign TEST_SIG2 = rTestSig2;


always @ (posedge CLK) begin
	rBUT1 <= BUT1;					//capture button 1 state to rBUT1
	rBUT2 <= BUT2;					//capture button 2 state to rBUT2
	
	rLED1 <= ~rBUT1;				//copy inversed state of button 1 to rLED1
	rLED2 <= ~rBUT2;				//copy inversed state of button 2 to rLED2

	counter <= counter + 1;

	// highest bit of counter generates signal
	rTestSig1 <= counter[size-1];
	rTestSig2 <= counter[size-1];
end


always @ (posedge CLK) begin
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

always @ (posedge CLK) begin
    if (ClkCounter == pClkCycPerStrobeCyc-1) begin
      ClkCounter <= 0;
      strobe     <= 1;
    end
    else begin
			strobe     <= 0;
			ClkCounter <= ClkCounter+1;
    end
end



endmodule // top
