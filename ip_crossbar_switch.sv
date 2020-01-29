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
	if_bus.slave m_0_bus ,
	if_bus.slave m_1_bus,
	if_bus.slave m_2_bus,
	if_bus.slave m_3_bus,	
	// i-faces for slave connection have type "master"
	if_bus.master s_0_bus,
	if_bus.master s_1_bus,
	if_bus.master s_2_bus,
	if_bus.master s_3_bus,
);

// Localparam
localparam ADDRESS_WIDTH	= 32;
localparam DATA_WIDTH		= 32;
localparam MASTERS_COUNT	= 4;
localparam SLAVES_COUNT		= 4;

// Module Item(s)

// vector of requests to slaves
logic [MASTERS_COUNT-1:0]										m_req_vec	=	{m_3_req,m_2_req,m_1_req,m_0_req};

// array of slave addresses
logic [MASTERS_COUNT-1:0][$clog2(SLAVES_COUNT)-1:0]	m_saddr_vec	=	{	m_3_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_2_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_1_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_0_addr[$clog2(SLAVES_COUNT)-1:0])};

//triggers array of simultaneous access to specific slave 
logic [$clog2(SLAVES_COUNT)-1:0]								simult_access;

//counter of round robin turns
logic	[$clog2(BUS_COUNT)-1:0]	rr_turn_counter;


always @ (posedge clk )
begin
	if (reset)
		simult_access 		=> 1'b0;
	else
		simult_access		=>	|m_req_vec;
end

always @( posedge clk )
begin
	
end

endmodule
