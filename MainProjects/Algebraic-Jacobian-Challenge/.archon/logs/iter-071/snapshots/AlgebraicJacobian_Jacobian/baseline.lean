/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus

/-! # The Jacobian of a smooth proper curve

The Jacobian of a smooth, proper, geometrically irreducible curve over a field, equipped with
its structure as an abelian variety.

## Status (iteration 069 — Phase C scaffolding)

The genus-0 case is closed: `Jacobian C = 𝟙_ (Over (Spec (.of k)))` (the terminal object),
which is `Spec k` with its identity morphism. For `g > 0`, the definition reduces to the
Albanese construction (deferred).

The file now contains:
- `IsAlbanese`: the Albanese universal property for a pointed curve.
- `IsAlbanese.unique`: uniqueness of the Albanese object up to canonical isomorphism.
- Decomposition of the five protected sorries into genus-0 / genus-pos cases.

### Forbidden shortcut (sanity check)

Defining `Jacobian C := 𝟙_ (Over (Spec (.of k)))` *unconditionally* (the terminal object,
i.e. `Spec k`) compiles and discharges three of the four instances for free, but the
fourth instance `SmoothOfRelativeDimension (genus C) (𝟙_ _).hom` would force `genus C = 0`,
which is mathematically wrong for any curve of genus `≥ 1`. The terminal-object definition
is therefore forbidden when `genus C > 0`.

The iteration-069 resolution is a *conditional* use of the terminal object: it is used
exactly when `genus C = 0`, which is the mathematically correct answer for that case.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- The Albanese universal property for a pointed smooth proper curve `(C, P)`.
An object `J` (with abelian-variety structure) is the Albanese of `(C, P)` if it
receives a universal pointed morphism `C ⟶ J` sending `P` to the identity. -/
def IsAlbanese (C : Over (Spec (.of k))) (P : 𝟙_ _ ⟶ C) (J : Over (Spec (.of k)))
    [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom] : Prop :=
  ∃ (ι : C ⟶ J), P ≫ ι = η[J] ∧
    ∀ {A : Over (Spec (.of k))} [GrpObj A] [IsProper A.hom]
      [Smooth A.hom] [GeometricallyIrreducible A.hom] (f : C ⟶ A) (hf : P ≫ f = η[A]),
      ∃! (g : J ⟶ A), f = ι ≫ g

namespace IsAlbanese

noncomputable def ofCurve {C P J} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J) : C ⟶ J :=
  Classical.choose h

lemma comp_ofCurve {C P J} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J) :
    P ≫ h.ofCurve = η[J] :=
  (Classical.choose_spec h).1

lemma exists_unique_ofCurve_comp {C P J} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J)
    {A : Over (Spec (.of k))} [GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom] (f : C ⟶ A) (hf : P ≫ f = η[A]) :
    ∃! (g : J ⟶ A), f = h.ofCurve ≫ g :=
  (Classical.choose_spec h).2 f hf

/-- The Albanese object is unique up to a unique isomorphism compatible with the
universal morphisms. -/
theorem unique {C : Over (Spec (.of k))} {P : 𝟙_ _ ⟶ C}
    {J₁ J₂ : Over (Spec (.of k))}
    [GrpObj J₁] [IsProper J₁.hom] [Smooth J₁.hom] [GeometricallyIrreducible J₁.hom]
    [GrpObj J₂] [IsProper J₂.hom] [Smooth J₂.hom] [GeometricallyIrreducible J₂.hom]
    (h₁ : IsAlbanese C P J₁) (h₂ : IsAlbanese C P J₂) :
    ∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e := by
  have ⟨g, hg_eq, hg_unique⟩ := h₁.exists_unique_ofCurve_comp h₂.ofCurve h₂.comp_ofCurve
  have ⟨h, hh_eq, hh_unique⟩ := h₂.exists_unique_ofCurve_comp h₁.ofCurve h₁.comp_ofCurve
  have ⟨g₁, hg₁_eq, hg₁_unique⟩ := h₁.exists_unique_ofCurve_comp h₁.ofCurve h₁.comp_ofCurve
  have g₁_eq_id : g₁ = 𝟙 J₁ := by
    refine (hg₁_unique (𝟙 J₁) ?_).symm
    simp
  have ggh_eq_g₁ : g ≫ h = g₁ := by
    refine (hg₁_unique (g ≫ h) ?_).symm
    rw [Category.assoc, hg_eq, hh_eq]
  have hgh : g ≫ h = 𝟙 J₁ := by rw [ggh_eq_g₁, g₁_eq_id]
  have ⟨h₂, hh₂_eq, hh₂_unique⟩ := h₂.exists_unique_ofCurve_comp h₂.ofCurve h₂.comp_ofCurve
  have h₂_eq_id : h₂ = 𝟙 J₂ := by
    refine (hh₂_unique (𝟙 J₂) ?_).symm
    simp
  have hhg_eq_h₂ : h ≫ g = h₂ := by
    refine (hh₂_unique (h ≫ g) ?_).symm
    rw [Category.assoc, hh_eq, hg_eq]
  have hhg : h ≫ g = 𝟙 J₂ := by rw [hhg_eq_h₂, h₂_eq_id]
  use g
  constructor
  · exact hg_eq
  · intro g' hg'
    exact (hg_unique g' hg').symm

end IsAlbanese

/-- The identity morphism on `Spec k` is geometrically irreducible.
This is a small helper needed for the genus-0 case of `Jacobian`. -/
lemma geometricallyIrreducible_id_Spec (k : Type u) [Field k] :
    GeometricallyIrreducible (𝟙 (Spec (.of k))) := by
  constructor
  intro x K _ y Z fst snd h
  have : IsIso snd := h.isIso_snd_of_isIso
  rw [ObjectProperty.prop_iff_of_iso (IrreducibleSpace ·) (asIso snd)]
  infer_instance

-- data
/-- The Jacobian of a smooth, proper curve over a field `k`.

For genus `0`, the Jacobian is the terminal object `Spec k` (the trivial group scheme).
For genus `> 0`, the honest definition is the Albanese variety of `C`; the construction
is deferred to a future iteration. -/
noncomputable def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : Over (Spec (.of k)) :=
  if h : genus C = 0 then
    𝟙_ (Over (Spec (.of k)))
  else
    -- Phase C, iteration 069: Albanese construction for genus > 0.
    -- Blocked on: existence of symmetric powers of schemes, quotients by finite
    -- group actions, or a direct Picard-scheme representability theorem.
    sorry

namespace Jacobian

/-! ## The Jacobian of `C` is an abelian variety. -/

-- data
/-- The group scheme structure on the Jacobian of the curve `C`. -/
instance instGrpObj : GrpObj (Jacobian C) := by
  unfold Jacobian
  split_ifs
  · infer_instance
  · sorry

/-- The Jacobian of `C` is smooth of relative dimension `g` over `k`, where `g` is the
genus of `C`. -/
instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom := by
  unfold Jacobian
  split_ifs with h
  · rw [h]
    infer_instance
  · sorry

/-- The Jacobian of `C` is proper over `k`. -/
instance instIsProper : IsProper (Jacobian C).hom := by
  unfold Jacobian
  split_ifs
  · infer_instance
  · sorry

/-- The Jacobian of `C` is geometrically irreducible over `k`. -/
instance instGeometricallyIrreducible : GeometricallyIrreducible (Jacobian C).hom := by
  unfold Jacobian
  split_ifs
  · exact geometricallyIrreducible_id_Spec k
  · sorry

end Jacobian

end AlgebraicGeometry
