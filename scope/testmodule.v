module testmodule(
  iClk,
  iBtn1,
  iBtn2,
  oLed1,
  oLed2,
  
  oTestSig1,
  oTestSig2
);

parameter pCntSize = 16;

input iClk;
input iBtn1;
input iBtn2;
output oLed1;
output oLed2;
output oTestSig1;
output oTestSig2;


reg rBtn1;
reg rBtn2;
reg rLed1;
reg rLed2;
reg rTestSig1;
reg rTestSig2;

reg [pCntSize-1:0] counter;
assign oLed1 = rLed1;
assign oLed2 = rLed2;
assign oTestSig1 = rTestSig1;
assign oTestSig2 = rTestSig2;


always @ (posedge iClk) begin
  rBtn1 <= iBtn1;
  rBtn2 <= iBtn2;
  rLed1 <= ~rBtn1;
  rLed2 <= ~rBtn2;

  // highest bit of counter generates signal
  counter <= counter + 1;
  rTestSig1 <= counter[pCntSize-1];
  rTestSig2 <= counter[pCntSize-1];
end


endmodule // testmodule
