# Recommendations for the next plan-agent iteration (iter-086)

## TL;DR

- **Priority target (iter-086)**: Lane 1 closure of `h_diff_pi_smul_f` in `BasicOpenCech.lean` via the per-summand R-linear restriction map approach.
- **Defer**: Lane 2 work on `Differentials.lean` — `cotangentExactSeq_structure` body is sorry-free (modulo the new named helper); the next-up target on that file is either (a) the helper body itself (multi-iteration upstream gap, defer to iter-088+) or (b) `relativeDifferentialsPresheaf_isSheaf` (also multi-iteration; not iter-086 budget).
- **Off-limits (unchanged)**: `Modules/Monoidal.lean` L173 (Mathlib gap); `Jacobian.lean` L179, `Picard/Functor.lean` L190 (Phase C deferred); BasicOpenCech.lean L502 / L826 / L854 (substep-(a) / `h_π_split` analogue / extra-degeneracy multi-iter blockers).
- **Realistic iter-086 sorry-count target**: net **−1** (13 active). Best-case if Lane 1 lands a clean closure.

---

## Lane 1 — `BasicOpenCech.lean` `h_diff_pi_smul_f` body (PRIORITY)

**Status**: iter-085 surfaced the inner `Pi.module` smul via `hsmul_eq` (L1399–1402). Goal at L1447 is now S6-form: `(...) (e₁.symm (r •_pi y)) = r •_{perI₂ j} (...) (e₁.symm y)`, which is "F is R-linear in r" where F is the j-projection of `eqToHom ∘ₗ Σ.hom ∘ e₁.symm`. Residual = genuine per-summand R-linearity, not typeclass scaffolding.

**iter-086 directive**: build an explicit per-summand R-linear restriction map as an inline `have` BEFORE the `rw [hsmul_eq]` at L1399. The body provided by the iter-085 prover task result is the canonical template:

```lean
have R_restrict_R_linear : ∀ (V W : Opens C.left.toTopCat) (h_VW : V ≤ W)
    (h_VU : V ≤ U) (h_WU : W ≤ U) (r' : R) (z : C.left.presheaf.obj W.op),
    (C.left.presheaf.map h_VW.op).hom
      ((C.left.presheaf.map h_WU.op).hom r' * z) =
    (C.left.presheaf.map h_VU.op).hom r' *
      (C.left.presheaf.map h_VW.op).hom z := by
  intro V W h_VW h_VU h_WU r' z
  rw [(C.left.presheaf.map h_VW.op).hom.map_mul,
      ← ConcreteCategory.comp_apply, ← C.left.presheaf.map_comp,
      show ((h_WU.op : W.op ⟶ U.op) ≫ (h_VW.op : V.op ⟶ W.op)) =
        (h_VU.op : V.op ⟶ U.op) from rfl]
```

Then chain per-summand: `Finset.sum_apply` + `Pi.smul_apply` + `Pi.lift_π_apply` + `R_restrict_R_linear` (per summand at fixed `i`) + `Finset.smul_sum` (S8 reassembly).

**CRITICAL — do NOT retry `LinearMap.comp_apply` directly**. iter-085 confirmed 8 distinct bypasses (4 plus the 11-lemma `simp` omnibus, the `change`, the `induction hRel`, the `set L`, the `have key`) all fail on the opaque `(eqToHom ∘ₗ Σ.hom) (...)` term. The HOU mismatch is fundamental. Use `congr_arg (Pi.π Z₂ j).hom` to pull the j-projection inside, then leverage `(eqToHom ⋯).hom`'s identity-after-substituting-hRel character via `eqToHom_app` or a focused `change` with explicit cast proof.

**Estimated complexity**: ~50–80 LOC inline. The `R_restrict_R_linear` helper is ~10 LOC; per-summand reduction + S8 reassembly is the bulk.

**Recommended approach**: work BACKWARDS from the RHS — start with `r •_{perI₂ j} (Pi.π Z₂ j).hom (...)` and rewrite using `Finset.smul_sum` + per-summand `R_restrict_R_linear` + `←` chain to match LHS. The "S8 → S7 → S6 reverse direction" is the path iter-085 outlined.

**iter-086 hard cap**: 5 sorries per file (file currently at 6 for BasicOpenCech, 5 for Differentials). Closure here would drop BasicOpenCech to 5; aggregate to 13.

**Stop rules iter-086 Lane 1**:
1. If after 6 hours of prover budget the `R_restrict_R_linear` helper hasn't compiled standalone, escalate to the challenger subagent with the explicit blocker pattern.
2. If `R_restrict_R_linear` compiles but the per-summand chain fails on the `eqToHom_app` step, fall back to documenting the explicit per-summand identification as a NEW project-local helper (which would be a SIXTH helper, exceeding the iter-085 plan's "five helpers" budget — flag this for user policy review before introducing).
3. Do NOT introduce new axioms.

## Lane 2 — `Differentials.lean` (DEFER — `cotangentExactSeq_structure` body is sorry-free)

**Status**: `cotangentExactSeq_structure` is now structurally complete — body is sorry-free. The single residual `sorry` in this file's "active" zone is `_root_.SheafOfModules.exact_iff_stalkwise` at L521, which packages a multi-iteration Mathlib gap (`SheafOfModules.stalkFunctor` + exactness-reflection).

**iter-086 directive on Lane 2**: do NOT assign new prover work. Reasons:

1. The helper body's closure requires defining `SheafOfModules.stalkFunctor R x : SheafOfModules R ⥤ ModuleCat (R.val.stalk x)` from scratch, proving it preserves and reflects exactness via filtered-colimit characterisation of stalks, and gluing — a multi-iteration upstream development that the iter-085 plan explicitly reserved for iter-088+.

2. The remaining 4 sorries in this file (L122 `relativeDifferentialsPresheaf_isSheaf`, L987 `smooth_iff_locally_free_omega`, L1004 `cotangent_at_section`, L1146 `serre_duality_genus`) are all Phase B / B+ tasks with their own multi-iteration trajectories (KaehlerDifferential localisation-compatibility, Jacobian criterion + Nakayama, Serre duality dimension-one case). None are iter-086 size.

3. Prover budget is best concentrated on Lane 1 closure, which is the cleanest deliverable in iter-086 reach.

**If user-hint overrides directive**: the closest-to-completion target in this file is L122 (`relativeDifferentialsPresheaf_isSheaf`) — but it requires upstream Mathlib chain on `KaehlerDifferential`'s localisation-compatibility. Estimated complexity ≥ 200 LOC; not iter-086 reach.

## Off-limits (do NOT assign — confirmed multi-iter blockers)

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L502 — substep (a) infrastructure (augmented Čech simplicial object); needs the extra-degeneracy chain.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L826 — `h_π_split` analogue / refinement transport.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L854 — substep (a) for `s₀`-indexed slice cover (extra-degeneracy).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L1492 — downstream of `h_diff_pi_smul_f` closure (`g_R.map_smul'`). iter-086 should NOT touch this until L1447 lands.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L1521 — `h_loc_exact`; needs `IsLocalizedModule.Away f.1` infrastructure.
- `AlgebraicJacobian/Differentials.lean` L521 — `_root_.SheafOfModules.exact_iff_stalkwise` body (deferred to iter-088+ per gap-fill policy).
- `AlgebraicJacobian/Differentials.lean` L122 — `relativeDifferentialsPresheaf_isSheaf` (Phase B step 1; multi-iter).
- `AlgebraicJacobian/Differentials.lean` L987, L1004, L1146 — Phase B step 2–4.
- `AlgebraicJacobian/Modules/Monoidal.lean` L173 — `instIsMonoidal_W` (Mathlib gap).
- `AlgebraicJacobian/Jacobian.lean` L179, `AlgebraicJacobian/Picard/Functor.lean` L190 — Phase C deferred.

---

## Reusable proof patterns to surface in iter-086 STRATEGY.md (NEW iter-085 additions)

1. **Open-frontier-as-named-helper protocol** *(NEW iter-085)*. When an inline sorry packages a Mathlib gap requiring multi-iteration upstream development, replace it with a top-level named helper whose signature states the abstract mathematical theorem (parameterised over the most general categorical setting) and whose body is `sorry`. Preserves the host theorem's body as sorry-free; surfaces the gap as a discoverable declaration. Net sorry count is 1-for-1; structural meaning is qualitatively different. Applied iter-085 to close `cotangentExactSeq_structure case h_exact`.

2. **`hsmul_eq` to surface inner `Pi.module` smul past an `AddEquiv.module` transport** *(NEW iter-085)*. When the LHS `r • e₁.symm y` uses the transported `AddEquiv.module` smul (defined as `r • z := e₁.symm (r • e₁ z)`), the rewrite `show e₁.symm (r • e₁ (e₁.symm y)) = e₁.symm (r • y); rw [LinearEquiv.apply_symm_apply]` collapses to `e₁.symm (r • y)` with the inner `Pi.module` smul.

3. **HOU obstruction catalogue for `(eqToHom ∘ₗ Σ.hom) (...)` opaque terms** *(NEW iter-085)*. The combination of homogeneous `∘ₗ` notation, `ConcreteCategory.hom` wrapping of `eqToHom`, and `∑` sum's `ModuleCat.Hom.hom` wrapping defeats: `simp [LinearMap.comp_apply]`, `rw [LinearMap.comp_apply (σ₁₂ := RingHom.id k) (σ₂₃ := RingHom.id k)]`, `change` with explicit cast type, `induction hRel; rfl` (motive), `set L : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := ...` (universe), `have key : ∀ z, ... = ?_` (underdetermined), 11-lemma omnibus simp. Only path forward: explicit per-summand R-linear restriction map + `congr_arg`-style equational reasoning.

4. **`set` to bind a comp as a local LinearMap fails on universe constraint** *(NEW iter-085)*. `set L : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := ...` produces `u =?= imax ?u' ?u''` stuck universe elaboration. Inline `have key : ∀ z, ...` also fails (`?_` underdetermined). Rules out tactic-level "bundle the comp as a binder" workarounds.

---

## Stop rules / repeat-blocker avoidance (iter-086)

The plan agent should AVOID retrying these in iter-086 without an architectural change:

- `LinearMap.comp_apply` (any form) on `h_diff_pi_smul_f` goal — confirmed dead-end across iter-083 / 084 / 085.
- `letI : Module ↑R ↑scK₀.X₁ := h_mod_X₁` (typed at `↑scK₀.X_i`) — must bind at literal `↑(∏ᶜ Z_i)` (iter-084 finding, still applicable).
- `simp [Equiv.smul_def]` for AddEquiv.module smul-commutation — does NOT fire (iter-084).
- `rw [map_smul]` on the LHS — fails at `MulActionHomClass` synthesis (`e₁` is `≃ₗ[k]`, not `≃ₗ[R]`).
- `subst hRel` / `induction hRel; rfl` — motive issue (`n` appears in many other hypotheses).
- `LinearMap.range_eq_top` + `rw [← span_range_derivation]` for `h_exact` — bundled-vs-unbundled `⊤` types (iter-084 dead-end, now superseded by iter-085's helper closure; this pattern is moot for Differentials.lean since `case h_exact` is closed).

If iter-086 prover hits one of these without success in 3 attempts, the prover should fall back to documenting the dead-end in their task result and proceeding to the next sub-step rather than burning further budget. The plan agent should NOT instruct retries of these patterns without first changing the approach (e.g., introducing a new helper or reformulating the goal).

---

## Suggested STRATEGY.md update points for plan agent

1. Mark Lane 2 (`Differentials.lean`) as **DEFERRED** for iter-086 — closure of `case h_exact` was a structural milestone but the next-up targets are multi-iteration.
2. Promote Lane 1 (`BasicOpenCech.lean`) to **PRIMARY iter-086 lane** with a concrete closure recipe (R_restrict_R_linear template).
3. Add iter-085 reusable patterns 1–4 to the Knowledge Base / Proof Patterns section.
4. Track `_root_.SheafOfModules.exact_iff_stalkwise` as a NEW upstream-gap-fill helper requiring multi-iteration plan (defer to iter-088+; coordinate with Mathlib PR if possible).
5. Track `cotangentExactSeq_structure` as "body sorry-free, modulo named helper" — this is a major Phase B milestone toward the cotangent exact sequence theorem.
