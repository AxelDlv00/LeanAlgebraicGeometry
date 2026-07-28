You are surveying the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (read-only; do NOT edit any file).

I need a precise API inventory to build `chartLocus c lambda`, a locus over a GENERAL TEST scheme T (a point set in T.left, or in `(T : Over (Spec (.of k))).left`), indexed by a "plus class" `lambda : pic0Subgroup C (Over.mk a)`, at the twisted fibre class `lambda_t * theta^m * (-Sigma)`, requiring: the fibre class at the residue field kappa(t) has an effective degree-g witness divisor with h^1 = 0.

Report EXACT declaration names, full signatures, and `file:line` for each of the following. Use `grep -n` and read files. Be exhaustive and literal — I will write Lean against your output, so signatures must be verbatim.

1. `pic0Subgroup` — definition and its carrier type; how an element is coerced/used; `pic0Map`. Which file/line.
2. `picEt`, `PicEtAff`, `PicEtAff.mk`, `picEtAffineEquiv` — the "collapse to an honest class over an affine/field base" API. Include `relPicToPicEt`, `relPicMk`, and any `picEtMap`.
3. The field-point witness predicate: anything named like `HasWitnessH1Vanishing`, `hasWitnessH1Vanishing`, plus `BasicOpenCocycleDatum` (its definition/fields), `cechPicClass`, `exists_cechPicClass_eq`, `hasWitnessH1Vanishing_congr_of_cechPicClass_eq`, `isOpen_setOf_exists_witness_h1_vanishing`. Give the exact statement of each.
4. `Scheme.CechPic`, `Scheme.CechPic.map`, `relCurve`, `relCurveMap`, `Scheme.CurveDivisor`, `Scheme.CurveDivisor.picClass`, `Scheme.CurveDivisor.deg`, `divisorSheaf`, `Sheaf.HModule` — exact signatures.
5. `thetaCechClass`, `classDeg`, `chartValue`, `chartValue_mem_pic0Subgroup`, `degAt`, `sigmaFamily`, `abelDiv` — exact signatures and files. Also anything named `ChartIndex`.
6. Everything in `AlgebraicJacobian/Picard/Pic0ChartLocusOpen.lean` and `AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean`: list every `theorem`/`def`/`lemma` name with its full statement (these two files are ~small; quote their declarations verbatim).
7. How a point `t` of a scheme `T` yields a residue field and a `k`-algebra map / a morphism `overSpec k (residue field) ⟶ T`: search for `residueField`, `Scheme.fromSpecResidueField`, `overSpec`, `Scheme.Hom.residueFieldMap`, and any project-local helper that turns a scheme point into a field-valued test object of `Over (Spec (.of k))`. This is crucial — I need to know how the project models "the fibre of a class at a point of a general test".
8. Any existing declaration whose name contains `Locus` or `locus` in the Picard directory, with its statement.
9. `IsOpenImmersion.presheaf` (mathlib) and `Scheme.LocalRepresentability` — the exact shape mathlib requires, and any project file that already produces an `IsOpenImmersion.presheaf`.
10. `divFunctor`, `divFamZar`, `DivFamZar`, `DivRepGlobalData`, and the parametric idiom at `AlgebraicJacobian/Picard/DivRepKit.lean:113` — quote the surrounding declaration verbatim.

Output as a compact reference document. No commentary about strategy — just the inventory with exact signatures and file:line anchors.
