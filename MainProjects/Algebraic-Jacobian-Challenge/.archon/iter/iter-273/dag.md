# DAG iter-273 narrative

## Headline: 1-to-1 coverage debt cut 369 → 172 (−197, −53%)

The injected DAG_STATUS (iter-272) had criterion 5 failing with 369 uncovered
`lean-aux` nodes. This iter attacked that debt directly: 12 blueprint-writers
across two batches added 197 faithful "Proved directly in Lean" 1-to-1 coverage
blocks, each wired into its chapter cone. Status stays `in_progress` (172
lean-aux remain, dominated by the actively-churning TensorObjSubstrate family),
but every other gate criterion is green and the reviewer certified no new
isolation.

## leandag: before → after

```
                       iter-start   iter-end
blueprint nodes            566         763   (+197)
lean-aux (uncovered)       369         172   (−197)
edges                      968        1298   (+330)
isolated blueprint           3           3   (all exempt; no new isolation)
∞ blueprint sources          0           0
broken \uses{}               0           0
content.tex                38/38       38/38
```

## What I dispatched

- **Batch 1 — 9 `blueprint-writer`s** (one per chapter, run 4-at-a-time under the
  max_parallel=4 semaphore), each given the exact list of uncovered `lean-aux`
  decls for its chapter (derived from `archon dag-query unmatched` mapped to Lean
  files), with a directive emphasizing faithful one-line statements read from the
  Lean source + mandatory statement-level `\uses{}` wiring + literal-REF cleanup:
  Albanese AuslanderBuchsbaum (32), CodimOneExtension (30); RiemannRoch
  WeilDivisor (31), OCofP (14), H1Vanishing (13); Picard FGAPicRepresentability
  (16), IdentityComponent (11), SheafOverEquivalence (10), RelativeSpec (9).
- **Batch 2 — 3 `blueprint-writer`s** on the next stable cluster, directives now
  carrying the leandag statement-vs-proof `\uses{}` quirk explicitly:
  AbelianVarietyRigidity+RigidityLemma (16), Albanese AlbaneseUP (8), Picard
  QuotScheme (8).
- **`blueprint-reviewer`** (whole-blueprint, mandatory) on the fresh post-writer
  state, concurrent with batch 2.
- **Deferred** the TensorObjSubstrate family (122 uncovered) — it is the active
  A.1.c.sub prover lane and churns its internal helpers every iter; covering it
  now is wasted work. Recorded in DAG_STATUS.

## The leandag wiring quirk I discovered (and the ∞ regression)

Empirically (re)established this iter and saved to project memory: **leandag
creates dependency edges ONLY from statement-level `\uses{}`** — a `\uses{}`
inside a `\begin{proof}` block contributes no edge and no `used-by`. Three
batch-1 helpers were referenced only in proof blocks and so showed up ISOLATED
despite being "used"; I hoisted their labels into the consumers' statement-level
`\uses{}` (which also correctly encodes formalization ordering), returning
isolated-blueprint to the 3-node exempt set. Batch-2 directives carried this rule
up front, and batch-2 produced no new isolation.

A related ∞ regression: a batch-2 AbelianVarietyRigidity block
(`lem:kbarChart1Ring_specMap_fac`, a `[sorry]` Lean decl) had its proof sketch
written *inside the statement body* with no `\begin{proof}` environment → leandag
read it as "no informal proof" = ∞. Fixed by wrapping the sketch in a proof
block; `archon dag-query gaps` back to 0 of 0.

## blueprint-reviewer findings and my actions

| Finding | My action |
|---|---|
| All iter-273 coverage blocks: statement-level `\uses{}`, faithful statements, no dup pins, **no new isolation** | Accepted — validates the batch. |
| **HARD FAIL**: `\mathlibok` anchor `thm:finite_appTop_of_universallyClosed` "fabricated — Mathlib lacks the name / UNMATCHED" | **Verified FALSE POSITIVE.** The theorem IS real Mathlib (`AlgebraicGeometry/Morphisms/Proper.lean:154`), used directly in-tree (`exact finite_appTop_of_universallyClosed k f`). A genuine external `\mathlibok` anchor always shows "unmatched" vs the project tree by design. Recurs (iter-270 same). Saved to project memory; no change. |
| Bare Kleiman `\cref{}` labels (`th:cmp`, `th:main`, `cor:algsch`, `lem:agps`, …) in prose of RelPicFunctor / FGAPic / Pic0AV / IdentityComponent | NOT broken `\uses{}` (leandag broken-uses = 0); they are unresolved `\cref{}` (crash `leanblueprint web`). **Review-agent's `\cref{}`-correction domain** per CLAUDE.md — surfaced in DAG_STATUS "Non-gating"; flagged RelPicFunctor's as the reviewer's HARD-GATE-before-A.1.c.fun item. Not fixed by me. |
| `def:Abelian_Ext_chgUnivLinearEquiv` possibly-nonexistent Mathlib name | Review-agent domain; surfaced for the loop. |
| Stale "residual sorry" prose in AbelianVarietyRigidity (superseded iter-162) | Cosmetic; surfaced, deferred. |
| 0 unstarted-phase proposals | No new chapters needed — full phase coverage confirmed. |

## Subagent skips

- strategy-critic: STRATEGY.md unchanged this iter (git working-tree diff empty;
  no route/phase edits) and the iter-272 verdict was SOUND with no live
  CHALLENGE — skip condition met. No strategy change was surfaced by any writer
  (all "Strategy-modifying findings" sections empty) or by the reviewer.
- dag-walker: not needed — the graph has 0 ∞-sources and the only isolated nodes
  are the 3 reviewer-certified exempt ones (no untranscribed-dependency cone to
  walk). The iter's work was 1-to-1 coverage (blueprint-writer territory), not
  cone-completion.

## What remains / next iter

- **Stable remainder (~50 lean-aux)** — one writer batch closes most:
  RationalCurveIso, RelPicFunctor, Thm32, RRFormula, GrpObj, MayerVietorisCore,
  LineBundleCoherence, FlatteningStratification, scattered singletons.
- **TensorObjSubstrate family (122)** — cover once A.1.c.sub stabilises (covering
  a churning lane is wasted).
- **Review-agent items** (non-gating): resolve the bare Kleiman `\cref{}` labels
  (RelPicFunctor first, before A.1.c.fun prover dispatch) and the
  `Abelian.Ext.chgUnivLinearEquiv` name.
- No external reference was needed or unobtainable this iter.
