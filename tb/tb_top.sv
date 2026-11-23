`include "dff_if.sv"
`include "environment.sv"

module tb_top;
  logic clk = 0;
  always #5 clk = ~clk;

  dff_if intf(clk);
  dff dut(.clk(clk), .rst_n(intf.rst_n), .d(intf.d), .q(intf.q));

  environment env;

  initial begin
    intf.rst_n = 0; intf.d = 0;
    #12 intf.rst_n = 1;
    env = new(intf);
    env.run();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end
endmodule