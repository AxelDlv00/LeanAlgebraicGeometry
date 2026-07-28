Reconnaissance complete. Findings below.

---

## Verdict up front

**The sibling Rebuild project has ZERO hits on all three obligations.** It does not work with sheaves of modules on schemes at all: `Scheme.Modules` appears **0 times**, `PresheafOfModules` **0 times**, `Modules.pullback` **0 times**, and the 8 `SheafOfModules` occurrences are all in one file about finite-presentation bookkeeping. Nothing to port. Details and the mathlib picture follow.

---

## (A) Flat pullback exactness — NO HITS IN SIBLING

Measured at the root of `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild`, whole-tree greps (all `.lean`):

| pattern | count |
|---|---|
| `PresheafOfModules` | 0 |
| `Scheme.Modules` | 0 |
| `Modules.pullback` | 0 |
| `Presheaf.pullback` | 0 |
| `pullbackObj` / `inverseImage` | 0 / 0 |
| `PreservesFiniteLimits` / `PreservesKernel` | 0 / 0 |
| `SheafOfModules.forget` | 0 |
| `PreservesMonomorphisms` | 1 — `Cohomology/OverOpen.lean:58`, and it is about `(ModuleCat.free R).PreservesMonomorphisms`, i.e. plain modules, not sheaves. **IRRELEVANT** |
| `SheafOfModules` | 8, all in `Picard/DivSchemeFlatteningBridge.lean:31-83` about `Presentation.IsFinite` / `QuasicoherentData.IsFinitePresentation`. **IRRELEVANT** |
| `stalkPullback` | 30ish, all in `Albanese/RationalMapFunctionField.lean` + `Albanese/Milne33Pullback.lean` — this is `Scheme.RationalMap.stalkPullback`, the germ pullback of a *rational map into the function field*. Nothing to do with sheaf-of-modules pullback. **IRRELEVANT** |
| "flat base change" (prose) | 5 files, all about *ring/section-level* flat base change (`Curve/Sections.lean:24`, `Descent/AmitsurEqualizer.lean:10`, `Algebra/DiagonalRegular.lean:23`, …). **IDEA ONLY at best; nothing sheaf-theoretic.** |

Index queries run at the sibling: `search "flat pullback of sheaves of modules preserves kernels exact"` (workspace-wide) and `search "pullback of sheaf of modules along scheme morphism" --lib Algebraic-Jacobian-Challenge-Rebuild`. The lib-restricted query returned only `Scheme.PointedCover.pullback`, `Scheme.Hom.pullbackUnitsH1/Cocycle` (units cocycles, `Picard/UnitsCocycle.lean`), and `Scheme.preimage_le_pullback` — all **IRRELEVANT**.

### One real hit, but it is an axiom

- `SubProjects/RelatedPapersFormalisation/MR0555258-Compactifying-Picard/MR0555258CompactifyingPicard/Basic.lean:1345` — `External.flat_pullback_exact` — `(f : X ⟶ S) (p : X ⟶ X₀) (sc₀ : ShortComplex X₀.Modules) (hsc : sc₀.ShortExact) (I : X.Modules) (hflat : IsSFlat f I) (e : I ≅ (Scheme.Modules.pullback p).obj sc₀.X₃) : (sc₀.map (Scheme.Modules.pullback p)).ShortExact`.
  **IRRELEVANT as a source** — it is declared with the `axiom` keyword, not proved. Its own docstring says: *"Mathlib has this at the module level (`Module.Flat.lTensor_shortComplex_exact`) but NOT for `Scheme.Modules.pullback` of a `ShortComplex` of sheaves of modules."* This independently corroborates the wall your file's header already records. Adjacent axioms in the same block (`External.pullback_isFreeMod:1373`, `External.pullback_isLFP:1387`, `External.pullbackTensorComparison:1425`) are the same story, and one of them names the precise mathlib gap: `SheafOfModules.pullbackObjFreeIso` exists but **requires `Opens.map p.base` to be `Functor.Final`, which mathlib does not supply for a general scheme morphism.**

---

## (B) Cosimplicial naturality of a σ-product-decomposition iso — NO HITS IN SIBLING

Whole-tree grep of the sibling for `CechNerve`, `cosimplicial`, `Cosimplicial`, `CosimplicialObject`, `SimplexCategory`, `coverInterOpen`, `pushPull`, `sigma_iso`, `alternatingCoface`: **all zero.** The only `coface` hits (`Picard/ComparisonCoherence.lean`, `Picard/AmitsurCochain.lean:99-110`) are the three *Amitsur* algebra cofaces `B ⊗_A B →ₐ B ⊗_A B ⊗_A B` — a fixed 3-term degree-2 cocycle condition, no `SimplexCategory` and no index-tuple product. **IRRELEVANT.**

Index query `search "Cech nerve cosimplicial coface index omission naturality"` returned hits **only** in your own project and in `SubProjects/Cech-Cohomology`, which is a **behind-HEAD fork of your own Cech tree**, not an independent source. I diffed it: it has `pushPull_sigma_iso` at `CechSectionIdentificationBase.lean:1261` and `pushPull_sigma_iso_π` at `:1280` — the *same* declarations your project has at `:1210` and `:1229`, and it **lacks** `pushPull_sigma_iso_π_incl`, which yours has. Nothing to gain.

The relevant declarations are therefore all already yours, and they are the right ingredients:

- `/home/axel/…/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean:1210` — `pushPull_sigma_iso 𝒰 F p : pushPullObj F ((coverCechNerveOver 𝒰).obj (op (SimplexCategory.mk p))) ≅ ∏ᶜ fun σ : Fin (p+1) → 𝒰.I₀ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))` — sorry-free.
- `…:1229` — `pushPull_sigma_iso_π` — the per-σ projection lemma: `(pushPull_sigma_iso 𝒰 F p).hom ≫ Pi.π _ σ = pushPullMap F (coprodOverIncl _ σ ≫ (overSigmaDescIso _).inv ≫ (cechBackbone_left_sigma 𝒰 p).inv)`. **This is exactly the "per-sigma projection lemma for such a product decomposition" you asked for, and you already own it.**
- `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean:79` — `pushPull_sigma_iso_π_incl` — same, restated as `= pushPullMap F (backboneIncl 𝒰 p τ)`. The clean form for a naturality square.
- `…/CechSectionIdentificationLeg.lean:109` — `nerveδ_backboneProj (𝒰) (p) (k : Fin (p+2)) (l : Fin (p+1)) : (coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op) ≫ backboneProj 𝒰 p l = backboneProj 𝒰 (p+1) ((SimplexCategory.δ k).toOrderHom l)` — the coface/projection commutation at the *geometric backbone* level, proved by `WidePullback.lift_π`.
- `…/CechSectionIdentificationLeg.lean:117` — `cechNerve_drop_δ 𝒰 F k : (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)).δ k = pushPullMap F ((coverCechNerveOver 𝒰).map ((SimplexCategory.δ k).op))` — proved by `rfl`. This converts the cosimplicial coface into a `pushPullMap`, where `pushPull_sigma_iso_π_incl` applies.

**Judgement: PORTABLE — from your own tree, not the sibling.** The two `sorry`s at `CechHigherDirectImageUnconditional.lean:2228` and `:2299` are both the `naturality` field of a `NatIso.ofComponents` whose components are built from `pushPull_sigma_iso` + `PreservesProduct.iso` + `Pi.mapIso`. The three lemmas above (`cechNerve_drop_δ` to turn `δ` into `pushPullMap`, `nerveδ_backboneProj`/`backboneIncl` for the index-omission bookkeeping, `pushPull_sigma_iso_π_incl` to reduce both sides to per-σ legs) are the closure kit, and they are all sorry-free and in-tree. No external dependency.

---

## (C) Beck–Chevalley for an open immersion on modules — NO HITS IN SIBLING

Sibling grep: `BeckChevalley` 0, `beckChevalley` 0. Index query `search "Beck-Chevalley open immersion pushforward" --lib …-Rebuild` returned only unrelated `IsOpenImmersion` facts (`Picard/RelPicPi.lean:66`, `Picard/DivCarvePairChart.lean:168`, `Picard/GrassmannianGlue.lean:54`, `AbelianVariety/Translation.lean:150`). **All IRRELEVANT.**

Note this obligation is **already discharged in your own file**: `CechHigherDirectImageUnconditional.lean:1662` — `openImmersion_beckChevalley … : (Scheme.Modules.pullback g').obj (pushPullObj F (Over.mk V₀.ι)) ≅ pushPullObj ((Scheme.Modules.pullback g').obj F) (Over.mk p')` — the docstring and body both say sorry-free, via `openImmersion_pushPull_unit_isIso` (`:1653`) off the essential-image node `openImmersion_pushPull_essImage`. Nothing needed from anywhere.

---

## mathlib v4.31 for (A)

Checked `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib` (toolchain `leanprover/lean4:v4.31.0`, HEAD `fabf563a7c9`).

**Stalk formula for topological presheaf pullback — YES, it exists.** `Mathlib/Topology/Sheaves/Stalks.lean`:
- `:330` `stalkPullbackIso (f : X ⟶ Y) (F : Y.Presheaf C) (x : X) : F.stalk (f x) ≅ ((pullback C f).obj F).stalk x`
- `:233` `stalkPullbackHom`, `:308` `stalkPullbackInv`, plus the computation rules `:241` `germ_stalkPullbackHom`, `:323` `germ_stalkPullbackInv`, `:287` `germToPullbackStalk_stalkPullbackHom`, `:249` `germToPullbackStalk`, and an extensionality lemma `:262` `pullback_obj_obj_ext` for maps out of `((pullback C f).obj F).obj U`.
- **Judgement: IDEA ONLY / partial.** This is the inverse-image of a `TopCat.Presheaf C` (`Presheaf.pullback` = left Kan extension along `(Opens.map f).op`). It gives you the pointwise model *at the abelian-sheaf level*, and stalks of a left Kan extension being preserved is genuinely the lever you'd want. But there is no wiring from it to `SheafOfModules.pullback`/`Scheme.Modules.pullback`, which is defined abstractly as `(pushforward φ).leftAdjoint` (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:44`, `Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:53`, `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:180`). Bridging it is the missing brick, not a lookup.

**Module-sheaf pullback preserving monos / finite limits under flatness — NO.** `grep -rn "Flat.*Modules\.pullback|Modules\.pullback.*Flat" Mathlib/` returns **nothing**. `Mathlib/AlgebraicGeometry/Morphisms/Flat.lean` contains **no** occurrence of `Modules`, `SheafOfModules`, or `tilde`. In `Mathlib/Algebra/Category/ModuleCat/{Sheaf,Presheaf}/` the only `PreservesFiniteLimits` instances are for functors that have nothing to do with pullback:
- `Sheaf/Limits.lean:98` `evaluationPreservesFiniteLimits`, `:101` `forgetPreservesFiniteLimits` (`PreservesFiniteLimits (SheafOfModules.forget R)`), `:107/:111` the `LimitsOfSize` versions, `:115/:118` `PreservesFiniteLimits (SheafOfModules.toSheaf R)` — **the last two answer your sub-question: `toSheaf` preserves finite LIMITS, proved via `preservesFiniteLimits_of_reflects_of_preserves`.**
- `Presheaf/Sheafification.lean:181/:190` `PreservesFiniteLimits (sheafification α)`.
- `Presheaf/Limits.lean:153/:156` evaluation and `toPresheaf`.
- **`forget`/`toSheaf` preserving finite COLIMITS: NOT present.** `Sheaf/Colimits.lean` has only two declarations, both `HasColimits*` transfer instances (`:32`, `:40`); it contains no `toSheaf` and no `forget`-colimit statement at all.

**`pullbackObj` / `pullbackObjIso` / `inverseImage` for presheaves of modules:**
- `pullbackObjIso` — **does not exist** anywhere in mathlib.
- `Presheaf/Pullback.lean:56` `pullbackObjIsDefined` (an `ObjectProperty`, partial-adjoint bookkeeping), `:82` `pullbackObjIsDefined_free_yoneda`, `:86` `pullbackObjIsDefined_eq_top`. Not a formula for the object.
- `Sheaf/PullbackFree.lean:89` `pullbackObjUnitToUnit`, `:104` `instance [F.Final] : IsIso (pullbackObjUnitToUnit φ)`, `:121` `pullbackObjFreeIso (I : Type u)`, `:128/:135` its computation/naturality lemmas. **IDEA ONLY** — and note the `[F.Final]` gate, which is exactly the instance the Compactifying-Picard axiom docstring flags as absent for a general scheme morphism.
- `inverseImage` — the five hits (`Sites/Equivalence.lean:245`, `Sites/Localization.lean:69,:88`, `Sheaf/Localization.lean:39,:48`) are all `MorphismProperty.inverseImage`, unrelated. **IRRELEVANT.**
- `Mathlib/AlgebraicGeometry/Modules/Tilde.lean` has **no** `pullback` occurrence; its only `stalk` declaration is `:180` `Module R ((tilde M).presheaf.stalk x)`.

**One mathlib lever worth knowing about, which I did not expect to find:** `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:421` — `restrictFunctorIsoPullback (f) [IsOpenImmersion f] : restrictFunctor f ≅ pullback f`, built as `(restrictAdjunction f).leftAdjointUniq (pullbackPushforwardAdjunction f)`. Since `restrictFunctor f = pushforward f.opensFunctor` is *definitionally pointwise* (`restrict_map` at `:380`, `Γ((M.restrict f), U) = Γ(M, f ''ᵁ U)` by `rfl`), this is a genuine pointwise model of `Scheme.Modules.pullback` — **for open immersions only**. It presumably underwrites your already-closed `openImmersion_beckChevalley`, and it is the reason (C) was tractable while (A) is not: no analogue exists for a general flat `g`.

---

## Summary of every query I ran

Sibling-root greps (all zero unless noted): `PresheafOfModules`, `SheafOfModules`(8, irrelevant), `Scheme.Modules`, `Modules.pullback`, `Presheaf.pullback`, `pullbackObj`, `inverseImage`, `PreservesFiniteLimits`, `PreservesKernel`, `PreservesMonomorphisms`(1, irrelevant), `SheafOfModules.forget`, `BeckChevalley`, `beckChevalley`, `CechNerve`, `cosimplicial`, `Cosimplicial`, `CosimplicialObject`, `SimplexCategory`, `coverInterOpen`, `pushPull`, `sigma_iso`, `alternatingCoface`, `coface`(irrelevant), `HigherDirectImage`, `cechComplex`, `FlatBaseChange`, `IsQuasicoherent`, `stalkPullback`(irrelevant).

Horizon index: `"flat pullback of sheaves of modules preserves kernels exact"`, `"Cech nerve cosimplicial coface index omission naturality"`, `"Beck-Chevalley base change open immersion pushforward pullback modules"` (all workspace-wide), plus three `--lib Algebraic-Jacobian-Challenge-Rebuild` restricted repeats, plus `graph -p Algebraic-Jacobian-Challenge-Rebuild frontier` (its frontier is entirely Picard/Jacobian/divisor-scheme work — no cohomology-of-modules items).

Net: **nothing to port from the sibling on any of (A)/(B)/(C).** (A) is walled in mathlib too, with the wall independently re-measured in a third project. (C) is already closed in your file. (B) is closable **from lemmas already in your own tree** — `cechNerve_drop_δ`, `nerveδ_backboneProj`, `pushPull_sigma_iso_π_incl` — and that is the only one of the three where I'd say there is live, unblocked work.
