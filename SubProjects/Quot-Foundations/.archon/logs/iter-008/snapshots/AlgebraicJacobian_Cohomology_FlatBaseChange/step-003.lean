/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.RegroupHelper

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

open scoped TensorProduct

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
    (ModuleCat.restrictScalarsCongr hcomp).app SecN ≪≫
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

/-- **Sections of an affine pushforward over an arbitrary open = restriction of scalars.**
The `D(a)`-level (indeed arbitrary-open) generalization of `gammaPushforwardIso`. For a ring map
`φ : R ⟶ R'`, an `Spec R'`-module `N`, and an open `U` of `Spec R` with preimage
`V = (Spec φ)⁻¹ U` in `Spec R'`, the `R`-module of sections of the pushforward
`(Spec φ)_* N` over `U` is the restriction of scalars along `φ` of the `R'`-module of sections of
`N` over `V`. Because `modulesSpecToSheaf` forgets to the *global* section ring uniformly (it
restricts scalars along the global-sections map at the top open, not at `U`), the construction is
*identical* to that of `gammaPushforwardIso` — the same restriction-of-scalars composition identity
twice plus the same `⊤`-level ring equation `globalSectionsIso_hom_comp_specMap_appTop` — with only
the evaluation open changed from `⊤` to `U` / `V`. Project-local. -/
noncomputable def gammaPushforwardIsoAt {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (N : (Spec R').Modules) (U : (Spec R).Opens) :
    (modulesSpecToSheaf.obj ((Scheme.Modules.pushforward (Spec.map φ)).obj N)).val.obj
        (Opposite.op U) ≅
      (ModuleCat.restrictScalars φ.hom).obj
        ((modulesSpecToSheaf.obj N).val.obj
          (Opposite.op ((TopologicalSpace.Opens.map (Spec.map φ).base).obj U))) := by
  set SecN : ModuleCat ↑((Spec R').ringCatSheaf.obj.obj (Opposite.op ⊤)) :=
    (((SheafOfModules.forgetToSheafModuleCat (Spec R').ringCatSheaf (Opposite.op ⊤)
        (Limits.initialOpOfTerminal Limits.isTerminalTop)).obj N).val.obj
          (Opposite.op ((TopologicalSpace.Opens.map (Spec.map φ).base).obj U))) with hSecN
  set gsRhom := (StructureSheaf.globalSectionsIso ↑R).hom.hom with hgsR
  set gsR'hom := (StructureSheaf.globalSectionsIso ↑R').hom.hom with hgsR'
  set pushTop := ((Spec.map φ).toRingCatSheafHom.hom.app (Opposite.op ⊤)).hom with hpush
  have hcomp : pushTop.comp gsRhom = gsR'hom.comp φ.hom := by
    apply RingHom.ext
    intro x
    simpa [hpush, hgsR, hgsR', RingHom.comp_apply] using
      congr($(globalSectionsIso_hom_comp_specMap_appTop φ).hom x)
  exact (ModuleCat.restrictScalarsComp'App gsRhom pushTop (pushTop.comp gsRhom) rfl SecN).symm ≪≫
    (ModuleCat.restrictScalarsCongr hcomp).app SecN ≪≫
    (ModuleCat.restrictScalarsComp'App φ.hom gsR'hom (gsR'hom.comp φ.hom) rfl SecN)

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

/-- **The structure-sheaf restriction of a tilde-module from `⊤` to `D(b)` is a localization.**
Read in `ModuleCat R'` via `modulesSpecToSheaf`, the restriction map
`Γ(M^~, ⊤) → Γ(M^~, D(b))` exhibits its target as the localization of its source at
`Submonoid.powers b`. This packages the Mathlib instance
`tilde.toOpen … (basicOpen b)` (which makes `M → Γ(M^~, D(b))` a localization) together with the
triangle identity `tilde.toOpen_res` and the fact that `M → Γ(M^~, ⊤)` is bijective (localization
at the trivial submonoid `powers 1`). Project-local. -/
lemma tildeRestriction_isLocalizedModule {R' : CommRingCat.{u}} (M : ModuleCat.{u} R') (b : R') :
    IsLocalizedModule (Submonoid.powers b)
      ((modulesSpecToSheaf.obj (tilde M)).val.map
        (homOfLE (show PrimeSpectrum.basicOpen b ≤ ⊤ from le_top)).op).hom := by
  -- `toOpen M ⊤` is a localization at `powers (1 : R')` (since `basicOpen 1 = ⊤`), hence bijective.
  haveI inst1 : IsLocalizedModule (Submonoid.powers (1 : R')) (tilde.toOpen M ⊤).hom := by
    have h := (inferInstance : IsLocalizedModule (Submonoid.powers (1 : R'))
      (tilde.toOpen M (PrimeSpectrum.basicOpen (1 : R'))).hom)
    rw [PrimeSpectrum.basicOpen_one] at h
    exact h
  have hbij : Function.Bijective (tilde.toOpen M ⊤).hom := by
    refine ⟨fun x y hxy => ?_, fun y => ?_⟩
    · obtain ⟨c, hc⟩ := IsLocalizedModule.exists_of_eq
        (S := Submonoid.powers (1 : R')) (f := (tilde.toOpen M ⊤).hom) hxy
      obtain ⟨n, hn⟩ := c.2
      have hc1 : (↑c : R') = 1 := by simpa using hn.symm
      rw [Submonoid.smul_def, Submonoid.smul_def, hc1, one_smul, one_smul] at hc
      exact hc
    · obtain ⟨⟨x, c⟩, hc⟩ := IsLocalizedModule.surj
        (Submonoid.powers (1 : R')) (tilde.toOpen M ⊤).hom y
      obtain ⟨n, hn⟩ := c.2
      have hc1 : (↑c : R') = 1 := by simpa using hn.symm
      refine ⟨x, ?_⟩
      rw [Submonoid.smul_def, hc1, one_smul] at hc
      exact hc.symm
  -- Triangle identity: `toOpen ⊤ ≫ (restriction) = toOpen (D b)`.
  have htri := tilde.toOpen_res M (⊤ : (Spec R').Opens) (PrimeSpectrum.basicOpen b)
    (homOfLE (le_top))
  -- The inverse equivalence `Γ(M^~, ⊤) ≃ M`.
  set le : M ≃ₗ[R'] ((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤)) :=
    LinearEquiv.ofBijective (tilde.toOpen M ⊤).hom hbij with hle
  -- The triangle at the level of linear maps: `restriction ∘ₗ le = toOpen (D b)`.
  have htri2 : ((modulesSpecToSheaf.obj (tilde M)).val.map
        (homOfLE (show PrimeSpectrum.basicOpen b ≤ ⊤ from le_top)).op).hom ∘ₗ le.toLinearMap
      = (tilde.toOpen M (PrimeSpectrum.basicOpen b)).hom := by
    have h := congrArg ModuleCat.Hom.hom htri
    rw [ModuleCat.hom_comp] at h
    exact h
  -- Hence `restriction = toOpen (D b) ∘ₗ le⁻¹`, a localization at `powers b` precomposed with
  -- a linear equivalence.
  have key : ((modulesSpecToSheaf.obj (tilde M)).val.map
        (homOfLE (show PrimeSpectrum.basicOpen b ≤ ⊤ from le_top)).op).hom
      = (tilde.toOpen M (PrimeSpectrum.basicOpen b)).hom ∘ₗ le.symm.toLinearMap :=
    (LinearEquiv.eq_comp_toLinearMap_symm _ _).mpr htri2
  rw [key]
  exact IsLocalizedModule.of_linearEquiv_right (Submonoid.powers b)
    (tilde.toOpen M (PrimeSpectrum.basicOpen b)).hom le.symm

/-- **Affine pushforward of a tilde-module (unconditional).** For a ring map `φ : R ⟶ R'`
and an `R'`-module `M`, pushing the quasi-coherent sheaf `M^~` forward along `Spec φ` is,
up to canonical isomorphism, the tilde of the restriction of scalars of `M` along `φ`. This
is the unconditional form of `pushforward_spec_tilde_iso_of_isLocalizedModule`: the latter's
hypothesis `hloc` (each structure-sheaf restriction `Γ(N,⊤) → Γ(N,D(a))` is a localization at
`powers a`) is discharged here by the `D(a)`-level transport. See blueprint
`lem:pushforward_spec_tilde_iso`. -/
noncomputable def pushforward_spec_tilde_iso {R R' : CommRingCat.{u}}
    (φ : R ⟶ R') (M : ModuleCat.{u} R') :
    (Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M) ≅
      tilde ((ModuleCat.restrictScalars φ.hom).obj M) := by
  apply pushforward_spec_tilde_iso_of_isLocalizedModule φ M
  intro a
  -- STRATEGY (`of_linearEquiv`): the restriction map `ρ : Γ(N,⊤) → Γ(N,D(a))` of
  -- `N := (Spec φ)_* (M^~)` is, under the isomorphisms
  -- `gammaPushforwardIsoAt φ (tilde M) ⊤` and `gammaPushforwardIsoAt φ (tilde M) (D a)`,
  -- identified with the restriction of scalars along `φ` of the `R'`-side tilde restriction
  -- `σ : Γ(M^~, ⊤) → Γ(M^~, D(φ a))`. That `σ` is a localization at `powers (φ a)`
  -- (`tildeRestriction_isLocalizedModule`), so its restriction of scalars along `φ` is a
  -- localization at `powers a` (`IsLocalizedModule.powers_restrictScalars`); transporting along
  -- the two isomorphisms then yields `hloc(a)`.
  -- The two bricks for this discharge are now in place and axiom-clean:
  --   • `gammaPushforwardIsoAt φ (tilde M) U : Γ(N, U) ≅ restrictScalars φ (Γ(M^~, (Spec φ)⁻¹ U))`
  --     — the open-indexed `e_{D(a)}` isomorphism (blueprint movement (1)); and
  --   • `tildeRestriction_isLocalizedModule M (φ a)` — the `R'`-side restriction
  --     `Γ(M^~, ⊤) → Γ(M^~, D(φ a))` is a localization at `powers (φ a)`.
  -- The `of_linearEquiv` finish is: with `e₁ = gammaPushforwardIsoAt φ (tilde M) ⊤` and
  -- `e₂ = gammaPushforwardIsoAt φ (tilde M) (D a)`, the naturality square
  -- `e₂.hom ∘ ρ = (restrictScalars φ σ) ∘ e₁.hom` (where `σ` is the `R'`-side restriction and
  -- `ρ` the pushforward-side one) gives `ρ = e₂.symm ∘ₗ (restrictScalars φ σ) ∘ₗ e₁`; then
  -- `IsLocalizedModule.powers_restrictScalars` upgrades `σ` (localization at `powers (φ a)`,
  -- since `algebraMapSubmonoid R' (powers a) = powers (φ a)` along `φ.hom.toAlgebra`) to a
  -- localization at `powers a` of `restrictScalars φ σ`, and two applications of
  -- `IsLocalizedModule.of_linearEquiv` / `of_linearEquiv_right` transport this to `ρ`.
  --
  -- iter-240 PIVOT (`algebraize`): preimage opens are *definitionally* the basic opens
  -- (`AlgebraicGeometry.SpecMap_preimage_basicOpen` is `rfl`), so the `R'`-side restriction
  -- `σ` is literally `tilde M`'s restriction `⊤ → D(φ a)`, and `algebraize [φ.hom]` supplies the
  -- honest `Algebra ↑R ↑R'`/`IsScalarTower` instances that `powers_restrictScalars` needs.
  algebraize [φ.hom]
  -- `σ` : the `R'`-side restriction map `Γ(M^~, ⊤) → Γ(M^~, D(φ a))` of `tilde M`.
  set σmor := (modulesSpecToSheaf.obj (tilde M)).val.map
      (homOfLE (show PrimeSpectrum.basicOpen (φ.hom a) ≤ ⊤ from le_top)).op with hσmor
  -- Re-expose the `compHom`-via-`φ` `R`-module/scalar-tower instances (the ones the
  -- `ModuleCat.restrictScalars φ.hom` objects carry) on the bare section carriers, so that
  -- `powers_restrictScalars` can see them.
  letI mTop : Module R ↑((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤)) :=
    inferInstanceAs (Module R ((ModuleCat.restrictScalars φ.hom).obj
      ((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤))))
  letI mDa : Module R ↑((modulesSpecToSheaf.obj (tilde M)).val.obj
      (Opposite.op (PrimeSpectrum.basicOpen (φ.hom a)))) :=
    inferInstanceAs (Module R ((ModuleCat.restrictScalars φ.hom).obj
      ((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op (PrimeSpectrum.basicOpen (φ.hom a))))))
  haveI tTop : IsScalarTower R R' ↑((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤)) :=
    ⟨fun x y z => by rw [Algebra.smul_def, mul_smul]; rfl⟩
  haveI tDa : IsScalarTower R R' ↑((modulesSpecToSheaf.obj (tilde M)).val.obj
      (Opposite.op (PrimeSpectrum.basicOpen (φ.hom a)))) :=
    ⟨fun x y z => by rw [Algebra.smul_def, mul_smul]; rfl⟩
  -- `σ` is a localization at `powers (φ a)`.
  haveI hσloc : IsLocalizedModule (Submonoid.powers (φ.hom a)) σmor.hom :=
    tildeRestriction_isLocalizedModule M (φ.hom a)
  -- restriction of scalars of `σ` along `φ` is a localization at `powers a`.
  have himg : Algebra.algebraMapSubmonoid (R' : Type u) (Submonoid.powers a)
      = Submonoid.powers (φ.hom a) := by
    rw [Algebra.algebraMapSubmonoid_powers]; rfl
  haveI : IsLocalizedModule (Algebra.algebraMapSubmonoid (R' : Type u) (Submonoid.powers a))
      σmor.hom := by rw [himg]; exact hσloc
  haveI hGloc := @IsLocalizedModule.powers_restrictScalars (↑R) (↑R') _ _ _ _ _ _ _
    mTop mDa _ _ tTop tDa (Submonoid.powers a) σmor.hom this
  -- The restriction-of-scalars of `σ` as a `ModuleCat R` morphism (bundled `compHom` instances).
  set Gmor := (ModuleCat.restrictScalars φ.hom).map σmor with hGmor
  -- `Gmor.hom` is `σmor.hom.restrictScalars R`, hence a localization at `powers a`.
  haveI hG : IsLocalizedModule (Submonoid.powers a) Gmor.hom := hGloc
  -- The pushforward restriction `ρ` (a `ModuleCat R` morphism).
  set ρ := (modulesSpecToSheaf.obj ((pushforward (Spec.map φ)).obj (tilde M))).val.map
      (homOfLE (show PrimeSpectrum.basicOpen a ≤ ⊤ from le_top)).op with hρdef
  -- The two open-indexed comparison isos (`e_{⊤}`, `e_{D(a)}`), via `gammaPushforwardIsoAt`.
  set e₁ := gammaPushforwardIsoAt φ (tilde M) ⊤ with he₁
  set e₂ := gammaPushforwardIsoAt φ (tilde M) (PrimeSpectrum.basicOpen a) with he₂
  -- Naturality square (at the `ModuleCat R` level): conjugating the pushforward restriction `ρ`
  -- by `e₁`, `e₂` gives the restriction of scalars along `φ` of the `R'`-side restriction `σ`.
  -- The common underlying `R'`-side forget restriction map (with `FN` inlined so it matches
  -- the unfolded `gammaPushforwardIsoAt`).
  set tForget := ((SheafOfModules.forgetToSheafModuleCat (Spec R').ringCatSheaf (Opposite.op ⊤)
        (Limits.initialOpOfTerminal Limits.isTerminalTop)).obj (tilde M)).val.map
      (homOfLE (show (TopologicalSpace.Opens.map (Spec.map φ).base).obj
        (PrimeSpectrum.basicOpen a) ≤ ⊤ from le_top)).op with htForget
  -- Structural identifications (peel `modulesSpecToSheaf`/pushforward through `restrictScalars`),
  -- written with the *raw* ring maps so they match `gammaPushforwardIsoAt`'s unfolding.
  have hσ' : σmor = (ModuleCat.restrictScalars
      (StructureSheaf.globalSectionsIso (↑R' : CommRingCat)).hom.hom).map tForget := rfl
  have hρ' : ρ = (ModuleCat.restrictScalars
        (StructureSheaf.globalSectionsIso (↑R : CommRingCat)).hom.hom).map
      ((ModuleCat.restrictScalars
        ((Spec.map φ).toRingCatSheafHom.hom.app (Opposite.op ⊤)).hom).map tForget) := rfl
  -- The open-naturality square `ρ ≫ e₂.hom = e₁.hom ≫ Gmor` (the residual `hsq`).
  have hsq : ρ ≫ e₂.hom = e₁.hom ≫ Gmor := by
    -- Substitute the structural exposures, then unfold `gammaPushforwardIsoAt`. Here
    --   ρ = rsc gsR ∘ rsc pushTop ∘ tForget,  Gmor = rsc φ ∘ σmor = rsc φ ∘ rsc gsR' ∘ tForget,
    --   e_U = (rsc-comp')⁻¹ ≫ (restrictScalarsCongr hcomp).app SecN ≫ (rsc-comp').
    rw [he₁, he₂, hGmor, hρ', hσ']
    simp only [gammaPushforwardIsoAt, Iso.trans_hom, Iso.symm_hom]
    -- KEY INSIGHT (iter-241): every constituent of `gammaPushforwardIsoAt` is the IDENTITY on
    -- underlying elements — `restrictScalarsComp'App_{hom,inv}_apply`, `restrictScalarsCongr`
    -- app, and `restrictScalars.map_apply` are all `rfl`; the middle `restrictScalarsCongr` (now
    -- replaces the former `eqToIso`, removing the only non-`rfl` cast) merely repackages the module
    -- structure on the unchanged carrier. So both legs of the square send `x` to the underlying
    -- `tForget x` definitionally — a pointwise `rfl` closes it, sidestepping the rewrite-matching
    -- pathology that defeated the prior `restrictScalarsComp'App_inv_naturality`-rewrite route.
    ext x
    rfl
  -- Solve for `ρ` and transport the localization across the two equivalences.
  have hρ : ρ = (e₁.hom ≫ Gmor) ≫ e₂.inv := (Iso.eq_comp_inv e₂).mpr hsq
  have key : ρ.hom
      = e₂.toLinearEquiv.symm.toLinearMap ∘ₗ
          (Gmor.hom ∘ₗ e₁.toLinearEquiv.toLinearMap) := by
    rw [hρ]; rfl
  rw [key]
  haveI hstep : IsLocalizedModule (Submonoid.powers a)
      (Gmor.hom ∘ₗ e₁.toLinearEquiv.toLinearMap) :=
    IsLocalizedModule.of_linearEquiv_right (Submonoid.powers a) Gmor.hom e₁.toLinearEquiv
  exact IsLocalizedModule.of_linearEquiv (Submonoid.powers a)
    (Gmor.hom ∘ₗ e₁.toLinearEquiv.toLinearMap) e₂.toLinearEquiv.symm

/-! ## Project-local Mathlib supplement — affine pullback dictionary -/

/-- **Naturality of the Γ-fragment comparison.** The per-object isomorphisms
`gammaPushforwardIso φ N : Γ_R((Spec φ)_* N) ≅ restrictScalars φ (Γ_{R'} N)` assemble into a
natural isomorphism of functors `(Spec R').Modules ⥤ ModuleCat R`
\[ (\operatorname{Spec}\varphi)_* \;\circ\; \Gamma_R
   \;\cong\; \Gamma_{R'} \;\circ\; \operatorname{restr}_\varphi . \]
Every constituent of `gammaPushforwardIso` is the identity on underlying elements (the
`restrictScalarsComp'App` isos and `restrictScalarsCongr` merely repackage the module structure
on the unchanged carrier), so naturality is a pointwise `rfl`. This is the right-adjoint natural
isomorphism that drives the affine pullback dictionary `pullback_spec_tilde_iso` via
`Adjunction.natIsoOfRightAdjointNatIso`. Project-local. -/
noncomputable def gammaPushforwardNatIso {R R' : CommRingCat.{u}} (φ : R ⟶ R') :
    Scheme.Modules.pushforward (Spec.map φ) ⋙ moduleSpecΓFunctor (R := R) ≅
      moduleSpecΓFunctor (R := R') ⋙ ModuleCat.restrictScalars φ.hom :=
  NatIso.ofComponents (fun N => gammaPushforwardIso φ N) (by
    intro N N' g
    ext x
    rfl)

/-- **Affine pullback of a tilde-module.** For a ring map `φ : R ⟶ R'` and an `R`-module `M`,
pulling the quasi-coherent sheaf `M^~` back along `Spec φ` is, up to canonical isomorphism, the
tilde of the extension of scalars `R' ⊗_R M`. This is the pullback companion of
`pushforward_spec_tilde_iso` and is part (1) of Stacks Tag 01I9 (`lemma-widetilde-pullback`).

The construction is the uniqueness-of-left-adjoints route. Pullback along `Spec φ` is left adjoint
to pushforward, and `tilde` is left adjoint to global sections; their composite
`tilde_R ⋙ pullback` is left adjoint to `pushforward ⋙ Γ_R`. Symmetrically `extendScalars φ` is
left adjoint to `restrictScalars φ`, so `extendScalars ⋙ tilde_{R'}` is left adjoint to
`Γ_{R'} ⋙ restrictScalars φ`. The two right adjoints are identified by the natural isomorphism
`gammaPushforwardNatIso` (which is the global-sections comparison `gammaPushforwardIso`), so
`Adjunction.natIsoOfRightAdjointNatIso` yields an isomorphism of the two left adjoints; evaluating
at `M` gives the claim. Project-local: the affine companion of the pushforward dictionary. See
blueprint `lem:pullback_spec_tilde_iso`. -/
noncomputable def pullback_spec_tilde_iso {R R' : CommRingCat.{u}}
    (φ : R ⟶ R') (M : ModuleCat.{u} R) :
    (Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
      tilde ((ModuleCat.extendScalars φ.hom).obj M) :=
  let adjL := (tilde.adjunction (R := R)).comp
    (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map φ))
  let adjR := (ModuleCat.extendRestrictScalarsAdj φ.hom).comp (tilde.adjunction (R := R'))
  (((conjugateIsoEquiv adjL adjR).symm (gammaPushforwardNatIso φ)).symm).app M

/-! ## Project-local Mathlib supplement — pullback cone legs as Spec of tensor inclusions -/

/-- **The pullback cone legs are the `Spec`-maps of the tensor inclusions.** For ring maps
`ψ : R ⟶ R'` and `φ : R ⟶ A` (regarding `A`, `R'` as `R`-algebras via `φ`, `ψ`), over the generic
pullback square `Limits.pullback (Spec.map φ) (Spec.map ψ)` Mathlib's `pullbackSpecIso` identifies
the total space with `Spec (A ⊗[R] R')`, and under it the two cone legs are the `Spec`-maps of the
canonical tensor inclusions `Algebra.TensorProduct.includeLeftRingHom : A → A ⊗[R] R'` and
`Algebra.TensorProduct.includeRight : R' → A ⊗[R] R'`. The only content beyond Mathlib's
`pullbackSpecIso_inv_fst`/`_inv_snd` is the structure bridging `Spec.map φ ↔ Spec.map (algebraMap
R A)` (definitional once `A` carries the `φ`-algebra structure). See blueprint
`lem:pullback_fst_snd_specMap_tensor`. -/
theorem pullback_fst_snd_specMap_tensor {R R' A : CommRingCat.{u}} (ψ : R ⟶ R') (φ : R ⟶ A) :
    letI : Algebra R A := φ.hom.toAlgebra
    letI : Algebra R R' := ψ.hom.toAlgebra
    ((pullbackSpecIso (R := ↑R) (S := ↑A) (T := ↑R')).inv ≫
        Limits.pullback.fst (Spec.map φ) (Spec.map ψ)
        = Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom)) ∧
      ((pullbackSpecIso (R := ↑R) (S := ↑A) (T := ↑R')).inv ≫
        Limits.pullback.snd (Spec.map φ) (Spec.map ψ)
        = Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeRight (R := ↑R) (A := ↑A) (B := ↑R')).toRingHom)) := by
  letI : Algebra R A := φ.hom.toAlgebra
  letI : Algebra R R' := ψ.hom.toAlgebra
  refine ⟨?_, ?_⟩
  · exact pullbackSpecIso_inv_fst ↑R ↑A ↑R'
  · exact pullbackSpecIso_inv_snd ↑R ↑A ↑R'

/-! ## Section-level mate computation, decomposed -/

/-- **Domain read of the section-level base-change map.** In the affine–affine model
(`g = Spec ψ`, `f = Spec φ`, `F = tilde M`), the global sections of the domain
`g^*(f_*(tilde M))` of the base-change map are canonically `R' ⊗_R M` as an `R'`-module — i.e.
the extension of scalars along `ψ` of the restriction of scalars along `φ` of `M`. The iso
`Θ_src` is the composite of the pushforward dictionary `pushforward_spec_tilde_iso` (reading
`f_*(tilde M)` as `restrictScalars φ M`) followed by the pullback dictionary
`pullback_spec_tilde_iso` (reading `g^*` of a tilde as extension of scalars along `ψ`), then the
tilde–Γ unit. The cospan maps `f = Spec φ`, `g = Spec ψ` are genuine `Spec`-maps, so the two
dictionaries apply directly with no pullback-leg identification needed. See blueprint
`lem:base_change_mate_domain_read`. -/
noncomputable def base_change_mate_domain_read {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (moduleSpecΓFunctor (R := R')).obj
        ((Scheme.Modules.pullback (Spec.map ψ)).obj
          ((Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M))) ≅
      (ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj M) :=
  (moduleSpecΓFunctor (R := R')).mapIso
      ((Scheme.Modules.pullback (Spec.map ψ)).mapIso (pushforward_spec_tilde_iso φ M) ≪≫
        pullback_spec_tilde_iso ψ ((ModuleCat.restrictScalars φ.hom).obj M)) ≪≫
    (tilde.toTildeΓNatIso.app
      ((ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj M))).symm

/-- **Pullback of modules along an isomorphism of schemes is an equivalence.** Project-local
helper: the inverse is `pullback (inv f)`, with unit/counit assembled from `pullbackComp` and
`pullbackId`. Used to recognise that pulling back along `pullbackSpecIso.hom` (an iso) and pushing
forward again returns the original module. -/
noncomputable def pullbackIsoEquivalenceOfIso {X Y : Scheme.{u}} (f : X ⟶ Y) [IsIso f] :
    Y.Modules ≌ X.Modules :=
  CategoryTheory.Equivalence.mk (Scheme.Modules.pullback f) (Scheme.Modules.pullback (inv f))
    ((Scheme.Modules.pullbackId Y).symm ≪≫
      Scheme.Modules.pullbackCongr (IsIso.inv_hom_id f).symm ≪≫
        (Scheme.Modules.pullbackComp (inv f) f).symm)
    (Scheme.Modules.pullbackComp f (inv f) ≪≫
      Scheme.Modules.pullbackCongr (IsIso.hom_inv_id f) ≪≫ Scheme.Modules.pullbackId X)

instance pullback_isEquivalence_of_iso {X Y : Scheme.{u}} (f : X ⟶ Y) [IsIso f] :
    (Scheme.Modules.pullback f).IsEquivalence :=
  (pullbackIsoEquivalenceOfIso f).isEquivalence_functor

/-- **Codomain read of the section-level base-change map.** In the affine–affine model, with
`f' = pullback.snd` and `g' = pullback.fst` the legs of the pullback square, the global sections of
the codomain `f'_*(g')^*(tilde M)` are canonically `(A ⊗_R R') ⊗_A M` as an `R'`-module. The legs
are identified with the `Spec`-maps of the tensor inclusions by
`pullback_fst_snd_specMap_tensor` (L1), pulling the functors back to the affine `Spec (A ⊗_R R')`
chart, after which the two affine dictionaries apply. See blueprint
`lem:base_change_mate_codomain_read`. -/
noncomputable def base_change_mate_codomain_read {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    (moduleSpecΓFunctor (R := R')).obj
        ((Scheme.Modules.pushforward (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))).obj
          ((Scheme.Modules.pullback (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).obj
            (tilde M))) ≅
      (ModuleCat.restrictScalars
          (Algebra.TensorProduct.includeRight (R := (R : Type u)) (A := (A : Type u))
            (B := (R' : Type u))).toRingHom).obj
        ((ModuleCat.extendScalars
          (Algebra.TensorProduct.includeLeftRingHom (R := (R : Type u)) (A := (A : Type u))
            (B := (R' : Type u)))).obj M) := by
  letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
  letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
  set e := pullbackSpecIso (R := (R : Type u)) (S := (A : Type u)) (T := (R' : Type u)) with he
  set inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))) with hinclA
  set inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeRight
    (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom with hinclR'
  obtain ⟨hfst0, hsnd0⟩ := pullback_fst_snd_specMap_tensor ψ φ
  have hfst : Limits.pullback.fst (Spec.map φ) (Spec.map ψ) = e.hom ≫ Spec.map inclA :=
    (Iso.inv_comp_eq e).mp hfst0
  have hsnd : Limits.pullback.snd (Spec.map φ) (Spec.map ψ) = e.hom ≫ Spec.map inclR' :=
    (Iso.inv_comp_eq e).mp hsnd0
  set g' := Limits.pullback.fst (Spec.map φ) (Spec.map ψ) with hg'
  set f' := Limits.pullback.snd (Spec.map φ) (Spec.map ψ) with hf'
  set W₀ := (Scheme.Modules.pullback (Spec.map inclA)).obj (tilde M) with hW₀
  -- Read the pullback leg `g'` through `pullbackSpecIso` as the affine `Spec inclA` pullback.
  have iso_g : (Scheme.Modules.pullback g').obj (tilde M)
        ≅ (Scheme.Modules.pullback e.hom).obj W₀ :=
    (Scheme.Modules.pullbackCongr hfst).app (tilde M) ≪≫
      (Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).symm.app (tilde M)
  -- `e.hom` is an iso of schemes, so pulling back then pushing forward returns the module.
  have unit_iso : W₀ ≅ (Scheme.Modules.pushforward e.hom).obj
        ((Scheme.Modules.pullback e.hom).obj W₀) :=
    (asIso (Scheme.Modules.pullbackPushforwardAdjunction e.hom).unit).app W₀
  -- Assemble the object isomorphism `C₀ ≅ tilde ((A⊗R')⊗_A M)`.
  refine (moduleSpecΓFunctor (R := R')).mapIso ?_ ≪≫
    (tilde.toTildeΓNatIso.app ((ModuleCat.restrictScalars inclR'.hom).obj
      ((ModuleCat.extendScalars inclA.hom).obj M))).symm
  exact (Scheme.Modules.pushforward f').mapIso iso_g ≪≫
    (Scheme.Modules.pushforwardCongr hsnd).app ((Scheme.Modules.pullback e.hom).obj W₀) ≪≫
    (Scheme.Modules.pushforwardComp e.hom (Spec.map inclR')).symm.app
      ((Scheme.Modules.pullback e.hom).obj W₀) ≪≫
    (Scheme.Modules.pushforward (Spec.map inclR')).mapIso unit_iso.symm ≪≫
    (Scheme.Modules.pushforward (Spec.map inclR')).mapIso (pullback_spec_tilde_iso inclA M) ≪≫
    pushforward_spec_tilde_iso inclR' ((ModuleCat.extendScalars inclA.hom).obj M)

/-- **Regrouping isomorphism for the section-level mate (object form).** The bundled `R'`-linear
isomorphism of `ModuleCat R'`
\[ (A \otimes_R R') \otimes_A M \;\cong\; R' \otimes_R M \]
in the exact `extendScalars`/`restrictScalars` packaging used by the codomain/domain reads: the
source is `restrictScalars includeRight` of `extendScalars includeLeftRingHom` of `M` (i.e.
`(A ⊗_R R') ⊗_A M` read as an `R'`-module through the right tensor factor), and the target is
`extendScalars ψ` of `restrictScalars φ` of `M` (i.e. `R' ⊗_R M`). Its inverse is the generator the
section-level mate produces (`r' ⊗ m ↦ (1 ⊗ r') ⊗ m`); it carries no flatness hypothesis. See
blueprint `lem:base_change_mate_regroupEquiv`.

The mathematical content is `base_change_regroup_linearEquiv` above (the proved
`comm ≪≫ cancelBaseChange ≪≫ comm` core, `R'`-linear via the `rightAlgebra` action). Here it is
transported to the `ModuleCat` change-of-rings objects through the identity `A`-linear bridge `eT`
(resolving the `Module A (A ⊗[R] R')` diamond: `extendScalars` uses `restrictScalars
includeLeftRingHom` whereas `cancelBaseChange` forces the canonical `Algebra A (A ⊗[R] R')`), so the
underlying additive equivalence `g` lands on the genuine `extendScalars`/`restrictScalars` object
carriers (no cross-declaration defeq is needed — `toModuleIso` packages it directly).

STATUS: the additive equivalence `g` and the bridge `eT` are constructed verbatim and the object
`R'`-action is definitionally the canonical `rightAlgebra` action (verified by `rfl` on generators);
the residual `map_smul'` (`hms`) is the same generator computation as the proved
`base_change_regroup_linearEquiv`, but `TensorProduct.induction_on` strips the `restrictScalars`
object wrapper from `x`, leaving an `R'`-smul on the bare tensor carrier that no standard smul lemma
matches syntactically (`ModuleCat.restrictScalars.smul_def` fires only while `x` is typed at the full
object, before induction). It is left as the single residual obligation; a `ModuleCat`-level
base-change (Beck–Chevalley) iso for the mixed `restrictScalars ∘ extendScalars` square, or a bundled
`TensorProduct.ext`-style linearity check keeping generators typed at the object, would discharge it.
NOTE: an alternative one-line proof `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`
typechecks once `base_change_regroup_linearEquiv` is in a *separate compiled module* (the imported
type normalizes the `Module A (A ⊗[R] R')` diamond); same-file it currently does not reduce. -/
noncomputable def base_change_mate_regroupEquiv {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    (ModuleCat.restrictScalars
        (Algebra.TensorProduct.includeRight (R := (R : Type u)) (A := (A : Type u))
          (B := (R' : Type u))).toRingHom).obj
      ((ModuleCat.extendScalars
        (Algebra.TensorProduct.includeLeftRingHom (R := (R : Type u)) (A := (A : Type u))
          (B := (R' : Type u)))).obj M) ≅
      (ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj M) := by
  letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
  letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
  letI instRM : Module (R : Type u) (↑M) :=
    inferInstanceAs (Module (R : Type u) ↑((ModuleCat.restrictScalars φ.hom).obj M))
  haveI towerRAM : IsScalarTower (R : Type u) (A : Type u) (↑M) :=
    ⟨fun r a m => by rw [Algebra.smul_def, mul_smul]; rfl⟩
  -- `eT`: the identity `A`-linear bridge from the `extendScalars`/`compHom` `A`-structure on
  -- `A ⊗[R] R'` to the canonical `Algebra A (A ⊗[R] R')` structure (resolving the diamond).
  let eT : (↑((ModuleCat.restrictScalars (Algebra.TensorProduct.includeLeftRingHom
        (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))).obj
          (ModuleCat.of ((A : Type u) ⊗[(R : Type u)] (R' : Type u))
            ((A : Type u) ⊗[(R : Type u)] (R' : Type u)))))
        ≃ₗ[(A : Type u)] ((A : Type u) ⊗[(R : Type u)] (R' : Type u)) :=
    { toFun := id, invFun := id, left_inv := fun _ => rfl, right_inv := fun _ => rfl,
      map_add' := fun _ _ => rfl, map_smul' := fun a x => by rw [Algebra.smul_def]; rfl }
  letI : Algebra (R' : Type u) ((A : Type u) ⊗[(R : Type u)] (R' : Type u)) :=
    Algebra.TensorProduct.rightAlgebra
  -- Register the `R'`-module structures on the bare tensor carriers so `toModuleIso` finds them.
  letI instLHS : Module (R' : Type u) (↑((ModuleCat.extendScalars
      (Algebra.TensorProduct.includeLeftRingHom (R := (R : Type u)) (A := (A : Type u))
        (B := (R' : Type u)))).obj M)) :=
    inferInstanceAs (Module (R' : Type u) ↑((ModuleCat.restrictScalars
        (Algebra.TensorProduct.includeRight (R := (R : Type u)) (A := (A : Type u))
          (B := (R' : Type u))).toRingHom).obj
      ((ModuleCat.extendScalars
        (Algebra.TensorProduct.includeLeftRingHom (R := (R : Type u)) (A := (A : Type u))
          (B := (R' : Type u)))).obj M)))
  letI instRHS : Module (R' : Type u) (↑((ModuleCat.restrictScalars ψ.hom).obj
      (ModuleCat.of (R' : Type u) (R' : Type u))) ⊗[(R : Type u)]
        ↑((ModuleCat.restrictScalars φ.hom).obj M)) :=
    inferInstanceAs (Module (R' : Type u)
      ↑((ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj M)))
  -- The underlying additive equivalence: `comm ≫ (congr eT) ≫ cancelBaseChange ≫ comm`, landing on
  -- the genuine object carriers (the `eT` bridge keeps the source equal to the object carrier).
  let g :
      (↑((ModuleCat.extendScalars
        (Algebra.TensorProduct.includeLeftRingHom (R := (R : Type u)) (A := (A : Type u))
          (B := (R' : Type u)))).obj M))
      ≃+ ↑((ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj M)) :=
    (TensorProduct.comm (A : Type u) _ ↑M).toAddEquiv.trans
      ((TensorProduct.congr (LinearEquiv.refl (A : Type u) ↑M) eT).toAddEquiv.trans
        (((TensorProduct.AlgebraTensorModule.cancelBaseChange
            (R : Type u) (A : Type u) (A : Type u) ↑M (R' : Type u)).toAddEquiv).trans
          (TensorProduct.comm (R : Type u) ↑M (R' : Type u)).toAddEquiv))
  refine LinearEquiv.toModuleIso (e := { g with map_smul' := ?_ })
  -- `R'`-linearity of `g`; the generator computation is mathematically exactly the one proved in
  -- `base_change_regroup_linearEquiv` (separate module). It does NOT transfer by the documented
  -- one-liner `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`: the helper's
  -- source `(A ⊗[R] R') ⊗[A] M` uses the CANONICAL `Algebra A (A ⊗[R] R')` (leftAlgebra) action,
  -- whereas the object carrier `(extendScalars includeLeftRingHom).obj M` tensors over the
  -- `restrictScalars includeLeftRingHom` A-action; the two `⊗[A]` carriers are genuinely DIFFERENT
  -- types (the A-module is an instance argument of `TensorProduct`), so the helper's `≃ₗ` is not
  -- defeq to the object `≃ₗ` even across the import boundary. The `eT` bridge above reconciles this
  -- A-module diamond at the carrier level (so `g` itself is correctly object-typed and the object
  -- iso is produced), leaving only this `R'`-linearity of `g`.
  --
  -- INTENDED PROOF (the generator trace, blocked on instance plumbing): by
  -- `TensorProduct.induction_on x`, reduce to a generator `(a ⊗ₜ[R] s) ⊗ₜ[A] m`. The object
  -- `R'`-action on the source is `r' • y = (1 ⊗ r') • y` (`ModuleCat.restrictScalars.smul_def`
  -- along `includeRight`), and on the `extendScalars` carrier
  -- `(1 ⊗ r') • ((a ⊗ s) ⊗ₜ m) = (a ⊗ (r' * s)) ⊗ₜ m` (`ModuleCat.ExtendScalars.smul_tmul` +
  -- `Algebra.TensorProduct.tmul_mul_tmul`); g then sends both sides to the matching
  -- `cancelBaseChange` value, identical to the helper's closed computation.
  -- BLOCKER (this Mathlib pin): the object `R'`-module on the source/target is supplied by the
  -- `letI instLHS`/`instRHS` (the only available `Module R'` on those carriers), which compile to
  -- opaque aux-defs (`base_change_mate_regroupEquiv._aux_3/_5`). Typeclass search then cannot
  -- derive `SMulZeroClass`/`DistribSMul` etc. through the opaque def, so `smul_zero`/`smul_add` and
  -- the `restrictScalars.smul_def`/`ExtendScalars.smul_tmul` rewrites do not fire on the goal's
  -- smul, and a freshly-stated `hsmul` smul does not match the goal's (opaque-instance) smul.
  -- See task_results for the full attempt log; closing this needs a transparent `Module R'` instance
  -- on the `extendScalars`/`restrictScalars` carriers (e.g. a project-local `ModuleCat`-level
  -- base-change iso for the mixed `restrictScalars ∘ extendScalars` square keeping generators typed
  -- at the object).
  intro r' x
  simp only [AddEquiv.toFun_eq_coe, RingHom.id_apply]
  -- The `R'`-action on the source is `restrictScalars includeRight` of the `A ⊗[R] R'`-module on
  -- `(extendScalars includeLeftRingHom).obj M`, so `r' • x = (1 ⊗ r') • x` definitionally; `change`
  -- exposes the transparent `A ⊗[R] R'`-module smul, on which the tensor smul lemmas fire.
  change g ((Algebra.TensorProduct.includeRight r' : (↑A ⊗[↑R] ↑R')) • x) = r' • g x
  induction x using TensorProduct.induction_on with
  | zero => simp
  | add a b ha hb => rw [smul_add, map_add, map_add, smul_add, ha, hb]
  | tmul t m =>
    induction t using TensorProduct.induction_on with
    | zero => simp
    | add a b ha hb => rw [TensorProduct.add_tmul, smul_add, map_add, map_add, smul_add, ha, hb]
    | tmul a s =>
      -- Reduce the `A ⊗[R] R'`-module smul on the left factor: `(1 ⊗ r') • (a ⊗ s) = a ⊗ (r' * s)`.
      rw [TensorProduct.smul_tmul', smul_eq_mul,
        show (Algebra.TensorProduct.includeRight r' : (↑A ⊗[↑R] ↑R')) = (1 : ↑A) ⊗ₜ[↑R] r' from rfl,
        Algebra.TensorProduct.tmul_mul_tmul, one_mul]
      -- Unfold `g` on both generators and reduce the `R'`-action on the target `R' ⊗[R] M`.
      simp only [AddEquiv.trans_apply, LinearEquiv.coe_toAddEquiv, TensorProduct.comm_tmul,
        TensorProduct.congr_tmul, LinearEquiv.refl_apply,
        TensorProduct.AlgebraTensorModule.cancelBaseChange_tmul, TensorProduct.smul_tmul',
        smul_eq_mul]
      sorry

/-- **Generator identification of the conjugated section-level map (L4-b).** With the domain and
codomain pinned by `base_change_mate_domain_read` (`Θ_src`) and `base_change_mate_codomain_read`
(`Θ_tgt`), the conjugated section-level base-change map
`Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt : R' ⊗_R M ⟶ (A ⊗_R R') ⊗_A M` sends `r' ⊗ m ↦ (1 ⊗ r') ⊗ m`; equivalently
it equals the *inverse* of the regrouping isomorphism `base_change_mate_regroupEquiv`, i.e.
`Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt = (base_change_mate_regroupEquiv ψ φ M).inv`. See blueprint
`lem:base_change_mate_generator_trace_eq`.

The proof is the blueprint's three-step adjoint-mate trace: (1) the value of the `((g')^*,(g')_*)`-unit
`η'` on the global module `M` is the base-change unit `m ↦ (1 ⊗ 1) ⊗ m`; (2) applying `f_* =
restrictScalars φ` and the pseudofunctor identities `(g'f)_* = (f'g)_* = g_* f'_*` reindexes the
target as `(A ⊗_R R') ⊗_A M` (the codomain read); (3) transposing under `(g^* ⊣ g_*)` for `ψ` sends
`r' ⊗ m ↦ r' · ((1 ⊗ 1) ⊗ m) = (1 ⊗ r') ⊗ m`, which is exactly `regroupEquiv.symm` on generators
(both sides `R'`-linear). This mate-unwinding coherence over the generic pullback square is the
genuine outstanding crux (typed `sorry` below); with it discharged, `base_change_mate_generator_trace`
is a one-line corollary. -/
theorem base_change_mate_generator_trace_eq {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (base_change_mate_domain_read ψ φ M).inv ≫
      (moduleSpecΓFunctor (R := R')).map
        (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ)
          (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))
          (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))
          (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w (tilde M)) ≫
      (base_change_mate_codomain_read ψ φ M).hom
      = (base_change_mate_regroupEquiv ψ φ M).inv := by
  -- STRUCTURAL REDUCTION (landed this iter): both sides are `R'`-linear maps
  -- `R' ⊗_R M ⟶ (A ⊗_R R') ⊗_A M`, so by `ModuleCat` hom-extensionality it suffices to check the
  -- identity on the `R'`-module generators `1 ⊗ₜ x` (`x : restrictScalars φ M`); `ext x` performs
  -- this reduction, leaving the concrete per-generator identity.
  ext x
  -- REMAINING (the genuine crux): the per-generator identity
  --   `(Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt) (1 ⊗ x) = regroupEquiv.inv (1 ⊗ x)`.
  -- The RHS computes (via the sorry-free additive part of `regroupEquiv`) to `(1 ⊗ 1) ⊗ x`-type
  -- data; the LHS is the blueprint's three-step adjoint-mate trace — unwind `pushforwardBaseChangeMap`
  -- (the `(g^*⊣g_*)`-transpose of `f_*(unit)`) through `moduleSpecΓFunctor.map` and the two tilde
  -- dictionaries `pushforward_spec_tilde_iso` / `pullback_spec_tilde_iso` packaged in `Θ_src`, `Θ_tgt`:
  --   (1) the `((g')^*,(g')_*)`-unit value `m ↦ (1 ⊗ 1) ⊗ m`;
  --   (2) the `f_* = restrictScalars φ` reindex via the pushforward pseudofunctor identities,
  --       landing the target as `(A ⊗_R R') ⊗_A M` (the codomain read);
  --   (3) the `(g^* ⊣ g_*)` transpose for `ψ`, `r' ⊗ m ↦ r' · ((1⊗1)⊗m) = (1⊗r')⊗m`.
  -- This mate-unwinding coherence over the generic pullback square is Mathlib-absent and is the
  -- flagged effort-break candidate (split the three steps into named sub-lemmas before the next iter).
  -- See task_results for the worked decomposition.
  sorry

/-- **Generator trace of the section-level base-change map.** With the domain and codomain pinned
by `base_change_mate_domain_read` (`Θ_src`) and `base_change_mate_codomain_read` (`Θ_tgt`), the
conjugated section-level base-change map `Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt` — a map `R' ⊗_R M ⟶
(A ⊗_R R') ⊗_A M` — is an isomorphism. The generator trace of the blueprint shows it sends
`r' ⊗ m ↦ (1 ⊗ r') ⊗ m`, i.e. it is `cancelBaseChange⁻¹` (after the `A ⊗_R R' ≅ R' ⊗_R A`
regrouping); since `cancelBaseChange` is a Mathlib `LinearEquiv` with no flatness hypothesis, the
conjugate is an isomorphism. This `IsIso` form is the iso-consequence the affine close consumes
(mirroring the parent `pushforward_base_change_mate_cancelBaseChange`); the proof obligation is the
adjoint-mate unwinding of `pushforwardBaseChangeMap` on global sections through the two proved
tilde dictionaries. See blueprint `lem:base_change_mate_generator_trace`. -/
theorem base_change_mate_generator_trace {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    IsIso ((base_change_mate_domain_read ψ φ M).inv ≫
      (moduleSpecΓFunctor (R := R')).map
        (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ)
          (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))
          (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))
          (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w (tilde M)) ≫
      (base_change_mate_codomain_read ψ φ M).hom) := by
  -- By the generator identification `base_change_mate_generator_trace_eq` the conjugated map equals
  -- `(base_change_mate_regroupEquiv ψ φ M).inv`, the inverse of a `ModuleCat` isomorphism, hence an
  -- isomorphism.
  rw [base_change_mate_generator_trace_eq]
  infer_instance

/-! ## Section-level value of the affine base-change map -/

/-- **Section-level value of the affine base-change map.** In the affine–affine model — base ring
maps `ψ : R ⟶ R'` (the base change `g = Spec ψ`) and `φ : R ⟶ A` (the affine morphism
`f = Spec φ`), with `F = M^~` for an `A`-module `M`, the canonical pullback square supplying
`g' = pullback.fst`, `f' = pullback.snd` — the global-sections incarnation `Γ(α)` of the
base-change map `pushforwardBaseChangeMap` is an isomorphism of `R'`-modules.

By the four affine dictionaries the domain `Γ(g^*(f_* M^~))` reads as `R' ⊗_R M` and the codomain
`Γ(f'_*(g')^* M^~)` reads as `(R' ⊗_R A) ⊗_A M`, under which `Γ(α)` is the canonical cancellation
isomorphism `TensorProduct.AlgebraTensorModule.cancelBaseChange` (in the orientation
`Γ(α) = cancelBaseChange⁻¹`, `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m`); since `cancelBaseChange` carries no
flatness hypothesis, `Γ(α)` is an isomorphism. This is the section-level content of the affine
close: it is the per-affine-chart input to `base_change_map_affine_local` once the locality
reduction has restricted an arbitrary square to this affine–affine model. See blueprint
`lem:pushforward_base_change_mate_cancelBaseChange`.

The proof is the 4-step generator trace of the blueprint: unwind the adjoint mate of the
`((g')^*, (g')_*)`-unit on global sections through `pushforward_spec_tilde_iso` and
`pullback_spec_tilde_iso`, landing on `cancelBaseChange⁻¹`. The mate-unwinding coherence over the
generic pullback square `pullback (Spec.map φ) (Spec.map ψ)` is the genuine crux and is the
outstanding obligation (typed `sorry` below). -/
theorem pushforward_base_change_mate_cancelBaseChange
    {R R' A : CommRingCat.{u}} (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    IsIso ((moduleSpecΓFunctor (R := R')).map
      (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ)
        (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))
        (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))
        (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w (tilde M))) := by
  -- Assemble the chain (blueprint `lem:pushforward_base_change_mate_cancelBaseChange`): the domain
  -- read `Θ_src` (`base_change_mate_domain_read`) and codomain read `Θ_tgt`
  -- (`base_change_mate_codomain_read`, resting on the `pullbackSpecIso` leg identification
  -- `pullback_fst_snd_specMap_tensor`) identify `Γ(α)`'s domain/codomain with `R' ⊗_R M` and
  -- `(A ⊗_R R') ⊗_A M`; the generator trace `base_change_mate_generator_trace` shows the conjugate
  -- `Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt` is an isomorphism (it is `cancelBaseChange⁻¹`, no flatness).
  -- Conjugating back, `Γ(α)` is itself an isomorphism.
  haveI hconj := base_change_mate_generator_trace ψ φ M
  set D := base_change_mate_domain_read ψ φ M with hD
  set C := base_change_mate_codomain_read ψ φ M with hC
  set Γα := (moduleSpecΓFunctor (R := R')).map
    (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ)
      (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))
      (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))
      (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w (tilde M)) with hΓα
  have heq : Γα = D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv := by
    simp [Category.assoc]
  rw [heq]
  infer_instance

/-! ## The affine base-change lemma and its locality reduction -/

/-- **Affine-local compatibility of the base-change map (locality reduction).** For `f` affine
and `F` quasi-coherent, the base-change map `pushforwardBaseChangeMap` is an isomorphism as soon
as it restricts to an isomorphism on the sections over every affine open of the base `S'`. This is
the locality reduction underlying `affineBaseChange_pushforward_iso`: it discharges the
affine-open locality criterion `Modules.isIso_iff_isIso_app_affineOpens` for the base-change map,
the per-affine-open hypothesis being the affine–affine section assertion supplied (over each chart)
by the section-level computation. The `[IsAffineHom f]`/`[F.IsQuasicoherent]` hypotheses are
carried because the per-open assertion `H` is only available under them (they make `X` restrict to
`Spec A` and `F` to `M^~` over each affine chart); the reduction itself is the locality criterion.
See blueprint `lem:base_change_map_affine_local`. -/
theorem base_change_map_affine_local (h : IsPullback g' f' f g) [IsAffineHom f]
    (F : X.Modules) [F.IsQuasicoherent]
    (H : ∀ U : S'.affineOpens, IsIso ((pushforwardBaseChangeMap f g f' g' h.w F).app U)) :
    IsIso (pushforwardBaseChangeMap f g f' g' h.w F) :=
  (Modules.isIso_iff_isIso_app_affineOpens (pushforwardBaseChangeMap f g f' g' h.w F)).mpr H

/-- **Affine base change.** If `f` is an affine morphism and the square is
cartesian, then the base-change map for the pushforward is an isomorphism. In the
affine-local picture this is the associativity isomorphism
`(R' ⊗_R A) ⊗_A M ≅ R' ⊗_R M`, which needs no flatness.

Source: Stacks Project, Cohomology of Schemes, Lemma "Affine base change". -/
theorem affineBaseChange_pushforward_iso (h : IsPullback g' f' f g) [IsAffineHom f]
    (F : X.Modules) [F.IsQuasicoherent] :
    IsIso (pushforwardBaseChangeMap f g f' g' h.w F) := by
  -- FIRST REDUCTION (locality on `S'`): by `base_change_map_affine_local` it suffices to check
  -- that the base-change map is an isomorphism on the sections over every affine open of `S'`.
  -- This is exactly the locality reduction; the per-affine-open hypothesis is the affine–affine
  -- section assertion that `pushforward_base_change_mate_cancelBaseChange` is intended to supply.
  apply base_change_map_affine_local f g f' g' h F
  intro U
  -- Remaining goal: `IsIso (Hom.app (pushforwardBaseChangeMap …) U)` for `U` affine.
  --
  -- The two obligations of the blueprint affine close are now NAMED declarations:
  --   • the SECTION-LEVEL identification is `pushforward_base_change_mate_cancelBaseChange`
  --     (above): in the affine–affine model `Γ(α) = cancelBaseChange⁻¹`, hence an iso (no
  --     flatness). Its statement is in place; its proof (the 4-step generator trace) is the
  --     genuine crux still carrying a `sorry`.
  --   • the SECTION-LEVEL locality reduction is `base_change_map_affine_local` (just applied):
  --     it reduced the global iso to this per-affine-open `U` goal.
  --
  -- WHAT REMAINS HERE (the AFFINE REDUCTION, "obligation 1"): the ambient `S, S', X, X'` are
  -- ARBITRARY (only `f` affine, `F` quasi-coherent). To discharge the per-`U` goal one must
  -- restrict the cartesian square over the affine open `U = Spec R' ⊆ S'` and a chosen affine
  -- `Spec R ⊆ S` containing `g(U)` — over which `[IsAffineHom f]` makes `X` restrict to `Spec A`
  -- and `[F.IsQuasicoherent]` makes `F` restrict to `M^~` — and IDENTIFY `(pushforwardBaseChangeMap
  -- …).app U` with the affine–affine base-change map of the restricted square (blueprint Step 2:
  -- naturality of the adjunction transpose + pushforward-commutes-with-restriction). Then the
  -- per-`U` goal is exactly `pushforward_base_change_mate_cancelBaseChange` (composed with the
  -- tilde–Γ counit isos to pass `IsIso Γ(α) ⟹ IsIso α` on the QC chart). This restriction-
  -- compatibility of `pushforwardBaseChangeMap` is itself Mathlib-absent and is the remaining
  -- multi-hundred-LOC build for the unconditional general theorem.
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
