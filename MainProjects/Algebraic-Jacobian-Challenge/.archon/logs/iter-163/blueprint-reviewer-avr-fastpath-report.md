# Blueprint Review Report

## Slug
avr-fastpath

## Iteration
163

## Scope note
Fast-path, single-chapter re-review of `blueprint/src/chapters/AbelianVarietyRigidity.tex`
ONLY, per the iter-163 directive. Other chapters are out of scope this pass (concurrent edits
by another writer). The full chapter was read end-to-end (lines 1–1028).

## Must-fix verification (the two items flagged in `blueprint-reviewer-iter163`)

### Item 1 (was must-fix #3) — `prop:morphism_P1_to_AV_constant` Cor 1.2 internal contradiction — RESOLVED
The "$\mathbb G_a/\mathbb G_m$ argument" paragraph (lines 904–911) now invokes
`\cref{lem:hom_from_Ga_trivial}` **directly** for the whole base case, and states explicitly
that the additive-homomorphism step is established "via the additive-defect map … extended to
$\mathbb P^1\times\mathbb P^1$ and killed by the Rigidity Lemma --- *not* via
`\cref{lem:av_regular_map_is_hom}`, which applies only between abelian varieties and is
inapplicable to the non-complete $\mathbb G_a$". This matches the correct mathematics in
`lem:hom_from_Ga_trivial` (lines 838–840), which makes the identical disclaimer. The
proposition's only `\uses` edge is `lem:hom_from_Ga_trivial` (lines 870, 892) — there is no
longer any edge to `lem:av_regular_map_is_hom`. The internal contradiction is gone.

### Item 2 (was must-fix #4) — `lem:hom_additivity_over_product` group-structure provenance — RESOLVED
A "Lean encoding" paragraph was added (lines 658–668). It states `A` is `[GrpObj A]` (not
assumed commutative); `+` on `Hom(X,A)` is the GrpObj-induced operation
`u+v = ⟨u,v⟩ ≫ mul`; the decomposition is read multiplicatively as `h = (f∘p)·(g∘q)` and does
NOT require commutativity; Milne Cor 1.4 (commutativity) is needed only to rewrite the product
symmetrically/additively, not for the statement or proof. The prover is told to infer the
operation from the `GrpObj` instance rather than a `CommGrpObj` instance. This is exactly the
fix the directive described, and it removes the prior ambiguity about where `+` comes from.

## Structural integrity checks (all pass)
- **No dangling cube reference.** `grep theorem_of_the_cube` → no matches. The cube appears
  only as prose in `rmk:cube_not_needed` (lines 623–638) and `rmk:rigidity_lemma_cube_free`,
  both stating it is *not* used; no `\uses`/`\cref` edge points at the deleted
  `thm:theorem_of_the_cube`.
- **§I.3 `\uses` graph is forward-acyclic:** `hom_additivity_over_product` → `rigidity_lemma`;
  `av_regular_map_is_hom` → `hom_additivity_over_product`; `rational_map_to_av_extends` → (none
  internal); `hom_from_Ga_trivial` → `{rigidity_lemma, hom_additivity_over_product,
  rational_map_to_av_extends}`; `morphism_P1_to_AV_constant` → `hom_from_Ga_trivial`;
  `rigidity_genus0_curve_to_AV` → `{morphism_P1_to_AV_constant, genusZero_curve_iso_P1}`. No cycle.
- **Proven Rigidity-Lemma chain (lines 60–612) reads untouched + correct.** Its DAG
  (`rigidity_lemma` → `rigidity_eqOn_dense_open` → `rigidity_eqOn_saturated_open_to_affine` →
  `{morphism_eq_of_eqAt_closedPoints, rigidity_eqAt_closedPoint_of_proper_into_affine}` →
  `{eq_comp_of_isAffine_of_properIntegral, isIntegral_of_retract_of_integral}`) is
  forward-acyclic. iter-162 chain-closed notes intact.
- **Cross-chapter `\uses{def:genus}`** (lines 929, 949) resolves: `\label{def:genus}` exists in
  `Genus.tex`. Not broken.
- **Citation files exist.** All three `% SOURCE: … (read from references/…)` parentheticals in
  the §I.3 blocks name files present on disk: `references/abelian-varieties.pdf` (Milne),
  `references/mumford-abelian-varieties.pdf`, `references/hartshorne-algebraic-geometry.pdf`.
  Visible `\textit{Source: …}` pointers match the `% SOURCE:` pointers; `% SOURCE QUOTE:` and
  `% SOURCE QUOTE PROOF:` present on the relevant blocks, verbatim and in the source's English.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Both prior must-fix items (Cor 1.2 contradiction in `prop:morphism_P1_to_AV_constant`;
    missing group-structure note in `lem:hom_additivity_over_product`) are resolved.
  - `rmk:thm32_codim1_mathlib_gap` (lines 781–809) flags the Lemma 3.3 / pure-codim-1
    Mathlib-divisor gap as the route's riskiest sub-build, *on* the genus-0 critical path. This
    is correctly surfaced, not a blueprint defect — it is a prover-difficulty note for whoever
    later attacks `lem:rational_map_to_av_extends` / `lem:hom_from_Ga_trivial`, neither of which
    is the target of THIS gate. No action this pass.

## Severity summary
Severity summary: HARD GATE CLEARS — no findings.

## HARD GATE verdict
`AbelianVarietyRigidity.tex` is `complete: true` AND `correct: true` with **no** remaining
must-fix-this-iter finding. The gate **CLEARS** this iter for a prover on both targeted blocks:
- `lem:hom_additivity_over_product` → `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}`
- `lem:av_regular_map_is_hom` → `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}`

Both `.lean` targets may be added to this iter's objectives.

Overall verdict: AbelianVarietyRigidity.tex is complete + correct with both prior must-fix items
resolved; HARD GATE clears this iter for provers on `hom_additive_decomp_of_rigidity` (Cor 1.5)
and `av_regularMap_isHom_of_zero` (Cor 1.2).
