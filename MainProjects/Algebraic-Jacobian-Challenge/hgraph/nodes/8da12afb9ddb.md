---
author: sync
content_type: theorem
created: '2026-07-30T08:53:11'
decl: AlgebraicGeometry.Scheme.PicScheme.ctrl_b_arbitrary_f
file: Scratch2/ScratchNonVac.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.PicScheme.ctrl_b_arbitrary_f
type: lean
updated: '2026-07-30T09:17:04'
---
theorem ctrl_b_arbitrary_f (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T W : Over (Spec (CommRingCat.of k))) (f : W ⟶ T)
    (x : (picEt C).obj (Opposite.op W))
    (hx : ∀ {V : Over (Spec (CommRingCat.of k))} (p₁ p₂ : V ⟶ W),
      p₁ ≫ f = p₂ ≫ f → (picEt C).map p₁.op x = (picEt C).map p₂.op x) :
    ∃! y : (picEt C).obj (Opposite.op T), (picEt C).map f.op y = x := by
  exact?