/-
Copyright (c) 2026 Archon Horizon. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Horizon (Archon Horizon)
-/
import Mathlib
import AlgebraicJacobian.Picard.RigidPushforward
import AlgebraicJacobian.Picard.QuotScheme
import AlgebraicJacobian.Picard.ChartSectionsFinite
import AlgebraicJacobian.Picard.GenericFlatnessGeometric
import AlgebraicJacobian.Picard.InvertibleGrBridge
import AlgebraicJacobian.Picard.PullbackFinitePresentation

/-!
# B3 transfer package — discharging the named hypotheses of the ℙ¹ reduction

`Picard/RigidPushforward.lean` reduces B3 local freeness for the constant
curve `C_A` to the ℙ¹ engine plus a *finite-pushforward transfer package*
along the finite map `π_A : C_A ⟶ ℙ¹_A` (`rigidPushforwardLocallyFree_of_p1`,
hypotheses `hfp`/`hflat`/`hH1`/`hH0`).  This file discharges the first two
transfer hypotheses:

* **`hfp` (Stacks 01XZ/087T flavour)** —
  `pushforward_finiteMapToP1BaseChange_isFinitePresentation`: the finite
  pushforward `(π_A)_* L` of an invertible module is finitely presented.
  The engine behind it is the general noetherian coherence criterion
  `Scheme.Modules.isFinitePresentation_of_finite_sections`: a quasi-coherent
  module on a locally noetherian scheme whose section modules over affine
  opens are finite is finitely presented.  The pushforward is quasi-coherent
  by Stacks 01XJ (`pushforward_isQuasicoherent`, proved in
  `Picard/QuotScheme.lean`), its sections over an affine `V` are
  `Γ(L, π_A⁻¹ V)` *definitionally*, and these are module-finite over
  `Γ(ℙ¹_A, V)` by composing the module-finiteness of the finite morphism
  `π_A` (Stacks 01WG) with the finiteness of the sections of the finitely
  presented `L` on the affine `π_A⁻¹ V` (Stacks 01PC,
  `finite_sections_preimage_of_isAffineHom`).  `A` is a finitely generated
  `k`-algebra, hence noetherian (Hilbert basis), hence `ℙ¹_A` is locally
  noetherian and finite section modules are finitely presented.

* **`hflat` (mixed-base flat stability)** —
  `pushforward_finiteMapToP1BaseChange_coherentSheafFlat`: `(π_A)_* L`
  stays `CoherentSheafFlat` over `Spec A`.  Since
  `Γ((π_A)_* L, V) = Γ(L, π_A⁻¹ V)` definitionally and
  `q = π_A ≫ p` (`finiteMapToP1BaseChange_snd`), the statement reduces to
  `CoherentSheafFlat q L` for the invertible `L` on the `A`-flat family
  `q : C_A ⟶ Spec A` (`coherentSheafFlat_pushforward_of_isAffineHom`).
  The latter is `coherentSheafFlat_of_isLocallyTrivial_of_flat`: on a
  trivialising affine chart `W` the section module `Γ(L, W)` is an
  invertible (hence flat) `Γ(C_A, W)`-module
  (`isInvertible_of_restrict_iso`), `Γ(C_A, W)` is flat over `A` because
  `q` is a flat morphism (base change of `C ⟶ Spec k`, and everything over
  the one-point integral `Spec k` is flat), and chart flatness globalises
  to all affine pairs by the affine-locality engine
  `flat_section_of_affine_cover` (`Picard/GenericFlatnessGeometric.lean`).

No pinned statement is touched: this file only *produces* the named
hypotheses consumed by `rigidPushforwardLocallyFree_of_p1`.

Sources: Stacks 01XJ (pushforward quasi-coherence), 01XZ/087T (finite
pushforward of coherent is coherent), 01PC (finite sections on affines),
01WG (finite morphisms are module-finite on affines), 00HB/00HT (flatness
is affine-local); Nitsure §4; Mumford AV II §5.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

/-! ## §1. Finite-module transport along a semilinear additive equivalence

The elementary bookkeeping brick for moving `Module.Finite` across the
section comparisons of the fromSpec dictionary: a surjective-semilinear
additive equivalence transports finite generation. -/

/-- **`Module.Finite` descends along a surjective-semilinear additive
equivalence.**  If `e : M ≃+ N` intertwines the `R`-action on `M` with the
`S`-action on `N` through a surjective ring homomorphism `σ : R →+* S`
(`e (r • x) = σ r • e x`) and `N` is a finite `S`-module, then `M` is a
finite `R`-module: the preimages of a finite `S`-generating set generate
`M` over `R`, because every `S`-scalar lifts along `σ`. -/
theorem Module.Finite.of_addEquiv_semilinear {R S : Type u} [Semiring R] [Semiring S]
    {M N : Type u} [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module S N]
    (σ : R →+* S) (hσ : Function.Surjective σ) (e : M ≃+ N)
    (he : ∀ (r : R) (x : M), e (r • x) = σ r • e x) (hN : Module.Finite S N) :
    Module.Finite R M := by
  obtain ⟨n, w, hw⟩ := hN.exists_fin (R := S) (M := N)
  refine Module.finite_def.mpr (Submodule.fg_def.mpr
    ⟨⇑e.symm '' Set.range w, ((Set.finite_range w).image _), ?_⟩)
  rw [eq_top_iff]
  intro x _
  have hx : e x ∈ Submodule.span S (Set.range w) := hw ▸ Submodule.mem_top
  have key : ∀ (y : N), y ∈ Submodule.span S (Set.range w) →
      e.symm y ∈ Submodule.span R (⇑e.symm '' Set.range w) := by
    intro y hy
    induction hy using Submodule.span_induction with
    | mem z hz => exact Submodule.subset_span ⟨z, hz, rfl⟩
    | zero => rw [map_zero]; exact Submodule.zero_mem _
    | add a b _ _ ha hb => rw [map_add]; exact Submodule.add_mem _ ha hb
    | smul s y hy' ih =>
      obtain ⟨r, rfl⟩ := hσ s
      have : e.symm (σ r • y) = r • e.symm y := by
        apply e.injective
        rw [he, e.apply_symm_apply, e.apply_symm_apply]
      rw [this]
      exact Submodule.smul_mem _ _ ih
  simpa using key (e x) hx

/-! ## §2. The noetherian coherence criterion (finite sections ⟹ finitely presented)

For a quasi-coherent module `N` on a locally noetherian scheme, finiteness
of the section modules over affine opens forces finite presentation: over
each affine `U` the module `N|_U` is the tilde of its (finite, hence — by
noetherianity — finitely presented) section module, and a finite module
over a noetherian ring admits a finite free presentation whose tilde is a
finite `SheafOfModules.Presentation`. -/

namespace Scheme.Modules

variable {Y : Scheme.{u}}

/-- **Section finiteness of the `fromSpec` pullback.**  For a module `N` on
`Y` and an affine open `U`, the module of global sections of the pullback
of `N` along `hU.fromSpec : Spec Γ(Y, U) ⟶ Y` is finite over `Γ(Y, U)`
(with the canonical `R`-module structure of sections over `Spec R`),
provided the sections of `N` over the image open `fromSpec ''ᵁ ⊤ (= U)`
are finite over its section ring.  Transport along the section comparison
`gammaPullbackImageIso` of the open immersion `fromSpec`, which is
semilinear over the (surjective) ring comparison
`Γ(Spec Γ(Y, U), ⊤) ≃+* Γ(Y, fromSpec ''ᵁ ⊤)` composed with the global
sections identification `ΓSpecIso`. -/
theorem module_finite_gamma_pullback_fromSpec (N : Y.Modules)
    {U : Y.Opens} (hU : IsAffineOpen U)
    (hfin : Module.Finite Γ(Y, hU.fromSpec ''ᵁ (⊤ : (Spec Γ(Y, U)).Opens))
      Γ(N, hU.fromSpec ''ᵁ (⊤ : (Spec Γ(Y, U)).Opens))) :
    Module.Finite Γ(Y, U) Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) := by
  set j := hU.fromSpec with hj
  -- the surjective ring comparison `Γ(Y, U) →+* Γ(Y, j ''ᵁ ⊤)`
  let σ : (Γ(Y, U) : Type u) →+* (Γ(Y, j ''ᵁ (⊤ : (Spec Γ(Y, U)).Opens)) : Type u) :=
    (Scheme.Modules.gammaImageRingEquiv j (⊤ : (Spec Γ(Y, U)).Opens)).toRingHom.comp
      ((Scheme.ΓSpecIso Γ(Y, U)).inv.hom)
  have hmid : (Spec Γ(Y, U)).presheaf.map
      (Opens.leTop (⊤ : (Spec Γ(Y, U)).Opens)).op = 𝟙 _ := by
    rw [show (Opens.leTop (⊤ : (Spec Γ(Y, U)).Opens)) =
      𝟙 (⊤ : (Spec Γ(Y, U)).Opens) from rfl]
    exact (Spec Γ(Y, U)).presheaf.map_id _
  have hσ : Function.Surjective σ := by
    intro z
    obtain ⟨y, hy⟩ :=
      (Scheme.Modules.gammaImageRingEquiv j (⊤ : (Spec Γ(Y, U)).Opens)).surjective z
    refine ⟨(Scheme.ΓSpecIso Γ(Y, U)).hom.hom y, ?_⟩
    change (Scheme.Modules.gammaImageRingEquiv j (⊤ : (Spec Γ(Y, U)).Opens))
      ((Scheme.ΓSpecIso Γ(Y, U)).inv.hom ((Scheme.ΓSpecIso Γ(Y, U)).hom.hom y)) = z
    have hcancel : (Scheme.ΓSpecIso Γ(Y, U)).inv.hom
        ((Scheme.ΓSpecIso Γ(Y, U)).hom.hom y) = y := by
      have h0 := (Scheme.ΓSpecIso Γ(Y, U)).hom_inv_id
      have h1 := congrArg
        (fun φ : Γ(Spec Γ(Y, U), ⊤) ⟶ Γ(Spec Γ(Y, U), ⊤) => φ.hom y) h0
      simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_id,
        RingHom.id_apply] at h1
      exact h1
    rw [hcancel]
    exact hy
  -- the additive section comparison of the open immersion `j`
  let e : (Γ((Scheme.Modules.pullback j).obj N, ⊤) : Type u) ≃+
      (Γ(N, j ''ᵁ (⊤ : (Spec Γ(Y, U)).Opens)) : Type u) :=
    (Scheme.Modules.gammaPullbackImageIso j N (⊤ : (Spec Γ(Y, U)).Opens)).addCommGroupIsoToAddEquiv
  refine Module.Finite.of_addEquiv_semilinear σ hσ e (fun r x => ?_) hfin
  -- semilinearity: unfold the `R`-action on Spec sections and apply the
  -- semilinearity of the pullback-section comparison
  change (Scheme.Modules.gammaPullbackImageIso j N _).hom.hom (r • x) =
    σ r • (Scheme.Modules.gammaPullbackImageIso j N _).hom.hom x
  rw [Scheme.Modules.smul_Spec_def (M := (Scheme.Modules.pullback j).obj N) r x, hmid]
  exact Scheme.Modules.gammaPullbackImageIso_hom_semilinear j N _ _ x

set_option backward.isDefEq.respectTransparency false in
/-- **A finite module sheaf on `Spec R` (R noetherian) with invertible
tilde–Γ counit admits a finite presentation.**  Choose a finite generating
family of the global sections (`Module.Finite.exists_fin`); the kernel of
the induced surjection from the finite free module is finitely generated
because `R` is noetherian; `presentationTilde` packages the data into a
finite `SheafOfModules.Presentation` of the tilde, which transports to `F`
across the (invertible) counit `fromTildeΓ`. -/
theorem exists_finite_presentation_of_isIso_fromTildeΓ {R : CommRingCat.{u}}
    (F : (Spec R).Modules) [IsIso (Scheme.Modules.fromTildeΓ F)]
    [IsNoetherianRing (R : Type u)]
    (hfin : Module.Finite (R : Type u) Γ(F, ⊤)) :
    ∃ P : F.Presentation, P.IsFinite := by
  set M0 : ModuleCat.{u} (R : Type u) :=
    (modulesSpecToSheaf.obj F).presheaf.obj (op (⊤ : (Spec R).Opens)) with hM0
  haveI hfin0 : Module.Finite (R : Type u) M0 := hfin
  obtain ⟨n, w, hw⟩ := hfin0.exists_fin
  set s : Set M0 := Set.range w with hsdef
  haveI : Finite (↥s) := (Set.finite_range w).to_subtype
  haveI : Module.Finite (R : Type u) (↥s →₀ (R : Type u)) := by infer_instance
  haveI : _root_.IsNoetherian (R : Type u) (↥s →₀ (R : Type u)) :=
    isNoetherian_of_isNoetherianRing_of_finite _ _
  obtain ⟨T, hT⟩ := _root_.IsNoetherian.noetherian
    (Finsupp.linearCombination (R : Type u) (Subtype.val : ↥s → M0)).ker
  haveI : Finite (↥(T : Set (↥s →₀ (R : Type u)))) := T.finite_toSet.to_subtype
  let P0 : (tilde M0).Presentation :=
    presentationTilde M0 s hw (T : Set (↥s →₀ (R : Type u))) hT
  haveI hP0gen : P0.generators.IsFiniteType :=
    { finite := inferInstanceAs (Finite ↥s) }
  haveI hP0rel : P0.relations.IsFiniteType :=
    { finite := inferInstanceAs (Finite (↥(T : Set (↥s →₀ (R : Type u))))) }
  haveI hP0 : P0.IsFinite :=
    SheafOfModules.Presentation.IsFinite.mk.{u, u, u} (p := P0) hP0gen hP0rel
  let eT : tilde M0 ≅ F :=
    @asIso _ _ _ _ (Scheme.Modules.fromTildeΓ F) ‹_›
  exact ⟨SheafOfModules.Presentation.ofIsIso.{u} eT.hom P0, inferInstance⟩

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Heartbeat headroom for the slice-site presentation transports and their
-- `IsFinite` instance searches, as elsewhere in the QuotScheme transport layer.
set_option synthInstance.maxHeartbeats 800000 in
/-- **Per-affine finite slice presentation from finite sections** (noetherian
coherence, slice form).  For a quasi-coherent `N` on a locally noetherian
scheme `Y` with finite section modules over affine opens, every affine `U`
carries a *finite* presentation of the slice `N.over U`.  This is the
finite upgrade of `pushforward_isQuasicoherent_over_affine`'s transport
chain: identify `N|_U` with the tilde of its finite section module (gap1,
`isIso_fromTildeΓ_of_isQuasicoherent`), take the finite tilde presentation
(`exists_finite_presentation_of_isIso_fromTildeΓ`), and transport back to
the slice along `U.ι = isoSpec.hom ≫ fromSpec`
(`presentationPullbackOfSchemeIso`, `overRestrictPresentationInv`), all of
which preserve the (finite) generator/relation index types. -/
theorem exists_finite_presentation_over_of_finite_sections
    [IsLocallyNoetherian Y] (N : Y.Modules) [N.IsQuasicoherent]
    (hfin : ∀ V : Y.Opens, IsAffineOpen V → Module.Finite Γ(Y, V) Γ(N, V))
    {U : Y.Opens} (hU : IsAffineOpen U) :
    ∃ P : (N.over U).Presentation, P.IsFinite := by
  haveI := Scheme.Modules.isQuasicoherent_pullback_fromSpec N hU
  haveI hP1 : IsIso (Scheme.Modules.fromTildeΓ
      ((Scheme.Modules.pullback hU.fromSpec).obj N)) :=
    Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent _
  haveI : IsNoetherianRing Γ(Y, U) :=
    IsLocallyNoetherian.component_noetherian ⟨U, hU⟩
  have himg : hU.fromSpec ''ᵁ (⊤ : (Spec Γ(Y, U)).Opens) = U := by
    rw [Scheme.Hom.image_top_eq_opensRange]
    exact Opens.ext hU.range_fromSpec
  have hfinTop : Module.Finite Γ(Y, U)
      Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) :=
    module_finite_gamma_pullback_fromSpec N hU
      (hfin _ (himg.symm ▸ hU))
  obtain ⟨P_M', hPfin⟩ :=
    exists_finite_presentation_of_isIso_fromTildeΓ
      ((Scheme.Modules.pullback hU.fromSpec).obj N) hfinTop
  haveI := hPfin
  have hcomp : hU.isoSpec.hom ≫ hU.fromSpec = U.ι := by
    rw [← hU.isoSpec_inv_ι, Iso.hom_inv_id_assoc]
  haveI hmapfin : (Scheme.Modules.presentationPullbackOfSchemeIso hU.isoSpec.symm
      ((Scheme.Modules.pullback hU.fromSpec).obj N) P_M').IsFinite := by
    delta Scheme.Modules.presentationPullbackOfSchemeIso
    infer_instance
  let P_ι : ((Scheme.Modules.pullback U.ι).obj N).Presentation :=
    SheafOfModules.Presentation.ofIsIso.{u, u, u}
      ((Scheme.Modules.pullbackComp hU.isoSpec.hom hU.fromSpec).app N ≪≫
        (Scheme.Modules.pullbackCongr hcomp).app N).hom
      (Scheme.Modules.presentationPullbackOfSchemeIso hU.isoSpec.symm
        ((Scheme.Modules.pullback hU.fromSpec).obj N) P_M')
  haveI hPιfin : P_ι.IsFinite := by
    change (SheafOfModules.Presentation.ofIsIso.{u, u, u}
      ((Scheme.Modules.pullbackComp hU.isoSpec.hom hU.fromSpec).app N ≪≫
        (Scheme.Modules.pullbackCongr hcomp).app N).hom
      (Scheme.Modules.presentationPullbackOfSchemeIso hU.isoSpec.symm
        ((Scheme.Modules.pullback hU.fromSpec).obj N) P_M')).IsFinite
    infer_instance
  refine ⟨Scheme.Modules.overRestrictPresentationInv U N P_ι, ?_⟩
  delta Scheme.Modules.overRestrictPresentationInv
  infer_instance

set_option maxHeartbeats 800000 in
-- Heartbeat headroom for the slice-site `HasSheafify` synthesis triggered by
-- assembling the `QuasicoherentData`, as elsewhere in this transport layer.
set_option synthInstance.maxHeartbeats 400000 in
/-- **The noetherian coherence criterion** (finite sections ⟹ finitely
presented; Stacks 01XZ-grade bookkeeping).  A quasi-coherent sheaf of
modules on a locally noetherian scheme whose section modules over all
affine opens are finite over the respective section rings is finitely
presented: assemble the per-affine finite slice presentations
(`exists_finite_presentation_over_of_finite_sections`) over the affine
opens cover into a `QuasicoherentData` witnessing
`SheafOfModules.IsFinitePresentation`. -/
theorem isFinitePresentation_of_finite_sections
    [IsLocallyNoetherian Y] (N : Y.Modules) [N.IsQuasicoherent]
    (hfin : ∀ V : Y.Opens, IsAffineOpen V → Module.Finite Γ(Y, V) Γ(N, V)) :
    N.IsFinitePresentation := by
  have h := fun V : Y.affineOpens =>
    exists_finite_presentation_over_of_finite_sections N hfin V.2
  choose P hP using h
  let q : N.QuasicoherentData :=
    { I := Y.affineOpens
      X := fun V => V.1
      coversTop := by
        intro W y hy
        obtain ⟨V, hVaff, hyV, hVW⟩ :=
          TopologicalSpace.Opens.isBasis_iff_nbhd.mp (Scheme.isBasis_affineOpens Y) hy
        refine ⟨V, homOfLE hVW, ?_, hyV⟩
        rw [CategoryTheory.Sieve.mem_ofObjects_iff]
        exact ⟨⟨V, hVaff⟩, ⟨𝟙 V⟩⟩
      presentation := P }
  have hsh : q.shrink.IsFinitePresentation := by
    apply SheafOfModules.QuasicoherentData.IsFinitePresentation.mk
    intro i
    exact hP _
  exact { exists_quasicoherentData := ⟨q.shrink, hsh⟩ }

end Scheme.Modules

/-! ## §3. `hfp` — the finite pushforward of a line bundle is finitely presented -/

namespace Adelic

open Scheme

variable {k : Type u} [Field k]
variable (A : Type u) [CommRing A] [Algebra k A]
variable (C : Over (Spec (CommRingCat.of k)))

set_option maxHeartbeats 800000 in
-- Heartbeat headroom for the pullback/pushforward instance synthesis on the
-- base-changed projective line, as elsewhere in the B3 lane.
set_option synthInstance.maxHeartbeats 400000 in
/-- **`hfp` for the B3 reduction (Stacks 01XZ/087T flavour): the finite
pushforward of an invertible module is finitely presented.**  For the
finite map `π_A : C_A ⟶ ℙ¹_A` (base change of the gate's finite
`C ⟶ ℙ¹`) and an invertible `L` on `C_A`, the pushforward `(π_A)_* L` is a
finitely presented module on `ℙ¹_A`, for every finitely generated
`k`-algebra `A`:

* `(π_A)_* L` is quasi-coherent (Stacks 01XJ, `pushforward_isQuasicoherent`;
  `π_A` is finite, hence affine, hence qcqs);
* `ℙ¹_A` is locally noetherian (`A` is noetherian by Hilbert basis, and
  `ℙ¹_A ⟶ Spec A` is locally of finite type as a base change of the proper
  `ℙ¹_k ⟶ Spec k`);
* over an affine `V ⊆ ℙ¹_A` the sections are `Γ(L, π_A⁻¹ V)`
  (definitionally), finite over `Γ(C_A, π_A⁻¹ V)` by Stacks 01PC
  (`finite_sections_preimage_of_isAffineHom`, using that `L` is finitely
  presented since locally trivial) and hence finite over `Γ(ℙ¹_A, V)` since
  `π_A` is module-finite on affines (Stacks 01WG, `IsFinite.finite_app`);

so the noetherian coherence criterion
(`isFinitePresentation_of_finite_sections`) applies.  This discharges the
`hfp` hypothesis of `rigidPushforwardLocallyFree_of_p1`. -/
theorem pushforward_finiteMapToP1BaseChange_isFinitePresentation
    [Algebra.FiniteType k A] [HasFiniteMapToP1 C]
    (L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L) :
    ((Scheme.Modules.pushforward (finiteMapToP1BaseChange A C)).obj L).IsFinitePresentation := by
  haveI := hL.isFinitePresentation
  haveI : IsFinite (finiteMapToP1BaseChange A C) := isFinite_finiteMapToP1BaseChange A C
  haveI := Scheme.Modules.pushforward_isQuasicoherent (finiteMapToP1BaseChange A C) L
  -- `ℙ¹_A` is locally noetherian
  haveI : IsNoetherianRing A := Algebra.FiniteType.isNoetherianRing k A
  haveI : IsLocallyNoetherian (Spec (CommRingCat.of A)) := inferInstance
  haveI : LocallyOfFiniteType (p1Over k).hom :=
    inferInstanceAs (LocallyOfFiniteType
      ((ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k))) ↘ Spec (CommRingCat.of k)))
  haveI : LocallyOfFiniteType
      (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) :=
    MorphismProperty.pullback_snd _ _ ‹_›
  haveI : IsLocallyNoetherian
      (Limits.pullback (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) :=
    LocallyOfFiniteType.isLocallyNoetherian
      (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
  -- finite sections on affines, then the coherence criterion
  apply Scheme.Modules.isFinitePresentation_of_finite_sections
  intro V hV
  letI : Algebra Γ(Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A))), V)
      Γ(Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))),
        finiteMapToP1BaseChange A C ⁻¹ᵁ V) :=
    ((finiteMapToP1BaseChange A C).app V).hom.toAlgebra
  haveI h1 : Module.Finite
      Γ(Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A))), V)
      Γ(Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))),
        finiteMapToP1BaseChange A C ⁻¹ᵁ V) :=
    (finiteMapToP1BaseChange A C).finite_app V hV
  haveI h2 : Module.Finite
      Γ(Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))),
        finiteMapToP1BaseChange A C ⁻¹ᵁ V)
      Γ(L, finiteMapToP1BaseChange A C ⁻¹ᵁ V) :=
    Scheme.Modules.finite_sections_preimage_of_isAffineHom
      (finiteMapToP1BaseChange A C) L hV
  letI : Module Γ(Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A))), V)
      Γ(L, finiteMapToP1BaseChange A C ⁻¹ᵁ V) :=
    Module.compHom _ ((finiteMapToP1BaseChange A C).app V).hom
  haveI : IsScalarTower
      Γ(Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A))), V)
      Γ(Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))),
        finiteMapToP1BaseChange A C ⁻¹ᵁ V)
      Γ(L, finiteMapToP1BaseChange A C ⁻¹ᵁ V) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  have : Module.Finite
      Γ(Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A))), V)
      Γ(L, finiteMapToP1BaseChange A C ⁻¹ᵁ V) :=
    Module.Finite.trans
      Γ(Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))),
        finiteMapToP1BaseChange A C ⁻¹ᵁ V)
      Γ(L, finiteMapToP1BaseChange A C ⁻¹ᵁ V)
  exact this

end Adelic

/-! ## §4. `hflat` — coherent-sheaf flatness of the finite pushforward -/

namespace Scheme

/-- **Coherent-sheaf flatness of an invertible module over an affine base
along a flat family.**  For a flat morphism `q : Y ⟶ T` with affine target
and a locally trivial (invertible) `L` on `Y`, the module `L` is flat over
`T` in the sense of `CoherentSheafFlat`: on a trivialising affine chart `W`
the sections `Γ(L, W)` form an invertible, hence flat, `Γ(Y, W)`-module
(`isInvertible_of_restrict_iso`), which is flat over `Γ(T, ⊤)` since `q` is
a flat morphism (`Flat.flat_appLE` + `Module.Flat.trans`); chart flatness
globalises to every affine pair by the affine-locality engine
`flat_section_of_affine_cover`. -/
theorem coherentSheafFlat_of_isLocallyTrivial_of_flat {T Y : Scheme.{u}} [IsAffine T]
    (q : Y ⟶ T) [AlgebraicGeometry.Flat q] {L : Y.Modules}
    (hL : Scheme.LineBundle.IsLocallyTrivial L) :
    Scheme.CoherentSheafFlat q L := by
  haveI := hL.isFinitePresentation
  choose W hxW hWaff hWtriv using hL
  have heW : ∀ y : Y, W y ≤ q ⁻¹ᵁ (⊤ : T.Opens) := by
    intro y
    rw [Scheme.Hom.preimage_top]
    exact le_top
  intro U hU V hV e
  refine flat_section_of_affine_cover q L W hWaff (fun _ => (⊤ : T.Opens))
    (fun _ => isAffineOpen_top T) heW (fun y => ⟨y, hxW y⟩) ?_ hU hV e
  intro y
  letI : Module Γ(T, ⊤) Γ(L, W y) :=
    Module.compHom _ (q.appLE ⊤ (W y) (heW y)).hom
  letI : Algebra Γ(T, ⊤) Γ(Y, W y) := (q.appLE ⊤ (W y) (heW y)).hom.toAlgebra
  haveI hflat1 : Module.Flat Γ(T, ⊤) Γ(Y, W y) :=
    q.flat_appLE (isAffineOpen_top T) (hWaff y) (heW y)
  haveI : Module.Invertible Γ(Y, W y) Γ(L, W y) :=
    Scheme.LineBundle.isInvertible_of_restrict_iso (W y) (hWtriv y).some
  haveI : IsScalarTower Γ(T, ⊤) Γ(Y, W y) Γ(L, W y) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  exact Module.Flat.trans Γ(T, ⊤) Γ(Y, W y) Γ(L, W y)

/-- **Coherent-sheaf flatness transfers along an affine pushforward.**  For
an affine `π : X ⟶ Y` over `p : Y ⟶ T`, flatness of `F` over `T` (via the
composite `π ≫ p`) gives flatness of `π_* F` over `T` (via `p`): the
sections of `π_* F` over an affine `V` are `Γ(F, π⁻¹ V)` definitionally
(with `π⁻¹ V` affine since `π` is), and the two `Γ(T, U)`-module structures
agree because `(π ≫ p).appLE = p.appLE ≫ π.appLE`
(`Scheme.Hom.appLE_comp_appLE`). -/
theorem CoherentSheafFlat.pushforward_of_isAffineHom {X Y T : Scheme.{u}}
    (π : X ⟶ Y) [IsAffineHom π] (p : Y ⟶ T) (F : X.Modules)
    (h : Scheme.CoherentSheafFlat (π ≫ p) F) :
    Scheme.CoherentSheafFlat p ((Scheme.Modules.pushforward π).obj F) := by
  intro U hU V hV e
  have hpre : IsAffineOpen (π ⁻¹ᵁ V) := hV.preimage π
  have epre : π ⁻¹ᵁ V ≤ (π ≫ p) ⁻¹ᵁ U := by
    rw [Scheme.Hom.comp_preimage]
    intro x hx
    exact e hx
  have base := h hU hpre epre
  -- identify the two ring homomorphisms `Γ(T, U) → Γ(X, π ⁻¹ᵁ V)`
  have hφ : ((π ≫ p).appLE U (π ⁻¹ᵁ V) epre).hom =
      ((π.app V).hom).comp ((p.appLE U V e).hom) := by
    have h1 := Scheme.Hom.appLE_comp_appLE π p U V (π ⁻¹ᵁ V) e le_rfl
    refine RingHom.ext fun r => ?_
    have h2 := congrArg (fun (φ : Γ(T, U) ⟶ Γ(X, π ⁻¹ᵁ V)) => φ.hom r) h1
    simp only [CommRingCat.hom_comp, RingHom.comp_apply] at h2
    rw [RingHom.comp_apply, Scheme.Hom.app_eq_appLE]
    exact h2.symm
  -- both module structures are `compHom`s of the canonical one, along
  -- pointwise-equal ring homomorphisms
  rw [hφ] at base
  exact base

end Scheme

namespace Adelic

open Scheme

variable {k : Type u} [Field k]
variable (A : Type u) [CommRing A] [Algebra k A]
variable (C : Over (Spec (CommRingCat.of k)))

/-- **`hflat` for the B3 reduction (mixed-base flat stability): the finite
pushforward `(π_A)_* L` stays flat over `Spec A`.**  Since
`Γ((π_A)_* L, V) = Γ(L, π_A⁻¹ V)` definitionally and `q = π_A ≫ p`
(`finiteMapToP1BaseChange_snd`), this reduces to `CoherentSheafFlat q L`
for the invertible `L` on the family `q : C_A ⟶ Spec A`, which is a flat
morphism as the base change of `C ⟶ Spec k` (everything over the one-point
integral `Spec k` is flat).  This discharges the `hflat` hypothesis of
`rigidPushforwardLocallyFree_of_p1`; no finiteness of `A` is needed. -/
theorem pushforward_finiteMapToP1BaseChange_coherentSheafFlat
    [HasFiniteMapToP1 C]
    (L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L) :
    Scheme.CoherentSheafFlat
      (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
      ((Scheme.Modules.pushforward (finiteMapToP1BaseChange A C)).obj L) := by
  haveI : Subsingleton ↥(Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  haveI : AlgebraicGeometry.Flat C.hom := inferInstance
  haveI : AlgebraicGeometry.Flat
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) :=
    inferInstance
  haveI : IsFinite (finiteMapToP1BaseChange A C) := isFinite_finiteMapToP1BaseChange A C
  have hq : Scheme.CoherentSheafFlat
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) L :=
    Scheme.coherentSheafFlat_of_isLocallyTrivial_of_flat _ hL
  have hq' : Scheme.CoherentSheafFlat
      (finiteMapToP1BaseChange A C ≫
        pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) L := by
    rw [finiteMapToP1BaseChange_snd]
    exact hq
  intro U hU V hV e
  exact Scheme.CoherentSheafFlat.pushforward_of_isAffineHom
    (finiteMapToP1BaseChange A C)
    (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
    L hq' hU hV e

end Adelic

/-! ## §5. Substrate for `hH1`/`hH0` — the fibre square of the finite map
and the definitional Čech bridges

Item (c) of the transfer package identifies `(π_A)_* L` restricted to the
fibre `ℙ¹_t` with `(π_t)_* (L_t)` and transports the Čech difference map
across it.  This section lands the geometric substrate: the induced finite
map `π_t : C_t ⟶ ℙ¹_t` between the scheme-theoretic fibres, its cartesian
square over `π_A`, and the two *definitional* Čech bridges — the difference
map of a 2-affine cover for an (affine) pushforward literally *is* the
difference map of the preimage cover, and surjectivity of the difference
map transports across isomorphisms of module sheaves.  What remains for
`hH1`/`hH0` (next session) is the affine-morphism base-change isomorphism
`(p.fiberι t)^* (π_A)_* L ≅ (π_t)_* (q.fiberι t)^* L` (Stacks 02KG for the
affine `π_A`; `κ(t)` is *not* flat over `A`, so this is the
glued form of `affinePushforwardPullbackBaseChange`), plus — for `hH1` —
the Čech-to-Čech cover-independence of `Ȟ¹`-vanishing on the fibre curve,
which is the recorded P2-interface TODO of `RigidPushforward.lean`. -/

namespace Scheme

/-- **The Čech difference map of an affine pushforward is the difference map
of the preimage cover** — definitionally: sections, intersections of
preimages, and restriction maps of `f_* M` over a 2-affine cover `V` all
agree with those of `M` over `V.preimage f`. -/
lemma AffineCoverMVSquare.moduleSectionDiff_pushforward {X Y : Scheme.{u}}
    (f : X ⟶ Y) [IsAffineHom f] (V : Y.AffineCoverMVSquare) (M : X.Modules) :
    V.moduleSectionDiff ((Scheme.Modules.pushforward f).obj M) =
      (V.preimage f).moduleSectionDiff M :=
  rfl

/-- **Naturality of the Čech difference map** in the module: a morphism of
module sheaves intertwines the difference maps of a 2-affine cover. -/
lemma AffineCoverMVSquare.moduleSectionDiff_naturality {X : Scheme.{u}}
    (V : X.AffineCoverMVSquare) {G G' : X.Modules} (φ : G ⟶ G')
    (a : Γ(G, V.U₁)) (b : Γ(G, V.U₂)) :
    V.moduleSectionDiff G' (φ.app V.U₁ a, φ.app V.U₂ b) =
      φ.app (V.U₁ ⊓ V.U₂) (V.moduleSectionDiff G (a, b)) := by
  have h₁ := congrArg (fun (ψ : Γ(G, V.U₁) ⟶ Γ(G', V.U₁ ⊓ V.U₂)) => ψ.hom a)
    (φ.mapPresheaf.naturality (homOfLE (inf_le_left : V.U₁ ⊓ V.U₂ ≤ V.U₁)).op)
  have h₂ := congrArg (fun (ψ : Γ(G, V.U₂) ⟶ Γ(G', V.U₁ ⊓ V.U₂)) => ψ.hom b)
    (φ.mapPresheaf.naturality (homOfLE (inf_le_right : V.U₁ ⊓ V.U₂ ≤ V.U₂)).op)
  simp only [AddCommGrpCat.hom_comp, AddMonoidHom.comp_apply] at h₁ h₂
  simp only [moduleSectionDiff_apply, map_sub]
  exact congrArg₂ Sub.sub h₁.symm h₂.symm

/-- **Surjectivity of the Čech difference map transports across an
isomorphism of module sheaves.** -/
lemma AffineCoverMVSquare.surjective_moduleSectionDiff_of_iso {X : Scheme.{u}}
    (V : X.AffineCoverMVSquare) {G G' : X.Modules} (e : G ≅ G')
    (h : Function.Surjective ⇑(V.moduleSectionDiff G)) :
    Function.Surjective ⇑(V.moduleSectionDiff G') := by
  intro c
  obtain ⟨⟨a, b⟩, hab⟩ := h (e.inv.app (V.U₁ ⊓ V.U₂) c)
  refine ⟨(e.hom.app V.U₁ a, e.hom.app V.U₂ b), ?_⟩
  rw [V.moduleSectionDiff_naturality e.hom a b, hab]
  change ((e.inv ≫ e.hom).app (V.U₁ ⊓ V.U₂)).hom c = c
  rw [e.inv_hom_id]
  rfl

end Scheme

namespace Adelic

open Scheme

variable {k : Type u} [Field k]
variable (A : Type u) [CommRing A] [Algebra k A]
variable (C : Over (Spec (CommRingCat.of k)))

/-- **The induced map on scheme-theoretic fibres of the finite
`π_A : C_A ⟶ ℙ¹_A`**: for `t : Spec A`, the map `π_t : C_t ⟶ ℙ¹_t` from the
fibre of `q = pullback.snd : C_A ⟶ Spec A` to the fibre of
`p = pullback.snd : ℙ¹_A ⟶ Spec A`, induced by functoriality of the fibre
square (`q = π_A ≫ p`, `finiteMapToP1BaseChange_snd`). -/
noncomputable def finiteMapToP1FiberMap [HasFiniteMapToP1 C]
    (t : Spec (CommRingCat.of A)) :
    (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiber t ⟶
      (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiber t :=
  pullback.map _ _ _ _ (finiteMapToP1BaseChange A C) (𝟙 _) (𝟙 _)
    (by rw [Category.comp_id]; exact (finiteMapToP1BaseChange_snd A C).symm)
    (by simp)

/-- `π_t` lies over `π_A`: the fibre square of `π_t` against the fibre
embeddings commutes. -/
@[reassoc (attr := simp)]
lemma finiteMapToP1FiberMap_fiberι [HasFiniteMapToP1 C]
    (t : Spec (CommRingCat.of A)) :
    finiteMapToP1FiberMap A C t ≫
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberι t =
      (pullback.snd C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberι t ≫
        finiteMapToP1BaseChange A C :=
  pullback.lift_fst _ _ _

/-- `π_t` is a map of `κ(t)`-schemes: it commutes with the structural maps
to `Spec κ(t)`. -/
@[reassoc (attr := simp)]
lemma finiteMapToP1FiberMap_toSpecResidueField [HasFiniteMapToP1 C]
    (t : Spec (CommRingCat.of A)) :
    finiteMapToP1FiberMap A C t ≫
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberToSpecResidueField t =
      (pullback.snd C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberToSpecResidueField t :=
  (pullback.lift_snd _ _ _).trans (Category.comp_id _)

/-- **The fibre square of the finite map is cartesian**: `C_t = C_A ×_{ℙ¹_A} ℙ¹_t`
(pasting of the two fibre squares over `Spec κ(t) ⟶ Spec A`).  This exhibits
`π_t` as the base change of the finite `π_A` along `ℙ¹_t ⟶ ℙ¹_A`. -/
lemma isPullback_finiteMapToP1FiberMap [HasFiniteMapToP1 C]
    (t : Spec (CommRingCat.of A)) :
    IsPullback
      ((pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberι t)
      (finiteMapToP1FiberMap A C t)
      (finiteMapToP1BaseChange A C)
      ((pullback.snd (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberι t) := by
  have hs : IsPullback
      ((pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberι t)
      (finiteMapToP1FiberMap A C t ≫
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberToSpecResidueField t)
      (finiteMapToP1BaseChange A C ≫
        pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
      ((Spec (CommRingCat.of A)).fromSpecResidueField t) := by
    rw [finiteMapToP1FiberMap_toSpecResidueField, finiteMapToP1BaseChange_snd]
    exact IsPullback.of_hasPullback _ _
  exact IsPullback.of_bot hs (finiteMapToP1FiberMap_fiberι A C t).symm
    (IsPullback.of_hasPullback _ _)

/-- **`π_t` is finite** — base change of the finite `π_A` along the fibre
embedding `ℙ¹_t ⟶ ℙ¹_A` (`isPullback_finiteMapToP1FiberMap`). -/
instance isFinite_finiteMapToP1FiberMap [HasFiniteMapToP1 C]
    (t : Spec (CommRingCat.of A)) :
    IsFinite (finiteMapToP1FiberMap A C t) :=
  MorphismProperty.IsStableUnderBaseChange.of_isPullback (P := @IsFinite)
    (isPullback_finiteMapToP1FiberMap A C t)
    (isFinite_finiteMapToP1BaseChange A C)

end Adelic

end AlgebraicGeometry
