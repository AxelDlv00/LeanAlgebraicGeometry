The full file verifies: kernel check exits 0, and the main theorem depends only on the three standard axioms (`propext`, `Classical.choice`, `Quot.sound`) — no `sorryAx`, no custom axioms. The "warnings" are just the benign `local instance` declarations (the standard relCurve base-change instances mirroring the Spread file).

Deliverable complete. Here is the raw report.

## Result

**File landed:** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneDatumGluedDivisor.lean` (257 lines, all ≤100 chars, standard three `set_option`s, two measured `maxHeartbeats 4000000` overrides mirroring the Spread file).

**Kernel check:** `lake env lean AlgebraicJacobian/Picard/Pic0RankOneDatumGluedDivisor.lean` → exit 0. Axioms: `propext, Classical.choice, Quot.sound` only. No sorry/admit/axioms.

**Main declaration:**
```lean
theorem AlgebraicGeometry.BasicOpenCocycleDatum.exists_glued_divFamZarAff_of_admissible_fibre
    (D : BasicOpenCocycleDatum C R pi) [IsNoetherianRing R]
    (hpi : pi ≫ P1.structureMap k = C.hom)
    (hwit : ∀ p : PrimeSpectrum R, D.HasWitnessH1Vanishing p.asIdeal.ResidueField)
    (hdeg : ∀ (K : Type u) [Field K] [Algebra k K] [Algebra R K] [IsScalarTower k R K],
      classDeg K (Scheme.CechPic.map (relCurveMap C R K) D.cechPicClass) = (genus C : ℤ)) :
    ∃ F : DivFamZarAff C R (genus C),
      relPicMk C (overSpec k R) F.picClass = relPicMk C (overSpec k R) D.cechPicClass
```
Private helpers: `GoodAway` (predicate), `picClass_mapAlgHom_awayMulOfDvd` (class transport across an away multiple), `exists_notMem_goodAway` (per-prime, steps 1–2), `relPicMk_eq_of_awaySpan` (step 5). Plus 5 `local instance`s for relCurve-over-field base change.

## Deviations from the plan (with reasons)

1. **Conclusion is `relPicMk`-equality, not on-the-nose `F.picClass = D.cechPicClass`.** This is not a proof gap — the on-the-nose CechPic equality is **genuinely false** in general. The glued family restricts to `D.cechPicClass` exactly on each `Localization.Away (bᵢ)`, so their ratio `L := F₀.picClass / D.cechPicClass` is a Čech class on `relCurve C R` trivialized on the base cover `{D(bᵢ)}`; such `L` can be the pullback of a **nontrivial base Picard bundle** (e.g. a class in `Cl(R)` for a Dedekind `R` that dies on each principal open). A dedicated exhaustive search confirmed the tree (and mathlib) lacks any `CommRing.Pic` Zariski-sheaf / CechPic-base-separatedness lemma, consistent with the strong form being false. `relPic = CechPic / picFromBase` quotients out exactly this base discrepancy and is the separated invariant the Abel map / datum-descent consumer actually reads. Step 5 is proved via the landed `PicEtAff.eq_of_away_eq` (Zariski separatedness of the étale plus construction) + `PicEtAff.unit_injective` + `mapAlg_unit`/`relPicAlgMap_mk` naturality. This is the plan's explicitly-sanctioned weaker conclusion, fully proved.
   - **Consumer usability preserved:** pushing `F₀` up along `mapAlgHom (Subalgebra.val)` and applying `descent_cechPicClass` + `picClass_mapAlg` + `relPicMap_mk` yields `relPicMk_B F.picClass = relPicMk_B D_B.cechPicClass` over the original base — the same relPic-level statement, which is the honest form the consumer can actually use.

2. **Specialized `n = g = genus C`** (plan option (a), explicitly allowed). The gluing uniqueness core `divFamZarAff_eq_of_picClass_eq_cechPicClass` is pinned to degree `genus C`, and its rank-one `H⁰` hypothesis holds **iff** the fibre degree equals the genus. At `n > g` the per-prime divisors genuinely fail to glue (positive-dimensional linear systems), so this is forced, not cosmetic. I dropped the `(n g : ℕ) hchi hgn` parameters and use `genus C`/`chi_moduleKSheaf C`/`le_rfl` internally; `hwit` and `hdeg` are spelled exactly as the `RankOneFamilyCertificates.ofActualDatum` inputs (`ResidueH1Witness`, `FibreClassDegree (genus C)`).

3. **Double-localization collapse** (step 2) done via `IsLocalization.Away.mul_of_associated` (single mathlib lemma) with the canonical `Localization.Away` R-algebra tower, then transported to the canonical carrier via `IsLocalization.algEquiv` + `AlgEquiv.restrictScalars k`. The plan's `cechPicMap_away_eq_of_mul` pattern is reproduced as the local `picClass_mapAlgHom_awayMulOfDvd`.

Steps 1–4 (per-prime producer → collapse → span → glue with uniqueness-core compatibility) went through exactly as the plan mapped.
