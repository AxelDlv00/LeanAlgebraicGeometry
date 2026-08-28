## 1. `WindowFieldTransport.lean` — what it actually proves

File: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean` (400 lines, **zero `sorry`, zero `axiom`**; `.olean` present, so it elaborates).

**It ASSUMES the base-changed curve's properties, it does not construct/discharge them.** `relCurve C K` is a `def` (`Cohomology/RelativeTwoCover.lean:115`: `noncomputable def relCurve : Scheme.{u} := (C ⊗ overSpec k R).left`), so `C_κ` itself *is* constructed. But at lines 118-120 / 186-191 / 287-292 the geometric instances are **`variable` instance-binders**, threaded as hypotheses:

```
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K))]
variable [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 1)]
```

These are *not* inferred from `Curve/BaseChangeInstances.lean` because those instances are keyed on the `(C ⊗ overSpec k K).left` spelling, not the `relCurve` def. Inside `deg_windowTransportDivisor` (lines 232-245) the author manually invokes `instIsIntegralBaseChange C k` etc. — but only at `K = k`, for the self base change.

Full theorem list (verbatim signatures):

- `:87` `theorem subsingleton_hModule_one_of_witness (W₀ D : Y.CurveDivisor) (hW₀ : Subsingleton (Sheaf.HModule (Y.divisorSheaf K W₀) 1)) (hdeg : CurveDivisor.deg K W₀ + 1 - Sheaf.chi (Y.moduleKSheaf K) ≤ CurveDivisor.deg K D) : Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)` — the π-free peeling; single-field, no base change.
- `:125` `noncomputable def windowTransportDatum : BasicOpenCocycleDatum C K π := (thetaChartDatum C k π a).baseChange K`
- `:131` `noncomputable def windowTransportPresentation : (relCurve C K).MeromorphicPresentation`
- `:140` `noncomputable def windowTransportDivisor : (relCurve C K).CurveDivisor := Scheme.presentationDivisor K (windowTransportPresentation C K π a)`
- `:146` **the H¹-fact transport**: `theorem subsingleton_h1_windowTransportDivisor (h : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1) : Subsingleton (Sheaf.HModule ((relCurve C K).divisorSheaf K (windowTransportDivisor C K π a)) 1)` — hypothesis is *k*-level H¹ vanishing of the theta twist pair; conclusion is *K*-level. Proved via `datum_subsingleton_h1_baseChange` + `presentationSheafIso`.
- `:162` `theorem picClass_windowTransportDivisor : CurveDivisor.picClass K (windowTransportDivisor C K π a) = (windowTransportDatum C K π a).cechPicClass`
- `:197` `lemma relCurveMap_eq_overSpecMap_ofId`, `:205` `lemma overSpec_self_hom`, `:212` `lemma fst_left_self_over`
- `:230` `theorem deg_windowTransportDivisor : CurveDivisor.deg K (windowTransportDivisor C K π a) = (a : ℤ) * windowδ π`
- `:298` `theorem relThetaPairH1_windowS (g : ℕ) : Subsingleton (relTwistPair C k π (relThetaCocycle C k π (windowS_choice π hπ g))).H1`
- `:307` `noncomputable def windowN (g : ℕ) : (relCurve C K).CurveDivisor := windowTransportDivisor C K π (windowM_choice π hπ g)`
- `:313` `theorem subsingleton_h1_windowN (g : ℕ) : Subsingleton (Sheaf.HModule ((relCurve C K).divisorSheaf K (windowN C K hπ g)) 1)`
- `:319` `theorem deg_windowN (g : ℕ) : CurveDivisor.deg K (windowN C K hπ g) = (windowM_choice π hπ g : ℤ) * windowδ π`
- `:326` `theorem two_mul_genus_le_deg_windowN (g : ℕ) (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1) (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) : 2 * (g : ℤ) ≤ CurveDivisor.deg K (windowN C K hπ g)`
- `:336` `theorem h0_windowN (g : ℕ) (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) (hχK : Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (g : ℤ)) : Sheaf.h0 ((relCurve C K).divisorSheaf K (windowN C K hπ g)) = Sheaf.h0 (C.left.divisorSheaf k (windowM_choice π hπ g • fiberWeilDivisor π))`
- `:362` `theorem subsingleton_h1_windowN_sub (g : ℕ) (hO …) (hχ …) (hχK …) (D' : (relCurve C K).CurveDivisor) (hD' : CurveDivisor.deg K D' ≤ 2 * (g : ℤ)) : Subsingleton (Sheaf.HModule ((relCurve C K).divisorSheaf K (windowN C K hπ g - D')) 1)`

Note `hχK` (χ of the base-changed curve) is a **hypothesis** in `h0_windowN` and `subsingleton_h1_windowN_sub`, even though `H1BaseFieldInvariance.lean` could supply it (see §3).

The module docstring's own binding claim (lines 19-21): the per-field ledger constants **do not transport** — `windowM_choice` is a per-field `Classical.choose` — so `N` is built by transporting window *facts*, not by re-running the K-level ledger.

## 2. Base change construction + discharged instances

`AlgebraicJacobian/Curve/BaseChangeInstances.lean` (197 lines, **0 `sorry`**) — this is the reusable machinery. `C_K := (C ⊗ overSpec k K).left`, viewed over `K` by the second projection. Verbatim:

- `:74` `noncomputable instance instOverBaseChange : ((C ⊗ overSpec k K).left).Over (Spec (CommRingCat.of K)) := .ofHom (snd C (overSpec k K)).left`
- `:83` `theorem baseChange_over_eq_snd_left : ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K)) = (snd C (overSpec k K)).left := rfl`
- `:97` `instance instSmoothOfRelativeDimensionSndLeft : SmoothOfRelativeDimension 1 (snd C (overSpec k K)).left`
- `:106` `instance instIsProperSndLeft : IsProper (snd C (overSpec k K)).left`
- `:112` `instance instGeometricallyIrreducibleSndLeft : GeometricallyIrreducible (snd C (overSpec k K)).left`
- `:125` `instance instSmoothOfRelativeDimensionBaseChange : SmoothOfRelativeDimension 1 ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))`
- `:130` `instance instIsProperBaseChange : IsProper ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))`
- `:136` `instance instQuasiCompactBaseChange : QuasiCompact ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))`
- `:152` `instance instIsIntegralBaseChange : IsIntegral ((C ⊗ overSpec k K).left)`
- `:167` `instance instModuleFiniteHModuleZeroBaseChange : Module.Finite K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 0)`
- `:176` `instance instModuleFiniteHModuleOneBaseChange : Module.Finite K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1)`
- `:193` `private noncomputable def classDegBaseChangeSmoke : Additive ((C ⊗ overSpec k K).left.CechPic) →+ ℤ := classDeg K` (smoke test: all six hypotheses inferred)

Standing hypotheses on `C`: `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`. Mechanism: `Over.isPullback_left` + `MorphismProperty.of_isPullback` + `isIntegral_left_of_geometricallyReduced`. **No `LocallyOfFiniteType` instance exists here** — consumers derive it locally (e.g. `Picard/DivisorThetaFibreData.lean:110`, from `SmoothOfRelativeDimension.smooth`).

The `relCurve`-spelling re-keying is done ad hoc per consumer, e.g. `Picard/DivisorThetaFibreData.lean:101-122` (six `noncomputable local instance`s: `instSmoothRelCurveKey`, `instQCRelCurveKey`, `instLFTRelCurveKey`, `instFinH0RelCurveKey`, `instFinH1RelCurveKey`), and identically at `Picard/DivSchemeRedesignGenericTotalStalk.lean:111-118` and `Picard/Pic0ChartCoverageNoDrop.lean:190-198`. That duplication is the reusability gap.

## 3. Flat base change for section spaces / cohomology

All **proved, 0 `sorry`** in every file below.

`Cohomology/SectionsBaseChange.lean` (the geometric root):
- `:85` `theorem Over.isPullback_left (X T : Over S) : IsPullback (fst X T).left (snd X T).left X.hom T.hom`
- `:113` `instance flat_overSpec_hom … : Flat (overSpec k A).hom`
- `:168` `theorem Over.isPushout_sections [Flat T.hom] (hT : IsAffineOpen (⊤ : T.left.Opens)) {V : X.left.Opens} (hV : IsCompact (V : Set X.left)) (hV' : IsQuasiSeparated (V : Set X.left)) : IsPushout …` (qcqs opens; affine case at `:136` needs no flatness)
- `:287` `noncomputable def Over.sectionsBaseChange {V : X.left.Opens} (hV : IsCompact (V : Set X.left)) (hV' : IsQuasiSeparated (V : Set X.left)) : Γ(X.left, V) ⊗[k] A ≃+* Γ((X ⊗ overSpec k A).left, (fst X (overSpec k A)).left ⁻¹ᵁ V)` — plus `_tmul`, `_one_tmul`, `_tmul_one`, `_naturality`.

`Cohomology/TransitionSectionsBaseChange.lean` — the same for a transition `K₁ → K₂`:
- `:228` `noncomputable def Over.transitionSectionsBaseChange {V : (C ⊗ overSpec k K₁).left.Opens} (hV : IsAffineOpen V) : Γ((C ⊗ overSpec k K₁).left, V) ⊗[K₁] K₂ ≃+* Γ((C ⊗ overSpec k K₂).left, (C ◁ Over.overSpecMap (IsScalarTower.toAlgHom k K₁ K₂)).left ⁻¹ᵁ V)`

`Cohomology/H1BaseFieldInvariance.lean` (384 lines, 0 `sorry`) — **the exact `H^i(X_κ) ≅ H^i(X) ⊗ κ` shapes you asked for**:
- `:328` `noncomputable def h1BaseFieldEquiv : letI : C.left.Over (Spec (.of k)) := .ofHom C.hom; K ⊗[k] Sheaf.HModule (C.left.moduleKSheaf k) 1 ≃ₗ[K] Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1`
- `:336` `noncomputable def h0BaseFieldEquiv : … K ⊗[k] Sheaf.HModule (C.left.moduleKSheaf k) 0 ≃ₗ[K] Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 0`
- `:344` `theorem finrank_h1_baseField : … Module.finrank K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1) = Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)`
- `:354` `theorem finrank_h0_baseField` (same for 0), `:364` `theorem finrank_h1_baseField_eq_genus … = genus C`, `:373` `theorem genus_baseField : … genus (baseChangeBundle C K) = genus C`
- Underlying: `:272` `curveH1BaseChange`, `:302` `curveH0BaseChange`, `:292` `curveCover` (one fixed affine two-cover). Structure sheaf only.

`Cohomology/RelativeH1BaseChange.lean` — general test ring `R → R'`, structure sheaf, *unconditional* (right-exactness, no flatness): `:302` `noncomputable def relH1BaseChange : R' ⊗[R] Sheaf.HModule ((relCurve C R).moduleKSheaf R) 1 ≃ₗ[R'] Sheaf.HModule ((relCurve C R').moduleKSheaf R') 1`. Its docstring explicitly parks the *twisted* case as "Frontier" (lines 308-316).

Twisted / glued sheaves, conditional on vanishing:
- `Cohomology/RigidEngine4BaseChange.lean:471` `noncomputable def relTwistH0BaseChange (hH1 : Subsingleton (relTwistPair C R π g).H1) : R' ⊗[R] (Sheaf.HModule (relTwistSheaf C R (fiberTwoCover π) g) 0) ≃ₗ[R'] Sheaf.HModule (relTwistSheaf C R' (fiberTwoCover π) (relCocycleBaseChange C R R' (fiberTwoCover π) g)) 0`; `:445` `theorem relTwist_subsingleton_h1_baseChange (hH1 : …) : Subsingleton (Sheaf.HModule (relTwistSheaf C R' …) 1)`
- `Cohomology/GluedSheafH0BaseChange.lean:229` `noncomputable def datumH0BaseChange (hH1 : Subsingleton (datumPair D).H1) : B' ⊗[B] (Sheaf.HModule D.sheaf 0) ≃ₗ[B'] Sheaf.HModule (D.baseChange B').sheaf 0`; `:245` `theorem datum_subsingleton_h1_baseChange (hH1 : Subsingleton (datumPair D).H1) : Subsingleton (Sheaf.HModule (D.baseChange B').sheaf 1)`

So: `Γ(X_κ, 𝒪) ≅ Γ(X,𝒪) ⊗ κ` and `H¹(X_κ,𝒪) ≅ H¹(X,𝒪) ⊗ κ` are unconditional and proved. For a **twisted** sheaf, only `H⁰` base change is available and only **on the vanishing locus** (`hH1` threaded); `H¹` transport is only the *vanishing* statement, not an isomorphism.

## 4. Divisor pullback along a field extension; deg over k vs deg over κ

**There is no `CurveDivisor.pullback`/`comap`/`map` along a field extension.** Grep for `pullbackDivisor|divisorPullback|CurveDivisor.pullback|CurveDivisor.comap` returns only `Picard/Pic0ChartRationalGraph.lean:103`, a comment saying "*no `CurveDivisor.pullback` is required*". The only divisor-level transport is indirect: pull back *local equations* (`Scheme.LocalEquations.pullback`) and take `Scheme.presentationDivisor` (`Picard/PresentationDivisor.lean:186`) of the result — this is exactly how `windowTransportDivisor` is built.

Degree relation across fields, all proved (`DegreeBaseFieldInvariance.lean`, 494 lines, 0 `sorry`):
- `:462` **the keystone (E-iv-alg)**: `theorem classDeg_cechPicMap_baseFieldTransition (φ : K₁ →ₐ[k] K₂) (L : (C ⊗ overSpec k K₁).left.CechPic) : classDeg K₂ (Scheme.CechPic.map ((C ◁ Over.overSpecMap φ).left) L) = classDeg K₁ L`
- `:273` `private theorem deg_presentationDivisor_pointTransition (φ : K₁ →ₐ[k] K₂) {x' …} (hx' : x' ≠ genericPoint …) : Scheme.CurveDivisor.deg K₂ (Scheme.presentationDivisor K₂ (pointTransitionEquations C φ hx').presentation) = ((C ⊗ overSpec k K₁).left.residueDeg K₁ x' : ℤ)` — the divisor-level statement, but `private`.
- `RiemannRoch/DegreeBaseChange.lean:212` `theorem sum_ordZ_residueDeg_baseFieldTransition (φ : K₁ →ₐ[k] K₂) …` — the fiber-sum identity (†) feeding the above.
- `RiemannRoch/ThetaDegree.lean:180` `theorem one_le_classDeg_cechPicMap_baseFieldTransition_of_one_le (φ : K₁ →ₐ[k] K₂) …`
- `Picard/Pic0ChartCoverageDegree.lean:93` `theorem classDeg_chartTwistClass_baseChange (L : Type u) [Field L] [Algebra k L] (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor) : classDeg L (…) = (m : ℤ) * classDeg k (thetaCechClass C) - Scheme.CurveDivisor.deg k Z`

The pattern is deliberate: degrees cross fields at the **class** level (`classDeg`), never as a divisor pullback map.

## 5. Uniform (single constant for all field extensions) H¹ vanishing

**No such statement exists.**

What exists is per-field: `RiemannRoch/UniformVanishing.lean:71`, **proved, 0 `sorry`**:

```
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```

`K` and `Y` are fixed **section variables** — `b` depends on `(Y, π)`. Its docstring says so ("depending only on `(Y, π)`"), and the project's own note is explicit: `informal/w4-datb-worksheet.md:65-70` — "DAT-0a's uniform bound `b` (`RiemannRoch/UniformVanishing.lean:71`) is a bound *per field* `b = b(Y_K, π_K)`, and per I-0204/I-0234 ledger constants never transport across `k → κ(t)` … no uniform `m₀` exists." `WindowLedger.lean:109` freezes it as `noncomputable def windowBound : ℤ := (exists_bound_… π hπ).choose` — a per-field `Classical.choose`.

Search basis for the absence claim (whole project, `.lake` excluded):
- `rg "exists_bound"` — 10 hits, all referencing the single per-field theorem above.
- `rg "∀ [({]?[KLκ'](['₁₂])? *: *Type"` — **8 total occurrences project-wide** of a universally quantified field variable in any statement: `Picard/ThetaShift.lean:163`, `Pic0Theta.lean:448,473`, `JacobianDataAbelSquare.lean:134,138,159`, `Pic0Functor.lean:108,123`. I checked all four files: **none contains the token `Subsingleton` at all.** They are degree-zero/degree-`d` layer conditions (`degAt lam t = 0`) and an Abel-map compatibility predicate.
- Multiline `rg -U "∃ [a-z]+ : (ℕ|ℤ)[ ,](…){0,1200}?\[Field "` — no decl pairs an existential integer bound with a universally quantified field.
- `rg -i uniform` across all `.lean` and `informal/`, cross-filtered for field/extension/κ — the only "uniform" H¹ statement is `UniformVanishing.lean`, uniform in **D**, not in the field.
- `rg "\baxiom\b"` at declaration position: none in the project. 29 files contain `sorry`; **none** of them is a base-change file (all base-change/degree/window files listed above are `sorry`-free).

## Reusable machinery, summary

`Curve/BaseChangeInstances.lean` (instances on `C_K`) and `Cohomology/H1BaseFieldInvariance.lean` (structure-sheaf `H⁰`/`H¹`/genus invariance) are the two clean, self-contained, `sorry`-free reusable bricks. `Cohomology/SectionsBaseChange.lean` + `TransitionSectionsBaseChange.lean` are the section-level substrate; `DegreeBaseFieldInvariance.lean:462` is the degree keystone. The two friction points for a porter: (a) `relCurve`-vs-`(C ⊗ overSpec k K).left` spelling means the instances don't fire on the `relCurve` def and get re-declared as local instances in at least three files; (b) twisted-sheaf `H¹` base change is only available as a *vanishing* transport, never as an isomorphism, and `χ(C_K)` is threaded as a hypothesis in `WindowFieldTransport` even though `H1BaseFieldInvariance` could discharge it.
