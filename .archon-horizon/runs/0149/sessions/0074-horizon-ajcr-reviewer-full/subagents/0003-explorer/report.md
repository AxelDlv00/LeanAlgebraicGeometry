Next kernel is the global multicoequalizer comparison, now that both diagram legs are available.

```lean
noncomputable def Pic0FiniteStageGluePackage.gluingGluedIso
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
      (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).glued ≅
    (pic0SepClosedAtlasGlueData C).glued
```

Construct `hom` and `inv` using `Multicoequalizer.desc`; use `gluingChartIso.hom` and `.inv` chartwise. The sole compatibility required for `hom` is exactly equality of the two multispan legs:

- first leg: `gluingOverlapIso_fst` at [Pic0FiniteStageGluingDiagramIso.lean:256](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:256);
- second leg: `gluingOverlapIso_snd` at [Pic0FiniteStageGluingOverlapIsoSnd.lean:181](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoSnd.lean:181).

The latter has precisely the required source leg `(t U V ≫ f V U)`, so it closes the former diagram gap. Derive inverse compatibilities by composing these equations with the inverse component isomorphisms. Prove inverse laws with `Multicoequalizer.hom_ext` and `Multicoequalizer.π_desc` ([mathlib Multiequalizer.lean:1184](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/.lake-packages/mathlib/Mathlib/CategoryTheory/Limits/Shapes/Multiequalizer.lean:1184)).

Then the immediately useful composite is:

```lean
noncomputable def finiteStageBaseChangeIso :
  pullback P.gluedMap (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
    (pic0_sepClosed_representableBy (C := C)).1.left :=
  baseChangeGluingIso C P ≪≫ gluingGluedIso C P ≪≫
    asIso (pic0SepClosedAtlasOpenCover C).fromGlued
```

`fromGlued` is already an isomorphism for the canonical atlas glue ([Gluing.lean:348](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:348), instance at :423). Thus this is feasible with no new mathematics, only categorical assembly and dependent-instance management.

The generic mathlib API does not provide a ready-made “isomorphic gluing data gives isomorphic glued schemes” theorem; `GlueData` exposes the colimit/multispan representation ([GlueData.lean:137](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/.lake-packages/mathlib/Mathlib/CategoryTheory/GlueData.lean:137)), so a small project-local utility is reasonable if the direct proof gets repetitive.

Root reachability is currently incomplete: [AlgebraicJacobian.lean:817](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian.lean:817) reaches `Pic0FiniteStageStableAffineCover`, while the critical import chain reaches `Pic0FiniteStageGluingDiagramIso` but not the new `...OverlapIsoSnd` ([Pic0CriticalPath.lean:83](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:83)). A global theorem must import the Snd module, then be explicitly added to the root or a root-reachable successor. No files changed or build run.
