# Effort Breaker Directive

## Slug
fbc-ecancel

## Target
`lem:base_change_mate_inner_eCancel` (in `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`).

This is the second-pass break the progress-critic (iter-024) named as the FBC STUCK corrective.
The first-pass effort-breaker (iter-023) split the gstar monolith into a 5-lemma chain; Seam C closed
axiom-clean, but Seam A's telescoping piece `inner_eCancel` (the genuinely hard ~150-LOC step) remains
the wall. This is the deeper break.

## Granularity
**Fine — one cancellation per lemma.** The whole point is that `inner_eCancel` bundles THREE distinct
cancellations into one opaque step; split it so each is an independently-formalizable lemma whose proof
is essentially a single move.

## Critical must-fix this break also resolves
The iter-023 lean-vs-blueprint-checker flagged that the blueprint blocks
`lem:base_change_mate_inner_unitReduce` and `lem:base_change_mate_inner_eCancel` carry
`\lean{...}` pins to declarations that DO NOT EXIST in the Lean file and have **no `% LEAN SIGNATURE`
hint** — prose alone is insufficient for a prover to write the stub. Your decomposition MUST give each
new sub-lemma a concrete `% LEAN SIGNATURE` block (the exact Lean `theorem` statement: explicit `letI`
algebra contexts, the source object, the target object, the result equality type). Read the LIVE Lean
goal state to draft these accurately — see "Proof structure" for where.

## Proof structure (the seams to cut along)

Read the live target site in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`:
- `base_change_mate_inner_value_eq` (theorem @~1543, body @~1569–1577) — the Seam-A conclusion whose
  residual IS `inner_eCancel`. The Γ-collapse step (ii) is already CLOSED and compiling
  (`Functor.map_comp` ×3 + `simp only [gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom]`);
  the `sorry` @1577 is exactly the `inner_eCancel` telescoping. The goal state immediately before that
  `sorry` is the live type your sub-lemma signatures must target — inspect it.
- `base_change_mate_codomain_read` (the codomain read the cancellation runs against) and the helpers
  `gammaMap_pushforwardComp_hom_eq_id`, `pullback_isEquivalence_of_iso`.

Per the iter-023 prover task result, `inner_eCancel` is THREE cancellations, in order:
1. **e-unit cancellation.** The `e`-unit (an iso) cancels against its matching `e`-piece in the codomain
   read. (The `e` here is the equivalence from `pullback_isEquivalence_of_iso` / the base-change square.)
2. **`pushforwardComp.hom` identity.** The surviving `pushforwardComp.hom` factor is an identity Γ-image
   (`gammaMap_pushforwardComp_hom_eq_id`) and drops out.
3. **`pullbackComp.hom` cancellation.** The trailing `pullbackComp.hom` cancels against the matching
   `e`-pieces baked into `base_change_mate_codomain_read`, leaving ONLY the affine `(Spec ι_A)`-unit.

After all three, what survives is the lone affine `(Spec ι_A)`-unit conjugated by the affine
tilde/Γ dictionaries over `Spec A` — which is what `inner_value_eq` then feeds to `base_change_mate_unit_value`
(Seam 1) + the `ι_A ∘ φ = ι_{R'} ∘ ψ` ring-equation transport.

Cut `inner_eCancel` into (at least) these three one-cancellation lemmas, each with a concrete
`% LEAN SIGNATURE`. Name them by convention, e.g.
`lem:base_change_mate_inner_eCancel_eUnit`, `..._pushforwardComp`, `..._pullbackComp` (pins
`AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit` etc.) — and rewrite `inner_eCancel`'s proof
(and/or `inner_value_eq`'s `\uses`) to invoke the chain. Note the chosen Lean names for the plan agent.

Also reconcile `lem:base_change_mate_inner_unitReduce`: either give it a concrete `% LEAN SIGNATURE`
(the four-factor Γ-image distribution it states) so it can be stubbed, OR — if its content is already
fully subsumed by the now-closed step-(ii) collapse inside `inner_value_eq` (the iter-023 prover judged
it was) — convert its block to a `% LEAN INTERNAL: subsumed inline in base_change_mate_inner_value_eq`
note and REMOVE its dangling `\lean{...}` pin so the dag stops listing a non-existent target as a
frontier node. Pick whichever is faithful to the live Lean structure and say which in your report.

## Strategy context
FBC-A route, gstar Seam 3. The affine base-change iso reduces (Stacks 02KH / "affine base change")
to the regroup iso via a counit-conjugation triangle: `gstar_transpose` = counit factorization → Seam C
(`gstar_counit_transport`, DONE) → Seam A (`inner_value_eq`, blocked on `inner_eCancel`) → Seam B
(`gstar_generator_close`). Closing the `inner_eCancel` chain unblocks Seam A, then `gstar_transpose`,
which cascades to `section_identity` → `affineBaseChange_pushforward_iso`.

## References
- Stacks Project, "Cohomology of Schemes", tag 02KH (affine base change), proof — the
  "describe pullbacks and pushforwards" step (`references/stacks-coherent.tex`, ~L928–938). Already
  quoted in the existing `inner_value_eq` / `gstar_generator_close` blocks; reuse those source quotes.
- This decomposition is project-bespoke categorical bookkeeping (no new external math) — the sub-lemmas
  are coherence steps, so a `% SOURCE` is only needed where the existing chain blocks already carry one.

## Out of scope
- Do NOT touch any other chapter or any `.lean` file (blueprint only).
- Do NOT add `\leanok` (sync_leanok owns it).
- Do NOT re-derive through the dead `fstar_reindex`/`_legs` apparatus.
