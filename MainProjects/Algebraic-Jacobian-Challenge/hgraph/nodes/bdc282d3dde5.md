---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.classify_homEquiv_symm
docstring: 'The classified section of the classifying morphism attached to a section

  of `F`: restriction of the section.'
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.classify_homEquiv_symm
type: lean
updated: '2026-07-24T03:02:12'
---
lemma classify_homEquiv_symm {Y : ∀ i, Over (U i).toScheme}
    (R : ∀ i, ((Over.map (U i).ι).op ⋙ F).RepresentableBy (Y i))
    {T : Scheme.{0}} (a : T ⟶ S) (x : F.obj (op (Over.mk a))) (k : ι) :
    classify R ((R k).homEquiv.symm
      (F.map (classifyInv U a k ≫ overResHom (Over.mk a) (pre U a k)).op x))
      = F.map (overResHom (Over.mk a) (pre U a k)).op x := by
  refine (congrArg (fun z => F.map (classifyHom U a k).op z)
    ((R k).homEquiv.apply_symm_apply _)).trans ?_
  refine (map_map _ _ _).trans ?_
  refine map_congr ?_ x
  rw [← Category.assoc, classifyHom_comp_inv, Category.id_comp]

variable (Y R) in