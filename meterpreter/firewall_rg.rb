#
# Meterpreter script to enable windows firewall
# Usefull for king of the hill type activities
# Test using railgun
#

@client 	= client
@port 		= '445' #probably want to block this
@rg 			= client.railgun
@shell32  = @rg.shell32
@firewall = @rg.FirewallAPI

opts = Rex::Parser::Arguments.new(
	"-h" => [ false, "Help Menu" ],
	"-d" => [ false, "Disable TCP port" ],
	"-e" => [ false, "Enable TCP port" ],
	"-p" => [ false, "Port number" ],
	"-f" => [ false, "Flush Firewall rules" ],
	"-s" => [ false, "Display Firewall status"]
)

opts.parse(args) { |opt, id, val|
	case opt
	when "-d"
		firewall_disable_tcp_port(@port)	
	when "-e"
		firewall_enable_tcp_port(@port)	
	when "-p"
		@port = val
	when "-f"
		firewall_flush
	when "-s"
		firewall_status
	when "-h"
		print_line "Firewall -- Windows Firewall Manipulation"
		print_line 
		print_line "Quick script for enabling and disabling "
		print_line "different firewall features using Windows "
		print_line "netsh advfirewall"
		print_line(opts.usage)
		raise Rex::Script::Completed
	end
}

def usage
	print_line("Cool script bro")
end

def enable(port)
	print_status("Enabling port #{port}")
	@firewall.Add(Add, @port)
end

def disable(port)
	print_status("Disabling port #{port}")
	@firewall.Remove(port, "TCP")
end
