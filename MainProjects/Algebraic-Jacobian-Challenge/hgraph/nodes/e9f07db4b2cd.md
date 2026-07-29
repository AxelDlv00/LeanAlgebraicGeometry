---
author: sync
content_type: theorem
created: '2026-07-30T00:50:56'
decl: AlgebraicGeometry.isMonHom_of_pointed_arbitraryField
docstring: "**Milne §I.1 Corollary 1.2 over an arbitrary field: a pointed morphism\
  \ of abelian\nvarieties is a homomorphism.**\n\nSame statement as `isMonHom_of_pointed`\
  \ (`Albanese/AVSelfProduct.lean`) with the\n`[IsAlgClosed kbar]` binder deleted.\n\
  \nThe descent is the one mathlib's 0BFD uses for commutativity, and it works here\
  \ for the\nsame reason: `IsMonHom` is a *pair of equations*, so a faithful monoidal\
  \ functor reflects\nit. Concretely, with `F = Over.pullback (Spec.map (algebraMap\
  \ K K̄))`:\n\n* the abelian-variety package is stable under this base change, so\
  \ the `k̄` corollary\n  `isMonHom_of_pointed` applies to `F.map α`;\n* pointedness\
  \ transports along `F` (`F.map` of the pointing equation, plus `ε`);\n* `Over.pullback`\
  \ is faithful, and `μ`-naturality turns the upstairs `mul_hom` into the\n  downstairs\
  \ one after cancelling the (iso) monoidal comparison.\n\nNo smoothness or properness\
  \ of `B` beyond what the `k̄` statement asks, and no\nquasi-projectivity: nothing\
  \ in the argument is field-specific once the engine is applied\nupstairs."
file: AlgebraicJacobian/Albanese/AVRigidityArbitraryField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isMonHom_of_pointed_arbitraryField
type: lean
updated: '2026-07-30T00:50:56'
---
theorem isMonHom_of_pointed_arbitraryField {A B : Over (Spec (.of K))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    [GrpObj B] [IsProper B.hom]
    (α : A ⟶ B) (hα : η[A] ≫ α = η[B]) : IsMonHom α := by
  let f := Spec.map (CommRingCat.ofHom <| algebraMap K (AlgebraicClosure K))
  let F := Over.pullback f
  let A' := F.obj A
  let B' := F.obj B
  -- the abelian-variety package is stable under this base change
  have : IsProper A'.hom := by change IsProper (Limits.pullback.snd A.hom f); infer_instance
  have : Smooth A'.hom := by change Smooth (Limits.pullback.snd A.hom f); infer_instance
  have : GeometricallyIrreducible A'.hom := by
    change GeometricallyIrreducible (Limits.pullback.snd A.hom f); infer_instance
  have : IsProper B'.hom := by change IsProper (Limits.pullback.snd B.hom f); infer_instance
  -- the `k̄` corollary applies upstairs
  have hup : IsMonHom (F.map α) := by
    have hpt : η[A'] ≫ F.map α = η[B'] := by simp [← Functor.map_comp, hα]
    exact isMonHom_of_pointed (A := A') (B := B') (F.map α) hpt
  -- and reflects back down, by faithfulness plus `μ`-naturality
  refine { one_hom := hα, mul_hom := ?_ }
  exact F.map_injective <| by
    simpa [← Functor.LaxMonoidal.μ_natural_assoc,
      ← cancel_epi (Functor.LaxMonoidal.μ F A A)] using IsMonHom.mul_hom (F.map α)