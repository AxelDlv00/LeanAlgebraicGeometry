---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.entryIdeal_matrixPresentationBasicOpen
docstring: 'The entry ideal of the basic-open restriction of a presentation is the

  image ideal of the entry ideal.'
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.entryIdeal_matrixPresentationBasicOpen
type: lean
updated: '2026-07-24T03:02:10'
---
lemma entryIdeal_matrixPresentationBasicOpen {mm : ℕ} {V : X.affineOpens}
    (P : MatrixPresentation Γ(X, V.1) Γ(G, V.1) e mm) (f : Γ(X, V.1)) :
    (MatrixPresentationBasicOpen G P f).entryIdeal =
      P.entryIdeal.map (X.presheaf.map (homOfLE (X.basicOpen_le f)).op).hom := by
  haveI := V.2.isLocalization_basicOpen f
  haveI := Scheme.Modules.isLocalizedModule_basicOpen G V.2 f
  rw [MatrixPresentationBasicOpen, Module.MatrixPresentation.congr_entryIdeal,
    Module.MatrixPresentation.entryIdeal_baseChange]
  rfl