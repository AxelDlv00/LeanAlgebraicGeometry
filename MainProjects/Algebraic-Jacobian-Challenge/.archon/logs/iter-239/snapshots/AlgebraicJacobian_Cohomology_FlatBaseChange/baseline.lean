/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Flat base change for the pushforward of a quasi-coherent sheaf (`i = 0`)

This file establishes the `i = 0` (direct-image) case of flat base change: the
formation of the pushforward `f_* F` of a quasi-coherent sheaf commutes with flat
base change on the target.

Throughout we work with a (commutative, eventually cartesian) square of schemes
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
recorded by morphisms `f : X ⟶ S`, `g : S' ⟶ S`, `f' : X' ⟶ S'`, `g' : X' ⟶ X`
with `g' ≫ f = f' ≫ g`, and `F : X.Modules` a sheaf of modules on `X`.

The three main declarations are:

* `AlgebraicGeometry.pushforwardBaseChangeMap` — the canonical base-change map
  `g^*(f_* F) ⟶ f'_*((g')^* F)`, built as the adjoint mate of the unit of the
  `((g')^*, (g')_*)`-adjunction.
* `AlgebraicGeometry.affineBaseChange_pushforward_iso` — for `f` affine and the
  square cartesian, the base-change map is an isomorphism (affine case: tensor
  associativity).
* `AlgebraicGeometry.flatBaseChange_pushforward_isIso` — for `g` flat and `f`
  quasi-compact quasi-separated, the base-change map is an isomorphism.

See `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`.

Source: Stacks Project, Cohomology of Schemes, §"Cohomology and base change, I",
Tag 02KH.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {S S' X X' : Scheme.{u}}
  (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)

/-- The canonical base-change map for the pushforward of a sheaf of modules.

Given a commutative square
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
(with `comm : g' ≫ f = f' ≫ g`) and a sheaf of modules `F` on `X`, this is the
canonical morphism `g^*(f_* F) ⟶ f'_*((g')^* F)` of sheaves of modules on `S'`.

It is the image, under the `(g^*, g_*)`-adjunction transpose, of the composite
```
  f_* F --f_*(unit)--> f_* (g')_* (g')^* F
        = (g' ≫ f)_* (g')^* F = (f' ≫ g)_* (g')^* F = g_* f'_* (g')^* F,
```
where `unit` is the unit of the `((g')^*, (g')_*)`-adjunction and the middle
equalities are the pseudofunctoriality of pushforward together with the
commutativity of the square.

Source: Stacks Project, Cohomology of Schemes, §"Cohomology and base change, I",
base-change diagram. -/
noncomputable def pushforwardBaseChangeMap (comm : g' ≫ f = f' ≫ g) (F : X.Modules) :
    (Scheme.Modules.pullback g).obj ((pushforward f).obj F) ⟶
      (pushforward f').obj ((Scheme.Modules.pullback g').obj F) :=
  ((pullbackPushforwardAdjunction g).homEquiv _ _).symm
    ((pushforward f).map ((pullbackPushforwardAdjunction g').unit.app F) ≫
      (pushforwardComp g' f).hom.app _ ≫
      (pushforwardCongr comm).hom.app _ ≫
      (pushforwardComp f' g).inv.app _)

/-! ## Project-local Mathlib supplement — locality of isomorphisms for `Scheme.Modules`

Mathlib provides the per-open criterion `Scheme.Modules.Hom.isIso_iff_isIso_app`
(`IsIso φ ↔ ∀ U, IsIso (φ.app U)`) and the stalkwise criterion
`TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` for `TopCat.Sheaf`-valued morphisms,
but it does not package the stalk-local criterion at the level of `Scheme.Modules`
morphisms. The following lemmas bridge that gap; they are the locality tools needed for
the affine reduction of `affineBaseChange_pushforward_iso` (where one checks the
base-change map after restricting to / taking stalks over affine opens). -/

/-- **Stalk-local criterion for isomorphisms of `𝒪_X`-modules.** A morphism `φ : M ⟶ N`
of sheaves of modules over a scheme `X` is an isomorphism iff its underlying morphism of
abelian presheaves is a stalkwise isomorphism. Project-local: Mathlib only ships the
per-open criterion and the `TopCat.Sheaf`-level stalk criterion separately. -/
theorem Modules.isIso_iff_isIso_stalkFunctor_map {X : Scheme.{u}} {M N : X.Modules}
    (φ : M ⟶ N) :
    IsIso φ ↔ ∀ x : X, IsIso ((TopCat.Presheaf.stalkFunctor Ab.{u} x).map
      ((Scheme.Modules.toPresheaf X).map φ)) := by
  constructor
  · intro h x
    haveI : IsIso ((Scheme.Modules.toPresheaf X).map φ) := Functor.map_isIso _ _
    exact Functor.map_isIso _ _
  · intro h
    -- Package the underlying abelian presheaves as `TopCat.Sheaf`es.
    let MS : TopCat.Sheaf Ab.{u} X := ⟨M.presheaf, M.isSheaf⟩
    let NS : TopCat.Sheaf Ab.{u} X := ⟨N.presheaf, N.isSheaf⟩
    let fS : MS ⟶ NS := ⟨(Scheme.Modules.toPresheaf X).map φ⟩
    haveI : ∀ x : X, IsIso ((TopCat.Presheaf.stalkFunctor Ab.{u} x).map fS.hom) := h
    haveI hSiso : IsIso fS := TopCat.Presheaf.isIso_of_stalkFunctor_map_iso fS
    have h1 : IsIso ((Scheme.Modules.toPresheaf X).map φ) :=
      (TopCat.Sheaf.forget Ab.{u} X).map_isIso fS
    exact (CategoryTheory.isIso_iff_of_reflects_iso φ (Scheme.Modules.toPresheaf X)).mp h1

/-- **Basis-local criterion for isomorphisms of `𝒪_X`-modules.** If `B` is a basis of
opens of `X` and `φ : M ⟶ N` restricts to an isomorphism on the sections over every basic
open `B i`, then `φ` is an isomorphism. This reduces iso-checking from *all* opens (the
content of `Scheme.Modules.Hom.isIso_iff_isIso_app`) to a chosen basis. Project-local:
Mathlib provides the stalkwise pieces (`germ_exist_of_isBasis`,
`stalkFunctor_map_injective_of_isBasis`) but not the packaged criterion at the
`Scheme.Modules` level. -/
theorem Modules.isIso_of_isIso_app_of_isBasis {X : Scheme.{u}} {M N : X.Modules}
    {ι : Type*} {B : ι → X.Opens} (hB : TopologicalSpace.Opens.IsBasis (Set.range B))
    (φ : M ⟶ N) (h : ∀ i, IsIso (φ.app (B i))) : IsIso φ := by
  -- Reduce to a stalkwise isomorphism of the underlying `Ab`-presheaf morphism `α`.
  rw [Modules.isIso_iff_isIso_stalkFunctor_map]
  intro x
  -- `α.app (op (B i))` is definitionally `φ.app (B i)`, hence an isomorphism on each basic open.
  have happ : ∀ U ∈ Set.range B,
      IsIso (((Scheme.Modules.toPresheaf X).map φ).app (Opposite.op U)) := by
    rintro U ⟨i, rfl⟩; exact h i
  rw [CategoryTheory.ConcreteCategory.isIso_iff_bijective]
  refine ⟨?_, ?_⟩
  · -- Injectivity of the stalk map from injectivity on a basis.
    refine TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis hB ?_ x
    intro U hU
    haveI := happ U hU
    exact (CategoryTheory.ConcreteCategory.bijective_of_isIso
      (((Scheme.Modules.toPresheaf X).map φ).app (Opposite.op U))).injective
  · -- Surjectivity: a germ at `x` comes from a section over a basic open, where `α` is onto.
    intro t
    obtain ⟨U, hxU, hU, s, rfl⟩ :=
      TopCat.Presheaf.germ_exist_of_isBasis hB N.presheaf x t
    haveI := happ U hU
    obtain ⟨s', hs'⟩ := (CategoryTheory.ConcreteCategory.bijective_of_isIso
      (((Scheme.Modules.toPresheaf X).map φ).app (Opposite.op U))).surjective s
    refine ⟨M.presheaf.germ U x hxU s', ?_⟩
    erw [TopCat.Presheaf.stalkFunctor_map_germ_apply]
    rw [hs']
    rfl

/-- **Affine-open locality criterion for isomorphisms of `𝒪_X`-modules.** A morphism
`φ : M ⟶ N` of sheaves of modules is an isomorphism iff it restricts to an isomorphism on
the sections over every affine open of `X`. This is the precise reduction used in the
affine proof of `affineBaseChange_pushforward_iso`: the affine opens of `X` form a basis,
and over an affine open the base-change map becomes the pure ring-theoretic
`cancelBaseChange` isomorphism. -/
theorem Modules.isIso_iff_isIso_app_affineOpens {X : Scheme.{u}} {M N : X.Modules}
    (φ : M ⟶ N) : IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U) := by
  refine ⟨fun _ U => inferInstance, fun h => ?_⟩
  exact Modules.isIso_of_isIso_app_of_isBasis
    (B := (Subtype.val : X.affineOpens → X.Opens))
    (by simpa [Subtype.range_val] using X.isBasis_affineOpens) φ h

/-! ## Project-local Mathlib supplement — affine tilde dictionary (global sections)

The affine reduction of `affineBaseChange_pushforward_iso` needs to translate
`Scheme.Modules.pushforward (Spec.map φ)` of a `tilde`-module into restriction of
scalars. The first concrete piece is the *global-sections* identification: for a
ring map `φ : R ⟶ R'` and an `R'`-module `M`, the `R`-module of global sections of
the pushforward of `M^~` should be the restriction of scalars along `φ` of the
`R'`-module of global sections of `M^~`. Both have the same underlying additive
group (the global sections `Γ(M^~, ⊤)`, since `(Spec.map φ)⁻¹ᵁ ⊤ = ⊤`); the only
content is that the two `R`-actions agree, which is exactly the naturality of
`Scheme.ΓSpecIso` (`ΓSpecIso_inv_naturality`: the global-sections map of `Spec.map φ`
is `φ`).

STATUS (iter-234): the iso

  `(ModuleCat.restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R := R')).obj (tilde M))
     ≅ (moduleSpecΓFunctor (R := R)).obj ((pushforward (Spec.map φ)).obj (tilde M))`

typechecks via `LinearEquiv.toModuleIso` with the identity `AddEquiv` on the common
carrier **only under** `set_option backward.isDefEq.respectTransparency false`, and
its sole `map_smul'` goal reduces (after `erw [ModuleCat.restrictScalars.smul_def]`)
to showing the `R`-action of the restriction of scalars (defeq `φ.hom r • s`, an
`R'`-action) agrees with the `R`-action of `moduleSpecΓFunctor (R)` of the pushforward.
That action is `Module.compHom` along `(StructureSheaf.globalSectionsIso R).hom` of the
`Γ(Spec R, ⊤)`-action, which is in turn `restrictScalars` along the pushforward ring map
`(Spec.map φ).appTop`, landing on the `Γ(Spec R', ⊤)`-action. The two sides therefore
both reduce to `c • s` for a common `Γ(Spec R', ⊤)`-action, with the scalars equal by
`ΓSpecIso_inv_naturality`. The BLOCKER is purely instance-level: the intermediate
`Γ(Spec R, ⊤)`- and `Γ(Spec R', ⊤)`-actions are buried in `Module.compHom` /
`ModuleCat.restrictScalars` and are not synthesizable `SMul`/`Module` instances on the
final carrier type, so `change`/`rw`/`rfl`/`IsScalarTower.algebraMap_smul` cannot name
the common action. Closing it needs either (a) a term-mode `@`-explicit smul reduction
threading the `Module.compHom`/`restrictScalars` instances by hand, then
`ΓSpecIso_inv_naturality`; or (b) a functorial construction via
`ModuleCat.restrictScalarsComp` (× 2) + an `eqToIso` from the RingHom equality
`(Spec.map φ).appTop ≫ (ΓSpecIso R').inv = (ΓSpecIso R).inv ≫ ... ` so that no element
smul is touched. The informal agent was unavailable (MOONSHOT_API_KEY → HTTP 401; no
other provider key set). See `task_results` for the full attempt log.

UPDATE (iter-236): route (a) is **empirically the carrier wall** and is now confirmed
DEAD. The `LinearEquiv.toModuleIso` with `AddEquiv.refl` typechecks once the linear
equivalence is annotated with the explicit ring `≃ₗ[(R : Type u)]` (no
`respectTransparency` needed), and its `map_smul'` goal, after `rw [RingHom.id_apply]`
+ four `erw [ModuleCat.restrictScalars.smul_def]`, reduces **exactly** to
`A • m = B • m` where `A, B : Γ(Spec R', ⊤)` are equal by `ΓSpecIso_inv_naturality`.
But `A` lives in the *type alias*
`((Opens.map (Spec.map φ).base).op ⋙ ringCatSheaf).obj (op ⊤)`, which is only **defeq**
(via `(Spec.map φ)⁻¹ᵁ ⊤ = ⊤`, `rfl`) to `B`'s type `ringCatSheaf.obj (op ⊤)`. Every
finisher (`congr 1` → `whnf` timeout; `congrArg (· • m)`, `change _ • (m : …) = _`,
forcing the binder type) fails at `failed to synthesize HSMul Γ(Spec R',⊤) ↑(carrier)`
because instance resolution does not reduce the alias to find the registered
`Module Γ(Spec R',⊤) (carrier)` instance. This is the documented carrier-instance wall.

Route (b) (element-free) is now **executed and axiom-clean** (iter-236): the
`Γ`-fragment iso is `gammaPushforwardIso` below (general `N`), with the tilde
specialisation `gammaPushforwardTildeIso`. The construction is exactly the planned one:
both `(moduleSpecΓFunctor (R := R)).obj ((pushforward (Spec.map φ)).obj N)` and
`(restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R := R')).obj N)` peel **by `rfl`** to
nested `ModuleCat.restrictScalars` towers over the common `Γ(N, ⊤)` (the
`forgetToSheafModuleCat` / `initialOpOfTerminal` wrapping is an identity restriction);
the towers are reconciled by `ModuleCat.restrictScalarsComp'App` (×2) + an `eqToIso`
from the ring equation `globalSectionsIso_hom_comp_specMap_appTop` — NO element-level
`smul`, dodging the route-(a) carrier wall.

What remains for the full object iso `pushforward_spec_tilde_iso`
(`pushforward (Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`): the comparison
factors as `pushforward (tilde M) ⟵[fromTildeΓ] tilde (Γ (pushforward (tilde M)))
⟶[tilde.map gammaPushforwardTildeIso.hom] tilde (restrictScalars φ M)`, where the second
map is an iso (tilde of an iso) but `fromTildeΓ (pushforward (tilde M))` is an iso **iff**
`pushforward (Spec φ)_* (tilde M)` is quasi-coherent. That QC fact is the sole remaining
obligation; it is Mathlib-absent and circular with the obvious counit route (`Γ` only
reflects isos between QC objects, since the tilde adjunction unit — not the counit — is
the iso), so it needs an independent argument: either a `SheafOfModules.Presentation` of
the pushforward, or `IsQuasicoherent.of_coversTop` over the basic opens with the
slice/over-category restriction shown QC, or a direct `Modules.isIso_of_isIso_app_of_isBasis`
construction of the object iso on basic opens via `IsLocalizedModule`
(`(restrictScalars φ M)` localised at `a` = `M` localised at `φ a`). -/

/-! ## Project-local Mathlib supplement — global-sections / pushforward ring map -/

/-- The global-sections comparison ring map underlying `Spec.map φ` at the top open is
conjugate to `φ` via the global-sections isomorphisms `Γ(Spec -) ≅ -`. Concretely, the
square
```
  R  --gsR.hom-->  Γ(Spec R, ⊤)
  |φ                     |(Spec.map φ).appTop
  v                      v
  R' --gsR'.hom--> Γ(Spec R', ⊤)
```
commutes, where `gsR = StructureSheaf.globalSectionsIso R`. This is the ring-level
heart of the affine pushforward-of-tilde identification (`pushforward_spec_tilde_iso`):
it is exactly the `eqToIso` hypothesis required by the element-free
`ModuleCat.restrictScalarsComp'` route for the Γ-fragment iso (route (b) above), since
`moduleSpecΓFunctor` builds its `R`-action by `restrictScalars` along `gsR.hom` and the
pushforward builds its `Γ(Spec R, ⊤)`-action by `restrictScalars` along
`(Spec.map φ).appTop`. Project-local: Mathlib ships the underlying
`Scheme.ΓSpecIso_inv_naturality` but not this `globalSectionsIso`/`appTop` form. -/
theorem globalSectionsIso_hom_comp_specMap_appTop {R R' : CommRingCat.{u}} (φ : R ⟶ R') :
    (StructureSheaf.globalSectionsIso ↑R).hom ≫ (Spec.map φ).appTop
      = φ ≫ (StructureSheaf.globalSectionsIso ↑R').hom := by
  have hR : (StructureSheaf.globalSectionsIso ↑R).hom = (Scheme.ΓSpecIso R).inv := rfl
  have hR' : (StructureSheaf.globalSectionsIso ↑R').hom = (Scheme.ΓSpecIso R').inv := rfl
  rw [hR, hR']
  exact (Scheme.ΓSpecIso_inv_naturality φ).symm

/-! ## Project-local Mathlib supplement — Γ of an affine pushforward -/

/-- **Global sections of an affine pushforward = restriction of scalars.** For a ring
map `φ : R ⟶ R'` and *any* sheaf of modules `N` on `Spec R'`, the `R`-module of global
sections of the pushforward `(Spec φ)_* N` is the restriction of scalars along `φ` of the
`R'`-module of global sections of `N`. Built element-free (route (b)): both sides peel
(by `rfl`) to nested `ModuleCat.restrictScalars` towers over the common global-section
module `Γ(N, ⊤)`; the two towers are reconciled by collapsing each via
`ModuleCat.restrictScalarsComp'App` and applying the ring equation
`globalSectionsIso_hom_comp_specMap_appTop`. No element-level scalar multiplication is
touched, dodging the carrier-instance wall. Project-local: the affine companion of the
global-sections fragment of flat base change. -/
noncomputable def gammaPushforwardIso {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (N : (Spec R').Modules) :
    (moduleSpecΓFunctor (R := R)).obj ((Scheme.Modules.pushforward (Spec.map φ)).obj N) ≅
      (ModuleCat.restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R := R')).obj N) := by
  set SecN : ModuleCat ↑((Spec R').ringCatSheaf.obj.obj (Opposite.op ⊤)) :=
    (((SheafOfModules.forgetToSheafModuleCat (Spec R').ringCatSheaf (Opposite.op ⊤)
        (Limits.initialOpOfTerminal Limits.isTerminalTop)).obj N).val.obj (Opposite.op ⊤)) with hSecN
  set gsRhom := (StructureSheaf.globalSectionsIso ↑R).hom.hom with hgsR
  set gsR'hom := (StructureSheaf.globalSectionsIso ↑R').hom.hom with hgsR'
  set pushTop := ((Spec.map φ).toRingCatSheafHom.hom.app (Opposite.op ⊤)).hom with hpush
  have hcomp : pushTop.comp gsRhom = gsR'hom.comp φ.hom := by
    apply RingHom.ext
    intro x
    simpa [hpush, hgsR, hgsR', RingHom.comp_apply] using
      congr($(globalSectionsIso_hom_comp_specMap_appTop φ).hom x)
  exact (ModuleCat.restrictScalarsComp'App gsRhom pushTop (pushTop.comp gsRhom) rfl SecN).symm ≪≫
    eqToIso (congrArg (fun h => (ModuleCat.restrictScalars h).obj SecN) hcomp) ≪≫
    (ModuleCat.restrictScalarsComp'App φ.hom gsR'hom (gsR'hom.comp φ.hom) rfl SecN)

/-- **Γ-fragment for a tilde-module.** Specialising `gammaPushforwardIso` to `N = M^~`
and using the unit iso `tilde.toTildeΓNatIso` (`Γ(M^~, ⊤) ≅ M`), the `R`-module of global
sections of `(Spec φ)_* (M^~)` is the restriction of scalars of `M` along `φ`. This is the
`Γ`-fragment comparison used to recognise the section-level base-change map in the affine
reduction of `affineBaseChange_pushforward_iso`. Project-local: corollary of
`gammaPushforwardIso`. -/
noncomputable def gammaPushforwardTildeIso {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (M : ModuleCat.{u} R') :
    (moduleSpecΓFunctor (R := R)).obj
        ((Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M)) ≅
      (ModuleCat.restrictScalars φ.hom).obj M :=
  gammaPushforwardIso φ (tilde M) ≪≫
    (ModuleCat.restrictScalars φ.hom).mapIso (tilde.toTildeΓNatIso.app M).symm

/-! ## Project-local Mathlib supplement — restriction of scalars and localization -/

/-- **Counit of the tilde–Γ adjunction is a basic-open isomorphism whenever the restriction
of the global sections is a localization.** For a sheaf of modules `N` on `Spec R` and `a : R`,
if the structure-sheaf restriction map `Γ(N, ⊤) → Γ(N, D(a))` (read in `ModuleCat R` via the
global-sections forgetful functor `modulesSpecToSheaf`) exhibits `Γ(N, D(a))` as the localization
of `Γ(N, ⊤)` at `Submonoid.powers a`, then the counit `fromTildeΓ N` is an isomorphism on the
sections over `D(a)`. This is the section-level engine of `pushforward_spec_tilde_iso`: it isolates
the *only* nontrivial input (`Γ(N, D(a)) = Γ(N, ⊤)[1/a]`) and discharges the rest — the comparison
`fromTildeΓ` is, on `D(a)`, the canonical map between two localizations of `Γ(N, ⊤)` (the tilde
localization `toOpen` and the restriction), hence an isomorphism by the uniqueness of localized
modules. Project-local: Mathlib has the localization-uniqueness lemmas but not this packaging at
the level of `fromTildeΓ`. -/
lemma fromTildeΓ_app_isIso_of_isLocalizedModule {R : CommRingCat.{u}} (N : (Spec R).Modules)
    (a : R)
    [IsLocalizedModule (Submonoid.powers a)
      ((modulesSpecToSheaf.obj N).val.map
        (homOfLE (show PrimeSpectrum.basicOpen a ≤ ⊤ from le_top)).op).hom] :
    IsIso (Scheme.Modules.Hom.app N.fromTildeΓ (PrimeSpectrum.basicOpen a)) := by
  -- The underlying function of `Hom.app` agrees (by `rfl`) with that of the `modulesSpecToSheaf`
  -- image, where the tilde–Γ triangle identity `toOpen_fromTildeΓ_app` applies.
  rw [ConcreteCategory.isIso_iff_bijective]
  have hfun : ⇑(ConcreteCategory.hom
        (Scheme.Modules.Hom.app N.fromTildeΓ (PrimeSpectrum.basicOpen a))) =
      ⇑(ConcreteCategory.hom
        ((modulesSpecToSheaf.map N.fromTildeΓ).1.app (Opposite.op (PrimeSpectrum.basicOpen a)))) :=
    rfl
  rw [hfun]
  -- Abbreviations: `j` is the tilde localization map, `ρ` the structure-sheaf restriction, both
  -- localizations of `Γ(N, ⊤)` at `powers a`; `L` is the section map of the counit.
  set j := (tilde.toOpen ((modulesSpecToSheaf.obj N).val.obj (Opposite.op ⊤))
    (PrimeSpectrum.basicOpen a)).hom with hj
  set ρ := ((modulesSpecToSheaf.obj N).val.map
    (homOfLE (show PrimeSpectrum.basicOpen a ≤ ⊤ from le_top)).op).hom with hρ
  haveI hρinst : IsLocalizedModule (Submonoid.powers a) ρ := by rw [hρ]; infer_instance
  clear_value ρ
  set L := ((modulesSpecToSheaf.map N.fromTildeΓ).1.app
    (Opposite.op (PrimeSpectrum.basicOpen a))).hom with hL
  -- The triangle identity gives `L ∘ₗ j = ρ`.
  have htri : L ∘ₗ j = ρ := by
    have := Scheme.Modules.toOpen_fromTildeΓ_app N (PrimeSpectrum.basicOpen a)
    apply_fun ModuleCat.Hom.hom at this
    simpa [hL, hj, hρ, ModuleCat.hom_comp] using this
  -- `L` equals the canonical iso between the two localizations of `Γ(N, ⊤)`, hence bijective.
  set ej := IsLocalizedModule.iso (Submonoid.powers a) j with hej
  set eρ := IsLocalizedModule.iso (Submonoid.powers a) ρ with heρ
  let e := ej.symm.trans eρ
  have hcomp : e.toLinearMap ∘ₗ j = ρ := by
    ext x
    simp only [e, hej, heρ, LinearMap.coe_comp, Function.comp_apply, LinearEquiv.coe_coe,
      LinearEquiv.trans_apply, IsLocalizedModule.iso_symm_apply]
    exact IsLocalizedModule.iso_mk_one (Submonoid.powers a) ρ x
  have hLeq : L = e.toLinearMap :=
    IsLocalizedModule.ext (Submonoid.powers a) j (IsLocalizedModule.map_units ρ)
      (htri.trans hcomp.symm)
  rw [show ⇑(ConcreteCategory.hom ((modulesSpecToSheaf.map N.fromTildeΓ).1.app
    (Opposite.op (PrimeSpectrum.basicOpen a)))) = ⇑L from rfl, hLeq]
  exact e.bijective

/-- **Affine pushforward of a tilde-module, conditional on the basic-open localization fact.**
This is the full assembly of `pushforward_spec_tilde_iso` (route iii), modulo the single
remaining ingredient: that on each basic open `D(a)` the structure-sheaf restriction of the
pushforward `(Spec φ)_* M^~` exhibits its sections over `D(a)` as the localization at
`Submonoid.powers a` of its global sections. Given that hypothesis (`hloc`), the counit
`fromTildeΓ ((Spec φ)_* M^~)` is an isomorphism (basis-locality criterion
`Modules.isIso_of_isIso_app_of_isBasis` over the basic opens, with each section iso supplied by
`fromTildeΓ_app_isIso_of_isLocalizedModule`), so `(Spec φ)_* M^~` lies in the essential image of
`tilde` and the global-sections comparison `gammaPushforwardTildeIso` upgrades to the desired
object isomorphism.

The hypothesis `hloc` is the *only* outstanding obligation for the unconditional
`pushforward_spec_tilde_iso`: it is the affine "`(Spec φ)⁻¹ D(a) = D(φ a)`, and localizing
`restrict φ M` at `a` agrees with localizing `M` at `φ a`" fact (Stacks, widetilde-pullback),
whose ring-change core is `IsLocalizedModule.powers_restrictScalars` below. Discharging it
requires identifying the `modulesSpecToSheaf` global-ring `R`-action on the sections of the
pushforward over `D(a)` with restriction of scalars along `φ` of the `R'`-localization
`M[1/φ a]` — the section-level structure-sheaf naturality at `D(a)`. -/
noncomputable def pushforward_spec_tilde_iso_of_isLocalizedModule {R R' : CommRingCat.{u}}
    (φ : R ⟶ R') (M : ModuleCat.{u} R')
    (hloc : ∀ a : R, IsLocalizedModule (Submonoid.powers a)
      ((modulesSpecToSheaf.obj ((Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M))).val.map
        (homOfLE (show PrimeSpectrum.basicOpen a ≤ ⊤ from le_top)).op).hom) :
    (Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M) ≅
      tilde ((ModuleCat.restrictScalars φ.hom).obj M) := by
  have hiso : IsIso (Scheme.Modules.fromTildeΓ
      ((Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M))) := by
    apply Modules.isIso_of_isIso_app_of_isBasis
      (B := fun a : R => PrimeSpectrum.basicOpen a) PrimeSpectrum.isBasis_basic_opens
    intro a
    haveI := hloc a
    exact fromTildeΓ_app_isIso_of_isLocalizedModule _ a
  exact (asIso (Scheme.Modules.fromTildeΓ _)).symm ≪≫
    (tilde.functor R).mapIso (gammaPushforwardTildeIso φ M)

/-- **Restriction of scalars of a localized module is a localized module.** If `f : M →ₗ[A] N`
exhibits `N` as the localization of `M` at the image submonoid `Algebra.algebraMapSubmonoid A S`
(for `S : Submonoid R` and `A` an `R`-algebra), then the `R`-linear map underlying `f`
exhibits `N` as the localization of `M` at `S` itself. This is the exact converse of
`IsLocalizedModule.of_restrictScalars` and is the ring-change ingredient powering the affine
pushforward identification: localizing `restrictScalars φ M` at `a ∈ R` agrees with localizing
`M` at `φ a ∈ R'`. Project-local: Mathlib ships only the forward direction. -/
lemma IsLocalizedModule.powers_restrictScalars
    {R A : Type*} [CommSemiring R] [CommSemiring A] [Algebra R A]
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N] [Module A M] [Module A N]
    [IsScalarTower R A M] [IsScalarTower R A N]
    (S : Submonoid R) (f : M →ₗ[A] N)
    [IsLocalizedModule (Algebra.algebraMapSubmonoid A S) f] :
    IsLocalizedModule S (f.restrictScalars R) where
  map_units x := by
    have h := IsLocalizedModule.map_units f
      (⟨algebraMap R A x, Submonoid.mem_map.mpr ⟨x, x.2, rfl⟩⟩ : Algebra.algebraMapSubmonoid A S)
    simp only [← IsScalarTower.algebraMap_apply, Module.End.isUnit_iff] at h ⊢
    exact h
  surj y := by
    obtain ⟨⟨x, ⟨_, t, ht, rfl⟩⟩, e⟩ := IsLocalizedModule.surj (Algebra.algebraMapSubmonoid A S) f y
    exact ⟨⟨x, ⟨t, ht⟩⟩, by simpa [Submonoid.smul_def, IsScalarTower.algebraMap_smul] using e⟩
  exists_of_eq {x₁ x₂} e := by
    obtain ⟨⟨_, c, hc, rfl⟩, h⟩ :=
      IsLocalizedModule.exists_of_eq (S := Algebra.algebraMapSubmonoid A S) (f := f) e
    exact ⟨⟨c, hc⟩, by simpa [Submonoid.smul_def, IsScalarTower.algebraMap_smul] using h⟩

/-- **Affine base change.** If `f` is an affine morphism and the square is
cartesian, then the base-change map for the pushforward is an isomorphism. In the
affine-local picture this is the associativity isomorphism
`(R' ⊗_R A) ⊗_A M ≅ R' ⊗_R M`, which needs no flatness.

Source: Stacks Project, Cohomology of Schemes, Lemma "Affine base change". -/
theorem affineBaseChange_pushforward_iso (h : IsPullback g' f' f g) [IsAffineHom f]
    (F : X.Modules) [F.IsQuasicoherent] :
    IsIso (pushforwardBaseChangeMap f g f' g' h.w F) := by
  -- A morphism of sheaves of modules is an isomorphism iff it is an isomorphism
  -- on sections over every *affine* open of the base `S'` (locality criterion
  -- `Modules.isIso_iff_isIso_app_affineOpens`; the affine opens form a basis).
  -- This is the honest first reduction: over an affine open is exactly where the
  -- tilde dictionary computes the section map.
  rw [Modules.isIso_iff_isIso_app_affineOpens]
  intro U
  -- Remaining goal: `IsIso (Hom.app (pushforwardBaseChangeMap …) U)` for `U` affine.
  --
  -- Over an affine open `Spec R' = U ⊆ S'` lying over an affine `Spec R ⊆ S`,
  -- affineness of `f` makes `X` and `X'` affine there, `f_* F` becomes restriction
  -- of scalars along `R → A`, pullback along `g` becomes `- ⊗_R R'`, and the
  -- base-change map becomes the cancellation/associativity isomorphism
  -- `(R' ⊗[R] A) ⊗[A] M ≃ R' ⊗[R] M`
  -- (`TensorProduct.AlgebraTensorModule.cancelBaseChange`, no flatness needed).
  --
  -- The missing Mathlib ingredient is the affine dictionary translating
  -- `Scheme.Modules.pushforward` / `Scheme.Modules.pullback` of `tilde`-modules
  -- on `Spec` into restriction of scalars / base change of `ModuleCat`s. The
  -- locality half is now supplied by `Modules.isIso_iff_isIso_app_affineOpens`.
  -- See `informal/affineBaseChange_pushforward_iso.md`.
  sorry

/-- **Flat base change, `i = 0` case.** If `g` is flat and `f` is quasi-compact
and quasi-separated, then the base-change map for the pushforward is an
isomorphism. Equivalently, in the affine situation `S = Spec A`, `S' = Spec B`
with `A → B` flat, the comparison map `H⁰(X, F) ⊗_A B → H⁰(X_B, F_B)` is an
isomorphism.

Source: Stacks Project, Tag 02KH ("Flat base change"), the `i = 0` case. -/
theorem flatBaseChange_pushforward_isIso (h : IsPullback g' f' f g) [Flat g]
    [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) [F.IsQuasicoherent] :
    IsIso (pushforwardBaseChangeMap f g f' g' h.w F) := by
  -- Proof strategy (Stacks 02KH, `i = 0`), deferred to a later iteration:
  -- the statement is local on `S'`, so reduce to `S = Spec A`, `S' = Spec B`
  -- with `A → B` flat.  Choose a finite affine open cover `𝒰` of `X`.  Since `f`
  -- is quasi-compact and quasi-separated the Čech complex of `𝒰` computes
  -- `H⁰(X, F)`, and base change identifies `Čech(𝒰_B, F_B) ≅ Čech(𝒰, F) ⊗_A B`
  -- term by term via `affineBaseChange_pushforward_iso`.  Flatness of `A → B`
  -- makes `- ⊗_A B` exact, so it commutes with `H⁰`, giving the isomorphism
  -- `H⁰(X, F) ⊗_A B ≅ H⁰(X_B, F_B)`.  Needs the (missing) Čech-cohomology /
  -- affine-cover infrastructure for `SheafOfModules`; see
  -- `informal/affineBaseChange_pushforward_iso.md`.
  sorry

end AlgebraicGeometry
