/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex

/-!
# Čech bridge — assembly layer

This file is the downstream assembly layer that consumes both:

- `AlgebraicGeometry.sectionCechComplex` (from `PresheafCech.lean`): the section Čech
  cochain complex `Č•(𝒰, F) : CochainComplex Ab ℕ` built cosimplicially from
  `alternatingCofaceMapComplex`.

- `AlgebraicGeometry.cechFreePresheafComplex` (from `FreePresheafComplex.lean`): the
  free-presheaf chain complex `K(𝒰)_• : ChainComplex X.PresheafOfModules ℕ` whose
  degree-`p` term is `∐_{σ : Fin(p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)`.

The reason this file must sit downstream of both is that `FreePresheafComplex.lean`
already imports `PresheafCech.lean`, so any file needing both must import
`FreePresheafComplex.lean` (which transitively brings in `PresheafCech.lean`).

## Declarations (to be filled by the prover)

- `cechComplex_hom_identification` (planned): a per-degree `Ab`-isomorphism
  `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)` intertwining the differentials, assembled with
  `HomologicalComplex.Hom.isoOfComponents`.

- `injective_cech_acyclic` (planned): Čech cohomology vanishes in positive degrees for
  injective sheaves, established via `cechComplex_hom_identification`.

- `ses_cech_h1` (planned): the short exact sequence in Čech H¹ induced by a short exact
  sequence of sheaves.

- `cech_eq_cohomology_of_basis` / `affine_serre_vanishing` (planned): the comparison
  isomorphism `Ȟ•(𝒰, F) ≅ H•(X, F)` on affine schemes / for acyclic covers, leading to
  Serre's vanishing theorem.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-
Planner strategy for `cechComplex_hom_identification`:
────────────────────────────────────────────────────────────────────────────────

Goal: construct a cochain-complex isomorphism
  `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)`
where:
  • `K(𝒰)_p = ∐_{σ : Fin(p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)`
    (the degree-`p` term of `cechFreePresheafComplex 𝒰`)
  • `Č^p(𝒰, F) = ∏_{σ : Fin(p+1) → 𝒰.I₀} F.obj (coverInterOpen 𝒰 σ)`
    (the degree-`p` term of `sectionCechComplex 𝒰 F`)
  Both complexes live in `Ab` after applying the global-sections functor.

Step 1 — per-degree hom-coproduct duality:
  For each `p`, the Yoneda/free-presheaf adjunction gives
    `Hom(freeYoneda.obj V, F) ≅ F.obj V`  (natural in `V`).
  This is exactly `AlgebraicGeometry.freeYonedaHomAddEquiv` from `PresheafCech.lean`.
  Combined with the coproduct-hom identity
    `Hom(∐_σ A_σ, F) ≅ ∏_σ Hom(A_σ, F)`
  (via `preadditiveYoneda` preservation of limits, or hand-rolled from
  `Limits.Sigma.desc` / `Limits.Sigma.ι`), we get a degree-wise `Ab`-iso
    `Hom(K(𝒰)_p, F) ≅ ∏_σ F.obj (coverInterOpen 𝒰 σ) = Č^p(𝒰, F)`.

Step 2 — differential intertwining:
  Show that the degree-wise isos commute with the differentials.  The differential on
  `Hom(K(𝒰)_•, F)` is precomposition with the Čech boundary `d_p : K(𝒰)_{p+1} → K(𝒰)_p`
  (the alternating sum of face maps of `cechFreeSimplicial`).  The differential on
  `Č•(𝒰, F)` is the alternating sum of restriction maps built by `sectionCechComplex`.
  These match under the per-degree iso by naturality of `freeYonedaHomAddEquiv`.

Step 3 — assemble:
  Use `HomologicalComplex.Hom.isoOfComponents` (or equivalent) to combine the per-degree
  isos into a full cochain-complex iso, supplying the naturality squares from Step 2.

Key API:
  • `AlgebraicGeometry.freeYonedaHomAddEquiv` (PresheafCech.lean): the per-degree iso.
  • `Limits.Sigma.desc`, `Limits.Sigma.ι`: coproduct universal property in
    `X.PresheafOfModules`.
  • `HomologicalComplex.Hom.isoOfComponents`: assemble component-wise isos into a
    full complex iso.
  • `sectionCechComplex` (PresheafCech.lean): the target complex.
  • `cechFreePresheafComplex` / `cechFreePresheafComplex_X` (FreePresheafComplex.lean):
    the source complex and its degreewise unfolding lemma.
-/

end AlgebraicGeometry
