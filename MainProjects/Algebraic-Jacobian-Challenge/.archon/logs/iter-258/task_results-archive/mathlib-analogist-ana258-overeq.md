# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ana258-overeq

## Iteration
258

## Question
Build `SheafOfModules.overEquivalence X U : SheafOfModules (↑U).ringCatSheaf ≌
SheafOfModules (X.ringCatSheaf.over U)` (modules-level lift of `Opens.overEquivalence U` with the
structure ring sheaf transported). (1) Does Mathlib already have a "sheaf-of-modules equivalence from
a site equivalence + ring-sheaf identification" primitive to mirror? (2) Full `Equivalence` or a
narrower functor/iso? (3) Concrete construction skeleton. (4) Feasibility / blast-radius.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Mirror Mathlib primitive vs. hand-roll a parallel equivalence | ALIGN_WITH_MATHLIB | major (proposal-stage) |
| 2. Full `Equivalence` vs. bare functor + 2 isos (minimal consumer shape) | PROCEED | informational |
| 3. Continuity prerequisites (the apparent blocker) | PROCEED — already in project | informational |

## Major

**Decision 1 — use `SheafOfModules.pushforwardPushforwardEquivalence`, do NOT hand-roll.**
Mathlib's `SheafOfModules.pushforwardPushforwardEquivalence`
(`Mathlib/Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean:305`, the whole `section
Equivalence` L289–329) is *exactly* "equivalence of `SheafOfModules` categories from a site
equivalence `eqv : C ≌ D` + a morphism of the two (DIFFERENT) structure ring sheaves `φ : S ⟶
pushforward R`, `ψ`, and coherences `H₁ H₂`". The base ring genuinely varies (`S : Sheaf J RingCat`,
`R : Sheaf K RingCat`) — so it serves the modules-with-varying-ring case that the project's
fixed-value-category `overSliceSheafEquiv` (`Vestigial.lean:715`, via
`Functor.IsDenseSubsite.sheafEquiv`) cannot. This is the Joël-Riou primitive used by
`QuasicoherentData.bind`. Building a fresh by-hand equivalence would duplicate ~150+ LOC of
unit/counit/coherence Mathlib already ships and fork the module-over-site API.

## Informational

**Decision 3 — the continuity prerequisites are already discharged by the project.**
`pushforwardPushforwardEquivalence` needs `[IsContinuous eqv.functor J K]` and
`[IsContinuous eqv.inverse K J]`. With `eqv := Opens.overEquivalence U`:
- `IsDenseSubsite ⇒ IsContinuous` is a `priority 900` instance
  (`Sites/DenseSubsite/Basic.lean:548`);
- `[e.inverse.IsDenseSubsite K J] ⇒ instance e.functor.IsDenseSubsite J K` is automatic for an
  equivalence (`Sites/Equivalence.lean:106-108`);
- the project's `overEquivInverseIsDenseSubsite` (`Vestigial.lean:689`) IS exactly
  `(overEquivalence U).inverse.IsDenseSubsite (gt ↥U) ((gt X).over U) = e.inverse.IsDenseSubsite K J`.

So BOTH continuity legs resolve by inference — the `Topology/Sheaves/Over.lean:19-22` TODO that the
`informal/chartOverIso.md` note treats as the wall is, for this slice case, already satisfied. The
belief "this is Mathlib-scale / the legs' continuity is missing" is RETRACTED for this construction.

**Decision 2 — minimal shape.** Both consumers (`chartOverIso`, `sliceDualTransport`) use only
`overEquivalence.functor` applied to an iso plus two object isos (`restrict ↦ over`, `unit ↦ unit`);
neither touches `.inverse`/unit/counit. So a bare functor `restrictOverFunctor := pushforward φ` +
those two isos is a strictly cheaper sufficient shape (skips `ψ`, `H₁`, `H₂`). Recommend the **full**
equivalence anyway (it is the documented canonical idiom and only marginally more, since continuity is
free), with the functor-only `restrictOverIso` as a documented fallback if `ψ`/`H₁`/`H₂` resist.

### Construction skeleton (all names confirmed by source read; file:line)

`e := TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U` (`Topology/Sheaves/Over.lean:41`),
`C=Over U` (`J=(Opens.grothendieckTopology X).over U`), `D=Opens ↥U` (`K=Opens.grothendieckTopology ↥U`),
`R=(↑U).ringCatSheaf`, `S=X.ringCatSheaf.over U`. Then `pushforward φ : SheafOfModules R ⥤ SheafOfModules S`
has exactly the directive's orientation.

1. **Continuity** — free (Decision 3).
2. **`φ` (the real content, RING-level)**: `X.ringCatSheaf.over U ⟶
   (e.functor.sheafPushforwardContinuous RingCat J K).obj (↑U).ringCatSheaf`; sectionwise at `V : Over U`
   it is `O_X(V.left) ⟶ O_{↥U}(e.functor V)`, the open-immersion structure-sheaf iso. Build from
   `U.ι.appIso` / `(U.ι.appIso _).inv` — the SAME datum `Scheme.Modules.restrictFunctor` uses inline
   (`AlgebraicGeometry/Modules/Sheaf.lean:320`). `ψ` symmetric. `Scheme.ringCatSheaf` =
   `sheafCompose (forget₂ CommRingCat RingCat) X.sheaf` (`AlgebraicGeometry/Modules/Presheaf.lean:34`).
3. **`H₁`,`H₂`**: ring-presheaf nat-trans equalities; naturality on the thin poset is free, the hom
   equalities follow from `φ`/`ψ` being mutual inverses via the `appIso` round-trip (`Sheaf.hom_ext`/`ext`).
   Skippable in the functor-only shape.
4. `overEquivalence X U := SheafOfModules.pushforwardPushforwardEquivalence e φ ψ H₁ H₂`.
5. **Iso (A) `restrict ↦ over`**: `M.restrict U.ι` is itself `pushforward` along `U.ι.opensFunctor`
   (`Sheaf.lean:319-322`); compose with `pushforward φ` via `SheafOfModules.pushforwardComp`
   (`PushforwardContinuous.lean:101`, `= Iso.refl _`), then `pushforwardNatIso` (`:188`) along the
   `eqToIso` nat-iso of the two underlying `Over U ⥤ Opens X` functors (both `V ↦ V.left`). **Verbatim
   mirror of `restrictFunctorAdjCounitIso`** (`Sheaf.lean:335-340`).
6. **Iso (B) `unit ↦ unit`**: `pushforward`-of-unit computation up to `φ` (cf. existing
   `pullbackObjUnitToUnitIso` pattern).
7. `chartOverIso M U e := (A).symm ≪≫ overEquivalence.functor.mapIso e ≪≫ (B)`; the dual lane's
   `sliceDualTransport` consumes the same three pieces.

### Feasibility / blast-radius

**~120–220 LOC, standalone file — NOT the ~200–350 "Mathlib-scale" estimate in `informal/chartOverIso.md`.**
The collapse: continuity is already done (project's dense-subsite instance + Mathlib auto-instance), and
the only genuine content (`φ`) is the open-immersion structure-sheaf iso the project already writes
inline. Most of the file mirrors three existing decls (`restrictFunctor`, `restrictFunctorAdjCounitIso`,
`pushforwardPushforwardEquivalence`). Unblocks BOTH `chartOverIso` (LineBundleCoherence engine) and
`exists_tensorObj_inverse`/`sliceDualTransport` (DualInverse). **PROCEED** — assemble existing
primitives; this is neither a Mathlib gap-fill nor a parallel API.

### Names confirmed (source read)
- `SheafOfModules.pushforwardPushforwardEquivalence` — `PushforwardContinuous.lean:305` ✓
- `SheafOfModules.pushforward` — `PushforwardContinuous.lean:44` ✓
- `SheafOfModules.over` (abbrev, `= pushforward (𝟙 _)`) — `PushforwardContinuous.lean:53` ✓
- `SheafOfModules.pushforwardComp` (`= Iso.refl _`) — `PushforwardContinuous.lean:101` ✓
- `SheafOfModules.pushforwardNatIso` — `PushforwardContinuous.lean:188` ✓
- `TopologicalSpace.Opens.overEquivalence` — `Topology/Sheaves/Over.lean:41` ✓
- `Equivalence` auto `e.functor.IsDenseSubsite J K` from `[e.inverse.IsDenseSubsite K J]` —
  `Sites/Equivalence.lean:106-108` ✓
- `IsDenseSubsite ⇒ IsContinuous` (priority 900) — `Sites/DenseSubsite/Basic.lean:548` ✓
- `Scheme.Modules.restrictFunctor` / `restrict` / `restrictFunctorAdjCounitIso` —
  `AlgebraicGeometry/Modules/Sheaf.lean:319,325,335` ✓
- `Scheme.ringCatSheaf` — `AlgebraicGeometry/Modules/Presheaf.lean:34` ✓
- `Sheaf.over` / `GrothendieckTopology.over` — `Sites/Over.lean:429,210` ✓
- project `overEquivInverseIsDenseSubsite` — `Vestigial.lean:689` ✓
- (no `[unconfirmed]` names)

## Persistent file
- `analogies/overeq258.md` — full decision/skeleton rationale for future iters.

Overall verdict: ALIGN_WITH_MATHLIB — build `overEquivalence` as
`SheafOfModules.pushforwardPushforwardEquivalence` at `Opens.overEquivalence U`; continuity is already
in the project, only the open-immersion ring iso `φ` is genuine work, ~120–220 LOC, unblocks both lanes.
