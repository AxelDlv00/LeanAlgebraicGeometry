## Report

### (1) Automorphisms / coordinate changes / PGL₂ action on `P1 k` — **NONE EXIST**

Exhaustive negative result. `P1 k` is defined once at `AlgebraicJacobian/Curve/P1.lean:135-136` (`Proj (homogeneousSubmodule (Fin 2) k)`), and the **only** morphism out of it in the entire project is the structure map:

- `AlgebraicJacobian/Curve/P1.lean:170` — `P1.structureMap : P1 k ⟶ Spec (.of k)` (the sole `P1 k ⟶ _`).
- Greps for `P1 k ⟶ P1`, `≅ P1 k`, `Aut`, `PGL`, `GL (Fin 2)`, `Möbius`, `coordinateChange`, `linearChange`, `Proj.map`, `Proj.comap`, `GradedRingHom`, `GradedAlgHom` over `AlgebraicJacobian/` return **zero** hits touching `P1`. Every `π : … ⟶ P1 k` in the repo is a *source* morphism (`AlgebraicJacobian/Curve/MapToP1.lean:140`, `AlgebraicJacobian/Picard/*`, `AlgebraicJacobian/RiemannRoch/*`).
- `MvPolynomial.rename` / `renameEquiv` appear **only** in `AlgebraicJacobian/Algebra/StandardSmoothDimension.lean:73` and `AlgebraicJacobian/Algebra/SmoothPrimeRegularityStep.lean:286`, both about Krull-height of `MvPolynomial ι k` — never applied to `Fin 2` / the graded ring of `P1`.
- `MvPolynomial.aeval` on `Fin 2` appears only at `AlgebraicJacobian/Curve/P1.lean:278` (`P1.dehomogenize i := aeval (Function.update (fun _ => Polynomial.X) i 1)`), a *dehomogenization* `k[X₀,X₁] → k[t]`, not a graded self-map.
- The only `HomogeneousLocalization` maps are the two chart→overlap restrictions, `awayMap` of mathlib: `AlgebraicJacobian/Curve/P1Charts.lean:48-55` (`awayToOverlapLeft`, `awayToOverlapRight`), lifted to schemes at `AlgebraicJacobian/Curve/P1Points.lean:226,234`. These go `D₊(X₀X₁) ↪ D₊(Xᵢ)`; they are not automorphisms.
- **No coordinate swap** `X 0 ↔ X 1` exists as a map. Symmetry is only *syntactic*: lemmas are stated for `i j : Fin 2` with `hij : i ≠ j` (`P1.lean:284,335,339,378,405,413`), and the two `Fin 2` disequalities are `P1.fin_zero_ne_one` / `P1.fin_one_ne_zero` (`P1.lean:145,147`). Some facts are hard-wired to chart 0 and would need re-proving for chart 1: `P1Points.lean:90` (`exists_mem_chartOpen_zero_of_isOpen`), `P1Points.lean:139` (`chartι_base_genericPoint`), `P1Points.lean:300` (`fromSpecChart_base_genericPoint`, chart 0 only).
- `Matrix` / `GL` machinery in the repo (`AlgebraicJacobian/Picard/GrassmannianMatrixPoint.lean:47,102,146,172`, `GrassmannianChartFrame.lean:160`) is Grassmannian-chart bookkeeping, unrelated to `P1`.

**Mathlib does supply the missing infrastructure** (project imports all of Mathlib at `P1.lean:6`), unused here:
- `AlgebraicGeometry.Proj.map : Proj ℬ ⟶ Proj 𝒜` — `<mathlib>/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Functor.lean:144`, with `map_preimage_basicOpen:147`, `awayι_comp_map:180`, `map_comp:204`, `map_id:211`.
- `GradedRingHom` (`𝒜 →+*ᵍ ℬ`) — `<mathlib>/Mathlib/RingTheory/GradedAlgebra/RingHom.lean:46,52`; `GradedAlgHom` (`𝒜 →ₐᵍ[R] ℬ`) — `<mathlib>/Mathlib/RingTheory/GradedAlgebra/AlgHom.lean:27,37`.
- So a PGL₂ action would be buildable as `Proj.map` of a degree-preserving `aeval` on `k[X₀,X₁]`, but **nothing of the sort is in this project**, and there is no `IsIso`/`Proj.mapIso` wrapper in mathlib either (only `map_id`/`map_comp`).

### (2) k-rational points of `P1 k` — **no `Spec k ⟶ P1 k` anywhere**; only generic/abstract-point topology

`AlgebraicJacobian/Curve/P1Points.lean` despite its name contains **no** rational-point construction. There is no `P1.pt`, no `P1.infty`, no `P1.zero`, no `Spec (.of k) ⟶ P1 k` (verified by grep over all `⟶ P1 k` occurrences).

What exists:

*Morphisms into `ℙ¹` from a ring under `k` (the near-miss):*
- `AlgebraicJacobian/Curve/P1Points.lean:185` — `P1.chartEval (ρ : CommRingCat.of k ⟶ A) (i : Fin 2) (a : A) : CommRingCat.of (Away 𝒜 (X i)) ⟶ A`.
- `AlgebraicJacobian/Curve/P1Points.lean:201` — `P1.fromSpecChart k ρ i a : Spec A ⟶ P1 k`; docstring says *"for `i = 0` this is the point `[1 : a]`, for `i = 1` it is `[a : 1]`"*. **Instantiating `A := CommRingCat.of k`, `ρ := 𝟙` would give exactly the k-rational point `[1:a]` — this is never done anywhere in the repo** (all uses are at `A = X.presheaf.stalk x`: `RationalToP1.lean:134,150,154`).
- `AlgebraicJacobian/Curve/P1Points.lean:205` `fromSpecChart_structureMap` (it is a k-morphism); `:213` `SpecMap_fromSpecChart` (naturality in `A`); `:250` `fromSpecChart_units` — the gluing identity `[1:u] = [u⁻¹:1]` for `u : Aˣ` (note: the module docstring at `:20` calls it `fromSpecChart_isUnit`, stale name); `:300` `fromSpecChart_base_genericPoint`.

*Topology of `ℙ¹` (abstract points, no rationality):*
- `AlgebraicJacobian/Curve/P1Points.lean:120` — `instance : IrreducibleSpace (P1 k)`.
- `:139` `chartι_base_genericPoint`; `:145` `exists_ne_genericPoint` (a point ≠ generic, via a prime of `k[t]`); `:157` `specializes_eq_genericPoint_or_eq` (height one); `:169` `isClosed_singleton_of_ne_genericPoint`; `:174` `instance : (P1 k).IsSeparated`.
- `:64,73,79` — `isPrincipalIdealRing_chartSections`, `isDomain_chartSections`, `isDedekindDomain_chartSections`.

*Which points lie in `chartOpen k 0` / `chartOpen k 1`:*
- `AlgebraicJacobian/Curve/P1.lean:224` `chartOpen_sup : chartOpen k 0 ⊔ chartOpen k 1 = ⊤`; `:233` `chartOpen_inf = Proj.basicOpen 𝒜 (X 0 * X 1)`; `:245` `opensRange_chartι`.
- `AlgebraicJacobian/Curve/P1Charts.lean:193,196` `overlap_le_left` / `overlap_le_right`; `:199` `isAffineOpen_overlap`.
- `AlgebraicJacobian/Curve/P1Points.lean:90` — `exists_mem_chartOpen_zero_of_isOpen`: every nonempty open meets `D₊(X₀)`.
- **`AlgebraicJacobian/RiemannRoch/FLVClass.lean:132`** — `exists_mem_chartOpen_zero_notMem_one (k) [Field k] : ∃ z : P1 k, z ∈ P1.chartOpen k 0 ∧ z ∉ P1.chartOpen k 1`. Docstring calls it "the origin `[1 : 0]`", but the proof (`:146-158`) picks an *arbitrary maximal ideal* `M ⊇ span{chartCoord k 0 1}` via `Ideal.exists_le_maximal` — it is **not** a rational point and carries no residue-degree-1 information. Consumed at `FLVClass.lean:181` inside `zero_lt_deg_fiberWeilDivisor` (`:179`).
- `AlgebraicJacobian/Cohomology/FinitenessP1.lean:136` `P1.basicOpen_awayToSection_chartCoord`; `:128` `isLocalizationElem_X_eq` — the chart-membership/basic-open dictionary.

*Rational points elsewhere (not on `ℙ¹`):* `AlgebraicJacobian/Curve/SeparablyClosedFibre.lean:80` (`SeparablyClosed.ratPt` on `Spec (K[X])`, `:85` `mem_ratPt_basicOpen`, `:97` `exists_ratPt_mem_range` needs `[Infinite K]`); `AlgebraicJacobian/Curve/SeparablyClosedPoints.lean:62,135,157` (`exists_rationalPoint_mem`, `[IsSepClosed K]`); `AlgebraicJacobian/Curve/SepPointsDenseKit.lean:113,183,238`; `AlgebraicJacobian/Curve/SepPointsDense.lean:278`. These are points of the **curve**, never pushed to `ℙ¹`.

### (3) How `π : C.left ⟶ P1 k` is obtained

Chain (bottom → top):

1. **`AlgebraicJacobian/Curve/StalksDVR.lean:198-202`**
   `theorem SmoothOfRelativeDimension.exists_transcendental_functionField {K} [Field K] (f : X ⟶ Spec (.of K)) [SmoothOfRelativeDimension 1 f] [IsIntegral X] : ∃ f₀ : X.functionField, ∀ P : Polynomial K, P ≠ 0 → Polynomial.eval₂ (…).hom f₀ P ≠ 0`
   Hypotheses on `K`: **only `[Field K]`**. The element is the étale coordinate of a standard smooth chart.

2. **`AlgebraicJacobian/Curve/RationalToP1.lean:123-125`**
   `theorem exists_locallyQuasiFinite_isDominant_toP1 [IsIntegral X] [IsProper f] [SmoothOfRelativeDimension 1 f] : ∃ π : X ⟶ P1 k, LocallyQuasiFinite π ∧ IsDominant π ∧ π ≫ P1.structureMap k = f`
   Ambient: `{k : Type u} [Field k] {X : Scheme.{u}} (f : X ⟶ Spec (CommRingCat.of k))` (`:114`). **No hypothesis on `k` beyond `[Field k]`.**
   Proof: picks `f₀` from step 1 (`:128`); builds `φK := P1.fromSpecChart k (f.structureStalk ξ) 0 f₀` (`:134`); at each `x`, `ValuationRing.isInteger_or_isInteger` gives `a` with germ `f₀` (chart 0, `:150`) or `b` with germ `f₀⁻¹` (chart 1, `:154`), glued by `P1.fromSpecChart_units` (`:159`); spreads out via `Scheme.RationalMap.ofFunctionField` (`:163`) and `toPartialMap` (`:181`).
   Projection: `AlgebraicJacobian/Curve/RationalToP1.lean:275-277` `exists_locallyQuasiFinite_toP1` (drops `IsDominant`).

3. **`AlgebraicJacobian/Curve/MapToP1.lean:52-56`** `IsFinite.of_locallyQuasiFinite_of_comp` (ZMT cancellation); **`:67-71`** `isFinite_toP1_of_locallyQuasiFinite (f : X ⟶ Spec (.of k)) [IsProper f] (π : X ⟶ P1 k) [LocallyQuasiFinite π] (hπ : π ≫ P1.structureMap k = f) : IsFinite π`; **`:77-79`** `exists_isFinite_toP1_of_locallyQuasiFinite`.

4. **Existence statements** (ambient `{k : Type u} [Field k]` at `MapToP1.lean:58`; curve bundle at `MapToP1.lean:83-84`: `{C : Over (Spec (.of k))} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`):
   - `AlgebraicJacobian/Curve/MapToP1.lean:107-109`
     `theorem exists_isFinite_toP1 : ∃ π : C.left ⟶ P1 k, IsFinite π ∧ π ≫ P1.structureMap k = C.hom`
   - `AlgebraicJacobian/Curve/MapToP1.lean:125-129`
     `theorem exists_isFinite_isDominant_toP1 : ∃ π : C.left ⟶ P1 k, IsFinite π ∧ IsDominant π ∧ π ≫ P1.structureMap k = C.hom`
   `IsIntegral C.left` is supplied by `AlgebraicJacobian/Curve/Basic.lean:69-73` (`isIntegral_left_of_geometricallyReduced`), with `GeometricallyReduced` from smoothness (`AlgebraicJacobian/Curve/GeometricallyReduced.lean:130,140`). **No `IsAlgClosed`/`Infinite`/`IsSepClosed`/`PerfectField` anywhere on this route.**

5. **Downstream bookkeeping** (only needs `π` finite/affine, not its construction): `MapToP1.lean:144` `isAffineOpen_preimage_chartOpen`, `:149` `preimage_chartOpen_sup`, `:161` `finite_app_chartOpen`, `:168` `finite_app_overlap`.

**Freedom in choosing π:** the existentials expose **none**. `f₀` is consumed internally at `RationalToP1.lean:128`; there is no `π`-from-given-`f₀` API (no lemma takes a transcendental element as a parameter). To gain freedom you would have to either (a) refactor `exists_locallyQuasiFinite_isDominant_toP1` to take `f₀` (and its transcendence) as an argument — the proof body is already parametric in `f₀`, so this is a mechanical generalization; or (b) post-compose with a `P1 k ⟶ P1 k` coordinate change, **which does not exist** (see §1) and would have to be built from `Proj.map` + a `GradedAlgHom`. Note post-composition also requires re-proving `π' ≫ structureMap = C.hom` (the automorphism must be over `k`) and preservation of `IsFinite`/`IsDominant`.

Consumers requiring the map as an explicit hypothesis: `AlgebraicJacobian/RiemannRoch/FLVClass.lean:179,363`, `FLVVanishing.lean:304`, `W6Full.lean:93`, `WindowLedger.lean:101`, `UniformVanishing.lean:74`, `PFib.lean:61`, `CarveDegreePinch.lean:332`, `Picard/DivSchemeHighWindowPencilTheta.lean:88`. The FLV-4 docstring `FLVClass.lean:54-64` explicitly records that dominance discharge for the constructed `π` was deferred (now solved by `exists_isFinite_isDominant_toP1`).

### (4) Base-field hypotheses stronger than `[Field k]` in `Picard/` and `RiemannRoch/` — **NONE**

Exhaustive check: enumerating every typeclass head applied to `k` across all 459 files of `AlgebraicJacobian/Picard/` + `AlgebraicJacobian/RiemannRoch/` yields only `Field` (510×), `Algebra`, `Module`, `Module.Finite`, `IsScalarTower`, `SmoothOfRelativeDimension`, `QuasiCompact`, `LocallyOfFiniteType`, `Module.Projective`, `Module.Flat`, `CommRing`. Greps for `IsAlgClosed`, `[Infinite`, `IsSepClosed`, `Fintype k`, `Finite k`, `PerfectField`, `CharZero`, `ExpChar`, `AlgebraicClosure`, `SeparableClosure` return **zero** hits in these two directories.

Nearest-neighbour conditions, all on *extensions* `k → K` or `K → L` and never on `k` itself:
- `AlgebraicJacobian/Picard/PicRepColimitResidual.lean:90,95` (`FiniteDimensional k L`), `:99,115,125,132,143` (`[Algebra.IsAlgebraic k K]`), `:152-153` (`[Algebra.IsSeparable k K]`)
- `AlgebraicJacobian/Picard/PicRepColimitMountain.lean:83,169,175,235` (`[Algebra.IsAlgebraic k K]`)
- `AlgebraicJacobian/Picard/DegreeZero.lean:92,94,141,143,275,285` (`[Module.Finite K L] [Algebra.IsSeparable K L]`)
- `AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean:161` (`[Algebra.IsSeparable L L']`, residue-field extension)
- `AlgebraicJacobian/Picard/SectionsToDivisors.lean:155,171` (`[IsNoetherianRing k]` — here `k` is a *base ring* variable, not the field)
- `AlgebraicJacobian/RiemannRoch/DegreePullbackDictionary.lean:253` (uses `Algebra.IsAlgebraic.finrank_of_isFractionRing`, derived not assumed)
- `AlgebraicJacobian/RiemannRoch/ChiSlice.lean:54-56` (`FiniteDimensional K V` for vector spaces)

**Stronger field hypotheses do exist, but exclusively outside `Picard/` and `RiemannRoch/`:**
- `[IsAlgClosed]`: `AbelianVariety/Rigidity.lean:151,172`; `AbelianVariety/RigidityCorollaries.lean:55`; `Albanese/Thm32RationalMapExtension.lean:123,151,201,265`; `Albanese/CodimOneStalkRegularity.lean:97,114,143`; `Albanese/Milne33RowSection.lean:69`; `Albanese/Milne33Transport.lean:258`; `Albanese/CodimOneSmoothReduced.lean:265,304,341,384`; `Albanese/CodimOneMilne31.lean:122,230`
- `[IsSepClosed]`: `Curve/SeparablyClosedFibre.lean:61,121,137`; `Curve/SeparablyClosedPoints.lean:63,135,157`; `Curve/SepPointsDense.lean:278`
- `[Infinite K]`: `Curve/SeparablyClosedFibre.lean:97` (derived from `IsSepClosed` by the instance at `:61-62`)
- `[PerfectField k]`: `Algebra/SmoothPrimeRegularity.lean:93,247`
