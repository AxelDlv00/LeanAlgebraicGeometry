# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## iter-224 — `internalHomEval` naturality (assigned PRIMARY target)

### Result: ALREADY CLOSED (verified) — no edit required

**The assigned `sorry` was already closed by prior iter-224 work** that the
plan-phase LSP snapshot had not yet picked up (the PROGRESS.md objective and the
first `lean_diagnostic_messages` call reported a stale `sorry` "at line 1475"; the
current on-disk file has no such sorry).

`PresheafOfModules.internalHomEval` (def at ~L1457) is **complete and axiom-clean**.
Its `naturality` field is the full six-step reduction (verbatim, L1461–1500):

```lean
PresheafOfModules.Hom.mk (fun X => internalHomEvalApp M X) (by
  intro X Y f
  refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)
  erw [ModuleCat.hom_comp, ModuleCat.hom_comp, LinearMap.comp_apply, LinearMap.comp_apply,
    internalHomEvalApp_tmul, internalHomEvalApp_tmul]
  simp only []
  change M.evalLin Y ((M.dual.map f) φ) ((M.map f) s)
    = ((𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))).map f).hom
        (M.evalLin X φ s)
  have key := PresheafOfModules.naturality_apply
    (φ : restr X.unop M ⟶ restr X.unop
      (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))))
    (Over.homMk f.unop : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op s
  rw [restr_map_homMk, restr_map_homMk] at key
  have hdt : M.evalLin Y ((M.dual.map f) φ) = (φ.app (op (Over.mk f.unop))).hom :=
    congrArg ModuleCat.Hom.hom
      (eq_of_heq (hom_app_heq
        (φ : restr X.unop M ⟶ restr X.unop
          (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))))
        (congrArg op (congrArg Over.mk (Category.id_comp f.unop)))))
  exact (DFunLike.congr_fun hdt _).trans key
  )
```

So the iter-222/223 `whnf` HEARTBEAT-BOMB diagnosis was indeed STALE (as recorded in
memory): a Mathlib update lets the composition split with `erw [ModuleCat.hom_comp, …]`,
after which the `evalLin`/`naturality_apply`/`hdt` reduction goes through directly —
**no `with_reducible`, no `unit`-reshape, no `maxHeartbeats` bump.** ROUTE A/ROUTE B
from the directive were not needed because the proof was already in place and working.

### Verification (authoritative)

- `lean_verify PresheafOfModules.internalHomEval` (correct param `file_path`) and an
  independent subagent run both report axioms = **`{propext, Classical.choice, Quot.sound}`**
  — **no `sorryAx`**. internalHomEval is axiom-clean.
- `lean_build` (full project): **success, 8362 jobs, `errors: []`** (only style/deprecation
  + unrelated-file sorry warnings).
- `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean` → **EXIT=0, 0 errors.**
- Bare `sorry` tokens in the file: **3**, at the three declarations the directive says to
  leave untouched:
  - L641 `isLocallyInjective_whiskerLeft_of_W` (route-(e) residual; d.1-bridge + d.2 stalk⊗
    commutation — documented genuinely Mathlib-absent; NOT this iter's target)
  - L1935 `exists_tensorObj_inverse` (**FORBIDDEN this iter** — sub-step 5)
  - L1981 `addCommGroup_via_tensorObj` (**FORBIDDEN this iter** — RPF consumer)
  `internalHomEval` is **not** among them.

### Project sorry count

Project sorry 81 → **80** (the `internalHomEval` naturality sorry is retired). **Sub-step 3
RETIRED.** This matches the file-header `## Status` block and the blueprint pin
`lem:internal_hom_eval` (ready for `\leanok` on its proof via `sync_leanok`).

### Edits made this session

**None.** I attempted no-op `Edit`s based on the stale LSP line numbers (looking for a
`sorry` + a "Step 2: reduce the LHS dual-restriction …" comment that do not exist); every
`Edit` returned "String to replace not found", so the file is **byte-unchanged**
(md5 `a86742554456110112389b065eed01f7`, 1987 lines). All `lake env lean` / `lean_build`
runs were read-only compiles and confirm the green, axiom-clean state.

### Ride-along (comment-only items from PROGRESS)

Already done by the prior iter-224 session — no action needed:
- (a) file-header `## Status` block already lists exactly the 3 residuals and already
  describes `internalHomEval` as CLOSED with the whnf-bomb diagnosis marked stale.
- (b)/(c)/(d) the cited docstrings/comments already reflect closed state.

### Tooling note for the planner (important)

This session ran in a **degraded harness**: large/unicode-heavy `Read`/`Bash`/`Grep`
outputs were intermittently truncated, fabricated, leaked between calls, or dropped; the
**first** `lean_diagnostic_messages` returned a STALE snapshot (showing the already-closed
sorry); and several MCP LSP calls failed because the schema field is **`file_path`**, not
`relative_path`. Authoritative signals that DID work: `lake env lean … ; echo EXIT=$?`
piped to a small grep, single-line `awk`, the (delayed) `Agent` subagent, and `lean_build`.
Future sessions on this file: use `file_path` for all `mcp__archon-lean-lsp__*` calls and
treat the first diagnostic snapshot as potentially stale (cross-check with a fresh
`lean_build` / `lake env lean`).

## Summary

- **Sorry count (this file): before 3 → after 3** (the assigned `internalHomEval` sorry was
  already closed before this session; the 3 remaining are the untouched/forbidden ones).
- **Sorries closed this session:** none *by me* — `internalHomEval` naturality was already
  closed by prior iter-224 work; I **verified** it (axiom-clean, build green).
- **Sorries still open:** `isLocallyInjective_whiskerLeft_of_W` (L641, hard Mathlib-absent
  d.2 stalk⊗ residual), `exists_tensorObj_inverse` (L1935, FORBIDDEN), and
  `addCommGroup_via_tensorObj` (L1981, FORBIDDEN).
- **Adjacent sorries attempted beyond assignment:** none — the only non-forbidden one (L641)
  depends on the genuinely Mathlib-absent stalk-tensor commutation (d.2), not tractable
  here and out of scope; I developed no new infrastructure that would open a path to it.

## Why I stopped

`Real progress (verification only, no new code)`: The assigned PRIMARY target —
`PresheafOfModules.internalHomEval`'s naturality — is **already closed and axiom-clean**
in the on-disk file (complete six-step reduction present; `lean_verify` =
`{propext, Classical.choice, Quot.sound}`; `lean_build` green). My net code change is
**zero** (every `Edit` was a no-op no-match against stale line numbers), so per the strict
rubric this counts as **verification, not new proof progress** — but the iter-224 objective
(retire sub-step 3, project sorry 81→80, `internalHomEval` axiom-clean, build GREEN) is
**met**. I did not touch the two FORBIDDEN residuals (L1935/L1981) or `tensorObj_assoc_iso`,
and did not pursue L641 because its blocker (the d.2 `(F ⊗ M)_x ≅ F_x ⊗_{R_x} M_x` stalk
commutation over a varying ring) is the documented Mathlib-absent piece, out of scope for
a `prove`-mode session and unsupported by anything I built here.
