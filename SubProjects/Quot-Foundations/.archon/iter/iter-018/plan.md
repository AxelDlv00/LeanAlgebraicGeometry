# Iter 018 — Plan (Quot-Foundations)

## TL;DR

Coverage-debt + gate-confirmation iter with a **3-lane prover dispatch** (FBC, GF, QUOT), all
gate-clear. Entry: iter-017 landed all three lanes axiom-clean (GF L5 CLOSED — OreLocalization diamond
defused; FBC Seam-2 motive wall DISSOLVED + 4 sub-lemmas, content sorry isolated to one goal; QUOT D6
keystone + full ambient homogeneity calculus, +13 decls, no isDefEq pathology) but surfaced **16
unmatched `lean_aux` coverage-debt nodes**. This iter: cleared that debt via two blueprint-writers
(`fbc-pins018` = 5 Seam-2 pins; `quot-route2-018` = ~10 homogeneity-calculus blocks + the finiteness-
encoding recipe), ran blueprint-clean + a full blueprint-reviewer to re-confirm the HARD GATE (same-iter
fast path), addressed the one reviewer must-fix (deprecated Mathlib anchor), and dispatch all three
frontier lanes. The decisive judgement: FBC's progress-critic **CHURNING** is mechanical (PARTIAL≥3 +
sorry flat at 4), but the iter-017 wall-dissolution is genuine structural progress and the critic's own
corrective ("blueprint expansion of step-iii before the prover") was executed and reviewer-confirmed —
so the FBC dispatch is a prove pass on a single isolated goal, not a forbidden helper round.

## State at entry (iter-017 outcomes, verified)

- **FBC 4→4** — Seam-2 motive wall dissolved; `base_change_mate_fstar_reindex` sorry-free (reduces to
  `…_legs`); +4 axiom-clean sub-lemmas. Content sorry isolated to `base_change_mate_fstar_reindex_legs`
  step-iii (1324). Seam 3 (1428), affine (1601), FBC-B (1623) untouched.
- **FlatteningStratification 4→3** (−1) — GF L5 `exists_free_localizationAway_polynomial` CLOSED
  axiom-clean; `gf_torsion_reindex` signature simplified (redundant 6th existential dropped). L4 (516),
  `genericFlatnessAlgebraic` (1558), `genericFlatness` (1625) remain.
- **QuotScheme 4→4** (+13 axiom-clean) — D6 `subquotient_degreewise_diff` + `subquotientHilb` + ambient
  homogeneity calculus. Blocked on the finiteness encoding (build-size deferral, exact tool path
  scouted). 4 protected stubs unchanged.
- Build: all 3 modules GREEN under `lake build` (iter-017 prover + lean-auditor confirmed).

## Subagents dispatched (5; all returned)

- **progress-critic `iter018`** — FBC CHURNING (mechanical; corrective = blueprint expansion, executed),
  GF CONVERGING (OVER_BUDGET — refresh estimate), QUOT UNCLEAR (watch — structural advance by iter-019
  or STUCK). dispatch-sanity OK (3 files, within cap, no under-dispatch).
- **blueprint-writer `fbc-pins018`** — added 5 Seam-2 blocks (3 Γ-collapse + 2 variable-legs) with
  matched `\lean{}` pins + accurate `\uses{}`; wired concrete `fstar_reindex` → `…_legs`. leandag: 0
  isolated, 0 unknown_uses in the Seam-2 neighbourhood. Noted `base_change_regroup_linearEquiv` IS a
  live Lean decl with its own block (the directive's optional-fix premise was wrong) — left as-is.
- **blueprint-writer `quot-route2-018`** — added the "Ambient homogeneity calculus" subsubsection (10
  blocks) + an `adjoinCommRingOfComm` Mathlib anchor + the finiteness-encoding recipe in
  `finite_transfer`. Tightened `\uses{}` to actual Lean proof deps (e.g. `comap_isHomogeneous` does NOT
  use `decompose_raisesDegree_zero`; `map_isHomogeneous` does). Private `finrank_comap_subtype` left
  unblueprinted by design.
- **blueprint-clean `iter018`** — stripped Lean leakage from both edited chapters (finiteness-recipe
  prose de-Leaned; FBC dependent-type tactic talk → timeless math). Both chapters pure.
- **blueprint-reviewer `iter018`** — FBC Seam-2 GATE PASS, GF L4 GATE PASS, QUOT GATE PASS w/ one
  must-fix (deprecated `adjoinCommRingOfComm`). DAG clean (1 isolated = the expected private helper).

## Decision made

### 1. FBC CHURNING — rebut-via-corrective, not a silent override
- progress-critic flagged FBC CHURNING on the mechanical PARTIAL≥3 + sorry-flat-at-4 rule. I do NOT
  silently override. The critic's OWN primary corrective is **blueprint expansion of the step-iii
  sequence before the prover** — and it explicitly notes "the blueprint-writer directive already
  encodes this; it must run and be confirmed first." That corrective ran this iter (`fbc-pins018` added
  the `…_legs` block + step-iii sketch) and the blueprint-reviewer GATE-PASSED the step-iii description
  as "sufficient to formalize." So the FBC dispatch is the sanctioned post-corrective prove pass on a
  single isolated affine goal — NOT another helper round (the failure pattern CHURNING guards against).
  The iter-017 motive-wall dissolution is the structural advance the mechanical rule can't see.
- **Cheapest signal to reverse:** if the iter-018 FBC prover again returns PARTIAL with the step-iii
  goal unmoved AND adds a new helper, FBC flips to a genuine STUCK → next corrective is mathlib-analogist
  (cross-domain) on the mate-unwinding, or effort-break the step-iii goal further.

### 2. QUOT deprecated-anchor must-fix — fixed in-place
- blueprint-reviewer found the `adjoinCommRingOfComm` Mathlib anchor is deprecated. Verified the
  replacement `Algebra.isMulCommutative_adjoin` via LSP loogle ([verified]: `(R) (hcomm) :
  IsMulCommutative ↥(Algebra.adjoin R s)`). Repinned `lem:adjoinCommRingOfComm_mathlib`'s `\lean{}` +
  adjusted the prose (yields `IsMulCommutative`; `CommRing` by `inferInstance`). PROGRESS + the QUOT
  directive both name the non-deprecated route explicitly so the mathlib-build prover doesn't reach for
  the deprecated lemma.

### 3. File-split deferred (standing parallelism directive)
- The standing user PARALLELISM-VIA-FILE-SPLITTING directive flags the QUOT graded content for a
  `GradedHilbertSerre.lean` split. Deferred: the subquotient API is still growing (split mid-development
  = churn risk), and there is NO parallelism gain this iter (QUOT graded work is the only active QUOT
  lane; the Quot-defs P2 lane is not open). Re-engagement plan recorded in PROGRESS Next-iter ramp:
  split once `subquotient_hilbertSeries_rational` + the `(⊤,⊥)` bridge land, opening P2 in parallel.

## Subagent skips

- strategy-critic: STRATEGY.md changed only in status/estimate CELLS within existing phases (FBC-A
  Seam-2-wall-dissolved + step-iii residual; GF-alg L5-done + OVER_BUDGET; SNAP-S2 D6/homogeneity-done +
  finiteness-encoding residual & the `isMulCommutative_adjoin` gap) — NO route swap, NO decomposition
  change, NO phase add/remove. iter-016 verdict was SOUND with all must-fix addressed; no live CHALLENGE
  carries forward. Re-dispatch when the strategy SUBSTANCE next changes.

## Anti-fabrication / tool notes
- No external-source verification was synthesized. The one Mathlib-existence claim
  (`Algebra.isMulCommutative_adjoin`) was confirmed via the LSP loogle tool directly, not from memory.
- `archon-informal-agent.py` unavailable (no API key) — not relied on this iter.
