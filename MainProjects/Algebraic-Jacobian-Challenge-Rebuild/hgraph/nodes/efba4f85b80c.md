---
author: sync
content_type: definition
created: '2026-08-01T11:57:32'
decl: AlgebraicGeometry.AffAdaptation.thetaTripleQuotientModule
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTriple.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaTripleQuotientModule
type: lean
updated: '2026-08-01T13:18:16'
---
noncomputable def thetaTripleQuotientModule (A : AffAdaptation D d) (a : ℕ)
    (i j l : D.index) :
    Module (A.tripleColength i j l)
      (A.ThetaTripleQuotient (π := π) a i j l) := by
  letI := A.thetaTripleSectionsModule (π := π) a i j l
  change Module
    (Γ(relCurve C R, A.thetaTripleOpen i j l) ⧸ A.thetaTripleIdeal i j l)
    (A.ThetaTripleSections (π := π) a i j l ⧸
      A.thetaTripleIdeal i j l •
        (⊤ : Submodule Γ(relCurve C R, A.thetaTripleOpen i j l)
          (A.ThetaTripleSections (π := π) a i j l)))
  infer_instance