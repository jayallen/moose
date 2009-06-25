#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 18;

BEGIN {
    use_ok('Moose::AttributeHelpers');
}

{
    package MyHomePage;
    use Moose;

    has 'counter' => (
        metaclass => 'Counter',
        is        => 'ro',
        isa       => 'Int',
        default   => sub { 0 },
        handles  => {
            inc_counter   => 'inc',
            dec_counter   => 'dec',
            reset_counter => 'reset',
            set_counter   => 'set'
        }
    );
}

my $page = MyHomePage->new();
isa_ok($page, 'MyHomePage');

can_ok($page, $_) for qw[
    dec_counter
    inc_counter
    reset_counter
    set_counter
];

is($page->counter, 0, '... got the default value');

$page->inc_counter;
is($page->counter, 1, '... got the incremented value');

$page->inc_counter;
is($page->counter, 2, '... got the incremented value (again)');

$page->dec_counter;
is($page->counter, 1, '... got the decremented value');

$page->reset_counter;
is($page->counter, 0, '... got the original value');

$page->set_counter(5);
is($page->counter, 5, '... set the value');

$page->inc_counter(2);
is($page->counter, 7, '... increment by arg');

$page->dec_counter(5);
is($page->counter, 2, '... decrement by arg');

# check the meta ..

my $counter = $page->meta->get_attribute('counter');
isa_ok($counter, 'Moose::AttributeHelpers::Counter');

is($counter->helper_type, 'Num', '... got the expected helper type');

is($counter->type_constraint->name, 'Int', '... got the expected type constraint');

is_deeply($counter->handles, {
    inc_counter   => 'inc',
    dec_counter   => 'dec',
    reset_counter => 'reset',
    set_counter   => 'set'
}, '... got the right handles methods');
