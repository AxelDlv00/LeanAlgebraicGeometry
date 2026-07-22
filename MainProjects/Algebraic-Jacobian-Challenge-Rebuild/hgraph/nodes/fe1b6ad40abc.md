---
author: sync
content_type: instance
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.directedSystem_divUniversalHighWindowTransition
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitions.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.directedSystem_divUniversalHighWindowTransition
type: lean
updated: '2026-07-22T02:02:05'
---
noncomputable instance directedSystem_divUniversalHighWindowTransition (side : Bool) :
    DirectedSystem (fun n => G n)
      (divUniversalHighWindowTransitionOfLE (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j side · · ·) :=
  HighWindowTransitionKit.directedSystem_transitionOfLE
    (fun q => divUniversalHighWindowAmbient (C := C) (pi := pi)
      (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
      (i := i) (j := j) q)
    (fun q => divUniversalHighWindowTransition (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j side q)

/-- Every iterated transition leaves the selected pinned-chart reading fixed. -/
@[simp]