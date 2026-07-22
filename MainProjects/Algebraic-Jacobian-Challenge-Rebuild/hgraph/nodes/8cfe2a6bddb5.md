---
author: sync
content_type: instance
created: '2026-07-16T21:33:28'
decl: search
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
title: search
type: lean
updated: '2026-07-16T21:33:28'
---
instance search finds it; since `(overSpec k R).left = Spec (.of R)` holds by `rfl` the
re-keyed forms apply on the nose).  The bridge between the scheme-side base rings
`Γ(Spec R, ⊤)` and the algebra-side rings `R` is crossed exactly twice, abstractly: by
`isLocalization_away_sections` (transport of the canonical localization along `ΓSpecIso`
via `IsLocalization.of_ringEquiv_left`) and by the elementwise naturality lemmas
`ΓSpecIso_hom_appTop` / `ΓSpecIso_inv_appTop`.  The `A`-algebra structures on the
section rings are the composites through the canonical `R`-structures
(`algebraA_sections`); all of these are `local instance`s — consumers reactivate them
with `attribute [local instance]`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace

open scoped TensorProduct

namespace AlgebraicGeometry

/-! ## Section rings on basic opens as localizations of the ring itself -/

/-- Elementwise `ΓSpecIso`-naturality: `ΓSpecIso.hom` intertwines `(Spec.map f).appTop`
with `f`. -/
lemma ΓSpecIso_hom_appTop {R S : CommRingCat.{u}} (f : R ⟶ S) (x : Γ(Spec R, ⊤)) :
    (Scheme.ΓSpecIso S).hom.hom ((Spec.map f).appTop.hom x)
      = f.hom ((Scheme.ΓSpecIso R).hom.hom x) := by
  have h := congrArg (fun (g : Γ(Spec R, ⊤) ⟶ S) => g.hom x) (Scheme.ΓSpecIso_naturality f)
  simp only [CommRingCat.hom_comp, RingHom.comp_apply] at h
  exact h

/-- Elementwise round-trip of `ΓSpecIso`. -/
lemma ΓSpecIso_inv_hom (R : CommRingCat.{u}) (x : Γ(Spec R, ⊤)) :
    (Scheme.ΓSpecIso R).inv.hom ((Scheme.ΓSpecIso R).hom.hom x) = x := by
  rw [← CommRingCat.comp_apply, Iso.hom_inv_id, CommRingCat.id_apply]

/-- The canonical `R`-algebra structure on the section rings of `Spec R` — the structure
map is `ΓSpecIso.inv` followed by restriction, definitionally as in mathlib's
`algebraMap_Spec_obj` — keyed on the bare ring `R` rather than on `↑(CommRingCat.of R)`
so that instance search finds it (local to this file). -/
noncomputable local instance specSectionsAlgebra (R : Type u) [CommRing R]
    (U : (Spec (CommRingCat.of R)).Opens) : Algebra R Γ(Spec (CommRingCat.of R), U) :=
  (((Spec (CommRingCat.of R)).presheaf.map (homOfLE le_top).op).hom.comp
    (Scheme.ΓSpecIso (CommRingCat.of R)).inv.hom).toAlgebra