Done. The module is landed and green.

## What was created

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardAffineDescent.lean` (441 lines), the only file touched. No commit made.

**Declarations (6, all public, all with `/-- … -/` docstrings):**

```
theorem AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_moduleSpecΓFunctor_map
    {R : CommRingCat.{u}} {M N : (Spec R).Modules} [M.IsQuasicoherent] [N.IsQuasicoherent]
    (φ : M ⟶ N) (h : IsIso ((moduleSpecΓFunctor (R := R)).map φ)) : IsIso φ

theorem AlgebraicGeometry.Scheme.Modules.isIso_of_bijective_appTop
    {R : CommRingCat.{u}} {M N : (Spec R).Modules} [M.IsQuasicoherent] [N.IsQuasicoherent]
    (φ : M ⟶ N) (h : Function.Bijective (Scheme.Modules.Hom.app φ (⊤ : (Spec R).Opens))) : IsIso φ

theorem AlgebraicGeometry.isIso_pushforwardBaseChangeMap_appTop_of_bijective
    (f : X ⟶ Y) (g : Y' ⟶ Y) (f' : X' ⟶ Y') (g' : X' ⟶ X) (comm : g' ≫ f = f' ≫ g)
    [IsAffine Y] [IsAffine Y'] (F : X.Modules) [((Modules.pushforward f).obj F).IsQuasicoherent]
    (e' : …) (s : … →+ …) (hs : … b ⊗ₜ x ↦ b • baseMap x) (hbij : Function.Bijective s) :
    IsIso (Scheme.Modules.Hom.app (pushforwardBaseChangeMap f g f' g' comm F) (⊤ : Y'.Opens))

theorem AlgebraicGeometry.isIso_pushforwardBaseChangeMap_of_bijective_gamma
    (f : X ⟶ Y) (g : Spec R' ⟶ Y) (f' : X' ⟶ Spec R') (g' : X' ⟶ X) (comm : g' ≫ f = f' ≫ g)
    [IsAffine Y] [QuasiCompact f'] [QuasiSeparated f'] (F : X.Modules) [F.IsQuasicoherent]
    [((Modules.pushforward f).obj F).IsQuasicoherent] (e') (s) (hs) (hbij) :
    IsIso (pushforwardBaseChangeMap f g f' g' comm F)

def AlgebraicGeometry.Adelic.RigidPushforwardGammaBaseChange
    (C : Over (Spec (CommRingCat.of k))) (A : Type u) [CommRing A] [Algebra k A] : Prop

theorem AlgebraicGeometry.Adelic.rigidPushforwardBaseChange_of_gamma
    (C : Over (Spec (CommRingCat.of k))) [IsProper C.hom] (A : Type u) [CommRing A] [Algebra k A]
    (hgamma : RigidPushforwardGammaBaseChange C A) : Scheme.RigidPushforwardBaseChange C A
```

## Verification

`lake build AlgebraicJacobian.Picard.RigidPushforwardAffineDescent`, verbatim tail:

```
⚠ [8621/8638] Replayed AlgebraicJacobian.Picard.QuotFunctorDef
warning: AlgebraicJacobian/Picard/QuotFunctorDef.lean:458:8: declaration uses `sorry`
warning: AlgebraicJacobian/Picard/QuotFunctorDef.lean:690:8: declaration uses `sorry`
⚠ [8626/8638] Replayed AlgebraicJacobian.RiemannRoch.WeilDivisor
warning: AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:1161:8: declaration uses `sorry`
⚠ [8631/8638] Replayed AlgebraicJacobian.Albanese.CodimOneExtension
warning: AlgebraicJacobian/Albanese/CodimOneExtension.lean:1691:8: declaration uses `sorry`
✔ [8638/8638] Built AlgebraicJacobian.Picard.RigidPushforwardAffineDescent (64s)
Build completed successfully (8638 jobs).
EXIT=0
```

The new module is `✔`, not `⚠` — zero warnings of its own (no docBlame, no lineLength, no unusedTactic, no unused section variables). The four `warning: … declaration uses 'sorry'` lines are **replayed cached logs of pre-existing dependency modules** (`QuotFunctorDef`, `WeilDivisor`, `CodimOneExtension`), untouched by me.

`#print axioms` on all six public declarations (`/tmp/ajc-afdesc-axioms.lean`, via `lake env lean`):

```
'AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_moduleSpecΓFunctor_map' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Scheme.Modules.isIso_of_bijective_appTop' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.isIso_pushforwardBaseChangeMap_appTop_of_bijective' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.isIso_pushforwardBaseChangeMap_of_bijective_gamma' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.RigidPushforwardGammaBaseChange' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.rigidPushforwardBaseChange_of_gamma' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## Fidelity

- **Zero proof-body changes.** A mechanical `diff` of the harvested region against source lines 25–281 shows *only* added `--` justification comments and extended docstrings; every statement and every tactic byte is identical to the probe's.
- **§5 discarded, confirmed.** `grep -c GammaLeafTodo` = 0; the file greps clean for `sorry`, `axiom`, `admit`, `native_decide` (exit 1). The two discarded signatures survive only as prose + a fenced code block in the module docstring (deliberately without `:= sorry`, so the file stays grep-clean).
- **Nothing the linters forced.** No lint fixes were needed.
- **Imports trimmed as instructed:** kept `RigidPushforwardTransfer` and `Cohomology.PullbackQuasicoherent`; dropped `RigidPushforwardFiberChart` and `RigidPushforwardP1Engine`, which only §5 needed (§5's `f.baseSectionsModule` lives in `P1Engine`). The green build confirms §1–§4 need neither. `Mathlib` still arrives via `RigidPushforwardTransfer`.
- **`set_option` lines preserved** per declaration, each with a one-line `--` justification above it, matching the style in `Cohomology/CechTermAcyclic.lean`.

## Docstring content

Written after reading both `RigidPushforwardGate.lean` ("Caveat on the `baseChange` field") and `RigidPushforwardFrontier.lean` (item 3). It records the four-step reduction, and honestly: (a) the non-Beck–Chevalley caveat for §2/§3 — stated both in the module docstring and on the two declarations, phrased as "all the content of a base-change theorem still sits in `hbij`, which without a cartesian square has no reason to hold"; (b) that `RigidPushforwardGammaBaseChange` is **not** proved here, with the probe's four-part route (`(p1BaseChangeCoverSquare A).preimage π_A` + `moduleSectionDiff_pushforward` being `rfl`; `bijective_kerBaseChange_of_surjective` + `globalSectionsEquivKerModuleSectionDiffBase`; the missing arbitrary-affine-base-change Čech square with both intended signatures reproduced; and the **dependency warning** that this route puts `baseChange` downstream of the `IsIntegral (ℙ¹_k)` leaf because it needs global surjectivity of `d`); (c) the vacuity audit.

All cross-file line numbers cited in the docstring were verified against the current tree (`RigidPushforward.lean:342/373`, `Transfer.lean:577/828/949/1108`, `QuotScheme.lean:2693/4611`, `TwoTermFiniteFree.lean:392`, `P1Engine.lean:287`).

One operational note for the caller: the first two build attempts each burned ~40 min and were killed by their own `timeout` **without ever reaching the module** — they were blocked behind other lanes' `lake` invocations. Once through, the module itself elaborates in 64s. A `timeout 1800` is not enough under concurrency; the useful signal is the `✔ … (64s)` line.
