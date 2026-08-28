Audit result: no generic “spread qcqs lfp scheme over a filtered field colimit” API is available, but the required ingredients are partly present.

- Finite affine cover plus qc pairwise intersections is already packaged in the sibling project:
  `Scheme.exists_finite_affineCover_inter_isQuasiCompact`
  ([FlatBaseChangeGlobal.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean:57)).
  It is a small, self-contained 19-line theorem and is the one coherent helper that can be ported to AJCR now. Mathlib also has `OpenCover.finiteSubcover` and `QuasiCompactCover.exists_isAffineOpen_of_isCompact`; the latter refines a compact overlap by finitely many affine opens, but does not make the overlap itself affine.

- `CategoryTheory.GlueData.mapGlueData` maps gluing data through a functor preserving the relevant pairwise pullbacks; with multicoequalizer preservation,
  `GlueData.gluedIso : F.obj D.glued ≅ (D.mapGlueData F).glued`
  gives exactly “base change commutes with gluing” ([GlueData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/GlueData.lean:215), [GlueData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/GlueData.lean:296)).
  However, Mathlib does not expose scheme base change as such a functor with these instances. Using this route requires substantial new infrastructure.

- The concrete alternatives are well supported:
  `Scheme.GlueData.vPullbackConeIsLimit`, `ι_isOpenImmersion`, `ι_jointly_surjective`, and `openCover`
  ([Gluing.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:176)).
  `Scheme.OpenCover.glueMorphisms` and `Scheme.Cover.hom_ext` glue/check morphisms locally ([Gluing.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:440)).
  Isomorphism can be discharged on an open cover through
  `MorphismProperty.of_zeroHypercover_target (P := MorphismProperty.isomorphisms Scheme)`.
  AJCR’s `GaloisQuotientOverlap.lean` is the working pattern: construct chart base-change maps manually, make a cover, then prove the global map is an iso locally around line 1528.

- For filtered fields viewed contravariantly as affine-transition schemes, Mathlib has the significant morphism-level theorem
  `Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation`
  ([AffineTransitionLimit.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1177)).
  It factors a morphism from the inverse limit through a finite stage under affine transitions and qcqs stage hypotheses. Its proof explicitly chooses a finite affine cover, synchronizes the finite stages, verifies overlap equality, and uses `glueMorphisms`. It does not descend the target scheme itself or yield a base-change isomorphism.

- Affine algebra descent is available precisely:
  `RingHom.EssFiniteType.exists_eq_comp_ι_app_of_isColimit` factors a map from a finitely presented algebra through a filtered-colimit stage, and `...exists_comp_map_eq_of_isColimit` spreads equality ([FinitePresentation.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Category/Ring/FinitePresentation.lean:34), [FinitePresentation.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Category/Ring/FinitePresentation.lean:63)).

Conclusion: porting the finite-cover/qc-overlap helper is landable immediately. A full scheme-spreading unit is not small: it still needs descending every affine chart and overlap ring, synchronizing finitely many maps/cocycle equations using the finite-presentation APIs, rebuilding `Scheme.GlueData`, and proving its base change iso chartwise. No files or index were modified.
