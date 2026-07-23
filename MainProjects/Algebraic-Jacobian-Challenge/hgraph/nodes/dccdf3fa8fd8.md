---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.map_map
docstring: 'Application form of the functoriality of `F` on abstract objects of

  `Over S` (avoids dependent-motive failures when rewriting under

  applications).'
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.map_map
type: lean
updated: '2026-07-16T21:14:28'
---
lemma map_map {A B C : Over S} (f : A ⟶ B) (g : B ⟶ C) (x : F.obj (op C)) :
    F.map f.op (F.map g.op x) = F.map (f ≫ g).op x := by
  rw [op_comp, Functor.map_comp_apply]