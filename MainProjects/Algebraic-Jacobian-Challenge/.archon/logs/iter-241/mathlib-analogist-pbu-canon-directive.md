# mathlib-analogist directive — iter-241

## Mode: api-alignment

## The declaration / situation
The project is building, on the critical path, the isomorphism `pullbackUnitIso : f^*𝒪_X ≅ 𝒪_Y` for a
general morphism of schemes `f : Y → X` (file `Picard/TensorObjSubstrate.lean`, "Route Z" local-chart
finality). The comparison map is the Mathlib morphism
`AlgebraicGeometry.Scheme.Modules` wrapper over `SheafOfModules.pullbackObjUnitToUnit f`
(abbreviated `pbu φ` below), the unit comparison of the left adjoint `f^*` on `SheafOfModules`.

Mathlib provides `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` — `IsIso (pbu φ)` when the
comparison functor is `Final`. The project proved, axiom-clean this iter, the composition coherence
`pullbackObjUnitToUnit_comp` (an adjunction-mate transport):
`pbu(h ; f) = (pullbackComp h f).inv ; (pullback h).map (pbu f) ; pbu h`.

## The problem we hit (concrete)
Inside a per-chart lemma with several `Final`/`IsIso` hypotheses in context, `infer_instance` FAILS to
synthesize `IsIso (pbu U.ι)`, `IsIso (pbu g)`, and even `IsIso ((pullbackComp g U.ι).inv.app _)` —
**all of which synthesize FINE standalone** (verified). Diagnosis from the prover:
`SheafOfModules.pullbackObjUnitToUnit φ` carries non-canonical implicit instance args
(`[(pushforward φ).IsRightAdjoint]`, `[F.IsContinuous]`); after `rw [pullbackObjUnitToUnit_comp …]` the
produced `pbu`/`pullbackComp` subterms bind those implicits to forms that the in-scope
`(Opens.map _).Final` haves + the `OfFinal` instance no longer match, and a pre-established `haveI` copy
matches the head but fails unification (blocking backtracking).

## Questions (api-alignment)
1. **Is `SheafOfModules.pullbackObjUnitToUnit`'s instance-shape canonical, or is the project fighting a
   design mismatch?** Specifically: do Mathlib's analogous adjunction-mate `IsIso` facts (e.g. monoidal
   functor unit/counit comparison `IsIso` lemmas, `Functor.Monoidal`/`OplaxMonoidal` `μ`/`δ` iso
   instances, `Adjunction` unit/counit `isIso_unit`/`isIso_counit` chains) state their `IsIso` with the
   same kind of buried `[IsRightAdjoint]`/`[IsContinuous]` implicits, and do they hit the same
   in-context synthesis failure? Find the closest Mathlib precedent for "an adjunction-mate comparison
   map that is iso under a finality/flatness hypothesis, used as a COMPONENT inside an `IsIso`
   composition proof".
2. **What is the canonical Mathlib idiom for transporting `IsIso` across a coherence equation like
   `pbu(h;f) = … ; … ; …` without re-triggering instance synthesis on the components?** Is it
   `asIso` + explicit `Iso` construction, `IsIso.of_iso`/`IsIso.comp_isIso` with `@`-explicit instance
   args, a `@[instance] lemma` with the canonical implicit shape, or a `letI`/`haveI` ascription
   pattern? Cite where Mathlib does this.
3. **Critical for planning: will this instance-canonicity issue RECUR in Phase 2/3?** Phase 2 builds an
   analogous `pullbackObjTensorToTensor` comparison and proves it iso by the same finality chart-chase;
   Phase 3 composes `pullbackTensorIso⁻¹ ; f^*e ; pullbackUnitIso`. If `pbu`'s instance-shape is the
   root cause (not a one-time context accident), Phases 2/3 will hit the same wall. Tell us whether the
   shape is the bottleneck (→ a one-time signature/instance refactor of the comparison-map API is
   cheaper) or whether this is a local per-proof workaround (type-ascription) that does not propagate.

## Out of scope
- Do NOT propose changing the protected Jacobian signatures.
- Do NOT write Lean proof bodies; give the idiom + citations + a PROCEED/ALIGN verdict.
- The deferred dual-bridge material is irrelevant.

Write the persistent rationale to `analogies/pbu-canon.md` and the report to `task_results/`.
