---
author: sync
content_type: definition
created: '2026-07-31T02:29:39'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.quotientGlueData
docstring: 'The gluing datum of invariant-ring quotient charts attached to all stable

  affine opens of the acted scheme.'
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.quotientGlueData
type: lean
updated: '2026-07-31T02:29:39'
---
noncomputable def quotientGlueData [FiniteDimensional K L] [IsGalois K L] :
    Scheme.GlueData where
  J := StableAffineOpen ρ
  U i := quotientChart ρ i
  V p := quotientOverlap ρ p.1 p.2
  f i j := quotientOverlapι ρ i j
  f_id i := quotientOverlapι_self_isIso ρ i
  f_open i j := quotientOverlapι_isOpenImmersion ρ i j
  t i j := (overlapIso ρ i j).hom
  t_id i := by rw [overlapIso_self]; rfl
  t' i j k := overlapTransition' ρ i j k
  t_fac i j k := overlapTransition'_fac ρ i j k
  cocycle i j k := overlapTransition'_cocycle ρ i j k