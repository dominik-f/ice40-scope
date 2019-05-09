module downsampling(
  iClk,
  
  iData,
  iData_Valid,
  
  oData,
  oData_Valid
);

input iClk;
input [7:0] iData;
input iData_Valid;
output [7:0] oData;
output oData_Valid;


// log2 1000  = 10
// log2 10000 = 14
localparam threshold = 'd1_000;
localparam bits = 10;
reg [bits-1:0] counter = 0;

reg [7:0] rData;
reg rData_Valid;
assign oData = rData;
assign oData_Valid = rData_Valid;

always @ (posedge iClk) begin
  rData <= iData;
  rData_Valid <= 0;

  if (iData_Valid) begin
    if (counter == threshold - 1) begin
      counter <= 0;
      rData_Valid <= 1;
    end
    else begin
      counter <= counter + 1;
    end
  end
end


endmodule // downsampling
