# API map (recon dump, 2026-07-14) — genus / Challenge interface, moduleKSheaf consumers, Gamma(C,O), roadmap leaves

*Machine-extracted verbatim signatures for the G8+G9 brick (spec-chi-g8-g9.md). Produced by read-only recon agents; signatures copied from source. Trust source over notes on any conflict.*

## Conventions in force

Two coefficient-letter conventions coexist. In the abstract cohomology files (ModuleKSheaf, OverOpen, MayerVietoris, AffineVanishing top, DedekindColength) the ring is `R : Type u [CommRing R]` (generic), or `k : Type u` which is `[CommRing k]` in ModuleKSheaf/TwoCover/AffineVanishing but strengthened to `[Field k]` only in Finiteness.lean, DedekindColength, Challenge, and Curve/Sections. Skyscraper.lean uses `K : Type u [CommRing K]` (NOT a field, and NOT necessarily the base field — it is the coefficient ring of the module value). Everything is strictly single-universe `u` (see the 'Universe discipline' note in ModuleKSheaf): C : Type u with [SmallCategory C], site hom-types in Type u, coefficients ModuleCat.{u} R, so HModule F n : Type u carries a Module R instance and Module.finrank applies with no universe bump. `HModule F n = Abelian.Ext (constModuleSheaf J R) F n` (Ext OUT of the constant sheaf = cohomology of the SITE); `HModule' F U n = Abelian.Ext (freeModuleSheaf J R U) F n` (cohomology of an OBJECT U of the site); they agree at a terminal object via HModule.linearEquivHModule'. Index n:ℕ; n=0 ⇒ global sections (linearEquiv₀), n=1 ⇒ the H¹ used for genus. The k-module structure on scheme sections Γ(X,U) is `Scheme.overModule` (restriction of scalars along the structure map), DELIBERATELY not a global instance — it is turned on by `attribute [local instance] Scheme.overModule` or `letI` in each file that needs it (ModuleKSheaf:218, TwoCover:113, Finiteness:77). MV-square field names: X₁=U₀⊓U₁ (overlap), X₂=U₀, X₃=U₁ (pieces), X₄=⊤; f₁₂,f₁₃ inclusions of overlap, f₂₄,f₃₄ inclusions into ⊤. Namespaces: abstract API under CategoryTheory.Sheaf (+ CategoryTheory.Abelian.Ext for subsingleton_one_of_injective_of_surjective, CategoryTheory.GrothendieckTopology.MayerVietorisSquare for the MV pieces); scheme-level API under AlgebraicGeometry (+ AlgebraicGeometry.IsAffineOpen, AlgebraicGeometry.TwoCover, AlgebraicGeometry.Scheme). Typeclasses in force for the challenge curve: [IsProper C.hom], [SmoothOfRelativeDimension 1 C.hom], [GeometricallyIrreducible C.hom] (and [GeometricallyReduced C.hom] for the Γ≅k instance), always for C : Over (Spec (.of k)) with the derived `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom`. Files set `set_option autoImplicit false`; Finiteness and Skyscraper additionally set `backward.isDefEq.respectTransparency false` (and Skyscraper sets linter.style.openClassical/unusedSectionVars false, with `open scoped Classical`).

## Warnings

1. PRIMED covariant_sequence_exact variants DO NOT EXIST in this rebuild. There is no `covariant_sequence_exact₁'/₂'/₃'` anywhere. The project uses mathlib's UNPRIMED lemmas directly: `Abelian.Ext.covariant_sequence_exact₁` (AffineVanishing.lean:71, inside subsingleton_one_of_injective_of_surjective) and `Abelian.Ext.contravariant_sequence_exact₁`/`contravariant_sequence_exact₃` (MayerVietoris.lean:246 and :311). The project's OWN long-exact-sequence surface is the elementwise moduleDelta lemmas in MayerVietoris.lean: moduleDelta_moduleDiff, exists_of_moduleDelta_eq_zero, res_moduleDelta₂/₃, exists_moduleDelta_eq, moduleDelta_surjective (plus the degree-0 sections_ext / moduleDiff_restriction / exists_glue_of_moduleDiff_eq_zero). The unprimed `covariant`/`contravariant` names are mathlib, not defined in the target files. 2. There is NO `chi_congr` and no bundled 'transport HModule along a sheaf iso' lemma. Transport is done ad hoc via `HModule.map` + `map_id_apply`/`map_comp_apply` (pointwise laws only; no morphism-level `map_id`/`map_comp`), or via linearEquivHModule'. 3. There is NO `def h0`, `def h1`, `def chi`, `def eulerChar` in the rebuild. The only realized numeric invariant is `genus` (Challenge.lean:89 = finrank of HModule ... 1). (Picard/CechH1.lean's `def H1.res`/`H1.resHom` are a DIFFERENT, Čech-style H1 API, unrelated to the HModule carrier.) 4. The H⁰-of-skyscraper computation is named `skyModuleGammaEquiv`, NOT `skyscraperGammaEquiv`. 5. finrank_alt_sum_eq_zero_of_exact₅ lives in AlgebraicJacobian/Algebra/DedekindColength.lean (namespace AlgebraicGeometry), NOT under Cohomology/. It uses `Function.Exact` (mathlib) and puts the result in ℤ. 6. Γ(C,𝒪)≅k is currently only a RING/SCHEME statement (bijective_appTop / isIso_appTop / the isIso instance in Curve/Sections.lean); it is NOT yet packaged as an H⁰ ≅ k LinearEquiv. To get `HModule (C.left.moduleKSheaf k) 0 ≃ₗ[k] k` you must compose Scheme.moduleKSheafHZero (ModuleKSheaf.lean:279, gives ≃ₗ[k] Γ(C.left,⊤)) with `asIso C.hom.appTop` and `(ΓSpecIso ...).symm` yourself — no such composite is pre-built. 7. moduleFinite_hModule_one (Finiteness.lean:388) is an INSTANCE whose statement is under a `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom`; it is deliberately keyed on the identical `letI` spelling used by `genus`, so proofs about `genus` pick it up by unification — do not respell the Over instance or the instance will not fire. 8. Many key ingredients are marked `private` (overlapLaurentHom, resLeft/resRight, moduleFinite_h1Cok, range_diff_eq in Finiteness; secRes* in AffineVanishing; cokernelπ_app_top_surjective, skyModule_map_isIso in Skyscraper) — usable only within their file; the public entry points are the theorems/defs listed above. 9. Skyscraper.lean's coefficient ring is `K : Type u [CommRing K]` and the base is `[X.Over (Spec (.of K))]`; do not assume K is a field or that M's ring is the curve's base field. 10. Verbatim caveat: I copied signatures faithfully; for defs whose bodies are long (h1LinearEquiv, HModule.linearEquivHModule', h1CokEquiv, skyModule_subsingleton_hModule_one) I truncated the PROOF/BODY with `...` but kept the full binder+type signature. Line numbers are 1-indexed against the current files (Skyscraper.lean was last modified 2026-07-14; the Cohomology files 2026-07-12).

## Declarations

### `CategoryTheory.Sheaf.constModuleSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:66`

```lean
variable {C : Type u} [SmallCategory C]
variable (J : GrothendieckTopology C) (R : Type u) [CommRing R]
  [HasSheafify J (ModuleCat.{u} R)]
noncomputable def constModuleSheaf : Sheaf J (ModuleCat.{u} R) :=
  (constantSheaf J (ModuleCat.{u} R)).obj (ModuleCat.of R R)
```

The object HModule is Ext OUT of: the constant sheaf of R-modules with value R on the small site (C,J). J, R explicit here; downstream `variable {J R}` (line 69) makes them implicit.

### `CategoryTheory.Sheaf.HModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:74`

```lean
variable {C : Type u} [SmallCategory C]
-- with {J : GrothendieckTopology C} {R : Type u} [CommRing R] [HasSheafify J (ModuleCat.{u} R)] in force (made implicit at line 69)
noncomputable abbrev HModule (F : Sheaf J (ModuleCat.{u} R)) (n : ℕ) : Type u :=
  Abelian.Ext (constModuleSheaf J R) F n
```

THE cohomology carrier. An `abbrev` for `Abelian.Ext (constModuleSheaf J R) F n` in the Grothendieck-abelian category `Sheaf J (ModuleCat.{u} R)`. Carries a `Module R` structure via the R-linear (R-Linear) structure on the sheaf category; lives in `Type u` (single-universe discipline). The whole mathlib Ext API applies transparently. Index n : ℕ; n=0 is global sections (linearEquiv₀), n=1 is the H^1 used for genus. R-module (not just the ring but the field k downstream).

### `CategoryTheory.Sheaf.HModule.map`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:82`

```lean
variable {C : Type u} [SmallCategory C]
-- {J R} implicit, [CommRing R] [HasSheafify J (ModuleCat.{u} R)]
namespace HModule
variable {F G G' : Sheaf J (ModuleCat.{u} R)}
noncomputable def map (f : F ⟶ G) (n : ℕ) : HModule F n →ₗ[R] HModule G n :=
  (Abelian.Ext.mk₀ f).postcompOfLinear R (constModuleSheaf J R) (add_zero n)
```

R-linear functoriality of HModule in the sheaf argument, by Ext-postcomposition with mk₀ f. This is the vehicle for transporting HModule along a sheaf morphism/iso (there is NO separately-named `chi_congr` / `HModule.mapIso` in this project — combine `map` with an iso, or use `map_id_apply`/`map_comp_apply` to get an equivalence by hand).

### `CategoryTheory.Sheaf.HModule.map_apply`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:85`

```lean
lemma map_apply (f : F ⟶ G) {n : ℕ} (x : HModule F n) :
    map f n x = x.comp (Abelian.Ext.mk₀ f) (add_zero n) := rfl
```

Definitional unfolding of map to Ext-composition.

### `CategoryTheory.Sheaf.HModule.map_id_apply`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:88`

```lean
@[simp]
lemma map_id_apply {n : ℕ} (x : HModule F n) : map (𝟙 F) n x = x := by
  simp [map_apply]
```

map_id law (pointwise / @[simp]). No bundled `map_id`/`map_comp` as morphism equalities — only the *_apply pointwise forms exist.

### `CategoryTheory.Sheaf.HModule.map_comp_apply`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:92`

```lean
lemma map_comp_apply (f : F ⟶ G) (g : G ⟶ G') {n : ℕ} (x : HModule F n) :
    map (f ≫ g) n x = map g n (map f n x) := by
  simp [map_apply]
```

map_comp law (covariant: map(f≫g) = map g ∘ map f).

### `CategoryTheory.Sheaf.HModule.instSubsingletonHModuleHAddNatOfNat (injective ⇒ H^{n+1}=0)`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:96`

```lean
instance [Injective F] (n : ℕ) : Subsingleton (HModule F (n + 1)) :=
  subsingleton_of_forall_eq 0 fun x ↦ x.eq_zero_of_injective 0
```

Ext vanishing on injective objects; underlies the whole vanishing strategy.

### `CategoryTheory.Sheaf.constModuleSheafHomEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:137`

```lean
variable {T : C} (hT : IsTerminal T)
variable (J) in
noncomputable def constModuleSheafHomEquiv (F : Sheaf J (ModuleCat.{u} R)) :
    (constModuleSheaf J R ⟶ F) ≃ₗ[R] F.obj.obj (op T) :=
  (constantSheafAdjHomLinearEquiv hT (ModuleCat.of R R) F).trans
    (ModuleCat.homLinearEquiv.trans (LinearMap.ringLmapEquivSelf R R _))
```

Hom(R_X, F) ≃ₗ[R] F(⊤) via constant-sheaf ⊣ global-sections adjunction. J explicit (via `variable (J) in`), hT explicit. Used repeatedly (Skyscraper H^1 lift, affine H^1 vanishing). Naturality: constModuleSheafHomEquiv_naturality (line 142).

### `CategoryTheory.Sheaf.HModule.linearEquiv₀`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:152`

```lean
variable {T : C} (hT : IsTerminal T)
variable (J) in
noncomputable def HModule.linearEquiv₀ (F : Sheaf J (ModuleCat.{u} R)) :
    HModule F 0 ≃ₗ[R] F.obj.obj (op T) :=
  (Abelian.Ext.linearEquiv₀ (R := R)).trans (constModuleSheafHomEquiv J hT F)
```

H^0 identification: degree-zero cohomology ≅ sections over a terminal object T of the site. J explicit, hT : IsTerminal T explicit. Naturality lemmas: HModule.linearEquiv₀_naturality (167), HModule.linearEquiv₀_symm_naturality (173).

### `CategoryTheory.Sheaf.HModule.linearEquiv₀_naturality`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:167`

```lean
variable {F G : Sheaf J (ModuleCat.{u} R)} (f : F ⟶ G)
theorem HModule.linearEquiv₀_naturality (x : HModule F 0) :
    f.hom.app (op T) (HModule.linearEquiv₀ J hT F x) =
      HModule.linearEquiv₀ J hT G (HModule.map f 0 x)
```

Compatibility of the H^0 identification with HModule.map and section-restriction f.hom.app. Symm form at line 173.

### `AlgebraicGeometry.Scheme.overAlgebraMap`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:193`

```lean
variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]
noncomputable def Scheme.overAlgebraMap (U : X.Opens) : k →+* Γ(X, U) :=
  ((Scheme.ΓSpecIso (.of k)).inv ≫ (X ↘ Spec (.of k)).appTop ≫
    X.presheaf.map (homOfLE le_top).op).hom
```

The k-algebra structure map k →+* Γ(X,U) from the structure morphism. k is only [CommRing k] at this file's generality (field-ness comes later).

### `AlgebraicGeometry.Scheme.overModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:215`

```lean
@[reducible] noncomputable def Scheme.overModule (U : X.Opens) : Module k Γ(X, U) :=
  (X.overAlgebraMap k U).toModule
```

The k-module structure on Γ(X,U). DELIBERATELY NOT a global instance (would clash with mathlib's Algebra R Γ(Spec R,U) via tautological OverClass). Activated by `attribute [local instance] Scheme.overModule` (done at line 218 and re-declared in TwoCover/Finiteness). overModule_smul_def (220): r • s = overAlgebraMap k U r * s.

### `AlgebraicGeometry.Scheme.moduleKSheaf`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:265`

```lean
variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]
noncomputable def Scheme.moduleKSheaf :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k) :=
  ⟨X.moduleKPresheaf k, X.isSheaf_moduleKPresheaf k⟩
```

The structure sheaf of X as a sheaf of k-modules on the small Zariski site Opens.grothendieckTopology X. This is the F plugged into HModule to get scheme cohomology. moduleKSheaf_obj (270, @[simp]): (moduleKSheaf k).obj.obj (op U) = ModuleCat.of k Γ(X,U) definitionally; moduleKSheaf_map_apply (273) gives restriction maps = structure-sheaf restrictions.

### `AlgebraicGeometry.Scheme.moduleKSheafHZero`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModuleKSheaf.lean:279`

```lean
noncomputable def Scheme.moduleKSheafHZero :
    Sheaf.HModule (X.moduleKSheaf k) 0 ≃ₗ[k] Γ(X, ⊤) :=
  Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens))
    (X.moduleKSheaf k)
```

H^0 of the structure sheaf ≅ Γ(X,⊤) k-linearly. This is the H^0-side computation; to reach `≅ k` you further compose with the appTop iso from Curve/Sections.lean (see bijective_appTop_of_isProper_of_geometricallyIntegral). k explicit, X explicit.

### `CategoryTheory.Sheaf.HModule' (over-open cohomology)`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/OverOpen.lean:269`

```lean
variable {C : Type u} [SmallCategory C]
-- {J : GrothendieckTopology C} {R : Type u} [CommRing R] [HasSheafify J (ModuleCat.{u} R)] (made implicit at OverOpen line 111)
noncomputable abbrev HModule' (F : Sheaf J (ModuleCat.{u} R)) (U : C) (n : ℕ) : Type u :=
  Abelian.Ext (freeModuleSheaf J R U) F n
```

Cohomology of an OBJECT U of the site (relative to F): Ext from the free R-module sheaf on U. HModule'.linearEquiv₀ (273): HModule' F U 0 ≃ₗ[R] F(U). HModule'.res (286): restriction H'^n(V) → H'^n(U) along i:U⟶V. For U terminal this is HModule via HModule.linearEquivHModule'.

### `CategoryTheory.Sheaf.HModule.linearEquivHModule'`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/OverOpen.lean:346`

```lean
variable {T : C} (hT : IsTerminal T)
variable (F : Sheaf J (ModuleCat.{u} R))
noncomputable def HModule.linearEquivHModule' (n : ℕ) :
    HModule F n ≃ₗ[R] HModule' F T n where
  __ := (Abelian.Ext.mk₀ (freeModuleSheafIsoConstModuleSheaf J R hT).hom).precompOfLinear R F (zero_add n)
  invFun := (Abelian.Ext.mk₀ (freeModuleSheafIsoConstModuleSheaf J R hT).inv).precompOfLinear R F (zero_add n)
  left_inv := ...
  right_inv := ...
```

Site cohomology HModule (Ext out of constant sheaf) ≅ over-terminal-object cohomology HModule' F T, k-linearly, in every degree n. hT, F explicit; n explicit. This is the glue letting the MayerVietoris/TwoCover HModule' machinery talk about HModule of the scheme.

### `AlgebraicGeometry.IsAffineOpen.subsingleton_moduleKSheaf_hModule'_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:310`

```lean
variable (k : Type u) [CommRing k] {X : Scheme.{u}} [X.Over (Spec (.of k))] {U : X.Opens}
namespace IsAffineOpen
theorem subsingleton_moduleKSheaf_hModule'_one (hU : IsAffineOpen U) :
    Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) U 1)
```

Serre H^1-vanishing on an affine open U (in the HModule' sense). k explicit, X/U implicit. Proof via subsingleton_one_of_injective_of_surjective + IsAffineOpen.cokernel_app_surjective. Fully-qualified: AlgebraicGeometry.IsAffineOpen.subsingleton_moduleKSheaf_hModule'_one.

### `AlgebraicGeometry.Scheme.subsingleton_moduleKSheaf_hModule_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:329`

```lean
variable (k : Type u) [CommRing k] {X : Scheme.{u}} [X.Over (Spec (.of k))] {U : X.Opens}
instance Scheme.subsingleton_moduleKSheaf_hModule_one (X : Scheme.{u})
    [X.Over (Spec (.of k))] [IsAffine X] :
    Subsingleton (Sheaf.HModule (X.moduleKSheaf k) 1)
```

Serre H^1-vanishing for an affine SCHEME (site-level HModule). An `instance`. Note X is re-bound explicitly in the signature shadowing the section's `{X}`; k stays from the section variable (explicit).

### `CategoryTheory.Abelian.Ext.subsingleton_one_of_injective_of_surjective`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:62`

```lean
variable {C : Type u} [Category.{v} C] [Abelian C] [HasExt.{w} C]
theorem subsingleton_one_of_injective_of_surjective {A I : C} (ι : A ⟶ I) [Mono ι]
    [Injective I] (L : C)
    (hsurj : ∀ φ : L ⟶ cokernel ι, ∃ ψ : L ⟶ I, ψ ≫ cokernel.π ι = φ) :
    Subsingleton (Abelian.Ext L A 1)
```

GENERAL Ext^1 vanishing criterion (this project's own lemma, in namespace CategoryTheory.Abelian.Ext, for any abelian C with HasExt). Given mono ι:A→I into an injective I and surjectivity of Hom(L,I)→Hom(L,cokernel ι), Ext^1(L,A)=0. Proof uses mathlib `covariant_sequence_exact₁` (line 71). This is the lemma invoked by both the affine and skyscraper H^1-vanishing proofs.

### `AlgebraicGeometry.IsAffineOpen.cokernel_app_surjective`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:180`

```lean
variable (k : Type u) [CommRing k] {X : Scheme.{u}} [X.Over (Spec (.of k))] {U : X.Opens}
namespace IsAffineOpen
set_option backward.isDefEq.respectTransparency false in
theorem cokernel_app_surjective (hU : IsAffineOpen U)
    {G : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k)}
    (ι : X.moduleKSheaf k ⟶ G) [Mono ι]
    (q : (cokernel ι).obj.obj (op U)) :
    ∃ s : G.obj.obj (op U), ((cokernel.π ι).hom.app (op U)).hom s = q
```

Geometric heart of affine vanishing: sections of cokernel ι over affine U lift to G. Skyscraper analogue is Skyscraper.lean's private cokernelπ_app_top_surjective (line 114).

### `CategoryTheory.Sheaf.exists_app_eq_of_cokernelπ_app_eq_zero`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/AffineVanishing.lean:92`

```lean
variable {C : Type u} [SmallCategory C] {J : GrothendieckTopology C}
  {R : Type u} [CommRing R] [HasSheafify J (ModuleCat.{u} R)]
theorem exists_app_eq_of_cokernelπ_app_eq_zero {F G : Sheaf J (ModuleCat.{u} R)}
    (ι : F ⟶ G) [Mono ι] (U : Cᵒᵖ) (c : G.obj.obj U)
    (hc : ((cokernel.π ι).hom.app U).hom c = 0) :
    ∃ a : F.obj.obj U, (ι.hom.app U).hom a = c
```

Left-exactness of sheaf evaluation (kernel exactness). Companion app_injective_of_mono (line 117): components of a sheaf mono are injective. Both reused in Skyscraper.lean.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleShortComplex`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:104`

```lean
variable {C : Type u} [SmallCategory C] {J : GrothendieckTopology C}
variable (R : Type u) [CommRing R]
variable [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} R)]
variable (S : J.MayerVietorisSquare)
noncomputable abbrev moduleShortComplex : ShortComplex (Sheaf J (ModuleCat.{u} R)) where
  X₁ := Sheaf.freeModuleSheaf J R S.X₁
  X₂ := Sheaf.freeModuleSheaf J R S.X₂ ⊞ Sheaf.freeModuleSheaf J R S.X₃
  X₃ := Sheaf.freeModuleSheaf J R S.X₄
  f := biprod.lift (Sheaf.freeModuleSheafMap J R S.f₁₂) (-Sheaf.freeModuleSheafMap J R S.f₁₃)
  g := biprod.desc (Sheaf.freeModuleSheafMap J R S.f₂₄) (Sheaf.freeModuleSheafMap J R S.f₃₄)
  zero := ...
```

The SHORT COMPLEX 0→R[X₁]→R[X₂]⊞R[X₃]→R[X₄]→0 of free module sheaves; its ShortExact witness is moduleShortComplex_shortExact (line 137). This is the ShortComplex/ShortExact input feeding the connecting map. R, S explicit.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleShortComplex_shortExact`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:137`

```lean
lemma moduleShortComplex_shortExact : (S.moduleShortComplex R).ShortExact where
  exact := S.moduleShortComplex_exact R
```

The .ShortExact structure passed to mathlib's Ext long-exact-sequence lemmas (contravariant_sequence_exact₁/₃) and to .extClass in moduleDelta.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDiff`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:161`

```lean
variable {R S}
variable (F : Sheaf J (ModuleCat.{u} R))
variable (S) in
noncomputable def moduleDiff :
    (F.obj.obj (op S.X₂) × F.obj.obj (op S.X₃)) →ₗ[R] F.obj.obj (op S.X₁) :=
  (F.obj.map S.f₁₂.op).hom.comp (LinearMap.fst R _ _) -
    (F.obj.map S.f₁₃.op).hom.comp (LinearMap.snd R _ _)
```

Restriction-difference map F(X₂)×F(X₃) → F(X₁), (s₂,s₃) ↦ s₂|₁ - s₃|₁ (moduleDiff_apply, 167). F explicit, S explicit (via `variable (S) in`), R implicit.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDelta`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:207`

```lean
variable (S) in
noncomputable def moduleDelta :
    F.obj.obj (op S.X₁) →ₗ[R] Sheaf.HModule' F S.X₄ 1 :=
  ((S.moduleShortComplex_shortExact R).extClass.precompOfLinear R F rfl).comp
    (Sheaf.HModule'.linearEquiv₀ F S.X₁).symm.toLinearMap
```

Mayer–Vietoris CONNECTING homomorphism δ: F(X₁) → H¹'(X₄,F), pairing with the extension class of moduleShortComplex_shortExact. moduleDelta_apply at line 212.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDelta_moduleDiff`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:219`

```lean
theorem moduleDelta_moduleDiff (t : F.obj.obj (op S.X₂) × F.obj.obj (op S.X₃)) :
    S.moduleDelta F (S.moduleDiff F t) = 0
```

LES piece: δ∘(diff)=0 (complex at F(X₁)).

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.exists_of_moduleDelta_eq_zero`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:242`

```lean
theorem exists_of_moduleDelta_eq_zero (s : F.obj.obj (op S.X₁))
    (hs : S.moduleDelta F s = 0) :
    ∃ t : F.obj.obj (op S.X₂) × F.obj.obj (op S.X₃), S.moduleDiff F t = s
```

LES exactness at F(X₁). Proof uses mathlib `Abelian.Ext.contravariant_sequence_exact₁ (S.moduleShortComplex_shortExact R) F ...` (line 246). This — together with res_moduleDelta₂/₃, exists_moduleDelta_eq — are THE covariant/contravariant long-exact-sequence pieces of this project. NOTE: no `covariant_sequence_exact₁'/₂'/₃'` (primed) exist in this rebuild; the project consumes mathlib's unprimed `Abelian.Ext.covariant_sequence_exact₁` (AffineVanishing:71) and `contravariant_sequence_exact₁/₃` (MayerVietoris:246,311) directly and re-exposes them as these moduleDelta lemmas.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.res_moduleDelta₂ / res_moduleDelta₃`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:274`

```lean
theorem res_moduleDelta₂ (s : F.obj.obj (op S.X₁)) :
    Sheaf.HModule'.res S.f₂₄ F 1 (S.moduleDelta F s) = 0
-- and
theorem res_moduleDelta₃ (s : F.obj.obj (op S.X₁)) :
    Sheaf.HModule'.res S.f₃₄ F 1 (S.moduleDelta F s) = 0
```

LES pieces at H¹'(X₄): connecting class restricts to 0 on each piece. res_moduleDelta₃ is at line 284. Both use (moduleShortComplex_shortExact R).comp_extClass_assoc.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.exists_moduleDelta_eq`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:295`

```lean
theorem exists_moduleDelta_eq (y : Sheaf.HModule' F S.X₄ 1)
    (h₂ : Sheaf.HModule'.res S.f₂₄ F 1 y = 0)
    (h₃ : Sheaf.HModule'.res S.f₃₄ F 1 y = 0) :
    ∃ s : F.obj.obj (op S.X₁), S.moduleDelta F s = y
```

LES exactness at H¹'(X₄): a class restricting to 0 on both pieces is a connecting class. Uses mathlib `Abelian.Ext.contravariant_sequence_exact₃ (S.moduleShortComplex_shortExact R) F y hg (n₀ := 0) rfl` (line 311). moduleDelta_surjective (319) follows when both pieces' H¹' vanish.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDelta_surjective`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:319`

```lean
theorem moduleDelta_surjective [Subsingleton (Sheaf.HModule' F S.X₂ 1)]
    [Subsingleton (Sheaf.HModule' F S.X₃ 1)] :
    Function.Surjective (S.moduleDelta F)
```

Connecting map surjective when both pieces have vanishing H¹'.

### `CategoryTheory.GrothendieckTopology.MayerVietorisSquare.h1LinearEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/MayerVietoris.lean:352`

```lean
noncomputable def h1LinearEquiv [Subsingleton (Sheaf.HModule' F S.X₂ 1)]
    [Subsingleton (Sheaf.HModule' F S.X₃ 1)] :
    (F.obj.obj (op S.X₁) ⧸ LinearMap.range (S.moduleDiff F)) ≃ₗ[R]
      Sheaf.HModule' F S.X₄ 1 :=
  LinearEquiv.ofBijective (S.moduleDeltaQuotient F) <| ...
```

The two-cover COKERNEL COMPUTATION at general coefficients: coker(moduleDiff) ≅ H¹'(X₄,F) when both pieces vanish. Compat: h1LinearEquiv_mk (370, @[simp]). moduleDeltaQuotient (337) is the descended connecting map.

### `AlgebraicGeometry.Scheme.twoCoverSquare`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:68`

```lean
variable (X : Scheme.{u}) (U₀ U₁ : X.Opens)
noncomputable def Scheme.twoCoverSquare (hcov : U₀ ⊔ U₁ = ⊤) :
    (Opens.grothendieckTopology (X : TopCat)).MayerVietorisSquare :=
  Opens.mayerVietorisSquare'
    { X₁ := U₀ ⊓ U₁, X₂ := U₀, X₃ := U₁, X₄ := ⊤,
      f₁₂ := homOfLE inf_le_left, f₁₃ := homOfLE inf_le_right,
      f₂₄ := homOfLE le_top, f₃₄ := homOfLE le_top,
      fac := Subsingleton.elim _ _ } hcov.symm rfl
```

The MV square (U₀⊓U₁, U₀, U₁, ⊤) for a covering pair. X, U₀, U₁ explicit.

### `AlgebraicGeometry.TwoCover.diff`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:118`

```lean
namespace TwoCover
variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]
variable (U₀ U₁ : X.Opens)
attribute [local instance] Scheme.overModule
noncomputable def diff : (Γ(X, U₀) × Γ(X, U₁)) →ₗ[k] Γ(X, U₀ ⊓ U₁) :=
  ((X.moduleKSheaf k).obj.map (homOfLE (inf_le_left : U₀ ⊓ U₁ ≤ U₀)).op).hom.comp (LinearMap.fst k _ _) -
    ((X.moduleKSheaf k).obj.map (homOfLE (inf_le_right : U₀ ⊓ U₁ ≤ U₁)).op).hom.comp (LinearMap.snd k _ _)
```

Scheme-level restriction-difference on structure-sheaf sections; diff_apply (124): = X.resHom inf_le_left t.1 - X.resHom inf_le_right t.2. diff_eq_moduleDiff (130): equals the MV moduleDiff of the twoCoverSquare. k,X,U₀,U₁ all explicit; overModule active as local instance.

### `AlgebraicGeometry.TwoCover.H1Cok`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:138`

```lean
noncomputable abbrev H1Cok : Type u :=
  Γ(X, U₀ ⊓ U₁) ⧸ LinearMap.range (diff k X U₀ U₁)
```

The concrete cokernel carrier for H¹ of a two-affine-cover: a plain quotient of section modules, so Module.finrank applies directly. This is what moduleFinite_h1Cok proves finite. h1Cok_mk_resHom_left/right (142,148): sections extending to a piece have zero class.

### `AlgebraicGeometry.TwoCover.delta`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:161`

```lean
variable (hcov : U₀ ⊔ U₁ = ⊤)
noncomputable def delta :
    Γ(X, U₀ ⊓ U₁) →ₗ[k] Sheaf.HModule (X.moduleKSheaf k) 1 :=
  ((Sheaf.HModule.linearEquivHModule' (isTerminalTop : IsTerminal (⊤ : X.Opens))
      (X.moduleKSheaf k) 1).symm.toLinearMap).comp
    ((X.twoCoverSquare U₀ U₁ hcov).moduleDelta (X.moduleKSheaf k))
```

Scheme-level connecting map into site cohomology Sheaf.HModule ... 1. delta_diff (168), delta_resHom_left/right (181,189), delta_surjective (201, needs affine U₀,U₁).

### `AlgebraicGeometry.TwoCover.h1CokEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:226`

```lean
variable (hcov : U₀ ⊔ U₁ = ⊤)
variable (hU₀ : IsAffineOpen U₀) (hU₁ : IsAffineOpen U₁)
noncomputable def h1CokEquiv :
    Sheaf.HModule (X.moduleKSheaf k) 1 ≃ₗ[k] H1Cok k X U₀ U₁ :=
  letI : Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) (X.twoCoverSquare U₀ U₁ hcov).X₂ 1) := hU₀.subsingleton_moduleKSheaf_hModule'_one k
  letI : Subsingleton (Sheaf.HModule' (X.moduleKSheaf k) (X.twoCoverSquare U₀ U₁ hcov).X₃ 1) := hU₁.subsingleton_moduleKSheaf_hModule'_one k
  (Sheaf.HModule.linearEquivHModule' (isTerminalTop : IsTerminal (⊤ : X.Opens)) (X.moduleKSheaf k) 1).trans
    ((X.twoCoverSquare U₀ U₁ hcov).h1LinearEquiv (X.moduleKSheaf k)).symm
```

THE two-affine-cover bridge: H¹ₖ(X,𝒪) ≃ₗ[k] H1Cok (the section-module cokernel). Hyps: hcov:U₀⊔U₁=⊤, hU₀,hU₁ affine. Compat: h1CokEquiv_delta (240), h1CokEquiv_symm_mk (269). This is what Finiteness.lean transports across to conclude Module.Finite.

### `AlgebraicGeometry.Scheme.twoCoverH1LinearEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/TwoCover.lean:92`

```lean
variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]
variable (U₀ U₁ : X.Opens)
noncomputable def Scheme.twoCoverH1LinearEquiv
    (F : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k))
    (hcov : U₀ ⊔ U₁ = ⊤)
    [Subsingleton (Sheaf.HModule' F U₀ 1)] [Subsingleton (Sheaf.HModule' F U₁ 1)] :
    Sheaf.HModule F 1 ≃ₗ[k]
      (F.obj.obj (op (U₀ ⊓ U₁)) ⧸ LinearMap.range ((X.twoCoverSquare U₀ U₁ hcov).moduleDiff F))
```

General-coefficients form of the two-cover H¹ computation (reusable for twisted/divisor sheaves F, not just the structure sheaf). k,X,U₀,U₁ explicit.

### `AlgebraicGeometry.moduleFinite_hModule_one_of_isFinite_toP1`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/Finiteness.lean:374`

```lean
variable {k : Type u} [Field k]
theorem moduleFinite_hModule_one_of_isFinite_toP1 {X : Scheme.{u}} [X.Over (Spec (.of k))]
    (π : X ⟶ P1 k) [IsFinite π] (hπ : π ≫ P1.structureMap k = X ↘ Spec (.of k)) :
    Module.Finite k (Sheaf.HModule (X.moduleKSheaf k) 1)
```

Conditional finiteness of H¹: for a FINITE k-morphism π:X⟶ℙ¹ compatible with the structure maps, H¹ₖ(X,𝒪) is a finite k-module. k is a FIELD here. Transports moduleFinite_h1Cok across h1CokEquiv.

### `AlgebraicGeometry.moduleFinite_hModule_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/Finiteness.lean:388`

```lean
variable {k : Type u} [Field k]
instance moduleFinite_hModule_one (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
    Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)
```

THE finiteness INSTANCE for the challenge curve: H¹(C,𝒪_C) is a finite (hence finite-dimensional, since FiniteDimensional := Module.Finite) k-vector space. Keyed on the exact `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom` spelling used by `genus`. Consumes `exists_isFinite_toP1`. Hyps: IsProper, SmoothOfRelativeDimension 1, GeometricallyIrreducible on C.hom.

### `AlgebraicGeometry.finrank_alt_sum_eq_zero_of_exact₅`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Algebra/DedekindColength.lean:78`

```lean
theorem finrank_alt_sum_eq_zero_of_exact₅
    {k V₁ V₂ V₃ V₄ V₅ : Type*} [Field k]
    [AddCommGroup V₁] [Module k V₁] [AddCommGroup V₂] [Module k V₂] [AddCommGroup V₃] [Module k V₃]
    [AddCommGroup V₄] [Module k V₄] [AddCommGroup V₅] [Module k V₅]
    [Module.Finite k V₁] [Module.Finite k V₂] [Module.Finite k V₃] [Module.Finite k V₄]
    [Module.Finite k V₅]
    (f₁ : V₁ →ₗ[k] V₂) (f₂ : V₂ →ₗ[k] V₃) (f₃ : V₃ →ₗ[k] V₄) (f₄ : V₄ →ₗ[k] V₅)
    (h₁ : Function.Injective f₁) (e₁ : Function.Exact f₁ f₂) (e₂ : Function.Exact f₂ f₃)
    (e₃ : Function.Exact f₃ f₄) (h₄ : Function.Surjective f₄) :
    (finrank k V₁ : ℤ) - finrank k V₂ + finrank k V₃ - finrank k V₄ + finrank k V₅ = 0
```

THE 5-term alternating finrank lemma. Located in Algebra/DedekindColength.lean (NOT under Cohomology/). Stated with Function.Exact and explicit inj/surj at the ends; all five spaces Module.Finite over a field k. Uses `open Module (finrank length)` so `finrank` = `Module.finrank`. Companion: finrank_add_of_exact (line 63) for the 3-term/short-exact case.

### `AlgebraicGeometry.skyModule`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Skyscraper.lean:64`

```lean
variable {K : Type u} [CommRing K] {X : Scheme.{u}} [X.Over (Spec (.of K))]
def skyModule (x : X) (M : ModuleCat.{u} K) :
    Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} K) :=
  skyscraperSheaf x M
```

Skyscraper sheaf of K-modules at point x with value M, = mathlib skyscraperSheaf, kept opaque. NOTE Skyscraper.lean uses K (not k), [CommRing K] (not Field). simp lemmas skyModule_obj_of_mem (76), skyModule_obj_of_not_mem (82). Under `noncomputable section` + `open scoped Classical`.

### `AlgebraicGeometry.skyModuleGammaEquiv`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Skyscraper.lean:88`

```lean
def skyModuleGammaEquiv (x : X) (M : ModuleCat.{u} K) :
    Sheaf.HModule (skyModule x M) 0 ≃ₗ[K] M :=
  (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
      (isTerminalTop : IsTerminal (⊤ : X.Opens)) (skyModule x M)).trans
    (eqToIso (skyModule_obj_of_mem x M (Opens.mem_top x))).toLinearEquiv
```

H^0 OF THE SKYSCRAPER = its value M, K-linearly. Named `skyModuleGammaEquiv` (there is NO `skyscraperGammaEquiv`). This is the H⁰ computation requested. `noncomputable` (inside `noncomputable section`).

### `AlgebraicGeometry.skyModule_subsingleton_hModule_one`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Skyscraper.lean:263`

```lean
instance skyModule_subsingleton_hModule_one (x : X) (M : ModuleCat.{u} K) :
    Subsingleton (Sheaf.HModule (skyModule x M) 1) := by ...
```

H^1 OF THE SKYSCRAPER VANISHES. An `instance`. Proof: embed into injective hull (Injective.ι) and apply Abelian.Ext.subsingleton_one_of_injective_of_surjective, discharging the lift via the private cokernelπ_app_top_surjective (line 114, uses flasqueness isFlasque_skyscraperSheaf_of_hasZeroObject). Under {K}[CommRing K]{X}[X.Over (Spec (.of K))].

### `AlgebraicGeometry.bijective_appTop_of_isProper_of_geometricallyIntegral`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/Sections.lean:95`

```lean
theorem bijective_appTop_of_isProper_of_geometricallyIntegral
    {K : Type u} [Field K] {X : Scheme.{u}} (f : X ⟶ Spec (CommRingCat.of K))
    [IsProper f] [GeometricallyIntegral f] :
    Function.Bijective f.appTop
```

Γ(C,𝒪) ≅ K expressed as bijectivity of the structure map on global sections f.appTop : Γ(Spec K,⊤) ⟶ Γ(X,⊤). Instance-friendly forms: isIso_appTop_of_isProper_of_geometricallyIntegral (147), and the bundle instance isIso_hom_appTop_of_geometricallyReduced (161) for Over (Spec (CommRingCat.of k)) with [IsProper][GeometricallyIrreducible][GeometricallyReduced]. The composite k ≅ Γ(C.left,⊤) is (ΓSpecIso ...).symm ≪≫ asIso C.hom.appTop (regression example at 175). NOTE: this is NOT yet linked to HModule 0 / skyModuleGammaEquiv-style — no `H⁰(C) ≅ k` LinearEquiv exists; you would compose Scheme.moduleKSheafHZero with asIso C.hom.appTop yourself.

### `AlgebraicGeometry.genus`
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:89`

```lean
variable {k : Type u} [Field k]
noncomputable def genus (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] : ℕ :=
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)
```

The genus = finrank k (HModule (C.left.moduleKSheaf k) 1). This is the ONLY consumer-facing 'h1-like' definition; there is NO `def h0`, `def h1`, `def chi`, or `def eulerChar` anywhere in the rebuild. (Picard/CechH1.lean has an unrelated Čech `def H1.res`/`H1.resHom` API, not the HModule carrier.) The `letI` spelling here is exactly what moduleFinite_hModule_one is keyed on.

