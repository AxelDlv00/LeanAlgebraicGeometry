---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Grassmannian.restrictBase_rel
docstring: '`restrictBase` respects the equivalence of families.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.restrictBase_rel
type: lean
updated: '2026-07-16T21:14:27'
---
lemma restrictBase_rel {S' : Scheme.{0}} (j : S' ⟶ S) {V : S.Modules} {d : ℕ}
    {T : Over S'} {x y : Scheme.LocallyFreeQuotient V d ((Over.map j).obj T)}
    (h : x.Rel y) : (restrictBase j x).Rel (restrictBase j y) := by
  obtain ⟨f, hf⟩ := h
  refine ⟨f, ?_⟩
  change (((Scheme.Modules.pullbackComp T.hom j).app V).hom ≫ x.q) ≫ f.hom
    = ((Scheme.Modules.pullbackComp T.hom j).app V).hom ≫ y.q
  rw [Category.assoc]
  exact congrArg (((Scheme.Modules.pullbackComp T.hom j).app V).hom ≫ ·) hf

omit [IsLocallyNoetherian S] in