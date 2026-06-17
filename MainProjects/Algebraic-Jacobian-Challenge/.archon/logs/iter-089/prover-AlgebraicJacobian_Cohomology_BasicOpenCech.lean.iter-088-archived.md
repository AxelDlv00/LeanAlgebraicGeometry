# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Iter-087 result: IN PROGRESS — S1–S5 prefix landed in the new top-level theorem; S6 closure not attempted (LSP unavailable in sandbox).**

## File status

- 6 syntactic sorries (unchanged from iter-086 hard cap): L522 (`cechCofaceMap_pi_smul`, this iter), L614, L938, L966, L1156, L1185.
- LSP unable to bootstrap in this sandbox (`.lake/packages/*` owned by `root`; `lake build` fails with `permission denied`; `lean_diagnostic_messages` returns `success: false` with empty items on every file). **Compilation NOT verified in this environment.**
- Hard cap 6 respected. Target 5 NOT met.

## cechCofaceMap_pi_smul (body at L495)

### Attempt 1 — S1–S5 prefix transcription (RESOLVED in structure; compilation unverified)

- **Approach:** Open the body with `intro R K₀ scK₀ Z₁ Z₂ e₁ e₂ perI₁ h_mod_pi₁ perI₂ h_mod_pi₂ r y` (to peel all 12 `let`/`letI` bindings + the two ∀-binders), then transcribe the iter-082 + iter-081 + iter-086 verified S1–S5 prefix:
  1. `funext j`
  2. `simp only [Pi.smul_apply]` (RHS smul → componentwise via `h_mod_pi₂`)
  3. `have hRel : (ComplexShape.up ℕ).prev n + 1 = n` via `rcases`
  4. `dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]`
  5. `simp [FormalCoproduct.cochainComplexFunctor, ..., ModuleCat.piIsoPi, dif_pos hRel]` (alternating-sum form exposed)
  6. iter-082 S5 prelude: `rw [show ... = ModuleCat.piIsoPi Z₂ from rfl, show ... = ModuleCat.piIsoPi Z₁ from rfl]`
  7. `show (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) _ j = r • (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) _ j`
  8. `rw [ModuleCat.piIsoPi_hom_ker_subtype_apply, ModuleCat.piIsoPi_hom_ker_subtype_apply]` (j-projection surfaced)
- **Result:** Structure laid down at L495–L522. Cannot verify compilation in this sandbox.
- **Adaptation from iter-086 inline body:** The iter-086 body had additional `letI := h_mod_X₁`, `letI := h_mod_X₂`, the inline `R_restrict_R_linear` `have`, and the `hsmul_eq` rewrite. In the new top-level theorem context the conclusion uses `h_mod_pi₁`/`h_mod_pi₂` directly (no `h_mod_X_i` available), so `hsmul_eq` is not needed. `R_restrict_R_linear` was extracted as top-level `presheafMap_restrict_collapse` (iter-087 refactor) so it is no longer an inline `have`.

### Attempt 2 — S6 closure: NOT ATTEMPTED in this iteration

- **Reason:** PROGRESS.md's S6 recipe (a–h) is ~80–120 LOC of carefully-sequenced tactics with several documented Mathlib gaps (`ModuleCat.hom_sum` absent; inline `Finset.cons_induction` chain required). Without LSP feedback (sandbox issue), iterative tactic-level testing is impossible.
- **Per user policy:** instead of leaving a long-form comment block scaffolding (forbidden), a clean `sorry` is left at L522. The PROGRESS.md recipe itself is the next-step record.

## Key code change

Body of `cechCofaceMap_pi_smul` at L495–L522 in the file: the single `sorry` is replaced with a 27-line tactic block performing S1–S5 followed by a single trailing `sorry` at the post-S5 goal state.

## Next-step recipe (unchanged from PROGRESS.md)

Goal after the S1–S5 prefix (per iter-086 verification of the inline-have analog):
```
(Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) ((piIsoPi Z₁).inv (r • y))) =
  r • (Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) ((piIsoPi Z₁).inv y))
```

S6 distribution chain (a–h):
- (a) inline `hom_sum_dist` via `Finset.cons_induction` + `ModuleCat.hom_add` + base case
- (b) `rw [hom_sum_dist]` on both sides
- (c) distribute `(Pi.π Z₂ j).hom` over the outer sum via `LinearMap.map_sum` / `Finset.sum_apply`
- (d) per-`(i,j)`: `Pi.lift_π_apply` to peel `Pi.lift`
- (e) `Pi.smul_apply` on `(r • y) (j ∘ δ_i.toOrderHom)` to surface the inner R-action
- (f) `RingHom.map_mul` to split the product `restrict_{i→j}(r-restricted * y(j∘δ_i))`
- (g) `presheafMap_restrict_collapse` (top-level lemma at L425) to collapse the algebra-map chain `R = Γ(U) → Γ(V_{j∘δ_i}) → Γ(V_j)`
- (h) reassemble via `Finset.smul_sum` to match the outer `r •` on RHS

## Verified Mathlib references

- `ModuleCat.piIsoPi_hom_ker_subtype` at `Mathlib/Algebra/Category/ModuleCat/Products.lean:63` (the `_apply` form is auto-generated via `@[elementwise]`).
- `ModuleCat.hom_add`, `ModuleCat.hom_id`, `ModuleCat.hom_comp` (verified iter-086).
- `presheafMap_restrict_collapse` at L425 (project-local, fully proved iter-086, hoisted to top level iter-087).

## Mathlib gap (confirmed iter-086)

- `ModuleCat.hom_sum` does NOT exist by that direct name. Inline `Finset.cons_induction` is required (no top-level helper allowed per user policy).

## Sandbox environmental issue (pre-existing, not caused by this iter)

`.lake/packages/*` are owned by `root` in this sandbox. `lake build` fails with cascading `permission denied (error code: 13)` errors and the LSP `lean_diagnostic_messages` / `lean_goal` return `success: false` with empty items on every file. This is the same condition documented in iter-086 + iter-087 plan + iter-087 refactor reports. Validation of the S1–S5 prefix transcription must be performed in the dispatcher environment.

## Blueprint marker recommendation

The chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § "Čech acyclicity" is the relevant section. `cechCofaceMap_pi_smul` is a top-level helper used in the proof of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`; it doesn't have its own `\lean{...}` entry (it is part of the inline scaffolding of the main theorem). No blueprint edits this iteration. The plan agent flagged that the blueprint chapter path `Cohomology_BasicOpenCech.tex` referenced in the prover prompt does not currently exist; the relevant content lives in `Cohomology_MayerVietoris.tex`.

## Compliance with hard constraints

- **No new project-local top-level helpers.** ✓ The S6 `hom_sum_dist` would be an inline `have` per the recipe; in this iter only the S1–S5 prefix landed.
- **No new axioms.** ✓ No `axiom` declarations.
- **No new false-signature helpers.** ✓ The single change is replacing a `sorry` with `S1–S5 prefix + sorry`; no helpers introduced.
- **No `lean_run_code` pre-validation of candidate bodies.** ✓ Only used `lean_local_search`, `lean_diagnostic_messages`, `lean_goal` (LSP non-functional in sandbox).
- **Sorry-count budget.** Likely held at 6 (the original `sorry` at L495 was replaced by tactics ending in a single `sorry` at L522 — net change 0). Hard cap 6 respected if file compiles.
- **No 80+-line in-code comment blocks.** ✓ Replaced original `sorry` with 27 lines of code, zero scaffolding-comment lines.
- **Preserved infrastructure byte-for-byte.** ✓ All of L412–L491 (theorem signature + `presheafMap_restrict_collapse`) and L897+ (`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` body) is unchanged.

## Risk assessment for the S1–S5 prefix

The S1–S5 prefix is byte-equivalent (modulo the `intro` line and removal of the iter-086 letI/hsmul_eq tail) to the iter-086 inline-`have` body which compiled. **However**, this transcription has not been LSP-verified in this sandbox. Two specific risks:

1. **`intro` semantics on `let`/`letI` conclusion.** In Lean 4, `intro` on a `let x := e; T` goal should introduce `x` as a local let-binding. `letI` in term position should behave similarly. If the elaborator instead beta-reduces away the `let` bindings before `intro` fires, the `intro R K₀ scK₀ ...` line will fail. Recovery: drop the `intro` line and use `simp only` to unfold the lets, or call `intros r y` after the lets are reduced.
2. **`Pi.smul_apply` firing.** This depends on `[∀ i, SMul R (Z₂ i)]` being synthesizable from `perI₂`. `perI₂` is in scope after `intro`, so this should fire. If it doesn't, add an explicit `letI := perI₂` before the simp.
