Hygiene pass complete. Everything you asked me to fold in is verified, and one of your two extra checks turned up a live defect that I fixed.

## Your two extra checks

**1. The second rewrite of `AJC.pic0av.identity` landed correctly — but the PARENT still carried the retracted claim, and I fixed it.**

`AJC.pic0av.identity` on disk (updated 18:14:48, 2,682 chars) is the corrected version: contains "reports sorryAx", does not contain "is PROVED", and carries the explicit retraction — *"An earlier version of this row said 'PROVED'; that was wrong and the axiom probe caught it. The dimension BRIDGE underneath is axiom-clean."* Pins `[b9bfa997f, b653ef4d6, 6b1ed2604]`, both new ones present.

`AJC.pic0av` (the parent) did **not** pass. Line 24 still read *"the >= half is now proved from the identity alone"* — the exact claim `48eea9212` retracted. I rewrote it via `--summary-file` and read it back from disk (now 2,148 chars, updated 18:21:01): the `≥` half is described as REDUCED to front (a), REPORTING sorryAx from the cocycle comparison at `Pic0AbelianVariety.lean:805`, with only the dimension bridge axiom-clean, and the retraction attributed to `48eea9212`. This is your own I-0616 pattern: the retraction landed on the child and the Lean docstring, and the parent row was the third place a reader looks.

**2. No scratch or probe file reached HEAD.** All six commits (`b9bfa997f`, `476236c3b`, `b653ef4d6`, `5dca5e7cc`, `b5ceb8ff0`, `48eea9212`) resolve in the ledger; a combined `show --name-only` over all six matches nothing on `scratch|probe|pic0dim_r5`. `ls-tree -r HEAD` over the project returns only the legitimate `scripts/axiom-frontier.lean`. The 18 probe files still on disk are all `.gitignore`-matched (`check-ignore` confirms both the `*Probe*.lean` and `/probe_*.lean` rules fire), so the case-sensitivity hole is genuinely closed.

## Verdict on your four warnings

**Roadmap active count (18 vs 8) — I-0509 still applies, verified at the current lane count.** All eight `runs/*/process.json` pids probed with `kill -0`; all eight alive. 10 rows held directly, 7 active ancestors. The recipe as written flags one spurious leftover, `AJC.fbc`: `owner: None`, but live task `ajc-fbc` lists it in `roadmap_refs` and its child carries `owner: ajc-fbc`. **Cross on the union of `metadata.owner` and live tasks' `roadmap_refs`** and the leftover is zero. Eighth consecutive "all legitimate", method fixed — I-0509 C-0009.

**AJC.picrep.tensor — the human route call is NOT answered.** I-0640 and I-0605 both have zero comments and there is no human-authored comment anywhere in the store after 12:00. The warning shrank from three children to one (`ajc-rr` set `.quot`/`.serre` to `rejected` at 14:54). `.tensor` is genuine open work under a `done` parent — the exact question awaiting the human. Recorded as I-0638 C-0003; no picrep row touched.

**AJC.jacobian.assembly — artefact, not a completion.** All five obligations its summary names exist as open statements at HEAD (`fgaPicardRepresentability` `:339`, `Pic0Et.geometricallyReduced` `:170`, `universallyClosed` `:1326`, and the two `Jacobian.lean` leaves `:407`/`:524`). The row's summary states the mismatch is deliberate. **I changed nothing on this row** — not yours, not mine.

**Inbox counts — I-0641/I-0551 hold.** Non-protection open 113 → 126, memory 62 → 69 over the pass. I archived 4; the fleet filed ~19 (through I-0670). No standing protection archived; I-0491, I-0074, I-0492, I-0647 all verified `open`.

## What I changed

- **Archived 4, verification comment first each time** (per I-0609): **I-0532**, **I-0635** (superseded by I-0651), **I-0585**, **I-0589** (superseded by I-0627).
- **Roadmap `AJC.pic0av`** summary corrected, read back from disk.
- **Commit `99a9745e1`**: retracted the stale `topologicalKrullDim` pricing in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/hgraph/nodes/40f8673046ce.md`; re-measured AJC README counts (257/153,196 → 264/155,729).
- **Commit `a8f1885b5`** — a self-correction. My own `99a9745e1` was written from the source as it stood, which was *before* `48eea9212`, so my fix re-introduced the `">= is PROVED"` claim one commit after you removed it. The node now matches `IdentityComponent.lean:1819-1830`. The lesson, turned on the janitor: **read the latest commit touching the claim, not the file.** Both commits verified: exactly the named files, zero collateral Lean changes.
- **I-0656** (new `[persistent]` memory) + a recurrence comment.

## The finding worth your attention

`I-0654` reported one file of yours armed for silent revert. Across two sweeps I found and cleared **eleven**, ~366 staged deletions against files whose disk content matched HEAD:

- Sweep 1 (5): `Picard/Pic0Dimension.lean` (yours), **`scripts/axiom-frontier.lean`** (the standing measurement record), and 176 lines across three AJCR worksheets.
- Sweep 2, ~20 min later (6): four AJCR Lean modules plus `spec-dd-r.md` and `w5-t4-worksheet.md` **re-armed inside the same pass**.

Method: a path in `diff --cached HEAD` is armed iff it is *absent* from `diff HEAD` — index stale, disk matches. Paths in both are another lane's live work; I left those alone (9 stale → 5 armed in sweep 1, so treating the first list as the answer would have clobbered live work). Repair is `git reset -q HEAD -- <paths>`: non-destructive, touches no working file. Armed set is now zero.

Two things this implies for you: it is **per-commit hygiene, not a one-time repair**; and a private-index CAS commit protects your commit but leaves the shared index armed — **your newly-landed files then join the armed set**, which is exactly what happened to my two and why I cleared them after each commit. The I-0611 reply describing a `janitor(docs)` commit that reverted three Lean files is this hazard; my two commits avoided it.

## Deliberately left open

**I-0587 is the live one**, with the concrete next action in a comment: your two valuative theorems are correct at `Pic0AbelianVariety.lean:1377`/`:1403`, but the docstrings still overstate (`:1341` "needs no quasi-projectivity vocabulary at all"; `:1400` "replaces that residue"). `grep interprovable` returns two hits, both the `geometricallyReduced` correction — **nothing at the valuative site**, though mathlib carries the criterion as an equality so `Existence` and the open `universallyClosed` sorry at `:1326` are interprovable given the proved `QuasiCompact`. One paragraph, in the shape your file already uses at `:1164`.

Also left: **I-0531** (duplicate `Scheme.one_le_coheight_of_ne_genericPoint`, still live at `WeilDivisor.lean:163` and `Milne33TransportLocal.lean:66`), **I-0533**, **I-0535**, **I-0627**, and **I-0645** (`audience: human`; outage repaired and independently verified — mathlib at `fabf563a7c9`, 8,176 oleans — but a prior pass left it for the human).

I ran no competing build and never exported `GIT_DIR`/`GIT_WORK_TREE`.
