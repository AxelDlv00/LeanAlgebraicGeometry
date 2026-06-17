# AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean

(iter-077, seams + assembly lane — DRAFT, build verification in progress)

## CRITICAL BASELINE FINDING

The file as landed by the prior incarnation **did not elaborate at all**: the signature of
`cechAugmented_to_acyclicResolutionInput` used
`(F ≅ …cycles 0) × (∀ n, …ExactAt (n+1))`, but `Prod`/`×` requires both components in `Type`,
while `HomologicalComplex.ExactAt` is a `Prop` (verified with a minimal `lake env lean` test:
"Application type mismatch … has type Prop … expected Type ?u"). The declaration is NOT
protected (only `cech_computes_higherDirectImage` is), so I changed `×` → `×'` (`PProd`,
Sort-polymorphic). Anonymous constructor / `obtain ⟨e, hexact⟩` destructuring unchanged.
**The blueprint block `lem:cechAugmented_to_acyclicResolutionInput` should be updated by the
planner to say `PProd` instead of `Prod`** (informal content unchanged).

## pushforward_mapHomologicalComplex_cechComplexOnX (was line 60)
### Attempt 1
- **Approach:** New general helper `mapAlternatingCofaceMapComplexIso` (object-level cosimplicial
  analogue of Mathlib's `AlgebraicTopology.map_alternatingFaceMapComplex`, which exists only for
  the simplicial/face case): `HomologicalComplex.Hom.isoOfComponents` with `Iso.refl` components;
  d-square check via `Functor.mapHomologicalComplex_obj_d`, `CochainComplex.of_d` (twice),
  `AlternatingCofaceMapComplex.objD` unfold + `Functor.map_sum` + `Functor.map_zsmul`, then `rfl`.
  The target then follows definitionally: `cechComplexOnX` and `CechComplex` are *by definition*
  the alternating coface complexes of the un-whiskered resp. `f_*`-whiskered drop of `CechNerve`.
- **Result:** (pending build)

## cechAugmented_to_acyclicResolutionInput (was line 91)
### Attempt 1
- **Approach:** From `cechAugmented_exact` get `∀ p, (cechAugmentedComplex 𝒰 F).ExactAt p` via
  `exactAt_iff_isZero_homology`. (2) Positive-degree exactness: `K.sc' (n+1) (n+2) (n+3)` is
  *definitionally* `C.sc' n (n+1) (n+2)` (the `CochainComplex.augment` match reduces on
  successors), so `exactAt_iff'` on both sides + `exact h` transports. (1) The iso `F ≅ cycles 0`:
  ε mono from exactness at 0 (`ShortComplex.Exact.mono_g`, `K.d 0 0 = 0` by `shape`);
  hom := `liftCycles ε 1 _ (cechAugmentation_comp_d)`; inv := `h1.lift (iCycles 0) (iCycles_d)`
  (exactness at 1 + Mono ε); both triangle identities by `cancel_mono` against ε resp. `iCycles 0`
  using `lift_f` / `liftCycles_i`.
- **Result:** (pending build)

## cech_computes_higherDirectImage_of_affineCover (was line 140)
### Attempt 1
- **Approach:** Planner's recipe (a)–(d) verbatim: destructure the resolution input; haveI the
  termwise acyclicity from `cechTerm_pushforward_acyclic` (black box — still `sorry` in lane 1's
  `CechTermAcyclic.lean`, usable as instance); `PreservesLimits (pushforward f)` from
  `(pullbackPushforwardAdjunction f).rightAdjoint_preservesLimits` (Prop-class, Mathlib instance
  `PreservesLimits.preservesFiniteLimits` then fires); final iso =
  `homologyFunctor.mapIso (seam-a).symm ≪≫ (rightDerivedIsoOfAcyclicResolution …).symm`;
  `higherDirectImage` is definitionally `(pushforward f).rightDerived i |>.obj F`.
- **Result:** (pending build)

## Needs blueprint entry
- `AlgebraicGeometry.mapAlternatingCofaceMapComplexIso` (CechToHigherDirectImage.lean) — new
  general helper: an additive functor commutes with the alternating coface map complex
  (cosimplicial analogue of Mathlib's `map_alternatingFaceMapComplex`, which Mathlib only has
  for the simplicial direction). Uses: `HomologicalComplex.Hom.isoOfComponents`,
  `CochainComplex.of_d`, `Functor.map_sum`, `Functor.map_zsmul`. Suggested: bundle into
  `lem:pushforward_mapHC_cechComplexOnX`'s `\lean{…}` list or give it its own block.

## Summary
(to be finalized after build)

## Why I stopped
(to be finalized after build)
