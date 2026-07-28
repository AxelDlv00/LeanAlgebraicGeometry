---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.PicSharp.relNeg
docstring: 'Descended negation on the relative Picard quotient: `-[L] := [Linv]` for
  the

  inverse witness of `Modules.exists_tensorObj_inverse`, well-defined by

  `pInverseUnique`. Mirror of `picInv`.'
file: AlgebraicJacobian/Picard/RelPicFunctor.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.PicSharp.relNeg
type: lean
updated: '2026-07-28T13:22:16'
---
private noncomputable def relNeg {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S} :
    Quotient (RelPicPresheaf.preimage_subgroup πC πT) →
      Quotient (RelPicPresheaf.preimage_subgroup πC πT) :=
  Quotient.lift
    (fun L => Quotient.mk _
      (⟨Classical.choose (Modules.exists_tensorObj_inverse L.isLocallyTrivial),
        (Classical.choose_spec (Modules.exists_tensorObj_inverse L.isLocallyTrivial)).1⟩ :
        LineBundle.OnProduct πC πT))
    (by
      rintro L M ⟨e⟩
      refine Quotient.sound ?_
      have h1 :=
        (Classical.choose_spec (Modules.exists_tensorObj_inverse L.isLocallyTrivial)).2.some
      have h2 := Modules.tensorObjIsoOfIso e (Iso.refl _) ≪≫
        (Classical.choose_spec (Modules.exists_tensorObj_inverse M.isLocallyTrivial)).2.some
      exact pInverseUnique h1 h2)

/-- **Abelian-group instance on the ABSOLUTE Picard group** `Pic(C ×_S T)`.

For a base scheme `S`, a curve-side morphism `πC : C ⟶ S`, and a test
object `πT : T ⟶ S`, the quotient set
```
Quotient (RelPicPresheaf.preimage_subgroup πC πT)  =  Pic(C ×_S T)
```
is the set of **iso-classes** of locally-trivial line bundles on
`C ×_S T` — the carrier setoid `RelPicPresheaf.preimage_subgroup` is the
iso-class relation `Nonempty (L.carrier ≅ L'.carrier)`, NOT the coset
relation by `π_T^* Pic(T)`. So this is the absolute Picard group, the
additive mirror of `picCommGroup`; the RELATIVE quotient
`Pic(C ×_S T) / π_T^* Pic(T)` that `lem:rel_pic_sharp_groupoid` names is
`PicSharp.addCommGroup_via_tensorObj` on `Quotient (relPicSetoid πC πT)`
below.

It carries a canonical abelian-group structure: addition is the descent of
tensor product `[L] + [L'] := [L ⊗ L']`, the zero element is the class
`[O_{C ×_S T}]`, and the inverse is `-[L] := [L⁻¹]` (the dual line
bundle). The absolute group is consumed by the relative construction below.

The carrier `LineBundle.OnProduct` is `{ M : (pullback πC πT).Modules // IsLocallyTrivial M }`
(`LineBundlePullback.lean`), and the tensor-product group law is built directly from the
substrate of `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (`Modules.tensorObj`,
`Modules.tensorObjOnProduct`, the coherence isos
`Modules.tensorObj_{assoc_iso,left_unitor,right_unitor,braiding}`) — not from a
`Scheme.Modules` monoidal-category instance. `neg`/`neg_add_cancel` use
`Modules.exists_tensorObj_inverse`, the reverse bridge
`IsLocallyTrivial ⟹ IsInvertible`. -/
-- `nsmul`/`zsmul` carry no field default in `AddMonoid`/`SubNegMonoid`
-- (`Mathlib/Algebra/Group/Defs.lean:641`), and the canonical `nsmulRec`/`zsmulRec`
-- need `Zero`/`Add`/`Neg` instances that are not yet in scope mid-structure; we
-- supply them via `letI` so `nsmulRec`/`zsmulRec` elaborate (standard idiom).