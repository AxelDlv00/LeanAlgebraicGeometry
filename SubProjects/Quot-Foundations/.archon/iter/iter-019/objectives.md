# Iter 019 — Objectives detail

## Lane 1 — FBC `FlatBaseChange.lean` [fine-grained]
Decompose-and-close step-(iii). Create + prove 5 standalone atomic lemmas (blueprint blocks already
written by effort-breaker `fbc-step3`), bottom-up, then chain into
`base_change_mate_fstar_reindex_legs`. WHOLE-GOAL ATTEMPTS PROHIBITED.
- `base_change_mate_fstar_reindex_legs_unitExpand` — invert comp-coherence (the "invert key" move).
- `base_change_mate_fstar_reindex_legs_gammaDistribute` — distribute through `(Spec φ)_* ⋙ Γ`.
- `base_change_mate_fstar_reindex_legs_eCancel` — **load-bearing**, 3 cancellation pairs vs the codomain
  read internals; if it resists isolated, REPORT (queued: re-break one-lemma-per-pair).
- `base_change_mate_fstar_reindex_legs_affineUnit` — Seam 1 application + pushforward dictionary.
- `base_change_mate_fstar_reindex_legs_innerMatch` — `restr_ψ∘restr_φ(η_M)` transported = ρ; closes target.
- Then cascade Seam 3 `base_change_mate_gstar_transpose` as budget allows.
- Partial bar: `_unitExpand` + `_gammaDistribute` + `_eCancel`.

## Lane 2 — GF `FlatteningStratification.lean` [prove]
Close L4 `exists_localizationAway_finite_mvPolynomial` via expanded Step 3a/3b/3c:
- 3a: `ν := IsLocalization.Away.lift (algebraMap A B g) hunitg`, injective, `ν(b_j)=gK(X_j)`.
- 3b: injectivity of φ via `AlgHom.algebraicIndependent_iff` [expected] +
  `AlgebraicIndependent.restrictScalars` [expected] along `A_g↪K`.
- 3c: `g1` from folding `gf_clear_one_denominator` over σ; push monic relations through ν;
  `Algebra.IsIntegral.finite` [verified] ⟹ `Module.Finite A_g[X] B_g`.
- Then `genericFlatnessAlgebraic` (§4 dévissage) as budget allows. Partial bar: L4 close.

## Lane 3 — QUOT `QuotScheme.lean` [prove, TOP-DOWN]
Foundation COMPLETE — add NO more foundation. Build the induction body, leaving intermediate sorries
only at genuinely-blocked leaves:
1. `SubquotientDatum.ker`/`.coker` constructors (all fields ready except `hfin` ← step 2).
2. `subquotient_finite_transfer` via `Module.Finite.of_surjective` [verified] + the FREE-poly
   `Fin(r+1)↠Fin r` surjection + `ker_annihilate`/`coker_annihilate`.
3. `subquotient_hilbertSeries_rational` (P(r) induction): base via
   `finiteDimensional_of_mvPolynomial_isEmpty_finite` + `IsRatHilb.ofEventuallyZero`; step via
   D6 + IH + `IsRatHilb.ofDiffEq`/`.bump`.
4. `(⊤,⊥)` bridge ⟹ `gradedModule_hilbertSeries_rational` (KEYSTONE = success bar).
HARD ENTRY CONSTRAINT: ambient `Naux ⊓ ℳn` only; free poly ring only; any isDefEq/whnf recurrence ⇒ STOP.

## Gate status
All three chapters: blueprint-reviewer `iter019` = complete + correct, GATE OPEN, 0 must-fix.
