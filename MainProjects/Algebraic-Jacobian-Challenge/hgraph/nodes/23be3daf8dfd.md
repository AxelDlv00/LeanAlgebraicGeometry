---
author: sync
content_type: theorem
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.DivFamily.twist_isFiniteSupport
docstring: 'The finite-support producer for the twisted D2 target.  It spends only
  the

  same locally-quasi-finite support binder already carried by the divisor row;

  properness comes from `DivFamily.properSupport`, and exact support preservation

  then transports finiteness to the twist.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.twist_isFiniteSupport
type: lean
updated: '2026-08-01T04:12:00'
---
theorem twist_isFiniteSupport
    (L : X.Modules) (hL : LineBundle.IsLocallyTrivial L)
    (x : DivFamily π T)
    [LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom)] :
    IsFinite (Modules.schematicSupportι (x.twist L) ≫ pullback.snd π T.hom) := by
  rw [twist_isFiniteSupport_iff L hL x]
  haveI : IsProper
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) := x.properSupport
  exact IsFinite.of_isProper_of_locallyQuasiFinite _

set_option backward.isDefEq.respectTransparency false in