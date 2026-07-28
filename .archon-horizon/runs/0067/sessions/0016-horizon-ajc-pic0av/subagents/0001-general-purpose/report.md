Survey complete. Findings below.

## Q1. `gluedSheaf` / `twistSheaf` binders — `[IsAffine X]` is ABSENT

**`GluedSheaf.lean`** (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/GluedSheaf.lean`, 369 lines). Exact `variable` lines:

- L56: `variable {X : Scheme.{u}} {J : Type u} (U : J → X.Opens)` (section `Incl`)
- L103: `variable (k : Type u) [CommRing k] {X : Scheme.{u}} [X.Over (Spec (.of k))]`
- L119: `variable {J : Type u} (U : J → X.Opens) (g : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ)`
- L281-282 (section `Triv`): `variable {U} {g}` / `variable (hc : Scheme.IsGluingCocycle U g)`

Key declarations: `Scheme.IsGluingCocycle` (L76, `Prop` structure, fields `unit_self`, `mul_res`), `gluedSubmodule` (L124), `isSheaf_gluedPresheaf` (L192), `gluedSheaf` (L265), `gluedTriv` (L287, `↥(gluedSubmodule k U g W) ≃ₗ[k] Γ(X, W)` for `hW : W ≤ U j`), `gluedTriv_res` (L341), `gluedTriv_eq_unit_mul` (L351). The only hypotheses beyond the variables are `hc : IsGluingCocycle U g` and `hW : W ≤ U j`. `X` is an arbitrary `Scheme.{u}` over `Spec k`.

**`TwistedSheaf.lean`** (500 lines): L117 `variable (k : Type u) [CommRing k] {X : Scheme.{u}} [X.Over (Spec (.of k))]`, L137 `variable (V₀ V₁ : X.Opens) (g : Γ(X, V₀ ⊓ V₁)ˣ)`. `twistSheaf` (L301), `twistTriv₀/₁` (L319/L366), `twistSheaf.instQcohOn₀/₁` — all with no affineness. `grep -n IsAffine` on both files returns exactly three hits, all in TwistedSheaf.lean and all `IsAffineOpen Vᵢ` on *charts*, not `IsAffine X`: L429 `subsingleton_hModule'_twistSheaf_one₀ (h₀ : IsAffineOpen V₀)`, L434 (`₁`), L443-444 `twistTwoCoverH1 (hcov : V₀ ⊔ V₁ = ⊤) (h₀ : IsAffineOpen V₀) (h₁ : IsAffineOpen V₁)`. `[IsAffine X]` appears nowhere in either file. So your suspicion is confirmed on this axis.

**Coboundary transport exists, also affine-free**: `GluedSheafCongr.lean:46` `Scheme.IsGluingCoboundary`, L168 `gluedSheafCongr (hc : IsGluingCoboundary U g g') : gluedSheaf k U g ≅ gluedSheaf k U g'` — docstring L31 notes "Neither multiplier family needs the cocycle law". Also `GluedSheafSubord.lean:380` `gluedSheafSubord`, and a genuine identification `RiemannRoch/GluedDivisorSheaf.lean:468` `gluedDivisorSheafIso : P.gluedSheaf K ≅ X.divisorSheaf K (presentationDivisor K P)` on an integral proper curve — no affineness.

**No invertibility theorem.** There is no theorem in either file (or anywhere in AJCR) saying `gluedSheaf`/`twistSheaf` is invertible / locally free of rank one. `grep -rn "IsLocallyTrivial\|IsInvertibleSheaf\|invertibleSheaf"` over all of AJCR: zero hits. `grep -rln "SheafOfModules\|\.Modules\b"` over AJCR's `Cohomology/` and `Picard/`: **one** file (`Picard/DivSchemeFlatteningBridge.lean`).

## Q2. Surjectivity/classification at non-affine X: ABSENT

The only surjectivity is `Scheme.CechPic.toPic_surjective` (`Picard/CechPicSurjective.lean:267`), under `variable (X) [IsAffine X]` (L259) — so the I-0689 verdict is correct *for that statement*. `cechPicEquivPic` (L283) likewise `[IsAffine X]`. Searched: `≅ gluedSheaf`, `≅ twistSheaf`, `exists_gluedSheaf`, `exists_twistSheaf`, `Nonempty (…gluedSheaf`, `exists_cocycle`, `exists_isGluingCocycle`, `of_trivializ`, plus the horizon index for "every invertible sheaf trivial on a cover arises from a unit cocycle" and "glued sheaf … invertible locally free rank one". Nothing at non-affine X.

The map exists in only one direction and only cocycle-to-cocycle-class: `GluedSheafClass.lean` (`gluedSubordCocycle`, subordination independence, `cechPicClass`) and `GluedSheafExtraction.lean:301` `exists_cechPicClass_eq : ∀ c : (relCurve C B).CechPic, ∃ D, D.cechPicClass = c` — that is surjectivity onto `CechPic`, from cocycle data, not from sheaves. There *is* a genuinely affineness-free trivialization extractor, `Scheme.exists_trimmed_trivializing_of_cechPicMap_ι_eq_one` (used at `Tangent/TwoChartRepresentable.lean:77`; its own restatement `exists_isTrimmedTrivializing` at L~70 is explicitly documented "No affineness hypothesis"), but it starts from a `CechPic` class, not from a sheaf.

## Q3. AJC has no GluedSheaf/TwistedSheaf analogue — but it does have `Scheme.Modules` gluing

`gluedSheaf`, `twistSheaf`, `IsGluingCocycle`, `twistSubmodule`, `gluedSubmodule`: **absent from AJC, zero files each** (searched all `.lean` under `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge`). `unitsRestrict`: zero. `Scheme.CechPic`: only 2 files, both prose (`Pic0AbelianVariety.lean`, `DualNumberChartTriviality.lean`).

What AJC *does* have, in the `Scheme.Modules` dialect:
- `Picard/GlueDescent.lean`: `Scheme.Modules.glue` (L111) — equalizer-of-pushforwards descent over a `Scheme.GlueData` with transition isos `g : (pullback (D.f i j)).obj (M i) ≅ …` (L985), `glueLift`, `glueProj`, restriction-iso tower, and `pullback_isLocallyFreeOfRank` (L296).
- `Picard/GrassmannianZariskiSheaf.lean:784` `gluedModule : (covGD W hW).glued.Modules` with L855 `gluedModule_locFree : SheafOfModules.IsLocallyFreeOfRank (gluedModule hcpt) d` — a landed glued-module-is-locally-free theorem in the right category, but note it is at `Scheme.{0}` in places (`GlueDescent.lean:941` `variable (D : Scheme.GlueData.{0})`).
- `SheafOfModules.IsLocallyFreeOfRank` (`Picard/QuotScheme.lean:505`), and `LineBundle.isLocallyTrivial_of_pointwise_free_one` (a rank-one entry point to `IsLocallyTrivial`).

`trivializ`/`transition` as substrings: ~17 and ~15 files respectively, all `Scheme.Modules`-side (`InvertibleGrBridge`, `LineBundleCoherence`, `GlueDescent`, `DualNumberChartTriviality`, …), none the AJCR cocycle-submodule pattern.

## Q4. `LineBundle.OnProduct` is a **predicate subtype**, not cover+trivialization data

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundlePullback.lean`:

```
def IsLocallyTrivial {X : Scheme.{u}} (M : X.Modules) : Prop :=          -- L122
  ∀ x : X, ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧
    Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)

def OnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : Type (u+1) :=  -- L136
  { M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }
```

There is no `LineBundle` type as such — `LineBundle` is a namespace; the carrier is `X.Modules = SheafOfModules X.ringCatSheaf` (mathlib `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:37`). So this is the harder of the two branches you named, with a further twist: the predicate is **existentially quantified per point** (`∀ x, ∃ U, …`), so it is not cover data you can supply — you must *prove* it, and the witness charts must be affine.

Consequently the decisive answer to your framing is: **producing an AJC line bundle from a cocycle requires proving invertibility, AND first crossing a category boundary.** `gluedSheaf` lands in `Sheaf (Opens.grothendieckTopology X) (ModuleCat k)` — a sheaf of *k*-modules — whereas `OnProduct` needs a `SheafOfModules X.ringCatSheaf`, a sheaf of *𝒪-modules*. AJC's bridge `toModuleKSheafOfModules` (`Cohomology/StructureSheafModuleK/QuasicoherentDegreeOneVanishing.lean:151`) goes the wrong way (𝒪-modules → k-modules, sections and restrictions definitionally equal). Nothing in either project inverts it. AJCR never builds an 𝒪-module from a cocycle at all; its whole glued layer is k-linear.

## Q5. Port price: 6 modules, 1760 lines — much cheaper than I-0689 implies

Transitive closure of `Cohomology/GluedSheaf.lean` + `Cohomology/TwistedSheaf.lean`: **24 AlgebraicJacobian modules** plus 7 external (`Mathlib`, `Mathlib.AlgebraicGeometry.Geometrically.Integral`, `Mathlib.AlgebraicGeometry.Morphisms.Smooth`, `Mathlib.RingTheory.Localization.FractionRing`, `Mathlib.RingTheory.RingHom.StandardSmooth`, `Mathlib.RingTheory.Smooth.Flat`, `Mathlib.RingTheory.Unramified.Field`).

A by-module-name diff (as I-0689 apparently did) says 23 of 24 absent, 6649 lines. That is wrong: **AJC already carries 15 of them verbatim** under `AlgebraicJacobian/RiemannRoch/Ledger/`, byte-identical modulo `import` lines (diff of non-import content = 0): `AffineCech`, `AffineVanishing`, `AffineVanishingQcoh`, `MayerVietoris`, `ModuleKSheaf`, `QcohSections`, `TwoCover`, `Curve.Basic`, `DedekindSections`, `MapToP1`, `P1Charts`, `P1Points`, `RationalToP1`, `Sections`, `StalksDVR` — all sorry-free (checked the 7 that matter: 0 `sorry` each). Three more differ only slightly (`OverOpen` 24 difflines, `Curve.GeometricallyReduced` 23, `Curve.P1` 26).

Genuinely absent from AJC, by content:

| lines | module |
|---|---|
| 500 | `Cohomology.TwistedSheaf` |
| 369 | `Cohomology.GluedSheaf` |
| 360 | `Cohomology.SectionsBaseChange` |
| 195 | `Picard.UniversalSections` |
| 175 | `Cohomology.RelativeTwoCover` |
| 161 | `Picard.AffineTwoCover` |
| **1760** | **total** |

So the port is ~1760 lines onto an existing sorry-free substrate that already provides `Scheme.resHom` (`Ledger/AffineCech.lean:55`), `secRes` (`Ledger/QcohSections.lean:81`), `moduleKSheaf`, `overModule`, `QcohOn`, `Sheaf.HModule`, `twoCoverSquare` — not 6649 lines from scratch.

## Bottom line for the lane

I-0689's verdict is right about `cechPicEquivPic` and right that no non-affine cocycle-to-sheaf classification exists anywhere in the workspace. But it is too strong in two places worth acting on: (a) AJCR's glued/twisted construction direction is entirely affineness-free and the port costs ~1760 lines, not ~6649; (b) AJC already has the 𝒪-module-side machinery the AJCR layer lacks (`Modules.glue`, `IsLocallyFreeOfRank`, `gluedModule_locFree`, `isLocallyTrivial_of_pointwise_free_one`).

The real wall is not affineness and not the port — it is two missing pieces neither project has: (1) a cocycle → `X.Modules` construction (AJCR's is k-linear only; the dialect bridge runs the wrong direction), and (2) the *converse* direction, "an invertible sheaf trivial on the two charts arises from a cocycle", which is what `relPicDualKernel → S.H1Cok` actually needs. Note (2) may be lighter than it looks here: for `relPicDualKernel` the chart triviality input is already landed as `DualNumber.free_of_cyclic_mod_eps` (clause (i), `Picard/DualNumberChartTriviality.lean`), so what is wanted is not general classification but "from `IsLocallyTrivial` plus two explicit chart trivializations, extract the overlap transition unit" — and `Modules.glue`/`glueRestrictionHom` in `Picard/GlueDescent.lean` is the AJC-side vocabulary for it. That reframing is worth pricing before adopting the port.
