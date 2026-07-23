---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.rhoU_comp
docstring: 'Restriction-of-scalars transitivity: `(Γ(X,U) → Γ(X,V)) ∘ (A → Γ(X,U))
  = (A → Γ(X,V))`.

  Project-local glue making the structure-sheaf restriction maps `A`-linear.'
file: AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rhoU_comp
type: lean
updated: '2026-07-16T21:14:26'
---
theorem rhoU_comp {X : Scheme.{u}} {U V : X.Opens} (h : V ≤ U) :
    ((X.ringCatSheaf.obj.map (homOfLE h).op).hom).comp (rhoU X U) = rhoU X V := by
  ext a
  change (X.ringCatSheaf.obj.map (homOfLE h).op).hom (rhoU X U a) = rhoU X V a
  have e : (X.ringCatSheaf.obj.map (homOfLE (le_top) : V ⟶ ⊤).op)
      = (X.ringCatSheaf.obj.map (homOfLE (le_top) : U ⟶ ⊤).op)
          ≫ (X.ringCatSheaf.obj.map (homOfLE h).op) := by
    rw [← X.ringCatSheaf.obj.map_comp]; rfl
  simp only [rhoU, e, RingCat.hom_comp]; rfl