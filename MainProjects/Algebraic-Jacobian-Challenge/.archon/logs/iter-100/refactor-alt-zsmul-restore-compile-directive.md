# Refactor Directive

## Slug

`alt-zsmul-restore-compile`

## Problem

The previous refactor (slug `alt-zsmul-pi-smul-aux-sum-comp`, this iter) inserted a new lemma `alternating_zsmul_pi_smul_aux_sum_comp` at L539-L590 of `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` AND rewrote the call site of `alternating_sum_pi_smul_aux_sum_comp` inside `cechCofaceMap_pi_smul` to use the new lemma. The refactor agent claimed the file compiles at `set_option maxHeartbeats 12800000`, but **independent plan-agent verification via `lake build` and `lean_diagnostic_messages` shows the file does NOT compile**:

```
error: AlgebraicJacobian/Cohomology/BasicOpenCech.lean:603:0: (deterministic)
  timeout at `whnf`, maximum number of heartbeats (12800000) has been reached
error: AlgebraicJacobian/Cohomology/BasicOpenCech.lean:836:8: (kernel) unknown
  constant 'AlgebraicGeometry.Scheme.cechCofaceMap_pi_smul'
```

`lake build` spent 850 seconds before exhausting the 12800000 heartbeat budget. The kernel error at L836 is a cascade from the L603 timeout — `cechCofaceMap_pi_smul` never elaborates, so downstream references fail.

The empirical heartbeat bisection in the prior refactor's report was incorrect — the agent's local check must have hit a transient cache or a less stringent timing. The structural change (new lemma + call-site rewrite + residual pruning + 8x heartbeat boost) is mathematically sound but exceeds Lean's deterministic elaboration budget.

The file must compile end-to-end for iter-103 to proceed (the prover cannot work in a non-compiling file).

## Mathematical Justification

The structural change introduced by the prior refactor is correct and useful:

- `alternating_zsmul_pi_smul_aux_sum_comp` is a clean sister of `_sum_comp` that exposes the per-summand sign `σ : ι' → ℤ` as a separate binder, allowing per-summand R-linearity discharge to be about the sign-free composite (where the discrimination-tree blocker class does not trigger).
- The new lemma itself elaborates fine — it is the **call-site application** inside `cechCofaceMap_pi_smul` that triggers the Miller-unification explosion. The σ-splitting Miller-unification, combined with `Pi.lift`'s anonymous-closure codomain, requires more heartbeats than the deterministic elaboration budget allows.

The right move is to **keep the new lemma as inert infrastructure** (the iter-103 prover may decide whether to use it, and may also fill its body so future call sites can rely on it) but **revert the call site change inside `cechCofaceMap_pi_smul`** so the file compiles again. The iter-103 prover then has two paths:

- (A) Continue with the existing `alternating_sum_pi_smul_aux_sum_comp` call site (sign baked into `?G`) and discharge `?hG` via a new tactic strategy (`show`-pivot def-eq, LinearMap.ext, or another route not yet tried).
- (B) Switch the call site to use the new `_zsmul...` lemma and pay the Miller-unification cost, but only AFTER closing the iter-103 ?hG discharge work proves to need this restructure. The prover can then bump the heartbeats as needed (or restructure further).

## Changes Requested

### Change 1: REVERT the call site inside `cechCofaceMap_pi_smul`

In `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`, the current call site at L773-L786 reads (approximately):

```lean
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_zsmul_pi_smul_aux_sum_comp (R := R) Z₁ _ Z₂ Finset.univ
      (fun i : Fin (n + 1) ↦ ((-1 : ℤ))^(↑i : ℕ)) _ _ e₁ e₂ ?_ r y) j
  -- Iter-102 refactor: per-summand hypothesis is now about the
  -- SIGN-FREE composite `Pi.lift_thing_i ≫ eqToHom`. ...
  -- The iter-103 prover closes this via `funext j'` + Pi.lift_π_apply / eqToHom
  -- normalization + `presheafMap_restrict_collapse`.
  intro i _ r' y'
  sorry
```

**Replace** this block with the iter-101 form (using `_sum_comp`, preserving the iter-099 + iter-100 + iter-101 cumulative chain through S1-S3 fuse + escalation comments + trailing sorry):

```lean
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j
  -- iter-099 hG: per-summand R-linearity of `((-1)^↑i • Pi.lift_thing) ≫ eqToHom`.
  -- Iter-102 PLAN NOTE: the new sister lemma `alternating_zsmul_pi_smul_aux_sum_comp`
  -- (introduced at L539-L590 with body `sorry`) is INERT infrastructure available
  -- to the iter-103 prover. The iter-102 attempt to APPLY it at this call site
  -- triggered a deterministic whnf timeout even at 12800000 heartbeats — the
  -- σ-splitting Miller-unification through Pi.lift's anonymous-closure codomain
  -- exceeds Lean's elaboration budget. The iter-103 prover should first attempt
  -- to discharge `?hG` via a NEW tactic strategy on the existing _sum_comp shape
  -- (e.g. `show`-pivot def-eq instead of `rw`/`simp_rw` for scalar extraction),
  -- and only switch to the new lemma if that route also stalls.
  intro i _ r' y'
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
  funext j'
  -- iter-101 S1-S3 cumulative chain landed: simp + show pivot + 4-layer
  -- ← ConcreteCategory.comp_apply fuse. The post-S3 goal frame is
  --   (ConcreteCategory.hom (((-1)^↑i • Pi.lift_thing) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j')) (e₁.symm (r' • y'))
  --     = r' • (same morphism) (e₁.symm y')
  -- See iter-101 prover report at .archon/logs/iter-100/prover-iter101-BasicOpenCech-report.md
  -- for the six exhausted post-S3 routes (zsmul_comp / hom_zsmul / body-local rfl / set).
  simp only [Pi.smul_apply]
  show (CategoryTheory.ConcreteCategory.hom (Limits.Pi.π Z₂ j')) _ =
      r' • (CategoryTheory.ConcreteCategory.hom (Limits.Pi.π Z₂ j')) _
  rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl,
      show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl,
      ← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply,
      ← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply]
  -- Post-S3 sorry: iter-103 prover takes over.
  sorry
```

### Change 2: REVERT `set_option maxHeartbeats` to iter-101 value

The current `set_option maxHeartbeats 12800000 in` at L602 should revert to `set_option maxHeartbeats 1600000 in` (the iter-101 value at which the file compiled). Update the explanatory comment block at L592-L601 to reflect the rollback:

```lean
-- Iter-087: lifted to 1600000 (8x the default 200000) because the
-- `cechCofaceMap_pi_smul` body's let-block reconstruction + S6 step (a)
-- `have hom_sum_dist` block + body-local key₁/key₂ helpers exceed the
-- default budget at the theorem head.
-- Iter-102 NOTE: the attempted use of `alternating_zsmul_pi_smul_aux_sum_comp`
-- at the L773 call site forced a transient 8x heartbeat bump (12800000)
-- that still timed out at whnf; the call site was reverted to use
-- `alternating_sum_pi_smul_aux_sum_comp` and the budget restored to 1600000.
-- The sister lemma remains available as inert infrastructure for iter-103.
set_option maxHeartbeats 1600000 in
```

### Change 3: KEEP the new lemma `alternating_zsmul_pi_smul_aux_sum_comp` BYTE-FOR-BYTE

Do NOT delete or modify the new lemma at L539-L590. It remains as inert infrastructure: the iter-103 prover may choose to fill its body and use it, or ignore it. The lemma's docstring stays as-is.

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — only file edited.

## Expected Outcome

After this revert:
- File compiles end-to-end (`lean_diagnostic_messages` severity=error returns `[]`).
- Total sorries in `BasicOpenCech.lean`: **7** (unchanged from the prior refactor's outcome — the new lemma's body sorry stays + the cechCofaceMap_pi_smul trailing sorry restored).
- Specifically, sorry locations should be:
  - L590 (new lemma body)
  - inside `cechCofaceMap_pi_smul` body, at the trailing `sorry` after the iter-101 S1-S3 fuse chain.
  - L860 area (iter-101: was L860)
  - L1184 area
  - L1212 area
  - L1402 area
  - L1431 area
- `set_option maxHeartbeats` reverts to 1600000.
- Line count: net -10 to -20 lines (vs. the broken iter-102 first-pass state); the call site reverts to its iter-101 cumulative form.

## Constraints

- **No new axioms.**
- **No protected declarations modified.**
- **Preserve byte-for-byte**:
  - `presheafMap_restrict_collapse` (L425).
  - `alternating_sum_pi_smul_aux` (L462-L494).
  - `alternating_sum_pi_smul_aux_sum_comp` (L513-L537).
  - **`alternating_zsmul_pi_smul_aux_sum_comp` (L539-L590) — the new lemma stays.**
  - `cechCofaceMap_pi_smul` SIGNATURE and BODY PRELUDE through L772 (the `refine ... ?_ r y` line is at L773, which gets reverted; the lines L661-L772 above stay).
- **Do NOT modify `archon-protected.yaml`.**

## Verification

After revert, run:
```bash
${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" \
  AlgebraicJacobian/Cohomology/BasicOpenCech.lean --format=summary
```
Expected: 7 sorries.

And via Lean LSP:
```
lean_diagnostic_messages(AlgebraicJacobian/Cohomology/BasicOpenCech.lean, severity=error)
```
Expected: empty list.

Also confirm via `lean_build`:
```
mcp__archon-lean-lsp__lean_build (lean_project_path=...)
```
Expected: success=true with only warnings (sorry warnings + L436 maxHeartbeats lint).
