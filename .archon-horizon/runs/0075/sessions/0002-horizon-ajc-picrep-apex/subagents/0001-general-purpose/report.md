I have enough to answer both questions precisely.

## QUESTION A — Čech h¹ vanishing on ℙ¹

### A.1 / A.2 — Yes: there IS exactly one concrete producer, and it is the ℙ¹ Čech complex `k[x] × k[y] → k[x,x⁻¹]`

The producer is in a file the brief did not name:

**`/home/axel/.../AlgebraicJacobian/RiemannRoch/Ledger/P1Vanishing.lean:246`**
```lean
theorem AlgebraicGeometry.Adelic.LaurentChartData.subsingleton_h1Cok (D : LaurentChartData Y) :
    Subsingleton (D.chartSquare.H1Cok (Scheme.toModuleKSheaf Y))
```
Hypotheses: only the datum `D : LaurentChartData Y` (no properness, smoothness, irreducibility, finiteness). Fully dischargeable at ℙ¹ — `Adelic.p1LaurentChartData k` (`RiemannRoch/Adelic/P1ChartData.lean:1128`) is a global `noncomputable instance` for every field, axiom-clean. This is exactly the `coker(k[x] × k[y] → k[x,x⁻¹]) = 0` computation, done in the span form.

Supporting layer, all sorry-free, same file:
- `P1Vanishing.lean:128` `Adelic.sup_eq_top_of_laurent_pair_span_one` — pure algebra: `t·u = 1`, `N₀` `t`-stable, `N₁` `u`-stable, `1 ∈ both`, ladder spans ⟹ `N₀ ⊔ N₁ = ⊤`.
- `P1Vanishing.lean:184` `Adelic.LaurentChartData.span_ladder_overlap` — `Γ(V₀ ⊓ V₁)` is the `k`-span of `{tʲ} ∪ {uʲ}`, i.e. the span form of `Γ(V₀ ⊓ V₁) = k[x,x⁻¹]`. Derived from existing `LaurentChartData` fields; no new structure field.
- `P1Vanishing.lean:227` `Adelic.LaurentChartData.chartSquare : Y.left.AffineCoverMVSquare` — the datum's own 2-affine cover.
- `P1Vanishing.lean:311` `Adelic.subsingleton_hModule_one_p1Over (k) : Subsingleton (Scheme.HModule k (Scheme.toModuleKSheaf (p1Over k)) 1)` — cover-free `H¹(ℙ¹, 𝒪) = 0`, via `hModuleOneEquivH1Cok_curve`.
- `P1Vanishing.lean:322` `genus_p1Over_eq_zero`, `:330` `uniformBaseDivisor_p1Over`, `:345` `uniformVanishing_p1Over`.

A second, independent, section-level route also exists: **`RiemannRoch/Ledger/P1Charts.lean:315`** `LaurentChartPair` with `:350` `LaurentChartPair.exists_res_add_res` (every overlap section = `res a + res b`, i.e. exactly the surjectivity half of the MV difference map) and the canonical term `:369` `P1.laurentChartPair k`, built on `chartSectionsEquiv₀/₁ : Γ ≃+* Polynomial k` (`:234`, `:239`) and `overlapSectionsEquiv : Γ(overlap) ≃+* LaurentPolynomial k` (`:245`). **Caveat:** `Ledger/P1Charts.lean` lives on `P1 k := Proj (homogeneousSubmodule (Fin 2) k)` (`Ledger/P1.lean:141`), a *different* ℙ¹ carrier from `p1Over k = ℙ(ULift (Fin 2); Spec k)`. I found **no** bridge isomorphism between the two models in the tree.

Also relevant: `RiemannRoch/Adelic/P1BaseCase.lean:113` `Adelic.nonneg_sup_nonpos_eq_top` — the abstract Laurent split `k[x,x⁻¹] = k[x] + k[x⁻¹]`.

### A.2b — What is NOT there: the `moduleSectionDiff` dialect
`subsingleton_h1Cok` is in the **`Sheaf (ModuleCat k)` dialect** (`sectionDiff`/`H1Cok`, `RiemannRoch/Adelic/Cokernel.lean:233,244`). `FiberH1Vanishing` needs the **`X.Modules` dialect** (`moduleSectionDiff`, `Picard/RigidPushforward.lean:140`). The bridges exist and are `rfl`-cheap:
- `QuasicoherentDegreeOneVanishing.lean:747` `AffineCoverMVSquare.sectionDiff_toModuleKSheafOfModules_apply : S.sectionDiff (toModuleKSheafOfModules C M) p = S.moduleSectionDiff M p := rfl`
- `QuasicoherentDegreeOneVanishing.lean:759` `subsingleton_h1Cok_iff : Subsingleton (S.H1Cok F) ↔ Function.Surjective ⇑(S.sectionDiff F)`
- `RigidPushforward.lean:171` `subsingleton_moduleH1Cok_iff` (the `X.Modules` twin)
- `CohomologyKit.lean:449` `unitH1CokₗEquiv`, `:472` `hModuleOneEquivH1Cokₗ_unit` — the 𝒪-case dialect bridge, all identity-function linear equivs.

The unclosed step is `Scheme.toModuleKSheaf Y` vs `toModuleKSheafOfModules Y (unitModule)`: both presheaves are `ModuleCat.of k Γ(…)` with the same restriction maps (`Presheaf.lean:182` vs `QuasicoherentDegreeOneVanishing.lean:151`), so this should be `rfl` or an identity `LinearEquiv`, but **no declaration in the tree states it**. That is the one missing glue lemma. I could not run the LSP probe (imports stale at HEAD; see I-0812 on the olean race).

### A.3 — No affine/trivial-cover surjectivity lemma, and NO `AffineCoverMVSquare` at `U₁ = U₂ = ⊤`
There is **no** declaration constructing an `AffineCoverMVSquare` with `U₁ := ⊤` (grep over all 9 `AffineCoverMVSquare` constructions: `RigidPushforward.lean:237` `preimage`, `FinitenessP1.lean:440` `pullbackSquare`, `:703` `p1CoverSquare`, `P1Vanishing.lean:228` `chartSquare`, `FinitePresentationFunctor.lean:525`, `CurveBaseChange.lean:342`, `RigidPushforwardTransfer.lean:1317`, `RigidPushforward.lean:587`). Nothing states "difference map is surjective when the cover is trivial" or "when the scheme is affine". `isAffineOpen_top` is mathlib's (`Mathlib/AlgebraicGeometry/AffineScheme.lean:266`), used only incidentally in this project. Note the structure (`Cohomology/MayerVietorisCover.lean:51`) has no `⊥`-avoidance field, so `U₁ = U₂ = ⊤` would be a legal construction for `IsAffine X` — it just does not exist.

What does exist at the affine level is stronger and is the real workhorse:
- `QuasicoherentDegreeOneVanishing.lean:719` `subsingleton_hModule'_one_of_isAffineOpen_of_isQuasicoherent (M : C.left.Modules) [M.IsQuasicoherent] (hU : IsAffineOpen U) : Subsingleton (HModule' k (toModuleKSheafOfModules C M) 1 U)`
- `AffineDegreeOneVanishing.lean:714` `subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen` (the 𝒪 case)
- `QuasicoherentDegreeOneVanishing.lean:779` `AffineCoverMVSquare.surjective_moduleSectionDiff_of_surjective (M) [M.IsQuasicoherent] (h : Surjective ⇑(V.moduleSectionDiff M)) (W) : Surjective ⇑(W.moduleSectionDiff M)` — **cover independence, unconditional.** So one cover suffices, forever.
- `QuasicoherentDegreeOneVanishing.lean:835` `Hom.FiberH1Vanishing.surjective_moduleSectionDiff`.

### A.4 — ℙ¹ standard-chart facts (all in `RiemannRoch/Adelic/FinitenessP1.lean` unless noted)
| Name | file:line | statement |
|---|---|---|
| `Adelic.p1Chart (i : ULift (Fin 2))` | `FinitenessP1.lean:644` | `toProjInt ⁻¹ᵁ Proj.basicOpen 𝒜 (X i)` |
| `Adelic.isAffineOpen_p1Chart` | `:653` | `IsAffineOpen (p1Chart k i)` |
| `Adelic.isAffineOpen_p1Chart_inf` | `:659` | `IsAffineOpen (p1Chart k ⟨0⟩ ⊓ p1Chart k ⟨1⟩)` |
| `Adelic.p1Chart_sup_eq_top` | `:675` | `p1Chart k ⟨0⟩ ⊔ p1Chart k ⟨1⟩ = ⊤` |
| `Adelic.p1CoverSquare` | `:702` | the `AffineCoverMVSquare` of ℙ¹ |
| `Adelic.p1ChartSectionsAlgEquivX` | `Picard/RigidPushforwardP1ChartSections.lean:364` | `Γ(ℙ¹_k, p1Chart k ⟨0⟩) ≃ₐ[k] Polynomial k`, `x ↦ T` |
| `Adelic.p1ChartSectionsAlgEquivY` | `:370` | `Γ(ℙ¹_k, p1Chart k ⟨1⟩) ≃ₐ[k] Polynomial k`, `y ↦ T` |
| `Adelic.p1Chart_inf_ne_bot` | `:445` | charts genuinely overlap |

**On the intersection `p1Chart k ⟨0⟩ ⊓ p1Chart k ⟨1⟩`:** there is **no `≃ₐ[k] LaurentPolynomial k`** for this carrier. What exists is weaker but sufficient for vanishing:
- `p1Chart_inf_eq_basicOpen_coordSection` (`Adelic/P1ChartData.lean:944`, **`private`**) — the overlap is `basicOpen` of the coordinate section, reached via `p1LaurentChartData.inf_eq_basicOpen_x` publicly;
- `p1_res_x_mul_res_y` (`P1ChartData.lean:1109`, **`private`**) — `res x · res y = 1`, publicly via `p1LaurentChartData.res_x_mul_res_y`;
- `LaurentChartData.span_ladder_overlap` (`P1Vanishing.lean:184`) — the span-level `k[x,x⁻¹]` statement, which is what the vanishing actually consumes.
The genuine `≃+* LaurentPolynomial k` (`overlapSectionsEquiv`, `Ledger/P1Charts.lean:245`) is on the **other** ℙ¹ model.

### A — bottom line
For a line bundle `L` there is **nothing**: every concrete result above is for `𝒪` (`toModuleKSheaf` / the unit module). Producing `FiberH1Vanishing` for ℙ¹ with `L = 𝒪` needs only (a) the dialect glue `toModuleKSheaf Y ≅ toModuleKSheafOfModules Y (unitModule)`, and (b) transport of the fibre `ℙ¹_t` to `p1Over κ(t)`. `RigidPushforwardP1Witness.lean:50` and `:264` state flatly that `FiberH1Vanishing` "has no producer anywhere in the tree" — that remains true, but the docstring predates `Ledger/P1Vanishing.lean`, and the ingredient it needs now exists.

One infrastructure note: **`AlgebraicJacobian/RiemannRoch/Ledger/P1Vanishing.lean` is NOT imported by the root `AlgebraicJacobian.lean`** (nothing in the tree imports it except `scripts/ajcrr-p1vanishing-axioms.lean`). Neither is `Ledger/P1Charts.lean`. Consuming either from the Picard cone requires rooting them.

## QUESTION B — `AJC.picrep.tensor`

### B.1 — Remaining code `sorry`s: exactly two, both in `Picard/QuotFunctorDef.lean`

**1. `AlgebraicJacobian/Picard/QuotFunctorDef.lean:458-460`**
```lean
theorem Modules.pullbackTensorMap_isIso {Z Y : Scheme.{u}} (f : Y ⟶ Z) (A B : Z.Modules) :
    IsIso (Modules.pullbackTensorMap f A B) := by
  sorry
```
This is the roadmap row's first clause verbatim (blueprint `lem:pullback_tensor_map_isiso`). Stated for **arbitrary** `A B` — no quasi-coherence.

**2. `AlgebraicJacobian/Picard/QuotFunctorDef.lean:690-715`**
```lean
theorem gammaFiber_finrank_baseChange_field (π : X ⟶ S) (L : X.Modules) [L.IsQuasicoherent]
    {T T' : Over S} (ψ : T' ⟶ T) (F : (pullback π T.hom).Modules) (hfp : F.IsFinitePresentation)
    (hps : Modules.HasProperSupport (pullback.snd π T.hom) F) (t' : T'.left) (m : ℕ) : … := by
  refine gammaFiber_finrank_baseChange_field_of_quasicoherent … ?_
  sorry
```
The residual obligation is a *single* named fact: **quasi-coherence of `moduleTensorPow F_t L_t m`** (the sheafified tensor of quasi-coherent modules, Stacks 01CB). This is the roadmap row's second clause ("finish the quasi-coherent tensor-section input used by Hilbert-function base change"). Everything else in that theorem is discharged by `gammaFiber_finrank_baseChange_field_of_quasicoherent`.

The four `sorry` hits in `Picard/LineBundlePullback.lean` (lines 34, 61, 66, 276) are **all docstring prose** — the file's iter-174 skeleton note. That file is now sorry-free in code (`OnProduct` at `:136` is a real subtype). `TensorObjSubstrate.lean`, all 8 files under `TensorObjSubstrate/`, `TensorSectionFormula.lean` and `TensorObjInverse.lean` are **sorry-free**.

### B.2 — Gate/hypothesis classes with no producer
**None.** There is no `class Has…Tensor`, no `Prop`-valued gate, and no hypothesis-shaped `IsIso (pullbackTensorMap …)` binder anywhere. The obligation is a plain sorried theorem, not a gate. (The `Prop`-valued gates I did find in this neighbourhood — `P1RankIdentity`, `P1CechFibrewiseBridge`, `P1PushforwardLocalFreenessBridge` — belong to the B3/rigid-pushforward lane, not to tensor comparison.)

### B.3 — What concretely remains (5 items)

1. **`Modules.pullbackTensorMap_isIso`** — `Picard/QuotFunctorDef.lean:458`. The single headline sorry. Three routes are written out in its own docstring; route (i) is furthest along.

2. **Quasi-coherence of `sheafTensorObj`/`moduleTensorPow` of quasi-coherent modules** (Stacks 01CB) — needed at `Picard/QuotFunctorDef.lean:715`. I confirmed by grep that **no declaration in the tree produces `IsQuasicoherent` for any tensor object**. This is the second, independent clause of the row and does *not* reduce to item 1.

3. **Promote `tensorSectionHom A B V` to a `LinearEquiv` for quasi-coherent `A B` and affine `V`** — `Picard/TensorSectionFormula.lean:101` (`tensorSectionHom`), the three-step recipe spelled out at `TensorSectionFormula.lean:50-70`. This is the shared prerequisite for both items 1 (route i) and 2, and the substrate around it (`tensorPresheaf_obj:108`, `tensorSectionHom_naturality_apply:115`, `isIso_sheafification_tensorSectionUnit:137`, `tensorObjIsoSheafTensorObj:130`) is already landed.

4. **A quasi-coherent variant of item 1**, `[A.IsQuasicoherent] [B.IsQuasicoherent]`, to sidestep the general ringed-space stalk machinery. Flagged as sufficient at `TensorSectionFormula.lean:71-79`: the sole consumer `pullback_moduleTensorPow_iso` (`QuotFunctorDef.lean:513`) already carries both instances. This is the cheapest honest close of the row.

5. **Globalization plumbing**: `isIso_of_isIso_restrict` over an affine cover plus the restriction coherence `pullbackTensorMap_restrict` (`Picard/TensorObjSubstrate.lean:2905`), and the currently-`private` 4-fold cancel helper `isIso_of_isIso_comp4_mid` (`TensorObjSubstrate.lean:3195`) — which the analogous chart-chase at `TensorObjSubstrate/PullbackTensorIso.lean:79` (`chart_isIso`) already consumes, so the pattern is proven. The affine-chart version needs `chart_isIso`'s unit-trivialisation hypotheses (`eM`, `eN`) replaced by the affine section formula of item 3.

Best available leverage: `pullbackTensorMap_isIso_of_isOpenImmersion` (`TensorObjSubstrate/PullbackTensorMapIso.lean:26`, sorry-free, unconditional), `pullbackTensorMap_isIso_of_base_unit` (`TensorObjSubstrate.lean:3207`), `pullbackTensorMap_unit_isIso` (`:1654`), `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (`:1133`, isolates the sheafified `δ` as the *only* conditional factor), and the completed locally-trivial case `pullbackTensorIsoOfLocallyTrivial` (`TensorObjSubstrate/PullbackTensorIso.lean:153`). The gap between "locally trivial" (done) and "quasi-coherent" (open) is precisely item 3.

Sizing note: `Picard/DivDegree.lean:52` records a correction worth keeping — only the *untwisted* core of the 02KE/02KH engine is landed; the degree lane deliberately routes around `hilbertFunction_quotBaseMap` to stay sorry-free. So item 2's consumer set is narrower than the campaign plan suggests.
