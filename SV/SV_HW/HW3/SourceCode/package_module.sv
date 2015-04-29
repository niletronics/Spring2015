`include "package.sv"

import ipv6::*;

module ipv6_module;

reg [350:0] hold_returned;

initial begin 

ipv6_header from_module;

from_module.version=4'h1;

from_module.trafficclass=8'h12;

from_module.flowlabel=20'h12345;

from_module.payloadlength=16'h1234;

from_module.nextheader=8'h12;

from_module.hoplimit=8'h12;

from_module.sourceaddress=128'hffffffffffffffffffffffffffffffff;

from_module.destinationaddress=128'hffffffffffffffffffffffffffffffff;


header_display(from_module);

hold_returned=display_length(from_module);

$display("Returned bit vector is %0h",hold_returned);

end

endmodule









