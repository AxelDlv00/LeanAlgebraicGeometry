# Directive: blueprint-reviewer (iter-053) — whole-blueprint audit, HARD-GATE re-clear

Perform your standard whole-blueprint audit (per-chapter completeness + correctness checklist).

Context for this iter (do NOT scope-limit — audit the whole blueprint, but pay attention here):

The consolidated chapter `Cohomology_CechHigherDirectImage.tex` was edited this iter and now gates
TWO NEW Lean files via its `% archon:covers` list:
- `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean` (target `cechAugmented_exact`,
  blueprint `lem:cech_augmented_resolution`).
- `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` (targets
  `higherDirectImage_openImmersion_acyclic` + `higherDirectImage_openImmersion_comp`, blueprint
  `lem:open_immersion_pushforward_comp`).

Both files are stubbed (sorry bodies) and the project compiles. Provers are about to be dispatched on
them THIS iter via the fast path — so your verdict on `Cohomology_CechHigherDirectImage.tex` gates
both.

Edits made this iter to that chapter:
1. New block `lem:sheafify_kills_locally_zero` (3 abelian-sheaf site lemmas, already landed in Lean).
2. `lem:cech_augmented_resolution`: proof Steps 3–4 REWRITTEN to use the cover-agnostic
   prepend-\(i_{\mathrm{fix}}\) contracting homotopy (the section complex over any \(V\) contained in a
   cover member is contractible because the restricted cover has a member equal to \(V\)), replacing
   the earlier tilde/standard-cover discharger. Statement- and proof-level `\uses{}` updated to
   `lem:cech_free_eval_prepend_homotopy`, `lem:cohomology_sheaf_is_sheafify_homology`,
   `lem:sheafify_kills_locally_zero`.
3. Private helper `affine_tildeVanishing` folded into an existing `\lean{}`; `def:`→`lem:` label fix.

Specifically verify:
- Is the rewritten `lem:cech_augmented_resolution` proof now CORRECT and COMPLETE (the prepend-homotopy
  argument is the right discharger for the local vanishing; the basis `{V ⊆ some Uᵢ}` is cofinal; the
  sheafification-square transport to the abelian-sheaf site lemmas is sound)?
- Is `lem:open_immersion_pushforward_comp` complete + correct + well-formulated for its (now scaffolded)
  two-declaration Lean shape?
- `lem:sheafify_kills_locally_zero` well-formed.
- Any broken `\uses{}` / dangling labels introduced by the edits.

Report per-chapter `complete`/`correct` verdicts + any must-fix-this-iter findings, so the planner can
clear or defer each of the two new files.
