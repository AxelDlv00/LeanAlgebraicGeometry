## 1. Every `JacobianData C` producer from a vanishing/rigidity hypothesis

There are exactly **five**, all sorry-free and all in the root import (`AlgebraicJacobian.lean:714-723`). All five funnel through one core producer.

**Core.** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0VanishingRoute.lean:175` and `:204`

Section context (lines 134-136): `{k : Type u} [Field k] {C : Over (Spec (.of k))}`, `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`; `variable (C) in` makes `C` explicit.

```lean
def pic0RepresentableBy_terminal_of_subsingleton
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T)) :
    (pic0TypeFunctor C).RepresentableBy (Over.mk (𝟙 (Spec (CommRingCat.of k)))) where

def jacobianData_of_subsingleton
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T)) :
    JacobianData C
```
Undischarged: `h` alone. The other two `JacobianData` fields are `locallyOfFiniteType_terminal` (:151) and `quasiCompact_terminal` (:157), both `infer_instance` on `𝟙`.

**Pic0VanishingRoute.lean:296** — `picEt`-level ring hypothesis (strictly stronger; false at any curve with a degree-one class):
```lean
def jacobianData_of_affine_subsingleton
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (PicEtAff C A)) :
    JacobianData C
```
Undischarged: `h`. Grep confirms **no producer anywhere** of `Subsingleton (PicEtAff C A)` — the only four occurrences in the tree are the binders in this file (:251, :270, :284, :297).

**Pic0VanishingAffineReduction.lean:266** — same hypothesis with the `∀ T` binder reduced to test rings (and the reduction is proved an *equivalence*, so nothing is lost):
```lean
def jacobianData_of_overSpec_subsingleton
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A],
      Subsingleton (pic0Subgroup C (overSpec k A))) :
    JacobianData C :=
  jacobianData_of_subsingleton C (subsingleton_pic0Subgroup_of_overSpec C h)
```
Undischarged: `h` at non-field `A`. All *field* instances are closed (item 3).

**Pic0RigidityAffineReduction.lean:190** — the shortest-antecedent producer in the tree. Section context lines 126-128: `(C : Over (Spec (.of k)))`, `[IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]`:
```lean
def jacobianData_of_rigidityAff (hg : genus C = 0)
    (hA : ∀ (A : Type u) [CommRing A] [Algebra k A] (q : PicEtAff C A),
      (∀ (K : Type u) [Field K] [Algebra k K] (φ : A →ₐ[k] K),
        PicEtAff.mapAlg C φ q = 1) → q = 1) : JacobianData C :=
  jacobianData_of_subsingleton C (subsingleton_pic0Subgroup_of_rigidityAff C hg hA)
```
Undischarged: `hA` (no producer). `hg` **is** discharged at `ℙ¹` — `P1.genus_asOver_eq_zero` (`Curve/P1H1Vanishing.lean:187`), sorry-free, arbitrary field.

**Albanese/Genus0VanishingDatum.lean:93** — the `= ⊥` spelling, for `Genus0Terminal`'s consumers:
```lean
def jacobianData_of_vanishing
    (h : ∀ T : Over (Spec (.of k)), pic0Subgroup C T = ⊥) :
    JacobianData C :=
  jacobianData_of_subsingleton C fun T => subsingleton_of_pic0Subgroup_eq_bot (h T)
```
The two spellings are interderivable: `pic0Subgroup_eq_bot_of_subsingleton` / `subsingleton_of_pic0Subgroup_eq_bot` (Pic0VanishingRoute.lean:308, :315).

**Nothing else.** There is no `Nonempty (JacobianData …)` theorem, no `JacobianData (P1.asOver k)` instance, and no `instance : Subsingleton (pic0Subgroup …)` anywhere (all three greps empty).

## 2. The exact gap hypotheses

**Pic0VanishingAffineReduction.lean:190** — `C` explicit:
```lean
theorem subsingleton_pic0Subgroup_forall_iff_overSpec :
    (∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T))
      ↔ ∀ (A : Type u) [CommRing A] [Algebra k A],
          Subsingleton (pic0Subgroup C (overSpec k A)) :=
  ⟨fun h A _ _ => subsingleton_pic0Subgroup_overSpec_of_forall C h A,
    fun h => subsingleton_pic0Subgroup_of_overSpec C h⟩
```
So the affine-side hypothesis says literally: *for every commutative `k`-algebra `A`, the degree-zero subgroup of `picEt C (overSpec k A)` has at most one element*. Membership unfolds (`Pic0Functor.lean:107-108`) to
```lean
  carrier := {lam | ∀ (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T),
    degAt lam t = 0}
```
Also available, same file, the plus-class coordinates version (:236), which is the *sufficient* direction only:
```lean
theorem subsingleton_pic0Subgroup_of_picEtAff_sep
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A] (q q' : PicEtAff C A),
      (∀ (K : Type u) (_ : Field K) (_ : Algebra k K) (t : overSpec k K ⟶ overSpec k A),
        degAt ((picEtAffineEquiv C A).symm q) t = 0) →
      (∀ (K : Type u) (_ : Field K) (_ : Algebra k K) (t : overSpec k K ⟶ overSpec k A),
        degAt ((picEtAffineEquiv C A).symm q') t = 0) →
      q = q')
    (A : Type u) [CommRing A] [Algebra k A] :
    Subsingleton (pic0Subgroup C (overSpec k A))
```

**The rigidity hypothesis is named `hA`, not `hrigAff`** (the docstring calls it `hrigAff`; the binder is `hA`). Pic0RigidityAffineReduction.lean:141, with `omit [SmoothOfRelativeDimension 1 C.hom] in`:
```lean
theorem rigidity_of_rigidityAff
    (hA : ∀ (A : Type u) [CommRing A] [Algebra k A] (q : PicEtAff C A),
      (∀ (K : Type u) [Field K] [Algebra k K] (φ : A →ₐ[k] K),
        PicEtAff.mapAlg C φ q = 1) → q = 1)
    (T : Over (Spec (.of k))) (lam : picEt C T)
    (h : ∀ (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T),
      picEtMap C t lam = 1) : lam = 1
```
and its `pic⁰` consequence (:178):
```lean
theorem subsingleton_pic0Subgroup_of_rigidityAff (hg : genus C = 0)
    (hA : ∀ (A : Type u) [CommRing A] [Algebra k A] (q : PicEtAff C A),
      (∀ (K : Type u) [Field K] [Algebra k K] (φ : A →ₐ[k] K),
        PicEtAff.mapAlg C φ q = 1) → q = 1)
    (T : Over (Spec (.of k))) : Subsingleton (pic0Subgroup C T)
```
`hA` mentions no scheme, no open, no morphism of schemes — only `k`-algebras `A`, plus classes, and `A →ₐ[k] K` into fields. This file does **not** prove the converse of `rigidity_of_rigidityAff` (docstring is explicit about that).

**Pic0VanishingRigidityReduction.lean:158** — the equivalence, both directions proved:
```lean
theorem pic0Vanishing_iff_rigidity (hg : genus C = 0) :
    (∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup C T))
      ↔ ∀ (T : Over (Spec (.of k))) (lam : picEt C T),
          (∀ (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T),
            picEtMap C t lam = 1) → lam = 1 :=
  ⟨rigidity_of_pic0Vanishing C, subsingleton_pic0Subgroup_of_rigidity C hg⟩
```
The converse half `rigidity_of_pic0Vanishing` (:141) needs **no** genus hypothesis. Note the object-level shape: `hrig` is field-point separation of the *presheaf* `picEt C ·`; no degree, no χ, no divisor, no chart appears in it.

**No producer** for `hA` or for `hrig`: greps for the shapes `PicEtAff.mapAlg C φ q = 1) → q = 1` and `picEtMap C t lam = 1) → lam = 1` hit only Pic0RigidityAffineReduction.lean and Pic0VanishingRigidityReduction.lean, and only as binders/conclusions of the reductions themselves. The nearest landed separation results are along *étale covers*, a different family of test maps: `PicEtAff.unit_injective` (`Picard/EtaleSeparatedness.lean:16`, also `CechKernelLemma.lean:361`) and `relPicAlgMap_injective_of_etaleCover` (`Picard/RelPicCoverInjective.lean:81`).

## 3. What IS closed (field test / genus 0 / ℙ¹)

**Pic0VanishingFieldTest.lean:149** — the field-test vanishing. Section vars 91-93 give four curve binders; `omit [GeometricallyReduced C.hom] in`:
```lean
theorem subsingleton_pic0Subgroup_overSpec_field_of_genus_zero
    (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0) :
    Subsingleton (pic0Subgroup C (overSpec k K))
```
**Pic0VanishingFieldTest.lean:172** — the ℙ¹ version, no hypothesis at all:
```lean
theorem P1.subsingleton_pic0Subgroup_overSpec_field
    (k : Type u) [Field k] (K : Type u) [Field K] [Algebra k K] :
    Subsingleton (pic0Subgroup (P1.asOver k) (overSpec k K)) :=
  subsingleton_pic0Subgroup_overSpec_field_of_genus_zero (P1.asOver k) K
    (P1.genus_asOver_eq_zero k)
```
Its step-1 input, Pic0VanishingFieldTest.lean:108:
```lean
theorem eq_one_of_degAff_eq_zero_of_genus_zero
    (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (q : PicEtAff C K) (hq : PicEtAff.degAff (C := C) K q = 0) : q = 1
```
Needs **no curve section / rational point** (`PicEtAff.unit_surjective_of_section`, `EffectivityClose.lean:141`, is not used).

Below that, Pic0VanishingFieldGenusZero.lean:89, :109, :124:
```lean
theorem chi_moduleKSheaf_baseChange_eq_one_of_genus_zero
    (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0) :
    Sheaf.chi ((C ⊗ overSpec k K).left.moduleKSheaf K) = 1

theorem relPic_eq_one_of_relPicDeg_eq_zero_of_genus_zero
    (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (y : relPic C (overSpec k K)) (hy : relPicDeg (C := C) K y = 0) : y = 1

theorem relPicDeg_eq_zero_iff_of_genus_zero
    (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (y : relPic C (overSpec k K)) :
    relPicDeg (C := C) K y = 0 ↔ y = 1
```
ℙ¹ forms of the two reductions (genus discharged, rigidity still assumed) — Pic0VanishingRigidityReduction.lean:174 and Pic0RigidityAffineReduction.lean:199:
```lean
theorem P1.subsingleton_pic0Subgroup_of_rigidity (k' : Type u) [Field k']
    (hrig : ∀ (T : Over (Spec (.of k'))) (lam : picEt (P1.asOver k') T),
      (∀ (K : Type u) [Field K] [Algebra k' K] (t : overSpec k' K ⟶ T),
        picEtMap (P1.asOver k') t lam = 1) → lam = 1)
    (T : Over (Spec (.of k'))) : Subsingleton (pic0Subgroup (P1.asOver k') T)

theorem P1.subsingleton_pic0Subgroup_of_rigidityAff (k' : Type u) [Field k']
    (hA : ∀ (A : Type u) [CommRing A] [Algebra k' A] (q : PicEtAff (P1.asOver k') A),
      (∀ (K : Type u) [Field K] [Algebra k' K] (φ : A →ₐ[k'] K),
        PicEtAff.mapAlg (P1.asOver k') φ q = 1) → q = 1)
    (T : Over (Spec (.of k'))) : Subsingleton (pic0Subgroup (P1.asOver k') T)
```
`Curve/P1DegreeZeroTrivial.lean` has only the base-changed-χ/`classDeg` layer (:115, :138, :145, :156) — its own header says it does not discharge the `∀ T` binder.

The seam side: `Pic0ChartSeamPairDecided.lean:469` proves the coverage antecedent at parameter `0` **is** the same hypothesis:
```lean
theorem isLocallySurjective_abelSigmaChartZero_iff
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ)) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
        (abelSigmaChartZero (C := C) (pi := pi) m Z hdeg)
      ↔ ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)
```

## 4. `fibre_eq_one_of_mem_pic0Subgroup`

`Pic0VanishingRigidityReduction.lean:104`:
```lean
theorem fibre_eq_one_of_mem_pic0Subgroup (hg : genus C = 0) {T : Over (Spec (.of k))}
    (lam : pic0Subgroup C T) (K : Type u) [Field K] [Algebra k K] (t : overSpec k K ⟶ T) :
    picEtMap C t (lam : picEt C T) = 1
```
Generality: **arbitrary** test object `T` — no affineness, no quasi-compactness, no finiteness. Conclusion is in `picEt C (overSpec k K)`, i.e. the restricted class is literally the trivial class. This is the one step that spends the degree condition; proof is `Subsingleton.elim` against the field-test theorem. The affine specializations in `Pic0RingFibrewiseTrivial.lean:141`/`:149` are strictly weaker and that file's own header (lines 34-47) says to cite this one instead.

## 5. Pic0RingDatumEngine.lean and Pic0RingEngineFromPic0.lean — every theorem

Shared section context, both files: `{k} [Field k] {C : Over (Spec (.of k))}`, `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`, `{B : Type u} [CommRing B] [Algebra k B]`, `{π : C.left ⟶ P1 k} [IsFinite π]`.

**Pic0RingDatumEngine.lean** (namespace `BasicOpenCocycleDatum`):
```lean
-- :110
theorem subsingleton_h1_moduleKSheaf_baseChange_of_genus_zero (hg : genus C = 0)
    (K : Type u) [Field K] [Algebra k K] :
    Subsingleton (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1)

-- :123
theorem subsingleton_h1_divisorSheaf_zero_of_genus_zero (hg : genus C = 0)
    (K : Type u) [Field K] [Algebra k K] :
    Subsingleton (Sheaf.HModule ((C ⊗ overSpec k K).left.divisorSheaf K
      (0 : (C ⊗ overSpec k K).left.CurveDivisor)) 1)

-- :138
theorem subsingleton_h1_residueField_tensor_of_genus_zero
    (D : BasicOpenCocycleDatum C B π) (hg : genus C = 0) (p : PrimeSpectrum B)
    (htriv : (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1) :
    Subsingleton ((datumPair D).H1 ⊗[B] p.asIdeal.ResidueField)

-- :152
theorem rigidEngine_of_genus_zero (D : BasicOpenCocycleDatum C B π) [IsNoetherianRing B]
    (hπ : π ≫ P1.structureMap k = C.hom) (hg : genus C = 0)
    (htriv : ∀ p : PrimeSpectrum B,
      (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1) :
    Subsingleton (Sheaf.HModule D.sheaf 1) ∧
      Module.Finite B (Sheaf.HModule D.sheaf 0) ∧
      Module.Projective B (Sheaf.HModule D.sheaf 0)

-- :170
theorem rankAtStalk_hModule_zero_eq_one_of_genus_zero
    (D : BasicOpenCocycleDatum C B π) [IsNoetherianRing B]
    (hπ : π ≫ P1.structureMap k = C.hom) (hg : genus C = 0)
    (htriv : ∀ p : PrimeSpectrum B,
      (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1)
    (p : PrimeSpectrum B) :
    Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1

-- :206  (five fibre instances as BINDERS here, installed by hand at the call sites)
theorem fibre_cechPicClass_eq_one_of_classDeg_eq_zero
    (D : BasicOpenCocycleDatum C B π) (hg : genus C = 0) (p : PrimeSpectrum B)
    [IsIntegral (relCurve C p.asIdeal.ResidueField)]
    [SmoothOfRelativeDimension 1
      (relCurve C p.asIdeal.ResidueField ↘ Spec (CommRingCat.of p.asIdeal.ResidueField))]
    [QuasiCompact
      (relCurve C p.asIdeal.ResidueField ↘ Spec (CommRingCat.of p.asIdeal.ResidueField))]
    [Module.Finite p.asIdeal.ResidueField (Sheaf.HModule
      ((relCurve C p.asIdeal.ResidueField).moduleKSheaf p.asIdeal.ResidueField) 0)]
    [Module.Finite p.asIdeal.ResidueField (Sheaf.HModule
      ((relCurve C p.asIdeal.ResidueField).moduleKSheaf p.asIdeal.ResidueField) 1)]
    (hdeg : classDeg p.asIdeal.ResidueField
      (D.baseChange p.asIdeal.ResidueField).cechPicClass = 0) :
    (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1
```

**Pic0RingEngineFromPic0.lean**:
```lean
-- :143
theorem relCurveMap_eq_whiskerLeft_residueField (C : Over (Spec (.of k)))
    (B : Type u) [CommRing B] [Algebra k B] (p : PrimeSpectrum B) :
    relCurveMap C B p.asIdeal.ResidueField
      = (C ◁ Over.overSpecMap
          ((Algebra.ofId B p.asIdeal.ResidueField).restrictScalars k)).left := rfl

-- :161
theorem exists_datum_relPicMk_eq (C : Over (Spec (.of k)))
    (B : Type u) [CommRing B] [Algebra k B] (π : C.left ⟶ P1 k) [IsFinite π]
    (z : relPic C (overSpec k B)) :
    ∃ D : BasicOpenCocycleDatum C B π, relPicMk C (overSpec k B) D.cechPicClass = z

-- :175
theorem exists_datum_pic0_presentation (C : Over (Spec (.of k)))
    (B : Type u) [CommRing B] [Algebra k B] (π : C.left ⟶ P1 k) [IsFinite π]
    (lam : picEt C (overSpec k B))
    (h : ∃ z : relPic C (overSpec k B), picEtAffineEquiv C B lam = PicEtAff.unit C B z) :
    ∃ D : BasicOpenCocycleDatum C B π,
      picEtAffineEquiv C B lam
        = PicEtAff.unit C B (relPicMk C (overSpec k B) D.cechPicClass)

-- :202
theorem htriv_of_pic0 (D : BasicOpenCocycleDatum C B π) (hg : genus C = 0)
    (lam : pic0Subgroup C (overSpec k B))
    (h : picEtAffineEquiv C B (lam : picEt C (overSpec k B))
      = PicEtAff.unit C B (relPicMk C (overSpec k B) D.cechPicClass))
    (p : PrimeSpectrum B) :
    (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1

-- :234
theorem rigidEngine_of_pic0 (D : BasicOpenCocycleDatum C B π) [IsNoetherianRing B]
    (hπ : π ≫ P1.structureMap k = C.hom) (hg : genus C = 0)
    (lam : pic0Subgroup C (overSpec k B))
    (h : picEtAffineEquiv C B (lam : picEt C (overSpec k B))
      = PicEtAff.unit C B (relPicMk C (overSpec k B) D.cechPicClass)) :
    Subsingleton (Sheaf.HModule D.sheaf 1) ∧
      Module.Finite B (Sheaf.HModule D.sheaf 0) ∧
      Module.Projective B (Sheaf.HModule D.sheaf 0)

-- :249
theorem rankAtStalk_hModule_zero_eq_one_of_pic0 (D : BasicOpenCocycleDatum C B π)
    [IsNoetherianRing B] (hπ : π ≫ P1.structureMap k = C.hom) (hg : genus C = 0)
    (lam : pic0Subgroup C (overSpec k B))
    (h : picEtAffineEquiv C B (lam : picEt C (overSpec k B))
      = PicEtAff.unit C B (relPicMk C (overSpec k B) D.cechPicClass))
    (p : PrimeSpectrum B) :
    Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1

-- :272
theorem presentation_of_relPicToPicEt (C : Over (Spec (.of k)))
    (B : Type u) [CommRing B] [Algebra k B] (π : C.left ⟶ P1 k) [IsFinite π]
    (z : relPic C (overSpec k B)) :
    ∃ D : BasicOpenCocycleDatum C B π,
      picEtAffineEquiv C B (relPicToPicEt C (overSpec k B) z)
        = PicEtAff.unit C B (relPicMk C (overSpec k B) D.cechPicClass)

-- :293
theorem exists_rankAtStalk_hModule_zero_eq_one_of_relPicToPicEt (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (B : Type u) [CommRing B] [Algebra k B] [IsNoetherianRing B]
    (π : C.left ⟶ P1 k) [IsFinite π] (hπ : π ≫ P1.structureMap k = C.hom)
    (hg : genus C = 0) (lam : pic0Subgroup C (overSpec k B))
    (z : relPic C (overSpec k B))
    (hz : (lam : picEt C (overSpec k B)) = relPicToPicEt C (overSpec k B) z) :
    ∃ D : BasicOpenCocycleDatum C B π,
      ∀ p : PrimeSpectrum B, Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1

-- :313
theorem P1.rankAtStalk_hModule_zero_eq_one_of_pic0 (k : Type u) [Field k]
    {B : Type u} [CommRing B] [Algebra k B] [IsNoetherianRing B]
    {π : (P1.asOver k).left ⟶ P1 k} [IsFinite π]
    (D : BasicOpenCocycleDatum (P1.asOver k) B π)
    (hπ : π ≫ P1.structureMap k = (P1.asOver k).hom)
    (lam : pic0Subgroup (P1.asOver k) (overSpec k B))
    (h : picEtAffineEquiv (P1.asOver k) B (lam : picEt (P1.asOver k) (overSpec k B))
      = PicEtAff.unit (P1.asOver k) B
          (relPicMk (P1.asOver k) (overSpec k B) D.cechPicClass))
    (p : PrimeSpectrum B) :
    Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1
```

**Which hypotheses in these two files are still binders:** `hπ : π ≫ P1.structureMap k = C.hom` (discharged by `Curve/MapToP1.lean:107 exists_isFinite_toP1`, sorry-free, so *free* at any curve with the three binders — but it comes bundled in an `∃`, so a consumer must `obtain` it); `[IsNoetherianRing B]` (the engine's own binder, removable per `Cohomology/DatumDescent.lean:547`); `hg : genus C = 0` (free at ℙ¹); `hz`/`h` — the `relPicToPicEt`-range condition, which is the genuinely open one. `exists_rankAtStalk_hModule_zero_eq_one_of_relPicToPicEt`'s docstring admits `hz` is known only at the trivial class (`map_one`), i.e. non-vacuous at a degenerate value; surjectivity of `relPicToPicEt` onto `picEt` over a ring has no producer (only the two prose mentions at :93, :289).

**What is proved about `rankAtStalk (Sheaf.HModule D.sheaf 0)`:** exactly `= 1` at every prime of `B` — the rank spelling of "`π_*L` is invertible". Nothing more. Its provenance is `DivisorDatumRankOne.lean:148 BasicOpenCocycleDatum.rankAtStalk_hModule_zero_eq_one` at `n := 0`, with the χ-normalization supplied from `genus C = 0`.

**Does anything conclude "the class is trivial" over a ring?** Not on this route. In these two files the only triviality conclusions are *fibrewise*: `cechPicClass = 1` at residue fields (`htriv_of_pic0`, `fibre_cechPicClass_eq_one_of_classDeg_eq_zero`, `subsingleton_h1_residueField_tensor_of_genus_zero`). The two engine outputs are `H¹ = 0` and `H⁰` finite projective of stalk rank 1 — "invertible pushforward" / "degree zero fibrewise", never "the class over `B` is `1`".

**But there is a ring-level `picClass = 1` producer elsewhere**, on the divisor-family carrier — `UnitEquationsTrivialClass.lean:102` and `:154` (section context `{k} [Field k] {C}`, `{R} [CommRing R] [Algebra k R]`, `{pi : C.left ⟶ P1 k} [IsAffineHom pi]`; **no** curve geometry binders at all):
```lean
theorem Scheme.LocalEquations.picClass_eq_one_of_isUnit_eqn (d : X.LocalEquations)
    (hu : ∀ x : X, IsUnit (d.eqn x)) : d.picClass = 1

theorem DivisorAdaptation.picClass_eq_one_of_isCertified_zero
    {d : (relCurve C R).LocalEquations} (A : DivisorAdaptation C R pi d)
    (hc : A.IsCertified 0) : d.picClass = 1
```
Its gap is the *converse production* step: from a degree-0 class on `C_A`, exhibit a certified family presenting it. That exists only over a **field** — `exists_divFam_divFamDivisor_eq` (`Picard/DivisorFamilyFieldSurj.lean:147`), whose certificate `isCertified_of_deg` (:104) is field-only because it uses `Module.Free.of_divisionRing`.

## 6. Evaluation map / seesaw / "trivial on all fibres ⟹ pulled back" — absent

- **`π^*π_*L → L`: absent.** No declaration constructs it. `Picard/DescentSectionEval.lean` has "evaluation maps" but they are `Γ(Spec A, V) ⊗[A] Mod →ₗ[A] Γ(Spec B, U)` for a descent-unit submodule — algebra-level, not the adjunction unit on a curve. `PicEtCourageBridge`-style "evaluation map" mentions in `Picard/PicEtCoverBridge.lean:189,248` are section-level too. The counit material in the tree is `Over.mapPullbackAdj` on the *slice* category (`JacobianDataBaseChange*`, `Pic0ThetaProjectionCoherence`), i.e. base change of test objects, not `π^*π_* ⇒ id` on sheaves.
- **Seesaw: absent.** Exactly one occurrence of the word in the whole tree, `Pic0RingEngineFromPic0.lean:247`, in prose saying the engine's output is what "the classical seesaw argument consumes next".
- **"trivial on all fibres ⟹ pulled back": absent.** The two hits for the phrase family are both prose statements of the gap (`Pic0VanishingFieldTest.lean:57`, `Pic0RingFibrewiseTrivial.lean:10`). The tree carries a documented *counterexample* pressure against the naive form: `Pic0RingFibrewiseTrivial.lean:90-93` records that `Subsingleton (CommRing.Pic (Polynomial A))` fails to synthesize even given `Subsingleton (CommRing.Pic A)` (Traverso–Swan), measured.
- **Cohomology-and-base-change producing triviality: absent.** `Cohomology/RelativeH1BaseChange.lean` is base-change *equivalences* of the H¹ cokernel carriers (`relH1BaseChange` etc.), not a triviality producer. `Cohomology/FibreSurjective.lean:32,71,83` gives Nakayama-style "fibrewise surjective ⟹ surjective" for module maps — the generic tool, but nothing applies it to a Picard class.
- **`RelCurveCollapse` (`Cohomology/RelCurveCollapse.lean`)**: builds the theta chart datum and its sheaf iso; the class results are `cechPicClass_thetaChartDatum` (:668) and `DivisorDatumInverse.lean:179 cechPicClass_thetaChartDatum_zero` — the *specific* theta datum at exponent 0 has trivial class over an arbitrary ring. That is a concrete datum, not a criterion.
- **`SectionsToDivisorsClass.lean:159/:212`** is the nearest thing to the missing step and runs the useful direction: a germ-regular / fibrewise-regular global section of the glued sheaf cuts a `LocalEquations` divisor whose `picClass` **is** `D.cechPicClass`. Combined with `DivisorDatumRankOne.lean:248 exists_fibrewise_generator_divisorDatum` (rank 1 ⟹ a Zariski-local fibrewise-nonzero generator on some `D(f)`), that is the live pushforward route — but the generator it produces is only local on `Spec B` and only fibrewise-nonzero, not the germ-regular *global* section `sectionLocalEquationsOfFibrewiseRegular` demands.

## Load-bearing candidates

Two disjoint frontiers, both with the genus and the map-to-ℙ¹ inputs already free at ℙ¹:

1. **`hA` of `jacobianData_of_rigidityAff`** (Pic0RigidityAffineReduction.lean:190) — ring-level field-point rigidity of `PicEtAff`. Shortest antecedent of any `JacobianData` producer, pure commutative algebra, no cohomology/divisor/pushforward. Landed separation results are along étale covers only, so this needs a genuinely new argument. `pic0Vanishing_iff_rigidity` guarantees nothing is lost by attacking it; the missing converse of `rigidity_of_rigidityAff` means the *affine* form may be strictly stronger than `hrig`, which is worth measuring before committing.
2. **The seam from the engine's rank-1 output to a germ-regular global section** (`DivisorDatumRankOne.lean:248` → `SectionsToDivisorsClass.lean:201`), plus **ring-level `isCertified_of_deg`** to feed `UnitEquationsTrivialClass.lean:154`. This route already has both cohomological outputs and the only ring-level `picClass = 1` producer in the tree; its blockers are local-to-global on the generator and the field-only certificate, not the absent `π^*π_*L → L`.
