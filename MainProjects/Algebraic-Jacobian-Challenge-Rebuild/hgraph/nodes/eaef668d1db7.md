---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.toOvlRight_reindex
docstring: The right overlap arrow of a relabelled adaptation is the original one,
  relabelled.
file: AlgebraicJacobian/Picard/DivisorFamilyAffReindex.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.toOvlRight_reindex
type: lean
updated: '2026-07-29T15:26:37'
---
lemma toOvlRight_reindex (A : AffAdaptation D d) {m' : ℕ} (e : Fin m' ≃ D.index)
    (i j : Fin m') :
    (A.reindex e).toOvlRight i j = A.toOvlRight (e i) (e j) := rfl