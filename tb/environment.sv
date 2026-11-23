`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard scb;
  mailbox #(transaction) g2d = new();
  mailbox #(transaction) m2s = new();

  function new(virtual dff_if vif);
    gen = new(); drv = new(); mon = new(); scb = new();
    gen.gen2drv = g2d;  drv.gen2drv = g2d;
    drv.vif = vif;      mon.vif = vif;
    mon.mon2scb = m2s;  scb.mon2scb = m2s;
  endfunction

  task run();
    fork
      gen.run(); drv.run(); mon.run(); scb.run();
    join_none
    #(gen.count * 10 + 20);
    $display("PASS=%0d FAIL=%0d", scb.pass, scb.fail);
    $finish;
  endtask
endclass