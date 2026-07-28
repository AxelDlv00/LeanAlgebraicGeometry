/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Albanese.CodimOneExtension
import AlgebraicJacobian.Picard.SchemeKrullDimStalk
import AlgebraicJacobian.Picard.Pic0AbelianVariety

/-!
# The dimension of `Pic⁰_{C/k}` is the genus

This file turns the tangent-space identity `dim_{κ(e)} m_e/m_e² = g(C)` at the
identity of `Pic⁰_{C/k}` (`Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne`,
`Picard/Pic0AbelianVariety.lean`) into a statement about the **dimension of the
scheme** `Pic⁰_{C/k}`, which is what Milne III.1 Rmk 1.4(e) — "the dimension of
`J` is the genus of `C`" — asserts and what
`Pic0Scheme.finrank_eq_genus` (`Picard/IdentityComponent.lean`) pins.

## Two inputs, and which of them was actually missing

The recorded blocker at `finrank_eq_genus` was the *dimension-theoretic* step,
priced as an absent mathlib API for `topologicalKrullDim`. That step is supplied
by `Picard/SchemeKrullDimStalk.lean`, from the definition of the invariant rather
than from a presentation. What remains here is the *local algebra*:

* **regularity of the stalk** at the point where the tangent space is computed
  — `Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField` below;
* the **≥ direction only** comes for free from data at the identity. The ≤
  direction genuinely needs information at every point, and is stated as a
  hypothesis (see `topologicalKrullDim_eq_genus_of_forall_ringKrullDim_stalk_le`).

## The generalisation this file contributes upstream of itself

`Albanese/CodimOneExtension.lean` already proves stalk regularity from
smoothness, as `isRegularLocalRing_stalk_of_smooth` — but over an
**algebraically closed** field, and with `[GeometricallyIrreducible]`,
`[IsSeparated]`, `[LocallyOfFiniteType]`, `[IsIntegral]`, `[IsReduced]` binders.
None of those is used by the argument: the chart step is mathlib's
`Smooth.exists_isStandardSmooth` (Stacks 00T7), which needs only smoothness, and
the algebra step is the project's own
`isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`
(`Albanese/SmoothPrimeRegularity.lean`), which needs only `PerfectField`. So the
version proved here has `[Field k] [PerfectField k] [Smooth X.hom]` and nothing
else.

That matters for this lane specifically: `Pic⁰_{C/k}` lives over the *given* base
field `k`, not over `k̄`, and no descent step is available for regularity — so the
alg-closed version could not have been applied here at all. (`PerfectField` is
still an assumption on `k`, and a real one: it holds in characteristic zero and
for finite and algebraically closed fields, and fails for e.g. `𝔽_p(t)`.)
-/

universe u

open AlgebraicGeometry Order TopologicalSpace CategoryTheory Limits IsLocalRing

namespace AlgebraicGeometry.Scheme

/-- **Stalks of a smooth scheme over a perfect field are regular local rings**
(Stacks 00TT, Jacobian-criterion direction) — at **every** point, closed or not,
with no hypothesis on the scheme beyond smoothness of the structural morphism.

Two steps, both already in the tree:

* mathlib's `Smooth.exists_isStandardSmooth` (Stacks 00T7) gives an affine chart
  `V ∋ z` on which the section ring is standard-smooth over `Γ(Spec k, U)`, and
  `gammaSpecField_ringEquiv` identifies that base with `k`;
* the stalk is the localisation of `Γ(X, V)` at the prime of `z`
  (`IsAffineOpen.isLocalization_stalk`), and the project's Serre-free Stacks-00TT
  theorem at an arbitrary prime over a perfect field,
  `isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`
  (`Albanese/SmoothPrimeRegularity.lean`), concludes.

**This is a strict generalisation of `isRegularLocalRing_stalk_of_smooth`**
(`Albanese/CodimOneExtension.lean`), which asks for `[IsAlgClosed kbar]` plus
`[GeometricallyIrreducible]`, `[IsSeparated]`, `[LocallyOfFiniteType]`,
`[IsIntegral]` and `[IsReduced]`. What is *measured* here is that the proof below
elaborates with all six absent simultaneously and `PerfectField` in place of
`IsAlgClosed` — which is the claim that matters, though it does not by itself
show each binder is individually unused in the original (that proof is a
different proof term). The alg-closedness enters the argument only through
`PerfectField`, which `IsAlgClosed` implies.

The generalisation is *load-bearing* for the Picard lane, not cosmetic: `Pic⁰_{C/k}`
sits over the given field `k`, and regularity of a stalk does not descend along
`Spec k̄ → Spec k` by any route in this tree, so the alg-closed form is unusable
here. -/
theorem isRegularLocalRing_stalk_of_smooth_of_perfectField
    {k : Type u} [Field k] [PerfectField k]
    (X : Over (Spec (.of k)))
    [Smooth X.hom]
    (z : X.left) :
    IsRegularLocalRing (X.left.presheaf.stalk z) := by
  obtain ⟨U, hU, V, hV, hzV, e, hSS⟩ :=
    AlgebraicGeometry.Smooth.exists_isStandardSmooth X.hom z
  -- Base identification `Γ(Spec k, U) ≃+* k`: `U` contains the image of `z`, so it
  -- is nonempty.
  let ε : k ≃+* Γ(Spec (.of k), U) :=
    (gammaSpecField_ringEquiv k U ⟨⟨_, e hzV⟩⟩).symm
  have hSS' : ((X.hom.appLE U V e).hom.comp ε.toRingHom).IsStandardSmooth :=
    RingHom.isStandardSmooth_respectsIso.2 _ ε hSS
  letI : Algebra k Γ(X.left, V) :=
    ((X.hom.appLE U V e).hom.comp ε.toRingHom).toAlgebra
  haveI : Algebra.IsStandardSmooth k Γ(X.left, V) := hSS'.toAlgebra
  letI : Algebra Γ(X.left, V) (X.left.presheaf.stalk z) :=
    TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
  haveI hLoc : IsLocalization.AtPrime (X.left.presheaf.stalk z)
      (hV.primeIdealOf ⟨z, hzV⟩).asIdeal :=
    hV.isLocalization_stalk ⟨z, hzV⟩
  have hp : (hV.primeIdealOf ⟨z, hzV⟩).asIdeal.IsPrime := (hV.primeIdealOf ⟨z, hzV⟩).isPrime
  haveI : Nontrivial Γ(X.left, V) := by
    refine ⟨0, 1, fun h => hp.1 ?_⟩
    exact Ideal.eq_top_of_isUnit_mem _ (Submodule.zero_mem _) (h ▸ isUnit_one)
  letI : Algebra k (X.left.presheaf.stalk z) :=
    ((algebraMap Γ(X.left, V) (X.left.presheaf.stalk z)).comp
      (algebraMap k Γ(X.left, V))).toAlgebra
  haveI : IsScalarTower k Γ(X.left, V) (X.left.presheaf.stalk z) :=
    IsScalarTower.of_algebraMap_eq fun _ => rfl
  exact isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField
    (k := k) (S := Γ(X.left, V)) _ hp (X.left.presheaf.stalk z)

namespace Pic0

/-- **`Pic⁰_{C/k}` is locally Noetherian** — free from finite type over a field,
via `Pic0.locallyOfFiniteType` and mathlib's
`LocallyOfFiniteType.isLocallyNoetherian`. Needed to make the stalks Noetherian,
which is what `IsRegularLocalRing.iff_finrank_cotangentSpace` consumes. -/
theorem isLocallyNoetherian {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsLocallyNoetherian (Pic0Scheme C).left := by
  haveI : LocallyOfFiniteType (Pic0Scheme C).hom := Pic0.locallyOfFiniteType C
  exact LocallyOfFiniteType.isLocallyNoetherian (Pic0Scheme C).hom

/-- **The genus is a LOWER bound for the dimension of `Pic⁰_{C/k}`** — proved,
modulo regularity of the single stalk at the identity.

This is the half of Milne III.1 Rmk 1.4(e) that the tangent-space computation
gives away for free, and it needs data at **one** point:

* `Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne` computes
  `dim_{κ(e)} m_e/m_e² = dim_k H¹(C, 𝒪_C) = g(C)` at the identity;
* at a regular point `IsRegularLocalRing.iff_finrank_cotangentSpace` turns that
  into `dim 𝒪_{Pic⁰, e} = g(C)`;
* and a stalk's dimension is at most the dimension of the scheme
  (`ringKrullDim_stalk_le_topologicalKrullDim`, from
  `Picard/SchemeKrullDimStalk.lean`).

Note what is *not* needed: no quantifier over the points of `Pic⁰`, no smoothness
of `Pic⁰` (only regularity at `e`), and no affine-local presentation — the
recorded route through `Algebra.IsStandardSmoothOfRelativeDimension` is not
taken. -/
theorem genus_le_topologicalKrullDim_of_isRegular {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hreg : IsRegularLocalRing ((Pic0Scheme C).left.presheaf.stalk
      ((identitySection C).base default))) :
    ((AlgebraicGeometry.genus C : ℕ) : WithBot ℕ∞)
      ≤ topologicalKrullDim (Pic0Scheme C).left := by
  haveI := isLocallyNoetherian C
  exact le_topologicalKrullDim_of_finrank_cotangentSpace _ _ _ hreg
    (finrank_cotangentSpace_eq_finrank_hModuleOne C)

/-- **The genus lower bound, with regularity discharged from smoothness over a
perfect field.**

`Pic⁰_{C/k}` smooth over `k` (which is what `Pic0.smooth` asserts, and what
`Pic0.smooth_of_isReduced_algebraicClosureBaseChange` reduces to reducedness over
`k̄`) gives regularity of *every* stalk by
`Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField`, in particular at the
identity. So over a perfect base field the lower bound needs no regularity
hypothesis at all — only smoothness, which is front (b) of this chapter. -/
theorem genus_le_topologicalKrullDim_of_smooth {k : Type u} [Field k] [PerfectField k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hsm : Smooth (Pic0Scheme C).hom) :
    ((AlgebraicGeometry.genus C : ℕ) : WithBot ℕ∞)
      ≤ topologicalKrullDim (Pic0Scheme C).left := by
  haveI := hsm
  exact genus_le_topologicalKrullDim_of_isRegular C
    (Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField (Pic0Scheme C) _)

/-- **`dim Pic⁰_{C/k} = g(C)`** — Milne III.1 Rmk 1.4(e), from smoothness over a
perfect field plus a uniform upper bound on the local dimensions.

This is the honest factoring of `Pic0Scheme.finrank_eq_genus`
(`Picard/IdentityComponent.lean`), and it makes visible that the two directions
have genuinely different costs:

* **≥** is discharged here, from the tangent-space identity at the identity alone
  (`genus_le_topologicalKrullDim_of_smooth`);
* **≤** is the hypothesis `hle`, and it cannot be obtained from data at one
  point: it says every local ring of `Pic⁰_{C/k}` has dimension at most `g`. On a
  smooth *equidimensional* scheme this is the statement that the relative
  dimension is `g`, i.e. exactly the content of
  `SmoothOfRelativeDimension (genus C) (Pic0Scheme C).hom`, which
  `Picard/IdentityComponent.lean` already flags as the cheaper target for
  consumers wanting a dimension index.

So the remaining open content of the dimension statement is one *uniform* bound,
with the tangent-space side fully consumed.

WHERE THE `≤` BOUND IS **NOT** AVAILABLE, measured so the next session does not
re-search. `Albanese/StandardSmoothDimension.lean` looks like it should supply it
and does not: its
`Algebra.IsStandardSmoothOfRelativeDimension.le_ringKrullDim_of_isLocalization_atPrime`
gives `n ≤ ringKrullDim Sₘ` — the **lower** bound, and only at a *maximal* ideal.
Every dimension lemma in that file points the same way (`natCast_le_height_of_isMaximal`,
`MvPolynomial.height_eq_natCard_of_isMaximal`), because the file exists to feed
`IsRegularLocalRing.of_finrank_cotangentSpace_le_ringKrullDim`, whose hypothesis
is a lower bound on the Krull dimension. So the `≤` direction is genuinely absent
rather than merely unlocated, and it is absent in the direction that matters: an
upper bound at *every* prime, not just the maximal ones. -/
theorem topologicalKrullDim_eq_genus_of_forall_ringKrullDim_stalk_le
    {k : Type u} [Field k] [PerfectField k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (hsm : Smooth (Pic0Scheme C).hom)
    (hle : ∀ z : (Pic0Scheme C).left,
      ringKrullDim ((Pic0Scheme C).left.presheaf.stalk z)
        ≤ ((AlgebraicGeometry.genus C : ℕ) : WithBot ℕ∞)) :
    topologicalKrullDim (Pic0Scheme C).left
      = ((AlgebraicGeometry.genus C : ℕ) : WithBot ℕ∞) :=
  le_antisymm
    (Scheme.topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le _ _ hle)
    (genus_le_topologicalKrullDim_of_smooth C hsm)

end Pic0

end AlgebraicGeometry.Scheme
