package WWW::Veoh::Download;

use strict;
use warnings;
our $VERSION = '0.01';

use Any::Moose;
use Carp;
use HTTP::Request;
use LWP::UserAgent;

has 'api_key' => ( is => 'rw', isa => 'Str', required => 1 );
has 'ua' => (
    is      => 'rw',
    isa     => 'LWP::UserAgent',
    default => sub {
        LWP::UserAgent->new( agent => 'WWW::Veoh::Download' );
    }
);
has 'timeout_for_check' => ( is => 'rw', isa => 'Int', default => 2 );

sub download {
    my ( $self, $video_id, @args ) = @_;

    my $mp4_url = $self->get_mp4_url($video_id);

    $self->ua->timeout( $self->timeout_for_check );    #xxx
    my $res = $self->ua->get($mp4_url);
    croak "can't download mp4 file: " . $res->staus_line
        if $res->is_error;
    $self->ua->timeout();
    $res = $self->ua->request( HTTP::Request->new( GET => $mp4_url ) , @args );
}

sub get_mp4_url {
    my ( $self, $video_id ) = @_;

    if ( $video_id =~ /(v[0-9a-zA-Z]{14,16})$/ ) {
        $video_id = $1;
    }

    my $api_url =
        sprintf "http://www.veoh.com/rest/v2/execute.xml?method=veoh.video.findByPermalink&apiKey=%s&permalink=%s",
            $self->api_key, $video_id;
    my $res = $self->ua->get($api_url);
    croak "can't get api content: " . $res->status_line if $res->is_error;
    $res->content =~ /ipodUrl="([^\"]+)"/;
    return $1 || croak "can't find mp4 url";
}

1;

__END__

=head1 NAME

WWW::Veoh::Download - Download mp4 files from Veoh

=head1 SYNOPSIS

  use WWW::Veoh::Download;

  my $client = WWW::Veoh::Download->new( api_key => 'your_api_key' );
  $client->download( 'vXXXXXXXXXXXXXXX', 'veoh.mp4' );

=head1 DESCRIPTION

WWW::Veoh::Download is module to get and download mp4 files for iPod etc. from Veoh Video Network.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
