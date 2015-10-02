# Pragmas.
use strict;
use warnings;

# Modules.
use Encode qw(decode_utf8);
use English;
use Map::Tube::Sofia;
use Test::More tests => 7;
use Test::NoWarnings;

# Test.
my $map = Map::Tube::Sofia->new;
eval {
	$map->get_shortest_route;
};
like($EVAL_ERROR, qr/ERROR: Either FROM\/TO node is undefined/,
	'Either FROM/TO node is undefined');

# Test.
eval {
	$map->get_shortest_route('Foo');
};
like($EVAL_ERROR, qr/ERROR: Either FROM\/TO node is undefined/,
	'Either FROM/TO node is undefined');

# Test.
eval {
	$map->get_shortest_route('Foo', 'Bar');
};
like(
	$EVAL_ERROR,
	qr/\QMap::Tube::get_shortest_route(): ERROR: Received invalid FROM node 'Foo'\E/,
	"Received invalid FROM node 'Foo'.",
);

# Test.
eval {
	$map->get_shortest_route(decode_utf8('Сердика'), 'Foo');
};
like(
	$EVAL_ERROR,
	qr/\QMap::Tube::get_shortest_route(): ERROR: Received invalid TO node 'Foo'\E/,
	"Received invalid TO node 'Foo'.",
);

# Test.
my $ret = $map->get_shortest_route(decode_utf8('Ломско шосе'),
	decode_utf8('Сливница'));
my $right_ret = decode_utf8('Ломско шосе (Втори метродиаметър), Обеля '.
	'(Първи метродиаметър, Втори метродиаметър), '.
	'Сливница (Първи метродиаметър)');
is($ret, $right_ret, "Shortest route from 'Ломско шосе' to 'Сливница'.");

# Test.
$ret = $map->get_shortest_route(decode_utf8('Сливница'),
	decode_utf8('Ломско шосе'));
$right_ret = decode_utf8('Сливница (Първи метродиаметър), Обеля '.
	'(Първи метродиаметър, Втори метродиаметър), '.
	'Ломско шосе (Втори метродиаметър)');
is($ret, $right_ret, "Shortest route from 'Сливница' to 'Ломско шосе'.");
