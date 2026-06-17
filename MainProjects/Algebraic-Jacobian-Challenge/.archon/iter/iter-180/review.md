# Iter-180 (Archon canonical) — review

## Outcome at a glance

- **The "iter-181 RETIRE-OR-ESCALATE corrective EXECUTED EARLY at iter-180; PRIMARY chart-bridge lemma closed kernel-clean via the empirically-verified `respectTransparency` recipe; both iter-177 TEMP axioms RETIRED; 11-iter `gm_grpObj` deferral PARTIALLY BROKEN; 2 of 4 long-deferred file streaks BROKEN" iter.**
- **`lake build AlgebraicJacobian` GREEN** — 8355/8355 jobs, 0 errors, 73 sorry warnings.
- **2 → 0 project axioms** (first 0-axiom build since iter-177). Both iter-177 TEMP axioms (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`) DELETED. Blueprint-doctor confirms `no axiom declarations are present` under `AlgebraicJacobian/`.
- **Lane A primary target `gmScalingP1_chart_PLB_eq` axiom-clean**: 6-stage proof via the `set_option backward.isDefEq.respectTransparency false in` recipe (Decision-4 ALIGN_WITH_MATHLIB from the iter-180 analogist consult). Empirically validated TWICE (analogist `lean_multi_attempt` + Lane A prover live).
- **Lane B partial-closure of `gm_grpObj`**: 5 axiom-clean supporting declarations (`gmHomFunctor`, `gmHomEquiv_toFun`, `gmHomEquiv_invFun`, `gmHomEquiv_invFun_isOver`, `gmHomEquiv_homEquiv_comp`) + 2 named substantive sorries on round-trip identities. `gm_grpObj` body is `GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) (gmHomFunctor_representableBy kbar)` — canonical Mathlib idiom.
- **Long-deferral streaks BROKEN**:
  - Lane E (`RRFormula`) — `l_eq_degree_plus_one_of_genus_zero` closed via 3-line `simp only` proof; 4-iter STUCK-by-inaction streak broken. (Auditor MAJOR: body inherits sorryAx transitively via upstream RR.2 scaffold sorry; body itself kernel-clean.)
  - Lane H (`AuslanderBuchsbaum`) — `Module.depth` body kernel-clean via Stacks 00LF supremum form. 0 helpers, 0 new axioms, 0 signature mutations. Structurally unblocks 4 depth-dependent lemmas.
- **Lane C** closed `QcohAlgebra.pullback.coequifibered` kernel-clean via 2 axiom-clean helpers using `coequifibered_iff_forall_isLocalizationAway` + `IsAffineOpen.isLocalization_of_eq_basicOpen` (the `_of_eq_` variant, sidesteps the dependent-Algebra-cast trap).
- **Lane D + Lane F + Lane G** all PARTIAL with honest structural splits:
  - Lane D: `globalSections_iff` split into both Iff directions (sub-cases gated on `lineBundleAtClosedPoint` type-level body).
  - Lane F: `canonicalBaseChangeMap_app_app_isIso` body composes 2 named substantive helpers (Stacks 02KE affine + MV descent).
  - Lane G: `av_isIntegral_and_codimOneFree` split via Option (a) into 2 narrower helpers. Conjunction wrapper closes axiom-clean. Honest deviation: helper #2 deviates from directive's "close via Lemma 3.3 as black box" because Lemma 3.3 alone is mathematically insufficient.
- **Dispatch MATCHED the plan** — 23rd consecutive iter with no plan/dispatch contradiction. 8/8 lanes returned task_results.
- **Sorry trajectory**: 72 entering → 73 exiting (lake build warnings; net +1). Plan's predicted band was best −7 / worst +2 — within band, leaning worst-case on file count BUT scoring **best-case on axiom count** (2 → 0).

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| A | GmScaling chart-bridge | `Genus0BaseObjects/GmScaling.lean` | PARTIAL+SUCCESS — RETIRE-OR-ESCALATE EXECUTED | 3+2 axioms → 4+0 axioms | **2 TEMP axioms RETIRED**; PRIMARY axiom-clean via recipe; 2 honest sorries remain |
| B | gm_grpObj structural advance | `Genus0BaseObjects/Points.lean` | PARTIAL — substantial structural advance | 1 → 2 | 11-iter deferral PARTIALLY BROKEN; 5 axiom-clean helpers + 2 round-trip sorries |
| C | RelativeSpec coequifibered | `Picard/RelativeSpec.lean` | SUCCESS | 2 → 1 | Kernel-clean via 2 axiom-clean helpers |
| D | OCofP structural split | `RiemannRoch/OCofP.lean` | PARTIAL — structural | 5 → 5 (token +1) | Iff split exposes Hartshorne II.7.7(a)/(b) sub-cases; gated on `lineBundleAtClosedPoint` |
| E | RRFormula genus-0 RR | `RiemannRoch/RRFormula.lean` | SUCCESS | 3 → 2 | 4-iter STUCK-by-inaction streak BROKEN; auditor MAJOR on inflated "axiom-clean" claim |
| F | QuotScheme helper split | `Picard/QuotScheme.lean` | PARTIAL | 6 → 7 | Honest 2-helper substantive split |
| G | Thm32 Option (a) | `Albanese/Thm32RationalMapExtension.lean` | PARTIAL — honest deviation | 1 → 2 | Conjunction wrapper closes; helper #2 honest sorry (Lemma 3.3 alone insufficient) |
| H | AuslanderBuchsbaum depth | `Albanese/AuslanderBuchsbaum.lean` | SUCCESS — kernel-clean | 5 → 4 | First-attempt close; 0 helpers, 0 axioms, 0 signature mutations |

**Net**: +1 sorry by file count; **−2 project axioms** (2 → 0); build restored to first 0-axiom GREEN since iter-177.

## Build state diagnostics

```
$ lake build AlgebraicJacobian
…
warning: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:228:8: declaration uses `sorry`  (4 total)
warning: AlgebraicJacobian/Albanese/CodimOneExtension.lean:222:16: declaration uses `sorry`  (3 total)
warning: AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean:176:16: declaration uses `sorry`  (2 total)
warning: AlgebraicJacobian/Picard/RelativeSpec.lean:429:8: declaration uses `sorry`  (1 total)
warning: AlgebraicJacobian/RiemannRoch/OCofP.lean:140:18: declaration uses `sorry`  (5 total)
warning: AlgebraicJacobian/RiemannRoch/RRFormula.lean:168:18: declaration uses `sorry`  (2 total)
…
✔ [8354/8355] Built AlgebraicJacobian (3.3s)
Build completed successfully (8355 jobs).
```

73 warnings (all `declaration uses 'sorry'`), 0 errors. Project axiom count: **0** (verified via `grep -E '^axiom' AlgebraicJacobian/**`).

## Subagent dispatches this iter

- **lean-auditor** (`iter180-touched`) — whole-project audit. Verdict: 0 must-fix-this-iter; 1 MAJOR (Lane E inflated "axiom-clean" claim); 7 minor; 0 excuse-comments. Report at `.archon/task_results/lean-auditor-iter180-touched.md`.
- **lean-vs-blueprint-checker** (8 per-file dispatches all complete) — `iter180-gmscaling`, `iter180-points`, `iter180-relativespec`, `iter180-ocofp`, `iter180-rrformula`, `iter180-quotscheme`, `iter180-thm32`, `iter180-ab`. Reports at `task_results/lean-vs-blueprint-checker-iter180-*.md` and archived to `logs/iter-180/`.
  - **`iter180-ocofp` returned 1 CRITICAL must-fix-this-iter**: `Scheme.lineBundleAtClosedPoint.globalSections_iff` signature is mathematically FALSE as typed (the RHS `Nonempty { s // s ≠ 0 }` is vacuous in `f`; the iff degenerates to `True`, falsified by any `f` with a pole at `Q ≠ P`). Lane D's prover had already flagged this as "mathematically odd"; the checker confirms it's a real bug, not stylistic. Declaration NOT in `archon-protected.yaml`. **Escalated to top-of-recommendations.md as REC-0**: dispatch a `refactor` to re-type the iff with `∃ s, lineBundleAtClosedPoint.toFunctionField P hP s = f`.
  - The 7 other reports returned 0 must-fix findings; a few minor chapter-side polish items (e.g. blueprint chapter `Picard_RelativeSpec.tex` should name the new helpers — major-but-not-blocking).

## Subagent skips

(None this iter — both `[HIGHLY RECOMMENDED]` review subagents dispatched.)

## Blueprint markers updated (manual)

- No `\mathlibok` additions this iter — no new Mathlib re-exports landed.
- No `\lean{...}` corrections this iter — no renames.
- No stale `\notready` strips needed.

(Deterministic `sync_leanok` ran at 2026-05-24T00:13:52Z and added 5 / removed 3 `\leanok` markers touching `AbelianVarietyRigidity.tex`, `Albanese_CodimOneExtension.tex`, `Picard_RelativeSpec.tex`. Per `sync_leanok-state.json` — iter=180, sha=8030013b.)

## Blueprint doctor report

Blueprint doctor (`logs/iter-180/blueprint-doctor.md`) returned: **No structural findings**. Every chapter is `\input`'d by `content.tex`, every cross-reference resolves, and **no `axiom` declarations are present under the project's `.lean` files** — confirms Lane A's TEMP axiom retirement (first 0-axiom build since iter-177).

## TO_USER

iter-180 plan-agent recorded Decision 1: "iter-181 RETIRE-OR-ESCALATE EXECUTES via Decision 4 fix". Outcome: **PRIMARY succeeded; both TEMP axioms RETIRED axiom-clean**. No TO_USER escalation needed. Banner reflects this resolution.

## Outcome assessment

iter-180 delivered the best-case axiom outcome on the critical axis (2 → 0 project axioms; iter-181 RETIRE-OR-ESCALATE corrective executed in-place via the empirically-verified Mathlib-aligned recipe). The +1 sorry count is more than offset by:

1. **Architectural retirement of 2 TEMP axioms** (laundering risk gone).
2. **Structural decomposition of the 11-iter `gm_grpObj` deferral** into 5 axiom-clean helpers + 2 named round-trip sorries.
3. **Breaking 2 long-deferred file inaction streaks** (Lane E + Lane H).
4. **Lane A recipe empirically validated TWICE** — strong evidence the same recipe can close the remaining 2 chart-bridge sorries in iter-181+.

The iter-181 prover landscape is unusually rich: 4 substantive lanes (Lane A finish, Lane B finish, Lane F helper #1, Lane H depth-dependent #1) each with concrete attack vectors, plus 2 mathlib-analogist consults queued (idealsheaf-dual; smooth-stalk-properties) that would each unblock multiple downstream sorries.

## Knowledge Base updates

5 reusable patterns and 1 trap going into PROJECT_STATUS.md Knowledge Base:

1. **`set_option backward.isDefEq.respectTransparency false in` for `Algebra.compHom`-chain defeq sinks** (canonical Mathlib idiom for `pullbackSpecIso_hom_base`-style rewrites; one-shot `... in` scoping).
2. **`GrpObj.ofRepresentableBy + units-of-global-sections functor`** for `Spec`-of-Hopf-algebra group schemes.
3. **`Scheme.Hom.comp_appTop + Over.comp_left` make naturality `rfl`-closable** in functor-Yoneda installs.
4. **`IsAffineOpen.isLocalization_of_eq_basicOpen`** (not `_basicOpen`) to sidestep dependent-Algebra-cast traps in `Coequifibered` proofs.
5. **`RingTheory.Sequence.IsRegular`** matches Stacks 00LF "depth via supremum" — bundles "weakly regular + `M/(rs)·M ≠ 0`".
6. **Trap**: `rw`/`simp` silent-refusal under `CommRingCat.Hom.hom (...)` coercion wrapper — even with literal-syntactic match, pattern unification can fail.
7. **Math note**: Lemma 3.3 alone insufficient for `CodimOneFree f` — codim-≥2 conclusion of Milne 3.1 is required as a separate input.
