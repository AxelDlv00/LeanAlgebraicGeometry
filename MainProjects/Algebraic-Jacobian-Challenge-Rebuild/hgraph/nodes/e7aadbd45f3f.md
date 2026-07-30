---
author: sync
content_type: theorem
created: '2026-07-26T15:04:49'
decl: AlgebraicGeometry.DivRepAffinePullback.divFamZarAffineEquiv_pullGlobal
docstring: '**Affine consistency**: on an affine test the general-test pullback collapses

  through the affine comparison `divFamZarAffineEquiv` to the affine pullback `D.pull`

  of the package.'
file: AlgebraicJacobian/Picard/DivRepGlobalLift.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivRepAffinePullback.divFamZarAffineEquiv_pullGlobal
type: lean
updated: '2026-07-30T15:28:05'
---
theorem divFamZarAffineEquiv_pullGlobal
    (D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)
    (A : Type u) [CommRing A] [Algebra k A] (v : overSpec k A ⟶ DivOver) :
    divFamZarAffineEquiv C pi g A
        (pullGlobal (hpi := hpi) (g := g) (hO := hO) (hchi := hchi) (r1 := r1)
          (r2 := r2) (b1 := b1) (b2 := b2) D v)
      = D.pull A v := by
  have h := D.pull_naturality (Over.overSpecΓTopAlgEquiv k A).toAlgHom
    (Over.fromSpecAffine (overSpec k A) (overSpecTopAffine A) ≫ v)
  rw [← Category.assoc, Over.overSpecMap_ΓTop_fromSpecAffine_top A, Category.id_comp] at h
  rw [divFamZarAffineEquiv_apply]
  exact h.symm