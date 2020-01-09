interface bus (clk, reset);
	input logic req, addr, cmd, wdata, ack, rdata
	
	
	
	
interface intf_2;
		 wire 		sig1, sig3;
		 var logic 	sig2, sig4;
		 modport		a_ports (	input		sig1,
										output	sig2);
		 modport		b_ports 	(	input		sig3,
										output	sig4);
endinterface: intf_2
	
	
	
	
module ip_crossbar_switch

#(
	// Parameter Declarations
	//parameter  = <default_value>	
)

(
	// Master interface
	input 										m_0_req,
	input [address_width-1:0	]			m_0_addr,
	input 										m_0_cmd,
	input [data_width-1:0		]			m_0_wdata,
	output								reg	m_0_ack,
	output								reg	m_0_rdata
	
	// Slave interface
	
	
);

// Localparam
localparam address_width	= 32;
localparam data_width		= 32;
localparam MASTERS_COUNT	= 4;

// Module Item(s)


// vector of requests to slaves
logic [MASTERS_COUNT-1:0]										m_req_vec	=	{m_3_req,m_2_req,m_1_req,m_0_req};

// array of slave addresses
logic [MASTERS_COUNT-1:0][$clog2(SLAVES_COUNT)-1:0]	m_saddr_vec	=	{	m_3_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_2_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_1_addr[$clog2(SLAVES_COUNT)-1:0],
																								m_0_addr[$clog2(SLAVES_COUNT)-1:0])};

//triggers array of simultaneous access to specific slave 
logic [$clog2(SLAVES_COUNT)-1:0]								sim_access;

//counter of round robin turns
logic	[$clog2(BUS_COUNT)-1:0]	rr_turn_counter;


always @ (posedge clk )
begin
	if (reset)
		sim_access 		=> 1'b0;
	else
		sim_access		=>	|m_req_vec;
end


endmodule
