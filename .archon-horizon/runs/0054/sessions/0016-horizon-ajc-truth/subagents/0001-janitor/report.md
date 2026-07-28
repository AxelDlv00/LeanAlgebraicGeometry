All four archives landed, and the protected/human-decision items are untouched. Final state verified.

## What I archived (4 items, 43 → 40 non-protection)

**I-0485** (issue, "'eleven' is 34") — verified fixed at HEAD, not taken on trust. `8ed20f0f1` publishes both reconciled triples (proof-level 1078 marks/1073 pins = 930+143, sorryAx **0**; statement-level 1567/1560 = 1372+188, sorryAx **34**), matching the item's independent re-measurement exactly including the 1560 and 188. `93feb6bf4` carries both into `README.md:197-199`. Critically, the item's actual *fix request* ("it needs the same identity applied to them") is satisfied: the loop at `scripts/axiom-frontier.lean:273` now iterates both mark positions through the same `pub + priv == len(pins)` assertion. Its second point is addressed too — the 143 private pins are decided via `Lean.collectAxioms`, 1073/1073, with the positive control retained.

One correction worth your attention: **I-0485's third citation was wrong.** It named `TO_USER.md:31` as carrying "eleven". That file has never contained the string, at HEAD or at `8ed20f0f1^` — its axiom-frontier bullet quotes the 126/84/42 probe figures and carries no statement-level count. There is no third site to fix. (`I-0473` was already `closed`.)

**I-0486** (memory, the fix-the-class rule) — consolidated into **I-0483**, not discarded. Same session, same 20-line check, and I-0483 is the general form; two memory items for one lesson is what the memory cap is warning about. I copied the durable content onto I-0483 first: the fix-the-class rule, the sixth domain bug (`re.search` keeping only the first `\lean{}` per statement, worth 8 pins), and the corollary about publishing a bound on a method.

**I-0484** (conversation → `task:ajc-gate`) — closed as unanswerable. It was an explicit one-way note ("Not a request"), so it should have been a `hint`; its recipient is `done` with no live run, so no reply can arrive. Content preserved on I-0483.

## Also done: I-0482 trimmed (kept open)

This was a live hazard. I-0482 is `[persistent]` and its body still asserted three claims its own comment retracts — that `inbox show` exits 0 silently (it exits **2** with a clear diagnostic), that I-0372 is "unreadable through every tool" (`inbox comment` works), and that "counted but not listed" is the discriminator. A future session reads the body, not necessarily the comments. Per the I-0381 precedent I deleted the wrong half and kept the rule, adding the filter at source: `reaches_horizon` in `/home/axel/Archon-Horizon/src/archon_horizon/core/inbox.py:191`, precedence project-scope → owner-task → audience-targets → `metadata.provenance.task|run`. That last fallback is the whole mechanism: **a `--to human` item is listable only by the team that filed it.** I put the same diagnosis on I-0481 for the human.

## Left open deliberately

- **I-0074** (protection) — untouched, active.
- **I-0372** — open human decision, untouched. It stays hidden from your list by the filter above (filed by `ajc-optimize`); read it with `python3 -c "import yaml;print(yaml.safe_load(open('.archon-horizon/inbox/local/items/I-0372.yaml'))['body'])"` and `cat .archon-horizon/inbox/local/comments/I-0372/*.md`.
- **I-0346** — also `--to human`, also hidden (filed by `ajcr-w4-rep-free`), genuinely awaiting a human.
- **I-0391** — human-initiated; you answered it (C-0013). Closure is the human's.
- **I-0487, I-0476** — fresh, untouched.
- **I-0411** — now confirmed at source seven times; settled, don't re-verify.
- The other 14 issues all carry "re-measured at HEAD, still live" comments from prior passes.

## Roadmap and tasks: clean

255 roadmap items, exactly **one** warning — the deliberately-left `AJC.jacobian.assembly` one. No parent/child disagreements under `AJC.jacobian`, `AJC.maintenance.blueprint`, or `AJC.picrep`; no milestone-focus warning (7 active). `AJC.picrep.rational-point` left `blocked` as instructed. Task queue: `ajc-truth` is the only `running` task and it is this live session (`horizon ps` shows run 0054 only) — no stale runners. 9 queued is long but each has real scope.

## The one warning that should survive the session

**The memory cap cannot be met by cleanup, and the count you see is not the count that exists.** After my pass: memory 23 against a cap of 10, non-protection 40 against 30. Prior passes already absorbed I-0320, I-0384, I-0416, I-0439, I-0465, I-0471, I-0479 — the consolidation work is done, and the remaining 23 memories are each still live. Two structural reasons, both already filed for the human on **I-0387** and **I-0481**: the caps assume a smaller workspace than 3-5 parallel teams over 8 projects, and the health count runs over items the calling team cannot list, putting a floor of 5 under the number that no pass by this team can lower. Do not spend another session trying to reach 30 by archiving; the next janitor should reconcile against the store and stop.
