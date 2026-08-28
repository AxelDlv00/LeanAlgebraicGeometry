## (1) Two-chart Čech Picard naturality along a scheme morphism — **ABSENT**

AJC has **no `CechPic` type at all**. Grep for `CechPic` across the whole tree returns exactly two hits, both prose in docstrings that explicitly say the name does not exist in AJC:
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/ClassInvariance.lean:50` — "`Sheaf.chi`, `CechPic`), none of whose names exist in this project"
- `.../Picard/OnePointRelPicCollapse.lean:50` — "This project's carrier is a *setoid*"

`twoChart*`, `pullbackUnitsCocycle`, `pairUnit`, `unitsAppLE` : **zero hits anywhere in AJC**. AJC's Picard-of-a-cover model is purely ring-theoretic (`DualNumber.cechCoboundaryUnits : Subgroup Bˣ` at `.../Picard/Pic0DualNumberCocycle.lean:746`), with no scheme morphism, no pointed cover, and no pullback functoriality. There is no naturality statement in any spelling. Your `Tangent/TwoChartNaturality.lean:181` `map_twoChartClassHom` has no AJC counterpart — that side of the frontier is yours alone.

## (2) Carrier translation at the dual numbers — **SORRIED/ABSENT (split)**

The *algebra core* is LANDED; the *scheme-level composite* and *both* compatibility laws are ABSENT.

LANDED, sorry-free:
- `DualNumber.baseChangeAlgEquiv : A ⊗[k] DualNumber k ≃ₐ[A] DualNumber A` — `.../Picard/Pic0DualNumberCocycle.lean:1133` (with `baseChangeAlgEquiv_tmul:1137`, `baseChangeAlgEquiv_symm_apply:1143`, bijectivity at `:1094`). This is byte-for-byte the same content as your `Tangent/DualNumberBaseChange.lean:119`.

ABSENT — no declaration mentions `DualNumber` and `Γ(-, V)`/`⁻¹ᵁ` together anywhere in AJC. Every hit for `Γ(V × Spec k[ε], 𝒪) ≅ Γ(V,𝒪)[ε]` is docstring prose:
- `.../Picard/Pic0AbelianVariety.lean:754` lists it as clause (ii) of the "geometric middle"
- `.../Picard/Pic0AbelianVariety.lean:768` claims "(ii) is `DualNumber.baseChangeAlgEquiv`"
- `.../Picard/DualNumberChartTriviality.lean:44` says "already available as `DualNumber.baseChangeAlgEquiv`"

That claim is the docstring-overreach pattern: the ring-level tensor identity is landed, but nothing composes it with a sections-of-a-pullback identification. AJC's nearest sections-base-change bricks are **not** at a preimage open of a *curve* chart in your shape:
- `globalSectionsBaseChangeAlgEquiv` — `.../Picard/SectionRingUniversal.lean:206`. Only at `⊤`, i.e. `Γ(Spec A,⊤) ⊗ Γ(X,⊤) ≃ₐ Γ(X ×_k Spec A, ⊤)`. No open-subset version.
- `exists_chartTensorEquiv` — `.../Picard/RigidPushforwardChartBaseChange.lean:151`. General affine open `W`, gives `Γ(Y',⊤) ⊗_{Γ(Y,⊤)} Γ(M,W) ≃+ Γ(g'^*M, g'⁻¹ᵁ W)` — but only as `≃+` (additive, semilinear), for a **module** `M`, not the structure sheaf as a ring/algebra. Its supporting pushout `isPushout_appLE_chartBaseChange` is at `:100`.

Neither compatibility law exists: no lemma anywhere in AJC relates `TrivSqZeroExt.fst`/`fstHom`/`unitsFst` to a scheme restriction (grep for `fstHom`/`unitsFst` outside the two algebra files returns only `DualNumberChartTriviality.lean` self-references), and there is no restriction-along-`≤` naturality for any dual-number identification. Your `Over.sectionsBaseChange_naturality` (`Cohomology/SectionsBaseChange.lean:337`) has no AJC counterpart at all.

## (3) Geometric clause: sheaf-to-module step and per-chart conclusion — **ABSENT (only the module statement exists)**

LANDED, sorry-free, module-level only:
- `DualNumber.free_of_cyclic_mod_eps` — `.../Picard/DualNumberChartTriviality.lean:120`
```
theorem free_of_cyclic_mod_eps (M : Type v) [AddCommGroup M] [Module (DualNumber A) M]
    [Module.Invertible (DualNumber A) M] (m : M)
    (h : ∀ x : M, ∃ r : DualNumber A,
      x - r • m ∈ Ideal.span {(ε : DualNumber A)} • (⊤ : Submodule (DualNumber A) M)) :
    Module.Free (DualNumber A) M
```
plus its inputs `augIdeal_mul_self_eq_bot:73`, `ker_fstHom_eq_span_eps:88`, `isNilpotent_ker_fstHom:103`, `isNilpotent_span_eps:107`, and the general `Module.Invertible.free_of_nilpotent_of_exists_sub_smul_mem` at `.../Picard/NilpotentThickeningFree.lean:153`.

The file is 128 lines and contains **nothing else** — no scheme, no `Scheme.Opens`, no sheaf. `DualNumberChartTriviality.lean` is imported by nobody except a docstring reference at `Pic0AbelianVariety.lean:760`; grep for the import name shows zero real `import` lines outside the root `AlgebraicJacobian.lean:140`. So it is a leaf with no consumer.

The sheaf-to-module step is ABSENT. AJC does have the generic bridge `Scheme.LineBundle.isInvertible_of_restrict_iso` (`.../Picard/InvertibleGrBridge.lean:65`, gives `Module.Invertible Γ(X,V) Γ(M,V)` from `M|_V ≅ 𝒪_V`) and `IsLocallyTrivial.isInvertibleGr` (`:106`), but neither is instantiated at a base-changed chart and neither produces the `∀ x, ∃ r, x - r•m ∈ (ε)•⊤` hypothesis that `free_of_cyclic_mod_eps` demands. No declaration in AJC concludes `= 1` for a Picard class of a thickened chart, or `Module.Free` for one.

Note also: `Module.Free` appears in AJC in exactly two contexts — `NilpotentThickeningFree`/`DualNumberChartTriviality`, and the unrelated `FlatteningStratification.lean`. Nothing in between.

## Pic0AbelianVariety.lean state

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`, 1514 lines.

**Term-level `sorry` count: exactly 3.** Measured with a comment-aware scanner (nested `/- -/` + `--`), because the file has 18 further `sorry` occurrences inside docstrings. The three are at lines **819, 1101, 1288**:

| line | declaration | statement |
|---|---|---|
| 819 | `semilinearComparison_cotangentSpaceDual_h1Cok` (decl at :804) | **SORRIED** |
| 1101 | `geometricallyReduced` (decl at :1095) | `GeometricallyReduced (Pic0Scheme C).hom` |
| 1288 | `universallyClosed` (decl at :1282) | `UniversallyClosed (Pic0Scheme C).hom` |

Your three named targets:

- **`tangentSpaceCotangentDual`** (`:664`) — **LANDED**, sorry-free proof body (`:680-688`), assembled from `grpObj` + `overDualNumberSectionEquivCotangentSpaceDual`. Conclusion: dual-number points of `Pic0Scheme C` at the identity section ≃ `Module.Dual κ(e) (CotangentSpace ...)`.

- **`finrank_cotangentSpaceDual_eq_finrank_h1Cok`** (`:891`) — **LANDED as a two-line reduction**, not sorried itself:
```
  obtain ⟨i, j, hi, hc⟩ := semilinearComparison_cotangentSpaceDual_h1Cok C S
  exact finrank_eq_of_addEquiv_of_bijective_smul i j hi hc
```
It inherits `sorryAx` transitively. Note the file's own docstring at `:71` still claims this is the sorried one — stale, the sorry moved down into the semilinear comparison at run 0067.

- **`semilinearComparison_cotangentSpaceDual_h1Cok`** (`:804`) — **SORRIED**, `:819`. This is the single genuine open statement on the tangent lane. Its shape:
```
∃ (i : κ(e) → k) (j : Module.Dual κ(e) (CotangentSpace ...) ≃+ S.H1Cok (toModuleKSheaf C)),
  Function.Bijective i ∧ ∀ r x, j (r • x) = i r • j x
```
Its docstring (`:726-802`) is the authoritative statement of what AJC believes it has: clauses (i) chart triviality and (ii) the tensor identity are claimed closed; **clause (iii), "under those identifications a kernel element goes to its transition unit," is the sole residue** — and the docstring at `:783-786` says explicitly "What is *not* yet done is the mathematics: exhibiting that equivalence." It also names your project's retraction (inbox I-0495) as the reason the statement is `≃+` rather than `Equiv`.

Downstream: `finrank_cotangentSpace_eq_finrank_hModuleOne` (`:928`) and `tangentSpaceIso` (`:1003`) are genuine sorry-free assemblies over the reduced core. `smooth` (`:1210`) and `proper` (`:1427`) are sorry-free assemblies over `geometricallyReduced`/`universallyClosed`.

Whole-project context: 28 term-level sorries across AJC's `AlgebraicJacobian/`, spread over 11 files (largest: `Albanese/AlbaneseUP.lean` 6, `Jacobian.lean` 4).

## Import-by-porting candidates

Honest answer: **the pickings are thin, and the one clean candidate you already have.**

1. **`DualNumberChartTriviality.lean` + `NilpotentThickeningFree.lean` — DO NOT PORT, you already have both.** I diffed by name against your tree: your `Tangent/DualNumberChartTriviality.lean` carries `augIdeal_mul_self_eq_bot:73`, `ker_fstHom_eq_span_eps:88`, `isNilpotent_span_eps:107`, `free_of_cyclic_mod_eps:132`, and your `Tangent/NilpotentThickeningFree.lean:143` has `free_of_nilpotent_of_exists_sub_smul_mem`. Same names, same lines, same content. Zero gain.

2. **`DualNumber.baseChangeAlgEquiv` — DO NOT PORT, you already have it** as `TruncExpCech.baseChangeAlgEquiv` (`Tangent/DualNumberBaseChange.lean:119`), with the same `_tmul` and `_symm_apply` companions.

3. **`isPushout_appLE_chartBaseChange`** — `.../Picard/RigidPushforwardChartBaseChange.lean:100`. **Byte-level portable in isolation** (it is one `exact` over `isPushout_appLE_of_isPullback'`, all mathlib vocabulary: `IsPullback`, `appLE`, `IsAffineOpen`). Genuinely useful if you ever need the *ring*-level pushout `Γ(Y,⊤) → Γ(X,W)`, `Γ(Y,⊤) → Γ(Y',⊤)` ⟹ `Γ(X', g'⁻¹ᵁ W)` at an affine open, which is the structural skeleton under your `Over.sectionsBaseChange`. You have **no counterpart**: grep for `isPushout_appLE` in AJCR returns nothing. Caveat — check whether `isPushout_appLE_of_isPullback'` is a mathlib name or AJC-local; if the latter it pulls in a dependency.

4. **`exists_chartTensorEquiv`** — `.../Picard/RigidPushforwardChartBaseChange.lean:151`. **NOT byte-level portable.** Its proof consumes `pullback_app_isoTensor_baseMap_sectionLinearEquiv` and `pullback_app_isoTensor_baseMap` from the 6000-line `QuotScheme.lean`, plus `f.baseSectionsModule` and `SectionBaseChange.bijective_addHom_of_isPushout`. That is the full AJC rigid-pushforward stack. Also it is `≃+` only, for modules, so it would not give you a ring equivalence anyway.

5. **`SectionBaseChange.bijective_addHom_of_isPushout`** (`.../Picard/SectionBaseChange.lean:223`) and `isPushout_of_ringEquiv` (`:196`) — **byte-level portable**; that file imports only mathlib (4 imports, no `AlgebraicJacobian.*`). Pure commutative algebra: scalar-extension associativity along a ring pushout, `B ⊗[A] M → D ⊗[C] M` bijective. If your `Over.sectionsBaseChange` needed such a cancellation step you would already have written it, so verify before spending time.

Bottom line for your lane: on (1) AJC gives you **nothing** — no `CechPic`, no cover functoriality. On (2) the composite and both compatibility laws are open on *both* sides; AJC's docstrings assert them closed, which is false at the declaration level. On (3) both projects hold the identical module lemma and neither has the sheaf-to-module step. **Clause (iii) plus the sheaf-to-module bridge is the genuine joint frontier**, and AJC's own `Pic0AbelianVariety.lean:781-786` says so in writing.
