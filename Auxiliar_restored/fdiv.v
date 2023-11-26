/*
 * fdiv
 *
 * divide o clkin por divisor resultando em clkout
 */


module fdiv (
	input wire clkin,
	input wire divisor,
	output reg clkout
	);

integer cont;

initial
   cont=0;
  
always @(posedge clkin)
  begin
	if (cont==divisor)
		begin
			cont<=0;
			clkout<=~clkout;
		end
	else
		begin
			cont<=cont+1;
			clkout<=clkout;
		end
   end
endmodule
