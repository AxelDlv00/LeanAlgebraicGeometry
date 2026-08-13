I now have everything needed. Here is my complete reconnaissance report.

---

# Search Report

## QUESTION 1 — Canonical morphism `overSpec k Γ(T.left, U.1) ⟶ T` from an affine open: **EXISTS**

**Declaration:** `AlgebraicGeometry.Over.fromSpecAffine`
**File:** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicEtUnit.lean`
**Line:** 60 (in `namespace Over`, opened at line 55)

```lean
def fromSpecAffine (T : Over (Spec (.of k))) (U : T.left.affineOpens) :
    overSpec k Γ(T.left, U.1) ⟶ T :=
  Over.homMk U.2.fromSpec (by ...)
```

Its `.left` component is `U.2.fromSpec = IsAffineOpen.fromSpec U.2 : Spec Γ(T.left, U.1) ⟶ T.left`, which is exactly mathlib's `(affine open's isoSpec).inv ≫ U.ι`. This is precisely the morphism your Question 1 describes, structured over `Spec k` (the `homMk` obligation discharges the over-`Spec k` compatibility via `Over.ofHom_algebraMap_sections` / `IsAffineOpen.SpecMap_appLE_fromSpec`).

**Supporting lemmas in the same file / namespace:**
- `Over.fromSpecAffine_naturality` — PicEtUnit.lean:79: `Over.overSpecMap (Over.appLEAlgHom f V.1 W.1 e) ≫ fromSpecAffine T V = fromSpecAffine T' W ≫ f`
- `Over.fromSpecAffine_resAlgHom` — PicEtUnit.lean:94: `Over.overSpecMap (Over.resAlgHom T h) ≫ fromSpecAffine T V = fromSpecAffine T U`
- `Over.overSpecMap_ΓTop_fromSpecAffine_top` — PicEtUnit.lean:106: on an affine test, `fromSpecAffine (overSpec k A) (overSpecTopAffine A)` composed with the `ΓSpecIso` transport is `𝟙`.
- `top_le_preimage_fromSpecAffine` — `Pic0RigidityAffineReduction.lean:107`: `(overSpecTopAffine Γ(T.left,U.1)).1 ≤ (Over.fromSpecAffine T U).left ⁻¹ᵁ U.1`.

It is used widely (Pic0ChartLocusIsoInvariance, Pic0ChartLocusGeneralTest, Pic0RigidityAffineReduction, PicEtCrossBaseGraph, DivRepGlobalLift, Pic0ChartHonestAff, etc.).

---

## QUESTION 2 — Lemma computing `divFamZarAffAffineEquiv (divFamZarAff.map (fromSpecAffine T U) s) = s.1 U`: **DOES NOT EXIST** (as a packaged lemma)

I searched exhaustively. The **exact composite expression** you describe occurs in exactly one place:

- `/home/axel/.../AlgebraicJacobian/Picard/Pic0ChartHonestAff.lean:145-147`, inside the proof of `abelDivAff'_isPlusHonest`:
```lean
(divFamZarAffAffineEquiv C n Γ(T.left, U.1)
  (divFamZarAff.map C n (Over.fromSpecAffine T U) s)).picClass
```
It is used verbatim (never rewritten to `s.1 U`); the surrounding proof goes through `picEtMap_abelDivAff'` and `picEtAffineEquiv_relPicToPicEt`, not through any `= s.1 U` collapse. So **no lemma of the form you want is proved**.

**What DOES exist (the raw ingredients, unassembled for the `divFamZarAff` side):**
- `divFamZarAff.mapVal_eq_mapAlgHom` — `DivisorFamilyAffMap.lean:198`:
  `mapVal C n f s W = DivFamZarAff.mapAlgHom (Over.appLEAlgHom f V.1 W.1 hV) (s.1 V)` when `W.1 ≤ f.left ⁻¹ᵁ V.1`.
- `divFamZarAff.map_val` — `DivisorFamilyAffMap.lean:219`: `(map C n f s).1 W = mapVal C n f s W`.
- `divFamZarAffAffineEquiv_apply` — `DivisorFamilyAffVehicle.lean:219`: `divFamZarAffAffineEquiv C n R s = DivFamZarAff.mapAlgHom (Over.overSpecΓTopAlgEquiv k R).toAlgHom (s.1 (overSpecTopAffine R))`.
- `top_le_preimage_fromSpecAffine` (`Pic0RigidityAffineReduction.lean:107`) and `fromSpecAffine_ΓTop_comp_appLEAlgHom` (`Pic0RigidityAffineReduction.lean:120`, stating `(overSpecΓTopAlgEquiv …).comp (appLEAlgHom (fromSpecAffine T U) …) = AlgHom.id`).

Notably, **the exact analogue of your desired lemma is fully assembled — but for `picEt`, not for `divFamZarAff`** — inside `rigidity_of_rigidityAff` (`Pic0RigidityAffineReduction.lean:151`, esp. lines 166-181), which computes `picEtAffineEquiv C K (picEtMapVal … (fromSpecAffine T U) lam …) = PicEtAff.mapAlg C … (lam.1 U)`. The `divFamZarAff`/`divFamZarAffAffineEquiv` version of that collapse is not present.

**Existing naturality lemmas of `divFamZarAffAffineEquiv`** (none specialized to `fromSpecAffine`):
- `divFamZarAffAffineEquiv_pullGlobalAff` — `DivRepGlobalAffLift.lean:159`.
- `divFamZarAffAffineEquiv_toAffVehicle` — `DivisorFamilyAffVehicle.lean:291`.

---

## QUESTION 3 — Injectivity/uniqueness of `abelDivAff'` at an arbitrary test object `T`: **DOES NOT EXIST**

There is **no** `Function.Injective (abelDivAff' C n T)` and **no** theorem concluding `s₁ = s₂` (for `s₁ s₂ : divFamZarAff C n T`) from `abelDivAff' C n T s₁ = abelDivAff' C n T s₂`. What exists are only *iff-characterizations* (which do NOT yield injectivity):

- `chartValueAff_eq_iff_abelDivAff'_eq` — `Pic0AdmissibleAbelKernel.lean:41`:
  `chartValueAff C n m Z T s₁ = chartValueAff C n m Z T s₂ ↔ abelDivAff' C n T s₁ = abelDivAff' C n T s₂`.
- `abelDivAff'_eq_iff_forall_relPicMk_picClass_eq` — `Pic0AdmissibleAbelKernel.lean:52`:
  `abelDivAff' C n T s₁ = abelDivAff' C n T s₂ ↔ ∀ U : T.left.affineOpens, relPicMk C (overSpec k Γ(T.left,U.1)) (s₁.1 U).picClass = relPicMk … (s₂.1 U).picClass`.
- `chartValueAff_eq_iff_forall_relPicMk_picClass_eq` — `Pic0AdmissibleAbelKernel.lean:65`.
- `chartValueAff_eq_iff_forall_picClass_div_mem_picFromBase` — `Pic0AdmissibleAbelKernel.lean:79`.

Explicit negative confirmations in-tree: `Pic0ChartAbelNonInjective.lean:83` and `Pic0ChartAbelForkReduce.lean:16` both state that *nothing in the tree* concludes `s₁ = s₂` for two families from equality of their classes (that is the chart-typed non-injectivity discussion).

**The only divisor-uniqueness statement** is the affine-only interface you already named:
- `RankOneDivisorUniqueness` — `Pic0RankOneCanonicalDivisorDescent.lean:62`, a `def … : Prop` quantifying over `(S : Type u) [CommRing S] [Algebra k S]` and `F G : DivFamZarAff C S (genus C)`, concluding `F = G` from equality of `abelDivAffPlus C S F = abelDivAffPlus C S G = picEtAffineEquiv C S lam.1`. **No arbitrary-test-object (`T : Over (Spec (.of k))`) analogue exists.**
- The consumer `existsUnique_abel_divFamZarAff_of_etale_witness` (`Pic0RankOneCanonicalDivisorDescent.lean:81`) is likewise affine-only (`DivFamZarAff C A …`).

For contrast, the only related "injective" facts are for *different* maps: `divFamZarToAffVehicle_injective` (`DivisorFamilyAffVehicle.lean:277`, injectivity of the old→widened vehicle comparison, not of `abelDivAff'`) and `Function.Injective (chartValue …)` (`Pic0ChartAbelForkReduce.lean:251`, chart-typed).

---

## QUESTION 4 — Definition of `overSpec` and general Scheme → `Over (Spec (.of k))` constructions

**`overSpec`** — `AlgebraicGeometry.overSpec`
File: `/home/axel/.../AlgebraicJacobian/Cohomology/SectionsBaseChange.lean`, **line 97**:
```lean
noncomputable abbrev overSpec : Over (Spec (.of k)) :=
  Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k A)))
```
(with `variable (k) [CommRing k] (A) [CommRing A] [Algebra k A]`). Simp lemmas `overSpec_left` (`= Spec (.of A)`), `overSpec_hom` at lines 101/104.

**`overSpecMap`** — `AlgebraicGeometry.Over.overSpecMap`
File: `/home/axel/.../AlgebraicJacobian/Cohomology/RelativeSectionsLinear.lean`, **line 147**:
```lean
noncomputable def overSpecMap : overSpec k R' ⟶ overSpec k R :=
  Over.homMk (Spec.map (CommRingCat.ofHom (algebraMap R R'))) (by ...)
```
(with `[Algebra R R'] [IsScalarTower k R R']`) — the slice map from an `R`-algebra `R'`.

**`overSpecTopAffine`** — `AlgebraicGeometry.overSpecTopAffine`
File: `/home/axel/.../AlgebraicJacobian/Picard/PicEt.lean`, **line 156**:
```lean
def overSpecTopAffine : (overSpec k A).left.affineOpens := ...
```
The top affine open of `overSpec k A`; `Γ((overSpec k A).left, ⊤)` connects to `A` via `Over.overSpecΓTopAlgEquiv` (`PicEtSections.lean:176`, `≃ₐ[k]`).

**General Scheme → `Over (Spec (.of k))` / affine-open slice morphism:**
- There is **no** general "arbitrary `Scheme` ⟶ `Over (Spec (.of k))`" functor. The one construction turning an affine open into a slice morphism is exactly **`Over.fromSpecAffine`** (Q1, PicEtUnit.lean:60).
- The generic `Over.mk`/`Over.homMk` pattern for building slice objects/morphisms from a scheme morphism `x` into `T.left` is used pervasively as `Over.mk (x ≫ T.hom)` with `Over.homMk x rfl` (e.g. `Pic0EndgameContract.lean:76`, `PicEtCoverBridge.lean:174/179` which builds `Over.mk (W.1.ι ≫ T.hom)` / `Over.homMk W.1.ι rfl` for an affine-open inclusion `W`, `DivRankOneOpen.lean:145-146`, `Pic0AdmissibleAbelEtaleSheafification.lean:185/193`). These are ad-hoc `Over.mk (·≫ T.hom)`, not a named general functor.

Supporting section-ring plumbing used by these constructions (all in `namespace Over`, file `PicEtSections.lean`): `Over.appLEAlgHom` (line 91), `Over.resAlgHom` (referenced; defined via `sectionsAlgebra`), `Over.overSpecΓTopAlgEquiv` (line 176). `Scheme.isoSpec`/`toSpecΓ`/`IsAffineOpen.fromSpec` are used from mathlib (e.g. `Curve/SeparablyClosedPoints.lean`, `AbelianVariety/Rigidity.lean`), and `fromSpecAffine`'s `.left` is `IsAffineOpen.fromSpec`.

---

### Summary
- **Q1: EXISTS** — `Over.fromSpecAffine` (PicEtUnit.lean:60).
- **Q2: DOES NOT EXIST** — no lemma equates `divFamZarAffAffineEquiv (divFamZarAff.map (fromSpecAffine T U) s)` to `s.1 U`; only the generic ingredients (`mapVal_eq_mapAlgHom`, `top_le_preimage_fromSpecAffine`, `fromSpecAffine_ΓTop_comp_appLEAlgHom`) exist, and the collapse is assembled only for the `picEt` side (`rigidity_of_rigidityAff`).
- **Q3: DOES NOT EXIST** — no injectivity/arbitrary-test uniqueness of `abelDivAff'`; only iff-characterizations (`Pic0AdmissibleAbelKernel.lean:41,52,65,79`) and the affine-only `RankOneDivisorUniqueness` (`Pic0RankOneCanonicalDivisorDescent.lean:62`).
- **Q4:** `overSpec` (SectionsBaseChange.lean:97), `overSpecMap` (RelativeSectionsLinear.lean:147), `overSpecTopAffine` (PicEt.lean:156), affine-open slice morphism = `fromSpecAffine`; no general Scheme→slice functor beyond ad-hoc `Over.mk (x ≫ T.hom)`.
