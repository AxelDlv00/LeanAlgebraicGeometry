# Iter-098 dispatched objectives (project-narrative iter-100)

## Summary

Single substantive prover lane: **close `cechCofaceMap_pi_smul`'s residual
`?hG` per-summand discharge sorry at L728** of `BasicOpenCech.lean`. Lane 2
(Differentials) is OFF-LIMITS pending Mathlib gap-fill.

## Lane 1 — `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

**Target sorry**: L728 — the residual `?hG` placeholder of the iter-099 `refine
alternating_sum_pi_smul_aux_sum_comp ...` application inside
`cechCofaceMap_pi_smul`.

**Goal at L728** (verified iter-099 plan-pass via `lean_goal`):

```
case h
[... full Lean context with `i : Fin (... + 2)`, `r' : ↑R`, `y' : ∀ i, Z₁ i` ...]
⊢ e₂ ((ModuleCat.Hom.hom (eqToHom ⋯))
      ((ModuleCat.Hom.hom ((-1) ^ ↑i • Pi.lift_thing))
        (e₁.symm (r' • y')))) =
  r' • e₂ ((ModuleCat.Hom.hom (eqToHom ⋯))
      ((ModuleCat.Hom.hom ((-1) ^ ↑i • Pi.lift_thing))
        (e₁.symm y')))
```

where `Pi.lift_thing := Pi.lift fun i_1 ↦ Pi.π Z₁ (i_1 ∘ (SimplexCategory.δ
i).toOrderHom) ≫ (toModuleKPresheaf C).map (Pi.lift fun x ↦ Pi.π
(basicOpenCover ↑s₀ ∘ i_1) ((SimplexCategory.δ i).toOrderHom x)).op`.

The current state has `intro i _ r' y'; simp only [ModuleCat.hom_comp,
LinearMap.comp_apply]; sorry` committed (the `simp only` already distributed
the composition, so the `eqToHom_hom` and `((-1)^↑i • Pi.lift_thing).hom` are
two separate `.hom`-applications nested under `e₂`).

**Dead ends from iter-099** (DO NOT RETRY):
- `Preadditive.smul_comp` is an unknown lemma name (correct: `CategoryTheory.Linear.smul_comp` for k-action; `CategoryTheory.Preadditive.zsmul_comp` for ℤ-action).
- `simp only [Linear.smul_comp]` — fails at the polymorphic `(-1)^↑i` typeclass synthesis stage.
- `simp only [Preadditive.zsmul_comp]` — same.
- `rw [ModuleCat.hom_smul]` — typeclass synth fails on polymorphic `(-1)^↑i`.
- `change ((-1 : k) ^ (↑i : ℕ)) • _` — nested-`Pi.lift` metavariables block ascription.
- `neg_smul`, `pow_succ`, `Int.even_or_odd'` rcases — none progressed.

**Recommended chain** (verify each step at LSP via `lean_diagnostic_messages`
after save, or `lean_multi_attempt` at L728):

```lean
intro i _ r' y'
-- (S1) Pin scalar to k via `set` BEFORE distributing through .hom.
--      This pre-elaborates the scalar's k-type, unblocking Linear.smul_comp.
set h_sgn : k := (-1) ^ (↑i : ℕ) with h_sgn_def
-- (S2) Extract scalar via Linear.smul_comp at the categorical morphism level
--      (h_sgn • Pi.lift_thing) ≫ eqToHom = h_sgn • (Pi.lift_thing ≫ eqToHom)
rw [Linear.smul_comp]
-- (S3) Distribute through .hom + LinearMap.smul_apply
simp only [ModuleCat.hom_smul, LinearMap.smul_apply]
-- (S4) Push h_sgn past e₂ via map_smul (e₂ is k-linear)
rw [map_smul e₂.toLinearMap h_sgn _]
rw [map_smul e₂.toLinearMap h_sgn _]
-- (S5) Cancel h_sgn symmetrically via smul_left_comm
rw [smul_left_comm h_sgn r' _]
congr 1
-- (S6) Residual R-linearity of e₂ ∘ eqToHom.hom ∘ Pi.lift_thing.hom ∘ e₁.symm
ext j'
simp only [Pi.smul_apply, ModuleCat.piIsoPi_hom_ker_subtype_apply,
           ModuleCat.eqToHom_hom, Pi.lift_π_apply, ConcreteCategory.comp_apply]
rw [presheafMap_restrict_collapse, map_mul]
rfl
```

**Fallback ladder** (each fallback is independent; try in order if the
recommended chain breaks at the corresponding step):

- **(F1) `set` doesn't pin scalar**: try explicit `change (((-1 : k) ^ (↑i : ℕ)) • Pi.lift_thing) ≫ eqToHom = ...` directly before `rw [Linear.smul_comp]`. Or interpose `have h_eq : ((-1 : k) ^ (↑i : ℕ) : k) • Pi.lift_thing = h_sgn • Pi.lift_thing := by rw [← h_sgn_def]` and `rw [h_eq]`.
- **(F2) `Linear.smul_comp` doesn't fire**: try `Preadditive.zsmul_comp` with `Int.cast` bridge `((-1 : ℤ)^(↑i : ℕ))`. Or show `((h_sgn • f) ≫ g).hom = h_sgn • (f ≫ g).hom` by hand via `LinearMap.ext` + per-element computation.
- **(F3) `map_smul e₂.toLinearMap h_sgn _` HOU-fails**: try `e₂.map_smul h_sgn _` directly on each side. Or use `(e₂ : (∏ᶜ Z₂) →ₗ[k] (∀ j, Z₂ j)).map_smul`.
- **(F4) `ext j'` fails on the LinearEquiv image**: try `funext j'` or `Pi.ext j'`. If the equality is at `(∀ j, Z₂ j)`-level (post-`e₂`), `funext j'` should work; if at `∏ᶜ Z₂`-level, `LinearEquiv.injective` + `funext` lift.
- **(F5) `presheafMap_restrict_collapse` doesn't close**: explicitly `change` the per-coordinate goal to expose `presheaf.map (homOfLE _).op` chain, then apply `presheafMap_restrict_collapse h_VW h_VU h_WU` with the precise `V W U` triple from the context (V = `∏ᶜ basicOpenCover ↑s₀ ∘ j'`, W = `∏ᶜ basicOpenCover ↑s₀ ∘ (j' ∘ δ i)`, U = ambient `U`).

**Mathematical justification** (for the prover's confidence):

The composite `e₂ ∘ eqToHom.hom ∘ Pi.lift_thing.hom ∘ e₁.symm : (∀ i, Z₁ i) →
(∀ j, Z₂ j)` is per-coordinate the presheaf restriction map `R = Γ(C.left, U)
→ Γ(C.left, basicOpenCover ↑s₀ ∘ j')` applied to `y' (j' ∘ δ i)`. Since the
coordinate-restriction-then-evaluate map is exactly `R-action via
RingHom.toModule`, R-linearity is intrinsic. The `(-1)^↑i •` is a categorical
k-scalar that commutes with R-action by `SMulCommClass k R _` (k embeds in R
via the structure morphism `k → R`).

**Stop-conditions**:

- **Hard cap**: 6 sorries (no regression from iter-099's compiling state).
- **Target**: 5 sorries (close L728).
- **Acceptable**: 6 sorries (escalate iter-101+ if all routes blocked at the LSP). In this case, write a SHORT report with the deepest committed step's `lean_goal` output + the failing tactic + which fallback ladder steps were tried.
- **Strict requirement**: FILE MUST COMPILE.

**State to preserve byte-for-byte UNLESS LSP says otherwise**:
- `presheafMap_restrict_collapse` (L425).
- `alternating_sum_pi_smul_aux` body (L478–L494, iter-097).
- `alternating_sum_pi_smul_aux_sum_comp` body (L532–L537, iter-099).
- `cechCofaceMap_pi_smul` body PRELUDE through L727 (`intro R K₀ scK₀ ...
  letI ... funext j ... key₂ ... iter-097 B1 bridge ... rw [← Pi.smul_apply
  (i := j)]; refine congrFun ... ; intro i _ r' y'; simp only [ModuleCat.hom_comp,
  LinearMap.comp_apply]`). Only the `sorry` at L728 changes.

**Hard constraints**:
- No new project-local helper lemmas at TOP LEVEL.
- No new axioms.
- No `first | <chain> | sorry` wraps.
- No `lean_run_code` pre-validation of full bodies.
- Strict per-step LSP verification.

**Pre-flight**:

```
PATH=$HOME/.elan/bin:$PATH lake env lean --version
PATH=$HOME/.elan/bin:$PATH lake build AlgebraicJacobian.Cohomology.BasicOpenCech
```

If the build cannot start, report environmental failure and abort.

**Blueprint**: `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § Čech
acyclicity. `cechCofaceMap_pi_smul`, `alternating_sum_pi_smul_aux`,
`alternating_sum_pi_smul_aux_sum_comp`, `presheafMap_restrict_collapse` are
project-local helpers without their own `\lean{...}` entries — no blueprint
edits expected this iter.

## Lane 2 — OFF-LIMITS

- `Differentials.lean` `h_exact` deferred parallel to `instIsMonoidal_W`.
- `Modules/Monoidal.lean` `instIsMonoidal_W` (Mathlib gap, deferred indefinitely).
- `Jacobian.lean` `nonempty_jacobianWitness` — Phase C step C3, iter-101+.
- `Picard/Functor.lean` `representable` — gated on C0–C3.
- BasicOpenCech `g_R.map_smul'` (L1362), `h_loc_exact` (L1391), L820, L1144, L1172 — gated or multi-iter Mathlib gaps.
