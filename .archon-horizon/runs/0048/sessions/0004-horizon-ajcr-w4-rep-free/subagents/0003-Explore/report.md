I have everything. Report follows.

---

# Genericity of `π` — audit report

## Bottom line

The apparatus **is genuinely generic in `π`**. Across the whole repo the *only* typeclass constraints ever placed on `π` are `IsFinite`, `IsDominant`, `IsAffineHom` (plus `LocallyQuasiFinite` in `Curve/` existence lemmas), and the *only* propositional hypothesis is the "π is a k-morphism" triangle `hπ/hpi : π ≫ P1.structureMap k = <structure morphism>`. No flatness, no separability, no degree bound, no `Finite.Free`, no `Module.Free`. `π` is a `variable` everywhere in Picard/RiemannRoch/Cohomology; the one `Classical.choose`-pinned `π` in the repo (`thetaP1`) lives on a *different* curve and is decoupled.

---

## (1) Exhaustive tally of constraints on `π`/`pi`

Machine tally over `AlgebraicJacobian/` of every bracketed instance argument mentioning `π`/`pi`:

| constraint | occurrences |
|---|---|
| `[IsFinite π]` / `[IsFinite pi]` | 215 + 71 |
| `[IsDominant π]` / `[IsDominant pi]` | 125 + 51 |
| `[IsAffineHom π]` / `[IsAffineHom pi]` | 71 + 4 |
| `[LocallyQuasiFinite π]` | 2 — **only in `Curve/`**, never Picard/RR/Cohomology (`AlgebraicJacobian/Curve/MapToP1.lean:53`, `:68`) |

Propositional hypotheses (machine tally):
- `hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)` — 65
- `hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)` — 47
- `hπ : π ≫ P1.structureMap k = C.hom` — 26 (Cohomology spelling)
- `hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)` — 10 (RiemannRoch spelling)

**Nothing else.** No `IsFlat π`, no `Finite.Free`, no separability, no `deg π = …`.

### Files imposing more than `IsFinite`/`IsAffineHom`

The *only* extra typeclass is `[IsDominant π]`. Representative `variable` lines:

- `AlgebraicJacobian/RiemannRoch/WindowLedger.lean:94-102`
  ```
  variable {K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y]
    [Y.Over (Spec (CommRingCat.of K))]
    [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
    [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
    [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K))
  ```
- `AlgebraicJacobian/RiemannRoch/UniformVanishing.lean:71-74` (DAT-0a source) — `(π : Y ⟶ P1 K) [IsFinite π] [IsDominant π] (hπ : …)`
- `AlgebraicJacobian/Picard/DivSchemeSeedUniv.lean:127`, `:132-137` — `(π : C.left ⟶ P1 k) [IsFinite π]` … `[IsDominant π]` … `variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))`
- `AlgebraicJacobian/Picard/DivSchemeHighWindowStage.lean:49,58` — `{pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]` … `(hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))`
- `AlgebraicJacobian/Picard/DivSchemeHighWindowPencilTheta.lean:88`, `DivSchemeSeedUnivFibre.lean:84,177,279`, `DivSchemeRedesignKappaZSeed.lean:58`, `DivSchemeSeedUnivFields.lean:49`, `Cohomology/RelCurveCollapse.lean:475`, `RiemannRoch/CarveDegreePinch.lean:332`, `RiemannRoch/WindowFieldTransport.lean:177,277` — all `[IsFinite _] [IsDominant _]`.
- Weakest tier (`IsAffineHom` only): `Picard/DivisorFamily.lean:160,232,452,463,472,476`, `Picard/DivSchemeCertZarSeed.lean:68`, `Picard/DivSchemeCertFibreRank.lean:35`, `Cohomology/GluedSheafDatum.lean:81,153`, `Cohomology/GluedSheafEngine.lean:66`, `Cohomology/DatumDescent.lean:80,151,514,525`.

`IsDominant` is exactly what `genericPoint_mem_preimage_inf` needs (`RiemannRoch/FiberTwist.lean:185-186, 194`). All three properties (`IsFinite`, `IsDominant`, `IsAffineHom`) are closed under post-composition with an isomorphism, so `π ≫ γ` inherits them for free.

---

## (2) Is `π` ever *constructed*/pinned?

Exhaustive search for `def`s producing a `⟶ P1 k` yields exactly two hits in the whole repo:

1. `AlgebraicJacobian/Curve/P1Points.lean:201` — `fromSpecChart (i : Fin 2) (a : A) : Spec A ⟶ P1 k` (a *point* of P1, not the curve map).
2. `AlgebraicJacobian/Picard/ThetaShift.lean:251-252`
   ```
   def thetaP1 : (C ⊗ overSpec k k).left ⟶ P1 k :=
     (exists_isFinite_isDominant_toP1 (C := baseCurveObj C)).choose
   ```
   with `isFinite_thetaP1` at `:254-255`, `isDominant_thetaP1` at `:257-258`.

**This is the only pinned `π` in the project.** Notes for the review:
- It lives on the *base-changed* curve `(C ⊗ overSpec k k).left`, not on `C.left`, so it is **not** the `π` that the DivScheme/RiemannRoch chain quantifies over.
- Its only downstream use is `thetaCechClass C := fiberTwist (thetaP1 C) 1` (`ThetaShift.lean:262-265`), consumed at exactly three places: `Picard/DivSchemeAbel.lean:354, 373, 385` — and there only through the *integer* `classDeg k (thetaCechClass C)` (`one_le_classDeg_thetaCechClass`, `ThetaShift.lean:270`). In `DivSchemeAbel.lean` the file's own `π` is an independent variable (`:63` — `{π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}`).
- Source existential: `AlgebraicJacobian/Curve/MapToP1.lean:125` `exists_isFinite_isDominant_toP1`.

Also: `AlgebraicJacobian/Picard/DivScheme.lean:144` — `DivScheme k A B g r₁ r₂ b₁ b₂` takes **no `π` at all**; it is parameterized by two arbitrary `X.CurveDivisor`s `A B` and bases (`DivScheme.lean:135-139`). `π` only enters through the *instantiation* `A := windowS_choice π hπ g • fiberWeilDivisor π`, `B := windowM_choice π hπ g • fiberWeilDivisor π` (see `DivSchemeSeedUniv.lean:138-143`). This is the strongest genericity evidence: the atlas scheme itself is π-free.

Zero occurrences of `∃ π`, `∀ π`, `∃ pi`, `∀ pi` in Picard/RiemannRoch/Cohomology/Albanese/AbelianVariety — i.e. **π is never currently quantified over inside a statement**; it is always a section-level `variable`.

---

## (3) `WindowLedger` / `ThetaSections` / `FiberTwist`

### `windowBound` — exact signature

`AlgebraicJacobian/RiemannRoch/WindowLedger.lean:109-110`
```lean
noncomputable def windowBound : ℤ :=
  (exists_bound_subsingleton_hModule_one_of_isFinite_toP1 π hπ).choose
```
with the section variables at `:94-102` (quoted in (1) above). So the full elaborated signature is
```lean
windowBound {K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y]
  [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
  (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
  (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) : ℤ
```
**`hπ` stands for**: `π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)` — "π is a morphism *over* `Spec K`", i.e. the structure-morphism triangle commutes. **Nothing more.** This is stable under `π ↦ π ≫ γ` for any `γ` with `γ ≫ P1.structureMap K = P1.structureMap K` (a k-automorphism), which is exactly the class in the proposal.

Spec at `:114-117`:
```lean
theorem windowBound_spec (D : Y.CurveDivisor) (hD : windowBound π hπ ≤ CurveDivisor.deg K D) :
    Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```
Source: `AlgebraicJacobian/RiemannRoch/UniformVanishing.lean:71-76` — the docstring at `:38-40` explicitly states "`b` depends only on `(Y, π)`". Downstream `windowδ π := classDeg K (fiberTwist π 1)` (`WindowLedger.lean:122`), `windowS_choice` (`:153`), `windowM_choice` (`:186`) — all functions of `(π, hπ, g)` only.

### `thetaUnit`

`AlgebraicJacobian/RiemannRoch/ThetaSections.lean:70-76`, under `variable {K} [Field K] {Y} (π : Y ⟶ P1 K)` at `:63` — **no typeclass on π at all** in the `Unit` section. The value section `:95-100` adds `[IsDominant π]` (+ `[IsIntegral Y]`, smooth/qc/lft on `Y ↘ Spec K`) — **still no `IsFinite`**. `thetaTwistSheaf` (`:85-87`) likewise.

### `FiberTwist.lean`

- `Cover` section `:73` — `(π : Y ⟶ P1 K)`, **no instances**: `fiberChart₀ := π ⁻¹ᵁ P1.chartOpen K 0` (`:79`), `fiberChart₁ := π ⁻¹ᵁ P1.chartOpen K 1` (`:82`), `fiberCoord := π* (X₁/X₀)` (`:88-89`), `fiberCover` (`:106`), `fiberEqn` (`:127`).
- `Main` section `:185-186` — adds `[IsIntegral Y]` and `[IsDominant π]` only. `fiberDivisor` (`:240`), `fiberTwist` (`:301`), `fiberCocycle` (`:306`).
- `Degree` section `:378-382` — adds only `Y ↘ Spec K` properties.

**Answer to (3): none of the three depend on any property of `π` beyond `IsFinite`/`IsDominant` + the `hπ` triangle.** `IsAffineHom` never appears in these files. Note `FiberTwist.lean:386-390` explicitly records that `deg Θ₁ = deg π` is a *deferred frontier*, i.e. the ledger never uses any numerical fact about `π`'s degree — another point in favour of genericity.

---

## (4) The seed / atlas layer — chart-specificity audit

All seed files take `π` as a `variable` with at most `[IsFinite π] [IsDominant π]`:

| file:line | `variable` |
|---|---|
| `Picard/DivSchemeSeed.lean:53` | `{π : C.left ⟶ P1 k} [IsFinite π]` |
| `Picard/DivSchemeSeedDvd.lean:47` | `{π} [IsFinite π] {a : ℕ}` |
| `Picard/DivSchemeSeedUniv.lean:128,132-137` | `(π) [IsFinite π]`, `[IsDominant π]`, `(hπ : …)` |
| `Picard/DivSchemeSeedUniv.lean:389,399` | `{π} [IsFinite π] [IsDominant π]`, `(hπ : …)` |
| `Picard/DivSchemeSeedUnivFibre.lean:84,177,279,369` | `[IsFinite π] [IsDominant π]` |
| `Picard/DivSchemeSeedUnivFields.lean:49,58` | `[IsFinite π] [IsDominant π]`, `(hπ)` |
| `Picard/DivSchemeSeedUnivMulSpan.lean:37,47` | `[IsFinite π]`, `(hπ)` |
| `Picard/DivSchemeSeedUnivSecondWindowMap.lean:45,56,95` | `[IsFinite π] [IsDominant π]`, `(hπ)`, `(hker : divCarveIdeal k (windowS_choice π hπ g • fiberWeilDivisor π) …)` |
| `Picard/DivSchemeCertZarSeed.lean:68` / `:98` | `{pi} [IsAffineHom pi]` / `{pi} [IsFinite pi]` |
| `Picard/DivSchemeHighWindowStage.lean:49,58` | `{pi} [IsFinite pi] [IsDominant pi]`, `(hpi)` |
| `Picard/DivSchemeHighWindow*` (~25 files, e.g. `RelativeKoszul.lean:50`, `Relations.lean:51`, `Persistence.lean:124`, `Syzygy.lean:168`, `DirectLimit.lean:209`, `FibreImage.lean:43`, `TransitionQuotient.lean:41`) | `{pi} [IsFinite pi] [IsDominant pi]` |
| `Picard/UniversalSections.lean:70-76,157` | **π-free entirely** (`C`, `A : Type u [CommRing A] [Algebra k A]`, `[IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]`) |
| `Picard/DivCarveKit.lean:44,114,140`, `DivCarveLocus.lean:59,249-253`, `DivCarvePairChart.lean:48,154,344,399` | **π-free entirely** — pure linear algebra / abstract `A B : X.CurveDivisor` + bases. (There is no `DivCarveChartRing*.lean` file; `DivCarveChartRing` is a *declaration* in `DivScheme.lean`/`DivCarve*`, taking `A B` divisors, not `π`.) |

### Declarations mentioning a SPECIFIC point of P1 (NOT stable under `π ↦ γ∘π`)

This is the load-bearing finding. Every use of `P1.chartOpen k 0/1` in Picard/RR is *through* `π` (so it's `(γ∘π)`-covariant, just with a different chart pair). The **statements that are genuinely about the specific pair `{π⁻¹(0), π⁻¹(∞)}`** are:

1. **`AlgebraicJacobian/Picard/DivSchemeCertZarSwallow.lean:153-160` `DivisorAdaptation.subset_chart₀_or_disjoint_chart₀`** and `:168-…` `subset_chart₁_or_disjoint_chart₁`. Docstring `:148-151`: *"This is the statement the DD-R atlas owes: **the chart's divisors avoid `pi⁻¹(0)` and `pi⁻¹(∞)`.** It is a hypothesis about the chart, and it is the only remaining geometric input of the (c1) side of the certificate."*

2. **`AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean:151-…` `supportLocus_subset_chart_of_isPreconnected`** — docstring `:143-147`: *"every landed route to `IsCertified` … is available for a connected divisor **only** if that divisor avoids `pi⁻¹(∞)` (so it sits in `V₀`) or avoids `pi⁻¹(0)` (so it sits in `V₁`). **This is a condition on the divisor and the chosen `pi`**."*

3. **`AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean:171-181` `not_forall_supportLeak_eq_empty_of_isPreconnected`** — the negative result: a connected divisor meeting both `pi⁻¹(0)` and `pi⁻¹(∞)` admits **no** leak-free adaptation over any base after any shrink. Explicit counter-model in the docstring: `V(t x² + x y + t y²) ⊆ ℙ¹` over `k[t]`, fibre at `t=0` equal to `{0, ∞}`.

4. **`AlgebraicJacobian/Picard/DivSchemeCertZarC1.lean:131` `DivisorAdaptation.supportLocus_subset_chart_of_isCertified`** (vars `:96-100`, only `[IsFinite π]`) — the positive verdict: `IsCertified n` ⟹ support confined to one pinned chart.

5. **`AlgebraicJacobian/Picard/DivSchemeCertZarVerdict.lean:64-71` `not_isCertified_of_isPreconnected_of_witnesses`** — the obstruction in witness form: two support points, one off `V₀`, one off `V₁` ⟹ `¬ A.IsCertified n`, **in any degree, with no leak hypothesis**.

These are precisely the declarations that are *not* invariant under `π ↦ γ∘π`, and they are exactly the failure mode the proposal targets: `γ` moves `{0,∞}`, so a divisor obstructed for `π` is generally unobstructed for `γ∘π`. Note they are **statements about a divisor relative to a fixed π**, not hypotheses on π — so quantifying over π is the well-typed fix, and nothing in the seed layer blocks it.

Supporting chart plumbing (all `π`-covariant, safe): `Picard/AffineTwoCover.lean:99-103` (`fiberTwoCover π := {V₀ := π ⁻¹ᵁ chartOpen k 0, V₁ := π ⁻¹ᵁ chartOpen k 1}`), `Picard/DivSchemeFamilySide.lean:115` (`relPinnedChart`), `Picard/DivSchemeSeed.lean:94-104`, `Picard/SectionsToDivisors.lean:254-263`, `Picard/DivSchemeHighWindowChartExhaustion.lean:107-118`, `Cohomology/RigidEngine4Relative.lean:75` (`fiberTwoCover`).

---

## (5) Properness of `relCurve C R ⟶ Spec R`

**`AlgebraicJacobian/Picard/SupportTube.lean:194-196`**
```lean
instance instIsProperRelCurveHom :
    IsProper ((relCurve C R) ↘ Spec (CommRingCat.of R)) :=
  inferInstanceAs (IsProper (snd C (overSpec k R)).left)
```
Section hypotheses — `SupportTube.lean:179-180`:
```lean
variable {k : Type u} [Field k] (C : Over (Spec (.of k))) [IsProper C.hom]
variable (R : Type u) [CommRing R] [Algebra k R]
```
**Yes, it needs `[IsProper C.hom]`** — and nothing else (no smoothness, no geometric irreducibility, no Noetherian, and `R` is an *arbitrary* commutative `k`-algebra). It is derived from `SupportTube.lean:186-188`:
```lean
instance instIsProperRelSndLeft : IsProper (snd C (overSpec k R)).left :=
  MorphismProperty.of_isPullback (P := @IsProper)
    (Over.isPullback_left C (overSpec k R)) inferInstance
```
`Separated`/`UniversallyClosed` fire by resolution from `IsProper` (documented `SupportTube.lean:38-41`, `:192-193`). Consumers: `Picard/DivSchemeCertZarTube.lean:84`, `Picard/DivSchemeSeedUnivColFin.lean:32-33, 216`, `Picard/DivSchemeCertZarSwallow.lean:130`, `Picard/SupportTubeFinite.lean:23, 286`, `Scheme.LocalEquations.exists_supportTube` (`SupportTube.lean:165`).

Field-only variants (superseded for general `R` by the above): `AlgebraicJacobian/Curve/BaseChangeInstances.lean:106-108` `instIsProperSndLeft` and `:130-132` `instIsProperBaseChange` — both under `variable … [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (K : Type u) [Field K] [Algebra k K]` (`BaseChangeInstances.lean:63-66`).

Separatedness elsewhere: `Picard/EffectivityPieces.lean:319-321` (`isSeparated_left`), `Picard/DivSchemeQProj.lean:211` (`isSeparated_divScheme`, about the atlas scheme, not the curve).

---

## Risk notes for the proposal

1. **No `Aut(P1 k)` infrastructure exists.** Exhaustive search for `Aut (P1`, `P1 k ⟶ P1 k`, `PGL`, `Möbius`, `linearFrac`, `IsIso … P1` returns **zero hits**. `Curve/P1.lean` (declaration list, `:135`–`:428`) provides `P1`, `structureMap`, `chartOpen`, `chartι`, `chartCoord`, `dehomogenize`, `polyToAway`, `awayAlgEquiv` — but *no* self-morphisms of `P1`. Building `γ` and proving `γ ≫ P1.structureMap k = P1.structureMap k` is new work; it is the main cost of the proposal, not the genericity refactor.
2. Once `γ` exists, `[IsFinite (π ≫ γ)]`, `[IsDominant (π ≫ γ)]`, `[IsAffineHom (π ≫ γ)]` follow from composition instances, and `hπ` transports by `Category.assoc` + `γ`'s triangle. So **no `variable` block in Picard/RiemannRoch/Cohomology needs weakening**.
3. The derived data all shift covariantly and consistently: `fiberChart₀/₁ (π ≫ γ) = π ⁻¹ᵁ γ ⁻¹ᵁ chartOpen`, `fiberWeilDivisor (π ≫ γ)`, `windowδ (π ≫ γ)`, `windowBound (π ≫ γ) hπ'`, `windowS_choice`/`windowM_choice`, and hence a *different* `A, B` fed into the π-free `DivScheme k A B g r₁ r₂ b₁ b₂`. Since the atlas is π-free, the two atlases for `π` and `π ≫ γ` are the same construction at different divisor inputs — the cleanest possible situation for quantifying.
4. `thetaP1` / `thetaCechClass` (`ThetaShift.lean:251`, `:262`) are the only pinned choice; they are on `(C ⊗ overSpec k k).left` and enter only via the scalar `classDeg k (thetaCechClass C)` at `DivSchemeAbel.lean:354, 373, 385`. Harmless, but worth flagging as the one place a "choice of π" is already baked in with `Classical.choose`.
