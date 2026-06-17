/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Rigidity

/-!
# Rigidity over `k̄`: morphisms `ℙ¹_{k̄} → A_{k̄}` are constant

The keystone classical input for the M2.a sub-step of the genus-0
Albanese-witness argument (Jacobian.tex § C.2): morphisms from the
projective line `ℙ¹_{k̄}` to a smooth proper geometrically irreducible
group scheme `A_{k̄}` over an algebraically closed field `k̄` that hit
the identity at a `k̄`-rational point are the constant morphism at the
identity. Mumford, *Abelian Varieties*, Chapter~II~§4.

See `blueprint/src/chapters/RigidityKbar.tex`.

## Status (iter-126 scaffold)

The named declaration `rigidity_over_kbar` is scaffolded with a single
`sorry` body. The body closure is gated on the shared cotangent-
vanishing Mathlib pile (`analogies/cotangent-vanishing-pile.md`,
iter-129+) per STRATEGY.md § M2.a + § M2.d-alt. The proof decomposition
into sub-steps C.2.b (reduction to `Scheme.Over.ext_of_eqOnOpen`),
C.2.c (image-dimension dichotomy), C.2.d (the cotangent-vanishing
keystone), and C.2.e (set-to-scheme promotion) is documented in
`RigidityKbar.tex` § "Proof decomposition".

## Encoding choice (iter-126 refactor agent note)

The directive offered two encodings of the source `ℙ¹_{k̄}`: a literal
`Over.mk (Spec.map (CommRingCat.ofHom MvPolynomial.C))` (Option A) or
an abstract "smooth proper geometrically irreducible curve over `k̄` of
genus 0" (Option B). The literal Option A is mathematically wrong as
written — `Spec(MvPolynomial σ kbar) ⟶ Spec kbar` is the affine, not
projective, line — and Mathlib `b80f227` has no `ProjectiveSpace n S`
construction packaged as a `Scheme` (`AlgebraicGeometry.Proj` is the
general `Proj` of a graded ring, not specialised). The refactor agent
took the directive-recommended Option B: the source is a smooth proper
geometrically irreducible `Over (Spec (.of kbar))` of relative dimension
`1` with `genus C = 0`. This is what the proof decomposition C.2.c–C.2.d
actually consume (the keystone uses the curve's `H¹(·, 𝒪) = 0` ↔
`genus = 0` characterisation, not a literal `ℙ¹` API).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {kbar : Type u} [Field kbar]

/-- Rigidity for morphisms `C ⟶ A` from a genus-`0` curve over an
algebraically closed field `k̄` (encoding `ℙ¹_{k̄}` via the abstract
smooth-proper-geometrically-irreducible-of-relative-dimension-`1`-with-
`genus = 0` characterisation): every morphism from such a curve to a
smooth proper geometrically irreducible group scheme `A` over `k̄`
that hits the identity at a `k̄`-rational point is the constant
morphism at the identity.

This is the keystone classical input for the M2.a sub-step of the
genus-0 Albanese-witness argument. Mumford, *Abelian Varieties*,
Chapter~II~§4.

**Status**: iter-126 scaffold — body is a single `sorry`. The closure
(C.2.b reduction via `Scheme.Over.ext_of_eqOnOpen` + C.2.c image-
dimension dichotomy + C.2.d cotangent-vanishing keystone) is gated on
the shared cotangent-vanishing Mathlib pile (iter-129+). See
`blueprint/src/chapters/RigidityKbar.tex`. -/
theorem rigidity_over_kbar
    [IsAlgClosed kbar] [CharZero kbar]
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
    f = (toUnit C ≫ η[A]) :=
  sorry

end AlgebraicGeometry
