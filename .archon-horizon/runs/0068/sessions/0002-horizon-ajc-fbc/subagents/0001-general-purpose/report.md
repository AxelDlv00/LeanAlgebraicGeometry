No import cycle — the Picard machinery is importable into the target file. Report follows.

---

# Q1. Categorical exactness criteria (mathlib)

All paths verified to compile against `Scheme.Modules.pullback`.

**(a) From kernel preservation**
- `CategoryTheory.Functor.preservesFiniteLimits_of_preservesKernels` — `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Preadditive/LeftExact.lean:117`
```lean
lemma preservesFiniteLimits_of_preservesKernels [HasFiniteProducts C] [HasEqualizers C]
    [HasZeroObject C] [HasZeroObject D] [∀ {X Y} (f : X ⟶ Y), PreservesLimit (parallelPair f 0) F] :
    PreservesFiniteLimits F
```
Ambient: `[Preadditive C] [Preadditive D] (F : C ⥤ D) [PreservesZeroMorphisms F]`. Also `preservesEqualizers_of_preservesKernels` at `:107`.

**(b) THE ONE YOU WANT — right exact + preserves monos.** Mathlib has no packaged lemma, but the 6-line derivation exists and I compiled it. The pieces:
- `CategoryTheory.Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono` — `Mathlib/Algebra/Homology/ShortComplex/ExactFunctor.lean:151`
```lean
lemma preservesFiniteLimits_iff_forall_exact_map_and_mono :
    PreservesFiniteLimits F ↔
      ∀ (S : ShortComplex C), S.ShortExact → (S.map F).Exact ∧ Mono (F.map S.f)
```
Ambient: `[Abelian C] [Abelian D] (F : C ⥤ D) [F.Additive]`.
- `CategoryTheory.ShortComplex.Exact.map_of_epi_of_preservesCokernel` — `Mathlib/Algebra/Homology/ShortComplex/Exact.lean:765`
```lean
lemma map_of_epi_of_preservesCokernel (hS : S.Exact) (F : C ⥤ D)
    [F.PreservesZeroMorphisms] [(S.map F).HasHomology] (_ : Epi S.g)
    (_ : PreservesColimit (parallelPair S.f 0) F) : (S.map F).Exact
```

VERIFIED COMPILING (`lean_run_code`, mathlib v4.31.0):
```lean
example {C D : Type u} [Category.{u} C] [Category.{u} D] [Abelian C] [Abelian D]
    (F : C ⥤ D) [F.Additive] [PreservesFiniteColimits F] [F.PreservesMonomorphisms] :
    PreservesFiniteLimits F := by
  rw [F.preservesFiniteLimits_iff_forall_exact_map_and_mono]
  intro S hS
  haveI := hS.mono_f; haveI := hS.epi_g
  refine ⟨?_, inferInstance⟩
  exact (hS.exact).map_of_epi_of_preservesCokernel F hS.epi_g inferInstance
```
and specialised to your exact target:
```lean
example {S S' : Scheme.{u}} (g : S' ⟶ S)
    [(Scheme.Modules.pullback g).PreservesMonomorphisms] :
    PreservesFiniteLimits (Scheme.Modules.pullback g) := ...   -- compiles
```
So **the whole remaining content of your `sorry` is `(Scheme.Modules.pullback g).PreservesMonomorphisms`.** No stalks, no kernels, no sheafification glue needed. `PreservesFiniteColimits` and `Additive` are already instances (`Sheaf.lean:196`, `CechHigherDirectImageUnconditional.lean:137`).

**(c) From `PreservesHomology`**
- `CategoryTheory.Functor.preservesFiniteLimits_of_preservesHomology` — `Mathlib/Algebra/Homology/ShortComplex/ExactFunctor.lean:70`
```lean
lemma preservesFiniteLimits_of_preservesHomology [HasFiniteProducts C] [HasKernels C] :
    PreservesFiniteLimits F
```
Ambient `[Preadditive C] [Preadditive D] (F : C ⥤ D) [F.Additive] [F.PreservesHomology] [HasZeroObject C]`. Note this is circular for you: `Functor.preservesHomologyOfExact` (`ShortComplex/PreservesHomology.lean:60`) is the only instance producing `PreservesHomology`, and it *needs* `PreservesFiniteLimits`. Your line 167 `pullback_preservesHomology` consumes the `sorry`.

**(d) TFAE bundles**
- `Functor.preservesFiniteLimits_tfae` — `ExactFunctor.lean:116`, four-way equivalence (short-exact-left / exact-left+mono / preserves kernels / preserves finite limits).
- `Functor.exact_tfae` — `ExactFunctor.lean:220`.
- `Functor.preservesMonomorphisms_of_preserves_shortExact_left` — `ExactFunctor.lean:101`.
- `Functor.preservesFiniteColimits_tfae` — `ExactFunctor.lean:176`; `preservesFiniteColimits_iff_forall_exact_map_and_epi` — `:250`.

**Reflection helpers**
- `Limits.preservesFiniteLimits_of_reflects_of_preserves` — `Mathlib/CategoryTheory/Limits/Preserves/Finite.lean:163`: `(F : C ⥤ D) (G : D ⥤ E) [PreservesFiniteLimits (F ⋙ G)] [ReflectsFiniteLimits G] : PreservesFiniteLimits F`.
- `Limits.reflectsFiniteLimits_of_reflectsIsomorphisms` — same file `:175` (instance): `[F.ReflectsIsomorphisms] [HasFiniteLimits C] [PreservesFiniteLimits F] : ReflectsFiniteLimits F`.

# Q2. Stalk machinery for `X.Modules`

**No stalk functor on `X.Modules` — NOT FOUND.** `Mathlib/Algebra/Category/ModuleCat/Stalk.lean` (217 lines) contains only module *structures* on the `Ab`-stalk of the underlying presheaf, no functor:
- `PresheafOfModules.instModule…` at `:165` — `Module (R.stalk x) ↑(TopCat.Presheaf.stalk M.presheaf x)` for `R : X.Presheaf RingCat`
- `PresheafOfModules.germ_ringCat_smul` `:174`, `PresheafOfModules.germ_smul` `:203` (CommRingCat section, `:186`+)
- `Limits.colimit.smul` `:42`, `Limits.IsColimit.module`, `Limits.IsColimit.ι_smul` `:134`

The only stalk-related declaration in `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`:
- `AlgebraicGeometry.Scheme.Modules.restrictStalkNatIso` `:478`
```lean
def restrictStalkNatIso (x : X) :
    restrictFunctor f ⋙ toPresheaf _ ⋙ TopCat.Presheaf.stalkFunctor _ x ≅
    toPresheaf _ ⋙ TopCat.Presheaf.stalkFunctor _ (f x)
```
(`f : X ⟶ Y`, `[IsOpenImmersion f]`), with `germ_restrictStalkNatIso_hom_app` `:487` and `_inv_app` `:498`.

**Mono/exact iff on stalks at `X.Modules` level — NOT FOUND in mathlib; PROJECT-LOCAL versions exist:**
- `AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map` — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:104`: `IsIso φ ↔ ∀ x : X, IsIso ((TopCat.Presheaf.stalkFunctor Ab.{u} x).map ((Scheme.Modules.toPresheaf X).map φ))`
- `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis` — `FlatBaseChange.lean:130`
- `AlgebraicGeometry.Scheme.Modules.mono_of_injective_app_of_isBasis` — `AlgebraicJacobian/Picard/FlatKernelBase.lean:258` (see Q3)
- `AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_restrict` — `ModulesCoverConservativity.lean:37`

Mathlib generics used by these: `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` (`Mathlib/Topology/Sheaves/Stalks.lean:674`), `mono_of_stalk_mono` (`:561`), `stalkFunctor_map_injective_of_isBasis` (`:492`), `app_injective_of_stalkFunctor_map_injective` (`:529`), `CategoryTheory.Sheaf.isIso_iff_of_coversTop` (`Mathlib/CategoryTheory/Sites/LocalProperties.lean:68`).

**Stalk of `pullback g |>.obj F` as `F_{gx} ⊗ O_{S',x}` — NOT FOUND anywhere** (mathlib or workspace). Only the topological-sheaf analogue exists: `TopCat.Presheaf.stalkPullbackIso` / `stalkPullbackHom` / `germToPullbackStalk` in `Mathlib/Topology/Sheaves/Stalks.lean` (for `TopCat.Presheaf.pullback`, not modules). The tilde-side stalk handle is `AlgebraicGeometry.tilde.toStalk` (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean:188`).

# Q3. Project sectionwise / cover-local criteria

## `AlgebraicJacobian/Cohomology/ModulesCoverConservativity.lean` (75 lines, 1 decl, sorry-free)
```lean
theorem AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_restrict
    {X : Scheme} {M N : X.Modules} (φ : M ⟶ N) (𝒰 : X.OpenCover) :
    IsIso φ ↔ ∀ j, IsIso ((Scheme.Modules.restrictFunctor (𝒰.f j)).map φ)
```
`:37`. No quasi-coherence, no affineness, no flatness. Iso-only (not mono/exact).

## `AlgebraicJacobian/Cohomology/TildeExactness.lean` (231 lines, sorry-free, all about `~`, no `pullback`)
- `tilde_preservesFiniteColimits : Limits.PreservesFiniteColimits (tilde.functor R)` `:83`
- `tilde_toStalk_map_injective {M N : ModuleCat R} (f : M ⟶ N) (hf : Function.Injective f.hom) (x : PrimeSpectrum.Top R) : Function.Injective (IsLocalizedModule.map x.asIdeal.primeCompl (tilde.toStalk M x).hom (tilde.toStalk N x).hom f.hom)` `:93`
- `tilde_preservesFiniteLimits_of_preservesKernels (H : ∀ {M N} (f : M ⟶ N), PreservesLimit (parallelPair f 0) (tilde.functor R)) : PreservesFiniteLimits (tilde.functor R)` `:105`
- `tilde_stalkFunctor_map_toStalk` `:120` (germ-naturality transport)
- `tildePreservesFiniteLimits_of_toPresheaf (H : PreservesFiniteLimits (tilde.functor R ⋙ Scheme.Modules.toPresheaf (Spec (.of R)))) : PreservesFiniteLimits (tilde.functor R)` `:153`
- `tilde_germ_algebraMap_smul` `:169`; `stalkMapₗ` `:185` (noncomputable def, `R`-linear `Ab`-stalk map); `stalkMapₗ_eq` `:210`; `stalkMapₗ_injective` `:226`

The header's line 48 statement is directly relevant: it records that the *categorical* glue obstruction is FALSE. Consistent with Q1(b).

## `AlgebraicJacobian/Cohomology/PullbackQuasicoherent.lean` (178 lines, sorry-free)
- `instance opensMapStructuredArrow_isFiltered {T T' : TopCat} (φ : T ⟶ T') (d : Opens T) : IsFiltered (StructuredArrow d (Opens.map φ))` `:55`
- `instance opensMap_final {T T' : TopCat} (φ : T ⟶ T') : (Opens.map φ).Final` `:74`
- `instance pullbackObjUnitToUnit_isIso_hom {Y X : Scheme} (g : Y ⟶ X) : IsIso (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom)` `:80` — **no hypotheses at all on `g`**
- `pullbackUnitIso {Y X} (g : Y ⟶ X) : (Scheme.Modules.pullback g).obj (SheafOfModules.unit X.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf` `:86`
- `presentationPullbackSliceOfOver (g : Y ⟶ X) (F : X.Modules) (A : X.Opens) (P : (F.over A).Presentation) : (((Scheme.Modules.pullback g).obj F).over (g ⁻¹ᵁ A)).Presentation` `:105`
- `pullback_isQuasicoherent_hom {Y X : Scheme.{u}} (g : Y ⟶ X) (F : X.Modules) (hF : F.IsQuasicoherent) : ((Scheme.Modules.pullback g).obj F).IsQuasicoherent` `:158` — **arbitrary `g`, only QC of `F`. No flatness, no affineness.**

## `AlgebraicJacobian/Picard/FlatKernelBase.lean` (the `pullbackKernelComparison` API)
- `Module.Flat.rTensor_injective_of_exact` `:150`, `Module.Flat.lTensor_injective_of_exact` `:176` (`hf : Injective f`, `hfg : Exact f g`, `hg : Surjective g`, `hC : Flat R C`)
- `instance Scheme.Modules.unit_isQuasicoherent (X : Scheme.{u}) : (SheafOfModules.unit X.ringCatSheaf).IsQuasicoherent` `:200`
- `Scheme.Modules.pullbackKernelComparison (g' : X' ⟶ X) {E F : X.Modules} (q : E ⟶ F) : (pullback g').obj (kernel q) ⟶ kernel ((pullback g').map q)` `:215` — no hypotheses
- `Scheme.Modules.pullbackKernelComparison_comp_ι` `:222` (`@[reassoc (attr := simp)]`)
- `Scheme.Modules.epi_pullbackKernelComparison (g' : X' ⟶ X) {E F} (q : E ⟶ F) [Epi q] : Epi (pullbackKernelComparison g' q)` `:241` — **hypotheses: `Epi q` ONLY.** No QC, no affine, no flat.
- `Scheme.Modules.mono_of_injective_app_of_isBasis {X} {M N : X.Modules} {ι} {B : ι → X.Opens} (hB : Opens.IsBasis (Set.range B)) (φ : M ⟶ N) (h : ∀ i, Function.Injective (φ.app (B i))) : Mono φ` `:258` — **no QC, no affine, no flat. Pure basis-local mono criterion.**
- `Scheme.Modules.isIso_pullbackKernelComparison_of_mono (g' : X' ⟶ X) {E F} (q : E ⟶ F) [Epi q] (hmono : Mono ((pullback g').map (kernel.ι q))) : IsIso (pullbackKernelComparison g' q)` `:291` — **hypotheses: `Epi q` + the mono hypothesis. Nothing else.**
- `Scheme.LineBundle.IsLocallyTrivial.trivialization_of_le` `:315`, `.exists_affine_trivializing_le` `:343`

The *heavy* versions live in `DivFunctorDef.lean` (carrying QC + finite presentation + flatness):
- `Scheme.Modules.mono_pullback_map_kernel_ι` — `AlgebraicJacobian/Picard/DivFunctorDef.lean:611`
```lean
theorem Modules.mono_pullback_map_kernel_ι
    {X S X' S' : Scheme.{u}} {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) {E F : X.Modules} (q : E ⟶ F) (hq : Epi q)
    (hE : E.IsQuasicoherent)
    (hfp : F.IsFinitePresentation) (hflat : CoherentSheafFlat f F)
    (hker : LineBundle.IsLocallyTrivial (Limits.kernel q)) :
    Mono ((Scheme.Modules.pullback g').map (Limits.kernel.ι q))
```
- `Modules.pullback_kernel_isLocallyTrivial` `:687`, `Modules.isIso_pullbackKernelComparison` `:718` (same 5 hypotheses).
- Private engines: `Modules.appₗ` `:405`; `app_injective_on_piece` `:426` (needs `[Epi q] [E.IsQuasicoherent] [F.IsQuasicoherent] [(kernel q).IsQuasicoherent] (hflat : CoherentSheafFlat f F)` + three affine opens `hU hV hUt` + `hUSX : V ≤ f ⁻¹ᵁ U`, `hUST : Ut ≤ g ⁻¹ᵁ U`); `app_injective_basicOpen` `:554` (needs `[M.IsQuasicoherent] [N.IsQuasicoherent]` + `IsAffineOpen W`); `section_surjective_of_epi_qcoh` `:292`.
- `Scheme.CoherentSheafFlat` def — `AlgebraicJacobian/Picard/FlatteningStratification.lean:1431`: `∀ affine U ⊆ S, affine V ⊆ X, V ≤ f⁻¹U, Module.Flat Γ(S,U) Γ(F,V)`.

Note the shape mismatch for your goal: `mono_pullback_map_kernel_ι` is about a *cartesian square* with `F` flat **over the base**, not about `g` itself being `Flat`. For your `[Flat g]` statement the relevant flatness fact is `flat_gamma_appLE_of_flat` (`QuotScheme.lean:5202`): `(g : S' ⟶ S) [Flat g] (hV : IsAffineOpen V) (hU : IsAffineOpen U) (e : U ≤ g ⁻¹ᵁ V) : Module.Flat Γ(S,V) Γ(S',U)`, wrapping mathlib's `Scheme.Hom.flat_appLE` (`Mathlib/AlgebraicGeometry/Morphisms/Flat.lean:44`).

# Q4. Limits in `SheafOfModules` / `X.Modules`

All in `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Category/ModuleCat/Sheaf/Limits.lean`:
```lean
noncomputable instance SheafOfModules.createsLimit : CreatesLimit F (forget _)         -- :62
instance SheafOfModules.hasLimit : HasLimit F                                          -- :68
noncomputable instance SheafOfModules.evaluationPreservesLimit (X : Cᵒᵖ) :
    PreservesLimit F (evaluation R X)                                                  -- :70
instance SheafOfModules.hasLimitsOfShape : HasLimitsOfShape D (SheafOfModules.{v} R)   -- :83
noncomputable instance SheafOfModules.evaluationPreservesLimitsOfShape (X : Cᵒᵖ) : ... -- :85
noncomputable instance SheafOfModules.forgetPreservesLimitsOfShape :
    PreservesLimitsOfShape D (forget.{v} R)                                            -- :88
instance SheafOfModules.Finite.hasFiniteLimits : HasFiniteLimits (SheafOfModules.{v} R)-- :95
noncomputable instance SheafOfModules.Finite.evaluationPreservesFiniteLimits (X : Cᵒᵖ) :
    PreservesFiniteLimits (evaluation.{v} R X)                                         -- :98
noncomputable instance SheafOfModules.Finite.forgetPreservesFiniteLimits :
    PreservesFiniteLimits (forget.{v} R)                                               -- :101
instance SheafOfModules.hasLimitsOfSize : HasLimitsOfSize.{v₂, v} (SheafOfModules.{v} R)  -- :106
noncomputable instance SheafOfModules.forgetPreservesLimitsOfSize                      -- :111
noncomputable instance : PreservesFiniteLimits (SheafOfModules.toSheaf.{v} R ⋙ sheafToPresheaf _ _) -- :114
noncomputable instance : PreservesFiniteLimits (SheafOfModules.toSheaf.{v} R)          -- :118
lemma PresheafOfModules.isSheaf_of_isLimit                                             -- :39
```
Note the name in your brief (`SheafOfModules.forgetPreservesFiniteLimits` at "Sheaf/Limits.lean:101") is real but its fully-qualified name is **`SheafOfModules.Finite.forgetPreservesFiniteLimits`** (inside `namespace Finite`), line 101. Typeclass hypotheses of the whole section: `{R : Sheaf J RingCat.{u}}`, and for the `Small`/`Finite` blocks the section variables `(F : D ⥤ SheafOfModules.{v} R)` with `[∀ X, Small.{v} (((F ⋙ evaluation R X) ⋙ forget _).sections)]`, `[HasLimitsOfShape D AddCommGrpCat.{v}]`. The `Finite` instances take no extra hypotheses.

**Does `forget` REFLECT finite limits?** Not stated in mathlib as a named lemma, but derivable and I verified it synthesises: `forget` is fully faithful (`SheafOfModules.fullyFaithfulForget`, `Mathlib/Algebra/Category/ModuleCat/Sheaf.lean:73`; `ReflectsIsomorphisms` at `:80`), preserves finite limits, and `HasFiniteLimits` holds, so `reflectsFiniteLimits_of_reflectsIsomorphisms` fires. VERIFIED:
```lean
example (X : Scheme.{u}) : ReflectsFiniteLimits (Scheme.Modules.toPresheafOfModules X) := inferInstance  -- ✓
example (X : Scheme.{u}) : ReflectsFiniteLimits (Scheme.Modules.toPresheaf X)          := inferInstance  -- ✓
example (X : Scheme.{u}) : PreservesFiniteLimits (Scheme.Modules.toPresheaf X)         := inferInstance  -- ✓
example (X : Scheme.{u}) (U : X.Opensᵒᵖ) :
    PreservesFiniteLimits (SheafOfModules.evaluation X.ringCatSheaf U)                 := inferInstance  -- ✓
```

**Kernels sectionwise:** no named "kernel is computed sectionwise" lemma. The mechanism is `createsLimit`/`evaluationPreservesFiniteLimits` above. Presheaf level: `PresheafOfModules.evaluationJointlyReflectsLimits` (`Presheaf/Limits.lean:40`), `limitPresheafOfModules` `:72`, `evaluation_preservesFiniteLimits` `:152`, `toPresheaf_preservesFiniteLimits` `:155`. Kernels are literally computed pointwise in `Presheaf/Abelian.lean:35` via `evaluationJointlyReflectsLimits`.

**Mono is sectionwise** (this is what you'd feed the Q1(b) route). `Mathlib/Algebra/Category/ModuleCat/Presheaf/EpiMono.lean`:
```lean
lemma PresheafOfModules.mono_of_injective (hf : ∀ ⦃X : Cᵒᵖ⦄, Function.Injective (f.app X)) : Mono f  -- :36
lemma PresheafOfModules.injective_of_mono [Mono f] (X : Cᵒᵖ) : Function.Injective (f.app X)         -- :54
lemma PresheafOfModules.mono_iff_surjective : Mono f ↔ ∀ ⦃X⦄, Function.Injective (f.app X)          -- :64  (misnamed; it IS the mono/injective iff)
lemma PresheafOfModules.epi_of_surjective / surjective_of_epi / epi_iff_surjective        -- :30 / :49 / :59
```
Both directions transfer to `X.Modules` — VERIFIED compiling:
```lean
example (X : Scheme.{u}) {M N : X.Modules} (φ : M ⟶ N)
    (h : ∀ U : X.Opens, Function.Injective (φ.app U)) : Mono φ := ...  -- ✓ via mono_of_injective + mono_of_mono_map
example (X : Scheme.{u}) {M N : X.Modules} (φ : M ⟶ N) [Mono φ] (U : X.Opens) :
    Function.Injective (φ.app U) := ...                                -- ✓ via injective_of_mono
```

Abelian: `AlgebraicGeometry.Scheme.Modules.instAbelian` at `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:48`; `SheafOfModules.instAbelian` at `Sheaf/Abelian.lean:40` (needs `[HasSheafify J AddCommGrpCat.{v}] [J.WEqualsLocallyBijective AddCommGrpCat.{v}]`; both synthesise for `Opens.grothendieckTopology X` — verified).

# Q5. Presheaf-level pullback

**Mathlib: NO pointwise description, NO limit-preservation, NO `extendScalars` identification.** `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean` (163 lines) is purely abstract:
```lean
noncomputable def PresheafOfModules.pullback (φ : S ⟶ F.op ⋙ R) :
    PresheafOfModules.{v} S ⥤ PresheafOfModules.{v} R := (pushforward.{v} φ).leftAdjoint   -- :44
noncomputable def pullbackPushforwardAdjunction : pullback.{v} φ ⊣ pushforward.{v} φ        -- :50
abbrev pullbackObjIsDefined : ObjectProperty (PresheafOfModules.{v} S)                      -- :56
noncomputable def pushforwardCompCoyonedaFreeYonedaCorepresentableBy (X : C)                -- :70
lemma pullbackObjIsDefined_free_yoneda (X : C)                                              -- :82
lemma pullbackObjIsDefined_eq_top : pullbackObjIsDefined.{u} φ = ⊤                          -- :86
instance : (pushforward.{u} φ).IsRightAdjoint                                               -- :97
noncomputable def pullbackId (S) : pullback.{v} (F := 𝟭 C) (𝟙 S) ≅ 𝟭 _                     -- :117
noncomputable def pullbackComp : pullback φ ⋙ pullback ψ ≅ pullback (φ ≫ whiskerLeft F.op ψ) -- :131
lemma pullback_assoc :138 / pullback_id_comp :151 / pullback_comp_id :156
```
Grep for `Flat`/`PreservesMonomorphisms`/`stalk` in this file and in `Sheaf/PullbackContinuous.lean`: **zero hits.**

**ChangeOfRings — no `extendScalars`, no flatness instance.**
`Mathlib/Algebra/Category/ModuleCat/Presheaf/ChangeOfRings.lean` (73 lines) has ONLY restriction:
```lean
noncomputable def PresheafOfModules.restrictScalarsObj (M' : PresheafOfModules.{v} R') (α : R ⟶ R') :
    PresheafOfModules R                                                        -- :32  (@[simps])
noncomputable def PresheafOfModules.restrictScalars (α : R ⟶ R') :
    PresheafOfModules.{v} R' ⥤ PresheafOfModules.{v} R                         -- :52  (@[simps])
instance (α : R ⟶ R') : (restrictScalars.{v} α).Additive                       -- :61
instance : (restrictScalars (𝟙 R)).Full := inferInstanceAs (𝟭 _).Full          -- :63
instance (α : R ⟶ R') : (restrictScalars α).Faithful                           -- :65
noncomputable def restrictScalarsCompToPresheaf (α) : restrictScalars α ⋙ toPresheaf R ≅ toPresheaf R' := Iso.refl _  -- :70
```
`Mathlib/Algebra/Category/ModuleCat/Sheaf/ChangeOfRings.lean` (70 lines):
```lean
noncomputable def SheafOfModules.restrictScalars (α : R ⟶ R') :
    SheafOfModules.{v} R' ⥤ SheafOfModules.{v} R                               -- :36  (@[simps])
instance : (SheafOfModules.restrictScalars.{v} α).Additive                     -- :43
noncomputable def PresheafOfModules.restrictHomEquivOfIsLocallySurjective
    (hM₂ : Presheaf.IsSheaf J M₂.presheaf) [Presheaf.IsLocallySurjective J α] :
    (M₁ ⟶ M₂) ≃ ((restrictScalars α).obj M₁ ⟶ (restrictScalars α).obj M₂)     -- :54
```
**`PresheafOfModules.extendScalars` does NOT EXIST in mathlib.** No flatness-related instance in either file.

**Identity-site special case:** `PresheafOfModules.pullbackId` (`Pullback.lean:117`) is the `φ = 𝟙` case only, not the "identity site functor, nontrivial ring map" case. The "only-the-ring-changes" pullback is NOT identified with any extension of scalars in mathlib. What *is* available and definitional: `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`, and `restrictScalars φ = pushforward (F := 𝟭 C) φ` on the nose.

**Module-level flat exactness (the algebraic target you want to reach):** `Mathlib/Algebra/Category/ModuleCat/Descent.lean`
```lean
lemma ModuleCat.preservesFiniteLimits_tensorLeft_of_ringHomFlat (hf : f.Flat) :
    PreservesFiniteLimits (tensorLeft ((restrictScalars f).obj (ModuleCat.of B B)))   -- :36
lemma ModuleCat.preservesFiniteLimits_extendScalars_of_flat (hf : f.Flat) :
    PreservesFiniteLimits (extendScalars.{_, _, u} f)                                 -- :42
lemma ModuleCat.reflectsIsomorphisms_extendScalars_of_faithfullyFlat                 -- :49
def comonadicExtendScalars (hf : f.FaithfullyFlat)                                   -- :59
```
(`{A B : Type u} [CommRing A] [CommRing B] {f : A →+* B}`.)

## **The Lan decomposition DOES EXIST — in your own project**
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, namespace `AlgebraicGeometry.Scheme.Modules`, section `PullbackLanDecomposition`, with `variable {C : Type u} [Category.{u} C] {D : Type u} [Category.{u} D] {F : C ⥤ D} {R : Dᵒᵖ ⥤ RingCat.{u}} {S : Cᵒᵖ ⥤ RingCat.{u}}`:
```lean
private lemma pushforward₀IsRightAdjoint (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    (PresheafOfModules.pushforward₀.{u} F R).IsRightAdjoint                          -- :1041
private lemma restrictScalarsIsRightAdjoint (φ : S ⟶ F.op ⋙ R) :
    (PresheafOfModules.restrictScalars.{u} φ).IsRightAdjoint                         -- :1047
noncomputable def pullback0 (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    PresheafOfModules.{u} (F.op ⋙ R) ⥤ PresheafOfModules.{u} R                       -- :1056
noncomputable def extendScalars (φ : S ⟶ F.op ⋙ R) :
    PresheafOfModules.{u} S ⥤ PresheafOfModules.{u} (F.op ⋙ R)                       -- :1064
noncomputable def pullback0Adjunction (F) (R) : pullback0 F R ⊣ PresheafOfModules.pushforward₀ F R  -- :1070
noncomputable def extendScalarsAdjunction (φ) : extendScalars φ ⊣ PresheafOfModules.restrictScalars φ -- :1076
noncomputable def pullbackLanDecomposition (φ : S ⟶ F.op ⋙ R) :
    PresheafOfModules.pullback φ ≅ extendScalars φ ⋙ pullback0 F R                    -- :1087
```
All sorry-free. (Duplicate copy in `SubProjects/Line-Bundle-Comparison-Iso/.../TensorObjSubstrate.lean:1284`.) Mathlib backing: `PresheafOfModules.pushforward₀` at `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:62`, `pushforward` at `:89`, `pushforwardId` at `:128`.

**Prior art on the presheaf-mono reduction** (exactly your `sorry`, for `j_!`): `SubProjects/RelatedPapersFormalisation/MR0555258-Compactifying-Picard/MR0555258CompactifyingPicard/Basic.lean`
```lean
theorem …extensionByZero_preservesMonomorphisms_of_presheafPullback
    [hp : (PresheafOfModules.pullback.{u} (restrictionRingSheafHom j).hom).PreservesMonomorphisms] :
    (extensionByZero j).PreservesMonomorphisms                     -- :3394
theorem …extensionByZero_preservesFiniteLimits_of_presheafPullback
    [(PresheafOfModules.pullback.{u} (restrictionRingSheafHom j).hom).PreservesMonomorphisms] :
    PreservesFiniteLimits (extensionByZero j)                      -- :3415
```
Its docstring (line ~3443) records the wall verbatim: "blocked on an absent pointwise Lan formula for the partial-adjoint presheaf pullback."

# Bottom line for your proof

Two viable routes, both with the categorical glue now *fully verified*:

**Route A (recommended, shortest):** prove `(Scheme.Modules.pullback g).PreservesMonomorphisms` for `[Flat g]`, then close with the 5-line Q1(b) block. I compiled the full glue against real project types (`Scheme.Modules.pullback g`, `g.toRingCatSheafHom`):
```lean
example {X Y : Scheme.{u}} (g : Y ⟶ X)
    [hp : (PresheafOfModules.pullback.{u} g.toRingCatSheafHom.hom).PreservesMonomorphisms] :
    PreservesFiniteLimits (Scheme.Modules.pullback g) := by
  haveI hmono : (Scheme.Modules.pullback g).PreservesMonomorphisms := by
    have e := SheafOfModules.pullbackIso.{u} g.toRingCatSheafHom
    refine (Functor.preservesMonomorphisms.iso_iff e).mpr ?_
    refine @Functor.preservesMonomorphisms_comp _ _ _ _ _ _ _ _ ?_ ?_
    · exact preservesMonomorphisms_of_preservesLimitsOfShape _
    · refine @Functor.preservesMonomorphisms_comp _ _ _ _ _ _ _ _ hp ?_
      exact preservesMonomorphisms_of_preservesLimitsOfShape
        (PresheafOfModules.sheafification (R₀ := Y.ringCatSheaf.obj) (𝟙 Y.ringCatSheaf.obj))
  rw [(Scheme.Modules.pullback g).preservesFiniteLimits_iff_forall_exact_map_and_mono]
  intro T hT
  haveI := hT.mono_f; haveI := hT.epi_g
  exact ⟨(hT.exact).map_of_epi_of_preservesCokernel _ hT.epi_g inferInstance, inferInstance⟩
```
(the `hp` presheaf hypothesis is optional — that's the *hard* factorisation route; you can instead prove `(Scheme.Modules.pullback g).PreservesMonomorphisms` directly at the sheaf level via the basis-local criterion, which avoids the presheaf-Lan wall entirely).

**Route A′ (avoids the presheaf-Lan wall — most promising):** `Mono φ` in `X.Modules` needs, by `Scheme.Modules.mono_of_injective_app_of_isBasis` (`FlatKernelBase.lean:258`, no QC/affine hypotheses), only sectionwise injectivity on a *basis*. Combine with the affine-open section formula `Scheme.Modules.pullback_app_isoTensor` (`QuotScheme.lean:4967`, `Γ((pullback g).obj N, U) ≃ₗ[Γ(Y,U)] Γ(Y,U) ⊗_{Γ(X,V)} Γ(N,V)` for affine `U ≤ g⁻¹V`, requires `[N.IsQuasicoherent]`), the flatness `flat_gamma_appLE_of_flat` (`QuotScheme.lean:5202`, `[Flat g]` ⟹ `Module.Flat Γ(S,V) Γ(S',U)`), and `app_injective_basicOpen` (`DivFunctorDef.lean:554`). **Caveat:** this needs quasi-coherence of the source, which your statement does not have — so it proves the flat left-exactness only after restricting to quasi-coherent modules, or requires a general (non-QC) mono argument.

**Route B:** kernel-preservation route via `preservesFiniteLimits_of_preservesKernels` (`LeftExact.lean:117`) — strictly more work than Route A, since Route A's mono hypothesis is one of the two halves that route needs anyway.

**Dead ends confirmed:** no stalk functor on `X.Modules`; no stalk description of the module pullback; no pointwise/Lan formula, no limit-preservation, and no `extendScalars` identification for `PresheafOfModules.pullback` in mathlib. Two independent prior sessions (yours at `CechHigherDirectImageUnconditional.lean:154` and the MR0555258 subproject at `Basic.lean:3443`) independently hit the same presheaf-Lan wall — so Route A′ (sheaf-level, basis-local, bypassing presheaves) is the one that has not yet been walled.
