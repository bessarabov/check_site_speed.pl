#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw( gettimeofday tv_interval );
use LWP::UserAgent;

my ($site, $count, $delay) = @ARGV[0..2];

unless ($site) {
    print "\nUsage:\n\n    $0 http://sitename [requests count] [delay between requests]\n\n";

    print "Script will send stated count of requests to the site and measure response time.\n";
    print "After each request script will pause for time in second specified by the third parameter.\n";
    print "Script will ignore time of the first request and calculate average time of the other.\n\n";

    exit 1;
}

$count ||= 10;
$delay ||= 1;

print "site: $site\n";
print "count: $count\n";
print "delay: $delay\n\n";

my $ua = LWP::UserAgent->new;
$ua->agent("$0");

my $sum;

for (my $i=1;$i<=$count;$i++) {
    print "request $i\t";

    my $t0 = [gettimeofday];
    my $req = HTTP::Request->new(GET => $site);
    my $res = $ua->request($req);
    my $elapsed = tv_interval($t0);

    print $res->status_line, "\t", $elapsed, "\n";
    
    unless ($i == 1) {
        $sum += $elapsed;
    }

    sleep $delay;
}

printf "\nAverage: %.3f\n", $sum/($count-1) if $count>1;

