# Mathlib Analogist Report

## Mode
api-alignment

## Slug
reparam

## Iteration
030

## Question
(1) Re-parameterize the free-Čech resolution in `FreePresheafComplex.lean` from
`(𝒰 : X.OpenCover) [Finite 𝒰.I₀]` to `{ι} [Finite ι] (U : ι → Opens X)`. Does Mathlib have a
raw-family-indexed Čech construction to align with? Does a free-Yoneda Čech resolution need the
family to cover the whole space? (2) For `surj_of_vanishing`: Mathlib idiom for
"epi `g : M ⟶ N` of `X.Modules` ⟹ local section surjectivity over a cover (basic/affine)".

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1-A: index free side by raw family `U : ι → Opens X` | ALIGN_WITH_MATHLIB | major |
| Q1-B: resolution needs `⨆ U = ⊤`? (no) | PROCEED | informational |
| Q1-C: replace bespoke `cechFreeSimplicial` with `FormalCoproduct.cech` | DIVERGE_INTENTIONALLY | informational |
| Q2-A: local-surjectivity idiom (`IsLocallySurjective`) | ALIGN_WITH_MATHLIB | major |
| Q2-B: bridge `Epi (X.Modules) ⟹ IsLocallySurjective` | NEEDS_MATHLIB_GAP_FILL | informational |
| Q2-C: refine cover to basic/affine opens | PROCEED | informational |

## Major

- **Q1-A (re-parameterize the free side).** Mathlib indexes its Čech complexes by a **raw family
  with no covering hypothesis**: `CategoryTheory.cechComplexFunctor`
  (`Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean:65`, `variable {ι} (U : ι → C)`) and
  `Limits.FormalCoproduct.cech`/`cechFunctor`/`power`
  (`Mathlib/CategoryTheory/Limits/FormalCoproducts/Cech.lean:186,194,34`) — the latter's degree-`n`
  index `i : Fin(n+1) → ι` over products `∏_a U(i a)` is exactly the project's
  `cechFreeSimplicial` shape. The project's section side (`sectionCechComplex {ι} (U : ι → Opens X)`,
  PresheafCech.lean:334) and `CovDatum`/`BasisCovSystem` (CechToCohomology.lean:309) are already
  raw-family; the `X.OpenCover`-indexed free side is the lone outlier. Re-parameterize
  `FreePresheafComplex.lean` to `{ι} [Finite ι] (U : ι → Opens X)`, keeping `X.OpenCover` callers
  as thin wrappers passing `coverOpen 𝒰`. This removes the wrapper impedance mismatch and the
  spurious `OpenCover.iSup_opensRange : ⨆ = ⊤` constraint (`AlgebraicGeometry/Cover/Open.lean:65`).

- **Q2-A (local-surjectivity idiom).** Use `CategoryTheory.Presheaf.IsLocallySurjective J f`
  (`Mathlib/CategoryTheory/Sites/LocallySurjective.lean:94`) with `localPreimage`/`app_localPreimage`
  (81/87), specialized to `Opens X` by `TopCat.Presheaf.IsLocallySurjective`
  (`Mathlib/Topology/Sheaves/LocallySurjective.lean:61`). The target form is **exactly** what
  `ses_cech_h1` needs:
  `isLocallySurjective_iff` (line 64): `IsLocallySurjective T ↔ ∀ U t, ∀ x∈U, ∃ V≤U, (∃ s, T.app s = t|_V) ∧ x∈V`.
  Produce the `ses_cech_h1` `sLoc`/`hlift` inputs this way instead of an ad-hoc lift.

## Informational

- **Q1-B (cover-agnostic).** Confirmed NO: `cechComplexFunctor`/`FormalCoproduct.cech` take an
  arbitrary family; the project's objectwise quasi-iso argument is about each `V` vs `⨆ U_i`,
  never `⊤`. `[Finite ι]` remains the only needed hypothesis (finite coproducts of shape
  `Fin(p+1)→ι`, evaluation-preserves-coproduct as a finite colimit, downstream
  `cech_computes_higherDirectImage` finiteness).

- **Q1-C (keep bespoke).** `cechFreeSimplicial`/`cechFreeComplex_quasiIso` are already built and
  axiom-clean; rebuilding on `FormalCoproduct.cech` would discard proven code for no proof gain.
  `cechComplexFunctor` is likewise a parallel API to the proven `sectionCechComplex` — record, do
  not refactor. `Arrow.cechNerve` (`AlgebraicTopology/CechNerve.lean:56`) is the Čech nerve of a
  single morphism (fibre products) — a different construction, not an alignment target.

- **Q2-B (the one real gap).** Verified in Lean (iter-030): every hypothesis of
  `Sheaf.isLocallySurjective_iff_epi'` (`Mathlib/CategoryTheory/Sites/EpiMono.lean:123`) is present
  as an instance for `Sheaf (Opens.grothendieckTopology X) AddCommGrpCat` (`HasSheafify`,
  `HasSheafCompose`, `Balanced`, `WEqualsLocallyBijective`,
  `HasFunctorialSurjectiveInjectiveFactorization`). The **only** missing fact is
  `(SheafOfModules.toSheaf X.ringCatSheaf).PreservesEpimorphisms` (i.e. `Epi g → Epi (toSheaf.map g)`):
  `infer_instance` fails. `toSheaf` is `Additive`/`Faithful`/`PreservesFiniteLimits` but not
  `PreservesFiniteColimits`; `Scheme.Modules.toPresheaf` is a right adjoint
  (`AlgebraicGeometry/Modules/Sheaf.lean:67`) so cannot transfer the epi by itself — it must go
  through `toSheaf` at the sheaf level. The fact is mathematically true (underlying-abelian-sheaf
  is exact, kernels/cokernels computed stalkwise) but unpackaged. Prover target: a project-local
  `instance`/`lemma toSheaf_preservesEpi`. Stalk alternative
  (`locally_surjective_iff_surjective_on_stalks`, LocallySurjective.lean:80) needs the same
  exactness, so the `toSheaf` lemma is the cheapest.

- **Q2-C (affine refinement).** `Scheme.isBasis_affineOpens : Opens.IsBasis X.affineOpens`
  (`AffineScheme.lean:297`) + `Opens.IsBasis.exists_subset_of_mem_open` shrinks the `{V_x}` cover
  to affine/basic opens, matching `BasisCovSystem.faces_mem`.

## Concrete prover targets

1. `instance : (SheafOfModules.toSheaf X.ringCatSheaf).PreservesEpimorphisms` (the gap; ~exactness
   of the underlying-abelian-sheaf functor).
2. From `Epi S.g`: `Sheaf.isLocallySurjective_iff_epi' ((toSheaf _).map S.g) |>.mpr` →
   `Sheaf.IsLocallySurjective`, defeq `Presheaf.IsLocallySurjective (Opens.grothendieckTopology X)
   ((Scheme.Modules.toPresheaf X).map S.g)`.
3. `TopCat.Presheaf.isLocallySurjective_iff` → per-point `(V, s)`; refine via
   `Scheme.isBasis_affineOpens`; assemble into `ses_cech_h1`'s `sLoc`/`hlift`.
4. Q1 refactor: re-sign `coverOpen`/`coverInterOpen`/`cechFreeSimplicial`/
   `cechFreePresheafComplex`/`cechFreeAug`/`coverStructurePresheaf`/`cechFreeComplexAug` over
   `{ι} [Finite ι] (U : ι → Opens X)`; add `X.OpenCover` wrappers; update `injective_cech_acyclic`
   to pass `coverOpen 𝒰`.

## Persistent file
- `analogies/reparam.md` — full decision blocks + citations captured for future iters.

Overall verdict: re-parameterize the free side to a raw `U : ι → Opens X` family (Mathlib + project
section side both endorse it; no covering hypothesis needed) and route local surjectivity through
`Presheaf.IsLocallySurjective`/`isLocallySurjective_iff`, whose only missing prerequisite is the
small `toSheaf.PreservesEpimorphisms` bridge.
