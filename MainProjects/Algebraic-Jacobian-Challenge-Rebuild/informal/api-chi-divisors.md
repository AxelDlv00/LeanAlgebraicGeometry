# API map (recon dump, 2026-07-14) — HModule cohomology carrier, LES pieces, alt-sum, skyscraper, finiteness

*Machine-extracted verbatim signatures for the G8+G9 brick (spec-chi-g8-g9.md). Produced by read-only recon agents; signatures copied from source. Trust source over notes on any conflict.*

## Conventions in force

BASE FIELD K vs k: In all four RiemannRoch target files (ClosedPoint, ResidueDegree, Divisor, PrincipalDivisor) and DivisorSheaf, the base field of the curve bundle is named `K`. The lowercase `k` appears ONLY in the imported infrastructure `Cohomology/ModuleKSheaf.lean` (e.g. `Scheme.overAlgebraMap` uses `variable (k : Type u) [CommRing k] ...`); those generic defs are instantiated with `K` in the RiemannRoch layer. There is no distinct second field in the target files — K IS the base field.

TYPECLASS ON K — NOT UNIFORM: `[Field K]` in ClosedPoint's DVR/Order sections, in ResidueDegree, in PrincipalDivisor, and in DivisorSheaf. BUT `[CommRing K]` (weaker) in ClosedPoint's ResidueDegree section (residueDeg, residueOverAlgebraMap, residueFieldOverModule) and in Divisor.lean's Degree section (deg and friends). So CurveDivisor.deg and residueDeg are defined for any CommRing base; positivity/finiteness (residueDeg_pos/finite) need Field.

K/X EXPLICIT vs IMPLICIT — differs by file/section: (a) CurveDivisor def takes X EXPLICIT, only `[IsIntegral X]`. (b) In ClosedPoint ResidueDegree section and Divisor Degree section, K is EXPLICIT (and in residueDeg/residueOverAlgebraMap X is EXPLICIT too). (c) In ClosedPoint DVR/Order, ResidueDegree finiteness, PrincipalDivisor, K and X are IMPLICIT (`{K}`, `{X}`). (d) In DivisorSheaf `namespace Scheme`, K is EXPLICIT `(K : Type u) [Field K]` with X implicit.

WHAT CARRIES THE CURVE — there is NO `IsCurveBundle` structure. The 'curve bundle' is a bare `X : Scheme.{u}` plus a stack of typeclass/hypothesis assumptions: always `[IsIntegral X]` (gives irreducible + reduced ⇒ generic point η, integral domain sections, a functionField K(X)); the base structure via either `[X.Over (Spec (CommRingCat.of K))]` (the `Over` typeclass, canonical morphism written `X ↘ Spec (CommRingCat.of K)`) or an EXPLICIT morphism argument `f : X ⟶ Spec (CommRingCat.of K)`; smoothness via `[SmoothOfRelativeDimension 1 f]` (or `[SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))]`); finite type via `[LocallyOfFiniteType f]`; and quasi-compactness via `[QuasiCompact f]`.

STRUCTURE-MORPHISM SPELLING — a genuine gotcha, it is INCONSISTENT across files: ClosedPoint.lean and PrincipalDivisor.lean take the structure morphism as an EXPLICIT term argument `f : X ⟶ Spec (CommRingCat.of K)` and write `[SmoothOfRelativeDimension 1 f]`, `Scheme.ord f hx`, `Scheme.divOf f g`. ResidueDegree.lean and DivisorSheaf.lean instead use the `Over`-instance canonical morphism `X ↘ Spec (CommRingCat.of K)` and write `[SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))]`, `Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx`. So the same `Scheme.ord`/`Scheme.residueDeg` are called with `f` in some files and `X ↘ …` in others.

CLOSED POINTS = NON-GENERIC POINTS: the recurring point subtype is `{x : X // x ≠ genericPoint X}`; `isClosed_singleton_of_ne_genericPoint` justifies calling these 'closed points'. CurveDivisor = `{x // x ≠ genericPoint X} →₀ ℤ`; single-point divisor = `Finsupp.single ⟨x,hx⟩ n`; addition/order are the inherited pointwise Finsupp structures.

VALUE MONOIDS & SIGN: `Scheme.ord` is `Valuation X.functionField (WithZero (Multiplicative ℤ))` (= ℤᵐ⁰), matching mathlib intValuation where a uniformizer maps to additive value −1. `Scheme.ordZ : K(X)ˣ →* Multiplicative ℤ` is the INVERTED units-extraction so `toAdd (ordZ π) = +1` (zeros positive, poles negative); `divOf f g x = toAdd (ordZ f hx g)`.

MODULE STRUCTURES via restriction of scalars (never global Algebra instances, to avoid overlap with `Scheme.overModule`): `Scheme.residueFieldOverModule` (Module K κ(x)) and `Scheme.functionFieldOverModule` (Module K K(X)), both `@[reducible]`, both activated via `attribute [local instance]` at the top of each file that needs finrank/submodules. residueDeg = `Module.finrank K (X.residueField x)`.

All files: `set_option autoImplicit false`, `universe u`, `namespace AlgebraicGeometry`. `open CategoryTheory Limits` (ClosedPoint, ResidueDegree, PrincipalDivisor, DivisorSheaf) / `open CategoryTheory` (Divisor). DivisorSheaf also opens `Opposite TopologicalSpace`.

## Warnings

1. `CurveDivisor` is a plain `def` (a type synonym for `{x // x ≠ genericPoint X} →₀ ℤ`), NOT a structure/abbrev. Consequently coercion to a function needs the raw Finsupp type: `divOf_apply` literally writes `@DFunLike.coe ({x : X // x ≠ genericPoint X} →₀ ℤ) _ _ _ (Scheme.divOf f g) ⟨x, hx⟩`. When you `Finsupp.ext`/`Finsupp.single`/`Finsupp.sum` on a `CurveDivisor` you may need to unfold the def or insert `letI D' : {x // …} →₀ ℤ := D` (as `divisorBound` does).

2. The structure morphism is passed EXPLICITLY as `f` in ClosedPoint.lean and PrincipalDivisor.lean, but via the `Over` typeclass `X ↘ Spec (CommRingCat.of K)` in ResidueDegree.lean and DivisorSheaf.lean. Do NOT assume a uniform `f`. `Scheme.ord`/`Scheme.ordZ`/`Scheme.divOf` take `f` as first explicit arg; `Scheme.residueDeg`/`Scheme.residueDeg_finite` do not (they read the `Over` instance).

3. `Scheme.residueDeg` takes K and X BOTH EXPLICIT with `[CommRing K]` only. `CurveDivisor.deg` takes K EXPLICIT `[CommRing K]`. But `Scheme.ord` / divOf / residueDeg_finite / residueDeg_pos take K (and usually X) IMPLICIT with `[Field K]`. Mixed explicitness — check per-decl.

4. Instance-argument requirements differ within the divisor pipeline: DVR/ord/residueDeg only need `[SmoothOfRelativeDimension 1 …] [IsIntegral X]`; residueDeg_finite/pos additionally need `[LocallyOfFiniteType …]`; and ordZ_support_finite / divOf / divOf_mul / divOf_one / divOf_apply need BOTH `[LocallyOfFiniteType f]` AND `[QuasiCompact f]`. QuasiCompact is required precisely for finite support of principal divisors (global Noetherian space), and is NOT needed for residueDeg finiteness. `residueDeg_finite` does NOT need QuasiCompact.

5. `Scheme.residueFieldOverModule` / `Scheme.functionFieldOverModule` are only LOCAL instances (`attribute [local instance]`). Outside these files the K-module structure on κ(x)/K(X) is not in scope unless you re-activate it; statements about `finrank K (X.residueField x)` or `Submodule K X.functionField` silently depend on it.

6. `g` in `divOf`/`ordZ`/`divOf_mul` is a UNIT of the function field: `X.functionFieldˣ` (Units), not a bare element. `boundedSections`/`mem_divisorSections` membership is stated for bare `g : X.functionField`.

7. `deg` uses `x.1` (the underlying point of the subtype) inside `residueDeg K x.1`; the Finsupp index is the subtype element.

8. `primeIdealOf_ne_bot` (ResidueDegree.lean:55) is `private` — not part of the public API, though its statement mirrors the ne-bot fact inside `IsAffineOpen.isDiscreteValuationRing_stalk`.

9. `Scheme.ord_eq_valuation` and `Scheme.divOf_apply` are proved by `rfl` — the definitional identities `ord = (stalkHeightOne X x).valuation` and `divOf f g ⟨x,hx⟩ = toAdd (ordZ f hx g)` hold definitionally, useful for rewriting.

10. This was READ-ONLY recon; no build was run, so signatures are transcribed verbatim from source but not machine-verified to elaborate.

## Declarations

### `AlgebraicGeometry.Scheme.CurveDivisor`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:40`

```lean
def CurveDivisor (X : Scheme.{u}) [IsIntegral X] : Type u :=
  {x : X // x ≠ genericPoint X} →₀ ℤ
```

The group of Weil divisors. Finsupp shape: a Finsupp from the point subtype `{x : X // x ≠ genericPoint X}` (non-generic = closed points) to `ℤ`. `X` is EXPLICIT; only class assumption is `[IsIntegral X]`. Independent of the base field. No `variable` line in force here (this is the opening decl of `namespace Scheme`). Type-in-Type: lands in `Type u`.

### `AlgebraicGeometry.Scheme.CurveDivisor.instAddCommGroup`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:47`

```lean
noncomputable instance : AddCommGroup X.CurveDivisor :=
  inferInstanceAs (AddCommGroup ({x : X // x ≠ genericPoint X} →₀ ℤ))
```

Inherited from `Finsupp`. In force: `variable {X : Scheme.{u}} [IsIntegral X]` (Divisor.lean:45). Addition/negation/zero are the pointwise Finsupp ones; `single`/`add` conventions are literally Finsupp's.

### `AlgebraicGeometry.Scheme.CurveDivisor.instPartialOrder`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:50`

```lean
instance : PartialOrder X.CurveDivisor :=
  inferInstanceAs (PartialOrder ({x : X // x ≠ genericPoint X} →₀ ℤ))
```

Pointwise (Finsupp) partial order — `D ≤ D'` iff `D x ≤ D' x` for all `x` (see `Finsupp.le_def` usage in DivisorSheaf.divisorBound_mono). In force: `variable {X : Scheme.{u}} [IsIntegral X]`.

### `AlgebraicGeometry.Scheme.CurveDivisor.deg`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:61`

```lean
noncomputable def deg (D : X.CurveDivisor) : ℤ :=
  D.sum fun x n => n * (X.residueDeg K x.1 : ℤ)
```

Full effective signature: `noncomputable def CurveDivisor.deg {X : Scheme.{u}} [IsIntegral X] (K : Type u) [CommRing K] [X.Over (Spec (CommRingCat.of K))] (D : X.CurveDivisor) : ℤ`. `K` is EXPLICIT here and only `[CommRing K]` (NOT Field). In force: `variable {X : Scheme.{u}} [IsIntegral X]` (l.45) and `variable (K : Type u) [CommRing K] [X.Over (Spec (CommRingCat.of K))]` (l.55), plus `attribute [local instance] Scheme.residueFieldOverModule` (l.57). Degree = residue-degree-weighted sum `∑ₓ Dₓ · [κ(x):K]`.

### `AlgebraicGeometry.Scheme.CurveDivisor.deg_zero`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:65`

```lean
@[simp]
theorem deg_zero : deg K (0 : X.CurveDivisor) = 0
```

Same variables in force as `deg` (K explicit, `[CommRing K]`, `[X.Over ...]`, `[IsIntegral X]`).

### `AlgebraicGeometry.Scheme.CurveDivisor.deg_add`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:70`

```lean
theorem deg_add (D D' : X.CurveDivisor) : deg K (D + D') = deg K D + deg K D'
```

Additivity. Effective: `theorem deg_add {X : Scheme.{u}} [IsIntegral X] (K : Type u) [CommRing K] [X.Over (Spec (CommRingCat.of K))] (D D' : X.CurveDivisor) : ...`.

### `AlgebraicGeometry.Scheme.CurveDivisor.deg_single`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:77`

```lean
theorem deg_single (x : {x : X // x ≠ genericPoint X}) (n : ℤ) :
    deg K (Finsupp.single x n : X.CurveDivisor) = n * (X.residueDeg K x.1 : ℤ)
```

Single-point value: `deg (n·x) = n · [κ(x):K]`. `single` here is `Finsupp.single` over the point subtype. Same variables in force as `deg`.

### `AlgebraicGeometry.Scheme.CurveDivisor.deg_neg`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:84`

```lean
theorem deg_neg (D : X.CurveDivisor) : deg K (-D) = -deg K D
```

The four deg lemmas are exactly: deg_zero, deg_add, deg_single, deg_neg (no deg_sub, no deg_smul in this file).

### `AlgebraicGeometry.Scheme.residueDeg`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:128`

```lean
noncomputable def Scheme.residueDeg (x : X) : ℕ :=
  Module.finrank K (X.residueField x)
```

Full effective signature: `noncomputable def Scheme.residueDeg (K : Type u) [CommRing K] (X : Scheme.{u}) [X.Over (Spec (CommRingCat.of K))] (x : X) : ℕ`. In section ResidueDegree with `variable (K : Type u) [CommRing K] (X : Scheme.{u}) [X.Over (Spec (CommRingCat.of K))]` (l.110) — K AND X both EXPLICIT, only `[CommRing K]`. `attribute [local instance] Scheme.residueFieldOverModule` (l.125) is active so `Module.finrank K` typechecks. The residue degree [κ(x):K].

### `AlgebraicGeometry.Scheme.residueOverAlgebraMap`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:115`

```lean
noncomputable def Scheme.residueOverAlgebraMap (x : X) : K →+* X.residueField x :=
  (X.residue x).hom.comp
    (((X.presheaf.germ ⊤ x trivial).hom).comp (X.overAlgebraMap K ⊤))
```

Effective: `... (K : Type u) [CommRing K] (X : Scheme.{u}) [X.Over (Spec (CommRingCat.of K))] (x : X) : K →+* X.residueField x`. The K-algebra structure map on κ(x) through the structure morphism: `K →+* Γ(X,⊤) →+* 𝒪_{X,x} →+* κ(x)`. Deliberately NOT a global `Algebra` instance (mirrors `Scheme.overModule`).

### `AlgebraicGeometry.Scheme.residueFieldOverModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:121`

```lean
@[reducible] noncomputable def Scheme.residueFieldOverModule (x : X) :
    Module K (X.residueField x) :=
  (X.residueOverAlgebraMap K x).toModule
```

Effective: `... (K : Type u) [CommRing K] (X : Scheme.{u}) [X.Over (Spec (CommRingCat.of K))] (x : X) : Module K (X.residueField x)`. The K-module structure on κ(x) by restriction of scalars along residueOverAlgebraMap. Made a LOCAL instance via `attribute [local instance] Scheme.residueFieldOverModule` in ClosedPoint.lean:125, ResidueDegree.lean:49, Divisor.lean:57. Activate before using residueDeg/finrank.

### `AlgebraicGeometry.Scheme.residueDeg_finite`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ResidueDegree.lean:71`

```lean
theorem Scheme.residueDeg_finite
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
    [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] {x : X} (hx : x ≠ genericPoint X) :
    Module.Finite K (X.residueField x)
```

Full effective: `theorem Scheme.residueDeg_finite {K : Type u} [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] {x : X} (hx : x ≠ genericPoint X) : Module.Finite K (X.residueField x)`. In force: `variable {K : Type u} [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]` (l.66) + `attribute [local instance] Scheme.residueFieldOverModule` (l.49). NOTE: K is `[Field K]` here (not just CommRing), K and X IMPLICIT. Uses the canonical `X ↘ Spec (CommRingCat.of K)` structure morphism (from `X.Over`), not an explicit `f`. This is the `moduleFinite`-style finiteness statement (`Module.Finite`, not a `finrank` inequality). Requires QuasiCompact? NO — residueDeg_finite needs `[LocallyOfFiniteType ...]` but NOT QuasiCompact (that's only needed for divisor support finiteness).

### `AlgebraicGeometry.Scheme.residueDeg_pos`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ResidueDegree.lean:154`

```lean
theorem Scheme.residueDeg_pos
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
    [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] {x : X} (hx : x ≠ genericPoint X) :
    0 < X.residueDeg K x
```

Full effective adds `{K : Type u} [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]` (l.66). `0 < X.residueDeg K x` i.e. `0 < finrank K κ(x)`. Same instance requirements as residueDeg_finite. Proof uses `Module.finrank_pos_iff_of_free`.

### `AlgebraicGeometry.primeIdealOf_ne_bot`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ResidueDegree.lean:55`

```lean
private theorem primeIdealOf_ne_bot {X : Scheme.{u}} [IsIntegral X] {V : X.Opens}
    (hV : IsAffineOpen V) [IsDomain Γ(X, V)] {x : X} (hx : x ∈ V) (hxg : x ≠ genericPoint X) :
    (hV.primeIdealOf ⟨x, hx⟩).asIdeal ≠ ⊥
```

PRIVATE helper (declared before the `variable {K...}` line, so fully self-contained binders). Nonzero-prime witness at a closed point of an affine domain chart.

### `AlgebraicGeometry.Scheme.ord`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:95`

```lean
noncomputable def Scheme.ord (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) :
    Valuation X.functionField (WithZero (Multiplicative ℤ))
```

Full effective: `noncomputable def Scheme.ord {K : Type u} [Field K] {X : Scheme.{u}} (f : X ⟶ Spec (CommRingCat.of K)) [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) : Valuation X.functionField (WithZero (Multiplicative ℤ))`. In section Order with `variable {K : Type u} [Field K] {X : Scheme.{u}}` (l.90). KEY: the structure morphism is an EXPLICIT argument `f : X ⟶ Spec (CommRingCat.of K)` here (contrast ResidueDegree/DivisorSheaf which use `X ↘ ...`). Value monoid is `ℤᵐ⁰ = WithZero (Multiplicative ℤ)`. Body = the HeightOneSpectrum valuation of the maximal ideal of the DVR stalk. `ord π` on a uniformizer has additive value -1 (mathlib intValuation sign convention).

### `AlgebraicGeometry.Scheme.ord_eq_valuation`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:79`

```lean
theorem Scheme.ord_eq_valuation (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) :
    letI := isDiscreteValuationRing_stalk f hx
    Scheme.ord f hx = (stalkHeightOne X x).valuation X.functionField
```

KEY ord lemma: `Scheme.ord` is DEFINITIONALLY (`:= rfl`) the adic valuation of the height-one prime `stalkHeightOne X x` = the maximal ideal of the DVR stalk. In force: `variable {K : Type u} [Field K] {X : Scheme.{u}}` (l.55). The `letI` supplies the DVR instance needed for `stalkHeightOne`.

### `AlgebraicGeometry.stalkHeightOne`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:71`

```lean
noncomputable def stalkHeightOne (X : Scheme.{u}) [IsIntegral X] (x : X)
    [IsDiscreteValuationRing (X.presheaf.stalk x)] :
    IsDedekindDomain.HeightOneSpectrum (X.presheaf.stalk x) where
  asIdeal := IsLocalRing.maximalIdeal (X.presheaf.stalk x)
  isPrime := (IsLocalRing.maximalIdeal.isMaximal (X.presheaf.stalk x)).isPrime
  ne_bot := IsDiscreteValuationRing.not_a_field (X.presheaf.stalk x)
```

The height-one prime (maximal ideal) of the DVR stalk whose adic valuation IS `Scheme.ord`. `X` explicit; needs `[IsDiscreteValuationRing (X.presheaf.stalk x)]` as an instance argument (supplied via `isDiscreteValuationRing_stalk`).

### `AlgebraicGeometry.Scheme.ord_eq_one_of_mem_basicOpen`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:88`

```lean
theorem Scheme.ord_eq_one_of_mem_basicOpen (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X)
    {U : X.Opens} (s : Γ(X, U)) (hη : genericPoint X ∈ U) (hx_mem : x ∈ X.basicOpen s) :
    Scheme.ord f hx ((X.presheaf.germ U (genericPoint X) hη).hom s) = 1
```

KEY: `ord = 1` (trivial valuation) at closed points where a representing section `s` is a unit (`x ∈ X.basicOpen s`). This is the engine behind finite support of `divOf`. In force: `variable {K : Type u} [Field K] {X : Scheme.{u}}`.

### `AlgebraicGeometry.Scheme.ordZ`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:62`

```lean
noncomputable def Scheme.ordZ (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) :
    X.functionFieldˣ →* Multiplicative ℤ :=
  invMonoidHom.comp
    (WithZero.unitsWithZeroEquiv.toMonoidHom.comp
      (Units.map (Scheme.ord f hx).toMonoidWithZeroHom.toMonoidHom))
```

The ℤ-valued classical order as a group hom `K(X)ˣ →* Multiplicative ℤ`. Full effective adds `{K : Type u} [Field K] {X : Scheme.{u}}` (l.55). Explicit `f`. SIGN CONVENTION: it INVERTS the units-extraction of `Scheme.ord`, so `toAdd (ordZ f hx π) = +1` on a uniformizer (zeros positive, poles negative). `divOf f g x = toAdd (ordZ f hx g)`.

### `AlgebraicGeometry.Scheme.ordZ_eq_one_iff`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:107`

```lean
theorem Scheme.ordZ_eq_one_iff (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X)
    (g : X.functionFieldˣ) :
    Scheme.ordZ f hx g = 1 ↔ Scheme.ord f hx (g : X.functionField) = 1
```

Bridges `ordZ` (Multiplicative ℤ) triviality and `ord` (ℤᵐ⁰) triviality. `variable {K : Type u} [Field K] {X : Scheme.{u}}`.

### `AlgebraicGeometry.Scheme.ordZ_support_finite`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:122`

```lean
theorem Scheme.ordZ_support_finite (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f]
    (g : X.functionFieldˣ) :
    {p : {x : X // x ≠ genericPoint X} | Scheme.ordZ f p.2 g ≠ 1}.Finite
```

The finite-support fact underpinning `divOf`. THIS is where BOTH `[LocallyOfFiniteType f]` AND `[QuasiCompact f]` first appear: LocallyOfFiniteType gives `IsLocallyNoetherian X`, QuasiCompact gives `CompactSpace X`, together `IsNoetherian X`. `variable {K : Type u} [Field K] {X : Scheme.{u}}`. Explicit `f`.

### `AlgebraicGeometry.Scheme.divOf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:150`

```lean
noncomputable def Scheme.divOf (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f]
    (g : X.functionFieldˣ) : X.CurveDivisor :=
  Finsupp.onFinset (Scheme.ordZ_support_finite f g).toFinset
    (fun p => Multiplicative.toAdd (Scheme.ordZ f p.2 g))
    (fun p hp => by
      rw [Set.Finite.mem_toFinset]
      exact fun he => hp (by rw [he, toAdd_one]))
```

THE principal divisor `div(g) = ∑ₓ ordₓ(g)·x`. Full effective: `noncomputable def Scheme.divOf {K : Type u} [Field K] {X : Scheme.{u}} (f : X ⟶ Spec (CommRingCat.of K)) [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f] (g : X.functionFieldˣ) : X.CurveDivisor`. HYPOTHESES (typeclasses): `[SmoothOfRelativeDimension 1 f]`, `[IsIntegral X]`, `[LocallyOfFiniteType f]`, `[QuasiCompact f]` — YES QuasiCompact IS required (needed for global Noetherian ⇒ finite support). Finite-support construction: `Finsupp.onFinset` over `ordZ_support_finite.toFinset`. `g` is a UNIT of the function field (`X.functionFieldˣ`). Explicit `f`.

### `AlgebraicGeometry.Scheme.divOf_apply`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:162`

```lean
theorem Scheme.divOf_apply (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f]
    (g : X.functionFieldˣ) {x : X} (hx : x ≠ genericPoint X) :
    @DFunLike.coe ({x : X // x ≠ genericPoint X} →₀ ℤ) _ _ _ (Scheme.divOf f g) ⟨x, hx⟩ =
      Multiplicative.toAdd (Scheme.ordZ f hx g)
```

Value of `divOf` at a closed point = classical order `toAdd (ordZ f hx g)`. Note the explicit `@DFunLike.coe` on the raw Finsupp type (CurveDivisor is a `def`, so coercion is spelled out). `:= rfl`.

### `AlgebraicGeometry.Scheme.divOf_mul`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:171`

```lean
theorem Scheme.divOf_mul (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f]
    (g g' : X.functionFieldˣ) :
    Scheme.divOf f (g * g') = Scheme.divOf f g + Scheme.divOf f g'
```

`div(g·g') = div(g) + div(g')`. Same four instance hypotheses as divOf. `variable {K : Type u} [Field K] {X : Scheme.{u}}`.

### `AlgebraicGeometry.Scheme.divOf_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:182`

```lean
theorem Scheme.divOf_one (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f] :
    Scheme.divOf f (1 : X.functionFieldˣ) = 0
```

`div(1) = 0`. Together with divOf_mul this makes divOf a monoid/group hom in spirit.

### `AlgebraicGeometry.IsAffineOpen.isDiscreteValuationRing_stalk`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:43`

```lean
theorem IsAffineOpen.isDiscreteValuationRing_stalk [IsIntegral X] {V : X.Opens}
    (hV : IsAffineOpen V) (hD : IsDedekindDomain Γ(X, V)) {x : X} (hx : x ∈ V)
    (hxg : x ≠ genericPoint X) :
    IsDiscreteValuationRing (X.presheaf.stalk x)
```

In section DVR, `variable {K : Type u} [Field K] {X : Scheme.{u}}` (K unused here). Localization of a Dedekind domain at a nonzero prime is a DVR.

### `AlgebraicGeometry.isDiscreteValuationRing_stalk`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:63`

```lean
theorem isDiscreteValuationRing_stalk (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) :
    IsDiscreteValuationRing (X.presheaf.stalk x)
```

The DVR-at-closed-point workhorse used everywhere (letI'd inside `Scheme.ord`, ordZ etc). Explicit `f`. `variable {K : Type u} [Field K] {X : Scheme.{u}}`.

### `AlgebraicGeometry.isDedekindDomain_stalk`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:71`

```lean
theorem isDedekindDomain_stalk (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) :
    IsDedekindDomain (X.presheaf.stalk x)
```

DVR ⇒ Dedekind. Explicit `f`.

### `AlgebraicGeometry.isClosed_singleton_of_ne_genericPoint`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:80`

```lean
theorem isClosed_singleton_of_ne_genericPoint (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) :
    IsClosed ({x} : Set X)
```

Justifies 'non-generic point = closed point', i.e. why CurveDivisor uses the subtype `{x // x ≠ genericPoint X}` as its 'closed points'. Explicit `f`.

### `AlgebraicGeometry.Scheme.ord_algebraMap_stalk_le_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:79`

```lean
lemma ord_algebraMap_stalk_le_one {x : X} (hx : x ≠ genericPoint X)
    (y : X.presheaf.stalk x) :
    Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx
        (algebraMap (X.presheaf.stalk x) X.functionField y) ≤ 1
```

KEY ord↔sheaf lemma. Effective binders from DivisorSheaf.lean:69-70: `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]` (K EXPLICIT, `[Field K]`), inside `namespace Scheme`. NOTE: uses `X ↘ Spec (CommRingCat.of K)` (canonical over-morphism), NOT explicit `f`. Integral elements have order ≤ 1 (no pole). This is 'the heart of the 𝒪(D)-submodule property'.

### `AlgebraicGeometry.Scheme.ord_functionFieldOverAlgebraMap_le_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:90`

```lean
lemma ord_functionFieldOverAlgebraMap_le_one {x : X} (hx : x ≠ genericPoint X) (r : K) :
    Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx (functionFieldOverAlgebraMap K X r) ≤ 1
```

Constants (image of K) have order ≤ 1. Same effective binders as ord_algebraMap_stalk_le_one (K explicit Field, uses `X ↘ ...`).

### `AlgebraicGeometry.Scheme.divisorBound`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:105`

```lean
noncomputable def divisorBound (D : X.CurveDivisor) {x : X} (hx : x ≠ genericPoint X) :
    WithZero (Multiplicative ℤ) :=
  letI D' : {x : X // x ≠ genericPoint X} →₀ ℤ := D
  ((Multiplicative.ofAdd (D' ⟨x, hx⟩) : Multiplicative ℤ) : WithZero (Multiplicative ℤ))
```

The ℤᵐ⁰ upper bound imposed by divisor `D` at `x`: `ofAdd (D x)`. Effective binders: `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over ...] [SmoothOfRelativeDimension 1 (X ↘ ...)] [IsIntegral X]`. Membership condition throughout DivisorSheaf is `Scheme.ord (X ↘ ...) hx g ≤ divisorBound D hx`.

### `AlgebraicGeometry.Scheme.boundedSections`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:122`

```lean
noncomputable def boundedSections (D : X.CurveDivisor) (U : X.Opens) :
    Submodule K X.functionField where
  carrier := {g | ∀ (x : X) (hx : x ≠ genericPoint X), x ∈ U →
    Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ divisorBound D hx}
  zero_mem' := ...
  add_mem' := ...
  smul_mem' := ...
```

The K-submodule of K(X) of functions whose pole order is ≤ D at every closed point of U. Membership predicate is literally the `ord ≤ divisorBound` condition. Effective binders K explicit `[Field K]`, uses `X ↘ ...`.

### `AlgebraicGeometry.Scheme.mem_boundedSections`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:138`

```lean
lemma mem_boundedSections {D : X.CurveDivisor} {U : X.Opens} {g : X.functionField} :
    g ∈ boundedSections K D U ↔ ∀ (x : X) (hx : x ≠ genericPoint X), x ∈ U →
      Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ divisorBound D hx
```

THE ord↔divisorSheaf membership lemma (`Iff.rfl`). g ∈ 𝒪(D) over U iff `ord_x g ≤ divisorBound D hx` for all closed x ∈ U.

### `AlgebraicGeometry.Scheme.mem_divisorSections_of_nonempty`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:173`

```lean
lemma mem_divisorSections_of_nonempty {D : X.CurveDivisor} {U : X.Opens}
    (hU : (U : Set X).Nonempty) {g : X.functionField} :
    g ∈ divisorSections K D U ↔ ∀ (x : X) (hx : x ≠ genericPoint X), x ∈ U →
      Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ divisorBound D hx
```

The sheaf-level ord↔membership statement (nonempty open). `divisorSections` is the sheaf-correct version guarding the empty open (⊥ ↦ 0). This is the public membership API for the sheaf 𝒪(D).

### `AlgebraicGeometry.Scheme.exists_stalk_of_ord_le_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:378`

```lean
lemma exists_stalk_of_ord_le_one {x : X} (hx : x ≠ genericPoint X) {g : X.functionField}
    (hg : Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ 1) :
    ∃ y : X.presheaf.stalk x, algebraMap (X.presheaf.stalk x) X.functionField y = g
```

Converse-direction ord↔integrality: `ord_x g ≤ 1` ⇒ g is in the image of the stalk 𝒪_{X,x}. Key for the `𝒪(0) ≅ 𝒪_X` identification. Effective binders K explicit `[Field K]`, uses `X ↘ ...`.

### `AlgebraicGeometry.Scheme.divisorSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:326`

```lean
noncomputable def divisorSheaf (D : X.CurveDivisor) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K) :=
  ⟨divisorPresheaf K D, isSheaf_divisorPresheaf K D⟩
```

The sheaf 𝒪(D) of K-modules whose sections are `divisorSections K D U` (functions with poles bounded by D). Effective binders K explicit `[Field K]`, `X ↘ ...`. `divisorSheaf_obj` (l.330) gives `.obj.obj (op U) = ModuleCat.of K (divisorSections K D U)`. This is the object the ord-membership lemmas describe.

### `AlgebraicGeometry.Scheme.functionFieldOverAlgebraMap`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:54`

```lean
noncomputable def Scheme.functionFieldOverAlgebraMap (K : Type u) [Field K] (X : Scheme.{u})
    [X.Over (Spec (CommRingCat.of K))] [IsIntegral X] : K →+* X.functionField :=
  (X.presheaf.germ ⊤ (genericPoint X) trivial).hom.comp (X.overAlgebraMap K ⊤)
```

Supporting: the K-algebra map into the function field `K →+* Γ(X,⊤) →+* K(X)` (germ at generic point). K and X both EXPLICIT, `[Field K]`. NOT a global Algebra instance; activated as local instance `Scheme.functionFieldOverModule` (l.60).

### `AlgebraicGeometry.Scheme.overAlgebraMap`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:193`

```lean
noncomputable def Scheme.overAlgebraMap (U : X.Opens) : k →+* Γ(X, U) :=
  ((Scheme.ΓSpecIso (.of k)).inv ≫ (X ↘ Spec (.of k)).appTop ≫
    X.presheaf.map (homOfLE le_top).op).hom
```

Supporting (imported). NOTE the base-ring convention here uses `k` not `K`: `variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]` (l.189). The section-level structure map `k →+* Γ(X,U)`. Used by residueOverAlgebraMap / functionFieldOverAlgebraMap with K substituted for k. `Scheme.overAlgebraMap_naturality` (l.197) is the res-compatibility lemma.

### `AlgebraicGeometry.SmoothOfRelativeDimension.exists_isDedekindDomain_section`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/StalksDVR.lean:153`

```lean
theorem SmoothOfRelativeDimension.exists_isDedekindDomain_section
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] (x : X) :
    ∃ V : X.Opens, IsAffineOpen V ∧ x ∈ V ∧ IsDedekindDomain Γ(X, V)
```

Supporting (imported). In section SmoothCurve: `variable {K : Type u} [Field K] (f : X ⟶ Spec (CommRingCat.of K))` (l.148). The Dedekind-chart existence used to build DVR stalks, residueDeg_finite, ord support finiteness. (X is from an outer `variable {X : Scheme.{u}}`.)

### `AlgebraicGeometry.SmoothOfRelativeDimension.specializes_eq_genericPoint_or_eq`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/StalksDVR.lean:184`

```lean
theorem SmoothOfRelativeDimension.specializes_eq_genericPoint_or_eq
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] {x y : X} (h : y ⤳ x) :
    y = genericPoint X ∨ y = x
```

Supporting (imported). Height-one specialization order; feeds isClosed_singleton and support-finiteness. `variable {K...} (f : X ⟶ Spec (CommRingCat.of K))`.

### `AlgebraicGeometry.Scheme.finite_of_isClosed_of_notMem_genericPoint`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/StalksDVR.lean:124`

```lean
theorem Scheme.finite_of_isClosed_of_notMem_genericPoint [IrreducibleSpace X]
    [TopologicalSpace.NoetherianSpace X]
    (hgen : ∀ x y : X, y ⤳ x → y = genericPoint X ∨ y = x) {Z : Set X} (hZ : IsClosed Z)
    (hξ : genericPoint X ∉ Z) : Z.Finite
```

Supporting (imported). Closed set avoiding η is finite on a Noetherian curve — used directly in `ordZ_support_finite`. Needs `[IrreducibleSpace X]` + `[NoetherianSpace X]`. In a `variable {X : Scheme.{u}}` context (no K).

