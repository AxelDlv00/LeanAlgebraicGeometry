---
author: sync
content_type: theorem
created: '2026-08-04T10:53:20'
decl: AlgebraicGeometry.Scheme.etaleTopology_eq_propQCTopology
docstring: The ordinary and quasi-compact presentations generate the same big etale
  topology.
file: AlgebraicJacobian/Picard/Pic0SigmaEtaleSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.etaleTopology_eq_propQCTopology
type: lean
updated: '2026-08-04T10:53:20'
---
theorem Scheme.etaleTopology_eq_propQCTopology :
    Scheme.etaleTopology.{u} = Scheme.propQCTopology (@Etale) := by
  apply le_antisymm
  · apply Precoverage.toGrothendieck_mono
    rw [Scheme.propQCPrecoverage, le_inf_iff]
    exact ⟨Scheme.precoverage_le_qcPrecoverage_of_isOpenMap
      (fun _ _ f _ => f.isOpenMap), le_rfl⟩
  · exact Precoverage.toGrothendieck_mono
      Scheme.propQCPrecoverage_le_precoverage