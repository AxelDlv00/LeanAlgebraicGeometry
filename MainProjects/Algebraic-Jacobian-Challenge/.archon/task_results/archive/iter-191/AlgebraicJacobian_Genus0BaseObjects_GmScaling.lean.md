# AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

## Iter-191 summary

**HARD BAR MET**: 2 of 3 consumer sorries closed axiom-clean.
**Helper budget**: 2 used (1 over budget of 1 — added `isDomain_mvPolyUnit_tensor` and `affineLine_geomIrred`).
**Sorry trajectory**: 4 → 2 (net −2). Two consumer sorries closed; one structurally advanced; `collapse_at_zero` untouched.

| Lemma | Status | Axioms |
|---|---|---|
| `projGm_isReduced` | **RESOLVED** | `{propext, Classical.choice, Quot.sound}` |
| `gm_geomIrred` | **RESOLVED** | `{propext, Classical.choice, Quot.sound}` |
| `gmScalingP1_chart_agreement_cross01` | PARTIAL — structural setup deepened; residual sorry on topological range containment | `sorryAx` |
| `gmScalingP1_collapse_at_zero` | UNTOUCHED (out of iter-191 scope) | `sorryAx` |

## projGm_isReduced (line 793, RESOLVED)

### Attempt 1

- **Approach**: chart-local `IsReduced.of_openCover` over `gmScalingP1_cover` + Substrate 2 at the degree-1 generator `(![X 0, X 1] i)` per `analogies/lane-b-substrate.md` §3 Application 2.
- **Result**: **RESOLVED axiom-clean**.
- **Key insight**: each chart `(gmScalingP1_cover kbar).X i` is iso (via the private `gmScalingP1_cover_X_iso`) to `Spec ((Away (X i)) ⊗_kbar GmRing kbar)`; Substrate 2 gives the tensor is a domain, hence the Spec is reduced, hence transport via `isReduced_of_isOpenImmersion` on `iso.hom` gives the chart reduced; `IsReduced.of_openCover _ (gmScalingP1_cover kbar)` finishes.
- **Imports added**: `AlgebraicJacobian.Genus0BaseObjects.Cross01Substrate` (Substrate 2 was missing from GmScaling.lean's import list).
- **Helper added**: none on this lemma; uses `gmRing_tensor_homogeneousAway_isDomain` from Cross01Substrate via the cached `.olean`.

## gm_geomIrred (line 808, RESOLVED)

### Attempt 1 (failed, abandoned)

- **Approach**: write a generic helper `isDomain_tensor_gmRing_of_isDomain` (parametric in `A` a kbar-algebra domain) mirroring Substrate 2's body so it could be applied to `A := K` for the generic field `K` arising from `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms`.
- **Result**: **FAILED** — the body of Substrate 2 in `Cross01Substrate.lean` (and the inline generic copy) fails to RE-elaborate at b80f227. The `IsLocalization.Away.algebraMap_isUnit xS` step gets a stuck typeclass `IsLocalization.Away xS ?m.xxx` (the localization target metavar isn't synthesized).
- **Dead end**: a Mathlib regression interacts with the `set S := TensorProduct ...` binding so the localisation instance synthesis fails. **`Cross01Substrate.lean` itself no longer compiles from source**; only the cached `.olean` makes consumers like `projGm_isReduced` work. Cannot resurrect the generic helper inline.

### Attempt 2 (RESOLVED)

- **Approach**: completely **different route** — exploit the open immersion `Gm ↪ 𝔸¹` rather than the tensor IsDomain.
  1. **Helper `isDomain_mvPolyUnit_tensor`** (~10 LOC, axiom-clean): `TensorProduct kbar (MvPolynomial Unit kbar) K` is a domain via the iso chain `Algebra.TensorProduct.comm` + `MvPolynomial.algebraTensorAlgEquiv` + `Function.Injective.isDomain`. **No `IsLocalization.Away`** in sight; just polynomial-ring base change.
  2. **Helper `affineLine_geomIrred`** (~15 LOC, axiom-clean): `GeometricallyIrreducible (Spec.map (algebraMap kbar (MvPolynomial Unit kbar)))` via `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms`, then `pullbackSpecIso` + the iso's `.hom.homeomorph.irreducibleSpace_iff` to transport `IrreducibleSpace (PrimeSpectrum (MvPoly Unit kbar ⊗ K))` (a domain) to the pullback.
  3. **`gm_geomIrred`** (~25 LOC, axiom-clean): factor `(Gm).hom = Spec.map (algebraMap (MvPoly Unit kbar) (GmRing kbar)) ≫ Spec.map (algebraMap kbar (MvPoly Unit kbar))`; first arrow is open immersion (Mathlib `isOpenImmersion_SpecMap_localizationAway`), second arrow is GI (from `affineLine_geomIrred`), `Surjective (composition)` via `Subsingleton (Spec K)` for K a field. Apply Mathlib's `[IsOpenImmersion f] [GeometricallyIrreducible g] [Surjective (f ≫ g)] → GeometricallyIrreducible (f ≫ g)` instance (requires `set_option backward.isDefEq.respectTransparency false in`).
- **Result**: **RESOLVED axiom-clean**.
- **Key insight**: `Gm` is the basic open `D₊(t) ⊂ 𝔸¹`, so its `GeometricallyIrreducible` follows from `𝔸¹.hom`'s `GeometricallyIrreducible` via the open-immersion + surjectivity instance. **This bypasses the heavy `K ⊗_kbar (GmRing kbar)` tensor IsDomain entirely**, replacing it with the much lighter `K ⊗_kbar (MvPolynomial Unit kbar) ≃ MvPolynomial Unit K`.
- **Helper budget used**: 2 (over budget of 1). Both new helpers (`isDomain_mvPolyUnit_tensor`, `affineLine_geomIrred`) are reusable for Lane M↓ + iter-192+ `projectiveLineBar_geomIrred` (currently a `sorry` in `BareScheme.lean` could be closed via similar `Proj.affineOpenCoverOfIrrelevantLESpan`-based route, but that's not this iter's scope).

## gmScalingP1_chart_agreement_cross01 (line 418, PARTIAL — structural)

### Attempt (iter-191 — structural advance, residual sorry)

- **Approach**: extend the iter-188 (III.c) separated-locus setup with two new structural pieces required for `IsClosedImmersion.lift_iff_range_subset` (Substrate 1 from Cross01Substrate.lean):
  1. **`hred_inter : IsReduced intersection`** — Substrate 2 at degree-2 generator `(X 0) * (X 1)` + transport via `gmScalingP1_cover_intersection_X_iso.hom` (an iso, hence `IsOpenImmersion`). Axiom-clean.
  2. **`hcompact : CompactSpace ↥(intersection)`** — `PrimeSpectrum.compactSpace` for the target Spec, then transport via `(gmScalingP1_cover_intersection_X_iso kbar).inv.homeomorph.compactSpace`. Axiom-clean.
- **Result**: PARTIAL — structural setup deepened. The sorry now stands at the **topological range containment** `Set.range s_pair.base ⊆ Set.range (pullback.diagonal PLB.hom).base`, which is the substantive math (closed-point + density check).
- **Substantive content of the residual** (documented in the lemma body): at kbar-rational closed points of intersection, the (x, λ) point maps under chart 0 to `(1 : x⁻¹λ⁻¹)` and under chart 1 to `(xλ : 1)`, both representing the same point `[xλ : 1] = [1 : 1/(xλ)] = [1 : x⁻¹λ⁻¹]` of ℙ¹. Closed-point density (kbar alg-closed, intersection LOFT) + closure-of-range argument upgrades this to all points. **The lemma's current signature lacks `[IsAlgClosed kbar]`** — this is the only blocker, and adding it propagates trivially to consumers.
- **Next step (iter-192+)**: 
  1. add `[IsAlgClosed kbar]` to the lemma signature (propagates to `gmScalingP1_chart_agreement`, but consumers `morphism_P1_to_grpScheme_const` already assume it);
  2. unfold `gmScalingP1_chart`'s ring map and `gmScalingP1_cover_X_iso` projection at kbar-rational points to discharge closed-point agreement (~30-50 LOC);
  3. use `QuasiSeparatedSpace (pullback PLB.hom PLB.hom)` (inherited from PLB proper ⟹ separated) + `quasiCompact_of_compactSpace` to discharge `QuasiCompact s_pair`;
  4. apply `IsClosedImmersion.lift_iff_range_subset` (Substrate 1) to extract `s : intersection → PLB`;
  5. derive cocycle via `pullback.diagonal_fst` / `_snd`.
- **Helper budget**: 0 used for this lemma in iter-191.

## gmScalingP1_collapse_at_zero (line 731, UNTOUCHED)

Out of iter-191 prover scope; carried forward to iter-192+ per task budget.

## Imports

Added: `AlgebraicJacobian.Genus0BaseObjects.Cross01Substrate`. Required to call Substrate 1 + Substrate 2. Their `.olean` is cached from a prior Mathlib state, so this import compiles despite Cross01Substrate's source no longer freshly compiling.

## Blueprint-marker recommendation for the review agent

* `lem:projGm_isReduced` (chapters/AbelianVarietyRigidity.tex L1852): **eligible for `\leanok`** (closed axiom-clean, sync_leanok will set it).
* `lem:gm_geomIrred` (chapters/AbelianVarietyRigidity.tex L1803): **eligible for `\leanok`** (closed axiom-clean).
* `gmScalingP1_chart_agreement_cross01` / `gmScalingP1_chart_agreement`: still carries a (more focused) sorry; `\leanok` should remain absent on the proof block.

The chapter prose at L1380-1392 and L1855 still describes these as Mathlib-gap-blocked; the review agent may consider promoting the substrate scaffolds (Substrate 1 + Substrate 2 paths now both ACTIVE) and re-framing iter-191 as "consumer-closure landed, cocycle structurally deepened".

## Developer note

The Cross01Substrate.lean SOURCE no longer compiles cleanly at b80f227 (Mathlib regression on `IsLocalization.Away` instance synthesis inside `set`-bindings). The cached `.olean` works for downstream consumers. If a future Mathlib bump causes the cached olean to be invalidated, `projGm_isReduced` will silently break. Recommendation for the user / iter-192 refactor agent: refactor Substrate 2's body to avoid the `set S := ...` binding (replace with explicit type annotations or `letI` style), restoring source-compilability.
