# Cohomology/BasicOpenCech.lean — iter-077 prover

## Outcome

- **File compiles cleanly** (0 errors).
- **Sorry count**: 7 → **6** (closed `f_R.map_smul'`).
- **No new axioms.**
- **No new project-local helper lemmas** (per user policy 2026-05-11).
- **No `lean_run_code` pre-validation** (per user policy). All checks via
  `lean_diagnostic_messages` after each edit.

## Sorries — old (iter-076) vs new (iter-077) mapping

| Line (iter-076) | Line (iter-077) | Declaration             | Status            |
|-----------------|-----------------|-------------------------|-------------------|
| L495            | L495            | substep (a) on `s`       | unchanged (dead end) |
| L819            | L819            | `h_π_split` (kernel-π)  | unchanged (dead end) |
| L847            | L847            | substep (a) on `s₀`     | unchanged (dead end) |
| L1077           | L1079           | `h_diff_pi_smul_f`      | unchanged (still sorry) |
| L1106           | —               | `f_R.map_smul'`         | **CLOSED** (-1) |
| L1116           | L1119           | `g_R.map_smul'`         | unchanged (still sorry, see g-side blocker) |
| L1145           | L1148           | `h_loc_exact`           | unchanged (still sorry) |

Net: **-1 sorry** (within budget; target was ≤ 5, achieved 6).

## What changed

### 1. Rebuilt `h_mod_X_i` to be a **literal** `e_i.toAddEquiv.module R`

`letI` (not `have`) so the module instance registers with typeclass synthesis,
and `exact e_i.toAddEquiv.module R` (not `convert h`) so the underlying smul
is exactly `e_i.toEquiv.smul R` — i.e. `r • x = e_i.symm (r • e_i x)` by `rfl`
(`Equiv.smul_def` is itself `rfl`).

```lean
letI h_mod_X₁ : Module R scK₀.X₁ := by
  dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
    toModuleKSheaf, toModuleKPresheaf_obj]
  letI := h_mod_pi₁
  exact e₁.toAddEquiv.module R
-- (analogous for X₂ and X₃; X₃ pre-rewrites `(up ℕ).next n` via `CochainComplex.next`)
```

The iter-076 analysis claim that `convert h` introduces "residual eta
congruence" turned out to be **partially correct in spirit but mis-diagnosed
in detail**: the actual blocker was the use of `have` (which does NOT register
as a typeclass instance), not the use of `convert`. With `letI` + `exact`,
the instance is both literal AND registered. The `Module R scK₀.X_i` instance
that typeclass synthesis finds for `r • x` is now literally
`e_i.toAddEquiv.module R` (visible in the goal state as
`h_mod_X₁ : Module ↑R ↑scK₀.X₁ := id (AddEquiv.module (↑R) e₁.toAddEquiv)`).

### 2. Closed `f_R.map_smul'`

Goal: `(scK₀.f)(r • x) = (RingHom.id R) r • (scK₀.f x)`.

```lean
intro r x
change (ConcreteCategory.hom scK₀.f) (e₁.symm (r • e₁ x)) =
  e₂.symm (r • e₂ ((ConcreteCategory.hom scK₀.f) x))
apply e₂.injective
rw [LinearEquiv.apply_symm_apply, h_diff_pi_smul_f r (e₁ x),
  LinearEquiv.symm_apply_apply]
```

The `change` step relies on the literal `h_mod_X₁`/`h_mod_X₂` instances:
- `r • x = e₁.symm (r • e₁ x)` by `rfl` (literal `h_mod_X₁`).
- `r • (scK₀.f x) = e₂.symm (r • e₂ (scK₀.f x))` by `rfl` (literal `h_mod_X₂`).
- `(RingHom.id R) r = r` by `rfl`.

After the `change`, applying `e₂.injective` and rewriting via
`LinearEquiv.apply_symm_apply` (collapsing the outer `e₂ ∘ e₂.symm`),
`h_diff_pi_smul_f r (e₁ x)` (which fires because the resulting goal
matches its statement at `y := e₁ x`), and `LinearEquiv.symm_apply_apply`
(collapsing `e₁.symm (e₁ x)` to `x`) closes the goal.

### 3. Replaced `show` → `change` for the `CochainComplex.next` rewrite (linter)

`show K₀.X ((ComplexShape.up ℕ).next n) = K₀.X (n + 1)` changed the
goal, which triggered a `linter.style.show` warning. Replaced with
`change`, which is the correct tactic for explicit goal rewriting.

## What did NOT close

### `g_R.map_smul'` (L1119) — blocker is X₃ instance literality

The same `change` recipe used for `f_R.map_smul'` does not lift to the g-side:

| Step (f-side) | Lift to g-side?  | Reason                                            |
|---------------|------------------|---------------------------------------------------|
| `r • x = e₂.symm (r • e₂ x)` | ✓ | `h_mod_X₂` is literal `e₂.toAddEquiv.module R` |
| `r • (scK₀.g x) = e₃.symm (r • e₃ (scK₀.g x))` | ✗ | `h_mod_X₃` is `Eq.mpr h_eq.symm (e₃.toAddEquiv.module R)` |

The issue: `↑scK₀.X₃ = ↑(K₀.X ((up ℕ).next n))` does NOT reduce to
`↑(K₀.X (n + 1))` (≅ `↑(∏ᶜ Z₃)`) by `rfl` — `(up ℕ).next n` is opaque
(`Classical.choose` over `Rel`).  The `h_mod_X₃` builder therefore uses
`rw [h_eq]` followed by `exact e₃.toAddEquiv.module R`, which makes
`h_mod_X₃ = Eq.mpr h_eq.symm (e₃.toAddEquiv.module R)`.  The
`r • z` for `z : scK₀.X₃` then carries an `Eq.mpr`-transport that
breaks the `change`-based literal alignment.

The verified attempt:
```lean
change (ConcreteCategory.hom scK₀.g) (e₂.symm (r • e₂ x)) =
  r • (ConcreteCategory.hom scK₀.g) (e₂.symm (e₂ x))
```
errors with `'change' tactic failed, pattern ... is not definitionally
equal to target ...` followed by `isDefEq` and `whnf` heartbeat
timeouts (cascade from the deep unfold attempt).

### Next iteration recipe for `g_R.map_smul'`

State a g-side analogue of `h_diff_pi_smul_f` with explicit `Eq.mpr`-casts
threaded through:

```lean
have h_diff_pi_smul_g : ∀ (r : R) (y : ∀ i, Z₂ i),
    letI := h_mod_pi₂
    letI := h_mod_pi₃
    e₃ (h_eq ▸ (⇑(ConcreteCategory.hom scK₀.g) (e₂.symm (r • y)))) =
      r • e₃ (h_eq ▸ (⇑(ConcreteCategory.hom scK₀.g) (e₂.symm y))) := sorry
```
where `h_eq : scK₀.X₃ = K₀.X (n+1)`.  Then in `g_R.map_smul'`, `change`
the goal through `h_eq` so `r • (scK₀.g x)` becomes `Eq.mpr h_eq.symm
(r • (h_eq ▸ scK₀.g x))`, apply `e₃.injective`, and rewrite via
`h_diff_pi_smul_g`.  This converts the `g_R.map_smul'` sorry into a
`h_diff_pi_smul_g` sorry (no net sorry reduction unless that's then
proved).

### `h_diff_pi_smul_f` (L1079) — substantive 5-layer decomposition

The S1–S8 recipe (decompose alternating-sum cochain differential into
per-summand R-linearity, with `algebraMap_naturality` per restriction)
is documented in the existing comment block.  The iter-075/076 attempts
hit blockers at the `Pi.smul_apply / Finset.sum_apply / Finset.smul_sum`
fire step (no progress after the 5-layer unfold) and the
`Finset.sum_congr` shape-mismatch step.  No mechanical execution this
iteration — the recipe needs the cochain-factor identification chain
to be re-established before the inner manipulation can proceed.

### `h_loc_exact` (L1148) — product-localization commutation

Trying `LocalizedModule.map_exact (Submonoid.powers f.1) f_R g_R _`
would require `Function.Exact ⇑f_R ⇑g_R`, which (via `hf_eq`, `hg_eq`)
is exactly the OUTER goal `h_K₀_exact` we're trying to prove.  **Circular.**

The intended route remains: transport `h_a₀_fun f` (slice-cover exactness)
across the cochain-factor identification (product-localization commutation
at the finite cover `↑s₀`).  This is non-trivial Mathlib infrastructure
work — needs an explicit `IsLocalizedModule.Away f.1` instance on the
*product* `LocalizedModule (powers f) (∏ᶜ Z_i) ≅ ∏ᶜ LocalizedModule (powers f) Z_i`
for finite indexing.

## Diagnostics after repair

```
{"success": true, "items": [warnings only — no errors]}
```

Active warnings (all pre-existing, none new this iter):

- `declaration uses sorry` (L453) — the parent `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`.
- Three `simp [π]` flexible-tactic warnings at L796–803 (pre-existing).
- Seven `linter.style.longLine` warnings inside comment blocks at L986–1067
  (pre-existing).

## Blueprint markers

No blueprint editing this iteration (prover writes results, not blueprint).
The deterministic `sync_leanok` phase between prover and review will
adjust `\leanok` based on the new sorry count.  Blueprint chapter:
`blueprint/src/chapters/Cohomology_MayerVietoris.tex § Čech acyclicity`.

The blueprint chapter file `blueprint/src/chapters/AlgebraicJacobian_Cohomology_BasicOpenCech.tex`
listed in the dispatch prompt does NOT exist; the actual content lives
in `Cohomology_MayerVietoris.tex` (which is already in place from iter-076).
No new blueprint file is needed.

## Repair budget

- Starts: 7 sorries.
- Plan target: ≤ 5 (close 2+).
- Hard cap: 7 (no regression).
- Ends: **6 sorries** (-1 net; close of `f_R.map_smul'`).

The target of -2 was not met because the g-side requires non-trivial
`Eq.mpr`-cast handling that would re-introduce a sorry rather than
eliminate one.

## Key insights for the plan agent

1. **`letI` + `exact`** is the right idiom for installing a transported
   module instance — NOT `have` + `convert`.  The iter-076 diagnosis
   ("residual eta-congruence from `convert`") was partially correct but
   missed that `have` doesn't register as instance for typeclass
   synthesis.  With `letI` (registers as instance) + `exact` (no
   congruence peeling), the instance is both literal and discoverable.

2. **`change` + `e_i.injective` transport** works for `f_R.map_smul'`
   because both `h_mod_X₁` and `h_mod_X₂` are literal.  It does NOT work
   for `g_R.map_smul'` because `h_mod_X₃` has a non-literal `Eq.mpr`
   transport (forced by `ComplexShape.next` opacity).

3. **`h_loc_exact` cannot be derived from `LocalizedModule.map_exact`**
   applied to `Function.Exact ⇑f_R ⇑g_R` — that's circular with the
   outer goal `h_K₀_exact`.  The intended product-localization
   commutation route requires explicit `IsLocalizedModule.Away`
   instances on the cochain-product, which is non-trivial Mathlib
   infrastructure.

## Next-iteration prover handoff

In dependency order (lowest-hanging first):

1. **`g_R.map_smul'` (L1119)** — state a *new* `h_diff_pi_smul_g` with
   explicit `Eq.mpr h_eq.symm`-casts on the codomain so the statement
   type-checks; then mirror the iter-077 `f_R.map_smul'` recipe with
   `change`-through-`h_eq`.  Net: trade L1119 for L`new h_diff_pi_smul_g`.

2. **`h_diff_pi_smul_f` (L1079)** — substantive content; needs the
   5-layer functor stack to be unfolded carefully (S1–S8 recipe).
   Documented in-place at L1009–1067.

3. **`h_loc_exact` (L1148)** — needs an `IsLocalizedModule.Away f.1`
   instance on `∏ᶜ Z_i` (or equivalently on `scK₀.X_i = K₀.X i`).
   This is the finite product-localization commutation theorem; not
   yet in Mathlib for the general curve setting but tractable for the
   finite `↑s₀` indexing.

4. **L495, L819, L847** — confirmed dead-ends per multiple iterations;
   stay sorry'd unless user supplies new hypothesis.
