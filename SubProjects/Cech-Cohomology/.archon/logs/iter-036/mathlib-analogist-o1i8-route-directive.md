# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
o1i8-route

## Design question
Given Mathlib's (recently surveyed) quasi-coherent / `tilde` machinery, what is the
SHORTEST Mathlib-aligned path to the project's load-bearing 01I8 goal

    `[SheafOfModules.IsQuasicoherent F] → IsIso F.fromTildeΓ`   on an affine `Spec R`

and does that machinery let the project DROP or SHORTCUT any of its hand-rolled
"Route P" sub-steps (P1a affine-restriction, P2 global-generation, P3 kernel-qcoh,
and the `tildePreservesFiniteLimits` exactness build)?

Concretely, answer three sub-questions:

1. **Reduction shape.** By `isIso_fromTildeΓ_iff` (Tilde.lean:340) and
   `isIso_fromTildeΓ_of_presentation` (Tilde.lean:398), the goal is equivalent to:
   *every quasi-coherent `F` on `Spec R` admits a GLOBAL `SheafOfModules.Presentation F`*
   (Mathlib's `IsQuasicoherent` only gives LOCAL `QuasicoherentData` — presentations on a
   cover). Is there ANY Mathlib path (e.g. `QuasicoherentData.bind`, `GeneratingSections`
   on the trivial affine cover, `Presentation.map`, the fully-faithful left adjoint
   `tilde.fullyFaithfulFunctor`) that produces a global `Presentation` from local data on
   an affine, OR is the local→global step genuinely the project's to build (Serre /
   Stacks 01I8 / Hartshorne II.5.5)?

2. **Is `tildePreservesFiniteLimits` (= `~` exact / preserves kernels) still needed,
   and is its claimed blocker false?** The TildeExactness prover stopped claiming
   "`Scheme.Modules.toSheaf` does not exist, so the jointly-reflecting-on-sheaves route is
   blocked." But `SheafOfModules.toSheaf` DOES exist
   (`Mathlib/Algebra/Category/ModuleCat/Sheaf.lean:89`), with
   `PreservesFiniteLimits (SheafOfModules.toSheaf R)`
   (`.../Sheaf/Limits.lean:118`) and `(forget R).ReflectsIsomorphisms`
   (`.../Sheaf.lean:80`); `toSheaf` is faithful (`.../Sheaf.lean:113`). Confirm whether
   `SheafOfModules.toSheaf` (preserves finite limits + reflects isos via
   `reflectsLimitsOfShape_of_reflectsIsomorphisms`) discharges
   `tildePreservesFiniteLimits` through the chain
   `preservesLimitOfReflectsOfPreserves` applied to `tilde ⋙ toSheaf`, with the per-stalk
   piece coming from `(tilde M).toStalk` being `IsLocalizedModule` (Tilde.lean:132) and
   TopCat sheaf stalks jointly reflecting isos. Give the precise lemma chain. Separately:
   does the global-`Presentation` reduction (sub-q 1) even REQUIRE
   `tildePreservesFiniteLimits`, or does `presentationTilde`/`isIso_fromTildeΓ_of_presentation`
   make P3/exactness unnecessary?

3. **Is the project's P1a (`QcohRestrictBasicOpen`: `F|_{D(f)} ≅ ~M_f` via
   `Scheme.Modules.restrict` + `basicOpenIsoSpecAway`) on the right path?** Its L2
   `tilde_restrict_basicOpen` is blocked on a tilde-base-change compatibility absent from
   Mathlib. If the global-`Presentation` route (sub-q 1) reaches 01I8 WITHOUT needing
   per-`D(f)` localized sections, P1a may be droppable. Tell me whether P1a is on the
   critical path to a global `Presentation`, or a detour.

## Project artifact(s) under question
- `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — conditional 01I8 forms
  (`qcoh_iso_tilde_sections` under `[IsIso F.fromTildeΓ]`, presentation form) + the
  unconditional goal the whole lane targets.
- `AlgebraicJacobian/Cohomology/TildeExactness.lean` — the `tildePreservesFiniteLimits`
  build (sub-step A done: `stalkMapₗ`/`stalkMapₗ_eq`/`stalkMapₗ_injective`); named target
  absent, claimed blocked on "no toSheaf".
- `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` — P1a L1 done
  (`modulesRestrictBasicOpen`/`…Iso`); L2 `tilde_restrict_basicOpen` absent (tilde
  base-change gap).
- STRATEGY.md "01I8 Route P" row + Open-question P0–P4 chain.

## Why now
The 01I8 globalization is the dominant remaining cost (STRATEGY est. ~4–6 iters) and gates
BOTH the unconditional `qcoh_iso_tilde_sections` AND the 02KG top affine-vanishing theorem.
Two of its sub-builds (`tilde_restrict_basicOpen`, `tildePreservesFiniteLimits`) just hit
"absent from Mathlib / multi-hundred-LOC" walls — but I just discovered Mathlib has a full
`SheafOfModules.IsQuasicoherent`/`Presentation`/`QuasicoherentData` layer and a `tilde`
adjunction with `isIso_fromTildeΓ_of_presentation` already proven. Before I re-dispatch
provers into those walls, I need to know the shortest Mathlib-aligned route and which
sub-builds are genuinely needed.

## Hints
- `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`: `tilde.functor`/`tilde.adjunction`
  (line 279, fully-faithful left adjoint, `IsIso unit`), `isIso_fromTildeΓ_iff` (340),
  `presentationTilde` (373), `(tilde M).IsQuasicoherent` (394),
  `isIso_fromTildeΓ_of_presentation` (398), `tildeFinsupp`/`tildeSelf`,
  `toStalk … IsLocalizedModule` (132), `isIso_toOpen_top` (171).
- `Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`: `Presentation` (44),
  `QuasicoherentData` (201), `QuasicoherentData.bind` (360), `IsQuasicoherent` (249),
  `Presentation.isQuasicoherent`, `generatorsOfIsCokernelFree`,
  `Presentation.map` (179), `localGeneratorsData`.
- `Mathlib/Algebra/Category/ModuleCat/Sheaf/Generators.lean`: `GeneratingSections`,
  `LocalGeneratorsData`, `IsFiniteType` (read to see if "globally generated on affine"
  is expressible).
- `Mathlib/Algebra/Category/ModuleCat/Sheaf.lean`: `toSheaf` (89), `forget`
  `ReflectsIsomorphisms` (80), `toSheaf` faithful (113).
- `Mathlib/Algebra/Category/ModuleCat/Sheaf/Limits.lean`: `PreservesFiniteLimits toSheaf`
  (118).
- `Mathlib/CategoryTheory/Limits/Preserves/...`: `preservesLimitOfReflectsOfPreserves`,
  `reflectsLimitsOfShape_of_reflectsIsomorphisms`.
- Reference: `references/stacks-schemes.tex` (Stacks 01HV / 01I8); the math is
  Hartshorne II.5.5 (qcoh on affine ⟺ `~M`).

## Severity expectation
high-stakes — this design choice steers the project's largest remaining lane.
