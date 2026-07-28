/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Curve.GeometricallyReduced
import AlgebraicJacobian.Picard.Pic0AbelianVariety
import AlgebraicJacobian.Picard.Pic0Et
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

`picardJacobianWitness` is wired to the `Pic⁰_{C/k}` development in its **étale** form
(`Picard/Pic0Et.lean`): the witness scheme is `Scheme.Pic0SchemeEt C`, the identity
component of the scheme representing the *étale-sheafified* relative Picard functor. It
carries **no hypothesis on `C(k)`** — exactly the three challenge hypotheses and nothing
else — which is the owner decision of 2026-07-28 (protection I-0491) and the full strength
the challenge asks for.

Why sheafifying is what makes that possible. The unsheafified functor
`T ↦ Pic(C ×_k T)/π_T^* Pic(T)` is not a sheaf even Zariski-locally, and a representable
functor is a sheaf for any subcanonical topology, so representability of *it* over an
arbitrary field is a **false** statement rather than an unproved one. The étale
sheafification is Kleiman's own object; its sheaf property is *proved* in
`Picard/PicEtSheaf.lean` (`picEt_isSheaf_forget`), not assumed.

## The five obligations, and none of them is false

Be precise about what the wiring buys, because "invoked upstream" is not "proved
upstream". The witness reaches **five** open obligations:

1. `Scheme.fgaPicardRepresentability` — representability of the étale-sheafified functor
   over an arbitrary field (`Picard/FGAPicRepresentability.lean`). The project's central
   open obligation, expected to stay open;
2. `Scheme.Pic0Et.geometricallyReduced` — Cartier's theorem in characteristic zero, a
   genuine statement in characteristic `p`;
3. `Scheme.Pic0Et.universallyClosed` — Kleiman §5 Thm. `th:qpp&p`;
4. `smoothOfRelativeDimension_genus_pic0Et`, 5. `isAlbanese_pic0Et` — the two leaves
   stated below, each at exactly the strength the assembly consumes.

Note (2) and (3) rather than smoothness and properness: `Pic0Et.smooth` and
`Pic0Et.proper` are **assemblies** over them, not obligations of their own, and citing
them as the open statements is a stale reading. What *is* proved unconditionally, and
measures axiom-clean: `Pic0Et.grpObj`, `Pic0Et.geometricallyIrreducible`,
`Pic0Et.locallyOfFiniteType`, `Pic0Et.isSeparated`.

**All five are true statements awaiting proofs**, and that is the substance of the 2026-07-28
change rather than the count. The former leaf `hasRationalPoint_of_curve` asserted a
`k`-rational point from the challenge hypotheses alone; it was *false*, so the witness rested
on an inconsistent hypothesis and its consequences were vacuously true — a state no axiom
check can distinguish from an honest one. It has been deleted, never proved. The count was
five before and is five now; what changed is that no obligation is a false statement any
more.

That the headline carries no rational-point binder is **checked**, not asserted: the
`HeadlineBinders` section of `scripts/axiom-frontier.lean` elaborates every headline
declaration under exactly the three challenge hypotheses and stops compiling if a
`[HasRationalPoint _]` binder ever returns.

Two conditional results are kept beside the headline and **neither may be presented as
it**: `picardJacobianWitnessOfHasRationalPoint`, the same assembly on the *unsheafified*
functor with `C(k) ≠ ∅` as a hypothesis (true, strictly weaker than the challenge), and
`picardJacobianWitnessOfIsAlgClosed`, a genuine theorem over `k̄`. Their gate
`Scheme.HasPicScheme` has no instance: its only producer is the named theorem
`Scheme.picSchemeOfHasRationalPoint`, so nothing acquires a rational point by synthesis.

The two étale leaves are each stated at exactly the strength the assembly consumes, and
each carries a *companion* measuring what the landed development already reaches, so the
remaining distance is compiler-checked rather than described:

- `smoothOfRelativeDimension_genus_pic0Et` — bare smoothness of `Pic⁰_{C/k}` refined to
  relative dimension `genus C`. `finrank_tangentSpace_pic0_eq_genus` measures what remains:
  the *dimension count* `dim T_e Pic⁰_{C/k} = genus C` is landed mathematics, so the leaf
  owes a translation between two invariants of smoothness — the tangent-space dimension and
  the rank of `Ω`, which is what Mathlib's presentation-based `SmoothOfRelativeDimension`
  is characterised by — plus the transport of that landed chain from `Pic0Scheme` to
  `Pic0SchemeEt`, which is the honest extra cost of the étale formulation here.
- `isAlbanese_pic0Et` — the Albanese universal property over an arbitrary base field and
  for every marked point, where the landed proof covers the algebraically closed,
  positive-genus case. `isAlbanese_pic0_of_isAlgClosed` measures the distance exactly:
  in that case the universal property *is* the landed
  `Albanese.Pic0.albanese_universal_property` with no transport, and what the leaf adds
  is arbitrary base field, genus `0`, and the basepoint condition `P ≫ ι_P = η`.

The `picSharp`-shaped leaves `smoothOfRelativeDimension_genus_pic0` and `isAlbanese_pic0`
are retained below: they are the obligations of the *conditional* milestone
`picardJacobianWitnessOfHasRationalPoint`, not of the headline.

The file contains:
- `IsAlbanese`: the Albanese universal property for a pointed curve.
- `IsAlbanese.unique`: uniqueness of the Albanese object up to canonical isomorphism.
- `JacobianWitness`: a bundled candidate Albanese object together with the universal
  property uniformly over the choice of $k$-rational marked point.
- `geometricallyIntegral_of_curve`: the Picard development's `GeometricallyIntegral`
  hypothesis, derived from the challenge hypotheses.
- `finrank_tangentSpace_pic0_eq_genus` and `isAlbanese_pic0_of_isAlgClosed`: the parts of
  leaves B and C that the landed development already proves, stated at the headline so
  that each leaf's remaining distance is compiler-checked rather than described.
- `hasRationalPoint_of_curve_of_isAlgClosed` and `picardJacobianWitnessOfIsAlgClosed`:
  leaf A discharged over an algebraically closed field, and the witness assembled without
  the inconsistent leaf. Unlike the two companions above the first of these is axiom-clean
  and is a discharge rather than a record of distance.
- `picardJacobianWitnessOfHasRationalPoint`: the assembly itself, with the rational point
  as a hypothesis rather than a source. Both witnesses below are `haveI` specialisations of
  it, so neither repeats a field, and it is the compiled form of branch (1) of the open
  decision — a headline carrying `C(k) ≠ ∅` needs no new mathematics beyond this. Branch
  (2) is not reachable from it; see its docstring.
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

/-! ### Former leaf A: the `k`-rational point — DELETED, not proved

**The decision is made and this is not an open branch** (owner decision of 2026-07-28,
protection I-0491). The Jacobian headline is stated over an arbitrary field with no
rational-point binder, and the étale-sheafified relative Picard functor is what gets
represented (`Scheme.PicScheme.picEt` and `Scheme.fgaPicardRepresentability`,
`Picard/PicEtSheaf.lean` and `Picard/FGAPicRepresentability.lean`). Sheafifying supplies
étale-locally what a section supplies globally, which is why Kleiman's theorem needs no
section; and Mathlib `v4.31` carries the étale topology, so this was never a platform
limitation.

The former leaf
`hasRationalPoint_of_curve` asserted `Scheme.HasRationalPoint C` from the challenge
hypotheses alone. That statement is **false**, not merely unproved: a smooth proper
geometrically integral curve over a general field need not have a `k`-rational point.
While it existed, every consequence of `picardJacobianWitness` rested on an inconsistent
hypothesis, so those consequences were vacuously true and no axiom check could tell the
difference.

It has been removed rather than proved, and nothing may reintroduce it. What replaced it
is not a different proof of the same statement but a different *statement*: the
representability obligation is now taken for the **étale-sheafified** relative Picard
functor (`Scheme.fgaPicardRepresentability`, `Picard/FGAPicRepresentability.lean`),
which is Kleiman's own formulation and needs no hypothesis on `C(k)`. The rational point
survives only where it is a theorem (`hasRationalPoint_of_curve_of_isAlgClosed`, over
`k̄`) or an explicit hypothesis (`picardJacobianWitnessOfHasRationalPoint`). -/

/-- **Leaf A over an algebraically closed field: a theorem, not a decision.**

The rational point is the one leaf of the witness whose statement is *false* over a general
base field, and therefore the one leaf that cannot be closed by proving it. Over an
algebraically closed field it is not merely provable but proved, by the landed
`Albanese.hasRationalPoint_of_isAlgClosed`: the curve is irreducible over the one-point base
and locally of finite type, hence a Jacobson space, so it has a closed point, and over
`k = k̄` a closed point *is* a `k`-rational section.

This delimits the open decision precisely. What is undecided is not whether a smooth proper
geometrically irreducible curve has a rational point over *some* field — it does over `k̄` —
but which of the two honest formulations the project claims over an arbitrary `k`: represent
`Pic^♯_{C/k}` and carry `C(k) ≠ ∅` as a hypothesis, or represent the étale sheafification
`Pic_{(C/k)ét}` and carry no such hypothesis. Both remain recorded, neither is assumed.

Unlike leaves B and C, whose `_of_isAlgClosed` companions record a *distance* and report
`sorryAx`, this one is a genuine discharge: its axioms are `[propext, Classical.choice,
Quot.sound]`. What it does **not** do is reduce the count. Over `k̄` the witness still rests
on five obligations — `Scheme.instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, and leaves B
and C — because discharging this leaf makes the representability gate *fire* rather than
removing it (`Scheme.Pic0Scheme` carries `[Scheme.HasPicScheme C]`, and that `sorry`-bodied
instance is its sole producer). What the discharge changes is the *kind* of every remaining
obligation: all five are then true statements awaiting proofs.
`scripts/axiom-frontier.lean` §0b measures this rather than asserting it. -/
theorem hasRationalPoint_of_curve_of_isAlgClosed [IsAlgClosed k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    Scheme.HasRationalPoint C :=
  hasRationalPoint_of_isAlgClosed C

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

/-! ### The étale leaves: B and C for the headline witness

The two leaves above and below are stated for `Scheme.Pic0Scheme C`, the identity
component of the scheme representing the *unsheafified* functor, so they carry
`[Scheme.HasPicScheme C]` — a hypothesis whose only producer is now the conditional
`Scheme.picSchemeOfHasRationalPoint`. The headline witness is assembled instead from
`Scheme.Pic0SchemeEt C` (`Picard/Pic0Et.lean`), so it needs the same two statements
there. These are those statements. Each is a **true** statement awaiting a proof, and
neither carries a hypothesis on `C(k)`. -/

/-- **Leaf B, étale formulation: the dimension refinement.**

`Scheme.Pic0Et.smooth` gives bare smoothness of `Pic⁰_{C/k}` over `k`; the witness field
`smoothGenus` needs it at the specific relative dimension `genus C`. Kleiman §5 Thm 5.11:
the tangent space at the identity is `H¹(C, 𝒪_C)`, of dimension `genus C` by definition
of `genus`, and for a smooth group scheme the relative dimension is the dimension of that
tangent space.

What it owes over and above the `picSharp` leaf `smoothOfRelativeDimension_genus_pic0` is
the same two steps recorded there — `Pic0Et.smooth` itself, plus the translation between
a tangent-space dimension and Mathlib's presentation-based `SmoothOfRelativeDimension`
(which is characterised by `Module.rank S Ω[S⁄R]`, a different invariant) — with one
addition: the landed dimension chain
`Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` is stated for `Pic0Scheme`,
so transporting it to `Pic0SchemeEt` needs the comparison of the two Picard schemes,
which is available only under a section. That transport is the honest remaining cost of
the étale formulation at this leaf, and it is why this is a separate statement rather
than a corollary. -/
theorem smoothOfRelativeDimension_genus_pic0Et (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] :
    SmoothOfRelativeDimension (genus C) (Scheme.Pic0SchemeEt C).hom :=
  sorry

/-- **Leaf B's dimension count, at the headline and against the landed development.**

The number `genus C` in leaf B is not an arbitrary index: it is the dimension of the
Zariski tangent space of `Pic⁰_{C/k}` at the identity, and *that* identity is landed
mathematics (`Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne`, the Kleiman §5
Thm 5.11 chain through the truncated-exponential splitting and the Mayer–Vietoris
comparison). Since `genus C` is by definition `dim_k H¹(C, 𝒪_C)`, the two sides match
with no transport, exactly as leaf C's `isAlbanese_pic0_of_isAlgClosed` matches
`Albanese.Pic0.albanese_universal_property`.

Stating it here fixes what leaf B still owes, which is easy to misjudge from the leaf
alone. It is *not* the dimension count. It is the two steps that turn a tangent-space
dimension into a relative dimension:

1. `Scheme.Pic0.smooth` — bare smoothness of `Pic⁰_{C/k}` over `k`, itself `sorry`-bodied
   upstream, so leaf B presupposes an obligation rather than reducing one. That obligation
   is smaller than it looks, and worth stating here because it changes what a reader should
   expect to have to build: its *entire* remaining content is
   `GeometricallyReduced (Pic⁰_{C/k}).hom`. Mathlib's public `smooth_of_grpObj` takes
   `[LocallyOfFiniteType f]`, `[GrpObj (Over.mk f)]` and `[GeometricallyReduced f]` and
   returns `Smooth f` over an arbitrary field, so the translation argument that propagates
   smoothness from the identity is already done there; the first two inputs are landed
   (`Pic0.locallyOfFiniteType`, `Pic0.grpObj`) and elaborate at these hypotheses verbatim,
   while `GeometricallyReduced` does not synthesize and its only producer in the tree is
   `Smooth.geometricallyReduced`, which would be circular. So `Pic0.smooth` is Cartier's
   theorem in characteristic zero and a genuine characteristic-`p` statement otherwise —
   not a translation argument. "Entire remaining content" is meant strictly, and it is
   measured rather than estimated: the conclusion of `Pic0.smooth`, proved at that
   theorem's binders verbatim with `GeometricallyReduced` as the sole added hypothesis, is
   **axiom-clean** — `[propext, Classical.choice, Quot.sound]`, where `Pic0.smooth` itself
   reports `sorryAx`. So supplying geometric reducedness discharges it outright, with no
   residual leak elsewhere in the assembly;
2. the passage from "smooth, with `dim_{κ(e)} T_e = n`" to
   `SmoothOfRelativeDimension n`. Mathlib defines the latter by local standard-smooth
   presentations, not by a tangent-space dimension. There *is* a bridge, but it is at the
   algebra level and it goes through a different invariant:
   `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` characterises
   relative dimension `n` as `Module.rank S Ω[S⁄R] = n`, the rank of the module of Kähler
   differentials. So the missing mathematics is (i) the identification of that rank with
   the tangent-space dimension at the identity — over a field these are dual to one
   another, but the statement has to be made and the duality is where a rank/`finrank`
   mismatch would bite — and (ii) the passage from an affine-local statement about
   presentations to the scheme-level class, which quantifies over an affine cover of
   `Pic⁰_{C/k}` rather than over a single point.

   This is worth stating precisely rather than as "no bridge exists", which an earlier
   version of this docstring claimed: the leaf's cost is a translation between two
   invariants of smoothness, not the construction of one from nothing.

Like `isAlbanese_pic0_of_isAlgClosed`, this is a faithful record of a distance rather
than a discharge: its axioms carry `sorryAx`, because the dimension chain it invokes
still rests on `Pic0.finrank_cotangentSpaceDual_eq_finrank_h1Cok`. -/
theorem finrank_tangentSpace_pic0_eq_genus (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [GeometricallyIntegral C.hom]
    [Scheme.HasPicScheme C] [Scheme.PicScheme.PicSchemeLocallyOfFiniteType C] :
    Module.finrank
        (IsLocalRing.ResidueField
          ((Scheme.Pic0Scheme C).left.presheaf.stalk
            ((Scheme.Pic0.identitySection C).base default)))
        (IsLocalRing.CotangentSpace
          ((Scheme.Pic0Scheme C).left.presheaf.stalk
            ((Scheme.Pic0.identitySection C).base default)))
      = genus C :=
  Scheme.Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne C

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

/-- **Leaf C, étale formulation: the Albanese universal property of `Pic⁰_{C/k}`.**

The same statement as `isAlbanese_pic0`, for the identity component of the scheme
representing the étale-sheafified functor — over an arbitrary base field, for every
`k`-rational marked point, and with **no hypothesis on `C(k)`**.

Its content over the landed `Albanese.Pic0.albanese_universal_property` is the three
pieces recorded on `isAlbanese_pic0_of_isAlgClosed`: arbitrary base field in place of
algebraically closed (the Galois-descent step of cluster `G`), `genus C = 0` as well as
positive genus (Mumford §4 rigidity), and the basepoint condition `P ≫ ι_P = η`. To those
the étale formulation adds the same transport `isAlbanese_pic0` does not need: the landed
Abel–Jacobi morphism `Pic0.abelJacobi` is constructed for `Pic0Scheme`, and carrying it
to `Pic0SchemeEt` is part of this leaf.

Note that the marked point `P` appears here as an argument, not as a hypothesis on `C`:
`IsAlbanese` is a statement *about* a pointing, and `JacobianWitness.isAlbaneseFor`
quantifies over all of them. That is exactly why the headline needs no rational point —
the witness scheme `J` is intrinsic to `C`, and only the universal morphism depends on a
choice of `P`, in the same way `Challenge.lean` binds a point only in
`AbelJacobi.Jacobian.ofCurve`. -/
theorem isAlbanese_pic0Et (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (grp : GrpObj (Scheme.Pic0SchemeEt C)) (pr : IsProper (Scheme.Pic0SchemeEt C).hom)
    (sm : Smooth (Scheme.Pic0SchemeEt C).hom)
    (gi : GeometricallyIrreducible (Scheme.Pic0SchemeEt C).hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
    @IsAlbanese k _ C P (Scheme.Pic0SchemeEt C) grp pr sm gi :=
  sorry

/-- **Leaf C in the case the landed proof covers**, over an algebraically closed field and
in positive genus, with the basepoint condition as an explicit hypothesis.

This is a theorem, and it is the honest measure of the distance between
`isAlbanese_pic0` and the Albanese development. The factorisation clause of `IsAlbanese`
-- the whole universal property -- is `Albanese.Pic0.albanese_universal_property` applied
directly, with no transport: `Pic0.jacobianScheme C` is `Scheme.Pic0Scheme C`, so the
statements match on the nose. What `isAlbanese_pic0` adds is therefore three pieces of
mathematics:

1. arbitrary base field, in place of algebraically closed -- the Galois-descent step of
   the campaign's cluster `G`;
2. `genus C = 0` as well as positive genus -- where `Pic⁰_{C/k} = Spec k` and the content
   is Mumford §4 rigidity;
3. the basepoint condition `P ≫ ι_P = η`, taken here as the hypothesis `hbase`.

There is no fourth difference. An earlier version of this docstring claimed a
"bookkeeping" one — that the extra `[GeometricallyIrreducible C.hom]` binder here, absent
from the general leaf, was needed because irreducibility is "not free at the binder even
though it is free mathematically". That is false, and it is the kind of claim worth
checking rather than repeating: `instGeometricallyIrreducibleOfGeometricallyIntegral`
synthesises it from `[GeometricallyIntegral C.hom]` directly, so the binder is redundant
and the statement elaborates unchanged without it. The binder is kept only because these
hypotheses mirror the witness's, and a redundant binder is harmless; what is *not*
harmless is a docstring asserting an obstruction that does not exist.

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

/-- **The assembly itself, with the rational point taken as a hypothesis.**

This is the mathematical content of the FGA route at the headline, separated from the
question of *where the rational point comes from* — which is the whole of the open decision
I-0372 and none of the assembly. Given `[Scheme.HasRationalPoint C]`, the identity component
`Pic⁰_{C/k}` carries a Jacobian witness, and the remaining obligations are the five
recorded in the file header: the representability gate `Scheme.instHasPicScheme` (which
this binder makes fire), the upstream `Pic0.smooth` and `Pic0.proper`, and leaves B and C.

**This is a CONDITIONAL milestone and NOT the headline** (owner decision of 2026-07-28,
protection I-0491 clause 4). It is true, it records exactly what a rational point buys, and
it is strictly weaker than the challenge, whose curve need not have one. It is retained
because the tangent-space development is written against the `picSharp` shape.

`picardJacobianWitnessOfIsAlgClosed` below is its specialisation to `k̄`, supplying the
binder from the theorem `hasRationalPoint_of_curve_of_isAlgClosed`. The headline
`picardJacobianWitness` is **not** a specialisation of this definition and does not route
through it: it is built on `Scheme.Pic0SchemeEt`, the identity component of the scheme
representing the *étale-sheafified* functor, which replaces `Scheme.HasPicScheme` rather
than supplying its hypothesis. That is why the headline carries no rational point while
this does.

Note the gate is named rather than synthesized: `Scheme.HasPicScheme` has no instance, so
`Scheme.picSchemeOfHasRationalPoint` is invoked explicitly here. Nothing in the tree
acquires a rational-point hypothesis by instance search. -/
noncomputable def picardJacobianWitnessOfHasRationalPoint (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [Scheme.HasRationalPoint C] :
    JacobianWitness C :=
  haveI : GeometricallyIntegral C.hom := geometricallyIntegral_of_curve C
  haveI := Scheme.picSchemeOfHasRationalPoint C
  { J := Scheme.Pic0Scheme C
    grpObj := (Scheme.Pic0.grpObj C).some
    proper := Scheme.Pic0.proper C
    smooth := Scheme.Pic0.smooth C
    geomIrred := Scheme.Pic0.geometricallyIrreducible C
    smoothGenus := smoothOfRelativeDimension_genus_pic0 C
    isAlbaneseFor := fun P => isAlbanese_pic0 C _ _ _ _ P }

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

**No hypothesis on `C(k)`.** The binders are exactly the three challenge hypotheses, which
is the owner decision of 2026-07-28 (protection I-0491) and the full strength the challenge
asks for. This is *not* a specialisation of
`picardJacobianWitnessOfHasRationalPoint`: it is wired to the **étale** Picard development,
with underlying scheme `Scheme.Pic0SchemeEt C` — the identity component of the scheme
representing the étale-sheafified relative Picard functor (`Picard/Pic0Et.lean`,
`Picard/FGAPicRepresentability.lean`). Sheafifying is what removes the rational point:
the unsheafified functor is not a sheaf, so representability of it over an arbitrary field
would be a *false* statement rather than an unproved one.

Four of the six witness fields come from theorems that are proved **unconditionally** and
measure axiom-clean (`Pic0Et.grpObj`, `Pic0Et.geometricallyIrreducible`, and through them
`Pic0Et.locallyOfFiniteType` / `Pic0Et.isSeparated`). This definition carries no `sorry` of
its own, but that is a statement about this file, not a completeness claim: it depends on
the five obligations enumerated in the file header —
`Scheme.fgaPicardRepresentability`, `Scheme.Pic0Et.geometricallyReduced`,
`Scheme.Pic0Et.universallyClosed`, `smoothOfRelativeDimension_genus_pic0Et` and
`isAlbanese_pic0Et` — every one of which is a **true statement awaiting a proof**. The
`GeometricallyIntegral` hypothesis of the Picard development is *not* among them: it is
synthesised from the challenge hypotheses through `Smooth.geometricallyIntegral` (see
`geometricallyIntegral_of_curve`). -/
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C where
  J := Scheme.Pic0SchemeEt C
  grpObj := (Scheme.Pic0Et.grpObj C).some
  proper := Scheme.Pic0Et.proper C
  smooth := Scheme.Pic0Et.smooth C
  geomIrred := Scheme.Pic0Et.geometricallyIrreducible C
  smoothGenus := smoothOfRelativeDimension_genus_pic0Et C
  isAlbaneseFor := fun P => isAlbanese_pic0Et C _ _ _ _ P

/-- **The witness over an algebraically closed field: a genuine `k̄` theorem.**

The same assembly as `picardJacobianWitnessOfHasRationalPoint`, with the rational point
supplied by the theorem `hasRationalPoint_of_curve_of_isAlgClosed` rather than assumed. Over
`k̄` a smooth proper geometrically irreducible curve really does have a rational point — the
curve is a nonempty Jacobson space and its closed points are rational — so this definition
records what the `picSharp` route actually reaches, with nothing false anywhere in it.

**It is not the headline** (owner decision of 2026-07-28, protection I-0491 clause 4). It is
a theorem about algebraically closed base fields, and the challenge asks for an arbitrary
one; that statement is `picardJacobianWitness`, which is built on the étale-sheafified
functor and does not pass through this definition or through
`picardJacobianWitnessOfHasRationalPoint`.

Its obligations are those of the `picSharp` route with the rational point discharged:
`Scheme.picSchemeOfHasRationalPoint`'s content (i.e. `Scheme.fgaPicardRepresentability`),
`Pic0.smooth`, `Pic0.proper`, and the two `picSharp`-shaped leaves
`smoothOfRelativeDimension_genus_pic0` / `isAlbanese_pic0`. Discharging the rational point
does not remove the representability gate — it makes it *fire* instead of being assumed,
since `Scheme.Pic0Scheme` carries `[Scheme.HasPicScheme C]` — so the count does not shrink
here either. What it buys is that every obligation is of the ordinary kind.

Both are kept: this one records what the `picSharp` route reaches over `k̄`, and the
headline states what the project claims over an arbitrary field. -/
noncomputable def picardJacobianWitnessOfIsAlgClosed [IsAlgClosed k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  haveI := hasRationalPoint_of_curve_of_isAlgClosed C
  picardJacobianWitnessOfHasRationalPoint C

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
