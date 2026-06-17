# Refactor Report

## Slug
alt-zsmul-restore-compile

## Status
COMPLETE

## Directive

### Problem (summary)
The prior refactor (`alt-zsmul-pi-smul-aux-sum-comp`, this iter) introduced
the new lemma `alternating_zsmul_pi_smul_aux_sum_comp` at L539-L590 of
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean` AND rewrote the call site
inside `cechCofaceMap_pi_smul` to use it, bumping `maxHeartbeats` to
12800000. Plan-agent verification showed the file did NOT compile: lake
build hit a deterministic whnf timeout at L603 and a cascade kernel error
at L836.

### Changes requested
1. **Revert** the call site inside `cechCofaceMap_pi_smul` to the iter-101
   form using `alternating_sum_pi_smul_aux_sum_comp` (sign baked into `?G`)
   with the iter-101 cumulative S1-S3 fuse chain + trailing sorry.
2. **Revert** `set_option maxHeartbeats` from 12800000 back to 1600000,
   updating the comment block to note the failed iter-102 bump.
3. **Keep** the new lemma `alternating_zsmul_pi_smul_aux_sum_comp`
   (L539-L590) byte-for-byte as inert infrastructure.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

- **Change A (comment + heartbeats revert, L592-L602):**
  - **What:** Replaced the iter-102 explanatory block + `set_option maxHeartbeats 12800000 in` with the iter-101 form: `set_option maxHeartbeats 1600000 in`, preceded by the iter-087 rationale comment plus an iter-102 NOTE that explains why the 8x bump was rolled back (deterministic whnf timeout even at 12800000) and that the sister lemma remains as inert infrastructure.
  - **Why:** The 12800000 budget still timed out on `whnf` during elaboration of the σ-splitting Miller-unification through `Pi.lift`'s anonymous-closure codomain. Restoring 1600000 matches the iter-101 budget at which the file compiled.
  - **Cascading:** None — only the inline `set_option` and its preceding comment changed.

- **Change B (call-site revert inside `cechCofaceMap_pi_smul`, L772-L802):**
  - **What:** Replaced the iter-102 `refine congrFun (alternating_zsmul_pi_smul_aux_sum_comp (R := R) ...)` + trailing `intro i _ r' y'; sorry` with the iter-101 cumulative form:
    1. `refine congrFun (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j` (sign baked into `?G`).
    2. iter-101 S1-S3 fuse chain inside the `?hG` discharge: `intro i _ r' y' ; simp only [ModuleCat.hom_comp, LinearMap.comp_apply] ; funext j' ; simp only [Pi.smul_apply] ; show ... ; rw [show ModuleCat.Hom.hom = ConcreteCategory.hom from rfl, ..., ← ConcreteCategory.comp_apply, × 4]`.
    3. Trailing `sorry` (Post-S3) for the iter-103 prover.
  - The comment block embedded between `?_` insertion and the `intro` line was rewritten as a "PLAN NOTE" pointing the iter-103 prover at the new lemma as a fallback while documenting the iter-102 failure mode.
  - **Why:** The σ-splitting Miller-unification through `Pi.lift`'s anonymous-closure codomain exceeds Lean's deterministic elaboration budget at any reasonable heartbeat setting. Reverting to the sign-baked iter-101 call site restores compilation; the iter-103 prover may now choose between (A) a new discharge tactic on the existing `_sum_comp` shape or (B) filling the new lemma's body and switching to it later.
  - **Cascading:** None — the iter-101 form was previously verified to compile; reverting to it makes the trailing `sorry` semantics-identical to the iter-101 state.

- **Change C (new lemma preserved):**
  - **What:** `alternating_zsmul_pi_smul_aux_sum_comp` at L539-L590 untouched (signature, body sorry, and docstring preserved byte-for-byte). The lemma remains as inert infrastructure available to the iter-103 prover.
  - **Why:** Per directive Change 3 — the lemma is correct and may be needed by future call sites.
  - **Cascading:** None — the lemma is unused anywhere else, so its presence does not affect compilation beyond the L590 sorry warning.

## New Sorries Introduced

No NEW sorries were introduced. The total count remains **7** (unchanged from the broken iter-102 first-pass state, since the new lemma's body sorry was already there and the call-site revert simply restored the iter-101 trailing sorry that the iter-102 first-pass had replaced).

The 7 sorry sites in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` are now:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:590` — body of new lemma `alternating_zsmul_pi_smul_aux_sum_comp` (inert infrastructure, iter-103 prover may fill).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:802` — `cechCofaceMap_pi_smul` trailing post-S3 sorry (iter-103 prover takes over after iter-101 S1-S3 fuse).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:894` — `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` substep (a) (extra-degeneracy infrastructure).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1218` — substep (b)+(c) assembly.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1246` — substep (a) for `s₀`-indexed slice cover.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1436` — anonymous constructor field sorry (inside helper definition).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1465` — `LocalizedModule.map g_R` definitional sorry.

## Compilation Status

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **compiles** (severity=error returns `[]`).
- Diagnostic warnings: 7 sorry warnings (matching the 7 sorry sites above) + 3 `maxHeartbeats` style-linter warnings (L436, L601, L810 — pre-existing, unchanged by this refactor) + numerous flexible-tactic / show-vs-change style lints inside `cechCofaceMap_pi_smul` (all pre-existing from iter-101).
- `sorry_analyzer.py` summary: `7 total across 1 file(s)` — matches expected outcome.

No other files were modified, so no downstream cascade.

## Notes for Plan Agent

1. **Directive followed exactly.** No improvisations beyond the three Changes specified.

2. **The new lemma is genuinely inert.** With the call site reverted to `alternating_sum_pi_smul_aux_sum_comp`, the new `alternating_zsmul_pi_smul_aux_sum_comp` is unreferenced anywhere in the codebase. It compiles only as a standalone declaration with body `sorry`. The iter-103 prover has full latitude on it: fill the body, swap a call site, or ignore it entirely.

3. **Iter-103 strategy split (the directive's suggested "two paths"):**
   - **Path (A) — Discharge `?hG` on the existing `_sum_comp` shape.** This is the cheaper-heartbeat path: the call site's `?hG` slot at L774 (the `?_`) is now an open subgoal where the iter-103 prover already has 6 layers of fuse chain landed (S1-S3 from iter-101). The remaining goal frame is documented in-place at L788-L793 and the iter-101 prover report `.archon/logs/iter-100/prover-iter101-BasicOpenCech-report.md` is referenced. Suggest the iter-103 prover try a `show`-pivot def-eq route or `change` instead of `rw`/`simp_rw` for the scalar extraction (zsmul_comp / hom_zsmul / body-local rfl / set were all exhausted per iter-101 report).
   - **Path (B) — Fill the new lemma's body, then switch.** The new lemma's body sorry has a 5-10 line proof sketch in its docstring (L555-L568). If Path (A) stalls, the iter-103 prover should fill the body via `Preadditive.sum_comp` + `simp_rw [Preadditive.zsmul_comp]` + `alternating_sum_pi_smul_aux`. Switching the call site after the lemma's body is filled will incur the same Miller-unification cost; consider whether bumping heartbeats to 12800000 + restructuring further (e.g. providing an explicit motive for σ) is needed before re-attempting that switch.

4. **Mathematical justification was sufficient.** The directive's explanation of why the call-site revert is safe (sign-baked iter-101 `?G` was previously verified to compile) and why the new lemma stays (iter-103 prover may choose) is consistent and required no judgment calls.

5. **No suggested follow-up refactors needed at this iteration.** The iter-103 prover should drive next.
