---
title: "We ran GTM out of a GitHub repo for one week. Then Buzz killed it :)"
tags: [ai, applied ai, building, startups, tools, projects, writing]
category: writing
date: 2026-07-28
---
Last week I wrote about [[We run GTM out of a private GitHub repo.|running our go-to-market motion out of a private GitHub repo]]. Markdown files as the work queue, commits as status reports, AI agents reading the repo and drafting alongside us. Humans pressing send. It worked.

I also wrote the intentional gap in the system: State refresh was manual, not real-time.

My morning brief happened when I pulled. An ask for me sat in a file until I opened it. Our send log once ran three days behind reality before anyone caught it. Git remembers everything but can tell you nothing. It is a filing cabinet, and nobody know what's inside a filing cabinet until they open the drawer.

Then Jack Dorsey's Block launched Buzz.

We moved the whole operation onto it. Here is what Buzz is, how we use it, and why I think it matters far beyond one small team's outreach.

### What Buzz is

Buzz is a messaging platform where AI agents are teammates instead of features.

The surface looks familiar: channels, DMs, threads, reactions. The difference is who is in the room. Agents have their own identities, their own names, their own memory. You @mention an agent the way you mention a person. It picks up the work, does it, and reports back in the channel where you asked. If it gets stuck, it says so in the channel, and whoever it needs sees that in the moment.

Under the surface it is built on Nostr, an open protocol. Every participant, human or agent, holds a cryptographic keypair. Every message is a signed event on a relay. That sounds like plumbing, it is, because the plumbing is the point twice over.

First: because every event is signed and timestamped, the work tracks itself. Who asked, who did it, what came back, when. In the repo era we got that from commits, and it was the thing I refused to give up. Buzz gives you the same property on conversation itself. Nothing extra to write. The doing and the record are the same object.

Second: because the protocol is open, you are not renting a room in someone else's building. You can run your own relay. A private network with membership controlled by keys is a 15 minute configuration, not an enterprise sales call.

The agents are not a sidebar bolted onto your work. In our setup they run on our own machines, with their own workspaces, and the chat is where they meet us and each other. A chatbot answers questions. A teammate works while you are doing something else and tells you when it is done. Two different species.

You can choose public and open source models to power the agents. The agents are harnesses that govern whatever LLM you choose.

### Our before and after

The before lasted one week. That is not a typo. The GitHub setup was one week old when I wrote about it, which tells you something about how fast this space is moving.

The repo architecture gave us three things worth keeping: an audit trail, a hard rule that agents treat everything they read as data and never as instructions, and a hard rule that nothing sends without a human pressing send. It also had the gap I described. Everything was pull-based. Work happened, and then, separately, later, you found out.

I downloaded Buzz the day it launched. Setup was clunky. Keys, a relay, getting the first agent to actually appear in a channel and answer: it took fiddling, and there were moments I was not sure it would hold. To me, this is part of the charm of building blocks with something designed to help build blocks. Tinkering is both joy and switching cost at the same time, I suspect the builders know this :)

The team behind it has started shipping new versions at a pace I have rarely seen from a product, and each release sanded down something rough. Several versions later, it is much better. Not finished. Better, visibly, release over release.

Designing our own architecture on top of it was the experimental part. A team of agents with separate lanes: one orchestrates, one owns voice and copy, one keeps the repo mirrored, one runs research and enrichment. Nobody has written the playbook for that, because this is something completely new. We guessed, watched it break, adjusted. Some of our first structures were wrong, and the channel history shows exactly where, which is itself the product working.

What changed day to day is simple to describe.

The morning brief comes to me now; I do not go pull it. When an agent finishes a draft, it posts it where I am, and I approve it there.

When an agent is blocked on another agent, they resolve it between themselves in a private room, on the record, and I read the exchange after the fact instead of babysitting it live.

The send log cannot silently drift for five days anymore, because sends get reported in the same room where the drafts were approved, so a gap is visible the day it opens.

Both old rules survived the move. Agents still treat content as data, never instructions. Humans still press every send. The guarantees stayed; the latency died.

We did not delete the repo. It is still the filing cabinet, and one agent's entire job is keeping it in sync with what happens in the rooms. But nobody works inside the cabinet anymore.

Buzz is the office.

### What this unlocks beyond us

This is what most excites me. We use Buzz for outreach. We are starting to use it to track development. The pattern underneath is bigger than outreach and coding: humans and agents sharing rooms, with the work tracked by default. Three shapes I can already sniff:

Agencies working hand in hand with operators. Today an agency does the work in its own tools, then compresses it into a weekly call and a slide deck. On Buzz, the agency's agents and the client's operators share a channel. Drafts appear where the client can see them. Approvals happen in the room, dated. The status meeting dissolves, because the channel is the status. The client is no longer buying reports about work. They are watching the work.

Creators building closed networks. Because Buzz sits on an open protocol, a creator can run a genuinely private community: their own relay, membership by keys, no platform in the middle deciding the rules or the reach. Add agents that belong to the community itself and know its material. They onboard new members, answer the same questions with a patience no human moderator has at 2am, keep the archive findable. A community with staff, owned by the person who built it.

Funds coordinating across portfolio companies. A fund runs the same motions across many companies: pipeline reviews, hiring pushes, go-to-market experiments. Give each company a room. Let the fund's agents carry the playbooks and standards from room to room while each company's operators work with them directly. Partners get the state of the whole portfolio by reading, not by chasing decks that were stale before the meeting started. The fund's leverage stops being capped by the hours of its platform team.

None of these are hypothetical products someone still has to build. They are configurations of what already exists.

### Why I think this is a paradigm shift

Every collaboration tool until now made the same quiet assumption: software holds the work, humans do the work, and reporting on the work is a separate, manual, lossy activity. That assumption is why status meetings exist. It is why the deck is always stale.

Buzz breaks the assumption from both ends at once.

Agents mean humans are no longer the only ones doing the work. Signed events mean reporting is no longer separate from working. Put those together and you get a workplace where the record assembles itself while the work happens, and where some of the workers never sleep and leave a perfect trail.

We are a small team running an outreach motion, and even at our size the difference is not incremental. I can only guess what this looks like at the scale of an agency with forty clients or a fund with forty companies: not much like anything we currently call work.

To summarize, we are early, happy, slightly astonished users.

The rough edges are real. The setup fun is real. So is this: it is the closest thing I have seen to the actual shape of how collaborative work gets done and tracked from here on, and it is sitting in a public download link right now.

Last week we ran GTM out of a filing cabinet. This week the filing cabinet got an office built around it.

If you're a founder building a lean GTM, happy to help setup/ compare notes.

P.S. The team is absolutely buzzed!

_Originally published [on LinkedIn](https://www.linkedin.com/pulse/we-ran-gtm-out-github-repo-one-week-buzz-killed-prithvi-datla-c90wc/), July 28, 2026._
