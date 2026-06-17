# Iter 021 — Review (Quot-Foundations)

## Verdict

Build GREEN (both prover-edited modules `lake build` EXIT 0; FBC 8318 jobs, GF 8317 jobs; only expected
`sorry` + linter/deprecation warnings; blueprint-doctor 0 findings; `sync_leanok` ran on this tree at
sha `9834fa4`, +24 `\leanok`, chapters_touched = `Picard_QuotScheme.tex`). **2 prover lanes (GF prove,
FBC prove) + 1 plan-phase enabling refactor (`quot-split`). Net −1 active sorry; +1 axiom-clean theorem
closed (GF L4).** Both prover-edited modules `lean_verify` axiom-clean (`{propext, Classical.choice,
Quot.sound}`). **Headline: the GF L4 finiteness leaf — deferred 3 iters and the progress-critic's
must-fix-this-iter — closed axiom-clean on the first genuine attempt**, vindicating the planner's
rebuttal of the GF-STUCK→pivot reading.

## Overall progress this iter (active `sorry` per file)

- **FlatteningStratification (GF) 3 → 2 (−1, +1 axiom-clean leaf)** —
  `exists_localizationAway_finite_mvPolynomial` (L4, `lem:gf_noether_clear_denominators`) CLOSED via the
  `g := g0·g1` two-factor witness + the collapsing lemma
  `IsIntegral.exists_multiple_integral_of_isLocalization`. `genericFlatnessAlgebraic` B/𝔭 cascade @2021
  advanced from a stale placeholder to a precise 4-step assembly route with one genuine new residual (the
  ring↔module localisation bridge). `genericFlatness` (GF-geo) @2109 untouched (out of scope; needs a
  finite-affine-cover chapter section first).
- **FlatBaseChange (FBC) 4 → 4 (net 0)** — `base_change_mate_gstar_transpose` @1551 PARTIAL: a 2-`rw`
  reframing (`Iso.inv_comp_eq, ← Iso.eq_comp_inv`) isolated the two geometric Γ-factors and the
  counit-conjugate route was pinned (`conjugateEquiv_counit_symm`, dual of proven Seam-1). Sorry remains.
  This seam bundles two pieces (inline inner-reindex + generator close), which is why it is harder than
  Seam-1. Dead `fstar_reindex_legs` @1421; affine @1724; FBC-B @1746 untouched.
- **QuotScheme (QUOT) 4 → 4 + GradedHilbertSerre.lean (NEW, 0 sorries)** — plan-phase file-split:
  `QuotScheme.lean` 1696→423 lines, graded Hilbert–Serre layer extracted to `GradedHilbertSerre.lean`
  (keystone axiom-clean), 11 toolkit decls de-privatized (clears M1), iter-020 stale-comment major
  removed. 4 protected stubs (@126/165/201/228) gated on upstream predicate builds.

## What shaped iter-022 (live frontiers)

1. **GF B/𝔭 cascade is now the highest-leverage GF target** — L1/L4/L5 all closed + axiom-clean, so the
   `genericFlatnessAlgebraic` quotient obligation @2021 is pure assembly EXCEPT the ring↔module
   localisation bridge (step 4). Cheapest path: a blueprint-writer round pinning the
   `LocalizedModule (powers g) C ≃ Localization.Away (algebraMap A C g)` `IsLocalizedModule`-uniqueness
   iso, then a prove pass. If it closes, GF-alg is DONE → open GF-geo `genericFlatness` (owes a
   finite-affine-cover chapter section).
2. **FBC `gstar_transpose` is a CONVERGING first-attempt** — route pinned, structure isolated. Next: the
   counit-conjugate close (`conjugateEquiv_counit_symm`) + inline piece-(a) (reuse PROVED
   `…_legs_unitExpand`/`_gammaDistribute`) + generator piece-(b). Whole-goal and per-generator brute force
   are confirmed dead ends — do NOT re-dispatch either. If it resists, effort-break into (a)/(b).
3. **FBC dead-code removal** (orphaned `fstar_reindex` apparatus + 5 superseded blueprint blocks) is owed
   in an FBC-no-prover slot (deferred iter-021 to avoid same-file conflict with the gstar prove).
4. **sync_leanok GF-chapter resolution failure** (see below) — the whole GF chapter shows 0 `\leanok`
   despite 3 axiom-clean public proved theorems. Recurring + now systemic; needs a sync-mechanism fix.

## Anomalies / debt surfaced

- **sync_leanok did NOT touch the GF chapter** despite L4 closing this iter (and L5/injectivity in prior
  iters). `Picard_FlatteningStratification.tex` has **0** `\leanok` markers across all blocks, including
  public sorry-free axiom-clean theorems. The dashboard materially under-reports GF. This subsumes the
  prior "11 private GF Nagata helpers invisible to sync" debt (018–021) but is broader: even **public**
  decls are unmarked. Not a marker the review agent owns — flagged for the planner/sync owner.
- **GF B/𝔠 cascade genuine new residual:** ring-localisation ↔ module-localisation bridge. Honest
  documented sorry, plan-sanctioned.
- **FBC 4 sorries** of which 1 is dead code (`fstar_reindex_legs`) awaiting removal.
- Both routes administratively OVER_BUDGET (estimate refresh, not a blocker).

## Subagent skips

- (none for the review phase — `lean-auditor` and both `lean-vs-blueprint-checker`s were dispatched.)
- strategy-critic / progress-critic / blueprint reviewers are plan-phase subagents; the planner
  dispatched progress-critic + blueprint-reviewer iter021 and recorded a strategy-critic skip rationale
  in `iter/iter-021/plan.md`.
