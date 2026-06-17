# Session 232 — review of iter-232

## Metadata

- **Iteration / session:** 232.
- **Project sorry count (canonical):** 80 → 80 (unchanged; see "Counter" below).
- **Prover lanes:** ONE — `Cohomology/FlatBaseChange.lean` (mode `prove`, opus).
- **Headline:** the **"strategy pivot + first stall-independent engine lane: the base-change MAP lands axiom-clean on a fresh front"** iter. The plan phase made a substantive carrier pivot (dissolving the 14-iter `exists_tensorObj_inverse` stall) and opened a parallel engine lane; the prover built that lane's primary deliverable.

## Context: what the plan phase did (not the prover, but it frames this iter)

The iter-232 plan phase (recorded in `iter/iter-232/plan.md`) executed three structural moves on the advice of two mandatory critics:
1. **Carrier pivot (strategy-critic CHALLENGE, ADOPTED):** carry `Pic X` on tensor-invertibility `IsInvertible M := ∃N, M⊗N≅𝒪` (Stacks 0B8M) instead of the locally-trivial predicate — making the group inverse a free membership *witness* and demoting the entire dual / `dual_restrict_iso` / `exists_tensorObj_inverse` arc to a deferred bridge.
2. **File-split (refactor):** `TensorObjSubstrate.lean` (2375 L) → `TensorObjSubstrate.lean` (768 L, public API + the 2 deferred sorries), `TensorObjSubstrate/PresheafInternalHom.lean` (1098 L, **0 sorries**), `TensorObjSubstrate/Vestigial.lean` (588 L, quarantined L691 whiskering sorry + dead slice-site root). Build GREEN.
3. **Engine de-gating:** the A.2.c cohomology engine (`R^i f_*`, flat base change, …) does not depend on the group law; the plan opened the first stall-independent engine prover lane this iter (`Cohomology/FlatBaseChange.lean`) and wrote the `Cohomology_HigherDirectImage.tex` chapter for the next lane.

The carrier-pivot prover was **deferred to iter-233** (pending the mandatory re-review of the freshly rewritten `Picard_TensorObjSubstrate.tex`). So this iter's prover worked the engine lane only.

## Target-by-target (the prover lane)

### `pushforwardBaseChangeMap` (def) — SOLVED, axiom-clean

- **Approach:** the canonical base-change map `g^*(f_*F) ⟶ f'_*(g'^*F)` built as the adjoint mate (under `pullback g ⊣ pushforward g`) of
  `(pushforward f).map (unit_{g'} F) ≫ (pushforwardComp g' f).hom ≫ (pushforwardCongr comm).hom ≫ (pushforwardComp f' g).inv`.
- **Key API** (Mathlib `AlgebraicGeometry/Modules/Sheaf.lean`): `Scheme.Modules.pushforward` / `pullback` / `pullbackPushforwardAdjunction` / `pushforwardComp` / `pushforwardCongr`.
- **Gotcha (recorded):** `pullback` is ambiguous with `Limits.pullback` under `open Limits` — qualify as `Scheme.Modules.pullback` in the signature. (The one live error this session, fixed by an Edit at L77.)
- **Verified:** `lean_verify` → axioms `{propext, Classical.choice, Quot.sound}` only. Sorry-free. This is a genuine, frontier-ready deliverable.

### `affineBaseChange_pushforward_iso` (lemma) — PARTIAL (genuine reduction + typed sorry)

- **Approach:** `rw [Scheme.Modules.Hom.isIso_iff_isIso_app]; intro U` reduces `IsIso (base-change map)` to sectionwise `IsIso (Hom.app … U)` over each `U : S'.Opens`. Live-verified via `lean_multi_attempt`. `sorry` at the section-iso step.
- **Blocker (precise, named):** Mathlib lacks (1) the affine dictionary translating `Scheme.Modules.pushforward`/`pullback` of `tilde`-modules on `Spec` into `ModuleCat.restrictScalars` / base change, and (2) an "iso local on an affine cover" criterion for `SheafOfModules` maps. The **algebraic heart is present**: `TensorProduct.AlgebraTensorModule.cancelBaseChange` (`(R'⊗[R]A)⊗[A]M ≃ R'⊗[R]M`, no flatness). Confirmed absent by source grep over `Mathlib/Algebra/Category/ModuleCat/Sheaf/` and `Mathlib/AlgebraicGeometry/Modules/`.

### `flatBaseChange_pushforward_isIso` (theorem) — DEFERRED (documented sorry, per directive)

- Directive explicitly permitted leaving the deep Čech+flatness theorem as `sorry`. Body carries the full Stacks-02KH reduction strategy as a comment (reduce to affine target `A→B` flat; Čech complex computes `H^0`; term-wise base change via the affine lemma; flatness ⟹ `-⊗_A B` exact ⟹ commutes with `H^0`). Needs Čech-cohomology / affine-cover infrastructure for `SheafOfModules` (not in Mathlib).

## Counter — why 80 → 80 despite a real deliverable

The new file `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` is **NOT yet imported by `AlgebraicJacobian.lean`** (the package aggregator). The prover flagged this in its task result (cross-file wiring is outside its single-file write domain). Consequences:
- The axiom-clean `pushforwardBaseChangeMap` and the 2 new sorries live in an **orphan module** — invisible to the canonical package build, so the project counter is unchanged at 80.
- Standalone `lake build AlgebraicJacobian.Cohomology.FlatBaseChange` succeeds (8317 jobs, only the 2 expected sorry warnings).
- **This is the single most important action item for iter-233:** add `import AlgebraicJacobian.Cohomology.FlatBaseChange` to `AlgebraicJacobian.lean`, or the lane's output never reaches the project.

## Honest read

This iter is categorically different from the 230/231 no-edit/probe stalls. It produced a **real axiom-clean deliverable** (the base-change map) on a **fresh, unblocked front**, and the plan made a substantive strategy pivot that targets the actual stall. That is genuine forward motion — but two caveats are owed:
1. The canonical counter is still flat (15th iter), and the deliverable is **orphaned** until the import is wired. Until then the engine lane contributes nothing to the build.
2. The carrier pivot's claim ("inverse becomes free") is still a *plan-level claim*; the iter-233 carrier-pivot prover is the first test of it. The counter-moving datapoint remains owed.

## Environment note

The informal-agent script was **unavailable**: only `MOONSHOT_API_KEY` is set (base `https://api.kimi.com/coding/`) and it returns HTTP 401 against the script's `api.moonshot.cn` endpoint; no `DEEPSEEK/OPENROUTER/OPENAI/GEMINI` key. The prover proceeded without it. (Note: `.claude/tools/archon-informal-agent.py` shows as modified in the working tree.) Recurring across recent iters — flagged for the user; the loop does not depend on it.

## Blueprint-doctor finding (structural)

The deterministic doctor flagged ONE coverage problem: `Cohomology_HigherDirectImage.tex` declares `% archon:covers AlgebraicJacobian/Cohomology/HigherDirectImage.lean`, **which does not exist**. The chapter was written this iter as the next engine seed but its `covers` target is unscaffolded. Surfaced to recommendations.

## sync_leanok attribution

`sync_leanok` ran for iter-232 (sha `4eb7c57c`): **+8 / −46**, chapters_touched includes `Cohomology_FlatBaseChange.tex`, `Picard_TensorObjSubstrate.tex`, and four others. The large −46 is consistent with the **structural reset** (file-split demoting/relocating the dual-bridge blocks whose decls moved out of the public file) and the carrier rewrite — NOT laundering. The +8 includes the legitimate `\leanok` on `pushforwardBaseChangeMap` (sorry-free, axiom-clean) and statement-level `\leanok` on the two new decls (declarations exist, with sorry). Verified first-hand against the chapter.

## Blueprint markers updated (manual)

- `Cohomology_FlatBaseChange.tex`, `lem:affine_base_change_pushforward` (proof): added `% NOTE:` recording the named Mathlib gap (affine Spec/tilde dictionary + `cancelBaseChange`) and pointing at `informal/affineBaseChange_pushforward_iso.md`.
- `Cohomology_FlatBaseChange.tex`, `thm:flat_base_change_pushforward` (proof): added `% NOTE:` recording the deferred Čech/affine-cover infrastructure dependency.
- No `\mathlibok` added (the three decls are project constructions, not Mathlib re-exports).
- Did NOT touch any `\leanok` (sync_leanok's domain).

## Subagent reports

- `lean-vs-blueprint-checker` (slug `flatbasechange`) and `lean-auditor` (slug `flatbasechange`) dispatched on the new file. See `recommendations.md` for landed findings and `task_results/` for the full reports.
