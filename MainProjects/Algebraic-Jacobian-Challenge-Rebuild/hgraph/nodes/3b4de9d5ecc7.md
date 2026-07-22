---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.extOpens_overlap_le_bot
docstring: 'Any overlap between a range member and a non-range member of the extension
  cover is

  empty.'
file: AlgebraicJacobian/Picard/CechPicClopenGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CechPic.extOpens_overlap_le_bot
type: lean
updated: '2026-07-16T21:33:28'
---
lemma extOpens_overlap_le_bot (hdisj : w.opensRange ⊓ Ω' = ⊥) {y y' : Y}
    (hy : y ∈ w.opensRange) (hy' : y' ∉ w.opensRange) :
    extOpens w Ω' 𝒰₀ y ⊓ extOpens w Ω' 𝒰₀ y' ≤ ⊥ := by
  rw [extOpens_of_notMem w Ω' 𝒰₀ hy']
  exact le_of_le_of_eq
    (inf_le_inf_right Ω' (extOpens_le_opensRange w Ω' 𝒰₀ hy)) hdisj