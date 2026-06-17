# Blueprint-writer directive — GR chapter (coverage debt + glued-scheme prover-readiness)

## Chapter
`blueprint/src/chapters/Picard_GrassmannianCells.tex` — edit ONLY this file.

## Strategy context
The Grassmannian scheme `Gr(r,d)` over ℤ is built by gluing the `Nat.choose r d` affine big-cell charts
`U^I` along overlaps `U^I_J ⊆ U^I` via the transition isos `θ_{I,J}`, which satisfy the cocycle condition.
Charts (`def:gr_affine_chart`), transitions (`def:gr_transition`), and the cocycle (`lem:gr_cocycle`) are
DONE and `\leanok`. The iter-026 prover built the entire **scheme-level transition layer** (11 axiom-clean
Lean decls) that realize the `Scheme.GlueData` fields, plus the linchpin pullback iso. These 11 decls are
currently `lean_aux` nodes with NO blueprint entry (coverage debt — the dependency graph cannot see them).
Your job: give each a blueprint block, and expand `def:gr_glued_scheme` so the GlueData build is
prover-ready.

## Task 1 — add a blueprint block for each of these 11 Lean decls (coverage debt)
For each: a `\begin{definition|theorem|lemma}` with `\label{}`, `\lean{<exact name>}`, accurate `\uses{}`,
and a one-to-three-line informal statement + proof sketch. These are mostly trivial bridge lemmas; a terse
honest block is correct and sufficient. Use the project's existing notation in this chapter (`U^I`, `P^I_J`,
`θ_{I,J}`, `Away`, `Spec`). Put them in a new subsection (e.g. `\section{Scheme-level glue-data layer}`)
placed AFTER `lem:gr_cocycle` and BEFORE the existing `\section{The glued Grassmannian scheme}`.

1. `AlgebraicGeometry.Grassmannian.minorDet_self` — `P^I_I = 1` (the `I`-minor of the universal matrix in
   chart `U^I` is the identity determinant). `\uses` the chart/minor defs. Lean relies on
   `universalMatrix_submatrix_self`, `Matrix.det_one`.
2. `AlgebraicGeometry.Grassmannian.chartOverlap` (def) — the `V`-object `U^I_J = Spec R^I[1/P^I_J]`
   (`= Spec (Localization.Away (minorDet I J))`).
3. `AlgebraicGeometry.Grassmannian.chartIncl` (def) — the open immersion `U^I_J → U^I`,
   `= Spec.map (algebraMap R^I (Away P^I_J))`.
4. `AlgebraicGeometry.Grassmannian.chartIncl_isOpenImmersion` (instance/lemma) — `chartIncl` is an open
   immersion (basic-open localization). Relies on Mathlib
   `instIsOpenImmersionMapOfHomAwayAlgebraMap` — author a `\mathlibok` Mathlib-dependency anchor for this
   (a block stating "Spec of a localization-away algebra map is an open immersion", `\lean{}` naming the
   Mathlib instance, marked `\mathlibok`).
5. `AlgebraicGeometry.Grassmannian.chartIncl_self_isIso` — `IsIso (chartIncl I I)` (the `f_id` GlueData
   field): `P^I_I = 1` is a unit, so the localization map is an iso. `\uses{}` `minorDet_self`. Relies on
   `IsLocalization.atUnit`, `ConcreteCategory.isIso_iff_bijective` (anchor candidates).
6. `AlgebraicGeometry.Grassmannian.chartTransition` (def) — the `t`-field `U^I_J → U^J_I`,
   `= Spec.map (transitionMap I J)`. `\uses{def:gr_transition}`.
7. `AlgebraicGeometry.Grassmannian.chartTransition_self` — the `t_id` field, `chartTransition I I = 𝟙`.
   `\uses` `transitionMap_self`.
8. `AlgebraicGeometry.Grassmannian.awayPullbackIso` (def) — **linchpin**: for a base ring `A` and `x,y ∈ A`,
   `pullback (Spec A[1/x] → Spec A ← Spec A[1/y]) ≅ Spec A[1/(xy)]`. Built from Mathlib `pullbackSpecIso`
   (pullback ≅ Spec of tensor) composed with `Spec` of the algebra-equiv `A[1/x] ⊗_A A[1/y] ≅ A[1/(xy)]`
   (`IsLocalization.Away.tensor` + `IsLocalization.Away.mul'` + `IsLocalization.algEquiv`). Author
   `\mathlibok` anchors for `pullbackSpecIso`, `IsLocalization.Away.tensor`/`mul'`, `IsLocalization.algEquiv`.
9. `AlgebraicGeometry.Grassmannian.awayPullbackIso_inv_fst` — `awayPullbackIso.inv ≫ pullback.fst =
   Spec.map (awayInclLeft x y)`. `\uses` `awayPullbackIso`. Relies on `pullbackSpecIso_inv_fst`,
   `AlgEquiv.commutes`.
10. `AlgebraicGeometry.Grassmannian.awayPullbackIso_inv_snd` — analogous for `pullback.snd` /
    `awayInclRight`.
11. `AlgebraicGeometry.Grassmannian.awayMulCommEquiv` (def) — the `orderSwap` ring iso
    `A[1/(x·y)] ≃+* A[1/(y·x)]` (via the `mul_comm`-transported `IsLocalization.Away` instance +
    `IsLocalization.algEquiv`). Resolves the product-order subtlety in the `t'` GlueData field.

## Task 2 — expand `def:gr_glued_scheme` to be prover-ready for the `Scheme.GlueData` build
The current block (lines ~1045–1086) describes the gluing informally but does not name the Mathlib vehicle
or the field construction. KEEP the existing Nitsure source quote and the smoothness paragraph. ADD a
construction paragraph (and extend `\uses{}` to include the new helper labels from Task 1 +
`lem:gr_cocycle`, `def:gr_transition`) describing:
- The Mathlib vehicle is `AlgebraicGeometry.Scheme.GlueData` (`Mathlib/AlgebraicGeometry/Gluing.lean`,
  extending `CategoryTheory.GlueData Scheme`). Index `J := {I : Finset (Fin r) // I.card = d}`; objects
  `U i := U^{i}` (`affineChart`); overlaps `V (i,k) := U^i_k` (`chartOverlap`); `f i k := chartIncl`
  (open immersions, mono); `f_id := chartIncl_self_isIso`; `t i k := chartTransition`;
  `t_id := chartTransition_self`.
- The `t'` field `pullback (f i j) (f i k) ⟶ pullback (f j k) (f j i)` is
  `(awayPullbackIso …).hom ≫ Spec.map (cocycleΘIJ i j k) ≫ Spec.map (awayMulCommEquiv …) ≫
   (awayPullbackIso …).inv`; the `awayMulCommEquiv` (orderSwap) inserts to reconcile the opposite product
  order `Away(b·a)` vs `Away(a·b)` of the target pullback iso.
- `t_fac` reduces (both pullbacks affine) to a ring identity via the leg lemmas `awayPullbackIso_inv_fst/_snd`
  + `Spec`-faithfulness, then `IsLocalization.ringHom_ext`.
- `cocycle` (`t' i j k ≫ t' j k i ≫ t' k i j = 𝟙`): the `awayPullbackIso` transports telescope, leaving
  exactly the ring `cocycleCondition` (`lem:gr_cocycle`) modulo the orderSwaps.
- Finally `Gr(r,d) := (theGlueData).glued`.

## Citation discipline
The Nitsure source quote already present in `def:gr_glued_scheme` covers the gluing. For the new bridge
blocks (Task 1) — these are project-bespoke Lean realizations of standard scheme glue-data; they need no
external `% SOURCE` quote (Archon-original bridge lemmas), EXCEPT the `\mathlibok` anchors, which name the
Mathlib decl in their `\lean{}` and are marked `\mathlibok` (no proof obligation). Do NOT invent a source
citation you have not read. Do NOT add `\leanok` to anything (that is sync_leanok's job) — `\mathlibok` only
on the genuine Mathlib anchors.

## Out of scope
`lem:gr_separated`, `lem:gr_proper` (already blueprinted, downstream). Do not touch the FBC/QUOT chapters.
