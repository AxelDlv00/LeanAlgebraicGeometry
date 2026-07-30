---
author: sync
content_type: theorem
created: '2026-07-30T08:42:04'
decl: Probe.exists_unique_descend
docstring: 'The `∃!` form: a class on `T_{k''}` whose two pullbacks agree descends
  uniquely.'
file: Scratch2/Exist3.lean
generated: lean
lean_status: lean_ok
title: Probe.exists_unique_descend
type: lean
updated: '2026-07-30T08:42:04'
---
theorem exists_unique_descend (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (hx : ∀ {W : Over (Spec (CommRingCat.of k))}
      (p₁ p₂ : W ⟶ (restrictTest k k').obj (baseTest (k' := k') T)),
      p₁ ≫ coverMap (k' := k') T = p₂ ≫ coverMap (k' := k') T →
      (picEt C).map p₁.op x = (picEt C).map p₂.op x) :
    ∃! y : (picEt C).obj (Opposite.op T),
      (picEt C).map (coverMap (k' := k') T).op y = x := by
  have h := isSheafFor_singleton k' C T
  rw [Presieve.isSheafFor_singleton] at h
  exact h x hx