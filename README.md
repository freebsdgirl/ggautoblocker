# GG auto blocker

Please see http://blog.randi.io/good-game-auto-blocker/ for a more updated version of this README.

### history

A major problem with social media is the lack of flexible filtering controls. Twitter has a block mechanism, but a user has to initiate contact in order to be blocked. For most forms of harassment, this is an effective way of moderating conversations. Unfortunately, as more social campaigns use Twitter as their basis for communications, this approach becomes less effective. While it’s suitable for use against a single harasser, it’s useless against a large number of accounts targeting a single user. These tweets needed to be stopped before they land in the user’s notifications.

### how it works

Good Game Auto Blocker compares the follower lists for a given set of Twitter accounts. If anyone is found to be following more than one of these accounts, they are added to a list and blocked.

Most discussions of ggautoblocker are referencing the GamerGate-specific block list. The GamerGate block list filters the majority of Twitter interactions by GamerGate supporters. This list is maintained and shared by the author, Randi Harper, as well as a number of volunteers. The previous version of ggautoblocker can be found at [freebsdgirl/ggautoblocker](http://github.com/freebsdgirl/ggautoblocker/), but a complete rewrite is underway. Newer versions will be published on [OAPI's github](http://github.com/oapi/ggautoblocker).  

### dependencies for running the old code manually

Requires Net::Twitter which has a huge level of crazy deps.

---

THE REST OF THIS PAGE REFERS TO THE SHARED GAMERGATE BLOCK LIST.


### how to use it

[Subscribe](https://blocktogether.org/show-blocks/5867111278318bd542293272f75147f8fc5931bea431e7ca16e9242964965d66494a6fb68f3518b82f171bcf0e419ccc) to the blocklist. Subscribers will automatically receive the updates.

### are you on it

The easiest way to check if you’re on the block list is to verify if [@randi_ebooks](http://twitter.com/randi_ebooks) is blocking you. This is the account that maintains and shares the block list. (This account is a markov bot that is not monitored by a human, so please don’t direct any questions at it.)

The block list is periodically re-generated and updated. Each update is announced with at least 24 hours advance notice by the [@ggautoblocker](http://twitter.com/ggautoblocker) Twitter account.

### appealing a block

After reviewing the [appeals board policy guidelines](https://docs.google.com/document/d/14iu4XVTKw2tSAlv3x8ktxQfz550bB_EtoUjNYIdPCpk/edit), send an [email](mailto:appeals@ggautoblocker.com) with your twitter username as well as any relevant information you believe they should know. [All requests and discussions are public](https://groups.google.com/forum/#!forum/ggautoblocker-appeals). You will be contacted when a decision has been made.

The maintainer of this block list is not a member of the appeals board and will not remove blocks without appeals board approval.

### contacting support

Please read the README and check out the latest version of [Frequently Yelled Statements](http://blog.randi.io/good-game-auto-blocker/frequently-yelled-statements/). Submit support requests via the [Contact page](http://blog.randi.io/contact/).

### what’s next

While the community version on github has been written in perl, it’s not going to be developed any further. Instead, there’s a new version written in ruby that will soon be open sourced.

### how you can help

After 15 years in engineering, I left to spend my time working on anti-harassment tools, policy, and education. I co-founded a (soon-to-be) non-profit, the [Online Abuse Prevention Initiative](http://onlineabuseprevention.org/). Until OAPI is further off the ground and able to receive funding, donations to my personal [Paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=donations%40ggautoblocker%2ecom&lc=US&item_name=ggautoblocker&no_note=0&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHostedGuest) or [Patreon](http://www.patreon.com/freebsdgirl) are always appreciated. I am currently 100% crowd-funded.

There are currently no spots open on the appeals board, but watch this space.

The code (though not the service) is currently in the process of being transitioned over to being managed by OAPI, so we’re not looking for any new developers yet.

A step-by-step guide for setting up the ggautoblocker GamerGate blocklist with screenshots would be immensely helpful. We want instructions that a user completely new to Twitter would be able to follow. If you’d like to put that together, email or use the Contact page to submit a draft.

