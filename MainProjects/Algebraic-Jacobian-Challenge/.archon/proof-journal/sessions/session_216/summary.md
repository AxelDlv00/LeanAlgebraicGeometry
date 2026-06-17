# Session 216 — review of iter-216

## Metadata
- **Iteration / session:** 216
- **Lane:** TS (`Picard/TensorObjSubstrate.lean`) — sole USER-permitted lane (ROUTE C PAUSE).
- **Global sorry count (loop-tracked):** 81 → **81** (net **0**, 7th consecutive flat window-iter).
- **TS-file code sorries:** 4 → **4** (`isLocallyInjective_whiskerLeft_of_W` L632, `tensorObj_restrict_iso` L1185, `exists_tensorObj_inverse` L1228, `addCommGroup_via_tensorObj` L1267).
- **Build:** GREEN. **Axiom-clean:** `restrictScalars_isIso_μ` `lean_verify` = `{propext, Classical.choice, Quot.sound}` — no `sorryAx`, no project axiom. The L1106 `opaque` warning is the known docstring comment-scan false positive.
- **blueprint-doctor:** clean (no orphans, all `\ref`/`\uses` resolve, no new `axiom`).
- **sync_leanok:** ran iter-216, sha `d9ca01c6`, **+1 / −0**, chapter `Picard_TensorObjSubstrate.tex`.

## Process anomaly (surface to next planner)
The iter-216 **plan agent explicitly deferred the prover** (`PROGRESS.md` Current Objectives: "(no prover dispatch this iter)"; rationale: blueprint HARD GATE returned `complete: partial`). **A prover ran anyway** — `attempts_raw.jsonl` records 12 edits + 8 diagnostics on `TensorObjSubstrate.lean` (17:12–18:05). The deferral intent was not honored by the loop; the prover executed the queued iter-217 objective-1 (the make-or-break + pivot) this iter. No harm done — the work is exactly what the planner wanted — but the gate-defer mechanism did not block dispatch. Worth noting so the next planner does not assume the deferral held.

## What the prover delivered

### 1. H2 ModuleCat strong-monoidal core — CLOSED, axiom-clean (6 new decls)
The documented Mathlib-absent fact that `ModuleCat.restrictScalars` along a **ring isomorphism** is **strong** monoidal (Mathlib ships `extendScalars` strong but only `restrictScalars` lax). All compile; `restrictScalars_isIso_μ` verified axiom-clean.

- `restrictScalarsRingIsoTensorEquiv_apply_tmul` (`@[simp]`) — `equiv (a ⊗ₜ[R] b) = a ⊗ₜ[S] b` for the iter-215 linear equiv.
- `restrictScalars_isIso_μ (e : R ≃+* S) (M₁ M₂) : IsIso (μ (restrictScalars e.toRingHom) M₁ M₂)` — proved `⇑μ = ⇑(restrictScalarsRingIsoTensorEquiv e M₁ M₂)` by tensor induction (`erw [ModuleCat.restrictScalars_μ_tmul]` on tmul), hence bijective, hence iso via `ConcreteCategory.isIso_iff_bijective`. **3 attempts to get the `zero` induction case** (see below).
- `restrictScalars_isIso_ε` — `⇑ε = ⇑e` (`ModuleCat.restrictScalars_η`), bijective since `e` is an equiv.
- `restrictScalarsMonoidalOfRingEquiv` — `@[implicit_reducible] noncomputable def … : (restrictScalars e.toRingHom).Monoidal` via `Functor.Monoidal.ofLaxMonoidal` after installing the two `IsIso` hyps.
- `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective` — bijective-ring-hom forms (consumed by the presheaf lift, where `(α.app X).hom` is bijective but not literally `(_ : R ≃+* S).toRingHom`); reduce via `RingEquiv.ofBijective` + `RingHom.ext`.

**Key tactic lesson (μ-iso):** the `hfun : ⇑μ = ⇑equiv` ext-induction needs `erw` (not `rw`) at `ModuleCat.restrictScalars_μ_tmul` (universe/instance elaboration), and the `zero`/`add` cases need explicit symmetrised maps — `rw [map_zero]; exact (map_zero _).symm` — because `simp only [map_zero]`/`rw [map_zero, map_zero]` do not rewrite under the equiv coercion:
- `rw [map_zero, map_zero]` → "Did not find an occurrence of the pattern `?f 0`".
- `simp only [map_zero]` → "unsolved goals ⊢ 0 = equiv 0".

### 2. MAKE-OR-BREAK determination (planner-requested) — pivot premise is FALSE
**Verdict: the "free-cover avoids H1" route does NOT discharge `tensorObj_restrict_iso`.** The consumer `tensorObj_isLocallyTrivial` (L1208–1211) applies `tensorObj_restrict_iso W.ι M N` to **arbitrary global** `M N` — the `restrict` is commuted past the **sheafified** tensor BEFORE the triviality witnesses `eM, eN` enter (the next `≪≫`). So the arbitrary-module statement — and therefore H1 (presheaf `pushforwardPushforwardAdj`) — is on the critical path. There is no free-cover shortcut.

**Consequence:** the iter-216 structural pivot does NOT eliminate the Mathlib-absent gap; it **relocates** it from route-(e)'s `d.2` (varying-ring stalk-⊗, the project's hardest absent piece) to **H1** (presheaf pushforward adjunction, ~100–150 LOC, mechanical — mirror `SheafOfModules.pushforwardPushforwardAdj`). The relocation is a genuine de-risking but the linchpin is still gated.

### 3. assoc_iso re-route + vestigial deletion — assessed, DEFERRED (sound call)
Research workflow confirmed (a) gluing infra EXISTS (`Sheaf.isLocallyBijective_iff_isIso`, `presheafHom` amalgamation — the analogist's "no gluing primitive" caveat was wrong), and (b) all 18 in-file helpers are referenced ONLY in this file (deletion-safe). But the re-route still depends on the open `restrict_iso` PLUS ~150–250 LOC overlap/amalgamation, so it would trade a vestigial whiskering `sorry` for a `restrict_iso`-transitive one with no honest-close gain and breakage risk on the currently-green decl. The prover correctly prioritised the zero-risk H2 deliverable + the make-or-break answer.

## Subagent reports (full content in task_results/)
- **lean-auditor ts216** — `task_results/lean-auditor-ts216.md`. 0 must-fix; 4 major (all stale docstrings: module "Status" header + `tensorObj`/`tensorObj_functoriality` still claim "typed sorry" though bodies are real; ROUTE (d)/(e) label inconsistency at L605/692); 4 minor (BP-1 `@[simp]` on `letI`-parameterised lemma likely won't fire; `set_option backward.isDefEq.respectTransparency false` ×3; flat-whisker lemmas dead-code; `tensorObjOnProduct` transitively sorry-backed). **All 6 new decls judged genuine + honest; the 4 sorries accurately labelled.**
- **lean-vs-blueprint-checker ts216** — `task_results/lean-vs-blueprint-checker-ts216.md`. **2 must-fix-this-iter** (see recommendations): (1) `lem:tensorobj_assoc_iso` blueprint (rewritten iter-216) says "direct gluing / no whiskering" but the Lean still uses route-(d) whiskering; (2) the "free-cover avoids H1" guidance in `lem:tensorobj_restrict_iso`/`lem:tensorobj_assoc_iso` is contradicted by the make-or-break finding. Plus 2 major (5 substantive iter-216 decls missing `\lean{}` pins; chapter doesn't describe the strong-monoidal packaging step).

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_restrict_iso` (proof block): added `% NOTE:` — the iter-216 make-or-break refutes the "free-cover avoids H1" guidance; H1 is on the critical path; writer correction needed.
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_assoc_iso` (proof block): added `% NOTE:` — the direct-gluing/"no whiskering" sketch does not match the Lean (still route-(d) whiskering); writer correction needed.
- No `\mathlibok` added: the 6 new decls are genuine project proofs, not Mathlib re-exports.
- No `\leanok` touched (owned by sync_leanok).

## Recommendations (detail in recommendations.md)
1. **BLOCKING (HARD GATE):** dispatch a blueprint-writer to fix the two must-fix contradictions in `Picard_TensorObjSubstrate.tex` BEFORE any prover re-attempts `tensorObj_restrict_iso`/`tensorObj_assoc_iso`.
2. The de-risked critical path is **H1** (presheaf `pushforwardPushforwardAdj`, ~100–150 LOC). Do NOT re-attempt a free-cover specialisation; do NOT revert to route-(e)/d.2.
3. Stale-docstring cleanup (lean-auditor 4 major) — fold into the next prover's objective or a refactor pass.
