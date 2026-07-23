---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Grassmannian.freeCompare
docstring: '**Comparison with the absolute Grassmannian** for the free module: the

  relative Grassmannian functor of `O_S^r` is naturally isomorphic to the merged

  absolute Grassmannian functor `Grass(r, d)` evaluated on underlying schemes.

  Components are `freeCompareEquiv`; naturality is

  `freeCompare_naturality_core`.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.freeCompare
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def freeCompare (d r : ℕ) :
    Scheme.Grassmannian (SheafOfModules.free (R := S.ringCatSheaf) (Fin r)) d ≅
      (Over.forget S).op ⋙ AlgebraicGeometry.Grassmannian.functor d r :=
  NatIso.ofComponents
    (fun T => Equiv.toIso (freeCompareEquiv d r T.unop))
    (fun {T T'} ψ => by
      ext z
      induction z using Quotient.ind with
      | _ x =>
        change Quotient.mk _ (Scheme.LocallyFreeQuotient.toRankQuotient
            (Scheme.LocallyFreeQuotient.pullbackAlong ψ.unop x))
          = Quotient.mk _ (AlgebraicGeometry.Grassmannian.rqPullback ψ.unop.left
            (Scheme.LocallyFreeQuotient.toRankQuotient x))
        refine Quotient.sound ⟨Iso.refl _, ?_⟩
        change ((Scheme.Modules.pullbackFreeIso T'.unop.hom (Fin r)).inv ≫
            (pullbackTriangleIso (Over.w ψ.unop)
              (SheafOfModules.free (R := S.ringCatSheaf) (Fin r))).inv ≫
            (Scheme.Modules.pullback ψ.unop.left).map x.q) ≫ 𝟙 _
          = (Scheme.Modules.pullbackFreeIso ψ.unop.left (Fin r)).inv ≫
            (Scheme.Modules.pullback ψ.unop.left).map
              ((Scheme.Modules.pullbackFreeIso T.unop.hom (Fin r)).inv ≫ x.q)
        rw [Category.comp_id, Functor.map_comp]
        rw [← Category.assoc, ← Category.assoc]
        exact congrArg (· ≫ (Scheme.Modules.pullback ψ.unop.left).map x.q)
          (freeCompare_naturality_core ψ.unop))

/-! ## §3. Representability of the pulled-back absolute functor

`Scheme.{0}` has binary products (`Spec ℤ` is terminal, pullbacks exist), so
the forgetful functor `Over S ⥤ Sch` has the right adjoint `Over.star S`,
`Y ↦ (S ⨯ Y, fst)`.  The base change of the absolute Grassmannian to `S` is
`(Over.star S).obj Gr(d, r)`, and the adjunction transports the absolute
representability (`AlgebraicGeometry.Grassmannian.represents`) to `Over S`. -/