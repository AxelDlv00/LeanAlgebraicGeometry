# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-092 prover report

## Outcome summary
- **File compiles**: ✅ (`lake build AlgebraicJacobian.Cohomology.BasicOpenCech` exits 0, no errors).
- **Sorry count**: 6 (hard cap respected; target 5 not reached because step-(b) `simp only [hom_sum_dist]` blocker).
- **Foundation repaired**: ✅ L454:77 (set_option / doc-comment order) and L495:46 (intro / letI) both cleared.

## Step 1 (foundation repair) — RESOLVED
### Attempt 1
- **Approach (1a):** Move `/-- doc -/` block from before `set_option … in` to after, matching working pattern at L591.
- **Result:** RESOLVED — L454:77 unexpected-token error gone.
- **Approach (1b):** Replace broken `intro R … perI₁ h_mod_pi₁ perI₂ h_mod_pi₂ r y` with `intro R K₀ scK₀ Z₁ Z₂ e₁ e₂ r y` followed by a body-local `letI` reconstruction of the four module instances (verbatim copy of the conclusion-position `letI` block at L472–L491).
- **Result:** RESOLVED — L495:46 introN error gone. Goal post-intro+letI matches the iter-090/091 assumed shape.
- **Key insight:** The conclusion-position `letI` block is zeta-reduced by the elaborator (binders not surviving in the type), so it cannot be re-`intro`'d. The body-level reconstruction puts the instances in scope without changing the theorem's type.

## Step 2 (S6 chain) — PARTIAL (Branch Closed)
### Attempt 1 — step (a) `hom_sum_dist`
- **Approach:** Re-prove `ModuleCat.Hom.hom (∑ i ∈ s, f i) = ∑ i ∈ s, (f i).hom` inline by `Finset.cons_induction` over `ModuleCat.hom_add` (iter-089 template).
- **Result:** FAILED — `AddCommMonoid (M.Hom N)` synthesis fails at L555 inside the abstract `∀ {M N : ModuleCat.{u} k}` statement of the inline lemma, so the empty-case `∑ ∈ ∅` reduces to `sorry`, all downstream rewrites no-op.
- **Dead end:** The iter-086+ note that `ModuleCat.hom_sum` is "absent from Mathlib" is INCORRECT — it exists at `Mathlib.Algebra.Category.ModuleCat.Basic` L359 as `@[simp]`. The iter-086+ inline reproof failed for the same HOU reason.

### Attempt 2 — step (a) use Mathlib `ModuleCat.hom_sum`
- **Approach:** Bind the Mathlib lemma via `have hom_sum_dist := @fun M N ι => ModuleCat.hom_sum (M := M) (N := N) (R := k)`, then `simp only [hom_sum_dist]`.
- **Result (`have hom_sum_dist`):** RESOLVED — lemma binds cleanly; goal context after the `have` shows `hom_sum_dist : ∀ {M N : ModuleCat k} {ι : Type} (f : ι → (M ⟶ N)) (s : Finset ι), ModuleCat.Hom.hom (∑ i ∈ s, f i) = ∑ i ∈ s, ModuleCat.Hom.hom (f i)`. The trick: passing `(R := k)` explicitly bypasses the AddCommMonoid synthesis failure that hit the abstract inline reproof.
- **Result (`simp only [hom_sum_dist]`):** FAILED — `simp made no progress`. Same for `simp only [ModuleCat.hom_sum]`, `simp [ModuleCat.hom_sum, LinearMap.coe_comp, LinearMap.sum_apply]`, `rw [ModuleCat.hom_sum]`, `rw [ModuleCat.hom_sum (s := Finset.univ)]`, `conv_lhs => rw [ModuleCat.hom_sum]`. All report either "made no progress" or "Did not find an occurrence of the pattern `ModuleCat.Hom.hom (∑ i ∈ ?s, ?f i)`".
- **Suspected cause (HOU):** The goal contains `ModuleCat.Hom.hom (∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ Pi.π Z (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom) ≫ map_φ_i)` — the summand closure references `i` both at the SMul `(-1)^↑i •` AND deep inside the Pi.lift body via `SimplexCategory.δ i`. The lambda abstraction needed for `?f i := body[i]` requires HOU pattern matching that Lean's discrimination tree appears not to solve here.
- **Independent evidence:** Supplying the type `f : Fin (n+1) → (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂)` EXPLICITLY (instead of via the `have`) triggers a different error: `failed to synthesize instance AddCommMonoid ((∏ᶜ Z₁).Hom (∏ᶜ Z₂))`. So when the abstract `M ⟶ N` is collapsed to the concrete `(∏ᶜ Z₁).Hom (∏ᶜ Z₂)`, Lean fails to find the inherited `AddCommMonoid` instance even though the goal's `∑` was elaborated using it.
- **Next step (for iter-093):** Try `LinearMap.ext` / point-wise evaluation. Decompose `(Σ f_i).hom (e₁.symm x)` via `LinearMap.sum_apply` (`Mathlib.Algebra.Module.Submodule.LinearMap` L259) AFTER first opening up the `∘ₗ` composition into `LinearMap.comp_apply`. Or: build `Σ f_i.hom` as an explicit `AddMonoidHom` via `(M ⟶ N) →+ (M →ₗ[k] N)` (the same construction Mathlib's `hom_sum` uses internally) and apply `map_sum` manually.

## Current file state
- L455–L491: theorem signature (preserved byte-for-byte).
- L495: REPAIRED — `intro R K₀ scK₀ Z₁ Z₂ e₁ e₂ r y` (8 names, matches actual elaborated binders).
- L496–L519: body-local `letI` reconstruction of `perI₁/h_mod_pi₁/perI₂/h_mod_pi₂` (verbatim from conclusion position).
- L520–L545: S1–S5 prefix unchanged (funext, dsimp, simp, rw chain landing on `r • LHS_inner = r • RHS_inner` form).
- L546–L555: `have hom_sum_dist` (NEW — uses Mathlib `ModuleCat.hom_sum`, elaborates cleanly).
- L556–L570: explanatory comment + single `sorry` (step (b) blocked by HOU; chain trimmed).

## Goal state at the trailing sorry (verbatim from `lean_goal`, L570)
```
⊢ (ConcreteCategory.hom (Pi.π Z₂ j))
      ((ModuleCat.Hom.hom (eqToHom ⋯) ∘ₗ
          ModuleCat.Hom.hom
            (∑ i,
              (-1) ^ ↑i •
                Pi.lift fun i_1 ↦
                  Pi.π (fun i ↦ ModuleCat.of k ↑(C.left.presheaf.obj (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ i))))
                      (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))) ≫
                    (toModuleKPresheaf C).map
                      (Pi.lift fun x ↦
                          Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i)) x)).op))
        ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
    r • (ConcreteCategory.hom (Pi.π Z₂ j))
        ((ModuleCat.Hom.hom (eqToHom ⋯) ∘ₗ … (e₁.symm y))
```

Hypotheses include: `R, K₀, scK₀, Z₁, Z₂, e₁, e₂` (let-binders from the signature), `r y` (introduced),
and `perI₁/h_mod_pi₁/perI₂/h_mod_pi₂` (reconstructed via body-local letI), plus the `hom_sum_dist` `have`.

## Sorry inventory (post-iter-092)
| Line | Theorem | Notes |
|---|---|---|
| 570 | `cechCofaceMap_pi_smul` | **NEW** — step-(b) `simp only [hom_sum_dist]` HOU blocker. Deepest LSP-verified state: after S5 prefix + `have hom_sum_dist`. |
| 662 | `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` substep (a) | unchanged from iter-091 |
| 986 | (substep continuation) | unchanged |
| 1014 | substep (a) for `s₀` | unchanged |
| 1204 | `g_R.map_smul'` | unchanged |
| 1233 | `h_loc_exact` | unchanged |

Total: **6 sorries** (hard cap respected). iter-091's "5 syntactic sorries" was a syntactic-only count masking a non-compiling file; iter-092's 6 with a compiling file is strictly better.

## Final diagnostics check
`mcp__archon-lean-lsp__lean_diagnostic_messages` on the file with `severity=error` returns `[]`. `lake build AlgebraicJacobian.Cohomology.BasicOpenCech` exits 0 with `Build completed successfully (8322 jobs)`. Only linter warnings (flexible-tactic advisories at L963 / L969 / L970) remain — these are pre-existing, NOT iter-092 regressions.

## Blueprint impact
No `\lean{...}` declarations are tied to `cechCofaceMap_pi_smul` (project-local helper). No blueprint edits.

## Recommendations for plan agent (iter-093)
1. **Update PROGRESS.md / STRATEGY.md** to retract the iter-086+ claim that `ModuleCat.hom_sum` is absent — it IS in Mathlib at `Mathlib.Algebra.Category.ModuleCat.Basic` L359. The blocker is HOU pattern matching on the specific Čech-differential summand shape, NOT lemma absence.
2. **Concrete next route for step (b):** explore `LinearMap.sum_apply` after `LinearMap.coe_comp` to convert `(eqToHom.hom ∘ₗ Σ_term.hom) x` to `eqToHom.hom (Σ_term.hom x)`, then use `LinearMap.sum_apply` (Mathlib `Submodule.LinearMap` L259) to push `(Σ f_i).hom x = Σ (f_i.hom x)`. Or build `Σ f_i.hom` as an explicit `AddMonoidHom (M ⟶ N) →+ (M →ₗ[k] N)` and use `map_sum` directly (mimicking Mathlib's own proof of `hom_sum`).
3. The full chain (c)..(closure) post-iter-091 was never LSP-verified. The plan agent should NOT assume those tactics will fire on the post-(b) goal — iter-093 must verify each one with LSP after step (b) lands.
