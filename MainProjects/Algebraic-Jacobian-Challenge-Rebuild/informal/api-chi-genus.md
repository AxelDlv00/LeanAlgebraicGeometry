# API map (recon dump, 2026-07-14) — genus / Challenge interface, moduleKSheaf consumers, Gamma(C,O), roadmap leaves

*Machine-extracted verbatim signatures for the G8+G9 brick (spec-chi-g8-g9.md). Produced by read-only recon agents; signatures copied from source. Trust source over notes on any conflict.*

## Conventions in force

UNIVERSE: everything is single-universe `u` (universe u; k/K : Type u, X : Scheme.{u}, ModuleCat.{u}). No universe bumps, so Module.finrank applies directly to HModule.

TWO NAMING/BASE-FIELD CONVENTIONS coexist: (1) Challenge.lean + Cohomology use `k : Type u` (lowercase); ModuleKSheaf/TwoCover/AffineVanishing take only `[CommRing k]` on the base and add Field downstream, while genus/finiteness take `[Field k]`. (2) RiemannRoch/* use `K : Type u [Field K]` (uppercase) and `[IsIntegral X]` for divisors.

C: In Challenge.lean, `C : Over (Spec (.of k))` is the BUNDLED curve (a scheme packaged with its structure morphism to Spec k as an Over-object); `C.left` is the underlying Scheme and `C.hom : C.left ⟶ Spec (.of k)` the structure morphism. The standing curve hypothesis bundle is `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (a 'smooth curve' = smooth relative dim 1, proper, geometrically irreducible over a field). GeometricallyReduced is a separate hypothesis, supplied downstream by 'smooth ⟹ geometrically reduced'. NOTE in `Sheaf.HModule` the letter `C` instead denotes a generic `[SmallCategory C]` site — do not confuse with the curve.

X: In the Cohomology and RiemannRoch layers the object is an UNBUNDLED `X : Scheme.{u}` carrying the TYPECLASS `[X.Over (Spec (.of k))]` (resp. `[X.Over (Spec (CommRingCat.of K))]`). This is exactly the form genus produces: `genus` unbundles via `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom`, so the finiteness instance `moduleFinite_hModule_one` is deliberately keyed on that identical `letI` spelling.

K vs k / .of vs CommRingCat.of: `Spec (.of k)` and `Spec (CommRingCat.of K)` are the same up to the abbreviation `.of` = `CommRingCat.of`.

MODULE STRUCTURE on sections: `Γ(X, U)` gets its k-module structure from `Scheme.overModule` (restriction of scalars along `Scheme.overAlgebraMap : k →+* Γ(X,U)`), which is a `@[reducible] noncomputable def`, NOT a global instance (to avoid overlap with mathlib's Algebra R Γ(Spec R, U)); it is turned on via `attribute [local instance] Scheme.overModule` or letI.

COHOMOLOGY: `Sheaf.HModule F n := Abelian.Ext (constModuleSheaf J R) F n`, a ModuleCat R-valued analogue of mathlib's AddCommGrp-valued Sheaf.H, chosen so Module.finrank applies. `Sheaf.HModule'` is the object-of-the-site (relative) variant used for local vanishing. Genus = `Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)`.

## Warnings

1. `horizon roadmap show` DOES NOT EXIST (only list/set/add/comment/remove). The roadmap items live as YAML at `.archon-horizon/roadmap/items/AJCR.w2-chi.ledger.yaml` and `...rr.yaml`. There is NO field literally named 'Detail'; the substantive prose is the `summary:` field. Reported VERBATIM below.

   AJCR.w2-chi.ledger — title: 'chi additivity along point twists'; status: pending; kind: proof; parent: AJCR.w2-chi. summary (verbatim): "G1-G8 of the recon gap list: closed-point valuation order and residue degree, the divisor sheaf O(D) with its local equations, the skyscraper with its adjunction-injectivity, the devissage sequence, and the six-term slice giving chi(O(D)) - chi(O(D-x)) = residueDeg x."

   AJCR.w2-chi.rr — title: 'Riemann-Roch-lite and h^0 bounds'; status: pending; kind: proof; parent: AJCR.w2-chi. summary (verbatim): "G8-G9: chi(O(D)) = 1 - g + deg D by induction along the ledger; h^0 positivity/vanishing bounds in large degree. Class-level base-change/normalisation (G10-G12) partially gated on Layer-2."

   Sibling AJCR.w2-chi.carrier is status: done ('Cohomology and divisor substrate (landed)'); parent AJCR.w2-chi is status: pending ('Wave 2b: Euler-characteristic ledger (Riemann-Roch-lite)').

2. NO chi / eulerChar / Euler-characteristic definition is landed anywhere in the project (grep for `def .*chi`, `eulerChar`, `def .*euler` returns nothing). The only genus/invariant def is `AlgebraicGeometry.genus` in Challenge.lean. The chi ledger and Riemann-Roch-lite are the PENDING work of AJCR.w2-chi.ledger/.rr; the substrate they will consume (CurveDivisor, deg, divisorSheaf O(D), divisorSheafZeroIso, residueDeg, skyscraper, devissage) is landed in RiemannRoch/*.

3. There is NO landed lemma connecting genus to the cokernel computation or to h^0. Specifically: (a) no `genus C = finrank k (H1Cok ...)` / `= corank` lemma — TwoCover.h1CokEquiv is the vehicle but the composite to `genus` is only stated in doc comments (TwoCover.lean:20-21), not as a theorem; (b) no combined `H⁰(C,𝒪) ≅ k` or `h0 = 1` statement — you must chain `Scheme.moduleKSheafHZero` (H⁰ ≅ Γ(X,⊤), ModuleKSheaf.lean:279) with `isIso_hom_appTop_of_geometricallyReduced` (k ≅ Γ, Sections.lean:161) yourself. The Γ(C,𝒪)≅k side is fully proved (no sorry); the h⁰-as-Ext side is proved as an equiv but not composed.

4. Challenge.lean is FROZEN (read-only, never edit). Its `genus` signature (binders, instance args, `noncomputable`, the `letI` body) must be matched EXACTLY by any downstream instance — `moduleFinite_hModule_one` demonstrates the required `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom` keying. The genus of Challenge.lean is the ONLY genus; the Cohomology `Scheme.subsingleton_moduleKSheaf_hModule_one` uses `[IsAffine X]` (affine vanishing) — do not mistake it for a curve statement.

5. TYPECLASS-FORM MISMATCH to watch: genus/Challenge use the bundled `C : Over (Spec (.of k))`; RiemannRoch/Cohomology consume the unbundled `X : Scheme.{u}` with `[X.Over (Spec (.of k))]`. Bridging requires `.ofHom C.hom` (as genus does) and, for RiemannRoch, additionally `[IsIntegral C.left]` (from geometrically-integral, via Curve/Basic.isIntegral_left_of_geometricallyReduced) since CurveDivisor/genericPoint need integrality.

6. AffineVanishing.lean file-top variable binders for `subsingleton_moduleKSheaf_hModule'_one` (k, X, U) were not read verbatim from the header; the signatures reported are the local `theorem`/`instance` lines, correct, but the exact in-force base-ring class (CommRing vs Field) on `k` at line 310 should be confirmed against lines ~40-60 of that file if load-bearing.

## Declarations

### `AlgebraicGeometry.genus`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:89`

```lean
noncomputable def genus (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] : ℕ :=
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)
```

THE FROZEN GENUS DEFINITION (item 1). Full body included (it is data, not a proof). In-force `variable {k : Type u} [Field k]` (line 57) is part of the effective signature; the file-level `variable {C ...}` with its three instances (lines 57-63) is shadowed by genus's own explicit `(C : Over (Spec (.of k)))` + 3 instance binders. Genus = finrank_k of H¹ of the structure sheaf viewed as a sheaf of k-modules: it re-bundles C.left as a scheme over Spec k via `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom`, forms `C.left.moduleKSheaf k` (the structure sheaf as ModuleCat k-valued sheaf on the small Zariski site), and takes `Sheaf.HModule _ 1` = Abelian.Ext from the constant sheaf, degree 1. This exact `letI` spelling is mirrored by the finiteness instance `moduleFinite_hModule_one`. Sorry-bearing declarations mentioning genus: `smoothOfRelativeDimension_genus` (Challenge.lean:112, the only sorry that references genus).

### `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:112`

```lean
instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom :=
  sorry
```

The one sorry-bearing frozen declaration that mentions `genus` (item 1). Uses in-force variable `{k : Type u} [Field k] {C : Over (Spec (.of k))} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (lines 57-63). States the Jacobian of C is smooth of relative dimension `genus C` over k.

### `AlgebraicGeometry.Curve`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:67`

```lean
structure Curve (k : Type u) [Field k] where
  /-- The underlying `k`-scheme. -/
  carrier : Over (Spec (.of k))
  [isProper : IsProper carrier.hom]
  [smoothOfRelativeDimension : SmoothOfRelativeDimension 1 carrier.hom]
  [geometricallyIrreducible : GeometricallyIrreducible carrier.hom]
```

The challenge-facing curve type (item 4). A `Curve k` bundles `carrier : Over (Spec (.of k))` (i.e. a scheme WITH a chosen structure morphism to Spec k, packaged as an Over-object) plus the three instance fields. `attribute [instance]` on all three fields (line 74). Category (Curve k) instance at line 76 with Hom X Y := X.carrier ⟶ Y.carrier. RELATIONSHIP TO RiemannRoch: Challenge/genus work with the BUNDLED `C : Over (Spec (.of k))`; genus unbundles to `C.left` with `.ofHom C.hom : C.left.Over (Spec (.of k))`. The RiemannRoch/Cohomology layers instead take an UNBUNDLED `X : Scheme.{u}` with the typeclass `[X.Over (Spec (CommRingCat.of K))]` — the same `.Over` typeclass form the genus `letI` produces.

### `AlgebraicGeometry.Scheme.moduleKSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:265`

```lean
noncomputable def Scheme.moduleKSheaf :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k) :=
  ⟨X.moduleKPresheaf k, X.isSheaf_moduleKPresheaf k⟩
```

ITEM 3: the structure module sheaf. Effective signature carries the in-force `variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]` (line 189) — so full form is `Scheme.moduleKSheaf (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))] : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k)`. NOTE base ring is only `[CommRing k]` here (Field is added downstream). Built from moduleKPresheaf (structure-sheaf sections Γ(X,U) with the k-action of Scheme.overModule) + sheaf condition. `attribute [local instance] Scheme.overModule` is active (line 218). Sections are DEFINITIONALLY `ModuleCat.of k Γ(X, U)` (moduleKSheaf_obj, rfl) and restriction maps are defeq to the structure sheaf's (moduleKSheaf_map_apply, rfl).

### `AlgebraicGeometry.Scheme.moduleKPresheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:226`

```lean
noncomputable def Scheme.moduleKPresheaf : X.Opensᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := ModuleCat.of k Γ(X, U.unop)
  map {U V} i := ModuleCat.ofHom
    { toFun := (X.presheaf.map i).hom
      map_add' := map_add _
      map_smul' := ... }
```

Underlying presheaf of moduleKSheaf. Same in-force variable `(k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]`. map_smul' proof body elided.

### `AlgebraicGeometry.Scheme.moduleKSheaf_obj`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:270`

```lean
@[simp]
lemma Scheme.moduleKSheaf_obj (U : X.Opens) :
    (X.moduleKSheaf k).obj.obj (op U) = ModuleCat.of k Γ(X, U) := rfl
```

Definitional (rfl) access to sections of the structure module sheaf. In-force variable as for moduleKSheaf.

### `AlgebraicGeometry.Scheme.moduleKSheafHZero`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:279`

```lean
noncomputable def Scheme.moduleKSheafHZero :
    Sheaf.HModule (X.moduleKSheaf k) 0 ≅ₗ[k] Γ(X, ⊤) :=
  Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens))
    (X.moduleKSheaf k)
```

ITEM 5 (the h⁰ side): H⁰ of the structure sheaf is Γ(X,⊤), k-LINEARLY. In-force variable `(k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]`. This is the genus-lane analogue of genus's degree-1 spelling but in degree 0. Composed with the Γ≅k results in Curve/Sections.lean it yields `H⁰(C,ᵒ) ≅ₗ[k] k` (i.e. h⁰=1) — but NO single combined `H⁰ ≅ k` / `h0 = 1` declaration is landed anywhere; you must chain moduleKSheafHZero with isIso_hom_appTop_of_geometricallyReduced yourself.

### `CategoryTheory.Sheaf.HModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:74`

```lean
noncomputable abbrev HModule (F : Sheaf J (ModuleCat.{u} R)) (n : ℕ) : Type u :=
  Abelian.Ext (constModuleSheaf J R) F n
```

The cohomology carrier used by genus. In-force: `variable {C : Type u} [SmallCategory C]` (line 57) [note: this `C` is a generic small category, NOT the curve], and (from line 61, then `variable {J R}` at line 69) `{J : GrothendieckTopology C} {R : Type u} [CommRing R] [HasSheafify J (ModuleCat.{u} R)]`. Definition: Ext-group from the constant sheaf `constModuleSheaf J R` to F in degree n. An `abbrev` so the whole mathlib Ext API applies. Carries a `Module R` instance; a `Type u` (no universe bump), so `Module.finrank` applies. `Subsingleton (HModule F (n+1))` when F is Injective (line 96).

### `CategoryTheory.Sheaf.constModuleSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:66`

```lean
noncomputable def constModuleSheaf : Sheaf J (ModuleCat.{u} R) :=
  (constantSheaf J (ModuleCat.{u} R)).obj (ModuleCat.of R R)
```

The constant sheaf of R-modules with value R; sheaf cohomology = Ext out of this. In-force `variable (J : GrothendieckTopology C) (R : Type u) [CommRing R] [HasSheafify J (ModuleCat.{u} R)]` (line 61) plus `{C : Type u} [SmallCategory C]`.

### `CategoryTheory.Sheaf.HModule.linearEquiv₀`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:152`

```lean
noncomputable def HModule.linearEquiv₀ (F : Sheaf J (ModuleCat.{u} R)) :
    HModule F 0 ≅ₗ[R] F.obj.obj (op T) :=
  (Abelian.Ext.linearEquiv₀ (R := R)).trans (constModuleSheafHomEquiv J hT F)
```

Degree-zero identification H⁰ ≅ₗ[R] global sections F(op T) over a terminal object T of the site. In-force: `{C}[SmallCategory C] {J}{R}[CommRing R][HasSheafify ...] {T : C} (hT : IsTerminal T)` (line 103), plus `variable (J)` reintroduced at line 149. Naturality lemmas at 167 (linearEquiv₀_naturality) and 173.

### `CategoryTheory.Sheaf.HModule.map`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:82`

```lean
noncomputable def map (f : F ⟶ G) (n : ℕ) : HModule F n →ₗ[R] HModule G n :=
  (Abelian.Ext.mk₀ f).postcompOfLinear R (constModuleSheaf J R) (add_zero n)
```

R-linear functoriality of HModule in the sheaf. In-force `variable {F G G' : Sheaf J (ModuleCat.{u} R)}` (line 79).

### `AlgebraicGeometry.Scheme.overAlgebraMap`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:193`

```lean
noncomputable def Scheme.overAlgebraMap (U : X.Opens) : k →+* Γ(X, U) :=
  ((Scheme.ΓSpecIso (.of k)).inv ≫ (X ↘ Spec (.of k)).appTop ≫
    X.presheaf.map (homOfLE le_top).op).hom
```

The k →+* Γ(X,U) structure map on sections. In-force `(k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]`. Underlies Scheme.overModule (the k-module structure on sections, line 215, `@[reducible] noncomputable def` — deliberately NOT a global instance; activate via `attribute [local instance] Scheme.overModule` or letI).

### `AlgebraicGeometry.bijective_appTop_of_isProper_of_geometricallyIntegral`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/Sections.lean:95`

```lean
theorem bijective_appTop_of_isProper_of_geometricallyIntegral
    {K : Type u} [Field K] {X : Scheme.{u}} (f : X ⟶ Spec (CommRingCat.of K))
    [IsProper f] [GeometricallyIntegral f] :
    Function.Bijective f.appTop
```

ITEM 5 (the Γ(C,ᵒ)≅k keystone, honest general form): for X proper + geometrically integral over field K, the structure map on global sections Γ(Spec K,⊤) → Γ(X,⊤) is BIJECTIVE, i.e. informally Γ(X,ᵒ_X)=K. Fully proved (no sorry). No `variable` in force at this point beyond `universe u` (the file-level `variable {k}[Field k]` appears only later, line 154).

### `AlgebraicGeometry.isIso_appTop_of_isProper_of_geometricallyIntegral`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/Sections.lean:147`

```lean
theorem isIso_appTop_of_isProper_of_geometricallyIntegral
    {K : Type u} [Field K] {X : Scheme.{u}} (f : X ⟶ Spec (CommRingCat.of K))
    [IsProper f] [GeometricallyIntegral f] :
    IsIso f.appTop
```

ITEM 5: instance-friendly IsIso form of the previous theorem. Proved.

### `AlgebraicGeometry.isIso_hom_appTop_of_geometricallyReduced`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/Sections.lean:161`

```lean
instance isIso_hom_appTop_of_geometricallyReduced (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom] :
    IsIso C.hom.appTop
```

ITEM 5: the BUNDLE instance form of Γ(C,ᵒ)≅k for the challenge curve. In-force `variable {k : Type u} [Field k]` (line 154). Takes the bundled `C : Over (Spec (CommRingCat.of k))` with IsProper + GeometricallyIrreducible + GeometricallyReduced (reducedness supplied downstream by smooth⇒geometrically reduced). Concludes IsIso C.hom.appTop, i.e. k ≅ Γ(C.left,⊤). Regression example at line 175 packages it as `CommRingCat.of k ≅ Γ(C.left, ⊤) := (Scheme.ΓSpecIso (CommRingCat.of k)).symm ≫≣ asIso C.hom.appTop`.

### `AlgebraicGeometry.moduleFinite_hModule_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/Finiteness.lean:388`

```lean
instance moduleFinite_hModule_one (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
    Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)
```

ITEM 2/finiteness backing genus: the instance making `genus` the finrank of an HONESTLY finite-dimensional space. In-force `variable {k : Type u} [Field k]` (line 367). Deliberately keyed on the SAME `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom` spelling as genus so instance resolution fires. `FiniteDimensional k (H¹ₖ(C,ᵒ_C))` is definitionally this. Proved (no sorry) via a finite map to ℙ¹ + two-lattice ladder. NO landed lemma yet states `genus C = corank(...)` or `genus C = finrank H1Cok` explicitly — TwoCover.h1CokEquiv is the vehicle but the composition to `genus` is not yet a named lemma.

### `AlgebraicGeometry.moduleFinite_hModule_one_of_isFinite_toP1`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/Finiteness.lean:374`

```lean
theorem moduleFinite_hModule_one_of_isFinite_toP1 {X : Scheme.{u}} [X.Over (Spec (.of k))]
    (π : X ⟶ P1 k) [IsFinite π] (hπ : π ≫ P1.structureMap k = X ↘ Spec (.of k)) :
    Module.Finite k (Sheaf.HModule (X.moduleKSheaf k) 1)
```

Conditional finiteness of H¹(X,ᵒ_X) given a finite k-morphism to ℙ¹. In-force `variable {k : Type u} [Field k]` (line 367). Uses UNBUNDLED X : Scheme with `[X.Over (Spec (.of k))]` typeclass. Proved.

### `AlgebraicGeometry.TwoCover.H1Cok`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:138`

```lean
noncomputable abbrev H1Cok : Type u :=
  Γ(X, U₀ ⊓ U₁) ⧸ LinearMap.range (diff k X U₀ U₁)
```

ITEM 2: the computational access point for genus — the H¹ cokernel carrier `Γ(U₀⊓U₁) / range(diff)`. In-force (namespace TwoCover) `variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]` (line 110) and `variable (U₀ U₁ : X.Opens)` (line 111); `attribute [local instance] Scheme.overModule` (line 113). Doc comment (lines 20-21) states the design intent: `genus C = finrank k H¹ₖ(C, ᵒ_C)` becomes the corank of an explicit map, via h1CokEquiv.

### `AlgebraicGeometry.TwoCover.h1CokEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:226`

```lean
noncomputable def h1CokEquiv :
    Sheaf.HModule (X.moduleKSheaf k) 1 ≅ₗ[k] H1Cok k X U₀ U₁ :=
  ...
```

ITEM 2: the two-affine-cover H¹ bridge — H¹ₖ(X,ᵒ) ≅ₗ[k] the cokernel H1Cok. In-force `variable (k)[CommRing k](X : Scheme.{u})[X.Over (Spec (.of k))] (U₀ U₁ : X.Opens)` PLUS the `Bridge`-section hypotheses `(hcov : U₀ ⊔ U₁ = ⊤) (hU₀ : IsAffineOpen U₀) (hU₁ : IsAffineOpen U₁)` (these appear as extra explicit args at use sites, e.g. `h1CokEquiv k X U₀ U₁ hcov hU₀ hU₁`). Compatibility: h1CokEquiv_delta (line 240), h1CokEquiv_symm_mk (line 269). This is the bridge feeding moduleFinite_hModule_one.

### `AlgebraicGeometry.TwoCover.diff`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:118`

```lean
noncomputable def diff : (Γ(X, U₀) × Γ(X, U₁)) →ₗ[k] Γ(X, U₀ ⊓ U₁) :=
  ((X.moduleKSheaf k).obj.map (homOfLE (inf_le_left : U₀ ⊓ U₁ ≤ U₀)).op).hom.comp
      (LinearMap.fst k _ _) -
    ((X.moduleKSheaf k).obj.map (homOfLE (inf_le_right : U₀ ⊓ U₁ ≤ U₁)).op).hom.comp
      (LinearMap.snd k _ _)
```

The restriction-difference Čech map whose cokernel is H1Cok. In-force TwoCover variables `(k)[CommRing k](X)[X.Over ...](U₀ U₁ : X.Opens)`.

### `AlgebraicGeometry.Scheme.twoCoverH1LinearEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:92`

```lean
noncomputable def Scheme.twoCoverH1LinearEquiv
    (F : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k))
    (hcov : U₀ ⊔ U₁ = ⊤)
    [Subsingleton (Sheaf.HModule' F U₀ 1)] [Subsingleton (Sheaf.HModule' F U₁ 1)] :
    Sheaf.HModule F 1 ≅ₗ[k]
      (F.obj.obj (op (U₀ ⊓ U₁)) ⧸
        LinearMap.range ((X.twoCoverSquare U₀ U₁ hcov).moduleDiff F))
```

General-coefficients Mayer-Vietoris H¹ computation. In-force (section GeneralCoefficients) `variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))] (U₀ U₁ : X.Opens)` (lines 85-86).

### `AlgebraicGeometry.IsAffineOpen.subsingleton_moduleKSheaf_hModule'_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:310`

```lean
theorem subsingleton_moduleKSheaf_hModule'_one (hU : IsAffineOpen U) :
    Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) U 1)
```

Serre affine vanishing on an affine open: H¹'(U) of the structure module sheaf is subsingleton. Feeds the Subsingleton hypotheses of h1CokEquiv/twoCoverH1LinearEquiv. In-force variables (namespace-level, `k : Type u` field/commring, X : Scheme with X.Over, U : X.Opens) — confirm exact binders at file top if needed.

### `AlgebraicGeometry.Scheme.subsingleton_moduleKSheaf_hModule_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:329`

```lean
instance Scheme.subsingleton_moduleKSheaf_hModule_one (X : Scheme.{u})
    [X.Over (Spec (.of k))] [IsAffine X] :
    Subsingleton (Sheaf.HModule (X.moduleKSheaf k) 1)
```

Serre affine vanishing globally: H¹(X,ᵒ)=0 for affine X over Spec k. In-force `k` (field/commring in scope).

### `AlgebraicGeometry.exists_isFinite_toP1`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/MapToP1.lean:102`

```lean
theorem exists_isFinite_toP1 :
    ∃ π : C.left ⟶ P1 k, IsFinite π ∧ π ≫ P1.structureMap k = C.hom
```

The keystone consumed by moduleFinite_hModule_one: existence of a finite k-morphism C ⟶ ℙ¹. In-force `variable {k : Type u} [Field k]` (line 53) AND `variable {C : Over (Spec (.of k))} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` (lines 78-79). Proved. `P1 k := Proj (homogeneousSubmodule (Fin 2) k)` (Curve/P1.lean:135); `P1.structureMap : P1 k ⟶ Spec (.of k)` (Curve/P1.lean:170).

### `AlgebraicGeometry.Scheme.divisorSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:326`

```lean
noncomputable def divisorSheaf (D : X.CurveDivisor) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K) :=
  ⟨divisorPresheaf K D, isSheaf_divisorPresheaf K D⟩
```

ITEM 4 (RiemannRoch stack): the sheaf ᵒ(D) of K-modules (rational functions with poles bounded by D). In-force `variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]` (line 69). NOTE the RiemannRoch typeclass convention: unbundled `X : Scheme.{u}` + `[X.Over (Spec (CommRingCat.of K))]` + `[Field K]`; and `X.CurveDivisor` requires `[IsIntegral X]` (Divisor.lean:45). This differs from Challenge's bundled `Over (Spec (.of k))`, but matches the `X.Over` typeclass form that genus's `letI` produces on `C.left`.

### `AlgebraicGeometry.Scheme.divisorSheafZeroIso`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheafZero.lean:285`

```lean
noncomputable def divisorSheafZeroIso :
    divisorSheaf K (0 : X.CurveDivisor) ≅ X.moduleKSheaf K :=
  (moduleKSheafDivisorSheafZeroIso K).symm
```

ITEM 2-adjacent (chi ledger anchor): ᵒ(0) ≅ the structure module sheaf X.moduleKSheaf K. In-force `variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]` (line 47) plus `[IsIntegral X]` needed for CurveDivisor. Doc calls this 'the keystone identifying χ(ᵒ(0)) with χ(ᵒ)'. Companion moduleKSheafDivisorSheafZeroIso (line 278) is the reverse. This links O(D) cohomology to the same moduleKSheaf that genus uses.

### `AlgebraicGeometry.Scheme.CurveDivisor`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:40`

```lean
def CurveDivisor (X : Scheme.{u}) [IsIntegral X] : Type u :=
  {x : X // x ≠ genericPoint X} →₀ ℤ
```

Weil divisor on the curve: finitely-supported ℤ-function on non-generic (closed) points. Requires `[IsIntegral X]`. Carries Finsupp AddCommGroup + pointwise PartialOrder. Independent of base field. `CurveDivisor.deg` (line 61, `noncomputable def deg (D : X.CurveDivisor) : ℤ := D.sum fun x n => n * (X.residueDeg K x.1 : ℤ)`) needs `variable (K : Type u) [CommRing K] [X.Over (Spec (CommRingCat.of K))]` (line 55). This is the divisor substrate for the pending chi ledger / Riemann-Roch-lite.

