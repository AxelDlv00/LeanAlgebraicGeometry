/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechAugmentedResolution
import AlgebraicJacobian.Cohomology.OpenImmersionPushforward
import AlgebraicJacobian.Cohomology.AcyclicResolution
import AlgebraicJacobian.Cohomology.CechTermAcyclic

/-!
# Čech computation of higher direct images — capstone leaf (correct hypotheses)

This file is the downstream leaf hosting the Route-A capstone: the Čech-to-derived-pushforward
comparison `cech_computes_higherDirectImage_of_affineCover` under the **correct** hypotheses
`[X.IsSeparated]` and `h𝒰 : ∀ i, IsAffine (𝒰.X i)`.

The companion `CechHigherDirectImage.lean` contains the frozen declaration
`cech_computes_higherDirectImage`, which omits those two hypotheses and is left as a `sorry`
(escalated to the mathematician).  The present file introduces the correctly-stated variant
that the prover can close.

Blueprint chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`,
blocks at lines L11819 (`lem:rightAcyclic_finite_prod`), L11635 (`lem:cech_term_pushforward_acyclic`),
L11845 (`lem:pushforward_mapHC_cechComplexOnX`), L11885 (`lem:cechAugmented_to_acyclicResolutionInput`),
L11926 (`lem:cech_computes_cohomology_affineCover`).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {X S : Scheme.{u}}

/-! ## Pushforward commutes with the Čech complex functor -/

/- Planner strategy: lem:pushforward_mapHC_cechComplexOnX ·
Both complexes are built as `alternatingCofaceMapComplex` of the same cosimplicial object, differing
only in whether `f_*` is applied before or after the alternating coface construction.  Since `f_*`
is additive, `(f_*).mapHomologicalComplex` commutes with `alternatingCofaceMapComplex` by the
naturality of `CosimplicialObject.whiskering` and the fact that the alternating-coface differential
is an alternating sum that `f_*` preserves by additivity.
Concretely: `cechComplexOnX 𝒰 F = alternatingCofaceMapComplex.obj (drop (CechNerve 𝒰 F))`,
and `CechComplex f 𝒰 F = relativeCechComplexOfNerve f (CechNerve 𝒰 F)
                        = alternatingCofaceMapComplex.obj (f_* ∘ drop (CechNerve 𝒰 F))`.
The iso is the natural isomorphism between the two functors
`alternatingCofaceMapComplex ∘ whiskering(f_*)` and `(f_*).mapHomologicalComplex ∘ alternatingCofaceMapComplex`
applied to the same cosimplicial object; the components are identities in each degree. -/
/-- **An additive functor commutes with the alternating coface map complex** (object-level
cosimplicial analogue of `AlgebraicTopology.map_alternatingFaceMapComplex`). The components are
identities: in each degree both complexes have the object `G.obj (Y.obj ⦋p⦌)`, and the
differential of the whiskered complex is `G` applied to the alternating coface differential,
by additivity (`Functor.map_sum`, `Functor.map_zsmul`). Project-local helper. -/
noncomputable def mapAlternatingCofaceMapComplexIso
    {C D : Type*} [Category C] [Category D] [Preadditive C] [Preadditive D]
    (G : C ⥤ D) [G.Additive] (Y : CosimplicialObject C) :
    (G.mapHomologicalComplex (ComplexShape.up ℕ)).obj
        ((AlgebraicTopology.alternatingCofaceMapComplex C).obj Y) ≅
      (AlgebraicTopology.alternatingCofaceMapComplex D).obj
        (((CosimplicialObject.whiskering C D).obj G).obj Y) :=
  HomologicalComplex.Hom.isoOfComponents (fun _ => Iso.refl _) (by
    rintro i j (rfl : i + 1 = j)
    simp only [Iso.refl_hom, Category.id_comp, Category.comp_id,
      Functor.mapHomologicalComplex_obj_d, AlgebraicTopology.alternatingCofaceMapComplex_obj]
    dsimp only [AlgebraicTopology.AlternatingCofaceMapComplex.obj]
    rw [CochainComplex.of_d, CochainComplex.of_d]
    simp only [AlgebraicTopology.AlternatingCofaceMapComplex.objD, Functor.map_sum,
      Functor.map_zsmul]
    rfl)

/-- **The `f_*`-image of the un-augmented Čech complex on `X` is isomorphic to the relative Čech
complex** (blueprint `lem:pushforward_mapHC_cechComplexOnX`). -/
noncomputable def pushforward_mapHomologicalComplex_cechComplexOnX
    (f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) :
    ((Scheme.Modules.pushforward f).mapHomologicalComplex (ComplexShape.up ℕ)).obj
        (cechComplexOnX 𝒰 F) ≅ CechComplex f 𝒰 F :=
  -- `cechComplexOnX` and `CechComplex` are *definitionally* the alternating coface complexes of
  -- the (un-whiskered, resp. `f_*`-whiskered) underlying cosimplicial object of the Čech nerve,
  -- so the general helper applies on the nose.
  mapAlternatingCofaceMapComplexIso (Scheme.Modules.pushforward f)
    (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))

/-! ## From augmented exactness to the acyclic-resolution input data -/

/- Planner strategy: lem:cechAugmented_to_acyclicResolutionInput ·
From `cechAugmented_exact` (CechAugmentedResolution.lean) we have:
  `∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p)`.
The augmented complex has `X 0 = F` and `X (n+1) = (cechComplexOnX 𝒰 F).X n`; its differential at
degree 0 is the augmentation `ε : F → C⁰`.

(1) Exactness of `cechComplexOnX 𝒰 F` at degree `n+1`:  the augmented complex at degree `n+2`
    coincides with the un-augmented complex at degree `n+1`.  Use
    `HomologicalComplex.exactAt_iff_isZero_homology` plus the vanishing from `cechAugmented_exact`.

(2) Iso `e : F ≅ (cechComplexOnX 𝒰 F).cycles 0`:  vanishing of homology at degree 0 gives that
    ε is a monomorphism; vanishing at degree 1 gives that the image of ε equals `ker d⁰ = cycles 0`.
    Hence ε is an iso onto `cycles 0`.  The iso is assembled from the augmentation `cechAugmentation`
    and the exactness data; use `ShortComplex.Exact.isoOfEpiMonoIsZero` or similar.

Both outputs are assembled into a `PProd` (anonymous constructor `⟨e, hexact⟩`; `PProd` rather
than `Prod` because the second component is a `Prop` while the first is an `Iso` in `Type`). -/
/-- **From augmented exactness to the P4 input data**
(blueprint `lem:cechAugmented_to_acyclicResolutionInput`).

Given the hypotheses of `cechAugmented_exact`, this declaration packages the two pieces of data
that `rightDerivedIsoOfAcyclicResolution` (the abstract acyclic-resolution lemma) requires:
an isomorphism `e : F ≅ (cechComplexOnX 𝒰 F).cycles 0` identifying `F` with the 0-cocycles,
and exactness `(cechComplexOnX 𝒰 F).ExactAt (n+1)` in every positive degree. -/
noncomputable def cechAugmented_to_acyclicResolutionInput
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    (F ≅ (cechComplexOnX 𝒰 F).cycles 0) ×' (∀ n, (cechComplexOnX 𝒰 F).ExactAt (n + 1)) := by
  have hKex : ∀ p, (cechAugmentedComplex 𝒰 F).ExactAt p := fun p =>
    (HomologicalComplex.exactAt_iff_isZero_homology _ p).2 (cechAugmented_exact 𝒰 h𝒰 F hF p)
  -- (2) positive-degree exactness: the short complex of the augmented complex around `n+2`
  -- is definitionally the short complex of the un-augmented complex around `n+1`.
  have hexact : ∀ n, (cechComplexOnX 𝒰 F).ExactAt (n + 1) := by
    intro n
    have h := hKex (n + 2)
    rw [(cechAugmentedComplex 𝒰 F).exactAt_iff' (n + 1) (n + 2) (n + 3)
      ((ComplexShape.up ℕ).prev_eq' rfl) ((ComplexShape.up ℕ).next_eq' rfl)] at h
    rw [(cechComplexOnX 𝒰 F).exactAt_iff' n (n + 1) (n + 2)
      ((ComplexShape.up ℕ).prev_eq' rfl) ((ComplexShape.up ℕ).next_eq' rfl)]
    exact h
  -- ε is a monomorphism: the augmented complex is exact at 0 and its incoming map vanishes.
  have h0 := hKex 0
  rw [(cechAugmentedComplex 𝒰 F).exactAt_iff' 0 0 1 CochainComplex.prev_nat_zero
    ((ComplexShape.up ℕ).next_eq' rfl)] at h0
  haveI hmono : Mono (cechAugmentation 𝒰 F) :=
    h0.mono_g ((cechAugmentedComplex 𝒰 F).shape 0 0 (by simp))
  -- exactness of the augmented complex at 1: the short complex `F –ε→ C⁰ –d⁰→ C¹`.
  have h1 := hKex 1
  rw [(cechAugmentedComplex 𝒰 F).exactAt_iff' 0 1 2
    ((ComplexShape.up ℕ).prev_eq' rfl) ((ComplexShape.up ℕ).next_eq' rfl)] at h1
  haveI : Mono ((cechAugmentedComplex 𝒰 F).sc' 0 1 2).f := hmono
  -- `ι' ≫ ε = iCycles`: the exactness-lift of the cycle inclusion through ε.
  have hl : h1.lift ((cechComplexOnX 𝒰 F).iCycles 0) ((cechComplexOnX 𝒰 F).iCycles_d 0 1) ≫
      cechAugmentation 𝒰 F = (cechComplexOnX 𝒰 F).iCycles 0 := h1.lift_f _ _
  refine ⟨⟨(cechComplexOnX 𝒰 F).liftCycles (cechAugmentation 𝒰 F) 1
      ((ComplexShape.up ℕ).next_eq' rfl) (cechAugmentation_comp_d 𝒰 F),
    h1.lift ((cechComplexOnX 𝒰 F).iCycles 0) ((cechComplexOnX 𝒰 F).iCycles_d 0 1),
    ?_, ?_⟩, hexact⟩
  · -- hom_inv_id: cancel the monomorphism ε on the right.
    rw [← cancel_mono (cechAugmentation 𝒰 F), Category.assoc, Category.id_comp, hl,
      HomologicalComplex.liftCycles_i]
  · -- inv_hom_id: cancel the monomorphism `iCycles` on the right.
    rw [← cancel_mono ((cechComplexOnX 𝒰 F).iCycles 0), Category.assoc, Category.id_comp,
      HomologicalComplex.liftCycles_i, hl]

/-! ## Capstone: Čech computes higher direct images (affine-cover form) -/

/- Planner strategy: lem:cech_computes_cohomology_affineCover ·
Assembly of the four Route-A ingredients:

(a) `cechAugmented_to_acyclicResolutionInput` yields:
    · `e : F ≅ (cechComplexOnX 𝒰 F).cycles 0`
    · `hexact : ∀ n, (cechComplexOnX 𝒰 F).ExactAt (n+1)`

(b) `cechTerm_pushforward_acyclic` provides the typeclass instance:
    `[∀ p, (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X p)]`
    (introduce with `haveI` for each `p`; or use `inferInstance` if the `∀ p` form is
    synthesisable from a blanket instance).

(c) `Functor.rightDerivedIsoOfAcyclicResolution` (AcyclicResolution.lean, fully proved) with
    G = `Scheme.Modules.pushforward f`, K = `cechComplexOnX 𝒰 F`, A = F, gives:
    `((Scheme.Modules.pushforward f).rightDerived i).obj F
      ≅ ((G.mapHomologicalComplex (ComplexShape.up ℕ)).obj (cechComplexOnX 𝒰 F)).homology i`

(d) `pushforward_mapHomologicalComplex_cechComplexOnX` rewrites the right-hand side to
    `(CechComplex f 𝒰 F).homology i`.

The final iso `(CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F` is the composite of
(d).symm, (c).symm, noting `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
Wrap in `Nonempty` via `⟨iso⟩`.

Additive / PreservesFiniteLimits hypotheses on `pushforward f`: `Additive` is an instance;
`PreservesFiniteLimits` is needed for `rightDerivedIsoOfAcyclicResolution` (via
`PreservesFiniteLimits (Scheme.Modules.pushforward f)` — left-exact since it is a right adjoint
via the global sections adjunction). -/
/-- **Čech computes higher direct images — affine-cover form**
(blueprint `lem:cech_computes_cohomology_affineCover`; Stacks Tag 02KE).

Let `f : X ⟶ S` be a separated quasi-compact morphism with `X` separated, `F` a quasi-coherent
`O_X`-module, and `𝒰` a finite affine open cover of `X`.  Then for every `i ≥ 0` there is an
isomorphism between the `i`-th cohomology of the relative Čech complex and the `i`-th higher
direct image:
```
  (CechComplex f 𝒰 F).homology i ≅ R^i f_* F  =  higherDirectImage f i F.
```
This is the correctly-stated capstone; the frozen `cech_computes_higherDirectImage` in
`CechHigherDirectImage.lean` omits `[X.IsSeparated]` and `h𝒰` and is escalated. -/
theorem cech_computes_higherDirectImage_of_affineCover [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F) := by
  -- (a) the resolution data extracted from the exactness of the augmented Čech complex
  obtain ⟨e, hexact⟩ := cechAugmented_to_acyclicResolutionInput 𝒰 h𝒰 F hF
  -- (b) termwise right-`f_*`-acyclicity of the Čech complex on `X` (black box from
  -- `CechTermAcyclic.lean`)
  haveI : ∀ n, (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X n) :=
    fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n
  -- (c) `f_*` is left exact: it is a right adjoint (of the module pullback)
  haveI : PreservesLimits (Scheme.Modules.pushforward f) :=
    (Scheme.Modules.pullbackPushforwardAdjunction f).rightAdjoint_preservesLimits
  -- (d) assemble: P4 acyclic-resolution comparison, then rewrite `f_* C•` to the relative
  -- Čech complex; `higherDirectImage f i F` is definitionally `((f_*).rightDerived i).obj F`.
  exact ⟨(HomologicalComplex.homologyFunctor S.Modules (ComplexShape.up ℕ) i).mapIso
      (pushforward_mapHomologicalComplex_cechComplexOnX f 𝒰 F).symm ≪≫
    ((Scheme.Modules.pushforward f).rightDerivedIsoOfAcyclicResolution
      (cechComplexOnX 𝒰 F) F e hexact i).symm⟩

end AlgebraicGeometry
