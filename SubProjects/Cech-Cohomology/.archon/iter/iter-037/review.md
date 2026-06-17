# iter-037 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead,
  `CechHigherDirectImage.lean:~679` frozen P5b). Both prover files 0-sorry.
- **Build:** GREEN. `QcohRestrictBasicOpen.lean` + `QcohTildeSections.lean` both `lake env lean … EXIT 0`,
  diagnostics empty; all 7 new decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Lanes planned 2, ran 2** (both `mathlib-build`, two `session_start` events). **+7 axiom-clean decls**
  (Lane A +5, Lane B +2); 0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 6** (1 pre-existing dead `CechAcyclic.affine` + 5 new
  helpers).
- `sync_leanok` ran for iter 37 (`sha 4f578c3`, +18/−0). `blueprint-doctor`: no structural findings.

## Headline — the CHURNING corrective worked: both Route B sub-bricks (B1, B2) closed
iter-037's plan responded to the progress-critic's CHURNING verdict (keystone absent ×5 iters, helpers
accumulating) by **building the bridge's leaves rather than re-attempting the absent keystone**, splitting
the B-chain into two cross-independent lanes. Both delivered their named targets:

- **Lane A `QcohRestrictBasicOpen.lean` (+5).** B2 `presentationOverBasicOpen` (restrict a presentation of
  `M.over U` to `M.over D(g)` via `pushforwardPushforwardEquivalence (Over.iteratedSliceEquiv W)` +
  `Presentation.map`/`ofIsIso`), plus four declarations that **close a documented Mathlib `## TODO`** —
  the continuity of `TopologicalSpace.Opens.overEquivalence` both ways
  (`overEquivalence_{functor,inverse}_{coverPreserving,isContinuous}`). The latter is the gateway B3's
  `pushforwardPushforwardEquivalence` instantiation requires on the slice↔subspace site equivalence.
- **Lane B `QcohTildeSections.lean` (+2).** B1 `qcoh_finite_presentation_cover` (refine the
  quasi-coherence cover of a qcoh `F` to a finite standard cover `D(g_j) ⊆ U_{φ(j)}` with `span{g_j}=⊤`,
  each carrying a presentation), plus the project-local helper `coversTop_iSup_eq_top`.

The named keystone `qcoh_section_isLocalizedModule` was correctly left ABSENT — gated to a future iter
pending the B3/B4 build + the `QcohRestrictBasicOpen` import (PROGRESS forbids the import until B3/B4
land). This is the first pair of named-target closures since the route entered its current phase.

## The stop is clean and lands on the single genuine remaining bridge
B3 `overBasicOpenIsoRestrict` is the one load-bearing build of Route B. Its site-equivalence half is now
CONTINUOUS both ways (the 4 new decls), so B3's `pushforwardPushforwardEquivalence` IsContinuous
obligations are discharged. The remaining work is the **structure-sheaf compatibility datum `φ/ψ/H₁/H₂`**:
unlike B2 (both ring sheaves were `…over` of the same base, related by `R.1.map_id`), B3's two ring
sheaves are genuinely different presentations of the structure sheaf, related by the open-immersion
`(specBasicOpen g).ι.appIso` — the same `appIso` `Scheme.Modules.restrictFunctor` uses. Real geometric
content, precisely located, decomposed by the prover into B3a/B3b/B3c. B4 is mechanical after B3.

## This iter's analysis
- **No forced mathematics; clean stops with named obstructions.** The mathlib-build no-sorry invariant
  held; both lanes delivered their provable leaves. The blocked B3/B4 were left ABSENT with a precise
  decomposition, not papered with a sorry.
- **No must-fix from any of the three reviewers.** lean-auditor `iter037` (0 critical/2 major/4 minor),
  lvb `qrbo` (0 red flags, 3 major adequacy gaps), lvb `qts` (0 red flags, 2 major bookkeeping gaps). All
  7 decls genuine, non-vacuous, axiom-clean; the 4 `overEquivalence` decls confirmed NOT circular.
- **All findings are documentation/coverage/blueprint-adequacy, not correctness:** (a) 4 `overEquivalence`
  decls + `coversTop_iSup_eq_top` need blueprint blocks (coverage debt, unmatched=6); (b) B3 sketch
  under-specified (missing B3a/B3b/B3c) — a blueprint-writer item BEFORE the next prover lane; (c) B2
  `\uses` omits `pushforwardPushforwardEquivalence`/`Presentation.ofIsIso`; (d) two comment-only staleness
  items (`CompatiblePreserving` docstring; undocumented transparency `set_option`); (e) a flagged
  `\leanok`-sync gap on `isLocalizedModule_of_span_cover` (P1b) — sync likely can't resolve the 7 private
  helper names in its `\lean{}` list. All surfaced to the planner in `recommendations.md`.

## Markers / coverage
- **Manual marker edits (2 stale `% NOTE` strips):** `lem:qcoh_finite_presentation_cover` (B1) and
  `lem:presentation_over_basicOpen` (B2) — both now formalized + `\leanok` (sync added them), so their
  `% NOTE: to-build` annotations were stale and removed. B3/B4/keystone `% NOTE: to-build` left in place.
- **No `\mathlibok`:** the 4 `overEquivalence` continuity decls are PROJECT theorems (genuine
  `CoverPreserving`/`IsContinuous` proofs closing a Mathlib TODO), not re-exports — they need real
  blueprint blocks, not `\mathlibok`. No `\leanok` touched. No `\lean{}` renames (names match pins).
- **Coverage debt = 6 unmatched:** listed in `recommendations.md` for the planner to blueprint.

## Blueprint-doctor
Clean — every chapter `\input`'d, every `\ref`/`\uses` resolves, no new `axiom` decls.

## Subagent skips
(none — all three highly-recommended review subagents dispatched: lean-auditor `iter037`,
lean-vs-blueprint-checker `qrbo` + `qts`.)
