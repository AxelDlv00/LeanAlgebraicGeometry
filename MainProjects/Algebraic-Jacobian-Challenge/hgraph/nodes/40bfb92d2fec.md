---
author: sync
content_type: theorem
created: '2026-07-29T20:27:13'
decl: AlgebraicGeometry.exists_base_subsingleton_curve
docstring: '**A divisor with vanishing `H¹` exists on the curve, at every genus**
  (★★).


  Three curve binders and nothing else: no genus hypothesis, no vanishing hypothesis,
  no finite

  map supplied by the caller.  The `π : C ⟶ ℙ¹` and both cohomology finiteness binders
  that

  `Ledger/FiberBound.exists_base_subsingleton_of_isFinite_toP1` asks for are discharged
  here from

  the curve itself (`Ledger/MapToP1.exists_isFinite_isDominant_toP1`,

  `Ledger/ChiCurve.moduleFinite_hModule_zero`).


  This is the existence clause of `UniformBaseDivisor` over the base field.  It is
  stated because

  the project''s index for that gap (`Ledger/GenusFieldInvariance.lean:426-430`) prices
  it as a

  missing production from geometry restricted to `genus C = 0`; the production exists
  at every

  genus, and only the degree bound is missing.  See the module docstring.'
file: AlgebraicJacobian/RiemannRoch/Ledger/BaseDivisorEveryField.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_base_subsingleton_curve
type: lean
updated: '2026-07-29T20:27:13'
---
theorem exists_base_subsingleton_curve :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    ∃ D₀ : C.left.CurveDivisor,
      Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  obtain ⟨π, hfin, hdom, hcomp⟩ := exists_isFinite_isDominant_toP1 (k := k) (C := C)
  haveI := hfin
  haveI := hdom
  exact exists_base_subsingleton_of_isFinite_toP1 π hcomp