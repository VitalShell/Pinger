# Pinger
Pinger - simple network monitoring tool. Allows to ping host by ICMP or TCP.
Prints info about network issues to STDOUT.
A trivial app to learn features of the Net::Ping module.

## Usage
```
./pinger.pl -h HOST [-t TIMEOUT] [-p icmp|tcp] [-s SIZE] [-i INTERVAL] [-b BARRIER] [-v]
  -h HOST      - host to check (IP address or hostname)
  -t TIMEOUT   - timeout (seconds)
  -p icmp|tcp  - protocol (icmp or tcp)
  -s SIZE      - size of packets (bytes)
  -i INTERVAL  - interval to ping (seconds)
  -b BARRIER   - alert barrier for delay (milliseconds)
  -v           - verbose mode
```

## Deployment
The Pinger uses core Perl modules and doesn't require any extra modules to install.

## Feature
The 'root' privileges are required to use the 'icmp' protocol (it's feature of the Net::Ping).
