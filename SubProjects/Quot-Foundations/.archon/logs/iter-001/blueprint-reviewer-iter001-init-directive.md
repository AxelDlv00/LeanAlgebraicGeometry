# Blueprint review — whole-blueprint audit (iter 001, first prover round)

This is the first plan phase of a freshly extracted subproject **Quot-Foundations**
(the "Čech-independent leg" carved from the parent Algebraic-Jacobian-Challenge).
No blueprint review has run in this subproject yet. `lake build` is GREEN.

Audit the WHOLE blueprint and return your standard per-chapter completeness +
correctness checklist plus the must-fix list. The chapters and their backing Lean
files are:

- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` → `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
  (flat base change of the pushforward, i=0 case; 18 declaration nodes, 16 proved,
  2 sorry-bearing: `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`;
  two TODO helper lemmas `lem:base_change_map_affine_local`,
  `lem:pushforward_base_change_mate_cancelBaseChange` whose `\lean{}` pins are
  `AlgebraicGeometry.TODO.*` placeholders — i.e. no Lean declaration exists yet).
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` → `AlgebraicJacobian/Picard/FlatteningStratification.lean`
  (generic flatness, Nitsure §4; `genericFlatness` sorry-bearing; `thm:generic_flatness_algebraic`
  is a TODO `\lean{AlgebraicGeometry.TODO.genericFlatnessAlgebraic}` placeholder).
- `blueprint/src/chapters/Picard_QuotScheme.tex` → `AlgebraicJacobian/Picard/QuotScheme.lean`
  (Hilbert polynomial, Quot functor, Grassmannian scheme + representability; 4 stubs, all sorry).
- `blueprint/src/chapters/Picard_RelativeSpec.tex` → `AlgebraicJacobian/Picard/RelativeSpec.lean`
  (relative Spec; supporting, all 5 nodes proved).

## What I most need from you

1. Per-chapter `complete: true|partial|false` and `correct: true|partial|false`, with
   the must-fix-this-iter findings that gate prover dispatch on each file.
2. **TODO-pin honesty.** For the three TODO-pinned nodes
   (`base_change_map_affine_local`, `pushforward_base_change_mate_cancelBaseChange`,
   `genericFlatnessAlgebraic`): is each informal proof detailed and correct enough
   that a prover could *scaffold the real Lean declaration with a faithful signature
   and attempt the proof*? Or is any of them too thin / hand-wavy at the crux
   (the adjoint-mate ↔ cancelBaseChange coherence computation; the affine-reduction
   naturality of the base-change map; the prime-filtration dévissage of generic
   flatness algebraic)?
3. **Signature faithfulness.** For the existing sorry-bearing Lean decls, do their
   signatures genuinely support the blueprint statement (coherence/finiteness/
   quasi-coherence hypotheses present where the math needs them)?
4. **Scope coherence.** `thm:flat_base_change_pushforward`'s informal proof relies on
   Čech-cohomology / affine-cover infrastructure for `SheafOfModules`. Flag whether
   that proof is realizable in a leg explicitly billed "Čech-independent," or whether
   the chapter needs a Čech-free i=0 route (e.g. H⁰ as a finite limit/equalizer that
   flat `-⊗B` preserves).

Reports go under `task_results/`. Read the chapters directly; do not rely on this
directive's summaries.
