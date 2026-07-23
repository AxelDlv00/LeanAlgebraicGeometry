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
lean_status: sorry
title: AlgebraicGeometry.Scheme.PicSharp.relNeg
type: lean
updated: '2026-07-24T03:02:11'
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
relation by `π_T^* Pic(T)`. (iter-121 correction of the earlier false
"`= Pic(C ×_S T) / π_T^* Pic(T)`" docstring: this is the absolute Picard
group, the additive mirror of `picCommGroup`; the RELATIVE quotient
`Pic(C ×_S T) / π_T^* Pic(T)` that `lem:rel_pic_sharp_groupoid` names is
`PicSharp.addCommGroup_via_tensorObj` on `Quotient (relPicSetoid πC πT)`
below.)

It carries a canonical abelian-group structure: addition is the descent of
tensor product `[L] + [L'] := [L ⊗ L']`, the zero element is the class
`[O_{C ×_S T}]`, and the inverse is `-[L] := [L⁻¹]` (the dual line
bundle). This instance is retained as a legitimate helper (the absolute
group of Step 1), consumed by the relative construction below.

iter-247 state: this instance now has a **real, sorry-free body**.
A.1.b's `LineBundle.OnProduct` carrier was concretised in
`LineBundlePullback.lean` (iter-188) as
`{ M : (pullback πC πT).Modules // IsLocallyTrivial M }`, and the
tensor-product group law is built directly from the upstream substrate
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
(`Modules.tensorObj`, `Modules.tensorObjOnProduct`, the coherence isos
`Modules.tensorObj_{assoc_iso,left_unitor,right_unitor,braiding}`) —
not from a `Scheme.Modules` monoidal-category instance.
`neg`/`neg_add_cancel` consume the now sorry-free
`Modules.exists_tensorObj_inverse` (`TensorObjSubstrate.lean:670`), the
reverse bridge `IsLocallyTrivial ⟹ IsInvertible`. There is no
file-local `addCommGroup` sorry and no Mathlib monoidal-upgrade gate
(cf. `LineBundlePullback.lean` L344--L346 for the historical note). -/
-- iter-247 Lane RPF: the real tensor-product Picard group on the iso-class
-- quotient (additive mirror of `picCommGroup`), now built from DIRECT citations of
-- the upstream substrate (`Modules.tensorObj_assoc_iso`, the unitors, the braiding,
-- `Modules.tensorObjOnProduct`, `Modules.exists_tensorObj_inverse`); the iter-246
-- local pure-Mathlib copies were deleted once the import cycle was broken. The
-- operation `relAdd` (well-defined via `Modules.tensorObjIsoOfIso`) and the axioms
-- `add_comm`/`zero_add`/`add_zero`/`add_assoc` are fully `sorry`-free; `zero` uses
-- the proven `isLocallyTrivial_unit`. `neg`/`neg_add_cancel` consume the now
-- sorry-free `Modules.exists_tensorObj_inverse` (the reverse bridge
-- `IsLocallyTrivial ⟹ IsInvertible`, `TensorObjSubstrate.lean:672`), so the whole
-- instance is `sorry`-free.
-- `nsmul`/`zsmul` carry no field default in `AddMonoid`/`SubNegMonoid`
-- (`Mathlib/Algebra/Group/Defs.lean:641`), and the canonical `nsmulRec`/`zsmulRec`
-- need `Zero`/`Add`/`Neg` instances that are not yet in scope mid-structure; we
-- supply them via `letI` so `nsmulRec`/`zsmulRec` elaborate (standard idiom).