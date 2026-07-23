---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Pic0.pointedDualNumberPoints_equiv_picScheme
docstring: '**Axiom-clean.** The tangent space of `Pic⁰_{C/k}` at the identity is
  the

  tangent space of `Pic_{C/k}` there (leg-(1) connector of the Kleiman §5

  Thm.~5.11 dimension identity): along the clopen inclusion

  `ι : Pic⁰_{C/k} ↪ Pic_{C/k}` (an open immersion by the sibling''s

  `IdentityComponent.isOpenSubgroupScheme`), composition identifies the pointed

  dual-number points at the identity section with those of the ambient Picard

  scheme at its image — `Spec k[ε]` is a one-point scheme, so dual-number

  points landing in the open subscheme lift uniquely

  (`pointedDualNumberPointsEquivOfOpenImmersion`,

  `Picard/Pic0TangentSpace.lean`). This lets the representability leg compute

  `T_e Pic⁰` on `Pic_{C/k}` itself, where `picSharp`-representability applies.'
file: AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.pointedDualNumberPoints_equiv_picScheme
type: lean
updated: '2026-07-16T21:14:27'
---
theorem pointedDualNumberPoints_equiv_picScheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (Σ' (ι : Pic0Scheme C ⟶ PicScheme C),
      pointedDualNumberPoints (Pic0Scheme C) (identitySection C) ≃
        pointedDualNumberPoints (PicScheme C) (identitySection C ≫ ι.left)) := by
  obtain ⟨f, hopen, -⟩ :=
    GroupScheme.IdentityComponent.isOpenSubgroupScheme (PicScheme C)
  haveI := hopen
  exact ⟨⟨f, pointedDualNumberPointsEquivOfOpenImmersion f (identitySection C)⟩⟩