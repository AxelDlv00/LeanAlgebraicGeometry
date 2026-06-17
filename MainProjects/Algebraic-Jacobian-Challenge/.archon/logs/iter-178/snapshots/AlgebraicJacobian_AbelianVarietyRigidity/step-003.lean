/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Genus0BaseObjects
import AlgebraicJacobian.RigidityLemma

/-!
# Abelian-variety rigidity: genus-`0` final assembly

This file is the **genus-`0` final layer** of the project's committed characteristic-free
route (route (c)) to abelian-variety rigidity. It assembles the headline
`rigidity_genus0_curve_to_grpScheme` — the char-free replacement (no `[CharZero kbar]`) for
`AlgebraicGeometry.rigidity_over_kbar` of `AlgebraicJacobian.RigidityKbar` (which remains in
tree as the fallback route (a) artifact and still carries `[CharZero]`).

The abstract Mumford Rigidity Lemma chain (`rigidity_lemma`) and the two Milne §I.1 corollaries
(`hom_additive_decomp_of_rigidity` = Cor 1.5, `av_regularMap_isHom_of_zero` = Cor 1.2) it
implies live **upstream** in `AlgebraicJacobian.RigidityLemma`, which is imported here. That
chain is PROVEN axiom-clean (iters 157–162); this file consumes it.

The final assembly has three links specific to the genus-`0` route:

1. `morphism_P1_to_grpScheme_const` — every morphism `ℙ¹ → A` into an abelian variety is
   constant. Proved (route resolved iter-164) by the **𝔾ₘ-scaling shortcut**: the total scaling
   action `σ_× : ℙ¹ × 𝔾ₘ → ℙ¹`, `(x, λ) ↦ λx`, feeds the proven Cor 1.5
   (`hom_additive_decomp_of_rigidity`) — NO theorem of the cube, NO Milne Thm 3.2, NO
   `Hom(𝔾ₐ, A) = 0`, char-general. (Still a scaffold `sorry` pending the concrete ℙ¹/𝔾ₘ/σ_× infra.)
2. `genusZero_curve_iso_P1` — a smooth proper geom-irred genus-`0` curve over `k̄` is
   isomorphic to `ℙ¹` (blocked on Riemann–Roch).
3. `rigidity_genus0_curve_to_grpScheme` — THE HEADLINE consumed by `genusZeroWitness`.

The file also exposes the project-local bridge `iotaGm_isDominant` — the dominance of the
canonical `Gm ↪ ℙ¹` inclusion — which becomes provable once Lane A
(`AlgebraicJacobian.Genus0BaseObjects`) ships the concrete chartwise body of `gmScalingP1`.

See `blueprint/src/chapters/AbelianVarietyRigidity.tex` for the informal sketches and sources
(Mumford, *Abelian Varieties*, Ch. II §6; Milne, *Abelian Varieties*, Prop. 3.10;
Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

## Encoding notes

Mathlib `b80f227` packages no `ℙ¹` as a `Scheme`, so the projective line is encoded by its
abstract characterisation: a smooth proper geometrically irreducible `Over (Spec (.of kbar))` of
relative dimension `1` with `genus = 0` (see
`AlgebraicJacobian.Genus0BaseObjects.ProjectiveLineBar`).
The signatures of declarations 1–3 are **provisional** (`SCAFFOLD` comments mark them); the prover
may refine the encoding when the bodies are filled. Declaration 3 is pinned verbatim to
`rigidity_over_kbar`'s signature minus `[CharZero kbar]`, because it is the exact signature the
consumer (`genusZeroWitness.key`) needs.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {kbar : Type u} [Field kbar]

/-! ### Iter-167 dominance bridge for the canonical `Gm ↪ ℙ¹` map

The four product / Proj instances `morphism_P1_to_grpScheme_const_aux` needs
(`GeometricallyIrreducible`, `LocallyOfFiniteType`, `IsReduced` of the product, and
`IsReduced (ProjectiveLineBar kbar).left`) all ship from Lane A
(`AlgebraicJacobian.Genus0BaseObjects`) as the instances `projGm_geomIrred`,
`projGm_locallyOfFiniteType`, `projGm_isReduced`, and `projectiveLineBar_isReduced`. The
helper resolves them all by `infer_instance`.

The one remaining bridge — dominance of the canonical inclusion `ι : Gm ⟶ ℙ¹` — is
file-local because its proof depends on the concrete chartwise body of `gmScalingP1` (still
a Lane A scaffold sorry through iter-167). It is exposed here as a named top-level lemma
`iotaGm_isDominant` so the helper carries no inline `sorry`. -/

/-- **The canonical `Gm ↪ ℙ¹` inclusion `ι : Gm ⟶ ℙ¹` is dominant.** Here `ι` is the
"specialise the scaling action at `x = 1`" map `lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1`.
Once Lane A ships the concrete `gmScalingP1` body (chartwise glue), this becomes the standard
open immersion `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` (sending `λ` to `[λ : 1]`), which is dense in the
irreducible `ℙ¹`.

Project-side bridge pending Lane A's concrete `gmScalingP1` body. -/
private lemma iotaGm_isDominant [IsAlgClosed kbar] :
    IsDominant (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
      ≫ gmScalingP1 kbar).left := by
  -- **Mathematical content.** This morphism is the canonical open immersion
  -- `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` sending `λ ↦ [λ : 1]`. Its image is the basic open
  -- `D₊(X₀X₁) = ℙ¹ \ {0, ∞}`, which is dense in the irreducible scheme `ℙ¹.left`.
  --
  -- **Structural decomposition** (gated by iter-178 chart-bridge gap):
  --   (i)   `(lift _ _).left ≫ gmScalingP1.left` factors through chart-1 of
  --         `gmScalingP1_cover` (the chart corresponding to `D₊(X 1) ⊂ ℙ¹`).
  --   (ii)  On the section `{1} × Gm ⊂ ℙ¹ ⊗ Gm`, the chart-1 ring map sends
  --         `u ↦ u ⊗ λ`, restricted at `u = 1` to `1 ↦ 1 ⊗ λ = λ` in `Gm`.
  --   (iii) The resulting underlying scheme map is the composition
  --         `Spec k̄[t, t⁻¹] →[Spec.map ofLocalization] Spec k̄[u] →[Proj.awayι _ X 1 _ _] ℙ¹`,
  --         each factor an open immersion into an irreducible target — hence dominant
  --         (composition of dominants is dominant: `instIsDominantCompScheme`).
  --
  -- **Iter-178 gap.** The chart-1 ring-map equality in (ii) requires concrete chartwise
  -- data on `gmScalingP1` that the existing temp axioms
  -- `gmScalingP1_chart_data_temp` and `gmScalingP1_collapse_at_zero_temp` do not expose
  -- (they cover over-coherence + cocycle + the `0`-collapse only). Closure requires the
  -- iter-178 mathlib-analogist consult `gmscaling-cover-bridge`
  -- (see `analogies/gmscaling-cover-bridge.md`) — its replacement axiom-clean chart-bridge
  -- body is scheduled iter-179+ per the consult, with iter-181 RETIRE-OR-ESCALATE as the
  -- hard deadline (STRATEGY.md Open Q "Lane A1 HARD STOP rule").
  --
  -- **Iter-178 partial advance.** Convert from term-mode `:= sorry` to tactic-mode and
  -- reduce the goal from the `IsDominant` class to the explicit `DenseRange` topology
  -- claim on the composed underlying continuous map. This isolates the remaining
  -- difficulty at a level where iter-179+ can apply `DenseRange.comp` (or the
  -- `IsOpenMap.denseRange_of_isPreirreducibleSpace` route) once the chart-1 factorisation
  -- (i)-(iii) lands.
  rw [Over.comp_left]
  refine ⟨?_⟩
  sorry

/-- **Helper (pointed case): a morphism `f : ℙ¹ → A` killing `0 ∈ ℙ¹` is the constant `1`.**
Over an algebraically closed field `k̄`, if `f : ProjectiveLineBar kbar ⟶ A` satisfies
`ProjectiveLineBar.zeroPt kbar ≫ f = η[A]`, then `f = (1 : ProjectiveLineBar kbar ⟶ A)`
(equivalently `f = toUnit ProjectiveLineBar ≫ η[A]`).

This is the pointed core of the `𝔾ₘ`-scaling shortcut: form `h := gmScalingP1 ≫ f`, feed it
to Cor 1.5 (`hom_additive_decomp_of_rigidity`) with `V = ProjectiveLineBar`, `W = Gm`, base
points `zeroPt`, `onePt`. The `W`-axis collapses by `gmScalingP1_collapse_at_zero`, leaving
`h = fst ≫ fV` (the relation `f(λx) = fV(x)`). Specialising at `x = 1` (via the canonical
inclusion `Gm ↪ ℙ¹` given by `λ ↦ σ×(1, λ) = λ`) and using density of `Gm ⊆ ℙ¹` plus
separatedness of `A` (via `ext_of_isDominant_of_isSeparated'`, the same Mathlib bridge
`rigidity_core` uses inline), we conclude `f = toUnit ℙ¹ ≫ (onePt ≫ fV)`. The basepoint
hypothesis then pins `onePt ≫ fV = η[A]`.

**Status (iter-167):** body fully refactored — all five in-line product/Proj `sorry`s have
been eliminated. Four of them (`GeometricallyIrreducible`, `LocallyOfFiniteType`, `IsReduced`
of the product, and `IsReduced (ProjectiveLineBar kbar).left`) ship from Lane A
(`AlgebraicJacobian.Genus0BaseObjects` instances `projGm_geomIrred`,
`projGm_locallyOfFiniteType`, `projGm_isReduced`, `projectiveLineBar_isReduced`) and resolve
by `infer_instance` in scope. The fifth — dominance of the canonical `Gm ↪ ℙ¹` map — is
exposed as the named top-level bridge `iotaGm_isDominant` above (a single `sorry` pending
Lane A's `gmScalingP1` body). The helper itself contains no `sorry`. -/
private theorem morphism_P1_to_grpScheme_const_aux
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A)
    (hf0 : ProjectiveLineBar.zeroPt kbar ≫ f = η[A]) :
    f = (1 : ProjectiveLineBar kbar ⟶ A) := by
  -- W-axis collapse via `gmScalingP1_collapse_at_zero`, precomposed with `onePt`:
  -- `lift zeroPt onePt ≫ gmScalingP1 = zeroPt`.
  have hcollapse :
      lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar) ≫ gmScalingP1 kbar
        = ProjectiveLineBar.zeroPt kbar := by
    have hbase := gmScalingP1_collapse_at_zero kbar
    -- Rewrite `lift zeroPt onePt = onePt ≫ lift (toUnit Gm ≫ zeroPt) (𝟙 Gm)`.
    have hreshape :
        lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
          = Gm.onePt kbar ≫
            lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) := by
      rw [comp_lift, Category.comp_id]
      congr 1
      rw [← Category.assoc,
        toUnit_unique (Gm.onePt kbar ≫ toUnit (Gm kbar)) (𝟙 _), Category.id_comp]
    rw [hreshape, Category.assoc, hbase, ← Category.assoc,
      toUnit_unique (Gm.onePt kbar ≫ toUnit (Gm kbar)) (𝟙 _), Category.id_comp]
  -- The Cor 1.5 basepoint hypothesis `lift v₀ w₀ ≫ (σ ≫ f) = η[A]`.
  have hcorhyp :
      lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
        ≫ (gmScalingP1 kbar ≫ f) = η[A] := by
    rw [← Category.assoc, hcollapse]; exact hf0
  -- Apply Cor 1.5.
  have key := hom_additive_decomp_of_rigidity
    (V := ProjectiveLineBar kbar) (W := Gm kbar)
    (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
    (gmScalingP1 kbar ≫ f) hcorhyp
  -- W-axis restriction: `lift (toUnit Gm ≫ zeroPt) (𝟙 Gm) ≫ σ ≫ f = (1 : Gm ⟶ A)`.
  have hfW :
      lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar))
        ≫ (gmScalingP1 kbar ≫ f) = (1 : Gm kbar ⟶ A) := by
    rw [← Category.assoc, gmScalingP1_collapse_at_zero, Category.assoc, hf0]
    exact Hom.one_def.symm
  -- `snd ≫ fW = snd ≫ 1 = 1` (using `toUnit` uniqueness).
  have hSndFW :
      snd (ProjectiveLineBar kbar) (Gm kbar)
        ≫ (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar))
          ≫ (gmScalingP1 kbar ≫ f))
        = (1 : ProjectiveLineBar kbar ⊗ Gm kbar ⟶ A) := by
    rw [hfW, Hom.one_def, ← Category.assoc]
    congr 1
    exact toUnit_unique _ _
  -- `key` now reads `σ ≫ f = fst ≫ fV` (after collapsing the W-axis to 1).
  rw [hSndFW, _root_.mul_one] at key
  -- Name the V-axis restriction `fV`.
  set fV : ProjectiveLineBar kbar ⟶ A :=
    lift (𝟙 (ProjectiveLineBar kbar)) (toUnit (ProjectiveLineBar kbar) ≫ Gm.onePt kbar)
      ≫ (gmScalingP1 kbar ≫ f) with hfVdef
  -- Precompose `key` with `gmInP1 := lift (toUnit Gm ≫ onePt) (𝟙 Gm) : Gm → ℙ¹ ⊗ Gm`
  -- ("λ ↦ (1, λ)"). The resulting morphism `ι := gmInP1 ≫ σ : Gm → ℙ¹` is the canonical
  -- inclusion `Gm ↪ ℙ¹` ("λ ↦ σ×(1, λ) = λ"); on its image, `f` is constant at `onePt ≫ fV`.
  set iotaGm : Gm kbar ⟶ ProjectiveLineBar kbar :=
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
      ≫ gmScalingP1 kbar with hιdef
  have hιf :
      iotaGm ≫ f = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
    calc iotaGm ≫ f
        = lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ (gmScalingP1 kbar ≫ f) := by rw [hιdef, Category.assoc]
      _ = lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ (fst (ProjectiveLineBar kbar) (Gm kbar) ≫ fV) := by rw [key]
      _ = (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ fst (ProjectiveLineBar kbar) (Gm kbar)) ≫ fV := by
          rw [Category.assoc]
      _ = (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) ≫ fV := by rw [lift_fst]
      _ = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
          rw [Category.assoc]
  -- Separatedness of the target `A` over `Spec k̄` in `OverClass.fromOver` form.
  haveI hAsep : IsSeparated A.hom := IsProper.toIsSeparated
  haveI : IsSeparated (A.left ↘ Spec (CommRingCat.of kbar)) := hAsep
  -- `IsReduced (ProjectiveLineBar kbar).left` and the product geom-irred / LOFT / IsReduced
  -- instances are all auto-resolved via Lane A's exports in `Genus0BaseObjects`
  -- (`projectiveLineBar_isReduced`, `projGm_geomIrred`, `projGm_locallyOfFiniteType`,
  -- `projGm_isReduced`). Dominance of `ι.left` is the only file-local bridge, cited
  -- explicitly via `iotaGm_isDominant` (the `set`-binding `hιdef` exposes `iotaGm.left`
  -- definitionally as `(lift _ _ ≫ gmScalingP1 kbar).left`).
  haveI hιDom : IsDominant iotaGm.left := iotaGm_isDominant
  -- Globalise: `ι ≫ f = ι ≫ (toUnit ℙ¹ ≫ (onePt ≫ fV))` gives, by dominance, `f = toUnit ℙ¹ ≫ c`.
  have hf_eq :
      f = toUnit (ProjectiveLineBar kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
    -- Promote the Over morphism equality from the underlying scheme equality.
    have hgoal :
        iotaGm ≫ f
          = iotaGm ≫ (toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.onePt kbar ≫ fV)) := by
      have hreshape :
          iotaGm ≫ (toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.onePt kbar ≫ fV))
            = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
        rw [← Category.assoc,
          toUnit_unique (iotaGm ≫ toUnit (ProjectiveLineBar kbar)) (toUnit (Gm kbar))]
      rw [hreshape, hιf]
    refine Over.OverMorphism.ext ?_
    refine ext_of_isDominant_of_isSeparated' (S := Spec (.of kbar))
      (X := (ProjectiveLineBar kbar).left) (Y := A.left)
      (f := f.left)
      (g := (toUnit (ProjectiveLineBar kbar) ≫
        (ProjectiveLineBar.onePt kbar ≫ fV)).left) iotaGm.left ?_
    rw [← Over.comp_left, ← Over.comp_left]
    exact congrArg Over.Hom.left hgoal
  -- Pin `onePt ≫ fV = η[A]` via the basepoint hypothesis `hf0`.
  have hc : ProjectiveLineBar.onePt kbar ≫ fV = η[A] := by
    have hcomp := hf0
    rw [hf_eq] at hcomp
    rw [← Category.assoc,
      toUnit_unique (ProjectiveLineBar.zeroPt kbar ≫ toUnit (ProjectiveLineBar kbar))
        (𝟙 _),
      Category.id_comp] at hcomp
    exact hcomp
  rw [hf_eq, hc, ← Hom.one_def]

/-- **A morphism `ℙ¹ → A` is constant.** Over an algebraically closed field `k̄`, every
morphism `f : ProjectiveLineBar kbar ⟶ A` from the projective line into an abelian variety
`A` (a smooth proper geometrically irreducible group scheme) is constant: it factors through
a single `k̄`-point `a₀ : 𝟙_ ⟶ A`, i.e. `f = toUnit ℙ¹ ≫ a₀`.

The single-curve base case of Milne's Proposition 3.10. **Route resolved iter-164: the
𝔾ₘ-scaling shortcut** — NO theorem of the cube, NO Milne Thm 3.2, NO `Hom(𝔾ₐ, A) = 0`,
char-general. The proof body proceeds by translating in the group `A` to reduce to the
basepoint case `zeroPt ≫ f = η[A]` (handled by the helper
`morphism_P1_to_grpScheme_const_aux`), then un-translating.

See blueprint `prop:morphism_P1_to_AV_constant`
(Milne, *Abelian Varieties*, Prop. 3.10).

**Status (iter-166):** body landed. Carries propagated `sorryAx` via the helper's residuals
(three product-instance Mathlib bridges + dominance of the canonical `Gm → ℙ¹` map). Lifts
to axiom-clean once those are discharged. -/
theorem morphism_P1_to_grpScheme_const
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A) :
    ∃ a₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ A,
      f = toUnit (ProjectiveLineBar kbar) ≫ a₀ := by
  -- Witness: `a₀ := zeroPt ≫ f` (the value of `f` at the scaling fixed point `0 ∈ ℙ¹`).
  refine ⟨ProjectiveLineBar.zeroPt kbar ≫ f, ?_⟩
  -- Translate: form `f' := f / (toUnit ℙ¹ ≫ a₀)` and apply the helper to `f'`.
  have hf' :
      (f / (toUnit (ProjectiveLineBar kbar) ≫ ProjectiveLineBar.zeroPt kbar ≫ f))
        = (1 : ProjectiveLineBar kbar ⟶ A) := by
    apply morphism_P1_to_grpScheme_const_aux
    -- Show `zeroPt ≫ (f / (toUnit ℙ¹ ≫ a₀)) = η[A]`.
    rw [GrpObj.comp_div]
    have hv :
        ProjectiveLineBar.zeroPt kbar ≫
            toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.zeroPt kbar ≫ f)
          = ProjectiveLineBar.zeroPt kbar ≫ f := by
      rw [← Category.assoc,
        toUnit_unique (ProjectiveLineBar.zeroPt kbar ≫ toUnit (ProjectiveLineBar kbar))
          (𝟙 _),
        Category.id_comp]
    rw [hv, div_self', Hom.one_def, toUnit_unique (toUnit _) (𝟙 _), Category.id_comp]
  -- Untranslate: `f / (toUnit ℙ¹ ≫ a₀) = 1` ⟺ `f = toUnit ℙ¹ ≫ a₀`.
  exact div_eq_one.mp hf'

/-- **A genus-`0` curve over `k̄` is isomorphic to `ℙ¹`.** Over an algebraically closed field
`k̄`, a smooth proper geometrically irreducible curve `C` with `genus C = 0` is isomorphic — in
`Over (Spec (.of kbar))` — to the concrete projective line `ProjectiveLineBar kbar`.

Hartshorne's Example IV.1.3.5 (Riemann–Roch). Its formalisation is a genuine sub-build:
Mathlib has no Riemann–Roch for curves; this is the dominant long pole flagged by the
iter-164 progress-critic.

See blueprint `prop:genusZero_curve_iso_P1`
(Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

**Status (iter-166):** signature refactored to the concrete `ProjectiveLineBar kbar`; body
remains `sorry` (RR bridge — iter-167+). -/
theorem genusZero_curve_iso_P1
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0) :
    Nonempty (C ≅ ProjectiveLineBar kbar) :=
  sorry

/-- **Headline: rigidity for a pointed genus-`0` curve.** Over an algebraically closed field
`k̄` (arbitrary characteristic — no `[CharZero kbar]`), let `C` be a smooth proper geometrically
irreducible curve with `genus C = 0` and `A` an abelian variety (smooth proper geom-irred group
scheme). Then every morphism `f : C ⟶ A` killing a `k̄`-point `p` (`p ≫ f = η[A]`) equals the
constant morphism at the identity, `f = toUnit C ≫ η[A]`.

This is the project's committed characteristic-free statement that `genusZeroWitness` consumes
(via the `k̄ → k` descent step hosted in `AlgebraicJacobian.Jacobian`). Its signature mirrors
`AlgebraicGeometry.rigidity_over_kbar` of `AlgebraicJacobian.RigidityKbar` **verbatim except**
the `[CharZero kbar]` instance is dropped. Combine `genusZero_curve_iso_P1` (`C ≅ ℙ¹`) with
`morphism_P1_to_grpScheme_const` (`ℙ¹ → A` constant) and pin the constant value to `η[A]` via
the pointed hypothesis. No `df = 0`, no Serre duality, no Picard representability.

**Status (iter-166):** body landed. Carries propagated `sorryAx` via `genusZero_curve_iso_P1`
(RR bridge, iter-167+) and `morphism_P1_to_grpScheme_const`'s helper residuals. Once the RR
bridge closes and the helper's product-instance + dominance sorries discharge, lifts to
axiom-clean. -/
theorem rigidity_genus0_curve_to_grpScheme
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : C ⟶ A)
    (p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C)
    (_hf : p ≫ f = η[A]) :
    f = (toUnit C ≫ η[A]) := by
  -- Transport `f` along `C ≅ ProjectiveLineBar kbar` to a morphism `g : ℙ¹ ⟶ A`.
  obtain ⟨φ⟩ := genusZero_curve_iso_P1 _hgenus
  set g : ProjectiveLineBar kbar ⟶ A := φ.inv ≫ f with hgdef
  -- `morphism_P1_to_grpScheme_const` gives `g = toUnit ℙ¹ ≫ a₀` for some `a₀`.
  obtain ⟨a₀, hga₀⟩ := morphism_P1_to_grpScheme_const g
  -- Pin `a₀ = η[A]` via the pointed hypothesis on `f`.
  have hpoint : (p ≫ φ.hom) ≫ g = η[A] := by
    rw [hgdef, Category.assoc, ← Category.assoc φ.hom, φ.hom_inv_id, Category.id_comp]
    exact _hf
  have hcst : a₀ = η[A] := by
    rw [hga₀, ← Category.assoc,
      toUnit_unique ((p ≫ φ.hom) ≫ toUnit (ProjectiveLineBar kbar)) (𝟙 _),
      Category.id_comp] at hpoint
    exact hpoint
  rw [hcst] at hga₀
  -- Back-transport: `f = φ.hom ≫ g = φ.hom ≫ toUnit ℙ¹ ≫ η[A] = toUnit C ≫ η[A]`.
  calc f
      = φ.hom ≫ φ.inv ≫ f := by
        rw [← Category.assoc, φ.hom_inv_id, Category.id_comp]
    _ = φ.hom ≫ g := by rw [hgdef]
    _ = φ.hom ≫ toUnit (ProjectiveLineBar kbar) ≫ η[A] := by rw [hga₀]
    _ = toUnit C ≫ η[A] := by
        rw [← Category.assoc,
          toUnit_unique (φ.hom ≫ toUnit (ProjectiveLineBar kbar)) (toUnit C)]


end AlgebraicGeometry
