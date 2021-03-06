//Module library for use in designs

//Parallel in Parallel out
module pipo_reg
  #(WIDTH = 8)
   (input logic [WIDTH-1:0] D,
    input logic load, clk, clr,
    output logic [WIDTH-1:0] Q);

   always_ff @(posedge clk) begin
      if (clr)
	Q <= 'd0;
      else if (load)
	Q <= D;
   end

endmodule: pipo_reg


//Parallel in with serial out and parallel out
module piso_reg
  #(WIDTH = 8)
   (input logic  [WIDTH-1:0] D,
    input logic  load, shift, clk, clr,
    output logic [WIDTH-1:0] Q,
    output logic out);
   

   assign out = Q[0];
   
   always_ff @(posedge clk) begin
      if (clr)
	Q <= 'd0;
      else if (load)
	Q <= D;
      else if (shift)
	Q <=  Q >> 1 | 1'b0;
   end      

endmodule: piso_reg

//Serial in Parallel out
module sipo_reg
  #(WIDTH = 8)
   (input logic  d_in, clk, clr, en,
    output logic [WIDTH-1:0] Q);
   logic [WIDTH-1:0] 	     D;
   
   always_ff @(posedge clk) begin
      if (en & ~clr)
	Q <= {d_in, Q[WIDTH-1:1]};
      else if (clr)
	Q <= 'b0;
   end

endmodule: sipo_reg

module counter
  #(WIDTH = 8)
   (input logic en, clr, clk,
    output logic [WIDTH-1:0] Q);
   logic [WIDTH-1:0] 	     Qup;
      
   always_ff @(posedge clk) begin
      if (clr)
	Q <= 'b0;
      else if (en)
	Q <= Qup;
   end // always_ff @ (posedge clk)

   assign Qup = Q + 1'd1;

endmodule: counter

module mux
  (input logic D0, D1, sel,
   output logic Y);

   always_comb begin
      if(sel)
	Y = D1;
      else
	Y = D0;
   end

endmodule: mux

module limit_counter
 #(parameter WIDTH = 8, LIMIT = $pow(2, WIDTH))
  (input  logic clk,
   input  logic en,clr,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clk)
    if (clr)
      Q <= 'd0;
    else if (en)
      begin
      if (Q == LIMIT)
        Q <= 'd0;
      else
        Q <= Q + 1;
      end

endmodule: limit_counter

module is_equal
    #(parameter WIDTH=8)
    (input  logic [WIDTH-1:0] A,
     input  logic [WIDTH-1:0] B,
     output logic equal);

     assign equal = A == B;

endmodule: is_equal 
