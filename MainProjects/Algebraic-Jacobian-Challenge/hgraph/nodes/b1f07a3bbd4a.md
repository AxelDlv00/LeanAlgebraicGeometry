---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.LineBundle.unitPresentation
docstring: 'The canonical finite presentation of the unit module `unit R`: one generator,

  no relations (its generating map is an isomorphism, so the relation kernel is the

  zero object).'
file: AlgebraicJacobian/Picard/LineBundleCoherence.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LineBundle.unitPresentation
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def unitPresentation : (SheafOfModules.unit R).Presentation where
  generators := unitGenerators
  relations :=
    { I := PEmpty.{u + 1}
      s := PEmpty.elim
      epi := by
        have hiso : IsIso (unitGenerators (R := R)).π := by
          dsimp only [unitGenerators, SheafOfModules.GeneratingSections.π]
          rw [Equiv.symm_apply_apply]
          infer_instance
        have : Mono (unitGenerators (R := R)).π := inferInstance
        have hz : Limits.IsZero (Limits.kernel (unitGenerators (R := R)).π) :=
          Limits.isZero_kernel_of_mono _
        exact ⟨fun g h _ => hz.eq_of_src g h⟩ }

instance : (unitPresentation (R := R)).IsFinite where
  isFiniteType_generators := ⟨inferInstanceAs (Finite PUnit.{u + 1})⟩
  isFiniteType_relations := ⟨inferInstanceAs (Finite PEmpty.{u + 1})⟩

end UnitPresentation

/-! ## §2. The trivial presentation on a chart -/