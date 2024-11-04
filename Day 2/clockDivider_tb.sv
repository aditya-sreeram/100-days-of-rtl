//author: Aditya Sreeram //date:3/11/24

//transaction
class transaction;
    rand bit rst, enb;
    bit div2, div4, div8;
    constraint cnstrn{
    enb dist{0:/50,1:/50};
    rst dist{0:/50,1:/50};}

    function transaction copy();
	copy= new();
	copy.rst=this.rst;
	copy.enb=this.enb;
	copy.div2=this.div2;
	copy.div4=this.div4;
	copy.div8=this.div8;
    endfunction

    function void display(input string tag);
      $display("[%s] : rst: %0b enb: %0b div2: %0b div4: %0b div8: %0b",tag,rst,enb,div2,div4,div8);
    endfunction
endclass

//generator 
class generator;
  transaction tr;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event sconext;
  event done;
  int count;
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx;
    this.mbxref = mbxref;
    tr = new();
  endfunction
  
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN] : Randomization Failed");
      
      mbx.put(tr.copy);
      mbxref.put(tr.copy);
      tr.display("GEN");
      @(sconext);
    end
    ->done;
  endtask
  
endclass

//driver
class driver;
  transaction tr;
  mailbox #(transaction) mbx;
  virtual clockDivider_if vif;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task reset();
    vif.rst <= 1'b1;
    repeat(5) @(posedge vif.clk);
    vif.rst <= 1'b0;
    @(posedge vif.clk);
    $display("[DRV] : Reset Done");
  endtask
  
  task run();
    forever begin
      mbx.get(tr);
      vif.enb <= tr.enb;
      vif.rst <= tr.rst;
      //@(posedge vif.clk);
      tr.display("DRV");
      @(posedge vif.clk);
    end
  endtask
  
endclass

//monitor 
class monitor;
  transaction tr;
  mailbox #(transaction) mbx;
  virtual clockDivider_if vif;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    tr = new();
    forever begin
      repeat(2) @(posedge vif.clk);
      tr.div2 = vif.div2;
      tr.div4 = vif.div4;
      tr.div8 = vif.div8;
      mbx.put(tr);
      tr.display("MON");
    end
  endtask
  
endclass

//scoreboard 
class scoreboard;

    transaction tr;
    transaction trref;
    mailbox #(transaction) mbx;
    mailbox #(transaction) mbxref;
    event sconext;

    function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
	this.mbx=mbx;
	this.mbxref=mbxref;
    endfunction

    task run();
	forever begin
	mbx.get(tr);
	mbxref.get(trref);
	tr.display("SCO");
	trref.display("REF");
      
      if ({trref.rst,tr.div2,tr.div4,tr.div8}==4'b1000)
      $display("[SCO]: Reset works");
      else if(trref.rst==1 && {tr.div2,tr.div4,tr.div8}!=000)       
      $display("[SCO]: Reset not working");
	->sconext;	
	end

    endtask
endclass


//environment
class environment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
    event next;

    mailbox #(transaction) gdmbx;
    mailbox #(transaction) msmbx;
    mailbox #(transaction) mbxref;

    virtual clockDivider_if vif;

    function new(virtual clockDivider_if vif);
	gdmbx= new();
	mbxref= new();
	gen=new(gdmbx,mbxref);
	drv=new(gdmbx);
	msmbx = new();
	mon=new(msmbx);
	sco=new(msmbx,mbxref);
    this.vif=vif;
	drv.vif=this.vif;
	mon.vif=this.vif;
	gen.sconext =next;
	sco.sconext=next;
    endfunction

    task pre_test();
	drv.reset();
    endtask

    task test();
	fork
	gen.run();
	drv.run();
	mon.run();
	sco.run();
	join_any
    endtask

    task post_test();
	wait(gen.done.triggered); 
	$finish();
    endtask
  
    task run();
    pre_test();
    test();
    post_test();
    endtask
endclass

//test bench
module tb;
  clockDivider_if vif();
    clockDivider dut(vif);
    
    initial begin
    vif.clk <=0;
	forever #10 vif.clk <= ~vif.clk;
    end
    

    environment env;
 

    initial begin
	env= new(vif);
 	env.gen.count=30;
	env.run();
    end
  
   initial begin
    $dumpfile("dump.vcd");
    $dumpvars; 
  end
  
endmodule