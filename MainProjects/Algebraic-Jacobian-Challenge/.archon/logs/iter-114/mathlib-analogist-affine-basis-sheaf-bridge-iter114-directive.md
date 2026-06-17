# Mathlib Analogist Directive

## Slug
affine-basis-sheaf-bridge-iter114

## Design question

For an underlying *type-valued* presheaf `F : Opens X^op ⥤ Type u` on a scheme `X`, does Mathlib b80f227 expose an off-the-shelf API that converts "`F` satisfies a sheaf condition on the affine opens of `X` (or on a base of basic opens of each affine chart)" into "`F` is a sheaf in the Zariski topology on `X`"? Or — broader — is `Scheme.PresheafOfModules`-as-sheaf even the right *predicate* for the project's iter-113 unique-gluing route, or should the project shift to a different infrastructure (`SheafOfModules.{u}` / `Sheaf (Opens X)` / `Scheme.OpenCover`-indexed gluing) for the sheaf-condition closure of `Ω_{X/S}`?

This is the **load-bearing Mathlib-bridge** that has been cited as a `[gap]` across iter-110 / iter-112 / iter-113 reports without independent audit. Progress-critic-iter114 returned STUCK on the route and prescribed this consult as the primary corrective before any further prover dispatch on the route.

## Project artifact(s) under question

- `AlgebraicJacobian/Differentials.lean:127–175` — new top-level helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (iter-113 NEW; sorry-bodied; the load-bearing residual after the iter-113 unique-gluing pivot). Its docstring contains a concrete 3-step closure recipe (universal property of `KaehlerDifferential` + structure-sheaf gluing on `iSup U` + uniqueness via `KaehlerDifferential.span_range_derivation`).
- `AlgebraicJacobian/Differentials.lean:209–234` — helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (iter-112 NEW; iter-113 fully closed via Mathlib framework chain `isSheaf_of_isSheafUniqueGluing_types` → `IsSheaf.isSheafOpensLeCover`).
- `AlgebraicJacobian/Differentials.lean:245–284` — helper #2 + main theorem `relativeDifferentialsPresheaf_isSheaf` (forgetful Step 1 reduction; downstream of helper #1).
- `AlgebraicJacobian/Differentials.lean:59–62` — `relativeDifferentialsPresheaf` itself; built via `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'` on top of `TopCat.Presheaf.pullbackPushforwardAdjunction`.
- `blueprint/src/chapters/Differentials.tex:28–53` — chapter prose for the sheaf condition; pinned to Route (a) (refinement-cofinality against `isSheaf_iff_isSheafOpensLeCover`) with an explicit `[gap]` callout at L51 stating "No direct off-the-shelf `sheaf-on-affine-basis-of-a-Scheme ⇒ sheaf` theorem is currently in Mathlib for `Scheme.PresheafOfModules`".

## Context

The iter-113 prover used the `IsSheafUniqueGluing` form to reformulate the sheaf condition, then closed helper #1 via the Mathlib chain `isSheaf_of_isSheafUniqueGluing_types → IsSheaf.isSheafOpensLeCover`. This is a **framework reformulation** — the mathematical content (proving the unique-gluing existence/uniqueness for compatible families of Kähler differentials) is parked at L168 with the docstring's 3-step recipe.

The recipe's step (1) "compatibility ⇒ gluing on the structure-sheaf side" assumes the project can transfer a compatible family `sf : ∀ i, Ω_{X/S}(U i)` of Kähler differentials to compatible structure-sheaf sections (modulo identification), then use the sheaf property of `X.ringCatSheaf` to glue. The recurring blocker phrase is that **no Mathlib API directly transfers this from a basis (affine opens / basic opens of affine charts) to the full `Opens X` lattice on schemes**. The iter-113 blueprint-writer search and the iter-113 prover both confirmed they couldn't locate one.

Progress-critic-iter114 found this blocker has been cited verbatim across 3 of 4 audited iters without independent audit. The two prover-bearing iters (iter-112, iter-113) both delivered Bar B outcomes (one new sorry-bodied sub-helper) with self-classified "reformulation rather than genuine mathematical progress" framing for iter-113. The verdict is STUCK; the corrective is this consult.

Strategy-critic-iter114 verified `PresheafOfModules.DifferentialsConstruction.isUniversal'` [VERIFIED] and `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing_types` [VERIFIED] as Mathlib infrastructure the project may legitimately use; but did not audit whether a `Scheme.PresheafOfModules.IsSheaf.of_isSheaf_affineCover`-style bridge exists.

## Specific sub-questions

Please answer all four:

1. **Does Mathlib b80f227 have a `Scheme.PresheafOfModules.IsSheaf.of_isSheaf_affineCover` / `Scheme.AffineOpenCover`-keyed gluing API the project has missed?** Search names like `Scheme.PresheafOfModules.IsSheaf.{ofAffineCover, ofAffineBasis, ofOpenCover}`, `Scheme.AffineOpenCover.isSheaf`, `TopCat.Presheaf.isSheaf_of_isSheaf_on_basis`, `TopCat.SheafOnBasis`. List exhaustively what you find (or do not find).

2. **Is there a Mathlib API for sheaves-on-a-basis at the underlying-type-presheaf level?** Specifically: given `Opens.IsBasis (basisOpens)` (or `TopologicalSpace.IsTopologicalBasis`) and a sheaf-condition on the basis, does Mathlib package the conversion to a full sheaf on `Opens X` for `Type u`-valued presheaves? Search names like `TopCat.Presheaf.IsSheafOnOpens.toSheaf`, `Presheaf.IsSheafOnBasis`, `TopologicalSpace.Opens.IsBasis.isSheaf_iff`. Compare with what the project uses now (`isSheaf_iff_isSheafOpensLeCover` vs. `isSheaf_iff_isSheafUniqueGluing_types`).

3. **Is `Scheme.PresheafOfModules`-as-sheaf the right predicate?** The project routes through `(presheaf ⋙ forget AddCommGrpCat)` and proves `TopCat.Presheaf.IsSheaf` for `Type u`-valued presheaves; this is the `IsSheaf` predicate of the standard Grothendieck-topology presheaf-on-`Opens`. **Alternative**: `SheafOfModules.{u}` packages a sheaf-of-modules object directly via `Sheaf (Opens X) ⋯`-typeclass and supplies pullback/pushforward via `AlgebraicGeometry.Scheme.Modules.{pullback, pushforward}`. Could the project skip the type-level `IsSheaf` proof entirely by going through `SheafOfModules` or `Sheaf (Opens X) AddCommGrpCat` constructors that derive `IsSheaf` automatically from a different presentation (e.g. quasi-coherent setup, sheafification of a presheaf-of-modules)? Catalogue the closest Mathlib idiom for the same end-state (a quasi-coherent sheaf of `O_X`-modules on a scheme `X` whose affine-section description is `KaehlerDifferential`).

4. **What does Mathlib's existing `AlgebraicGeometry.Modules.tilde` do, exactly?** The iter-110 blueprint-writer mentioned `AlgebraicGeometry.tilde Ω_{B/A}` as the quasi-coherent module sheaf attached to `Ω_{B/A}` on `Spec B`. Verify the signature and check: does `tilde` + a Mathlib gluing-along-affine-cover lemma constitute a complete alternative route that bypasses both `isSheaf_iff_isSheafOpensLeCover` and `IsSheafUniqueGluing`? Specifically, search for `AlgebraicGeometry.{tilde, Tilde.isSheaf, Tilde.fromAffineCover, glueAffineSheaves}`. If `tilde`-via-cover-gluing is a complete route, the project should consider it as Route (d).

## Out of scope

- Do NOT audit the Mathlib b80f227 gap on `SheafOfModules.stalkFunctor` exactness (that's `instIsMonoidal_W`/`h_exact` territory, not the sheaf-condition territory).
- Do NOT audit the `serre_duality_genus` Mathlib gap (named-deferred per gap #7).
- Do NOT audit the `Smooth`-vs-`IsSmoothOfRelativeDimension`-vs-`IsStandardSmoothOfRelativeDimension` predicate landscape (separate question; not part of the sheaf-condition route).

## Expected output

Your report should:

- Answer all four sub-questions with concrete Mathlib names + module paths (verified via `lean_leansearch` / `lean_loogle`) or with "MISSING" verdicts.
- Render a top-level verdict on the iter-113 unique-gluing pivot: **PROCEED with iter-115+ closure** / **ALIGN WITH MATHLIB via Route (X) instead** / **DEFER — Mathlib gap is real, no workaround**.
- If "ALIGN WITH MATHLIB", give the planner a concrete recipe with named Mathlib lemmas to chain.
- Write a persistent `analogies/affine-basis-sheaf-bridge.md` summary that future iters can re-read.

The planner will act on your verdict in the iter-115 plan. If you return ALIGN WITH MATHLIB, the iter-114 blueprint-writer's prose will need a follow-up iter-115 revision (a non-blocker — the writer's iter-114 job is to land the iter-113 Lean state; the iter-115 follow-up revises the recipe given your findings).
