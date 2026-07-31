You are a READ-ONLY census agent in the Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon, project MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR, Lean 4, root module AlgebraicJacobian). Do NOT edit any file. Report exact declaration names, file:line, and FULL statements.

CONTEXT. `AlgebraicGeometry.relPic C T = (C ⊗ T).left.CechPic ⧸ picFromBase C T` (AlgebraicJacobian/Picard/RelPic.lean:63), where `picFromBase C T` is the range of `CechPic.map (snd C T).left`. I want to prove: for an arbitrary commutative k-algebra A and C a genus-0 curve, a class `L : (C ⊗ overSpec k A).left.CechPic` whose degree at every field point of Spec A vanishes lies in `picFromBase C (overSpec k A)`.

CENSUS, exhaustively:

1. WHAT `Scheme.CechPic` IS: its definition (find the file), its API, and above all the DICTIONARY between `CechPic` and honest line bundles / `Scheme.Modules` / `CommRing.Pic`: e.g. `cechPicEquivPic` (I am told it is in a file named like CechPicSurjective.lean), any `CechPic.map`, functoriality, exactness, injectivity/surjectivity lemmas. Say plainly whether CechPic is a cocycle-with-respect-to-a-chosen-cover construction or a colimit over covers, and what data a term of it carries.

2. EVERY existing tool for proving membership in `picFromBase` (or for proving a `relPic` element is `1`): list all lemmas mentioning `picFromBase`, `relPicMk_eq_relPicMk_iff`, and any "pulled back from the base" criterion.

3. THE TWO-CHART MACHINERY: files AlgebraicJacobian/Tangent/TwoChartCechPic.lean, TwoChartRepresentable.lean and neighbours. Give the exact statements of `twoChartClassHom`, `twoChartClass_injective`, `twoChartClassHom_surjOn_of_chartTrivial` and their hypotheses; state exactly which scheme/base they are about (P1 over a field only? over an arbitrary base? a general two-chart cover?), and whether the base may be `Spec A` for a general ring A.

4. `classDeg`, `relPicDeg`, `degAt`: where defined, what they take, and every lemma concluding a class is trivial FROM degree information (any injectivity statement for the degree map).

5. Finally: search the project for any theorem whose conclusion is `x ∈ picFromBase …`, or `relPicMap … = 1`, or `Subsingleton (relPic …)`, or `Subsingleton (picEt …)`, or `Subsingleton (pic0Subgroup …)` — I want the complete producer list for those shapes, with hypotheses.

Use `"$HORIZON_BIN" search "<name or words>" --json` (indexes AJCR, AJC and mathlib) plus targeted grep. Terse prose, exhaustive names. Final message = the report, ending with 5 lines on the cheapest existing route from "fibrewise degree 0 over a ring" to `picFromBase` membership, and what is missing.
