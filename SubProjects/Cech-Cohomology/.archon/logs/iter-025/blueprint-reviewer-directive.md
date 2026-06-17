# Blueprint-reviewer directive — iter-025 whole-blueprint audit (HARD GATE)

Audit the whole blueprint (`blueprint/src/chapters/*.tex`), per your standard per-chapter
completeness + correctness checklist. Report the per-chapter verdict and any must-fix-this-iter
findings.

## This iter's context (what changed since your last pass)
1. **Coverage debt cleared**: 32 prover-created helper names were bundled into the `\lean{...}`
   lists of `lem:ses_cech_h1`, `lem:cech_engine_complex`, `lem:cech_free_eval_engine_iso`,
   `lem:cech_free_eval_nonempty` (pure `\lean{}` reconciliation, no statement changes).
2. **New `def:absolute_cohomology` block** added to `Cohomology_CechHigherDirectImage.tex`:
   realizes `H^p(U,F) := Ext^p(𝒪_U, F|_U)` via Mathlib `Abelian.Ext`, with six `\mathlibok`
   Mathlib anchors (Ext LES, injective vanishing, homEquiv₀, HasExt.standard, restrictFunctor).
   `lem:affine_serre_vanishing` and `lem:cech_to_cohomology_on_basis` were rewired to `\uses` it
   and their proof prose now cites the Ext LES + `Ext.eq_zero_of_injective`.

## Gate focus (the live prover lane this iter)
The planner intends to dispatch ONE prover lane: **build `AlgebraicGeometry.injective_cech_acyclic`
in `CechBridge.lean`** (its blueprint block is `lem:injective_cech_acyclic`, ~L2562). Both its
gates — `lem:cech_free_complex_quasi_iso` and `lem:ses_cech_h1` — landed last iter. Confirm
whether `lem:injective_cech_acyclic` is **complete + correct + formalize-ready** (statement
faithful to Stacks `lemma-injective-trivial-cech`, proof detailed enough to formalize the
op-transport assembly). This is the gate that matters this iter.

Secondarily, assess whether the new `def:absolute_cohomology` block and the rewired
`lem:cech_to_cohomology_on_basis` / `lem:affine_serre_vanishing` are sound (these feed FUTURE
lanes, not this iter's, but flag any must-fix). Report any `\uses{}` you believe is missing or
any Mathlib anchor whose `\lean{}` looks wrong.

Provide your standard `## Unstarted-phase blueprint proposals` section if any strategy phase lacks
blueprint coverage.
