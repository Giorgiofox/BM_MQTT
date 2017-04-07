#!/usr/bin/perl

use Net::MQTT::Simple;
use JSON qw( decode_json );
use strict;
use Encode qw(from_to);
use warnings;
no warnings 'uninitialized';

#Set Up MQTT server and channel details
my $mqtt_hostname = 'yourserver:port';
my $mqtt_input = "Master/2221/Session/#";
#my $mqtt_input = "Master/2221/Repeater/#";

#instantiate the MQTT connection
my $mqtt = Net::MQTT::Simple->new($mqtt_hostname);

#subscribe to the input channel
#direct incoming messages to the callback function
$mqtt->subscribe($mqtt_input,\&callback);

while(1) { #main loop
    $mqtt->tick(1); #check MQTT with a 1 second timeout
}


sub callback {#function to handle incoming MQTT messages
  my ($topic, $message) = @_; #take the incoming message data
  from_to($message, 'UTF-8','UTF-16le');
  my $decoded = decode_json($message);
  my $origin = $decoded->{'SourceID'};
  my $destination = $decoded->{'DestinationID'};
  #if (($origin eq "222220") or ($destination eq "222220")){print "$message\n";}
  print "$message\n";
}
