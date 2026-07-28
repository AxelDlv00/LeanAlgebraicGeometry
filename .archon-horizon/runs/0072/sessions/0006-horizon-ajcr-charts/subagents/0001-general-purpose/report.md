Search is complete — all four sections were finished before your message. Below is (1) and (2) as requested, then a pointer to the rest.

## (1) Divisor base change `CurveDivisor` on `relCurve C k` → `relCurve C L`: NOT FOUND

No such operation exists in the tree, in either direction.

Searches run: `CurveDivisor.{pullback,comap,map,baseChange,pull}`; any `def` whose signature takes `(… CurveDivisor)` and returns `… CurveDivisor`; `fibreDivisor`, `pullbackDivisor`, `divisorPullback`, `baseChangeDivisor`, `CurveDivisor.baseChange`. Files read in full or in relevant part: `RiemannRoch/Divisor.lean`, `DegreeBaseChange.lean`, `DegreeBaseFieldInvariance.lean`, `DegreePullback.lean`, `DegreePullbackFiber.lean`, `DegreePullbackDictionary.lean`, `ClassCohomology.lean`, `FLVClass.lean`, `Picard/PresentationDivisor.lean`, `Picard/DivisorClassMeromorphic.lean`, `Picard/LocalEquationsPullback.lean`.

`Scheme.CurveDivisor` is a bare `Finsupp` with no functoriality at all — `/…/AlgebraicJacobian/RiemannRoch/Divisor.lean:40`, `def CurveDivisor (X : Scheme.{u}) [IsIntegral X] : Type u := {x : X // x ≠ genericPoint X} →₀ ℤ`. Consequently there is also no `deg`-compatibility and no `picClass`/`CechPic.map` commuting square for a divisor base change, because there is nothing to state them about.

Direction correction, since it affects how you use the替 route: `relCurveMap C R R' : relCurve C R' ⟶ relCurve C R` (`Cohomology/RelativeSectionsLinear.lean:160`) points from the larger ring to the smaller, so `CechPic.map (relCurveMap C k L)` carries classes **from `C_k` to `C_L`** — the direction COV-1 needs.

What the tree uses instead (this is the landed route, at the class / local-equations layer):

- `Scheme.LocalEquations.pullback` — `Picard/LocalEquationsPullback.lean:118` — `(f : Y ⟶ X) (E : X.LocalEquations) (hreg : ∀ (y z : Y) (hz : z ∈ (E.cover.pullback f).opens y), (Y.presheaf.germ … z hz).hom (pullbackEqn f E y) ∈ nonZeroDivisors (Y.presheaf.stalk z)) : Y.LocalEquations`
- `Scheme.LocalEquations.picClass_pullback` — `Picard/LocalEquationsPullback.lean:172`, `@[simp]` — `(E.pullback f hreg).picClass = CechPic.map f E.picClass`
- `Scheme.LocalEquations.pullbackEqn_germ_mem_nonZeroDivisors` — `RiemannRoch/DegreeBaseFieldInvariance.lean:72` — discharges `hreg` with no flatness for integral schemes and generic-to-generic `f`
- `classDeg_cechPicMap_baseFieldTransition` (E-iv-alg) — `RiemannRoch/DegreeBaseFieldInvariance.lean:462` — `(φ : K₁ →ₐ[k] K₂) (L : (C ⊗ overSpec k K₁).left.CechPic) : classDeg K₂ (Scheme.CechPic.map ((C ◁ Over.overSpecMap φ).left) L) = classDeg K₁ L`. Spelled with `(C ◁ Over.overSpecMap φ).left`; cross to `relCurveMap` by `relCurveMap_eq_overSpecMap_ofId` (`RiemannRoch/WindowFieldTransport.lean:197`), as `deg_windowTransportDivisor` (`:247-253`) already does.
- `Scheme.CurveDivisor.exists_picClass_eq` — `Picard/DivisorClassMeromorphic.lean:118` — re-extract a divisor after the class move
- `classDeg_picClass` (E-i) — `RiemannRoch/Degree.lean:157`

So: push the class, read the degree by E-iv-alg, then choose a fresh `L`-divisor. Your Σ on the `K_s` curve and the base-changed points on `C_L` will be linked at class level only.

## (2) k-rational point of `C.left` → point of `relCurve C L`: the map and its two triangles FOUND; `residueDeg = 1` NOT FOUND

Found, all in `Curve/SepPointsDenseKit.lean` under `variable {k} [Field k] (C : Over (Spec (.of k))) (L : Type u) [Field L] [Algebra k L]`:

- `Over.rationalPointBaseChange` — `:113` — `noncomputable def (p : Spec (.of k) ⟶ C.left) (hp : p ≫ C.hom = 𝟙 (Spec (.of k))) : Spec (.of L) ⟶ (C ⊗ overSpec k L).left`
- `Over.rationalPointBaseChange_fst` — `:123`, `@[reassoc]` — `… ≫ (fst C (overSpec k L)).left = Spec.map (CommRingCat.ofHom (algebraMap k L)) ≫ p`
- `Over.rationalPointBaseChange_snd` — `:134`, `@[reassoc]` — `… ≫ (snd C (overSpec k L)).left = 𝟙 (Spec (.of L))`. Docstring: "the input from which **B-5 extracts** `residueDeg L = 1`."
- `Over.dense_baseChange_rationalPoints` — `Curve/SepPointsDense.lean:278` — `[IsSepClosed k] [SmoothOfRelativeDimension 1 C.hom] [IsIntegral C.left] (W : (relCurve C L).Opens) (hW : (W : Set (relCurve C L)).Nonempty) : ∃ (p) (hp : p ≫ C.hom = 𝟙 _), (Over.rationalPointBaseChange C L p hp).base (IsLocalRing.closedPoint L) ∈ W`
- `Over.exists_rationalPoint_mem` — `Curve/SeparablyClosedPoints.lean:157`
- Supporting: `tensorPointEval` `:58`, `exists_algHom_tensorPointEval_ne_zero` `:85`, `Over.rationalPointEval` `:183`, `Over.rationalPointEval_ne_zero_of_mem_basicOpen` `:238`

NOT FOUND, and this is real B-5 work: no `residueDeg L (… .base (closedPoint L)) = 1`; no "the fibre over a `k`-rational point is a single point"; no base change of `single x 1`. A tree-wide `residueDeg` grep yields only `residueDeg_finite` (`ResidueDegree.lean:71`), `residueDeg_pos` (`:154`), `residueDeg_eq_of_isIso` (`DegreeIsoTransport.lean:225`), and arithmetic uses. Both worksheet headers concede it (`SepPointsDenseKit.lean:132`, `SepPointsDense.lean:36`).

Two precedents that shorten it:
- `Scheme.Pic0.residueFieldIso_of_section_over_field` — **sibling AJC tree**, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean:373` — a section of a scheme over `Spec k` has residue field `≅ k`; sorry-free, scheme-general, portable. Route: split epi + field mono ⟹ iso.
- `classDeg_graphPicClass` — `RiemannRoch/GraphDegree.lean:445` — `classDeg K (Over.graphPicClass C t) = 1` for `t : overSpec k K ⟶ C`, via `presentationDivisor_graphLocalEquations:422`. The tree proves `ord · residueDeg = 1` as a product, never the factor alone.

For `single` itself: `Scheme.CurveDivisor.single` — `RiemannRoch/ChiFiniteness.lean:67`; `deg_single'` — `:104` — `deg K (single hx n) = n * X.residueDeg K x`. The consumers wanting `residueDeg = 1` are `CoverageDrop.lean:143` (`hdx`) and `:218` (`hPdeg`).

## (3) and (4)

Both finished; full detail is in my previous message. Headlines: (3) the honest fibre reading exists as a three-rewrite composite of `thetaFamily_overSpec_affineEquiv` (`Picard/ThetaShift.lean:122`), `relPicAlgMap_mk` (`Picard/RelPicPi.lean:252`), and `relCurveMap_eq_overSpecMap_ofId`, but is not a named lemma; `chartTwist_collapse` (`Picard/Pic0ChartTwistCollapse.lean:167`) fuses the whole `λ·θᵐ·Σ⁻¹` twist into one theta-family; `exists_splitting_of_picEt` (`Picard/Pic0ChartSplit.lean:143`) is unconditional. (4) `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` is at `RiemannRoch/UniformVanishing.lean:71` and needs a seven-instance `Y/K` pack plus a finite dominant `π_L : relCurve C L ⟶ P1 L` — that `π_L` is the second genuine gap, nothing landed supplies it; χ-invariance IS landed and public as `chi_relCurve` (`Picard/DivisorDatumRankOne.lean:82`), not under any `chi_moduleKSheaf_baseChange` name.
