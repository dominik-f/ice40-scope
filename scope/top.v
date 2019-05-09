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
  TEST_SIG2,
  
  D0,
  D1,
  D2,
  D3,
  D4,
  D5,
  D6,
  D7
);

input CLK;        //input 100Mhz clock
input BUT1;       //input signal from button 1
input BUT2;       //input signal from button 2
output LED1;      //output signal to LED1
output LED2;      //output signal to LED2

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


reg rBUT1;        //register to keep button 1 state
reg rBUT2;        //register to keep button 2 state
reg rLED1;        //LED1 value
reg rLED2;        //LED2 value
reg rTestSig1;
reg rTestSig2;

parameter cntSize = 16;
reg [cntSize-1:0] counter;
wire [7:0] wAdcByte;
wire wAdcClock;
wire wAdcnOE;
wire [7:0] wAdcData;
wire wAdcDataValid;
wire [7:0] wAdcDataDownsampled;
wire wAdcDataDownsampledValid;


assign LED1 = rLED1;
assign LED2 = rLED2;
assign TEST_SIG1 = rTestSig1;
assign TEST_SIG2 = rTestSig2;


always @ (posedge CLK) begin
  rBUT1 <= BUT1;          //capture button 1 state to rBUT1
  rBUT2 <= BUT2;          //capture button 2 state to rBUT2
  
  rLED1 <= ~rBUT1;        //copy inversed state of button 1 to rLED1
  rLED2 <= ~rBUT2;        //copy inversed state of button 2 to rLED2

  counter <= counter + 1;

  // highest bit of counter generates signal
  rTestSig1 <= counter[cntSize-1];
  rTestSig2 <= counter[cntSize-1];
end


assign wAdcByte[0] = ADC_D0;
assign wAdcByte[1] = ADC_D1;
assign wAdcByte[2] = ADC_D2;
assign wAdcByte[3] = ADC_D3;
assign wAdcByte[4] = ADC_D4;
assign wAdcByte[5] = ADC_D5;
assign wAdcByte[6] = ADC_D6;
assign wAdcByte[7] = ADC_D7;
assign ADC_CLK = wAdcClock;
assign ADC_nOE = wAdcnOE;

scope scope1(
  .iClk         (CLK),
  .iADC_Data    (wAdcByte),
  .oADC_Data    (wAdcData),
  .oData_Valid  (wAdcDataValid),
  .oADC_CLK     (wAdcClock),
  .oADC_nOE     (wAdcnOE)
);


output D0;
output D1;
output D2;
output D3;
output D4;
output D5;
output D6;
output D7;
reg [7:0] rDataOutput = 0;
assign D0 = rDataOutput[0];
assign D1 = rDataOutput[1];
assign D2 = rDataOutput[2];
assign D3 = rDataOutput[3];
assign D4 = rDataOutput[4];
assign D5 = rDataOutput[5];
assign D6 = rDataOutput[6];
assign D7 = rDataOutput[7];

downsampling dwn(
  .iClk         (CLK),
  .iData        (wAdcData),
  .iData_Valid  (wAdcDataValid),
  .oData        (wAdcDataDownsampled),
  .oData_Valid  (wAdcDataDownsampledValid)
);


always @ (posedge CLK) begin
  if (wAdcDataDownsampledValid) begin
    rDataOutput <= wAdcDataDownsampled;
  end
end


endmodule // top
