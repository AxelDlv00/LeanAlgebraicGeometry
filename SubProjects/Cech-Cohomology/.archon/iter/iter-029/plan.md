# Iter-029 plan — 01EO chain COMPLETE; open 02KG affine Serre vanishing (two parallel lanes)

## Entering state (verified)
The iter-028 single mathlib-build lane landed the **ENTIRE remaining 01EO chain, beyond the hedge**:
**+7 axiom-clean decls, 0 new sorries** in `CechToCohomology.lean` — `sectionsFunctor`,
`faceShortComplex_shortExact_of_sheaf_ses` (per-face SES), `absoluteCohomology_one_eq_zero_of_basis` (L3),
`BasisCovSystem`+`CovDatum`+`HasVanishingHigherCech`, `injSES`/`injSES_shortExact`,
`absoluteCohomology_eq_zero_of_basis` (L4 induction), `cech_eq_cohomology_of_basis` (TOP). **01EO is COMPLETE.**
Audits: lean-auditor `iter028` 0 must-fix (4 minor); lvb `cechtocohom-iter028` 0 Lean red flags + 3 blueprint-
side majors (BasisCovSystem prose divergence, `[EnoughInjectives]` disclosure, stale NOTEs) + 4-helper coverage
debt. Project sorry = 2 (both frozen/superseded). Build green.

## What I did this iter (plan phase)
1. Processed the iter-028 lane (task_done += the 7-decl chain; task_pending: 01EO DONE, 02KG opened).
2. **STRATEGY.md**: moved 01EO → `## Completed` (`028 · 3`, ~600 LOC); set 02KG ACTIVE with the affine-
   instantiation decomposition; recorded the **EnoughInjectives connector** obligation; flagged the P5a
   Ext-by-injective-resolution backing as UNVERIFIED; trimmed drifted table cells + collapsed Route B
   (strategy-critic format=DRIFTED).
3. **reference-retriever `sheaves-cofinal`**: fetched Stacks "Sheaves on Spaces" Tag **009L**
   `lemma-cofinal-systems-coverings-standard-case` → `references/stacks-sheaves.tex` (cofinality of standard
   covers — condition (2) of 02KG, not previously local).
4. **blueprint-writer `02kg`** (one consolidated chapter, references/** authorized): JOB 1 reconcile —
   `def:basis_cov_system` rewritten to the real 5-field Lean encoding (`surj_of_vanishing` OUTPUT field +
   `injective_acyclic`, dropping the false "no derived-functor machinery" claim); `[EnoughInjectives]`
   disclosure on L4/top/02KG; coverage-debt pins bundled (CovDatum→def:basis_cov_system,
   sectionsFunctor→lem:face_ses, injSES/injSES_shortExact→L4); dead `CechAcyclic.affine` de-pinned from
   `lem:cech_acyclic_affine`. JOB 2 — **decomposed `lem:affine_serre_vanishing` (Tag 02KG) into an 8-block
   `\uses`-chain** (`def:affine_cover_system` + faces_mem/cofinal/cover_datum_bridge/surj_of_vanishing/
   injective_acyclic/qcoh_iso_tilde_sections/affine_cech_vanishing_qcoh), each cited verbatim.
5. **blueprint-clean `02kg`**: purity pass (2 minor edits; all 10 new-block source quotes verbatim-confirmed).
6. **blueprint-reviewer `iter029` (HARD GATE, whole blueprint): CLEARS** all 3 chapters
   (`complete:true·correct:true`); the 9 new 02KG decls FORMALIZE-READY (`\uses` acyclic, citations resolve,
   pins present, BasisCovSystem prose matches the 5-field Lean). 4 INFO (non-blocking): qcoh_iso_tilde sketch
   thin (entry `…Tilde.isIso_fromTildeΓ_of_presentation`), source-quote ordering on standard_cover_cofinal,
   1 isolated lean_aux (the dead decl), affine_serre_vanishing opening quote possibly editorial.
   **`AffineSerreVanishing.lean` may be dispatched.**
7. **strategy-critic `iter029`: SOUND-with-CHALLENGE** — see Decision D2.
8. Wrote PROGRESS.md (TWO parallel lanes, scaffold keywords on both path lines), task ledgers, this sidecar,
   objectives.md, ARCHON_MEMORY.md, TO_USER.md.

## Decisions made

### D1 — 02KG as TWO parallel mathlib-build lanes, isolating the tilde globalisation.
**Chosen** over one serial 02KG lane. **Why:** the strategy-critic + the user's standing parallelism directive
both flag that faces_mem / cover-bridge / tilde-globalisation are largely independent, and the tilde
globalisation `F≅~(ΓF)` (01HV/01I8) is the **single least-certain piece** (Mathlib qcoh↔module-on-`Spec`
coverage is partial). Isolating it in `QcohTildeSections.lean` lets a dedicated prover attack it without the
cover-system context, in parallel with the cover-system infra in `AffineSerreVanishing.lean`. The cross-
dependency (`affine_cech_vanishing_qcoh` + top need both halves) is deferred to the next-iter assembly — so
Lane 1 does NOT import Lane 2 this iter (avoids a blocked-deps failure if the hard lane stalls). **Trade-off:**
two new files + a deferred assembly step vs. one serial lane; mathlib-build's no-sorry-handoff invariant means
neither lane wastes budget — each builds its independent pieces and hands off cleanly. **Reversal signal:** if
the cover-system pieces turn out to depend on the tilde infra after all, merge into one file next iter.

### D2 — Address the EnoughInjectives connector CHALLENGE by recording it as a cone obligation (not building it yet).
The strategy-critic correctly found the frozen target provides `[HasInjectiveResolutions X.Modules]` while the
whole 01EO/02KG cone carries the stronger `[EnoughInjectives X.Modules]`, with no connector named — so the
final assembly would not type-check as written. The connector `HasInjectiveResolutions C → EnoughInjectives C`
is TRUE and ~6 LOC (deg-0 mono into `I.cocomplex.X 0` via `CategoryTheory.InjectiveResolution.instMonoFNatι`).
**Decision:** record it as an explicit obligation in STRATEGY (Open questions + Mathlib gaps) and build it
(register as instance) when the P5b assembly lane opens — it is NOT on the 02KG critical path (the 02KG decls
legitimately carry the minimal `[EnoughInjectives]` hyp). **This dissolves the project's recurring
"EnoughInjectives absent in Mathlib" anxiety:** the instance is DERIVED from the frozen hypothesis, not needed
for free. **Why not build it this iter:** it has no natural home until the assembly file, and forcing it now
would either churn a DONE file or create a stub file with one lemma; recording satisfies the critic's
"must be on the books" requirement. Rebuttal not needed — the challenge is valid and addressed.

## Subagent skips
- progress-critic: the only active route that ran a prover last iter (01EO) COMPLETED in iter-028 (sorry→0,
  route closed); the 02KG route is fresh with no trajectory to extrapolate (explicit skip condition met).
  5 consecutive first-attempt-COMPLETE iters, no churn, no CHURNING/STUCK signal to chase.

## Risks / watch
- Tilde globalisation (Lane 2) is the least-certain Mathlib-coverage piece — if `isIso_fromTildeΓ_of_presentation`
  doesn't cover qcoh-on-affine, it becomes a Mathlib-gradient build (mathlib-build will hand off a decomposition).
- 02KG ~200–400 LOC may be optimistic (cover-bridge plumbing + tilde infra). The two-lane split hedges this.
- INFO-4 (affine_serre_vanishing opening quote possibly editorial) — review agent to verify verbatim; low-priority.
