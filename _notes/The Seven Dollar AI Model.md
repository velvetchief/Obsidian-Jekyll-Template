---
title: "The Seven Dollar AI Model: A Two-Day Fine-Tuning Experiment and AI Economics"
tags: [ai, applied ai, building, projects, writing]
category: writing
date: 2026-07-19
---

![[1.jpg]]

_Claude Opus 4.8 vs Inkling, Kimi K2.6, Qwen3.5 4B, fine tuned on Tinker._

## The short version

- The weekend of July 18th, I ran a bake-off: three open models, each fine-tuned for seven dollars or less, against a carefully prompted Claude Opus on one unglamorous job. Read a Texas government RFP, pull every requirement into a compliance matrix.

- Before training anything I hand-labeled 438 requirements across three contracts and locked them away as the answer key. Round one, nobody beat Claude across the board, and the reason had nothing to do with model choice: the frontier model that wrote the training examples (the teacher) had silently missed a third of the requirements, and every student inherited its blind spots. I fixed the training data, changed nothing else, and all three models passed Claude. The winner scored 0.57 to Claude's 0.52.

- Costs. The winning model runs at $3.30 per contract against Claude's $4.70. A small model two points behind runs at 22 cents. Self-hosting the winner would cost $25,000 a month, which is absurd at low volumes. On a live solicitation, the full pipeline took twenty minutes to say: 189 requirements, we can prove 8, partially cover 29, and have no evidence for 152. Partner or pass.

The rest of this article is the story with the numbers attached: what actually broke along the way (the PDFs and the homework, never the models), the deployment arithmetic, and the situations where I would still just prompt Claude.

## Part 1: The Why

### The task

When a government agency wants to buy something, it publishes an RFP, a request for proposals, usually between 20-100 p. Buried in its many pages are the sentences that can disqualify a bidder: "the Respondent must," "the Contractor shall," a deadline, an insurance requirement, a form that has to be signed a particular way.

Proposal teams extract every one of those sentences into a compliance matrix: a table of each requirement, where it appears, what type it is, and whether the bidder can meet it. It is the least glamorous document in government contracting and the one that decides whether a bid survives first contact. Building one by hand takes a skilled person most of a day per contract.

I wanted this table produced by a machine, and I wanted to know something more valuable than whether it could be done.

### The real question

The obvious way to automate this is to send each contract to a frontier model like Claude with a well-written prompt. That works, sort of, and you will see exactly how well below.

But it commits you to a specific future: every document you process, forever, flows through someone else's API at someone else's prices. For public RFP text that is fine. The problem arrives at step two, when you ask "can WE meet this requirement?" Answering that means showing the model your company's private history: past bids, security posture, what you have actually shipped. That is not text I want leaving the building as a habit.

So the real question was: **can a model whose weights I control learn this one narrow task well enough to beat the best closed model at it?** If yes, the privacy problem and the cost problem both shrink dramatically.

### The bet, stated before running anything

My hypothesis: _For a narrow, repeatable document task, a small amount of fine-tuning on open models beats prompting the best closed model, at a fraction of the deployed cost._

And the falsifier, written down in advance: if the fine-tuned models could not beat a well-prompted Claude on contracts they had never seen, I would publish that result instead. A bet you cannot lose is not a bet.

\*\*An _open model_ is one whose weights (the billions of numbers that make it work) you can download and run yourself. _Fine-tuning_ means continuing a model's training on your own examples so it gets better at your specific task. I used _LoRA_, a technique that trains a small attachment on top of the frozen base model rather than rewiring the whole thing. This is also why my cost to train was seven dollars and not seven thousand. Picture a giant reference book you are not allowed to reprint: the fine-tune is a thin booklet of corrections clipped to the cover. LoRA trains well under 1% of the model's numbers and never touches the rest. The book is a terabyte. The booklet is megabytes, and the booklet is all you pay to create.

## Part 2: The How

### Evals before everything

The single best decision of the project happened before any training: I built the measuring stick first.

I hand-labeled three contracts, sentence by sentence, into answer keys: a small one (54 requirements), a medium one (181), and a 74-page monster (203). That is 438 requirements checked by a human. Those three contracts were locked away. No model ever trained on them. They exist only to grade.

Scoring is deterministic code, not another AI's opinion. A model's row counts as "found" if it lands in the right section with enough word overlap against the answer key. Two numbers matter: **recall** (of the real requirements, what share did you find?) and **precision** (of the rows you produced, what share were real?). A model that misses half the requirements fails quietly. A model that invents rows fails loudly. You need both numbers to see either failure.

### The contestants and the fairness rule

Four models, one job:

- **Claude Opus**, Anthropic's flagship, carefully prompted with a worked example. Closed weights, so it cannot be fine-tuned. It sets the bar.
- **Qwen 3.5-4B**, a small open model. The "can cheap win?" entry.
- **Moonshot AI Kimi K2.6**, a huge open mixture-of-experts model (a trillion parameters, of which 32 billion activate per word).
- **Thinking Machines Lab Inkling**, Thinking Machines' brand-new model, three days old when the project started.

The three open models were fine-tuned on Tinker, a managed training platform, with one strict fairness rule: **identical training data, identical recipe, identical test harness. Only the model changes.** Kimi 3 and GLM 5.2 were not available on Tinker at the time of this work.

![[Screenshot 2026-07-18 at 9.50.54 AM.png]]


### Where the training data came from

Fine-tuning needs examples. I had eleven other contracts (separate from the three answer keys), and Claude acted as the "teacher": it produced draft compliance matrices for those eleven, and the open models trained on its output.
Notice the beauty in the setup. The students learn from the teacher's homework, then try to beat the teacher on a locked exam.

Training cost per model: about 1.4 million tokens, four passes over the data, 36 steps. On the winning model that came to roughly seven dollars. Not seven thousand. Seven.

## Part 3: What broke, and how it was fixed

This section is the actual learning material. The results table gets the applause, but these failures are where the two days went, and every one of them seems common.

### Failure 1: models that think themselves to death

Un-tuned, the open models' signature failure was reasoning out loud until they ran out of room. One filled 100,000 characters with notes to itself ("Page 15: ... Deadline. Skip.") and died before writing a single row of actual output. Score: zero.

**The fix was not a better prompt.** I tried. The fix was fine-tuning on examples that contain no visible reasoning at all. After one round of tuning, every model started its answer with structured data at character zero. Lesson: some behaviors are trained in or out, not instructed in or out.

### Failure 2: the document itself is hostile

Government PDFs stamp a version footer on every page. That footer leaked into extracted requirement text and even into due-date fields. Page breaks cut sentences in half. List markers masquerade as section numbers. Headings glue themselves onto the text below.

Roughly a third of my hand-labeling time went to cleaning artifacts like these, not to judgment calls about requirements. **Budget for this.** In document AI, the fight with the PDF is half the project, and nobody puts it on the slide.

### Failure 3: degenerate output

One tuned model developed a stutter: on some inputs it locked into repeating the same row hundreds of times, like a skipping record. The fix was a harness guard that detects the repetition and re-asks the question with more randomness. All affected runs recovered. Lesson: production AI pipelines need seatbelts around the model, because the model will occasionally do something absurd.

### Failure 4: the teacher's blind spots became everyone's ceiling

After round one, all three tuned models were stuck in the same recall band. They found more than Claude on the hardest contract, but nobody could break past finding about half the requirements.

Round two changed **nothing about the training recipe**. Same settings, same steps. I only fixed the homework: re-graded the teacher's labels against rules learned from hand-checking, then went hunting, with a dumb high-recall sentence extractor plus review, for requirement sentences the teacher had missed entirely.

That hunt found 586 real requirements the training data did not have. The training set grew by half.

Sit with that: one of the best models in the world, doing its best work as a teacher, had silently missed about a third of the requirements in its own training material. Every student inherited those blind spots. The ceiling I kept hitting was never the models. It was the data.

_**If you remember one sentence from this piece: iterate on your data before you iterate on anything else.**_

## Part 4: The Findings

### The scoreboard

Same locked-away contracts, after round two. Recall / precision per contract, then the average balanced score (F1). Kimi K2.6 is the winner.

> [!note] Placeholder
> Scoreboard table image goes here (from the original article).

Every tuned model edges Claude on the balanced score. Kimi K2.6 wins the bake-off, beating Claude outright on two contracts and tying its recall on the third. The bet survived, but only in round two, and only after the data got fixed.

Claude keeps exactly one crown, and it matters: precision. 91% on the medium contract is untouchable. When Claude writes a row, that row is almost always real. If your workflow punishes false rows more than missed ones, prompted Claude is still the right pick.

_**Important note:**_ the best model finds about half the requirements. This is a draft accelerator that saves a person most of a day. It is not a person.

### The live test

Numbers on held-out contracts are one thing. So I ran the full pipeline on a live solicitation from a Texas state agency, one the models had never seen in any form, posted this month with a September due date.

Twenty minutes later: 189 requirements extracted, each quoted verbatim with its section number, and each checked against my firm's own capability library. The check works like an open-book exam with a librarian: for each requirement, a local search fetches the few most relevant paragraphs from the firm's own documents, and the fine-tuned model rules met, partial, or gap, citing the exact paragraphs or admitting there are none. Verdict: we can prove we meet 8 today, partially cover 29, and have no evidence for 152.

That last number is the product. It says, in one automated pass, that this is a bid to partner on or walk away from. The 37 non-gap rows are the exact paragraphs a proposal writer would reuse.

Privacy design is hybrid here. The pipeline is split: public RFP text may touch public APIs, but the capability library, the record of everything the firm has bid and shipped, is only ever read by the fine-tuned model, running on infrastructure where the weights are mine.

I audited the verdicts by hand. In 189 judgments the private model made one real mistake (it matched a coincidental date and called it evidence). Elsewhere it was conservative in exactly the right direction, refusing to count administrative paperwork as capability and flagging placeholder text in our own documents. One error in 189, leaning cautious, is a draft I will hand a proposal team. One more thing worth pausing on: the model was fine-tuned for extraction, and this judging job is a different task with a different prompt. It followed it anyway, with 361 of 362 answers parsing on the first attempt. The narrow tune had not damaged the general model underneath. The booklet adds a skill; it does not overwrite the book.

## Part 5: What this means for your organization

### The cost arithmetic, three flavors

The workload, measured from the live run: one contract through the full pipeline pushes about 560,000 tokens in and 35,000 out. Assume a proposal shop screening 20 RFPs a month. July 2026 prices.

**Flavor 1: Public API.** Claude Opus at $5 per million input tokens and $25 per million output comes to about **$4.70 per contract, roughly $95 a month**. No training, no setup, weakest scores in our test, and your private evidence library travels to an external API on every verdict call.

**Flavor 2: Your weights, rented serving.** The tuned Kimi runs on a per-token platform where the base model is open and the trained attachment is mine: about **$3.30 per contract, $66 a month, plus the one-time $7 training bill**. Better scores than Claude, cheaper than Claude, and the private library only meets a model I control.

The sleeper is the small model. Tuned Qwen scored within two points of the winner and costs about **22 cents per contract, under $5 a month, $1 to train**. At high volume this is the one I would ship.

**Flavor 3: Fully self-hosted.** Here size decides everything. The trillion-parameter winner needs an eight-GPU node at $25,000 to $37,000 a month rented. Absurd at 20 contracts a month; defensible only at massive volume or under rules that forbid any external serving. The 4-billion-parameter Qwen flips it: one mid-range GPU, a few hundred a month, or the workstation already under your desk.

### The ROI a layman can check

A skilled proposal person building one compliance matrix by hand: most of a working day, call it $400 to $600 of loaded labor cost, per contract. The machine draft: between $0.22 and $4.70 of compute, in twenty minutes, finding about half the requirements with citations, plus the complete evidence check against your own library that a human would need another day to do.

The machine does not replace the person. It hands them a draft and a gap list before their coffee is cold, and it turns "should we even bid this?" from a day of reading into a number: 152 gaps means partner or pass.

At 20 contracts a month, the compute bill for the best model is $66. The first bad bid you _avoid_ pays for years of it. ROI that does not need a discounted cash flow model to be convincing.

### For Enterprise

The lesson is not "open models beat Claude." On general work they do not, and our own table shows Claude keeping the precision crown. The lesson is that **for a narrow, repeatable, verifiable task, a seven-dollar fine-tune moved a model you control past the frontier model you rent.**

Three implications:

1. **Custody stops being a tax.** The usual story is that privacy costs you quality: use the weaker on-prem model, accept worse answers. Here the private-weights option is also the accuracy winner. When the task is narrow, you can have both.
2. **Your moat is your data work, not your model.** The recipe was 36 training steps anyone can run. The value was 438 hand-checked requirements and the discovery that the teacher had missed a third of them. Competitors can copy the recipe. They cannot copy the labeled corpus without doing the work.
3. **Build the eval before the pilot.** Most enterprise AI pilots fail undiagnosably because nobody can say what "better" means. Our entire result rests on three hand-labeled answer keys and a deterministic scorer. That was two days of unglamorous effort, and it is the reason every claim in this piece has a number attached.

### For Small Business

The Qwen small-model result is the one that should change plans: two F1 points behind the winner, 22 cents per contract, one dollar to train, runs on cheap, existing hardware.

The start to AI Native: pick one document task you repeat weekly, one where you can write down what a right answer looks like. Invoices against POs. Intake forms against eligibility rules. Permits against checklists. Spend your effort on 50 to 100 hand-checked examples, not on model shopping. The fine-tune itself costs less than lunch.

### When NOT to fine-tune

- **The task varies wildly.** Fine-tuning bakes in a distribution. Our models learned Texas government contracts; hand them a novel format and the advantage shrinks.
- **You cannot write down what "correct" means.** No answer key, no eval, no way to know if tuning helped. Prompt a frontier model and keep a human in the loop.
- **Volume is trivial.** At two documents a month, $4.70 versus $0.22 is not a decision worth engineering time.
- **The task needs frontier reasoning.** Ours needed careful reading, not deep thought. For genuinely hard reasoning, buy the frontier.

### Key takeaways

- A $7 LoRA fine-tune on an open model beat prompted Claude Opus at compliance-matrix extraction on held-out contracts: 0.57 average F1 versus 0.52, with the small $1 model at 0.55.
- The binding constraint was training-data quality, not model choice. Fixing the teacher's blind spots (+586 missed requirements, +49% data) moved every model past the baseline. The recipe never changed.
- Half the project was fighting PDFs: footers poisoning text, page breaks cutting sentences, headings gluing themselves to requirements. Budget for it.
- Privacy and quality are not a trade-off on narrow tasks. The model that keeps your documents private is also the one that won.
- The ROI question is labor, not tokens: $0.22 to $4.70 of compute against half a day of skilled reading, and a bid/no-bid answer in twenty minutes.
- Evals first. Hand-labeled requirements and a deterministic scorer are why any of these claims can be checked.

### For your understanding

**Q. Your team wants to fine-tune a model on your best analyst's report drafts. What must exist before training starts, and why?**

_Answer: An answer key and a scorer: held-out examples of correct output and a defined measure. Otherwise you cannot know whether tuning helped, hurt, or did nothing._

**Q. Our tuned models plateaued at similar recall in round one. Why was the fix better data rather than a bigger model?**

_Answer: All students trained on the same teacher's output, so they shared the teacher's blind spots. No model can learn requirements its training data never had._

**Q. A vendor pitches you a self-hosted trillion-parameter model for a 30-document-a-month workflow. What question do you ask?**

_Answer: What does the GPU node cost per month versus per-token serving? At that volume, $25,000+ a month of hardware against under $100 of per-token billing needs an extraordinary justification, like a hard rule against external serving._

**Q. When is prompted Claude still the right choice in our own results?**

_Answer: When false positives are costlier than misses: its 91% precision was untouched. And whenever the task is too varied or too rare to justify building an eval and a tune._
