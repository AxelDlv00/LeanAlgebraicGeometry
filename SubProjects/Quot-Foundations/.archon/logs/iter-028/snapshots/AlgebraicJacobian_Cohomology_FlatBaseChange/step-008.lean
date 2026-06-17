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
  -- Use `.1`/`.2` projections (not `obtain`) so the body has no stuck `And.casesOn`; this makes
  -- `base_change_mate_codomain_read` definitionally the variable-legs read
  -- `base_change_mate_codomain_read_legs … pullback.fst pullback.snd …` (proof irrelevance on the
  -- leg-equality arguments), which is what lets `base_change_mate_fstar_reindex` reduce to the
  -- abstract `base_change_mate_fstar_reindex_legs` by `exact`.
  have hfst : Limits.pullback.fst (Spec.map φ) (Spec.map ψ) = e.hom ≫ Spec.map inclA :=
    (Iso.inv_comp_eq e).mp (pullback_fst_snd_specMap_tensor ψ φ).1
  have hsnd : Limits.pullback.snd (Spec.map φ) (Spec.map ψ) = e.hom ≫ Spec.map inclR' :=
    (Iso.inv_comp_eq e).mp (pullback_fst_snd_specMap_tensor ψ φ).2
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

The mathematical content is the proved, axiom-clean `comm ≪≫ cancelBaseChange ≪≫ comm` core
(`TensorProduct.AlgebraTensorModule.cancelBaseChange`, `R'`-linear via the `rightAlgebra` action,
no flatness). Here it is transported to the `ModuleCat` change-of-rings objects through the identity
`A`-linear bridge `eT` (resolving the `Module A (A ⊗[R] R')` diamond: `extendScalars` uses
`restrictScalars includeLeftRingHom` whereas `cancelBaseChange` forces the canonical
`Algebra A (A ⊗[R] R')`), so the underlying additive equivalence `g` lands on the genuine
`extendScalars`/`restrictScalars` object carriers; `LinearEquiv.toModuleIso` packages it directly.

STATUS (iter-011, route (a) executed): the def is **fully proved, no `sorry`**. The residual
`map_smul'` of `g` is discharged by `TensorProduct.induction_on`: the per-generator (`tmul`) identity
and `R'`-additivity (`add`) close via `erw [ModuleCat.ExtendScalars.smul_tmul]` (defeq-matching past
the opaque object `Module R'`) + a `change` peeling `g` to `cancelBaseChange_tmul`/`comm_tmul`; the
two `zero` branches — `g (r' • 0) = r' • g 0`, formerly the carrier-instance wall — close in term
mode via `congrArg`/`AddEquiv.map_zero`/`smul_zero` (sidestepping `rw`'s keyed matching) and, for the
inner `0 ⊗ₜ m`, `erw [TensorProduct.zero_tmul]` (defeq-matching the diamond instance). Eliminating the
`map_smul'` field entirely via the natively `R'`-linear `Algebra.IsPushout.cancelBaseChange` is
blocked by the same `A`-action diamond at the `exact`/ascription boundary (the object carrier and the
pushout carrier are defeq but not syntactically equal, so neither `exact` nor a `≃ₗ` type ascription
unifies them); the present route reaches the same axiom-clean conclusion. -/
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
  -- `eT`: the identity `A`-linear bridge from the `restrictScalars includeLeftRingHom` `A`-structure
  -- on `A ⊗[R] R'` to the canonical `Algebra A (A ⊗[R] R')` structure (resolving the diamond).
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
  -- ROUTE (a) (blueprint `lem:base_change_mate_regroupEquiv`): the mathematical core is the
  -- natively `R'`-linear pushout cancellation `cancelBaseChange` (Mathlib, no flatness). The object
  -- carrier produced by the dictionaries tensors `A ⊗[R] R'` over the `restrictScalars
  -- includeLeftRingHom` `A`-action, whereas `cancelBaseChange` uses the canonical `Algebra A
  -- (A ⊗[R] R')`; the identity `A`-linear bridge `eT` reconciles this lone diamond at the carrier
  -- level. The underlying additive equivalence is `comm ≫ congr(refl, eT) ≫ cancelBaseChange ≫ comm`,
  -- landing on the genuine object carriers.
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
  intro r' x
  simp only [AddEquiv.toFun_eq_coe, RingHom.id_apply]
  induction x using TensorProduct.induction_on with
  | zero =>
      -- `g (r' • 0) = r' • g 0`: both sides are `0`. Term-mode (sidesteps `rw`'s keyed matching,
      -- which is blocked by the opaque object `Module ↑R'` instances on the tensor carriers).
      exact (congrArg (⇑g) (smul_zero r')).trans
        (g.map_zero.trans ((smul_zero r').symm.trans (congrArg (r' • ·) g.map_zero.symm)))
  | add a b ha hb =>
      erw [smul_add, map_add, map_add, smul_add]
      exact congrArg₂ (· + ·) ha hb
  | tmul t m =>
    induction t using TensorProduct.induction_on with
    | zero =>
      -- `g (r' • (0 ⊗ₜ m)) = r' • g (0 ⊗ₜ m)`: since `0 ⊗ₜ m = 0`, this is the zero identity.
      -- `convert` peels `g`/`r' • ·`, leaving `0 ⊗ₜ m = 0` goals whose carrier instance is taken
      -- from the context (so `TensorProduct.zero_tmul` matches), avoiding the `A`-action diamond.
      have h0 : g (r' • (0 : ↑((ModuleCat.extendScalars
            (Algebra.TensorProduct.includeLeftRingHom (R := (R : Type u)) (A := (A : Type u))
              (B := (R' : Type u)))).obj M))) = r' • g 0 :=
        (congrArg (⇑g) (smul_zero r')).trans
          (g.map_zero.trans ((smul_zero r').symm.trans (congrArg (r' • ·) g.map_zero.symm)))
      erw [TensorProduct.zero_tmul]
      exact (congrArg (⇑g) (smul_zero r')).trans
        (g.map_zero.trans ((smul_zero r').symm.trans (congrArg (r' • ·) g.map_zero.symm)))
    | add a b ha hb =>
      erw [TensorProduct.add_tmul, smul_add, map_add, map_add, smul_add]
      exact congrArg₂ (· + ·) ha hb
    | tmul a s =>
      -- The `R'`-action on the source is `restrictScalars includeRight` of the `A ⊗[R] R'`-module,
      -- so `r' • z = (1 ⊗ r') • z` definitionally; `erw` reduces the `A ⊗[R] R'`-module smul on the
      -- left factor up to that defeq: `(1 ⊗ r') • (a ⊗ s) = (1 ⊗ r') * (a ⊗ s) = a ⊗ (r' * s)`.
      erw [ModuleCat.ExtendScalars.smul_tmul,
        show (Algebra.TensorProduct.includeRight r' : (↑A ⊗[↑R] ↑R')) = (1 : ↑A) ⊗ₜ[↑R] r' from rfl,
        Algebra.TensorProduct.tmul_mul_tmul, one_mul]
      -- Unfold `g` on both generators; `eT` is the identity bridge, so it drops out (defeq).
      change (TensorProduct.comm ↑R ↑M ↑R')
          ((TensorProduct.AlgebraTensorModule.cancelBaseChange ↑R ↑A ↑A ↑M ↑R')
            (m ⊗ₜ[↑A] (a ⊗ₜ[↑R] (r' * s))))
        = r' • (TensorProduct.comm ↑R ↑M ↑R')
          ((TensorProduct.AlgebraTensorModule.cancelBaseChange ↑R ↑A ↑A ↑M ↑R')
            (m ⊗ₜ[↑A] (a ⊗ₜ[↑R] s)))
      rw [TensorProduct.AlgebraTensorModule.cancelBaseChange_tmul,
        TensorProduct.AlgebraTensorModule.cancelBaseChange_tmul,
        TensorProduct.comm_tmul, TensorProduct.comm_tmul]
      -- LHS `(r' * s) ⊗ₜ (a • m)`; RHS `r' • (s ⊗ₜ (a • m)) = (r' * s) ⊗ₜ (a • m)`.
      rw [TensorProduct.smul_tmul', smul_eq_mul]

/-! ## Section-level mate identity, decomposed into three seams

The LHS unwinding of `pushforwardBaseChangeMap` on global sections splits at three categorical
seams (blueprint `lem:base_change_mate_unit_value` / `…_fstar_reindex` / `…_gstar_transpose`):

* Seam 1 — the affine pullback–pushforward unit IS the algebraic unit `η_M`;
* Seam 2 — the pushforward pseudofunctor reindex of the inner comparison;
* Seam 3 — the `(g^* ⊣ g_*)` transpose of the comparison on sections.

`base_change_mate_section_identity` is then the one-line chain of the counit factorization
(`Adjunction.homEquiv_counit`) and Seam 3. -/

-- The conjugate-unit calculus chains several `erw` defeq-unifications and a `simp` closure over the
-- `restrictScalars`/tilde–Γ round trips, which collectively exceed the default heartbeat budget.
set_option maxHeartbeats 4000000 in
/-- **Seam 1: the affine pullback–pushforward unit is the algebraic unit.** Let
`ι_A : A → A ⊗_R R'` be the canonical inclusion. The unit of the
`((Spec ι_A)^*, (Spec ι_A)_*)`-adjunction evaluated at `tilde M`, read on global sections over
`Spec A` through the two tilde dictionaries (`pullback_spec_tilde_iso`,
`pushforward_spec_tilde_iso`) and the tilde–Γ unit, equals the algebraic unit
`η_M : M → (A ⊗_R R') ⊗_A M`, `m ↦ (1 ⊗ 1) ⊗ m` (Mathlib's `ModuleCat.extendRestrictScalarsAdj`
unit). See blueprint `lem:base_change_mate_unit_value`. -/
theorem base_change_mate_unit_value {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    let inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
      (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))
    (tilde.toTildeΓNatIso.app M).hom ≫
      (moduleSpecΓFunctor (R := A)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction (Spec.map inclA)).unit.app (tilde M)) ≫
        ((moduleSpecΓFunctor (R := A)).mapIso
            ((Scheme.Modules.pushforward (Spec.map inclA)).mapIso
                (pullback_spec_tilde_iso inclA M) ≪≫
              pushforward_spec_tilde_iso inclA ((ModuleCat.extendScalars inclA.hom).obj M))
          ≪≫ (tilde.toTildeΓNatIso.app
                ((ModuleCat.restrictScalars inclA.hom).obj
                  ((ModuleCat.extendScalars inclA.hom).obj M))).symm).hom
        = (ModuleCat.extendRestrictScalarsAdj inclA.hom).unit.app M := by
  -- REMAINING (the affine, square-free heart): a conjugate-adjunction unit coherence. The
  -- geometric adjunction `((Spec ι_A)^* ⊣ (Spec ι_A)_*)` transports, under the two tilde
  -- dictionaries — `pullback_spec_tilde_iso` (identifying `(Spec ι_A)^*` of a tilde with
  -- `extendScalars ι_A`) and `pushforward_spec_tilde_iso` (identifying `(Spec ι_A)_*` of a tilde
  -- with `restrictScalars ι_A`) — to the algebraic adjunction
  -- `(extendScalars ι_A ⊣ restrictScalars ι_A) = ModuleCat.extendRestrictScalarsAdj ι_A`. Since
  -- `pullback_spec_tilde_iso` is by construction `((conjugateIsoEquiv adjL adjR).symm
  -- (gammaPushforwardNatIso ι_A)).symm.app`, the LHS is the image of the geometric unit under the
  -- comparison, and `Adjunction.conjugateEquiv` / `homEquiv` naturality identify it with the
  -- algebraic unit evaluated at `M` (`m ↦ (1 ⊗ 1) ⊗ m`). The element-level actions of the two
  -- dictionaries are opaque (built via `conjugateIsoEquiv`), so the closure needs the abstract
  -- conjugate-unit coherence, not an `ext`-chase. Uses: `pullback_spec_tilde_iso`,
  -- `pushforward_spec_tilde_iso`, `Adjunction.conjugateEquiv`.
  intro inclA
  -- The two composed adjunctions, exactly as in `pullback_spec_tilde_iso` (with `φ := inclA`).
  set adjL := (tilde.adjunction (R := A)).comp
    (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map inclA)) with hadjL
  set adjR := (ModuleCat.extendRestrictScalarsAdj inclA.hom).comp
    (tilde.adjunction (R := _)) with hadjR
  -- Move 1: the first two factors are the unit of `adjL`.
  have hunitL : adjL.unit.app M
      = (tilde.toTildeΓNatIso.app M).hom ≫
          (moduleSpecΓFunctor (R := A)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction (Spec.map inclA)).unit.app (tilde M)) := by
    rw [hadjL, Adjunction.comp_unit_app]
    rfl
  -- Move 3: the unit of `adjR` splits off the algebraic unit `η_M`.
  have hunitR : adjR.unit.app M
      = (ModuleCat.extendRestrictScalarsAdj inclA.hom).unit.app M ≫
          (ModuleCat.restrictScalars inclA.hom).map
            ((tilde.toTildeΓNatIso.app ((ModuleCat.extendScalars inclA.hom).obj M)).hom) := by
    rw [hadjR, Adjunction.comp_unit_app]
    rfl
  -- The right-adjoint comparison nat-iso `β : R₁ ≅ R₂` fed to the conjugate calculus.
  set β := gammaPushforwardNatIso inclA with hβ
  -- Move 2: the conjugate-unit coherence. `((conjugateEquiv adjL adjR).symm β.hom).app M` is, by the
  -- definition of `pullback_spec_tilde_iso` via `conjugateIsoEquiv`, exactly `pullback_spec_tilde_iso⁻¹`.
  have hpullinv : ((conjugateEquiv adjL adjR).symm β.hom).app M
      = (pullback_spec_tilde_iso inclA M).inv := by rw [hβ]; rfl
  have huce := CategoryTheory.unit_conjugateEquiv_symm adjL adjR β.hom M
  rw [hpullinv] at huce
  -- Move 4, part 1 (Claim A): the pushforward dictionary `pushforward_spec_tilde_iso`, read on Γ and
  -- composed with the tilde–Γ unit, is the Γ-fragment comparison `gammaPushforwardTildeIso`. This is
  -- the right-triangle identity of the tilde ⊣ Γ adjunction (`fromTildeΓ` is its counit).
  have htri : (moduleSpecΓFunctor (R := A)).map (Scheme.Modules.fromTildeΓ
        ((pushforward (Spec.map inclA)).obj (tilde ((ModuleCat.extendScalars inclA.hom).obj M))))
      = (tilde.toTildeΓNatIso.app ((moduleSpecΓFunctor (R := A)).obj
          ((pushforward (Spec.map inclA)).obj
            (tilde ((ModuleCat.extendScalars inclA.hom).obj M))))).inv :=
    (Iso.hom_comp_eq_id _).mp (tilde.adjunction.right_triangle_components _)
  have hClaimA : (moduleSpecΓFunctor (R := A)).map
        (pushforward_spec_tilde_iso inclA ((ModuleCat.extendScalars inclA.hom).obj M)).hom ≫
        (tilde.toTildeΓNatIso.app ((ModuleCat.restrictScalars inclA.hom).obj
          ((ModuleCat.extendScalars inclA.hom).obj M))).inv
      = (gammaPushforwardTildeIso inclA ((ModuleCat.extendScalars inclA.hom).obj M)).hom := by
    rw [Iso.comp_inv_eq, pushforward_spec_tilde_iso, pushforward_spec_tilde_iso_of_isLocalizedModule]
    simp only [Iso.trans_hom, Iso.symm_hom, asIso_inv, Functor.mapIso_hom, Functor.map_comp,
      Functor.map_inv, IsIso.inv_comp_eq]
    rw [htri]
    exact (NatIso.naturality_1 tilde.toTildeΓNatIso
      (gammaPushforwardTildeIso inclA ((ModuleCat.extendScalars inclA.hom).obj M)).hom).symm
  -- Move 4, part 2: `β.hom` at a tilde object is the per-object `gammaPushforwardIso`, and
  -- `gammaPushforwardTildeIso` factors through it and the tilde–Γ unit.
  have hβapp : β.hom.app (tilde ((ModuleCat.extendScalars inclA.hom).obj M))
      = (gammaPushforwardIso inclA (tilde ((ModuleCat.extendScalars inclA.hom).obj M))).hom := by
    rw [hβ, gammaPushforwardNatIso]; simp
  have hgPTI : (gammaPushforwardTildeIso inclA ((ModuleCat.extendScalars inclA.hom).obj M)).hom
      = β.hom.app (tilde ((ModuleCat.extendScalars inclA.hom).obj M)) ≫
        (ModuleCat.restrictScalars inclA.hom).map
          (tilde.toTildeΓNatIso.app ((ModuleCat.extendScalars inclA.hom).obj M)).inv := by
    rw [hβapp, gammaPushforwardTildeIso]
    simp [Iso.trans_hom]
  -- Final assembly. Move 1 folds the first two factors into `adjL.unit`; unfolding the bracket and
  -- applying Claim A + hgPTI rewrites it through `β`; β-naturality at `pullback_spec_tilde_iso.hom`
  -- and the conjugate-unit identity `huce` then collapse everything to the algebraic unit `η_M`.
  rw [← Category.assoc, ← hunitL]
  simp only [Iso.trans_hom, Functor.mapIso_hom, Iso.symm_hom, Functor.map_comp, Category.assoc]
  rw [hClaimA]
  -- Finish: hgPTI expands the Γ-fragment comparison; converting to composed-functor form
  -- (`← Functor.comp_map`) lets the β-naturality square (`erw [β.hom.naturality_assoc]`) and the
  -- conjugate-unit identity (`erw [reassoc_of% huce]`) push the geometric unit through `β`; the
  -- tilde–Γ and pullback-iso round trips then cancel, leaving the algebraic unit `η_M` (hunitR).
  rw [hgPTI]
  simp only [← Functor.comp_map]
  erw [β.hom.naturality_assoc]
  erw [reassoc_of% huce]
  rw [hunitR]
  simp only [Functor.comp_map]
  simp [← Functor.map_comp]
  rw [← Iso.app_hom, ← Iso.app_inv, Iso.hom_inv_id, CategoryTheory.Functor.map_id, Category.comp_id]

/-- **The `Spec R`-section reading `ρ` of the inner pushforward comparison.** The canonical
`R`-linear map `M → (A ⊗_R R') ⊗_A M`, `m ↦ (1 ⊗ 1) ⊗ m`, viewed as a morphism of `ModuleCat R`
into the `restrictScalars ψ`/`restrictScalars inclR'` packaging of the codomain read. It is built
as `restrictScalars φ` of the algebraic unit `η_M = extendRestrictScalarsAdj inclA` (Seam 1's
value), transported across the ring equation `inclA ∘ φ = inclR' ∘ ψ` (both equal
`algebraMap R (A ⊗_R R')`) by the change-of-rings tower isos. This is the `ρ` appearing on the RHS
of Seam 2 (`base_change_mate_fstar_reindex`). -/
noncomputable def base_change_mate_inner_value {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    let inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
      (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))
    let inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeRight
      (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom
    (ModuleCat.restrictScalars φ.hom).obj M ⟶
      (ModuleCat.restrictScalars ψ.hom).obj
        ((ModuleCat.restrictScalars inclR'.hom).obj
          ((ModuleCat.extendScalars inclA.hom).obj M)) := by
  letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
  letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
  intro inclA inclR'
  have hring : inclA.hom.comp φ.hom = inclR'.hom.comp ψ.hom := by
    ext r
    show (CommRingCat.Hom.hom φ) r ⊗ₜ[(R : Type u)] (1 : (R' : Type u))
        = (1 : (A : Type u)) ⊗ₜ[(R : Type u)] (CommRingCat.Hom.hom ψ) r
    have ha : (CommRingCat.Hom.hom φ) r = r • (1 : (A : Type u)) :=
      Algebra.algebraMap_eq_smul_one r
    have hb : (CommRingCat.Hom.hom ψ) r = r • (1 : (R' : Type u)) :=
      Algebra.algebraMap_eq_smul_one r
    rw [ha, hb, TensorProduct.smul_tmul]
  exact (ModuleCat.restrictScalars φ.hom).map
        ((ModuleCat.extendRestrictScalarsAdj inclA.hom).unit.app M) ≫
      ((ModuleCat.restrictScalarsComp'App φ.hom inclA.hom (inclA.hom.comp φ.hom) rfl
            ((ModuleCat.extendScalars inclA.hom).obj M)).symm ≪≫
        (ModuleCat.restrictScalarsCongr hring).app
            ((ModuleCat.extendScalars inclA.hom).obj M) ≪≫
        ModuleCat.restrictScalarsComp'App ψ.hom inclR'.hom (inclR'.hom.comp ψ.hom) rfl
            ((ModuleCat.extendScalars inclA.hom).obj M)).hom

/-- **Pseudofunctoriality of the pullback–pushforward unit.** For composable scheme morphisms
`a : X₁ ⟶ X₂`, `b : X₂ ⟶ X₃` and a module `N` on `X₁`, the unit of the
`(pullback (a ≫ b) ⊣ pushforward (a ≫ b))`-adjunction factors through the units of `a` and `b`
together with the `pushforwardComp`/`pullbackComp` coherences. This is the abstract mate identity
`unit_conjugateEquiv` specialised by `conjugateEquiv_pullbackComp_inv`
(`conjugateEquiv … (pullbackComp a b).inv = (pushforwardComp a b).hom`). It is the leg-reindex
engine of Seam 2: with `a := e.hom` (an iso) and `b := Spec ι_A`, it turns the generic
`(pullback.fst)`-unit into the affine `(Spec ι_A)`-unit modulo the transparent coherences.
Project-local. -/
theorem pullbackPushforward_unit_comp {X₁ X₂ X₃ : Scheme.{u}} (a : X₁ ⟶ X₂) (b : X₂ ⟶ X₃)
    (N : X₃.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app N ≫
        (Scheme.Modules.pushforward b).map
          ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
            ((Scheme.Modules.pullback b).obj N)) ≫
        (Scheme.Modules.pushforwardComp a b).hom.app _
      = (Scheme.Modules.pullbackPushforwardAdjunction (a ≫ b)).unit.app N ≫
          (Scheme.Modules.pushforward (a ≫ b)).map
            ((Scheme.Modules.pullbackComp a b).inv.app N) := by
  have h := CategoryTheory.unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction b).comp
      (Scheme.Modules.pullbackPushforwardAdjunction a))
    (Scheme.Modules.pullbackPushforwardAdjunction (a ≫ b))
    (Scheme.Modules.pullbackComp a b).inv N
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv, Adjunction.comp_unit_app] at h
  rw [← Category.assoc]
  exact h

/-! ### Seam 2, step (ii): Γ-collapse of the transparent pushforward coherences

On global sections over `Spec R`, the two `pushforwardComp` composition coherences and the
`pushforwardCongr` congruence coherence appearing in the inner composite `θ_in` are transparent:
their section value at every open is the identity (`pushforwardComp_*_app_app = 𝟙`) or a presheaf
transport (`pushforwardCongr_hom_app_app`). Hence under `moduleSpecΓFunctor` they collapse to the
identity / an `eqToHom` repackaging. These are the blueprint step-(ii) atomic claims. -/

/-- **(ii-a) Γ-collapse of `pushforwardComp` (hom factor).** The `pushforwardComp` hom-coherence
has identity section value at every open, hence is the identity morphism of `(Spec R).Modules`, and
its `moduleSpecΓFunctor` image is the identity. -/
private lemma gammaMap_pushforwardComp_hom_eq_id {X₁ X₂ : Scheme.{u}} {R : CommRingCat.{u}}
    (a : X₁ ⟶ X₂) (b : X₂ ⟶ Spec R) (M : X₁.Modules) :
    (moduleSpecΓFunctor (R := R)).map
      ((Scheme.Modules.pushforwardComp a b).hom.app M) = 𝟙 _ := by
  have h : (Scheme.Modules.pushforwardComp a b).hom.app M = 𝟙 _ := rfl
  rw [h]; exact (moduleSpecΓFunctor (R := R)).map_id _

/-- **(ii-b) Γ-collapse of `pushforwardComp` (inv factor).** Same as (ii-a) for the inverse. -/
private lemma gammaMap_pushforwardComp_inv_eq_id {X₁ X₂ : Scheme.{u}} {R : CommRingCat.{u}}
    (a : X₁ ⟶ X₂) (b : X₂ ⟶ Spec R) (M : X₁.Modules) :
    (moduleSpecΓFunctor (R := R)).map
      ((Scheme.Modules.pushforwardComp a b).inv.app M) = 𝟙 _ := by
  have h : (Scheme.Modules.pushforwardComp a b).inv.app M = 𝟙 _ := rfl
  rw [h]; exact (moduleSpecΓFunctor (R := R)).map_id _

/-- **(ii-c) Γ-collapse of `pushforwardCongr` (hom factor).** For equal scheme morphisms
`f = g` into `Spec R`, the congruence coherence collapses, under `moduleSpecΓFunctor`, to the
canonical `eqToHom` transport along the induced object equality — a repackaging carrying no
substantive content. -/
private lemma gammaMap_pushforwardCongr_hom {X : Scheme.{u}} {R : CommRingCat.{u}}
    {f g : X ⟶ Spec R} (hfg : f = g) (M : X.Modules) :
    (moduleSpecΓFunctor (R := R)).map ((Scheme.Modules.pushforwardCongr hfg).hom.app M)
      = eqToHom (by rw [hfg]) := by
  subst hfg
  have h : (Scheme.Modules.pushforwardCongr (rfl : f = f)).hom.app M = 𝟙 _ := by
    ext U; simp
  rw [h]; simp

/-- **(Seam 2, step i) Abstract variable-legs codomain read.** The codomain identification
`base_change_mate_codomain_read`, restated for *generic* legs `g' f'` carrying the cone-leg
equalities `hfst : g' = e ≫ Spec ιA`, `hsnd : f' = e ≫ Spec ιR'` as explicit hypotheses (with
`e = pullbackSpecIso`). In this form the legs are free variables rather than the literal pullback
projections, so they can be eliminated by `subst` on a well-typed motive — this is the structural
device of blueprint step (i) that dissolves the `motive is not type correct` wall. Its body is the
verbatim construction of `base_change_mate_codomain_read`, which is the special case at
`g' = pullback.fst`, `f' = pullback.snd`. -/
noncomputable def base_change_mate_codomain_read_legs {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    ∀ (g' : Limits.pullback (Spec.map φ) (Spec.map ψ) ⟶ Spec A)
      (f' : Limits.pullback (Spec.map φ) (Spec.map ψ) ⟶ Spec R')
      (_hfst : g' = (pullbackSpecIso (R := (R : Type u)) (S := (A : Type u))
            (T := (R' : Type u))).hom ≫
          Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
            (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))))
      (_hsnd : f' = (pullbackSpecIso (R := (R : Type u)) (S := (A : Type u))
            (T := (R' : Type u))).hom ≫
          Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeRight
            (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom)),
    (moduleSpecΓFunctor (R := R')).obj
        ((Scheme.Modules.pushforward f').obj
          ((Scheme.Modules.pullback g').obj (tilde M))) ≅
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
  intro g' f' hfst hsnd
  set W₀ := (Scheme.Modules.pullback (Spec.map inclA)).obj (tilde M) with hW₀
  have iso_g : (Scheme.Modules.pullback g').obj (tilde M)
        ≅ (Scheme.Modules.pullback e.hom).obj W₀ :=
    (Scheme.Modules.pullbackCongr hfst).app (tilde M) ≪≫
      (Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).symm.app (tilde M)
  have unit_iso : W₀ ≅ (Scheme.Modules.pushforward e.hom).obj
        ((Scheme.Modules.pullback e.hom).obj W₀) :=
    (asIso (Scheme.Modules.pullbackPushforwardAdjunction e.hom).unit).app W₀
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

/-! ### Seam 2, step (iii): the mate-unwinding crux, cut into five atomic links

The five lemmas `base_change_mate_fstar_reindex_legs_{unitExpand, gammaDistribute, eCancel,
affineUnit, innerMatch}` decompose the step-(iii) obligation of
`base_change_mate_fstar_reindex_legs` into one mathematical move each. See blueprint
`lem:base_change_mate_fstar_reindex_legs_{unitExpand,…}`. -/

/-- **(iii-1) Unit expansion: inverting the comp-coherence.** For composable `a : X₁ ⟶ X₂`,
`b : X₂ ⟶ X₃`, a module `N` on `X₃`, and `g' = a ≫ b`, the bare `(g')`-unit expands as the
four-factor composite `η^b ≫ b_*(η^a) ≫ pushforwardComp(a,b).hom ≫ g'_*(pullbackComp(a,b).hom)`.
This is the inversion of the leg-reindex engine `pullbackPushforward_unit_comp`: post-composing its
identity with `g'_*(pullbackComp.hom)` collapses the trailing `pullbackComp.inv` (functoriality of
`g'_*` on `inv ≫ hom = id`). See blueprint `lem:base_change_mate_fstar_reindex_legs_unitExpand`. -/
theorem base_change_mate_fstar_reindex_legs_unitExpand {X₁ X₂ X₃ : Scheme.{u}}
    (a : X₁ ⟶ X₂) (b : X₂ ⟶ X₃) (N : X₃.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction (a ≫ b)).unit.app N
      = ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app N ≫
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
              ((Scheme.Modules.pullback b).obj N)) ≫
          (Scheme.Modules.pushforwardComp a b).hom.app
            ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback b).obj N))) ≫
        (Scheme.Modules.pushforward (a ≫ b)).map
          ((Scheme.Modules.pullbackComp a b).hom.app N) := by
  rw [pullbackPushforward_unit_comp a b N]
  -- The two trailing `(a ≫ b)_*`-images cancel (`pullbackComp.inv ≫ pullbackComp.hom = 𝟙`), but a
  -- spurious `X.Modules` instance diamond under single-file elaboration makes `rw [Category.assoc]`
  -- / `rw [hI]` / `simp only [Iso.inv_hom_id_app]` misfire on the goal's locked composition. We
  -- prove the cancellation on FRESH terms (where the rewrites match) and discharge the goal in
  -- term mode (`exact`), which checks defeq and tolerates the diamond.
  have hI : (Scheme.Modules.pushforward (a ≫ b)).map ((Scheme.Modules.pullbackComp a b).inv.app N) ≫
        (Scheme.Modules.pushforward (a ≫ b)).map ((Scheme.Modules.pullbackComp a b).hom.app N)
      = 𝟙 _ := by
    rw [← Functor.map_comp, Iso.inv_hom_id_app, CategoryTheory.Functor.map_id]
  have hfin := (congrArg (fun z =>
      (Scheme.Modules.pullbackPushforwardAdjunction (a ≫ b)).unit.app N ≫ z) hI).trans
    (Category.comp_id _)
  exact ((Category.assoc _ _ _).trans hfin).symm

/-- **(iii-2) Distribute the expansion through a functor (e.g. `(Spec φ)_* ⋙ Γ`).** Applying any
functor `F` out of `X₃.Modules` to the `unitExpand` four-factor expansion of the `(a ≫ b)`-unit
distributes over the four factors, by functoriality (`F (u ≫ v) = F u ≫ F v`). In the assembly `F`
is `(Spec φ)_* ⋙ Γ_R`, giving the four `Γ`-image factors of the blueprint. See blueprint
`lem:base_change_mate_fstar_reindex_legs_gammaDistribute`. -/
theorem base_change_mate_fstar_reindex_legs_gammaDistribute {X₁ X₂ X₃ : Scheme.{u}}
    {D : Type*} [Category D] (a : X₁ ⟶ X₂) (b : X₂ ⟶ X₃) (N : X₃.Modules)
    (F : X₃.Modules ⥤ D) :
    F.map ((Scheme.Modules.pullbackPushforwardAdjunction (a ≫ b)).unit.app N)
      = (F.map ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app N) ≫
          F.map ((Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
              ((Scheme.Modules.pullback b).obj N))) ≫
          F.map ((Scheme.Modules.pushforwardComp a b).hom.app
            ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback b).obj N)))) ≫
        F.map ((Scheme.Modules.pushforward (a ≫ b)).map
          ((Scheme.Modules.pullbackComp a b).hom.app N)) := by
  -- After `unitExpand` the goal is pure functoriality (`F (u ≫ v) = F u ≫ F v`), but the
  -- `X.Modules` instance diamond blocks `rw/simp [Functor.map_comp]`; we apply `F.map_comp` in term
  -- mode (elaboration unifies the instances up to defeq).
  rw [base_change_mate_fstar_reindex_legs_unitExpand a b N]
  exact (F.map_comp _ _).trans (congrArg (· ≫ F.map _)
    ((F.map_comp _ _).trans (congrArg (F.map _ ≫ ·) (F.map_comp _ _))))

-- The post-`subst` unit expansion (`erw [unitExpand]`) plus the four-factor Γ-distribution and the
-- eCancel telescoping against the codomain read run a large amount of `whnf` during defeq matching.
set_option maxHeartbeats 4000000 in
/-- **(Seam 2, steps i+iii) Abstract variable-legs reindex.** The Seam-2 identity restated for
*generic* legs `g' f'` (of the pullback square) carrying the cone-leg equalities `hfst`/`hsnd` and
the square's commutativity `comm` as explicit hypotheses, with the codomain read replaced by the
variable-legs version `base_change_mate_codomain_read_legs`. Because the legs are now free
variables, `subst hfst; subst hsnd` rewrites them to `e ≫ Spec ιA` / `e ≫ Spec ιR'` on a
well-typed motive (dissolving the `motive is not type correct` wall), reducing the goal to the
affine model where the leg-reindex engine `pullbackPushforward_unit_comp` (step iii) and the
Γ-collapse lemmas (step ii) apply. The concrete `base_change_mate_fstar_reindex` is the
instantiation at `g' = pullback.fst`, `f' = pullback.snd`. -/
theorem base_change_mate_fstar_reindex_legs {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    ∀ (g' : Limits.pullback (Spec.map φ) (Spec.map ψ) ⟶ Spec A)
      (f' : Limits.pullback (Spec.map φ) (Spec.map ψ) ⟶ Spec R')
      (hfst : g' = (pullbackSpecIso (R := (R : Type u)) (S := (A : Type u))
            (T := (R' : Type u))).hom ≫
          Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
            (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))))
      (hsnd : f' = (pullbackSpecIso (R := (R : Type u)) (S := (A : Type u))
            (T := (R' : Type u))).hom ≫
          Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeRight
            (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom))
      (comm : g' ≫ Spec.map φ = f' ≫ Spec.map ψ),
    (gammaPushforwardTildeIso φ M).inv ≫
      (moduleSpecΓFunctor (R := R)).map
        ((Scheme.Modules.pushforward (Spec.map φ)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction g').unit.app (tilde M)) ≫
          (Scheme.Modules.pushforwardComp g' (Spec.map φ)).hom.app _ ≫
          (Scheme.Modules.pushforwardCongr comm).hom.app _ ≫
          (Scheme.Modules.pushforwardComp f' (Spec.map ψ)).inv.app _) ≫
      (gammaPushforwardIso ψ
            ((Scheme.Modules.pushforward f').obj
              ((Scheme.Modules.pullback g').obj (tilde M))) ≪≫
          (ModuleCat.restrictScalars ψ.hom).mapIso
            (base_change_mate_codomain_read_legs ψ φ M g' f' hfst hsnd)).hom
      = base_change_mate_inner_value ψ φ M := by
  letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
  letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
  intro g' f' hfst hsnd comm
  -- (i) The legs are free variables; substitute their defining equations on a well-typed motive.
  subst hfst
  subst hsnd
  -- (ii) Expose the four Γ-image factors and collapse the transparent coherences.
  rw [Functor.map_comp, Functor.map_comp, Functor.map_comp]
  -- NOTE: the `pushforwardComp.inv` and `pushforwardCongr` coherences collapse here; the
  -- `pushforwardComp.hom` factor (`gammaMap_pushforwardComp_hom_eq_id`) does not fire under `simp`
  -- in this position (discrimination-tree miss on the composed-functor source object) — it collapses
  -- inside the step-(iii) mate-unwinding once the unit factor is rewritten by `key`.
  simp only [gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom]
  set e := pullbackSpecIso (R := (R : Type u)) (S := (A : Type u)) (T := (R' : Type u)) with he
  set inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))) with hinclA
  set inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeRight
    (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom with hinclR'
  -- (iii) Reduce the surviving unit factor to its four-factor reindex form.
  -- LITERAL-FORM LOCK BROKEN (iter-026): after `subst`, the goal's unit leg is the literal
  -- `(pullbackSpecIso ↑R ↑A ↑R').hom ≫ Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom)`,
  -- which is DEFEQ to `e.hom ≫ Spec.map inclA` but differs in invisible implicit arguments, so plain
  -- `rw [base_change_mate_fstar_reindex_legs_unitExpand …]` reports "did not find pattern" (the 4-iter
  -- wall, memory `fbc-subst-legs-literal-form-lock`; re-verified this iter with no-arg, `set`-fvar,
  -- exact-literal, and `▸`/`simp only` variants — ALL fail). The fix is `erw`, whose DEFEQ matching sees
  -- through the implicit-arg divergence and fires cleanly. This expands the bare `(g')`-unit into
  --   (η^{Spec ιA} ≫ (Spec ιA)_*(η^e) ≫ pushforwardComp(e,Spec ιA).hom) ≫ g'_*(pullbackComp(e,Spec ιA).hom).
  erw [base_change_mate_fstar_reindex_legs_unitExpand e.hom (Spec.map inclA) (tilde M)]
  -- REMAINING CRUX (the genuine ~100-LOC `eCancel` telescoping, now UNBLOCKED). The next step is to
  -- distribute the now-expanded four factors through `(Spec φ)_*` and then `Γ = moduleSpecΓFunctor`.
  -- NOTE (iter-026, verified): `simp only [Functor.map_comp]` / `rw [Functor.map_comp]` make NO
  -- progress on `(Spec φ)_*.map((a≫b≫c)≫d)` here — the `X.Modules` `CategoryStruct.comp` instance
  -- diamond blocks the keyed match (the SAME diamond that forced `base_change_mate_fstar_reindex_legs_`
  -- `gammaDistribute` to be proven in TERM mode). So the distribution must go through that term-mode
  -- lemma (or a `Functor.map_comp` applied in term mode), NOT a `simp`/`rw`. After distribution the four
  -- Γ-factors are, in order: `Γ((Spec φ)_*(η^{Spec ιA}))`, `Γ((Spec φ)_*((Spec ιA)_*(η^e)))`,
  -- `Γ((Spec φ)_*(pushforwardComp(e,Spec ιA).hom))`, `Γ((Spec φ)_*(g'_*(pullbackComp(e,Spec ιA).hom)))`.
  -- The three PROVED atoms cancel three of them against the `e`-pieces baked into the codomain read
  -- `base_change_mate_codomain_read_legs` (which must be UNFOLDED to expose `iso_g =
  -- pullbackCongr(hfst) ≫ pullbackComp(e,inclA).symm`, `unit_iso.symm = (asIso η^e).symm`, and
  -- `pushforwardComp(e,inclR').symm`):
  --   • `base_change_mate_inner_eCancel_pushforwardComp e.hom (Spec.map inclA) φ (tilde M)` — factor 3
  --     has identity Γ-image and drops;
  --   • `base_change_mate_inner_eCancel_eUnit e.hom ((Scheme.Modules.pullback (Spec.map inclA)).obj
  --     (tilde M))` — factor 2's `η^e` is an iso, cancels `unit_iso.symm`;
  --   • `base_change_mate_inner_eCancel_pullbackComp ψ φ M` — factor 4's `pullbackComp.hom` cancels
  --     `iso_g`'s `pullbackComp.symm`.
  -- The lone survivor `Γ((Spec φ)_*(η^{Spec ιA}))`, read through the affine tilde/Γ dictionaries, is
  -- Seam 1 `base_change_mate_unit_value`; the `inclA∘φ = inclR'∘ψ` ring-equation transport then lands on
  -- `base_change_mate_inner_value`. The adjacency bookkeeping (reassociating each atom's two factors to
  -- be composable against the unfolded codomain read) is the residual; the `erw` unlock above is the
  -- step that 4 prior iters could not pass.
  -- STEP 1 (the surviving `pushforwardComp(g', Spec φ).hom` collapse) is the entry to the eCancel
  -- telescoping. The collapse fact IS available and cheaply provable as `hpfc` below
  -- (`gammaMap_pushforwardComp_hom_eq_id` — unification only assigns the leg metavariables), but it
  -- CANNOT be applied in place: `rw [hpfc]` / `simp only [hpfc]` both report "no occurrence / no
  -- progress", and `erw [gammaMap_pushforwardComp_hom_eq_id]` times out at `whnf`. The obstruction is
  -- the `X.Modules` instance diamond: the lemma's section term lives over the COMPOSED functor
  -- `pushforward (LEG) ⋙ pushforward (Spec φ)` (its `.hom.app` domain), whereas the goal's matching
  -- factor — produced by the `rw [Functor.map_comp]` split at step (ii) — carries the NESTED-`obj`
  -- form of that same object; the two are defeq but not syntactically equal, so `rw`/`simp` cannot
  -- abstract the motive and `erw`'s defeq search is unbudgetable. The same diamond will recur at each
  -- of the three atom cancellations (`_eUnit`/`_pushforwardComp`/`_pullbackComp`) against the
  -- unfolded `base_change_mate_codomain_read_legs`. The viable route is term-mode congruence surgery
  -- (the file's `congrArg`/`Functor.map_comp` pattern, cf. `unitExpand`/`gammaDistribute`) carried
  -- through the whole composite, OR a mathlib-analogist consult on a diamond-robust telescoping —
  -- per the iter-028 escalation tripwire (NOT a 3rd helper round). The collapse fact is recorded so
  -- the next pass can build on it.
  have hpfc :
      (moduleSpecΓFunctor (R := R)).map
        ((Scheme.Modules.pushforwardComp
            ((pullbackSpecIso (R := (R : Type u)) (S := (A : Type u)) (T := (R' : Type u))).hom ≫
              Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
                (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))))
            (Spec.map φ)).hom.app
          ((Scheme.Modules.pullback
              ((pullbackSpecIso (R := (R : Type u)) (S := (A : Type u)) (T := (R' : Type u))).hom ≫
                Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
                  (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))))).obj
            (tilde M)))
        = 𝟙 _ :=
    gammaMap_pushforwardComp_hom_eq_id _ _ _
  sorry

-- The `exact`-onto-`…_legs` reduction unfolds two large change-of-rings dictionaries and certifies
-- a proof-irrelevant defeq between the concrete and variable-legs codomain reads.
set_option maxHeartbeats 1600000 in
/-- **Seam 2: the pushforward pseudofunctor reindex of the inner comparison.** In the generic
pullback square with legs `g' = pullback.fst`, `f' = pullback.snd`, write `θ_in` for the inner
composite built from the `(g')`-unit and the three pushforward pseudofunctor coherences
(`pushforwardComp` twice, `pushforwardCongr` once) that appear inside `pushforwardBaseChangeMap`
before the `(g^* ⊣ g_*)`-transpose. Read on global sections over `Spec R` through the
`Γ`-pushforward dictionaries (`gammaPushforwardTildeIso` / `gammaPushforwardIso`), with the
codomain pinned by `base_change_mate_codomain_read`, the map `θ_in` is the canonical `R`-linear map
`ρ : m ↦ (1 ⊗ 1) ⊗ m` (`base_change_mate_inner_value`), i.e. `restrictScalars ψ` of the
codomain-read transport of Seam 1's unit value. See blueprint `lem:base_change_mate_fstar_reindex`. -/
theorem base_change_mate_fstar_reindex {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (gammaPushforwardTildeIso φ M).inv ≫
      (moduleSpecΓFunctor (R := R)).map
        ((Scheme.Modules.pushforward (Spec.map φ)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
                (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).unit.app (tilde M)) ≫
          (Scheme.Modules.pushforwardComp
              (Limits.pullback.fst (Spec.map φ) (Spec.map ψ)) (Spec.map φ)).hom.app _ ≫
          (Scheme.Modules.pushforwardCongr
              (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w).hom.app _ ≫
          (Scheme.Modules.pushforwardComp
              (Limits.pullback.snd (Spec.map φ) (Spec.map ψ)) (Spec.map ψ)).inv.app _) ≫
      (gammaPushforwardIso ψ
            ((Scheme.Modules.pushforward (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))).obj
              ((Scheme.Modules.pullback (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).obj
                (tilde M))) ≪≫
          (ModuleCat.restrictScalars ψ.hom).mapIso (base_change_mate_codomain_read ψ φ M)).hom
      = base_change_mate_inner_value ψ φ M := by
  -- STRUCTURE (iter-017): the dependent-type ("motive is not type correct") wall that blocked
  -- iters 014–016 is now dissolved by the blueprint step-(i) device: the abstract variable-legs
  -- reindex `base_change_mate_fstar_reindex_legs`, where the legs `g' f'` are FREE variables so
  -- `subst hfst; subst hsnd` acts on a well-typed motive. That lemma also performs step (ii) (the
  -- Γ-collapse of the `pushforwardCongr`/`pushforwardComp` coherences via
  -- `gammaMap_pushforwardComp_*`/`gammaMap_pushforwardCongr_hom`) and stages step (iii) (the
  -- `pullbackPushforward_unit_comp` leg-reindex engine), leaving only the mate-unwinding crux.
  -- This concrete theorem is the instantiation at `g' = pullback.fst`, `f' = pullback.snd`.
  --
  -- Instantiate the abstract variable-legs reindex at `g' = pullback.fst`, `f' = pullback.snd`.
  -- Since `base_change_mate_codomain_read` now uses `.1`/`.2` (no stuck `And.casesOn`), the goal's
  -- codomain read is definitionally `base_change_mate_codomain_read_legs … hfst hsnd` (proof
  -- irrelevance on the leg-equality arguments), so `exact` closes the goal modulo the step-(iii)
  -- mate-unwinding crux carried by `base_change_mate_fstar_reindex_legs`.
  letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
  letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
  set e := pullbackSpecIso (R := (R : Type u)) (S := (A : Type u)) (T := (R' : Type u)) with he
  set inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))) with hinclA
  set inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeRight
    (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom with hinclR'
  have hfst : Limits.pullback.fst (Spec.map φ) (Spec.map ψ) = e.hom ≫ Spec.map inclA :=
    (Iso.inv_comp_eq e).mp (pullback_fst_snd_specMap_tensor ψ φ).1
  have hsnd : Limits.pullback.snd (Spec.map φ) (Spec.map ψ) = e.hom ≫ Spec.map inclR' :=
    (Iso.inv_comp_eq e).mp (pullback_fst_snd_specMap_tensor ψ φ).2
  exact base_change_mate_fstar_reindex_legs ψ φ M _ _ hfst hsnd
    (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w

/-! ### Seam 3, the gstar chain (effort-breaker `fbc-gstar`): five `\uses`-linked links

The `(g^* ⊣ g_*)`-transpose crux `base_change_mate_gstar_transpose` needs the inner pushforward
comparison `θ_in`, read on `Spec R` sections, to equal `ρ : m ↦ (1 ⊗ 1) ⊗ m`
(`base_change_mate_inner_value`). The chain cuts the ~150-LOC monolith into:
  • Seam A : `inner_unitReduce` (distribute) → `inner_eCancel` (cancel) → `inner_value_eq` (assemble);
  • Seam B : `gstar_generator_close` (the algebraic generator close); and
  • Seam C : `gstar_counit_transport` (the geometric→algebraic counit transport).
See blueprint `lem:base_change_mate_inner_unitReduce/_inner_eCancel/_inner_value_eq/`
`_gstar_generator_close/_gstar_counit_transport`. -/

/-- **(A-2a) The `e`-unit is an isomorphism.** For an isomorphism of schemes `e : X ⟶ Y` and a
`Y`-module `N`, the unit `η^e_N : N → e_* e^* N` of the `(e^* ⊣ e_*)`-adjunction is an isomorphism:
the left adjoint `pullback e` is an equivalence (`pullback_isEquivalence_of_iso`), and the unit of an
adjunction whose left adjoint is an equivalence is an iso. Cancellation (1) of the eCancel
telescoping. See blueprint `lem:base_change_mate_inner_eCancel_eUnit`. -/
theorem base_change_mate_inner_eCancel_eUnit {X Y : Scheme.{u}} (e : X ⟶ Y) [IsIso e]
    (N : Y.Modules) :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction e).unit.app N) := by
  haveI := pullback_isEquivalence_of_iso e
  infer_instance

/-- **(A-2b) The surviving `pushforwardComp` factor has identity `Γ`-image.** For composable scheme
morphisms `a : X₁ ⟶ X₂`, `b : X₂ ⟶ Spec A`, a ring map `φ : R ⟶ A`, and a module `M` on `X₁`, the
`Γ`-image over `Spec R` of the `(Spec φ)_*`-image of the `pushforwardComp a b` hom-coherence is the
identity. Cancellation (2) of the eCancel telescoping; the `(Spec φ)_*`-lifted form of
`gammaMap_pushforwardComp_hom_eq_id`. See blueprint
`lem:base_change_mate_inner_eCancel_pushforwardComp`. -/
theorem base_change_mate_inner_eCancel_pushforwardComp {X₁ X₂ : Scheme.{u}}
    {R A : CommRingCat.{u}} (a : X₁ ⟶ X₂) (b : X₂ ⟶ Spec A) (φ : R ⟶ A) (M : X₁.Modules) :
    (moduleSpecΓFunctor (R := R)).map
        ((Scheme.Modules.pushforward (Spec.map φ)).map
          ((Scheme.Modules.pushforwardComp a b).hom.app M))
      = 𝟙 _ := by
  have h : (Scheme.Modules.pushforwardComp a b).hom.app M = 𝟙 _ := rfl
  rw [h]
  exact ((moduleSpecΓFunctor (R := R)).congr_map
      ((Scheme.Modules.pushforward (Spec.map φ)).map_id _)).trans
    ((moduleSpecΓFunctor (R := R)).map_id _)

/-- **(A-2c) The `pullbackComp` factor cancels its inverse in the codomain read.** In the concrete
pullback square, with `e = pullbackSpecIso` the canonical isomorphism and `inclA` the left tensor
inclusion, the hom and inverse of the pseudofunctor coherence `pullbackComp e.hom (Spec.map inclA)`
on `tilde M` compose to the identity. Cancellation (3) of the eCancel telescoping. See blueprint
`lem:base_change_mate_inner_eCancel_pullbackComp`. -/
theorem base_change_mate_inner_eCancel_pullbackComp {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    let e := pullbackSpecIso (R := (R : Type u)) (S := (A : Type u)) (T := (R' : Type u))
    let inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
      (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))
    (Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).hom.app (tilde M) ≫
        (Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).inv.app (tilde M)
      = 𝟙 _ := by
  exact (Scheme.Modules.pullbackComp _ _).hom_inv_id_app (tilde M)

/-- **(B) Generator close: the base change of `ρ` is the inverse regrouping.** The extension of
scalars along `ψ` of the inner value `ρ = base_change_mate_inner_value` (`m ↦ (1 ⊗ 1) ⊗ m`),
post-composed with the algebraic counit `ε^alg` of the `(extendScalars ψ ⊣ restrictScalars ψ)`
adjunction, equals the inverse regrouping isomorphism `base_change_mate_regroupEquiv`: both are
`R'`-linear maps `R' ⊗_R M → (A ⊗_R R') ⊗_A M` sending the generator `r' ⊗ m ↦ (1 ⊗ r') ⊗ m`. See
blueprint `lem:base_change_mate_gstar_generator_close`. -/
theorem base_change_mate_gstar_generator_close {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
    letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
    let inclA := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
      (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u)))
    let inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeRight
      (R := (R : Type u)) (A := (A : Type u)) (B := (R' : Type u))).toRingHom
    (ModuleCat.extendScalars ψ.hom).map (base_change_mate_inner_value ψ φ M) ≫
        (ModuleCat.extendRestrictScalarsAdj ψ.hom).counit.app
          ((ModuleCat.restrictScalars inclR'.hom).obj ((ModuleCat.extendScalars inclA.hom).obj M))
      = (base_change_mate_regroupEquiv ψ φ M).inv := by
  letI : Algebra (R : Type u) (A : Type u) := φ.hom.toAlgebra
  letI : Algebra (R : Type u) (R' : Type u) := ψ.hom.toAlgebra
  intro inclA inclR'
  -- Both sides are `R'`-linear maps `R' ⊗_R M → (A ⊗_R R') ⊗_A M`; by `ext` it suffices to check on
  -- the generator `1 ⊗ₜ x`. The algebraic counit `ε^alg` cancels the leading `extendScalars ψ`
  -- against the `1 ⊗ₜ`, reducing the LHS to the inner value `ρ(x) = base_change_mate_inner_value`.
  ext x
  rw [ModuleCat.comp_apply]
  erw [ModuleCat.ExtendRestrictScalarsAdj.Counit.map_apply_one_tmul]
  change (ModuleCat.Hom.hom (base_change_mate_inner_value ψ φ M)) x = _
  -- RESIDUAL (pure tensor computation, no categorical content): `ρ(x) = regroupEquiv.inv (1 ⊗ₜ x)`.
  -- Both sides reduce, by `rfl`, to `(1 : A ⊗_R R') ⊗ₜ[A] x`: the transports in
  -- `base_change_mate_inner_value` are identity on carriers and the buried
  -- `extendRestrictScalarsAdj inclA`-unit sends `x ↦ (1 : A⊗R') ⊗ₜ x`; on the other side,
  -- `regroupEquiv.inv (1 ⊗ₜ x)` unfolds (`comm`/`cancelBaseChange`/`congr`) to the same generator.
  rfl

/-- **(A) The inner comparison reads as `ρ` on `Spec R` sections.** In the concrete pullback square
(`g' = pr₁`, `f' = pr₂`), the inner composite `θ_in` (the `(g')`-unit followed by the pushforward
pseudofunctor coherences), read on global sections over `Spec R` through the Γ-pushforward
dictionaries with the codomain pinned by `base_change_mate_codomain_read`, equals the canonical
`R`-linear map `ρ : m ↦ (1 ⊗ 1) ⊗ m` (`base_change_mate_inner_value`). This is the
"`X' = Spec(R' ⊗_R A)`, `F'` is `(R' ⊗_R A) ⊗_A M`" bookkeeping of the source. It is Seam A,
realised THROUGH the leg-parametrised `base_change_mate_fstar_reindex` /
`base_change_mate_fstar_reindex_legs` (the inline pre-subst route at the literal projection leg is
walled by a dependent-motive obstruction; see the proof). See blueprint
`lem:base_change_mate_inner_value_eq`. -/
theorem base_change_mate_inner_value_eq {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (gammaPushforwardTildeIso φ M).inv ≫
      (moduleSpecΓFunctor (R := R)).map
        ((Scheme.Modules.pushforward (Spec.map φ)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
                (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).unit.app (tilde M)) ≫
          (Scheme.Modules.pushforwardComp
              (Limits.pullback.fst (Spec.map φ) (Spec.map ψ)) (Spec.map φ)).hom.app _ ≫
          (Scheme.Modules.pushforwardCongr
              (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w).hom.app _ ≫
          (Scheme.Modules.pushforwardComp
              (Limits.pullback.snd (Spec.map φ) (Spec.map ψ)) (Spec.map ψ)).inv.app _) ≫
      (gammaPushforwardIso ψ
            ((Scheme.Modules.pushforward (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))).obj
              ((Scheme.Modules.pullback (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).obj
                (tilde M))) ≪≫
          (ModuleCat.restrictScalars ψ.hom).mapIso (base_change_mate_codomain_read ψ φ M)).hom
      = base_change_mate_inner_value ψ φ M := by
  -- CASCADE (iter-028): this theorem has the SAME statement as `base_change_mate_fstar_reindex`
  -- (the concrete-legs Seam-2 reindex), which is realised THROUGH the leg-parametrised
  -- `base_change_mate_fstar_reindex_legs` (post-`subst`, where the leg is DEFINITIONALLY
  -- `e.hom ≫ Spec ιA`). The earlier INLINE pre-subst route — distributing the bare `(g')`-unit at the
  -- literal projection leg `pullback.fst` — is WALLED by the dependent-motive obstruction (`pullback.fst`
  -- is only propositionally, not definitionally, equal to `e.hom ≫ Spec ιA`, and it is threaded through
  -- the dependent codomain-read argument). So Seam A is discharged via the `_legs` engine, not inline:
  exact base_change_mate_fstar_reindex ψ φ M

/-- **(C) The geometric counit, conjugated by the dictionaries, is the algebraic counit.** For
`g = Spec ψ` and any `W : (Spec R').Modules`, the geometric `(g^* ⊣ g_*)`-counit `ε_g`, conjugated
by the pullback dictionary `pullback_spec_tilde_iso ψ` and the tilde–Γ counit on either side, equals
the algebraic extend/restrict-scalars counit `ε^alg` along `ψ`. This is the counit dual of Seam 1's
`unit_conjugateEquiv_symm` coherence; it is obtained by instantiating
`CategoryTheory.conjugateEquiv_counit_symm` at the two composed adjunctions
`adjL = (tilde ⊣ Γ)_R . (g^* ⊣ g_*)` and `adjR = (extend ⊣ restrict)_ψ . (tilde ⊣ Γ)_{R'}`, with
right-adjoint comparison `β = gammaPushforwardNatIso ψ` (whose conjugate is `pullback_spec_tilde_iso`,
`hpullinv`), and splitting each composite counit into its tilde–Γ and geometric/algebraic factors. See
blueprint `lem:base_change_mate_gstar_counit_transport`. -/
theorem base_change_mate_gstar_counit_transport {R R' : CommRingCat.{u}}
    (ψ : R ⟶ R') (W : (Spec R').Modules) :
    (ModuleCat.extendScalars ψ.hom ⋙ tilde.functor R').map
          ((gammaPushforwardNatIso ψ).hom.app W) ≫
        (tilde.functor R').map
            ((ModuleCat.extendRestrictScalarsAdj ψ.hom).counit.app
              ((moduleSpecΓFunctor (R := R')).obj W)) ≫
          (tilde.adjunction (R := R')).counit.app W
      = (pullback_spec_tilde_iso ψ
            ((Scheme.Modules.pushforward (Spec.map ψ) ⋙ moduleSpecΓFunctor).obj W)).inv ≫
          (Scheme.Modules.pullback (Spec.map ψ)).map
              ((tilde.adjunction (R := R)).counit.app
                ((Scheme.Modules.pushforward (Spec.map ψ)).obj W)) ≫
            (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map ψ)).counit.app W := by
  -- Lifted verbatim from the landed `huce` scaffold in `base_change_mate_gstar_transpose`.
  set adjL := (tilde.adjunction (R := R)).comp
    (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map ψ)) with hadjL
  set adjR := (ModuleCat.extendRestrictScalarsAdj ψ.hom).comp
    (tilde.adjunction (R := R')) with hadjR
  set β := gammaPushforwardNatIso ψ with hβ
  have hpullinv : ∀ (N : ModuleCat.{u} R),
      ((conjugateEquiv adjL adjR).symm β.hom).app N = (pullback_spec_tilde_iso ψ N).inv := by
    intro N; rw [hβ]; rfl
  have huce := CategoryTheory.conjugateEquiv_counit_symm adjL adjR β.hom W
  rw [hpullinv] at huce
  have hcounitL : adjL.counit.app W
      = (Scheme.Modules.pullback (Spec.map ψ)).map
          ((tilde.adjunction (R := R)).counit.app
            ((Scheme.Modules.pushforward (Spec.map ψ)).obj W))
        ≫ (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map ψ)).counit.app W := by
    rw [hadjL, Adjunction.comp_counit_app]
  have hcounitR : adjR.counit.app W
      = (tilde.functor R').map
          ((ModuleCat.extendRestrictScalarsAdj ψ.hom).counit.app
            ((moduleSpecΓFunctor (R := R')).obj W))
        ≫ (tilde.adjunction (R := R')).counit.app W := by
    rw [hadjR, Adjunction.comp_counit_app]
  rw [hcounitL, hcounitR] at huce
  exact huce

/-- **Seam 3: the `(g^* ⊣ g_*)` transpose of the comparison on sections.** By the counit formula
for the `(g^* ⊣ g_*)`-adjunction (`g = Spec ψ`; Mathlib's `Adjunction.homEquiv_counit`),
`pushforwardBaseChangeMap` factors as `g^*(inner)` followed by the counit, with no opaque
adjunction transpose remaining. On the global sections over `Spec R'`, conjugated by the domain
read `Θ_src` and codomain read `Θ_tgt`, this transpose is the extension of scalars along
`ψ : R → R'` of the `Spec R`-section reading `ρ` of `inner` (Seam 2); on the generator `r' ⊗ m`
it returns `(1 ⊗ r') ⊗ m`, exactly the inverse of the regrouping isomorphism
`base_change_mate_regroupEquiv`. See blueprint `lem:base_change_mate_gstar_transpose`. -/
theorem base_change_mate_gstar_transpose {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (base_change_mate_domain_read ψ φ M).inv ≫
      (moduleSpecΓFunctor (R := R')).map
        ((Scheme.Modules.pullback (Spec.map ψ)).map
            ((Scheme.Modules.pushforward (Spec.map φ)).map
                ((Scheme.Modules.pullbackPushforwardAdjunction
                    (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).unit.app (tilde M)) ≫
              (Scheme.Modules.pushforwardComp
                  (Limits.pullback.fst (Spec.map φ) (Spec.map ψ)) (Spec.map φ)).hom.app _ ≫
              (Scheme.Modules.pushforwardCongr
                  (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w).hom.app _ ≫
              (Scheme.Modules.pushforwardComp
                  (Limits.pullback.snd (Spec.map φ) (Spec.map ψ)) (Spec.map ψ)).inv.app _) ≫
          (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map ψ)).counit.app
            ((Scheme.Modules.pushforward (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))).obj
              ((Scheme.Modules.pullback (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).obj
                (tilde M)))) ≫
      (base_change_mate_codomain_read ψ φ M).hom
      = (base_change_mate_regroupEquiv ψ φ M).inv := by
  -- PARTIAL: split `Γ(g^*(inner) ≫ ε_g) = Γ(g^*(inner)) ≫ Γ(ε_g)` by functoriality of
  -- `moduleSpecΓFunctor`. After this the goal is
  --   `Θ_src⁻¹ ≫ (Γ(g^*(inner)) ≫ Γ(ε_g)) ≫ Θ_tgt = regroupEquiv.inv`.
  rw [Functor.map_comp]
  -- ISOLATE the geometric factor. Move the domain read `Θ_src`, the regrouping iso, and the
  -- codomain read `Θ_tgt` to the RHS, leaving on the LHS exactly the two geometric `Γ`-factors
  -- `Γ_{R'}(g^*(θ_in)) ≫ Γ_{R'}(ε_g)`. After this the goal is
  --   `Γ_{R'}(g^*(θ_in)) ≫ Γ_{R'}(ε_g) = (Θ_src.hom ≫ regroupEquiv.inv) ≫ Θ_tgt.inv`,
  -- which is the precise shape the counit-conjugate calculus below consumes (the `g^*`-leg and the
  -- counit `ε_g` together on the left, the algebraic target on the right).
  rw [Iso.inv_comp_eq, ← Iso.eq_comp_inv]
  -- RESIDUAL (the genuine crux — the `(g^* ⊣ g_*)` counit-conjugate coherence). This is the DUAL
  -- of the proven Seam 1 `base_change_mate_unit_value`, which closed the analogous *unit* coherence
  -- via `CategoryTheory.unit_conjugateEquiv_symm`. The counit companion for this route is
  -- `CategoryTheory.conjugateEquiv_counit_symm`:
  --     L₂.map (α.app _) ≫ adj₂.counit.app d
  --       = ((conjugateEquiv adj₁ adj₂).symm α).app _ ≫ adj₁.counit.app d,
  -- instantiated — exactly mirroring the construction of `pullback_spec_tilde_iso ψ` — at
  --     adjL = (tilde.adjunction R).comp (pullbackPushforwardAdjunction (Spec.map ψ))   -- left adj
  --     adjR = (ModuleCat.extendRestrictScalarsAdj ψ.hom).comp (tilde.adjunction R')    -- left adj
  --     α    = gammaPushforwardNatIso ψ,
  -- so that `(conjugateEquiv adjL adjR).symm α = pullback_spec_tilde_iso ψ` (the ψ-dictionary that
  -- `Θ_src`/`Θ_tgt` already bake in). Applying it rewrites the geometric counit `ε_g`, conjugated
  -- by the tilde dictionaries, to the ALGEBRAIC extend/restrict-scalars counit along `ψ`. Two pieces
  -- then remain to assemble (this is why the seam bundles strictly more than Seam 1):
  --   (a) the inner reindex of `θ_in` read over `Spec R`: `Γ_R(θ_in)` is the canonical
  --       `ρ : m ↦ (1 ⊗ 1) ⊗ m` (= `base_change_mate_inner_value`). NOTE the existing Seam-2 lemma
  --       `base_change_mate_fstar_reindex` asserts exactly this but is currently sorry-backed (its
  --       `…_legs` apparatus carries a dead `sorry`), so this content must be REPROVEN INLINE here,
  --       not cited — otherwise the result is not axiom-clean. The buried `(g')`-unit value inside
  --       `θ_in` is Seam 1 `base_change_mate_unit_value` (proved, axiom-clean).
  --   (b) `extendScalars ψ (ρ)` post-composed with the algebraic counit equals `regroupEquiv.inv`
  --       on the generator `r' ⊗ m ↦ (1 ⊗ r') ⊗ m` (both `R'`-linear; a one-generator `ext`
  --       against `base_change_mate_regroupEquiv`, whose value `cancelBaseChange_tmul` is already
  --       unfolded in that def).
  -- The per-generator route is a dead end: `ext x` reduces the goal to the full opaque geometric
  -- composite applied to `1 ⊗ₜ x`, which neither `rfl` nor `simp` can evaluate (the geometric
  -- counit/pullback/Γ have no element-level normal form) — the abstract conjugate calculus above is
  -- the only tractable route. Uses: `conjugateEquiv_counit_symm`, `pullback_spec_tilde_iso` (ψ),
  -- `base_change_mate_unit_value` (Seam 1), `base_change_mate_regroupEquiv`.
  -- See blueprint `lem:base_change_mate_gstar_transpose`.
  -- SCAFFOLD (iter-022): the conjugate-counit calculus, dual to Seam 1's unit calculus.
  set adjL := (tilde.adjunction (R := R)).comp
    (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map ψ)) with hadjL
  set adjR := (ModuleCat.extendRestrictScalarsAdj ψ.hom).comp
    (tilde.adjunction (R := R')) with hadjR
  set β := gammaPushforwardNatIso ψ with hβ
  -- The conjugate of `β.hom` (the right-adjoint comparison) is, at every base module `N`, the
  -- inverse of the pullback dictionary `pullback_spec_tilde_iso ψ` (the dual of Seam 1's `hpullinv`).
  have hpullinv : ∀ (N : ModuleCat.{u} R),
      ((conjugateEquiv adjL adjR).symm β.hom).app N
        = (pullback_spec_tilde_iso ψ N).inv := by
    intro N; rw [hβ]; rfl
  -- The counit object `W = g_*(g'^*(tilde M))` carrying the geometric counit `ε_g` in the goal.
  set W := (Scheme.Modules.pushforward (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))).obj
      ((Scheme.Modules.pullback (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))).obj (tilde M))
    with hW
  -- The conjugate-counit coherence (dual of Seam 1's `huce`): transports the geometric counit of
  -- `adjL` across the conjugate to the algebraic counit of `adjR`, with the `pullback_spec_tilde_iso`
  -- dictionary appearing via `hpullinv`.
  have huce := CategoryTheory.conjugateEquiv_counit_symm adjL adjR β.hom W
  rw [hpullinv] at huce
  -- Split `adjL.counit` into the tilde counit and the geometric `ε_g` (the factor in the goal).
  have hcounitL : adjL.counit.app W
      = (Scheme.Modules.pullback (Spec.map ψ)).map
          ((tilde.adjunction (R := R)).counit.app
            ((Scheme.Modules.pushforward (Spec.map ψ)).obj W))
        ≫ (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map ψ)).counit.app W := by
    rw [hadjL, Adjunction.comp_counit_app]
  -- Split `adjR.counit` into the tilde counit and the algebraic extend/restrict counit.
  have hcounitR : adjR.counit.app W
      = (tilde.functor R').map
          ((ModuleCat.extendRestrictScalarsAdj ψ.hom).counit.app
            ((moduleSpecΓFunctor (R := R')).obj W))
        ≫ (tilde.adjunction (R := R')).counit.app W := by
    rw [hadjR, Adjunction.comp_counit_app]
  -- Fuse the two splits into `huce` to obtain the master counit-transport identity: the geometric
  -- `ε_g` (conjugated by the pullback dictionary and the tilde counit) equals the algebraic
  -- extend/restrict counit (conjugated by `β` and the tilde counit).
  rw [hcounitL, hcounitR] at huce
  -- LANDED SCAFFOLD (iter-022, recipe step 1 COMPLETE — verified compiling): `huce` is now the
  -- master counit-transport identity (the counit dual of Seam 1's `huce`):
  --   L₂.map(β.hom.app W) ≫ tilde.map(ε^alg) ≫ ε_tilde.app W
  --     = (pullback_spec_tilde_iso ψ _).inv ≫ pullback(Spec ψ).map(ε_tilde) ≫ ε_g.app W,
  -- where `ε^alg = (extendRestrictScalarsAdj ψ).counit` is the ALGEBRAIC counit and `ε_g` is the
  -- geometric `(g^* ⊣ g_*)` counit appearing in the goal's second factor. Solving `huce` for `ε_g`
  -- (the trailing dictionary/tilde-counit factors are isos) and applying `moduleSpecΓFunctor.map`
  -- rewrites the goal's `Γ_{R'}(ε_g)` into the algebraic counit conjugated by the dictionaries that
  -- `Θ_src`/`Θ_tgt` (domain/codomain reads) already bake in.
  --
  -- REMAINING CRUX (recipe steps 2–3, the genuine ~150-LOC telescoping):
  --   (a) the inner reindex `Γ_R(θ_in) = ρ` (`base_change_mate_inner_value`), to be reproven INLINE
  --       (NOT via the sorry-backed `base_change_mate_fstar_reindex`) from the PROVED standalone
  --       `base_change_mate_fstar_reindex_legs_unitExpand` (@~1273) + `…_gammaDistribute` (@~1304) +
  --       `gammaMap_pushforwardComp_*` + Seam-1 `base_change_mate_unit_value` +
  --       `pullbackPushforward_unit_comp` (@~1144);
  --   (b) the generator close `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv` on `r' ⊗ m ↦
  --       (1 ⊗ r') ⊗ m`, a one-generator `ext` against `base_change_mate_regroupEquiv`;
  --   plus the dictionary cancellation matching `huce`'s `pullback_spec_tilde_iso`/tilde-counit
  --       factors against the `pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` baked into
  --       `Θ_src`/`Θ_tgt`. NOTE: `set W` did NOT fold the goal's `ε_g` argument (the counit-app
  --       object differs syntactically from `W`'s body), so the `ε_g` rewrite must be staged on the
  --       unfolded form or via `conv`/`change`, not a bare `rw [hεg]`.
  sorry

/-- **The section-level base-change map is the base change of the unit.** With the domain and
codomain pinned by `base_change_mate_domain_read` (`Θ_src`) and `base_change_mate_codomain_read`
(`Θ_tgt`), the conjugated section-level base-change map
`Θ_src⁻¹ ≫ Γ(θ) ≫ Θ_tgt : R' ⊗_R M ⟶ (A ⊗_R R') ⊗_A M` is the `R'`-base change of the algebraic
unit `η_M : M → (A ⊗_R R') ⊗_A M`, `m ↦ (1 ⊗ 1) ⊗ m`: on the generator `r' ⊗ m` it returns
`r' • ((1 ⊗ 1) ⊗ m) = (1 ⊗ r') ⊗ m`. Equivalently it equals the *inverse* of the regrouping
isomorphism `base_change_mate_regroupEquiv`, i.e.
`Θ_src⁻¹ ≫ Γ(θ) ≫ Θ_tgt = (base_change_mate_regroupEquiv ψ φ M).inv`. See blueprint
`lem:base_change_mate_section_identity`.

The argument is carried out directly on the module of global sections; no abstract adjoint-mate
identification at the level of sheaves intervenes. By `ModuleCat` hom-extensionality it suffices to
check on the `R'`-module generators `1 ⊗ₜ x` (`ext x`), leaving the concrete per-generator identity
`(Θ_src⁻¹ ≫ Γ(θ) ≫ Θ_tgt) (1 ⊗ x) = regroupEquiv.inv (1 ⊗ x)`. By construction `Γ(θ)` is, read on
global sections through the two tilde dictionaries `pushforward_spec_tilde_iso` /
`pullback_spec_tilde_iso` packaged in `Θ_src`, `Θ_tgt`, the extension of scalars along `ψ : R → R'`
of the algebraic unit of extension of scalars along `A → A ⊗_R R'` (`m ↦ (1 ⊗ 1) ⊗ m`); evaluating
through the `R'`-action on the target gives `1 ⊗ x ↦ (1 ⊗ 1) ⊗ x`, which is exactly
`regroupEquiv.inv` on generators (both sides `R'`-linear). The remaining obligation is the
identification of `Γ(pushforwardBaseChangeMap …)` on the generator with the unit value, i.e. the
mate-unwinding coherence over the generic pullback square; it is Mathlib-absent (typed `sorry` at the
per-generator node below). With it discharged, `base_change_mate_generator_trace` is a one-line
corollary. -/
theorem base_change_mate_section_identity {R R' A : CommRingCat.{u}}
    (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (base_change_mate_domain_read ψ φ M).inv ≫
      (moduleSpecΓFunctor (R := R')).map
        (pushforwardBaseChangeMap (Spec.map φ) (Spec.map ψ)
          (Limits.pullback.snd (Spec.map φ) (Spec.map ψ))
          (Limits.pullback.fst (Spec.map φ) (Spec.map ψ))
          (IsPullback.of_hasPullback (Spec.map φ) (Spec.map ψ)).w (tilde M)) ≫
      (base_change_mate_codomain_read ψ φ M).hom
      = (base_change_mate_regroupEquiv ψ φ M).inv := by
  -- COUNIT FACTORIZATION (blueprint Seam 3 step): `pushforwardBaseChangeMap` is by definition the
  -- `(g^* ⊣ g_*)`-adjunction transpose `((pullbackPushforwardAdjunction g).homEquiv _ _).symm inner`
  -- of the inner pushforward comparison `inner`. By `Adjunction.homEquiv_counit` this transpose is
  -- `g^*(inner) ≫ counit`, with no opaque adjunction transpose remaining. After this rewrite the goal
  -- is exactly the statement of Seam 3 (`base_change_mate_gstar_transpose`).
  unfold pushforwardBaseChangeMap
  rw [Adjunction.homEquiv_counit]
  exact base_change_mate_gstar_transpose ψ φ M

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
  -- By the section identity `base_change_mate_section_identity` the conjugated map equals
  -- `(base_change_mate_regroupEquiv ψ φ M).inv`, the inverse of a `ModuleCat` isomorphism, hence an
  -- isomorphism.
  rw [base_change_mate_section_identity]
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
