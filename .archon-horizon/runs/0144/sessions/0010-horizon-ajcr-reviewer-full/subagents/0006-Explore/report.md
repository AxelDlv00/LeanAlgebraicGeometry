I have gathered comprehensive coverage. Here is my exhaustive report.

---

# Findings: "base-cover separatedness" for Čech Picard classes

Note on layout: all paths are absolute under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`. I abbreviate that prefix as `…/`. Mathlib lives at `../../.lake-packages/mathlib`.

The single most important distinction that runs through the whole answer: the project has a rich **family-level** (`DivFamZar` / `DivFamZarAff` / `DivFam` / `PicEtAff`) Zariski-away separation-and-glue theory over a spanning family, but it does **NOT** have a **CechPic-class-level** away-span separatedness (`CechPic.map` to each `Localization.Away (b i)` ⟹ equal). The only CechPic-class separatedness is for a **disjoint clopen partition**, not an overlapping Zariski open cover.

---

## Category 1 — CechPic class separatedness across an away/span family

**DOES NOT EXIST at the CechPic-class level for a spanning family.** There is no theorem of the shape "`∀ i, Scheme.CechPic.map (relCurveMap C R (Localization.Away (b i))) L = … L'` with `Ideal.span (Set.range b) = ⊤` ⟹ `L = L'`". I grepped every `CechPic` occurrence combined with `away|span|zariski|glue|sheaf|eq_of|inject`; the only class-level separatedness is the clopen-partition one below.

What DOES exist:

1. `…/AlgebraicJacobian/Picard/CechPicClopenSep.lean:188`
   `theorem CechPic.eq_of_map_eq_of_clopen (hdisj : ∀ i j, i ≠ j → (w i).opensRange ⊓ (w j).opensRange = ⊥) (hcover : ∀ y : Y, ∃ i, y ∈ (w i).opensRange) {L L' : Y.CechPic} (h : ∀ i, CechPic.map (w i) L = CechPic.map (w i) L') : L = L'`
   This is separation along a **disjoint clopen partition** (pairwise `⊓ = ⊥`), i.e. a decomposition, not a Zariski `D(b_i)` cover with overlaps.

2. The glue partner: `…/AlgebraicJacobian/Picard/CechPicClopenGlue.lean:312`
   `theorem exists_map_eq_of_clopen [Finite ι] …` (produces a class whose pullback to each clopen piece is a prescribed family).

The away-span separatedness that DOES exist lives one level down, on the divisor **families** (not on their `picClass` / CechPic image):

3. `…/AlgebraicJacobian/Picard/DivRepAwaySpanGlue.lean:225`
   `theorem DivFamZar.eq_of_awaySpan_eq {ι : Type} [Finite ι] (f : ι → S) (hspan : Ideal.span (Set.range f) = ⊤) {F G : DivFamZar C S π n} (h : ∀ p : ι, DivFamZar.mapAlgHom (IsScalarTower.toAlgHom k S (Localization.Away (f p))) F = DivFamZar.mapAlgHom (IsScalarTower.toAlgHom k S (Localization.Away (f p))) G) : F = G`

4. `…/AlgebraicJacobian/Picard/DivRepAwaySpanGlueAff.lean:99`
   `theorem DivFamZarAff.eq_of_awaySpan_eq {iota : Type} [Finite iota] (f : iota → S) (hspan : Ideal.span (Set.range f) = ⊤) {F G : DivFamZarAff C S n} (h : ∀ p, mapAlgHom (IsScalarTower.toAlgHom k S (Localization.Away (f p))) F = mapAlgHom … G) : F = G` (needs `[IsProper C.hom]`)

5. The underlying keystones these delegate to (arbitrary away carriers `S i` supplied as instances):
   - `…/AlgebraicJacobian/Picard/DivisorFamilyZarMapAlg.lean:240` `theorem DivFamZar.eq_of_away_eq {n : ℕ} {ι : Type u} [Finite ι] (g : ι → R) (S : ι → Type u) [∀ i, CommRing (S i)] [∀ i, Algebra k (S i)] [∀ i, Algebra R (S i)] [∀ i, IsScalarTower k R (S i)] [∀ i, IsLocalization.Away (g i) (S i)] (hg : Ideal.span (Set.range g) = ⊤) {F G : DivFamZar C R π n} (h : ∀ i, DivFamZar.mapAlg (S i) n F = DivFamZar.mapAlg (S i) n G) : F = G`
   - `…/AlgebraicJacobian/Picard/DivisorFamilyAffMapAlg.lean:375` `theorem DivFamZarAff.eq_of_away_eq [IsProper C.hom] {ι : Type u} [Finite ι] (g : ι → R) (S : ι → Type u) [instances…] (hg : Ideal.span (Set.range g) = ⊤) {F G : DivFamZarAff C R n} (h : ∀ i, DivFamZarAff.mapAlg (S i) n F = … G) : F = G`
   - `…/AlgebraicJacobian/Picard/DivisorFamilyZariskiSep.lean:272` `theorem DivFam.eq_of_away_eq {ι : Type u} [Finite ι] (g : ι → R) (S : ι → Type u) [instances…] (hg : Ideal.span (Set.range g) = ⊤) {F G : DivFam C R π n} (h : ∀ i, DivFam.mapAlg (S i) n F = … G) : F = G`

   All three reduce, per their proofs and docstrings, to the `DivEq`-level engine `Scheme.LocalEquations.divEq_of_divEq_pullback` over the open-immersion cover `relCurveMap C R (S i)`.

6. Matching existence/`∃!` glue in the same away-span spelling (companions, not separatedness):
   - `…/AlgebraicJacobian/Picard/DivRepAwaySpanGlue.lean:150` `DivFamZar.exists_glue_of_awaySpan`, `:258` `DivFamZar.existsUnique_glue_of_awaySpan`
   - `…/AlgebraicJacobian/Picard/DivRepAwaySpanGlueAff.lean:38` `DivFamZarAff.exists_glue_of_awaySpan`, `:119` `existsUnique_glue_of_awaySpan`
   - keystone `…/AlgebraicJacobian/Picard/DivisorFamilyZarGlue.lean:71` `theorem DivFamZar.exists_glue_of_away_compat …` (the pinned S5b keystone; full instance-parameterized signature there)

Bottom line for Cat 1: the `DivFamZar`/`DivFamZarAff` family separatedness `eq_of_awaySpan_eq` is exactly the away-span separatedness you want, **but on the family object**. To get a CechPic-class conclusion you would need to know the two classes are `picClass`es of families and that agreement holds at the family level (stronger than agreement of `CechPic.map picClass`). No lemma bridges "`CechPic.map` of `picClass` agrees on each `Away b_i`" to "families agree", nor a direct CechPic-class version.

---

## Category 2 — relPic base-separatedness

Two relevant landed results, but neither is the away-span/Zariski-cover separatedness you asked for.

DESCENT direction (the converse of what you want) — present and central:
- `…/AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean:140`
  `theorem exists_notMem_cechPicMap_eq_of_relPicMk_eq {B : Type u} [CommRing B] [Algebra k B] {L L' : (relCurve C B).CechPic} (h : relPicMk C (overSpec k B) L = relPicMk C (overSpec k B) L') (q : PrimeSpectrum B) : ∃ f : B, f ∉ q.asIdeal ∧ Scheme.CechPic.map (relCurveMap C B (Localization.Away f)) L = Scheme.CechPic.map (relCurveMap C B (Localization.Away f)) L'`
  i.e. `relPicMk`-equal ⟹ CechPic-equal on *one* `Away f` near each prime. This is the direction "relPicMk kernel = picFromBase, and base classes die Zariski-locally", not "agreement on a cover ⟹ relPicMk-equal".
- Consumer form: `…/AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean:169`
  `theorem DivFamZarAff.exists_notMem_picClass_map_eq_of_relPicMk_eq {B} [CommRing B] [Algebra k B] (F F' : DivFamZarAff C B (genus C)) (h : relPicMk C (overSpec k B) F.picClass = relPicMk C (overSpec k B) F'.picClass) (q : PrimeSpectrum B) : ∃ f : B, f ∉ q.asIdeal ∧ (DivFamZarAff.mapAlgHom (IsScalarTower.toAlgHom k B (Localization.Away f)) F).picClass = (DivFamZarAff.mapAlgHom … F').picClass`

FINITE-PRODUCT separation (different cover shape — a `Π`-decomposition, proved via the clopen machinery, NOT a spanning `Away` family):
- `…/AlgebraicJacobian/Picard/RelPicPi.lean:297`
  `theorem relPic.eq_of_pi_proj_eq [Finite ι] {ζ ζ' : relPic C (overSpec k (Π j, B j))} (h : ∀ i, relPicAlgMap C (Pi.evalAlgHom k B i) ζ = relPicAlgMap C (Pi.evalAlgHom k B i) ζ') : ζ = ζ'`
  Its proof calls `Scheme.CechPic.exists_map_eq_of_clopen` + `Scheme.CechPic.eq_of_map_eq_of_clopen` — again clopen, not overlapping-Zariski.

ÉTALE-cover separation (not Zariski away, but the closest "cover" separatedness for relPic/PicEtAff):
- `…/AlgebraicJacobian/Picard/RelPicCoverInjective.lean:81`
  `theorem relPicAlgMap_injective_of_etaleCover (E : Algebra.EtaleCover R) : Function.Injective (relPicAlgMap C ((Algebra.ofId R E.Carrier).restrictScalars k))`
- `…/AlgebraicJacobian/Picard/PicEtAffZariskiSep.lean:137`
  `theorem eq_of_away_eq (hg : Ideal.span (Set.range g) = ⊤) {x y : PicEtAff C A} (h : ∀ i, PicEtAff.mapAlg C (IsScalarTower.toAlgHom k A (S i)) x = PicEtAff.mapAlg C (IsScalarTower.toAlgHom k A (S i)) y) : x = y`
  This **is** an away-span separatedness, but for `PicEtAff` (the étale plus-construction / sheafified relative Pic), not for `relPic` or for `relPicMk` of CechPic classes.

Subsingleton edge case: `…/AlgebraicJacobian/Picard/Pic0RingZariskiLocal.lean:153` `theorem subsingleton_relPic_of_subsingleton (A) [CommRing A] [Algebra k A] [Subsingleton A] : Subsingleton (relPic C (overSpec k A))`.

"relPic is a Zariski sheaf on the base": NOT stated as such. The nearest is `Pic0ZariskiSheaf.lean` (see Cat 5), which is about the `PicEtAff`/`pic0` functor, established through `PicEtAffZariskiSep`/`PicEtAffZariskiGlue`.

---

## Category 3 — Pic of a ring is a Zariski sheaf

**DOES NOT EXIST**, neither in the project nor in mathlib, as an injectivity `CommRing.Pic R → ∏ CommRing.Pic (Localization.Away (b i))` for a spanning family, nor as a sheaf/glue statement.

What the project HAS (local triviality, not sheaf/product-injectivity):
- `…/AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean:61`
  `theorem CommRing.Pic.exists_notMem_mapAlgebra_eq_one {B : Type u} [CommRing B] (P : CommRing.Pic B) (q : PrimeSpectrum B) : ∃ f : B, f ∉ q.asIdeal ∧ CommRing.Pic.mapAlgebra B (Localization.Away f) P = 1`
  Proof: invertible module is finite projective ⟹ free at the stalk (`Module.free_of_flat_of_isLocalRing`) ⟹ free spreads to a basic open (`Module.FinitePresentation.exists_free_localizedModule_powers`). This is exactly "each class dies near each prime", i.e. one half of a sheaf argument, but there is no assembly into a global injectivity.
- Affine-scheme transport of the same: `…/AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean:91` `theorem exists_notMem_cechPicMap_specMap_eq_one {B} [CommRing B] (N : (Spec (CommRingCat.of B)).CechPic) (q : PrimeSpectrum B) : ∃ f : B, f ∉ q.asIdeal ∧ Scheme.CechPic.map (Spec.map (CommRingCat.ofHom (algebraMap B (Localization.Away f)))) N = 1`.

Mathlib (`../../.lake-packages/mathlib/Mathlib/RingTheory/PicardGroup.lean`, where `CommRing.Pic` is defined): has `Pic.of_isLocalization` (line 358, `Module.Invertible A N` for a localized module), `Pic.mapAlgebra` (521), `mk_eq_one_iff_free` (465), `mapAlgebra_mapAlgebra` (531). It has **no** Zariski-sheaf / localization-span injectivity; the file's own module docstring (line ~60) still lists "Exhibit isomorphism with sheaf cohomology H¹(Spec R, 𝓞ˣ)" as a TODO. So this building block would have to be built (it does not come from mathlib today). The project's `exists_notMem_mapAlgebra_eq_one` is the reusable primitive to build it from.

---

## Category 4 — H⁰ of the relative curve equals the base

**EXISTS**, cleanly, over an arbitrary commutative `k`-algebra `R`:

- `…/AlgebraicJacobian/Cohomology/RelativeTwoCover.lean:170`
  `noncomputable def relStructureSectionsTop : Γ(relCurve C R, ⊤) ≃+* R := (Over.universalSectionsEquiv C R).symm`
  In scope under `variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (the `StandingBundle` section, line 162). Docstring: "`Γ(C_R, ⊤) ≃+* R`, universally in the commutative `k`-algebra `R`" — Kleiman's `𝒪_S ≅ f_* 𝒪_X` read as base change. This is the `H⁰` = base statement.

Supporting/adjacent:
- `…/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:279` `noncomputable def Scheme.moduleKSheafHZero : Sheaf.HModule (X.moduleKSheaf k) 0 ≃ₗ[k] Γ(X, ⊤)` — identifies `H⁰(moduleKSheaf 0)` with global sections.
- `…/AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean:304` `R ⊗[k] Sheaf.HModule (C.left.moduleKSheaf k) 0 ≃ₗ[R] Sheaf.HModule ((relCurve C R).moduleKSheaf R) 0` — H⁰ of the relative curve base-changes freely (`moduleKSheafHZero`-compatible; line 313–315).

Units form `Γ(relCurve C R, ⊤)ˣ ≃ Rˣ`: NOT stated as a standalone lemma, but it is an immediate `Units.mapEquiv`/`RingEquiv.toMulEquiv` of `relStructureSectionsTop`. (There is heavy use of `Γ(relCurve C R, …)ˣ` on overlap opens, e.g. `…/AlgebraicJacobian/Cohomology/TwistedSheaf.lean:470`, but no `⊤`-units-≃-`Rˣ` lemma.)

---

## Category 5 — `CechPic.toPic`, `toPic_injective`, and genuine-Pic gluing

`Scheme.CechPic.toPic` and its injectivity EXIST:
- `…/AlgebraicJacobian/Picard/CechPicToPic.lean:82`
  `noncomputable def toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤)` (fields `toFun := toPicFun X`, `map_one'`, `map_mul'`). Underlying function `toPicFun` at line 45; `@[simp] lemma toPic_mk` at line 110.
- `…/AlgebraicJacobian/Picard/CechPicToPic.lean:116`
  `theorem toPic_injective : Function.Injective (toPic X)` (refinement injectivity).
- Naturality: `…/AlgebraicJacobian/Picard/CechPicToPicNaturality.lean:455`
  `theorem toPic_map [IsAffine X] [IsAffine Y] (g : X ⟶ Y) (L : Y.CechPic) : toPic X (CechPic.map g L) = CommRing.Pic.mapRingHom g.appTop.hom (toPic Y L)`; algebra-face form `toPic_mapAlgebra` at line 471.
- Bijectivity / equiv (affine): `…/AlgebraicJacobian/Picard/CechPicSurjective.lean:276` `toPic_bijective`, `:285` `noncomputable def cechPicEquivPic X := MulEquiv.ofBijective (CechPic.toPic X) …`.

"genuine Pic is a Zariski sheaf / glues line bundles on an open cover": in this project the "genuine" scheme Picard group is modeled by `CechPic` itself (glued via `PointedCover` refinements), and the Zariski-sheaf statement that exists is for the relative plus-functor, not `CommRing.Pic`:
- `…/AlgebraicJacobian/Picard/Pic0ZariskiSheaf.lean` — "The degree-zero Picard functor is a Zariski sheaf on the slice (DAT-2)". Main pieces: `exists_isGlueValue` (129), `glueSection` (228), `existsUnique_glue_of_le_cover` (246), `mem_pic0Subgroup_of_cover` (277). These are about `PicEtAff C Γ(T.left, W)` / `pic0`, built on `PicEtAffZariskiSep` + `PicEtAffZariskiGlue`.
- CechPic gluing over overlapping covers exists only in the two specialized forms already cited: clopen (`CechPicClopenGlue.exists_map_eq_of_clopen`) and the glued-sheaf datum route (`GluedSheafClass`/`GluedSheafExtraction`).

No lemma says "`CommRing.Pic Γ(X,⊤)` glues over an arbitrary open cover".

---

## Category 6 — existence of `DivFamZar(Aff)` with `picClass = <cechPicClass>` over a general ring

Two landed existence theorems produce a `DivFamZarAff` whose `picClass` is a prescribed base-changed `cechPicClass` over a **non-field** base — but both **escape** off the given ring (to an étale cover, or to a double `Away` localization). There is **no "clean over-R" version**.

- `…/AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveSpreadDescent.lean:71`
  `theorem exists_etale_divFamZarAff_of_admissible_fibre (D : BasicOpenCocycleDatum C B pi) (hpi : pi ≫ P1.structureMap k = C.hom) (n g : ℕ) (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) (hgn : g ≤ n) (hdeg : ∀ (K) [Field K] [Algebra k K] [Algebra B K] [IsScalarTower k B K], classDeg K (Scheme.CechPic.map (relCurveMap C B K) D.cechPicClass) = (n : ℤ)) (p : PrimeSpectrum B) (hp : D.HasWitnessH1Vanishing p.asIdeal.ResidueField) : ∃ (S : Type u) (_ : CommRing S) (_ : Algebra k S) (_ : Algebra B S) (_ : IsScalarTower k B S) (_ : Algebra.Etale B S) (q : PrimeSpectrum S), PrimeSpectrum.comap (algebraMap B S) q = p ∧ ∃ F : DivFamZarAff C S n, F.picClass = Scheme.CechPic.map (relCurveMap C B S) D.cechPicClass`
  (`B` arbitrary affine; conclusion over an **étale** `S`.)

- `…/AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveSpread.lean:320`
  `theorem exists_away_away_divFamZarAff_of_admissible_fibre (D : BasicOpenCocycleDatum C B pi) [IsNoetherianRing B] (hpi : …) (n g : ℕ) (hchi : …) (hgn : g ≤ n) (p : PrimeSpectrum B) (hp : D.HasWitnessH1Vanishing p.asIdeal.ResidueField) (hdegp : classDeg p.asIdeal.ResidueField (Scheme.CechPic.map (relCurveMap C B p.asIdeal.ResidueField) D.cechPicClass) = (n : ℤ)) : ∃ h : B, h ∉ p.asIdeal ∧ ∃ q₁ : PrimeSpectrum (Localization.Away h), PrimeSpectrum.comap (algebraMap B (Localization.Away h)) q₁ = p ∧ ∃ f : Localization.Away h, f ∉ q₁.asIdeal ∧ ∃ q₂ : PrimeSpectrum (Localization.Away f), PrimeSpectrum.comap (algebraMap B (Localization.Away f)) q₂ = p ∧ ∃ F : DivFamZarAff C (Localization.Away f) n, F.picClass = Scheme.CechPic.map (relCurveMap C B (Localization.Away f)) D.cechPicClass`
  (conclusion over a **double `Away`** localization of `B`.)

Related but over a FIELD only (not a general ring), listed for completeness:
- `…/AlgebraicJacobian/Picard/DivisorFamilyAffClassDegree.lean:312` `theorem exists_divFamZarAff_classDeg_eq … : ∃ G : DivFamZarAff C K n, classDeg K G.picClass = (n : ℤ)` (base `K` a field).
- `…/AlgebraicJacobian/Picard/Pic0ChartForkNegativeBranch.lean` (~180) `∃ F₁ F₂ : DivFamZar C K π n, F₁ ≠ F₂ ∧ F₁.picClass = F₂.picClass` (field `K`).
- `…/AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorDescent.lean:82` `existsUnique_abel_divFamZarAff_of_etale_witness … : ∃! F : DivFamZarAff C A (genus C), abelDivAffPlus C A F = picEtAffineEquiv C A lam.1` (over general `A`, but conditioned on an étale witness `F'`, and the conclusion is an **Abel-value** equation, not `picClass = cechPicClass`).

Datum-level surjectivity onto CechPic over an arbitrary ring `B` (the shape you'd feed the above, not itself a `DivFamZar`):
- `…/AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean:301` `theorem exists_cechPicClass_eq (c : (relCurve C B).CechPic) : ∃ D : BasicOpenCocycleDatum C B π, D.cechPicClass = c`.
- Fixed-class local identity: `…/AlgebraicJacobian/Picard/Pic0RankOneLocalDivisor.lean:398` `have hFclass : F.picClass = (P.datum.baseChange B).cechPicClass := …` (inside a proof, `B` general).

`picClass = D.cechPicClass` equalities over a field/at the datum level (context, plentiful): `…/AlgebraicJacobian/Picard/SectionsToDivisorsClass.lean:160,217`, `…/AlgebraicJacobian/Picard/Pic0RankOneDivisorUnique.lean:98`, `…/AlgebraicJacobian/Picard/DivisorDatumSectionOfClass.lean:117`, `…/AlgebraicJacobian/Picard/DivisorDatumRankOne.lean:132`.

---

## Summary table

| # | You asked for | Status | Key hit(s) |
|---|---|---|---|
| 1 | CechPic-class away-span separatedness | **Missing** at class level; **exists** at family level | `DivFamZar.eq_of_awaySpan_eq` (DivRepAwaySpanGlue.lean:225), `DivFamZarAff.eq_of_awaySpan_eq` (DivRepAwaySpanGlueAff.lean:99), `DivFam(Aff/…).eq_of_away_eq`. Class-level only clopen: `CechPic.eq_of_map_eq_of_clopen` (CechPicClopenSep.lean:188) |
| 2 | relPic base away-span separatedness / sheaf | **Missing** as away-span; **descent converse** and **product/étale** variants exist | descent: `exists_notMem_cechPicMap_eq_of_relPicMk_eq` (RelPicBaseLocalTriviality.lean:140); product: `relPic.eq_of_pi_proj_eq` (RelPicPi.lean:297); étale: `relPicAlgMap_injective_of_etaleCover` (RelPicCoverInjective.lean:81); away-span for `PicEtAff`: `PicEtAff.eq_of_away_eq` (PicEtAffZariskiSep.lean:137) |
| 3 | `CommRing.Pic R` Zariski sheaf / product-injective | **Missing** (project + mathlib) | local-triviality primitive only: `CommRing.Pic.exists_notMem_mapAlgebra_eq_one` (RelPicBaseLocalTriviality.lean:61); mathlib `PicardGroup.lean` has no sheaf statement |
| 4 | `Γ(relCurve C R,⊤) ≃ R` | **Exists** | `relStructureSectionsTop` (RelativeTwoCover.lean:170); `moduleKSheafHZero` (ModuleKSheaf.lean:279); H⁰ base change (H1BaseFieldInvariance.lean:304) |
| 5 | `CechPic.toPic`, `toPic_injective`; genuine-Pic sheaf | **Exists** (toPic); genuine-Pic sheaf only via `PicEtAff`/`pic0` | `toPic` (CechPicToPic.lean:82), `toPic_injective` (:116), `toPic_map` (CechPicToPicNaturality.lean:455), `cechPicEquivPic` (CechPicSurjective.lean:285); `Pic0ZariskiSheaf.lean` |
| 6 | `∃ F : DivFamZar(Aff), F.picClass = cechPicClass` over ring | **Exists only with escape** (étale / double-Away); no clean over-R | `exists_etale_divFamZarAff_of_admissible_fibre` (…SpreadDescent.lean:71); `exists_away_away_divFamZarAff_of_admissible_fibre` (…Spread.lean:320); datum surjectivity `exists_cechPicClass_eq` (GluedSheafExtraction.lean:301) |

The architecture gap, stated sharply: you have (a) family-level away-span separatedness (`eq_of_awaySpan_eq`), (b) the base-descent converse for relPicMk (`exists_notMem_cechPicMap_eq_of_relPicMk_eq`), (c) `H⁰ = R`, and (d) `CommRing.Pic` local triviality — but **not** the CechPic-class away-span separatedness itself, and **not** the `CommRing.Pic` Zariski-sheaf injectivity that a base-cover separatedness proof for CechPic classes would most naturally route through (mathlib does not supply it either).

(One background note: a whole-disk `grep` I launched to locate mathlib timed out and is still running as job `ba2pxdxc6`; it is harmless and read-only — I subsequently located mathlib at `../../.lake-packages/mathlib` via the manifest and used that.)
