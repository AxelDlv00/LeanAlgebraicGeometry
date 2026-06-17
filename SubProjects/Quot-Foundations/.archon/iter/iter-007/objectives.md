# Iter 007 — Objectives detail

## Dispatched this iter (prover lanes)

### QUOT-A — `Picard/QuotScheme.lean` [mathlib-build]
Build 3 NEW predicate/helper defs from `Picard_QuotScheme.tex` (none exist yet; the 4 typed-sorry
stubs are BLOCKED, untouched):
- `AlgebraicGeometry.Scheme.Modules.annihilator` — `def:modules_annihilator` (Archon-original; the
  ideal sheaf `Ann_{O_X(U)}(F(U))` on affine opens).
- `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank` — `def:is_locally_free_of_rank` (rank-`d`
  local freeness, locally `O_U^d`; Nitsure §1 Ex.2).
- `AlgebraicGeometry.sectionGradedRing` — `def:sectionGradedRing` (`⊕_{m≥0} Γ(X_s, L_s^⊗m)`; Nitsure §1).

### QUOT-B — `Picard/GrassmannianCells.lean` [prove]
Fill `affineChart (d r : ℕ) (I : Finset (Fin r)) : Scheme` sorry (line ~60, refactor-scaffolded):
`Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`. `def:gr_affine_chart`, Nitsure §1.

## Deferred (gate-cleared, iter-008 MANDATORY)

### FBC-A — `Cohomology/FlatBaseChange.lean`
Build+prove (iter-008): `base_change_mate_unit_value`, `base_change_mate_fstar_reindex`,
`base_change_mate_gstar_transpose` (3 new sub-lemmas) → thin `generator_trace_eq` assembly; close
`base_change_mate_regroupEquiv` `map_smul'` via route-(a) `TensorProduct.ext` at the full carrier
(in-code recipe: `restrictScalars.smul_def → ExtendScalars.smul_tmul → tmul_mul_tmul → helper simp`).
Fallback route-(b): ModuleCat base-change-square helper.

### GF-alg — `Picard/FlatteningStratification.lean`
iter-008 order: (1) restructure L5 `Nat.strong_induction_on` to generalize BASE DOMAIN `A` (revert
`A`+instances into the motive) — load-bearing; (2) build `gf_generic_rank_ses` from verified atoms
(`Module.finBasis`, `IsLocalizedModule.surj`, `LinearIndependent.restrict_scalars`,
`Fintype.linearCombination`; `m := finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`,
`T := N ⧸ range φ`, `Module.IsTorsion P_d T`, no g-inversion); (3) build the shared variable-drop engine
+ `gf_torsion_reindex` (`m'=d-1`, `Submodule.annihilator_top_inter_nonZeroDivisors`); (4) thin L5
assembly applying IH at base `A_g` + L3 splice. (5) L4 `gf_clear_one_denominator` + Finset-fold reuses
the engine. Full recipe + signatures: `analogies/gf-generic-rank-ses.md`.

## Verified-this-iter (Mathlib existence, expires next pin)
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` [verified] (`…AssociatedPrime.Finiteness`).
- `exists_finite_inj_algHom_of_fg` [verified].
- generic rank atoms `Module.finBasis`, `IsLocalizedModule.surj`, `LinearIndependent.restrict_scalars`,
  `Fintype.linearCombination`, `Submodule.annihilator_top_inter_nonZeroDivisors`, `MvPolynomial.instFree`
  [verified, analogist].
- `Mathlib.RingTheory.Flat.Equalizer` (`Module.Flat.ker_lTensor_eq`, `tensorEqLocusEquiv`) [verified,
  strategy-critic] — FBC-B.
- variable-drop / single-variable-Nagata-elimination + denominator clearing: [gap] Mathlib-absent,
  project build (shared L4 ↔ reindex).
