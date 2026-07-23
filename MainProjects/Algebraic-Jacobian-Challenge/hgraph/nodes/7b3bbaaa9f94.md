---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.glueProj_coordSectionGlued
docstring: '**Restriction identity for the coordinate section.**  On the `i`-th chart
  the

  glued coordinate section `x_j` restricts to `Xⱼ/Xᵢ = chartSectionsIso i (Xⱼ/Xᵢ)`.'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.glueProj_coordSectionGlued
type: lean
updated: '2026-07-24T03:02:12'
---
lemma glueProj_coordSectionGlued (i j : n₀) :
    (Scheme.Modules.glueProj (glueData n₀)
        (fun i => SheafOfModules.unit ((glueData n₀).U i).ringCatSheaf)
        (fun i j => twistTransition n₀ 1 i j)
        (fun i => twistTransition_self n₀ 1 i)
        (fun i j k => twistTransition_cocycle n₀ 1 i j k) i).app ⊤ (coordSectionGlued j)
      = (chartSectionsIso n₀ i).hom (formChart 1 i ⟨X j, X_mem_deg_one n₀ j⟩) :=
  Scheme.Modules.glueProj_app_glueSectionsEquiv_symm (glueData n₀)
    (fun i => SheafOfModules.unit ((glueData n₀).U i).ringCatSheaf)
    (fun i j => twistTransition n₀ 1 i j)
    (fun i => twistTransition_self n₀ 1 i)
    (fun i j k => twistTransition_cocycle n₀ 1 i j k)
    ⟨formFamily 1 ⟨X j, X_mem_deg_one n₀ j⟩, formFamily_mem 1 ⟨X j, X_mem_deg_one n₀ j⟩⟩ i

/-! ## Surjectivity of the graded-separation map (headline (C))

The two sub-lemmas scoped by wave 3: (1) `overlapRingHom` is injective (via `overlapHom`
being an isomorphism onto `D₊(XᵢXⱼ)`), so the abstract compatible-family condition descends
to an equation of away-fractions; (2) graded separation — a compatible away-fraction family
comes from a single degree-`m` form.  Together with `formSectionHom_injective` this packages
`Γ(Proj ℤ[X], O(m)) ≅ (ℤ[X])_m` as `formSectionEquiv`. -/

set_option backward.isDefEq.respectTransparency false in