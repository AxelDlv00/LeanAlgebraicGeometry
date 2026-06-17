# Progress Critic Directive

## Slug
iter106

## Iter
106 (Archon canonical) / iter-108 (project narrative)

## Active routes / files under review

### Route: `cechCofaceMap_pi_smul` (Phase A engine residual) — `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

- **Started at iter**: ~099 (project narrative) — first PARTIAL on this exact slot
- **Iters audited**: 099 → 100 → 101 → 103 → 105 → 106 → 107 (last 7 project-narrative iters; iter-102 + iter-104 had different sub-targets but on the same file/engine)
- **Total iters on slot**: 7 (consecutive PARTIAL outcomes; sorry count 6→6→6→6→6→6→6 — no closure)

#### Sorry counts per iter (BasicOpenCech.lean syntactic total)
- iter-099 entry → 6
- iter-100 entry → 6
- iter-101 entry → 6
- iter-103 entry → 6
- iter-105 entry → 6
- iter-106 entry → 6 (+1 transient Route 1 lemma signature added by iter-106 prover, body sorry, BACKED OUT by iter107-cleanup refactor)
- iter-107 entry → 6 (post iter107-cleanup; -1 from Route 1 backout)
- iter-107 exit → 6 (option 3 attempt failed; trailing sorry intact)
- iter-108 entry → 6 (current; load-bearing `have h_iter104` staged, trailing sorry preserved)

#### Helpers added per iter on this slot
- iter-099: closed `alternating_sum_pi_smul_aux_sum_comp` body (+0 helper additions; bodies closed)
- iter-100: 0 new helpers
- iter-101: 0 new helpers (S1-S3 scaffold inside body)
- iter-102: added `alternating_zsmul_pi_smul_aux_sum_comp` (1 new helper, body added iter-103)
- iter-103: closed `alternating_zsmul_pi_smul_aux_sum_comp` body
- iter-104: added `cechCofaceMap_summand_family` + `cechCofaceMap_summand_family_R_linear` (2 new top-level helpers; both bodies CLOSED iter-104)
- iter-105: added `cechCofaceMap_summand_family'` + `cechCofaceMap_summand_family'_R_linear` (2 new wrapper helpers; both bodies CLOSED iter-105) + partial-proof scaffold at L1115-L1144 invoking wrappers
- iter-106: added `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` (1 new Route 1 morphism-equality lemma; body sorry — backed out iter107-cleanup)
- iter-107: 0 new helpers; PARTIAL with `have h_iter104` staged at L1119 (body-local, not top-level)
- **Total**: 6 top-level helpers added over 7 iters (5 with closed bodies + 1 backed-out dead-end)

#### Prover statuses
- iter-099: PARTIAL (closed sum_comp body, did NOT close `cechCofaceMap_pi_smul`'s trailing sorry)
- iter-100: PARTIAL
- iter-101: PARTIAL
- iter-103: PARTIAL
- iter-105: PARTIAL
- iter-106: PARTIAL (added transient Route 1 sorry, did not close trailing sorry)
- iter-107: PARTIAL (option 3 failed in 6 attempts; staged h_iter104 + comment)

**Sequence: 7 consecutive PARTIAL.** Zero COMPLETE on this slot since the lane opened iter-099.

#### Recurring blocker phrases (verbatim from prover task_results across iters)
- "anonymous-closure Pi.lift codomain" — appears in 6/7 reports (iter-100, 101, 103, 105, 106, 107)
- "discrim-tree pattern-unification" — appears in 5/7 reports (iter-101, 103, 105, 106, 107)
- "whnf timeout at 1600000 heartbeats" — appears in 4/7 reports (iter-101, 103, 106, 107)
- "eqToHom-vs-Pi.π transport" — appears in 4/7 reports (iter-103, 105, 106, 107)
- "Fin index mismatch" / "Fin.cast" — appears in 4/7 reports (iter-105, 106, 107)
- "ModuleCat.hom_zsmul/hom_smul/hom_nsmul find no match" — iter-106, 107

#### Iter-107 prover's iter-108 recommendation (from task_results)
"Mirror iter-104's binder-level proof of `cechCofaceMap_summand_family_R_linear` (L502–L603), with the eqToHom-bridge baked into the per-coord step. The closely-related wrapper proof `cechCofaceMap_summand_family'_R_linear` (L676–L734) already does this for the wrapper, and iter-108 can adapt it directly. Key steps: 1. From `h_iter104`, derive the per-coord version at `j_int := j' ∘ Fin.cast hRel'` via `congrFun` + `Pi.smul_apply`. 2. Bridge from `(Pi.π Z_int j_int).hom (F.hom z)` to `(Pi.π Z₂ j').hom (eqToHom_outer.hom (F.hom z))` via a categorical identity… 3. Handle σ-smul via `congrArg (σ • ·)` on both sides + `smul_comm`."

Estimated by the prover: ~80–120 LOC of inlined proof body.

#### Iter-105 progress-critic verdict (your own prior verdict to consider for repeat detection)

iter-105 progress-critic returned STUCK on this route. Primary corrective: "route pivot — adopt iter-106 prover's option 3 (discard wrapper, direct `Pi.hom_ext` per-coord scalar pullback)". Iter-107 (the iter dispatched after that verdict) executed option 3 and FAILED with 6 distinct attempts. The corrective you recommended did NOT resolve the route.

Render your iter-106 verdict per this signal.

### Route: lean-auditor-iter105 must-fix items (cross-file)

- **Started at iter**: iter-104 (Archon) — when LineBundle and instIsMonoidal_W findings first surfaced
- **Iters audited**: iter-104 → iter-105 (project narrative iter-107)

#### Must-fix items still uncorrected entering iter-106 (Archon)
- `Picard/LineBundle.lean:85-86` weakened-wrong def `LineBundle X := CommRing.Pic Γ(X, ⊤)` (CRITICAL; carrying since iter-104).
- `Modules/Monoidal.lean:166-173` `noncomputable instance instIsMonoidal_W ... := sorry` (CRITICAL; carrying since iter-104).
- (Iter-105 added 2 more, both stale status docstrings — also still uncorrected: StructureSheafModuleK.lean:27-31, Rigidity.lean:19-23.)

#### Helpers added per iter on this route
None of these have been touched by any prover or refactor across iter-104/105/106 plan rounds (PARTIAL coverage at best — iter-107-cleanup refactor cleaned related lower-severity items but did NOT touch these 4 must-fix items).

### Iter-108 abort policy (already committed in STRATEGY.md)

If option 3 fails (which it just did), acceptable iter-108 shapes are:
- (a) refactor `cechCofaceMap_pi_smul`'s body to use a different decomposition (rcases n / manual Pi.hom_ext / etc.);
- (b) re-dispatch strategy-critic mid-iter on a revised Phase A strategy;
- (c) user-escalation.
Wrapper engineering as such is committed to NOT be repeated.

Render verdicts:
- Phase A `cechCofaceMap_pi_smul` route: CONVERGING / CHURNING / STUCK / UNCLEAR + primary corrective.
- Lean-auditor must-fix-items route: CONVERGING / CHURNING / STUCK / UNCLEAR + primary corrective.

For each STUCK or CHURNING route, name a SPECIFIC corrective from your descriptor's list (blueprint expansion / mathlib-analogist consult / refactor / route pivot / user escalation). Be explicit: which subagent, what directive shape, what success criterion.

