---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.freeYonedaEval_iso_of_le
docstring: '**Evaluating `freeYoneda W` at an open `V ≤ W` gives `O_X(V)`.**


  When `V ≤ W` the hom-set `V ⟶ W` is a singleton (`Unique`), so the free `O_X(V)`-module
  on it

  is `O_X(V)` itself.  This is the per-summand identification of the surviving (`I₁`)
  summands in

  the sectionwise reduction (blueprint `lem:cech_free_eval_sectionwise`): together
  with

  `freeYonedaEval_isZero_of_not_le` it gives the description

  `K(𝒰)_p(V) = ⊕_{σ : V ≤ U_σ} O_X(V)`.


  Project-local: a degreewise identification for the project''s `freeYoneda`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.freeYonedaEval_iso_of_le
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def freeYonedaEval_iso_of_le {W V : TopologicalSpace.Opens ↥X} (h : V ≤ W) :
    (PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).obj (freeYoneda.obj W)
      ≅ ModuleCat.of (X.ringCatSheaf.obj.obj (Opposite.op V))
          (X.ringCatSheaf.obj.obj (Opposite.op V)) :=
  haveI : Unique (V ⟶ W) := ⟨⟨homOfLE h⟩, fun _ => Subsingleton.elim _ _⟩
  (Finsupp.LinearEquiv.finsuppUnique _ _ (V ⟶ W)).toModuleIso