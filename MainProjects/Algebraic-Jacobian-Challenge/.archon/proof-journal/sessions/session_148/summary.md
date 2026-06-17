# Session 148 — Review Summary

## Session metadata

- **Session number**: 148 (= iter-148).
- **Stage**: prover (lane fired).
- **Duration**: prover ~24.4 min (`durationSecs: 1465`); plan ~47.3 min.
- **Files touched** (per `attempts_raw.jsonl` summary): 1 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (5 edits / 3 goal checks / 4 diagnostic checks / 0 lemma searches / 0 builds via LSP; `lake build` invoked twice via Bash, both clean).
- **Sorry count before / after**: 5 declarations + 5 inline sorries → **5 declarations + 5 inline sorries** (NET 0 strict-count delta). Per-file unchanged: `Cotangent/ChartAlgebra.lean` 2/2; `Jacobian.lean` 2/2; `RigidityKbar.lean` 1/1.
- **Targets attempted** (per `PROGRESS.md` § "Iter-148 prover lane"):
  - `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (KDM forward inclusion) at L139 (iter-147 close).
  - `constants_integral_over_base_field` (substep 3) at L294 (iter-147 close).

## Per-target attempts (from `attempts_raw.jsonl`)

### Target 1 — `constants_integral_over_base_field` (substep 3)

**Outcome: PARTIAL (structural advance, sorry concentrated at named conjunction)**

Substep (3) before iter-148: `Function.Surjective ((X ↘ Spec(.of k)).appTop.hom)` with a residual `sorry` at the chain exit and a 7-step closure chain (a)–(g) documented as in-source comments; the substantive Mathlib gap was step (e) ("flat base change of Γ for proper schemes"; Stacks 02KH; ~250–500 LOC ad-hoc per `analogies/step-e-iter148.md`).

#### Attempt 1 — Smart-proof path (b) structural reduction (per `PROGRESS.md` iter-148 commitment)

- **Approach**: bypass step (e) entirely. Reduce surjectivity of `appTop.hom` to the conjunction `IsPurelyInseparable k Γ(X, ⊤) ∧ Algebra.IsSeparable k Γ(X, ⊤)` and discharge via Mathlib `IsPurelyInseparable.surjective_algebraMap_of_isSeparable` (`Mathlib/FieldTheory/PurelyInseparable/Basic.lean:158`).

- **Code landed** (sorry-free framework, L307–L371):
  ```lean
  rw [RingHom.range_eq_top]
  letI _hΓfield' : Field ↥(X.presheaf.obj (Opposite.op ⊤)) := _hΓfield.toField
  set α : (.of k) ⟶ X.presheaf.obj (Opposite.op ⊤) :=
    (Scheme.ΓSpecIso (.of k)).inv ≫ (X ↘ Spec (.of k)).appTop with hαdef
  letI algkΓ : Algebra k ↥(X.presheaf.obj (Opposite.op ⊤)) := α.hom.toAlgebra
  have h_algebraMap_eq : (algebraMap k _) = α.hom := rfl
  suffices h_surj : Function.Surjective (algebraMap k _) by
    intro y; obtain ⟨c, hc⟩ := h_surj y
    refine ⟨(Scheme.ΓSpecIso (.of k)).inv.hom c, ?_⟩
    have hcomp : (((X ↘ Spec(.of k)).appTop.hom)).comp
        ((Scheme.ΓSpecIso (.of k)).inv.hom) = α.hom := by
      simp [hαdef, CommRingCat.hom_comp]
    have hcompc := congrArg (fun (f : k →+* _) => f c) hcomp
    simp only [RingHom.comp_apply] at hcompc
    rw [hcompc]
    have hac : α.hom c = (algebraMap k _) c := by rw [h_algebraMap_eq]
    rw [hac]; exact hc
  have ⟨hPI, hSep⟩ :
      IsPurelyInseparable k _ ∧ Algebra.IsSeparable k _ := by sorry
  haveI := hPI; haveI := hSep
  exact IsPurelyInseparable.surjective_algebraMap_of_isSeparable k _
  ```

- **Initial lean_error**: `Unknown identifier 'ΓSpecIso'` at L285/296/300 (3 sites). Fixed by fully-qualifying to `Scheme.ΓSpecIso` (Mathlib `Mathlib/AlgebraicGeometry/Scheme.lean:606`); verified by re-running `lean_diagnostic_messages` → 0 errors, 1 warning `declaration uses sorry` at L220.

- **Final diagnostic** (after fix): `lake build AlgebraicJacobian.Cotangent.ChartAlgebra` clean (8325/8325 replayed); `lean_verify` axioms = `{propext, sorryAx, Classical.choice, Quot.sound}` (kernel + `sorryAx` from L367).

- **Result**: PARTIAL — structural reduction lands sorry-free; single residual `sorry` at L367 concentrated on the conjunction. The 4 named sub-claims:
  - **(S3.pi.1)** `Γ(X_{\bar k}, ⊤) ≅ Γ(X, ⊤) ⊗_k \bar k` — flat base change of Γ for proper schemes (the prior step-(e) Mathlib gap, ~250–500 LOC).
  - **(S3.pi.2)** finite-dim k-algebra with `_ ⊗_k \bar k` having unique minimal prime ⇒ source is purely inseparable (assemblable from Mathlib's `IsPurelyInseparable.of_*` family once (S3.pi.1) lands).
  - **(S3.sep.1)** `Smooth ⇒ Algebra.IsGeometricallyReduced k Γ` — no Mathlib b80f227 instance (verified via full Mathlib grep; `Mathlib/RingTheory/Smooth/*` and `Mathlib/RingTheory/Nilpotent/GeometricallyReduced.lean` have no smooth-related lemmas).
  - **(S3.sep.2)** `geom-reduced finite field ext ⇒ separable` — assemblable via Mathlib's `IsSeparable` infrastructure once (S3.sep.1) bridge lands.

- **Insight**: the iter-148 smart-proof path (b) does **not** eliminate the substantive Mathlib gap; it relocates and narrows it. The gap is now factored into 4 named sub-claims (2 per side of the `IsPurelyInseparable ∧ Algebra.IsSeparable` conjunction) rather than concentrated at the single step-(e) "flat base change of Γ for proper schemes" framing. The (S3.pi.1) sub-claim is genuinely the same Mathlib gap as the iter-147 step (e); the iter-148 reduction's net structural advance is that (S3.sep.1) is now a named bridge claim — and the iter-148 prover lane's full Mathlib grep delivers the answer "no such instance in b80f227" with high confidence, giving iter-149+ a clean route-pivot choice rather than the iter-147 "one big gap, unclear path forward" framing.

#### Attempt 2 — Build verification

`lake build AlgebraicJacobian.Cotangent.ChartAlgebra` produced `8325/8325 Replayed` clean; the only sorry warnings are the in-scope L168 + L367 (`ChartAlgebra.lean`) + 2 in `Jacobian.lean` + 1 in `RigidityKbar.lean`.

### Target 2 — `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (KDM forward inclusion)

**Outcome: PARTIAL (in-source docstring refresh; no new code)**

#### Attempt 1 — (p2) char-0 path via `Differential.ContainConstants`

- **Approach** (per blueprint `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`'s primary (p2) path): build a bridge from the universal Kähler derivation `D : B → Ω_{B/k}` to a `Differential B` instance with `ContainConstants k B`.

- **Sub-gap inventory committed in-source** at L137–168:
  - **(BR.1)** `Algebra.IsStandardSmooth k B` chart hypothesis on `B` (not in current signature; would need adding `[Algebra.IsStandardSmoothOfRelativeDimension k B]`).
  - **(BR.2)** Basis selection `{dx_1, .., dx_n}` of `Ω_{B/k}` via `Algebra.IsStandardSmooth.free_kaehlerDifferential` (`Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:300`; verified Mathlib b80f227).
  - **(BR.3)** Coefficient-derivation extraction `∂_i : B → B` from basis (no off-the-shelf Mathlib lemma; ~30–50 LOC).
  - **(BR.4)** `Differential B` instance per `∂_i` (`Derivation ℤ B B`; the `∂_i` is k-linear hence ℤ-linear) — assemblable via `RingTheory.Derivation.Basic` once (BR.3) lands.
  - **(BR.5)** `Differential.ContainConstants k B` instance for the chosen `∂_i` in `CharZero k` — Mathlib has the class (`Mathlib/RingTheory/Derivation/DifferentialRing.lean:62`) but **no** instance for the standard-smooth case. The single Mathlib consumer (`IsLiouville.trans` at `Mathlib/FieldTheory/Differential/Liouville.lean:56`) uses the class only on Liouville fields (`F → K` with `K/F` essentially-finite).

- **Result**: PARTIAL — sorry preserved at L168 (no code change); in-source documentation now lists the (BR.1)–(BR.5) sub-gap inventory and the iter-149+ continuation path.

- **Lean errors / negative results**:
  - The lemma as stated is FALSE without additional hypotheses (char p > 0 with `B = k[X]`, `b = X^p` has `D b = 0` but `b ∉ range`). The blueprint's blueprint-mandated signature commits to `[Algebra.FiniteType k B]` only; the iter-149+ closure must either inflate the signature with `[CharZero k] + [Algebra.IsStandardSmoothOfRelativeDimension k B]` and land the (BR.1)–(BR.5) bridge body (~80–150 LOC), or commit to the (p1) char-p Cartier chain (~140–230 LOC).
  - β-core consumer `df_zero_factors_through_constant_on_chart` (L196) delegates to this KDM lemma. Signature inflation on KDM propagates to β-core, but β-core has no in-tree consumer beyond `Scheme.Over.ext_of_diff_zero` at L402 (which delegates directly to `Scheme.Over.ext_of_eqOnOpen` of `AlgebraicJacobian/Rigidity.lean` without going through β-core). Therefore an iter-149+ signature refactor on KDM + β-core is structurally safe.

- **Insight**: the iter-148 prover lane invested significantly in Mathlib reconnaissance on this target (large number of grep+read events on `Mathlib/RingTheory/Derivation/`, `Mathlib/RingTheory/Kaehler/`, `Mathlib/RingTheory/Smooth/`, `Mathlib/RingTheory/Unramified/`, `Mathlib/AlgebraicGeometry/Geometrically/`, etc.) before concluding the (p2) char-0 path requires a Mathlib-PR-grade bridge rather than a thin in-tree wrapper. The reconnaissance results are codified in the L137–168 docstring; iter-149+ should not re-do this lemma-search work.

## Key findings / patterns discovered

1. **`IsPurelyInseparable.surjective_algebraMap_of_isSeparable` as the natural `algebraMap k Γ` surjectivity closer** when `Γ/k` is known to be both purely inseparable and separable. Mathlib idiom: `Mathlib/FieldTheory/PurelyInseparable/Basic.lean:158`. Reusable any time a finite field extension is shown to be both PI and separable.

2. **`Scheme.ΓSpecIso (.of k)).inv` as the canonical `(.of k) ⟶ Γ(Spec(.of k), ⊤)` arrow** for promoting a CommRingCat morphism `X.appTop : Γ(Spec k, ⊤) ⟶ Γ(X, ⊤)` to a `k → Γ(X, ⊤)` algebra map. The fully-qualified `Scheme.ΓSpecIso` (NOT bare `ΓSpecIso`) is the correct identifier (Mathlib `Mathlib/AlgebraicGeometry/Scheme.lean:606`).

3. **Mathlib b80f227 `Differential.ContainConstants` typeclass is positioned for `Differential B` instances on specific derivations `B → B`, NOT for the universal Kähler derivation `D : B → Ω_{B/k}`**. The bridge requires a basis selection of `Ω_{B/k}` (only available in the standard-smooth case via `Algebra.IsStandardSmooth.free_kaehlerDifferential`) and per-basis coefficient-derivation extraction. The only Mathlib consumer of the class (`IsLiouville.trans`) is over Liouville fields, not standard-smooth k-algebras. **Iter-149+ should not retry the (p2) char-0 path without signature inflation**.

4. **Mathlib b80f227 lacks `Smooth ⇒ Algebra.IsGeometricallyReduced` for finite-type k-algebras**. Verified via full Mathlib grep across `Mathlib/RingTheory/Smooth/*` and `Mathlib/RingTheory/Nilpotent/GeometricallyReduced.lean`. The (S3.sep.1) sub-claim of the iter-148 smart-proof reduction is therefore a Mathlib gap, not an in-tree thin wrapper.

5. **Mathlib b80f227 lacks proper-Γ-flat-base-change**. Verified iter-148 plan-phase by `mathlib-analogist-step-e-iter148` (persistent file `analogies/step-e-iter148.md`). The (S3.pi.1) sub-claim is the same Mathlib gap as the iter-147 step (e), confirmed by 2 independent reconnaissance dispatches.

## Recommendations for the next session

See `recommendations.md` for the full priority-ordered list. Headline:
- **Iter-149 escalation hook fires.** Per iter-148 plan `## Decision 3`: "iter-149 escalation trigger fires iff iter-148's prover lane closes NEITHER sorry AND the substep 3 residual gap is STILL framed as flat base change of Γ for proper schemes with no further narrowing." Iter-148 closed neither sorry but **did** narrow the substep 3 gap (4-claim sub-decomposition; named (S3.pi.1)/(S3.sep.1) Mathlib bridges). Per the planner's "acceptable narrowing examples" carve-out — "A reduction to a different lemma family (including the path (b) smart-proof gap 'Γ of smooth ⇒ Γ separable')" matches verbatim — the iter-149 escalation is partially satisfied; the iter-149 progress-critic should read this iter as CONVERGING-with-Mathlib-gap-pivot, not STUCK.

## Subagent reports

- **`task_results/AlgebraicJacobian_Cotangent_ChartAlgebra.lean.md`** — prover task result.
- **`task_results/lean-auditor-iter148.md`** — mandatory whole-project audit (this review). Severity: 6 must-fix-this-iter + 5 major + 3 minor + 0 excuse-comments. Headline: **`mem_range_algebraMap_of_D_eq_zero` ships a signature whose conclusion is mathematically false under the stated hypotheses** (the in-source docstring at L117–119 openly admits the char-p counter-example); the auditor escalates this to must-fix despite the planner's substantive-content gating. Other must-fix items are documented load-bearing sorries elsewhere; major items are 4 stale section-framing blocks in `Cotangent/GrpObj.lean` referring to iter-145-excised declarations + 1 dead-code computation in `Jacobian.lean:102-128` `IsAlbanese.unique`.
- **`task_results/lean-vs-blueprint-checker-chartalgebra-iter148.md`** — mandatory bidirectional checker on the prover-touched file (this review). Severity: 1 must-fix-this-iter + 2 major + 1 minor. Headline: **`df_zero_factors_through_constant_on_chart` is a structurally weaker stand-in** for the blueprint's named theorem (Lean is a thin KDM wrapper under decorative chart-of-proper-curve typeclasses; blueprint prose describes the full five-step per-chart $f^{\sharp}$ helper). One side of this must-fix landed this review via the iter-148 `% NOTE:` block on `RigidityKbar.tex`; the Lean-side fix is queued REC-3-bis in `recommendations.md`. The blueprint adequacy of `constants_integral_over_base_field` (silent on path (b)) also landed via a parallel `% NOTE:` block this review.

(See `recommendations.md` for landed findings, priority order, and the iter-149 escalation discussion.)

## Blueprint markers updated (manual)

Two `% NOTE: (iter-148 review)` annotations landed in `blueprint/src/chapters/RigidityKbar.tex` in response to the `lean-vs-blueprint-checker-chartalgebra-iter148` must-fix-this-iter findings:

- `RigidityKbar.tex` § `lem:chart_algebra_df_zero_factors_through_constant_on_chart` (statement block): added a `% NOTE: (iter-148 review)` block authorising the iter-148 thin-wrapper disposition (Lean drops `(A, f, W, V, B, R, f^♯, df = 0)` chart-pair data and keeps only `(k, C-typeclasses, B, b, hDb)`). Documents that the four `C`-side typeclasses are decorative under the current commitment and pins the iter-149+ substantive-refinement plan.
- `RigidityKbar.tex` § `lem:constants_integral_over_base_field` (proof block, just after `\leanok`): added a `% NOTE: (iter-148 review)` block documenting the iter-148 prover-lane commitment to path (b) SMART PROOF (bypassing step (e) via `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`) and pinning the four (S3.pi.1) / (S3.pi.2) / (S3.sep.1) / (S3.sep.2) named sub-claims. The 7-step chain (a)–(g) below remains as the informational alternative.

No `\leanok` touched (deterministic sync's domain). No `\mathlibok` added (closest candidate `algebra_isPushout_of_affine_product` is `inferInstance`, not `:= Mathlib.bar`). No `\lean{...}` corrections (no renames in the prover lane). No stale `\notready` to strip on the prover-touched declarations.

## TO_USER.md

Empty (no user escalation; no `planValidate.status: ok_intentional_skip`; the iter-148 plan agent did NOT signal an escalation).

## Files written this review

- `.archon/proof-journal/sessions/session_148/summary.md` (this file).
- `.archon/proof-journal/sessions/session_148/milestones.jsonl`.
- `.archon/proof-journal/sessions/session_148/recommendations.md`.
- `.archon/PROJECT_STATUS.md` (Knowledge Base + Last Updated).
- `.archon/iter/iter-148/review.md`.
- `.archon/TO_USER.md` (empty).
