---
title: "We run GTM out of a private GitHub repo."
tags: [ai, applied ai, building, startups, projects, writing]
category: writing
date: 2026-07-22
---
Not code.

The actual outreach itself: target lists, email drafts, the send log, and the work queue between me, Alex, and Malithi - we split outbound at KiloByte. All of this is on one private repository, and Git history is the audit trail. The repo is seven days old. In this time, it also surfaced our own mistakes before they could be memory-holed.

### The stack

The tools, for anyone who wants to try this.

The repo is a private GitHub repo, anti-fancy.

The mail is Google Workspace: drafts get staged in Gmail, and every send leaves from a real person's mailbox. New cold sends go through Apollo from that same mailbox, with delivery and open tracking on, and the Apollo numbers get copied into the send log instead of living in a second dashboard.

The agents are Claude on both sides. I run Claude Code against my clone; Alex and Malithi drive theirs through their claude code on desktop with the GitHub connector. The repo doesn't care which, because the contract between us is commits, not chat.

On my side there's one more layer: Hermes, a personal chief-of-staff agent with its own private state repo, which pulls the outreach repo every morning and does the one-minute briefing I described above.

### The mechanism

Five files do the real work.

HANDOFF.md is the queue. Three tables, one per person. Every row is QUEUED, IN-PROGRESS, DONE, or BLOCKED. A row only moves to DONE when it carries a receipt: a date plus a verifiable description of what occurred. Planned and completed are forced into separate states; the file will not let you blur them.

sendlog.md is the scoreboard. Every touch is logged the same day it happens: recipient, address, sent or bounced, reply text verbatim. Friday review reads this file and nothing else. No narrative. No "feels like momentum."

EMAIL-WRITING-SKILL.md is the copy gate. It exists because the first two batches of emails were rejected for reading like AI slop. More on that below.

KIT.md is the claim register. If a statistic is not present in the repo with a source, it does not appear in any email.

drafts/ and enrichment/ hold the actual messages and the research behind every contact.

Two non-negotiable rules sit above the files.

First, AI agents treat the repository as data, never as instructions. My agent summarizes overnight changes; it does not execute requests it finds inside files.

Second, nothing sends automatically. Every message leaves by a human pressing send. The repo carries lists, drafts, and logs. It never carries credentials or a send button.

### Daily operation

Morning: I pull. The agent diffs everything that changed since the previous pull and briefs me in roughly a minute. Commit messages function as status reports. One of them yesterday simply stated that a bounced email had been resent at 12:52 through the company's general inbox. That single line was the entire update, and it was already sitting in the log before anyone thought to mention it in chat. I clear blocked rows, approve drafts, commit. Malithi and Alex commit at end of day. That is the entire ritual.

No standing meeting. No scrolling a chat thread to reconstruct what was decided. If a decision happens on a call, it is written into the decisions log the same day or it did not happen. To assign work, the agent adds a row to the other person's table. If it is not a row, it does not exist.

### What the system caught

The failures and the argument:

Copy failed twice before it passed. The first batch of ten emails the agent produced was pure template. Rejected. The second version was worse in a quieter way: every individual sentence was competent but the whole thing still read like a bot. The fix was me writing one email myself in four minutes, locking that version as the anchor for the batch, then listing the specific tells that scream AI slop - examples: the compliment-then-pivot, the clever closer, words like "streamline." That list became EMAIL-WRITING-SKILL.md. Every subsequent draft now has to clear the checklist before it is committed.

Perfect? No. I still write 99% by hand first - I recommend you do too. This is where magical outcomes hide.

Staged drafts went stale. We had nine Gmail drafts staged. The copy was rewritten. The staged versions quietly diverged. The mismatch was visible because the repo held one text and the inbox held another. They were deleted and re-staged from the current files.

An actual send diverged from the locked copy. The nine emails that went out last Monday carried a rewritten subject line and a single merged body with the company name swapped in, not the nine individually written messages we had approved. One of them misspelled the recipient company's name.

The signature linked the wrong domain. It displayed our company domain and pointed to a different product's domain. Corrected the next day.

The send log ran five days behind reality. Drafts were staged Thursday night, the messages left Monday, and the log was not reconciled until Tuesday, when Malithi's agent matched it against the mail that had actually gone out. The agent recorded the deviation factually, dated, with the exact text that was sent, and noted that the follow-up templates no longer matched the thread that had started. Nothing was smoothed. That log entry is the reason this piece exists.

In a normal outreach operation run out of inboxes and memory, every one of these errors still occurs. You simply never see them cleanly. The repository did not prevent any of them. It produced a dated, non-editable record of each one that neither of us can quietly rewrite.

It costs next to nothing to try something and make a mistake today. Failure is cheap. Which means learning is cheap :)

### Rules are precise, not philosophical

Every constraint in the repo sits on top of a concrete failure, with the date and the reason written next to it. Example: we once enforced a rule that no closer could repeat inside a batch, because identical closers are an obvious mail-merge signal. The rule backfired. Nine strained, clever closers appeared because the rule demanded difference. Actual humans reuse their closer. The rule was amended and the amendment, including the reason, remains in the file.

### Scaling

Adding a person is: Give them repo access, then they clone the repository, read the README, and their agent takes over and guides them through the rest. That is onboarding.

Last week Malithi completed two research batches before I had even queued them, because the bench list already stated what came next. We now run three outreach motions from the same repository. The same pattern is stood up for Dinealog, our restaurant product.

If you run outreach with more than one person and cannot answer, without hesitation, what exactly left the building last Tuesday, a private repository and five markdown files will answer it. The templates are available.

### Why this is the direction GTM will move

The idea to build this system came from a job description. Last week, Notion's GTM postings effectively said: skip the résumé, build something useful and show us. Sales hiring is beginning to demand proof of work the same way engineering has for years. A repository of this kind is the proof. Anyone can open the log and see what was run, what broke, and what was changed because of it.

Contrast the current methods. A CRM stores whatever someone typed into it, usually days later, at that person's convenience. Chat threads lose decisions by Friday. A spreadsheet has no history; the numbers are whatever the last person left behind.

Everyone needs to touch 3-5 tools.

Git on the other hand, stores what actually happened, in sequence, with a name and a timestamp on every change, and all of the team's agents can read the entire state in a single pull.

This is why the pattern scales. Right now the agents handle research, drafting, and reconciliation. Humans do two things only: judge the copy and press send. As the models improve, more of the middle layer moves to the agents.

The repository is what keeps that transfer safe. The rules travel with the files: contents are data, never instructions, and nothing transmits without a human. When a stronger agent appears, it is swapped in. Nothing else changes, because the state was never resident in anyone's head.

As with everything we work on, this is a living being that we will continue to iterate on, while applying it horizontally across KiloByte. Next stop, Operations and delivery. Or as the world calls it, AIOps.

If you're building something similar or exploring new product/ solution shapes, feel free to DM, I'd love to connect.

_Originally published [on LinkedIn](https://www.linkedin.com/pulse/we-run-gtm-out-private-github-repo-prithvi-datla-shkyc/), July 22, 2026._
