I have what I need. Time to report.

## 1. AJCR: what exists towards clause (iii) — ALL VERIFIED SORRY-FREE

File-name correction: the paths in your list are wrong. AJCR uses `AlgebraicJacobian/Tangent/`, **not** `Picard/Tangent/`. And `Picard/TangentSpaceDualNumbers.lean` does **not exist in AJCR** — it exists only in **AJC** (`/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TangentSpaceDualNumbers.lean`). AJCR's counterpart is `Tangent/TangentDualNumbers.lean`, whose docstring line 49 in fact cites the AJC file.

Sorry census (grep for `sorry` as a term; every hit below was read and is docstring prose):

| file (root `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/`) | lines | verdict |
|---|---|---|
| `Tangent/TwoChartNaturality.lean` | 203 | sorry-free (0 hits) |
| `Tangent/DualNumberCarrier.lean` | 232 | sorry-free (0 hits) |
| `Tangent/DualNumberCarrierReduction.lean` | 199 | sorry-free (0 hits) |
| `Tangent/Pic0TangentSpace.lean` | 269 | sorry-free (2 prose hits, L32/L176) |
| `Tangent/TwoChartCechPic.lean` | 460 | sorry-free |
| `Tangent/TwoChartNormalize.lean` | 267 | sorry-free |
| `Tangent/TwoChartRepresentable.lean` | 327 | sorry-free |
| `Tangent/TruncExpCech.lean` / `TruncExpCechH1.lean` / `TruncExpUnits.lean` | 392/377/329 | sorry-free |
| `Tangent/DualNumberChartPic.lean` | 142 | sorry-free (1 prose hit L120) |
| `Tangent/DualNumberChartTriviality.lean`, `DualNumberBaseChange.lean` | 140/137 | sorry-free |
| `Picard/Pic.lean`, `CechPicToPic.lean`, `CechPicSurjective.lean`, `CechPicToPicNaturality.lean`, `CechPicClopenGlue.lean`, `CechPicClopenSep.lean`, `RefinementInjectivity.lean`, `RelPic.lean`, `Tangent/RelPicPointTest.lean` | — | all sorry-free |

The real `CechPic*` names: `Picard/CechPicToPic.lean`, `CechPicToPicNaturality.lean`, `CechPicSurjective.lean`, `CechPicClopenGlue.lean`, `CechPicClopenSep.lean`, plus `Tangent/TwoChartCechPic.lean`.

**AJCR's residue (iii-c2-aff) is NOT a sorry.** It is carried as an explicit **hypothesis** — `Tangent/DualNumberChartPic.lean:127` `Opens.cechPicMap_ι_eq_one_of_dualNumberChart`, whose binder `hcyc` is exactly the missing content:

```
(hcyc : ∀ x : (CommRing.Pic.mapRingHom (e : Γ(Z,O) →+* DualNumber A) (O.cechPicClass hO L)).AsModule,
   ∃ r : DualNumber A, x - r • m ∈ Ideal.span {(ε : DualNumber A)} • (⊤ : Submodule _ _))
: Scheme.CechPic.map O.ι L = 1
```

Its own docstring (L44-48) states what is owed: "**Only the generator.** given `L` on the thickened curve with `L` restricting trivially to `C`, produce `m` ... That is where the hypothesis 'trivial on `C`' is spent". Per w5-worksheet §0(4) AJCR deliberately never registers this as a `sorry`, so **a sorry-free AJCR does not mean (iii-c2-aff) is proved**. This is the single most important thing to carry back: AJCR's clause (iii) is open exactly like AJC's, just spelled as a binder instead of a `sorry`.

## 2. AJC: what exists that clause (iii) could consume — all VERIFIED

All in `/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/`. `Pic0DualNumberCocycle.lean`, `DualNumberChartTriviality.lean`, `NilpotentThickeningFree.lean`, `OnePointRelPicCollapse.lean`, `Pic0TangentSpace.lean`, `RelPicFunctor.lean` are all **0 sorry-token hits**. `Pic0AbelianVariety.lean` has exactly **three** real sorry bodies: L820 (`semilinearComparison_cotangentSpaceDual_h1Cok`), L1102 (`geometricallyReduced`), L1332 (`universallyClosed`).

- `relPicDualKernel` — `Pic0AbelianVariety.lean:264`. `: AddSubgroup ((PicSharp.relPresheaf C).obj (op (overDualNumber k)))` `:= ((PicSharp.relPresheaf C).map (overDualNumberZero k).op).hom.ker`. Plus `relPicDualKernel_eq_subtype` (L273) `:= rfl`.
- `relPicDualKernelAddEquivAbsKernel` — `Pic0AbelianVariety.lean:301`. `: relPicDualKernel C ≃+ ((PicSharp C).map (overDualNumberZero k).op).hom.ker := PicSharp.kerRelPresheafAddEquivKerAbs C`. **The `H_T`-coset quotient is already removed on the AJC side** — this matches AJCR's `relPicMulEquivCechPic` (`Tangent/RelPicPointTest.lean:100`) exactly in content.
- `AffineCoverMVSquare.h1CokAddEquivTruncExpCechKernel` — `Pic0AbelianVariety.lean:315`. `: S.H1Cok (Scheme.toModuleKSheaf C) ≃+ Additive (DualNumber.cechUnitsReduction S.resLeft S.resRight).ker`, built from `h1CokAddEquivCechQuotient` (L233) ∘ `truncExpCechKernelAddEquiv`.
- `DualNumber.truncExpCechKernelAddEquiv` — `Pic0DualNumberCocycle.lean:962`. `(ρ₁ : A₁ →+* B) (ρ₂ : A₂ →+* B) : B ⧸ cechCoboundaryAdd ρ₁ ρ₂ ≃+ Additive (cechUnitsReduction ρ₁ ρ₂).ker`. Full proof present (injectivity via `mk_truncExpUnit_eq_one_iff`, surjectivity via `exists_mk_truncExpUnit_of_cechUnitsReduction_eq_one`).
- `DualNumber.unitsScale_mk_truncExpUnit` — `Pic0DualNumberCocycle.lean:1037`. `{s₁ : A₁} {s₂ : A₂} {t : B} (h₁ : ρ₁ s₁ = t) (h₂ : ρ₂ s₂ = t) (b : B) : QuotientGroup.map _ _ (Units.map (scaleRingHom t).toMonoidHom) _ (mk (truncExpUnit b)) = mk (truncExpUnit (t * b))`. This is the `hc` intertwining on the Čech side.
- `DualNumber.baseChangeAlgEquiv` — `Pic0DualNumberCocycle.lean:1133`. `: A ⊗[k] DualNumber k ≃ₐ[A] DualNumber A`. (AJCR has its own at `Tangent/TruncExpCech`-namespace, used by `Over.dualNumberSections`.)
- `DualNumber.free_of_cyclic_mod_eps` — `DualNumberChartTriviality.lean:120`. `(M) [Module.Invertible (DualNumber A) M] (m : M) (h : ∀ x, ∃ r, x - r • m ∈ Ideal.span {ε} • ⊤) : Module.Free (DualNumber A) M`. **Note: this has the identical `h` binder as AJCR's `hcyc`.** Both projects' clause-(iii) residue is "produce `m` and `h`" — literally the same obligation, same spelling.
- `relPicKernelSMul` — `Pic0DualNumberCocycle.lean:570`, on a general `G : (Over (Spec k))ᵒᵖ ⥤ AddCommGrpCat`, subtype-valued; laws at L585/597/617. Docstring flags that distributivity `(a+b)•x` is **not** proved at this generality.
- `cotangentSpaceDual_equiv_relPicKernel` — `Pic0AbelianVariety.lean:549`. `: Nonempty (Module.Dual κ(e) (CotangentSpace ...) ≃ {a // (relPresheaf.map (overDualNumberZero k).op).hom a = 0})`. Bare `Equiv`, set-level, as its docstring says.

Every name you listed exists. `AffineCoverMVSquare` itself is `Cohomology/MayerVietorisCover.lean:51`.

## 3. DECISIVE: (iii-a)/(iii-b) are NOT importable and only half-portable

The declarations, both `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Tangent/TwoChartCechPic.lean`:

- **(iii-a)** L428 `twoChartClass (V : Bool → X.Opens) (sel : X → Bool) (hmem : ∀ x, x ∈ V (sel x)) (hsel : Function.Surjective sel) : (Γ(X, V false ⊓ V true)ˣ ⧸ TruncExpCech.cechCoboundaryUnits (X.resHom inf_le_left) (X.resHom inf_le_right)) →* X.CechPic`
- **(iii-b)** L449 `twoChartClass_injective ... : Function.Injective (twoChartClass V sel hmem hsel)`
- bonus **(iii-c1)** `Tangent/TwoChartNormalize.lean:243` `twoChartClassHom_mk_range` and L258 `twoChartClass_mk_range` (surjectivity onto classes representable on the cover)
- bonus **(iii-c2-Zar)** `Tangent/TwoChartRepresentable.lean:301` `twoChartClassHom_surjOn_of_chartTrivial (L : X.CechPic) (hL : ∀ s : Bool, Scheme.CechPic.map (V s).ι L = 1) : ∃ u, twoChartClassHom V sel hmem u = L`

**Answer: NOT importable, and the port is blocked at the target, not the source.**

They *are* scheme-general — no curve, no field, no dual numbers, arbitrary `X : Scheme.{u}` — but they are **not stated in mathlib vocabulary only**. The mathlib names they use: `X.Opens`, `Γ(X, ·)`, `X.resHom`, `inf_le_left/right`, `Units`, `QuotientGroup`, `Function.Surjective/Injective`. The AJCR-only names, which are the load-bearing ones:

- **`X.CechPic`** — `Picard/Pic.lean:60`, `Quotient (cechPicSetoid X)` over `Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰`. **AJC has no `CechPic` and no `PointedCover` at all** (grep: only two prose mentions, `Picard/OnePointRelPicCollapse.lean:50` and `RiemannRoch/Adelic/ClassInvariance.lean:50`, the latter saying "none of whose names exist in this project").
- `X.PointedCover` (`Picard/UnitsCocycle.lean:94`), `X.unitsH1`, `OneCocycle.class`, `unitsRes`, `X.unitsRestrict`, `Scheme.unitsCocycle_isCohomologous` — the whole `UnitsCocycle` + `RefinementInjectivity` layer.
- `TruncExpCech.cechCoboundaryUnits` — this one **is duplicated in AJC** as `DualNumber.cechCoboundaryUnits` (`Pic0DualNumberCocycle.lean:746`), verbatim the same definition `(Units.map ρ₁.toMonoidHom).range ⊔ (Units.map ρ₂.toMonoidHom).range`. So the *source* group of (iii-a) is already available in AJC.

The carrier divergence is worse than the one that broke the earlier port, and it is at the *absolute* level, not the relative one:

- AJCR: `picFromBase C T := (CechPic.map (snd C T).left).range : Subgroup ((C ⊗ T).left.CechPic)` and `relPic C T := (C ⊗ T).left.CechPic ⧸ picFromBase C T` (`Picard/RelPic.lean:54,63`) — a `QuotientGroup` of a **Čech** group.
- AJC: `relPicSetoid` on `LineBundle.OnProduct πC πT = {M : (pullback πC πT).Modules // IsLocallyTrivial M}` (`Picard/RelPicFunctor.lean:320-325`) — a setoid quotient of **sheaf-theoretic modules**. AJC's nearest absolute analogue is `PicGroup X := Quotient (picSetoid X)` on `{M : X.Modules // IsInvertible M}` (`Picard/TensorObjSubstrate.lean:620`), i.e. **iso-classes of invertible modules, not Čech classes on pointed covers**.

Concretely: there is no `AJC` type to put on the right of (iii-a)'s arrow. Importing is impossible (no cross-project dependency: AJC's `lakefile.toml` requires only checkdecls/doc-gen4/mathlib, and no `.lean` file references `AlgebraicJacobianRebuild`). Porting (iii-a)/(iii-b) means **first building a sheaf-side comparison `Γ(U₁ ⊓ U₂)ˣ ⧸ coboundaries →* AJC's LineBundle.OnProduct-quotient` and its injectivity from scratch** — the "glue a line bundle from a transition unit + recognise when two glued bundles are isomorphic" content, which in AJCR is `RefinementInjectivity` + the whole `UnitsCocycle` layer. That is the port cost, and it is *not* the same as the AJCR proof: AJCR's injectivity proof is `Quot.ind` on a Čech representative followed by refinement injectivity, and there is no `Quot.ind` on a Čech representative available on AJC's `OnProduct` setoid. This is precisely the "port the idea, the proof cannot port" pattern.

What **is** cheaply reusable, and which AJC should take: nothing at the `CechPic` level, but AJCR's `Tangent/DualNumberCarrier.lean` (`Over.dualNumberSections : DualNumber Γ(C.left, W) ≃+* Γ(C_ε, fst⁻¹ W)`, L141; `Over.dualNumberSectionsUnits` L195) and `DualNumberCarrierReduction.lean:189` (`Over.relSectionsMapUnits_dualNumberSectionsUnits`) are clause-(ii)-on-units plumbing stated in scheme/sheaf vocabulary, whose AJC analogue is only the algebra-level `baseChangeAlgEquiv`. Those are the genuinely portable pieces.

## 4. Mathlib v4.31: NOTHING for the surjectivity half

Searched `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib` (toolchain `v4.31.0`, mathlib `rev = v4.31.0`).

- **There is no Picard group of a scheme in mathlib.** `grep -rn "Pic " Mathlib/AlgebraicGeometry/` returns **zero hits**. No `Scheme.Pic`, no `picardGroup`, no `InvertibleSheaf`, no `LineBundle`.
- The only Picard group is **ring-level**: `CommRing.Pic (R) [CommSemiring R]` at `Mathlib/RingTheory/PicardGroup.lean:400`, with `mk_eq_one_iff_free` (L465), `mk_tensor` (L473), `mk_dual` (L480). Its one exact sequence is `mulExact_unitsMap_spanSingleton_unitsToPic` (L732): `1 → Rˣ → Aˣ → (Submodule R A)ˣ → Pic R → Pic A` — a *localisation/fractional-ideal* sequence, not a cover sequence. Not applicable.
- Čech: `Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean` has only three declarations (`cosimplicialObjectFunctor` L43, `cochainComplexFunctor` L53, `cechComplexFunctor` L65) — the abstract cochain complex of a presheaf, with **no** `H¹`-of-units, no comparison to a Picard group.
- Mayer-Vietoris: `Mathlib/CategoryTheory/Sites/SheafCohomology/MayerVietoris.lean` has the six-term exact sequence `sequence` (L120) / `sequence_exact` (L141) / `δ` (L112), and `Mathlib/Topology/Sheaves/MayerVietoris.lean` supplies `mayerVietorisSquare (U V : Opens T)` (L59). These are **abelian-sheaf-valued** (`AddCommGrpCat`) — they give the additive two-open sequence AJC's `H1Cok` already models, and cannot see `𝒪ˣ` (a sheaf of groups, not abelian groups in mathlib's sense here).
- `Algebra.FormallyEtale.comp_bijective` does exist, at `Mathlib/RingTheory/Etale/Basic.lean:77`, with `(I : Ideal B) (hI : I ^ 2 = ⊥)` — so the I-0495 claim about it is verified as to existence and to the square-zero hypothesis shape.

**Verdict: no mathlib candidate for the surjectivity half exists at any strength.** The "invertible sheaf trivial on each of two charts is determined by its transition unit" statement has to be built in-project. AJCR built it (`twoChartClassHom_mk_range`, `twoChartClassHom_surjOn_of_chartTrivial`) against its own `CechPic`; that is the only implementation in either tree.

### The one-line answer for the two lanes
Neither side has clause (iii). AJC carries it as `sorry` at `Pic0AbelianVariety.lean:820`; AJCR carries the *same* remaining content as the `hcyc`/`m` binder at `Tangent/DualNumberChartPic.lean:127` — compare it with AJC's already-proved `DualNumber.free_of_cyclic_mod_eps` (`DualNumberChartTriviality.lean:120`), whose `h` binder is character-for-character the same obligation. AJCR is ahead only on the Zariski/cocycle scaffolding around it ((iii-a),(iii-b),(iii-c1),(iii-c2-Zar), all sorry-free, all scheme-general), and that scaffolding is welded to `X.CechPic`, which does not exist in AJC.
