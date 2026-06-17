# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean — iter-201 Lane WD-A4a Sub-build 2

## Summary

- **Declarations added (6, all axiom-clean)**:
  1. `Ring.ord_ringEquiv` (L247) — `Ring.ord R x = Ring.ord S (e x)` naturality.
  2. `Ring.nonZeroDivisors_ringEquiv` (L273) — `r ∈ nzd R ↔ e r ∈ nzd S`.
  3. `Ring.ordMonoidWithZeroHom_ringEquiv` (L285) —
     `ordMonoidWithZeroHom S (e r) = ordMonoidWithZeroHom R r`.
  4. **`Ring.ordFrac_ringEquiv` (L311) — Sub-build 2 HARD BAR**:
     `Ring.ordFrac S (e_K x) = Ring.ordFrac R x` for compatible `(e, e_K)`.
  5. `AlgebraicGeometry.Scheme.Opens.functionFieldIso` (L380) —
     `U.toScheme.functionField ≅ X.functionField` for integral `X`,
     nonempty `U`. PUSH-BEYOND step (2) partial: the iso is defined; its
     compatibility with `stalkIso` (Sub-build 3 `h_compat` discharge) is
     deferred.
  6. `AlgebraicGeometry.Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`
     (L519) — scheme-side packaging of `Ring.ordFrac_ringEquiv` parameterized
     on a user-supplied function-field iso `e_K` and a compatibility
     hypothesis `h_compat`. Sub-build 3 entry point.

- **Sorries**: 3 → 3 (unchanged; substrate-only iter respecting the SCOPE
  FENCE on L538 / L1108).

- **Axiom-cleanliness**: every new declaration verified via `lean_verify`
  to depend only on `{propext, Classical.choice, Quot.sound}`.

- **File metrics**: 1438 → 1647 LOC (+209 LOC; within the directive's
  ~30-50 LOC for HARD BAR step (1) + ~20-30 LOC for PUSH-BEYOND step (2)
  envelope when including doc comments).

- **Blueprint impact**: chapter `RiemannRoch_WeilDivisor.tex` already hosts
  the iter-201 plan-agent "End-to-end map: Sub-builds 1--3" paragraph
  (L366-433). Review agent may consider adding new `\lean{...}` pins:
  - `Ring.ordFrac_ringEquiv` (Sub-build 2 anchor),
  - `Scheme.Opens.functionFieldIso` (Sub-build 2 PUSH-BEYOND anchor),
  - `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` (Sub-build 3 entry).

## HARD BAR vs PUSH-BEYOND

- **HARD BAR (per PROGRESS.md L132)**: land step (1) `Ring.ordFrac_ringEquiv`
  axiom-clean. **MET** at L311. Three project-local helper lemmas
  (ord/nzd/ordMonoidWithZeroHom naturality) landed as ancillary substrate.

- **PUSH-BEYOND (per PROGRESS.md L133-138)**: step (2) — assemble
  `Scheme.PrimeDivisor.stalkIso` into the `IsFractionRing` compatibility
  through the function-field iso. **PARTIAL**:
  - `Scheme.Opens.functionFieldIso` defined (L380, axiom-clean).
  - `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` (L519) packages the
    application but takes `h_compat` as a hypothesis. Discharging
    `h_compat` from `Scheme.Opens.functionFieldIso` + naturality of
    `Scheme.Opens.stalkIso` w.r.t. `stalkSpecializes` to the generic point
    is iter-202 Sub-build 3 scope (requires either a
    `Scheme.Hom.stalkSpecializes_stalkMap`-style naturality lemma or a
    direct chase via `AlgebraicGeometry.Scheme.Opens.germ_stalkIso_hom_assoc`).

## Ring.ord_ringEquiv (L247) — RESOLVED axiom-clean

- **Approach**: build the R-linear equivalence
  `R/(x) ≃ₗ[R] S/(e x)` (with the `S`-side equipped with R-module
  structure via `e.toRingHom.toAlgebra`). The forward map is
  `Ideal.quotientEquiv (Ideal.span {x}) (Ideal.span {e x}) e _ ` promoted
  to R-linear via a `map_smul'` field discharged by an
  `induction m using Quotient.inductionOn`. Then chain
  `LinearEquiv.length_eq` (R-side comparison) with
  `Module.length_eq_of_surjective` (R-vs-S comparison on the `S`-module
  side, with surjective algebra map `e : R → S`).
- **Result**: axiom-clean.

## Ring.nonZeroDivisors_ringEquiv (L273) — RESOLVED axiom-clean

- **Approach**: rewrite via Mathlib's
  `MulEquivClass.map_nonZeroDivisors (e : R ≃* S)` and chase the resulting
  `Submonoid.map` predicate via the injectivity of `e`.
- **Result**: axiom-clean.

## Ring.ordMonoidWithZeroHom_ringEquiv (L285) — RESOLVED axiom-clean

- **Approach**: unfold `Ring.ordMonoidWithZeroHom`, split on
  `r ∈ nonZeroDivisors R` via `by_cases`, and rewrite each branch using
  `nonZeroDivisors_ringEquiv` + `ord_ringEquiv`.
- **Result**: axiom-clean.

## Ring.ordFrac_ringEquiv (L311) — RESOLVED axiom-clean **(HARD BAR)**

- **Approach**: `by_cases hx : x = 0` for the junk-zero branch. For
  `x ≠ 0`:
  (a) obtain `(a, b)` with `b ∈ nzd R` from `IsLocalization.surj`;
  (b) deduce `a ≠ 0` from `x ≠ 0` and `algebraMap R K_R b ≠ 0`
      (the latter via `IsFractionRing.injective` + `mem_nonZeroDivisors_iff_ne_zero`);
  (c) lift to `a ∈ nzd R` via `mem_nonZeroDivisors_of_ne_zero` (uses `[IsDomain R]`);
  (d) express `x = mk' K_R a ⟨b, _⟩` via `IsLocalization.mk'_eq_iff_eq_mul`;
  (e) express `e_K x = mk' K_S (e a) ⟨e b, _⟩` by chasing `h_compat`
      through `mk'_eq_iff_eq_mul.mpr`;
  (f) apply Mathlib's `Ring.ordFrac_eq_div` on both sides;
  (g) close via `ordMonoidWithZeroHom_ringEquiv` on numerator and denominator.
- **Result**: axiom-clean.

## Scheme.Opens.functionFieldIso (L380) — RESOLVED axiom-clean

- **Approach**: compose `Scheme.Opens.stalkIso U (genericPoint U.toScheme)`
  with `X.presheaf.stalkCongr` along the equality
  `(genericPoint U.toScheme).val = genericPoint X` from Mathlib's
  `genericPoint_eq_of_isOpenImmersion U.ι`. The `Inseparable` witness
  needed by `stalkCongr` collapses to `Inseparable.refl _` after the
  rewrite.
- **Result**: axiom-clean. Required `noncomputable` (stalkIso /
  stalkCongr both noncomputable).

## Scheme.PrimeDivisor.ordFrac_stalkIso_naturality (L519) — RESOLVED axiom-clean

- **Approach**: direct application of `Ring.ordFrac_ringEquiv` with
  - `e := (Scheme.PrimeDivisor.stalkIso U Y hYU).commRingCatIsoToRingEquiv`
  - `e_K` and `h_compat` supplied by the caller.

  Typeclass synthesis discharges
  `[IsDomain (X.presheaf.stalk Y.point)]`,
  `[IsNoetherianRing (X.presheaf.stalk Y.point)]`,
  `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]`,
  and similarly for the `U.toScheme` stalk, via Mathlib's auto-derivations
  + the project-local `Scheme.IsRegularInCodimensionOne.instOpen` (iter-200)
  and `instKrullDimLEStalk` (also iter-200).

  The `[Scheme.IsRegularInCodimensionOne U.toScheme]` typeclass on `U.toScheme`
  is threaded explicitly even though it would derive via `instOpen` --- this
  avoids elaboration cycles when the user calls the lemma at sites where
  `U.toScheme` is not yet known to satisfy the predicate. This is a clean
  forward-compatible signature for iter-202 Sub-build 3.
- **Result**: axiom-clean.

## Why I stopped — `Real progress`

Six axiom-clean declarations landed (L247, L273, L285, L311, L380, L519).
HARD BAR met (Ring.ordFrac_ringEquiv at L311). PUSH-BEYOND step (2)
partial: function-field iso defined + scheme-side packaging lemma landed,
both axiom-clean. The IsFractionRing-compatibility (the `h_compat`
hypothesis) remains taken as parameter rather than discharged — this is
the iter-202 Sub-build 3 task.

## Sub-build 3 handoff (iter-202+)

To close the L535 sorry (`rationalMap_order_finite_support` non-zero
branch), the iter-202 plan needs to discharge the `h_compat` hypothesis
of `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`. The concrete claim
to discharge is:

```lean
∀ (X : Scheme.{u}) [IsIntegral X] (U : X.Opens) [Nonempty U]
    [IsIntegral U.toScheme] (Y : X.PrimeDivisor) (hYU : Y.point ∈ U)
    (r : U.toScheme.presheaf.stalk (Scheme.PrimeDivisor.restrictToOpen U Y hYU).point),
  (Scheme.Opens.functionFieldIso U).hom.hom
    (algebraMap _ U.toScheme.functionField r) =
  algebraMap _ X.functionField
    ((Scheme.PrimeDivisor.stalkIso U Y hYU).commRingCatIsoToRingEquiv r)
```

Both `algebraMap`s are concretely `stalkSpecializes` to the respective
generic points (from Mathlib's `stalkFunctionFieldAlgebra` in
`AlgebraicGeometry.FunctionField`, L81-85). The compatibility is therefore
a naturality of `stalkSpecializes` w.r.t. `Scheme.Opens.stalkIso`.

**First Mathlib files to read for Sub-build 3** (per iter-201 prover scout):
- `Mathlib.AlgebraicGeometry.FunctionField` L81-95 (algebraMap definition).
- `Mathlib.AlgebraicGeometry.Restrict` (`Scheme.Opens.stalkIso` definition +
  the `germ_stalkIso_hom_assoc` lemma).
- `Mathlib.Geometry.RingedSpace.LocallyRingedSpace`
  (`stalkSpecializes_stalkMap` — generic naturality).
- `Mathlib.Geometry.RingedSpace.Stalks`
  (`PresheafedSpace.stalkMap.stalkSpecializes_stalkMap_assoc` — the
  cleanest naturality at the underlying presheaf level).

**Recipe for Sub-build 3** (~30-60 LOC):
1. Prove the morphism-level commutativity
   `stalkIso ≫ stalkSpecializes (X-side gp ⤳ Y) = stalkSpecializes (U-side gp ⤳ Y') ≫ functionFieldIso`
   in `CommRingCat`, via the existing `germ_stalkIso_hom_assoc` or via the
   underlying-PresheafedSpace `stalkSpecializes_stalkMap` instance.
2. Apply the morphism-level equation pointwise to discharge `h_compat`.
3. Specialize `ordFrac_stalkIso_naturality` to
   `e_K = Scheme.Opens.functionFieldIso U` (specifically the
   `CommRingCat`-iso converted to `RingEquiv` via `.commRingCatIsoToRingEquiv`).

**Then the terminal closure of L535 non-zero branch** (~40-80 LOC,
iter-203+ target per the blueprint chapter):
- Pick a finite affine cover `X = ⋃ U_i` (requires strengthening signature
  to `[IsNoetherian X]` or `[CompactSpace X]`; this is the USER-blocked
  signature-strengthening step per the iter-198 structural note at L496-534);
- Apply Sub-build 3 to each `Y ∈ support` lying in some `U_i`, transporting
  to `U_i`-side computation;
- Bound `|support|` via Mathlib's
  `Ideal.finite_minimalPrimes_of_isNoetherianRing` on the principal ideal
  `(image of f) ⊂ Γ(U_i, O_X)`.

## Dead ends (none this iter)

No dead ends. The analogist's iter-200 Sub-build 2 preview signature was
followed verbatim and landed cleanly with an extra refinement:
`ordMonoidWithZeroHom_ringEquiv` was an unanticipated useful intermediate
that emerged during the proof of `ordFrac_ringEquiv`. The split into
`ord_ringEquiv` + `nonZeroDivisors_ringEquiv` + `ordMonoidWithZeroHom_ringEquiv`
+ `ordFrac_ringEquiv` is the natural modular decomposition.

## Substrate-already-exists notes

- `MulEquivClass.map_nonZeroDivisors` (Mathlib
  `Algebra.GroupWithZero.NonZeroDivisors`) gave `nonZeroDivisors_ringEquiv`
  immediately.
- `Module.length_eq_of_surjective` (Mathlib `RingTheory.Length` L136) was
  load-bearing for `ord_ringEquiv` — the surjectivity of the algebra map
  derived from `e.surjective`.
- `Ideal.quotientEquiv` (Mathlib `RingTheory.Ideal.Quotient.Operations`)
  gave the ring iso between quotients for `ord_ringEquiv`.
- `IsLocalization.mk'_eq_iff_eq_mul` (Mathlib `RingTheory.Localization.Defs`)
  + `IsLocalization.surj` were the key tools for `ordFrac_ringEquiv`.
- `Ring.ordFrac_eq_div` (Mathlib `RingTheory.OrderOfVanishing.Basic` L334)
  + the chain `mk' K_R a b` ↔ `mk' K_S (e a) (e b)` under compatible isos
  collapsed `ordFrac_ringEquiv` to algebra-only chase.
- `genericPoint_eq_of_isOpenImmersion` (Mathlib `AlgebraicGeometry.FunctionField`)
  + `X.presheaf.stalkCongr` gave `functionFieldIso`.
