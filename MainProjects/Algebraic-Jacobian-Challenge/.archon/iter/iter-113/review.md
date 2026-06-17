# Iter-113 (Archon canonical) — review

## Outcome at a glance

- **Single Phase B prover lane** on `AlgebraicJacobian/Differentials.lean` L177 helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type`, plus the iter-113 plan-phase 3-signature refactor lane already applied to L818 / L835 / L976–982 (which landed before the prover started).
- **Result**: **PARTIAL — Bar B variant (reformulation route)**. The prover pivoted from the plan's Sub-lemma A / Sub-lemma B decomposition to a unique-gluing reformulation: helper #1's body (now at L209) is fully closed via the Mathlib chain `isSheaf_of_isSheafUniqueGluing_types → IsSheaf.isSheafOpensLeCover`, and the residual mathematical content sits in a new top-level sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at L168 with sorry body and a concrete iter-114+ closure recipe in its docstring (universal property of `KaehlerDifferential` + structure-sheaf gluing + `span_range_derivation` uniqueness).
- **Sorry trajectory**: project total **16 → 16** (no closure; structural state change — helper #1 closes; sorry migrates from L177 to L175 in a new top-level helper). Per-file: `Differentials.lean` 5 → 5.
- **Compile-verified**: yes. `lean_diagnostic_messages severity=error` on `Differentials.lean` returns `[]`. Two pre-existing cosmetic deprecation warnings on `IsSmoothOfRelativeDimension` (L818, L835) carry from the plan-phase refactor.
- **No new axioms**; no protected signatures touched; `archon-protected.yaml` unchanged (9 protected declarations).
- **Named-gap roster**: unchanged. 7 named Mathlib gaps + 1 budget-deferral. The new sub-helper `_isSheafUniqueGluing_type` is **NOT** added to the named-gap roster — it is documented Bar-B-variant scaffolding pending iter-114+ closure (with a concrete recipe, not a Mathlib-gap deferral).

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **16**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at L1120 PAUSED, L1212 / L1536 / L1564 substep-deferred, L1754 gated on L1120, L1846 budget-deferred (all off-limits this iter).
  - `AlgebraicJacobian/Differentials.lean`: **5** at:
    - L175 (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type`; **iter-113 NEW** Bar-B-variant scaffolding helper; replaces the prior helper #1 sorry).
    - L798 (`cotangentExactSeq_structure case h_exact`; named gap #2, parallel to `instIsMonoidal_W`; off-limits).
    - L880 (`smooth_iff_locally_free_omega`; signature **corrected this iter** via plan-phase refactor — now `IsSmoothOfRelativeDimension n f ↔ ...`).
    - L897 (`cotangent_at_section`; signature corrected this iter via plan-phase refactor).
    - L1039 (`serre_duality_genus`; cohomology indices corrected this iter — now `H^0(Ω) = H^1(O)`; residual hypothesis-strength gap on `[IsIntegral]` vs "geometrically irreducible" + `Smooth` vs `IsSmoothOfRelativeDimension 1` flagged by iter-113 blueprint-checker, not blocking).
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (`instIsMonoidal_W`; Mathlib gap).
  - `AlgebraicJacobian/Picard/LineBundle.lean`: **2** at L82 / L96 (named Mathlib gap pair).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L181 (`representable`; gated on Phase C3).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`; Phase C3 exit policy).
- **Solved this iter**: **0**.
- **Partial this iter**: **1** — helper #1 body fully closed (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L209 now sorry-free); load-bearing residual exposed at L175 in a strictly mathematically-equivalent claim in cleaner form.
- **Blocked this iter**: none.
- **Untouched (deferred)**: 15.

## What the iter-113 plan got right

- **Re-verification of Mathlib names**: the plan agent re-verified 5 of the load-bearing names (`IsSmoothOfRelativeDimension`, `KaehlerDifferential.isLocalizedModule_map`, `IsAffineOpen.isLocalization_basicOpen`, `Scheme.isBasis_affineOpens`, `isSheaf_iff_isSheafOpensLeCover`) via `lean_leansearch` / `lean_loogle` this iter. All 5 held under the prover's `lean_local_search` checks during the session. The 1 gap flag (`IsGeometricallyIntegral` for schemes — not in Mathlib b80f227) was load-bearing for the iter-113 plan-agent's intentional decision NOT to upgrade `serre_duality_genus`'s `[IsIntegral C.left]` hypothesis to "geometrically irreducible" via refactor; the residual gap is correctly flagged by the iter-113 blueprint-checker as a hypothesis-strength issue for iter-114 to address.
- **Refactor-first sequencing**: the strategy-critic-iter113-retry CHALLENGE on Phase B signature defects (free `n : ℕ` on `Smooth`-iffs; `H^0 = H^0` on Serre duality) was addressed via the `refactor-differentials-signatures-iter113` lane in the plan phase, BEFORE the prover lane. This sequencing was correct: the iter-113 blueprint-checker confirms all three iter-112 must-fix findings are resolved by the refactor. No "fix the signatures *after* a failed prover attempt" cycle wasted.
- **Concrete Bar A / Bar B / Bar C spec**: the plan agent specified the success bar in terms of "did Sub-lemma A or Sub-lemma B close?", giving the prover and the review agent a clean operational target. The bar's strict reading does not credit the iter-113 reformulation as a Bar B closure (no sub-lemma closed), but the bar's *intent* (genuine structural advance, no helper explosion) is met — only ONE new top-level helper added, helper #1 closes.

## What didn't go as planned

- **Plan-vs-prover decomposition divergence**: the plan agent decomposed helper #1 closure into "Sub-lemma A (affine restriction to tilde sheaf identification, ~40–80 LOC) + Sub-lemma B (cofinality refinement against affine basis, ~50–100 LOC)". The prover executed neither; after a single failed scaffolding pass on Sub-lemma A (one type-error on `convert+rfl` for the `Opens.IsBasis` shape, immediately repaired by switching to direct form `Scheme.isBasis_affineOpens X` against `Opens.IsBasis X.affineOpens` — see Knowledge Base mini-pattern), the prover pivoted to the unique-gluing reformulation. The pivot is mathematically legitimate (verified by `lean-vs-blueprint-checker-differentials-iter113`: the chapter L53 disavowal of `IsSheafUniqueGluing` was about the OPPOSITE direction; the iter-113 use is the correct direction) and operationally cleaner (single `∃!` over compatible Kähler-differential families instead of categorical-cone limit machinery). But strictly: the iter-113 prover did **not** close any planned sub-lemma. The residual sorry sits in mathematically-equivalent form at L175 rather than at L209's old site.
- **Watch-flag tightening required**: the progress-critic-iter113 watch flag fired iff "TWO new sorry-bodied sub-helpers introduced without closure" — a literal helper-explosion failure mode. iter-113 added ONE new helper, so the literal trigger did not fire. But the underlying concern (no substantive new closure) is present. The iter-114 progress-critic dispatch needs to weigh "another reformulation without genuine closure" as functionally equivalent to two-new-sub-helpers. See `session_113/recommendations.md` § HIGH 1 for the tightened bar.

## Subagent dispatches this review phase

Two mandatory review subagents dispatched in parallel:

- **`lean-auditor-iter113`** — COMPLETE. Verdict: **clean iteration. 0 must-fix, 2 major, 5 minor, 0 excuse-comments.** Approves the iter-113 Bar B factoring as a "structurally sound reduction" of helper #1's content to a single existential. Two majors are structural debt (BasicOpenCech `letI` duplication; LineBundle sorry-bodied `noncomputable def`s — both pre-existing named-deferrals). Five minors are stale-status docstring refreshes and prune-after-closure candidates. Archived at `.archon/task_results/lean-auditor-iter113.md`.
- **`lean-vs-blueprint-checker-differentials-iter113`** — COMPLETE. Verdict: **0 must-fix-this-iter, 2 major, 4 minor.** All three iter-112 must-fix signature mismatches resolved. Two majors are blueprint-side adequacy gaps (route divergence — chapter Route (a) doesn't acknowledge the unique-gluing pivot; `serre_duality_genus` residual hypothesis-strength gap on `[IsIntegral]` and `Smooth`). Four minors are chapter-side cosmetic asks. Archived at `.archon/task_results/lean-vs-blueprint-checker-differentials-iter113.md`.

Both reports feed the `recommendations.md` HIGH-priority items 1 and 2.

## Verification (pre-handoff, iter-113 review pass)

| Check | Status |
|---|---|
| Sorry count per file | BasicOpenCech 6 / Differentials 5 / LineBundle 2 / Modules-Monoidal 1 / Picard.Functor 1 / Jacobian 1 = **16 total** |
| File compilation (`Differentials.lean`) | `lean_diagnostic_messages severity=error` → `[]`; 1 warning "declaration uses `sorry`" at L168 + 2 carryover `IsSmoothOfRelativeDimension` deprecation warnings at L818, L835 |
| `archon-protected.yaml` | unchanged (9 declarations) |
| New axioms | none |
| Review subagent dispatches | 2 mandatory completed: lean-auditor, lean-vs-blueprint-checker. Both clean (0 must-fix) |
| `\leanok` markers | Unchanged this review (deterministic `sync_leanok` ran before me; no manual touches per § Step 6 rules) |
| `\mathlibok` additions | none (no new Mathlib re-exports this iter) |
| `% NOTE:` annotations | none added or stripped this iter (iter-112 NOTEs at L183–188 / L209–212 / L233–240 remain — partially addressed by the iter-113 refactor but the chapter prose hasn't been updated; the iter-114 blueprint-writer dispatch for route (c) should also address the residual NOTE state) |
| `\lean{...}` renames | none flagged by prover or reviewers |
| `\notready` stripped | none (no `\notready` markers exist on iter-113-touched blocks) |
| Knowledge Base updated | yes — 2 new patterns added (unique-gluing reformulation route; `Opens.IsBasis X.affineOpens` direct form) |
| TO_USER.md | empty (no critical issues for the user) |
