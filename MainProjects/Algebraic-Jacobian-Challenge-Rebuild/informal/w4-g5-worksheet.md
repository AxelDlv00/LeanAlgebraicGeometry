# W4-G5 WORKSHEET — the ε frame-locus cover and the morphism stitch (DDR-9 backward assembly)

*2026-07-18, Fable design lane.  Parent: `informal/spec-w4-gates.md` Addendum 1 §G-5
(spec:200–222) and the corrected full map (spec:224–232).  Every file:line below was
verified by direct read this pass.  Constraint of record: the chart-frame data
`hw₁`/`hw₂` of `divClassifyAff` is honest input (`Picard/DivSchemeClassifyAff.lean:16-18,
77-80`); G-5 manufactures it over a basic-open cover and glues the resulting unique
morphisms.*

## §0 Verdict up front

1. **Frame convention: QUOTIENT.**  We frame the quotient of the coordinate image of
   the ε-window, never the window submodule itself.  Mathlib's `Module.Grassmannian`
   is the set of submodules with finite projective rank-`g` **quotient**
   (`.lake-packages/mathlib/Mathlib/RingTheory/Grassmannian.lean:64-71`, and the local
   `grFunctorAff` is an abbrev for it, `Picard/GrassmannianFunctor.lean:53-55`); the
   landed matrix calculus presents a point by a split-surjective `g × r` matrix whose
   **kernel** is the submodule and whose free quotient carries the frame
   (`matrixPoint`, `Picard/GrassmannianMatrixPoint.lean:102-121`).  A basis of the free
   localized quotient, read through `LinearMap.toMatrix'`, IS the matrix; the window is
   recovered as `ker`.  No submodule-side generators are ever chosen.
2. **The Spec-basic-open cover constructor exists in mathlib** — the Rebuild needs
   none: `Scheme.affineOpenCoverOfSpanRangeEqTop`
   (`mathlib/Mathlib/AlgebraicGeometry/Cover/Open.lean:200-215`) turns a span-⊤ family
   `f : ι → S` into an `AffineOpenCover` of `Spec S` with pieces
   `Spec (Localization.Away (f i))` and maps `Spec.map (algebraMap …)`;
   `.openCover` (same file, :128) feeds it to `Scheme.Cover.glueMorphisms`
   (`mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:439-448`), `ι_glueMorphisms` (:462),
   `Cover.hom_ext` (:451).  The in-repo gluing precedent with exactly this
   `pullback.fst/snd` overlap shape is `Picard/Pic0SigmaSheaf.lean:97-105`.
   (`Scheme.openCoverOfIsOpenCover`, `mathlib/Mathlib/AlgebraicGeometry/Restrict.lean:179`,
   is the GRQ pattern's constructor; we do not need it — our pieces are Specs of
   localizations, not open subschemes.)
3. **One genuinely new scheme-level workhorse is missing**: the *converse* of
   `map_chartTautologicalPoint_eq_of_specMap_ι_eq` (`Picard/DivCarvePairChart.lean:55-144`)
   — from equal pulled-back tautological points to equal composites with the chart
   immersions, across DIFFERENT charts (W1/W2 in §3).  Everything it needs is landed;
   nothing like it exists in the Rebuild (grep over `Picard/Grassmannian*`,
   `Picard/DivCarve*` returned only the forward direction).
4. **G-2 enters at four pinned points** (§2 step (e); §3 W3; §4 existence; the carve
   transport `hcarve_mapAlg`) — never anywhere else.  The spelling bridge between
   G-2's `Submodule.map (windowBaseChangeMap …)` form (spec:76-79) and mathlib's
   `ker (baseChangeMkQ)` form is already landed:
   `ker_baseChangeMkQ_eq_map_baseChange` (`Picard/DivCarveKit.lean:165-183`, needs the
   projective quotient — i.e. the certificate).

Throughout, the ambient context is the `divClassifyAff` block
(`Picard/DivSchemeClassifyAff.lean:41-62`): `k`, `C`, `π`, `hπ`, `g r₁ r₂`, boundary
bases `b₁ : Basis (Fin r₁) k H_M`, `b₂ : Basis (Fin r₂) k H_{M+s}`, affine test
`S : Type u`, `[CommRing S] [Algebra k S]`, plus `[IsNoetherianRing S]` (the engine
requires it: `Picard/DivSchemeCertificateEngine.lean:306,318,330,373,387`).
Write `M := windowM_choice π hπ g`, `s := windowS_choice π hπ g`,
`H_M := ↥(divisorSections k (M • fiberWeilDivisor π) ⊤)`, similarly `H_{M+s}`;
`ε := divFamEps hπ g F` (`Picard/DivisorFamilyWindow.lean:260-266`).

---

## §1 The free-locus cover of the ε-pair

### §1.0 The certificate packaging (input layer)

For a representative `G : CertifiedDivisorFamily C S π g` of `F` (DivFam is the setoid
quotient — `DivFam.window` is a `Quotient.lift`, `Picard/DivisorFamilyWindow.lean:133-138`),
the two window components of `ε` become Grassmannian points through
`divisorWindowGr` (`Picard/DivisorFamilyWindow.lean:194-209`) with slots

* `hsurj` — `DivisorAdaptation.thetaGluedEval_surjective hπ hfib`
  (`Picard/DivisorThetaSurjectivity.lean:487` per spec:33-35),
* `hfin` — `finite_thetaGlued` (`Picard/DivSchemeCertificateEngine.lean:406-415`),
* `hproj`, `hrank` — the certificate clauses `projective_glued`, `rankAtStalk_glued`
  (field list visible in `isCertified_pullback`, `Picard/DivisorFamilyMapAlg.lean:245-258`;
  `hrank` gives constant rank `g`),

where `hfib` is **the G-1 slot, threaded verbatim** (the engine shape,
`Picard/DivSchemeCertificateEngine.lean:308-310`):

```
(hfib₁ : ∀ p : PrimeSpectrum S,
  Subsingleton ((datumPair (G.adaptation.thetaIdealDatum M)).H1 ⊗[S] p.asIdeal.ResidueField))
(hfib₂ : … (M + s) …)
```

Per the G-2 precedent (spec:109-110) the file threads these named slots so G-5 need
not WAIT on G-1; when G-1 lands (`DivisorAdaptation.IsCertified.fibrewise_h1`,
spec:60-63) they are discharged from `G.certified` and disappear.

### §1.1 Kit (new, module-algebra only, no scheme)

**K1 — ambient coordinate transport.**
```
noncomputable def Grassmannian.congrAmbient (e : H ≃ₗ[k] H') :
    grFunctorAff k H g T → grFunctorAff k H' g T
```
`toSubmodule := Submodule.map (LinearMap.baseChange T e.toLinearMap) x.toSubmodule`;
quotient certificate via `Submodule.Quotient.equiv` along the base-changed ambient
equivalence (invertible by `baseChange_symm_comp_baseChange`,
`Picard/DivSchemeClassify.lean:138-144`).  This packages the coordinate points

```
K₁ᶜ := congrAmbient b₁.equivFun (divisorWindowGr … M-window …)   -- ⊆ S ⊗[k] (Fin r₁ → k)
K₂ᶜ := congrAmbient b₂.equivFun (divisorWindowGr … (M+s)-window …)
```
whose `toSubmodule`s are exactly the right-hand sides of `divClassifyAff`'s `hw₁`/`hw₂`
at `S` (`Picard/DivSchemeClassifyAff.lean:85-90`, via `divisorWindowGr_coe`,
`Picard/DivisorFamilyWindow.lean:211-221`).

**K2 — matrix presentation from a free quotient** (the pinned SHAPE).
```
lemma exists_matrixPoint_eq_of_free {T : Type u} [CommRing T] [Algebra k T] [Nontrivial T]
    (x : grFunctorAff k (Fin r → k) g T)
    (hfree : Module.Free T ((T ⊗[k] (Fin r → k)) ⧸ x.toSubmodule)) :
    ∃ (X : Matrix (Fin g) (Fin r) T) (hX : Function.Surjective (matrixProj k g r T X)),
      matrixPoint k g r T X hX = x
```
Route: `[Nontrivial T]` gives `PrimeSpectrum T` nonempty, so the point's
`rankAtStalk_eq` clause plus `Module.rankAtStalk_eq_finrank_of_free`
(`mathlib/Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean:254`) pins
`finrank T (quotient) = g`; reindex `Module.Free.chooseBasis` to `Fin g`; set
`φ := b.equivFun.toLinearMap ∘ₗ x.toSubmodule.mkQ` and
`X := LinearMap.toMatrix' (φ ∘ₗ (TensorProduct.piScalarRight k T T (Fin r)).symm.toLinearMap)`.
Then `matrixProj k g r T X = φ` (`matrixProj` def,
`Picard/GrassmannianMatrixPoint.lean:47-49`, plus `Matrix.toLin'_toMatrix'`), surjective
(`mkQ` surjective, `b.equivFun` iso), kernel `= x.toSubmodule`; conclude by
`Module.Grassmannian.ext` as in `matrixPoint_eq_of_ker_eq`
(`Picard/GrassmannianMatrixPoint.lean:137-142`).  The matrix columns are the
quotient-basis coordinates of the images of the standard ambient generators
`1 ⊗ₜ e_q` — no lifted submodule generators appear (quotient convention, §0.1).

**K3 — per-point free localization of the pair.**  For `Q` finite projective over `S`:
`Module.FinitePresentation` holds (`Module.finitePresentation_of_projective`, used at
`mathlib/Mathlib/RingTheory/Localization/Free.lean:49`), the free locus is everything
(`Module.freeLocus_eq_univ_iff`,
`mathlib/Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean:158-162`), and **the pinned
mathlib lemma** is

```
Module.FinitePresentation.exists_free_localizedModule_powers
    (mathlib/Mathlib/RingTheory/Localization/Free.lean:78-92)
```
— for `p : PrimeSpectrum S`, applied at `S := p.asIdeal.primeCompl` with
`f := LocalizedModule.mkLinearMap` and `Rₛ := Localization.AtPrime p.asIdeal` (freeness
there from `Module.mem_freeLocus`, FreeLocus.lean:54): it returns `h ∈ p.primeCompl`
with `LocalizedModule.Away h Q` free over `Localization (.powers h)` **and**
`finrank = finrank (AtPrime)`, i.e. `= rankAtStalk Q p = g` by the definition of
`rankAtStalk` (FreeLocus.lean:184-188) and the point's rank clause.  (Its sibling
`exists_basis_localizedModule_powers`, Free.lean:41-70, even lifts a chosen basis; we
only need freeness + finrank.)  Bridge to the tensor spelling:
`LocalizedModule.equivTensorProduct` / `tensorProduct_isLocalizedModule`
(`mathlib/Mathlib/RingTheory/Localization/BaseChange.lean:63,94`), so
`(Localization.Away h) ⊗[S] Q` is free of finrank `g`; and the quotient of the
localized POINT is identified with `(Away h) ⊗[S] Q` by `baseChangeMkQEquiv`
(`mathlib/Mathlib/RingTheory/Grassmannian.lean:111-114`).  Run this for both quotients
`Q₁, Q₂` of `K₁ᶜ, K₂ᶜ` and take `h_p := h₁ · h₂` (freeness survives the further
localization: base change of a free module along `Away h₁ → Away (h₁h₂)`).

**K4 — naturality of K1 under `Module.Grassmannian.map`.**
```
lemma map_congrAmbient (α : T →ₐ[k] T') (e : H ≃ₗ[k] H') (x : grFunctorAff k H g T) :
    Module.Grassmannian.map α (congrAmbient e x) = congrAmbient e (Module.Grassmannian.map α x)
```
Submodule level: rewrite both sides with `ker_baseChangeMkQ_eq_map_baseChange`
(`Picard/DivCarveKit.lean:165-183`; the projective-quotient instances are the points'
own), then `Submodule.map_map` plus the `cancelBaseChange`-vs-`baseChange e` square
(the `cancelBaseChange_comp_baseChange_baseChange` shape used at
`Picard/DivCarveKit.lean:197-205`).

**K5 — residue-field minor selection** (transcription of GR-Quot's private
`exists_isUnit_submatrix`,
`SubProjects/GR-Quot-Closure/AlgebraicJacobian/Picard/GrassmannianQuot.lean:2586-2667`,
verbatim at module level — its enumeration `I.orderIsoOfFin` is exactly the Rebuild's
`frameMinor` spelling, `Picard/GrassmannianChartFrame.lean:49-57`):
```
lemma exists_isUnit_frameMinor_det_of_mul_eq_one {F : Type u} [Field F] [Algebra k F]
    (X : Matrix (Fin g) (Fin r) F) (Y : Matrix (Fin r) (Fin g) F) (hXY : X * Y = 1) :
    ∃ (I : Finset (Fin r)) (hI : I.card = g), IsUnit (frameMinor k g r F X I hI).det
```
Core mathlib input: `Matrix.linearIndependent_cols_iff_isUnit`
(`mathlib/Mathlib/LinearAlgebra/Matrix/NonsingularInverse.lean:370`) +
`exists_linearIndependent`.  Applied over the residue field of the prime `p̃` of
`Away h_p` lying over `p`: the split certificate of `X` transports entrywise
(`exists_mul_eq_one_of_matrixProj_surjective`,
`Picard/GrassmannianMatrixPoint.lean:77-90`, then `Matrix.map` along
`Away h_p → κ(p̃)`), the chosen minor's determinant has unit image in `κ(p̃)`, hence
`det (frameMinor X I) ∉ p̃`.

**K6 — one numerator stage** (basic-open bookkeeping):
```
lemma exists_away_isUnit_of_notMem (h : S) (p : PrimeSpectrum S) (hh : h ∉ p.asIdeal)
    (c : Localization.Away h) (hc : c ∉ p̃) :
    ∃ u : S, u ∉ p.asIdeal ∧ (S → Away h → Away u factoring) ∧ IsUnit (image of c in Away u)
```
Write `c = mk' a ⟨h^n⟩` (`IsLocalization.mk'_surjective`), set `u := h * a`; primality
gives `u ∉ p`; `Away u` is a localization of `Away h` at the powers of the image of
`a` (`IsLocalization.Away.awayToAwayRight`-style tower / `Localization.awayLift`), in
which both `a` and `h` are units, hence `c` is.  Apply once, at
`c := det(frameMinor X₁ I) · det(frameMinor X₂ J)` (unit-ness of each factor is
GL-invariant across presentations: `frameMinor (U·X) I = U · frameMinor X I` by
`mul_submatrix_col`, `Picard/GrassmannianChart.lean:147`, so the choice of
presentation does not matter).

### §1.2 The §1 keystone (pin)

```
theorem divFamEps_exists_frameCover
    [IsNoetherianRing S] (G : CertifiedDivisorFamily C S π g)
    (hfib₁ : <§1.0>) (hfib₂ : <§1.0>) :
    ∃ (m : ℕ) (f : Fin m → S), Ideal.span (Set.range f) = ⊤ ∧
      ∀ t : Fin m,
        ∃ (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
          (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away (f t)),
          Module.Grassmannian.map (w.comp (Algebra.TensorProduct.includeLeft (S := k)))
              (chartTautologicalPoint k g r₁ i.down.1 i.down.2)
            = Module.Grassmannian.map (IsScalarTower.toAlgHom k S (Localization.Away (f t)))
                (congrAmbient b₁.equivFun (divisorWindowGr … hfib₁-slots …))
          ∧ (…includeRight / j / b₂ / hfib₂ analogue…)
```

Deliberately stated at the **`S`-level points** (right-hand sides are `map αₜ` of the
`S`-packaged coordinate points): this makes §1 free of G-2.  The conversion of the
right-hand side into `divClassifyAff`'s literal `hw₁`/`hw₂` for the RESTRICTED family
is §2 (where G-2 is consumed).  Descends to `F : DivFam` by `Quotient.inductionOn`
(the conclusion mentions only `divFamEps`-level data once §2 rewrites it).

Assembly of the proof from the kit: per `p : PrimeSpectrum S` — K3 gives `h_p` with
both localized quotients free of rank `g`; K2 (at `T := Away h_p`, nontrivial since
`D(h_p) ∋ p`) gives matrices `X₁, X₂` presenting the localized points
(`Module.Grassmannian.map` of `K₁ᶜ, K₂ᶜ` along `αₚ`, using K4 to keep coordinates
outside); K5 at `κ(p̃)` chooses `(I, J)`; K6 gives `u_p ∈ S ∖ p` with both minor
determinants units in `Away u_p`; transport the presentations along
`Away h_p → Away u_p` by `map_matrixPoint`
(`Picard/GrassmannianMatrixPoint.lean:199-246`) and `Module.Grassmannian.map_comp`
(`mathlib/Mathlib/RingTheory/Grassmannian.lean:154`); the unit minors fire
`matrixPoint_eq_map_chartTautologicalPoint_of_isUnit`
(`Picard/GrassmannianChartFrame.lean:136-154`) with chart maps
`w₁ := chartFrameMap k g r₁ (Away u_p) X₁ I hI` (:69-71), `w₂ := … X₂ J hJ`; set
`w := Algebra.TensorProduct.productMap w₁ w₂`
(`mathlib/Mathlib/RingTheory/TensorProduct/Maps.lean:744`), whose `includeLeft`/
`includeRight` composites are `w₁`/`w₂` (`productMap_left`/`productMap_right`,
:756,:763) — this is the displayed equation pair.  Finite span-⊤ selection: the family
`{u_p}` meets no prime, so `Ideal.span = ⊤` (`Ideal.exists_le_maximal` contradiction,
or `PrimeSpectrum.iSup_basicOpen_eq_top_iff`,
`mathlib/Mathlib/RingTheory/Spectrum/Prime/Topology.lean:628`); `1 ∈ span` restricts
to a finite subfamily by `Submodule.mem_span_finite_of_mem_span`
(`mathlib/Mathlib/LinearAlgebra/Span/Defs.lean:587`); enumerate by `Fin m`.  The
rank-1 packaging precedent for exactly this choose-then-span-⊤ dance is
`Scheme.TrivializingFamily.nonempty` (`Picard/CechPicSurjective.lean:68-90`).

---

## §2 From frame to chart map: the `hw₁ᵢ` equation

Fix a piece `t`, write `T := Localization.Away (f t)`,
`αₜ := IsScalarTower.toAlgHom k S T`, `F_T := DivFam.mapAlg T g F`
(`Picard/DivisorFamilyMapAlg.lean:275-283`; instance form
`[Algebra S T] [IsScalarTower k S T]`, :158-160 — satisfied by `Localization.Away`).

**The equation to be proven** (= `divClassifyAff`'s `hw₁` at `(T, F_T)`,
`Picard/DivSchemeClassifyAff.lean:85-87`):

```
(hw₁ₜ) (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
        = Submodule.map (LinearMap.baseChange T b₁.equivFun.toLinearMap)
            (divFamEps hπ g (DivFam.mapAlg T g F)).1
```

Chain (each step one rewrite; `hw₂ₜ` is the mirrored chain at `includeRight`, `b₂`,
`pairTautSnd`):

* (a) `map w (pairTautFst i j) = map (w.comp includeLeft) (chartTautologicalPoint I hI)`
  — `pairTautFst` def (`Picard/DivCarveLocus.lean:63-69`) + `Module.Grassmannian.map_comp`;
  then `w.comp includeLeft = w₁` by `productMap_left`.
* (b) `map w₁ (chartTautologicalPoint I hI) = matrixPoint k g r₁ T X₁ hX₁`
  — `matrixPoint_eq_map_chartTautologicalPoint_of_isUnit`
  (`Picard/GrassmannianChartFrame.lean:136`) read right-to-left (`w₁` IS its
  `chartFrameMap`).
* (c) `matrixPoint … = Module.Grassmannian.map αₜ K₁ᶜ` — the §1 construction (K2
  presentation + `map_matrixPoint` transport across `Away h_p → Away u_p`).
* (d) `(map αₜ K₁ᶜ).toSubmodule
      = Submodule.map (LinearMap.baseChange T b₁.equivFun.toLinearMap)
          ((map αₜ (divisorWindowGr …)).toSubmodule)` — K4 (`map_congrAmbient`) +
  K1's `toSubmodule` formula.
* (e) **THE G-2 ENTRY POINT.**
  `(Module.Grassmannian.map αₜ (divisorWindowGr …)).toSubmodule
      = (divFamEps hπ g (DivFam.mapAlg T g F)).1`.
  Left side: `map_toSubmodule` (`mathlib/Mathlib/RingTheory/Grassmannian.lean:139-142`)
  gives `ker (baseChangeMkQ T ε.1)`; `ker_baseChangeMkQ_eq_map_baseChange`
  (`Picard/DivCarveKit.lean:165-183`) converts it to the
  `Submodule.map (cancelBaseChange) (ε.1.baseChange T)` spelling — which is G-2's
  pinned `windowBaseChange T (divFamEps hπ g F).1` (spec:76-79, the ONE recorded
  `windowBaseChangeMap` seam).  Right side: **`divFamEps_mapAlg_awayMap`** (G-2's
  localization corollary, spec:107-108) read right-to-left.  This is where the ε of
  the restricted family becomes the restricted certificate; nothing else in G-5
  touches window internals.

**The carve for the restricted family** (needed to invoke `divClassifyAff` at `T`):

```
lemma hcarve_mapAlg (hcarve : ∀ a, carvePairArrow (windowShiftMul hπ g a) ε.1 ε.2 = 0) :
    ∀ a, carvePairArrow (windowShiftMul hπ g a)
      (divFamEps hπ g (DivFam.mapAlg T g F)).1 (divFamEps hπ g (DivFam.mapAlg T g F)).2 = 0
```
Route: `carvePairArrow … = 0` over `S` ⟹ its base change to `T` is `0` ⟹
`baseChange_carvePairArrow_eq_zero_iff` (`Picard/DivCarveKit.lean:185-196`, `.mp`)
gives the carve for the `ker (baseChangeMkQ)` pair ⟹ rewrite to `ε(F_T)` by step (e)
(G-2 again).  With `hw₁ₜ`, `hw₂ₜ`, `hcarve_mapAlg` in hand, `divClassifyAff`
(`Picard/DivSchemeClassifyAff.lean:82-108`) yields, per piece,

```
∃! vₜ : Spec (CommRingCat.of T) ⟶ DivScheme k (s•F) (M•F) g r₁ r₂ b₁ (b₂.map (windowShiftEquiv hπ g).symm),
  vₜ ≫ divSchemeι … = Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
```

---

## §3 Overlap agreement and the stitch

### §3.1 The missing cross-chart workhorse (new, launchable now)

**W1 (single Grassmannian).**  The converse of
`map_chartTautologicalPoint_eq_of_specMap_ι_eq` (`Picard/DivCarvePairChart.lean:55-144`):

```
theorem specMap_ι_eq_of_map_chartTautologicalPoint_eq
    (i i' : (glueData k d r).J) {B : Type u} [CommRing B] [Algebra k B]
    (a : ChartRing k d r i.down.1 →ₐ[k] B) (a' : ChartRing k d r i'.down.1 →ₐ[k] B)
    (h : Module.Grassmannian.map a (chartTautologicalPoint k d r i.down.1 i.down.2)
       = Module.Grassmannian.map a' (chartTautologicalPoint k d r i'.down.1 i'.down.2)) :
    Spec.map (CommRingCat.ofHom a.toRingHom) ≫ (glueData k d r).ι i
      = Spec.map (CommRingCat.ofHom a'.toRingHom) ≫ (glueData k d r).ι i'
```

Proof skeleton, all landed ingredients:
1. `X := (universalMatrix i).map a`, `X' := (universalMatrix i').map a'` present the
   same point (`chartTautologicalPoint_eq_matrixPoint`,
   `Picard/GrassmannianMatrixPoint.lean:130-134`, + `map_matrixPoint` :199); GL factor
   `X = U · X'` (`exists_isUnit_mul_of_matrixPoint_eq`,
   `Picard/GrassmannianChartFrame.lean:162-234`).
2. `frameMinor X' i'.down.1 = 1` (`universalMatrix_submatrix_self`,
   `Picard/GrassmannianChart.lean:131`, mapped), so `frameMinor X i'.down.1 = U`
   (`mul_submatrix_col`, `Picard/GrassmannianChart.lean:147`) — hence
   `a (minorDet i i')` is a unit (`minorDet`, `Picard/GrassmannianChart.lean:72`).
3. `a` factors through `Localization.Away (minorDet i i')`: `ψ` with
   `ψ.comp (Algebra.algHom k _ _) = a` (`IsLocalization.Away.lift`; the AlgHom
   packaging pattern is `Picard/DivCarvePairChart.lean:119-125` run in reverse).
4. `ψ.comp (transitionPreMap …) = a'` by
   `algHom_ext_of_map_chartTautologicalPoint_eq` (`Picard/DivCarvePairChart.lean:351-393`)
   after `map_transitionPreMap_chartTautologicalPoint`
   (`Picard/GrassmannianTautologicalCocycle.lean:52`) and `h`.
5. Scheme leg: `Spec.map ψ ≫ (pullbackιIso k d r i i').inv`
   (`Picard/GrassmannianScheme.lean:118`) lands in
   `pullback ((glueData).ι i) ((glueData).ι i')`; its `fst`/`snd` composites are
   `Spec.map a` / `Spec.map a'` (`pullbackιIso_inv_fst/snd` + steps 3–4, exactly the
   legs hchart1/hchart2 of the forward proof, `Picard/DivCarvePairChart.lean:69-81`);
   conclude by `pullback.condition`.

**W2 (pair version).**
```
theorem specMap_pairChartMap_eq_of_map_pairTaut_eq
    (i j i' j') (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] B)
    (w' : PairChartRing k g r₁ g r₂ i' j' →ₐ[k] B)
    (h₁ : Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)
        = Module.Grassmannian.map w' (pairTautFst k g r₁ r₂ i' j'))
    (h₂ : … pairTautSnd …) :
    Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
      = Spec.map (CommRingCat.ofHom w'.toRingHom) ≫ pairChartMap k g r₁ g r₂ i' j'
```
`grPair` is a `Limits.pullback` (`Picard/GrassmannianPair.lean:36-38`), so
`Limits.pullback.hom_ext` reduces to the two projections; `pairChartMap_fst`/`_snd`
(`Picard/DivCarvePairChart.lean:176,231`) rewrite each composite into
`Spec.map (includeLeft/Right-composite) ≫ (chart immersion)`; finish with W1 at
`(w.comp includeLeft, w'.comp includeLeft)` and `(… includeRight …)` — the hypotheses
are `h₁`, `h₂` unfolded through the `pairTautFst/Snd` definitions
(`Picard/DivCarveLocus.lean:63-78`) and `map_comp`.

### §3.2 Overlap agreement (W3) — the second G-2 entry

For the cover `𝒰 := (Scheme.affineOpenCoverOfSpanRangeEqTop (f ·) hspan).openCover`
of `Spec (CommRingCat.of S)` and the per-piece `vₜ` of §2, the `glueMorphisms`
obligation (`mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:440` shape, precedent
`Picard/Pic0SigmaSheaf.lean:97-105`):

```
hglue : ∀ t t', pullback.fst (𝒰.f t) (𝒰.f t') ≫ vₜ = pullback.snd (𝒰.f t) (𝒰.f t') ≫ v_{t'}
```

Route: `divScheme_hom_ext` (`Picard/DivScheme.lean:170-175`) reduces to the
composites with `divSchemeι`; rewrite both by the `hvₜ` clauses; conjugate the
pullback into `Spec B` with `B := Localization.Away (f t) ⊗[S] Localization.Away (f t')`
via `pullbackSpecIso` (usage pattern `Picard/GrassmannianPair.lean:73-81`) — no
identification of `B` with `Away (f t · f t')` is needed, `B` stays abstract.  The
two sides become `Spec.map (pushforward of wₜ) ≫ pairChartMap iₜ jₜ` and
`Spec.map (pushforward of w_{t'}) ≫ pairChartMap i_{t'} j_{t'}`: apply **W2 over
`B`**.  Its hypotheses `h₁/h₂`: push `hw₁ₜ`(§2) along `Away (f t) →ₐ[k] B` with
`Module.Grassmannian.map_comp`, and identify the two right-hand sides through
**G-2's instance-form naturality** (`divFamEps_mapAlg`, spec:71-74) along both legs
plus the functor law `DivFam.mapAlg_comp` (`Picard/DivisorFamilyMapAlg.lean:349`):

```
DivFam.mapAlg B g (DivFam.mapAlg (Away (f t)) g F) = DivFam.mapAlg B g F
  = DivFam.mapAlg B g (DivFam.mapAlg (Away (f t')) g F)
```
so both mapped pair points equal the coordinate image of
`divFamEps hπ g (DivFam.mapAlg B g F)` — the same point.  (The K4/DivCarveKit
spelling bridge is reused verbatim; `[IsNoetherianRing B]` is NOT needed — only the
S-level certificates, transported by `Module.Grassmannian.map`, appear.)

### §3.3 The stitch (transcription of the GRQ skeleton)

```
noncomputable def divClassifyGlue … : Spec (CommRingCat.of S) ⟶ DivScheme … :=
  𝒰.glueMorphisms (fun t => vₜ) hglue
```
with `𝒰.ι_glueMorphisms … t : 𝒰.f t ≫ divClassifyGlue = vₜ` — the exact
`grPointOfRankQuotient` pattern
(`SubProjects/GR-Quot-Closure/AlgebraicJacobian/Picard/GrassmannianQuot.lean:4984-4988`,
uniqueness comparison pattern :4999-5022 and :5043-5109), with mathlib names
`Scheme.Cover.glueMorphisms` (Gluing.lean:439), `Scheme.Cover.ι_glueMorphisms` (:462),
`Scheme.Cover.hom_ext` (:451).  The GRQ sheaf-of-modules machinery (`isoLocus`,
`chartLocus`, GrassmannianQuot.lean:2545-2584) is NOT transcribed — the matrix
substrate of §1 replaces it wholesale.

---

## §4 The keystone: `divClassify`

```
theorem divClassify [IsNoetherianRing S] (F : DivFam C S π g)
    (hcarve : ∀ a : ↥(divisorSections k (s • fiberWeilDivisor π) ⊤),
      carvePairArrow (windowShiftMul hπ g a) (divFamEps hπ g F).1 (divFamEps hπ g F).2 = 0) :
    ∃! v : Spec (CommRingCat.of S) ⟶
        DivScheme k (s • fiberWeilDivisor π) (M • fiberWeilDivisor π) g r₁ r₂ b₁
          (b₂.map (windowShiftEquiv hπ g).symm),
      ∀ (f₀ : S) (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
        (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away f₀)
        (hw₁ : (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
          = Submodule.map (LinearMap.baseChange (Localization.Away f₀) b₁.equivFun.toLinearMap)
              (divFamEps hπ g (DivFam.mapAlg (Localization.Away f₀) g F)).1)
        (hw₂ : … b₂ / pairTautSnd / .2 …),
        Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away f₀))) ≫ v ≫ divSchemeι …
          = Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
```

Frame data is no longer input (spec:220-222): the characterizing property is
universally quantified over ALL localizations-with-chart-framings.  G-1's `hfib`
slots are threaded until G-1 lands (then `[IsNoetherianRing S]` + the certificate
inside `F` discharge them).

* **Uniqueness.**  `v, v'` both satisfying the clause: instantiate at the §1 cover's
  `(f t, iₜ, jₜ, wₜ, hw₁ₜ, hw₂ₜ)` (produced by §1+§2 from `F` itself); each piece
  gives `𝒰.f t ≫ v ≫ divSchemeι = 𝒰.f t ≫ v' ≫ divSchemeι`
  (note `𝒰.f t = Spec.map (algebraMap …)` definitionally,
  `affineOpenCoverOfSpanRangeEqTop_f`), so `𝒰.f t ≫ v = 𝒰.f t ≫ v'` by
  `divScheme_hom_ext` (`Picard/DivScheme.lean:170-175`), and `v = v'` by
  `Scheme.Cover.hom_ext` (Gluing.lean:451).
* **Existence.**  `v := divClassifyGlue` (§3.3).  The clause at ARBITRARY
  `(f₀, i, j, w, hw₁, hw₂)`: `divClassifyAff` at `Away f₀` (hypotheses from
  `hw₁/hw₂` given and `hcarve_mapAlg`) yields the unique `u` with
  `u ≫ divSchemeι = Spec.map w ≫ pairChartMap i j`; show
  `Spec.map (algebraMap S (Away f₀)) ≫ v = u` by comparing over the pullback cover
  of `Spec (Away f₀)` along `𝒰` (pieces `Spec ((Away f₀) ⊗[S] (Away (f t)))`):
  on each piece both `≫ divSchemeι`-composites are chart morphisms of the same
  framed point — W2 + G-2 + `DivFam.mapAlg_comp`, exactly the W3 argument with
  `(f₀, f t)` in place of `(f t, f t')` — then `divScheme_hom_ext` +
  `Scheme.Cover.hom_ext` on the pullback cover.

**DDR-9 consumer shape** (spec:224-232): `divClassify` is the backward half of
`divRepAff`; the forward half is G-4's `divUniversalFamily` mapped along chart points;
Law 1 composes `DivSchemeEpsUniv` + G-2 + DDR-8 (`Picard/DivSchemeMono.lean`), Law 2
is `divScheme_hom_ext` chart-locally.  The ∀-form clause is deliberately stable under
further localization (the clause at `f₀·f₁` follows from the clause at `f₀` by
`DivFam.mapAlg_comp` + W2), which is the shape DD-2's
`ext_of_le_cover`/`existsUnique_glue_of_le_cover` + `divFunctor`
(`Picard/DivisorFamilyZarFunctor.lean`, staged — spec:11-12) consume to lift
`divRepAff` to the full `divRep`.

---

## §5 File plan, gating, risks

Memory discipline (spec:16-19, 153-158): one heavy lane at a time, single-module
`lake build` with `LEAN_NUM_THREADS=1`; every heavy keystone in its own compilation
unit; `set_option maxSynthPendingDepth 3` in-file (I-0161 pattern,
`Picard/DivSchemeClassifyAff.lean:21-24`); files ≤ 500 L.

| # | File (new) | Contents | Est. size | Gates |
|---|---|---|---|---|
| 1 | `Picard/GrassmannianChartCompare.lean` | W1 + the `IsLocalization.Away.lift` AlgHom helper | ~250 L | none — launchable now |
| 2 | `Picard/GrassmannianPairCompare.lean` | W2 | ~120 L | file 1 |
| 3 | `Picard/DivSchemeFrameKit.lean` | K1, K2, K4, K5, K6 (module algebra only, no curve context) | ~380 L | none — launchable now, parallel to 1 |
| 4 | `Picard/DivSchemeFrameCover.lean` | §1.2 `divFamEps_exists_frameCover` (+ the packaged coordinate points) | ~350 L | file 3; G-1 soft (thread `hfib₁/hfib₂` named slots) |
| 5 | `Picard/DivSchemeClassifyLocal.lean` | §2: `hw₁ₜ/hw₂ₜ` conversion, `hcarve_mapAlg`, per-piece `vₜ` | ~300 L | files 2,4; **G-2 hard** (`divFamEps_mapAlg` + `divFamEps_mapAlg_awayMap`); salvage (the `DivSchemeClassify*` tree under faithful re-verification, spec:8-10) |
| 6 | `Picard/DivSchemeClassifyGlobal.lean` | §3.2 W3 + §3.3 glue + §4 `divClassify` | ~450 L (split W3 out if over) | file 5 |

Lane order under the memory constraint: 1 ∥ 3 (light, no gates) → 2 → 4 → 5 → 6;
this matches the spec's global order (…G-2 → G-4 → G-5 → assembly, spec:230-232) with
files 1–4 startable before G-2/G-4 finish.

**Honest risks.**

1. **G-2 spelling drift** (medium).  Step (e) needs G-2's `windowBaseChangeMap` to be
   the `cancelBaseChange` orientation pinned at spec:76-79 so that
   `ker_baseChangeMkQ_eq_map_baseChange` (`Picard/DivCarveKit.lean:165-183`) closes
   the bridge; if the G-2 lane coins a different ambient comparison, one transport
   lemma must be added (bounded, but a real seam).  Mitigation: file 5's docstring
   should re-pin the orientation and cite DivCarveKit:168 as the normal form.
2. **The ∀-form clause's existence proof** (medium): the arbitrary-`f₀` comparison
   (§4) costs a second pullback-cover argument (~100 L on top of W3).  Fallback: state
   the clause existentially over the produced cover; uniqueness survives (W2 on double
   overlaps), but the DD-2 consumer must then be re-checked against the weaker form —
   record the decision in the file header if taken.
3. **`hfib` threading through the setoid** (low): `divisorWindowGr` slots are
   per-adaptation; §1 works on a representative (`Quotient.inductionOn`) and the
   conclusion is class-level only after §2's rewrite to `divFamEps`.  The worker-form
   statement (§1.2) must stay representative-level until G-1 lands — do not try to
   state `hfib` on `DivFam`.
4. **Nontriviality/rank bookkeeping in K2** (low): pieces are `Away u_p` with
   `D(u_p) ∋ p`, hence nontrivial; the finrank-`g` transfer is
   FreeLocus.lean:254 + the finrank clause of Free.lean:78 — both read this pass.
   Trivial-ring corner cases never arise on the produced cover.
5. **K6 localization tower** (low-medium): the `Away h → Away (h·a)` factoring and
   unit bookkeeping is standard but fiddly (`IsLocalization.Away.awayToAwayRight`,
   `Localization.awayLift`); the GL-invariance note in §1.1/K6 is what keeps the
   choice of presentation out of the statement.  Budget a day of instance wrangling.
6. **Elaboration weight of file 6** (medium): full curve context + scheme category +
   pullback covers is the profile that OOMed `DivSchemeClassify.lean` at 58 GB
   (spec:16-19).  Keep W3 and `divClassify` in separate sections with minimal
   variable blocks; if the file crosses 450 L or a single decl elaborates > ~10 min at
   1 thread, split W3 into its own unit (`DivSchemeClassifyOverlap.lean`).
7. **What G-5 does NOT need** (recorded to prevent scope creep): no `IsOpenCover` of
   chart loci (GRQ:2680) — the frame loci never appear as opens; no iso-locus sheaf
   machinery (GRQ:2545); no identification `Sₜ ⊗[S] Sₜ' ≅ Away (f t · f t')`; no
   Noetherian hypothesis on overlap rings; no new Spec-basic-open cover constructor
   (§0.2).
