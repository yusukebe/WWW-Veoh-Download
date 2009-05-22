#!/usr/bin/perl

use strict;
use warnings;
use WWW::Veoh::Download;

my ( $api_key, $video_id ) = @ARGV;
my $client = WWW::Veoh::Download->new( api_key => $api_key );
$client->download( $video_id , 'sample.mp4' );

