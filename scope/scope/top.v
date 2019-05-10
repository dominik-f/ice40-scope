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
  D7,

  UART_RX,
  UART_TX,
  UART_RX_2,
  UART_TX_2
);

input CLK;        //input 100Mhz clock

input BUT1;       //input signal from button 1
input BUT2;       //input signal from button 2
output LED1;      //output signal to LED1
output LED2;      //output signal to LED2
output TEST_SIG1;
output TEST_SIG2;

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

input UART_RX;
output UART_TX;
input UART_RX_2;
output UART_TX_2;


// generate test signal with approx. 100Hz
testmodule #(.pCntSize(20)) t(
  .iClk         (CLK),
  .iBtn1        (BUT1),
  .iBtn2        (BUT2),
  .oLed1        (LED1),
  .oLed2        (LED2),
  .oTestSig1    (TEST_SIG1),
  .oTestSig2    (TEST_SIG2),
);


wire [7:0] wAdcInput;
wire wAdcClock;
wire wAdcnOE;
wire [7:0] wAdcData;
wire wAdcDataValid;
wire [7:0] wAdcDataDownsampled;
wire wAdcDataDownsampledValid;

assign wAdcInput[0] = ADC_D0;
assign wAdcInput[1] = ADC_D1;
assign wAdcInput[2] = ADC_D2;
assign wAdcInput[3] = ADC_D3;
assign wAdcInput[4] = ADC_D4;
assign wAdcInput[5] = ADC_D5;
assign wAdcInput[6] = ADC_D6;
assign wAdcInput[7] = ADC_D7;
assign ADC_CLK = wAdcClock;
assign ADC_nOE = wAdcnOE;

scope scope1(
  .iClk         (CLK),
  .iADC_Data    (wAdcInput),
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
    rTxData <= wAdcDataDownsampled;
  end
end


reg [7:0] rTxData = 0;
wire wTxActive;
wire wTxDataOutput;
wire wTxDone;
assign UART_TX = wTxDataOutput;
assign UART_TX_2 = wTxDataOutput;

uart_tx tx(
  .i_Clock     (CLK),
  .i_Tx_DV     (wAdcDataDownsampledValid),
  .i_Tx_Byte   (rTxData),
  .o_Tx_Active (wTxActive),
  .o_Tx_Serial (wTxDataOutput),
  .o_Tx_Done   (wTxDone)
);


endmodule // top
