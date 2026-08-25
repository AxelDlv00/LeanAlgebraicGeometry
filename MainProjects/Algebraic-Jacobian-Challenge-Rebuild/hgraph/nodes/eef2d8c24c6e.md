---
author: sync
content_type: theorem
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0ClassYoneda_app
file: AlgebraicJacobian/Picard/Pic0FiniteStageUniversalYoneda.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0ClassYoneda_app
type: lean
updated: '2026-08-25T10:27:23'
---
theorem pic0ClassYoneda_app {J : Over (Spec (.of k))}
    (u : pic0Subgroup C J) {T : Over (Spec (.of k))} (f : T ⟶ J) :
    (pic0ClassYoneda C u).app (op T) f = pic0Map C f u := by
  calc
    (pic0ClassYoneda C u).app (op T) f =
        (pic0TypeFunctor C).map f.op u := by
      simpa [pic0ClassYoneda] using
        (yonedaEquiv_symm_app_apply (F := pic0TypeFunctor C) u (op T) f)
    _ = pic0Map C f u := by
      exact pic0TypeFunctor_map_apply (C := C) f.op u

/-! ## The pinned separably closed universal class -/

variable [IsSepClosed k]