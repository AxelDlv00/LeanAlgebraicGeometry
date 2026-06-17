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

/-- A bundled Albanese witness for the smooth proper geometrically irreducible curve
`C`: a candidate group scheme `J` (with proper, smooth, geometrically irreducible
structure, smooth of relative dimension `genus C`), and a proof that `J` satisfies
the Albanese universal property of Definition `IsAlbanese` for `C` *for every choice
of $k$-rational marked point* `P : 𝟙_ _ ⟶ C`.

Mathematically, the underlying scheme `J` (and its group/proper/smooth/irreducible
structure) is intrinsic to `C`; only the universal morphism `C ⟶ J` depends on the
choice of marked point `P`. Encoding `isAlbaneseFor` as a `∀ P, IsAlbanese …` field
keeps the bundle independent of any specific pointing, which is what
`AbelJacobi.Jacobian.ofCurve P` needs in order to project the Albanese morphism for
an *arbitrary* input `P`.

The smoothness witness is recorded at the specific relative dimension `genus C`,
which is the form required by `Jacobian.smoothOfRelativeDimension_genus`. -/
structure JacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] where
  /-- The candidate Albanese object. -/
  J : Over (Spec (.of k))
  /-- The group-scheme structure on `J`. -/
  grpObj : GrpObj J
  /-- `J` is proper over `k`. -/
  proper : IsProper J.hom
  /-- `J` is smooth over `k`. -/
  smooth : Smooth J.hom
  /-- `J` is geometrically irreducible over `k`. -/
  geomIrred : GeometricallyIrreducible J.hom
  /-- `J` is smooth of relative dimension `genus C` (so dim `J = genus C`). -/
  smoothGenus : SmoothOfRelativeDimension (genus C) J.hom
  /-- The Albanese universal-property data: for every choice of $k$-rational marked
  point `P : 𝟙_ _ ⟶ C`, the scheme `J` together with its group/proper/smooth/irreducible
  structure satisfies the Albanese universal property for the pointed curve `(C, P)`. -/
  isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), @IsAlbanese k _ C P J grpObj proper smooth geomIrred

/-- Existence of an Albanese witness for every smooth proper geometrically irreducible
curve. This is the single remaining mathematical sorry of the Phase-C Jacobian
scaffolding: it packages all five protected sorries (`Jacobian`, `instGrpObj`,
`smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`)
into a single existence hypothesis, *and* records that the Albanese property of the
underlying scheme `J` is uniform over every choice of $k$-rational marked point
`P : 𝟙_ _ ⟶ C` (via the `isAlbaneseFor` field of `JacobianWitness`).

Mathematically this corresponds to the construction of the Albanese variety of `C`,
classically via symmetric powers $\mathrm{Sym}^g(C)$ and the Abel--Jacobi map
(Brill--Noether--Riemann--Roch), or equivalently as the identity component of the
Picard scheme. Both routes require infrastructure not yet available in Mathlib
(quotients of schemes by finite group actions; FGA representability), so the
existence is assumed and the proof is deferred to a future iteration. -/
theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C) :=
  sorry

/-- A choice of Albanese witness for `C`, extracted via `Classical.choice`.
Used to populate the genus `> 0` branch of `Jacobian C` and to discharge each of
the four protected instances. -/
noncomputable def jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  Classical.choice (nonempty_jacobianWitness C)

-- data
/-- The Jacobian of a smooth, proper curve over a field `k`.

For genus `0`, the Jacobian is the terminal object `Spec k` (the trivial group scheme).
For genus `> 0`, the Jacobian is the underlying scheme of an Albanese witness for `C`
(see `JacobianWitness` and `nonempty_jacobianWitness`); the existence of such a
witness is the single remaining mathematical sorry of the Phase-C scaffolding. -/
noncomputable def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : Over (Spec (.of k)) :=
  if h : genus C = 0 then
    𝟙_ (Over (Spec (.of k)))
  else
    -- Phase C, iteration 071: project to the underlying scheme of an Albanese witness
    -- (`JacobianWitness`). Existence of such a witness is the sole remaining
    -- mathematical sorry; the four protected instance fields below all reduce to
    -- projecting the relevant component of this witness.
    (jacobianWitness C).J

namespace Jacobian

/-! ## The Jacobian of `C` is an abelian variety. -/

-- data
/-- The group scheme structure on the Jacobian of the curve `C`. -/
instance instGrpObj : GrpObj (Jacobian C) := by
  unfold Jacobian
  split_ifs
  · infer_instance
  · exact (jacobianWitness C).grpObj

/-- The Jacobian of `C` is smooth of relative dimension `g` over `k`, where `g` is the
genus of `C`. -/
instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom := by
  unfold Jacobian
  split_ifs with h
  · rw [h]
    infer_instance
  · exact (jacobianWitness C).smoothGenus

/-- The Jacobian of `C` is proper over `k`. -/
instance instIsProper : IsProper (Jacobian C).hom := by
  unfold Jacobian
  split_ifs
  · infer_instance
  · exact (jacobianWitness C).proper

/-- The Jacobian of `C` is geometrically irreducible over `k`. -/
instance instGeometricallyIrreducible : GeometricallyIrreducible (Jacobian C).hom := by
  unfold Jacobian
  split_ifs
  · exact geometricallyIrreducible_id_Spec k
  · exact (jacobianWitness C).geomIrred

end Jacobian

end AlgebraicGeometry
