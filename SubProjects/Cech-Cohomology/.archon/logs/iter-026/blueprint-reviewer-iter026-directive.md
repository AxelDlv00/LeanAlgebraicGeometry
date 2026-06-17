# Directive: whole-blueprint audit (iter-026), HARD GATE for the AbsoluteCohomology.lean scaffold

Audit the WHOLE blueprint per your standard per-chapter checklist (completeness + correctness,
proof-detail adequacy, well-formed Lean targets, broken `\uses`, source-quote fidelity).

## This iter's focus (do NOT scope away the cross-chapter view — just weight attention here)
The absolute-cohomology realization in `Cohomology_CechHigherDirectImage.tex` was rewritten this iter
to **Form B**: `H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)` with
`jShriekOU U := sheafification(free(yoneda U))` the corepresenting object of `F ↦ Γ(U,F)=F(U)`
(`= j_!O_U` up to iso, built WITHOUT the extension-by-zero functor). New blocks: `def:jshriek_ou`,
`lem:jshriek_corepr` (corepresentability iso `Hom(jShriekOU U, F) ≅ F(U)`, proved by composing
`sheafificationAdjunction.homEquiv` with the project's `freeYonedaHomAddEquiv`). `def:absolute_cohomology`
rewritten; the `restrictFunctor` anchor removed; the 01EO `lem:cech_to_cohomology_on_basis` proof prose
updated so injective vanishing uses the injective `I` as the SECOND Ext argument (no restriction taken).

## The gate question
I intend to dispatch a `mathlib-build` prover this iter to scaffold a NEW file
`AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` building exactly:
`AlgebraicGeometry.jShriekOU`, `AlgebraicGeometry.jShriekOU_homEquiv`, `AlgebraicGeometry.absoluteCohomology`,
plus the H⁰=Γ iso, the injective-vanishing wrapper, and the covariant-LES wrappers — the ~50–80 LOC of
reuse the realization needs. Report whether the absolute-cohomology section (the three new/rewritten
blocks + their Mathlib anchors + the 01EO proof that consumes them) is **complete + correct** and gives
the prover enough to formalize these declarations. Specifically check:
- Are `def:jshriek_ou` / `lem:jshriek_corepr` well-formed Lean targets (clear statement, accurate
  `\uses`, a formalizable one-line proof for the corepr iso)?
- Does `def:absolute_cohomology`'s three-clause structure (H⁰=Γ via `Ext.homEquiv₀`∘corepr; injective
  vanishing via `Ext.eq_zero_of_injective` with `I` 2nd arg; LES via `Ext.covariant_sequence_exact*` at
  fixed 1st arg) correctly read off the off-the-shelf Mathlib Ext API? Are the five Ext `\mathlibok`
  anchors' `\lean{}` names real Mathlib declarations?
- Is the 01EO proof now self-consistent under Form B (no leftover Form-A `O_U`/`F|_U`/restriction
  language in the realization)?
- Any broken `\uses{}` introduced by the rewrite (`def:jshriek_ou` uses
  `def:cech_free_presheaf_complex`, `lem:mod_pmod_adjunction`, `lem:cech_complex_hom_identification`)?

Report per the HARD-GATE convention: for the chapter `Cohomology_CechHigherDirectImage.tex` give a
single `complete:` / `correct:` verdict (it is a `% archon:covers` consolidated chapter) and name any
must-fix-this-iter finding. Also surface any `## Unstarted-phase blueprint proposals` as usual.
