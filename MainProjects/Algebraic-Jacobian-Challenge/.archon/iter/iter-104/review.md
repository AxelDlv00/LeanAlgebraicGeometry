# Iter-104 (Archon canonical) / iter-106 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** to close `cechCofaceMap_pi_smul` per-summand `hG` residual at L1147 (now L1179) via the iter-104 plan's "Route 1 then close" strategy.
- **Result**: **PARTIAL — 0 sorry closed, 1 new top-level lemma signature committed with body sorry, 5 new closure attempts on the L1179 trailing sorry — all failed**.
  - **Route 1 lemma** `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` added at L728–L751 (~24 LOC including docstring). Signature elaborates clean. Body has `rcases n with _ | n'; · omega; · have hPrev := by simp [...]; sorry`. Auxiliary hPrev computed but never used — **dead-end scaffold** (lean-auditor major finding).
  - **L1179 trailing sorry** unchanged: 5 attempts (`simp piIsoPi_hom_ker_subtype_apply`, `← ConcreteCategory.comp_apply (×4) + Preadditive.zsmul_comp` → whnf timeout at 1600000, `ModuleCat.hom_zsmul`/`hom_smul`/`hom_nsmul` not found, `set F_at_i := Pi.lift ...` discrim-tree blocked).
- **Sorry trajectory**: BasicOpenCech **6 → 7**. Project total **14 → 15**. Hard cap of 7 met at exactly the upper budget; iter-104 plan's "acceptable: 6" missed by 1. This is the **iter-104 plan's "fallback acceptable" outcome** (Route 1 lemma added, L1147 still sorry — bank infrastructure for iter-107).
- **Compile-verified**: yes (`lean_diagnostic_messages` returns `[]` for severity=error end-to-end). **Twelfth consecutive compile-verified prover iteration** (iter-092 through iter-106).
- **No new axioms; no protected signatures touched; iter-104/105 helpers (`cechCofaceMap_summand_family`, `cechCofaceMap_summand_family_R_linear`, `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`) preserved byte-for-byte; iter-105 L1179 partial proof scaffold preserved.**
- **STREAK STATUS**: 6 consecutive substantive lanes on the `cechCofaceMap_pi_smul` slot (iter-099/100/101/103/105/106); iter-104 was the different target L536. Iter-106 is the **first lane in the streak that added a sorry without closing one**. **Moderate streak-escalation triggered** — see recommendations.md.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **15**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **7** at
    - L751 (Route 1 lemma transient, NEW iter-106),
    - L1179 (cechCofaceMap_pi_smul trailing, shifted +32 from iter-105's L1147 due to Route 1 lemma insertion),
    - L1271 (substep (a) augmented Čech, deferred),
    - L1595 (ker assembly, deferred),
    - L1623 (substep (a) extra-degeneracy on s₀, deferred),
    - L1813 (g_R.map_smul', gated on L1179),
    - L1842 (h_loc_exact, deferred).
  - `AlgebraicJacobian/Differentials.lean`: **5** at L122, L636, L957, L974, L1116 (unchanged).
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (Mathlib upstream gap; off-limits).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`; Phase C step C3).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L190 (`PicardFunctor.representable`; gated on Phase C, and now flagged by lean-auditor as upstream of a critical-severity `LineBundle` admitted-wrong definition).
- **Solved this iter**: none.
- **Partial this iter**:
  - Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` (L732): signature commit, body sorry, dead-end `have hPrev` scaffold.
  - L1179 trailing sorry: 5 new attempts documented in `summary.md`; structural attempt chain identified (iter-099 S1-S3 still works, then attempts 3-5 hit either whnf timeout or discrim-tree blocker).
- **Blocked this iter**: none directly; the L1179 trailing sorry has two concrete iter-107 routes (R1 heartbeat-lift, R2 re-design) — see `recommendations.md`.
- **Untouched (deferred)**: 5 BasicOpenCech sorries (L1271/L1595/L1623/L1813/L1842) + 5 Differentials + 1 Monoidal + 1 Jacobian + 1 Picard.Functor — total 13 untouched (1 more than iter-105 because the Route 1 transient at L751 was added).

## What the iter-104 plan got right

- **Decision 1 was correct**: iter-105 produced 2 fully proved helpers + a clean L1147 partial-proof scaffold; the residual was identified as a precise morphism-level eqToHom-vs-Pi.π identification, and three concrete routes (Route 1, Route 3, refactor) were proposed by the iter-105 prover. Iter-104 plan-agent rightly avoided dispatching a refactor subagent (the wrapper engine is the right infrastructure) and rightly avoided dispatching a blueprint-writer this iter (deferred to iter-107 with the multi-finding batch).
- **Route 1 lemma signature elaborates clean**: the eqToHom-type-level metavariable resolution worked, and the lemma typechecks. The plan-agent's signature design (parameterising by `i : Fin (n+1)` with `Fin.cast hRel.symm i` inner index) was structurally sound; the elaboration cost was anticipated and addressed via explicit `hCod` argument.
- **Single-lane discipline** held; no expansion of scope.

## What the iter-104 plan got wrong / where the plan-agent could improve

- **Underestimated the Route 1 lemma's body difficulty**. The plan sketched the body as `Pi.hom_ext + Pi.lift_π_apply + Fin.cast roundtrip + rfl/eqToHom_naturality`, but the structural mismatch between **object equality** (`∏ᶜ Z_int = ∏ᶜ Z₂` from `Fin a = Fin b`) and Mathlib's **index equality** version of `Pi.π_comp_eqToHom` was not anticipated. The Mathlib gap is exposed by the lemma but not bridged by it.
- **The `rcases n with _ | n'` + `have hPrev` scaffold was the wrong direction**: hPrev does not propagate into `hCod`'s type-level Fin indices (the simp set cannot rewrite type-position Fin index occurrences). The Route 1 lemma's body shape should have been designed WITHOUT the `rcases` + hPrev approach in the first place — but this was the iter-106 prover's choice during execution, not the plan-agent's prescription. Plan-agent's fallback route (Route 3) was not explicitly tested by the prover.
- **Heartbeat budget not pre-emptively lifted on `cechCofaceMap_pi_smul`**. The iter-104 plan's primary route was Route 1; the fallback was Route 3 (`convert h_wrap_pt using N`). Neither anticipated that even with the Route 1 lemma signature committed, applying it at the call site would whnf-timeout at maxHeartbeats=1600000. **For iter-107, plan-agent should pre-emptively bump heartbeats** as the cheapest possible move (recommendations.md Priority 1 R1).

## What iter-106 discovered (deep)

### `Pi.π_comp_eqToHom` Mathlib gap (object-equality version is absent)

Mathlib exposes `Limits.Pi.π_comp_eqToHom : eqToHom (h : (i : ι) → Z₁ i = Z₂ i) ≫ Pi.π Z₂ j = Pi.π Z₁ j ≫ ...` for **per-index** equality. The `cechCofaceMap_pi_smul` blocker needs the **object-equality** case: an `eqToHom (h : ∏ᶜ Z₁ = ∏ᶜ Z₂)` arising from `Fin a = Fin b` index-type equality, NOT from per-index object equality. The two cases are structurally distinct; no Mathlib lemma covers the object-equality case directly. **Project-local helper is required** (and is what Route 1 was supposed to be), but the helper's body is the iter-106 blocker.

### Preadditive.zsmul_comp whnf-cascade at maxHeartbeats=1600000

After the iter-099 S1-S3 chain fuses `(Pi.π Z₂ j').hom (eqToHom_hom (smul_thing.hom (e₁.symm _)))` into a single categorical morphism `((-1)^↑i • F_at_i) ≫ eqToHom_outer ≫ Pi.π Z₂ j'`, the subsequent `rw [Preadditive.zsmul_comp]` to extract `(-1)^↑i •` triggers a whnf cascade that exceeds 1600000 heartbeats. This is the same root-cause class as iter-099 (pre-funext) and iter-101 (post-funext literal `show`). The discrim-tree match through `Pi.lift fun i_1 ↦ <body referencing i_1>` is the underlying culprit. **Mitigation candidates**:
1. Bump heartbeats to 3200000-6400000 (cheapest; precedent in iter-087's 800000 → 1600000 bump).
2. Re-design the Pi.lift source to avoid the anonymous-closure body (R2 in recommendations.md).
3. Manually `set f := Pi.lift fun i_1 ↦ ... with hf` plus `show` def-eq to force a particular elaboration path — but iter-099/iter-106 confirmed this doesn't reliably help.

### Wrapper R-linearity is the right structural infrastructure

The iter-105 wrapper helpers + L1147 partial proof are **not at fault** for the L1179 blocker. The bottleneck is the morphism-level F_at_i-vs-wrapper identification, which Route 1 was supposed to bridge. With Route 1 in place + a heartbeat bump (R1) OR a Route 1 redesign (R2), the wrapper invocation closes cleanly.

### Streak-escalation moderate trigger

This is the first lane in the 6-iter streak that ADDED a sorry without closing one. The plan-agent's iter-107 decisions need to balance:
- Cheap retry (R1 heartbeat bump) — justified for ONE more substantive lane.
- Re-design (R2) — justified if R1 fails after 1-2 attempts.
- Pivot to other targets (5 deferred BasicOpenCech sorries + 5 Differentials) — justified only if R1 AND R2 both fail (i.e., iter-108 earliest).

## Files modified this iter (verified via diff)

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`:
  - **Added L728–L751**: `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` Route 1 lemma signature + dead-end body scaffold.
  - **Modified L1144–L1178** (inside `cechCofaceMap_pi_smul`): iter-106 attempt notes appended to the comment block; iter-107 plan-agent re-route guidance for the heartbeat-lift recommended.
  - **Unchanged otherwise**: iter-104/105 closures preserved byte-for-byte (`cechCofaceMap_summand_family` L454–L477, `cechCofaceMap_summand_family_R_linear` L494–L595, `cechCofaceMap_summand_family'` L604–L629, `cechCofaceMap_summand_family'_R_linear` L634–L726, iter-105 L1147 partial proof scaffold now at L1112–L1178).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` final line count: 1820 (was 1788 at iter-105 close; +32 from Route 1 lemma insertion).
- No other `.lean` files modified.

## Compile + sorry verification (iter-104 close)

- `lean_diagnostic_messages` severity=error on whole file: `[]`.
- `grep -cE "^[[:space:]]*sorry[[:space:]]*$|[[:space:]]sorry$|sorry$" BasicOpenCech.lean`: 7 tactic-position sorries (verified at L751, L1179, L1271, L1595, L1623, L1813, L1842).
- No new axioms (`grep -nE "^axiom\b" BasicOpenCech.lean`: empty).
- Protected signatures `archon-protected.yaml`: unchanged.

## Subagents dispatched

- `lean-auditor` (slug `iter104`, MANDATORY): full report at `.archon/task_results/lean-auditor-iter104.md` (archived also at `.archon/logs/iter-104/lean-auditor-iter104-report.md`). 15 files audited, 12 issues (critical/major/minor: 1/7/4). Findings incorporated into `summary.md` § "Audit findings" and `recommendations.md` § CRITICAL/HIGH/MEDIUM/LOW.

## TO_USER status

No new alerts. The `Picard/LineBundle.lean:85` critical audit finding is RECORDED in recommendations.md as a strategic decision pending; it does NOT require user intervention this iter (the wrongness is currently contained — no `theorem`/`lemma` downstream proves a quantitative result against the approximation). If the project advances to Phase C step 2 (closing `PicardFunctor.representable`), this becomes blocking and would warrant a `TO_USER.md` alert at that time.
