# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-099 prover report

## Outcome summary

- **Sorry count**: 7 → **6** (one closed, no regression). FILE COMPILES (`lean_diagnostic_messages` severity=error → `[]`).
- **Step 1 (L532)**: FULLY CLOSED — `alternating_sum_pi_smul_aux_sum_comp` body filled with the recipe from the directive.
- **Step 2 (L695 / now L728)**: PARTIALLY CLOSED — the iter-098 split-slot structural lemma is successfully *applied* at the call site; only the per-summand `hG` discharge remains as the residual sorry inside `cechCofaceMap_pi_smul`.

Aligned with the directive's **Acceptable** outcome ("close ONLY L532; L695 awaits iter-100 follow-up"), with additional structural progress on L695.

## `alternating_sum_pi_smul_aux_sum_comp` (was L532)
### Attempt 1
- **Approach**: directive recipe — `intro r y; rw [Preadditive.sum_comp s G E]; exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`.
- **Result**: RESOLVED on first try via `lean_multi_attempt` (`goals_after: []`).
- **Committed at L532–L540**: 4 lines tactic body + 3 lines comment.
- **Key insight (preserved)**: `G` and `E` are LEMMA BINDERS, so the `rw [Preadditive.sum_comp]` fires HOU-free (Miller-pattern unification), avoiding the iter-094 dead-end where `rw` on the literal Čech body failed.

## `cechCofaceMap_pi_smul` L695 trailing sorry (now L728)
### Attempt 1 — family-level bridge via `congrFun` + `alternating_sum_pi_smul_aux_sum_comp`
- **Approach**:
  ```lean
  rw [← Pi.smul_apply (i := j)]            -- lift `r • _ j` to `(r • _) j` on RHS
  refine congrFun
    (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j
  ```
- **Result**: SUCCESS — Lean's Miller-pattern unifier fills the four `_` placeholders (`Z_int`, `G`, `E`, `s := Finset.univ`) from the goal's literal shape. Only the per-summand `?hG` placeholder remains.
- **Committed at L710–L712**: 3 lines + descriptive comments.
- **Key insight**: The `Pi.smul_apply` reversal converts the goal's RHS `r • (...) j` to `(r • (...)) j`, allowing `congrFun ?_ j` to strip the `j`-evaluation symmetrically on both sides, lifting the goal from j-eval to family level. The iter-098 split-slot lemma then fires HOU-free with `?E := eqToHom ⋯` landing in its independent elaboration slot (bypassing the iter-097 Attempt-5 index-type mismatch).

### Attempt 2 — per-summand `hG` discharge (PARTIAL, ~6 routes explored)
- **Approach 2a**: directive's suggested simp chain `[Preadditive.smul_comp, ModuleCat.hom_smul, LinearMap.smul_apply, ModuleCat.hom_comp, LinearMap.comp_apply, Pi.smul_apply, map_smul]` then `rfl`.
- **Result**: FAILED. `Preadditive.smul_comp` is an unknown constant in Mathlib (the correct names are `CategoryTheory.Linear.smul_comp` for k-action and `CategoryTheory.Preadditive.zsmul_comp` for ℤ-action). Of the remaining simp lemmas, only `ModuleCat.hom_comp` + `LinearMap.comp_apply` fired (distributing the `≫` composition); `ModuleCat.hom_smul`, `LinearMap.smul_apply`, `Pi.smul_apply`, `map_smul` all reported "unused".

- **Approach 2b**: `simp only [Linear.smul_comp]` (k-action smul-comp).
- **Result**: FAILED — `simp` made no progress. Pattern `(?r • ?f) ≫ ?g` exists syntactically in the goal but does not unify, likely due to the polymorphic `(-1)^↑i` scalar not being elaborated as `k` in the Linear k context.

- **Approach 2c**: `simp only [Preadditive.zsmul_comp]` (ℤ-action smul-comp).
- **Result**: FAILED — same "pattern not found". The `(-1)^↑i` scalar must be neither `k` nor `ℤ` from Lean's perspective at this goal position, despite `(-1)^(↑i : ℕ)` being mathematically valued in `ℤ`.

- **Approach 2d**: `rw [ModuleCat.hom_smul]` AFTER the comp unfolding (where `ModuleCat.Hom.hom ((-1)^↑i • _)` is exposed).
- **Result**: FAILED — pattern `ModuleCat.Hom.hom (?s • ?f)` not found, even though the literal `ModuleCat.Hom.hom ((-1) ^ ↑i • Pi.lift ...)` is present in the goal. Hypothesis: the `Monoid S`/`DistribMulAction S _`/`SMulCommClass k S _` typeclass chain required by `ModuleCat.hom_smul` fails to synthesise with the polymorphic scalar.

- **Approach 2e**: explicit `change` with `((-1 : k) ^ (↑i : ℕ) : k)` scalar ascription.
- **Result**: FAILED — type-elaboration error inside the nested `Pi.lift` (the inner `Pi.π (basicOpenCover ↑s₀ ∘ i_1)` has unification metavariables that the explicit `change` doesn't fill).

- **Approach 2f**: smoke tests of `neg_smul`, `pow_succ`, `Int.even_or_odd'` rcases — none made progress on the head smul.

- **Decision**: committed the partial chain
  ```lean
  intro i _ r' y'
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
  sorry
  ```
  so iter-100 starts from a partially-distributed goal (eqToHom and `(-1)^↑i • Pi.lift_thing` are now separate `.hom`-applications outside `e₂`), with explicit notes in the comment block on what's needed.

## What remains for iter-100 follow-up

The residual sorry at L728 (`hG` for `alternating_sum_pi_smul_aux_sum_comp` on `cechCofaceMap_pi_smul`) requires:

1. **Force-elaborate the polymorphic `(-1)^↑i` scalar** via either (a) `change` with explicit `(-1 : ℤ)` or `(-1 : k)` ascription (taking care with the nested-`Pi.lift` metavariables), or (b) `set h : ℤ := (-1)^(↑i : ℕ)` to bind it.
2. **Then** `Linear.smul_comp` (k-route) or `Preadditive.zsmul_comp` (ℤ-route) should fire, extracting `(-1)^↑i • (Pi.lift_thing ≫ eqToHom)` from the `((-1)^↑i • Pi.lift_thing) ≫ eqToHom` form.
3. **Then** `ModuleCat.hom_smul` + `LinearMap.smul_apply` + `map_smul` (k-linearity of e₂) extract the `(-1)^↑i` past `e₂`.
4. **Then** discharge the residual R-linearity of `e₂ ∘ (Pi.lift_thing ≫ eqToHom).hom ∘ e₁.symm` using `presheafMap_restrict_collapse` (L425, fully proved iter-087) per-component.
5. **Then** `SMulCommClass` (k acts on R or ℤ acts on R) commutes the two scalars.

This is conceptually clean but mechanically involves carefully managing typeclass synthesis across the polymorphic scalar — likely 20–40 lines of tactic.

## Final state (committed)

```
L532–L540  alternating_sum_pi_smul_aux_sum_comp  — body filled (4 tactic lines)
L710–L712  cechCofaceMap_pi_smul Step 2 bridge   — congrFun + lemma application
L726–L728  cechCofaceMap_pi_smul hG residual     — partial chain + sorry
```

Sorries: L728 (NEW — was L695 trailing sorry, now reduced to hG residual), L820, L1144, L1172, L1362, L1391. Total: **6** (was 7). No new axioms, no protected signatures touched.

## Verification artefact

`lean_diagnostic_messages` (severity=error):
```
{"result":{"success":true,"items":[],"failed_dependencies":[]}}
```

## Blueprint marker

`alternating_sum_pi_smul_aux_sum_comp` is a project-local helper without a `\lean{...}` entry in `blueprint/src/chapters/Cohomology_MayerVietoris.tex`, so no blueprint edits this iter (per directive).

## Mathlib lemmas found / verified

- `CategoryTheory.Linear.smul_comp` ([loogle-verified]): `Linear R C` → `(r • f) ≫ g = r • (f ≫ g)`. **Did NOT fire** in this goal due to polymorphic scalar elaboration.
- `CategoryTheory.Preadditive.zsmul_comp` ([leansearch-verified]): `Preadditive C` → `(n • f) ≫ g = n • (f ≫ g)` for `n : ℤ`. **Did NOT fire** for the same reason.
- `ModuleCat.hom_smul` ([loogle-verified, run_code-verified in vacuum]): `(s • f).hom = s • f.hom` requires `Monoid S`/`DistribMulAction`/`SMulCommClass`. **Synthesises in isolated test but NOT in this goal** — likely a typeclass-search obstacle with the polymorphic `(-1)^↑i`.
- `Preadditive.sum_comp` (used inside `alternating_sum_pi_smul_aux_sum_comp` body) — fires HOU-free when `G`, `E` are binders, confirming the iter-098 refactor's design.

## Dead-end warnings for iter-100

- Do NOT retry `Preadditive.smul_comp` — the correct name is `CategoryTheory.Linear.smul_comp` (for k-action) or `CategoryTheory.Preadditive.zsmul_comp` (for ℤ-action).
- Do NOT retry `simp only [Linear.smul_comp]` or `simp only [Preadditive.zsmul_comp]` *without first force-elaborating* `(-1)^↑i`'s scalar type — both fail at pattern matching due to the polymorphic `(-1)^↑i`.
- Do NOT retry hand-typing the alternating-sum literal inside `suffices` blocks — re-triggers iter-097 Attempt-2 whnf timeout.
- Do NOT revert the iter-097 B1 bridge (`simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]` at L699) — the iter-099 `rw [← Pi.smul_apply (i := j)]; refine congrFun ...` chain depends on it.
