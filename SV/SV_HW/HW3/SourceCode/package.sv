package ipv6;

logic [320:0] push;
reg   [350:0] temp;

typedef struct {
logic [3:0]   version;
logic [7:0]   trafficclass;
logic [19:0]  flowlabel;
logic [15:0]  payloadlength;
logic [7:0]   nextheader;
logic [7:0]   hoplimit;
logic [127:0] sourceaddress;
logic [127:0] destinationaddress;
} ipv6_header;

function header_display(ipv6_header header_disp); 


	    $display("Version == %h",header_disp.version);
	    $display("TrafficClass == %h",header_disp.trafficclass);
	    $display("FlowLabel == %h",header_disp.flowlabel);
	    $display("PayloadLength == %h",header_disp.payloadlength);
	    $display("NextHeader == %h",header_disp.nextheader);
	    $display("HopLimit == %h",header_disp.hoplimit);
	    $display("SourceAddress == %h",header_disp.sourceaddress);
	    $display("DestinationAddress == %h",header_disp.destinationaddress);

endfunction

function display_length(ipv6_header header_length);


		temp=$bits(header_length);
		
		push[319:0]={320'b1};
		
		$display("push is %b",push);
		
		return push;

endfunction

endpackage


































