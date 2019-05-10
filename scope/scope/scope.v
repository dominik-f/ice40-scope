module scope(
  iClk,

  iADC_Data,
  oADC_Data,
  oData_Valid,

  oADC_CLK,
  oADC_nOE
);

input iClk;  // 100Mhz clock
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


// Clock Frequency: 100MHz
// Strobe Cycle:
// Frequency    <->    Period           <->    Clock Cycles Per Strobe Cycle (= Clock Frequency / Strobe Cycle Frequency)
//   1 Hz       <->      1 sec          <->    100.000.000
//   1 kHz      <->      1 millisec     <->        100.000
//  10 kHz      <->    100 microsec     <->         10.000
//  20 kHz      <->     50 microsec     <->          5.000
// 100 kHz      <->     10 microsec     <->          1.000
//   1 MHz      <->      1 microsec     <->            100
//  10 MHz      <->    100 nanosec      <->             10
//  20 MHz      <->     50 nanosec      <->              5
// 100 MHz      <->     10 nanosec      <->              1
localparam integer pClkCycPerStrobeCyc = 'd5;
// log2(5)      = 2.32
// log2(5_000)  = 12.29
// log2(10_000) = 13.29
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
