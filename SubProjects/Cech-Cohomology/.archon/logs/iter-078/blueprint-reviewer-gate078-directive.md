Whole-blueprint audit (per your standard checklist). Read the entire blueprint; do not limit scope.

Primary gate question this iter: is `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` complete + correct for the consolidated files it covers — in particular `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` (the capstone consumer)? A prover will be dispatched on that file this iter ONLY if your verdict clears the HARD GATE for this chapter.

Focus the per-chapter checklist especially on the iter-078-edited blocks:
- `lem:cech_term_pushforward_acyclic` — statement now carries `[X.IsSeparated]`, `[S.IsSeparated]`, and the `hres` per-intersection injective-resolutions family; proof routed via affine-morphism vanishing (`f∘j_σ` affine, Stacks 01SG). Confirm the statement matches a true theorem and the `\uses` is accurate.
- `lem:isQuasicoherent_pullback_opens` — new block (general-opens restrict–over bridge). Confirm statement well-formed, proof sketch adequate, `\uses` resolves.
- `lem:cech_computes_cohomology_affineCover` — statement carries `f` separated + `S` separated with `X`-separated DERIVED (separated-cancellation) and a `Scope` paragraph (X-separated specialization of 02KE). Confirm this is a faithful, formalizable target for `cech_computes_higherDirectImage_of_affineCover`, whose Lean signature will carry `[IsSeparated f]`+`[S.IsSeparated]` (NOT `[X.IsSeparated]`) + the `hres` family, deriving `X.IsSeparated` internally.
- `lem:cechAugmented_to_acyclicResolutionInput` — PProd note.

Report any must-fix-this-iter findings and broken `\uses{}`. Verdict per chapter: complete? correct? must-fix items?
