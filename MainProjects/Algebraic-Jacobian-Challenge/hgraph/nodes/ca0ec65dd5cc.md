---
author: sync
content_type: instance
created: '2026-07-29T01:14:28'
decl: '`FixedPoints.subring`/`subalgebra`'
file: AlgebraicJacobian/Albanese/SymPowTensorAction.lean
generated: lean
lean_status: lean_ok
stale: true
title: '`FixedPoints.subring`/`subalgebra`'
type: lean
updated: '2026-07-29T11:05:50'
---
instance `FixedPoints.subring`/`subalgebra` cannot even be *stated* at the tensor power, so
Milne's formula was not expressible in the tree.

## Main results

* `PiTensorProduct.permAlgHom` — factor permutation as an `R`-**algebra** homomorphism of
  `⨂[R] _ : ι, A`, built from `liftAlgHom` on the reindexed `tprod`.
* `PiTensorProduct.permAlgHom_comp` — the composition law, and note its **variance**:
  `permAlgHom σ ∘ permAlgHom τ = permAlgHom (τ * σ)`, an *anti*-homomorphism.
* `PiTensorProduct.permAlgEquiv` — hence the algebra automorphism.
* `PiTensorProduct.permMulSemiringAction` — the left `S_n`-action, taking `σ` to
  `permAlgHom σ⁻¹`. The inverse is forced by the previous item, exactly as
  `SymPowColimit.permEnd` needs `σ⁻¹` on the geometric side.
* `PiTensorProduct.permSMulCommClass` — the action commutes with scalars (one `map_smul`).
  `FixedPoints.subalgebra` needs this *in addition to* the `MulSemiringAction`, and mathlib
  supplies neither at a tensor power; it is also what makes the action a diagram over the
  base ring (`Albanese/SymPowInvariantsUnder.lean`).
* `symTensorPowSubalgebra R A` — **Milne's `(A^{⊗ n})^{S_n}`**, as an `R`-subalgebra, with
  `mem_symTensorPowSubalgebra_iff` and `symTensorPowSubalgebra_toSubring`. The universal
  property is *not* restated here as an algebra statement; it arrives in categorical form
  through the next item, which is where the limit/colimit property is proved.
* `hasLimit_actionDiagram_symTensorPow` / `hasColimit_actionDiagram_op_symTensorPow` — the
  same fact as a limit in `CommRingCat` and a colimit in `CommRingCatᵒᵖ`, obtained by
  instantiating `SymPowInvariants`' general theorems at this action. This is the first
  place in the tree where Milne's affine carrier appears as a named object with a proved
  quotient property.

## Characteristic-free, and no finiteness on the ring

Nothing here averages over the group, so no `n!` is inverted and the statements hold in
every characteristic — which matters, since `Sym^g C` is wanted over an arbitrary
algebraically closed `k̄` and `g!` may vanish there.

Where finiteness of `ι` *is* needed, precisely (an earlier version of this paragraph said the
action needs none, which is false — `permMulSemiringAction ℤ (ι := ℕ) ℤ` fails to synthesize
`Finite ℕ`): `permAlgHom`, `symTensorPowSubalgebra`, `mem_symTensorPowSubalgebra_iff` and
`tprod_const_mem_symTensorPowSubalgebra` need none; `permAlgHom_comp`, `permAlgHom_one`,
`permAlgEquiv` and hence the **action** do, because `PiTensorProduct.algHom_ext` (extensionality
over `singleAlgHom`) requires `[Finite ι]`. `Fin n` in particular enters only when specialising
to Milne's `n`-fold power.

## Scope — what this is not

This is **affine commutative algebra**. It does not construct `Sym^n C` for a curve, and it
does not close `SymPowInvariants` §4's other two items:

* the curve case still needs `HasColimit (permDiagram C g)` in `Over (Spec k̄)`, i.e. the
  gluing (`Albanese/SymPowColimit.lean` §6);
* the **category** caveat stands. `SymPowColimit`'s affine inhabitation statement
  `symPowData_affineAlgebra` lives in `(Under k)ᵒᵖ`; everything here, like
  `SymPowInvariants`, lives in `CommRingCat`/`CommRingCatᵒᵖ` with no base ring in the
  *category*, even though the ring statements are `R`-algebra statements. Bridging those
  two remains open, so no declaration in `SymPowColimit.lean` consumes anything below.

Read this file, then, as: *Milne's affine carrier is now nameable and its universal
property is proved*, not as *Milne III.3 Proposition 3.1 is formalised*.

## References

Milne, *Abelian Varieties*, §III.3 Proposition 3.1, p. 94 (the symmetric power as
`Spec (A^{⊗ n})^{S_n}` glued over an affine cover). Mumford, *Abelian Varieties*, §II.7.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits TensorProduct

namespace PiTensorProduct

section Action

variable (R : Type u) [CommRing R] {ι : Type v} (A : Type u) [CommRing A] [Algebra R A]

/-! ## §1. Factor permutation as an algebra homomorphism

The multilinear map `x ↦ tprod R (x ∘ e)` is unital and multiplicative on the nose, since
`(x * y) ∘ e = (x ∘ e) * (y ∘ e)` pointwise, so `liftAlgHom` applies with no side
conditions to discharge beyond those two equations. -/