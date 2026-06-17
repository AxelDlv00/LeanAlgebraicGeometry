# Recommendations — after iter-016 (for the iter-017 plan agent)

## HIGH

### H1. Blueprint-writer on `Cohomology_FlatBaseChange.tex` BEFORE the next FBC prover (lvb-fbc must-fix ×2)
The FBC chapter under-specifies the two mechanisms the prover actually needs; a raw re-dispatch churns.
- **Seam 2 (`lem:base_change_mate_fstar_reindex`):** the `% RECIPE` names the 4-step approach and the
  `rw`-dead-end but NOT the concrete fix. The prover proved the leg-reindex engine
  (`pullbackPushforward_unit_comp`) and wired it as `have key`, yet the `sorry` persists because the two
  pullback legs sit in **dependent positions** (`rw` → `motive is not type correct`). The chapter must
  specify the restructure: restate the goal (and the opaque `codomain_read`) with the legs as
  `subst`-able **variables** `g' f'`, then `subst` + Γ-transparent coherence collapse + Seam 1. Split the
  block into (i) abstract `codomain_read`-with-variable-legs, (ii) the Γ-collapse, (iii) the Seam-1 substitution.
- **Seam 3 (`lem:base_change_mate_gstar_transpose`):** prose says "counit-triangle identity + naturality"
  but omits the concrete coherence — `pullback_spec_tilde_iso ψ` is built via `conjugateIsoEquiv`; its
  interaction with the counit needs the `unit_conjugateEquiv` + `homEquiv_counit` chain at the Lean level.
- After the writer returns + `lake build` green, use the sanctioned **same-iter fast-path** re-review
  (fresh slug, scoped to this chapter) to clear the gate and dispatch the FBC prover in iter-017.

### H2. Blueprint block for `pullbackPushforward_unit_comp` (sole unmatched `lean_aux` node)
`archon dag-query unmatched` returns exactly one node: `AlgebraicGeometry.pullbackPushforward_unit_comp`
(FlatBaseChange.lean ~1140, **proved, axiom-clean, has_sorry:false**). It is invisible to the DAG until
blueprinted. Author a `\begin{lemma}` block immediately before `lem:base_change_mate_fstar_reindex`:
statement = pseudofunctoriality of the pullback–pushforward unit; `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}`;
`\uses` adjacent to `lem:base_change_mate_unit_value`; Mathlib deps `unit_conjugateEquiv`,
`conjugateEquiv_pullbackComp_inv`, `Adjunction.comp_unit_app`. (Review cannot author informal prose.)

### H3. GF L5 `exists_free_localizationAway_polynomial` is a DO-NOT-RETRY blocker (raw re-dispatch will fail)
The math is complete (the 5-line assembly is recorded verbatim in-code; both feeder lemmas are closed
axiom-clean). The `sorry` is an `OreLocalization` instance-**presentation** diamond between
`gf_torsion_reindex`'s IH output and `free_localizationAway_of_away_tower`'s input (CommSemiring /
AddCommMonoid / Module-SMul on `T_g` all defeq but not instance-transparent-equal). Four bridging
attempts failed (`@IH`-explicit, `letI`/`haveI` ambient, re-ascription, full-defeq `exact`).
**Corrective = structural refactor, NOT another prover round / heartbeat bump:** make `gf_torsion_reindex`
emit its conclusion over the canonical `OreLocalization.*` instances (final `exact` / existential binders,
~lines 1245–1252), OR restate `free_localizationAway_of_away_tower`'s `hfree` over the
`CommRing.toCommSemiring`/`hmod2` presentation. Dispatch a refactor (or mathlib-analogist consult on the
canonical `IsLocalization`/`OreLocalization` instance shape) before any L5 prover. `% NOTE` already added
to `lem:gf_polynomial_core`.

## MEDIUM

### M1. GF chapter shows 0 `\leanok` — `sync_leanok` cold-elaboration timeout (DAG under-represents GF)
`Picard_FlatteningStratification.tex` has **0** `\leanok` despite ≥2 closed axiom-clean pinned decls.
`sync_leanok` ran (iter 16, sha `9f02062`) but only touched `Picard_QuotScheme.tex`. Root cause: the
known iter-015 KB cold `lake env lean` heartbeat timeout on this file, now compounded by **three**
`set_option synthInstance.maxHeartbeats 1000000` bumps (lines 1015, 1254, 1375). Not laundering / not a
regression (both decls verify axiom-clean under LSP). Mitigation options for the planner: (a) raise the
sync's per-file elaboration budget / split the GF file so each piece elaborates cold within budget; (b)
accept the DAG gap and track GF progress via `lean_verify` in reviews. Surface to tooling owner if neither
is in-loop.

### M2. Stale cross-project comments — prover-cleanup (lean-auditor 5 major)
Review cannot edit `.lean`. Have the owning prover prune on its next touch:
- **`FlatBaseChange.lean:234–247`** — ACTIVELY MISLEADING: the `STATUS (iter-234)/UPDATE (iter-236)` block
  claims `pushforward_spec_tilde_iso` has "the sole remaining obligation" still open; it is **CLOSED**
  (line 538). Highest priority of the five.
- `FlatBaseChange.lean:547` (`iter-240 PIVOT`), `635–639` (`iter-241 KEY INSIGHT`) — predecessor-project markers.
- `RelativeSpec.lean` (~54, 96, 168, 205, 213, 229, 277) — pervasive iter-173..179 predecessor markers.
- `QuotScheme.lean` (`QuotFunctor` docstrings, `iter-177+`) — minor.
All originate from the "Algebraic-Jacobian-Challenge" predecessor (per `git log`); current project is iter-016.

### M3. QUOT Route 2 build resumes iter-017 (the iter-016 plan decision)
Per `iter-016/plan.md` `## Decision made`: QUOT pivoted to **Route 2 (ambient subquotient induction)**
to sidestep the `DirectSum.IsInternal`/`Decomposition` `isDefEq` non-termination on quotient/subtype
carriers (`memory/graded-quotient-module-isdefeq-pathology.md`). Strategy-critic SOUND, mathlib-analogist
validated. The QUOT prover lane (deferred since iter-015 as CHURNING) re-opens iter-017 on Route 2 — gated
by the mandatory whole-blueprint review confirming the Route-2 chapter is `complete + correct`.

## Reusable patterns discovered
- **Mate idiom for unit pseudofunctoriality:** `unit_conjugateEquiv ((adj b).comp (adj a)) (adj (a≫b)) (pullbackComp a b).inv N`
  then `rw [conjugateEquiv_pullbackComp_inv, comp_unit_app]`. `N` lives on the **codomain** (source of the
  left adjoint `pullback`). Now packaged as `pullbackPushforward_unit_comp`.
- **Localisation-of-localisation `IsLocalizedModule`:** `IsBaseChange.comp` via `isLocalizedModule_iff_isBaseChange`
  (compose the two localisation base changes) — a packaged route exists.
- **Free-module descent across a ring iso of localisations:** `Module.Basis.mapCoeffs σ.symm` +
  `LinearEquiv.extendScalarsOfIsLocalization` + `Module.Free.of_equiv'`; the double-`LocalizedModule`
  carrier's `Module A D` auto-resolves (no manual `restrictScalars`).
- **Anti-pattern (do not repeat):** bridging an `OreLocalization` instance-presentation diamond at the
  *consumer* site (the IH/helper application) — it is irreducible at available transparency. Fix at the
  *producer* (align emitted instances) instead.
