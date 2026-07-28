State survey of the DAT-B coverage / local-surjectivity layer (AlgebraicJacobian/Picard/), as of current HEAD. All files checked contain zero code-level `sorry` (verified both case-sensitive and case-insensitive grep across the full ten files plus Pic0SigmaSheaf.lean — count is 0 in every file, so there is no docstring-vs-code ambiguity to resolve here).

## 1. Declarations mentioning `Presheaf.IsLocallySurjective` for chart maps

Grep of `IsLocallySurjective`, `Sigma.desc`, `locallySurjective` (case-insensitive) across `AlgebraicJacobian/Picard/` hits exactly these declarations (all as a **hypothesis/instance argument**, never as a proved conclusion — nothing in the tree proves an `IsLocallySurjective` instance):

- `AlgebraicGeometry.pic0RepresentableByOfCharts` — `Picard/Pic0SigmaSheaf.lean:161-169`
  ```
  noncomputable def pic0RepresentableByOfCharts
      {ι : Type u} {X : ι → Scheme.{u}}
      (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
      (hf : ∀ i, IsOpenImmersion.presheaf (f i))
      [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
      (pic0TypeFunctor C).RepresentableBy
        (Over.mk ((Scheme.LocalRepresentability.representableBy hf).homEquiv
          (𝟙 (Scheme.LocalRepresentability.glueData hf).glued)).1) :=
    (Scheme.LocalRepresentability.representableBy hf).overSlice
  ```
  Sorry-free. `IsLocallySurjective` here is an **instance-argument hypothesis** consumed via `Scheme.LocalRepresentability.representableBy`, not proved.

- `gluedHom` / `gluedOfCharts` / `representableBy_homEquiv_toGlued` / `toGlued_comp_gluedHom` / `locallyOfFiniteType_gluedHom` / `quasiCompact_gluedHom` / `JacobianData.ofCharts` / `JacobianData.ofChartsOfCompactSpace` — `Picard/JacobianDataCharts.lean:117` (`variable [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`), scoping over lines 119-223 in `section Charts`. All sorry-free (confirmed no `sorry` in file).

- `JacobianData.ofAbelLifts` / `ofChartsOfAbelLifts` — `Picard/JacobianDataAbelImage.lean:183` (`variable [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)]`), scoping `JacobianData.ofChartsOfAbelLifts` at lines 193-202. Sorry-free.

- `JacobianData.ofAbelImage` / `ofChartsOfAbelImage` — `Picard/JacobianDataAbelSurj.lean:183` (same variable declaration), scoping `JacobianData.ofChartsOfAbelImage` at lines 144-150. Sorry-free.

- `mixedParamRepresentableBy` — `Picard/Pic0ChartAtlasParamFree.lean:125-138`:
  ```
  def mixedParamRepresentableBy {ι : Type u} (nn : ι → ℕ) (D : ι → Over (Spec (.of k)))
      (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
      (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
      (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i) = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
      (V : ∀ i, (D i).left.Opens)
      (hf : ∀ i, IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i))
      [Presheaf.IsLocallySurjective Scheme.zariskiTopology
        (Sigma.desc (mixedParamChart C π nn D rep m Z hdeg V))] :
      (pic0TypeFunctor C).RepresentableBy (...) :=
    pic0RepresentableByOfCharts C (mixedParamChart C π nn D rep m Z hdeg V) hf
  ```
  Sorry-free (confirmed no `sorry` in file).

Prose-only mentions (not declaration statements): `Picard/Pic0AtlasFromDivRep.lean:61` (docstring bullet), `Picard/Pic0ChartCoverageNoDrop.lean:212` (docstring, referring to what DAT-B B-6's packaging "consumes"), `Picard/JacobianDataCharts.lean:252` (docstring blockquote in the module doc's "What remains" section).

**No declaration anywhere in the ten-plus-two files searched actually proves an `IsLocallySurjective` instance.** Every occurrence is a `variable [...]` binder or explicit instance-argument that downstream code takes as given.

## 2/3. Per-file declaration list, statement, sorry status, sorry count

**Pic0ChartCoverageDegree.lean** (0 code `sorry`; grep confirms zero matches file-wide)
- `classDeg_cechPicMap_base_of_field` (line 83) — `classDeg L (Scheme.CechPic.map (...) Λ) = classDeg k Λ`. Sorry-free.
- `classDeg_chartTwistClass_baseChange` (line 93) — `classDeg L (Scheme.CechPic.map (...) (chartTwistClass C m Z)) = m·classDeg k Θ − deg_k Z`. Sorry-free.
- `classDeg_of_presenting` (line 140) — `classDeg L M = PicEtAff.degAff L (PicEtAff.map C L (picEtAffineEquiv C K ν))`, given a presentation hypothesis. Sorry-free. (Docstring notes this theorem "remains without consumers" — landed but unused.)

**Pic0ChartCoverageDegreeStep2.lean** (0 code `sorry`)
- `classDeg_presenting_eq_degAff` (line 85) — `classDeg L M = PicEtAff.degAff K a`, the base-field step. Sorry-free.
- `classDeg_presenting_eq_zero` (line 98) — degree-zero case: `classDeg L M = 0`. Sorry-free.
- `classDeg_presenting_twist` (line 125) — assembled ledger: `classDeg L (M₀ · twist) = m·d₁ − deg_k Z`. Sorry-free.
- `classDeg_presenting_twist_eq_add` (line 148) — the `g+e` shape: `classDeg L (M₀·twist) = g + e`. Sorry-free.

**Pic0ChartCoverageFibre.lean** (0 code `sorry`)
- `mem_chartLocus_of_isSplitWitness_fibre` (line 95) — a split witness of the twisted fibre class gives `t ∈ chartLocus C m Z lam`. Sorry-free.
- `mem_chartLocus_of_drop` (line 200) — B-5 assembly via the greedy drop; conclusion `t ∈ chartLocus ... ∧ ∃ S, 0 ≤ S ∧ deg L S = e ∧ h0(...) = 1 ∧ Subsingleton(...)`. Sorry-free.

**Pic0ChartCoverageTest.lean** (0 code `sorry`)
- `mem_chartLocus_of_witness_h1` (line 106) — coverage drop-free: a witness with `H¹ = 0` alone gives `t ∈ chartLocus`. Sorry-free.
- `mem_chartLocus_of_vanishing_bound` (line 154) — coverage from a DAT-0a-style threshold `hb`; note module docstring's **retraction** (I-0660) that `b` is *forced* to equal the chart parameter `n`, not freely derivable from DAT-0a. Sorry-free.
- `exists_mem_chartLocus_of_vanishing_bound` (line 214) — the `∃ m', Z'` packaged form. Sorry-free.

**Pic0ChartCoverageNoDrop.lean** — this file's declarations are actually `mem_chartLocus_of_witness_h1` etc. shown above under Pic0ChartCoverageTest; correction: checking imports, `Pic0ChartCoverageTest.lean` imports `Pic0ChartCoverageDegreeStep2` + `Pic0ChartCoverageTest`... Re-verified via outline: **`Pic0ChartCoverageNoDrop.lean` itself has 0 declarations** in its own outline (imports `Pic0ChartRationalGraph`, `DivSchemeSeedUnivAssembleKappa`, `RiemannRoch.CoverageDrop`) — the declarations `mem_chartLocus_of_witness_h1`/`mem_chartLocus_of_vanishing_bound`/`exists_mem_chartLocus_of_vanishing_bound` live in **Pic0ChartCoverageTest.lean**, not NoDrop. `Pic0ChartCoverageNoDrop.lean`'s single declaration is:
- `exists_isSplitWitness_of_drop` (line 105) — drop-based witness existence: `IsSplitWitness ... ∧ ∃ S, 0 ≤ S ∧ deg = e ∧ (support clause) ∧ h0 = 1 ∧ Subsingleton(...)`. Sorry-free. 0 code `sorry` in file.

**Pic0ChartCoverageIndexSlack.lean** (0 code `sorry`)
- `ledger_forces_b_eq_n` (line 119) — at chart index legal at parameter `n`, `hdeg` forces `b = n`. Sorry-free.
- `index_of_threshold` (line 147) — converse: every `b ≥ 0` realized by index at parameter `b.toNat`. Sorry-free.
- `hb_forces_h0_eq_one` (line 180) — `hb` at `b=n` forces every degree-`n` divisor to have `h⁰=1`. Sorry-free.

**Pic0ChartAtlasParamFree.lean** (0 code `sorry`)
- `mixedParamChart` (line 86) — a chart family with per-index parameter `nn i`. `def`, no proof body beyond `restrictChart (...)`. Sorry-free.
- `isOpenImmersion_presheaf_mixedParamChart` (line 103) — `hf` clause = per-index `IsChartUniv`. Sorry-free.
- `mixedParamRepresentableBy` (line 125) — admissibility into `pic0RepresentableByOfCharts` (see §1 above). Sorry-free.

**JacobianDataAbelSurj.lean** (0 code `sorry`)
- `quasiCompact_of_surjective_from_divScheme` (line 78) — `QuasiCompact J.hom` from a surjection `DivScheme k A B g r₁ r₂ b₁ b₂ ⟶ J.left`. Sorry-free.
- `JacobianData.ofAbelImage` (line 104) — DJ-2 packaging with qc field via Abel-image surjectivity. Sorry-free.
- `JacobianData.ofAbelImage_J` (line 114, `@[simp]`) — `.J` projection lemma, `rfl`. Sorry-free.
- `JacobianData.ofChartsOfAbelImage` (line 144) — chart-atlas form of DJ-2 (this is the declaration in §1's local-surjectivity variable scope, line 131). Sorry-free.

**JacobianDataAbelImage.lean** (0 code `sorry`)
- `surjective_of_forall_exists_residueField_lift` (line 82) — per-point residue-field lifts give `Function.Surjective f.base`. Sorry-free.
- `quasiCompact_of_forall_residueField_lift_from_divScheme` (line 118) — DJ-1 qc step from per-point lifts. Sorry-free.
- `JacobianData.ofAbelLifts` (line 149) — DJ-2 against per-point lifts. Sorry-free.
- `JacobianData.ofAbelLifts_J` (line 160, `@[simp]`) — `.J` projection, `rfl`. Sorry-free.
- `JacobianData.ofChartsOfAbelLifts` (line 193) — atlas producer against per-point lifts (this is the declaration in the local-surjectivity variable scope, line 183). Sorry-free.

**JacobianDataCharts.lean** (0 code `sorry`)
- `JacobianData.ofRepresentableBy` (line 71) — packages a `RepresentableBy` + two finiteness certs into `JacobianData C`. Sorry-free.
- `JacobianData.ofRepresentableBy_J` / `_rep` (lines 81, 88, `@[simp]`) — projection lemmas, `rfl`. Sorry-free.
- `JacobianData.homEquiv_ofRepresentableBy` (line 96, `@[simp]`) — `rfl`. Sorry-free.
- `chartHom` (line 114) — structure morphism of the `i`-th chart, `(yonedaEquiv (f i)).1`. Sorry-free.
- `gluedHom` (line 122, `abbrev`) — structure morphism of the glued object. Sorry-free. **This is the declaration whose `variable` context (line 117) carries `IsLocallySurjective`.**
- `gluedOfCharts` (line 129, `abbrev`) — glued object as `Over`. Sorry-free.
- `representableBy_homEquiv_toGlued` (line 133) — universal element restricts along glue map. Sorry-free.
- `toGlued_comp_gluedHom` (line 141) — charts are charts over the base field. Sorry-free.
- `locallyOfFiniteType_gluedHom` (line 154) — lft descends from charts (Zariski-local-on-source). Sorry-free.
- `quasiCompact_gluedHom` (line 164) — qc descends from a finite family of compact charts. Sorry-free.
- `JacobianData.ofCharts` (line 182) — **finite-atlas producer**: chart family + lft + compact charts ⟹ `JacobianData C`. Sorry-free.
- `JacobianData.ofCharts_J` (line 192, `@[simp]`) — `rfl`. Sorry-free.
- `JacobianData.ofChartsOfCompactSpace` (line 209) — **infinite-atlas producer**: same but `CompactSpace` of glued object supplied directly. Sorry-free.
- `JacobianData.ofChartsOfCompactSpace_J` (line 219, `@[simp]`) — `rfl`. Sorry-free.

Per-file sorry-as-term counts (all zero, confirmed by both `grep -n "sorry"` — no output — and `grep -ic "sorry"` — all print `0`):
```
Pic0ChartCoverageDegree.lean: 0
Pic0ChartCoverageDegreeStep2.lean: 0
Pic0ChartCoverageFibre.lean: 0
Pic0ChartCoverageTest.lean: 0
Pic0ChartCoverageNoDrop.lean: 0
Pic0ChartCoverageIndexSlack.lean: 0
Pic0ChartAtlasParamFree.lean: 0
JacobianDataAbelSurj.lean: 0
JacobianDataAbelImage.lean: 0
JacobianDataCharts.lean: 0
Pic0SigmaSheaf.lean: 0
```

## 4. Final assembly declaration signatures

**JacobianDataCharts.lean** — `JacobianData.ofCharts` (line 182), the finite-atlas producer that consumes `hf` and the ambient `IsLocallySurjective` variable:
```
noncomputable def JacobianData.ofCharts [Finite ι]
    (hlft : ∀ i, LocallyOfFiniteType (chartHom C f i))
    (hcpt : ∀ i, CompactSpace (X i)) :
    JacobianData C :=
  JacobianData.ofRepresentableBy C (gluedOfCharts C f hf)
    (pic0RepresentableByOfCharts C f hf)
    (locallyOfFiniteType_gluedHom C f hf hlft)
    (quasiCompact_gluedHom C f hf hcpt)
```
(and its infinite-atlas sibling `JacobianData.ofChartsOfCompactSpace`, line 209, dropping `Finite ι` and `∀ i, CompactSpace (X i)` for a direct `CompactSpace (glueData hf).glued` hypothesis.)

**Pic0SigmaSheaf.lean** — `pic0RepresentableByOfCharts` (lines 161-169), the `RepresentableBy` producer that consumes `hf` and `IsLocallySurjective` directly:
```
noncomputable def pic0RepresentableByOfCharts
    {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (hf : ∀ i, IsOpenImmersion.presheaf (f i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
    (pic0TypeFunctor C).RepresentableBy
      (Over.mk ((Scheme.LocalRepresentability.representableBy hf).homEquiv
        (𝟙 (Scheme.LocalRepresentability.glueData hf).glued)).1) :=
  (Scheme.LocalRepresentability.representableBy hf).overSlice
```

## 5. Declaration mentioning BOTH a chart map and `IsLocallySurjective` in its statement

Yes — `AlgebraicGeometry.mixedParamRepresentableBy`, `Picard/Pic0ChartAtlasParamFree.lean:125-138`. Its statement's hypotheses literally contain the chart-map term `mixedParamChart` nested inside the `IsLocallySurjective` instance argument:
```
def mixedParamRepresentableBy {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens)
    (hf : ∀ i, IsOpenImmersion.presheaf (mixedParamChart C π nn D rep m Z hdeg V i))
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (mixedParamChart C π nn D rep m Z hdeg V))] :
    (pic0TypeFunctor C).RepresentableBy (...) :=
  pic0RepresentableByOfCharts C (mixedParamChart C π nn D rep m Z hdeg V) hf
```
Sorry-free. Same pattern holds for `pic0RepresentableByOfCharts` itself (`Pic0SigmaSheaf.lean:161-169`, §1/§4 above): the chart map `f` appears both as the `hf` argument's index and inside `Sigma.desc f` under `IsLocallySurjective`.
