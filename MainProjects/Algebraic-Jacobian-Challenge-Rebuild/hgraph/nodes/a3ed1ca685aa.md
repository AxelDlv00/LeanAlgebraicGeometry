---
author: sync
content_type: theorem
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.projective_glued_pullback
docstring: (c2) transport, projectivity.
file: AlgebraicJacobian/Picard/DivisorFamilyAffCert.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.projective_glued_pullback
type: lean
updated: '2026-07-28T17:25:25'
---
theorem projective_glued_pullback
    [Module.Flat R (A.chartProd ⧸ A.gluedSubmodule)]
    [Module.Flat R (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight))]
    (hproj' : Module.Projective R A.Glued) :
    Module.Projective R' (A.pullback R' hproj).Glued := by
  haveI := hproj'
  exact Module.Projective.of_equiv (A.gluedBaseChange R' hproj hinf)

include hinf in