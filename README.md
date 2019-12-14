# TCPPortScan
A simple TCP Port Scanner in [Ruby](https://www.ruby-lang.org/en/)

![Screenshot](https://github.com/James-P-D/TCPPortScan/blob/master/screenshot.gif)

## Usage

```
C:\Users\jdorr\Desktop\Dev\TCPPortScan\src>ruby TCPPortScan.rb
ruby TCPPortScan.rb host ports
e.g. ruby TCPPortScan.rb host.com 80 443
e.g. ruby TCPPortScan.rb 192.168.0.1 21-25 80 443

C:\Users\jdorr\Desktop\Dev\TCPPortScan\src>ruby TCPPortScan.rb 192.168.0.1 21-25 53 80
Start scanning host 192.168.0.1 for 7 ports
Port 53 (DNS) open
Port 80 (HTTP) open
Complete. 2 open ports. 5 closed ports
```
