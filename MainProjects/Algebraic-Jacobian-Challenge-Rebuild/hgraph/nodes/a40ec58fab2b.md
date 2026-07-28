---
author: sync
content_type: class
created: '2026-07-24T17:02:46'
decl: is
file: AlgebraicJacobian/Tangent/TwoChartRepresentable.lean
generated: lean
lean_status: lean_ok
title: is
type: lean
updated: '2026-07-29T06:15:35'
---
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