---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.degAff_unit
docstring: '**The unit normalization of the plus-class degree** (needed by G-D8''s
  degree

  certificates): on a class pulled back from the base along the unit of the plus

  construction, the degree is the relative degree over the base field itself — the

  trivial cover is refined by the field cover of `K` itself.'
file: AlgebraicJacobian/Picard/DegreeZero.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PicEtAff.degAff_unit
type: lean
updated: '2026-07-30T15:28:03'
---
theorem PicEtAff.degAff_unit (z : relPic C (overSpec k K)) :
    PicEtAff.degAff K (PicEtAff.unit C K z) = relPicDeg K z := by
  have hrep : PicEtAff.unit C K z
      = PicEtAff.mk C (.self K)
          ⟨relPicAlgMap C
              ((Algebra.ofId K (Algebra.EtaleCover.self K).Carrier).restrictScalars k) z,
            PicEtAff.tautological_mem_descentClasses C (.self K) z⟩ := rfl
  rw [hrep,
    PicEtAff.degAff_mk (.self K) _ K (Algebra.EtaleCover.selfEquiv K).toAlgHom,
    ← relPicAlgMap_comp,
    show ((Algebra.EtaleCover.selfEquiv K).toAlgHom.restrictScalars k).comp
        ((Algebra.ofId K (Algebra.EtaleCover.self K).Carrier).restrictScalars k)
      = AlgHom.id k K from AlgHom.ext fun r => by
        simp [Algebra.ofId_apply],
    relPicAlgMap_id]