All checks are complete. Here is the report.

---

## G-1 — `Pic0PreservesFilteredBaseColimit`

**VERDICT: REAL** (the object exists and is genuinely unproved), **with one correction to the framing.**

`AlgebraicGeometry.Pic0PreservesFilteredBaseColimit`, `AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136`, is a **`def … : Prop`** — not a class, not a structure, not a theorem:

```lean
def Pic0PreservesFilteredBaseColimit : Prop :=
  ∀ ⦃J : Type u⦄ [SmallCategory J] [IsCofiltered J] (S : J ⥤ Over (Spec (.of k))),
    (∀ ⦃i j : J⦄ (f : i ⟶ j), IsAffineHom (S.map f).left) →
    (∀ i, CompactSpace (S.obj i).left) →
    (∀ i, QuasiSeparatedSpace (S.obj i).left) →
    ∀ [HasLimit S], PreservesColimit S.op (pic0TypeFunctor C)
```

Producer census — **zero producers**, confirmed by: case-insensitive `grep -rni "pic0preservesfilteredbasecolimit"` over the whole tree (17 hits, listed below); suffix-position searches for `pic0PreservesFiltered`, `preservesFilteredBaseColimit`, `_pic0Preserves` (zero hits); cross-project grep over `MainProjects/` + `SubProjects/`. Every hit is either the `def` itself, prose in a docstring, or the single **consumer** `preservesColimit_deltaScheme_of_residual` which takes it as an explicit hypothesis `(h : …)`. `PicRepColimitResidual.lean:49` looks like a producer in a grep but is inside a fenced code block in the module docstring.

What it demands: that `pic0TypeFunctor C` over the **fixed** base `k` is locally of finite presentation as a functor — it sends the colimit of `S.op` to the colimit of values, for every cofiltered `S` of qcqs test schemes with affine transition maps.

Because it is a bare `Prop` (not a class), it is not silently satisfiable by instance search, and the sole consumer takes it explicitly. Files are rooted (`AlgebraicJacobian.lean:244-246`), `sorry`-free, oleans fresh, and axiom-clean on `[propext, Classical.choice, Quot.sound]`.

**Correction to the prescription's wording:** the row says the residue *is* the filtered-colimit compatibility. It is not the whole residue — see G-3, where I found a genuine unclosed step between the residual and the stated conclusion. Also: `PicRepColimitCompat.lean:91` advertises `pic0_baseField_preserves_of_fixedBase` in its "Main declarations" list. **That declaration does not exist** (grep, case-insensitive, tree-wide: the docstring line is the only hit). Same defect at `PicRepColimitResidual.lean:56` (`instConsumesFiniteBaseColimit` "below" — absent) and `PicRepColimitMountain.lean:127` (`deltaSchemeIsLimit`) and `:24` (`instAffineTransition_delta`) — four docstring-cited names with no declarations.

## G-2 — `toJacobianDataOfAbelLifts` / `PicRepDatum`

**VERDICT: REAL, and stronger than stated — `PicRepDatum` has ZERO producers, so everything stated over it is currently uninhabited.**

Both declarations exist and the signatures are as claimed:

- `AlgebraicGeometry.PicRepDatum.toJacobianData`, `JacobianDataFromPicRepDatum.lean:83` — carries `J := d.J`, `rep := d.rep`, `locallyOfFiniteType := d.lft` verbatim, plus `hqc` as the one argument. The row's "carries J/rep/lft across verbatim" is exact.
- `AlgebraicGeometry.PicRepDatum.toJacobianDataOfAbelLifts`, `:132` — two hypotheses beyond `d`: `abel : DivScheme k A B g r₁ r₂ b₁ b₂ ⟶ d.J.left` and `hlift : ∀ y : d.J.left, ∃ q : Spec (d.J.left.residueField y) ⟶ DivScheme …, q ≫ abel = d.J.left.fromSpecResidueField y`. The row's ADDITION 1 is accurate.
- `structure PicRepDatum`, `PicRepDatum.lean:89`, fields `J`, `rep : (pic0TypeFunctor C').RepresentableBy J`, `lft`.

Producer census for `PicRepDatum` — **zero**. Method: case-insensitive `grep -rni "picrepdatum"` tree-wide (49 hits across 6 files, all enumerated); `grep ":[[:space:]]*PicRepDatum"` for return-type position (9 hits, **all argument position** `(d : PicRepDatum k k C)` / `(d d' : …)`); anonymous-constructor and `{ J := … }` searches; `structure PicRepDatum` cross-project (only the AJCR definition and one docstring); `"$HORIZON_BIN" search "PicRepDatum"` returns only the consumers. **No `PicRepDatum k k C` term exists anywhere, including under hypotheses.** The named producer target `picRepDatumKprime` (`PicRepDatum.lean:65`) and `datGDatum` (`JacobianDataFromPicRepDatum.lean:17-21`) are both docstring-only — neither exists.

The row's claim that the file "states plainly that it produces no PicRepDatum" is verified verbatim at `JacobianDataFromPicRepDatum.lean:47-52`.

So this prescription is honest, but a lane should know the sharper fact: this is a **carrier with 9 consumers and 0 producers**, the shape of the documented `DivFamily` hazard. `toJacobianDataOfAbelLifts` is not "two inputs away" from a `JacobianData` — the first of the two inputs is an entire uninhabited structure.

## G-3 — the "LANDED green" reduction

**VERDICT: OVER-STATED / incomplete — all four declarations exist and are sorry-free and axiom-clean, but "LANDED green" describes a reduction that does NOT compose with the residual as written. A middle step is missing, and it is free.**

All four verified present, sorry-free, axiom-clean on `[propext, Classical.choice, Quot.sound]`:

- `AlgebraicGeometry.pic0Theta`, `Pic0ThetaAssembly.lean:203` — `pic0Functor (C_L) ≅ (Over.map σ).op ⋙ pic0Functor C`
- `AlgebraicGeometry.pic0ThetaType`, `Pic0ThetaAssembly.lean:238` — the Type-valued whiskering
- `AlgebraicGeometry.pic0TypeFunctor_baseChange_iso`, `PicRepColimitCompat.lean:119` — literally `:= pic0ThetaType k L C`
- `AlgebraicGeometry.preservesColimit_pic0TypeFunctor_baseChange`, `PicRepColimitCompat.lean:150`

The "arbitrary `k → L`, no finiteness/Galois" claim is **correct**: the binders are `variable (k L : Type u) [Field k] [Field L] [Algebra k L]` (`Pic0ThetaAssembly.lean:56`). Nothing in the chain carries `Pic0PreservesFilteredBaseColimit` or any other unproduced class — so "LANDED green" is *unconditional* in the sense the comment means.

**But the reduction does not connect.** `preservesColimit_pic0TypeFunctor_baseChange` takes as an instance hypothesis

```
[PreservesColimit K ((Over.map σ).op ⋙ pic0TypeFunctor C)]     -- K : J ⥤ (Over (Spec L))ᵒᵖ
```

while the residual delivers `PreservesColimit S.op (pic0TypeFunctor C)` for `S : J ⥤ Over (Spec k)`. Instantiating `S := T ⋙ Over.map σ` gives `PreservesColimit (T.op ⋙ (Over.map σ).op) (pic0TypeFunctor C)` — the **pre**composition, not the **post**composition the reduction wants. Measured: probe at `/tmp/ajcr_probe_g3c.lean`, the direct application fails with

```
has type      PreservesColimit (T ⋙ Over.map (sig k L)).op (pic0TypeFunctor C)
but is expected to have type
              PreservesColimit T.op ((Over.map (sig k L)).op ⋙ pic0TypeFunctor C)
```

The missing middle is `PreservesColimit T.op (Over.map σ).op`, i.e. **`Over.map σ` preserves the cofiltered limit of `L`-tests**, after which `CategoryTheory.Limits.comp_preservesColimit` closes it (confirmed by `exact?`). That middle is **not in the tree**: `grep -rniE "preserves(limit|colimit).*over[_.]?map|over[_.]?map.*preserves(limit|colimit)"` over `AlgebraicJacobian/` returns only the hypothesis at `PicRepColimitCompat.lean:152`; workspace-wide search for `preservesLimit_overMap`/`preservesColimit_overMap` returns nothing. Mathlib has no `Over.map` + `Preserves` lemma either (`Over.map` is a left adjoint via `mapPullbackAdj`, which gives colimits, not the limits needed here).

**It is free, and I closed it** (`/tmp/ajcr_probe_g3i.lean`, EXIT=0):

```lean
theorem preservesLimit_overMap {J : Type u} [SmallCategory J] [IsConnected J]
    (T : J ⥤ Over (Spec (.of L))) [HasLimit T] : PreservesLimit T (Over.map (sig k L)) := by
  haveI : PreservesLimit T (Over.map (sig k L) ⋙ Over.forget (Spec (.of k))) :=
    (inferInstance : PreservesLimit T (Over.forget (Spec (.of L))))
  exact preservesLimit_of_reflects_of_preserves _ (Over.forget (Spec (.of k)))
```

It works because `Over.map σ ⋙ Over.forget (Spec k) = Over.forget (Spec L)` **by `rfl`** (verified), and `Over.forget` creates connected limits; `IsCofiltered.isConnected` supplies `IsConnected`. Four lines, no geometry. A prover lane should land this lemma plus its `.op` transport into `PicRepColimitCompat.lean` and re-state the reduction so the residual plugs in directly — otherwise the "LANDED reduction" cannot be used by the lane that eventually proves the mountain.

## G-4 — the δ-scheme bricks

**VERDICT: REAL / accurate.** All three exist in `Picard/PicRepColimitMountain.lean`, sorry-free, rooted, axiom-clean:

- `AlgebraicGeometry.DatG0.deltaSchemeDiagram`, `:128` — `(FinSubext k K)ᵒᵖ ⥤ Over (Spec (.of k))`, `obj L := overSpec k (unop L).1`
- `AlgebraicGeometry.DatG0.deltaIsColimit`, `:83` — `IsColimit (deltaCocone (k := k) (K := K))`, i.e. `K = colim k''` at ring level, under `[Algebra.IsAlgebraic k K]`
- `AlgebraicGeometry.DatG0.preservesColimit_deltaScheme_of_residual`, `:244` — `(h : Pic0PreservesFilteredBaseColimit C) : PreservesColimit (deltaSchemeDiagram (k := k) (K := K)).op (pic0TypeFunctor C)`

The "residual" it takes **is exactly `Pic0PreservesFilteredBaseColimit`**, verbatim, as an explicit non-instance hypothesis. The three side conditions are genuinely discharged in-file (`deltaSchemeMap_isAffineHom`, `deltaSchemeDiagram_compactSpace`, `deltaSchemeDiagram_quasiSeparatedSpace`, plus the `HasLimit` instance at `:195` via `hasLimit_of_created`). Note the deliverable is at the **fixed base** `k` — it does not need the G-3 bridge, which is why the gap in G-3 went unnoticed: this consumer instantiates the residual at a `k`-diagram directly, while the `L`-side reduction is the one that does not compose.

## G-5 — the M2/M1/M6 avatars

**VERDICT: prescription "XL, no avatar shortcut" for M2 is UNCHALLENGED (I found nothing that shortens it), but the claimed avatars all EXIST and M6 is OVER-PRICED.**

Every cited mathlib name verified present in `v4.31.0` (`.lake-packages/mathlib`, rev `fabf563a7c95`):

- `CommRingCat.preservesColimit_coyoneda_of_finitePresentation` — `Mathlib/Algebra/Category/Ring/FinitePresentation.lean:144` (plus an `alias` at `:165`). **Note:** three AJCR sites cite it unqualified as `preservesColimit_coyoneda_of_finitePresentation`; the `alias` exists, so both spellings resolve — but no AJCR file has ever *used* either.
- `RingHom.EssFiniteType.exists_eq_comp_ι_app_of_isColimit` — `:81`; `RingHom.EssFiniteType.exists_comp_map_eq_of_isColimit` — `:45`
- `Scheme.exists_π_app_comp_eq_of_locallyOfFinitePresentation` — `Mathlib/AlgebraicGeometry/AffineTransitionLimit.lean:1177`
- `Scheme.exists_hom_hom_comp_eq_comp_of_locallyOfFiniteType` — `:686`
- `Scheme.exists_isAffineOpen_preimage_eq` — `:1058` (tagged `@[stacks 01Z4 "(1)"]`)
- `Scheme.exists_isOpenCover_and_isAffine` — `:1078`

Two bonuses not cited anywhere in AJCR:

- **`CommRingCat.preservesFilteredColimits_coyoneda`** (`FinitePresentation.lean:169`) and **`CommRingCat.isFinitelyPresentable_under`** (`:178`) — the `PreservesFilteredColimits`-of-shape form and the `IsFinitelyPresentable` packaging, both strictly more usable than the single-diagram `preservesColimit_coyoneda_…` the comments name.
- **`Scheme.exists_isAffine_of_isLimit`** (`AffineTransitionLimit.lean:1036`): under `[IsCofiltered I]`, affine transition maps, compact and quasi-separated stages, and `[IsAffine c.pt]`, gives `∃ i, IsAffine (D.obj i)`.

That last one bears directly on **M6 ("qcqs → affine reduction", priced L)**. Its hypothesis list is *character-for-character* the residual's own three side conditions plus affineness of the limit — and in the δ application the limit is `Spec K_s`, affine by construction. So M6 at the δ system is one lemma application, not an L brick; `Scheme.exists_isOpenCover_and_isAffine` (`:1078`) covers the general-qcqs case with a finite affine refinement at a finite stage. A prover lane should reprice M6 to XS-at-δ before spending on it.

For **M2** and **M1**: searched mathlib for Picard-functor filtered-colimit preservation (`grep -rniE "(lemma|theorem|instance|def).*[Pp]ic.*(FilteredColimit|PreservesColimit)"` — **zero hits**), `Module.FinitePresentation` colimit/spreading lemmas (**zero**), line-bundle/invertible-module spreading over filtered colimits (**zero**), and `AffineTransitionLimit` consumers outside its own file (**zero — nothing in mathlib uses it**). `CategoryTheory/Presentable/Finite.lean` and `MorphismProperty/Ind.lean` provide generic `IsFinitelyPresentable` machinery (`exists_hom_of_isColimit`, `exists_eq_of_isColimit`) but nothing at the Picard/line-bundle layer. **M2 XL stands.** M1 (étale-cover spreading) has no direct avatar either, though `exists_isOpenCover_and_isAffine` + `exists_π_app_comp_eq_of_locallyOfFinitePresentation` are the right raw material.

## G-6 — `ofCharts` vs `ofChartsOfCompactSpace`

**VERDICT: the two declarations exist as described, but the claim "the finite route is not available for the class-indexed atlas" is OVER-PRICED as a warning — a lane does NOT need to decide before choosing the index type.**

Both exist in `Picard/JacobianDataCharts.lean`, sorry-free, rooted (`AlgebraicJacobian.lean:242`), axiom-clean:

- `AlgebraicGeometry.JacobianData.ofCharts`, `:182` — `[Finite ι]` + `(hlft : ∀ i, LocallyOfFiniteType (chartHom C f i))` + `(hcpt : ∀ i, CompactSpace (X i))`
- `AlgebraicGeometry.JacobianData.ofChartsOfCompactSpace`, `:209` — no `[Finite ι]`, same `hlft`, and `(hcpt : CompactSpace (Scheme.LocalRepresentability.glueData hf).glued)`

The hypothesis reading is exact. But the "must know which of the two BEFORE choosing the index type" framing implies a fork. There isn't one: **`ofChartsOfCompactSpace` subsumes `ofCharts`, and they are equal on the finite input.** Both probes pass (`/tmp/ajcr_probe_g6.lean`, EXIT=0):

```lean
noncomputable example … [Finite ι] … : JacobianData C :=
  JacobianData.ofChartsOfCompactSpace C f hf hlft (compactSpace_of_finite_atlas C f hf hcpt)

noncomputable example … [Finite ι] … :
    JacobianData.ofCharts C f hf hlft hcpt
      = JacobianData.ofChartsOfCompactSpace C f hf hlft
          (compactSpace_of_finite_atlas C f hf hcpt) := rfl
```

The bridge `AlgebraicGeometry.compactSpace_of_finite_atlas` already exists (`Picard/Pic0AtlasCompactFromClass.lean:346`) and is exactly `ofCharts`'s internal `quasiCompact_gluedHom` argument re-exposed. So: **target `ofChartsOfCompactSpace` unconditionally**; if the atlas turns out finite, `compactSpace_of_finite_atlas` recovers `hcpt` for free and the results are `rfl`-equal. Nothing is lost by not deciding.

Also relevant to any lane reading this row: `hcpt` for the class-indexed atlas is *already* reduced to the `dat-j.qcfield` hypothesis by `compactSpace_glued_of_pic0_class` (`Pic0AtlasCompactFromClass.lean:193`) and `jacobianDataOfCompactFromClass` (`:232`), so the row's ADDITION 2 framing of `hcpt` as a live choice point is stale relative to that file. That file's own docstring states `hcl` has no producer, so this is a shortened list, not a discharged one.

## G-7 — the frozen-signature hypothesis gap

**VERDICT: REAL / accurate on every clause. This is the one prescription I found fully correct.**

- The `inferInstance` example **exists**: `JacobianDataCharts.lean:237`, `example : GeometricallyReduced C.hom := inferInstance`, and it is genuinely **after** the Charts section (`section Charts` at `:105`, `end Charts` at `:225`). It elaborates — the file is sorry-free and its olean is fresh.
- The derivation is a genuine **global instance chain**, no axiom, no sorry, in `AlgebraicJacobian/Curve/GeometricallyReduced.lean` (0 `sorry`): `Smooth.of_smoothOfRelativeDimension_one` (`:141`, `instance (priority := 100)`, `[SmoothOfRelativeDimension 1 f] → Smooth f`) then `Smooth.geometricallyReduced` (`:130`, `instance (priority := 100)`, `[Smooth f] → GeometricallyReduced f`, proved via `Smooth.isReduced_of_field` and `MorphismProperty.of_isPullback`). The non-instance `SmoothOfRelativeDimension.geometricallyReduced` (`:148`) exists too, for general `n`; at `n = 1` resolution goes through the instance pair, exactly as the row says. `GeometricallyReduced` itself is mathlib's (`Mathlib/AlgebraicGeometry/Geometrically/Reduced.lean:44`).
- `Pic0SigmaSheaf.lean` does introduce `[GeometricallyReduced C.hom]` — at `:79`, after its base bundle at `:50-52`. Confirmed.
- `Challenge.lean` carries **exactly** `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]` (`:57-62`), and `grep -c GeometricallyReduced Challenge.lean` = **0**. So the frozen bundle is as described and the gap is genuinely absent.

---

### Summary for the caller

The row's headline claim "AUDITED, price correct" survives on **G-2, G-4, G-7** and on the existence half of **G-1**. Three findings a lane should act on:

1. **G-3 is the substantive one.** The "LANDED green reduction" does not compose with the residual — `preservesColimit_pic0TypeFunctor_baseChange`'s instance hypothesis is a post-composition where the residual yields a pre-composition. The missing bridge (`Over.map σ` preserves connected limits) is absent from the tree *and* from mathlib, but I closed it in 4 lines using the `rfl` identity `Over.map σ ⋙ forget k = forget L`. Cheap, and it should land before anyone attempts the mountain.
2. **M6 is over-priced** (G-5): `Scheme.exists_isAffine_of_isLimit` (`AffineTransitionLimit.lean:1036`) has precisely the residual's three side conditions as hypotheses, and the δ limit `Spec K_s` is affine. M2 XL stands — nothing in mathlib touches Picard-functor filtered colimits.
3. **G-6's "decide before choosing the index type" is not a real fork** — `ofChartsOfCompactSpace` subsumes `ofCharts` and the two are `rfl`-equal on finite input via the already-existing `compactSpace_of_finite_atlas`.

Hygiene note worth filing: **four declaration names cited in docstrings on this route do not exist** — `pic0_baseField_preserves_of_fixedBase` (`PicRepColimitCompat.lean:91`, in the "Main declarations" list), `instConsumesFiniteBaseColimit` (`PicRepColimitResidual.lean:56`, "below"), `deltaSchemeIsLimit` (`PicRepColimitMountain.lean:127`), `instAffineTransition_delta` (`:24`). Also `picRepDatumKprime` and `datGDatum`, cited as the producer targets, are docstring-only.

I wrote no files in the repository. Probes were scratch files under `/tmp/` only.
