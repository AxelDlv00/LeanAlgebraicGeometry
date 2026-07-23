---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Pic0.cotangentSpaceDual_equiv_relPicKernel
docstring: '**Axiom-clean (through the `HasPicScheme` gate).** The two proved halves

  of Kleiman §5 Thm.~5.11 composed: the `κ(e)`-linear dual of the cotangent

  space `m_e/m_e²` at the identity of `Pic⁰_{C/k}` bijects with the kernel of

  `Pic^♯_{C/k}(Spec k[ε]) →+ Pic^♯_{C/k}(Spec k)` — the Stacks 0B28 dictionary

  (`pointedDualNumberPoints_equiv_cotangentSpaceDual`) chained through the

  tangent space with the representability leg

  (`pointedDualNumberPoints_equiv_relPicKernel`). Same linearity caveat as the

  latter: this is a bijection of sets.'
file: AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.cotangentSpaceDual_equiv_relPicKernel
type: lean
updated: '2026-07-16T21:14:27'
---
theorem cotangentSpaceDual_equiv_relPicKernel {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (Module.Dual
        (IsLocalRing.ResidueField
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
        (IsLocalRing.CotangentSpace
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
      ≃ {a : (PicSharp.relPresheaf C).obj (Opposite.op (overDualNumber k)) //
          ((PicSharp.relPresheaf C).map (overDualNumberZero k).op).hom a = 0}) := by
  obtain ⟨φ⟩ := pointedDualNumberPoints_equiv_cotangentSpaceDual C
  obtain ⟨ψ⟩ := pointedDualNumberPoints_equiv_relPicKernel C
  exact ⟨φ.symm.trans ψ⟩