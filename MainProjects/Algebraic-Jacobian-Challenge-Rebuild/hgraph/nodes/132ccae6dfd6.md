---
author: sync
content_type: theorem
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.picEtAffineEquiv_picEtPullback
docstring: '**`picEtAffineEquiv`-compatibility**: at an affine test the componentwise
  lift is

  the affine curve transport under the affine comparison.'
file: AlgebraicJacobian/Picard/PicEtCurveMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.picEtAffineEquiv_picEtPullback
type: lean
updated: '2026-07-30T15:46:06'
---
theorem picEtAffineEquiv_picEtPullback (g : D ⟶ E) (s : picEt E (overSpec k A)) :
    picEtAffineEquiv D A (picEtPullback g (overSpec k A) s)
      = PicEtAff.curveMap A g (picEtAffineEquiv E A s) := by
  rw [picEtAffineEquiv_apply, picEtAffineEquiv_apply, picEtPullback_val,
    PicEtAff.mapAlg_curveMap]
  rfl