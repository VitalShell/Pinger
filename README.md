# Pinger
Pinger - simple network monitoring tool. Allows to ping a host by ICMP or TCP.
Prints info about network issues to STDOUT.
A trivial app to learn features of the Net::Ping module.

## Usage
```
./pinger.pl -h HOST [-t TIMEOUT] [-p icmp|tcp] [-s SIZE] [-i INTERVAL] [-d DELAY] [-r THRESHOLD] [-v]
  -h HOST      - host to check (IP address or hostname)
  -t TIMEOUT   - timeout for waiting an answer (seconds, 1 second by default)
  -p icmp|tcp  - protocol (icmp or tcp, icmp by default if you are root)
  -s SIZE      - size of packets (bytes, 64 by default)
  -i INTERVAL  - interval after getting a reply before sending the next request (seconds, 1 second by default)
  -d DELAY     - critical delay, adds alert about reply time longer than specified (milliseconds, no alerts by default)
  -r THRESHOLD - losses threshold, alert only after specified count of lost packets (1 by default)
  -v           - verbose mode, generates more detailed log
```

## Deployment
The Pinger uses core Perl modules and doesn't require any extra modules to install.

## Features
The 'root' privileges are required to use the 'icmp' protocol (it's a feature of the Net::Ping).

## Examples of usage
### Standard log
```
# ./pinger.pl -h somehost.com
```
```
2016-04-05 21:24:14 Start
2016-04-05 21:24:20 Communication lost.
2016-04-05 21:24:21 Communication recovered after 1 seconds (1 sec.)
2016-04-05 21:24:25 Communication lost.
2016-04-05 21:24:27 Communication recovered after 2 seconds (2 sec.)
2016-04-05 21:24:29 Communication lost.
2016-04-05 21:24:32 Communication recovered after 3 seconds (3 sec.)
2016-04-05 21:24:36 Stop
```

### Verbose log
The verbose mode allows you to add more detailed information to the output.
```
# ./pinger.pl -h somehost.com -v
```
```
2016-04-05 21:24:14 Start
2016-04-05 21:24:14 somehost.com: got a reply within 163.808 ms.
2016-04-05 21:24:16 somehost.com: got a reply within 163.480 ms.
2016-04-05 21:24:17 somehost.com: got a reply within 163.493 ms.
2016-04-05 21:24:18 somehost.com: got a reply within 164.418 ms.
2016-04-05 21:24:20 somehost.com: no response within 1 sec.
2016-04-05 21:24:20 Communication lost.
2016-04-05 21:24:21 somehost.com: got a reply within 164.090 ms.
2016-04-05 21:24:21 Communication recovered after 1 seconds (1 sec.)
2016-04-05 21:24:22 somehost.com: got a reply within 164.428 ms.
2016-04-05 21:24:23 somehost.com: got a reply within 164.161 ms.
2016-04-05 21:24:25 somehost.com: no response within 1 sec.
2016-04-05 21:24:25 Communication lost.
2016-04-05 21:24:27 somehost.com: got a reply within 163.336 ms.
2016-04-05 21:24:27 Communication recovered after 2 seconds (2 sec.)
2016-04-05 21:24:29 somehost.com: no response within 1 sec.
2016-04-05 21:24:29 Communication lost.
2016-04-05 21:24:31 somehost.com: no response within 1 sec.
2016-04-05 21:24:32 somehost.com: got a reply within 164.068 ms.
2016-04-05 21:24:32 Communication recovered after 3 seconds (3 sec.)
2016-04-05 21:24:33 somehost.com: got a reply within 163.699 ms.
2016-04-05 21:24:34 somehost.com: got a reply within 164.140 ms.
2016-04-05 21:24:35 somehost.com: got a reply within 166.797 ms.
2016-04-05 21:24:36 Stop
```

### Standard log with the increased timeout
You can use `-t` option to increase time for waiting a reply.
```
# ./pinger.pl -h somehost.com -t 10
```
```
2016-04-05 21:38:08 Start
2016-04-05 21:38:18 Communication lost.
2016-04-05 21:38:30 Communication recovered after 12 seconds (12 sec.)
2016-04-05 21:38:41 Communication lost.
2016-04-05 21:38:42 Communication recovered after 1 seconds (1 sec.)
2016-04-05 21:38:58 Communication lost.
2016-04-05 21:39:21 Communication recovered after 23 seconds (23 sec.)
2016-04-05 21:39:24 Stop
```

### Verbose log with the increased timeout
```
# ./pinger.pl -h somehost.com -v -t 10
```
```
2016-04-05 21:38:08 Start
2016-04-05 21:38:18 somehost.com: no response within 10 sec.
2016-04-05 21:38:18 Communication lost.
2016-04-05 21:38:29 somehost.com: no response within 10 sec.
2016-04-05 21:38:30 somehost.com: got a reply within 163.571 ms.
2016-04-05 21:38:30 Communication recovered after 12 seconds (12 sec.)
2016-04-05 21:38:41 somehost.com: no response within 10 sec.
2016-04-05 21:38:41 Communication lost.
2016-04-05 21:38:42 somehost.com: got a reply within 163.681 ms.
2016-04-05 21:38:42 Communication recovered after 1 seconds (1 sec.)
2016-04-05 21:38:43 somehost.com: got a reply within 163.338 ms.
2016-04-05 21:38:44 somehost.com: got a reply within 163.921 ms.
2016-04-05 21:38:45 somehost.com: got a reply within 163.289 ms.
2016-04-05 21:38:47 somehost.com: got a reply within 163.407 ms.
2016-04-05 21:38:58 somehost.com: no response within 10 sec.
2016-04-05 21:38:58 Communication lost.
2016-04-05 21:39:09 somehost.com: no response within 10 sec.
2016-04-05 21:39:20 somehost.com: no response within 10 sec.
2016-04-05 21:39:21 somehost.com: got a reply within 163.371 ms.
2016-04-05 21:39:21 Communication recovered after 23 seconds (23 sec.)
2016-04-05 21:39:22 somehost.com: got a reply within 181.109 ms.
2016-04-05 21:39:23 somehost.com: got a reply within 164.209 ms.
2016-04-05 21:39:24 Stop
```

### Verbose log with the loss threshold specified
You can use `-r` option to specify the number of lost packets before generate 'Communication lost' message.
```
# ./pinger.pl -h somehost.com -v -t 3 -r 10
```
```
2016-04-09 06:25:41 Start
2016-04-09 06:25:44 somehost.com: no response within 3 sec.
2016-04-09 06:25:48 somehost.com: no response within 3 sec.
2016-04-09 06:25:52 somehost.com: no response within 3 sec.
2016-04-09 06:25:56 somehost.com: no response within 3 sec.
2016-04-09 06:26:00 somehost.com: no response within 3 sec.
2016-04-09 06:26:04 somehost.com: no response within 3 sec.
2016-04-09 06:26:08 somehost.com: no response within 3 sec.
2016-04-09 06:26:12 somehost.com: no response within 3 sec.
2016-04-09 06:26:13 somehost.com: got a reply within 149.443 ms.
2016-04-09 06:26:17 somehost.com: no response within 3 sec.
2016-04-09 06:26:21 somehost.com: no response within 3 sec.
2016-04-09 06:26:22 somehost.com: got a reply within 149.546 ms.
2016-04-09 06:26:26 somehost.com: no response within 3 sec.
2016-04-09 06:26:30 somehost.com: no response within 3 sec.
2016-04-09 06:26:34 somehost.com: no response within 3 sec.
2016-04-09 06:26:38 somehost.com: no response within 3 sec.
2016-04-09 06:26:42 somehost.com: no response within 3 sec.
2016-04-09 06:26:46 somehost.com: no response within 3 sec.
2016-04-09 06:26:50 somehost.com: no response within 3 sec.
2016-04-09 06:26:54 somehost.com: no response within 3 sec.
2016-04-09 06:26:58 somehost.com: no response within 3 sec.
2016-04-09 06:27:02 somehost.com: no response within 3 sec.
2016-04-09 06:27:02 Communication lost.
2016-04-09 06:27:06 somehost.com: no response within 3 sec.
2016-04-09 06:27:07 somehost.com: got a reply within 149.424 ms.
2016-04-09 06:27:07 Communication recovered after 5 seconds (5 sec.)
2016-04-09 06:27:11 somehost.com: no response within 3 sec.
2016-04-09 06:27:13 Stop
```

### Verbose log with the critical delay specified
You can use `-d` option to specify the critical delay for replies.
```
# ./pinger.pl -h somewhere.com -v -d 90
```
```
2016-04-09 12:09:22 Start
2016-04-09 12:09:22 somewhere.com: got a reply within 92.917 ms.
2016-04-09 12:09:22 somewhere.com: too slow connection (92.917 ms.)
2016-04-09 12:09:23 somewhere.com: got a reply within 92.661 ms.
2016-04-09 12:09:23 somewhere.com: too slow connection (92.661 ms.)
2016-04-09 12:09:24 somewhere.com: got a reply within 88.958 ms.
2016-04-09 12:09:26 somewhere.com: got a reply within 89.145 ms.
2016-04-09 12:09:27 somewhere.com: got a reply within 91.329 ms.
2016-04-09 12:09:27 somewhere.com: too slow connection (91.329 ms.)
2016-04-09 12:09:28 somewhere.com: got a reply within 78.861 ms.
2016-04-09 12:09:29 somewhere.com: got a reply within 78.740 ms.
2016-04-09 12:09:29 Stop
```
