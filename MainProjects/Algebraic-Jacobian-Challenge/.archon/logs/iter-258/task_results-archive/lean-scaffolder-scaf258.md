# lean-scaffolder scaf258 — Report

## Outcome: SUCCESS — file compiles, 0 errors

**File created**: `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`

## LSP verification

```
Errors:    0
Warnings:  3 × "declaration uses `sorry`" (expected — one per sorry stub)
           2 × line-length style linter (lines 73, 96 in strategy comments; non-blocking)
```

`chartOverIso` compiled **without sorry** — its one-liner body
`(restrictOverIso U M).symm ≪≫ (overEquivalence U).functor.mapIso e ≪≫ unitOverIso U`
typechecks against the sorry stubs' declared types.

## Final signatures

All 4 declarations live in `namespace AlgebraicGeometry.Scheme.Modules` under
`variable {X : Scheme.{u}} (U : X.Opens)`.

```lean
noncomputable def overEquivalence :
    SheafOfModules ((↑U : Scheme).ringCatSheaf) ≌ SheafOfModules (X.ringCatSheaf.over U) :=
  sorry

noncomputable def restrictOverIso (M : X.Modules) :
    (overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U :=
  sorry

noncomputable def unitOverIso :
    (overEquivalence U).functor.obj (SheafOfModules.unit (↑U : Scheme).ringCatSheaf) ≅
    SheafOfModules.unit (X.ringCatSheaf.over U) :=
  sorry

noncomputable def chartOverIso (M : X.Modules)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (↑U : Scheme).ringCatSheaf) :
    M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U) :=
  (restrictOverIso U M).symm ≪≫ (overEquivalence U).functor.mapIso e ≪≫ unitOverIso U
```

## Signature adjustments vs directive

None. All four signatures match the directive exactly.

## Imports used

```lean
import Mathlib
import AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial
```

`Mathlib` supplies: `SheafOfModules`, `Scheme`, `Scheme.Opens`, `Scheme.ringCatSheaf`,
`SheafOfModules.over`, `SheafOfModules.unit`, `Scheme.restrict`, `Sheaf.over`,
`pushforwardPushforwardEquivalence` (strategy reference), `Iso.trans` (`≪≫`), `Functor.mapIso`.
`Vestigial` supplies: `overEquivInverseIsDenseSubsite` in scope for eventual proof bodies.

## Strategy comments

Rich `/- Planner strategy: ... -/` blocks are placed above each stub:

- **`overEquivalence`**: Steps 1–4 from `analogies/overeq258.md` quoted verbatim —
  continuity (free via `overEquivInverseIsDenseSubsite` + DenseSubsite→IsContinuous chain),
  ring morphism φ construction from `(U.ι.appIso V.left).inv` mirroring `restrictFunctor`,
  coherences H₁/H₂ via `Sheaf.hom_ext` + `appIso` round-trips, and
  `pushforwardPushforwardEquivalence e φ ψ H₁ H₂` assembly.

- **`restrictOverIso`**: Step 5 — `pushforwardComp = Iso.refl` + `pushforwardNatIso` along
  `eqToIso` of `V ↦ V.left` equality; verbatim mirror of `restrictFunctorAdjCounitIso`
  at `AlgebraicGeometry/Modules/Sheaf.lean:335–340`.

- **`unitOverIso`**: Step 6 — `pushforward φ (unit R) ≅ unit S` since φ is the open-immersion
  structure-sheaf identification.

- **`chartOverIso`**: Step 7 — three-step composite; redirects to this declaration next iter.

## Next steps (not this iter)

- Prover: fill `overEquivalence` body via `pushforwardPushforwardEquivalence`
  (`PushforwardContinuous.lean:305`).
- Consumer wiring (next iter): redirect `LineBundleCoherence.chartOverIso` to
  `Scheme.Modules.chartOverIso` (drops last sorry in the coherence engine).
- No other file was edited this iter.
