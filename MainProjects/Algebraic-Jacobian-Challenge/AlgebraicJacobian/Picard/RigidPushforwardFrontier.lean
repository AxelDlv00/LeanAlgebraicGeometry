/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.RigidPushforwardGate
import AlgebraicJacobian.Picard.RigidPushforwardFiberChart
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf

/-!
# The `HasRigidPushforward` frontier after the fibre-chart and sheaf bricks

`Picard/RigidPushforwardGate.lean` factored the B3 campaign gate into four
named leaves.  Two of them have since been discharged, and this file records
the resulting state of the frontier — as Lean, not as prose.

## What is now closed

* **Leaf 2, `P1CechFibrewiseBridge k A`, is PROVED**
  (`p1CechFibrewiseBridge_proved` below, from
  `Adelic.p1_hfib_of_fiberH1Vanishing`,
  `Picard/RigidPushforwardFiberChart.lean`).  Fibrewise Čech
  `h¹`-vanishing of a finitely presented `M` on `ℙ¹_A` at every scheme point
  really does force the base-linear Čech differential to stay surjective
  after `⊗ κ(𝔪)` at every maximal ideal.  The proof runs Stacks 02KG in
  degree `0` on each affine chart of `ℙ¹_A` — the section-ring pushout on
  arbitrary compatible affine opens (`isPushout_appLE_of_isPullback'`,
  generalising the `f ⁻¹ᵁ V`-pinned form, which is unusable here because
  `p ⁻¹ᵁ ⊤ = ℙ¹_A` is not affine), the resulting chart comparison
  `κ(t) ⊗_{Γ(Spec A, ⊤)} Γ(M, W) ≅ Γ(M_t, W_t)` and its restriction
  naturality, the intertwining with the Čech differential, and the
  maximal-ideal-to-point package.

* **Leaf 3's sheaf half is PROVED**
  (`Adelic.p1PushforwardLocalFreenessBridge_of_rank`,
  `Picard/RigidPushforwardP1Sheaf.lean`): a quasi-coherent module on
  `Spec R` whose global sections are finite projective *is* free of rank
  `rankAtStalk` on a basic-open neighbourhood of any point
  (`exists_free_restrict_of_finite_projective_sections`), and
  `Γ(Spec A, p_* M)` really is `ker d`
  (`Adelic.pushforwardTop_linearEquiv_ker`).

## What remains — the whole frontier, in two statements plus one field

`p1RigidPushforwardStatement_of_isIntegral_of_rank` below shows that the ℙ¹
engine statement, hence the gate's `locallyFree` field, now needs exactly:

1. **`IsIntegral (ℙ¹_k)`** — integrality of the projective line over the one
   field `k`.  The load-bearing sub-probe is the chart-ring identification
   `Γ(ℙ¹, D₊(X₀)) ≅ R[T]`: the tree has the spanning half
   (`span_p1CoordAway_pow_top`, `RiemannRoch/Adelic/P1ChartData.lean`) and
   nothing about freeness, and `RelLaurentChartData` supplies spanning but
   never a basis.  mathlib has `GeometricallyIrreducible`/`Reduced`/`Integral`
   for *affine* space and no integrality API for `Proj` at all, so landing
   the chart iso would give `IsReduced` and `IrreducibleSpace` of `ℙ¹` by
   transport.

2. **`hrank`** — that the pointwise rank of `p_* M` really is the fibre
   `h⁰`, `sectionsRankAtStalk (p_* M) t = p.fiberH0 M t`.  This is the same
   fibre-chart base change that leaf 2 already uses: the chart comparison
   `exists_fiberChartTensorEquiv` identifies `ker (d ⊗ κ(t))` with the Čech
   `H⁰` of the fibre, i.e. with `Γ(ℙ¹_t, M_t)`, and the engine's
   `kerBaseChange` bijectivity at `B = κ(t)` converts that into the rank
   statement.  So this is assembly of bricks that now exist, not new
   mathematics.

and, for the gate's second field,

3. **`Scheme.RigidPushforwardBaseChange C A`** — untouched.  Every `IsIso`
   theorem for the adjoint mate `pushforwardBaseChangeMap` in this tree
   requires `[IsAffineHom f]`, and `q : C_A ⟶ Spec A` is proper; with
   `IsAffineHom q` assumed the field closes in one line, so its entire
   content is the non-affine case.  There is also no composition/pasting API
   for `pushforwardBaseChangeMap`, so "reduce along the finite affine `π_A`,
   then treat `p : ℙ¹_A ⟶ Spec A`" cannot yet be assembled.

Sources: Mumford, *Abelian Varieties*, II §5; Stacks 02KG, 01YS; EGA III
7.9.9; Kleiman, *The Picard scheme* (FGA Explained), §5.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Adelic

open Scheme

variable {k : Type u} [Field k]

/-- **Leaf 2 of the gate is closed.**  `P1CechFibrewiseBridge k A` — fibrewise
Čech `h¹`-vanishing at all scheme points implies surjectivity of
`d ⊗ (Γ(Spec A, ⊤) ⧸ 𝔪)` at every maximal ideal — holds for every
`k`-algebra `A` (no finiteness on `A` needed).

This is `Adelic.p1_hfib_of_fiberH1Vanishing`
(`Picard/RigidPushforwardFiberChart.lean`) restated against the gate's pin. -/
theorem p1CechFibrewiseBridge_proved (A : Type u) [CommRing A] [Algebra k A] :
    P1CechFibrewiseBridge k A := by
  intro M hfp h1
  haveI := hfp
  exact p1_hfib_of_fiberH1Vanishing A M h1

/-- **The ℙ¹ engine statement from what actually remains.**  With leaf 2
proved and the sheaf half of leaf 3 proved, `P1RigidPushforwardStatement k A`
needs only

* `IsIntegral (ℙ¹_k)` (as an instance — the `H⁰`-finiteness anchor), and
* `hrank`: the pointwise rank of `p_* M` is the fibre `h⁰`.

Both are recorded in the module docstring; `hrank` is assembly of existing
bricks, `IsIntegral (ℙ¹_k)` is the genuine remaining mathematics. -/
theorem p1RigidPushforwardStatement_of_isIntegral_of_rank
    [IsIntegral ((p1Over k).left)]
    (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
    (hrank : ∀ (M : (Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules),
      M.IsFinitePresentation →
      ∀ t : Spec (CommRingCat.of A),
        sectionsRankAtStalk ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M) t =
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 M t) :
    P1RigidPushforwardStatement k A :=
  p1RigidPushforwardStatement_of_leaves_of_isIntegral A
    (p1CechFibrewiseBridge_proved A)
    (p1PushforwardLocalFreenessBridge_of_rank A hrank)

/-- **The gate's `locallyFree` field from what actually remains.**  For an AJC
curve, rank-`χ` local freeness of the rigid pushforward for the constant curve
`C_A` follows from `IsIntegral (ℙ¹_k)` and the rank identification alone —
`HasFiniteMapToP1 C` and the entire finite-pushforward transfer package along
`π_A : C_A ⟶ ℙ¹_A` are already discharged in the tree. -/
theorem rigidPushforwardLocallyFree_of_isIntegral_of_rank
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    [IsIntegral ((p1Over k).left)]
    (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
    (hrank : ∀ (M : (Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules),
      M.IsFinitePresentation →
      ∀ t : Spec (CommRingCat.of A),
        sectionsRankAtStalk ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M) t =
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 M t) :
    Scheme.RigidPushforwardLocallyFree C A :=
  rigidPushforwardLocallyFree_of_p1Engine A C
    (p1RigidPushforwardStatement_of_isIntegral_of_rank A hrank)

/-- **The gate itself, from what actually remains.**  Three statements:
integrality of `ℙ¹_k`, the rank identification at every finitely generated
`k`-algebra, and the base-change field.  Nothing else about the B3 engine is
open. -/
theorem hasRigidPushforward_of_isIntegral_of_rank_of_baseChange
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom]
    [IsIntegral ((p1Over k).left)]
    (hrank : ∀ (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
      (M : (Limits.pullback (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules),
      M.IsFinitePresentation →
      ∀ t : Spec (CommRingCat.of A),
        sectionsRankAtStalk ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M) t =
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 M t)
    (hBC : ∀ (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A],
      Scheme.RigidPushforwardBaseChange C A) :
    Scheme.HasRigidPushforward C :=
  hasRigidPushforward_of_p1Engine_of_baseChange C
    (fun A => p1RigidPushforwardStatement_of_isIntegral_of_rank A (hrank A)) hBC

end Adelic

end AlgebraicGeometry
