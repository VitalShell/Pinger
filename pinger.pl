#!/usr/bin/env perl
#
#  Pinger - simple network monitoring tool. Allows to ping host by ICMP or TCP.
#  Copyright (C) 2015 Vitaly Druzhinin aka VitalkaDrug (vitalkadrug@gmail.com)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use Net::Ping;
use Getopt::Std;
use strict;
use warnings;

#
# Global variables
our $VERSION = '0.3';   # current version
our $break   = 0;       # break indicator

#
# Set default values for command line arguments
our $opt_t   = 1;       # timeout
our $opt_p   = undef;   # protocol
our $opt_s   = 64;      # packets size
our $opt_i   = 1;       # interval
our $opt_v   = 0;       # verbose
our $opt_b   = undef;   # barrier
our $opt_h   = undef;   # hostname
our $opt_r   = 1;       # threshold

#
$Getopt::Std::STANDARD_HELP_VERSION = 1;        #
$| = 1;                                         # Disable buffered output


sub HELP_MESSAGE () {
    print("Usage: $0 -h HOST [-t TIMEOUT] [-p icmp|tcp] [-s SIZE] [-i INTERVAL] [-b BARRIER] [-v]\n");
    print("  -h HOST      - host to check (IP address or hostname)\n");
    print("  -t TIMEOUT   - timeout (seconds)\n");
    print("  -p icmp|tcp  - protocol (icmp or tcp)\n");
    print("  -s SIZE      - size of packets (bytes)\n");
    print("  -i INTERVAL  - interval to ping (seconds)\n");
    print("  -b BARRIER   - alert barrier for delay (milliseconds)\n");
    print("  -r THRESHOLD - loss threshold\n");
    print("  -v           - verbose mode\n");
    print("\n");
}


sub VERSION_MESSAGE () {
    print("Pinger v.$VERSION. Simple network monitoring tool.\n");
    print("Copyright (C) 2015 Vitaly Druzhinin.\n\n");
}


sub break () {
    $break = 1;
}
$SIG{INT}  = \&break;
$SIG{TERM} = \&break;


sub output {
    my @args = @_;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    printf("%04d-%02d-%02d %02d:%02d:%02d ", $year+1900, $mon+1, $mday, $hour, $min, $sec);
    printf(@args);
    printf("\n");
}


getopts('h:t:p:s:i:b:r:v');
if (not $opt_h) {
    VERSION_MESSAGE();
    HELP_MESSAGE();
    exit(0);
}

#
# Cheking effective rights and available modes
#
if ($>) {
    # if effective UID is not equal 0 (not a root)
    if (!defined($opt_p)) {
        printf("No root privileges, using 'tcp' mode.\n");
        $opt_p = 'tcp';
    } elsif ($opt_p eq 'icmp') {
        printf("No root priveleges to use 'icmp'. Try to use 'tcp' mode.\n");
        exit(1);
    }
} else {
    $opt_p = 'icmp' if (!defined($opt_p));
}

#
# Begin
#
output('Start');
my $ping = Net::Ping->new($opt_p, $opt_t, $opt_s);
$ping->hires(1);
my $last_state = 1;             # Last state of communication
my $last_time  = time();        # Last time changing of state
my $loss_count = 0;

#
# Working until interrupt
#
while (!$break) {
    my ($success, $time, $host) = $ping->ping($opt_h);
    $time = $time * 1000;
    if (defined($success)) {
        if ($success) {
            $loss_count = 0;
            if ($opt_v) {
                output("%s: got a reply within %.3f ms.", $opt_h, $time);
            } elsif ($opt_b and $time > $opt_b) {
                output("%s: too slow connection (%.3f ms.)", $opt_h, $time);
            }
            if (!$last_state) {
                my $interval = time() - $last_time;
                my $days     = int($interval / 86400);
                my $hours    = int(($interval - $days * 86400) / 3600);
                my $minutes  = int(($interval - $days * 86400 - $hours * 3600) / 60);
                my $seconds  = $interval - $days * 86400 - $hours * 3600 - $minutes * 60;
                output("Communication recovered after $interval seconds ("
                    . ($days ? "$days days " : "")
                    . ($hours ? "$hours hours " : "")
                    . ($minutes ? "$minutes min. " : "")
                    . ($seconds ? "$seconds sec." : "")
                    . ")"
                );
                $last_state = 1;
                $last_time  = time();
            }
        } else {
            $loss_count++;
            if ($opt_v) {
                output("%s: no response within %d sec.", $opt_h, $opt_t);
            }
            if ($last_state && $loss_count >= $opt_r) {
                output("Communication lost.");
                $last_state = 0;
                $last_time  = time();
            }
        }
        sleep($opt_i) if (!$break);
    }
}

$ping->close();
output('Stop');

# end of file