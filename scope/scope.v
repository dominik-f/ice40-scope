module top(						//top module
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

input			CLK;				//input 100Mhz clock
input			BUT1;				//input signal from button 1
input			BUT2;				//input signal from button 2
output			LED1;				//output signal to LED1
output			LED2;				//output signal to LED2

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

parameter size = 16;

reg			BUT1_r;				//register to keep button 1 state
reg			BUT2_r;				//register to keep button 2 state
reg			LED1_r;				//LED1 value
reg			LED2_r;				//LED2 value

reg [size-1:0] counter; // Signals assigned
wire TEST_SIG1;
wire TEST_SIG2;


assign LED1 = LED1_r;
assign LED2 = LED2_r;

always @ (posedge CLK) begin				//on each positive edge of 100Mhz clock//on each positive edge of 24414Hz clock
	BUT1_r <= BUT1;					//capture button 1 state to BUT1_r
	BUT2_r <= BUT2;					//capture button 2 state to BUT2_r
	
	LED1_r <= ~BUT1_r;				//copy inversed state of button 1 to LED1_r
	LED2_r <= ~BUT2_r;				//copy inversed state of button 2 to LED2_r

	counter <= counter + 1;

	TEST_SIG1 <= counter[size-1];
	TEST_SIG2 <= counter[size-1];
end

endmodule
