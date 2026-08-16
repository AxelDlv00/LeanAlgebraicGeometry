The target is not currently closeable by an existing preservation theorem. [`Pic0PreservesFilteredBaseColimit`](AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136) is only a named `Prop`; [`preservesColimit_pic0TypeFunctor_baseChange`](AlgebraicJacobian/Picard/PicRepColimitCompat.lean:150) merely transports an already available preservation instance through `pic0ThetaType`.

**Definition Trace**

- [`pic0TypeFunctor`](AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:58) forgets `pic0Functor`; its object is definitionally `pic0Subgroup`.
- [`pic0Subgroup`](AlgebraicJacobian/Picard/Pic0Functor.lean:107) consists of `picEt` classes having degree zero at every field-valued point.
- [`picEt`](AlgebraicJacobian/Picard/PicEt.lean:105) is the subgroup of compatible `PicEtAff` values over every affine open. On affine tests it is equivalent to `PicEtAff` via [`picEtAffineEquiv`](AlgebraicJacobian/Picard/PicEt.lean:235), naturally by [`picEtAffineEquiv_naturality`](AlgebraicJacobian/Picard/PicEtMap.lean:354).
- [`PicEtAff`](AlgebraicJacobian/Picard/PicEtAff.lean:218) is the quotient of `Σ E : EtaleCover A, descentClasses C E` by common refinement; [`mk_eq_mk_iff`](AlgebraicJacobian/Picard/PicEtAff.lean:235) exposes the equality witness.
- [`descentClasses`](AlgebraicJacobian/Picard/PicEtAff.lean:76) is the equalizer of the two maps from `relPic` to the self-tensor cover.
- [`relPic`](AlgebraicJacobian/Picard/RelPic.lean:63) is
  `CechPic(C × T) / range(CechPic(T) → CechPic(C × T))`.
  Its useful quotient APIs are [`relPicMk_surjective`](AlgebraicJacobian/Picard/RelPic.lean:74) and [`relPicMk_eq_relPicMk_iff`](AlgebraicJacobian/Picard/RelPic.lean:80).
- [`CechPic`](AlgebraicJacobian/Picard/Pic.lean:60) is itself a quotient over pointed covers; equality is exposed by [`CechPic.mk_eq_mk_iff`](AlgebraicJacobian/Picard/Pic.lean:75).

**Landed Finite Data**

The strongest useful existing substrate is genuine, not residual:

- [`exists_isFinite_toP1`](AlgebraicJacobian/Curve/MapToP1.lean:107) supplies a finite `π : C → P¹`.
- [`BasicOpenCocycleDatum.exists_cechPicClass_eq`](AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean:301) presents every class of `CechPic(C_B)` by a finite pinned basic-open datum.
- [`BasicOpenCocycleDatum.exists_fg_subalgebra_baseChange_eq`](AlgebraicJacobian/Cohomology/DatumDescent.lean:151) descends that datum to a finitely generated `k`-subalgebra.
- [`BasicOpenCocycleDatum.descent_cechPicClass`](AlgebraicJacobian/Cohomology/DatumDescent.lean:525) proves class-level base-change compatibility.

These should prove the surjective half of `CechPic(C_A)` continuity after factoring the finitely presented coefficient algebra through a diagram stage. They do not prove eventual equality of two Čech classes.

Other proved partial APIs:

- [`Scheme.cechPicEquivPic`](AlgebraicJacobian/Picard/CechPicSurjective.lean:283) identifies affine `CechPic` with `CommRing.Pic`, but no filtered-colimit theorem for `CommRing.Pic` exists.
- [`Algebra.Etale.exists_subalgebra_fg`](../../../../.lake-packages/mathlib/Mathlib/RingTheory/Smooth/NoetherianDescent.lean:280) spreads an étale algebra, but does not preserve the `EtaleCover` surjectivity certificate.
- [`Scheme.exists_map_eq_top`](../../../../.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:180) is the likely tool for making a spread étale morphism surjective after moving farther in the system.
- [`Scheme.exists_isOpenCover_and_isAffine`](../../../../.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1078) descends finite affine covers.
- Zariski assembly is proved by [`picEt.existsUnique_glue_of_le_cover`](AlgebraicJacobian/Picard/Pic0ZariskiSheaf.lean:246), [`pic0Subgroup_ext_of_le_cover`](AlgebraicJacobian/Picard/Pic0ZariskiSheaf.lean:263), and [`mem_pic0Subgroup_of_cover`](AlgebraicJacobian/Picard/Pic0ZariskiSheaf.lean:277).

**Shortest Honest Proof Path**

The genuinely short path is conditional:

```lean
(rep : (pic0TypeFunctor C).RepresentableBy J)
[LocallyOfFinitePresentation J.hom]
⊢ Pic0PreservesFilteredBaseColimit C
```

Transport through `rep.homEquiv`, use [`Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation`](../../../../.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1177) for element descent, [`Scheme.exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType`](../../../../.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:686) for eventual equality, and assemble with [`Types.FilteredColimit.isColimitOf'`](../../../../.lake-packages/mathlib/Mathlib/CategoryTheory/Limits/Types/Filtered.lean:90).

This gives a short theorem over separably closed `k`, using [`pic0_sepClosed_representableBy`](AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426) and [`locallyOfFinitePresentation_pic0_sepClosed_representableBy`](AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:112). It cannot prove the arbitrary-field target without circularly assuming the representer being descended.

For the unconditional current proposition, the remaining gates are:

1. Prove eventual equality for `CechPic(C_A)` by descending a finite common-refinement/coboundary witness.
2. Prove filtered-colimit compatibility for affine `CechPic(Spec A)` or `CommRing.Pic A`.
3. Assemble `relPic` continuity using the two preceding results and `relPicMk_eq_relPicMk_iff`.
4. Spread `EtaleCover`, its common refinements, and descent classes; restore cover surjectivity at a later stage.
5. Assemble `PicEtAff` continuity from `mk_eq_mk_iff`.
6. Prove degree-zero stabilization: if a finite-stage `picEt` class becomes degree zero at the limit, it becomes degree zero at some later stage. Existing degree invariance is only along field extensions, not arbitrary ring diagrams.
7. Descend finite affine covers and glue for the general qcqs case.
8. Finish elementwise with `Types.FilteredColimit.isColimitOf'`.

Thus the module docstring’s “equivalently, on affine tests `PicEtAff` commutes” suppresses both the degree-zero stabilization gate and the general qcqs gluing gate. The actual δ-system of fields would be a substantially smaller target: field-extension degree invariance removes gate 6, and a finite-stage rational point can bypass much of the étale-plus layer. Even that route still needs eventual equality for line-bundle/Čech data.

No files or git state were modified.
