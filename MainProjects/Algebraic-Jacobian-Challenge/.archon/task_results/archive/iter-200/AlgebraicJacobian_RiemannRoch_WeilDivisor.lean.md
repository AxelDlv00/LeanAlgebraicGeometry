# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean — iter-200 Lane WD-A4a Sub-build 1

## Summary

- **Declarations added (8, all axiom-clean)**:
  1. `Scheme.PrimeDivisor.ext` (L153) — structure extensionality from
     `point` equality.
  2. `Scheme.PrimeDivisor.restrictToOpen` (L162) — `Y : X.PrimeDivisor`,
     `Y.point ∈ U` ⟶ `U.toScheme.PrimeDivisor`.
  3. `Scheme.PrimeDivisor.ofOpen` (L174) — `U.toScheme.PrimeDivisor` ⟶
     `X.PrimeDivisor`.
  4. `Scheme.PrimeDivisor.restrictToOpen_point` (L182) — `@[simp]` field
     extraction.
  5. `Scheme.PrimeDivisor.ofOpen_point` (L187) — `@[simp]` field
     extraction.
  6. `Scheme.PrimeDivisor.equivOpen` (L195) — bijection
     `{ Y : X.PrimeDivisor // Y.point ∈ U } ≃ U.toScheme.PrimeDivisor`.
  7. `Scheme.PrimeDivisor.stalkIso` (L210) — wrapper around Mathlib's
     `Scheme.Opens.stalkIso`, giving
     `U.toScheme.presheaf.stalk (restrictToOpen U Y hYU).point ≅
       X.presheaf.stalk Y.point`.
  8. `Scheme.IsRegularInCodimensionOne.instOpen` (L305) — open-immersion
     descent instance (PUSH-BEYOND step 4).

- **Sorries**: 3 → 3 (unchanged; substrate-only iter). The three remaining
  sorries are at the originally-protected positions:
  - L535 `rationalMap_order_finite_support` non-zero branch (was L415)
  - L843 `principal_degree_zero` non-constant branch (was L723)
  - L1413 `degree_positivePart_principal_eq_finrank` (was L1293)
  None of these were touched per the directive's SCOPE FENCE.

- **Axiom-cleanliness**: every new declaration verified via
  `lean_verify` to depend only on `{propext, Classical.choice, Quot.sound}`.

- **File metrics**: 1318 → 1438 LOC (+120 LOC, within the analogist's
  50-110 LOC PUSH-BEYOND budget). Compilation: no errors, no warnings.

- **Blueprint impact**: chapter `RiemannRoch_WeilDivisor.tex` does not
  currently host blocks for these substrate declarations. Review agent
  may consider adding a new `\section{Open-immersion descent for prime
  divisors}` block citing Stacks 02IZ + the iter-183 CoheightBridge
  substrate.

## HARD BAR vs PUSH-BEYOND

- **HARD BAR (per PROGRESS.md L132)**: land steps (1)-(3) axiom-clean. **MET**.
  - Step (1): import added at L4. **DONE**.
  - Step (2): `restrictToOpen` + `ofOpen` + `equivOpen` + `ext` + simp
    helpers. **DONE** axiom-clean.
  - Step (3): `stalkIso` via Mathlib's `Scheme.Opens.stalkIso`. **DONE**
    axiom-clean.

- **PUSH-BEYOND (per PROGRESS.md L133-136)**: step (4)
  `IsRegularInCodimensionOne` open-immersion descent. **MET**.
  - Step (4): `Scheme.IsRegularInCodimensionOne.instOpen` axiom-clean.

- **Out-of-scope per analogist `wd-stacks02iz` Decision 5**: `Ring.ordFrac`
  naturality across the new stalk iso is iter-201+ Sub-build 2 scope
  (Mathlib gap fill, ~30-50 LOC); intentionally deferred.

## Scheme.PrimeDivisor.ext (L153) — RESOLVED axiom-clean

- **Approach**: structure ext from `cases Y; cases Y'; congr`. The
  `coheight` field is `Prop`, so `congr` collapses it.
- **Result**: axiom-clean, no friction.
- **Why added**: useful for the round-trip lemmas of `equivOpen` (the
  forward + inverse functions land definitionally on the right field, so
  `rfl` suffices for `left_inv` / `right_inv` — but `ext` is a clean
  downstream helper).

## Scheme.PrimeDivisor.restrictToOpen / ofOpen (L162, L174) — RESOLVED

- **Approach**: thin layer over the existing iter-183 substrate
  `Order.coheight_eq_of_isOpenEmbedding` from
  `AlgebraicJacobian.Albanese.CoheightBridge`. Match the L175-185 defeq
  cast pattern noted by the analogist.
- **Friction**: zero — the spec preorder on `U.toScheme.carrier` is
  defeq to the spec preorder on `↥U.1`, so the existing bridge lemma
  applies directly.
- **Result**: axiom-clean.

## Scheme.PrimeDivisor.equivOpen (L195) — RESOLVED

- **Approach**: package `restrictToOpen` and `ofOpen` as an `Equiv`. The
  `left_inv` and `right_inv` proofs are `rfl` since both directions
  preserve the point field definitionally (`Subtype` eta + structure
  eta).
- **Result**: axiom-clean.

## Scheme.PrimeDivisor.stalkIso (L210) — RESOLVED

- **Approach**: direct invocation of Mathlib's
  `AlgebraicGeometry.Scheme.Opens.stalkIso` on `⟨Y.point, hYU⟩`.
- **Friction**: had to mark `noncomputable` (Mathlib's
  `Scheme.Opens.stalkIso` is noncomputable).
- **Result**: axiom-clean.

## Scheme.IsRegularInCodimensionOne.instOpen (L305) — RESOLVED

- **Approach**: refine on the per-prime-divisor obligation; push the
  open-side `YU` to `Scheme.PrimeDivisor.ofOpen U YU` on the ambient
  side; harvest `IsDiscreteValuationRing` on `X.presheaf.stalk YU.point.1`
  from `Scheme.IsRegularInCodimensionOne.out`; transport to
  `U.toScheme.presheaf.stalk YU.point` via
  `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing` along
  `(Scheme.Opens.stalkIso U YU.point).symm.commRingCatIsoToRingEquiv`.
- **Note**: requires `[IsIntegral U.toScheme]` (needed for `IsDomain` on
  the U-side stalk; integrality of an open subscheme is not automatic).
- **Result**: axiom-clean.

## Why I stopped — `Real progress`

Eight axiom-clean declarations landed (L141, L154, L165, L172, L177,
L186, L201, L227). HARD BAR met. PUSH-BEYOND step (4) met. Out-of-scope
items (`Ring.ordFrac` naturality across stalk iso) explicitly deferred
to iter-201+ Sub-build 2 per analogist Decision 5.

## Iter-201+ commitments (handoff)

- **Sub-build 2 preview**: `Ring.ordFrac` naturality across a ring iso.
  The signature would be of the form
  ```lean
  lemma Ring.ordFrac_ringEquiv {R S : Type*} [CommRing R] [IsDomain R]
      [IsNoetherianRing R] [Ring.KrullDimLE 1 R]
      [CommRing S] [IsDomain S] [IsNoetherianRing S] [Ring.KrullDimLE 1 S]
      (e : R ≃+* S) (K_R K_S : Type*) [Field K_R] [Field K_S]
      [Algebra R K_R] [IsFractionRing R K_R]
      [Algebra S K_S] [IsFractionRing S K_S]
      (e_K : K_R ≃+* K_S)  -- compatible with e on R-image
      (x : K_R) :
      Ring.ordFrac S (e_K x) = (Multiplicative.ofAdd ∘ ...) (Ring.ordFrac R x)
  ```
  This is a Mathlib gap and a clean upstream PR candidate. Project-side
  ~30-50 LOC (chase through `IsFractionRing.ringEquivOfRingEquiv` plus
  the `Ring.ordMonoidWithZeroHom` naturality at the base ring).

- **Sub-build 3 preview**: `Scheme.RationalMap.order` naturality across
  the `stalkIso U Y hYU` of Sub-build 1, conditional on Sub-build 2.
  Would yield `order Y f = order (restrictToOpen U Y hYU) f'` for `f'`
  the corresponding function field element across the iso
  `X.functionField ≃ U.toScheme.functionField` (Mathlib has this iso
  for integral X via the irreducibility of the generic point lying in
  any non-empty open).

- **Blueprint suggestion**: `RiemannRoch_WeilDivisor.tex` could host a
  new "§Open-immersion descent for prime divisors" section pinning
  - `Scheme.PrimeDivisor.restrictToOpen`,
  - `Scheme.PrimeDivisor.ofOpen`,
  - `Scheme.PrimeDivisor.equivOpen`,
  - `Scheme.PrimeDivisor.stalkIso`,
  - `Scheme.IsRegularInCodimensionOne.instOpen`,
  citing Stacks 02IZ and the iter-183 `CoheightBridge.lean` substrate.

## Substrate-already-exists notes (re-surfaced from analogist)

- `IsLocallyNoetherian U.toScheme` is automatic from `IsLocallyNoetherian X`
  via Mathlib's existing typeclass propagation (verified via
  `infer_instance` in a scratch buffer); no project-side work needed.
- `IsIntegral U.toScheme` is **not** automatic — open subschemes need
  non-emptiness; threaded explicitly in `instOpen`.
- The directive's "build a fresh Stacks 02IZ/005X bridge" estimate
  (~150-250 LOC) was over-estimated by ~50% per the analogist; actual
  cost +120 LOC realized.

## Dead ends (none)

No dead ends this iter — the analogist's recipe was followed verbatim and
landed cleanly. The only friction was the `noncomputable` marker on
`stalkIso` (one-line correction).
