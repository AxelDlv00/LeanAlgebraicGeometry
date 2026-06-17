/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.LineBundle

/-!
# The relative Picard functor

Phase C step 2 (per `STRATEGY.md`): the relative Picard functor of a curve
`C` over `Spec k`, packaged as a contravariant functor on schemes, plus the
(deferred) representability theorem whose closure jointly unblocks the four
`Jacobian.lean` sorries.

See `blueprint/src/chapters/Picard_Functor.tex`.

## Status (iteration 004 — refactor scaffold)

This file is a scaffold. The two declarations below are `sorry`. The iter-005
prover is responsible for filling **only the definition** of `PicardFunctor`
(the `representable` theorem is FGA-level and intentionally deferred — see the
forward-compatibility note in `Picard_Functor.tex`).

## Forward-compatibility note (`LineBundle` approximation)

`LineBundle` (per `Picard/LineBundle.lean`) is currently realised as the
global-sections approximation `CommRing.Pic Γ(X, ⊤)`. The relative Picard
functor built on top of this approximation gives smaller subgroups than the
true relative Picard functor on non-affine `S`. Closing `representable` on
top of this approximation would silently assert representability of the wrong
functor and is therefore a forbidden shortcut: keep it as `sorry`.

## Signature shape

The directive's sketch had `(C : Scheme.{u}) [C.Over (Spec (.of k))]`, but this
shape is inconvenient because Lean cannot infer the implicit `{k}` from
`C : Scheme` alone (typeclass inference for `[C.Over (Spec (.of k))]` gets
stuck on the metavariable `?k`). Following the formulation already used in
`Jacobian.lean`, we instead take `C : Over (Spec (.of k))`, i.e.\ a scheme
together with a chosen morphism to `Spec k` packaged as an object of the
over-category. This preserves the mathematical intent (a `k`-scheme) while
allowing `k` to be inferred from the type of `C`. See `task_results/refactor.md`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry.Scheme

/-- The relative Picard functor of `C` over `Spec k`:
    `S ↦ Pic(C ×_k S) / p_S^* Pic(S)`,
where `p_S : C ×_k S → S` is the projection. Functoriality in `S` is via base
change of the fiber product and the pull-back homomorphism on Picard groups
(`Pic.pullback`).

**Iteration 004 implementation.** This is the scaffolded signature; the iter-005
prover fills the body using `Limits.pullback` (fiber product of schemes),
`LineBundle`, `Pic.pullback`, and `QuotientGroup.mk` for the quotient. -/
noncomputable def PicardFunctor
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k))) :
    Scheme.{u}ᵒᵖ ⥤ Type u := sorry

/-- Representability of the relative Picard functor for a smooth, proper,
geometrically irreducible curve `C` over a field `k` (Grothendieck FGA, Mumford
*Abelian Varieties* §III.13). The connected component of the identity of the
representing group scheme is the Jacobian `Jac(C)`.

**Intentionally deferred.** This is FGA-level and not honestly closeable on
the global-sections-approximate `LineBundle`. The four `Jacobian.lean` sorries
all reduce to this theorem. Do not attempt to fill it in iter-005 — see the
file docstring and `Picard_Functor.tex` forward-compatibility note. -/
theorem PicardFunctor.representable
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    (PicardFunctor C).IsRepresentable := sorry

end AlgebraicGeometry.Scheme
