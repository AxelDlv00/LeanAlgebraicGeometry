# Recommendations for the next plan-agent iteration (iter-076)

## Context

Iter-075 closed **0 active sorries** (15 → 15 syntactic). Both prover lanes returned PARTIAL with strictly structural progress (no closures).

- **Lane 1 (Differentials, `_structure.h_zero` Step 7)**: advanced from "Steps 1–6 + bare commentary" (iter-074) to "Steps 1–6 + 40 LOC of `hcoh`/`hcoh_app`/`hd_app` + flattening simp chain + labelled trailing sorry". The four residual identifications (α-fac, α-def, β-fac, d-app) are now individually named in the comments above the `sorry` at L540. Closing them needs either (i) live LSP for `unfold + Universal.fac` chain, or (ii) project-local `Derivation.postcomp_comp` helper (iter-074 P3 recommendation, **not** acted on iter-075).
- **Lane 2 (BasicOpenCech, `h_diff_pi_smul_f`)**: replaced iter-074's `try`-wrapped chain with bare un-`try` chain + `Finset.sum_congr` per-summand reduction. The four-step (i)–(iv) decomposition is documented inline. The bare chain may not elaborate under live LSP, but per the plan-agent's accepted trade-off, the failure mode (clean diagnostic) is preferable to `try`'s permanent mask.

This is the **third consecutive iteration** advancing `_structure.h_zero` Step 7 without closure, and the **third consecutive iteration** advancing `h_diff_pi_smul_f` without closure. The P-1 staircase pattern (each iteration strictly narrows the residual sorry) is real progress in the *blueprint-prose* sense but has saturated in the *sorry-count* sense.

## Priority ranking

### P0 — Build environment repair (**EIGHTH** consecutive ask)

**Why critical**: persistent since iter-068. `.lake/packages/*` root-owned; `lake env lean` fails with `unknown module prefix 'Mathlib'`; LSP `lean_goal` returns `goals: null`, `lean_multi_attempt` returns `goals: []`, `lean_run_code` silently swallows import-bearing errors. Every "PARTIAL → PARTIAL" lane this iteration was direct consequence of this — provers cannot verify their edits' semantic correctness.

**Action**: surface to user.
1. `sudo chown -R $(id -u):$(id -g) .lake/packages/`
2. `lake update && lake build` to regenerate `.lake/build/lib/Mathlib/**.olean`.
3. `sync_leanok` and LSP resume working.

The plan agent should write `TO_USER.md` (the review agent already does on each iteration; this iteration's review surfaces it again with explicit cadence emphasis).

### P1 — Differentials.lean `_structure.h_zero` Step 7 closure (Lane A)

**Why**: 6 of 7 strategy steps are concrete; ~40 LOC of structural setup committed; residual 4-step identification individually named.

**Action under live LSP (P0 fixed)**:
1. Run `lean_goal` at L540 to confirm the post-simp goal matches the documented residual.
2. Run `unfold cotangentExactSeqAlpha` (or re-`unfold` inside Step 7) to expose inline `d_target`.
3. Apply `Universal.fac` on `(derivation' φ_g').postcomp ((isUniversal' φ_g').desc <inline-d_target>)`.
4. `unfold cotangentExactSeqBeta` to expose `β.val = (isUniversal' φ_fg').desc d1`.
5. Second `Universal.fac` for `d1.d = (derivation' φ_2').d`.
6. `rw [hd_app]` closes.

Expected closing chain: `simp [Universal.fac, hd_app] <;> rfl` after the unfolds (~20–30 LOC).

**Action under broken env (P0 NOT fixed)**: stage `Derivation.postcomp_comp` helper (iter-074 P3, NOT acted on iter-075). Likely `rfl`-provable:

```lean
@[simp]
lemma PresheafOfModules.Derivation.postcomp_comp
    {R S : Cᵒᵖ ⥤ CommRingCat} (φ : S ⟶ R)
    {M N K : PresheafOfModules ...} (d : M.Derivation φ)
    (f₁ : M ⟶ N) (f₂ : N ⟶ K) :
    d.postcomp (f₁ ≫ f₂) = (d.postcomp f₁).postcomp f₂ := by rfl
```

**User constraint to verify before staging helpers**: the user's "no thin helpers" feedback memory says `chains of thin helpers across iterations` are forbidden. A single one-line `rfl` helper that bridges `simp [Universal.fac, hd_app]` is **not** a chain; the plan agent should confirm this is allowed before assigning.

### P2 — BasicOpenCech.lean `h_diff_pi_smul_f` closure (Lane B)

**Why**: iter-073 inline recipe → iter-074 runnable `try`-wrapped chain → iter-075 bare chain + `Finset.sum_congr` reduction. Residual is the per-summand (i)–(iv) decomposition.

**Action under live LSP**:
1. `lean_goal` after `funext j` — verify alternating-sum equality at index `j`.
2. `lean_goal` after the 14-name simp chain — inspect the alternating-sum normal form.
3. `lean_goal` after `Finset.sum_congr` — confirm per-summand goal.
4. Implement four-step chain inline:
   - (i) `simp only [Pi.smul_apply]` on LHS.
   - (ii) `rw [RingHom.map_mul]` (or `map_mul`).
   - (iii) `rw [← C.left.presheaf.map_comp]` (functoriality + poset uniqueness).
   - (iv) reverse `simp only [Pi.smul_apply]` at `h_mod_pi₂`.
   - **Project lemma to invoke (optional)**: `Scheme.toModuleKSheaf.algebraMap_naturality` (`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` L161). Useful if `r` is a `k`-scalar; for `r : R` direct ring functoriality suffices.

**Risk**: if the 14-name simp chain doesn't fully reduce (some `simp only` step fails to fire under live LSP), replace failed steps with explicit `show ...` clauses or split the chain. The bare un-`try` chain produces an actionable diagnostic per the plan-agent's iter-075 directive.

**Estimated**: 30–60 LOC under live LSP.

### P3 — `h_diff_pi_smul_g` mechanical copy

**Why**: once P2 lands, mechanically identical at one degree shifted.

**Action**: copy the closing chain with `h_mod_pi₃`-side smul; preserve iter-074's `try`-wrapped prefix at L1141–L1142.

**Estimated**: 10–20 LOC.

### P4 — `_structure.h_epi` helper staging + closure

**Why**: needs project-local `SheafOfModules.epi_of_epi_presheaf` helper (Mathlib does not provide — confirmed iter-073 search). Once available, `h_epi` reduces to pointwise `KaehlerDifferential.map_surjective` via `PresheafOfModules.epi_iff_surjective`.

**Estimated**: 30–50 LOC for the helper, 20–30 LOC for the closure.

### P5 — `_structure.h_exact` (deferred)

**Why deferred lower**: needs the dual helper `SheafOfModules.exact_iff_stalkwise` (Mathlib may have a stalkwise-exactness lemma under a different name; worth `lean_local_search` first). Once available, `h_exact` reduces to ring-level `KaehlerDifferential.exact_mapBaseChange_map` applied stalkwise. Localisation chains involved.

**Estimated**: 40–60 LOC for the helper, 20–40 LOC for the closure.

## Do NOT assign (blocked / deferred)

- **`Jacobian.nonempty_jacobianWitness`** (L177) — Albanese existence + genus-0 rigidity; multi-month effort.
- **`PicardFunctor.representable`** (L190) — intentionally deferred.
- **`relativeDifferentialsPresheaf_isSheaf`** (Differentials.lean L122) — large; lower priority than `_structure` closure.
- **`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`** — downstream of `_structure`; do not assign until `_structure` is complete.
- **BasicOpenCech.lean L495, L819, L847** (Cluster (a) extra-degeneracy substeps) — confirmed dead-end across iter-061+; do not retry.
- **BasicOpenCech.lean L1222** (`LocalizedModule.map ... = sorry` in `h_a₀_fun` region) — blocked behind `h_diff_pi_smul_{f,g}` and `h_loc_exact`.

## Reusable patterns to propagate

1. **P-1 staircase to closure** *(iter-073 → iter-074 → iter-075)*. When a closure cannot land under broken env, each iteration commits one more structural step toward it, leaving a strictly smaller trailing `sorry`. Works for 1–2 iterations; saturates by iteration 3. After saturation, switch to env-repair or helper-staging.
2. **Drop `try` to gain actionable diagnostics** *(iter-075 directive)*. Bare un-`try` tactics may fail under live LSP but produce a clean error pointing to the specific failed step. `try` permanently masks failures, making post-recovery debugging impossible. Use bare for the final residual step; reserve `try` for genuinely speculative wide-recipe skeletons.
3. **`Finset.sum_congr rfl fun k _ => ?_` for alternating-sum R-linearity** *(NEW iter-075)*. After `Finset.smul_sum` pulls `r •` inside the RHS sum, `Finset.sum_congr` reduces the equality to per-summand R-linearity. Pattern reusable for any alternating-sum R-linearity check on cosimplicial cochains.
4. **`have hcoh = adj_f.unit ≫ pushforward.map φ_2' = f.c` via `Adjunction.homEquiv = unit ≫ G.map` (rfl) + `Equiv.apply_symm_apply`** *(NEW iter-075 explicit form)*. The adjunction-coherence identity for the composed pullback adjunction is `rfl`-then-`apply_symm_apply`. Reusable for any pullback-pushforward adjunction coherence in cross-space sheaf-of-modules calculations.
5. **`congr_arg + simpa` for pointwise-evaluating a natural-transformation equation** *(iter-075 confirmed)*. Given `hcoh : α ≫ β = γ` of natural transformations, `congr_arg (fun h => h.app U .hom b) hcoh` followed by `simpa` produces the pointwise equation. Reusable.
6. **6-of-7-steps committed-with-trailing-sorry pattern** *(iter-074)*. (See iter-074 recommendations.)
7. **`set`-alias rebinding after `unfold + simp [...]`** *(iter-074)*. (See iter-074 recommendations.)
8. **Adjunction-injection + universal-property scaffold** *(iter-073, extended iter-074, structural setup iter-075)*. (See iter-074 recommendations.)
9. **Embedded reduction recipes for opaque sorries** *(iter-073)*. (See iter-074 recommendations.)

## Process notes

- **Build environment caveat persists.** Eighth iteration. The plan agent should write `TO_USER.md` with explicit cadence (e.g. "BLOCKER: env broken since iter-068 (8 iters). All prover lanes degraded. Action required: `sudo chown -R $(id -u):$(id -g) .lake/packages/` then `lake update && lake build`.").
- **LSP degradation measurable.** `lean_goal` returns `goals: null`; `lean_multi_attempt` returns `goals: []`. The provers' only viable signal is `lean_diagnostic_messages`'s `clean: true`/`error_count: 0`, which is valid only against cached oleans — not authoritative for new tactic interactions.
- **Process discipline held.** Both lanes confined edits to their assigned files. Zero new axioms. Protected signatures preserved verbatim. `archon-protected.yaml` unchanged. No new project-local helpers (honoring "no thin helpers" feedback).
- **Lane budget calibration**: realistic for iter-076 under broken env: **0 to −1 sorry** (continued P-1 staircase). Under repaired env: **−2 to −4 sorries** (Lane A P1 + Lane B P2 + possibly Lane C P3 mechanical `_g` copy).

## Suggested iter-076 dispatch

**If env repaired**:
1. **Lane A (Differentials, P1)**: close `_structure.h_zero` Step 7 via `unfold + Universal.fac + hd_app` chain (~20–30 LOC).
2. **Lane B (BasicOpenCech, P2)**: close `h_diff_pi_smul_f` via per-summand (i)–(iv) chain (~30–60 LOC).
3. **Lane C (BasicOpenCech, P3)**: mechanical `h_diff_pi_smul_g` copy after Lane B (~10–20 LOC).
4. *(optional)* **Lane D (Differentials, P4)**: stage `SheafOfModules.epi_of_epi_presheaf` + close `h_epi`.

**If env NOT repaired**:
1. **Lane A (Differentials, P1 fallback)**: stage `Derivation.postcomp_comp` helper inline in `Differentials.lean` (or a project utility file), close Step 7 via `simp [postcomp_comp, Universal.fac, hd_app]`. Confirm with plan-agent that one-line `rfl` helper is permitted under "no thin helpers" policy.
2. **Lane B (BasicOpenCech, hold)**: do not edit Lane 2 further until env repaired; or commit a pure structural narrowing (e.g. `show` clauses to expose the per-summand sum normal form without invoking `Pi.smul_apply` directly).

The honest assessment: **continued P-1 staircase without env repair is not converging on closure**. The plan agent should either escalate env repair to highest priority, or accept that iter-076 may also close 0 sorries.
