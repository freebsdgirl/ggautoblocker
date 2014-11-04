#!/usr/bin/perl -w

use strict;

use Net::Twitter;

# Needs read/write access!

my $consumer_key = "";
my $consumer_secret = "";

my $access_token = "";
my $access_secret = "";

my @idiots = ( "CHSommers", "AdamBaldwin", "Nero", "FartToContinue", "PlayDangerously" );
#my @idiots = ( "FartToContinue", "PlayDangerously" );
my @whitelist = ( "gamergatetxt" );

my $debug = 1;

my ( @follower_ids, @myfollower_ids, @shared_ids, @shared_names, @sheeple_ids, @sheeple_names );


# set up our twitter connection
my $nt = Net::Twitter->new(
	traits			=> [qw/API::RESTv1_1/],
	ssl			=> 1,
	consumer_key		=> $consumer_key,
	consumer_secret		=> $consumer_secret,
	access_token		=> $access_token,
	access_token_secret	=> $access_secret
);


# check our rate limits.
# this would probably be better off stored in a hash whose values are monitored by
# this program so we didn't have to make this call so often, but whatever.
sub get_rate_limit {
	my $type = shift;

	my $m = $nt->rate_limit_status;

		if ( $m->{'resources'}->{'application'}->{'/application/rate_limit_status'}->{'remaining'} == 0 ) {
			print " -- API limit reached, waiting for ". ( $m->{'resources'}->{'application'}->{'/application/rate_limit_status'}->{'reset'} - time ) . " seconds --\n" if $debug;
		sleep ( $m->{'resources'}->{'application'}->{'/application/rate_limit_status'}->{'reset'} - time + 1 );
	}

	if ( $type =~ /followers/ ) {
		return { 
			remaining => $m->{'resources'}->{'followers'}->{'/followers/ids'}->{'remaining'}, 
			reset => $m->{'resources'}->{'followers'}->{'/followers/ids'}->{'reset'} 
		};
	} elsif ( $type =~ /lookup_users/ ) {
		return {
			remaining => $m->{'resources'}->{'users'}->{'/users/lookup'}->{'remaining'},
			reset => $m->{'resources'}->{'users'}->{'/users/lookup'}->{'reset'}
		};
	}
}


# sleep until the reset is happy again.
sub wait_for_rate_limit {
	my $type = shift;

	my $limit = get_rate_limit($type);

	if ( $limit->{'remaining'} == 0 ) {
		print " -- API limit reached, waiting for ". ( $limit->{'reset'} - time ) . " seconds --\n" if $debug;
		sleep ( $limit->{'reset'} - time + 1 );
	}
}


# get a list of followers
sub get_followers {
	my $screen_name = shift;
	my @followers;

	for ( my $cursor = -1, my $r; $cursor; $cursor = $r->{next_cursor} ) {
		wait_for_rate_limit('followers');

		if ( $screen_name ) {
			$r = $nt->followers_ids({ screen_name => $screen_name, cursor => $cursor });
		} else {
			$r = $nt->followers_ids({ cursor => $cursor });
		}	

		push @followers, @{$r->{ids}};
	}

	return @followers;
}


# get screen_names to go along with the account ids.
sub get_screen_names {
	my $user_ids = shift; 
	my @ids = @$user_ids;
	my @names;

	while ( $#ids > 0 ) {
		wait_for_rate_limit('lookup_users');

		my @subset_ids = splice @ids, 0, 100;
		my $users = $nt->lookup_users( { user_id => \@subset_ids } );

		foreach my $user ( @{$users} ) {
			push @names, $user->{'screen_name'};
		}
	}

	return @names;
}


# is username in whitelist?
sub is_whitelisted {
	my $sheep = shift;

	if ( @whitelist ) {
		foreach my $notasheep ( @whitelist ) {
			return 1 if $notasheep =~ $sheep;
		}
	}

	return 0;
}



print "This is going to take a while, because API limits are dumb.\n\n";
$| = 1;


# first, get a list of the IDs of all the problem children. 
foreach my $idiot ( @idiots ) {
	print "Examining follower list for $idiot.\n";
	push @follower_ids, get_followers( $idiot );
}


# get a list of our personal followers
print "Getting a list of my followers for comparison.\n";
@myfollower_ids = get_followers;


# get a list of unique IDs.
print "Examining follower lists...\n";


# if the sheeple is following us, don't put it in the main array. put it in
# a separate data structure. This is to keep ourselves from doing excessive
# API calls later when we're checking usernames.
my %seen;
foreach my $id (@follower_ids) {
	if ( $seen{$id} ) {
		my $found = 0;

		# does this id exist in our followers?
		foreach my $my_id ( @myfollower_ids ) {
			if ( $my_id == $id ) {
				push @shared_ids, $id;
				$found = 1;
			}
		}

		push @sheeple_ids, $id if $found == 0;

	} else {
		$seen{$id} = 1;
	}
}

# print out some stats
print "> $#follower_ids users following idiots.\n";
print "> " . ($#sheeple_ids + $#shared_ids ) . " users following multiple accounts.\n";
print "> $#shared_ids users following me.\n";


# save ids to file if we're debugging
if ( $debug ) {
	print "Saving list of IDs to block_ids.txt.\n";
	open BL, '>block_ids.txt' or die "Can't open block_ids.txt: $!\n";
	foreach ( @sheeple_ids, @shared_ids ) {
		print BL "$_\n";
	}
	close BL;
}


# turn IDs into usernames.
print "Getting list of usernames from IDs.\n";

@sheeple_names = get_screen_names(\@sheeple_ids);
@shared_names = get_screen_names(\@shared_ids);


# save to a file, but only if they aren't part of the whitelist.
print "Saving list of usernames to block_names.txt.\n";
open BL, '>block_names.txt' or die "Can't open block_names.txt: $!\n";
foreach my $sheep ( @sheeple_names ) {
	next if is_whitelisted( $sheep );

	print BL "$sheep\n";
}
close BL;

print "Saving list of my suspect followers usernames to shared_names.txt.\n";
open BL, '>shared_names.txt' or die "Can't open shared_names.txt: $!\n";
foreach my $sheep ( @shared_names ) {
	next if is_whitelisted( $sheep );

	print BL "$sheep\n";
}
close BL;

# TODO: actually block the user!
# $nt->create_block( { user_id => $id } )

# TODO: do we want to look at account stats for these users? maybe limit by f:f ratio/acct creation date?
# otherwise users like hootsuite are going to get blocked.
