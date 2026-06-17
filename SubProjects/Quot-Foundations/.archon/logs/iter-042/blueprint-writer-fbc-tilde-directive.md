# Blueprint-writer directive — Cohomology_FlatBaseChange.tex tilde-transport route (iter-042)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (only this file).

## Strategy context (the slice that matters)

The FBC affine base-change iso `g^* f_* F ≅ f'_* g'^* F` has two obligations: (1) the
affine-open locality reduction (`lem:base_change_map_affine_local`, already present and
`\leanok`), and (2) the section-level identity for the parent-frozen canonical map
`pushforwardBaseChangeMap`. Obligation (2) was pursued for 5 iterations (037–041) via
the conjugate-counit calculus; the root `lem:base_change_mate_gstar_transpose` (the
multi-layer composite-`conjugateEquiv` recognition) is a bespoke Mathlib-absent
construction the prover could not assemble. **Per the armed protocol the conjugate
route is closed off — no further conjugate rounds.**

The PIVOT (this directive) replaces obligation (2) with an **affine tilde-transport**
computation that bypasses `gstar_transpose` entirely. The iter-042 blueprint-review
(`task_results/blueprint-reviewer-iter042.md` §3) provides the full outline — a new
lemma `lem:pushforward_base_change_mate_sections_direct` and a revised proof of
`lem:pushforward_base_change_mate_cancelBaseChange`. Use that §3 outline as your
primary template (statement, `\uses{}` seams, and proof structure are given there).

## Required edits

### A. Add the new lemma `lem:pushforward_base_change_mate_sections_direct`

Author the block per blueprint-review §3 (lines 201–264 of that report). The statement:
in the affine-affine model (S = Spec R, S' = Spec R', X = Spec A, F = M̃, g = Spec ψ,
f = Spec φ), the composite `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ : R'⊗_R M → (R'⊗_R A)⊗_A M` equals
`cancelBaseChange⁻¹ : r'⊗m ↦ (r'⊗1)⊗m`, where `Θ_src`/`Θ_tgt` are the domain/codomain
reads (`lem:base_change_mate_domain_read` / `lem:base_change_mate_codomain_read`) and
`α = pushforwardBaseChangeMap`. `\uses{def:pushforward_base_change_map,
lem:base_change_mate_domain_read, lem:base_change_mate_codomain_read,
lem:cancelBaseChange_mathlib}`.

### B. **Make the affine collapse EXPLICIT (critical — strategy-critic must-fix)**

The strategy-critic's one load-bearing concern: the proof's middle step "Γ(α) on the
affine model collapses to the canonical tensor map `r'⊗m ↦ (r'⊗1)⊗m`" is exactly where
the bypass could secretly re-derive the abstract mate coherence we are trying to avoid.
Your proof prose MUST make this collapse explicit and honest, not handwaved:

- Unfold `pushforwardBaseChangeMap`'s DEFINITION (the adjunction natural transformation
  built from `(f'^*,f'_*)` and `(g^*,g_*)` units/counits applied to `𝟙 (f_* M̃)`) and
  state, step by step, how each unit/counit becomes a concrete algebra map between
  tensor products on the affine model — citing the tilde dictionary lemmas
  (`pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`) for each `Spec φ`-pullback
  and `Spec ψ`-pushforward layer. The conclusion `r'⊗m ↦ (r'⊗1)⊗m` must fall out of the
  tensor-product universal property + the algebra map `φ : R → A`, NOT out of a
  conjugate/mate identity.
- If, while writing this, you find the collapse genuinely CANNOT be done without
  re-invoking the section-level mate identity (i.e. the bypass is illusory and the
  parent-frozen map forces the coherence), STOP and report this under a
  `## Strategy-modifying findings` section in your report rather than papering it with
  vague prose. That is the reversal signal the planner armed; surfacing it honestly is
  the correct outcome.
- Flag the Lean proof approach in a `% LEAN HINT` comment: the direct computation is
  approachable via `TensorProduct.induction_on` (or `ext` + induction) unfolding the
  adjunction definition; no flatness hypothesis is needed.

### C. Revise the proof of `lem:pushforward_base_change_mate_cancelBaseChange`

The STATEMENT (lines ~3322–3352) is correct — leave it. REPLACE the proof block (lines
~3356–3388, currently routing through `lem:base_change_mate_section_identity` →
`lem:base_change_mate_gstar_transpose`) with the §3 revised proof (report lines
271–288): cite `lem:pushforward_base_change_mate_sections_direct`, conclude IsIso Γ(α)
from `cancelBaseChange⁻¹` being iso, then IsIso α from the tilde-equivalence being fully
faithful on quasi-coherent source/target. Update the proof `\uses{}` to drop
`lem:base_change_mate_section_identity` and `lem:base_change_mate_gstar_transpose`.

### D. Re-point `lem:affine_base_change_pushforward`'s `\uses{}`

Per §3 (report lines 290–304): remove `lem:base_change_mate_section_identity` and
`lem:base_change_mate_gstar_transpose` from the critical-path `\uses{}`; the conjugate
scaffolding blocks STAY in the chapter (do not delete them) as dead-end record nodes,
but they are no longer dependencies of `lem:affine_base_change_pushforward`.

## Out of scope
- Do NOT delete the conjugate-calculus blocks (conj-0/1/2b/2c/2d, `gstar_transpose`,
  `section_identity`) — they remain as a dictionary/record.
- Do NOT add or remove `\leanok`.
- Do NOT touch any other chapter.
- FBC-A2 (the affine/locality reduction itself) is already blueprinted — not your scope.

## References
Stacks 02KH (flat base change of R^i f_*), Stacks 01I9 (`widetilde-pullback`, backs
`pullback_spec_tilde_iso`). `references/**` is authorized if you need a verbatim quote;
the summaries are `references/stacks-coherent.md` (02KH) and `references/stacks-schemes.md`
(01I9). Open the actual `.tex`/`.md` before quoting.
