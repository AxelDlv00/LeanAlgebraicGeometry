# Iter 015 — Objectives detail

## Lane 1 — FBC: `Cohomology/FlatBaseChange.lean` [prove]

**Target:** Seam 2 `base_change_mate_fstar_reindex` (`sorry` ~1170) → Seam 3
`base_change_mate_gstar_transpose` (~1215) → `affineBaseChange_pushforward_iso` (~1388).

Seam 2 = the **generic-pullback-square pseudofunctor reindex** (fundamentally different from Seam 1's
adjunction-unit identity). From the iter-014 FBC task-result roadmap:
- Identify legs `pullback.fst`/`pullback.snd` with `Spec inclA`/`Spec inclR'` through `pullbackSpecIso`
  via `pullback_fst_snd_specMap_tensor` — mirror the existing `base_change_mate_codomain_read`
  scaffold (it already uses `pullback_fst_snd_specMap_tensor` + `pullbackSpecIso` + `unit_iso`).
- Transport the 3 pushforward coherences (`pushforwardComp ×2`, `pushforwardCongr`) through that
  reindexing; the `(g')`-unit's Γ-value is then Seam 1 `base_change_mate_unit_value` (proven iter-014).
- Expect the Seam-1 assembly discipline: `simp only [← Functor.comp_map]` / `Functor.comp_map` + `erw`
  for defeq matching on functor-composition object forms (`G.obj (F.obj X)` vs `(F⋙G).obj X`).
Seam 3: the `rw [Functor.map_comp]` prefix already splits the goal; uses Seam 2 + `pullback_spec_tilde_iso`.
Closing Seam 3 auto-lands `section_identity`/`generator_trace`/`cancelBaseChange` (proven mod Seam 3).
OUT OF SCOPE: `flatBaseChange_pushforward_isIso` (~1410, FBC-B).

## Lane 2 — GF: `Picard/FlatteningStratification.lean` [prove]

**Target:** L5 `exists_free_localizationAway_polynomial` (`sorry` ~1337) → L4
`exists_localizationAway_finite_mvPolynomial` (~516) → `genericFlatnessAlgebraic` (~1404).

L5 5-step assembly (chapter `lem:gf_polynomial_core` proof, expanded this iter + inline steps):
1. equip `T = N⧸range φ` with `Module.Finite P_d T` (quotient of finite `N`) + restricted
   `Module A T` / `IsScalarTower A P_d T`;
2. `gf_torsion_reindex A d hd T hTtors` (closed iter-014) ⟹ `g ≠ 0`, `m' < d`,
   `Module.Finite A_g[X_{m'}] T_g`;
3. base-generalised IH at `A_g` (`Nat.strong_induction_on d` with the base domain reverted into the
   motive — load-bearing; see chapter LEAN PROOF STRUCTURE note);
4. descend the witness `A_g → A` via `free_localizationAway_of_free_of_eq_mul` (L3b), `f := g·a`;
5. splice the localised SES `0 → (P_d^{⊕m})_f → N_f → T_f → 0` (free ends) via
   `exists_free_localizationAway_of_shortExact` (L3).
Steps 1 & 5 carry restriction-of-scalars / SES-localisation plumbing.
L4: Finset-fold over `gf_clear_one_denominator`; discharge a `RingHom.Finite` goal (not `Module.Finite`)
when calling `gf_mvPolynomial_quotient_finite_monic`.
OUT OF SCOPE: `genericFlatness` (~1471, GF-geo).
Recipe: `analogies/gf-generic-rank-ses.md`; helper blocks now in the chapter.

## Lane 3 — QUOT: `Picard/QuotScheme.lean` [prover-mode: mathlib-build]

**Target:** build the graded-module API into `AlgebraicGeometry.GradedModule`, axiom-clean, as far as
possible. Build order **G1→G2→G5→G3→G4→D5→assembly** (`lem:gradedHilbertSerre_rational` is the eventual
assembly consumer). Unconditional commitment (progress-critic STUCK corrective) — must not be displaced.

| Step | `\lean{}` pin (`AlgebraicGeometry.GradedModule.*`) | blueprint label | note |
|---|---|---|---|
| G1 | `homogeneousSubmodule_decomposition` | `lem:graded_homogeneousSubmodule_decomposition` | no deps; over `HomogeneousSubmodule` |
| G2 | `quotient_decomposition` | `lem:graded_quotient_decomposition` | uses G1 + `QuotSMulTop` |
| G5 | `finite_over_quotient` | `lem:graded_finite_transfer` | finiteness transfer |
| G3 | `quotientRing_gradedRing` | `lem:graded_quotientRing_gradedRing` | **real new theory** — `GradedRing` on `R/(x)` |
| G4 | `regrade_over_quotient` | `lem:graded_regrade_over_quotient` | regrade |
| D5 | `degreewise_finrank_diff` | `lem:graded_degreewise_finrank_diff` | rank-nullity, avoids graded objects |

Wraps EXISTING Mathlib scaffold (`HomogeneousSubmodule`, `QuotSMulTop`, `Ideal.homogeneous_span`,
rank-nullity, `Submodule.FG.restrictScalars_of_surjective`) — NOT from scratch. Power-series engine
(`IsRatHilb`, 8 decls) already in-file. Plan: `analogies/quot-graded-module-api.md`.
mathlib-build invariant: no `sorry` — each step fully proved or absent; stop only when genuinely
blocked and hand off a precise decomposition for iter-016.
OUT OF SCOPE: the 4 downstream `hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`representable` stubs.
