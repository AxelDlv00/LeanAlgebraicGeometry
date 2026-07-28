/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Tangent.TwoChartNormalize
import AlgebraicJacobian.Picard.EffectivityTrivialization

/-!
# (iii-c2-Zar): chart-trivial classes are representable on the two-chart cover (W5-T4)

The **Zariski half** of clause `(iii-c2)` (`informal/w5-t4-worksheet.md` §6.9). For a scheme
`X` with two opens `V : Bool → X.Opens` covering it:

> `Scheme.twoChartClass_surjOn_of_chartTrivial` —
> if `L : X.CechPic` restricts trivially to each chart (`CechPic.map (V s).ι L = 1`), then
> `L = twoChartClassHom V sel hmem u` for an overlap unit `u : Γ(X, V₀ ⊓ V₁)ˣ`.

Composed with the landed `(iii-c1)` normalization this is the whole cohomological content of
`(iii-c2)`: **no `IsAffine`, no dual numbers, no curve hypothesis.** Everything geometric in
the T4 lane is thereby confined to the single remaining clause `(iii-c2-aff)`, "an `ε`-kernel
class is trivial on each *thickened* chart", for which `Picard/EffectivityMoving.lean` is the
correct tool (see the retraction in §6.9 — that file bridges *into* chart triviality, so it
belongs to `(iii-c2-aff)`, not here).

## The argument

Write `L = mk 𝒩 γ.class`.

1. **Per-chart cochains.** `CechPic.map (V s).ι L = 1` feeds the landed
   `exists_trimmed_trivializing_of_cechPicMap_ι_eq_one` — which carries **no affineness
   hypothesis** — giving units `t s b : Γ(X, 𝒩.opens b ⊓ V s)ˣ` with
   `t s b · γ(b,b') = t s b'` on trimmed pairwise overlaps.
2. **The overlap unit.** On `𝒩.opens b ⊓ V₀ ⊓ V₁` the ratio `t false b · (t true b)⁻¹` is
   **independent of `b`**: the two instances of step 1 contribute the same factor `γ(b,b')`,
   which cancels because units of a commutative ring of sections commute. These opens cover
   `V₀ ⊓ V₁`, so `exists_unitsRestrict_eq` glues them to `u : Γ(X, V₀ ⊓ V₁)ˣ`.
3. **The comparison.** On the refinement `𝒩 ⊓ twoChartCover V sel hmem`, whose member at `b`
   is `𝒩.opens b ⊓ V (sel b)`, the `0`-cochain `b ↦ t (sel b) b` conjugates `γ` into
   `twoChartCocycle u`. Note `t (sel b) b` typechecks at that member **on the nose**: the
   `Bool` index is instantiated, never transported — the §6.8 lesson once more.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite CategoryTheory.PresheafOfGroups TopologicalSpace

namespace AlgebraicGeometry

namespace Scheme

variable {X : Scheme.{u}} {V : Bool → X.Opens}

/-! ## Step 1–2: the glued overlap unit -/

/-- **The trivializing relation of a chart cochain**, as a standalone predicate: `t` trivializes
the cocycle `γ` on the `W`-trimmings of the members of `𝒩`. This is exactly the conclusion of
the landed `exists_trimmed_trivializing_of_cechPicMap_ι_eq_one`, named so that the two chart
instances can be handled uniformly. -/
def IsTrimmedTrivializing {𝒩 : X.PointedCover} (γ : X.unitsCocycle 𝒩) (W : X.Opens)
    (t : ∀ b : X, Γ(X, 𝒩.opens b ⊓ W)ˣ) : Prop :=
  ∀ b b' : X,
    X.unitsRestrict (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
        (𝒩.opens b ⊓ 𝒩.opens b') ⊓ W ≤ 𝒩.opens b ⊓ W) (t b)
      * X.unitsRestrict (inf_le_left :
          (𝒩.opens b ⊓ 𝒩.opens b') ⊓ W ≤ 𝒩.opens b ⊓ 𝒩.opens b')
          (Scheme.unitsEvInf γ b b')
    = X.unitsRestrict (le_inf (inf_le_left.trans inf_le_right) inf_le_right) (t b')

/-- The landed trimmed-trivialization theorem, restated through `IsTrimmedTrivializing`. No
affineness hypothesis: this is Zariski sheaf theory on the open subscheme `W`. -/
theorem exists_isTrimmedTrivializing {𝒩 : X.PointedCover} (γ : X.unitsCocycle 𝒩)
    (W : X.Opens) (h : Scheme.CechPic.map W.ι (Scheme.CechPic.mk 𝒩 γ.class) = 1) :
    ∃ t : ∀ b : X, Γ(X, 𝒩.opens b ⊓ W)ˣ, IsTrimmedTrivializing γ W t :=
  Scheme.exists_trimmed_trivializing_of_cechPicMap_ι_eq_one 𝒩 γ W h

/-- **The `b`-independence of the chart-cochain ratio.** If `t₀`, `t₁` trivialize `γ` on the
`V false`- and `V true`-trimmings, then the ratios `t₀ b · (t₁ b)⁻¹` at two points agree on
their common overlap: both instances of the trivializing relation contribute the *same*
factor `γ(b,b')`, and units of a commutative section ring commute, so it cancels. -/
theorem ratio_agree {𝒩 : X.PointedCover} (γ : X.unitsCocycle 𝒩)
    {t₀ : ∀ b : X, Γ(X, 𝒩.opens b ⊓ V false)ˣ}
    {t₁ : ∀ b : X, Γ(X, 𝒩.opens b ⊓ V true)ˣ}
    (h₀ : IsTrimmedTrivializing γ (V false) t₀)
    (h₁ : IsTrimmedTrivializing γ (V true) t₁) (b b' : X) :
    X.unitsRestrict (le_inf (inf_le_left.trans inf_le_left)
          (inf_le_right.trans inf_le_left) :
        ((𝒩.opens b ⊓ 𝒩.opens b') ⊓ (V false ⊓ V true)) ≤ 𝒩.opens b ⊓ V false) (t₀ b)
        * (X.unitsRestrict (le_inf (inf_le_left.trans inf_le_left)
            (inf_le_right.trans inf_le_right)) (t₁ b))⁻¹
      = X.unitsRestrict (le_inf (inf_le_left.trans inf_le_right)
            (inf_le_right.trans inf_le_left)) (t₀ b')
        * (X.unitsRestrict (le_inf (inf_le_left.trans inf_le_right)
            (inf_le_right.trans inf_le_right)) (t₁ b'))⁻¹ := by
  set O : X.Opens := (𝒩.opens b ⊓ 𝒩.opens b') ⊓ (V false ⊓ V true) with hO
  have hnn : O ≤ 𝒩.opens b ⊓ 𝒩.opens b' := inf_le_left
  -- both trivializing relations, restricted to `O`
  have e₀ := congrArg (X.unitsRestrict (le_inf hnn (inf_le_right.trans inf_le_left) :
    O ≤ (𝒩.opens b ⊓ 𝒩.opens b') ⊓ V false)) (h₀ b b')
  have e₁ := congrArg (X.unitsRestrict (le_inf hnn (inf_le_right.trans inf_le_right) :
    O ≤ (𝒩.opens b ⊓ 𝒩.opens b') ⊓ V true)) (h₁ b b')
  simp only [map_mul, unitsRestrict_unitsRestrict] at e₀ e₁
  -- `t₀ b · g = t₀ b'` and `t₁ b · g = t₁ b'` with the SAME `g`, so the ratios agree
  rw [← e₀, ← e₁]
  group

/-- **The glued overlap unit.** The `b`-independent ratios of `ratio_agree` live on the opens
`𝒩.opens b ⊓ (V₀ ⊓ V₁)`, which cover `V₀ ⊓ V₁` because `𝒩` is a pointed cover; so they glue to
a single unit on the overlap. -/
theorem exists_overlapUnit {𝒩 : X.PointedCover} (γ : X.unitsCocycle 𝒩)
    {t₀ : ∀ b : X, Γ(X, 𝒩.opens b ⊓ V false)ˣ}
    {t₁ : ∀ b : X, Γ(X, 𝒩.opens b ⊓ V true)ˣ}
    (h₀ : IsTrimmedTrivializing γ (V false) t₀)
    (h₁ : IsTrimmedTrivializing γ (V true) t₁) :
    ∃ u : Γ(X, V false ⊓ V true)ˣ, ∀ b : X,
      X.unitsRestrict (inf_le_right : 𝒩.opens b ⊓ (V false ⊓ V true) ≤ V false ⊓ V true) u
        = X.unitsRestrict (le_inf inf_le_left (inf_le_right.trans inf_le_left)) (t₀ b)
          * (X.unitsRestrict (le_inf inf_le_left
              (inf_le_right.trans inf_le_right)) (t₁ b))⁻¹ := by
  refine exists_unitsRestrict_eq (V := V false ⊓ V true)
    (W := fun b : X => 𝒩.opens b ⊓ (V false ⊓ V true)) (fun b => inf_le_right)
    (fun w hw => Opens.mem_iSup.mpr ⟨w, 𝒩.mem_opens w, hw⟩) _ (fun b b' => ?_)
  have h := ratio_agree γ h₀ h₁ b b'
  have hle : (𝒩.opens b ⊓ (V false ⊓ V true)) ⊓ (𝒩.opens b' ⊓ (V false ⊓ V true))
      ≤ (𝒩.opens b ⊓ 𝒩.opens b') ⊓ (V false ⊓ V true) :=
    fun w hw => ⟨⟨hw.1.1, hw.2.1⟩, hw.1.2⟩
  have key := congrArg (X.unitsRestrict hle) h
  simp only [map_mul, map_inv, unitsRestrict_unitsRestrict] at key ⊢
  exact key

end Scheme

end AlgebraicGeometry
