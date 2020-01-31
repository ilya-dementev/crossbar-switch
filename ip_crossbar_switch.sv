interface if_bus (clk, reset);
	logic 							req;		// master-> slave
	logic [address_width-1:0	]	addr;		// master-> slave
	logic 							cmd;		// master-> slave
	logic [data_width-1:0		]	wdata;		// master-> slave
	logic ack;									// slave-> master
	logic [data_width-1:0		]	rdata;		// slave-> master
	modport slave (	
		input req, 		
		input addr, 	
		input cmd, 		
		input wdata, 	
		output ack, 	
		output rdata
	);
	modport master (		
		output req, 		
		output addr, 	
		output cmd, 		
		output wdata, 	
		input ack, 	
		input rdata
	);
endinterface: bus	
	

module ip_crossbar_switch
#(
	// Parameter Declarations
	//parameter  = <default_value>	
)
(
	// i-faces for master connection have type "slave"
	if_bus.slave m0bus ,
	if_bus.slave m1bus,
	if_bus.slave m2bus,
	if_bus.slave m3bus,	
	// i-faces for slave connection have type "master"
	if_bus.master s0bus,
	if_bus.master s1bus,
	if_bus.master s2bus,
	if_bus.master s3bus,
);

// Localparam
localparam ADDRESS_WIDTH	= 32;
localparam DATA_WIDTH		= 32;
localparam MASTERS_COUNT	= 4;
localparam SLAVES_COUNT		= 4;

// Module Item(s)

// vector of requests to slaves
logic [MASTERS_COUNT-1:0]										m_req_vec	=	{m3bus.req,m2bus.req,m1bus.req,m0bus.req};

// array of slave addresses
logic [MASTERS_COUNT-1:0][$clog2(SLAVES_COUNT)-1:0]	m_saddr_vec	=	{	m_3_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_2_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_1_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_0_addr[$clog2(SLAVES_COUNT)-1:0])};

//triggers array of simultaneous access to specific slave 
logic [$clog2(SLAVES_COUNT)-1:0]								simult_access;

//counter of round robin turns
logic	[$clog2(BUS_COUNT)-1:0]	rrs0_counter;
logic	[$clog2(BUS_COUNT)-1:0]	rrs1_counter;
logic	[$clog2(BUS_COUNT)-1:0]	rrs2_counter;
logic	[$clog2(BUS_COUNT)-1:0]	rrs3_counter;

s0bus.addr =	( rrs0_counter == 0 )	?	m0bus.addr :
				( rrs0_counter == 1 )	?	m1bus.addr :
				( rrs0_counter == 2 )	?	m2bus.addr :
				//( rrs0_counter == 3 )	?	m3bus.addr :
											m3bus.addr ;
if 

// simult_request
always @ (posedge clk )
begin
	if (reset)
		simult_request 		=> 1'b0;
	else
		simult_request		=>	|m_req_vec;
end

always @( posedge clk )
begin
	
end

endmodule
