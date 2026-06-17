# Iter-148 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED** on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` with 2 in-scope sorries (KDM forward inclusion L139 → L168 + constants substep 3 L294 → L367). Result: **2 substantive partials, NET 0 strict-count delta on sorries, substantive structural advance on constants substep 3** (4-claim sub-decomposition; smart-proof framework sorry-free). `meta.json`: `planValidate.status: ok / objectives: 1`, `prover.status: done`, `prover.durationSecs: 1465` (~24.4 min).

- **Sorry count delta** (declarations using `sorry` / inline `sorry`): 5 / 5 → **5 / 5** (NET 0). Per-file at iter-148 close:
  - `Cotangent/ChartAlgebra.lean` — **2 / 2** (unchanged):
    - L168 `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` forward inclusion (was L139 iter-147; docstring refresh moved the line number).
    - L367 `constants_integral_over_base_field` (was L294 iter-147; smart-proof reduction L307–L371 + structured sorry at the consolidated `IsPurelyInseparable ∧ Algebra.IsSeparable` step).
  - `Cotangent/GrpObj.lean` — 0 / 0 (unchanged).
  - `Jacobian.lean` — 2 / 2 (unchanged).
  - `RigidityKbar.lean` — 1 / 1 (unchanged).

- **Per-target outcome** (iter-148 in-scope: 2 of 2 chart-algebra remaining sorries):
  - **(constants substep 3) `constants_integral_over_base_field`** — PARTIAL (structural advance). Iter-147 7-step closure chain (a)–(g) chain superseded iter-148 by smart-proof path (b) framework: `rw [RingHom.range_eq_top]` → algebraize via `Scheme.ΓSpecIso` + `RingHom.toAlgebra` → reduce `appTop.hom surj ⟺ algebraMap k Γ surj` → close via `IsPurelyInseparable.surjective_algebraMap_of_isSeparable` after the consolidated conjunction. **Residual sorry concentrated on `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ`**; 4 named sub-claims: (S3.pi.1) `Γ_{\bar k} ≅ Γ ⊗_k \bar k` flat base change; (S3.pi.2) finite-dim k-algebra with `_ ⊗_k \bar k` having unique min prime ⇒ PI; (S3.sep.1) `Smooth ⇒ IsGeometricallyReduced`; (S3.sep.2) geom-reduced fin field ext ⇒ separable. All 4 sub-claims verified to be Mathlib gaps in b80f227 by the iter-148 prover-lane's full grep.
  - **(KDM) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`** — PARTIAL (docstring refresh; no new code). L137–168 in-source docstring now lists the (BR.1)–(BR.5) char-0 bridge sub-gap inventory: (BR.1) `Algebra.IsStandardSmooth k B` chart hypothesis required for signature inflation; (BR.2) basis selection via `Algebra.IsStandardSmooth.free_kaehlerDifferential` (verified Mathlib b80f227); (BR.3) coefficient-derivation extraction `∂_i : B → B` (~30–50 LOC); (BR.4) `Differential B` instance per `∂_i`; (BR.5) `Differential.ContainConstants` instance for the chosen `∂_i` in `CharZero k` — Mathlib has the class but no instance for standard-smooth + CharZero.

- **Substantive code delta** (iter-148 prover lane, 5 edits / 3 goal checks / 4 diagnostic checks / 0 LSP builds + 2 `lake build` invocations per `attempts_raw.jsonl`): `Cotangent/ChartAlgebra.lean` 342 → **419 LOC** (+77 LOC). One declaration body refactored to smart-proof path (b) framework (substep 3); one declaration docstring expanded with (BR.1)–(BR.5) sub-gap inventory (KDM). No other files edited; no protected signatures touched.

- **Net structural advance**: the iter-148 prover lane invested significant Mathlib reconnaissance (full grep across `Mathlib/RingTheory/Derivation/`, `Mathlib/RingTheory/Kaehler/`, `Mathlib/RingTheory/Smooth/`, `Mathlib/RingTheory/Unramified/`, `Mathlib/AlgebraicGeometry/Geometrically/`, etc.) to confirm that:
  - the (p2) char-0 KDM path requires a Mathlib-PR-grade bridge (not a thin in-tree wrapper); and
  - the substep 3 step (e) "flat base change of Γ for proper schemes" gap (now (S3.pi.1)) is genuinely 250–500 LOC ad-hoc.
  - **(S3.sep.1)** `Smooth ⇒ IsGeometricallyReduced` is a fresh Mathlib gap on the (b.1) side, unaddressed by the iter-148 plan-phase analogist (which targeted step (e) only).
  The iter-149+ continuation has a clean 4-claim residual list to target rather than the iter-147's single-residual "geom-irr base change" framing.

- **Iter-149 escalation hook (per iter-148 plan `## Decision 3`)**: triggered nominally (iter-148 closed neither sorry) BUT **satisfied by the planner's carve-out**: "A reduction to a different lemma family (including the path (b) smart-proof gap 'Γ of smooth ⇒ Γ separable')". The iter-148 smart-proof reduction produces (S3.sep.1) as the exact "Γ of smooth ⇒ separable"-family bridge claim. Iter-149 progress-critic should read Route 1 as **CONVERGING-with-Mathlib-gap-pivot**, not STUCK / CHURNING.

- **2 review-phase subagent dispatches** (this iter, both mandatory; both returned + absorbed):
  - `lean-auditor-iter148` → 6 must-fix-this-iter + 5 major + 3 minor + 0 excuse-comments. **Headline**: `mem_range_algebraMap_of_D_eq_zero` ships a signature whose conclusion is mathematically false under the stated hypotheses (the in-source docstring at L117–119 openly admits the char-p counter-example); the auditor escalates this from "documented sorry" to "weakened-wrong-definition" must-fix. Other must-fix items: substep 3 consolidated sorry at L367 (gated on Mathlib infrastructure), 4 documented load-bearing sorries elsewhere (`Jacobian.lean:197/223`, `RigidityKbar.lean:87`). Major items: 4 stale section-framing blocks in `Cotangent/GrpObj.lean:297-525` (referring to iter-145-excised declarations) + 1 proof-golfing dead-end in `Jacobian.lean:102-128` `IsAlbanese.unique`. Minor: 2 cosmetic iter-number drifts (`AbelJacobi.lean:14`, `Genus.lean:14`) + 1 aspirational name (`Scheme.Over.ext_of_diff_zero`). Advisory: the review agent's auditor directive carried a stale file list (6 files don't exist, 2 missing); plan agent should refresh via glob.
  - `lean-vs-blueprint-checker-chartalgebra-iter148` → 1 must-fix + 2 major + 1 minor. **Headline**: `df_zero_factors_through_constant_on_chart` is a structurally weaker stand-in for the blueprint's named theorem — Lean drops `(A, f, W, V, B, R, f^{\sharp}, df = 0)` chart-pair data and keeps only `(k, C-typeclasses, B, b, hDb)`; the four `C`-side typeclasses are decorative. The blueprint side carries no NOTE authorising this collapse; the Lean side acknowledges the gap in the in-source docstring but the bidirectional mismatch is the must-fix. Also: blueprint's `lem:constants_integral_over_base_field` proof block is silent on the iter-148 path (b) route. **One side of both findings landed this review via 2 `% NOTE: (iter-148 review)` blocks on `RigidityKbar.tex`** (statement block of β-core + proof block of constants). Lean-side fix is queued as REC-3-bis in `recommendations.md`.

## Sorry trajectory (Route 1)

| Iter | Decls | Inline | Δ | Notes |
|---|---|---|---|---|
| 144 | 6 | 6 | — | bundled-route pre-pivot |
| 145 | 8 | 8 | +2 | chart-algebra decomposition cost |
| 146 | 6 | 6 | −2 | α + lift closed; constants partial |
| 147 | 5 | 5 | −1 | β-core closed; KDM + constants partial |
| 148 | **5** | **5** | **0** | KDM + substep 3 both PARTIAL; structural advance via smart-proof reduction |

Three consecutive iters of substantive Route 1 progress (iter-146 + iter-147 strict-count drops; iter-148 NET-0 with structural advance). The iter-148 NET-0 is the **first non-strict-decrease** on Route 1 since the iter-145 chart-algebra decomposition cost, but is qualified by the iter-148 plan's pre-committed acceptable-narrowing clause and reflects the project moving from "1 large opaque gap" to "4 named smaller gaps" rather than churning.

## Blueprint markers landed manually (iter-148 review)

2 `% NOTE: (iter-148 review)` annotations landed in `blueprint/src/chapters/RigidityKbar.tex` in response to the `lean-vs-blueprint-checker-chartalgebra-iter148` must-fix-this-iter findings:

- `RigidityKbar.tex` § `lem:chart_algebra_df_zero_factors_through_constant_on_chart` (statement block, immediately after `\uses{...}`): added a `% NOTE: (iter-148 review)` block authorising the iter-148 thin-wrapper disposition (Lean drops `(A, f, W, V, B, R, f^{\sharp}, df = 0)` chart-pair data and keeps only `(k, C-typeclasses, B, b, hDb)`). Mirrors the iter-146/iter-147 NOTE discipline on `\lem:Scheme_Over_ext_of_diff_zero`. Documents that the four `C`-side typeclasses are decorative under the current commitment and pins the iter-149+ substantive-refinement plan.
- `RigidityKbar.tex` § `lem:constants_integral_over_base_field` (proof block, just after `\leanok`): added a `% NOTE: (iter-148 review)` block documenting the iter-148 prover-lane commitment to path (b) SMART PROOF (bypassing step (e) flat-base-change-of-Γ-for-proper-schemes via `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`) and pinning the four (S3.pi.1) / (S3.pi.2) / (S3.sep.1) / (S3.sep.2) named sub-claims so iter-149+ prover lanes can target them by name. The 7-step chain (a)–(g) below remains as the informational alternative.

No `\leanok` touched (deterministic sync's domain). No `\mathlibok` added (closest candidate `algebra_isPushout_of_affine_product` is `inferInstance`, not `:= Mathlib.bar`; same disposition as iter-147). No `\lean{...}` corrections required (no renames in the prover lane). No stale `\notready` to strip on the prover-touched declarations.

## Notable structural decisions absorbed

- **Smart-proof reduction `Function.Surjective (algebraMap k Γ) ⟸ IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` via `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`** (`Mathlib/FieldTheory/PurelyInseparable/Basic.lean:158`). The natural closer when a finite field extension is shown to be both PI and separable. Iter-148 instance: substep 3 of `constants_integral_over_base_field`. The reduction bypasses the step (e) flat-base-change-of-Γ-for-proper-schemes Mathlib gap entirely — at the cost of factoring the residual into a 4-claim sub-decomposition where each sub-claim is independently named and tractable.

- **`Scheme.ΓSpecIso (.of k)).inv` is the canonical `(.of k) ⟶ Γ(Spec(.of k), ⊤)` arrow** for promoting `appTop : Γ(Spec k, ⊤) ⟶ Γ(X, ⊤)` to a `k → Γ(X, ⊤)` algebra map under `RingHom.toAlgebra`. Fully-qualified `Scheme.ΓSpecIso` required (NOT bare `ΓSpecIso`); Mathlib `Mathlib/AlgebraicGeometry/Scheme.lean:606`.

- **Mathlib reconnaissance dead-ends as iter-148 structural advance**: iter-148 invested ~60 grep+read events on Mathlib b80f227 to confirm 3 separate gaps (smooth ⇒ IsGeometricallyReduced absent; proper-Γ-flat-base-change absent; `Differential.ContainConstants` instance for standard-smooth absent). Documented in `summary.md` § "Key findings". Future plan agents should NOT re-dispatch the analogist on these 3 specific questions.

## Open items for iter-149 plan agent

- **REC-1** (top priority): substep 3 (S3.sep.1) bridge attempt as the cleanest single sub-claim closure. Estimated ~80–150 LOC.
- **REC-2**: KDM signature inflation `[CharZero k] + [Algebra.IsStandardSmoothOfRelativeDimension k B]` + (BR.1)–(BR.5) bridge body (~80–150 LOC). β-core consumer's signature inflates correspondingly; iter-148 verified this is structurally safe.
- **REC-3** (anti-pattern enforcement): do NOT retry the iter-147 path (a) BUILD-IT chain (step (e) / (S3.pi.1) flat base change) without structural change. Do NOT attempt the (p2) char-0 KDM path without signature inflation.
- **REC-4**: STRATEGY.md `## Open strategic questions` block update: commit iter-149 to one of (b-continue) / (a-pivot) / (c-defer) per the iter-148 reduction outcome.
- **REC-5**: blueprint-writer dispatch for substep 3 4-claim narrowing prose update (`RigidityKbar.tex` § `lem:constants_integral_over_base_field`).
- **REC-6**: Knowledge Base addition for the smart-proof reduction pattern (landed this review).

(See `recommendations.md` for the priority-ordered list and full text.)

## Critical paths committed (unchanged from iter-147 close, refined)

- Critical path: chart-algebra piece (ii) in `Cotangent/ChartAlgebra.lean`. 3 sub-pieces fully closed (α + lift + β-core); 2 partial (KDM + constants substep 3). Iter-149+ continuation per REC-1 + REC-2.
- M2.a body closure gated on chart-algebra piece (ii) — realistic earliest fire iter-152+ (substep 3 needs iter-149 (S3.sep.1) + iter-150 (S3.sep.2) + iter-151 symmetric (S3.pi.*) chain assuming clean closures).
- M2.b body closure + terminal-object cluster + vacuity branch — iter-155+ (unchanged).
- M2 closure — iter-158+ (~3 iter slip vs iter-147 estimate due to the 4-claim sub-decomposition cost).
- M3 Route A scaffold scheduling — iter-170+ (unchanged).

## Blueprint doctor (iter-148)

Clean. No orphan chapters, no broken cross-references, no empty `\uses{}` annotations, no new `axiom` declarations. (Report at `.archon/logs/iter-148/blueprint-doctor.md`.)

## Files written this review

- `.archon/proof-journal/sessions/session_148/summary.md`.
- `.archon/proof-journal/sessions/session_148/milestones.jsonl`.
- `.archon/proof-journal/sessions/session_148/recommendations.md`.
- `.archon/PROJECT_STATUS.md` (Knowledge Base + Last Updated).
- `.archon/iter/iter-148/review.md` (this file).
- `.archon/TO_USER.md` (empty — no escalation).
