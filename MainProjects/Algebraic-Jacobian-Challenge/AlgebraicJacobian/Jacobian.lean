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

One of the five is of a different *kind* from the other four, and the difference decides what
can be done about it. `Pic0.smooth`, `Pic0.proper` and leaves B and C are *unproved*: each is
a true statement awaiting a proof. Leaf A is *false* over a general base field, so
`picardJacobianWitness` rests on an inconsistent hypothesis and its consequences are
vacuously true — a state no axiom check can distinguish from an honest one. Over an
algebraically closed field that leaf is a theorem
(`hasRationalPoint_of_curve_of_isAlgClosed`), and `picardJacobianWitnessOfIsAlgClosed`
assembles the same witness with it supplied rather than assumed. That is the version of the
headline whose open obligations are all of the ordinary kind.

What that does *not* do is reduce the count, and the tempting arithmetic here is wrong.
`Scheme.Pic0Scheme` carries `[Scheme.HasPicScheme C]`, whose sole producer is the
`sorry`-bodied `Scheme.instHasPicScheme`. Over a general field that gate is reached *through*
leaf A, so counting it separately looks like double-counting; discharging leaf A makes it
*fire* rather than removing it, and it stands free over `k̄`. So the obligations over `k̄`
number five as well — `instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, leaves B and C — with
the difference that all five are true. `scripts/axiom-frontier.lean` §0b measures this instead
of asserting it.

The three leaves are each stated at exactly the strength the assembly consumes:

- `hasRationalPoint_of_curve` — the one genuine hypothesis gap: a `k`-rational point on
  `C`, which the challenge hypotheses do not give and which is false in general. It is a
  gap marker to be *replaced*, not proved (see the leaf's docstring). The former
  combined leaf also asserted geometric integrality; that half is now the theorem
  `geometricallyIntegral_of_curve`, so the gap is exactly the rational point. Over an
  algebraically closed field the gap closes outright:
  `hasRationalPoint_of_curve_of_isAlgClosed` is a theorem with clean axioms, so the leaf
  is a gap only over a general base field, and `picardJacobianWitnessOfIsAlgClosed`
  assembles the witness over `k̄` with it supplied rather than assumed — five obligations
  still, but every one of them true.
- `smoothOfRelativeDimension_genus_pic0` — bare smoothness of `Pic⁰_{C/k}` refined to
  relative dimension `genus C`. Note this refines `Pic0.smooth`, which is itself
  unproved, so the leaf presupposes an obligation rather than resting on one.
  `finrank_tangentSpace_pic0_eq_genus` measures what remains: the *dimension count*
  `dim T_e Pic⁰_{C/k} = genus C` is landed mathematics and holds here with no transport,
  so the leaf owes `Pic0.smooth` plus a translation between two invariants of smoothness
  — the tangent-space dimension and the rank of `Ω`, which is what Mathlib's
  presentation-based `SmoothOfRelativeDimension` is characterised by — and nothing else.
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

Factoring the assembly this way is what makes the two witnesses below *specialisations*
rather than duplicated code: `picardJacobianWitness` supplies the binder from the false
gap marker `hasRationalPoint_of_curve`, `picardJacobianWitnessOfIsAlgClosed` from the
theorem `hasRationalPoint_of_curve_of_isAlgClosed`, and neither repeats a field. It also
gives branch (1) of the open decision a compiled form: a headline that carries
`C(k) ≠ ∅` as a hypothesis is exactly this definition, so that branch costs no new
mathematics — a fact worth having checked by the elaborator rather than described in
prose. Branch (2), étale sheafification, is *not* obtainable from here: it needs a
different representability input and would replace `Scheme.instHasPicScheme` rather than
supply its hypothesis. Recording both branches is not the same as being able to build
both, and this definition is honest about which one it reaches.

Nothing here chooses a branch. Both consumers below are kept, and the general-field one
remains the default. -/
noncomputable def picardJacobianWitnessOfHasRationalPoint (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [Scheme.HasRationalPoint C] :
    JacobianWitness C where
  J := Scheme.Pic0Scheme C
  grpObj := (Scheme.Pic0.grpObj C).some
  proper := Scheme.Pic0.proper C
  smooth := Scheme.Pic0.smooth C
  geomIrred := Scheme.Pic0.geometricallyIrreducible C
  smoothGenus := smoothOfRelativeDimension_genus_pic0 C
  isAlbaneseFor := fun P => isAlbanese_pic0 C _ _ _ _ P

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

The construction is **wired to the Picard development**: the underlying scheme
is `Scheme.Pic0Scheme C`, and four of the six witness fields are theorems of
`Picard/Pic0AbelianVariety.lean` applied directly. Those fields live in
`picardJacobianWitnessOfHasRationalPoint`, of which this definition is the specialisation
supplying the rational point from leaf A; splitting them apart separates the assembly
from the open decision about where the point comes from. This definition carries no
`sorry` of its own, but that is a statement about this file, not a completeness claim: two
of those four upstream theorems (`Pic0.smooth`, `Pic0.proper`) are `sorry`-bodied, so
the witness depends on five open obligations — those two, plus the three leaves
`hasRationalPoint_of_curve`, `smoothOfRelativeDimension_genus_pic0` and
`isAlbanese_pic0` above. The `GeometricallyIntegral` hypothesis of the Picard
development is *not* among them: it is synthesised from the challenge hypotheses
through `Smooth.geometricallyIntegral` (see `geometricallyIntegral_of_curve`). -/
noncomputable def picardJacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  haveI := hasRationalPoint_of_curve C
  picardJacobianWitnessOfHasRationalPoint C

/-- **The witness over an algebraically closed field, free of the inconsistent leaf.**

The same assembly as `picardJacobianWitness` — both are
`picardJacobianWitnessOfHasRationalPoint` — differing in exactly one thing: the rational
point is supplied by the theorem `hasRationalPoint_of_curve_of_isAlgClosed` rather than by
the gap marker `hasRationalPoint_of_curve`. Since the shared assembly is now a single
definition, that one difference is the *only* difference, which the elaborator checks
rather than the reader. The distinction is not cosmetic and is the reason this
definition exists separately.

`hasRationalPoint_of_curve` is *false* as stated, so every consequence of
`picardJacobianWitness` is a consequence of an inconsistent hypothesis: true, but with no
content, and no axiom check can see the difference. Here the same assembly runs on a
hypothesis that holds, so the obligations that remain are all *true statements awaiting
proofs*: `Scheme.instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, and leaves B and C.
Closing those five closes this definition; closing them would *not* give
`picardJacobianWitness` content over a general field, because leaf A must be replaced there
rather than proved.

The count is **five, not four**, and the reason is worth stating because the natural
arithmetic gets it wrong. Discharging leaf A does not remove the representability gate — it
makes `instHasPicScheme` *fire* instead of being assumed, since `Scheme.Pic0Scheme` carries
`[Scheme.HasPicScheme C]` and that `sorry`-bodied instance is its sole producer. Over a
general field the gate sits *behind* leaf A, which is what makes counting it separately look
like double-counting; over `k̄` it stands free. `scripts/axiom-frontier.lean` §0b measures
this rather than asserting it: naming `Pic0Scheme` with leaf A discharged and neither
`Pic0.smooth`, `Pic0.proper`, nor leaves B and C anywhere in the term still reports `sorryAx`,
while the control that assumes the gate is clean. So what this definition buys is not a
smaller count — it is that every remaining obligation is of the ordinary kind.

Both are kept: this one records what is actually reachable, and the general one keeps the
open decision visible where a reader of the headline meets it. -/
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
