# Blueprint Writer Directive

## Slug
cech

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Strategy context

This chapter blueprints `CechHigherDirectImage.lean` (the geometric construction + the protected
comparison theorem `lem:cech_computes_cohomology`). Route A: the augmented Čech complex is an
`f_*`-acyclic resolution of `F`, and the abstract acyclic-resolution lemma identifies its
cohomology with `(pushforward f).rightDerived i F`.

The iter-002 blueprint review rated this chapter `correct: partial`, driven by exactly TWO
citation/dependency findings (both on P3/P5 sub-lemmas). The push–pull-functor sub-graph that
feeds the ready P1 target `lem:push_pull_comp` is clean. This directive is a **scoped fix of
those two findings only**, so the chapter can re-clear the HARD GATE this iter and the P1 prover
lane can dispatch. Do NOT rewrite anything outside the two nodes named below.

## Required content

1. **`lem:cech_to_cohomology_on_basis`** (around L623, `\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}`):
   its `% SOURCE QUOTE:` for the *statement* is absent — the writer note acknowledges the
   standalone statement of Stacks `cohomology-lemma-cech-vanish-basis` lives in the Stacks
   "Cohomology" chapter, which is NOT in `references/` yet. **Retrieve Stacks `cohomology.tex`**
   (dispatch a child reference-retriever — your write-domain authorizes `references/**`) and add a
   verbatim `% SOURCE QUOTE:` for the standalone statement of
   `cohomology-lemma-cech-vanish-basis` (the basis-comparison criterion: conditions (1) closure
   under finite intersection, (2) cofinality of the admissible covers, (3) Čech vanishing on the
   basis ⇒ the Čech-to-cohomology comparison is an isomorphism). Fix the `% SOURCE:` pointer to
   name the retrieved local file (`read from references/<retrieved-cohomology-file>`). Keep the
   existing `% SOURCE QUOTE PROOF:` (the application context from `stacks-coherent.tex`) — it is
   correct and verbatim. The prose statement and the honest "general basis-comparison criterion
   for sheaves of modules on a scheme is not yet available in Mathlib — to-build dependency"
   remark are correct; leave them.

   If retrieval genuinely fails (Stacks cohomology.tex unreachable), do NOT fabricate the quote —
   leave the block flagged `% SOURCE: ... (verbatim text not yet retrieved)` and say so clearly
   in your report so the plan agent knows the citation gap persists.

2. **`lem:cech_term_pushforward_acyclic`** (around L750,
   `\lean{AlgebraicGeometry.cechTerm_pushforward_acyclic}`): its proof invokes two steps that are
   neither in `\uses{}` nor separately blueprinted:
   (a) the **presheaf description of higher direct images** — `R^k f_* G` is the sheaf associated
   to the presheaf `V ↦ H^k(f⁻¹(V), G|_{f⁻¹(V)})` (Stacks
   `cohomology-lemma-describe-higher-direct-images`, in the same Stacks cohomology.tex you are
   retrieving for item 1); and
   (b) the **Grothendieck composition degeneration** for `f ∘ j_s` when `j_s` is an affine open
   immersion (so `R^q (j_s)_* = 0` for `q ≥ 1` ⇒ `R^k f_*((j_s)_* …) = R^k (g_s)_* …`).
   Isolate each as its OWN declaration block so the dependency graph records it, then add the
   corresponding labels to this lemma's `\uses{}`:
   - For (a): add a Mathlib dependency anchor IF Mathlib provides this for `Scheme.Modules`
     (check via the Lean LSP; e.g. search for a `higherDirectImage`/`Rᵏf_*` presheaf
     description). If Mathlib provides it, mark `\mathlibok` with the real `\lean{}`. If it does
     NOT (likely, for the relative `Scheme.Modules` setting), declare it as a to-build sub-lemma
     (statement + `\lean{...}` [expected] + short informal proof + Stacks SOURCE/SOURCE QUOTE from
     the retrieved cohomology.tex). Do NOT mark `\mathlibok` on a to-build project lemma.
   - For (b): declare a to-build sub-lemma for `R^q (j_s)_* = 0` (affine open immersion into a
     separated scheme is an affine morphism ⇒ relative affine vanishing) and the resulting
     composition identity, with `\lean{...}` [expected] and a short informal proof. Cite Stacks
     `lemma-relative-affine-vanishing` (already quoted in this lemma) and the composition/Leray
     degeneration. Add its label to the `\uses{}`.
   Then add both new labels to the `\uses{}` of `lem:cech_term_pushforward_acyclic` (both on the
   lemma statement block and on its proof block).

## Out of scope
- Do NOT touch the push–pull-functor blocks (`def:push_pull_obj`, `def:push_pull_map`,
  `lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`,
  `lem:push_pull_transport_cancel`) — that sub-graph is clean and is the active P1 prover lane.
- Do NOT touch `lem:cech_acyclic_affine`, `lem:affine_serre_vanishing`,
  `lem:cech_augmented_resolution`, or `lem:cech_computes_cohomology` beyond what's needed to add
  the two new `\uses{}` labels.
- Do NOT touch any other chapter (`Cohomology_AcyclicResolution.tex` is being edited by a separate
  writer this iter).
- Do NOT add or remove `\leanok`.

## References
- RETRIEVE: Stacks Project "Cohomology" chapter source (`cohomology.tex`) from
  stacks.math.columbia.edu — needed for the verbatim statement of
  `cohomology-lemma-cech-vanish-basis` (item 1) and `cohomology-lemma-describe-higher-direct-images`
  (item 2a). Register it in `references/summary.md` as the retriever does.
- `references/stacks-coherent.tex` — already local; the existing `% SOURCE QUOTE PROOF:` blocks
  quote it correctly. `lemma-relative-affine-vanishing` is at L180–199.

## Expected outcome
The two flagged nodes are fixed: `lem:cech_to_cohomology_on_basis` carries a verbatim
`% SOURCE QUOTE:` from the retrieved Stacks cohomology.tex, and `lem:cech_term_pushforward_acyclic`
has its two previously-implicit dependencies (presheaf description of `R^k f_*`; affine-open-
immersion vanishing + composition degeneration) promoted to their own declaration blocks and wired
into `\uses{}`. The chapter is then `complete + correct` and ready to re-clear the HARD GATE for
the P1 lane. The push–pull sub-graph is untouched.
