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
updated: '2026-08-01T09:44:16'
---
theorem jointlyInjective_iff {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) :
    JointlyInjective C f ↔
      IndexSeparated C f ∧ ∀ (i : ι) (S : Scheme.{u}) (_ : Nonempty S),
        Function.Injective ((f i).app (op S)) := by
  constructor
  · intro h
    refine ⟨fun S hS i j x y hxy => ?_, fun i S hS x y hxy => ?_⟩
    · exact congrArg Sigma.fst (h S hS i j x y hxy)
    · exact eq_of_heq (Sigma.mk.injEq .. ▸ h S hS i i x y hxy).2
  · rintro ⟨hsep, hinj⟩ S hS i j x y hxy
    obtain rfl : i = j := hsep S hS i j x y hxy
    exact congrArg (fun z => (⟨i, z⟩ : Σ i, (yoneda.obj (X i)).obj (op S))) (hinj i S hS hxy)