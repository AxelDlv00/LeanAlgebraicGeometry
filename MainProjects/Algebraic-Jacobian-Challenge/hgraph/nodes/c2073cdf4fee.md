---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.LocallyFreeQuotient.congrModule_rel
docstring: The module-iso transport respects the equivalence of quotients.
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocallyFreeQuotient.congrModule_rel
type: lean
updated: '2026-07-16T21:14:27'
---
lemma congrModule_rel {V V' : S.Modules} (g : V ≅ V') {d : ℕ} {T : Over S}
    {x y : LocallyFreeQuotient V d T} (h : x.Rel y) :
    (congrModule g x).Rel (congrModule g y) := by
  obtain ⟨f, hf⟩ := h
  refine ⟨f, ?_⟩
  change (((Scheme.Modules.pullback T.hom).mapIso g).inv ≫ x.q) ≫ f.hom
    = ((Scheme.Modules.pullback T.hom).mapIso g).inv ≫ y.q
  rw [Category.assoc]
  exact congrArg (((Scheme.Modules.pullback T.hom).mapIso g).inv ≫ ·) hf

end LocallyFreeQuotient

set_option backward.isDefEq.respectTransparency false in