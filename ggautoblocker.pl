#!/usr/bin/perl -w

use strict;

use Net::Twitter;

# Needs read/write access!

my $consumer_key = "";
my $consumer_secret = "";

my $access_token = "";
my $access_secret = "";

my $blacklist_file = "blacklist.txt";
my $whitelist_file = "whitelist.txt";

my $debug = 1;

my ( @whitelist, @idiots );

my %problem;

my ( @follower_ids, @myfollower_ids, @sheeple_ids );


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
	my $sheeple = shift;
	my @ids = keys %$sheeple;
	my @names;

	while ( $#ids > 0 ) {
		wait_for_rate_limit('lookup_users');

		my @subset_ids = splice @ids, 0, 100;
		my $users = $nt->lookup_users( { user_id => \@subset_ids } );

		foreach my $user ( @{$users} ) {
			$sheeple->{$user->{'id'}}->{'name'} = $user->{'screen_name'};
		}
	}

}


# is username in whitelist?
sub is_whitelisted {
	my $sheep = shift;
        return 0 unless $sheep;

	if ( @whitelist ) {
		foreach my $notasheep ( @whitelist ) {
			return 1 if $notasheep =~ $sheep;
		}
	}

	return 0;
}


# get a list of whitelisted users
open W, '<', $whitelist_file or die "Can't open $whitelist_file: $!\n";
foreach ( <W> ) {
	chomp;
	push @whitelist, $_;
}
close W;


# get a list of idiots
open B, '<', $blacklist_file or die "Can't open $blacklist_file: $!\n";
foreach ( <B> ) {
	chomp;
	push @idiots, $_;
}
close B;



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
foreach my $id (@follower_ids) {
	if ( exists $problem{$id} ) {
		$problem{$id}->{'count'}++;
	} else {
		$problem{$id}->{'count'} = 1;

		# does this id exist in our followers?
		foreach my $my_id ( @myfollower_ids ) {
			if ( $my_id == $id ) {
				$problem{$id}->{'stalker'} = 1;
			}
		}
	}
}

# print out some stats
# BUG! these numbers aren't accurate. plzfix.
@sheeple_ids = keys %problem;
print "> $#follower_ids users following idiots.\n";
print "> $#sheeple_ids users following multiple accounts.\n";


# save ids to file if we're debugging
if ( $debug ) {
	print "Saving list of IDs to block_ids.txt.\n";
	open BL, '>block_ids.txt' or die "Can't open block_ids.txt: $!\n";
	foreach my $monster ( keys %problem ) {
		if ( $problem{$monster}->{'count'} == 1 ) {
			delete $problem{$monster};
		} else {
			print BL "$monster\n";
		}
	}
	close BL;
}

# turn IDs into usernames.
print "Getting list of usernames from IDs.\n";

get_screen_names(\%problem);


# save to a file, but only if they aren't part of the whitelist.
print "Saving list of usernames to block_names.txt & shared_names.txt\n";
open BL, '>block_names.txt' or die "Can't open block_names.txt: $!\n";
open SL, '>shared_names.txt' or die "Can't open shared_names.txt: $!\n";
foreach my $sheep ( keys %problem ) {
	next if is_whitelisted( $problem{$sheep}->{'name'} );
	next unless exists $problem{$sheep}->{'name'};
	next unless exists $problem{$sheep}->{'count'};

	print BL $problem{$sheep}->{'name'}."\n";

	if ( exists $problem{$sheep}->{'stalker'} ) {
		print SL $problem{$sheep}->{'name'}."\n";
	}
}
close BL;
close SL;


# TODO: actually block the user!
# $nt->create_block( { user_id => $id } )

# TODO: do we want to look at account stats for these users? maybe limit by f:f ratio/acct creation date?
# otherwise users like hootsuite are going to get blocked.
