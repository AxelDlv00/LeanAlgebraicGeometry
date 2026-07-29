---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.overSpecMap_comp_section
docstring: 'Compatibility of the base-changed sections: restricting the section attached
  to a

  point `σ` over `A` along `Spec` of an `A`-algebra map `j` of covers lands at the
  section

  attached to the canonical point over the target algebra.'
file: AlgebraicJacobian/Picard/Rigidification.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Over.overSpecMap_comp_section
type: lean
updated: '2026-07-29T15:26:31'
---
private lemma overSpecMap_comp_section {E : Algebra.EtaleCover A} {R : Type u}
    [CommRing R] [Algebra k R] [Algebra A R] [IsScalarTower k A R]
    (j : E.Carrier →ₐ[A] R) (σ : overSpec k A ⟶ C) :
    Over.overSpecMap (j.restrictScalars k)
        ≫ (Over.overSpecMap ((Algebra.ofId A E.Carrier).restrictScalars k) ≫ σ)
      = Over.overSpecMap ((Algebra.ofId A R).restrictScalars k) ≫ σ := by
  have key : (j.restrictScalars k).comp ((Algebra.ofId A E.Carrier).restrictScalars k)
      = (Algebra.ofId A R).restrictScalars k := by
    refine AlgHom.ext fun a => ?_
    change j (Algebra.ofId A E.Carrier a) = Algebra.ofId A R a
    rw [Algebra.ofId_apply, Algebra.ofId_apply]
    exact j.commutes a
  rw [← Category.assoc, ← Over.overSpecMap_comp, key]