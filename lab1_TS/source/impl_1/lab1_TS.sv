// Tali Smith, natasmith@hmc.edu, 9/1/25
// Lab 1
// Code for implementing 7-segment display to display all hexadecimal digits using 4 switches.

module top(input  logic  	  clk,
			   input  logic [3:0] s,
		       output logic [2:0] led,
		       output logic [6:0] seg);

	logic int_osc;
	logic pulse;
	logic led_state = 0;
	logic [24:0] counter = 0;
	
	// Internal high-speed oscillator
	HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	// determine the correct segments based on hex represented by switches
	determineHex hex(clk, s, seg);
	
	// control the LEDs using the switches
	// LED[0]
	assign led[0] = s[1] ^ s[0]; // s[1] OR s[0]
	// LED[1]
	assign led[1] = s[3] & s[2]; // s3[3] AND s[2]
	// LED[2]
	// clock divider
	always_ff @(posedge int_osc)
		begin
			if (counter == 25'd10000000 - 1) begin // switch led every 10 mil cycles
				counter <= 0;
				led[2] <= ~led[2];
			end else begin
				counter <= counter + 1;
			end
		end
	
endmodule


// Tali Smith, natasmith@hmc.edu, 9/1/25
// This module takes in the 4 switches and determines what segments of the 7-segment
// display  should be lit to represent hex value (for common anode display)
module determineHex(input  logic 	   clk,
					input  logic [3:0] s,
					output logic [6:0] seg);
				
	always_comb
		case (s)
			4'b0000: seg = 7'b1000000; // 0
			4'b0001: seg = 7'b1111001; // 1
			4'b0010: seg = 7'b0100100; // 2
			4'b0011: seg = 7'b0110000; // 3
			4'b0100: seg = 7'b0011001; // 4
			4'b0101: seg = 7'b0010010; // 5
			4'b0110: seg = 7'b0000010; // 6
			4'b0111: seg = 7'b1111000; // 7
			4'b1000: seg = 7'b0000000; // 8
			4'b1001: seg = 7'b0010000; // 9
			4'b1010: seg = 7'b0001000; // A
			4'b1011: seg = 7'b0000011; // b
			4'b1100: seg = 7'b1000110; // C
			4'b1101: seg = 7'b0100001; // d
			4'b1110: seg = 7'b0000110; // E
			4'b1111: seg = 7'b0001110; // F
			default: seg = 7'b1111111; // off
		endcase
endmodule
	
	 