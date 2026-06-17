# Effort-breaker — decompose `lem:base_change_mate_section_identity`

Chapter: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`. You edit ONLY this chapter. You may
also write `references/**` (Stacks 02KH/affine-base-change source is at `references/stacks-coherent.tex`).

## Target
`lem:base_change_mate_section_identity` (`AlgebraicGeometry.base_change_mate_section_identity`,
statement block ≈ line 1370, proof ≈ line 1439). Its Lean decl EXISTS with a typed `sorry` (the LHS
crux, `FlatBaseChange.lean:1011`). The RHS is computable (`regroupEquiv.inv`, axiom-clean). The LHS —
the adjoint-mate unwinding of `pushforwardBaseChangeMap` read on global sections through the two
tilde dictionaries `Θ_src`/`Θ_tgt` over the generic pullback square — is Mathlib-absent and the
current proof sketch narrates it at too high a level to formalize. A raw prover re-dispatch would
churn (progress-critic iter-012: FBC CONVERGING but "do NOT raw-redispatch").

## Granularity
**One level**, but each resulting sub-lemma MUST carry its own `% LEAN SIGNATURE` block (not prose
only). The progress-critic's hard requirement (the iter-007 lesson): prose-only stubs produce zero
prover output; the prover refused to guess types for adjunction-unit / pseudofunctor-reindex /
transpose-on-elements. To pin faithful signatures you MUST read the existing FBC Lean infrastructure
in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (you may read Lean; you write only blueprint):
the decls `pushforwardBaseChangeMap`, the adjunction `pullbackPushforwardAdjunction` (or whatever the
file names the `(g'^*, g'_*)` / `(g^*, g_*)` adjunction unit/counit), `moduleSpecΓFunctor`, and the
tilde dictionaries packaged in `base_change_mate_domain_read` (`Θ_src`) /
`base_change_mate_codomain_read` (`Θ_tgt`). Pin each sub-lemma's type against those real decls.

## Proof structure (cut along these three seams — the iter-011 prover identified them)
The LHS unwinding `Θ_tgt ∘ Γ(pushforwardBaseChangeMap …) ∘ Θ_src⁻¹ = regroupEquiv.inv` decomposes as:

1. **`base_change_mate_unit_value`** — the `pullbackPushforwardAdjunction` unit applied to the
   affine object `tilde M` (i.e. `g'^*` of the unit of `((g')^*, (g')_*)`) equals, on global sections
   through the tilde dictionary, the base-change of the algebraic unit `η_M : m ↦ (1⊗1)⊗ₜ m` of
   extension of scalars along `A → A ⊗_R R'`. (The "base-change map IS the base change of the unit"
   step.) Pin: source/target `ModuleCat`s, and the equality as a morphism identity.

2. **`base_change_mate_fstar_reindex`** — the pushforward `f_*` reindexes as `restrictScalars φ` and
   the pushforward pseudofunctor identities `(g'∘f)_* = (f'∘g)_*` (the two factorizations of the
   pullback square's composite) let `Γ` of the comparison be read on the `restrictScalars` side. Pin
   the reindex identity relating `Γ(pushforwardBaseChangeMap …)` to the algebraic `lTensor`/regroup
   data via the pseudofunctor coherence.

3. **`base_change_mate_gstar_transpose`** — the `(g^*
   ⊣ g_*)` transpose for `ψ = Spec map` relates the adjunction transpose of the comparison to the
   domain/codomain tilde dictionaries `Θ_src`/`Θ_tgt` on global sections. Pin the transpose identity.

Then the top-level proof of `lem:base_change_mate_section_identity` becomes: chain (1)+(2)+(3) to
rewrite the LHS into `lTensor R' η_M` on generators, then match `regroupEquiv.inv` by
hom-extensionality on `r'⊗m` (already in the existing sketch). Update the section-identity proof to
`\uses{}` the three new sub-lemmas and reduce the prose to the chaining argument.

Wire `\uses{}` so each sub-lemma is a leaf the prover can attack independently, and the section
identity depends on all three. If a sub-lemma is itself still too large to pin a single signature,
say so explicitly in your report (it then needs a second, finer break next iter) — do NOT paper over
it with vague prose.

## Secondary cleanups (same chapter, blueprint-reviewer iter-012 should-fix)
- **F-2a**: `lem:base_change_mate_regroupEquiv` prose uses the `R' ⊗_R A` orientation; the landed Lean
  uses Mathlib's `A ⊗[R] R'` (`pullbackSpecIso`) orientation, and builds the equiv INLINE via an `eT`
  identity-bridge + `TensorProduct.induction_on` (the `cancelBaseChange` helper route was abandoned
  over the `extendScalars` diamond). Update the prose to match the Lean orientation + the inline
  construction (the standalone helper `lem:base_change_regroup_linearEquiv` is imported but not the
  realized route — note it as conceptual content, not the build).
- **F-2b**: `lem:pushforward_base_change_mate_cancelBaseChange` and `lem:base_change_mate_generator_trace`
  prose claim the full equality; the Lean formalizes the `IsIso` corollary only. Adjust the statement
  prose to the `IsIso` form, relegating the equality to the proof sketch.

## Out of scope
- Do NOT touch `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward` (downstream).
- Do NOT add `\leanok`. `\mathlibok` only on genuine Mathlib anchors.

## Report
List the 3 sub-lemma labels + the EXACT `% LEAN SIGNATURE` you pinned for each (against the real Lean
decls you read). If you could NOT pin a faithful signature for any of the three, say which and why —
that is the signal the planner needs (it would mean a mathlib-analogist consult on Mathlib's
base-change-comparison coherence is required before a prover, not another effort-break).
