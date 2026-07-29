/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Albanese.CodimOneExtension
import AlgebraicJacobian.Albanese.Milne33

/-!
# The Milne §I.3 chain over a perfect field, and where the field is really used

Headline obligation 5 of the Jacobian (`isAlbanese_pic0Et`, `Jacobian.lean`) is
stated over an **arbitrary** field, and its supply route — Milne Theorem 3.2
(`Scheme.RationalMap.extend_to_av`, `Albanese/Thm32RationalMapExtension.lean`) —
is stated over an algebraically closed one.  This file measures which links of
that chain actually need the hypothesis.

## The correction this file records

`I-1115` (`ajc-p4`, run 0086 r2 — my own measurement) localised the chain's
`[IsAlgClosed]` to **one** lemma and priced it:

> the single obligation is Milne 3.1's regularity input over a non-closed
> residue field.  Over a general `k` the residue field is a finite extension
> instead, so the statement needs a residue-degree-aware version, not a binder
> deletion.

**Both halves of that are wrong, and they are wrong in opposite directions.**

* The regularity input is **not** an obligation at all over a perfect field.
  `isRegularLocalRing_stalk_of_smooth` (`CodimOneExtension.lean`) already routes
  through `isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`
  (`Albanese/SmoothPrimeRegularity.lean`), which is `sorry`-free at an
  **arbitrary** prime over a **perfect** field.  The residue-degree-aware
  version my costing said had to be built was already in the tree, one import
  away, and is what the chain's own proof calls.  §1 below carries the whole
  Milne 3.1 chain over `PerfectField` with the proof bodies unchanged.
* Milne 3.3 was the load-bearing link, and `I-1115` said the opposite —
  "Milne 3.3 has NO `IsAlgClosed` in its signature, in EITHER project".  It
  does: `Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme` binds
  it on its `variable` line, so it does not appear in the declaration's own
  header where I read.  §2 records the refuting probe.

So the chain's field restriction sits one link **above** where I put it, and the
link I named is free.  A lane pricing "transport the Albanese descent to an
arbitrary field" off `I-1115` would have attacked a discharged step and left the
live one untouched.

## §1 — what is field-agnostic (four theorems, `PerfectField`)

* `isRegularLocalRing_stalk_of_smooth_perfectField` — Stacks `00TT` at every
  point.
* `isReduced_of_smooth_perfectField` — reducedness of a smooth scheme, via
  regular local ⇒ domain at every stalk.  Note this is a **different route**
  from the in-tree `isReduced_of_smooth_of_isAlgClosed`, which goes through the
  closed-point theorem and the reduced-chart-ring statement
  `isReduced_of_isStandardSmooth_of_isAlgClosed`; that one does not widen,
  because its own input is the closed-point regularity lemma.
* `localRing_dvr_of_codim_one_perfectField` — smooth + codim 1 ⇒ DVR.
* `indeterminacy_codimGe2_of_smooth_of_complete_perfectField` — **Milne 3.1**.

## §2 — what is not, and it is measured rather than asserted

`milne33_needs_isAlgClosed` is a documented negative: restating Milne 3.3 over
`PerfectField` and closing it by its own core fails with
`failed to synthesize instance of type class IsAlgClosed k`.  The consumption
site is `Milne33RowSection.mem_domain_of_selfDiag_mem_domain`, whose row
argument calls mathlib's `pointOfClosedPoint` — available only over an
algebraically closed field, because it needs the residue field at a closed
point to **be** the base field (`residueFieldIsoBase`, via
`IsAlgClosed.ringHom_bijective_of_isIntegral`).  Nine of the twelve modules in
the Milne 3.3 cone carry no `IsAlgClosed` at all; the three that do are
`Milne33.lean`, `Milne33RowSection.lean` and `Milne33Transport.lean`, and the
latter two are the closed-point layers.

**What this does NOT establish, stated because it is the natural misreading.**
Nothing here closes `isAlbanese_pic0Et`, and no antecedent of it is witnessed at
any curve.  §1's theorems are the same statements the chain already had, over a
weaker field hypothesis; a curve over an *imperfect* field is still outside every
one of them, and `PerfectField` is not `Field`.  What the file buys is that the
remaining distance is one named link (Milne 3.3's closed-point row argument),
not the four-link chain the previous costing described, and not the regularity
lemma it named.

## Why the perfect-field case is not vacuous as a target

Every field of characteristic zero and every finite field is perfect, so §1
applies to `ℚ`, to every number field, and to every `𝔽_q` — none of which is
algebraically closed, and all of which the headline's "arbitrary field" covers.
The gap that remains after §1 is the imperfect case (`𝔽_p(t)` and its like)
*plus* Milne 3.3 everywhere outside the algebraically closed case.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ### §1. The Milne 3.1 chain over a perfect field -/

/-- **Stacks `00TT` over a perfect field**: for a smooth integral variety `X`
over a perfect field `k`, the stalk at **every** point is a regular local ring.

This is `isRegularLocalRing_stalk_of_smooth` with `[IsAlgClosed kbar]` weakened
to `[PerfectField k]`, and the proof is the same one: the algebraic-closure
hypothesis was never consumed, because the theorem it delegates to
(`isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`)
asks only for perfectness.  Recorded as a correction to `I-1115`, which priced
this step as the chain's single open obligation. -/
theorem isRegularLocalRing_stalk_of_smooth_perfectField
    {k : Type u} [Field k] [PerfectField k]
    (X : Over (Spec (.of k)))
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    (z : X.left) :
    IsRegularLocalRing (X.left.presheaf.stalk z) := by
  obtain ⟨U, hU, V, hV, hzV, e, hSS⟩ :=
    AlgebraicGeometry.Smooth.exists_isStandardSmooth X.hom z
  let ε : k ≃+* Γ(Spec (.of k), U) :=
    (Scheme.gammaSpecField_ringEquiv k U ⟨⟨_, e hzV⟩⟩).symm
  have hSS' : ((X.hom.appLE U V e).hom.comp ε.toRingHom).IsStandardSmooth :=
    RingHom.isStandardSmooth_respectsIso.2 _ ε hSS
  letI : Algebra k Γ(X.left, V) :=
    ((X.hom.appLE U V e).hom.comp ε.toRingHom).toAlgebra
  haveI : Algebra.IsStandardSmooth k Γ(X.left, V) := hSS'.toAlgebra
  letI : Algebra Γ(X.left, V) (X.left.presheaf.stalk z) :=
    TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
  haveI hLoc : IsLocalization.AtPrime (X.left.presheaf.stalk z)
      (hV.primeIdealOf ⟨z, hzV⟩).asIdeal :=
    Scheme.isLocalization_atPrime_stalk_of_affineOpen hV z hzV
  letI : Algebra k (X.left.presheaf.stalk z) :=
    ((algebraMap Γ(X.left, V) (X.left.presheaf.stalk z)).comp
      (algebraMap k Γ(X.left, V))).toAlgebra
  haveI : IsScalarTower k Γ(X.left, V) (X.left.presheaf.stalk z) :=
    IsScalarTower.of_algebraMap_eq fun _ => rfl
  haveI : Nonempty V := ⟨⟨z, hzV⟩⟩
  haveI : Nontrivial Γ(X.left, V) :=
    AlgebraicGeometry.Scheme.component_nontrivial X.left V
  exact isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField
    (k := k) (hV.primeIdealOf ⟨z, hzV⟩).asIdeal
    (hV.primeIdealOf ⟨z, hzV⟩).isPrime (X.left.presheaf.stalk z)

/-- **A smooth scheme over a perfect field is reduced.**

The in-tree `isReduced_of_smooth_of_isAlgClosed` does not widen: its chart-ring
input `isReduced_of_isStandardSmooth_of_isAlgClosed` runs through the
**closed-point** regularity lemma, which needs the residue field to be the base
field.  This proof takes the other route — the arbitrary-prime regularity
theorem gives `IsRegularLocalRing` at each stalk directly, regular local rings
are domains (Stacks `00NP`, project-local
`RingTheory.CohenMacaulay.isDomain_of_regularLocal`), and domains are reduced —
so no closed point is ever named and no chart ring has to be shown reduced.

Note the binder set is wider than §1's other theorems: only `[Smooth X.hom]` is
needed, matching the in-tree statement. -/
theorem isReduced_of_smooth_perfectField
    {k : Type u} [Field k] [PerfectField k]
    (X : Over (Spec (.of k)))
    [Smooth X.hom] :
    IsReduced X.left := by
  haveI hstalk : ∀ z : X.left.toPresheafedSpace,
      _root_.IsReduced (X.left.presheaf.stalk z) := by
    intro z
    obtain ⟨U, hU, V, hV, hzV, e, hSS⟩ :=
      AlgebraicGeometry.Smooth.exists_isStandardSmooth X.hom z
    let ε : k ≃+* Γ(Spec (.of k), U) :=
      (Scheme.gammaSpecField_ringEquiv k U ⟨⟨_, e hzV⟩⟩).symm
    have hSS' : ((X.hom.appLE U V e).hom.comp ε.toRingHom).IsStandardSmooth :=
      RingHom.isStandardSmooth_respectsIso.2 _ ε hSS
    letI : Algebra k Γ(X.left, V) :=
      ((X.hom.appLE U V e).hom.comp ε.toRingHom).toAlgebra
    haveI : Algebra.IsStandardSmooth k Γ(X.left, V) := hSS'.toAlgebra
    letI : Algebra Γ(X.left, V) (X.left.presheaf.stalk z) :=
      TopCat.Presheaf.algebra_section_stalk X.left.presheaf ⟨z, hzV⟩
    haveI hLoc : IsLocalization.AtPrime (X.left.presheaf.stalk z)
        (hV.primeIdealOf ⟨z, hzV⟩).asIdeal := hV.isLocalization_stalk ⟨z, hzV⟩
    letI : Algebra k (X.left.presheaf.stalk z) :=
      ((algebraMap Γ(X.left, V) (X.left.presheaf.stalk z)).comp
        (algebraMap k Γ(X.left, V))).toAlgebra
    haveI : IsScalarTower k Γ(X.left, V) (X.left.presheaf.stalk z) :=
      IsScalarTower.of_algebraMap_eq fun _ => rfl
    haveI : Nonempty V := ⟨⟨z, hzV⟩⟩
    haveI : Nontrivial Γ(X.left, V) :=
      AlgebraicGeometry.Scheme.component_nontrivial X.left V
    haveI : IsRegularLocalRing (X.left.presheaf.stalk z) :=
      isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField
        (k := k) (hV.primeIdealOf ⟨z, hzV⟩).asIdeal
        (hV.primeIdealOf ⟨z, hzV⟩).isPrime (X.left.presheaf.stalk z)
    haveI : IsDomain (X.left.presheaf.stalk z) :=
      RingTheory.CohenMacaulay.isDomain_of_regularLocal _
    infer_instance
  exact isReduced_of_isReduced_stalk X.left

/-- **Smooth + codim 1 ⇒ DVR, over a perfect field.**  `localRing_dvr_of_codim_one`
with the field hypothesis weakened: the geometric input is regularity of the
stalk (now `isRegularLocalRing_stalk_of_smooth_perfectField`) and the rest is
the dimension bookkeeping, which never mentions the field. -/
theorem localRing_dvr_of_codim_one_perfectField
    {k : Type u} [Field k] [PerfectField k]
    (X : Over (Spec (.of k)))
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    (z : X.left) (hz : Order.coheight z = 1) :
    IsDiscreteValuationRing (X.left.presheaf.stalk z) := by
  haveI : IsLocallyNoetherian X.left :=
    LocallyOfFiniteType.isLocallyNoetherian X.hom
  have hreg : IsRegularLocalRing (X.left.presheaf.stalk z) :=
    isRegularLocalRing_stalk_of_smooth_perfectField X z
  have hdim : ringKrullDim (X.left.presheaf.stalk z) = 1 := by
    rw [Scheme.ringKrullDim_stalk_eq_coheight]
    exact_mod_cast hz
  have hfin :
      Module.finrank
        (IsLocalRing.ResidueField (X.left.presheaf.stalk z))
        (IsLocalRing.CotangentSpace (X.left.presheaf.stalk z)) = 1 := by
    have h := (IsRegularLocalRing.iff_finrank_cotangentSpace _).mp hreg
    rw [hdim] at h
    exact_mod_cast h
  have hprin : Submodule.IsPrincipal
      (IsLocalRing.maximalIdeal (X.left.presheaf.stalk z)) :=
    IsLocalRing.finrank_cotangentSpace_le_one_iff.mp hfin.le
  have hne : IsLocalRing.maximalIdeal (X.left.presheaf.stalk z) ≠ ⊥ := by
    intro hbot
    have hF : IsField (X.left.presheaf.stalk z) :=
      IsLocalRing.isField_iff_maximalIdeal_eq.mpr hbot
    have h0 : ringKrullDim (X.left.presheaf.stalk z) = 0 :=
      ringKrullDim_eq_zero_of_isField hF
    rw [hdim] at h0
    exact_mod_cast h0
  have hfield : ¬ IsField (X.left.presheaf.stalk z) := fun hF =>
    hne ((IsLocalRing.isField_iff_maximalIdeal_eq).mp hF)
  exact ((IsDiscreteValuationRing.TFAE (X.left.presheaf.stalk z) hfield).out 0 4).mpr hprin

namespace RationalMap

/-- **Milne Theorem 3.1 over a perfect field.**  For a rational map `f : X ⇢ Y`
of varieties over a perfect field `k` with `X` nonsingular and `Y` complete,
every point of the indeterminacy locus has coheight at least `2`.

The proof is `indeterminacy_codimGe2_of_smooth_of_complete`'s, verbatim except
that the DVR step calls the perfect-field version.  The `IsAlgClosed` binder on
the original is not consumed anywhere else: the coheight-`0` branch is pure
topology of an irreducible sober space, and the coheight-`1` branch is the
valuative criterion at the DVR stalk, which asks nothing of the base field.

**This is the theorem `I-1115` said needed a new residue-degree-aware
ingredient.**  It needed none; the ingredient existed. -/
theorem indeterminacy_codimGe2_of_smooth_of_complete_perfectField
    {k : Type u} [Field k] [PerfectField k]
    {X : Over (Spec (.of k))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    {Y : Over (Spec (.of k))}
    [IsProper Y.hom] [GeometricallyIrreducible Y.hom]
    [IsIntegral Y.left] [IsReduced Y.left]
    (f : X.left.RationalMap Y.left)
    (hf : f.compHom Y.hom = X.hom.toRationalMap) :
    ∀ z ∈ indeterminacyLocus f, 2 ≤ Order.coheight z := by
  intro z hz
  have hzdom : z ∉ f.domain := hz
  by_contra hlt
  have hle : Order.coheight z ≤ 1 := by
    have h2 : Order.coheight z < 2 := not_le.mp hlt
    rwa [ENat.lt_two_iff] at h2
  have hspec : genericPoint X.left ⤳ z :=
    (genericPoint_spec X.left).specializes trivial
  have hff : f.fromFunctionField ≫ Y.hom
      = X.left.fromSpecStalk (genericPoint X.left) ≫ X.hom := by
    obtain ⟨g0, rfl⟩ := f.exists_rep
    have h1' : (g0.compHom Y.hom).toRationalMap
        = X.hom.toPartialMap.toRationalMap := by
      rw [RationalMap.compHom_toRationalMap]; exact hf
    have h2 := congrArg RationalMap.fromFunctionField h1'
    rw [RationalMap.fromFunctionField_toRationalMap,
      RationalMap.fromFunctionField_toRationalMap] at h2
    simpa using h2
  rcases hle.lt_or_eq with h0 | h1
  · rw [Order.lt_one_iff] at h0
    have hmax : IsMax z := Order.coheight_eq_zero.mp h0
    have hzeq : z = genericPoint X.left :=
      ((show z ⤳ genericPoint X.left from hmax hspec).antisymm hspec).eq
    obtain ⟨w, hw⟩ := f.dense_domain.nonempty
    exact hzdom (hzeq ▸ (genericPoint_specializes w).mem_open f.domain.2 hw)
  · haveI hDVR : IsDiscreteValuationRing (X.left.presheaf.stalk z) :=
      localRing_dvr_of_codim_one_perfectField X z h1
    haveI : ValuationRing (X.left.presheaf.stalk z) := inferInstance
    have hVC : ValuativeCriterion Y.hom := by
      have hP : IsProper Y.hom := inferInstance
      rw [IsProper.eq_valuativeCriterion] at hP
      exact hP.1.1.1
    have hcommSq : CommSq f.fromFunctionField
        (Spec.map (CommRingCat.ofHom
          (algebraMap (X.left.presheaf.stalk z) X.left.functionField)))
        Y.hom (X.left.fromSpecStalk z ≫ X.hom) := ⟨by
      rw [hff, ← Category.assoc]
      congr 1
      exact (Scheme.SpecMap_stalkSpecializes_fromSpecStalk hspec).symm⟩
    have hdom : IsDomain (X.left.presheaf.stalk z) := inferInstance
    have hvr : ValuationRing (X.left.presheaf.stalk z) := inferInstance
    let hfld : Field X.left.functionField := inferInstance
    have hfr : IsFractionRing (X.left.presheaf.stalk z) X.left.functionField :=
      inferInstance
    obtain ⟨hlift⟩ := hVC
      { R := X.left.presheaf.stalk z
        commRing := inferInstance
        domain := hdom
        valuationRing := hvr
        K := X.left.functionField
        field := hfld
        algebra := stalkFunctionFieldAlgebra X.left z
        isFractionRing := hfr
        i₁ := f.fromFunctionField
        i₂ := X.left.fromSpecStalk z ≫ X.hom
        commSq := hcommSq }
    obtain ⟨L₀, hfacl₀, hfacr₀⟩ := hlift.default
    let L : Spec (X.left.presheaf.stalk z) ⟶ Y.left := L₀
    have hfacl : Spec.map (X.left.presheaf.stalkSpecializes hspec) ≫ L
        = f.fromFunctionField := hfacl₀
    have hfacr : L ≫ Y.hom = X.left.fromSpecStalk z ≫ X.hom := hfacr₀
    let g : X.left.PartialMap Y.left :=
      PartialMap.ofFromSpecStalk (x := z) X.hom Y.hom L hfacr
    have hzg : z ∈ g.domain :=
      PartialMap.mem_domain_ofFromSpecStalk (x := z) X.hom Y.hom L hfacr
    have hgL : g.fromSpecStalkOfMem hzg = L :=
      PartialMap.fromSpecStalkOfMem_ofFromSpecStalk (x := z) X.hom Y.hom L hfacr
    have hfactor : g.fromFunctionField =
        Spec.map (X.left.presheaf.stalkSpecializes hspec) ≫
          g.fromSpecStalkOfMem hzg := by
      dsimp only [PartialMap.fromFunctionField, PartialMap.fromSpecStalkOfMem]
      rw [← Category.assoc]
      congr 1
      rw [← cancel_mono g.domain.ι, Category.assoc, Scheme.Opens.fromSpecStalkOfMem_ι,
        Scheme.Opens.fromSpecStalkOfMem_ι, Scheme.SpecMap_stalkSpecializes_fromSpecStalk]
    have hgen : g.toRationalMap = f := by
      refine RationalMap.eq_of_fromFunctionField_eq _ _ ?_
      rw [RationalMap.fromFunctionField_toRationalMap, hfactor, hgL]
      exact hfacl
    exact hzdom (RationalMap.mem_domain.mpr ⟨g, hzg, hgen⟩)

/-- **Milne Theorem 3.1, `CodimOneFree` phrasing, over a perfect field.** -/
theorem codimOneFree_of_smooth_of_complete_perfectField
    {k : Type u} [Field k] [PerfectField k]
    {X : Over (Spec (.of k))}
    [Smooth X.hom] [GeometricallyIrreducible X.hom]
    [IsSeparated X.hom] [LocallyOfFiniteType X.hom]
    [IsIntegral X.left] [IsReduced X.left]
    {Y : Over (Spec (.of k))}
    [IsProper Y.hom] [GeometricallyIrreducible Y.hom]
    [IsIntegral Y.left] [IsReduced Y.left]
    (f : X.left.RationalMap Y.left)
    (hf : f.compHom Y.hom = X.hom.toRationalMap) :
    CodimOneFree f := by
  intro x hx
  by_contra hnotin
  have h2 :=
    indeterminacy_codimGe2_of_smooth_of_complete_perfectField f hf x hnotin
  rw [hx] at h2
  norm_num at h2

end RationalMap

end Scheme

end AlgebraicGeometry
