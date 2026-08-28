The dictionary is load-bearing infrastructure, not a decoration. All three parts are answered.

## (2) DECISIVE: AJCR's `CechPic` IS connected to a sheaf-side Picard group — but to *modules over a ring*, not to sheaves of modules

AJCR proves a full **isomorphism**, sorry-free and kernel-verified axiom-clean:

```lean
/-- **The Čech–Picard dictionary** of an affine scheme -/
noncomputable def cechPicEquivPic (X : Scheme.{u}) [IsAffine X] :
    X.CechPic ≃* CommRing.Pic Γ(X, ⊤)
```
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/CechPicSurjective.lean:283`

Built from, all in the same tree:
- `Scheme.CechPic.toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤)` — `Picard/CechPicToPic.lean:82`
- `Scheme.CechPic.toPic_injective` — `Picard/CechPicToPic.lean:116`
- `Scheme.CechPic.toPic_surjective` — `Picard/CechPicSurjective.lean:267`
- `Scheme.CechPic.toPic_bijective` — `Picard/CechPicSurjective.lean:275`
- naturality: `CechPic.toPic_map`, `toPic_mapAlgebra` — `Picard/CechPicToPicNaturality.lean:455,471`

Kernel probe (`#print axioms`, run under `lake env lean` in AJCR): `cechPicEquivPic`, `toPic_injective`, `toPic_surjective` each depend on `[propext, Classical.choice, Quot.sound]` only. No `sorryAx`. All the files above contain the token `sorry` exactly **zero** times.

The target is mathlib's `CommRing.Pic R = Shrink (Skeleton (SemimoduleCat R))ˣ` (`Mathlib/RingTheory/PicardGroup.lean:400`) — the Picard group of **invertible modules over a commutative ring**. AJCR's docstrings state explicitly that this discharges mathlib's own `RingTheory.PicardGroup` TODO "exhibit isomorphism with `H¹(Spec R, 𝓞ˣ)`".

The important qualification, and it matters for AJC: **this is not a `SheafOfModules` statement, and it carries `[IsAffine X]`.** AJCR has essentially no sheaf-of-modules vocabulary at all. Measured across all 712 AJCR `.lean` files:

| token | AJCR files |
|---|---|
| `SheafOfModules` | 1 (`Picard/DivSchemeFlatteningBridge.lean`, an unrelated finite-presentation instance) |
| `Scheme.Modules` / `X.Modules` | 0 |
| `LineBundle` | 0 |
| `IsInvertible` (sheaf predicate) | 0 |
| `IsLocallyTrivial` | 0 |
| `SheafOfModules.unit` | 0 |
| `PicGroup` | 0 |

So: **`CechPic` is not a self-contained definitional Picard group with no sheaf-side comparison — that framing is wrong.** It has a *complete, sorry-free comparison to the module-theoretic Picard group of global sections over affines.* What it lacks is any comparison to a *sheaf-of-modules* carrier of the kind AJC uses.

There is a second, weaker, genuinely sheaf-valued connection worth knowing about: AJCR builds a cocycle→sheaf assignment via `gluedSheaf` (`Cohomology/GluedSheaf.lean:265`, a `Sheaf … (ModuleCat k)`, not a `SheafOfModules`) with
- `BasicOpenCocycleDatum.cechPicClass : (relCurve C B).CechPic` — `Cohomology/GluedSheafClass.lean:269`
- `cechPicClass_eq_of_anchor`, `exists_cechPicClass_eq` (every `CechPic` class comes from a datum) — `Cohomology/GluedSheafExtraction.lean:242,301`

The pieces are proved free of rank one (`Cohomology/GluedSheafModule.lean:146`), but I found **no** theorem stating this glued sheaf is invertible as an object of a monoidal category of sheaves of modules, and no `PicGroup`-style quotient on that side. So this is a class-assignment, not an isomorphism of Picard groups.

## (1) There is no `OnProduct`/sheaf-of-modules ↔ Čech-cocycle bridge anywhere in the workspace

The two carriers are cleanly disjoint across all eight projects. Counting files containing Čech-cocycle Picard vocabulary (`CechPic|unitsH1|unitsCocycle|IsGluingCocycle|cechPicClass`) vs sheaf-side vocabulary (`SheafOfModules|Scheme.Modules|IsInvertible|IsLocallyTrivial|OnProduct|PicGroup`):

| project | Čech files | sheaf files |
|---|---|---|
| AJC | 5 (all **docstring prose only**) | 98 |
| AJCR | 154 | 1 |
| SubProjects/Albanese | 0 | 0 |
| SubProjects/Cech-Cohomology | 0 | 23 |
| SubProjects/GR-Quot-Closure | 0 | 5 |
| **SubProjects/Line-Bundle-Comparison-Iso** | **0** | 12 |
| SubProjects/Picard-IdentityComponent | 0 | 0 |
| SubProjects/RelatedPapersFormalisation | 0 | 1 |

Your "AJC has zero occurrences" is right in substance: AJC's 5 hits are all prose in `RiemannRoch/Ledger/*`, `Picard/OnePointRelPicCollapse.lean:50`, `RiemannRoch/Adelic/ClassInvariance.lean` explicitly noting the sibling has names AJC does not.

`SubProjects/Line-Bundle-Comparison-Iso` specifically: 15 Lean files, and its `Cech`/`cocycle` grep hits are all *mate-calculus* cocycles (adjunction-uniqueness `H1` cocycles in `TensorObjSubstrate/DualInverse/PresheafDualPullback.lean:83,656`), nothing to do with Čech cohomology of units. Its `TO_USER.md` records it as a completed archive already merged back into AJC (2026-07-02). It has sorries: `RelPicFunctor.lean` 32, `TensorObjSubstrate.lean` 14, `DualInverse.lean` 8, `LineBundlePullback.lean` 4, `TensorObjInverse.lean` 4, `PresheafDualPullback.lean` 2 — but AJC's merged-back copies of `RelPicFunctor.lean`, `TensorObjSubstrate.lean` and `LineBundlePullback.lean` are sorry-free as terms (AJC's `LineBundlePullback.lean` hits are 4 docstring mentions at lines 34, 61, 66, 276 describing history).

`SubProjects/Cech-Cohomology` (26 files) is pure Čech-to-derived-functor cohomology with zero Picard content.

So the answer to (1) is: **no such bridge exists anywhere in the workspace.** What AJC has is `Scheme.Modules.IsInvertible` (`Picard/TensorObjSubstrate.lean:119`) and `Scheme.Modules.PicGroup` (`:620`, a `Quotient (picSetoid X)` over `{M : X.Modules // IsInvertible M}`) plus `LineBundle.IsLocallyTrivial` / `LineBundle.OnProduct` (`Picard/LineBundlePullback.lean:121,136`) — and nothing connecting either to a cocycle quotient.

## (3) Port price: 14 files, ~1,940 lines — not 57 files / 16,459

Import closure of `TwoChartRepresentable` + `TwoChartNormalize` is 57 modules / 16,459 lines. **That number is a 4× overcount.** I measured the true declaration-reference closure with a Lean meta-program walking `getUsedConstants` over types and proof values from all 24 declarations of the two seed files, pruning at the mathlib boundary (script `/tmp/portprice/C3.lean`, run against AJCR's oleans; all 24 seeds resolved, 0 missing). Result: **273 AJCR constants across 14 modules.**

| AJCR file | file lines | decls defined | referenced | absent from AJC | LOC of referenced slices |
|---|---|---|---|---|---|
| `Picard/UnitsCocycle.lean` | 372 | 38 | 25 | 23 | 240 |
| `Picard/CechH1.lean` | 502 | 53 | 34 | 20 | 298 |
| `Tangent/TwoChartCechPic.lean` | 461 | 26 | 20 | 20 | 276 |
| `Picard/Pic.lean` | 280 | 22 | 17 | 16 | 175 |
| `Tangent/TwoChartNormalize.lean` | 268 | 13 | 13 | 13 | 194 |
| `Tangent/TwoChartRepresentable.lean` | 328 | 11 | 11 | 11 | 267 |
| `Picard/OpenImmersionUnits.lean` | 124 | 9 | 6 | 6 | 57 |
| `Picard/RefinementInjectivity.lean` | 221 | 8 | 6 | 6 | 131 |
| `Picard/EffectivityTrivialization.lean` | 271 | 6 | 5 | 5 | 212 |
| `Picard/UnitsPresheaf.lean` | 144 | 12 | 4 | 4 | 28 |
| `Picard/DivisorClass.lean` | 467 | 28 | 1 | 1 | 14 |
| `Picard/SectionsAlgebra.lean` | 86 | 5 | 1 | 1 | 13 |
| `Cohomology/AffineCech.lean` | 283 | 10 | 2 | **0** | 14 |
| `Tangent/TruncExpCech.lean` | 393 | 19 | 2 | **0** | 21 |
| **TOTAL** | **4,200** | **260** | **147** | **126** | **1,940** |

**Total to port: 12 files, 126 declarations, ~1,940 lines of referenced slices** (or 3,794 lines if you copy whole files rather than slices).

Two files need nothing — AJC already has them under different names:
- `Cohomology/AffineCech.lean` → AJC `RiemannRoch/Ledger/AffineCech.lean` (`Scheme.resHom`, `resHom_resHom`, … match name-for-name)
- `Tangent/TruncExpCech.lean` → AJC has the same content under namespace **`DualNumber`** in `Picard/Pic0DualNumberCocycle.lean` §6 and `Picard/DualNumberUnits.lean` (`DualNumber.cechCoboundaryUnits` ↔ `TruncExpCech.cechCoboundaryUnits`, `truncExpUnit`, `cechUnitsReduction`, `truncExpCechKernelAddEquiv`, … all present; a rename, not a port)

The whole 2,486-line `Curve/` layer (10 modules: `P1`, `P1Charts`, `P1Points`, `RationalToP1`, `StalksDVR`, `Sections`, `GeometricallyReduced`, `MapToP1`, `DedekindSections`, `Basic`) is in the import closure but is **referenced by zero** of the seed declarations. Ditto `Algebra/` (5 modules, 1,539 lines), `Descent/` (5, 1,322), and 20 of the 30 `Picard/` modules. That is where the 4× overcount lives.

Grouped by what the port actually is:

**Layer A — the scheme-side unit-cocycle API AJC entirely lacks (~75 declarations, ~929 LOC).** AJC has **0 files** mentioning `unitsRestrict`, `unitsEvInf`, `OneCocycle`, `unitsCocycle`, `unitsRes`, `PointedCover` (as a definition), `IsGluingCocycle`. This is the foundation, and it is the bulk:
- `Picard/CechH1.lean` (20 absent): `CategoryTheory.PresheafOfGroups.OneCocycle`/`OneCochain`/`H1` — `evInf`, `res_evInf`, `isCohomologous_iff_evInf`, `ofPairs`, `class_eq_iff`, the `CommGroup H1` instance
- `Picard/UnitsCocycle.lean` (23 absent): `Scheme.PointedCover` (+ its `SemilatticeInf`/`OrderTop`), `Scheme.unitsRestrict`, `unitsEvInf`, `unitsCocycle`, `unitsH1`, `unitsRes`, `Hom.pullbackUnitsH1`
- `Picard/UnitsPresheaf.lean` (4): `Scheme.unitsPresheaf`, `Hom.unitsAppLE`
- `Picard/Pic.lean` (16): `Scheme.CechPic` itself, `cechPicSetoid`, `mk`, `mk_eq_mk_iff`, `mk_unitsRes`, `mk_mul_mk_inf`, the `CommGroup` instance, `CechPic.map`
- `Picard/RefinementInjectivity.lean` (6): `CechPic.mk_eq_one_iff`, `exists_unitsRestrict_eq`, `unitsRes_injective` — the mathematical content behind `twoChartClass_injective`
- `Picard/OpenImmersionUnits.lean` (6), `Picard/DivisorClass.lean` (1: `unitsCocycle_isCohomologous`), `Picard/SectionsAlgebra.lean` (1)

**Layer B — the two-chart comparison proper (44 declarations, ~737 LOC), the part you actually asked for:**
- `Tangent/TwoChartCechPic.lean` (20): `twoChartPairUnit`, `twoChartCover`, `twoChartCocycle`, `twoChartClassHom`, `twoChartClassHom_eq_one_iff`, `twoChartCob`, `twoChartCoboundary_of_pairRelation`, `mixedValue`, `twoChartCandidate`, `twoChartClass`, `twoChartClass_mk`
- `Tangent/TwoChartNormalize.lean` (13): `cocycleValueOn` + its 4 laws, `normCochain`, `normCochain_conj`, `twoChartCocycle_isCohomologous`, `twoChartClassHom_mk_range`, `twoChartClass_mk_range`
- `Tangent/TwoChartRepresentable.lean` (11): `IsTrimmedTrivializing`, `exists_isTrimmedTrivializing`, `ratio_agree`, `exists_overlapUnit`, `selCochain`, `pairCochain` (+3 laws), `twoChartClassHom_surjOn_of_chartTrivial`
- `Picard/EffectivityTrivialization.lean` (5): `exists_trimmed_trivializing_of_cechPicMap_ι_eq_one` — the one leaf input step 1 consumes

Note `twoChartClass_injective` itself does **not** appear in the absent set: it is not referenced by either seed file (it is a sibling result in `TwoChartCechPic.lean`). Its own dependency is `twoChartClassHom_eq_one_iff`, which is in the set. `twoChartClass` and `twoChartClass_mk` are in.

**Sorry / hypothesis-binder status.** All 14 files contain the token `sorry` **zero** times. Kernel-confirmed axiom-clean (`[propext, Classical.choice, Quot.sound]`, no `sorryAx`) for `twoChartClass`, `twoChartClass_injective`, `twoChartClassHom_mk_range`, `twoChartClass_mk_range`, `twoChartClassHom_surjOn_of_chartTrivial`.

There is no hidden hypothesis binder standing in for open content **inside the port set** — but the stack is honestly incomplete at its top, and AJCR says so in its own docstrings. `twoChartClassHom_surjOn_of_chartTrivial` takes `(hL : ∀ s : Bool, CechPic.map (V s).ι L = 1)` as a hypothesis: "the class is already trivial on each chart." AJCR's docstring at `TwoChartRepresentable.lean:19-24` names the remaining clause explicitly — **(iii-c2-aff), "an ε-kernel class is trivial on each thickened chart"** — as the one place the geometry lives, still open, with `Picard/EffectivityMoving.lean` flagged as the intended tool. So porting all 1,940 lines gives AJC the cohomological half and leaves the geometric half where AJCR left it.

## Two things that change the shape of the AJC task

**AJC already has the algebra layer of the ε-kernel computation, natively.** `Picard/Pic0DualNumberCocycle.lean` (1,153 lines, sorry-free) §6 is described in its own docstring as "the **two-chart Čech unit-cocycle engine**, the pure-algebra heart of the Kleiman §5 Thm 5.11 cocycle leg", with `DualNumber.cechCoboundaryUnits ρ₁ ρ₂` the coboundary subgroup `im(ρ₁ˣ)·im(ρ₂ˣ) ≤ Bˣ` and `DualNumber.truncExpCechKernelAddEquiv : B ⧸ (ρ₁(A₁) + ρ₂(A₂)) ≃+ ker(Ȟ¹ˣ(B[ε]) → Ȟ¹ˣ(B))`. That is *exactly* the quotient `twoChartClass`'s source is built on. What AJC lacks is not the algebra — it is Layer A, the scheme-side cocycle-to-`CechPic` geometry that connects that quotient to a Picard group.

**AJC has already made the same relative→absolute collapse AJCR relies on.** `Picard/OnePointRelPicCollapse.lean` (272 lines, sorry-free) proves `PicSharp.relPicQuotAddEquivAbs : Pic(C ×_S T)/π_T^*Pic(T) ≃+ Pic(C ×_S T)` at a one-point test object, on the `OnProduct` setoid carrier, and its docstring at lines 20-23 says the coset calculus "disappears from the ε-kernel computation entirely, and the dual-number kernel of the *relative* functor may be computed on the *absolute* Picard group, where the two-chart Čech model of `Picard/Pic0DualNumberCocycle.lean` §6 lives." AJCR's counterpart is `relPicMulEquivCechPic` + `relPicMulEquivCechPic_relPicMap` (`Tangent/RelPicPointTest.lean:99,145`).

So the port target reduces to one specific thing neither project has: **a bridge from AJC's `Scheme.Modules.PicGroup` / `LineBundle.OnProduct` iso-classes to a cocycle quotient.** Porting Layer A gives AJC a *second, parallel* Picard carrier (`CechPic`) rather than connecting to the one it has. Since `cechPicEquivPic` targets `CommRing.Pic Γ(X,⊤)` (modules over a ring, affine-only) and AJC's carrier is sheaves of modules on a possibly-non-affine product, the AJCR dictionary does not close that gap either — you would still need `Scheme.Modules.PicGroup X ≃ CommRing.Pic Γ(X,⊤)` for affine `X`, plus a gluing argument, or a direct cocycle comparison on the sheaf carrier. I found no formalization of either anywhere in the workspace.

Caveats on my numbers: the 273/14 closure figure is kernel-exact for what the two seed files' *elaborated terms* reference. The "absent from AJC" judgement (126) is by short-name matching against my syntactic index of AJC's 5,684 declarations — it can overcount absence if AJC has a lemma under a genuinely different name (as happened with `TruncExpCech`↔`DualNumber`, which I caught and corrected), so 126 is an upper bound. The `~1,940 LOC` is measured as the sum of source line-slices from each referenced declaration to the next, which includes docstrings.
