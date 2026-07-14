# API map (recon dump, 2026-07-14) — divisorSheaf, divisorSheafZeroIso, devissageSES, jump module, mulEquivDivisorSheaf

*Machine-extracted verbatim signatures for the G8+G9 brick (spec-chi-g8-g9.md). Produced by read-only recon agents; signatures copied from source. Trust source over notes on any conflict.*

## Conventions in force

SHARED SETUP (\"the curve bundle\"): X : Scheme.{u} that is [IsIntegral X] and [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] over a base field, with [X.Over (Spec (CommRingCat.of K))]. The base is K : Type u [Field K] in ALL six target files EXCEPT Skyscraper.lean which uses [CommRing K] and takes K IMPLICITLY. The structure morphism is written `X ↘ Spec (CommRingCat.of K)` and is passed explicitly to Scheme.ord/ordZ/divOf. SITE: `Opens.grothendieckTopology (X : TopCat)` (small Zariski site). TARGET CATEGORY: `ModuleCat.{u} K`. Sheaves live in `Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K)`.\n\nK: base field (explicit, FIRST argument of nearly every def: divisorSheaf K D, divisorSheafLE K h, devissageπ K hx D, jumpModule K hx D, mulEquivDivisorSheaf K g D). EXCEPTION 1: in Devissage.lean between `variable {K}` (line 156) and `variable (K)` (line 184) K is implicit — affects skyModule_obj_of_mem', skyModule_map_eq, skyModule_obj_subsingleton. EXCEPTION 2: Skyscraper.lean K is `{K}` implicit throughout.\n\nx: a point of X used as a CLOSED point; \"closed point\" is encoded as the hypothesis `hx : x ≠ genericPoint X` (non-generic point of an irreducible curve). η = genericPoint X. There is no separate IsClosedPoint typeclass.\n\nD, D': X.CurveDivisor = `{x : X // x ≠ genericPoint X} →₀ ℤ` (Weil divisors), pointwise PartialOrder. CurveDivisor is a `def` wrapper hiding FunLike/Sub; use `toFinsupp D` (Devissage.lean:67) and `coeffAt hx D` (:70) to read coefficients. n : ℤ used as a one-point valuation bound in pointLattice K hx n.\n\nORDER / ℤᵐ⁰: `Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx : Valuation X.functionField (WithZero (Multiplicative ℤ))` is the DVR valuation at x, landing in ℤᵐ⁰ = WithZero (Multiplicative ℤ). `Scheme.ordZ` is the classical ℤ-valued order (via Multiplicative.toAdd of the inverse). SIGN CONVENTION: pole order of g bounded by D ⟺ ord_x g ≤ divisorBound D hx = ofAdd(D x); a uniformizer has ord = ofAdd(−1) < 1; g=0 has ord 0=⊥; D=0 gives bound ≤ 1 = \"integral at x\" (this is what makes 𝒪(0)=𝒪_X). Larger divisor ⇒ larger allowed pole ⇒ 𝒪(D)⊆𝒪(D') for D≤D'.\n\nK-MODULE STRUCTURES are sealed reducible local instances, NEVER global Algebra instances, activated per-file via `attribute [local instance]`: `Scheme.functionFieldOverModule` (on K(X)=X.functionField, hence on pointLattice/divisorSections/jumpModule), `Scheme.overModule` (on Γ(X,U)), `Scheme.residueFieldOverModule` (on κ(x)=X.residueField x). finrank/Module.Finite are always over K.\n\nSTRUCTURE SHEAF: `X.moduleKSheaf K` (Cohomology/ModuleKSheaf.lean:265) = 𝒪_X as a sheaf of K-modules; underlying `X.moduleKPresheaf K` (:226). residueDeg K x = Module.finrank K (X.residueField x) = [κ(x):K] (ClosedPoint.lean:128).\n\nDÉVISSAGE SHAPE (definitive): devissageSES = ShortComplex.mk (divisorSheafLE …) (devissageπ …), i.e. `0 ⟶ 𝒪(D − x) ⟶ 𝒪(D) ⟶ skyModule x (jumpModule K hx D) ⟶ 0`. The twist is D − x (subtract the point; devissageDivisor = toFinsupp D − single ⟨x,hx⟩ 1). mulEquiv twist is D − div g (subtract the principal divisor). Both are subtractions.\n\nCONSTRUCTION IDIOM: every sheaf morphism/iso is built at presheaf level then lifted through `(fullyFaithfulSheafToPresheaf _ _).preimage` / `.preimageIso`; behaviour on nonempty opens is a real map, on the empty open both sides are subsingleton/terminal (the ⊥-guard forced by the sheaf condition).

## Warnings

1. ARGUMENT ORDER: K is explicit and comes FIRST in the target-file API (Field K). But in Skyscraper.lean K is IMPLICIT with only [CommRing K] — skyModule/skyModuleGammaEquiv/skyModule_subsingleton_hModule_one take (x : X) (M : ModuleCat.{u} K) with K inferred. Also inside Devissage.lean lines 156–184, K is temporarily implicit (`variable {K}`).\n\n2. HYPOTHESIS BUDGET differs across the SES certificates: `devissageSES_mono_f` and `devissageSES_exact` need NO QuasiCompact. `devissageSES_epi_g` and the packaged `devissageSES_shortExact` REQUIRE `[QuasiCompact (X ↘ Spec (CommRingCat.of K))]`. `finrank_jumpModule`/`moduleFinite_jumpModule` require `[LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]`. `mulEquivDivisorSheaf` requires BOTH LocallyOfFiniteType AND QuasiCompact (needed for divOf to exist).\n\n3. DIRECTION of divisorSheafZeroIso is `divisorSheaf K 0 ≅ X.moduleKSheaf K` (𝒪(0) ⟶ 𝒪_X direction of the iso object). The reverse-named `moduleKSheafDivisorSheafZeroIso` is `X.moduleKSheaf K ≅ divisorSheaf K 0`. Pick by which way you need the forward map.\n\n4. THIRD TERM of the SES: `(devissageSES K hx D).g = devissageπ K hx D : divisorSheaf K D ⟶ skyModule x (jumpModule K hx D)`. To compute its cohomology use the Skyscraper package with M := jumpModule K hx D and point x: H⁰ via `skyModuleGammaEquiv x (jumpModule K hx D)` (≃ₗ[K] jumpModule, then jumpEquivResidueField to κ(x), then finrank_jumpModule ⇒ dim = residueDeg K x); H¹ = 0 via the instance `skyModule_subsingleton_hModule_one`.\n\n5. finrank_jumpModule is EXACTLY `Module.finrank K (jumpModule K hx D) = X.residueDeg K x` — finrank over the BASE FIELD K (not over κ(x) or the stalk), and residueDeg = [κ(x):K].\n\n6. CurveDivisor is a `def` (opaque wrapper over Finsupp) — you cannot directly apply/subtract a CurveDivisor; go through `toFinsupp`/`coeffAt`. Coefficient access on divOf uses `@DFunLike.coe … ⟨x,hx⟩` (see Scheme.divOf_apply).\n\n7. divisorSheaf and all its morphisms are built via the presheaf then `fullyFaithfulSheafToPresheaf.preimage`; `.hom` of these equals the presheaf map only through the seam lemmas (`divisorSheafLE_hom`, `devissageπ_hom`, `divisorSheafLE_app_hom_apply`). Don't expect defeq to the raw presheaf app.\n\n8. The `divisorBound`/`pointLattice` bounds use ℤᵐ⁰ multiplicative order (ofAdd), where `≤ 1` means integral and `< 1` (i.e. `≤ ofAdd(−1)`) means vanishing residue — mind the multiplicative-vs-additive flip when reasoning about pole orders.\n\n9. Skyscraper sheaf value away from x is `terminal (ModuleCat.{u} K)` (the zero object), and sections there are Subsingleton — used pervasively to discharge the empty/away-from-x branches. Same ⊥-guard pattern governs divisorSections over the empty open (`divisorSections_of_empty`, subsingleton)."


## Declarations

### `AlgebraicGeometry.Scheme.divisorSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:326`

```lean
noncomputable def divisorSheaf (D : X.CurveDivisor) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K) :=
  ⟨divisorPresheaf K D, isSheaf_divisorPresheaf K D⟩
```

ITEM 1. In namespace AlgebraicGeometry.Scheme; variables in force (lines 69-70): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]`. So effective sig: `divisorSheaf (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] (D : X.CurveDivisor) : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K)`. K is EXPLICIT and FIRST. Site = small Zariski site `Opens.grothendieckTopology (X : TopCat)`; target category = `ModuleCat.{u} K`. Local instances `Scheme.functionFieldOverModule`, `Scheme.overModule` active (attribute [local instance], lines 43/65). Sections over U: rational functions in K(X) with pole order ≤ D at every closed point; guarded to ⊥ over the empty open. `@[simp] divisorSheaf_obj` (line 330): `(divisorSheaf K D).obj.obj (op U) = ModuleCat.of K (divisorSections K D U)`.

### `AlgebraicGeometry.Scheme.divisorSections`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:156`

```lean
noncomputable def divisorSections (D : X.CurveDivisor) (U : X.Opens) :
    Submodule K X.functionField :=
  ⨆ (_ : (U : Set X).Nonempty), boundedSections K D U
```

Sections of 𝒪(D) over U as a K-submodule of K(X). Equals boundedSections for nonempty U (`divisorSections_of_nonempty`, 160), and ⊥ for empty U (`@[simp] divisorSections_of_empty`, 164). Membership lemma `mem_divisorSections_of_nonempty` (173): g ∈ 𝒪(D)(U) ↔ ∀ x ≠ η, x ∈ U → Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ divisorBound D hx.

### `AlgebraicGeometry.Scheme.divisorBound`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:105`

```lean
noncomputable def divisorBound (D : X.CurveDivisor) {x : X} (hx : x ≠ genericPoint X) :
    WithZero (Multiplicative ℤ) :=
  letI D' : {x : X // x ≠ genericPoint X} →₀ ℤ := D
  ((Multiplicative.ofAdd (D' ⟨x, hx⟩) : Multiplicative ℤ) : WithZero (Multiplicative ℤ))
```

The valuation upper bound at x = ofAdd(D x) in ℤᵐ⁰. `@[simp] divisorBound_zero` (110): divisorBound 0 hx = 1. `divisorBound_mono` (114): D ≤ D' → divisorBound D hx ≤ divisorBound D' hx. Sign convention: pole order of g at x bounded by D ⟺ ord_x g ≤ divisorBound D hx; uniformizer has ord = ofAdd(-1) < 1.

### `AlgebraicGeometry.Scheme.divisorPresheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:221`

```lean
noncomputable def divisorPresheaf (D : X.CurveDivisor) : (X.Opens)ᵒᵖ ⥤ ModuleCat.{u} K where
  obj U := ModuleCat.of K (divisorSections K D U.unop)
  map {U V} i := ModuleCat.ofHom (divisorSectionsRes K D (leOfHom i.unop))
```

Underlying presheaf of divisorSheaf. Sheaf property is `isSheaf_divisorPresheaf` (line 277): `Presheaf.IsSheaf (Opens.grothendieckTopology (X : TopCat)) (divisorPresheaf K D)`.

### `AlgebraicGeometry.Scheme.divisorSections_mono`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:334`

```lean
lemma divisorSections_mono {D D' : X.CurveDivisor} (h : D ≤ D') (U : X.Opens) :
    divisorSections K D U ≤ divisorSections K D' U :=
  iSup_mono (fun _ => boundedSections_mono K h U)
```

ITEM 2 (submodule level). The submodule inclusion 𝒪(D)(U) ⊆ 𝒪(D')(U) from D ≤ D'.

### `AlgebraicGeometry.Scheme.divisorPresheafLE`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:339`

```lean
noncomputable def divisorPresheafLE {D D' : X.CurveDivisor} (h : D ≤ D') :
    divisorPresheaf K D ⟶ divisorPresheaf K D' where
  app U := ModuleCat.ofHom (Submodule.inclusion (divisorSections_mono K h U.unop))
```

ITEM 2 (presheaf level). The presheaf inclusion 𝒪(D) ↪ 𝒪(D') induced by D ≤ D', componentwise Submodule.inclusion. `divisorSheafLE_hom` (DevissageExact-adjacent, actually Devissage.lean line 327): (divisorSheafLE K h).hom = divisorPresheafLE K h.

### `AlgebraicGeometry.Scheme.divisorSheafLE`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:358`

```lean
noncomputable def divisorSheafLE {D D' : X.CurveDivisor} (h : D ≤ D') :
    divisorSheaf K D ⟶ divisorSheaf K D' :=
  (fullyFaithfulSheafToPresheaf _ _).preimage (divisorPresheafLE K h)
```

ITEM 2 (sheaf level). THE monotone inclusion morphism of sheaves 𝒪(D) ↪ 𝒪(D') for D ≤ D', obtained via fully faithful sheafToPresheaf.preimage. Full effective sig prepends variables (69-70): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]`.

### `AlgebraicGeometry.Scheme.divisorSheafLE_mono`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:362`

```lean
instance divisorSheafLE_mono {D D' : X.CurveDivisor} (h : D ≤ D') :
    Mono (divisorSheafLE K h) := by
```

ITEM 2 (Mono instance). Mono of divisorSheafLE, proved from injectivity of Submodule.inclusion componentwise + NatTrans.mono_of_mono_app + sheafToPresheaf.mono_of_mono_map. UNCONDITIONAL (no QuasiCompact needed). This is exactly the certificate reused as `devissageSES_mono_f`.

### `AlgebraicGeometry.Scheme.exists_stalk_of_ord_le_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean:378`

```lean
lemma exists_stalk_of_ord_le_one {x : X} (hx : x ≠ genericPoint X) {g : X.functionField}
    (hg : Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ 1) :
    ∃ y : X.presheaf.stalk x, algebraMap (X.presheaf.stalk x) X.functionField y = g := by
```

Key helper (ord ≤ 1 ⟺ integral at x) reused in JumpDimension (preimageStalk, baseHom) and DivisorSheafZero (exists_local_section). Adjacent: `ord_algebraMap_stalk_le_one` (79), `ord_functionFieldOverAlgebraMap_le_one` (90).

### `AlgebraicGeometry.Scheme.divisorSheafZeroIso`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheafZero.lean:285`

```lean
noncomputable def divisorSheafZeroIso :
    divisorSheaf K (0 : X.CurveDivisor) ≅ X.moduleKSheaf K :=
  (moduleKSheafDivisorSheafZeroIso K).symm
```

ITEM 3. Direction: 𝒪(0) ≅ 𝒪_X where 𝒪_X = X.moduleKSheaf K (structure sheaf as sheaf of K-modules, from Cohomology/ModuleKSheaf.lean line 265). In namespace Scheme; variables (47-48): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]`. The reverse iso is `moduleKSheafDivisorSheafZeroIso` (278): `X.moduleKSheaf K ≅ divisorSheaf K 0`. Section-wise map is s ↦ germ_η s (germ at generic point).

### `AlgebraicGeometry.Scheme.moduleKSheafDivisorSheafZeroIso`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DivisorSheafZero.lean:278`

```lean
noncomputable def moduleKSheafDivisorSheafZeroIso :
    X.moduleKSheaf K ≅ divisorSheaf K 0 :=
  (fullyFaithfulSheafToPresheaf _ _).preimageIso (moduleToDivisorZeroPresheafIso K)
```

Reverse direction of the ITEM 3 iso, built from the presheaf iso `moduleToDivisorZeroPresheafIso` (268: X.moduleKPresheaf K ≅ divisorPresheaf K 0), whose components are s ↦ germ_η s (`moduleToDivisorZeroPresheafApp`, 123).

### `AlgebraicGeometry.toFinsupp`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:67`

```lean
def toFinsupp (D : X.CurveDivisor) : {p : X // p ≠ genericPoint X} →₀ ℤ := D
```

Coercion re-exposing the Finsupp under CurveDivisor (the wrapper blocks FunLike/Sub). `coeffAt` (70): `def coeffAt : ℤ := toFinsupp D ⟨x, hx⟩` — the coefficient of D at x. Namespace AlgebraicGeometry (not Scheme). Variables in force (59-61): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)`. coeffAt's effective sig: `coeffAt (hx : x ≠ genericPoint X) (D : X.CurveDivisor) : ℤ` (K,X instances implicit but present).

### `AlgebraicGeometry.pointLattice`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:77`

```lean
noncomputable def pointLattice (n : ℤ) : Submodule K X.functionField where
  carrier := {g | Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤
    ((Multiplicative.ofAdd n : Multiplicative ℤ) : WithZero (Multiplicative ℤ))}
```

ITEM 5 (building block). One-point valuation lattice Lₙ = {g : K(X) | ord_x g ≤ ofAdd n}. Effective sig: `pointLattice (K : Type u) [Field K] ... (hx : x ≠ genericPoint X) (n : ℤ) : Submodule K X.functionField`. `mem_pointLattice` (94), `pointLattice_mono` (101). Referenced form `pointLattice K hx n`.

### `AlgebraicGeometry.jumpModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:115`

```lean
noncomputable def jumpModule : ModuleCat.{u} K :=
  ModuleCat.of K
    (pointLattice K hx (coeffAt hx D) ⧸
      (pointLattice K hx (coeffAt hx D - 1)).submoduleOf (pointLattice K hx (coeffAt hx D)))
```

ITEM 5. THE jump module J = 𝒪(D)ₓ / 𝒪(D−x)ₓ = pointLattice(D x) / pointLattice(D x − 1), the associated-graded piece of the valuation filtration at x. As a ModuleCat.{u} K. Effective sig prepends `(K : Type u) [Field K] {X} [..] {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)`. Referenced as `jumpModule K hx D`. This is the M appearing in the skyscraper third term `skyModule x (jumpModule K hx D)`.

### `AlgebraicGeometry.jumpProj`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:133`

```lean
noncomputable def jumpProj (U : X.Opens) (hxU : x ∈ U) :
    divisorSections K D U →ₗ[K] jumpModule K hx D :=
  (Submodule.mkQ ((pointLattice K hx (coeffAt hx D - 1)).submoduleOf
      (pointLattice K hx (coeffAt hx D)))).comp
    (Submodule.inclusion (divisorSections_le_pointLattice K hx D U hxU))
```

Section-wise projection 𝒪(D)(U) → J, g ↦ ⟦g⟧, for U ∋ x. `jumpProj_apply` (139), `jumpProj_eq_of_coe_eq` (147, depends only on the underlying rational function). Used to define the skyscraper morphism component `skyComponent`.

### `AlgebraicGeometry.devissageDivisor`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:281`

```lean
noncomputable def devissageDivisor : X.CurveDivisor :=
  toFinsupp D - Finsupp.single (⟨x, hx⟩ : {p : X // p ≠ genericPoint X}) 1
```

ITEM 4 (twist). D' = D − x: subtract the closed point x with multiplicity 1. `coeffAt_devissageDivisor` (290): coeffAt hx (D−x) = coeffAt hx D − 1. `devissageDivisor_le` (300): devissageDivisor hx D ≤ D. This confirms the SES uses the D−x twist (subtracting a point), NOT D+x.

### `AlgebraicGeometry.devissageπ`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:254`

```lean
noncomputable def devissageπ :
    divisorSheaf K D ⟶ skyModule x (jumpModule K hx D) :=
  (fullyFaithfulSheafToPresheaf _ _).preimage (devissagePresheafπ K hx D)
```

ITEM 4 / ITEM 7. The dévissage projection π : 𝒪(D) ⟶ sky_x J (the `g` map of devissageSES). Target is `skyModule x (jumpModule K hx D)` — skyscraper at point x with value M = jumpModule K hx D. Sends section g over U ∋ x to its jump class ⟦g⟧, transported through the sealed skyscraper eqToHom; 0 away from x. Underlying presheaf map `devissagePresheafπ` (224). Behaviour lemma `devissageπ_app_hom_apply_of_mem` (270).

### `AlgebraicGeometry.devissage_comp_eq_zero`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:344`

```lean
lemma devissage_comp_eq_zero :
    divisorSheafLE K (devissageDivisor_le hx D) ≫ devissageπ K hx D = 0 := by
```

The composite 𝒪(D−x) ↪ 𝒪(D) → sky_x J is zero (the zero-map certificate feeding ShortComplex.mk). A (D−x)-section has strictly smaller pole at x so its jump class vanishes.

### `AlgebraicGeometry.devissageSES`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:362`

```lean
noncomputable def devissageSES :
    ShortComplex (Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K)) :=
  ShortComplex.mk (divisorSheafLE K (devissageDivisor_le hx D)) (devissageπ K hx D)
    (devissage_comp_eq_zero K hx D)
```

ITEM 4. THE dévissage short complex, direction/shape: 0 ⟶ 𝒪(D − x) ⟶ 𝒪(D) ⟶ sky_x J ⟶ 0. Confirmed: .f = divisorSheafLE K (devissageDivisor_le hx D) : 𝒪(D−x) ↪ 𝒪(D); .g = devissageπ K hx D : 𝒪(D) → skyModule x (jumpModule K hx D). Twist convention = D−x (subtract the point x). NOT the 0→𝒪(D)→𝒪(D+x)→sky→0 shape. In namespace AlgebraicGeometry; effective sig prepends `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)`. Referenced `devissageSES K hx D`.

### `AlgebraicGeometry.devissageSES_mono_f`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Devissage.lean:369`

```lean
instance devissageSES_mono_f : Mono (devissageSES K hx D).f :=
  divisorSheafLE_mono K (devissageDivisor_le hx D)
```

ITEM 4 (left-exactness certificate). Mono of the inclusion .f; just reuses divisorSheafLE_mono. Unconditional.

### `AlgebraicGeometry.devissageSES_epi_g`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DevissageExact.lean:190`

```lean
instance devissageSES_epi_g [QuasiCompact (X ↘ Spec (CommRingCat.of K))] :
    Epi (devissageSES K hx D).g := by
```

ITEM 4 (right-exactness certificate). Epi of π; REQUIRES [QuasiCompact (X ↘ Spec (CommRingCat.of K))] (only place it enters, via finiteness of principal-divisor support ordZ_support_finite). Proved from local surjectivity `devissageπ_isLocallySurjective` (171). Variables in force (58-60) same as Devissage plus this section's local instance `locallyOfFiniteType_structureMorphism` (64).

### `AlgebraicGeometry.devissageSES_exact`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DevissageExact.lean:286`

```lean
theorem devissageSES_exact :
    (devissageSES K hx D).Exact := by
```

ITEM 4 (middle exactness). Exactness of the complex, reflected from sectionwise exactness `devissageSES_map_exact` (260) via sheafToPresheaf (creates limits) + evaluationJointlyReflectsLimits. Does NOT need QuasiCompact (mono of .f alone suffices for the kernel-fork argument).

### `AlgebraicGeometry.devissageSES_shortExact`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/DevissageExact.lean:316`

```lean
theorem devissageSES_shortExact [QuasiCompact (X ↘ Spec (CommRingCat.of K))] :
    (devissageSES K hx D).ShortExact where
  exact := devissageSES_exact K hx D
  mono_f := devissageSES_mono_f K hx D
  epi_g := devissageSES_epi_g K hx D
```

ITEM 4. THE short exact sequence 0 ⟶ 𝒪(D − x) ⟶ 𝒪(D) ⟶ sky_x J ⟶ 0 as ShortComplex.ShortExact. REQUIRES [QuasiCompact (X ↘ Spec (CommRingCat.of K))] (for epi_g). Packages exact + mono_f + epi_g. Full effective sig prepends `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)`.

### `AlgebraicGeometry.jumpEquivResidueField`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/JumpDimension.lean:269`

```lean
noncomputable def jumpEquivResidueField : jumpModule K hx D ≃ₗ[K] X.residueField x :=
  (Submodule.quotEquivOfEq _ _ (jumpToResidue_ker K hx D).symm).trans
    ((jumpToResidue K hx D).quotKerEquivOfSurjective (jumpToResidue_surjective K hx D))
```

ITEM 5. K-linear iso J ≃ₗ[K] κ(x) (residue field), by first-isomorphism theorem on jumpToResidue (247, the composite Lₐ → L₀ → κ(x) via shiftMap by a uniformizer power and the residue baseHom). Variables (81-83): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)`. Local instances functionFieldOverModule, residueFieldOverModule, overModule active (49-51).

### `AlgebraicGeometry.finrank_jumpModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/JumpDimension.lean:274`

```lean
theorem finrank_jumpModule [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] :
    Module.finrank K (jumpModule K hx D) = X.residueDeg K x :=
  (jumpEquivResidueField K hx D).finrank_eq
```

ITEM 5. EXACT statement: `Module.finrank K (jumpModule K hx D) = X.residueDeg K x`. finrank is over the BASE FIELD K. `X.residueDeg K x = Module.finrank K (X.residueField x) = [κ(x):K]` (ClosedPoint.lean line 128). REQUIRES [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]. This is the h⁰(sky)=residueDeg input. Companion `moduleFinite_jumpModule` (279): Module.Finite K (jumpModule K hx D) under the same hypothesis.

### `AlgebraicGeometry.moduleFinite_jumpModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/JumpDimension.lean:279`

```lean
theorem moduleFinite_jumpModule [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] :
    Module.Finite K (jumpModule K hx D) := by
```

ITEM 5 companion. jumpModule is a finite K-module (from residueDeg_finite via jumpEquivResidueField). Needed so finrank/χ are meaningful.

### `AlgebraicGeometry.jumpToResidue`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/JumpDimension.lean:247`

```lean
noncomputable def jumpToResidue :
    ↥(pointLattice K hx (coeffAt hx D)) →ₗ[K] X.residueField x :=
  (baseHom K hx).comp (shiftMap K hx (coeffAt hx D))
```

The surjection Lₐ ↠ κ(x) whose kernel is L₍ₐ₋₁₎ (`jumpToResidue_ker`, 255; `jumpToResidue_surjective`, 251), giving jumpEquivResidueField. Built from `shiftMap` (130, mult by uniformizer^a) and `baseHom` (187, L₀=𝒪ₓ → κ(x) residue map, kernel L₍₋₁₎ per `baseHom_ker` 221).

### `AlgebraicGeometry.Scheme.mulEquivDivisorSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/MulEquiv.lean:268`

```lean
noncomputable def mulEquivDivisorSheaf :
    divisorSheaf K D ≅ divisorSheaf K (D - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g) :=
  (fullyFaithfulSheafToPresheaf _ _).preimageIso (divisorMulPresheafIso K g D)
```

ITEM 6. EXACT statement: `divisorSheaf K D ≅ divisorSheaf K (D - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)`, i.e. 𝒪(D) ≅ 𝒪(D − div g). Twist direction = SUBTRACT divOf g (the principal divisor of the unit g). Section-wise map is multiplication by g (s ↦ g·s), inverse ×g⁻¹. In namespace Scheme; variables (52-56): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))] [QuasiCompact (X ↘ Spec (CommRingCat.of K))] (g : X.functionFieldˣ) (D : X.CurveDivisor)`. Requires BOTH LocallyOfFiniteType and QuasiCompact (for divOf to exist). g is a UNIT of the function field. `divisorVal_mulEquiv` (275): behaviour on section values = g·(value).

### `AlgebraicGeometry.Scheme.ord_val_eq`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/MulEquiv.lean:76`

```lean
theorem ord_val_eq {x : X} (hx : x ≠ genericPoint X) :
    Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx (g : X.functionField)
      = divisorBound (- Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g) hx := by
```

The single geometric bridge for mulEquivDivisorSheaf: ord_x g = divisorBound(−div g) hx. Confirms the sign/twist convention (a pole of order n, div(g) x = −n, contributes valuation ofAdd n). `mem_boundedSections_mul_iff` (119) is the engine: (g·h) ∈ 𝒪(D−div g)(U) ↔ h ∈ 𝒪(D)(U). `divisorBound_add` (102), `divisorBound_sub_divOf` (110).

### `AlgebraicGeometry.skyModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Skyscraper.lean:64`

```lean
def skyModule (x : X) (M : ModuleCat.{u} K) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K) :=
  skyscraperSheaf x M
```

ITEM 7. The skyscraper sheaf package. IMPORTANT: this file uses `variable {K : Type u} [CommRing K] {X : Scheme.{u}} [X.Over (Spec (.of K))]` (line 57) — K is IMPLICIT here and only [CommRing K] (not [Field K]). Realised as mathlib's skyscraperSheaf, kept opaque. In devissageSES the third term is `skyModule x (jumpModule K hx D)` — point = x, value M = jumpModule K hx D. Behaviour: `skyModule_obj_of_mem` (76): (skyModule x M).obj.obj (op U) = M for x ∈ U; `skyModule_obj_of_not_mem` (82): = terminal (zero) for x ∉ U.

### `AlgebraicGeometry.skyModuleGammaEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Skyscraper.lean:88`

```lean
def skyModuleGammaEquiv (x : X) (M : ModuleCat.{u} K) :
    Sheaf.HModule (skyModule x M) 0 ≃ₗ[K] M :=
  (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
      (isTerminalTop : IsTerminal (⊤ : X.Opens)) (skyModule x M)).trans
    (eqToIso (skyModule_obj_of_mem x M (Opens.mem_top x))).toLinearEquiv
```

ITEM 7 (H⁰). H⁰(X, skyModule x M) ≃ₗ[K] M. For the SES third term this gives H⁰(sky_x J) ≃ₗ[K] jumpModule K hx D, which composes with jumpEquivResidueField to κ(x) and finrank_jumpModule to give dim = residueDeg. `Sheaf.HModule (skyModule x M) 0` is the degree-0 sheaf cohomology (global sections over ⊤).

### `AlgebraicGeometry.skyModule_subsingleton_hModule_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Skyscraper.lean:263`

```lean
instance skyModule_subsingleton_hModule_one (x : X) (M : ModuleCat.{u} K) :
    Subsingleton (Sheaf.HModule (skyModule x M) 1) := by
```

ITEM 7 (H¹). H¹(X, skyModule x M) = 0 (Subsingleton). Together with skyModuleGammaEquiv this fully computes the cohomology of the SES third term: h⁰(sky_x J) = finrank = residueDeg, h¹(sky_x J) = 0. Proof via Ext¹-vanishing + cokernelπ_app_top_surjective (skyscraper is flasque). Instance, so available automatically for χ computations.

### `AlgebraicGeometry.Scheme.CurveDivisor`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:40`

```lean
def CurveDivisor (X : Scheme.{u}) [IsIntegral X] : Type u :=
  {x : X // x ≠ genericPoint X} →₀ ℤ
```

Context def. Weil divisor group = finitely supported ℤ-functions on non-generic (= closed) points. Carries Finsupp AddCommGroup (instance 47) and pointwise PartialOrder (instance 50). Independent of base field. The wrapper is a `def` (not abbrev) so FunLike/Sub are hidden — hence `toFinsupp` in Devissage. `CurveDivisor.deg K D = ∑ₓ Dₓ·[κ(x):K]` (61).

### `AlgebraicGeometry.Scheme.divOf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:150`

```lean
noncomputable def Scheme.divOf (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f]
    (g : X.functionFieldˣ) : X.CurveDivisor :=
  Finsupp.onFinset (Scheme.ordZ_support_finite f g).toFinset
    (fun p => Multiplicative.toAdd (Scheme.ordZ f p.2 g))
    (fun p hp => by ...)
```

Context def used by mulEquivDivisorSheaf. Principal divisor of a unit g: div(g) x = Multiplicative.toAdd (ordZ f hx g) = classical order (+1 zero, −1 pole). Note it takes the structure morphism `f` explicitly (called as `Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g`). Requires SmoothOfRelativeDimension 1, IsIntegral, LocallyOfFiniteType, QuasiCompact. `divOf_apply` (170), `divOf_mul` (additivity, 178).

