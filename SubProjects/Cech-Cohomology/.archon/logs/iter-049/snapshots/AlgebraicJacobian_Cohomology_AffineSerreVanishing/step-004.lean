/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechToCohomology
import AlgebraicJacobian.Cohomology.QcohTildeSections

/-!
# Serre vanishing on affines (Stacks 02KG) — affine cover-system infrastructure

Project-local: builds the *affine cover system* feeding the basis-comparison criterion
`cech_eq_cohomology_of_basis` (01EO). The basis `B` is the distinguished opens `D(f)`
of an affine scheme, and the admissible coverings `Cov` are the standard open covers.

This file builds the cover-system infrastructure (Lane 1 of the 02KG decomposition) as far
as possible; the quasi-coherent seed `affine_cech_vanishing_qcoh` and the top
`affine_serre_vanishing` are handed off to the assembly iteration (they consume Lane 2's
`qcoh_iso_tilde_sections`).
-/

universe u

open CategoryTheory Limits TopologicalSpace CategoryTheory.Abelian

namespace AlgebraicGeometry

variable {X : Scheme.{u}}

/-! ## Project-local Mathlib supplement — distinguished opens closed under finite intersection -/

/-- **Distinguished opens are closed under finite intersection** (Stacks 02KG, condition (1)).
For a family `s : ι → R` of ring elements and a Čech multi-index `σ : Fin (p + 1) → ι`, the
`(p + 1)`-fold intersection of distinguished opens `⨅ₖ D(s_{σ k})` is again a distinguished
open, namely `D(∏ₖ s_{σ k})`; hence it lies in the basis of distinguished opens. This discharges
the `faces_mem` field of the affine cover system. Project-local: re-export of `basicOpen_sprod`
in the membership shape the `BasisCovSystem.faces_mem` field consumes. -/
theorem affine_faces_mem {R : CommRingCat.{u}} {ι : Type u} (s : ι → R)
    {p : ℕ} (σ : Fin (p + 1) → ι) :
    (⨅ k, PrimeSpectrum.basicOpen (s (σ k)) : (Spec R).Opens)
      ∈ Set.range (fun f : R => (PrimeSpectrum.basicOpen f : (Spec R).Opens)) :=
  ⟨∏ k, s (σ k), (basicOpen_sprod (p + 1) s σ).symm⟩

/-! ## Project-local Mathlib supplement — covering-datum bridge to the open-cover Čech form -/

/-- **The standard affine open cover realizes the distinguished-open family.** For a spanning
family `s : ι → R`, the `i`-th member of the standard affine open cover
`affineOpenCoverOfSpanRangeEqTop s hs` of `Spec R` has open range exactly the distinguished open
`D(s_i)`, i.e. `coverOpen 𝒰 i = PrimeSpectrum.basicOpen (s i)`. This is the open-level half of the
covering-datum bridge (`lem:cover_datum_bridge`): funext-rewriting the raw family `c.2 = fun i ↦
D(s_i)` to `coverOpen 𝒰` identifies the two section Čech complexes, so the Čech cohomology computed
over the raw `CovDatum` and over the `X.OpenCover` agree. Project-local: needed to feed the
`X.OpenCover`-shaped `injective_cech_acyclic` into the raw-family `BasisCovSystem` fields. -/
theorem coverOpen_affineOpenCoverOfSpan {R : CommRingCat.{u}} {ι : Type u} [Finite ι]
    (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤) (i : ι) :
    coverOpen (Scheme.AffineOpenCover.openCover (Scheme.affineOpenCoverOfSpanRangeEqTop s hs)) i
      = PrimeSpectrum.basicOpen (s i) := by
  unfold coverOpen
  change (Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away (s i))))).opensRange = _
  apply TopologicalSpace.Opens.ext
  change Set.range (Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away (s i))))).base = _
  rw [Spec.map_base]
  exact PrimeSpectrum.localization_away_comap_range (Localization.Away (s i)) (s i)

/-! ## Project-local Mathlib supplement — injective acyclicity for the standard affine cover -/

/-- **Injective Čech-acyclicity for the standard affine cover** (Stacks 02KG, `injective_acyclic`
field; Stacks `lemma-injective-trivial-cech`). For a spanning family `s : ι → R` (so the
distinguished opens `D(s_i)` cover `Spec R`) and an injective `O_X`-module `I`, the positive-degree
section Čech cohomology over the standard cover vanishes:
`Ȟ^q(𝒰, I) = 0` for all `q > 0`. Reduces the raw-family `cechCohomology` to the `X.OpenCover` form
via `coverOpen_affineOpenCoverOfSpan` and applies `injective_cech_acyclic`. Project-local: this is
the affine instantiation of `injective_cech_acyclic` discharging the
`BasisCovSystem.injective_acyclic` field for standard covers of the whole affine. -/
theorem affine_injective_acyclic {R : CommRingCat.{u}} {ι : Type u} [Finite ι]
    (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤)
    (I : (Spec R).Modules) [Injective I] (q : ℕ) (hq : 0 < q) :
    IsZero (cechCohomology (fun i => PrimeSpectrum.basicOpen (s i))
      ((Scheme.Modules.toPresheafOfModules (Spec R)).obj I) q) := by
  have hbridge : (fun i => PrimeSpectrum.basicOpen (s i))
      = coverOpen (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover := by
    funext i; exact (coverOpen_affineOpenCoverOfSpan s hs i).symm
  haveI : Finite (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover.I₀ :=
    inferInstanceAs (Finite ι)
  rw [cechCohomology, hbridge]
  exact injective_cech_acyclic (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover I q hq

/-! ## Project-local Mathlib supplement — the underlying-abelian-sheaf functor preserves colimits

The gap-fill `toSheaf_preservesFiniteColimits` / `toSheaf_preservesEpimorphisms` (blueprint
`lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`) — the statement that
`SheafOfModules.toSheaf R` (the forgetful functor to abelian sheaves) preserves finite colimits,
hence epimorphisms — is the foundational ingredient for `affine_surj_of_vanishing` (and hence for
the `surj_of_vanishing` field of `affineCoverSystem`).  Mathlib provides only the limit-side dual
`PreservesFiniteLimits (toSheaf R)` (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Limits`); the
colimit side is genuinely absent because epis of sheaves of modules are only *locally* surjective
and no factorisation through the right adjoint `forget` can capture it.

The build below mirrors Mathlib's `…/ModuleCat/Sheaf/Colimits.lean` construction but routes through
the **sheafification square** `PresheafOfModules.sheafificationCompToSheaf (𝟙 R.obj)` (not through
`forget`).  Write `L := PresheafOfModules.sheafification (𝟙 R.obj)`, a left adjoint (counit iso).
Step 1: `L ⋙ toSheaf R ≅ toPresheaf R.obj ⋙ presheafToSheaf J Ab` (the square), and the right-hand
composite preserves finite colimits (`toPresheaf` does objectwise; `presheafToSheaf` is a left
adjoint).  Step 2 (descent): for a finite diagram `F`, `F ≅ (F ⋙ forget R) ⋙ L`; applying the
colimit-preserving `L` and then `L ⋙ toSheaf R` to a colimit cocone of `F ⋙ forget R` exhibits
`toSheaf R` as preserving the colimit of `F`.  Epi-preservation follows from `WalkingSpan` being
finite. -/

/-- **The underlying-abelian-sheaf functor preserves finite colimits** (blueprint
`lem:toSheaf_preservesFiniteColimits`).  The forgetful functor `SheafOfModules.toSheaf R` from
sheaves of `R`-modules to the underlying sheaves of abelian groups preserves finite colimits — the
right-exact dual of the Mathlib-supplied `PreservesFiniteLimits (toSheaf R)`.  Project-local: the
missing colimit side, built through the sheafification square (never through the right adjoint
`forget`). -/
theorem toSheaf_preservesFiniteColimits.{v', u', w'} {C : Type u'} [Category.{w'} C]
    {J : GrothendieckTopology C} (R : Sheaf J RingCat.{v'})
    [HasWeakSheafify J AddCommGrpCat.{v'}] [J.WEqualsLocallyBijective AddCommGrpCat.{v'}] :
    PreservesFiniteColimits (SheafOfModules.toSheaf.{v'} R) := by
  have step1 : PreservesFiniteColimits
      (PresheafOfModules.sheafification (𝟙 R.obj) ⋙ SheafOfModules.toSheaf.{v'} R) :=
    preservesFiniteColimits_of_natIso
      (PresheafOfModules.sheafificationCompToSheaf (𝟙 R.obj)).symm
  haveI : PreservesColimitsOfSize (PresheafOfModules.sheafification.{v'} (𝟙 R.obj)) :=
    (PresheafOfModules.sheafificationAdjunction (𝟙 R.obj)).leftAdjoint_preservesColimits
  constructor
  intro K _ _
  constructor
  intro F
  set D := F ⋙ SheafOfModules.forget R with hD
  have e : F ≅ D ⋙ PresheafOfModules.sheafification (𝟙 R.obj) :=
    Functor.isoWhiskerLeft F
      (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 R.obj)).counit).symm
  have hc : IsColimit (colimit.cocone D) := colimit.isColimit D
  have hLc := isColimitOfPreserves (PresheafOfModules.sheafification (𝟙 R.obj)) hc
  have hF := isColimitOfPreserves
    (PresheafOfModules.sheafification (𝟙 R.obj) ⋙ SheafOfModules.toSheaf R) hc
  haveI hpres : PreservesColimit (D ⋙ PresheafOfModules.sheafification (𝟙 R.obj))
      (SheafOfModules.toSheaf R) :=
    preservesColimit_of_preserves_colimit_cocone hLc hF
  exact preservesColimit_of_iso_diagram (SheafOfModules.toSheaf R) e.symm

/-- **The underlying-abelian-sheaf functor preserves epimorphisms** (blueprint
`lem:to_sheaf_preserves_epi`).  A one-line corollary of `toSheaf_preservesFiniteColimits`:
finite-colimit preservation implies preservation of pushouts (`WalkingSpan`), hence of
epimorphisms.  This is the instance unlocking the passage from a module epimorphism to local
surjectivity in `affine_surj_of_vanishing`. -/
theorem toSheaf_preservesEpimorphisms.{v', u', w'} {C : Type u'} [Category.{w'} C]
    {J : GrothendieckTopology C} (R : Sheaf J RingCat.{v'})
    [HasWeakSheafify J AddCommGrpCat.{v'}] [J.WEqualsLocallyBijective AddCommGrpCat.{v'}] :
    (SheafOfModules.toSheaf.{v'} R).PreservesEpimorphisms := by
  haveI : PreservesColimitsOfShape WalkingSpan (SheafOfModules.toSheaf.{v'} R) :=
    (toSheaf_preservesFiniteColimits R).preservesFiniteColimits WalkingSpan
  exact preservesEpimorphisms_of_preservesColimitsOfShape _

/-! ## Project-local Mathlib supplement — standard covers are cofinal -/

/-- **Standard covers are cofinal among open covers of a distinguished open** (Stacks 02KG, Tag
009L; blueprint `lem:standard_cover_cofinal`).  Given a distinguished open `D(f)` of `Spec R` and an
arbitrary open cover `W : α → (Spec R).Opens` of it, there is a finite standard subcover refining
it: finitely many `g : Fin n → R` with `D(f) = ⨆ᵢ D(gᵢ)` and each `D(gᵢ) ≤ W (φ i)`.  This is the
refinement step invoked in `affine_surj_of_vanishing`.  Project-local: combines quasi-compactness of
`D(f)` with the basic-open basis. -/
theorem standard_cover_cofinal {R : CommRingCat.{u}} (f : R) {α : Type u}
    (W : α → (Spec R).Opens)
    (hcov : (PrimeSpectrum.basicOpen f : (Spec R).Opens) ≤ ⨆ a, W a) :
    ∃ (n : ℕ) (g : Fin n → R) (φ : Fin n → α),
      (PrimeSpectrum.basicOpen f : (Spec R).Opens) = ⨆ i, PrimeSpectrum.basicOpen (g i) ∧
      ∀ i, (PrimeSpectrum.basicOpen (g i) : (Spec R).Opens) ≤ W (φ i) := by
  classical
  set Uf : (Spec R).Opens := PrimeSpectrum.basicOpen f with hUf
  have hK : IsCompact (Uf : Set ↥(Spec R)) := PrimeSpectrum.isCompact_basicOpen f
  have hbasis := PrimeSpectrum.isTopologicalBasis_basic_opens (R := R)
  -- `B r` is the distinguished open `D(r)` typed as an open of `Spec R`.
  let B : R → (Spec R).Opens := fun r => PrimeSpectrum.basicOpen r
  -- Index type: basic opens contained in `Uf ⊓ W a`, carrying the witness `a`.
  let I := {p : R × α // B p.1 ≤ Uf ⊓ W p.2}
  let cover : I → Set ↥(Spec R) := fun p => (B p.1.1 : Set ↥(Spec R))
  have hopen : ∀ i, IsOpen (cover i) := fun i => (B i.1.1).isOpen
  -- The chosen basic opens cover `Uf`.
  have hsub : (Uf : Set ↥(Spec R)) ⊆ ⋃ i, cover i := by
    intro x hx
    have hxUf : x ∈ Uf := hx
    obtain ⟨a, hxa⟩ := TopologicalSpace.Opens.mem_iSup.mp (hcov hxUf)
    have hxinf : x ∈ ((Uf ⊓ W a : (Spec R).Opens) : Set ↥(Spec R)) := by
      rw [TopologicalSpace.Opens.coe_inf]
      exact ⟨hxUf, hxa⟩
    obtain ⟨v, hvrange, hxv, hvsub⟩ :=
      hbasis.exists_subset_of_mem_open hxinf (Uf ⊓ W a).isOpen
    obtain ⟨r, hr⟩ := hvrange
    have hr' : (B r : Set ↥(Spec R)) = v := hr
    have hle : B r ≤ Uf ⊓ W a := by
      rw [← SetLike.coe_subset_coe, hr']; exact hvsub
    refine Set.mem_iUnion.mpr ⟨⟨(r, a), hle⟩, ?_⟩
    change x ∈ (B r : Set ↥(Spec R))
    rw [hr']; exact hxv
  -- Quasi-compactness: extract a finite subcover.
  obtain ⟨t, ht⟩ := hK.elim_finite_subcover cover hopen hsub
  -- Repackage the finite index set `t : Finset I` as `Fin n`.
  let e := t.equivFin
  refine ⟨t.card, fun i => (e.symm i).1.1.1, fun i => (e.symm i).1.1.2, ?_, ?_⟩
  · apply le_antisymm
    · intro x hx
      obtain ⟨i, hit, hxi⟩ := Set.mem_iUnion₂.mp (ht hx)
      rw [TopologicalSpace.Opens.mem_iSup]
      refine ⟨e ⟨i, hit⟩, ?_⟩
      change x ∈ B (e.symm (e ⟨i, hit⟩)).1.1.1
      rw [Equiv.symm_apply_apply]; exact hxi
    · rw [iSup_le_iff]
      intro i
      exact le_trans (e.symm i).1.2 inf_le_left
  · intro i
    exact le_trans (e.symm i).1.2 inf_le_right

/-! ## Project-local Mathlib supplement — section surjectivity for the affine cover system -/

set_option maxHeartbeats 1600000 in
/-- **Section surjectivity for the affine cover system** (Stacks 02KG, `surj_of_vanishing` field;
Stacks `lemma-ses-cech-h1`). Let `S : 0 → S₁ → S₂ → S₃ → 0` be a short exact sequence of
`O_X`-modules on `Spec R` whose left term `S₁` has vanishing positive Čech cohomology over every
standard cover `i ↦ D(gᵢ)` (`hvanish`). Then the section map `S₂(D f) → S₃(D f)` is surjective over
every distinguished open `D f`. This discharges the `surj_of_vanishing` field of `affineCoverSystem`.

Proof: `S.g` is an epi of `O_X`-modules, so (via `toSheaf_preservesEpimorphisms` + the sheaf
local-surjectivity criterion) the underlying map of abelian presheaves is locally surjective. A
section `t ∈ S₃(D f)` therefore lifts locally on an open cover of `D f`; refine it to a standard
cover `D(gᵢ)` (`standard_cover_cofinal`) carrying local lifts, feed the cover, the lifts and the
vanishing `Ȟ¹(𝒰, S₁) = 0` to the Čech `Ȟ¹`-surjectivity criterion `ses_cech_h1`, and glue to a
global lift. Project-local: the affine instantiation of the `ses_cech_h1` criterion. -/
theorem affine_surj_of_vanishing {R : CommRingCat.{u}}
    (S : ShortComplex (Spec R).Modules) (hS : S.ShortExact)
    (hvanish : ∀ (n : ℕ) (g : Fin n → R) (f' : R),
      (PrimeSpectrum.basicOpen f' : (Spec R).Opens)
        = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) →
      ∀ (q : ℕ), 0 < q →
        IsZero (cechCohomology (fun i : ULift.{u} (Fin n) => PrimeSpectrum.basicOpen (g i.down))
          ((Scheme.Modules.toPresheafOfModules (Spec R)).obj S.X₁) q))
    (f : R) :
    Function.Surjective (ConcreteCategory.hom
      (((PresheafOfModules.toPresheaf (Spec R).ringCatSheaf.obj).map
        ((Scheme.Modules.toPresheafOfModules (Spec R)).map S.g)).app
          (Opposite.op (PrimeSpectrum.basicOpen f)))) := by
  classical
  set V₀ : (Spec R).Opens := PrimeSpectrum.basicOpen f with hV₀
  set FX := (Scheme.Modules.toPresheafOfModules (Spec R)).obj S.X₁ with hFX
  set GX := (Scheme.Modules.toPresheafOfModules (Spec R)).obj S.X₂ with hGX
  set HX := (Scheme.Modules.toPresheafOfModules (Spec R)).obj S.X₃ with hHX
  set fι := (PresheafOfModules.toPresheaf (Spec R).ringCatSheaf.obj).map
    ((Scheme.Modules.toPresheafOfModules (Spec R)).map S.f) with hfι
  set gπ := (PresheafOfModules.toPresheaf (Spec R).ringCatSheaf.obj).map
    ((Scheme.Modules.toPresheafOfModules (Spec R)).map S.g) with hgπ
  -- Step 1: a module epi becomes a locally surjective map of abelian presheaves.
  haveI hgepi : Epi S.g := hS.epi_g
  have hepiTS : Epi ((SheafOfModules.toSheaf.{u} (Spec R).ringCatSheaf).map S.g) :=
    @Functor.map_epi _ _ _ _ (SheafOfModules.toSheaf.{u} (Spec R).ringCatSheaf)
      (toSheaf_preservesEpimorphisms.{u} (Spec R).ringCatSheaf) _ _ S.g hgepi
  have hls : TopCat.Presheaf.IsLocallySurjective gπ :=
    (Sheaf.isLocallySurjective_iff_epi' AddCommGrpCat.{u}
      ((SheafOfModules.toSheaf.{u} (Spec R).ringCatSheaf).map S.g)).mpr hepiTS
  rw [TopCat.Presheaf.isLocallySurjective_iff] at hls
  intro t
  -- Step 2: per-point local lifts of `t`.
  have hch : ∀ p : ↥V₀, ∃ (W : (Spec R).Opens) (hWle : W ≤ V₀)
      (sl : ToType (GX.presheaf.obj (Opposite.op W))),
      ConcreteCategory.hom (gπ.app (Opposite.op W)) sl
        = ConcreteCategory.hom (HX.presheaf.map (homOfLE hWle).op) t ∧ (p : Spec R) ∈ W := by
    intro p
    obtain ⟨W, hWle, ⟨sl, hsl⟩, hmem⟩ := hls V₀ t p.1 p.2
    exact ⟨W, hWle, sl, hsl, hmem⟩
  choose W hWle sLift hsLift hmem using hch
  have hVcov : V₀ ≤ ⨆ p : ↥V₀, W p := by
    intro x hx
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨⟨x, hx⟩, hmem ⟨x, hx⟩⟩
  -- Step 3: refine to a standard cover `D(gᵢ)`.
  obtain ⟨n, g, φ, hVeq, hgle⟩ := standard_cover_cofinal f W hVcov
  set U : ULift.{u} (Fin n) → (Spec R).Opens := fun i => PrimeSpectrum.basicOpen (g i.down) with hU
  have hUsup : ⨆ i, U i = V₀ := by
    rw [hU, hV₀, hVeq]
    exact Equiv.ulift.{u}.iSup_comp (g := fun i => PrimeSpectrum.basicOpen (g i))
  -- the restricted local lifts on the standard cover
  set sLoc : ∀ i : ULift.{u} (Fin n), ToType (GX.presheaf.obj (Opposite.op (U i))) :=
    fun i => ConcreteCategory.hom (GX.presheaf.map (homOfLE (hgle i.down)).op)
      (sLift (φ i.down)) with hsLoc
  -- the section `t` transported to `⨆ U` (`= V₀`)
  have hopV : (Opposite.op (⨆ i, U i) : (TopologicalSpace.Opens (Spec R))ᵒᵖ) = Opposite.op V₀ :=
    congrArg Opposite.op hUsup
  set s : ToType (HX.presheaf.obj (Opposite.op (⨆ i, U i))) :=
    ConcreteCategory.hom (HX.presheaf.map (eqToHom hopV.symm)) t with hs
  -- assemble the hypotheses of `ses_cech_h1`
  have hπι : ∀ (V : (TopologicalSpace.Opens ↥(Spec R))ᵒᵖ) (x : ToType (FX.presheaf.obj V)),
      ConcreteCategory.hom (gπ.app V) (ConcreteCategory.hom (fι.app V) x) = 0 := by
    intro V x
    have hz : fι ≫ gπ = 0 := by
      rw [hfι, hgπ, ← Functor.map_comp, ← Functor.map_comp, S.zero,
        Functor.map_zero, Functor.map_zero]
    have := congrArg (fun (ψ : FX.presheaf ⟶ HX.presheaf) => ConcreteCategory.hom (ψ.app V) x) hz
    simpa using this
  have hmono : ∀ (V : (TopologicalSpace.Opens ↥(Spec R))ᵒᵖ),
      Function.Injective (ConcreteCategory.hom (fι.app V)) := by
    intro V
    haveI hpzm : (sectionsFunctor (Opposite.unop V)).PreservesZeroMorphisms := by
      unfold sectionsFunctor; infer_instance
    haveI hpfl : PreservesFiniteLimits (sectionsFunctor (Opposite.unop V)) := by
      unfold sectionsFunctor; infer_instance
    haveI : Mono S.f := hS.mono_f
    have hmonoAb : Mono (fι.app V) :=
      inferInstanceAs (Mono ((sectionsFunctor (Opposite.unop V)).map S.f))
    rwa [AddCommGrpCat.mono_iff_injective] at hmonoAb
  have hker : ∀ (V : (TopologicalSpace.Opens ↥(Spec R))ᵒᵖ) (x : ToType (GX.presheaf.obj V)),
      ConcreteCategory.hom (gπ.app V) x = 0 → ∃ y, ConcreteCategory.hom (fι.app V) y = x := by
    intro V x hx
    haveI hpzm : (sectionsFunctor (Opposite.unop V)).PreservesZeroMorphisms := by
      unfold sectionsFunctor; infer_instance
    haveI hpfl : PreservesFiniteLimits (sectionsFunctor (Opposite.unop V)) := by
      unfold sectionsFunctor; infer_instance
    have hex : (S.map (sectionsFunctor (Opposite.unop V))).Exact :=
      ShortComplex.Exact.map_of_mono_of_preservesKernel hS.exact
        (sectionsFunctor (Opposite.unop V)) hS.mono_f inferInstance
    rw [ShortComplex.ab_exact_iff_function_exact] at hex
    exact (hex x).mp hx
  -- the vanishing input, packaged as homology of the section Čech complex
  have hcovf : (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) := by
    rw [hVeq]
    exact (Equiv.ulift.{u}.iSup_comp (g := fun i => PrimeSpectrum.basicOpen (g i))).symm
  have hH1 : IsZero ((sectionCechComplex U FX).homology 1) := hvanish n g f hcovf 1 one_pos
  -- the local-lift compatibility `gπ(sLocᵢ) = s |_ Uᵢ`
  have hlift : ∀ i, ConcreteCategory.hom (gπ.app (Opposite.op (U i))) (sLoc i)
      = ConcreteCategory.hom (HX.presheaf.map (TopologicalSpace.Opens.leSupr U i).op) s := by
    intro i
    simp only [hsLoc, hs]
    erw [gπ.naturality_apply (homOfLE (hgle i.down)).op (sLift (φ i.down)), hsLift (φ i.down)]
    show ConcreteCategory.hom (HX.presheaf.map (homOfLE (hgle i.down)).op)
        (ConcreteCategory.hom (HX.presheaf.map (homOfLE (hWle (φ i.down))).op) t)
      = ConcreteCategory.hom (HX.presheaf.map (TopologicalSpace.Opens.leSupr U i).op)
        (ConcreteCategory.hom (HX.presheaf.map (eqToHom hopV.symm)) t)
    have hmaps : HX.presheaf.map (homOfLE (hWle (φ i.down))).op
          ≫ HX.presheaf.map (homOfLE (hgle i.down)).op
        = HX.presheaf.map (eqToHom hopV.symm)
          ≫ HX.presheaf.map (TopologicalSpace.Opens.leSupr U i).op := by
      rw [← HX.presheaf.map_comp, ← HX.presheaf.map_comp]
      congr 1
    simp only [← ConcreteCategory.comp_apply]
    rw [← hmaps]
    exact (ConcreteCategory.comp_apply _ _ t).symm
  -- apply the Čech surjectivity criterion
  obtain ⟨glob, hglob⟩ := ses_cech_h1 U FX GX HX fι gπ S.X₂.isSheaf S.X₃.isSheaf
    hπι hmono hker s hH1 sLoc hlift
  -- transport the global lift back to `V₀`
  refine ⟨ConcreteCategory.hom (GX.presheaf.map (eqToHom hopV)) glob, ?_⟩
  erw [gπ.naturality_apply (eqToHom hopV) glob, hglob]
  show ConcreteCategory.hom (HX.presheaf.map (eqToHom hopV))
      (ConcreteCategory.hom (HX.presheaf.map (eqToHom hopV.symm)) t) = t
  rw [← ConcreteCategory.comp_apply, ← HX.presheaf.map_comp]
  simp only [eqToHom_trans, eqToHom_refl, CategoryTheory.Functor.map_id]
  rfl

/-! ## Project-local Mathlib supplement — the affine cover system (Stacks 02KG) -/

set_option maxHeartbeats 2000000 in
/-- **The affine cover system** (Stacks 02KG, `def:affine_cover_system`). For `X = Spec R`, the
basis `B` is the distinguished opens `D f` (`f : R`) and the admissible coverings `Cov` are the
standard finite covers `i ↦ D(gᵢ)` (indexed by `ULift (Fin n)`, so as to land in `Type u`). The
three nontrivial fields are discharged by:
- `faces_mem` ← `affine_faces_mem` (finite intersections of distinguished opens are distinguished);
- `surj_of_vanishing` ← `affine_surj_of_vanishing` (the `ses_cech_h1` section-surjectivity criterion);
- `injective_acyclic` ← `injective_cech_acyclicFam` (cover-agnostic injective Čech-acyclicity, applied
  directly to the distinguished opens of each standard cover — no `Spec R_f` restriction detour).
Project-local: the affine instantiation of `BasisCovSystem` consumed by `cech_eq_cohomology_of_basis`. -/
noncomputable def affineCoverSystem (R : CommRingCat.{u}) : BasisCovSystem (Spec R) where
  B := Set.range (fun f : R => (PrimeSpectrum.basicOpen f : (Spec R).Opens))
  Cov := { c : CovDatum (Spec R) | ∃ (n : ℕ) (g : Fin n → R) (f : R),
    c = ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩ ∧
    (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) }
  faces_mem := by
    rintro c ⟨n, g, f, rfl, hcov⟩ p σ
    exact affine_faces_mem (fun j : ULift.{u} (Fin n) => g j.down) σ
  surj_of_vanishing := by
    rintro S hSE hvanish V ⟨f, rfl⟩
    refine affine_surj_of_vanishing S hSE (fun n g f' hcov q hq => ?_) f
    exact hvanish ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩
      ⟨n, g, f', rfl, hcov⟩ q hq
  injective_acyclic := by
    rintro I hI c ⟨n, g, f, rfl, hcov⟩ q hq
    haveI : Injective I := hI
    have hfam := injective_cech_acyclicFam
      (U := fun i : ULift.{u} (Fin n) => PrimeSpectrum.basicOpen (g i.down)) I q hq
    exact hfam

/-! ## Project-local Mathlib supplement — Čech cohomology transports along isomorphisms -/

/-- **{\v C}ech cohomology transports along an isomorphism of coefficient presheaves.** An
isomorphism `e : F ≅ G` of presheaves of `𝒪_X`-modules induces an isomorphism of section {\v C}ech
complexes (`sectionCechComplexFunctor`), hence of their degree-`p` homologies; so vanishing of
`Ȟᵖ(𝒰, F)` transfers to `Ȟᵖ(𝒰, G)`. Project-local: the naturality used to reduce the
quasi-coherent {\v C}ech-vanishing seed to the tilde case via `F ≅ ~(ΓF)`. -/
theorem cechCohomology_isZero_of_iso {ι : Type u} (U : ι → TopologicalSpace.Opens X)
    {F G : X.PresheafOfModules} (e : F ≅ G) (p : ℕ)
    (h : IsZero (cechCohomology U F p)) : IsZero (cechCohomology U G p) :=
  h.of_iso ((HomologicalComplex.homologyFunctor Ab.{u} (ComplexShape.up ℕ) p).mapIso
    ((sectionCechComplexFunctor U).mapIso e)).symm

/-! ## Project-local Mathlib supplement — quasi-coherent {\v C}ech-vanishing seed (reduction) -/

/-- **Reduction of the quasi-coherent {\v C}ech-vanishing seed to the tilde case.**  For a
quasi-coherent `𝒪_{Spec R}`-module `F`, the affine structure theorem `qcoh_iso_tilde_sections`
gives `F ≅ ~M` with `M = Γ(Spec R, F)`; transporting along this isomorphism
(`cechCohomology_isZero_of_iso`) reduces the seed `HasVanishingHigherCech (affineCoverSystem R) F`
to the tilde-case standard-cover {\v C}ech vanishing supplied in `htilde`.  Project-local: isolates
the single remaining geometric obligation (positive-degree {\v C}ech vanishing of `~M` over a
standard cover of a distinguished open `D(f)`), which is the change-of-base-to-`R_f` leaf. -/
theorem affine_cech_vanishing_qcoh_of_tildeVanishing {R : CommRingCat.{u}}
    (F : (Spec R).Modules) [F.IsQuasicoherent]
    (htilde : ∀ (n : ℕ) (g : Fin n → R) (f : R),
        (PrimeSpectrum.basicOpen f : (Spec R).Opens)
          = ⨆ i : ULift.{u} (Fin n), PrimeSpectrum.basicOpen (g i.down) →
        ∀ p, 0 < p →
          IsZero (cechCohomology
            (fun i : ULift.{u} (Fin n) => PrimeSpectrum.basicOpen (g i.down))
            ((Scheme.Modules.toPresheafOfModules (Spec R)).obj
              (tilde (moduleSpecΓFunctor.obj F))) p)) :
    HasVanishingHigherCech (affineCoverSystem R) F := by
  intro c hc p hp
  obtain ⟨n, g, f, rfl, hcov⟩ := hc
  refine cechCohomology_isZero_of_iso _
    ((Scheme.Modules.toPresheafOfModules (Spec R)).mapIso
      (qcoh_iso_tilde_sections F).symm) p ?_
  exact htilde n g f hcov p hp

end AlgebraicGeometry
