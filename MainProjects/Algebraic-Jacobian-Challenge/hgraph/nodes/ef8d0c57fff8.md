---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sectionsMul_mul_one
docstring: 'Right unitality of the graded section multiplication

  (`lem:sectionMul_coherent`, right-unit case):

  for `a ∈ Γ(X, L^{⊗n})`, transporting `a · 1` along `n + 0 = n` gives `a`.

  Mirrors `TensorPower.mul_one`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sectionsMul_mul_one
type: lean
updated: '2026-07-24T03:02:12'
---
theorem sectionsMul_mul_one (L : X.Modules) {n : ℕ} (a : sectionDeg L n) :
    sectionsCast L (add_zero n) (GradedMonoid.GMul.mul a GradedMonoid.GOne.one) = a := by
  rw [gMul_mul_apply, gOne_one_eq]
  -- The right-unit coherence of the comparison family: the degree-`(n,0)` comparison IS the right
  -- unitor.  After the iter-023 second-index refactor this is the literal `m' = 0` base clause of
  -- `tensorPowAdd`, so `tensorPowAdd L n 0 = tensorObjRightUnitor (tensorPow L n)` holds by `rfl`
  -- (`tensorPowAdd_zero_right`) — NO induction, NO braiding, NO triangle.  The degreewise statement
  -- then follows from `tensorObjRightUnitor_hom_sectionsMul` (axiom-clean) + `sectionsCast_self`.
  have hμn0 : tensorPowAdd L n 0 = tensorObjRightUnitor (tensorPow L n) :=
    tensorPowAdd_zero_right L n
  have hinner : ((tensorPowAdd L n 0).hom.val.app (Opposite.op ⊤)).hom
      ((sectionsMul (tensorPow L n) (tensorPow L 0)).hom
        (a ⊗ₜ[(X.sheaf.obj ⋙ forget₂ CommRingCat RingCat).obj (Opposite.op ⊤)]
          (1 : ↥(X.ringCatSheaf.obj.obj (Opposite.op ⊤))))) = a := by
    rw [hμn0]
    exact tensorObjRightUnitor_hom_sectionsMul (tensorPow L n) a
  rw [hinner]
  exact sectionsCast_self L (add_zero n) a