#!/usr/bin/perl
# Copyright (c) 2019, The NibbleClassic Developers
#
# Please see the included LICENSE file for more information.

require HTTP::Request;
require LWP::UserAgent;
use Data::Dump qw(dump);
use JSON;

my $cur_blockheight = 0;
my $max_blockheight = 0;
my $uri = 'http://localhost:17122/json_rpc';
my $json = '{"jsonrpc":"2.0", "method":"getblockcount", "params":{}}';
my $req = HTTP::Request->new( 'POST', $uri );
$req->header( 'Content-Type' => 'application/json' );
$req->content( $json );
my $lwp = LWP::UserAgent->new;
my $res = $lwp->request( $req );
if ($res->is_success) {
    $json_buffer = decode_json($res->decoded_content);
    $max_blockheight = $json_buffer->{result}{count} - 1;

}
else {
    print STDERR $res->status_line, "\n";
    exit 1;
}
while($cur_blockheight < $max_blockheight)
{
$json = '{"jsonrpc":"2.0", "method":"on_getblockhash", "params": [' . ($cur_blockheight+1) .']}';
$req = HTTP::Request->new( 'POST', $uri );
$req->header( 'Content-Type' => 'application/json' );
$req->content( $json );
$lwp = LWP::UserAgent->new;
$res = $lwp->request( $req );
if ($res->is_success) {
    $json_buffer = decode_json($res->decoded_content);
    print $cur_blockheight . ',' . $json_buffer->{result} . "\n";

}
else {
    print STDERR $res->status_line, "\n";
    exit 1;
}
$cur_blockheight++;
}
