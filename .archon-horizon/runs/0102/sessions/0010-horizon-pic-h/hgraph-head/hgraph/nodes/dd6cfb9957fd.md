---
author: sync
content_type: lemma
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.Scheme.LocalEquations.mem_sectionIdeal_iff
docstring: Membership in the section ideal is the defining germwise condition.
file: AlgebraicJacobian/Picard/DivisorIdealSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocalEquations.mem_sectionIdeal_iff
type: lean
updated: '2026-08-01T09:44:14'
---
lemma mem_sectionIdeal_iff {d : X.LocalEquations} {U : X.Opens} {s : Γ(X, U)} :
    s ∈ d.sectionIdeal U ↔ ∀ (z : X) (hz : z ∈ U),
      (X.presheaf.germ U z hz).hom s ∈ d.stalkIdeal z :=
  Iff.rfl