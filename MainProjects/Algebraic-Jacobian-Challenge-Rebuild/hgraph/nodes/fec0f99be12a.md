---
author: sync
content_type: theorem
created: '2026-08-19T06:28:15'
decl: AlgebraicGeometry.pic0FiniteStageFiniteInAffine_of_isAlgClosed_of_connected
docstring: 'Over an algebraically closed finite-stage field, connectedness and the
  represented

  group law make the exact glued Picard-zero carrier `FiniteInAffine`.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageFiniteInAffine_of_isAlgClosed_of_connected
type: lean
updated: '2026-08-19T06:28:15'
---
theorem pic0FiniteStageFiniteInAffine_of_isAlgClosed_of_connected
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [IsAlgClosed P.N.1]
    [ConnectedSpace P.glueData.glued]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver) :
    Scheme.FiniteInAffine P.glueData.glued := by
  letI : GrpObj P.gluedOver :=
    pic0FiniteStageGrpObjOfRepresentableBy C Ck P rep
  letI : LocallyOfFiniteType P.gluedOver.hom := by
    change LocallyOfFiniteType P.gluedMap
    infer_instance
  letI : ConnectedSpace P.gluedOver.left := by
    change ConnectedSpace P.glueData.glued
    infer_instance
  exact GroupScheme.finiteInAffine_of_isAlgClosed_of_connected P.gluedOver

/-- Connectedness of the represented finite-stage group supplies orbit affineness over an
algebraically closed field.  No arbitrary-field closure is asserted here. -/
@[implicit_reducible]
noncomputable def
    pic0FiniteStageOrbitsInAffineOpen_of_isAlgClosed_of_connected
    (P : Pic0FiniteStageGluePackage Ck F)
    [Algebra K P.N.1] [FiniteDimensional K P.N.1] [IsGalois K P.N.1]
    [IsAlgClosed P.N.1] [ConnectedSpace P.glueData.glued]
    (rep : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver) :
    (pic0SemilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen :=
  Scheme.orbitsInAffineOpen_of_finiteInAffine _
    (pic0FiniteStageFiniteInAffine_of_isAlgClosed_of_connected C Ck P rep)