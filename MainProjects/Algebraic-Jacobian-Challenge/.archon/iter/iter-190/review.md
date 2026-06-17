# Iter-190 (Archon canonical) — review

## Outcome at a glance

- **The "Lane I positivePart NAMING CLASH (paired parallel prover dispatch
  across WeilDivisor.lean + RationalCurveIso.lean both landed
  `AlgebraicGeometry.Scheme.WeilDivisor.positivePart` ⟹ integration
  build RED) + Lane A iotaGm_r_1_range_subset CLOSED axiom-clean post-
  refactor + Lane B Substrate 2 gmRing_tensor_homogeneousAway_isDomain
  CLOSED axiom-clean ~270 LOC + Lane G Stacks 00NQ substrate dramatically
  narrowed (full induction scaffold + base case + inductive prep +
  x ∉ 𝔭 branch axiom-clean; residual scoped to (x) ∈ minimalPrimes R) +
  Lane I Pin 2 corrective Option (a) intent landed (file-local pin +
  Hom.poleDivisor refactor) but BROKEN at integration due to the
  positivePart clash + Lane I Pin 3 Step 2 sub-task (b) axiom-clean
  inline via IsProper.comp_iff + Lane F PARTIAL with AddEquiv fully
  closed and residual scoped to ring-identity + restrictScalars unfold"
  iter.**
- **`lake build AlgebraicJacobian` RED** — exits 1 with namespace
  collision on `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`.
  iter-190 `meta.json` records `prover.status: done` (each per-file
  prover snapshot built in isolation), but the integration step never
  completes. The 10-consecutive-zero-axiom build streak is *interrupted*
  until iter-191 plan-phase resolves the clash.
- **Sorry trajectory**: entering iter-190 prover phase = 79 (= 78
  post-iter-189 + 1 from plan-phase Lane E refactor). Per-task-report
  deltas suggest the naive post-prover count would be 79
  (AVR −1; WeilDivisor +1; others 0). Actual integration-build sorry
  count is **not measurable** while the clash is live; the partial
  build reports 80 `declaration uses 'sorry'` warnings up to the failed
  target.
- **planValidate**: 6/6 planner-dispatching lanes dispatched.
- **Plan-predicted band**: best 78→~73 (−5), realistic 78→~76-78 (−2 to
  0), worst 78→~79-81 (+1 to +3). Actual landing is **integration RED**
  — not on the band axis but blocking until iter-191 resolves it.
- **Review-phase subagents skipped** (see `## Subagent skips` below).
  Rationale: the build-break dominates the iteration's signal; per-file
  Lean↔blueprint checking is unreliable while integration is broken.
- **sync_leanok**: 0 added / 4 removed / 2 chapters touched
  (RiemannRoch_RationalCurveIso, RiemannRoch_WeilDivisor) per
  `.archon/sync_leanok-state.json` iter=190 sha=2e130481 timestamp
  2026-05-26T09:03:52Z. The 4 removals are consistent with (a)
  RationalCurveIso.lean per-file `lake env lean` failing on the clash,
  (b) the new typed-sorry pin in WeilDivisor.lean reducing markers
  there.
- **blueprint-doctor iter-190**: 1 finding —
  `RiemannRoch_H1Vanishing.tex` covers
  `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` which does not
  exist (chapter landed iter-190 plan-phase ahead of the Lean
  skeleton). Surfaced in recommendations.md §3.
- **No manual blueprint markers landed this review**. The blueprint↔Lean
  mismatch on `lem:degree_positivePart_principal_eq_finrank`
  (equational chapter prose vs existential Lean signature) is
  deferred to iter-191 plan-phase for either Lean signature reshape
  or chapter prose rewrite (recommendations.md §4).

## CRITICAL — integration build RED

The iter-190 paired Lane I prover dispatch split a 2-file work item
("public `positivePart` def in `WeilDivisor.lean` + consume in
`RationalCurveIso.lean`") across two parallel prover sessions. Each
session built its own snapshot. The `WeilDivisor.lean` session landed
the public `Scheme.WeilDivisor.positivePart` def per spec; the
`RationalCurveIso.lean` session, not seeing the public def in its
snapshot, landed its planned file-local fallback `private
noncomputable def WeilDivisor.positivePart` at L416. At integration,
Lean rejects:

```
error: AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:416:26:
  a non-private declaration `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`
  has already been declared
```

The `private` keyword does NOT shadow the imported public name —
Lean's namespace resolution is at the fully-qualified level. The
iter-190 plan's instruction "the Pin 2 body close lands in
RationalCurveIso.lean **after the dependency lands**" implied
serialisation but was dispatched in parallel.

**This is the single most consequential finding of iter-190 review.**
Until iter-191 resolves it, no downstream prover lane can be sanely
dispatched (every `lake build` returns 1; sync_leanok runs only because
its per-file mode is partly resilient to the downstream break).

Recommendations.md §1 lays out the concrete fix recipe (~50 LOC edit
in RationalCurveIso.lean) and §2 lays out the prevention rule
(serialise paired prover dispatches across iters, OR mandate
distinctive private names for parallel fallbacks).

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| I-public | **SUCCESS (axiom-clean def + axiom-clean simp lemma + typed-sorry pin in existential form)** | `RiemannRoch/WeilDivisor.lean` | **PARTIAL** (substrate landed, pin owed) | 2 → 3 (+1 NEW typed-sorry pin) | `Scheme.WeilDivisor.positivePart` (L502) via `Finsupp.mapRange (fun n : ℤ => n ⊔ 0)`; `positivePart_zero` (L507) via `change` + `Finsupp.mapRange_zero`; `degree_positivePart_principal_eq_finrank` (L543) in existential form for soundness (equation form false-as-stated for arbitrary `t`). Blueprint↔Lean mismatch flag raised (rec §4). |
| I-consumer | **BLOCKED (integration RED — name clash)** | `RiemannRoch/RationalCurveIso.lean` | 2 → 2 (structural; file does NOT compile) | `Hom.poleDivisor` body refactored to `positivePart (principal ...)` and `Hom.poleDivisor_degree_eq_finrank` body would close axiom-clean via the file-local pin — but the file-local `WeilDivisor.positivePart` def at L416 clashes with the public def landed in `WeilDivisor.lean` by the parallel paired prover (see §CRITICAL above). Pin 3 Step 2 sub-task (b) DID land axiom-clean inline via `IsProper.comp_iff` (`IsProper φ.left` + `QuasiCompact` + `QuasiSeparated` derivations). |
| G | **SUCCESS (substrate narrowed; 2 axiom-clean helpers; HARD BAR MET)** | `Albanese/AuslanderBuchsbaum.lean` | 2 → 2 (substantive narrowing; +0 helper count above the 3 budget) | `isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero` (L1299, base case) + `regularLocal_quotient_isRegularLocal_of_notMemSq` (L1323, inductive step prep without IsSMulRegular). `isDomain_of_regularLocal` body now structured strong induction; base + inductive `x ∉ 𝔭` branch axiom-clean via Nakayama; residual scoped to `x ∈ 𝔭` ↔ `(x) ∈ minimalPrimes R` (Stacks `lemma-regular-graded` NOT in Mathlib b80f227). |
| B | **SUCCESS (Substrate 2 axiom-clean, HARD BAR MET)** | `Genus0BaseObjects/Cross01Substrate.lean` | 0 → 0 (Substrate 2 closed axiom-clean) | `gmRing_tensor_homogeneousAway_isDomain` (L129) closed kernel-only via explicit kbar-AlgHom `φ` into `L := Localization.Away (X () : MvPolynomial Unit (Away f))` (a domain), left-inverse `ψ_ring` via `IsLocalization.Away.lift` + `IsLocalization.ringHom_ext` pointwise. ~270 LOC (well above analogist 50-80 estimate due to Away f algebra plumbing). |
| A (Lane E post-refactor) | **SUCCESS (HARD BAR MET; iter-190 plan-phase refactor's +1 absorbed)** | `AbelianVarietyRigidity.lean` | 3 → 2 (−1; `iotaGm_r_1_range_subset` L104 closed axiom-clean) | Attempt 1 transplant of iter-184 closed body FAILED (`↥(ProjectiveLineBar kbar).left` vs `↥(Proj 𝒜)` defeq bridgeable by `change` but NOT `rw`); Attempt 2 reshape via stepwise `change` chain BEFORE `Proj.opensRange_awayι` invocation. Cascade upgrade: `iotaGm_r_1` def + `iotaGm_r_1_fac` lemma also axiom-clean. `iotaGm_chart1_composition_isOpenImmersion` deferred (~150 LOC budget; approach (b) recipe documented). |
| F | **PARTIAL (substantial qualitative progress; residual ring-identity; HARD BAR ≥1 axiom-clean closure NOT MET)** | `Picard/QuotScheme.lean` | 13 → 13 (sorry moved deeper; AddEquiv fully closed) | `pullback_of_openImmersion_iso_restrict` (L650): AddEquiv chain fully built (toFun/invFun/left_inv/right_inv/map_add'); smul through `Hom.app` migrated via `Scheme.Modules.Hom.app_smul`; residual sorry is the ring-level `Y.presheaf.map (eqToHom hImg.symm).op ((hU.fromSpec.appIso ⊤).inv ((ΓSpecIso _).inv.hom r)) = r` combined with `restrictScalars.smul_def`. 3 Mathlib bridges identified (NOT in Mathlib upstream-PR territory — all in `b80f227`); estimated 30-60 LOC iter-191 close. |

## Critic outcomes (recap from iter-190 plan-phase)

iter-190 plan-phase ran all 3 `[HIGHLY RECOMMENDED]` critics. None
re-dispatched in review phase (no new strategic content; build break
dominates).

| Critic | Slug | Verdict (summary) |
|---|---|---|
| `blueprint-reviewer` | `iter190` | 3 MUST-FIX (all addressed plan-phase: Pin 2 corrective NOTE; 2 missing QuotScheme pins; broken `\cref{chap:RR_H1Vanishing}` → new chapter landed via writer). |
| `progress-critic` | `route190` | 4 must-fix routes: Lane A.3.i CHURNING (HARD SCOPE CAP fired iter-189; analogist dispatched iter-191 plan-phase); Lane F CHURNING; Lane H CHURNING; Lane E STUCK + OVER_BUDGET (refactor landed; +1 sorry transplant friction absorbed by prover); Lane I UNCLEAR-must-act (Pin 2 false-as-stated diagnosis acted on via Option (a)). |
| `strategy-critic` | `iter190` | CHALLENGE: Lane M↓ Option (c) REJECTED (`sorryAx` not in kernel-only allow-list); A.3.0 / A.4.d.0 substrates enumerated; format DRIFTED corrected to 12.2 KB / 145 lines. |

## Plan-phase subagent dispatches this iter (recap)

- `blueprint-writer rr-h1vanishing-skeleton` — COMPLETE (560 lines;
  `\label{chap:RR_H1Vanishing}` resolves the broken cref).
- `refactor lane-e-iotagm-packaging` — COMPLETE (iotaGm_r_1 def +
  iotaGm_r_1_fac axiom-clean; backward-compat wrapper removed; file
  net +1 sorry on transplant friction; iter-190 prover lane absorbed).
- `mathlib-analogist lane-a3i-isconnected-prod` — directive prepared
  at `.archon/logs/iter-190/mathlib-analogist-lane-a3i-isconnected-prod-directive.md`
  but DISPATCH DEFERRED to iter-191 plan-phase per max_parallel=1
  semaphore constraint.
- `blueprint-writer pic0-abelian-variety-skeleton` — DEFERRED iter-191
  plan-phase.
- `blueprint-writer albaneseup-divisormap-rewrite` — DEFERRED iter-191
  plan-phase (directive re-dispatchable verbatim).

## Subagent skips

- **lean-auditor**: skipped this iter. Rationale: integration build RED
  on localised parallel-prover naming clash; a whole-project audit
  would mostly re-discover the build break + the pre-existing
  structural sorries already cataloged. The iter-191 planner must
  prioritise the clash fix before any audit signal becomes actionable.
- **lean-vs-blueprint-checker** (per-file × 6): skipped this iter.
  Rationale: `RationalCurveIso.lean` does NOT produce a `.olean` due
  to the naming clash, so any Lean↔blueprint alignment query against
  it fails at the LSP level; per-file checks on the other 5 files
  would not surface iter-191's highest-priority finding (cross-file
  integration bug is invisible to single-file audits). Re-enable
  per-file checks iter-191 review *after* the clash is resolved.

## Blueprint doctor (iter-190)

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/logs/iter-190/blueprint-doctor.md`:

> chapter `RiemannRoch_H1Vanishing.tex` covers
> `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`, which does not exist

Expected — chapter landed iter-190 plan-phase ahead of Lean scaffold.
Surfaced in `recommendations.md` §3 for iter-191 plan-phase: either
create the Lean skeleton first thing iter-191, or drop the
`% archon:covers` line until the file exists. The first option keeps
the HARD GATE coverage check live for Lane H; the second leaves
Lane H gate-uncovered.

## `\leanok` sync attribution

`.archon/sync_leanok-state.json` iter=190 sha=2e130481 timestamp
2026-05-26T09:03:52Z; added=0, removed=4, chapters_touched=
`[RiemannRoch_RationalCurveIso, RiemannRoch_WeilDivisor]`. Removals
attributable to (a) `RationalCurveIso.lean` failing per-file build on
the clash and stripping any proof-block markers, (b) the new
existential typed-sorry pin in WeilDivisor.lean reducing markers there.
iter=190 matches current iteration; markers are the script's
deterministic verdict, no laundering audit needed.

## Notable confirmations of prior KB entries

- **iter-188 KB `change` over `rw` for `OverClass.asOver`**:
  re-confirmed by Lane E iter-190 (Attempt 1 `rw` failed; Attempt 2
  `change` succeeded).
- **iter-189 KB `Subalgebra.bot_eq_top_of_finrank_eq_one`**: re-confirmed
  by Lane I iter-190 Pin 3 Step 1 inline (already closed iter-189; no
  regression).
- **iter-188 KB `letI`-driven Γ-module structure on pullback sections**:
  consumed by Lane F iter-190 attempt at QuotScheme L650 (necessary
  setup for the section-level LinearEquiv signature).

## New KB entries (added to PROJECT_STATUS.md)

1. **Parallel-paired prover dispatch across two files (introduce-public
   in A, consume in B) is unsafe — serialise across iters** (iter-190
   Lane I clash analysis).
2. **Existential vs equational typed-sorry pins: prefer existential when
   the equation is false-as-stated for free parameters** (iter-190 Lane
   I WeilDivisor route).
3. **`ringKrullDim_le_ringKrullDim_quotient_add_encard` (Krull's height
   theorem) sidesteps `IsSMulRegular` for the regular-quotient half of
   joint induction in Stacks 00NQ** (iter-190 Lane G2 prep).

## Iteration outcome summary

| Metric | Value |
|---|---|
| `lake build AlgebraicJacobian` | **RED** (namespace collision on `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`) |
| Project axioms | not verifiable (integration RED) |
| Closed sorries this iter | 1 axiom-clean (`iotaGm_r_1_range_subset` L104, AVR) |
| New typed-sorry pins | 2 (file-local in RationalCurveIso.lean — invalid due to clash; public `degree_positivePart_principal_eq_finrank` existential pin in WeilDivisor.lean) |
| New axiom-clean substrate decls | 2 (AuslanderBuchsbaum helpers) + 2 (WeilDivisor `positivePart` + `positivePart_zero`) + 1 (Cross01Substrate Substrate 2 `gmRing_tensor_homogeneousAway_isDomain`) = 5 |
| HARD BAR results | A: MET; B: MET; G: MET (helpers); F: NOT MET; I-public: PARTIAL (pin owed); I-consumer: BLOCKED |
| Critic dispatches (plan-phase) | 3/3 [HIGHLY RECOMMENDED] |
| Critic dispatches (review-phase) | 0 (skip rationales documented) |
| Plan-phase deferrals to iter-191 | 3 (A.3.i analogist + 2 blueprint writers) |
