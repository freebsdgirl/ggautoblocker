# GG auto blocker

#### Intro

Takes a list of the 5 major idiots of GG, looks at their follower lists. Generates a list of sheeple following more than one account, as well as a list of your followers that might be questionable.

#### Dependancies

Requires Net::Twitter which has a huge level of crazy deps.

If you add CHSommers or Adam Baldwin back to the list of users, it's going to take a really long time to run because of API limits. Ugh. Literally the worst, Twitter. Be less annoying.

#### TODO

Doesn't actually block users yet, but creates a list of users to block.

#### Bugs

Currently creating duplicate users in list, so needs to be run through uniq. My logic is broken somewhere. I'm tired, will fix later.
