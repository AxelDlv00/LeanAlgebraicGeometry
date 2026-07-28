Content hash is identical to HEAD — the stale olean is an mtime touch only, not a content change. That's a cosmetic rebuild trigger, not work loss.

## Report — ajc-fbc close-out hygiene pass (run 0068 r4)

### 1. Work-loss audit (task 1) — clean, one finding in another lane

**This lane's claim verifies.** Measured, not inferred:
- All 7 commits are ancestors of `main` HEAD (`c04477e2e`, `b88c38ee7`, `c0c9ed6e4`, `883ba62f4`, `13f64374f`, `b845fc3ef`, `48c61891c`).
- Both of this lane's files are byte-identical to HEAD in *both* diffs (worktree and index): `.../AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean` and `.../scripts/axiom-frontier.lean`. Content hash of the fbc file equals `HEAD:` blob exactly (`ca90b72d9`).

**Armed paths found (I-0718's corrected instrument — staged modifications, not just deletions).** Crossing `diff --cached --numstat HEAD` against `diff --numstat HEAD` over the whole shared index, four times over ~20 minutes:

| measurement | armed paths |
|---|---|
| 1st | 5 (incl. `GenusFieldInvariance.lean` +2/-2, `SectionsFieldBaseChange.lean` +6/-13) |
| 2nd/3rd | 3 (`SectionsFieldBaseChange.lean` +6/-13, `I-0493.yaml`, `I-0493.jsonl`) |
| final | **0** |

None were mine. The two Lean files belong to **`ajc-rr`** (last touched by `f17b2c2e6`), and the staged content was a genuine **revert of committed prose** — the index held the pre-`f17b2c2e6` docstring, including restoring two `set_option backward.isDefEq.respectTransparency false` lines that commit had measured dead. I did not touch them, per instruction. `ajc-rr` has since confirmed on I-0493 that four of its files were armed as stale modifications and cleared them; the armed set is now zero. `--diff-filter=D` read clean throughout, confirming I-0718.

One cosmetic non-issue: the fbc module's olean is older than its source mtime, but the source content is identical to HEAD, so this is an mtime touch, not a content change. No rebuild is owed for correctness.

### 2. Stale-claim sweep (task 2) — one genuine hit, fixed

**Fixed (the only clearly-mechanical one I found):**
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/pic-representability-campaign.md:344-350` asserted that of the tree's sorry carriers "exactly *two* are instances ... `instHasPicScheme` itself and `pullback_preservesFiniteLimits`". That is case (b) verbatim. Measured at HEAD: `pullback_preservesFiniteLimits` is a plain `theorem` (line 936 of the fbc file), no `instance` declaration or `attribute` restoring it anywhere in the module. I replaced the claim with a dated correction box that states the demotion, points at roadmap `AJC.fbc.exactness` and the named carrier `pullback_preservesMonomorphisms`, and says not to restore the attribute. I deliberately did **not** restate the `instHasPicScheme` half (that seam is `ajc-etale-pic`'s under protection I-0491) and did not re-measure the carrier count — the box redirects to `scripts/axiom-frontier.lean` instead. The edit is unstaged in the worktree; committing it is yours, since it is outside the two files you committed.

**Checked and current — no action needed.** Each of these already carries r4's correction:
- Project `README.md:91-92` and `TO_USER.md:37-41` — both state the demotion correctly, TO_USER explicitly "*not* proved, and naming it still reports `sorryAx`".
- `hgraph/nodes/bfd835ccaa0b.md` (the `twisted_cech_nerve_iso` mirror) — carries the r4 block with the guard "DO NOT READ THE PARAGRAPH ABOVE AS A PRICE", so the surviving two-nerve/`isoOfRangeEq` prose is explicitly framed as superseded. Updated `2026-07-29T04:37`.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex:11626-11637` — "A single ingredient is still assumed ... namely the coface compatibility", and describes `cech_flatBaseChange_oneLeaf` correctly.
- `analogies/02kh-leaves-304.md` and `analogies/fbc-pushpull-tilde-317.md` — both stamped by `13f64374f` with a HISTORICAL banner.
- Six other fbc analogies (`fbc-dict`, `fbc-locality-305`, `fbc-qc`, `fbc327`, `fbc329`, `openimm-beckchevalley-326`) are unstamped but I checked each: their `instance` hits are unrelated mathlib instances, and none states an obligation count or a critical-path claim. No stamp needed.

**Ground truth I measured, for the record:** exactly three `sorry` *terms* in the 3762-line fbc file — line 916 (`pullback_preservesMonomorphisms`), 2778 (`cech_pushforward_baseChange_natIso`), 2959 (`twisted_cech_nerve_iso`). The module header's "Three statements below are still assumed" is accurate, and correctly marks two of the three as off the critical path. The other 58 `sorry` mentions are prose.

### 3. Roadmap consistency (task 3)

`AJC.fbc`'s own subtree is **internally consistent** — all four rows re-read on disk and each matches HEAD. `AJC.fbc.cosimplicial` is correct at `active · 1/2 done`, and its summary even explains the choice ("active rather than pending because .twisted is being worked, not deferred").

All three warnings concern **other lanes**:
- `AJC.jacobian.assembly` — every sub-item done; the row is `pending`, owner `None`. Not fbc.
- `AJC.picrep` done with `AJC.picrep.tensor` still pending. Not fbc.
- 20 active rows vs cap 8. Applying I-0509's liveness rule (an active row is legitimate if a live lane owns it *or* it is an active ancestor of such a row — the walk goes **downward**, which I got wrong on my first pass and corrected): **16 of 20 are legitimately held** by the 7 running lanes, including all three fbc rows. The 4 genuinely unheld are `AJC.pic0av{,.identity,.structure,.tangent}`, whose owner `ajc-pic0av` is **queued**, not running. Those are that lane's rows — reported, not touched.

On `AJC.fbc.exactness`'s `pending`: **I recommend leaving it.** Its own summary already argues the case explicitly — "Left `pending` rather than `rejected`: the statement is TRUE and someone may want it if mathlib grows a pointwise model for module pullback." `rejected` would read as "we decided this is wrong"; `deferred` would lose the standing "do not spend a session here" warning that the row body carries. The label encodes a judgement and the judgement is already documented, so changing it would only lose information.

### 4. Inbox hygiene (task 4) — two deltas posted, both kept

- **I-0635** (r2 hand-off) — already `archived`, by the lane. Nothing to do.
- **I-0691** (`ajc-pic0av`'s "your file is red") — already `archived`. Resolved: the fbc source is byte-identical to HEAD and the 96 in-flight lines are committed. Nothing to do.
- **I-0651** (r3 hand-off, `memory`, open) — **comment-and-keep, done.** Comment `C-0002`. Its central instruction was stale: it priced the residue as a "TWO-NERVE comparison ... the `isoOfRangeEq` slice identifications commute with the inclusions", which is exactly half (b) — the half r4 proved free by mono-cancellation (`slice_compat`). The delta records that, notes the narrowing from general-φ to coface, names half (a) (mate naturality in the *square*) as what remains with the `mateEquiv_vcomp` route and the measured-negative `pushPullMap`-is-the-degenerate-mate result, and preserves what still stands. Kept rather than archived because the sibling-route facts (`cechOuterBC = canonicalBaseChangeMap` by rfl) and the "don't touch `pullback_preservesMonomorphisms`" warning are still live guidance.
- **I-0570** (r1 probe record, `memory`, open) — **not in your list, but stale in the same two ways; comment-and-keep, done.** Comment `C-0004`. It claimed (i) `Pi.hom_ext` "does NOT fire here" and (ii) the per-σ projection lemmas "DO NOT EXIST ... anywhere in the tree". r4 refuted both: `Pi.hom_ext` fires once the obligation is narrowed to cofaces, and the σ-coordinate lemmas existed in `CechSectionIdentification{Leg,LegMid1}` but were outside the import cone. Kept because its probe discipline and mate-composition survey remain the right starting points.
- **I-0545** — checked, out of scope: its two items are the `ajc-etale-pic` blueprint mark and the `leanok-audit` control, both owned elsewhere. Left alone.
- **I-0725** — its "two-nerve" mention is a retrospective quote of the superseded price, correctly framed. Left alone.
- No standing protection was touched (`I-0491`, `I-0074`, and the third protection all untouched).

### 5. Count warnings (task 5) — applied by liveness, delta only

Applied the standing answers (I-0509 roadmap, I-0641/I-0551 inbox, I-0648 tasks) rather than re-deriving.

| metric | before | after | cap |
|---|---|---|---|
| open non-protection | 152 | 151 | 30 |
| open `memory` | 91 | 90 | 10 |
| open conversations | 12 | 12 | 8 |
| open issues | 46 | 46 | — |
| roadmap active | 20 | 20 | 8 |
| open tasks | 13 (7 running + 6 queued) | 13 | 12 |

Open memory by originating lane: `ajc-rr` 15, `ajcr-cert-r2` 11, `ajc-pic0av` 11, `ajcr-w5-av` 10, `ajcr-charts` 8, `ajcr-divrep` 8, **`ajc-fbc` 8**, `ajc-albanese` 7, then three retired lanes at 5/5/3. 24 of the 90 are `[persistent]`. No lane is hoarding and this lane is at the fleet median — consistent with I-0641's "the count is the fleet's steady state". I forced nothing down; per I-0551 archiving to hit a number costs live lanes their context, and archive is one-way.

### Recommendations I did *not* act on, with reasons

1. **`ajc-rr`'s armed revert** — cleared by that lane itself; report-only per instruction, and it is now zero.
2. **The `instHasPicScheme` half of the campaign-note claim** — belongs to the `ajc-etale-pic` seam under binding protection I-0491. I corrected only the half I measured and flagged the other in the box.
3. **The 4 unheld `AJC.pic0av` active rows** — another lane's rows; status changes there are its call.
4. **`AJC.fbc.exactness` status** — recommend keeping `pending`; the row already documents why, and both alternatives lose information.
5. **The 6 unstamped fbc analogies** — no in-scope stale claims; a banner would be noise.
6. **The stale olean** — content matches HEAD, so this is an mtime artifact, not a correctness issue.

### Measured vs inferred

Measured: the commit ancestry, both file diffs and the content hash, the armed-path crossing (4 times), the three `sorry` terms and their owning declarations, `pullback_preservesFiniteLimits` being a `theorem`, all doc/blueprint/hgraph/roadmap text quoted, every count in the table, and both comments verified once-only on disk at `.archon-horizon/inbox/local/comments/I-0570/C-0004.md` and `.../I-0651/C-0002.md`.

Inferred: that the 6 unstamped analogies need no banner (judgement from reading them, not from a rule); that the olean mtime skew is a touch rather than a reverted-and-restored edit (the hash match is consistent with both, but only one is plausible); and the ownership attribution of the armed Lean files, which I read from `git log` and which the `ajc-rr` lane then confirmed independently.
