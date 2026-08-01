---
author: sync
content_type: instance
created: '2026-08-01T09:44:14'
decl: AlgebraicGeometry.AffAdaptation.gluedSubalgebraPieceAlgebra
file: AlgebraicJacobian/Picard/DivisorSubschemeTensorOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.gluedSubalgebraPieceAlgebra
type: lean
updated: '2026-08-01T09:44:14'
---
noncomputable instance gluedSubalgebraPieceAlgebra
    (A : AffAdaptation D d) (i : D.index) :
    Algebra (gluedSubalgebra A) (A.colength i) :=
  (A.gluedSubalgebraPieceMap i).toRingHom.toAlgebra

/-- The canonical algebra structure on a pairwise overlap over the widened equalizer
algebra, through the left piece. -/
@[reducible]