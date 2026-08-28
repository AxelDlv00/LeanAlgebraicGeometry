The hygiene pass is done. Findings and actions below.

## What I changed

**Docs (fixed directly)**

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md` — the unrooted-module arithmetic was wrong in method, not just in age: it subtracted the root's 528 `import` lines from 651 files on disk and reported "~120 modules never kernel-checked". Reachability is transitive; I closed it and measured 583 reachable, so the real figure is 68. Left a note to count transitively and re-measure rather than quote.

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/README.md` — the index claimed 76 files against 78 on disk, and its Wave-5 section was headed "not yet started (`AJCR.w5-av` … pending)" while your lane works it today. Split Wave 5 out as live, added the missing `w5-s-worksheet.md` row (your S-cluster worksheet, with the note that its §2 corrects `w5-recon.md`), refreshed the counts.

`/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md` and `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md` — both sorry snapshots understated the tree. Term-level census (comment-stripped): AJCR 16 → **17** (a new rooted sorry at `Picard/Pic0ChartLocusIsOpen.lean:173` from the live chart lane), AJC 26 → **28**. AJC module/line counts were 187/132,344 against a measured 202/137,433.

**Inbox** — archived `I-0488` (its finding is verbatim inside `I-0483` C-0001: same 1552-vs-1560 domain gap, same `re.search`/`re.findall` mechanism) and `I-0411` (the deliberate `AJC.jacobian.assembly` warning, which had accumulated seven "re-verified, still correct to leave" comments across five passes; the decision already lives in the row's own summary, which is where a session meeting the warning reads it). Both got a rationale comment first. Filed `I-0509`, a memory recording the liveness-triage method below so the next pass does not re-derive it.

**Roadmap** — set `AJC.maintenance` `active` → `pending`, with the reasoning on the row.

## Your three warnings

**Roadmap active count.** Your instinct was right and I can now put a number on it. I crossed all 13 active rows against the 8 live pids: seven are held directly by a running lane, six more are active *ancestors* of those (a live leaf drags its whole spine — that is most of the over-count). Exactly one row was left over: `AJC.maintenance`, owned by `ajc-optimize`, which is **queued**, last touched 2026-07-25. That is the one I moved. The warning still fires at 13/8 and every remaining row is legitimate; the advisory max was written for 3-5 lanes.

**Task queue.** No orphaned `running`. All eight running tasks map to live pids (0066-0073), and run 0065 left no zombie marker or half-set state — both dead sessions wrote only the auth-error stub and touched nothing. The 14-open warning is legacy `T*` rows plus queued lanes, not staleness.

**Inbox.** Started at 44 non-protection; I archived 2 and 4 other lanes archived 12 concurrently, but the same lanes filed 9 new items during the pass, so it now reads 46 in the store / 17 memory visible. I did not archive further: I read all 22 memories and each carries a distinct, already-consolidated rule. The pressure is real filing volume from 8 lanes, not duplication — which is exactly the argument `I-0387` makes to the human. Untouched as instructed: `I-0492`, `I-0074`, `I-0494`, `I-0495`.

## Your own items

`AJCR.w5-av` reads `pending · 10/16 done`, not 8/16 — `t1` and `s2` landing moved it. **No parent/child warning fires on it**, correctly: `t5` is active and `s1`/`s3`/`t3`/`t4` are pending, so the parent is not "all children done". The only roadmap consistency warning in the workspace remains `AJC.jacobian.assembly`, which is not yours.

## For the human

One thing needs a decision, and one is a real accident I could only partly repair.

A concurrent lane (`ajcr-charts`, run 0072) archived **I-0357** at 05:04 — ten minutes *after* `ajcr-cert-r2` commented on it concluding "finding 1 is partly wrong; **finding 2 is still fully true**". Finding 2 is that all sixteen `AJCR.w5-av.*` rows have empty summaries, which has already cost a mis-sizing (`I-0499`). There is no unarchive, so I refiled the surviving half as **I-0508**. Worth knowing that concurrent archiving can drop a live finding mid-confirmation.

The inbox filter defect is now escalating on its own: 21 of 49 open items are invisible to the CLI, including protection `I-0491`. `I-0505` (filed by `ajcr-charts` an hour ago) already reports the safety-relevant version — a binding protection not reaching the session it binds — so I did not duplicate it. I did confirm the rule exactly: an item is hidden if its provider is non-local, its project scope excludes yours, its audience is `human`, or it is owned by another task. Note the consequence for hygiene work: **the janitor cannot archive what it cannot list**, so those 21 items are unreachable to any cleanup pass. That is the root cause of the cap warnings never coming down, and it is a CLI fix, not a hygiene one.
