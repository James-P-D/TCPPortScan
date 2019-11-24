##################################################################
# Libraries Used                                                 #
##################################################################

require 'socket'

##################################################################
# Global Variables                                               #
##################################################################

# Lookup dictionary mapping port numbers to names
$port_lookup = { 17 => "QOTD", 
                20 => "FTP",
                21 => "FTP-Data",
                22 => "SSH",
                23 => "Telnet",
                25 => "SMTP",
                43 => "Whois",
                53 => "DNS",
                70 => "Gopher",
                80 => "HTTP",
                109 => "POP2",
                110 => "POP3",
                119 => "NNTP",
                443 => "HTTPS"
}

##################################################################
# usage() - Tells user what parameters are available             #
##################################################################

def usage()
  puts "ruby TCPPortScan.rb host ports"
  puts "e.g. ruby TCPPortScan.rb host.com 80 443"
  puts "e.g. ruby TCPPortScan.rb 192.168.0.1 21-25 80 443"
  exit(0)
end

##################################################################
# parse_string_to_port(str) - Converts a string to a port number #
# If input string isn't a number or is negative, return -1       #
##################################################################

def parse_string_to_port(str)
  begin
    # Try and convert to a number
    number = Integer(str)
    if (number <1) || (number > 65535)
      # If outside the range of valid port numbers, return -1
      return -1
    else
      # If valid port number, return it to caller
      return number
    end  
  rescue ArgumentError
    # On any exceptions, return -1
    return -1
  end
end

##################################################################
# parse_argv(argv) - Parse the arguments received from OS and    #
# return the hostname and an array of port numbers               #
##################################################################

def parse_argv(argv)
  # Host is always first argument
  host = argv[0]

  # Create array for ports
  ports = Array.new

  # Ignore the first argument (host), and just traverse the rest
  for i in 1..argv.length - 1
    # If argument contains a hyphen..
    if (argv[i]).include? "-"
      # ..split it in two..
      tokens = argv[i].split("-")
      if tokens.length != 2
        # ..if we get more than two tokens, then it's not valid
        puts "'%s' is not in the form 'number1-number2'" % argv[i]
        exit(1)
      else
        # ..otherwise, parse both tokens..
        number1 = parse_string_to_port(tokens[0])
        if number1 == -1
          puts "'%s' is not a valid port number" % tokens[0]
          exit(1)
        end
        number2 = parse_string_to_port(tokens[1])
        if number2 == -1
          puts "'%s' is not a valid port number" % tokens[1]
          exit(1)
        end
        # ..and create the range between number1 and number2
        for j in number1..number2
          # Add the port to the array
          ports.push(j)
        end
      end
    else
      # If there's no hyphen, then just treat the parameter as
      # a single port number
      number = parse_string_to_port(argv[i])
      if number == -1
        puts "'%s' is not a valid port number" % argv[i]
        exit(1)
      else
        # Add the port to the array
        ports.push(number)
      end
    end
  end

  # Finally, return the host and the port array
  return host, ports
end

##################################################################
# open_TCP_port(host, port) - Attempts to open a TCP socket to   #
# host:port, returning true if successful, or false otherwise    #
##################################################################

def open_TCP_port(host, port)
  begin
    # Try and open the socket
    socket = TCPSocket.open(host, port)
    if socket
      # If it suceeded, port is open, so close it and return true
      socket.close
      return true
    end
  rescue
    # ..in all other cases, close the socket if open, and return false
    if socket != nil
      socket.close
    end
    return false
  end
end

##################################################################
# main()                                                         #
##################################################################

def main()
  # We need atleast 1 argument (hostname), otherwise display
  # usage and exit to OS
  if ARGV.length < 2
    usage()
  end

  # Get the hostname and array of ports from ARGV (arguments
  # to process from OS)
  host, ports = parse_argv(ARGV)

  # If number of ports is zero, nothing we can do so exit to OS
  if ports.length == 0
    puts "No ports to scan"
    exit(1)
  end

  # Initialise counters for open and closed ports
  total_open_ports = 0
  total_closed_Ports = 0

  # Start scanning..
  puts "Start scanning host %s for %d ports" % [host, ports.length]
  for port in ports
    if open_TCP_port(host, port)
      # If port open, see if we have a name for the port, and display to user
      port_name = $port_lookup[port]
      if port_name == nil
        puts "Port %d open" % port
      else
        puts "Port %d (%s) open" % [port, port_name]
      end
      # ..and finally increment the total_open_ports counter
      total_open_ports += 1
    else
      # ..otherwise just increment total_closed_ports
      total_closed_Ports += 1
    end
  end
  
  # Tell the user the total of open/closed ports
  puts "Complete. %d open ports. %d closed ports" % [total_open_ports, total_closed_Ports]

  # Exit to OS
  exit(0)
end

##################################################################
# Call main()                                                    #
##################################################################

main()