---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.presentationDivisor_graphLocalEquations
docstring: '**The presentation divisor of the graph is a one-point divisor** at the
  graph point.'
file: AlgebraicJacobian/RiemannRoch/GraphDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.presentationDivisor_graphLocalEquations
type: lean
updated: '2026-07-30T15:46:08'
---
theorem presentationDivisor_graphLocalEquations :
    Scheme.presentationDivisor K (Over.graphLocalEquations C t).presentation
      = Scheme.CurveDivisor.single (graphPoint_ne_genericPoint C t)
          (Multiplicative.toAdd
            (Scheme.ordZ ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))
              (graphPoint_ne_genericPoint C t)
              ((Over.graphLocalEquations C t).presentation.elem (Over.graphPoint C t)))) := by
  refine Scheme.CurveDivisor.ext_coeffAt (fun x hxg => ?_)
  rw [Scheme.coeffAt_presentationDivisor]
  by_cases hxx : x = Over.graphPoint C t
  · subst hxx
    exact (Scheme.CurveDivisor.coeffAt_single_self hxg _).symm
  · rw [presentationElem_graphLocalEquations_of_ne C t hxx, map_one, toAdd_one,
      Scheme.CurveDivisor.coeffAt_single_of_ne (graphPoint_ne_genericPoint C t) hxg hxx]

/-! ## The keystone: the graph class has degree one -/