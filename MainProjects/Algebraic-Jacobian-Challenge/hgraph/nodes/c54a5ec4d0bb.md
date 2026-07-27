---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.PicScheme.degree
docstring: 'The **degree map** `Pic_{C/k}(k) → ℤ`.


  Sends a `k`-point `λ ∈ Pic_{C/k}(k)` --- a morphism

  `Spec k ⟶ (PicScheme C).left` --- to the leading coefficient of the

  Hilbert polynomial of a representing invertible sheaf `L` on `C` (relative

  to a fixed degree-one polarisation `O_C(1)`). By Riemann--Roch,

  `χ(C, L ⊗ O_C(n)) = n · deg L + 1 - g`, so the degree is the leading

  coefficient of `Φ_L(n)`, well-defined on the isomorphism class `[L]` and on

  the `k`-point `λ` (because `PicScheme C` represents the étale-sheafified

  relative Picard functor).


  The degree map is a group homomorphism from the additive structure on

  `Pic_{C/k}(k)` (tensor product on `L`) to `(ℤ, +)`; only the underlying

  function is stated here, the homomorphism property and the functoriality in

  `k` being left to separate lemmas.


  The construction is an open obligation: the value should be obtained by

  extracting a representing invertible sheaf from `PicScheme.representable C`,

  forming its Hilbert polynomial with the machinery of the sibling file

  `Picard/QuotScheme.lean`, and taking the leading coefficient. The body is

  currently `sorry`.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.PicScheme.degree
type: lean
updated: '2026-07-27T12:33:55'
---
noncomputable def degree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ :=
  sorry

end PicScheme

/-! ## §4. `Pic⁰_{C/k}` is an abelian variety

The terminal statement of the chapter identifies `Pic⁰_{C/k}` with an
abelian variety of dimension `g(C)` --- the Jacobian variety of `C`. In
this project, "abelian variety" is the conjunction of the four properties
`[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`
threaded through `AlgebraicJacobian.AbelianVarietyRigidity` and consumed by
`AlgebraicJacobian.Albanese.AlbaneseUP`.

Blueprint reference: `thm:pic_zero_is_abelian_variety` (Kleiman §5
Ex.~`ex:jac` + Rmk.~`rmk:Jac`; cf. Milne §I.1, Rmk. III.1.4(e)). -/

namespace Pic0Scheme

/- The abelian-variety identification `Pic0Scheme.isAbelianVariety`
(blueprint `thm:pic_zero_is_abelian_variety`) lives in the sibling file
`Picard/Pic0AbelianVariety.lean`, where it is assembled from the per-conjunct
theorems `Pic0.proper` / `Pic0.smooth` / `Pic0.geometricallyIrreducible` /
`Pic0.grpObj` of that chapter. -/