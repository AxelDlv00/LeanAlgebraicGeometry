---
author: sync
content_type: theorem
created: '2026-07-29T05:21:16'
decl: AlgebraicGeometry.finrank_cotangentSpace_stalk_eq_of_isIso
docstring: '**The cotangent dimension at `f x` equals the one at `x`, for `f` an isomorphism
  of

  schemes.** The stalk map of an isomorphism is an isomorphism of rings, so this is

  `finrank_cotangentSpace_eq_of_ringEquiv` at `f.stalkMap x`.'
file: AlgebraicJacobian/Picard/GroupSchemeHomogeneity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finrank_cotangentSpace_stalk_eq_of_isIso
type: lean
updated: '2026-07-29T05:21:16'
---
theorem finrank_cotangentSpace_stalk_eq_of_isIso {X Y : Scheme.{u}} (f : X ⟶ Y) [IsIso f]
    (x : X) [IsLocalRing (X.presheaf.stalk x)] [IsLocalRing (Y.presheaf.stalk (f.base x))]
    [IsNoetherianRing (X.presheaf.stalk x)]
    [IsNoetherianRing (Y.presheaf.stalk (f.base x))] :
    Module.finrank (IsLocalRing.ResidueField (Y.presheaf.stalk (f.base x)))
        (IsLocalRing.CotangentSpace (Y.presheaf.stalk (f.base x)))
      = Module.finrank (IsLocalRing.ResidueField (X.presheaf.stalk x))
        (IsLocalRing.CotangentSpace (X.presheaf.stalk x)) :=
  finrank_cotangentSpace_eq_of_ringEquiv ((asIso (f.stalkMap x)).commRingCatIsoToRingEquiv)

/-! ### The homogeneity reduction for `Pic⁰_{C/k}`

What the two theorems above buy the dimension chapter. The `≤` half of `dim Pic⁰ = g` needs
```
∀ z, dim_{κ(z)} (m_z / m_z²) ≤ g
```
(`Pic0.topologicalKrullDim_le_genus_of_forall_finrank_cotangentSpace_le`). Since `Pic⁰` is a
group scheme, the translations are automorphisms of the underlying scheme, so this uniform
statement follows from the bound at **one** point together with the statement that every point
is a translate of it. The theorem below is that reduction, stated with the orbit condition as
a hypothesis so that what remains open is visible and is a statement about *points*.

Why the hypothesis is phrased with an existential over `Over S`-sections rather than "the
translations act transitively": the translations available here are indexed by sections
`𝟙_ (Over (Spec k)) ⟶ Pic0Scheme C`, i.e. by `k`-rational points. Over a non-closed field a
scheme has points whose residue field is a proper extension of `k`, and those are *not* reached
by a `k`-rational translation. So the hypothesis is exactly the gap, and it is not a
formality — over `k̄` it holds for closed points, in general it is a descent question. Naming
it is the point: it moves the residue out of dimension theory. -/

namespace Scheme.Pic0

open CategoryTheory.GrpObj PicScheme