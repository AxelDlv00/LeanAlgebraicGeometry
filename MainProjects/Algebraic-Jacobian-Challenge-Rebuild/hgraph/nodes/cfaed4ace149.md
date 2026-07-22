---
author: sync
content_type: theorem
created: '2026-07-20T20:32:02'
decl: AlgebraicGeometry.Scheme.range_finiteMulMap
docstring: 'The range of the finite basis-indexed product map is exactly the span
  of

  all products of elements of the two subspaces.'
file: AlgebraicJacobian/Picard/DivSchemeMulSpanMap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.range_finiteMulMap
type: lean
updated: '2026-07-20T20:32:02'
---
theorem Scheme.range_finiteMulMap
    (U T : Submodule K X.functionField) (b : Module.Basis ι K U) :
    LinearMap.range (Scheme.finiteMulMap U T b) = Scheme.mulSpan K U T := by
  classical
  apply le_antisymm
  · rintro _ ⟨x, rfl⟩
    rw [Scheme.finiteMulMap_apply]
    exact Submodule.sum_mem _ fun i _ =>
      Scheme.mul_mem_mulSpan K (b i).property (x i).property
  · rw [Scheme.mulSpan, Submodule.span_le]
    rintro _ ⟨h, hh, f, hf, rfl⟩
    let hU : U := ⟨h, hh⟩
    let fT : T := ⟨f, hf⟩
    let x : ι → T := fun i => (b.repr hU i) • fT
    refine ⟨x, ?_⟩
    rw [Scheme.finiteMulMap_apply]
    change (∑ i, (b i : X.functionField) *
      ((b.repr hU i) • (fT : X.functionField))) = h * f
    have hterm : ∀ i,
        (b i : X.functionField) * ((b.repr hU i) • (fT : X.functionField)) =
          ((b.repr hU i) • (b i : X.functionField)) * (fT : X.functionField) := by
      intro i
      rw [Scheme.functionFieldOverModule_smul_def,
        Scheme.functionFieldOverModule_smul_def]
      ring
    simp_rw [hterm]
    rw [← Finset.sum_mul]
    have hb : (∑ i, (b.repr hU i) • (b i : X.functionField)) = h := by
      calc
        (∑ i, (b.repr hU i) • (b i : X.functionField)) =
            ((∑ i, (b.repr hU i) • b i : U) : X.functionField) := by
          symm
          simpa only [Submodule.coe_smul] using
            (Submodule.coe_sum U (fun i => (b.repr hU i) • b i) Finset.univ)
        _ = h := by rw [b.sum_repr]
    rw [hb]