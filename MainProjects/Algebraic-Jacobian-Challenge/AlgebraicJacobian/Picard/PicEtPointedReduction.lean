/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtGaloisQuotient
import AlgebraicJacobian.Picard.PicEtSubcanonical
import AlgebraicJacobian.Curve.GaloisLevelRationalPoint

/-!
# The arbitrary-field seam reduces to the POINTED Picard theorem

`Scheme.fgaPicardRepresentability` (`Picard/FGAPicRepresentability.lean`) is this
project's one open obligation. Its statement carries **no** hypothesis on `C(k)`,
by the owner decision `I-0491`, and that is exactly what makes it hard: the
classical FGA/Kleiman representability theorem, and the whole Milne–Kollár
campaign built to formalise it, produce a representing scheme only for a curve
that **has** a rational point.

This file removes that gap. It proves that **both** conjuncts of the seam, over an
**arbitrary** field, follow from the *pointed* statement — plus one geometric side
condition on the representing scheme, `FiniteInAffine`, which is the
action-free form of the EGA II 4.5.4 hypothesis and is true for quasi-projective
schemes.

## What is proved

* `seamClauseOne_of_pointedPicSharpRep` — clause (1), over an arbitrary `k`.
* `seamClauseTwo_of_pointedPicSharpRep` — clause (2). It needs the pointed
  antecedent **alone**: no Galois level, no quotient, no orbit hypothesis.
* `fgaPicardRepresentability_of_pointedPicSharpRep` — the seam statement itself,
  verbatim, as the conclusion of an implication.

## Why this is not a new hypothesis on the headline

`I-0491` forbids putting `[HasRationalPoint C]` on the headline. Nothing here
does: `PointedPicSharpRep` is a **closed** proposition quantifying over *all*
fields and *all* pointed curves, and the theorems below conclude about a curve
over an arbitrary `k` with no section. The rational point is produced, not
assumed — `Curve/GaloisLevelRationalPoint.lean`'s
`exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral` is
unconditional, so the curve reaches a finite Galois level carrying a point using
only the binders the seam already has. That is the step which turns a pointed
input into an arbitrary-field output, and it is where the descent machinery of
`Picard/PicEtGaloisQuotient.lean` is spent.

## The three landed facts this composes, and why nobody had composed them

Each was proved by a different lane for a different row; none of the three rows
mentions the other two.

1. `Scheme.exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral`
   (`Curve/GaloisLevelRationalPoint.lean`) — every curve with the seam's own
   binders has a rational point over *some* finite **Galois** `k''/k`. Not merely
   separable: `IsGalois` is what the semilinear-action machinery needs, and the
   normal-closure step in that file is what supplies it.
2. `Scheme.PicScheme.seamClauseOne_of_hasGaloisQuotient_lftFree`
   (`Picard/PicEtGaloisQuotient.lean`) — the descent step with `hq` **and** `hcov`
   already discharged internally. This is the fact that changes the price: the
   board row `AJC.picrep.etale-rep.descent-assembly` lists *four* inputs, and at
   this spelling three of them are gone (`hcov` closed by `pic-f`'s
   `coverSelfSection_generate_mem_etaleTopology`, the quotient by the **global**
   instance `hasGaloisQuotient_of_orbitsInAffineOpen`
   (`GaloisDescent/GaloisQuotientOverlap.lean`), the `G1` predicate match by
   `isInvariantMatch_canonical`). The one remaining instance binder is
   `OrbitsInAffineOpen`.
3. `Scheme.picSharp_representableBy_picEt_transport` and
   `Scheme.isIso_picEtComparison_of_picSharp_representability`
   (`Picard/PicEtSubcanonical.lean`) — a scheme representing `picSharp` also
   represents `picEt`, and makes the comparison an iso, with no section anywhere.
   So the pointed **`picSharp`** theorem is enough; nothing needs an étale
   representability statement of its own.

## Correction to the seam docstring's own item 3, measured here

`Picard/FGAPicRepresentability.lean` item 3 says the quotient gate "bites only off
the affine locus" and that `inferInstance` for it at an abstract action carrying
the orbit hypothesis but not affineness **fails**. At HEAD that is stale for the
gate as a whole: `hasGaloisQuotient_of_orbitsInAffineOpen`
(`GaloisDescent/GaloisQuotientOverlap.lean`) is a global instance requiring
`[FiniteDimensional K L] [IsGalois K L] [ρ.OrbitsInAffineOpen]` and **no**
affineness, and `seamClauseOne_of_hasGaloisQuotient_lftFree` consumes it
successfully at the *glued* quotient (`gluedQuotientMap`). What survives of item 3
is the *orbit* hypothesis, which is the honest residue and is the one this file
carries. I have not edited that file: the sentence there is about `HasGaloisQuotient`
at an action with **no** orbit binder, where it is still true.

## What this does NOT do

It does not close the seam. `PointedPicSharpRep` is **unproved in this project** —
it *is* the Milne–Kollár campaign's undischarged output — and no curve is exhibited
satisfying `FiniteInAffine` at its Picard scheme. Both are explicit antecedents
below, not hidden ones. What changes is the *shape* of what remains: the
arbitrary-field difficulty that `I-0491` deliberately put on the headline is now
**discharged**, and what is left is the classical pointed theorem plus
quasi-projectivity of the representing scheme.

`FiniteInAffine` is not free: `exact?` fails on it at an arbitrary scheme
(measured, control in the same probe as the results). It is also not vacuous — §3
inhabits it at an affine scheme.
-/

open CategoryTheory Limits AlgebraicGeometry
open AlgebraicJacobian.GaloisDescent

universe u

set_option autoImplicit false

namespace AlgebraicGeometry.Scheme

/-! ## §1. The two hypotheses, named -/

/-- **Every finite subset lies in a single affine open** — the action-free,
scheme-level form of the EGA II 4.5.4 orbit hypothesis.

`SemilinearGalAction.OrbitsInAffineOpen` (`Picard/FiniteGaloisQuotient.lean`) is
stated *about an action*, so a consumer cannot discharge it before knowing which
action it will face. This form is a property of the scheme alone, and §2 shows it
implies the action form for **every** semilinear action of a finite Galois group.
That is what lets the antecedent of §4 be stated without mentioning the Galois
level, which is chosen inside the proof.

True for quasi-projective schemes (finite point sets of a quasi-projective scheme
lie in an affine open). Mathlib `v4.31` has no quasi-projectivity vocabulary at
this pin, which is why the hypothesis is carried in this elementary form rather
than derived. -/
def FiniteInAffine (X : Scheme.{u}) : Prop :=
  ∀ s : Set X, s.Finite → ∃ U : X.affineOpens, s ⊆ U.1

/-- **The pointed Picard theorem**: FGA/Kleiman representability of the relative
Picard functor, for curves that *have* a rational point, uniformly in the base
field, together with quasi-projectivity of the representing scheme.

This is the campaign's target, written as a closed proposition. Three things about
its shape are deliberate.

* It quantifies over **all** base fields `K`, not just over `k`. That is
  essential and it is not a strengthening in any useful sense: §4 applies it at a
  finite Galois extension of `k` chosen by the curve, so a version fixed at `k`
  would not compose. Every formalisation route to FGA representability is uniform
  in the base field anyway.
* It is about `picSharp`, the **unsheafified** relative Picard functor — the object
  the Milne–Kollár modules target (`I-0907`). No étale-sheafified representability
  statement is needed on top of it; §3 of `Picard/PicEtSubcanonical.lean` supplies
  the transport for free.
* `FiniteInAffine X.left` is bundled rather than carried separately so that the
  results below have **one** antecedent. It is a property of the scheme the
  antecedent itself produces, so it cannot be stated outside it. -/
def PointedPicSharpRep : Prop :=
  ∀ {K : Type u} [Field K] (E : Over (Spec (CommRingCat.of K))),
    ∀ [SmoothOfRelativeDimension 1 E.hom] [IsProper E.hom] [GeometricallyIntegral E.hom],
      Scheme.HasRationalPoint E →
      ∃ X : Over (Spec (CommRingCat.of K)),
        Nonempty ((PicScheme.picSharp E).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom ∧ FiniteInAffine X.left

/-! ## §2. The scheme-level hypothesis implies the action-level one -/

/-- **`FiniteInAffine` discharges `OrbitsInAffineOpen`, for every semilinear
action of a finite Galois group.**

The orbit of a point is the range of a map indexed by `L ≃ₐ[K] L`, which is finite
because `L/K` is finite Galois (`Finite (L ≃ₐ[K] L)` by synthesis), so it is a
finite subset and the hypothesis applies directly.

Note where the finiteness of the group is consumed: only here. The quotient
machinery downstream binds `[FiniteDimensional K L] [IsGalois K L]` for its own
reasons. -/
theorem orbitsInAffineOpen_of_finiteInAffine
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    [FiniteDimensional K L] [IsGalois K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (ρ : SemilinearGalAction K L X f) (h : FiniteInAffine X) :
    ρ.OrbitsInAffineOpen where
  exists_affineOpen x := by
    obtain ⟨U, hU⟩ :=
      h (Set.range fun γ : L ≃ₐ[K] L => (ρ.act γ).hom.base x) (Set.finite_range _)
    exact ⟨U, fun γ => hU ⟨γ, rfl⟩⟩

/-! ## §3. `FiniteInAffine` is inhabited, and is not free

Both directions are recorded as declarations rather than as docstring sentences,
per `I-0838`: a hypothesis whose satisfiability is unmeasured is how a vacuous
statement survives, and a hypothesis that is *free* would make the results below
empty. -/

/-- **Non-vacuity**: an affine scheme satisfies `FiniteInAffine`, with `⊤` as the
affine open. So the antecedent of §4 is not asserting something about no scheme.

This is the cheap witness, and it is the honest one to give: it is *not* a witness
at a Picard scheme, and no such witness exists in this project. What it rules out
is the failure mode where `FiniteInAffine` is unsatisfiable and the results below
are vacuously true. -/
theorem finiteInAffine_of_isAffine (X : Scheme.{u}) [IsAffine X] : FiniteInAffine X :=
  fun _ _ => ⟨⟨⊤, isAffineOpen_top X⟩, fun _ _ => trivial⟩

/-! ## §4. The reduction

Clause (2) first, because it needs strictly less. -/

/-- **Clause (2) of the seam, from the pointed antecedent alone.**

No Galois level, no quotient, no orbit hypothesis, and the `FiniteInAffine`
conjunct of the antecedent is discarded: given a section, the antecedent applies
to `C` *itself*, and subcanonicity of the étale topology turns a representation
into invertibility of the comparison map
(`isIso_picEtComparison_of_picSharp_representability`).

So of the seam's two conjuncts, this one costs nothing beyond the pointed theorem.
That is a sharper statement than the seam docstring's "clause (2) costs zero extra
work", which was said relative to a `picSharp`-shaped endpoint over the *same*
field; here it is said relative to the pointed antecedent, which is the thing
actually being assumed. -/
theorem seamClauseTwo_of_pointedPicSharpRep {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (H : PointedPicSharpRep.{u}) :
    Scheme.HasRationalPoint C → IsIso (PicScheme.picEtComparison C) := by
  intro hpt
  obtain ⟨X, ⟨rep⟩, -, -, -⟩ := H C hpt
  exact isIso_picEtComparison_of_picSharp_representability C rep

/-- **Clause (1) of the seam, over an ARBITRARY field, from the pointed
antecedent.** This is the theorem the file exists for.

The proof is the composition the module docstring describes, and each step is a
landed sorry-free theorem of a different lane:

1. `exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral` produces
   a finite **Galois** `k''/k` and a rational point on `C_{k''}` — unconditionally,
   from `[SmoothOfRelativeDimension 1]` and `[GeometricallyIntegral]` alone. This
   is the only step that uses `GeometricallyIntegral`.
2. The antecedent, applied at `k''` to the base-changed curve (all three binders
   are stable under field base change, by synthesis), gives a scheme representing
   `picSharp (C_{k''})` with the two side conjuncts and `FiniteInAffine`.
3. `picSharp_representableBy_picEt_transport` converts it to a `picEt`
   representation — the same scheme, so `LocallyOfFiniteType` rides along.
4. §2 turns `FiniteInAffine` into `OrbitsInAffineOpen` at the canonical semilinear
   action `semilinearGalActionOfRepresentableBy C rep`, which is the action the
   descent step uses.
5. `seamClauseOne_of_hasGaloisQuotient_lftFree` descends to `k`, discharging the
   quotient and the covering sieve internally.

The conclusion is over `k` with **no** section and **no** `k''` in sight, and no
hypothesis of the theorem mentions a representation of `picEt C` — so this is not
`P → P`, and it is not the refuted shape of `representableByRestrict_of_baseChange`
(`I-1312`), which concluded about a `k'`-object. -/
theorem seamClauseOne_of_pointedPicSharpRep {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (H : PointedPicSharpRep.{u}) :
    ∃ Z : Over (Spec (CommRingCat.of k)),
      Nonempty ((PicScheme.picEt C).RepresentableBy Z) ∧
        LocallyOfFiniteType Z.hom ∧ IsSeparated Z.hom := by
  obtain ⟨k'', hfd, hgal, hpt⟩ :=
    Scheme.exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral C
  letI := hfd
  letI := hgal
  obtain ⟨X', ⟨rep0⟩, hft, -, hfa⟩ := H (Scheme.baseChangeField C (k'' : Type u)) hpt
  letI rep :=
    picSharp_representableBy_picEt_transport (Scheme.baseChangeField C (k'' : Type u)) rep0
  letI := orbitsInAffineOpen_of_finiteInAffine
    (PicScheme.semilinearGalActionOfRepresentableBy C rep) hfa
  exact PicScheme.seamClauseOne_of_hasGaloisQuotient_lftFree rep hft

/-- **The seam, verbatim, as the conclusion of an implication.**

The conclusion is character-for-character the statement of
`Scheme.fgaPicardRepresentability`, so a lane that proves `PointedPicSharpRep`
closes the project's central `sorry` by `exact`. Stated as a named theorem rather
than left to the reader to assemble, because "the two clauses are available
separately" is not the same as "the seam follows", and the difference is exactly
the kind of joint that goes unchecked. -/
theorem fgaPicardRepresentability_of_pointedPicSharpRep {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    (H : PointedPicSharpRep.{u}) :
    (∃ X : Over (Spec (CommRingCat.of k)),
        Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
          LocallyOfFiniteType X.hom ∧ IsSeparated X.hom)
      ∧ (Scheme.HasRationalPoint C → IsIso (PicScheme.picEtComparison C)) :=
  ⟨seamClauseOne_of_pointedPicSharpRep C H, seamClauseTwo_of_pointedPicSharpRep C H⟩

end AlgebraicGeometry.Scheme
