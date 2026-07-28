Survey complete. Report below.

---

# DAT-B / COV-1 inventory — four families

Direction fact first, because it inverts one assumption in the brief: **`relCurveMap C R R' : relCurve C R' ⟶ relCurve C R`** (`AlgebraicJacobian/Cohomology/RelativeSectionsLinear.lean:160`), i.e. it points from the *bigger* ring to the *smaller* one. So for `k → L` you get `relCurveMap C k L : relCurve C L ⟶ relCurve C k`, and `Scheme.CechPic.map (relCurveMap C k L)` pushes a class **from `C_k` to `C_L`** — which is the direction §1.2 step 4 needs. Definition: `(C ◁ overSpecMap R R').left`, with `overSpecMap R R' : overSpec k R' ⟶ overSpec k R` (`:145`). The bridge to the E-iv-alg spelling is landed: `relCurveMap_eq_overSpecMap_ofId` — `relCurveMap C k K = (C ◁ Over.overSpecMap (Algebra.ofId k K)).left` (`/AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean:197`).

## (1) Divisor base change along `relCurveMap` — NOT FOUND as a divisor operation; FOUND at the class and local-equations level

`Scheme.CurveDivisor` is a bare `Finsupp` with no functoriality:

- `AlgebraicGeometry.Scheme.CurveDivisor` — `/AlgebraicJacobian/RiemannRoch/Divisor.lean:40` — `def CurveDivisor (X : Scheme.{u}) [IsIntegral X] : Type u := {x : X // x ≠ genericPoint X} →₀ ℤ`. Data: an ℤ-coefficient function on non-generic points. `AddCommGroup` + pointwise `PartialOrder` inherited (`:48`, `:52`).
- `Scheme.CurveDivisor.deg` — `Divisor.lean:63` — `variable (K : Type u) [CommRing K] [X.Over (Spec (CommRingCat.of K))]`; `noncomputable def deg (D : X.CurveDivisor) : ℤ := D.sum fun x n => n * (X.residueDeg K x.1 : ℤ)`. Plus `deg_zero :68`, `deg_add :72`, `deg_single :80`, `deg_neg :89`.

**MISSING (verified, not by one grep).** I grepped for `CurveDivisor.{pullback,comap,map,baseChange}`, for any `def` with signature `(… CurveDivisor) : … CurveDivisor`, and for `fibreDivisor/pullbackDivisor/divisorPullback/baseChangeDivisor` — all empty. I read `Divisor.lean`, `DegreeBaseChange.lean`, `DegreeBaseFieldInvariance.lean`, `DegreePullback.lean`, `DegreePullbackFiber.lean`, `DegreePullbackDictionary.lean`, `ClassCohomology.lean`, `FLVClass.lean`, `PresentationDivisor.lean`, `DivisorClassMeromorphic.lean`. There is **no** divisor-level pullback/pushforward in either direction, hence no `deg`-compatibility statement for one, and no `picClass ∘ (divisor base change) = CechPic.map ∘ picClass` square. The tree deliberately goes around it: **base change acts on classes, and a divisor is re-extracted downstream** by `CurveDivisor.exists_picClass_eq`.

What exists instead, and is the intended route:

- `Scheme.LocalEquations.pullback` — `/AlgebraicJacobian/Picard/LocalEquationsPullback.lean:118` — `noncomputable def pullback (f : Y ⟶ X) (E : X.LocalEquations) (hreg : ∀ (y z : Y) (hz : z ∈ (E.cover.pullback f).opens y), (Y.presheaf.germ ((E.cover.pullback f).opens y) z hz).hom (pullbackEqn f E y) ∈ nonZeroDivisors (Y.presheaf.stalk z)) : Y.LocalEquations`. *This* is the divisor-datum pullback; `hreg` is a real side condition.
- `Scheme.LocalEquations.picClass_pullback` — `LocalEquationsPullback.lean:172`, `@[simp]` — `lemma picClass_pullback (f : Y ⟶ X) (E : X.LocalEquations) (hreg) : (E.pullback f hreg).picClass = CechPic.map f E.picClass`. The picClass-compatibility you asked for, at the LocalEquations layer.
- `Scheme.LocalEquations.pullbackEqn_germ_mem_nonZeroDivisors` — `/AlgebraicJacobian/RiemannRoch/DegreeBaseFieldInvariance.lean:72` — discharges `hreg` with **no flatness** when both schemes are integral and `f` is generic-to-generic. This is what makes the route cheap along `relCurveMap C k L`.
- `classDeg_cechPicMap_baseFieldTransition` (**E-iv-alg**) — `DegreeBaseFieldInvariance.lean:462` — with `variable {k} [Field k] (C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] {K₁ K₂ : Type u} [Field K₁] [Algebra k K₁] [Field K₂] [Algebra k K₂]`:
  ```
  theorem classDeg_cechPicMap_baseFieldTransition (φ : K₁ →ₐ[k] K₂)
      (L : (C ⊗ overSpec k K₁).left.CechPic) :
      classDeg K₂ (Scheme.CechPic.map ((C ◁ Over.overSpecMap φ).left) L) = classDeg K₁ L
  ```
  Note the spelling is `(C ◁ Over.overSpecMap φ).left`, not `relCurveMap`; use `relCurveMap_eq_overSpecMap_ofId` to cross (`WindowFieldTransport.lean:247-253` does exactly this, and is the worked precedent).
- `Scheme.CurveDivisor.exists_picClass_eq` — `/AlgebraicJacobian/Picard/DivisorClassMeromorphic.lean:118` — surjectivity of `picClass`, the re-extraction step.
- `classDeg_picClass` (E-i) — `/AlgebraicJacobian/RiemannRoch/Degree.lean:157` — `classDeg K (CurveDivisor.picClass K D) = CurveDivisor.deg K D`.

Usability: for COV-1 you never need a divisor base change. Push the class with `CechPic.map (relCurveMap C k L)`, read its degree by E-iv-alg, then pick a divisor with `exists_picClass_eq`. Consequence for step 5: your Σ on the `K_s` curve and the base-changed points on `C_L` do **not** have a landed divisor-level transport tying them; you will get a class-level identity plus a separately-constructed `L`-divisor.

## (2) Single-point divisors and base change of a k-rational point — `single` FOUND, the base-change lemma MISSING

- `Scheme.CurveDivisor.single` — `/AlgebraicJacobian/RiemannRoch/ChiFiniteness.lean:67` — `noncomputable def single {x : X} (hx : x ≠ genericPoint X) (n : ℤ) : X.CurveDivisor := Finsupp.single ⟨x, hx⟩ n`; with `single_zero :83`, `single_add :89`, `nsmul_single_one :95`, and `deg_single' (K) [CommRing K] [X.Over (Spec (.of K))] {x} (hx) (n) : deg K (single hx n) = n * X.residueDeg K x` at `:104`.
- `Over.rationalPointBaseChange` — `/AlgebraicJacobian/Curve/SepPointsDenseKit.lean:113` — `noncomputable def (p : Spec (.of k) ⟶ C.left) (hp : p ≫ C.hom = 𝟙 (Spec (.of k))) : Spec (.of L) ⟶ (C ⊗ overSpec k L).left`, under `variable {k} [Field k] (C : Over (Spec (.of k))) (L : Type u) [Field L] [Algebra k L]`.
- `Over.rationalPointBaseChange_fst` — `:123`, `@[reassoc]` — `… ≫ (fst C (overSpec k L)).left = Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫ p`.
- `Over.rationalPointBaseChange_snd` — `:134`, `@[reassoc]` — `… ≫ (snd C (overSpec k L)).left = 𝟙 (Spec (.of L))`. Its own docstring: "the input from which **B-5 extracts** `residueDeg L = 1`".
- `Over.dense_baseChange_rationalPoints` — `/AlgebraicJacobian/Curve/SepPointsDense.lean:278` — `[IsSepClosed k] [SmoothOfRelativeDimension 1 C.hom] [IsIntegral C.left] (W : (relCurve C L).Opens) (hW : (W : Set (relCurve C L)).Nonempty) : ∃ (p) (hp : p ≫ C.hom = 𝟙 _), (Over.rationalPointBaseChange C L p hp).base (IsLocalRing.closedPoint L) ∈ W`.
- `Over.exists_rationalPoint_mem` — `/AlgebraicJacobian/Curve/SeparablyClosedPoints.lean:157` — `[IsSepClosed K] (C : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 C.hom] (W) (hW) : ∃ p, p ≫ C.hom = 𝟙 _ ∧ p.base (IsLocalRing.closedPoint K) ∈ W`.

**MISSING**, and this is real new work for B-5: there is **no** statement `residueDeg L (rationalPointBaseChange … .base (closedPoint L)) = 1`, no "the fibre over a `k`-rational point is a single point", and no lemma computing the base change of `single x 1`. Both worksheet files say so in prose (`SepPointsDenseKit.lean:132`, `SepPointsDense.lean:36`: "not proved here; B-5 extracts it"), and `grep residueDeg` across the whole tree returns only `residueDeg_finite`, `residueDeg_pos`, `residueDeg_eq_of_isIso` (`DegreeIsoTransport.lean:225`) and arithmetic uses. The consumers that want it are `CoverageDrop.lean:143` (`hdx : Y.residueDeg K x = 1`) and `:218` (`hPdeg : ∀ x ∈ P, Y.residueDeg K x = 1`).

Two nearby precedents worth knowing before writing it:
- `Scheme.Pic0.residueFieldIso_of_section_over_field` — in the **sibling AJC tree**, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean:373` — "a section of a scheme over `Spec k` has residue field `≅ k`", sorry-free and scheme-general. Exactly the shape needed, in the wrong tree; it is portable and its route (split epi + field mono ⟹ iso) is short.
- `classDeg_graphPicClass` — `/AlgebraicJacobian/RiemannRoch/GraphDegree.lean:445` — `classDeg K (Over.graphPicClass C t) = 1` for a `K`-point `t : overSpec k K ⟶ C`. This is the *degree-1 certificate for the graph of a point*, obtained via `presentationDivisor_graphLocalEquations :422` (the graph presentation divisor is `single (graphPoint) (ord)`), i.e. the tree already has "one-point divisor of a rational point has degree 1" in class form — it just proves `ord · residueDeg = 1` as a product, never `residueDeg = 1` alone.

## (3) The fibre of theta/sigma as an honest Čech class — FOUND, but assembled from three lemmas, not one

Argument types first: `thetaFamily C (L₀ : (C ⊗ overSpec k k).left.CechPic) (T) : picEt C T` — the base class argument is a **Čech class on `C_k`**, not on `relCurve C k`-spelled-differently, and there is no `thetaCechClass` implicit default.

- `thetaFamily` — `/AlgebraicJacobian/Picard/ThetaShift.lean:104` — `def thetaFamily (L₀ : (C ⊗ overSpec k k).left.CechPic) (T : Over (Spec (.of k))) : picEt C T := picEtMap C (toBaseTest T) (thetaBase C L₀)`; `thetaBase` at `:97` is `(picEtAffineEquiv C k).symm (PicEtAff.unit C k (relPicMk C (overSpec k k) L₀))`.
- `thetaCechClass` — `ThetaShift.lean:263`; `one_le_classDeg_thetaCechClass :270`.
- **`thetaFamily_overSpec_affineEquiv`** — `ThetaShift.lean:122` — the closest thing to what you asked for:
  ```
  theorem thetaFamily_overSpec_affineEquiv (L₀ : (C ⊗ overSpec k k).left.CechPic)
      (A : Type u) [CommRing A] [Algebra k A] :
      picEtAffineEquiv C A (thetaFamily C L₀ (overSpec k A))
        = PicEtAff.unit C A
            (relPicAlgMap C (Algebra.ofId k A) (relPicMk C (overSpec k k) L₀))
  ```
  So the fibre is honest **at every affine test**, including a field `A := L`, and the honest class is `relPicAlgMap (ofId k L)` of `relPicMk L₀` — a `relPic`, not yet `relPicMk` of a `CechPic`.
- `relPicAlgMap_mk` — `/AlgebraicJacobian/Picard/RelPicPi.lean:252` — the missing last step, and it is the base-change identity you wanted:
  ```
  lemma relPicAlgMap_mk (f : A →ₐ[k] A') (L : ((C ⊗ overSpec k A).left).CechPic) :
      relPicAlgMap C f (relPicMk C (overSpec k A) L)
        = relPicMk C (overSpec k A') (Scheme.CechPic.map (C ◁ Over.overSpecMap f).left L)
  ```
  Composing the two gives, verbatim, `picEtAffineEquiv C L (thetaFamily C L₀ (overSpec k L)) = PicEtAff.unit C L (relPicMk C (overSpec k L) (CechPic.map (C ◁ overSpecMap (ofId k L)).left L₀))`, and `relCurveMap_eq_overSpecMap_ofId` rewrites the map to `relCurveMap C k L`. **This composite is not itself a landed lemma** — three rewrites, all landed, zero new mathematics. Underlying general version: `relPicMap_mk` (`/AlgebraicJacobian/Picard/RelPic.lean:112`, `@[simp]`).
- `picEtAffineEquiv_naturality` — `/AlgebraicJacobian/Picard/PicEtMap.lean:354` — `picEtAffineEquiv C B (picEtMap C (Over.overSpecMap φ) s) = PicEtAff.mapAlg C φ (picEtAffineEquiv C A s)`; `PicEtAff.mapAlg_unit` (`/AlgebraicJacobian/Picard/PicEtAffMap.lean:286`) — `mapAlg C φ (unit C A x) = unit C A' (relPicAlgMap C φ x)`; `PicEtAff.map_id :204`, `mapAlg_id :282`.
- The twist collapse, which makes the whole `λ·θᵐ·Σ⁻¹` one theta-family: `thetaFamily_mul` / `_inv` / `_pow` — `/AlgebraicJacobian/Picard/Pic0ChartTwistCollapse.lean:116/124/134`; `sigmaFamily_eq_thetaFamily :145` (`rfl`); **`chartTwist_collapse :167`** — `chartTwist C m Z T lam = lam * thetaFamily C (thetaCechClass C ^ m * (picClass k Z)⁻¹) T`; `chartTwistClass :195`.
- Splitting side, for the `λ` factor: `exists_splitting_of_picEt` — `/AlgebraicJacobian/Picard/Pic0ChartSplit.lean:143` — every plus class over a field `K` satisfies `∃ (L) (_ : Field L) (_ : Algebra k L) (_ : Algebra K L) (_ : IsScalarTower k K L) (_ : Module.Finite K L) (_ : Algebra.IsSeparable K L) (M : (C ⊗ overSpec k L).left.CechPic), PicEtAff.map C L (picEtAffineEquiv C K μ) = PicEtAff.unit C L (relPicMk C (overSpec k L) M)`. Unconditional, witness-free. `isSplitWitness_iff_exists_splitting_witness :163` is `Iff.rfl`; read the file's closing note — a positional intro lemma was **removed** as un-elaborable, use `.mpr` with `L` already fixed.
- `IsSplitWitness` — `/AlgebraicJacobian/Picard/Pic0ChartLocus.lean:148`; `chartLocus :242`; `degAt_chartTwist :212` (`= m * classDeg k (thetaCechClass C) - deg k Z`, sign fixed 2026-07-28, I-0514); `chartTwist_chartValue :227` (the inversion law); `exists_witness_of_separable_extension :335` (upward closure of the witness clause along separable `L → L'`, stated with `CechPic.map (relCurveMap C L L')` — the one place a class base change along `relCurveMap` between two *field* levels is landed).
- Datum presentation with no GAP-1 mul: `exists_datum_cechPicClass_chartTwistClass` — `Pic0ChartTwistCollapse.lean:214`; `exists_datum_cechPicClass_twist` — `/AlgebraicJacobian/Picard/Pic0ChartHonest.lean:171`.

Usability caveat that will bite step 4→6: `IsSplitWitness`'s witness clause asks for **neither `0 ≤ W` nor `deg W = g`** (the `Pic0ChartLocus.lean:120-150` docstring says so explicitly and explains why — the GAP-6 dictionary is an iff against a condition that cannot see effectivity or degree). Degree comes in externally via `degAt_chartTwist`; effectivity must be re-supplied where you need `h⁰ = 1` uniqueness.

## (4) The uniform vanishing bound and the χ ledger — all FOUND

- **`exists_bound_subsingleton_hModule_one_of_isFinite_toP1`** — `/AlgebraicJacobian/RiemannRoch/UniformVanishing.lean:71`. Section variables (`:49-53`) are part of the pack:
  ```
  variable {K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y]
    [Y.Over (Spec (CommRingCat.of K))]
    [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
    [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
    [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]

  theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
      [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
      [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
      (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
      (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
      ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
        Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
  ```
  To instantiate at `L`: `Y := relCurve C L`, `K := L`, and you must supply seven things — `IsIntegral`, the `Over`, smooth-rel-dim-1, `LocallyOfFiniteType`, `QuasiCompact`, both `Module.Finite`s — plus a **finite dominant `π_L : relCurve C L ⟶ P1 L` with the structure-map triangle**. The first six have landed base-change instances (`instIsIntegralBaseChange`, `instSmoothOfRelativeDimensionBaseChange`, `instQuasiCompactBaseChange`, `instModuleFiniteHModule{Zero,One}BaseChange`, used as `haveI`s at `WindowFieldTransport.lean:225-241` and `DivSchemeMonoBridgeRel.lean:100-108`); note they need `haveI`, they do not fire through the `relCurve` def barrier. The `π_L` is *not* handed to you by anything I found — `thetaP1 C` (`ThetaShift.lean:251`, with `isFinite_thetaP1 :254`, `isDominant_thetaP1 :257`) is the `C_k` version.
- Spellings, as used there: `Scheme.CurveDivisor.deg` (Divisor.lean:63, above); `Sheaf.h0 (F) := Module.finrank R (HModule F 0)` — `/AlgebraicJacobian/RiemannRoch/Chi.lean:81`, with `h1 :86`, `chi := h0 - h1 :92`, `chi_congr :106`; `Scheme.divisorSheaf` — `/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:326`, `variable (K) [Field K] {X} [X.Over (Spec (.of K))]` at `:69`, `noncomputable def divisorSheaf (D : X.CurveDivisor) : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K)`; `Scheme.moduleKSheaf` — `/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:265`.
- **χ-invariance under base field extension: FOUND, public.** `AlgebraicGeometry.chi_relCurve` — `/AlgebraicJacobian/Picard/DivisorDatumRankOne.lean:82`:
  ```
  theorem chi_relCurve (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (n : ℤ))
      (L : Type u) [Field L] [Algebra k L] :
      Sheaf.chi ((relCurve C L).moduleKSheaf L) = 1 - (n : ℤ)
  ```
  under `{k} [Field k] {C} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` and a file-local `instOverCleftRankOne : C.left.Over (Spec (.of k)) := ⟨C.hom⟩` (`:75` — keyed on `C.hom`, deliberately, so `chi_moduleKSheaf C` unifies). This is exactly the `hχ` input of `exists_effective_sub_h0_eq_one`. A **private** duplicate lives at `/AlgebraicJacobian/Picard/DivSchemeMonoBridgeRel.lean:126` — use the public one.
  Its ingredients, if you need them directly: `chi_moduleKSheaf` (`/AlgebraicJacobian/RiemannRoch/ChiCurve.lean:148`, `= 1 - genus C`), `genus` (`/AlgebraicJacobian/Challenge.lean:89`), `genus_baseField` (`/AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean:373`, `genus (baseChangeBundle C K) = genus C`), `finrank_h1_baseField :342`. There is **no** `chi_moduleKSheaf_baseChange` under that name — searching `chi_moduleKSheaf` finds only the base statement and ~30 `hχ : Sheaf.chi (…moduleKSheaf…) = 1 - g` hypothesis binders.
- The B-1 drop, which is what consumes all of the above: **`exists_effective_sub_h0_eq_one`** — `/AlgebraicJacobian/RiemannRoch/CoverageDrop.lean:213` — under the same seven-instance `Y/K` pack (`:66-72`, including both `Module.Finite`s):
  ```
  theorem exists_effective_sub_h0_eq_one (g : ℕ)
      (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g : ℤ))
      (P : Set Y)
      (hdense : ∀ U : Y.Opens, (U : Set Y).Nonempty → (P ∩ U).Nonempty)
      (hPcl : ∀ x ∈ P, x ≠ genericPoint Y)
      (hPdeg : ∀ x ∈ P, Y.residueDeg K x = 1)
      (W : Y.CurveDivisor) (e : ℕ)
      (hdeg : CurveDivisor.deg K W = (g : ℤ) + e)
      (h1 : Subsingleton (Sheaf.HModule (Y.divisorSheaf K W) 1)) :
      ∃ S : Y.CurveDivisor, 0 ≤ S ∧ CurveDivisor.deg K S = (e : ℤ) ∧
        (∀ (x : Y) (hx : x ≠ genericPoint Y), coeffAt hx S ≠ 0 → x ∈ P) ∧
        Sheaf.h0 (Y.divisorSheaf K (W - S)) = 1 ∧
        Subsingleton (Sheaf.HModule (Y.divisorSheaf K (W - S)) 1)
  ```
  Companions: `exists_admissible_nonbase_point :86`, `h0_sub_single_of_rational_nonbase :141`.
- Class-invariance transports (step 4): `subsingleton_hModule_one_of_picClass_eq` — `/AlgebraicJacobian/RiemannRoch/ClassCohomology.lean:111`, `(K) [Field K] {X} [X.Over …] [SmoothOfRelativeDimension 1 (X ↘ …)] [IsIntegral X] [QuasiCompact (X ↘ …)]`, needs **no** finiteness; also `h0_divisorSheaf_eq_of_picClass_eq :89`, `h1_… :98`, `moduleFinite_… :122/:131`.
- Rank anchor (step 6, `h⁰ = 1` at `deg = g`): `h0_eq_deg_add_chi_of_subsingleton_hModule_one` — `/AlgebraicJacobian/RiemannRoch/FLVClass.lean:412` — `(D) (hsub : Subsingleton (HModule (Y.divisorSheaf K D) 1)) : (Sheaf.h0 … : ℤ) = CurveDivisor.deg K D + Sheaf.chi (Y.moduleKSheaf K)`. Also `riemann_inequality` — `/AlgebraicJacobian/RiemannRoch/ChiLedger.lean:137`.

## The two genuine gaps, restated

1. **`residueDeg L = 1` at a base-changed `k`-rational point** (family 2). Nothing landed; both worksheet headers acknowledge it as B-5's job. The sibling AJC tree has the general scheme-level lemma (`Pic0AbelianVariety.lean:373`) — port it rather than rebuild.
2. **A finite dominant `π_L : relCurve C L ⟶ P1 L` with its structure triangle** (family 4), to instantiate DAT-0a at the fibre field. The `C_k` version `thetaP1` is landed; I found no base-changed counterpart.

Everything else in the four families is either landed or a two-to-three-rewrite composite of landed lemmas — notably the family-(3) fibre reading, which is `thetaFamily_overSpec_affineEquiv` ∘ `relPicAlgMap_mk` ∘ `relCurveMap_eq_overSpecMap_ofId` and is not yet a named lemma.
