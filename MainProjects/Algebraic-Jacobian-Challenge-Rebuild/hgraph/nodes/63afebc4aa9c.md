---
author: sync
content_type: theorem
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.jointlyInjective_iff
docstring: '**Joint injectivity decomposes**: it is index separation together with
  per-chart

  injectivity on every test.


  Read left to right this says what the multi-index coverage argument''s conclusion
  contains; read

  right to left it says the one-chart theorem''s conclusion (per-chart injectivity)
  is only *half*

  of what would be needed to run the refutation at a general `ι`.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.jointlyInjective_iff
type: lean
updated: '2026-07-30T12:49:24'
---
theorem jointlyInjective_iff {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) :
    JointlyInjective C f ↔
      IndexSeparated C f ∧ ∀ (i : ι) (S : Scheme.{u}ᵒᵖ), Function.Injective ((f i).app S) := by
  constructor
  · intro h
    refine ⟨fun S i j x y hxy => ?_, fun i S x y hxy => ?_⟩
    · exact congrArg Sigma.fst (h S i j x y hxy)
    · exact eq_of_heq (Sigma.mk.injEq .. ▸ h S i i x y hxy).2
  · rintro ⟨hsep, hinj⟩ S i j x y hxy
    obtain rfl : i = j := hsep S i j x y hxy
    exact congrArg (fun z => (⟨i, z⟩ : Σ i, (yoneda.obj (X i)).obj S)) (hinj i S hxy)