# Recommendations for the next plan agent (post-iter-221)

> Review-subagent findings (`lean-auditor` ts221, `lean-vs-blueprint-checker` ts221) are folded
> into the "Review-subagent findings" section below. **Both returned 0 must-fix-this-iter** — no
> blocker for the next prover round.

## 1. Continue the funded build — assemble `internalHomEval` (sub-step 3 → done)

The dual object and per-object eval landed; the missing piece is the FULL natural evaluation
morphism `internalHomEval`. Dispatch a `mathlib-build` prover on:

- **Target:** `internalHomEval : M ⊗_R M^∨ ⟶ R` — `Hom.mk` with `app X := internalHomEvalApp M
  X` and the semilinear `naturality` field.
- **Concrete handoff (do NOT let the prover re-derive — it is already worked out).** The
  naturality goal reduces, via `ModuleCat.MonoidalCategory.tensor_ext`, to
  `evalLin M Y ((dual M).map f φ) (M.map f s) = (𝟙_).map f ((φ.app term).hom s)`, i.e.
  `PresheafOfModules.naturality_apply φ (Over.homMk f.unop).op s` modulo three `Over.map`
  coherence identifications (named in
  `task_results/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md` §`internalHomEval (NOT
  ADDED)`). This is the **same `Over.map` pseudofunctor coherence obstacle iter-220 cracked for
  `restrictionMap`** (`hom_app_heq`: `subst h; rfl` + `eq_of_heq`). Point the prover at the
  iter-220 `restrictionMap` functoriality proof as template.
- A first sub-step is the helper `internalHomEvalApp_tmul`
  (`(internalHomEvalApp M X).hom (s ⊗ₜ φ) = evalLin M X φ s`, via `TensorProduct.lift.tmul`) —
  the prover had it building modulo the `(𝟙_).obj X` vs `R₀.obj X` codomain ascription; state
  the value at its natural type, NOT ascribed to `(𝟙_).obj X`.
- **Honour the diamond-bridge rules** (PROJECT_STATUS KB): keep eval values at their natural
  over-ring type; `show ... from ofHom ...` at the `ofHom` boundary; NEVER land eval in
  `(𝟙_).obj X`. No-sorry invariant (sorry must stay 3).

## 2. Track the lane by sub-step retirement, NOT sorry count

The build is **elapsed 3 of ~6–12**. Remaining bricks toward the ⊗-inverse: finish the eval
morphism → split `lem:internal_hom_isSheaf` + build the sheaf-level dual (`Scheme.Modules.dual`,
sub-step 4) → inverse object → iso-class `CommGroup` → group law → RPF consumer
(`addCommGroup_via_tensorObj`). The project sorry counter has not moved since iter-217 (81→80)
**by design** — do not read this as a stall. progress-critic ts221 = CONVERGING (~1 sub-step/iter).

**Churn trigger to watch (iter-222):** PARTIAL with only more eval helpers and no assembled
`internalHomEval` morphism. If that fires, run a `mathlib-analogist` (api-alignment) on
`Over.map` naturality / `SheafOfModules` morphism descent before re-proving.

## 3. Blueprint maintenance before the next prover round (HARD GATE)

For `blueprint-writer` on `Picard_TensorObjSubstrate.tex`:

- **(carryover, non-blocking from iter-220)** repoint the `def:presheaf_internal_hom` `\lean{}`
  pin to the `PresheafOfModules.InternalHom.` namespace if not already done.
- **(prover suggestion)** consider pinning the new per-object helpers in the chapter:
  `internalHomEvalApp` could back an "open-by-open contraction" sub-block under
  `lem:internal_hom_eval` (mirroring how `internalHomObjModule`/`restrictionMap` back
  `def:presheaf_internal_hom`), so the next prover formalizes the natural-morphism assembly
  against a current chapter.
- **(blueprint-reviewer ts221 "soon", sub-step 4)** split `lem:internal_hom_isSheaf` into a
  pinned sheaf-object block + the `Scheme.Modules.dual` block BEFORE sub-step 4 is dispatched.

Run the HARD-GATE fast path (scoped blueprint-reviewer on this chapter after the writer + green
build) before adding the file to objectives for sub-step 4.

## 4. No do-not-retry blocks

`internalHomEval` is NOT a do-not-retry — it has a concrete precedented path (item 1). The 3
file residuals (`isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`,
`addCommGroup_via_tensorObj`) remain downstream of the funded build and must NOT be assigned as
proof-fill until the dual→eval→sheafify→inverse chain reaches them.

## Review-subagent findings

Both dispatched this review phase on the prover-touched file. **Neither reports a
must-fix-this-iter blocker.** The 6 new decls are confirmed genuinely proved and axiom-clean.

### lean-auditor ts221 (`logs/iter-221/lean-auditor-ts221-report.md`) — 0 must-fix, 3 major, 6 minor

- **MEDIUM (major) — 2 stale status docstrings misreporting proof status** (comment-only, fold
  into the next prover's ride-along cleanup; do NOT touch proof bodies):
  - `tensorObjOnProduct` (~L1853): docstring says "iter-202 Lane TS scaffold: typed `sorry`" but
    the decl is fully proved & axiom-clean.
  - `tensorObj_assoc_iso` (~L1562): the embedded status block claims "genuine residual is the
    flatness" but the proof uses ROUTE (d) (avoids flatness); the real residual is the
    `isLocallyInjective_whiskerLeft_of_W` sorry. Update so a reader of the decl in isolation
    isn't misled.
- **MEDIUM (major) — 14 occurrences of deprecated `CategoryTheory.Sheaf.val`** (lines
  1441–1638, in `tensorObj`/`tensorObj_functoriality`/unitors/braiding/assoc): compiler warns
  "Use ObjectProperty.obj". Schedule a mechanical sweep before Mathlib removes the accessor —
  good candidate to bundle into the next prover's ride-along or a small `refactor` pass.
- **LOW (minor):** transitive `sorryAx` in `tensorObj_assoc_iso` not disclosed in its own
  docstring (file header lists it); unused `hM/hN/hP` in `tensorObj_assoc_iso` (kept for
  blueprint-pin conformance); `ext r` unused pattern (L311); 3 over-length lines (L1764–1766);
  4× `set_option backward.isDefEq.respectTransparency false` (instance-diamond workaround,
  signals resolution fragility); blanket `import Mathlib`.
- Confirmed first-hand: `dual`, `termRingMap_terminal`, `evalLin`, `evalLin_add`, `evalLin_smul`,
  `internalHomEvalApp` all `{propext, Classical.choice, Quot.sound}`; `@[implicit_reducible]` on
  `internalHomObjModule` present & correctly placed; 3 pre-existing sorries at ~602/1839/1889,
  no new ones.

### lean-vs-blueprint-checker ts221 (`logs/iter-221/lean-vs-blueprint-checker-ts221-report.md`) — 0 blocking must-fix

- Verdict **PARTIAL** (Lean faithful & axiom-clean; one pinned label is ahead of the Lean). No
  fake/weakened statements. `def:presheaf_dual` fully realised & faithful.
- `lem:internal_hom_eval` is `\lean{PresheafOfModules.internalHomEval}`-pinned but that decl does
  not exist yet (only `internalHomEvalApp`). This is EXPECTED mid-build; `sync_leanok` correctly
  leaves it unmarked. **No `\lean{}` rename to apply** (nothing was renamed) — no review-agent
  marker action needed.
- **Soft (feeds item 3 above):** (a) add a blueprint sub-block `lem:internal_hom_eval_app`
  pinned `\lean{PresheafOfModules.internalHomEvalApp}` so `sync_leanok` can mark the genuine
  per-object progress and the next prover has a named intermediate target; (b) name the
  `restrictionMap` functoriality reuse (iter-220 `hom_app_heq`/`subst`) explicitly in the
  `lem:internal_hom_eval` proof sketch. Blueprint judged **adequate** for the next sub-step.
