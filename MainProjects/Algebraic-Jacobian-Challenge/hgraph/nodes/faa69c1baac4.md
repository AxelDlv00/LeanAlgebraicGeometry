---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.trivialisation_telescope_assemble
docstring: '**Telescope seam 2 (blueprint `lem:trivialisation_telescope_assemble`):
  generic

  `ρ`-cancellation assembly of the five restriction-naturality squares.**


  Work in an arbitrary category `C` (sibling of `dual_scp_assemble` / `unit_assemble`
  /

  `hcore_assemble`).  Given the five `restrict j`-image constituents `dU₁,…,dU₅` (the

  `(restrict j)`-images of the `U`-built chain constituents `c^U_k`) and their `V`-built
  counterparts

  `cV₁,…,cV₅`, with the six reindexing isos `ρ₀,…,ρ₅`, suppose each constituent satisfies
  its

  restriction-naturality square

  `dU_k = ρ_{k-1}.hom ≫ cV_k ≫ ρ_k.inv`

  (so the target reindex `ρ_k` of square `k` is the source reindex of square `k+1`).  Then
  composing

  the five squares in order, the internal reindexings `ρ₁,…,ρ₄` cancel telescopically:

  `dU₁ ≫ ⋯ ≫ dU₅ = ρ₀.hom ≫ (cV₁ ≫ ⋯ ≫ cV₅) ≫ ρ₅.inv`,

  leaving only the two outer reindexings `ρ₀ = hobjU` and `ρ₅ = hobjV`.  Pure `Category.assoc`

  cocycle collapse; the statement lives over an abstract `[Category C]` and is applied
  to the concrete

  `SheafOfModules ≫` chain by `exact`/`refine` (defeq unification), NEVER by a keyed
  `rw`/`ext` on a

  conjugate-headed goal — this is what confines all seam-crossing.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/TrivialisationRestrict.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.trivialisation_telescope_assemble
type: lean
updated: '2026-07-24T03:02:12'
---
lemma trivialisation_telescope_assemble {C : Type*} [Category C]
    {O0 O1 O2 O3 O4 O5 P0 P1 P2 P3 P4 P5 : C}
    {dU1 : O0 ⟶ O1} {dU2 : O1 ⟶ O2} {dU3 : O2 ⟶ O3} {dU4 : O3 ⟶ O4} {dU5 : O4 ⟶ O5}
    {cV1 : P0 ⟶ P1} {cV2 : P1 ⟶ P2} {cV3 : P2 ⟶ P3} {cV4 : P3 ⟶ P4} {cV5 : P4 ⟶ P5}
    (ρ0 : O0 ≅ P0) (ρ1 : O1 ≅ P1) (ρ2 : O2 ≅ P2) (ρ3 : O3 ≅ P3) (ρ4 : O4 ≅ P4) (ρ5 : O5 ≅ P5)
    (h1 : dU1 = ρ0.hom ≫ cV1 ≫ ρ1.inv)
    (h2 : dU2 = ρ1.hom ≫ cV2 ≫ ρ2.inv)
    (h3 : dU3 = ρ2.hom ≫ cV3 ≫ ρ3.inv)
    (h4 : dU4 = ρ3.hom ≫ cV4 ≫ ρ4.inv)
    (h5 : dU5 = ρ4.hom ≫ cV5 ≫ ρ5.inv) :
    dU1 ≫ dU2 ≫ dU3 ≫ dU4 ≫ dU5
      = ρ0.hom ≫ (cV1 ≫ cV2 ≫ cV3 ≫ cV4 ≫ cV5) ≫ ρ5.inv := by
  subst h1 h2 h3 h4 h5
  simp only [Category.assoc, Iso.inv_hom_id_assoc]