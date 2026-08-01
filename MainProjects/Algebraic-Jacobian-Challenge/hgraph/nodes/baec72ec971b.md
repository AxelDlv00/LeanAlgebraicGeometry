---
author: sync
content_type: definition
created: '2026-08-01T12:39:19'
decl: AlgebraicGeometry.Scheme.Grassmannian.universalCandidateIdeal
docstring: 'The kernel of the universal candidate quotient.  This is the actual

  curve-side module whose invertible locus D3 must carve out; the kernel of the

  Grassmannian quotient itself lives on the base and has the wrong rank.  Its

  ordinary `lineBundleLocus` lies in the total space `X_G`; D3 must still descend

  the whole-fibre condition to a locus in the Grassmannian base `G`.'
file: AlgebraicJacobian/Picard/DivGrassmannianCandidate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.universalCandidateIdeal
type: lean
updated: '2026-08-01T12:39:19'
---
noncomputable def universalCandidateIdeal (L : X.Modules) {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward π).obj L) r)
    (hd : 1 ≤ d) (hdr : d ≤ r) :=
  LocallyFreeQuotient.candidateIdeal L
    (universalQuotient hV hd hdr)