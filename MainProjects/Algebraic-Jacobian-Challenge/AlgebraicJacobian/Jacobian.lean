/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Picard.Pic0AbelianVariety

/-! # The Jacobian of a smooth proper curve

The Jacobian of a smooth, proper, geometrically irreducible curve over a field, equipped with
its structure as an abelian variety.

## Status

The Jacobian is defined uniformly as the underlying scheme of an Albanese witness
(`JacobianWitness`) for the curve `C`; the four protected instances on `Jacobian C` all
project from the witness directly.

The construction is **uniform in the genus**: the witness is the Picard identity
component `Pic⁰_{C/k}` (`picardJacobianWitness`), an abelian variety of dimension
`genus C` built by the FGA route (`AlgebraicJacobian.Picard.*` +
`AlgebraicJacobian.Albanese.*`). There is **no** genus `= 0` / genus `> 0` split: when
`genus C = 0` the tangent space `H¹(C, 𝒪_C)` is `0`-dimensional, so `Pic⁰_{C/k} = Spec k`
falls out automatically. The former separate `genusZeroWitness` lane (with its
`RigidityKbar` / cotangent-vanishing / Frobenius / `ℙ¹`-identification machinery) was a
pre-FGA local optimisation and has been removed.

`picardJacobianWitness` is wired to the landed `Pic⁰_{C/k}` development: the witness
scheme is `Scheme.Pic0Scheme C`, and its group, proper, smooth and geometrically
irreducible fields are the theorems of `Picard/Pic0AbelianVariety.lean`. What remains
open is isolated into three named leaves, each stated at exactly the strength the
assembly consumes:

- `hasRationalPoint_and_geometricallyIntegral` — the hypothesis gap. Geometric
  integrality follows from the ambient hypotheses; the `k`-rational point does not
  follow and is not implied by the challenge statement (see the leaf's docstring).
- `smoothOfRelativeDimension_genus_pic0` — bare smoothness of `Pic⁰_{C/k}` refined to
  relative dimension `genus C`.
- `isAlbanese_pic0` — the Albanese universal property over an arbitrary base field and
  for every marked point, where the landed proof covers the algebraically closed,
  positive-genus case.

The file contains:
- `IsAlbanese`: the Albanese universal property for a pointed curve.
- `IsAlbanese.unique`: uniqueness of the Albanese object up to canonical isomorphism.
- `JacobianWitness`: a bundled candidate Albanese object together with the universal
  property uniformly over the choice of $k$-rational marked point.
- the three leaves above, and `picardJacobianWitness`, the Albanese witness
  `J = Pic⁰_{C/k}` assembled from them with no `sorry` of its own.
- `nonempty_jacobianWitness`: existence of an Albanese witness for every curve,
  delegating to `picardJacobianWitness`.
- `Jacobian` and its four protected instances, each obtained by projection from the
  Albanese witness.

### Forbidden shortcut (sanity check)

Defining `Jacobian C := 𝟙_ (Over (Spec (.of k)))` *unconditionally* (the terminal object,
i.e. `Spec k`) compiles and discharges three of the four instances for free, but the
fourth instance `SmoothOfRelativeDimension (genus C) (𝟙_ _).hom` would force `genus C = 0`,
which is mathematically wrong for any curve of genus `≥ 1`. The terminal-object definition
is therefore forbidden when `genus C > 0`. The witness-based definition avoids this
issue: the witness's `J` is `Pic⁰_{C/k}`, which is `Spec k` exactly when `genus C = 0`
and the honest Albanese object otherwise.
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
def IsAlbanese (C : Over (Spec (.of k))) (P : 𝟙_ (Over (Spec (.of k))) ⟶ C)
    (J : Over (Spec (.of k)))
    [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom] : Prop :=
  ∃ α : C ⟶ J, P ≫ α = η[J] ∧
    ∀ {A : Over (Spec (.of k))} [GrpObj A] [IsProper A.hom]
      [Smooth A.hom] [GeometricallyIrreducible A.hom] (f : C ⟶ A) (_ : P ≫ f = η[A]),
      ∃! (g : J ⟶ A), f = α ≫ g

namespace IsAlbanese

noncomputable def ofCurve {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {P : 𝟙_ _ ⟶ C} {J : Over (Spec (.of k))} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J) : C ⟶ J :=
  Classical.choose h

lemma comp_ofCurve {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {P : 𝟙_ _ ⟶ C} {J : Over (Spec (.of k))} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J) :
    P ≫ h.ofCurve = η[J] :=
  (Classical.choose_spec h).1

lemma exists_unique_ofCurve_comp {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {P : 𝟙_ _ ⟶ C} {J : Over (Spec (.of k))} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J)
    {A : Over (Spec (.of k))} [GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom] (f : C ⟶ A) (hf : P ≫ f = η[A]) :
    ∃! (g : J ⟶ A), f = h.ofCurve ≫ g :=
  (Classical.choose_spec h).2 f hf

/-- The Albanese object is unique up to a unique isomorphism compatible with the
universal morphisms. -/
theorem unique {k : Type u} [Field k] {C : Over (Spec (.of k))} {P : 𝟙_ _ ⟶ C}
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
    refine hg₁_unique (g ≫ h) ?_
    change h₁.ofCurve = h₁.ofCurve ≫ (g ≫ h)
    rw [← Category.assoc, ← hg_eq, ← hh_eq]
  have hgh : g ≫ h = 𝟙 J₁ := by rw [ggh_eq_g₁, g₁_eq_id]
  have ⟨k₂, hk₂_eq, hk₂_unique⟩ := h₂.exists_unique_ofCurve_comp h₂.ofCurve h₂.comp_ofCurve
  have k₂_eq_id : k₂ = 𝟙 J₂ := by
    refine (hk₂_unique (𝟙 J₂) ?_).symm
    simp
  have hhg_eq_k₂ : h ≫ g = k₂ := by
    refine hk₂_unique (h ≫ g) ?_
    change h₂.ofCurve = h₂.ofCurve ≫ (h ≫ g)
    rw [← Category.assoc, ← hh_eq, ← hg_eq]
  have hhg : h ≫ g = 𝟙 J₂ := by rw [hhg_eq_k₂, k₂_eq_id]
  exact ⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩

end IsAlbanese

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


/-! ## The three open leaves of the witness

`picardJacobianWitness` below is assembled from the landed `Pic⁰_{C/k}` development
(`Picard/Pic0AbelianVariety.lean`) together with the three statements of this section.
They are the entire mathematical distance between the current tree and the headline;
everything else in the assembly is projection.

Each is stated at the exact strength the assembly consumes, so that a proof of the
three closes `picardJacobianWitness` with no further work. -/

/-- **Leaf A: the hypothesis gap between the challenge statement and `Pic⁰_{C/k}`.**

The ambient hypotheses of `Jacobian C` are `SmoothOfRelativeDimension 1`, `IsProper`
and `GeometricallyIrreducible`. The Picard development runs instead under
`GeometricallyIntegral` and `Scheme.HasRationalPoint`, and both extra hypotheses are
load-bearing rather than cosmetic:

* `GeometricallyIntegral C.hom` follows from the ambient hypotheses by pure geometry —
  a smooth morphism is geometrically reduced, and geometrically reduced plus
  geometrically irreducible is geometrically integral
  (`GeometricallyIntegral.of_geometricallyReduced_of_geometricallyIrreducible`). The
  missing input is the first implication, `Smooth ⟹ GeometricallyReduced`, which
  Mathlib `v4.31` does not carry.
* `Scheme.HasRationalPoint C` does **not** follow: a smooth proper geometrically
  integral curve over a field need not have a `k`-rational point (a genus-`0`
  conic without rational points, or the standard genus-`2` example over `ℚ`). It is
  available over an algebraically closed field only
  (`Albanese.hasRationalPoint_of_isAlgClosed`).

So this leaf is not one statement but two of very different natures, and the second is
where the challenge statement and the tree currently disagree: `Scheme.instHasPicScheme`
takes `[HasRationalPoint C]` and is correct to do so, because without a section
`Pic(C ×_k T)/π_T^* Pic(T)` need not even be a Zariski sheaf. Kleiman's theorem needs no
section because it represents the *étale* sheaf. The two ways to close the gap —
étale-sheafify the Picard functor, or carry the rational point as a hypothesis of the
headline and prove something weaker than the challenge asks — are a design decision, not
a platform limitation. -/
theorem hasRationalPoint_and_geometricallyIntegral (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    GeometricallyIntegral C.hom ∧ Scheme.HasRationalPoint C :=
  sorry

/-- **Leaf B: the dimension refinement.**

The landed `Scheme.Pic0.smooth` gives bare smoothness of `Pic⁰_{C/k}` over `k`; the
witness field `smoothGenus` needs it at the specific relative dimension `genus C`. The
mathematical content is Kleiman §5 Thm 5.11 together with `Scheme.Pic0.tangentSpaceIso`:
the tangent space at the identity is `H¹(C, 𝒪_C)`, of dimension `genus C` by definition
of `genus`, and for a smooth group scheme the relative dimension equals the dimension of
that tangent space. -/
theorem smoothOfRelativeDimension_genus_pic0 (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] [Scheme.PicScheme.PicSchemeLocallyOfFiniteType C] :
    SmoothOfRelativeDimension (genus C) (Scheme.Pic0Scheme C).hom :=
  sorry

/-- **Leaf C: the Albanese universal property, over an arbitrary field and every point.**

`Albanese.Pic0.albanese_universal_property` proves exactly this statement, but under two
restrictions the witness cannot accept: the base field is algebraically closed, and the
genus is positive. The witness needs the property over the ambient field `k` and for
*every* choice of `k`-rational marked point `P`, including `genus C = 0` (where
`Pic⁰_{C/k} = Spec k` and the content is the classical rigidity statement that every
pointed morphism from a genus-`0` curve to an abelian variety is constant).

Descending the algebraically-closed case to `k` is the Galois-descent step of the
campaign's cluster `G`; the genus-`0` case is Mumford §4 rigidity. -/
theorem isAlbanese_pic0 (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] [Scheme.PicScheme.PicSchemeLocallyOfFiniteType C]
    (grp : GrpObj (Scheme.Pic0Scheme C)) (pr : IsProper (Scheme.Pic0Scheme C).hom)
    (sm : Smooth (Scheme.Pic0Scheme C).hom)
    (gi : GeometricallyIrreducible (Scheme.Pic0Scheme C).hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    @IsAlbanese k _ C P (Scheme.Pic0Scheme C) grp pr sm gi :=
  sorry

/-- The Albanese witness for a smooth proper geometrically irreducible curve `C`,
constructed **uniformly in the genus** as the identity component `Pic⁰_{C/k}` of the
Picard scheme of `C`.

By the FGA route (`AlgebraicJacobian.Picard.*`), `Pic⁰_{C/k}` is representable
(`Scheme.PicScheme.representable`) and is an abelian variety of dimension `genus C`:
its tangent space at the identity is `H¹(C, 𝒪_C)` (`Scheme.Pic0.tangentSpaceIso`),
giving smoothness of relative dimension `genus C` (`Scheme.Pic0.smooth`), properness
(`Scheme.Pic0.proper`), and geometric irreducibility
(`Scheme.Pic0.geometricallyIrreducible`); the Albanese universal property is the
Abel–Jacobi factorisation of `AlgebraicJacobian.Albanese.AlbaneseUP`.

The genus-`0` case is **not** special and needs no separate construction: when
`genus C = 0` the tangent space is `0`-dimensional, so `Pic⁰_{C/k} = Spec k`
automatically, and the universal property degenerates to the (then trivial) statement
that every pointed morphism `C ⟶ A` into an abelian variety is constant. The former
`genusZeroWitness` / `positiveGenusWitness` genus split — together with its bespoke
rigidity / cotangent-vanishing / Frobenius / `ℙ¹`-identification machinery — has been
removed in favour of this single uniform witness.

The construction below is **wired to the landed Picard development**: the underlying
scheme is `Scheme.Pic0Scheme C`, and four of the six witness fields are the theorems of
`Picard/Pic0AbelianVariety.lean` applied directly. The remaining distance to the headline
is the three leaves `hasRationalPoint_and_geometricallyIntegral`,
`smoothOfRelativeDimension_genus_pic0` and `isAlbanese_pic0` above; this definition
carries no `sorry` of its own. -/
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C := by
  obtain ⟨hgi, hrp⟩ := hasRationalPoint_and_geometricallyIntegral C
  haveI := hgi
  haveI := hrp
  exact
    { J := Scheme.Pic0Scheme C
      grpObj := (Scheme.Pic0.grpObj C).some
      proper := Scheme.Pic0.proper C
      smooth := Scheme.Pic0.smooth C
      geomIrred := Scheme.Pic0.geometricallyIrreducible C
      smoothGenus := smoothOfRelativeDimension_genus_pic0 C
      isAlbaneseFor := fun P => isAlbanese_pic0 C _ _ _ _ P }

/-- Existence of an Albanese witness for every smooth proper geometrically irreducible
curve, uniformly in the genus via the Picard identity component `Pic⁰_{C/k}`
(`picardJacobianWitness`). This packages the five protected obligations (`Jacobian`,
`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`,
`instGeometricallyIrreducible`) into a single existence statement, and records that the
Albanese property of the underlying scheme `J` is uniform over every choice of
`k`-rational marked point `P : 𝟙_ _ ⟶ C` (via the `isAlbaneseFor` field of
`JacobianWitness`). -/
theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C) :=
  ⟨picardJacobianWitness C⟩

/-- A choice of Albanese witness for `C`, extracted via `Classical.choice`.
Used to define `Jacobian C` and to discharge each of the four protected instances
on it. -/
noncomputable def jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  Classical.choice (nonempty_jacobianWitness C)

-- data
/-- The Jacobian of a smooth, proper curve over a field `k`.

The Jacobian is the underlying scheme of an Albanese witness for `C` (see
`JacobianWitness` and `nonempty_jacobianWitness`), so it is `Pic⁰_{C/k}` for the
witness `picardJacobianWitness`, whose remaining content is the three leaves of
§"The three open leaves of the witness". The genus-`0`
specialisation is implicit in the witness — a smooth proper geometrically
irreducible group scheme over `k` of relative dimension `0` is `Spec k` — so
no separate genus-`0` construction is needed. -/
noncomputable def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    Over (Spec (.of k)) :=
  (jacobianWitness C).J

namespace Jacobian

/-! ## The Jacobian of `C` is an abelian variety. -/

-- data
/-- The group scheme structure on the Jacobian of the curve `C`. -/
noncomputable instance instGrpObj : GrpObj (Jacobian C) := (jacobianWitness C).grpObj

/-- The Jacobian of `C` is smooth of relative dimension `g` over `k`, where `g` is the
genus of `C`. -/
instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom :=
  (jacobianWitness C).smoothGenus

/-- The Jacobian of `C` is proper over `k`. -/
instance instIsProper : IsProper (Jacobian C).hom := (jacobianWitness C).proper

/-- The Jacobian of `C` is geometrically irreducible over `k`. -/
instance instGeometricallyIrreducible : GeometricallyIrreducible (Jacobian C).hom :=
  (jacobianWitness C).geomIrred

end Jacobian

end AlgebraicGeometry
