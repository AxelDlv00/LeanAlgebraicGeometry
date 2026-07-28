Hygiene pass done. Note: my README edits were partly overwritten/superseded by a concurrent lane's edit to the same file, and their numbers were the correct ones (details below).

## Changed (with ids)

Inbox — 3 items archived, all with a closure comment recording what survives and where:
- **I-0346** archived. Authorized by its own human comment ("I am archiving it once the executing task has read it"); ajcr-cert-r2 has read and executed R2. Comment points readers at I-0492 as the binding form.
- **I-0488** archived, absorbed into **I-0483**. Same incident, same task, same 20-line `\leanok` check; I-0483's C-0001 already quoted its evidence. Its three rules (compare domain sizes before reporting agreement; an unexplained discrepancy is an unfound bug; assert reconciliation identities per measurement) are now carried verbatim on I-0483.
- **I-0476** archived. Both halves consumed: its explicit ACTION (three AJC docs never mentioned the AJCR etale layer) is discharged at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md:149-166`, `TO_USER.md:22`, `informal/pic-representability-campaign.md:333-336`; and the decision it was evidence for is closed by protection **I-0491**, whose clause 3 carries its finding as an instruction.

Comments added, no status change: **I-0501** (confirmed and generalized), **I-0357** (re-measured), **I-0387** (fifth-pass confirmation with today's numbers), **I-0362** (count refresh + a retraction of my own bad figure).

Docs: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md` — 14→15 files over the 500-line limit, 77→78 informal worksheets. My third edit (file/import counts) was superseded by a concurrent lane; see below.

## Your four warnings

**1. Inbox.** Memory 25 → **16** (cap 10); non-protection 45 → **39** (cap 30). I did not archive the standing negative results: they live in **I-0492** clause 5 and on leaf `field-size` (done), both untouched. I also did not archive **I-0365** — it is not a record of the open design question, it is the standing positive finding that the gate is L8 local surjectivity, still binding on the divrep/charts lanes. Same for **I-0470**/**I-0447** (the hbump/hledger refutation is a live negative result, not a closed question).

The 39 is genuinely near-irreducible at eight live lanes. **I-0387** is the standing item saying so, and it now carries the measurement: the CLI shows 38 open while the store has 42, because `reaches_horizon` hides 14 items (`I-0083 I-0319 I-0354 I-0367 I-0372 I-0387 I-0397 I-0408 I-0430 I-0437 I-0481 I-0489 I-0491 I-0493`). A janitor optimising the visible list optimises the wrong number. That is a cap/scoping decision for the human, not archivable work.

**2. Tasks.** 18 → **14** (cap 12) — *not my doing*. Another lane cancelled T2, T9, T10, T11 at 05:09-05:10 UTC while I was reading. The remaining 6 queued are: `T16`, `rebuild`, `ajcr-w4-rep-free`, `ajc-optimize`, `ajc-rr`, `ajc-truth`. `T16` and `rebuild` are umbrella rows with zero `roadmap_refs` and are the only real duplication candidates (both restate what `AJCR.jacobian`/`AJC.jacobian` already track). I did not close them — `rebuild` is the charter task the rebuild README cites as authoritative, and killing it would orphan that reference. The other four are queued lanes with live refs; not mine to touch. Also: **I-0386** warns that `task set --status` rewrites the roadmap rows in a task's `roadmap_refs`, which is a concrete reason not to bulk-close these.

**3. Roadmap.**
- **p1-aut is `pending`, not `done`.** Your tree read was stale. History: `pending → done` on 2026-07-27T02:38 (before the decision), then `done → pending` on 2026-07-28T04:48:29 by horizon — i.e. already reconciled to I-0492 after the decision landed. It is `priority: low`, `milestone: w4-gate`, title reads "R1/p1-aut: DEPRIORITISED by the R2 decision — do not build the GL_2 action", and its summary carries clause 1 verbatim. **Pinned to `af99f2b70`** ("P1: move ordered rational point pairs and transport the relative cover" — `Curve/P1Aut.lean` +24, `Cohomology/TwistedFiberTwoCover.lean` +86, run 0052, task ajcr-w4-rep-free). That is the two-transitivity groundwork, which I-0492 says stays valid and must not be deleted. No discrepancy to flag, and nothing changed.
- `away-kerspan` left `blocked` as instructed. Its summary already says cert-collapse must be tried first; that happened and confirmed the obligation, so `blocked` is now the honest status rather than a stale one.
- `AJC.jacobian.assembly` warning is **intentional and documented** — its own summary says "this item stays open with its only child done — that status mismatch is deliberate", and **I-0411** is the standing issue with seven prior verifications. Left as-is; do not mark done.
- 14 active items: 11 of the 14 are a single legitimate parent chain (`AJCR.jacobian → w4-rep → datum → dat-d → ddr → certificate/divrep`) plus the AJC equivalents. The cap counts ancestors, so four live lanes cannot produce fewer than ~12. Intentional.

**4. Ledger index.** Both paths you saw are **gone** from the index — `AbelianVariety/JacobianSmooth.lean` and `informal/w5-s-worksheet.md` no longer appear, so that drift self-resolved (the Lean file's real path is `AlgebraicJacobian/AbelianVariety/JacobianSmooth.lean`, which is why the index entry never matched). One new staged deletion is present now:

```
 D MainProjects/Algebraic-Jacobian-Challenge/hgraph/edges/03ccc83e89b1__e07dfa671d41.md
```

This one is **not** index drift — the file is absent from disk, present in HEAD, and both endpoint nodes (`nodes/03ccc83e89b1.md`, `nodes/e07dfa671d41.md`) still exist, so it is a real orphaned-edge removal by an AJC lane's graph work. Different project, not yours; I left it alone. Note it as another lane's pending commit, not as drift.

## Recommended, not done

- **No `hgraph/config.yaml` exists for *either* main project** — I confirmed AJC lacks one too, and `config.yaml` declares no blueprint/hgraph keys. So `graph sync` cannot run anywhere, which is the mechanism behind **I-0441** (35+ landed AJC RiemannRoch declarations with no node) and the scanner-defect family **I-0452**/**I-0472**. Fixing the regexes is wasted until sync runs at all. Recorded on I-0501.
- **All eight `AJCR.w5-av.*` leaves still have empty summaries** (I-0357 finding 2, unchanged in two days) while three of them have since been worked. **I-0499** is the receipt: a Wave-5 session mis-sized `s1` off a filename because the row said nothing. Six open leaves need one paragraph each; `p1` needs its blocker written down.
- I-0357 finding 1 is now **partly stale** — `blueprint/src/chapters/DivisorScheme.tex` (979 lines) exists, so DD-R coverage is thin rather than zero. Noted on the item; not closed.
- **I-0220** (RelCurveCollapse.lean still 752 lines; 15 files over the 500-line charter limit) is real but is a Lean-source change, so it stays an issue.

## One correction against myself

I initially measured "~123 unrooted modules" in the rebuild and wrote it into I-0362, then found a concurrent lane had put **583 reachable / 68 unrooted** in the README. Theirs is right and mine was wrong: my scanner broke out of each file's import list at the first non-import line and so never followed the transitive closure, counting the root's 528 direct imports as the whole reachable set. A module imported only by a rooted sibling *is* kernel-checked. I filed the retraction on **I-0362** rather than leave the wrong figure, and left the README's 583/68 in place. Worth carrying: reachability is transitive, and my check measured a smaller domain than it reported on — the same shape as I-0483.
