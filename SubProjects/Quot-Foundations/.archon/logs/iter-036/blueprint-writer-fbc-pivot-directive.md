# Blueprint Writer Directive

## Slug
fbc-pivot

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Strategy context
The affine base-change lemma `affineBaseChange_pushforward_iso` (Stacks Cohomology of Schemes, tag 02KH,
the `i=0` affine case) states the canonical map `pushforwardBaseChangeMap : g^* f_* F ⟶ f'_* g'^* F` is an
isomorphism when `f` is affine and `F` quasi-coherent. Its affine close has TWO obligations:
- **(obligation 1) affine reduction**: identify `(pushforwardBaseChangeMap …).app U` (for an affine open
  `U = Spec R' ⊆ S'`, with a chosen affine `Spec R ⊆ S` containing `g(U)`) with the affine–affine
  base-change map of the restricted cartesian square. This is restriction-compatibility of
  `pushforwardBaseChangeMap`, Mathlib-absent, a separate large build. **OUT OF SCOPE this round.**
- **(obligation 2) section-level identity**: on the fully-affine model the section-level base-change map is
  an isomorphism (needs no flatness). This is what the chapter currently routes through the mate-coherence
  chain `pushforward_base_change_mate_cancelBaseChange` → `base_change_mate_section_identity` →
  `base_change_mate_gstar_transpose`, and `…_inner_value_eq` → `…_fstar_reindex_legs` → conj-2a.

**ROUTE PIVOT (this iter).** The conjugate-side discharge of obligation 2 (re-encode the comparison via
`Scheme.Modules.leftAdjointCompIso` of the free morphisms, then `conjugateEquiv.injective` + the reassoc
conjugate simp set) is EXHAUSTED — it bottoms at the section-composite→`conjugateEquiv`-component reframing
under the `X.Modules` instance diamond (5-iter stall). It is ABANDONED. The new active route for
obligation 2 is the **affine-local explicit inverse + element-`ext`**:

> In the fully-affine model every object is `Spec` of a ring and every module is `M^~`, so `Γ` is
> conservative and a `ModuleCat`-morphism is an isomorphism iff it is bijective on underlying modules.
> The section-level base-change map identifies, after passing through the tilde–Γ counit isomorphisms, with
> the regrouping comparison `R' ⊗_R M ⟶ (R' ⊗_R A) ⊗_A M`. The lemma `regroupEquiv` (chapter
> `Cohomology_RegroupHelper.tex`, the `A`-linear isomorphism `(A ⊗_R R') ⊗_A M ≅ R' ⊗_R M`, axiom-clean)
> supplies a two-sided inverse. One proves the two round-trips (`θ ≫ inv = 𝟙` and `inv ≫ θ = 𝟙`) by
> `ModuleCat`-extensionality — checking equality on pure tensors `r' ⊗ (a ⊗ m)` / `r' ⊗ m` by an element
> chase — so the mate normal form is never produced and the `X.Modules` diamond is never crossed. `IsIso`
> of the section-level map (hence of obligation 2) follows from the two round-trips.

## Required content

1. **Rewrite the obligation-2 route in the chapter to the explicit-inverse argument.** Add a small
   `\uses`-linked chain of blocks describing the new route (project-bespoke proof technique; the *statement*
   is Stacks 02KH, the affine case). Suggested decomposition (the prover will pick exact Lean names; give
   informal statements + sketches):
   - a block for the **explicit inverse** of the affine–affine section-level base-change map, built from
     `regroupEquiv` and the tilde–Γ counit isomorphisms (`\uses{lem:regroupEquiv_*}` from
     `Cohomology_RegroupHelper.tex`, the `gammaPushforwardTildeIso`/`fromTildeΓ` counit blocks already in
     this chapter);
   - a block for **round-trip 1** (`map ≫ inverse = 𝟙`) proved by `ModuleCat`-extensionality / pure-tensor
     element chase;
   - a block for **round-trip 2** (`inverse ≫ map = 𝟙`) likewise;
   - a block assembling **`IsIso` of the section-level map** (obligation 2) from the two round-trips, and
     stating how it feeds `affineBaseChange_pushforward_iso` together with obligation 1 (the affine
     reduction, out of scope).
   Pin `\lean{}` only where a Lean name is known/expected; for to-be-built decls describe by name in prose
   and leave `\lean{}` as the expected name the prover will create (do NOT invent a non-existent name as if
   it exists). Mark nothing `\leanok`.

2. **Mark the conjugate route as SUPERSEDED (keep the blocks, do NOT delete).** The conjugate chain decls
   (`lem:base_change_mate_codomain_read_legs_conj` (conj-1a), `…_conj_eq` (conj-1b),
   `…_reindex_conj_pushforwardCollapse` (conj-2c), `…_reindex_conj_pullbackLeg` (conj-2b),
   `…_reindex_conj_crossLayer` (conj-2d), `…_fstar_reindex_legs_conj` (conj-2a), `conjPullbackFactor`,
   `conjPullbackFactor_eq_pullbackComp`) and `lem:base_change_mate_gstar_transpose` are the abandoned
   route. Add a brief prose note at the head of that section that obligation 2 is now discharged by the
   explicit-inverse route above, so these blocks are inert scaffolding retained only because their Lean
   decls still exist (the proven ones) / are no longer on the critical path (conj-2a, gstar_transpose).
   Do NOT delete any block whose `\lean{}` names a live Lean declaration.

3. **Fix the MAJOR mismatch on `lem:base_change_mate_codomain_read_legs`** (checker iter-035): its prose
   says the pullback factor is assembled as `leftAdjointCompIso`, but the pinned Lean decl
   `base_change_mate_codomain_read_legs` (line 1254) uses `pullbackComp`. Correct the prose to describe the
   `pullbackComp` (variable-legs) form. Move the two `\uses` entries `lem:leftAdjointCompIso_mathlib` and
   `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` OFF this block and ONTO
   `lem:base_change_mate_codomain_read_legs_conj` (conj-1a), which is the block that actually uses
   `leftAdjointCompIso`.

4. **Add coverage-debt blocks** (4 Lean decls with no blueprint block; bespoke conjugate-route scaffolding,
   give thin one-line-proof entries with accurate `\uses`):
   - `\lean{AlgebraicGeometry.conjPullbackFactor}` (noncomputable def; `leftAdjointCompIso` of the free
     legs `e`, `Spec ιA`).
   - `\lean{AlgebraicGeometry.conjPullbackFactor_eq_pullbackComp}` (= `pullbackComp e.hom (Spec ιA)`;
     `\uses{lem:pullbackComp_eq_leftAdjointCompIso}`).
   - `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs_param}` (noncomputable def; the codomain
     read with the pullback factor abstracted as an explicit iso argument `Pcomp`).
   - `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs_eq_param}` (the original read = `_param` at
     `pullbackComp`, by `rfl`).

5. **Sharpen `lem:gammaMap_pushforwardCongr_hom`**: the result is `= eqToHom (proof that the domains
   agree)`, not "the identity morphism" (the Lean statement is the more precise `eqToHom` form).

## Out of scope
- Obligation 1 (the affine reduction / restriction-compatibility @ line 2303) — separate Mathlib-absent
  build, not this round.
- `flatBaseChange_pushforward_isIso` (the global flat case / FBC-B globalization) — gated downstream.
- Any `\leanok` marker (forbidden — managed by sync_leanok).

## References
- `references/stacks-coherent.md` → `references/stacks-coherent.tex`: tag 02KH (flat base change of
  `R^i f_*`, the `i=0` / affine case). Cite the affine-base-change statement verbatim for the
  obligation-2 / `affineBaseChange_pushforward_iso` block.
- `references/stacks-schemes.md` → `references/stacks-schemes.tex`: tag 01I9 (`lemma-widetilde-pullback`)
  — the `ψ^* M̃ = (S⊗_R M)~` source underlying the regroup comparison.
- The explicit-inverse element-chase itself is project-bespoke (no external proof to quote); the blocks for
  the inverse/round-trips stand on their sketch alone (omit `% SOURCE` lines for those bespoke blocks).

## Expected outcome
The chapter's affine-close section reads as: obligation 1 (affine reduction, owed separately) + obligation 2
discharged by the explicit-inverse + element-`ext` route (new `\uses`-linked blocks), with the conjugate
chain retained but flagged superseded. The `codomain_read_legs` mismatch is fixed, the 4 coverage-debt
helpers have blocks, and `gammaMap_pushforwardCongr_hom` is sharpened. No `\leanok` touched.
