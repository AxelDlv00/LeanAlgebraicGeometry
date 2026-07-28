import AlgebraicJacobian.Cohomology.CechHigherDirectImageUnconditional

/-!
Scratch probe (task ajc-fbc, run 0068 round 1).  NOT part of the library.

THE ROUTE.  `pullback_preservesMonomorphisms` quantifies over ALL modules and is walled
(no pointwise model of the module pullback).  But the CONSUMER only needs homology
preservation at the *specific* short complexes of the Čech complex, whose terms are
quasi-coherent, i.e. in the essential image of `tilde` over an affine base.  And on the
tilde image exactness is ALREADY PROVED (`tildePullback_preservesFiniteLimits`).

Step 1 (this file): cone-cancellation.  `tilde` preserves finite limits and
`tilde ⋙ pullback (Spec φ)` preserves finite limits, so `pullback (Spec φ)` preserves the
limit of any diagram *of the form* `K ⋙ tilde`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-- **Cone-cancellation.**  If `F` preserves the limit of `K` and `F ⋙ G` preserves the limit
of `K`, then `G` preserves the limit of `K ⋙ F`. -/
theorem probe_preservesLimit_comp_cancel {J C D E : Type*} [Category J] [Category C]
    [Category D] [Category E] (K : J ⥤ C) (F : C ⥤ D) (G : D ⥤ E)
    [HasLimit K] [PreservesLimit K F] [PreservesLimit K (F ⋙ G)] :
    PreservesLimit (K ⋙ F) G := by
  refine preservesLimit_of_preserves_limit_cone
    (isLimitOfPreserves F (limit.isLimit K)) ?_
  exact isLimitOfPreserves (F ⋙ G) (limit.isLimit K)

/-- Step 2: flat pullback preserves finite limits of diagrams *of tildes*. -/
theorem probe_tildePullback_preservesLimit {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (hφ : φ.hom.Flat) {J : Type} [SmallCategory J] [FinCategory J] (K : J ⥤ ModuleCat.{u} R) :
    PreservesLimit (K ⋙ tilde.functor R) (Scheme.Modules.pullback (Spec.map φ)) := by
  haveI := tildePreservesFiniteLimits (R := R)
  haveI := tildePullback_preservesFiniteLimits φ hφ
  exact probe_preservesLimit_comp_cancel K (tilde.functor R) _

/-- Step 3: the parallel-pair specialisation, i.e. flat pullback preserves the KERNEL of a
map between tildes. -/
theorem probe_tildePullback_preservesKernel {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (hφ : φ.hom.Flat) {M N : ModuleCat.{u} R} (f : M ⟶ N) :
    PreservesLimit (parallelPair ((tilde.functor R).map f) 0)
      (Scheme.Modules.pullback (Spec.map φ)) := by
  haveI := probe_tildePullback_preservesLimit φ hφ (parallelPair f 0)
  exact preservesLimit_of_iso_diagram (Scheme.Modules.pullback (Spec.map φ))
    (parallelPair.ext (Iso.refl _) (Iso.refl _) :
      parallelPair f 0 ⋙ tilde.functor R ≅ parallelPair ((tilde.functor R).map f) 0)

/-! ### Step 4: lift from `Spec.map φ` to a general flat `g` between AFFINE schemes.

The Čech consumer carries `[IsAffine S] [IsAffine S']`, so `g` is `isoSpec`-conjugate to
`Spec.map (Γ g)`.  We need: exactness transports along conjugation by the pullback functors of
isomorphisms. -/

#check @AlgebraicGeometry.arrowIsoSpecΓOfIsAffine
#check @Scheme.Modules.pullbackIsoPushforwardInv
#check @Scheme.Modules.pushforwardEquivOfIso

/-- Pullback along an iso is an equivalence, via pushforward along the inverse. -/
theorem probe_pullback_iso_isEquivalence {X Y : Scheme.{u}} (e : X ≅ Y) :
    (Scheme.Modules.pullback e.hom).IsEquivalence := by
  haveI : (Scheme.Modules.pushforward e.inv).IsEquivalence :=
    (Scheme.Modules.pushforwardEquivOfIso e.symm).isEquivalence_functor
  exact Functor.isEquivalence_of_iso (Scheme.Modules.pullbackIsoPushforwardInv e).symm

/-- For a flat morphism `g` between AFFINE schemes, the ring map `Γ(g)` is flat. -/
theorem probe_appTop_flat {S S' : Scheme.{u}} (g : S' ⟶ S) [Flat g] [IsAffine S] [IsAffine S'] :
    (Scheme.Hom.appTop g).hom.Flat := by
  have h := Flat.flat_appLE g (U := ⊤) (isAffineOpen_top S) (V := ⊤) (isAffineOpen_top S')
    (by simp)
  rw [Scheme.Hom.appLE] at h
  simpa [Scheme.Hom.appTop] using h


/-! ### Step 5: per-short-complex homology preservation needs only ONE kernel

`mapHomologyIso` requires only `PreservesLeftHomologyOf S`, and a left homology datum is
preserved as soon as `F` preserves the kernel of `S.g` (the cokernel half is free for a left
adjoint).  So the GLOBAL `PreservesHomology` is far more than the consumer needs. -/

open ShortComplex in
theorem probe_preservesLeftHomologyOf_of_preservesKernel {C D : Type*} [Category C] [Category D]
    [Abelian C] [Abelian D] (F : C ⥤ D) [F.Additive] [Limits.PreservesFiniteColimits F]
    (S : ShortComplex C) [Limits.PreservesLimit (Limits.parallelPair S.g 0) F] :
    F.PreservesLeftHomologyOf S :=
  ⟨fun _ => ⟨inferInstance, inferInstance⟩⟩

/-! ### Step 6: transport from `Spec.map (Γ g)` to `g` itself.

`arrowIsoSpecΓOfIsAffine g : Arrow.mk g ≅ Arrow.mk (Spec.map (Γ g))` gives the two square
identities.  What we want is `pullback g ≅ (conjugate of) pullback (Spec.map (Γ g))`, which comes
from `pullbackComp` + `pullbackCongr` on `g ≫ isoSpec.hom = isoSpec.hom ≫ Spec.map (Γ g)`. -/

/-- The pullback functor of a flat `g` between affines, conjugated onto `Spec.map (Γ g)`. -/
noncomputable def probe_pullbackConjIso {S S' : Scheme.{u}} (g : S' ⟶ S)
    [IsAffine S] [IsAffine S'] :
    Scheme.Modules.pullback S.isoSpec.hom ⋙ Scheme.Modules.pullback g ≅
      Scheme.Modules.pullback (Spec.map (Scheme.Hom.appTop g)) ⋙
        Scheme.Modules.pullback S'.isoSpec.hom :=
  Scheme.Modules.pullbackComp g S.isoSpec.hom ≪≫
    Scheme.Modules.pullbackCongr (Scheme.isoSpec_hom_naturality g).symm ≪≫
    (Scheme.Modules.pullbackComp S'.isoSpec.hom (Spec.map (Scheme.Hom.appTop g))).symm

end AlgebraicGeometry
