# Lean Audit Report

## Slug
iter255

## Iteration
255

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 6 flagged
- **excuse-comments**: none
- **notes**:
  - **L41–43 (status block)**: The module-header `## Status (current)` section reads "There are TWO tracked typed-`sorry` residuals (iter-254): … and D1′ itself (`pullbackTensorMap_natural`, gated below)." `pullbackTensorMap_natural` was closed this iteration, so the claim of TWO residuals is now factually wrong. A reader opening the file at iter-255 will believe there are still two sorries. Should be updated to ONE (only `exists_tensorObj_inverse`).
  - **L41-43 (status block)**: The "(iter-254)" parenthetical timestamp on the sorry list was never advanced. It is not clearly historical-only prose; it reads as the current state. At minimum it should say "(iter-254 → iter-255: D1′ CLOSED)" or similar.
  - **L1699, 1740**: `set_option maxHeartbeats 1600000 in` on `pullbackSheafifyUnitEtaTriangle` and `sheafifyTensorUnitIso_hom_natural` — 8× the default. Proofs touching sheafification-laden composites that slow to this extent are fragile: any Lean/Mathlib update that widens whnf scope will re-trigger the heartbeat wall.
  - **L1999, 2036**: `set_option maxHeartbeats 3200000 in` on `pullbackEtaUnitSquare` and `pullbackTensorMap_natural` — 16× the default. These are the most expensive proofs in the file; their cost budget is a maintenance liability against upstream Lean version bumps.
  - **L1661, 1671**: `set_option backward.isDefEq.respectTransparency false in` on `epsilonPresheafToSheafUnit`. The specific reason is documented (CommRing instance synthesis on a `restrictScalars`-wrapped carrier). Narrow and justified, but creates an elevated baseline transparency that future modifications to the proof body must account for.
  - **L2053–2058**: The `show … from (Hom.toRingCatSheafHom f).hom` type ascription inside `erw [← Functor.OplaxMonoidal.δ_natural …]` is the "mapin255 LIGHT fix." The comment documents why it works (forces a specific `MonoidalCategory` instance), but this ascription is a named-type workaround that will silently break if `δ_natural`'s signature changes (the `erw` would then fail with a non-obvious error) or if a future Lean version infers the instance differently.
  - **L2080, 2084**: `erw [Category.assoc]` and `erw [Iso.cancel_iso_hom_left]` to bridge the `Sheaf.val`/`.obj` defeq gap in the connecting object of `pullbackTensorMap_natural`. These two `erw`s are tightly coupled to the internal type spellings. A Mathlib refactor that normalises the `SheafOfModules`/`Scheme.Modules` carrier forms would require rewriting this section.
  - **L2085–2086**: `refine ((Functor.map_comp _ _ _).symm.trans ?_).trans (Functor.map_comp _ _ _)` — the isDefEq merge across the `.val`/`.obj` boundary that `rw`/`erw` cannot see. Correct, but opaque: the comment explains why `rw` fails, but not what invariant makes the `refine` succeed. If the connecting object's definitional equality changes, this silently stops working.
  - **`pullbackTensorMap_natural` overall**: The four-square paste compiles, but relies on five distinct defeq-boundary workarounds (`erw` for `.val`/`.obj`, a `show … from` ascription, an isDefEq `refine` merge, two `tensorHom_comp_tensorHom` TERM applications). Any one of these can silently fail after an upstream change. The heartbeat budget (3,200,000) is a canary: if it approaches that limit, the proof has already become unmaintainable.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged
- **excuse-comments**: 1 flagged
- **notes**:
  - **L9–33 (module docstring)**: `dual_restrict_iso` is described as "PARTIAL (iter-251)." We are at iter-255; the parenthetical iteration label is stale. This is a minor accuracy issue (the sorry is still open; the reference iter is just wrong), but cross-iteration readers will be confused.
  - **L441**: `set_option backward.isDefEq.respectTransparency false in` applied to the **entire** `homOfLocalCompat` definition. The option was presumably needed for a specific sub-step (possibly the `hcompat` or `hconn` legs), but no comment localises which one. Applying the option to the whole definition means: (a) all sub-goals inside are elaborated with widened defeq, silently making tactics succeed that would otherwise require explicit justification; (b) the proof body's sorry at L656 survives despite the option (the comment at L649 confirms this), but the option may have closed an intermediate goal that really required explicit justification. Without isolating which sub-step actually needed the option, future proof maintenance cannot narrow the scope.
  - **L162–228, L286–330, L462–511**: Large `/-  Planner strategy: … -/` planning documents embedded inside production API docstrings for `dual_restrict_iso`, `dual_isLocallyTrivial`, and `homOfLocalCompat`. Planning scaffolds belong in external informal files (e.g. `informal/`), not inline in production code docstrings. As the code evolves, these planning notes will drift from the actual proof structure and mislead readers about what is proven vs. planned.
  - **L648–655**: Comment says the remaining sorry is "REMAINING OBSTACLE (precisely isolated, much narrower than before)." The phrase "much narrower than before" embeds iteration-relative context that decays: in a future context, readers cannot know what "before" means or whether the isolation has changed.
  - **L648–650**: "verified live, the `:=`/`erw`/`refine` defeq check rejects the native vs `restrictScalars-𝟙` `isModule` instances even under `backward.isDefEq.respectTransparency false`." This "verified live" observation is hand-checked, not machine-checked. If the verification is stale (due to an upstream change), the sorry's scope may have shifted.
  - **L651 (excuse-comment)**: `-- TO CLOSE (next iter):` — explicit deferral. Flagged separately below.

---

## Must-fix-this-iter

- `DualInverse.lean:651` — Excuse-comment `-- TO CLOSE (next iter): bridge with …` attached to the inner `sorry` of `homOfLocalCompat` (the A-bridge). This is an admission that the code is incomplete with an explicit "will fix later" commitment. `homOfLocalCompat` is load-bearing (it feeds `exists_tensorObj_inverse`, which feeds the Picard group construction). Why must-fix: the audit rules treat "TO CLOSE (next iter)" as an excuse-comment per the standing definition; it documents that the project knows the proof is incomplete and has deferred it, which hardens wrong code.

---

## Major

- `TensorObjSubstrate.lean:41–43` — Status section claims "TWO tracked typed-`sorry` residuals (iter-254)" and names `pullbackTensorMap_natural` as one of them. This is factually wrong after iter-255. A first-time reader will believe there are still two sorries. The status block should be updated to reflect ONE residual (`exists_tensorObj_inverse` only), and to record that D1′ was closed in iter-255.
- `TensorObjSubstrate.lean:1999–2112` — `pullbackTensorMap_natural` carries `set_option maxHeartbeats 3200000` and five distinct defeq-boundary workarounds (`erw` for `.val`/`.obj`, a `show … from` ascription, an isDefEq `refine` merge, two TERM-application bifunctoriality closes). The proof is correct and closed, but it is structurally fragile: each workaround targets a specific Lean definitional equality that can shift with upstream changes. The heartbeat budget of 3,200,000 is a hard-to-maintain ceiling.
- `DualInverse.lean:441` — `set_option backward.isDefEq.respectTransparency false in` scoped over the entire `homOfLocalCompat` definition rather than the specific sub-step that required it. The sorry at L656 survives even with the option (confirmed in comment), but the broader scope introduces an uncontrolled transparency environment for the other sub-goals. The specific sub-step that needed the option should be isolated (scoped to the minimum tactic span) so future maintainers can reason about what each sub-step requires.
- `TensorObjSubstrate.lean:2053–2058` — The `show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶ … from (Hom.toRingCatSheafHom f).hom` ascription inside `erw [← Functor.OplaxMonoidal.δ_natural …]` is a non-obvious type workaround. If `δ_natural`'s signature is generalised or the monoidal instance changes, this `erw` will fail without a diagnostic that explains what went wrong.

---

## Minor

- `TensorObjSubstrate.lean:1699, 1740, 1936` — Multiple `set_option maxHeartbeats 1600000` (8× default) on `pullbackSheafifyUnitEtaTriangle`, `sheafifyTensorUnitIso_hom_natural`, and `pullbackValIso_hom_natural`. Each is documented with a specific reason (sheafification-laden `whnf` cost), but the collective budget escalation across the file is a maintenance concern.
- `DualInverse.lean:9–33` — Module docstring says `dual_restrict_iso` is "PARTIAL (iter-251)"; the iteration reference should be updated to reflect current state (still partial, now iter-255+).
- `DualInverse.lean:162–228, 286–330, 462–511` — Oversized planning scaffolds inside production docstrings. The information is valuable but belongs in `informal/` or `analogies/`, not inline in code.
- `TensorObjSubstrate.lean:2080–2086` — The `erw [Category.assoc]` / isDefEq `refine` pattern for the `.val`/`.obj` connecting-object boundary is correct but opaque without the surrounding comment. The comment is adequate, but anyone modifying `pullbackTensorMap` or `pullbackValIso` must read the comment carefully to avoid inadvertently breaking the boundary.

---

## Excuse-comments (called out separately)

- `DualInverse.lean:651`: `"-- TO CLOSE (next iter): bridge with \`ModuleCat.restrictScalars.smul_def\`/\`restrictScalarsId'App\`"` (attached to the `sorry` in `homOfLocalCompat`, the load-bearing A-bridge). Severity: **must-fix-this-iter** — the comment is a direct admission that the code is incomplete with an explicit future-iteration deferral.

---

## Severity summary

- **must-fix-this-iter**: 1
- **major**: 4
- **minor**: 5
- **excuse-comments**: 1 (also counted in must-fix-this-iter above)

Overall verdict: Both files are structurally sound — no wrong definitions or axiom violations — but `DualInverse.lean` carries an excuse-comment that must be addressed, the status section of `TensorObjSubstrate.lean` is now factually stale about the sorry count, and `pullbackTensorMap_natural`'s proof is correct but harbours five defeq-boundary workarounds and a 16× heartbeat budget that collectively make it the most fragile proof in the file.
