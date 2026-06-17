/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus0BaseObjects.BareScheme
import AlgebraicJacobian.Genus0BaseObjects.ChartIso
import AlgebraicJacobian.Genus0BaseObjects.Points

/-!
# Cross01 substrate — Lane B (𝔾ₘ-scaling) reusable lemmas

This file ships **substrate** lemmas needed to close the Lane B
`gmScalingP1_chart_agreement_cross01` cocycle proof (path (III.c) of
`AbelianVarietyRigidity.tex`) together with two off-target sorries
(`gm_geomIrred`, `projGm_isReduced`) in `Genus0BaseObjects/GmScaling.lean`.

The substrates are generic in the geometric situation and live in their own
file rather than inline so they can be re-used by the three GmScaling consumer
applications and, if upstreamed, by Mathlib itself.  Their construction
follows the recipe of `analogies/lane-b-substrate.md` (§2) and the prover-facing
specification at `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex`.

## Contents (this iter)

* `AlgebraicGeometry.IsClosedImmersion.lift_iff_range_subset` —
  Substrate 1 (iter-189, axiom-clean): the closed-immersion universal
  property phrased as a topological range containment (under reduced
  source / target hypotheses).

* `AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain` —
  Substrate 2 (iter-190): the tensor
  `Away f ⊗_{k̄} GmRing k̄` is a domain, via the iso chain to
  `Localization.Away (X () : MvPolynomial Unit (Away f))` per
  `analogies/lane-b-substrate.md` §3.
-/

set_option autoImplicit false
set_option linter.style.setOption false

universe u

open CategoryTheory TopologicalSpace Topology

noncomputable section

namespace AlgebraicGeometry

namespace IsClosedImmersion

/--
**Closed immersion lift by range inclusion.**
For a closed immersion `i : Z ⟶ X` whose source `Z` is reduced and a
quasi-compact morphism `g : Y ⟶ X` whose source `Y` is reduced, `g` factors
through `i` if and only if the topological range of `g` is contained in the
topological range of `i`.

This is the topological-range form of the universal property of closed
immersions; the kernel-inequality form is `IsClosedImmersion.lift` /
`IsClosedImmersion.lift_fac`.  The two forms are interchanged by the Galois
connection `vanishingIdeal ⊣ support` on ideal sheaves
(`IdealSheafData.gc` / `IdealSheafData.vanishingIdeal_support`).

This is **Substrate 1** of the Lane B Cross01 cocycle proof; see
`blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex`,
`Theorem~\ref{thm:IsClosedImmersion_lift_iff_range_subset}`.
-/
theorem lift_iff_range_subset
    {X Y Z : Scheme.{u}} (i : Z ⟶ X) [IsClosedImmersion i] [IsReduced Z]
    (g : Y ⟶ X) [QuasiCompact g] [IsReduced Y] :
    (∃ h : Y ⟶ Z, h ≫ i = g) ↔ Set.range g.base ⊆ Set.range i.base := by
  refine ⟨?_, ?_⟩
  · -- (⇒) Forward direction: range pushdown.
    rintro ⟨h, rfl⟩
    rintro _ ⟨y, rfl⟩
    refine ⟨h.base y, ?_⟩
    simp [Scheme.Hom.comp_base]
  · -- (⇐) Backward direction: the substantive content.
    intro hrange
    -- Helper: the kernel of a ring hom into a reduced ring is a radical ideal.
    have ker_isRadical : ∀ {R S : Type u} [CommSemiring R] [CommSemiring S]
        [_root_.IsReduced S] (f : R →+* S), (RingHom.ker f).IsRadical := by
      intro R S _ _ _ f x hx
      obtain ⟨n, hxn⟩ := hx
      rw [RingHom.mem_ker] at hxn ⊢
      have h₁ : (f x) ^ n = 0 := by
        rw [← map_pow]; exact hxn
      exact eq_zero_of_pow_eq_zero h₁
    -- Step 1: For a closed immersion, the support of its kernel equals its range.
    -- (`support_ker` gives `closure (range)`; closed range collapses the closure.)
    have hi_range_eq : (i.ker.support : Set X) = Set.range i.base := by
      rw [Scheme.Hom.support_ker]
      exact i.isClosedEmbedding.isClosed_range.closure_eq
    -- Step 2: `g.ker.support ⊆ i.ker.support` (set-theoretic, via `closure_minimal`).
    have hsup_set : (g.ker.support : Set X) ⊆ (i.ker.support : Set X) := by
      rw [Scheme.Hom.support_ker]
      refine closure_minimal ?_ i.ker.support.isClosed
      exact hrange.trans hi_range_eq.ge
    -- Promote the set inclusion to the `Closeds X` ordering.
    have hsup : g.ker.support ≤ i.ker.support := hsup_set
    -- Step 3: `g.ker` is radical (because `Y` is reduced, so each `Γ(Y, g ⁻¹ᵁ U)` is reduced
    -- and the ring kernel is therefore radical, pointwise on affine opens).
    have hg_rad : g.ker.radical = g.ker := by
      refine le_antisymm ?_ (Scheme.IdealSheafData.le_radical _)
      intro U
      rw [Scheme.IdealSheafData.radical_ideal, Scheme.Hom.ker_apply]
      exact ker_isRadical (g.app U.1).hom
    -- Step 4: `i.ker` is radical (same argument; closed immersions are quasi-compact).
    have hi_rad : i.ker.radical = i.ker := by
      refine le_antisymm ?_ (Scheme.IdealSheafData.le_radical _)
      intro U
      rw [Scheme.IdealSheafData.radical_ideal, Scheme.Hom.ker_apply]
      exact ker_isRadical (i.app U.1).hom
    -- Step 5: thread the Galois connection `vanishingIdeal ⊣ support`.
    have hker : i.ker ≤ g.ker := by
      calc i.ker
          = i.ker.radical := hi_rad.symm
        _ = Scheme.IdealSheafData.vanishingIdeal i.ker.support :=
              Scheme.IdealSheafData.vanishingIdeal_support.symm
        _ ≤ Scheme.IdealSheafData.vanishingIdeal g.ker.support :=
              Scheme.IdealSheafData.vanishingIdeal_antimono hsup
        _ = g.ker.radical := Scheme.IdealSheafData.vanishingIdeal_support
        _ = g.ker := hg_rad
    -- Step 6: feed the kernel inequality to Mathlib's `IsClosedImmersion.lift`.
    exact ⟨IsClosedImmersion.lift i g hker, IsClosedImmersion.lift_fac i g hker⟩

end IsClosedImmersion

/--
**Substrate 2 — `Away f ⊗_{k̄} GmRing k̄` is a domain.**

For a non-zero homogeneous element `f` of positive degree `d` in the
`projectiveLineBar` grading on `MvPolynomial (Fin 2) k̄`, the tensor
`HomogeneousLocalization.Away (projectiveLineBarGrading k̄) f ⊗_{k̄} GmRing k̄`
is an integral domain.

The proof builds an explicit `RingEquiv` to
`Localization.Away (X () : MvPolynomial Unit (Away f))`, which is a
localization of a polynomial ring over a domain at a non-zero-divisor,
hence a domain.

This is **Substrate 2** of the Lane B Cross01 cocycle proof; see
`blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex`,
`Theorem~\ref{thm:gmRing_tensor_homogeneousAway_isDomain}`.
-/
theorem gmRing_tensor_homogeneousAway_isDomain
    (kbar : Type u) [Field kbar] {d : ℕ} (_hd : 0 < d)
    (f : MvPolynomial (Fin 2) kbar)
    (_hf : f ∈ projectiveLineBarGrading kbar d)
    (hf_ne : f ≠ 0) :
    IsDomain (TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f)
      (GmRing kbar)) := by
  classical
  -- ===== Abbreviations =====
  -- `A` = the homogeneous localization (a `kbar`-algebra and a domain).
  set A : Type u := HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f
    with hA_def
  -- `T` = `MvPolynomial Unit A`, a polynomial ring over `A`.
  -- `L` = `Localization.Away (X () : T)`, target domain.
  -- We construct a ring iso `A ⊗[kbar] (GmRing kbar) ≃+* L` and transport `IsDomain`.
  -- ===== Step 1: A is a domain (using val-injection into Localization.Away f). =====
  haveI hA_dom : IsDomain A := by
    refine Function.Injective.isDomain (algebraMap A (Localization.Away f)) ?_
    intro x y h
    exact HomogeneousLocalization.val_injective _ h
  -- ===== Step 2: T = MvPolynomial Unit A is a domain. =====
  haveI hT_dom : IsDomain (MvPolynomial Unit A) := inferInstance
  -- ===== Step 3: L = Localization.Away (X () : T) is a domain. =====
  haveI hL_dom : IsDomain (Localization.Away
      (MvPolynomial.X () : MvPolynomial Unit A)) :=
    IsLocalization.isDomain_localization
      (powers_le_nonZeroDivisors_of_noZeroDivisors (MvPolynomial.X_ne_zero _))
  -- ===== Step 4: Build forward AlgHom `φ : A ⊗[kbar] Gm →ₐ[kbar] L`. =====
  -- (a) `A →ₐ[kbar] L` via `A → MvPolynomial Unit A → L`.
  let φ_A : A →ₐ[kbar] Localization.Away
      (MvPolynomial.X () : MvPolynomial Unit A) :=
    (IsScalarTower.toAlgHom kbar (MvPolynomial Unit A)
        (Localization.Away (MvPolynomial.X () : MvPolynomial Unit A))).comp
      (IsScalarTower.toAlgHom kbar A (MvPolynomial Unit A))
  -- (b) Base map `MvPolynomial Unit kbar →ₐ[kbar] L` via `aeval`.
  let polk_to_L : MvPolynomial Unit kbar →ₐ[kbar]
      Localization.Away (MvPolynomial.X () : MvPolynomial Unit A) :=
    MvPolynomial.aeval (fun (_ : Unit) =>
      (algebraMap (MvPolynomial Unit A)
        (Localization.Away (MvPolynomial.X () : MvPolynomial Unit A)))
        (MvPolynomial.X () : MvPolynomial Unit A))
  -- (c) Image of `X ()` is a unit in `L`.
  have hX_unit : IsUnit
      (polk_to_L (MvPolynomial.X () : MvPolynomial Unit kbar)) := by
    have h_eq : polk_to_L (MvPolynomial.X () : MvPolynomial Unit kbar)
        = (algebraMap (MvPolynomial Unit A)
            (Localization.Away (MvPolynomial.X () : MvPolynomial Unit A)))
          (MvPolynomial.X () : MvPolynomial Unit A) := by
      simp [polk_to_L]
    rw [h_eq]
    exact IsLocalization.Away.algebraMap_isUnit (MvPolynomial.X () : MvPolynomial Unit A)
  -- (d) Lift `polk_to_L` through the localization `MvPolynomial Unit kbar → GmRing kbar`.
  let φ_Gm_ring : GmRing kbar →+*
      Localization.Away (MvPolynomial.X () : MvPolynomial Unit A) :=
    IsLocalization.Away.lift
      (g := polk_to_L.toRingHom)
      (MvPolynomial.X () : MvPolynomial Unit kbar) hX_unit
  -- (e) Promote `φ_Gm_ring` to an `AlgHom kbar`.
  let φ_Gm : GmRing kbar →ₐ[kbar]
      Localization.Away (MvPolynomial.X () : MvPolynomial Unit A) :=
    { φ_Gm_ring with
      commutes' := fun k => by
        -- algebraMap kbar Gm k = algebraMap MvPolyUnit Gm (algebraMap kbar MvPolyUnit k)
        have step :
            (algebraMap kbar (GmRing kbar)) k
              = (algebraMap (MvPolynomial Unit kbar) (GmRing kbar))
                ((algebraMap kbar (MvPolynomial Unit kbar)) k) :=
          (IsScalarTower.algebraMap_apply kbar (MvPolynomial Unit kbar)
            (GmRing kbar) k).symm
        show φ_Gm_ring _ = _
        rw [step]
        show φ_Gm_ring
            ((algebraMap (MvPolynomial Unit kbar) (GmRing kbar))
              ((algebraMap kbar (MvPolynomial Unit kbar)) k)) = _
        rw [IsLocalization.Away.lift_eq]
        exact polk_to_L.commutes k }
  -- (f) Lift through tensor to obtain φ.
  let φ : TensorProduct kbar A (GmRing kbar) →ₐ[kbar]
      Localization.Away (MvPolynomial.X () : MvPolynomial Unit A) :=
    Algebra.TensorProduct.lift φ_A φ_Gm (fun _ _ => Commute.all _ _)
  -- ===== Step 5: Build inverse AlgHom (ring hom) `ψ : L → A ⊗[kbar] Gm`. =====
  -- (a) Map `T = MvPolynomial Unit A → target` sending `X ()` to `1 ⊗ (X () in Gm)`.
  let target : Type u := TensorProduct kbar A (GmRing kbar)
  -- Image of X () in target — the element we want to be invertible.
  let xImg : target :=
    (1 : A) ⊗ₜ[kbar] (algebraMap (MvPolynomial Unit kbar) (GmRing kbar)
      (MvPolynomial.X () : MvPolynomial Unit kbar))
  -- `T →ₐ[A] target` via aeval. (target is an A-algebra via Algebra.TensorProduct.leftAlgebra.)
  let ψ_T : MvPolynomial Unit A →ₐ[A] target :=
    MvPolynomial.aeval (fun (_ : Unit) => xImg)
  -- (b) Image of `X () : T` is invertible in target. The inverse is `1 ⊗ (X())⁻¹`.
  have hX_unit_target : IsUnit (ψ_T (MvPolynomial.X () : MvPolynomial Unit A)) := by
    have heq : ψ_T (MvPolynomial.X () : MvPolynomial Unit A) = xImg := by
      simp [ψ_T]
    rw [heq]
    -- Use that `xImg = 1 ⊗ algebraMap polkbar Gm (X())`,
    -- and `algebraMap polkbar Gm (X())` is a unit (as X() is the localized element).
    refine IsUnit.map ?_ ?_
    · -- We want a hom A → target. Take TensorProduct.includeRight composed with itself?
      -- Actually we use `algebraMap (GmRing kbar) target` (via includeRight).
      exact (Algebra.TensorProduct.includeRight : GmRing kbar →ₐ[kbar] target).toRingHom
    · -- algebraMap MvPolyUnit Gm (X ()) is a unit in Gm.
      exact IsLocalization.Away.algebraMap_isUnit (MvPolynomial.X () : MvPolynomial Unit kbar)
  -- (c) Lift to `L = Localization.Away X () : T → target`.
  let ψ_ring : Localization.Away (MvPolynomial.X () : MvPolynomial Unit A) →+* target :=
    IsLocalization.Away.lift
      (g := ψ_T.toRingHom)
      (MvPolynomial.X () : MvPolynomial Unit A) hX_unit_target
  -- ===== Step 6: Show φ.toRingHom and ψ_ring are mutual inverses. =====
  -- We verify (ψ_ring ∘ φ) = id on generators (A and GmRing kbar),
  -- and (φ ∘ ψ_ring) = id on generators (T = MvPolynomial Unit A, which suffices
  -- since L is the localization).
  have hψφ_AlgHom : (ψ_ring.comp φ.toRingHom : target →+* target) = RingHom.id _ := by
    -- For a ring hom out of A ⊗[kbar] Gm to be identity, it suffices to agree
    -- on includeLeft (A) and includeRight (Gm).
    refine RingHom.ext fun x => ?_
    induction x using TensorProduct.induction_on with
    | zero => simp
    | tmul a b =>
      -- (ψ_ring ∘ φ) (a ⊗ b) = ψ_ring (φ_A a * φ_Gm b)
      -- = ψ_ring (φ_A a) * ψ_ring (φ_Gm b)
      -- = (a ⊗ 1) * (1 ⊗ b) = a ⊗ b
      simp only [RingHom.comp_apply, RingHom.id_apply]
      -- Compute φ on a ⊗ b
      change ψ_ring (φ (a ⊗ₜ b)) = a ⊗ₜ b
      rw [show φ (a ⊗ₜ b) = φ_A a * φ_Gm b from by simp [φ]]
      rw [map_mul]
      -- ψ_ring (φ_A a) = a ⊗ 1
      have h_A : ψ_ring (φ_A a) = (a : A) ⊗ₜ[kbar] (1 : GmRing kbar) := by
        -- φ_A a = algebraMap T L (algebraMap A T a) = algebraMap A L a (via IsScalarTower).
        show ψ_ring (φ_A a) = _
        have : φ_A a = (algebraMap A
              (Localization.Away (MvPolynomial.X () : MvPolynomial Unit A))) a := by
          show ((IsScalarTower.toAlgHom kbar (MvPolynomial Unit A) _).comp
              (IsScalarTower.toAlgHom kbar A (MvPolynomial Unit A))) a = _
          simp [IsScalarTower.algebraMap_apply A (MvPolynomial Unit A)
            (Localization.Away (MvPolynomial.X () : MvPolynomial Unit A))]
        rw [this, IsScalarTower.algebraMap_apply A (MvPolynomial Unit A)
          (Localization.Away (MvPolynomial.X () : MvPolynomial Unit A))]
        show ψ_ring ((algebraMap (MvPolynomial Unit A) _)
          ((algebraMap A (MvPolynomial Unit A)) a)) = _
        rw [show ψ_ring = IsLocalization.Away.lift (g := ψ_T.toRingHom)
              (MvPolynomial.X () : MvPolynomial Unit A) hX_unit_target from rfl]
        rw [IsLocalization.Away.lift_eq]
        show ψ_T ((algebraMap A (MvPolynomial Unit A)) a) = _
        -- ψ_T is aeval-based; on constants it's algebraMap A target.
        rw [show (algebraMap A (MvPolynomial Unit A)) a = MvPolynomial.C a from rfl]
        rw [MvPolynomial.aeval_C]
        show (algebraMap A target) a = (a : A) ⊗ₜ (1 : GmRing kbar)
        rfl
      -- ψ_ring (φ_Gm b) = 1 ⊗ b
      have h_Gm : ψ_ring (φ_Gm b) = (1 : A) ⊗ₜ[kbar] (b : GmRing kbar) := by
        -- Use surjectivity of localization: b = algebraMap polkbar Gm p * (algebraMap polkbar Gm X())⁻ⁿ
        -- It suffices to show ψ_ring ∘ φ_Gm = inclusion (algebraMap or rightAlgebra-style).
        -- For a hom out of GmRing = Localization.Away X (), equality is checked on
        -- the base and on the inverse of the localized element.
        have key : (ψ_ring.comp φ_Gm.toRingHom : GmRing kbar →+* target)
            = (Algebra.TensorProduct.includeRight :
                GmRing kbar →ₐ[kbar] target).toRingHom := by
          -- Both are ring homs from Localization.Away (X()); they agree iff they agree
          -- after composition with `algebraMap MvPolyUnit Gm` (the base map).
          apply IsLocalization.ringHom_ext (Submonoid.powers
            (MvPolynomial.X () : MvPolynomial Unit kbar))
          ext p
          simp only [RingHom.comp_apply]
          show ψ_ring (φ_Gm ((algebraMap (MvPolynomial Unit kbar) (GmRing kbar)) p))
            = (Algebra.TensorProduct.includeRight
                ((algebraMap (MvPolynomial Unit kbar) (GmRing kbar)) p))
          -- LHS: ψ_ring (φ_Gm (algebraMap _ _ p)) = ψ_ring (polk_to_L p) by lift_eq
          have lhs_eq : φ_Gm ((algebraMap (MvPolynomial Unit kbar) (GmRing kbar)) p)
              = polk_to_L p := by
            show φ_Gm_ring _ = _
            rw [show φ_Gm_ring = IsLocalization.Away.lift
                (g := polk_to_L.toRingHom)
                (MvPolynomial.X () : MvPolynomial Unit kbar) hX_unit from rfl]
            rw [IsLocalization.Away.lift_eq]
            rfl
          rw [lhs_eq]
          -- Both sides are ring homs of p : MvPolynomial Unit kbar.
          -- Compute by induction on p.
          induction p using MvPolynomial.induction_on with
          | C r =>
            -- polk_to_L (C r) = aeval _ (C r) = algebraMap kbar L r
            -- includeRight (algebraMap MvPolyUnit Gm (C r)) = includeRight (algebraMap kbar Gm r)
            --   = 1 ⊗ algebraMap kbar Gm r = algebraMap kbar target r (via leftAlgebra/scalarTower).
            simp only [MvPolynomial.aeval_C, polk_to_L]
            show (algebraMap kbar _) r = _
            rw [show (algebraMap (MvPolynomial Unit kbar) (GmRing kbar))
                (MvPolynomial.C r) = (algebraMap kbar (GmRing kbar)) r by
              simp [MvPolynomial.algebraMap_eq]]
            -- Now: algebraMap kbar L r = includeRight (algebraMap kbar Gm r)
            show (algebraMap kbar _) r = (Algebra.TensorProduct.includeRight :
                GmRing kbar →ₐ[kbar] target) ((algebraMap kbar (GmRing kbar)) r)
            rw [(Algebra.TensorProduct.includeRight :
                GmRing kbar →ₐ[kbar] target).commutes r]
            rfl
          | add p q hp hq =>
            simp only [map_add, hp, hq]
          | mul_X p i hp =>
            simp only [map_mul, MvPolynomial.aeval_X, polk_to_L] at hp ⊢
            rw [hp]
            -- Now need: φ_A (1) * algebraMap T L (X () : T) * includeRight (gm thing)
            --        = includeRight (algebraMap polkbar Gm p * algebraMap polkbar Gm X())
            -- Hmm need careful unfolding
            sorry
        -- Apply key
        have := congr_fun (DFunLike.congr_fun (R := GmRing kbar →+* target) key.symm).symm b
        sorry
      rw [h_A, h_Gm, Algebra.TensorProduct.tmul_mul_tmul, mul_one, one_mul]
    | add x y hx hy =>
      simp only [map_add, hx, hy]
  -- Use injectivity (ψ_ring ∘ φ = id implies φ is injective).
  -- Then RingEquiv via Bijectivity (φ is also surjective as ψ_ring is a left inverse + matching universal properties).
  -- For now, use Function.Injective.isDomain.
  refine Function.Injective.isDomain φ.toRingHom ?_
  -- φ is injective because ψ_ring ∘ φ = id.
  intro x y hxy
  have : ψ_ring (φ x) = ψ_ring (φ y) := by rw [hxy]
  have hx : ψ_ring (φ x) = x := by
    have := congr_fun (DFunLike.congr_fun (R := target →+* target) hψφ_AlgHom).symm x
    sorry
  have hy : ψ_ring (φ y) = y := by sorry
  rw [hx, hy] at this
  exact this

end AlgebraicGeometry

end
