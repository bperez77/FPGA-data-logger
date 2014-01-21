
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE0_Nano
  (//////////// CLOCK //////////
   CLOCK_50,
   
   //////////// LED //////////
   LED,
   
   //////////// KEY //////////
   KEY,
   
   //////////// SW //////////
   SW,
   
   //////////// SDRAM //////////
   //DRAM_ADDR,
   //DRAM_BA,
   //DRAM_CAS_N,
   //DRAM_CKE,
   //DRAM_CLK,
   //DRAM_CS_N,
   //DRAM_DQ,
   //DRAM_DQM,
   //DRAM_RAS_N,
   //DRAM_WE_N,
   
   //////////// EPCS //////////
   //EPCS_ASDO,
   //EPCS_DATA0,
   //EPCS_DCLK,
   //EPCS_NCSO,
   
   //////////// Accelerometer and EEPROM //////////
   //G_SENSOR_CS_N,
   //G_SENSOR_INT,
   //I2C_SCLK,
   //I2C_SDAT,
   
   //////////// ADC //////////
   //ADC_CS_N,
   //ADC_SADDR,
   //ADC_SCLK,
   //ADC_SDAT,
   
   //////////// 2x13 GPIO Header //////////
   //GPIO_2,
   //GPIO_2_IN,
   
   //////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
   GPIO_0_D,
   GPIO_0_IN
   
   //////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
   //GPIO_1,
   //GPIO_1_IN 
   );
   
   //=======================================================
   //  PARAMETER declarations
   //=======================================================
   
   
   //=======================================================
   //  PORT declarations
   //=======================================================
   
   //////////// CLOCK //////////
   input         CLOCK_50;
   
   //////////// LED //////////
   output [7:0]  LED;
   
   //////////// KEY //////////
   input [1:0] 	 KEY;
   
   //////////// SW //////////
   input [3:0] 	 SW;
   
   //////////// SDRAM //////////
   //output [12:0] DRAM_ADDR;
   //output [1:0]  DRAM_BA;
   //output 	 DRAM_CAS_N;
   //output 	 DRAM_CKE;
   //output 	 DRAM_CLK;
   //output 	 DRAM_CS_N;
   //inout [15:0]  DRAM_DQ;
   //output [1:0]  DRAM_DQM;
   //output 	 DRAM_RAS_N;
   //output 	 DRAM_WE_N;
   
   //////////// EPCS //////////
   //output 	 EPCS_ASDO;
   //input 	 EPCS_DATA0;
   //output 	 EPCS_DCLK;
   //output 	 EPCS_NCSO;
   
   //////////// Accelerometer and EEPROM //////////
   //output 	 G_SENSOR_CS_N;
   //input 	 G_SENSOR_INT;
   //output 	 I2C_SCLK;
   //inout 	 I2C_SDAT;
   
   //////////// ADC //////////
   //output 	 ADC_CS_N;
   //output 	 ADC_SADDR;
   //output 	 ADC_SCLK;
   //input 	 ADC_SDAT;
   
   //////////// 2x13 GPIO Header //////////
   //inout [12:0]  GPIO_2;
   //input [2:0] 	 GPIO_2_IN;
   
   //////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
   inout [33:0]  	GPIO_0_D;
   input [1:0] 	GPIO_0_IN;
   
   //////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
   //inout [33:0]  GPIO_1;
   //input [1:0] 	 GPIO_1_IN;
   
   //////////////////////////////////////////////////////////////
   
   logic 	 rx, tx, data_ready, trigger;	 
   logic 	 new_m1, new_m2, new_S, pwm1, pwm2, pwmS;
   logic [6:0] 	 dc1, dc2, dcS;
   logic [7:0] 	 data_out, data_in;
   logic [$clog2(50000000)-1:0] counted;
   
   counter #(.WIDTH ($clog2(50000000))) count(.en(1'b1), .clk(CLOCK_50), .Q(counted), .clr(~KEY[1]));
   
   assign trigger = counted == 49999999;
   assign LED[7:0] = data_out;
   assign GPIO_0_D[0] = tx;
   assign rx = GPIO_0_D[1];
   assign GPIO_0_D[3] = pwm1;
   assign GPIO_0_D[5] = pwm2;
   assign GPIO_0_D[7] = pwmS;

	
   uart #(.CLOCK(50000000), .BAUD(9600)) ser1(.rx(rx), .new_data(trigger), .clk(CLOCK_50), 
					      .rst(~KEY[1]), .data_in(8'd100), 
					      .data_out(data_out), .tx(tx), .data_ready(data_ready));

   pwm #(.CLOCK(50000000), .WIDTH(7), .FREQ(100)) m1(.clk(CLOCK_50), .clr(~KEY[1]), .duty_cycle(dc1),
						     .pwm(pwm1), .new_dc(new_m1));
   pwm #(.CLOCK(50000000), .WIDTH(7), .FREQ(100)) m2(.clk(CLOCK_50), .clr(~KEY[1]), .duty_cycle(dc2),
						     .pwm(pwm2), .new_dc(new_m2));
   pwm #(.CLOCK(50000000), .WIDTH(7), .FREQ(50)) servo(.clk(CLOCK_50), .clr(1'b0), .duty_cycle(dcS),
						       .pwm(pwmS), .new_dc(new_S));
   
   controller cntrl(.data_ready(data_ready), .clk(CLOCK_50), .clr(~KEY[1]), .load_front(new_m1),
		    .load_rear(new_m2), .load_servo_out(new_S), .data(data_out), .rear_motor(dc2),
		    .front_motor(dc1), .servo(dcS));
   

   
endmodule: DE0_Nano