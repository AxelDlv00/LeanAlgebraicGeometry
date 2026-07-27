/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Curve.GeometricallyReduced
import AlgebraicJacobian.Picard.Pic0AbelianVariety
import AlgebraicJacobian.Albanese.AlbaneseUP

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

`picardJacobianWitness` is wired to the `Pic⁰_{C/k}` development: the witness scheme
is `Scheme.Pic0Scheme C`, and its four structural fields are the theorems of
`Picard/Pic0AbelianVariety.lean`. Be precise about what that buys, because
"invoked upstream" is not "proved upstream": of those four, `Pic0.grpObj` and
`Pic0.geometricallyIrreducible` are proved, while **`Pic0.smooth` and `Pic0.proper`
are themselves `sorry`-bodied**. So the witness reaches **five** open obligations,
not three: those two upstream, plus the three leaves below, which are the ones new
here. Proving only the three would leave `sorryAx` in the witness — verified with
`scripts/axiom-frontier.lean`.

The three leaves are each stated at exactly the strength the assembly consumes:

- `hasRationalPoint_of_curve` — the one genuine hypothesis gap: a `k`-rational point on
  `C`, which the challenge hypotheses do not give and which is false in general. It is a
  gap marker to be *replaced*, not proved (see the leaf's docstring). The former
  combined leaf also asserted geometric integrality; that half is now the theorem
  `geometricallyIntegral_of_curve`, so the gap is exactly the rational point.
- `smoothOfRelativeDimension_genus_pic0` — bare smoothness of `Pic⁰_{C/k}` refined to
  relative dimension `genus C`. Note this refines `Pic0.smooth`, which is itself
  unproved, so the leaf presupposes an obligation rather than resting on one.
- `isAlbanese_pic0` — the Albanese universal property over an arbitrary base field and
  for every marked point, where the landed proof covers the algebraically closed,
  positive-genus case. `isAlbanese_pic0_of_isAlgClosed` measures the distance exactly:
  in that case the universal property *is* the landed
  `Albanese.Pic0.albanese_universal_property` with no transport, and what the leaf adds
  is arbitrary base field, genus `0`, and the basepoint condition `P ≫ ι_P = η`.

The file contains:
- `IsAlbanese`: the Albanese universal property for a pointed curve.
- `IsAlbanese.unique`: uniqueness of the Albanese object up to canonical isomorphism.
- `JacobianWitness`: a bundled candidate Albanese object together with the universal
  property uniformly over the choice of $k$-rational marked point.
- `geometricallyIntegral_of_curve`: the Picard development's `GeometricallyIntegral`
  hypothesis, derived from the challenge hypotheses.
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
These three plus the two unproved upstream theorems named in the file header are the
entire mathematical distance between the current tree and the headline; everything else
in the assembly is projection.

Each is stated at the exact strength the assembly consumes, so that a proof of the
three closes `picardJacobianWitness` with no further work — up to the two `sorry`-bodied
upstream theorems `Pic0.smooth` and `Pic0.proper` recorded in the file header, which the
assembly invokes and which no leaf here covers. -/

/-! ### Leaf A, split: what follows from the challenge hypotheses and what does not

The ambient hypotheses of `Jacobian C` are `SmoothOfRelativeDimension 1`, `IsProper`
and `GeometricallyIrreducible`. The Picard development runs instead under
`GeometricallyIntegral` and `Scheme.HasRationalPoint`. These two extra hypotheses have
entirely different status, and conflating them hides where the mathematics actually
stops:

* `GeometricallyIntegral C.hom` **follows** from the ambient hypotheses. A smooth
  morphism is geometrically reduced (`Smooth.geometricallyReduced`, proved in
  `Curve/GeometricallyReduced.lean` over the standard-smooth structure theorem), and
  geometrically reduced plus geometrically irreducible is geometrically integral. Both
  steps are instances, so the upgrade is automatic; `geometricallyIntegral_of_curve`
  below records it as a named statement for the reader, and the assembly uses
  synthesis directly.
* `Scheme.HasRationalPoint C` does **not** follow, and cannot: a smooth proper
  geometrically integral curve over a field need not have a `k`-rational point (a
  conic without rational points has genus `0`; the standard genus-`2` examples over
  `ℚ` are pointless). It is available over an algebraically closed field only
  (`Albanese.hasRationalPoint_of_isAlgClosed`).
-/

/-- **Geometric integrality of the curve, from the challenge hypotheses alone.**

The Picard development's ambient hypothesis, derived rather than assumed: `Smooth`
gives `GeometricallyReduced` (`Smooth.geometricallyReduced`), and geometrically
reduced plus geometrically irreducible is geometrically integral. This half of the
former combined leaf is a theorem, not a decision.

Not an instance: `Smooth.geometricallyIntegral` in `Curve/GeometricallyReduced.lean`
already fires for this goal, and a second path would only slow synthesis down. It is
stated here so that the split of the former leaf `hasRationalPoint_and_geometricallyIntegral`
into a proved half and an open half is legible at the headline. -/
theorem geometricallyIntegral_of_curve (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    GeometricallyIntegral C.hom :=
  SmoothOfRelativeDimension.geometricallyIntegral 1 C.hom

/-- **Leaf A: the `k`-rational point.** The one genuine gap between the challenge
statement and the FGA route, and the only part of the former combined leaf that is a
decision rather than a theorem.

`Scheme.instHasPicScheme` takes `[HasRationalPoint C]` and is correct to do so: without
a section, `Pic(C ×_k T)/π_T^* Pic(T)` need not even be a Zariski sheaf. Kleiman's
theorem needs no section because it represents the *étale* sheaf, and sheafifying
supplies étale-locally what a section supplies globally. So the two ways to close the
gap are

1. carry `[Scheme.HasRationalPoint C]` as a hypothesis of the headline — cheap, and
   proves something strictly weaker than the challenge asks; or
2. étale-sheafify the relative Picard functor and represent that — Kleiman's own
   formulation, and the full strength, at the cost of a new representability input.

Neither is chosen (the decision is recorded as an open owner decision; see
`README.md` and `informal/pic-representability-campaign.md`), and it is not a platform
limitation: Mathlib `v4.31` does carry the étale topology.

**Read this leaf as a gap marker, not as an obligation to discharge.** The statement is
false as stated, so it is not merely unproved but unprovable, and everything downstream
of `picardJacobianWitness` currently rests on an inconsistent hypothesis rather than on
an open frontier. That is deliberate — it puts the gap where a reader of the headline
meets it, instead of leaving it implicit in the Picard hypotheses — but it means this
leaf must be **replaced** once the decision above is made, by either a rational-point
binder on the Jacobian itself or an étale-sheafified representability input. It must not
be "proved". -/
theorem hasRationalPoint_of_curve (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    Scheme.HasRationalPoint C :=
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
campaign's cluster `G`; the genus-`0` case is Mumford §4 rigidity.

`isAlbanese_pic0_of_isAlgClosed` below is the same statement in the case the landed
proof covers, and it is a theorem rather than a leaf: it shows the *only* content this
leaf adds over the landed `Albanese.Pic0.albanese_universal_property`, beyond the two
restrictions named above, is the basepoint condition. -/
theorem isAlbanese_pic0 (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] [Scheme.PicScheme.PicSchemeLocallyOfFiniteType C]
    (grp : GrpObj (Scheme.Pic0Scheme C)) (pr : IsProper (Scheme.Pic0Scheme C).hom)
    (sm : Smooth (Scheme.Pic0Scheme C).hom)
    (gi : GeometricallyIrreducible (Scheme.Pic0Scheme C).hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    @IsAlbanese k _ C P (Scheme.Pic0Scheme C) grp pr sm gi :=
  sorry

/-- **Leaf C in the case the landed proof covers**, over an algebraically closed field and
in positive genus, with the basepoint condition as an explicit hypothesis.

This is a theorem, and it is the honest measure of the distance between
`isAlbanese_pic0` and the Albanese development. The factorisation clause of `IsAlbanese`
-- the whole universal property -- is `Albanese.Pic0.albanese_universal_property` applied
directly, with no transport: `Pic0.jacobianScheme C` is `Scheme.Pic0Scheme C`, so the
statements match on the nose. What `isAlbanese_pic0` adds is therefore exactly three
things, and no more:

1. arbitrary base field, in place of algebraically closed -- the Galois-descent step of
   the campaign's cluster `G`;
2. `genus C = 0` as well as positive genus -- where `Pic⁰_{C/k} = Spec k` and the content
   is Mumford §4 rigidity;
3. the basepoint condition `P ≫ ι_P = η`, taken here as the hypothesis `hbase`.

The third is the one that is easy to lose sight of, because it is not a restriction on
the landed theorem's *hypotheses* but a conjunct of `IsAlbanese` that
`albanese_universal_property` does not state. In the Albanese development it is
`lem:abel_jacobi_morphism`: the restriction of the diagonal correspondence
`𝓛^{P₀} = 𝓞_{C × C}(Δ - \{P₀\} × C - C × \{P₀\})` to `C × \{P₀\}` is trivial, so the
moduli class of the basepoint is the identity. It is unproved because
`Pic0.abelJacobi` is itself unconstructed, and no statement of it can be discharged
before that morphism exists.

Note also what this does *not* establish. `Pic0.abelJacobi` is `sorry`-bodied, so this
theorem's own axioms carry `sorryAx` and it is not a discharge of anything; it is a
faithful record of where the mathematics stops, in a form the compiler checks. -/
theorem isAlbanese_pic0_of_isAlgClosed [IsAlgClosed k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] [Scheme.PicScheme.PicSchemeLocallyOfFiniteType C]
    (hg : 0 < genus C)
    (grp : GrpObj (Scheme.Pic0Scheme C)) (pr : IsProper (Scheme.Pic0Scheme C).hom)
    (sm : Smooth (Scheme.Pic0Scheme C).hom)
    (gi : GeometricallyIrreducible (Scheme.Pic0Scheme C).hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C)
    (hbase : P ≫ Pic0.abelJacobi C P = @MonObj.one _ _ _ _ grp.toMonObj) :
    @IsAlbanese k _ C P (Scheme.Pic0Scheme C) grp pr sm gi :=
  ⟨Pic0.abelJacobi C P, hbase, fun f hf => Pic0.albanese_universal_property C hg P f hf⟩

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

The construction below is **wired to the Picard development**: the underlying scheme
is `Scheme.Pic0Scheme C`, and four of the six witness fields are theorems of
`Picard/Pic0AbelianVariety.lean` applied directly. This definition carries no `sorry`
of its own, but that is a statement about this file, not a completeness claim: two of
those four upstream theorems (`Pic0.smooth`, `Pic0.proper`) are `sorry`-bodied, so
the witness depends on five open obligations — those two, plus the three leaves
`hasRationalPoint_of_curve`, `smoothOfRelativeDimension_genus_pic0` and
`isAlbanese_pic0` above. The `GeometricallyIntegral` hypothesis of the Picard
development is *not* among them: it is synthesised from the challenge hypotheses
through `Smooth.geometricallyIntegral` (see `geometricallyIntegral_of_curve`). -/
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C := by
  haveI := hasRationalPoint_of_curve C
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
§"The three open leaves of the witness" together with the two unproved upstream
theorems named in the file header. The genus-`0`
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
