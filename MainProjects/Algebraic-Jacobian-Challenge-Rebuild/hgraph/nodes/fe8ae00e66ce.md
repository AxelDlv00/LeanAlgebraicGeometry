---
author: sync
content_type: lemma
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.relSectionsBaseChangeAffRingEquiv_tmul_one
docstring: On `s ⊗ 1` the raw base change is the section comparison `relAffSectionsMap`.
file: AlgebraicJacobian/Picard/DivisorFamilyAffSections.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relSectionsBaseChangeAffRingEquiv_tmul_one
type: lean
updated: '2026-07-29T15:26:39'
---
lemma relSectionsBaseChangeAffRingEquiv_tmul_one {V : (relCurve C R).Opens}
    (hV : IsAffineOpen V) (s : Γ(relCurve C R, V)) :
    relSectionsBaseChangeAffRingEquiv C R' hV (s ⊗ₜ 1) = relAffSectionsMap C R' V s :=
  Over.pieceRingEquiv_tmul_one (A := R) (B := R') C hV s