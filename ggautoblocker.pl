#!/usr/bin/perl -w

use strict;

use Net::Twitter;

# Needs read/write access!

my $consumer_key = "";
my $consumer_secret = "";

my $access_token = "";
my $access_secret = "";

#my @idiots = ( "CHSommers", "AdamBaldwin", "FartToContinue", "PlayDangerously" );
my @idiots = ( "FartToContinue", "PlayDangerously" );
my @whitelist = ( "gamergatetxt" );
my @blacklist; 

my @sheeple_ids;
my @sheeple_names; # add any other users you want blocked here 

my $nt = Net::Twitter->new(
	traits			=> [qw/API::RESTv1_1/],
	ssl			=> 1,
	consumer_key		=> $consumer_key,
	consumer_secret		=> $consumer_secret,
	access_token		=> $access_token,
	access_token_secret	=> $access_secret
);

print "This is going to take a while, because API limits are dumb.\n\n";
$| = 1;

# TODO: ironically, the rate limit to check rate limit status is a bit low. So I may need to tweak this a bit.
foreach my $idiot ( @idiots ) {
	print "Examining follower list for $idiot.";

	for ( my $cursor = -1, my $r; $cursor; $cursor = $r->{next_cursor} ) {
		my $m = $nt->rate_limit_status();

		if ( $m->{'resources'}->{'followers'}->{'/followers/ids'}->{'remaining'} == 0) {
			while (time <= $m->{'resources'}->{'followers'}->{'/followers/ids'}->{'reset'}) {
				sleep 1;
			}
		}

		$r = $nt->followers_ids({ screen_name => $idiot, cursor => $cursor });
		push @blacklist, @{$r->{ids}}; 
		print ".";
		sleep 1;
	}

	print " done.\n";
}


# get a list of unique usernames.

print "\nExamining follower lists...\n";

my %seen;
foreach my $id (@blacklist) {
	if ( $seen{$id} ) {
		push @sheeple_ids, $id;
	} else {
		$seen{$id} = 1;
	}
}

print "> $#blacklist users following idiots.\n";
print "> $#sheeple_ids users following multiple accounts.\n";

print "Saving list of IDs to block_ids.txt.\n";
open BL, '>block_ids.txt' or die "Can't open block_ids.txt: $!\n";
foreach ( @sheeple_ids ) {
	print BL "$_\n";
}
close BL;



# lookup usernames. limited to 100 users per request, 1000 calls per hour.

print "Getting list of usernames from IDs.";

# TODO: need to check rate limit for this, although it's pretty damn high. But need to fix rate limit
# request rate limiting (heh!) first.
while ( $#sheeple_ids > 0 ) {
	my @ids = splice @sheeple_ids, 0, 100;
	my $sheeple = $nt->lookup_users( { user_id => \@ids } );

	foreach my $sheep ( @{$sheeple} ) {
		push @sheeple_names, $sheep->{'screen_name'};
	}
	print ".";
}
print " done.\n";

print "Saving list of usernames to block_names.txt.\n";
open BL, '>block_names.txt' or die "Can't open block_names.txt: $!\n";
foreach my $sheep ( @sheeple_names ) {
	if ( @whitelist ) {
		foreach my $notasheep ( @whitelist ) {
			next if $notasheep =~ $sheep;
		}
	}

	print BL "$sheep\n";
}
close BL;

# TODO: actually block the user!
# $nt->create_block( { user_id => $id } )

# TODO: do we want to look at account stats for these users? maybe limit by f:f ratio/acct creation date?
# otherwise users like hootsuite are going to get blocked.
