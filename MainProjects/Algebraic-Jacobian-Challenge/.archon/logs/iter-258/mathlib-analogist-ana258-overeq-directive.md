# mathlib-analogist ana258-overeq

## Mode: api-alignment

## Question
We need to build NEW project infrastructure:

```
SheafOfModules.overEquivalence (X : Scheme.{u}) (U : X.Opens) :
  SheafOfModules ((U : Scheme).ringCatSheaf)  ≌  SheafOfModules (X.ringCatSheaf.over U)
```

i.e. the **modules-level lift** of the site equivalence
`Opens.overEquivalence U : Over U ≌ Opens ↥U` (`Mathlib.Topology.Sheaves.Over`), where the
structure **ring sheaf is also transported** (the base ring varies between the two sides:
`(↑U).ringCatSheaf` vs `X.ringCatSheaf.over U`). Under it we need:
- `overEquivalence X U (M.restrict U.ι) ≅ M.over U`  (for `M : X.Modules`), and
- `overEquivalence X U (unit _) ≅ unit _`.

This is the shared root of two open obligations (verified by two independent prover sessions):
- engine `chartOverIso : M.over U ≅ unit (X.ringCatSheaf.over U)` (`LineBundleCoherence.lean`);
- dual `sliceDualTransport`/`exists_tensorObj_inverse` (`TensorObjSubstrate/DualInverse.lean`).

The project already has the **fixed-value-category, Sheaf-of-Ab** version
`overSliceSheafEquiv` (`AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv`, in
`Picard/TensorObjSubstrate.lean`), built via `Functor.IsDenseSubsite.sheafEquiv` over
`Opens.overEquivalence U`. It is INAPPLICABLE here because the ring varies (modules, not a fixed
target category).

## What I need from you (api-alignment)
1. **Does Mathlib already have a "sheaf-of-modules equivalence induced by a site equivalence +
   ring-sheaf identification" primitive** we should mirror, rather than building a parallel API?
   Candidates flagged by the prover: `pushforwardPushforwardEquivalence`
   (`Mathlib/.../ModuleCat/Sheaf/...Quasicoherent.lean` ~L370, used by `QuasicoherentData.bind`);
   `SheafOfModules.pushforward` along a continuous functor
   (`Mathlib/Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean`);
   `Functor.IsDenseSubsite.sheafEquiv` (the one `overSliceSheafEquiv` uses, but at fixed value cat).
   Identify the canonical Mathlib idiom for "equivalence of module-sheaf categories from an
   equivalence of sites + an iso of the two structure ring sheaves."
2. **Is the right shape a full `Equivalence`, or a bare functor iso / a `pushforward`-along-the-
   equivalence that is an iso?** The two consumers only need the action on `restrict ↦ over` and
   `unit ↦ unit` — would a narrower `restrictOverIso`/natural-iso suffice and be much cheaper than a
   full categorical equivalence? Recommend the MINIMAL shape that serves both consumers.
3. **Concrete construction skeleton**: the ordered list of Mathlib primitives to compose (with
   file:line where you can confirm them), the ring-sheaf identification step
   (`(↑U).ringCatSheaf ≅ X.ringCatSheaf.over U` transport + `restrictScalars` reconcile), and the
   pseudofunctor-coherence obligations (`Over.mapId`/`mapComp`) — noting which are killed by
   thinness of `Opens` (`Subsingleton.elim`) vs which carry real module content.
4. **Feasibility / blast-radius**: is this genuinely ~200–350 LOC, or does a Mathlib primitive
   collapse it? Any PROCEED vs ALIGN verdict on the proposed `SheafOfModules.overEquivalence` shape.

Write the persistent rationale to `analogies/overeq258.md` and the report to task_results.
Confirm every Mathlib name with `lean_loogle`/`lean_local_search`/`lean_hover_info` (file:line);
flag any you could not confirm as `[unconfirmed]`. Note: informal agent (kimi) is DOWN — rely on
Mathlib source + the LSP only.
