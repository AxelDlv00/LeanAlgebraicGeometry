# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Iter-086 result: IN PROGRESS — Step 1 of recipe landed; Step 2 closure stalled.**

## File status

- Compiles cleanly (0 errors, verified via `lean_diagnostic_messages`).
- 6 syntactic sorries (unchanged from iter-085): L502, L826, L854, **L1478** (this lane's
  target, was L1447 pre-edit — now shifted by the 47-line `R_restrict_R_linear` helper
  + revised comment block), L1523 (`g_R.map_smul'`), L1552 (`h_loc_exact`).
- Hard cap 6 respected. Target 5 NOT met (full closure not achieved).

## h_diff_pi_smul_f (L1032, sorry at L1478)

### Attempt 1: R_restrict_R_linear inline `have` (Step 1 of plan recipe)
- **Approach:** Inline `have R_restrict_R_linear` (lines 1406–1414) stating that
  `(presheaf.map (V≤W).op).hom ∘ (presheaf.map (W≤U).op).hom = (presheaf.map (V≤U).op).hom`
  at the element level (for any `r' : ↑R`).
- **Body:** 3 tactics: `intro V W h_VW h_VU h_WU r'`, `rw [← ConcreteCategory.comp_apply,
  ← C.left.presheaf.map_comp]`, `congr 1`. The `congr 1` closes via `Opens.op`'s
  subsingleton hom-types (any two morphisms `W → V` in `(Opens C.left)^op` are
  propositionally equal).
- **Result:** RESOLVED. Helper compiles; `lean_diagnostic_messages` confirms zero errors.
- **Statement-level subtlety:** The original recipe's signature
  `(z : C.left.presheaf.obj (Opposite.op W))` with `(... * z)` failed because Lean
  couldn't synthesise `HMul ↑(C.left.presheaf.obj (Opposite.op W))` at statement
  elaboration (typeclass resolution at the `*` site couldn't reach the bundled
  `CommRingCat` instance through the carrier coercion). Workaround: drop the `* z`
  factor and state the lemma at the element-level functoriality form only —
  `(presheaf.map ...).hom ((presheaf.map ...).hom r') = (presheaf.map ...).hom r'`.
  This is the form the per-summand argument actually needs (the `* z` factor is
  pulled out separately via `(presheaf.map ...).hom.map_mul` at the call site).

### Attempt 2: Step 2 closure chain (S6–S8 per plan recipe)
- **Goal after `rw [hsmul_eq]`:** Verified via `lean_goal` at L1466:
  ```
  (Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) (e₁.symm (r •_pi y))) =
  r •_{perI₂ j} (Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) (e₁.symm y))
  ```
  where `Σ.hom = ∑ i, (-1)^i • Pi.lift (i_1 ↦ Pi.π Z₁ (i_1 ∘ δ_i) ≫
                  (toModuleKPresheaf C).map (Pi.lift (Pi.π (basicOpenCover ↑s₀
                                                    ∘ i_1) (δ_i ·)).op))`.
- **Tactics attempted (via `lean_multi_attempt`, all FAILED to make progress):**
  - `simp only [LinearMap.comp_apply, map_sum, LinearMap.zsmul_apply, ConcreteCategory.comp_apply]`
  - `simp only [map_sum, LinearMap.coe_comp, Function.comp_apply, LinearMap.smul_apply, Finset.smul_sum]`
  - `simp only [Pi.lift_π_apply]`
  - `simp only [LinearMap.coe_comp, Function.comp_apply, ConcreteCategory.hom_ofHom]`
  - `simp only [ModuleCat.hom_sum]` — note: this lemma may not exist as named
  - `rw [ModuleCat.hom_comp]` — fails: pattern `ModuleCat.Hom.hom (?f ≫ ?g)` not
    in the goal (the `≫` sits INSIDE the `Pi.lift` inside the sum).
- **Result:** FAILED. The `Σ.hom`'s sum sits OUTSIDE the `Pi.π ≫ ...` composition.
  Surface-level simp rewrites can't peel the layers without first applying
  `ModuleCat.hom_sum`-style distributivity (which seems absent from Mathlib by that
  literal name).
- **Diagnostic:** All `simp only` invocations report `unused simp argument` warnings,
  confirming the named lemmas do not pattern-match the goal even structurally.

## Substantive iter-086 progress (mathematically meaningful, not scaffolding)

1. **`R_restrict_R_linear` is a TRUE, FULLY-PROVED lemma** with a 3-tactic body
   (`intro`, `rw [← presheaf.map_comp]`, `congr 1`) — no sorry, no axioms, no false
   signature. It is the per-summand R-linear restriction-collapse lemma exactly as
   specified in the plan recipe (modulo dropping the `* z` factor, which is pulled
   out via `map_mul` separately).
2. **Comment block reorganised** (L1420–1466): the iter-085 "obstruction" prose is
   replaced with an iter-086 progress + iter-087 path-forward summary. The
   replacement is roughly the same line count and the analysis is more concrete.
3. **The `R_restrict_R_linear` helper is now AVAILABLE in scope** as a hypothesis
   inside the `h_diff_pi_smul_f` proof body, ready to be `apply`-ed at the per-`(i,j)`
   summand site once the `ModuleCat.hom_sum`-style distribution is achieved.

## Why closure was not achieved

The plan recipe assumed the post-`hsmul_eq` goal could be tackled by reversing
direction and applying `R_restrict_R_linear` per-summand. In practice, **before
the per-summand step can fire**, the goal needs the sum to be distributed out of
the `ModuleCat.Hom.hom (∑ i, ...)` wrapper. That distribution requires a lemma like
`ModuleCat.hom_sum : ModuleCat.Hom.hom (∑ i ∈ s, f i) = ∑ i ∈ s, ModuleCat.Hom.hom (f i)`.

`lean_loogle ModuleCat.Hom.hom (∑ _, _)` returned 0 results. Only `ModuleCat.hom_add`
(two-summand) and `ModuleCat.hom_id` exist by direct name. Iterated `Finset.cons_induction`
is needed to derive `ModuleCat.hom_sum`, or `map_sum` on the additive-hom wrapper
ought to fire after suitable `change` / `show` rewriting.

Even reaching that point, the `∘ₗ`-comp split via `LinearMap.coe_comp` is documented
as failing (iter-085 finding (a)-(d), confirmed iter-086 via repeated `lean_multi_attempt`).

## Iter-087 next-step recipe (concrete, executable)

1. **Surface the sum.** Introduce
   ```lean
   have hom_sum_dist :
       ∀ (s : Finset ι) (f : ι → (M ⟶ N)),
         ModuleCat.Hom.hom (∑ i ∈ s, f i) = ∑ i ∈ s, ModuleCat.Hom.hom (f i)
   ```
   via `Finset.cons_induction` + `ModuleCat.hom_add` + `ModuleCat.hom_zero` (the
   latter via `ModuleCat.hom_id`-style or `map_zero` of the AddMonoidHom).
   *Important:* this must be an inline `have` (no top-level helper per user policy).
2. **Apply `hom_sum_dist`** at the call site of `ModuleCat.Hom.hom (∑ i, ...)` on
   both sides of the goal.
3. **Distribute `(Pi.π Z₂ j).hom`** over the resulting outer sum via
   `LinearMap.coe_sum` + `Finset.sum_apply` (now applicable, since the sum is at
   the `(Pi.π Z₂ j).hom (∑ i, ...)` level — `(Pi.π Z₂ j).hom` is k-linear hence
   sum-distributive via `map_sum`).
4. **Per-summand `(i,j)`:** use `Pi.lift_π_apply` to peel the `Pi.lift`, then
   `Pi.smul_apply` (perI₁) on the inner `e₁.symm (r •_pi y)` smul, then
   `(C.left.presheaf.map _).hom.map_mul` to split the product, then
   `R_restrict_R_linear` (already landed!) to collapse the algebra-map chain.
5. **Reassemble via `Finset.smul_sum`** on the RHS.

Total estimate: ~40–60 LOC of carefully-sequenced tactics.

## Mathlib lemmas verified to exist (via `lean_loogle`)

- `ModuleCat.Hom.hom` (the projection).
- `ModuleCat.hom_add : ModuleCat.Hom.hom (f + g) = ModuleCat.Hom.hom f + ModuleCat.Hom.hom g`.
- `ModuleCat.hom_comp : ModuleCat.Hom.hom (f ≫ g) = ModuleCat.Hom.hom g ∘ₗ ModuleCat.Hom.hom f`.
- `ModuleCat.hom_id`, `ModuleCat.hom_bijective`, `ModuleCat.hom_ext`, `ModuleCat.ofHom_hom`.

## Mathlib lemmas verified NOT to exist by direct name

- `ModuleCat.hom_sum` (iterated `hom_add` needed).
- `LinearMap.zsmul_apply` (despite plausibility — the iter-085 commentary's reference).

## Dead-end warnings

1. **Outer type-ascription `(... : ↑(∏ᶜ Z₁))`** — typeclass synthesis fails on
   `HSMul ↑R ↑(∏ᶜ Z₁) ↑scK₀.X₁` even with `letI := h_mod_X₁` in scope. Documented
   in iter-083 commentary; avoid this ascription style.
2. **`r' : ↑R` with `(r' * z)`** in `R_restrict_R_linear`'s signature — Lean fails
   to synthesise `HMul` because the carrier types differ syntactically even when
   defeq. Workaround: drop the `* z` factor and prove the cleaner element-level
   functoriality form.
3. **`change` on the `(eqToHom).hom ∘ₗ Σ.hom` form** — fails because the `eqToHom`-
   cast type proof can't be inferred without elaborator context.
4. **`induction hRel; rfl`** — motive issue (n appears throughout).

## Blueprint marker recommendation

`h_diff_pi_smul_f` is the inline sub-claim inside the main theorem; it is not a
top-level declaration, so it has no `\lean{...}` blueprint marker of its own. The
top-level theorem `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` should remain
unmarked until full closure of all 6 sorries. No blueprint edits this iteration.

## Compliance with hard constraints

- **No new project-local top-level helpers.** ✓ `R_restrict_R_linear` is an inline
  `have` inside the proof body.
- **No new axioms.** ✓ Verified via `lean_diagnostic_messages` (no axiom warnings).
- **No new helpers of the iter-085 false-signature kind.** ✓ `R_restrict_R_linear`'s
  signature is mathematically true (presheaf functoriality at the element level)
  and the body is fully proved (no sorry).
- **No `lean_run_code` pre-validation.** ✓ Only used `lean_diagnostic_messages`
  after edits and `lean_multi_attempt` for tactic probes.
- **Sorry-count budget.** ✓ 6 sorries (= hard cap, no regression).
- **Preserved infrastructure byte-for-byte.** ✓ All iter-077 → iter-085 letI/perI
  block, the iter-081 S2+S3+S4 chain, the iter-082 S5 prelude, the iter-083 letI
  block, the iter-084 `letI hmod_pi_Z₁/Z₂` + smul-commutation rewrite, the iter-085
  `hsmul_eq` rewrite are all unchanged (the comment block above the sorry has been
  revised; the tactic chain itself is byte-equal to iter-085 plus the
  `R_restrict_R_linear` insertion above `hsmul_eq`).
