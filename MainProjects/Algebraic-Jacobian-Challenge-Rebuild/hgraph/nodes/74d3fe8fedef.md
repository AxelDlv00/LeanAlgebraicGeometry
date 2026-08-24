---
author: sync
content_type: theorem
created: '2026-08-07T04:54:08'
decl: AlgebraicGeometry.SepClosedTranslatedDropResult.rankOneLayer_isSplitWitness
file: AlgebraicJacobian/Picard/Pic0RankOneTranslatedCoverLayer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.SepClosedTranslatedDropResult.rankOneLayer_isSplitWitness
type: lean
updated: '2026-08-18T20:51:05'
---
theorem SepClosedTranslatedDropResult.rankOneLayer_isSplitWitness
    (mu : picEt C (overSpec k K))
    (d : SepClosedTranslatedDropData (C := C) (L := L) mu)
    (r : SepClosedTranslatedDropResult (C := C) (L := L) mu d) :
    IsSplitWitness C (r.rankOneLayer mu d).1 := by
  rw [SepClosedTranslatedDropResult.rankOneLayer_coe]
  exact r.translated

end Layer

section GeneralConsumer

variable [IsSepClosed k]
variable {K : Type u} [Field K] [Algebra k K]