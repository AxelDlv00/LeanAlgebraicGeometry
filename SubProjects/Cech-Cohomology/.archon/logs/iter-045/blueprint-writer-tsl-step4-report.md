# Blueprint Writer Report

## Slug
tsl-step4

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### 1. Coverage debt — five new blocks for the iter-044 Lean decls (placed in `TileSectionLocalization`, immediately before `lem:tile_section_comparison`)
- **Added lemma** `\label{lem:appTop_appIso_inv_eq_res}` / `\lean{AlgebraicGeometry.appTop_appIso_inv_eq_res}` — general open-immersion fact: under the section iso `β_f`, the global-sections comparison map of `f` is restriction to the image open `f(⊤)`. Proof sketch added (naturality of `f^♯` + thin-cat inclusion uniqueness). `\uses{}`: none (relies only on Mathlib `appIso_hom`, `Hom.naturality`); not isolated — consumed by `lem:key_morph`.
- **Added lemma** `\label{lem:key_morph}` / `\lean{AlgebraicGeometry.key_morph}` — Γ–Spec naturality of the localisation immersion `ι = Spec(R→R_g)`, section form: `ρ^{D(g)} ∘ θ_R = β_ι^{-1} ∘ θ_{R_g} ∘ λ`. `\uses{lem:appTop_appIso_inv_eq_res}`; Mathlib `ΓSpecIso` naturality + `specAwayToSpec_eq` cited in prose (no anchor per directive).
- **Added lemma** `\label{lem:tile_appIso_comp}` / `\lean{AlgebraicGeometry.tile_appIso_comp}` — the two tile section isos (affine identification + open inclusion) compose into `β_ι^{-1}`, up to a structure-sheaf transport `τ` along `ι(⊤)=D(g)`. `\uses{}`: none (Mathlib `comp_appIso`, `ι_appIso`); not isolated — consumed by `lem:tile_section_ring_identity`.
- **Added lemma** `\label{lem:tile_section_ring_identity}` / `\lean{AlgebraicGeometry.tile_section_ring_identity}` — assembled morphism-level ring identity `ρ^{D(g)} ∘ θ_R = β_↪^{-1} ∘ β_aff^{-1} ∘ θ_{R_g} ∘ λ`. `\uses{lem:key_morph, lem:tile_appIso_comp}`.
- **Added lemma** `\label{lem:tile_scalar_compat}` / `\lean{AlgebraicGeometry.tile_scalar_compat}` — scalar core at `V=⊤`: `r·x = λ(r)·x` on the common underlying carrier. Statement explicitly flags it is NOT the full natural iso, only the scalar equality at `V=⊤`. `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq, lem:tile_section_ring_identity}`.

### 2. Revised `lem:tile_section_comparison` (Q1, Q2)
- **Proof para 1**: rewrote "carriers coincide definitionally" → equality of the underlying section **type** only (via `lem:restrict_obj_mathlib`, F-side open kept as `W=ι(V)`); made explicit the **bundled** module objects do NOT coincide — `Mod R_g` (tile) vs `Mod R` (F) are different objects of different categories.
- **Proof para 2**: the two scalar actions *reduce* via the two rfl bridges, but their reconciliation is **not** definitional; dropped the unqualified "definitional" framing.
- **Proof closing**: named the realised route (A) — the ring identity is `lem:tile_section_ring_identity` (from `lem:key_morph` + `lem:tile_appIso_comp`), and the scalar-compat corollary at `V=⊤` is `lem:tile_scalar_compat`. Replaced the misleading "the carrier and scalar bookkeeping above is definitional" sentence.
- Added the new helpers to both `\uses{}` lists (statement + proof).
- Added a one-line `% NOTE` that the block stays UNFORMALIZED (no `\lean{}`); only its `V=⊤` scalar core exists in Lean. Did **not** pin `\lean{}` (per directive 2c).

### 3. Revised `lem:tile_section_localization` Step 4 (Q4 — critical)
- Rewrote Step 4 to describe the actual implementation path: work at the **underlying section type** (not bundled `modulesSpecToSheaf.obj`, which is a different `ModuleCat`); install `Module R` + scalar tower `R→R_g` by transport; the `V=⊤` compatibility is `lem:tile_scalar_compat`.
- **Acknowledged the `V = D(f̄)` gap** the checker raised: descent needs the same compatibility at the *target* open; `tile_scalar_compat` covers only `V=⊤`. Described obtaining the `D(f̄)` analogue by re-running the route-(A) machinery one localisation deeper at `gf` (`Γ(D(gf),𝒪)=R_{gf}`) or generalising `tile_scalar_compat` to an arbitrary basic open — flagged as mechanical reuse, not new mathematics.
- Replaced the dependence on `lem:tile_section_comparison` (unformalized) in both `\uses{}` lists with `lem:tile_scalar_compat` + the two rfl bridges `lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq`; kept the existing ingredients and the `% NOTE` warning about the unsound `restrict_obj`-rfl recipe.

## Cross-references introduced
- `lem:key_morph` `\uses{lem:appTop_appIso_inv_eq_res}` — target in this chapter ✓
- `lem:tile_section_ring_identity` `\uses{lem:key_morph, lem:tile_appIso_comp}` — both in this chapter ✓
- `lem:tile_scalar_compat` `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq, lem:tile_section_ring_identity}` — all in this chapter ✓
- `lem:tile_section_comparison` / `lem:tile_section_localization` `\uses{}` augmented with `lem:tile_scalar_compat` + bridges ✓

Verified with `leandag build --json`: `unknown_uses: []`; the 5 new `\lean{}` decls are now matched (no longer in `unmatched_lean`); `leandag show isolated` lists none of the touched nodes. LaTeX begin/end balanced (lemma 121/121, proof 91/91).

## References consulted
None — all five new blocks are project-bespoke Lean infrastructure (route-(A) Γ–Spec-naturality realisation); they stand on their proof sketches with no external citation, per directive. The Mathlib facts (`ΓSpecIso` naturality, `specAwayToSpec_eq`, `comp_appIso`) are cited in prose, not anchored, per directive.

## Macros needed
None — used existing macros (`\Spec`, `\Gamma`, `\mathcal`) and prose; `\mathrm{Mod}` and `\texttt{}` are standard.

## Notes for Plan Agent
- `lem:tile_section_comparison` deliberately remains unpinned (no `\lean{}`): only its `V=⊤` scalar core (`tile_scalar_compat`) is formalized. The full natural `R_g`-linear iso over all `V` is still an assembly target.
- Step 4's prose now states an honest sub-obligation: a `V = D(f̄)` analogue of `tile_scalar_compat` is needed for the base-ring descent. This is the next prover-facing micro-target before `tile_section_localization` closes — consider whether to (a) generalise `tile_scalar_compat` to an arbitrary basic open `V` (cleaner, one lemma serves both opens) or (b) re-run route (A) at `gf`. Option (a) seems preferable.
- The pre-existing coverage-debt items `isLocalizedModule_of_span_cover`, `isIso_fromTildeΓ_of_genSections`, `exists_finite_basicOpen_subcover` were left untouched (out of scope).

## Strategy-modifying findings
None.
