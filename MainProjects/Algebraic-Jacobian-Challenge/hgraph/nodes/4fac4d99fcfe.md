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
updated: '2026-07-29T13:43:15'
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
it is the point: it moves the residue out of dimension theory.

**RETRACTED (run 0067 r8), and this is the FOURTH framing of this leg to be wrong. The orbit
condition is not a gap that a descent argument can close: it is CONTRADICTORY for every curve
of genus `≥ 1`, so the two theorems below are VACUOUS exactly where the A.3 leg needs them.**

`Picard/HomogeneityOrbitCollapse.lean` proves
`Pic0.topologicalKrullDim_eq_zero_of_homogeneous`: the `htrans` hypothesis alone forces
`topologicalKrullDim Pic⁰_{C/k} = 0`, hence (with `hid`, `hreg`)
`Pic0.genus_eq_zero_of_homogeneous` — `genus C = 0`.

The error is visible in the paragraph above, in the phrase "over `k̄` it holds **for closed
points**". The hypothesis quantifies over **all** points of `Pic⁰`, and translations are
*isomorphisms of schemes*, hence homeomorphisms; the identity point is closed (it is the image
of a section of a morphism to `Spec k`, so a closed immersion's range). A homeomorphism carries
closed points to closed points, so `htrans` says every point of `Pic⁰` is closed — `T1` — and a
nonempty sober `T1` space has topological Krull dimension `0`. Nothing about `k` or the descent
question enters; the collapse is unconditional.

The corroboration was already in this project: the sibling irreducibility proof
(`identityComponent_irreducibleSpace_of_isAlgClosed`, `Picard/IdentityComponent.lean:866`)
translates through **closed** points only and then needs *Jacobson density* to "sweep up the
non-closed points". That extra step is exactly what a `k`-rational orbit cannot supply.

So the `≤` half's uniform cotangent bound is still owed, and it needs a route that reaches
**non-closed** points — transport along a translation by a point valued in an extension of `k`,
or a generic-point/density argument in the shape the sibling proof uses. What the two theorems
below establish remains true and is worth keeping as the *shape* of the reduction; what is
withdrawn is the claim that their hypothesis set is satisfiable for `g ≥ 1`, and with it the
"one point suffices" reading recorded at
`Picard/EmbeddingDimensionBound.lean`, `Picard/Pic0Dimension.lean` and
`Picard/IdentityComponent.lean`. The cotangent-invariance theorems above
(`finrank_cotangentSpace_eq_of_ringEquiv`, `finrank_cotangentSpace_stalk_eq_of_isIso`) are
about a single isomorphism and are untouched. -/

namespace Scheme.Pic0

open CategoryTheory.GrpObj PicScheme