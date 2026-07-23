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


  The degree map is a group homomorphism for the additive structure on

  `Pic_{C/k}(k)` (tensor product on `L`) and the standard `(ℤ, +)`. The full

  group-homomorphism refinement / functoriality in `k` lives as a follow-up

  lemma in iter-186+; the file-skeleton pins only the underlying function.


  iter-186+: the body extracts the representing invertible sheaf from

  `(PicScheme.representable C)`, forms its Hilbert polynomial via the project''s

  Hilbert-polynomial machinery (sibling `Picard/QuotScheme.lean`), and returns

  the leading coefficient. For the iter-185 file-skeleton the body is a typed

  `sorry`.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.PicScheme.degree
type: lean
updated: '2026-07-24T03:02:11'
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

/- `Pic0Scheme.isAbelianVariety` (blueprint pin
`thm:pic_zero_is_abelian_variety`) MOVED (run 0008, T5) to sibling
`Picard/Pic0AbelianVariety.lean`, where it is assembled sorry-free from the
per-conjunct theorems `Pic0.proper` / `Pic0.smooth` /
`Pic0.geometricallyIrreducible` / `Pic0.grpObj` of that chapter. -/