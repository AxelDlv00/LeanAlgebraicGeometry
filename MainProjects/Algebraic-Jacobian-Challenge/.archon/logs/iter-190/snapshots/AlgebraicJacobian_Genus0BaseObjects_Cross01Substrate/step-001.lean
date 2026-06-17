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

end AlgebraicGeometry

end
