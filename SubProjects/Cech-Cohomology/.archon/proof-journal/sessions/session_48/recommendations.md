# Recommendations — for the iter-049 plan agent

## Headline: 01I8 is CLOSED — `qcoh_iso_tilde_sections` is now unconditional
The Route B section-localization program (iters 040→048) is complete. The downstream cone
that gated on the unconditional quasi-coherent `qcoh_iso_tilde_sections` is now open. This is
the moment to **fan out parallel lanes** — the single-critical-path discipline that held
through the keystone build no longer applies.

## Now-ready frontier nodes (prioritize)
`archon dag-query frontier` returns 4 ready nodes. In rough priority / dependency order:

1. **`lem:cech_augmented_resolution` / `cechAugmented_exact`** (effort_local ~1054) — the
   DIRECT beneficiary of 01I8: its `\uses{lem:qcoh_iso_tilde_sections}` gate (the
   frontier-honesty gate installed iter-043) just cleared. Highest-value next lane.
2. **`lem:affine_cech_vanishing_qcoh` / `affine_cech_vanishing_qcoh`** (effort_local ~925,
   effort_total ~2788) — a 02KG vanishing top. Higher total effort (it pulls a sub-cone);
   consider an effort-breaker pass if the prover stalls.
3. **`lem:tilde_restrict_basicOpen` / `tilde_restrict_basicOpen`** (effort_local ~704) —
   Route-P / restriction asset; independent, parallelizable.
4. **`lem:cech_free_eval_prepend_homotopy`** (effort_local ~739) — no standalone `\lean{}`
   pin (transported from the engine complex, per the iter-048 planner note); confirm it is a
   genuine prover target before dispatching, or it is a structural transport, not a lane.

These (1)+(3) (and possibly (4)) are genuinely independent — open ≥2 lanes this iter.

## Blueprint cleanups for the planner (MEDIUM/LOW — `\uses{}` is planner-domain, not review's)
From `lean-vs-blueprint-checker iter048-qts` (no correctness issue; all minor):
- **`lem:qcoh_isIso_fromTildeGamma` `\uses{}` has 2 stale entries.** The Lean proof uses
  `SpecModulesToSheafFullyFaithful` + `IsCoverDense.iso_of_restrict_iso`, NOT the cited
  Mathlib anchors. Drop / correct: `lem:isIso_fromTildeGamma_iff_mathlib` (never invoked;
  only a parenthetical equivalence remark) and `lem:forget_reflectsIso_mathlib` (replaced by
  `SpecModulesToSheafFullyFaithful`). Consider adding a Mathlib anchor naming
  `SpecModulesToSheafFullyFaithful` / `Functor.IsCoverDense.iso_of_restrict_iso` instead.
- The proof-sketch prose cites `SheafOfModules.fullyFaithfulForget`; the Lean uses
  `SpecModulesToSheafFullyFaithful`. Align the prose name. (Minor.)

## Coverage debt (review handled the lightweight part)
- Review **bundled** `isIso_fromTildeΓ_app_basicOpen` into the `\lean{}` of
  `lem:qcoh_isIso_fromTildeGamma` (it is that lemma's component step). The next `sync_leanok` /
  `dag-query unmatched` should then show only the pre-existing dead `CechAcyclic.affine`.
- **`CechAcyclic.affine`** (`CechAcyclic.lean:110`) remains `unmatched` + sorry-bodied and dead
  (the iter-040+ re-parameterization superseded it; the cover-agnostic `injective_cech_acyclic`
  is the live path). Recommend the planner formally retire/delete it or give it a blueprint
  node — it has lingered as the sole pre-existing unmatched node for many iters.

## Do NOT
- Do not re-open `QcohTildeSections.lean` for the 01I8 route — it is 0-sorry and the route is
  closed. Any further work there is downstream consumers in OTHER files.
- Do not treat the single-critical-path constraint as still binding; it was a property of the
  pre-01I8 keystone chain, now dissolved.

## Reusable proof patterns discovered (also in Knowledge Base)
- **Sheaf-of-modules morphism iso via basis check:** reflect through a fully faithful forget
  (`…FullyFaithful.isIso_of_isIso_map`, guarded by `suffices … from` to avoid eager synthesis),
  then `Functor.IsCoverDense.iso_of_restrict_iso` over `inducedFunctor` on the basis +
  `NatIso.isIso_of_isIso_app`. Provide the cover-dense / app-iso hypotheses via `haveI`, never
  `apply`. Pin the basis functor's codomain to the sheaf's actual `Opens` space (project abbrev
  `specBasicOpen`, not bare `PrimeSpectrum.basicOpen`) for Grothendieck-topology unification.
  `TopCat.Sheaf` morphisms project via `.hom` (not `.val`); whisker via `G.op.whiskerLeft`.
- **Two-localization component is the canonical equiv:** when a map `c` between two
  `IsLocalizedModule (powers r)` localizations of the same module satisfies the localization
  triangle, `c = IsLocalizedModule.linearEquiv …` (via `IsLocalizedModule.ext` + `map_units`),
  hence bijective ⟹ iso by `ConcreteCategory.isIso_iff_bijective`.
  (`linearEquiv_of_isLocalizedModule_comp` does NOT exist — loogle false positive.)
