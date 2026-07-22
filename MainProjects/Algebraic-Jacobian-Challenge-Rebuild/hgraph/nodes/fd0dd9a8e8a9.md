---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.unitsPresheaf_forget
file: AlgebraicJacobian/Picard/UnitsPresheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.unitsPresheaf_forget
type: lean
updated: '2026-07-16T21:33:28'
---
lemma unitsPresheaf_forget₂_map_apply {U V : (X.Opens)ᵒᵖ} (i : U ⟶ V) (u : Γ(X, unop U)ˣ) :
    (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat).map i u
      = Units.map (X.presheaf.map i).hom u :=
  rfl

/-- Split form of `unitsPresheaf_forget₂_map_apply`: after `Functor.comp_map` has fired,
the restriction maps appear as `(forget₂ _ _).map (X.unitsPresheaf.map i)`. -/
@[simp]