---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.relResAlgHom
docstring: 'Restriction of sections of the relative curve as an `R`-algebra homomorphism

  (`Scheme.overSectionsAlgebra` structures on both sides).'
file: AlgebraicJacobian/Picard/DivisorFamily.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relResAlgHom
type: lean
updated: '2026-07-29T15:26:38'
---
noncomputable def relResAlgHom {W V : (relCurve C R).Opens} (h : W ≤ V) :
    Γ(relCurve C R, V) →ₐ[R] Γ(relCurve C R, W) :=
  AlgHom.mk' (CommRingCat.Hom.hom ((relCurve C R).presheaf.map (homOfLE h).op))
    (fun c x => by
      simp only [Algebra.smul_def]
      rw [map_mul]
      congr 1
      rw [Scheme.algebraMap_overSectionsAlgebra, Scheme.algebraMap_overSectionsAlgebra]
      exact (relCurve C R).overAlgebraMap_apply_res R (homOfLE h).op c)

@[simp]