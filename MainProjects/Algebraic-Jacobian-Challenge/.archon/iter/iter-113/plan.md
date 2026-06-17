# Iter-113 (Archon canonical) plan-agent run

## Headline outcome

**Refactor lane absorbed in plan phase + single Phase B prover lane on helper #1 closure**. 4 subagent dispatches: 3 mandatory critics (strategy-critic required a retry due to a mid-run socket error on the first attempt; the retry slug is `iter113-retry`) + 1 refactor (`differentials-signatures-iter113`). Strategy-critic-iter113-retry CHALLENGE on Phase B orphan-signature defects (free `n : ℕ` on `Smooth f`-iffs; `H^0 = H^0` for Serre duality) **resolved THIS iter** via the refactor — Soundness rule no longer violated. Iter-114 prover lane is on closing helper #1 (Bar A) or splitting it into Sub-lemmas A + B with ≥1 fully closed (Bar B).

Project sorry count entering iter-113: 16. Post-plan-phase: 16 (refactor changed statements but not counts). Target post-iter-113 prover phase: **15** (Bar A: helper #1 closes) or **16** (Bar B: structural advance with ≥1 sub-lemma closed).

## What I consumed

- `task_results/AlgebraicJacobian_Differentials.lean.md` — iter-112 prover report (PARTIAL Bar B; helper #1 introduced at L159 with sorry-bodied content; helper #2 at L188 fully closed; main body at L220 fully closed). Archived to `logs/iter-113/prover-iter112-differentials-report.md` and cleared from `task_results/`.
- `task_results/lean-auditor-iter112.md` + `task_results/lean-vs-blueprint-checker-differentials-iter112.md` — iter-112 review-phase subagent reports left in `task_results/` (not cleared during iter-112 review). Archived to `logs/iter-112/` and cleared.
- `USER_HINTS.md` — empty; left empty.
- `STRATEGY.md` — read for the 7+1 named-gap roster + scope rationale. Unchanged this iter (strategy-critic-iter113-retry confirmed the iter-112 scheduling-rationale edits remain SOUND; only the Phase B signatures themselves needed correction).
- `PROGRESS.md` — read for iter-112 outcome; rewritten for iter-113.
- `task_pending.md` / `task_done.md` — read for sorry inventory + protected status. `task_pending.md` updated with iter-113 active target (L177 helper #1) and refactor-resolved signatures (L823, L840, L982). `task_done.md` unchanged (no closures; the refactor changed statements but did not close any sorry).
- `archon-protected.yaml` — unchanged. 9 protected declarations.
- Iter-110 / iter-111 / iter-112 (Archon canonical) sidecars from injected context window.

## Independent verification (pre-action and post-refactor)

Pre-action:

- `sorry_analyzer.py AlgebraicJacobian/ --format=summary` → 16 total across 6 files (BasicOpenCech 6, Differentials 5, LineBundle 2, Jacobian 1, Modules-Monoidal 1, Picard-Functor 1). Matches iter-112 end-state.
- `lean_diagnostic_messages` severity=error on `Differentials.lean` → `[]`.
- `archon-protected.yaml` — unchanged (9 protected declarations).
- `grep -rn '^axiom\b' AlgebraicJacobian/` → only matches inside comments. No real axioms.

Post-refactor (after the `differentials-signatures-iter113` dispatch landed):

- `sorry_analyzer.py AlgebraicJacobian/ --format=summary` → 16 total, distribution unchanged.
- `lean_diagnostic_messages` severity=error on `Differentials.lean` → `[]`. Two deprecation warnings on L818 / L835 (`IsSmoothOfRelativeDimension` deprecated for `SmoothOfRelativeDimension`); cosmetic-only, no behavioural impact.
- Sorry sites in `Differentials.lean` post-refactor: L177 (helper #1, NEW iter-112), L622 (`h_exact`, off-limits), L823 (smooth_iff, signature corrected; off-limits), L840 (cotangent_at_section, signature corrected; off-limits), L982 (serre_duality_genus, signature corrected; off-limits). File total: 5.

## Iter-112 outcome assessment

**PARTIAL Bar B (as iter-112 plan agent intended)** — Route (a) chosen explicitly; ≥2 named helpers instantiated; main theorem body fully closed; residual sorry isolated in helper #1. Compile-verified throughout. The iter-112 reviewer also surfaced 3 pre-existing must-fix signature mismatches (smooth_iff_locally_free_omega, cotangent_at_section, serre_duality_genus) that were latent in the Lean file; the strategy-critic-iter113-retry CHALLENGE formalized these as Soundness rule violations.

The iter-113 response to both threads:

1. **Helper #1 path forward**: dispatch a prover lane on closing helper #1 via Sub-lemmas A (affine identification) + B (cofinality refinement). Concrete success bar (Bar A / Bar B / Bar C) defined for progress-critic-iter114 to measure against.
2. **Signature mismatch resolution**: dispatch a refactor lane in plan phase, before the prover lane. The refactor lands the 3 signature corrections per the blueprint prose; no new sorries; no downstream breakage.

Both threads addressed cleanly in iter-113.

## Mandatory subagent dispatches

Three mandatory per the canonical plan-phase ordering.

### blueprint-reviewer (slug `iter113`)

**Verdict**: **GREEN for the iter-113 prover lane (helper #1) and for the 3-signature refactor lane**. 13 chapters audited; all `complete: true × correct: true`; 0 must-fix findings.

Per-chapter highlights:

- `Differentials.tex`: `complete: true × correct: true`. Step 2 + Step 3 prose for `\thm:relative_kaehler_isSheaf` is adequate to drive helper #1 closure: Sub-lemma A inputs (`KaehlerDifferential.isLocalizedModule_map`, `IsAffineOpen.isLocalization_basicOpen`, `tilde`, `tensorKaehlerEquivOfFormallyEtale`, `FormallyEtale.of_isLocalization`) and Sub-lemma B inputs (`isSheaf_iff_isSheafOpensLeCover`, `isBasis_affineOpens`, `isSheaf_iff_isSheafPairwiseIntersections`, `isSheaf_iff_isSheafEqualizerProducts`) all named `[verified]`. The basis-to-opens descent honestly disclosed as `[gap]` (not a Mathlib gap; expensive prover-side sub-lemma work). The three iter-112 `% NOTE:` annotations (signature mismatches at L183–188 / L209–212 / L233–240) are well-placed and adequate to drive the iter-113 refactor.
- 12 other chapters: clean. The iter-112 must-fix on `Cohomology_MayerVietoris.tex:1198` (gap-list count 6 → 7 + `serre_duality_genus`) is **verified landed**.
- 6 soon-severity items (line-number staleness across MV/Picard_Functor chapters, one broken `\ref{}` in MV L917, one stale `% NOTE:` in `Picard_Functor.tex:10`) — non-blocking; queued for an iter-114 blueprint-writer cleanup round alongside the `% NOTE:` removals from `Differentials.tex` (now that the refactor has landed, the iter-112 NOTE annotations describe a resolved issue and can be removed).

Archived to `logs/iter-113/blueprint-reviewer-iter113-report.md`.

### progress-critic (slug `iter113`)

**Verdict**: **UNCLEAR (trending CONVERGING)** on helper #1 route; **UNCLEAR (fresh)** on refactor route. No CHURNING/STUCK verdicts.

Key signals:

- Helper #1 route has only 1 prover round of data (iter-112 PARTIAL Bar B). The iter-112 sorry "migration" (L122 → helper #1 at L177) is structural advance, not churn. Recurring blockers ("basis-to-opens descent", "no off-the-shelf sheaf-on-affine-basis ⇒ sheaf lemma") appear in only 2 iters (below the 3-iter STUCK threshold), and the planner translated them into a concrete two-sub-lemma decomposition with named Mathlib hooks rather than re-circling.
- Refactor route is fresh; convergence verdict doesn't apply directly. Sound on disjoint-write grounds (helper #1 at L177 vs. refactored signatures at L816 / L832 / L976 — disjoint declaration ranges; sequenced plan-phase → prover-phase has no overlap).
- **Watch flag for iter-114**: if iter-113's prover round returns PARTIAL again with two new sorry-bodied sub-helpers (no closure of either Sub-lemma A or Sub-lemma B), this flips helper #1 to CHURNING. Corrective then = `mathlib-analogist` on the affine-basis-to-Opens descent (the recurring-blocker phrase will cross the 3-iter threshold). The plan-agent should re-dispatch `progress-critic` next iter and act on its verdict.

Archived to `logs/iter-113/progress-critic-iter113-report.md`.

### strategy-critic (slug `iter113-retry`; first attempt failed)

**First attempt** (slug `iter113`) — failed mid-run with `API Error: The socket connection was closed unexpectedly` after 5.9 min ($2.08 / 13.4k output tokens). No report written to disk.

**Retry** (slug `iter113-retry`) — completed in 4.6 min ($1.46 / 18.7k output tokens). **CHALLENGE — 2 of 5 routes CHALLENGE**.

Per-route verdicts:

- Phase A: SOUND.
- Phase B: **CHALLENGE** — orphan-disclosure named gaps L718 (`smooth_iff_locally_free_omega`), L735 (`cotangent_at_section`), L877 (`serre_duality_genus`) carry mathematically-false signatures. Free `(n : ℕ)` on iffs with rank-independent `Smooth f` makes the iff false for wrong `n`; `H^0 = H^0` for Serre duality is false for genus > 1 curves. The Soundness rule explicitly forbids `sorry`-bodied theorems with mathematically wrong signatures; the strategy's framing as "honest named-deferred gaps" masks a violation of the project's own Soundness rule.
- Phase C0: SOUND.
- Phase C1: SOUND.
- Phase C3: SOUND.

The critic offered three options for must-fix:

- (a) Fix the false signatures (re-state L718/L735 with `IsSmoothOfRelativeDimension n` instead of free `n`; re-state L877 as `H^1(O_C) = H^0(Ω)`).
- (b) Delete the orphan signatures and downgrade the named-gap count from 7 to 4.
- (c) Explicit rebuttal in `iter/iter-113/plan.md` arguing why the signature defects do not violate the Soundness rule.

**Response THIS iter**: option (a) executed via the `refactor-differentials-signatures-iter113` dispatch (see below). No `iter/iter-113/plan.md` rebuttal needed — the refactor IS the response.

The critic also flagged one **sunk-cost reasoning** in STRATEGY.md L24 ("we'd erase the iter-109 C1 promotion's correct sheaf-theoretic LineBundle work"). This is informational, not must-fix. The proper rationale for retaining Phase B is the *forward value* (blueprint-completeness commitment on cotangent sheaves), not preservation of past investment. I'm leaving STRATEGY.md unchanged for now because the iter-112 scope-rationale paragraph DOES name the forward-value framing as the primary justification — the "would erase iter-109's work" line is a secondary point. A future iter may tighten the wording if the critic re-flags.

Two alternative routes raised:

- **Fix-signatures-first sub-phase** (critical) — what this iter executed. The cost (~50–100 LOC of re-statement + zero downstream consumers) is exactly what the refactor delivered.
- **Trim orphan-signature blueprint commitments** (major) — delete L877 / L718 / L735 from the Lean and the blueprint. Considered and rejected: the blueprint's "blueprint-completeness commitment" framing is forward-valuable (a downstream consumer should see the cotangent-side material formalized at the signature level even if bodies are sorry-deferred), and the signatures are now correct post-refactor.
- **Helper #1 via `SheafOfModules.IsQuasicoherent`** (minor) — partially considered already in STRATEGY.md as Route (b); the chapter documents both Route (a) refinement-cofinality and Route (b) explicit affine-cover gluing. The chapter pins Route (a) as the Lean route per the iter-112 Bar-B scaffolding. The critic's suggestion to "commit to Route (b) upfront" is reasonable but I'm sticking with Route (a) because the iter-112 helper structure already enacts it; switching to Route (b) would require re-doing the iter-112 Bar-B work.

Archived to `logs/iter-113/strategy-critic-iter113-retry-report.md`.

## Refactor dispatch (slug `differentials-signatures-iter113`)

**Status**: COMPLETE.

**Changes**: 3 signature edits in `AlgebraicJacobian/Differentials.lean`:

1. **L818** (`smooth_iff_locally_free_omega`): LHS `Smooth f` → `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`. The biconditional now reads "smooth of relative dimension n ↔ Ω locally free of rank n", which is structurally satisfiable for any specific `n`.
2. **L835** (`cotangent_at_section`): hypothesis `(hsmooth : Smooth f)` → `(hsmooth : AlgebraicGeometry.IsSmoothOfRelativeDimension n f)`. The dimension parameter is now pinned by the hypothesis.
3. **L976–982** (`serre_duality_genus`): swap LHS↔RHS, change RHS index `0 → 1`. Final equation: `Module.rank k (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) = Module.rank k (HModule k (toModuleKSheaf C) 1)`. This is now `dim H^0(Ω_{C/k}) = dim H^1(O_C)`, the actual Serre duality genus equation.

**Verification**:

- `lean_diagnostic_messages severity=error` → `[]`.
- Sorry count in `Differentials.lean`: 5 (unchanged).
- Project total: 16 (unchanged).
- No downstream consumers; no cascading edits.

**Cosmetic follow-up noted by refactor agent**:

`AlgebraicGeometry.IsSmoothOfRelativeDimension` is `@[deprecated]` in favor of `AlgebraicGeometry.SmoothOfRelativeDimension` (no `Is` prefix). Two deprecation warnings on L818 / L835. The refactor used `IsSmoothOfRelativeDimension` because the directive specified that name (which is what the blueprint chapter prose names). **Defer the `Is`-prefix removal to iter-114 cleanup** paired with a blueprint-writer round on `Differentials.tex` (updating prose + `% NOTE:` removals + Picard_Functor stale line-refs + MV broken `\ref{}` — bundled cleanup pass).

Archived to `logs/iter-113/refactor-differentials-signatures-iter113-report.md`.

## Iter-113 Mathlib name re-verification (load-bearing this iter)

Per plan.md "past iters' verification status does NOT carry forward — Mathlib bumps can rename or remove declarations," I re-verified the names cited by THIS iter's prover lane (helper #1 closure recipe) + the refactor signatures via `lean_leansearch` / `lean_loogle` THIS iter:

- `AlgebraicGeometry.IsSmoothOfRelativeDimension` — **[verified]** (Mathlib.AlgebraicGeometry.Morphisms.Smooth; signature `ℕ → {X Y : Scheme} → (X ⟶ Y) → Prop`). **Deprecation alias** to `AlgebraicGeometry.SmoothOfRelativeDimension`; both names compile; the refactor uses the deprecated form to match blueprint prose. Cosmetic follow-up scheduled iter-114.
- `KaehlerDifferential.isLocalizedModule` (instance form) — **[verified]** (Mathlib.RingTheory.Kaehler.TensorProduct). The "_map" suffix in iter-112 PROGRESS.md / chapter prose is the project's hint shorthand for the same instance.
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` — **[verified]** (Mathlib.AlgebraicGeometry.AffineScheme).
- `AlgebraicGeometry.Scheme.isBasis_affineOpens` — **[verified]** (Mathlib.AlgebraicGeometry.AffineScheme; also `AlgebraicGeometry.isBasis_affine_open` as a snake_case sibling — both resolve to `TopologicalSpace.Opens.IsBasis X.affineOpens`).
- `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` — **[verified]** (Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover).
- `AlgebraicGeometry.IsGeometricallyIntegral` (typeclass for schemes) — **[gap]**. Does NOT exist in Mathlib b80f227. Only `Algebra.IsGeometricallyReduced` exists, on the algebra side. The refactor on `serre_duality_genus` keeps `[IsIntegral C.left]` and does NOT upgrade to "geometrically irreducible" — the blueprint prose mentions "geometrically irreducible curve" but this is forward-compatibility wording, not load-bearing for the iter-113 closure.

## STRATEGY.md updates this iter

**None**. The iter-112 scope-rationale paragraph + load-bearing-vs-orphan split remain load-bearing and address the iter-112 strategy-critic CHALLENGE. The iter-113 strategy-critic-retry's CHALLENGE on Phase B signature defects is addressed via the refactor (not via STRATEGY.md edits) — the strategy's own Soundness rule is preserved by fixing the signatures, not by re-stating the rule.

The strategy-critic's informational sunk-cost flag on STRATEGY.md L24 ("we'd erase iter-109's work") is noted but not acted on this iter; the iter-112 forward-value framing remains the primary rationale and the sunk-cost line is secondary. If the critic re-flags, the wording can be tightened iter-114.

## Iter-113 prover objective

Single lane on **`AlgebraicJacobian/Differentials.lean`** — close helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L177) via Sub-lemmas A (affine identification) + B (cofinality refinement). Success bar Bar A / Bar B / Bar C defined in PROGRESS.md. LOC budget ~100–200.

OFF-LIMITS iter-113: all other named-gap surfaces + the 4 other `Differentials.lean` sorries (L622 deferred parallel; L823 / L840 Phase B prover-viable but scheduled later; L982 named gap #7 with corrected signature).

## Files touched by plan agent this iter

- `.archon/PROGRESS.md` — rewritten for iter-113.
- `.archon/task_pending.md` — updated active target + signature-corrected status.
- `.archon/task_done.md` — unchanged (no closures this iter).
- `.archon/USER_HINTS.md` — unchanged (empty entering and leaving iter-113).
- `.archon/iter/iter-113/plan.md` — THIS file.
- `.archon/logs/iter-113/` — directives + report archives for the 4 subagent dispatches (3 critics + 1 refactor), plus the iter-112 prover report.

No blueprint chapters edited this iter (the iter-112 `% NOTE:` annotations were the right shape to drive the refactor without further prose edits; cleanup deferred to iter-114).

## Verification (pre-handoff, iter-113 plan pass)

| Check | Status |
|---|---|
| Sorry count per file | BasicOpenCech 6, LineBundle 2, Modules-Monoidal 1, Picard-Functor 1, Differentials 5, Jacobian 1, others 0 = **16 total**. Verified via `sorry_analyzer.py --format=summary` (pre- and post-refactor). |
| File compilation (Differentials.lean post-refactor) | `lean_diagnostic_messages severity=error` → `[]`. Two deprecation warnings on L818 / L835 (`IsSmoothOfRelativeDimension`); cosmetic-only. |
| `archon-protected.yaml` | unchanged (9 declarations). |
| New axioms | none across the project. |
| Subagent dispatches | 4 total (3 mandatory critics + 1 refactor; strategy-critic required a retry due to first-attempt socket error). All COMPLETE; reports archived to `logs/iter-113/`. |
| Mathlib name re-verification | 5 names re-verified `[verified]` (`IsSmoothOfRelativeDimension`, `KaehlerDifferential.isLocalizedModule`, `IsAffineOpen.isLocalization_basicOpen`, `Scheme.isBasis_affineOpens`, `isSheaf_iff_isSheafOpensLeCover`). 1 `[gap]` (`IsGeometricallyIntegral` for schemes — not load-bearing). |
| `USER_HINTS.md` | empty; not cleared (was already empty). |
| `task_results/` | cleared of iter-112 leftover review-phase results (`lean-auditor-iter112.md`, `lean-vs-blueprint-checker-differentials-iter112.md`); iter-113 plan-phase subagent reports retained pending iter-113 review-phase archive. |
| Build env | mathlib available in `.lake/packages/`. |
