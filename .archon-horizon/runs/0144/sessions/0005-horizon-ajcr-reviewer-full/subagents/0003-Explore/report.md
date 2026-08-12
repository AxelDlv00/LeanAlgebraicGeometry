I now have complete, precise information on all three items. Here is my report.

---

# Verification Report — three proof-design risk items

Project: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild`
Pinned mathlib: `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`
All cited declarations are `sorry`/`admit`-free (verified by grep; the one apparent match was the word "admits" in a docstring).

---

## ITEM 1 — SPLIT-WITNESS TRANSPORT — VERDICT: CONFIRMED usable, with one scheduling caveat

`IsSplitWitness` is defined at `AlgebraicJacobian/Picard/Pic0ChartLocus.lean:151-161`:
```
def IsSplitWitness {K : Type u} [Field K] [Algebra k K] (μ : picEt C (overSpec k K)) : Prop :=
  ∃ (L : Type u) (_ : Field L) (_ : Algebra k L) (_ : Algebra K L) (_ : IsScalarTower k K L)
      (_ : Module.Finite K L) (_ : Algebra.IsSeparable K L) (M : (relCurve C L).CechPic),
    PicEtAff.map C L (picEtAffineEquiv C K μ) = PicEtAff.unit C L (relPicMk C (overSpec k L) M)
      ∧ ∃ W : ((C ⊗ overSpec k L).left).CurveDivisor,
          Scheme.CurveDivisor.picClass L W = M
            ∧ Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)
```

### (a) DOWN — witness after extension ⟹ witness at base: EXISTS
`AlgebraicGeometry.isSplitWitness_of_overSpecMap` — `AlgebraicJacobian/Picard/Pic0RankOneSplitDescent.lean:67`
```
theorem isSplitWitness_of_overSpecMap
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    {K K' : Type u} [Field K] [Algebra k K] [Field K'] [Algebra k K']
    (e : K →ₐ[k] K') (nu : picEt C (overSpec k K))
    (h : IsSplitWitness C (picEtMap C (Over.overSpecMap e) nu)) :
    IsSplitWitness C nu
```
Arbitrary `k`-algebra embedding `e : K →ₐ[k] K'` (docstring explicitly: no finiteness/separability/algebraicity on `e`).

### (b) UP — base ⟹ extension: EXISTS
`AlgebraicGeometry.isSplitWitness_map_overSpecMap_of_algHom` — `AlgebraicJacobian/Picard/Pic0RankOneNativePresentationField.lean:54`
```
theorem isSplitWitness_map_overSpecMap_of_algHom
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    {K L : Type u} [Field K] [Algebra k K] [Field L] [Algebra k L]
    (e : K →ₐ[k] L) (nu : picEt C (overSpec k K))
    (h : IsSplitWitness C nu) :
    IsSplitWitness C (picEtMap C (Over.overSpecMap e) nu)
```
Arbitrary embedding; the output splitting field is a finite-separable field factor of the base change of the original cover.

Together (a)+(b) make the split-witness condition **intrinsic to the underlying point** for arbitrary field embeddings — but see the CAVEAT below.

There is also a **pi-free** transport, restricted to *isomorphisms* of the reading field:
- `AlgebraicGeometry.isSplitWitness_map_overSpecMap` (forward, along `e : K ≃ₐ[k] K'`) — `Pic0ChartLocusIsoInvariance.lean:204` — keeps the *same* `L`; no `pi` needed.
- `AlgebraicGeometry.isSplitWitness_map_overSpecMap_iff` (the full iff along `e : K ≃ₐ[k] K'`) — `Pic0ChartLocusIsoInvariance.lean:240` — no `pi` needed.

### (c) Along residue-field maps induced by `Over.testPoint` / field points
- ISO case, packaged as an iff: `AlgebraicGeometry.isSplitWitnessIsoInvariant_holds` — `Pic0ChartLocusIsoInvariance.lean:263`, proving `IsSplitWitnessIsoInvariant C` (defined `Pic0ChartLocusGeneralTest.lean:129`). It gives, for `f : T' ⟶ T`, `t : T'.left` with `IsIso (Over.testPointFieldMap f t)`:
  `IsSplitWitness C (picEtMap C (Over.testPoint t) (picEtMap C f mu)) ↔ IsSplitWitness C (picEtMap C (Over.testPoint (f.left.base t)) mu)`.
  Proof route: `Over.testPoint_comp` naturality reduces to `overSpecMap` of the residue-field algHom, then `isSplitWitness_map_overSpecMap_iff` at the induced `≃ₐ`. No `pi` required.
- GENERAL (non-iso) field points: NOT packaged as a single iff, but obtainable in both directions by combining `Over.testPoint_comp` (naturality) with (a)/(b) at the algHom `Over.testPointFieldAlgHom f t`. These each require `pi`.

### Membership converse (Pic0RankOneSplitOfPresentation.lean ~169)
The name `isSplitWitness_testPoint_of_mem` **does NOT exist** anywhere in the project. The two membership lemmas that DO exist:
- `AlgebraicGeometry.mem_picRankOneOpen_of_isSplitWitness` — `Pic0RankOneNativePresentationSplit.lean:114` (split ⟹ membership; needs `hpi : pi ≫ P1.structureMap k = C.hom`).
- `AlgebraicGeometry.isSplitWitness_of_mem_picRankOneOpen_field` — `Pic0RankOneSplitOfPresentation.lean:169`:
```
theorem isSplitWitness_of_mem_picRankOneOpen_field
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    {K : Type u} [Field K] [Algebra k K]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k K)}
    (h : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k K))) :
    IsSplitWitness C lam.1
```
(built on `PicRankOneLocalPresentation.isSplitWitness`, `Pic0RankOneSplitOfPresentation.lean:129`). Together with `mem_picRankOneOpen_of_isSplitWitness` this is a fibrewise characterization at fields.

The datum-level engine under all of this is the full field-extension iff (any extension in the tower, both directions):
`BasicOpenCocycleDatum.hasWitnessH1Vanishing_iff_of_fieldExtension` — `Pic0ChartLocusFibreField.lean:142`.

**CAVEAT for scheduling (not a defect, but a hypothesis to budget):** every *arbitrary-embedding* transport of `IsSplitWitness` (directions a, b, and hence the general/non-iso case of c) is threaded through an auxiliary finite map `pi : C.left ⟶ P1 k` with `[IsFinite pi]`. Only the *isomorphism*-restricted transports (`isSplitWitness_map_overSpecMap`, `..._iff`, `isSplitWitnessIsoInvariant_holds`) are `pi`-free. Any consumer wanting a `pi`-free iff along a *non-iso* field map does not have it off the shelf.

---

## ITEM 2 — L1 PLUMBING — VERDICT: CONFIRMED usable; all ingredients exist, derivation is well under 50 lines (the full proof already appears inline elsewhere)

How `picEt` is the affine-opens limit — `AlgebraicJacobian/Picard/PicEt.lean`:
- `picEtSubgroup` (`PicEt.lean:91`) / `def picEt := picEtSubgroup C T` (`PicEt.lean:105`): a subgroup of `Π U : T.left.affineOpens, PicEtAff C Γ(T.left, U.1)` cut out by the restriction-compatibility `PicEtAff.mapAlg C (Over.resAlgHom T h) (s V) = s U`. So for `lam : picEt C T`, the component is `lam.1 U : PicEtAff C Γ(T.left, U.1)`; for a `picDegLayer` class (`ThetaShift.lean:162`, a subtype of `picEt`) it is `lam.1.1 U`. The design's notation is exactly right.
- `picEtAffineEquiv C A : picEt C (overSpec k A) ≃* PicEtAff C A` (`PicEt.lean:235`), with `picEtAffineEquiv_apply` (`PicEt.lean:240`): `picEtAffineEquiv C A s = PicEtAff.mapAlg C (overSpecΓTopAlgEquiv k A).toAlgHom (s.1 (overSpecTopAffine A))`.

The exact identity the design needs — `lam.1.1 U = picEtAffineEquiv C Γ(T.unop.left, U.1) (picEtMap C (Over.fromSpecAffine T.unop U) lam.1)` — is **NOT currently a standalone named lemma**, but its complete proof already exists inline inside `rigidity_of_rigidityAff` (`Pic0RigidityAffineReduction.lean:158-181`). Extracting it as a named lemma is ~10 lines. The named ingredients, all present and sorry-free:

1. `AlgebraicGeometry.picEtAffineEquiv_apply` — `PicEt.lean:240` (collapse the equiv at `⊤`).
2. `AlgebraicGeometry.picEtMap_val` — `PicEtMap.lean:256` (`(picEtMap C f s).1 W = picEtMapVal C f s W`).
3. `AlgebraicGeometry.picEtMapVal_eq_mapAlg` — `PicEtMap.lean:227`:
   `picEtMapVal C f s W = PicEtAff.mapAlg C (Over.appLEAlgHom f V.1 W.1 hV) (s.1 V)` for `hV : W.1 ≤ f.left ⁻¹ᵁ V.1`. This is precisely "the component of `picEtMap` along a morphism at an affine open."
4. `AlgebraicGeometry.top_le_preimage_fromSpecAffine` — `Pic0RigidityAffineReduction.lean:107`: supplies the `hV` for `f = Over.fromSpecAffine T U`, `V = U`, `W = overSpecTopAffine Γ(T.left,U.1)` (via `IsAffineOpen.fromSpec_preimage_self`).
5. `AlgebraicGeometry.fromSpecAffine_ΓTop_comp_appLEAlgHom` — `Pic0RigidityAffineReduction.lean:120`: the bookkeeping identity
   `(overSpecΓTopAlgEquiv k Γ(T.left,U.1)).toAlgHom.comp (Over.appLEAlgHom (Over.fromSpecAffine T U) U.1 (overSpecTopAffine …).1 (top_le_preimage_fromSpecAffine T U)) = AlgHom.id k Γ(T.left, U.1)`. This is the load-bearing "the composite is the identity" fact.
6. `PicEtAff.mapAlg_comp` and `PicEtAff.mapAlg_id` (used in the same calc, `Pic0RigidityAffineReduction.lean:177-181`).

For the affine-`Spec`-of-algHom variant there is also the ready-made `AlgebraicGeometry.picEtAffineEquiv_naturality` (`PicEtMap.lean:354`): `picEtAffineEquiv C B (picEtMap C (Over.overSpecMap φ) s) = PicEtAff.mapAlg C φ (picEtAffineEquiv C A s)`. The exact chaining you want (compose `overSpecMap φ ≫ fromSpecAffine T U`, apply `picEtAffineEquiv`, rewrite with `picEtAffineEquiv_naturality` + `picEtMapVal_eq_mapAlg` + `fromSpecAffine_ΓTop_comp_appLEAlgHom`) is exactly what `rigidity_of_rigidityAff` (`Pic0RigidityAffineReduction.lean:162-181`) does. No gap.

---

## ITEM 3 — OPEN IMAGE (flat + finite presentation ⟹ open) — VERDICT: CONFIRMED usable; present in pinned mathlib at both scheme and ring level

Scheme level — `Mathlib/AlgebraicGeometry/Morphisms/UniversallyOpen.lean`:
- `AlgebraicGeometry.UniversallyOpen.of_flat` — `UniversallyOpen.lean:145` (an `instance`, priority low):
  ```
  instance (priority := low) UniversallyOpen.of_flat [Flat f] [LocallyOfFinitePresentation f] :
      UniversallyOpen f
  ```
- `AlgebraicGeometry.Scheme.Hom.isOpenMap` — `UniversallyOpen.lean:48`:
  ```
  lemma Scheme.Hom.isOpenMap {X Y : Scheme} (f : X ⟶ Y) [UniversallyOpen f] : IsOpenMap f
  ```
  So for `f : X ⟶ Y` with `[Flat f] [LocallyOfFinitePresentation f]`, `f.isOpenMap : IsOpenMap f` fires by instance resolution; the image of any open (in particular `Set.range f.base` / `f.opensRange`) is open.
- Underlying general lemma: `AlgebraicGeometry.isOpenMap_of_generalizingMap [LocallyOfFinitePresentation f] (hf : GeneralizingMap f) : IsOpenMap f` — `UniversallyOpen.lean:108` (stacks 01U1); and `AlgebraicGeometry.Flat.generalizingMap [Flat f] : GeneralizingMap f` — `UniversallyOpen.lean:132`.

Ring / `PrimeSpectrum` level — `Mathlib/RingTheory/Spectrum/Prime/Chevalley.lean`:
- `PrimeSpectrum.isOpenMap_comap_of_hasGoingDown_of_finitePresentation` — `Chevalley.lean:59` (stacks 00I1):
  ```
  lemma isOpenMap_comap_of_hasGoingDown_of_finitePresentation
      [Algebra R S] [Algebra.HasGoingDown R S] [Algebra.FinitePresentation R S] :
      IsOpenMap (comap (algebraMap R S))
  ```
  Note it is stated with `Algebra.HasGoingDown R S` (which `Module.Flat R S` supplies via `Algebra.HasGoingDown.of_flat`, used at `UniversallyOpen.lean:140`), not with `Flat` literally.
- For the range/image specifically there is also `PrimeSpectrum.isConstructible_range_comap {f : R →+* S} (hf : f.FinitePresentation) : IsConstructible (Set.range (comap f))` — `Chevalley.lean:54` (constructibility of the image; combine with going-down/flat for openness).
- Field base-change special case (used to build the above): `PrimeSpectrum.isOpenMap_comap_algebraMap_tensorProduct_of_field` — `Chevalley.lean:72` (stacks 037G).

Most directly usable statement for "the image of `Spec B → Spec A` is open when `A → B` is flat of finite presentation": at scheme level, `[Flat f] [LocallyOfFinitePresentation f] ⟹ UniversallyOpen f ⟹ IsOpenMap f` (`UniversallyOpen.of_flat` + `Scheme.Hom.isOpenMap`); at ring level, `[Module.Flat R S] [Algebra.FinitePresentation R S] ⟹ Algebra.HasGoingDown R S ⟹ IsOpenMap (PrimeSpectrum.comap (algebraMap R S))` (`Algebra.HasGoingDown.of_flat` + `isOpenMap_comap_of_hasGoingDown_of_finitePresentation`).

The project itself does **not** re-prove any of this — grep for `IsOpenMap`/`isOpen_range`/`isOpenMap` across `AlgebraicJacobian/` returned no local open-image-of-flat-morphism lemma; consumers should pull directly from mathlib as above.

---

### One-line verdicts
1. CONFIRMED — DOWN (`isSplitWitness_of_overSpecMap`) and UP (`isSplitWitness_map_overSpecMap_of_algHom`) both exist for arbitrary field embeddings; iso-case iff (`isSplitWitness_map_overSpecMap_iff`, `isSplitWitnessIsoInvariant_holds`) and membership converse (`isSplitWitness_of_mem_picRankOneOpen_field`) exist. CAVEAT: arbitrary-embedding transports require a finite `pi : C.left ⟶ P1 k`; `isSplitWitness_testPoint_of_mem` does not exist (use `isSplitWitness_of_mem_picRankOneOpen_field`).
2. CONFIRMED — every ingredient (`picEtMapVal_eq_mapAlg`, `picEtAffineEquiv_apply`, `top_le_preimage_fromSpecAffine`, `fromSpecAffine_ΓTop_comp_appLEAlgHom`, `picEtAffineEquiv_naturality`, `PicEtAff.mapAlg_comp/id`) is present; the target identity's full proof already appears inline in `rigidity_of_rigidityAff`; deriving the named lemma is ~10 lines.
3. CONFIRMED — `UniversallyOpen.of_flat` + `Scheme.Hom.isOpenMap` (scheme level) and `isOpenMap_comap_of_hasGoingDown_of_finitePresentation` (+ `Algebra.HasGoingDown.of_flat`) at ring level are in the pinned mathlib; project has no competing local lemma.
