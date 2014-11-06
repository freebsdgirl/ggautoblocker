# GG auto blocker

#### Intro

Takes a list of the supposed ringleaders of GG, looks at their follower lists. Generates a list of sheeple following more than one account, as well as a list of your followers that might be questionable.

This does not rank users. It doesn't look at bios, it doesn't look at hashtags. But GamerGate appears to be completely useless at figuring out github when it's not just a wiki explaining how to be shitheads, so they'll probably never read this README and figure that part out.

#### Dependencies

Requires Net::Twitter which has a huge level of crazy deps.

If you add CHSommers or Adam Baldwin back to the list of users, it's going to take a really long time to run because of API limits. Ugh. Literally the worst, Twitter. Be less annoying.

#### TODO

Doesn't actually block users yet, but creates a list of users to block.

#### Frequently Yelled Statements

##### This is censorship!

No, it's not. I'm not preventing you from speaking. I just don't have to listen.

##### I am not a high enough number on the list. I want to be #1!

Well, princess, if you try to exercise your powers of observation, the list is alphabetically sorted.

##### How do I get added to the list?

Follow one of the idiots. Submitting a pull request to get added to the list does nothing.

##### How do I remove myself from the list?

Submit a pull request to add yourself to the whitelisted users. I'll review your account and add you if you don't appear to be a miserable excuse for a human being. I've made this easier, as there's now a whitelist.txt file. Create pull requests against this file. 

##### You just don't want to have a healthy discussion!

Well, kiddos, I tried. But after 22k tweets thrown at me in one month by accounts that appeared to have all the reading comprehension of a jar of peanut butter, I'm throwing in the towel. Sometimes, I want quiet time. Your right to be heard is not greater than my right to not be harassed. Sometimes, I just want to play video games and not have all you rabid sheeple flooding my mentions with hate. It happens more than you might think. If the discussion was actually that healthy, by the way, I wouldn't be keeping a tally of threats of rape, death, and violence. 

##### But I don't want to be blocked!

Tough. I want twitter to be what it used to be before you sockpuppet chan idiots wandered in and tried to ruin everything. So I'm taking it back.

##### Why doesn't the bot actually block yet?

Because I need to talk to twitter about how to best implement a way to toggle the blocking of large amounts of users. There are specific ToS for this, and I want clarification before I go implementing anything that might violate ToS. It's my intention to allow a mechanism to block/unblock this list.

##### This is hate speech!

It's really not.

##### I'm going to report your GitHub account for abuse!

Go ahead. Several already have. Good luck with that.

##### Some of these people are moderates and not strongly GG and haven't threatened anyone! / Some of these people have nothing to do with GG!

That's true. Because of the rate limitations of the API, I don't have a lot to work with. This isn't a definitive list of GG supporters, and it was never meant to be. I took a list of people that seemed to always have a fog of idiot hate spewing fanboys around them, and I decided that anyone that followed more than one of them was probably not someone I wanted to interact with.

##### I'm going to fork your code and use it to block anti-GGers!

Cool. This code is BSD Licensed, so you're free to do whatever you want with it.
