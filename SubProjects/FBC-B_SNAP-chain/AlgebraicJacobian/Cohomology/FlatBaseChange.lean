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

UPDATE (resolved): the full object iso `pushforward_spec_tilde_iso`
(`pushforward (Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`) is now **fully proved,
no `sorry`** (blueprint `lem:pushforward_spec_tilde_iso`, `\leanok`). The earlier worry
that the comparison `pushforward (tilde M) ⟵[fromTildeΓ] tilde (Γ (pushforward (tilde M)))
⟶[tilde.map gammaPushforwardTildeIso.hom] tilde (restrictScalars φ M)` needed an
independent quasi-coherence input for `fromTildeΓ` to be an iso is OBSOLETE: the iso is
built directly on a basis of basic opens (the non-circular route) via
`pushforward_spec_tilde_iso_of_isLocalizedModule` + `Modules.isIso_of_isIso_app_of_isBasis`
+ the per-basic-open `IsLocalizedModule` fact (`fromTildeΓ_app_isIso_of_isLocalizedModule`,
`tildeRestriction_isLocalizedModule`, `IsLocalizedModule.powers_restrictScalars`:
`(restrictScalars φ M)` localised at `a` = `M` localised at `φ a`); quasi-coherence of the
pushforward then follows as a corollary, not a prerequisite. There is no open QC
obligation. -/

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

/-- **Three-fold naturality of the global-sections comparison square** (blueprint
`lem:globalSectionsIso_hom_comp3_specMap_appTop`). The `R → S → T` composite analogue of
`globalSectionsIso_hom_comp_specMap_appTop`: for ring maps `φ : R ⟶ S` and `ρ : S ⟶ T`, the
ring square
```
  R       --gsR.hom-->       Γ(Spec R, ⊤)
  |φ≫ρ                              |(Spec.map (φ ≫ ρ)).appTop
  v                                 v
  T       --gsT.hom-->       Γ(Spec T, ⊤)
```
commutes. Because the single-map square `globalSectionsIso_hom_comp_specMap_appTop` is stated
for an *arbitrary* ring map, the composite case is just that lemma instantiated at `φ ≫ ρ`; the
splicing through `gs_S` (and the `Spec`-contravariance cast `Spec.map_comp`) is what the
single-map lemma already encapsulates via `Scheme.ΓSpecIso_inv_naturality`. Project-local. -/
theorem globalSectionsIso_hom_comp3_specMap_appTop {R S T : CommRingCat.{u}}
    (φ : R ⟶ S) (ρ : S ⟶ T) :
    (StructureSheaf.globalSectionsIso ↑R).hom ≫ (Spec.map (φ ≫ ρ)).appTop
      = (φ ≫ ρ) ≫ (StructureSheaf.globalSectionsIso ↑T).hom :=
  globalSectionsIso_hom_comp_specMap_appTop (φ ≫ ρ)

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

/-- **The Γ-pushforward comparison is the identity on underlying sections.** Every constituent of
`gammaPushforwardIso φ N` (`restrictScalarsComp'App`, `restrictScalarsCongr`) merely repackages the
module structure on the unchanged carrier `Γ(N, ⊤)`, so its forward map sends each section to
itself. Project-local helper, used to collapse the per-component composition coherence
`gammaPushforwardIso_comp`. -/
theorem gammaPushforwardIso_hom_apply {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (N : (Spec R').Modules)
    (y : (moduleSpecΓFunctor (R := R)).obj ((Scheme.Modules.pushforward (Spec.map φ)).obj N)) :
    (ModuleCat.Hom.hom (gammaPushforwardIso φ N).hom) y = y := rfl

/-- **The Γ-pushforward comparison inverse is the identity on underlying sections.** -/
theorem gammaPushforwardIso_inv_apply {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (N : (Spec R').Modules)
    (y : (ModuleCat.restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R := R')).obj N)) :
    (ModuleCat.Hom.hom (gammaPushforwardIso φ N).inv) y = y := rfl

/-- **`eqToHom` on `ModuleCat` is the carrier transport.** Applying the morphism `eqToHom h`
attached to an object equality `h : M = N` of `ModuleCat R` to an element is, on the underlying
carrier, the `cast` along the induced type equality. This is the kernel-light replacement for a
`change`/`rfl` collapse of an `eqToHom` cast (the latter forces `whnf` of the full
structure-sheaf machinery and times out). Project-local. -/
theorem moduleCat_eqToHom_concreteCategory_apply {R : Type u} [Ring R]
    {M N : ModuleCat.{v} R} (h : M = N) (x : M) :
    (ConcreteCategory.hom (eqToHom h)) x
      = cast (congrArg (fun K : ModuleCat.{v} R => (↑K : Type v)) h) x := by
  subst h
  rfl

/-- `ConcreteCategory.hom`-keyed restatement of `gammaPushforwardIso_hom_apply` (so that `simp`/`rw`
fire after `ModuleCat.comp_apply` has rewritten every application head to `ConcreteCategory.hom`).
Single-layer `rfl`, hence kernel-light. Project-local. -/
theorem gammaPushforwardIso_hom_concreteApply {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (N : (Spec R').Modules)
    (y : (moduleSpecΓFunctor (R := R)).obj ((Scheme.Modules.pushforward (Spec.map φ)).obj N)) :
    (ConcreteCategory.hom (gammaPushforwardIso φ N).hom) y = y := rfl

/-- Restriction of scalars does not change the underlying function of a morphism. Single-layer
`rfl`, kernel-light. Project-local. -/
theorem restrictScalars_map_concreteApply {R S : Type u} [Ring R] [Ring S] (f : R →+* S)
    {A B : ModuleCat.{u} S} (h : A ⟶ B) (y : (ModuleCat.restrictScalars f).obj A) :
    (ConcreteCategory.hom ((ModuleCat.restrictScalars f).map h)) y = (ConcreteCategory.hom h) y :=
  rfl

/-- The restrict-scalars composition iso is the identity on underlying elements. Single-layer
`rfl`, kernel-light. Project-local. -/
theorem restrictScalarsComp_inv_app_concreteApply {R S T : Type u} [Ring R] [Ring S] [Ring T]
    (f : R →+* S) (g : S →+* T) (M : ModuleCat.{u} T)
    (y : ((ModuleCat.restrictScalars g).comp (ModuleCat.restrictScalars f)).obj M) :
    (ConcreteCategory.hom ((ModuleCat.restrictScalarsComp f g).inv.app M)) y = y := rfl

/-- **Per-component composition coherence of the affine-pushforward Γ-comparison** (blueprint
`lem:gammaPushforwardIso_comp`). For ring maps `φ : R ⟶ S`, `ρ : S ⟶ T` and a `Spec T`-module
`N`, the comparison `gammaPushforwardIso (φ ≫ ρ) N` for the composite agrees with the pasting of
the two single-map comparisons (that for `ρ` at `N`, that for `φ` at `(Spec ρ)_* N`), reorganised
on the domain by the pushforward composition iso (carrying the `Spec.map_comp` cast) and on the
codomain by `restrictScalarsComp`. This is the component where the genuine global-sections ring
content lives; the cast reconciliation is exactly the three-fold ring coherence
`globalSectionsIso_hom_comp3_specMap_appTop`. Project-local. -/
theorem gammaPushforwardIso_comp {R S T : CommRingCat.{u}} (φ : R ⟶ S) (ρ : S ⟶ T)
    (N : (Spec T).Modules) :
    (gammaPushforwardIso (φ ≫ ρ) N).hom =
      (moduleSpecΓFunctor (R := R)).map
          ((eqToIso (congrArg Scheme.Modules.pushforward (Spec.map_comp φ ρ))).hom.app N ≫
            (Scheme.Modules.pushforwardComp (Spec.map ρ) (Spec.map φ)).inv.app N) ≫
        (gammaPushforwardIso φ ((Scheme.Modules.pushforward (Spec.map ρ)).obj N)).hom ≫
          (ModuleCat.restrictScalars φ.hom).map (gammaPushforwardIso ρ N).hom ≫
            (ModuleCat.restrictScalarsComp φ.hom ρ.hom).inv.app
              ((moduleSpecΓFunctor (R := T)).obj N) := by
  apply ModuleCat.hom_ext
  refine LinearMap.ext fun x => ?_
  -- LHS collapses on the carrier by the pointwise-identity helper; the RHS outer compositions
  -- distribute to nested section maps. After this purely lemma-driven step the goal is
  --   `x = restrictScalarsComp.inv (restrictScalars.map (γ_ρ) (γ_φ (Γ(cast) x)))`,
  -- where every wrapper is the identity on the underlying section `x ∈ Γ(N, ⊤)` (by
  -- `gammaPushforwardIso_{hom,inv}_apply`) and the only genuine content is the reindexing cast
  -- `Γ(cast)` = global sections of the `Spec.map_comp φ ρ` glue (`eqToIso` ≫ `pushforwardComp.inv`).
  rw [gammaPushforwardIso_hom_apply (φ ≫ ρ) N x, ModuleCat.comp_apply, ModuleCat.comp_apply]
  -- GOAL NOW: `x = B (A (γ_φ (Γ_cast x)))`, where `Γ_cast = moduleSpecΓFunctor.map (eqToIso.hom.app N
  -- ≫ pushforwardComp.inv.app N)` is the domain reindexing cast and `B, A, γ_φ` are the three
  -- comparison wrappers. On the underlying carrier `Γ(N,⊤)` EVERY wrapper is the identity:
  --   • `B  = restrictScalarsComp.inv.app _`                       — `restrictScalarsComp_inv_app_concreteApply` (`:= rfl`)
  --   • `A  = restrictScalars.map (gammaPushforwardIso ρ N).hom`   — `restrictScalars_map_concreteApply` (`:= rfl`)
  --   • `γ_φ = (gammaPushforwardIso φ _).hom`                       — `gammaPushforwardIso_hom_concreteApply` (`:= rfl`)
  --   • `Γ_cast` splits (via `Functor.map_comp`, `eqToHom_map`) into `moduleSpecΓFunctor.map
  --     (pushforwardComp.inv.app N)` (`:= rfl`) ∘ `Γ(eqToHom (Spec.map_comp))`, the latter sent to a
  --     SYMBOLIC carrier `cast` by `moduleCat_eqToHom_concreteCategory_apply`; the carrier transport
  --     itself is `rfl`-CHEAP (verified: `(rfl : ↑(Γ(pushforward (Spec (φ≫ρ)) N)) =
  --     ↑(Γ(pushforward (Spec ρ ≫ Spec φ) N)))` typechecks instantly).
  -- The five single-layer `*_concreteApply` helpers above ALL COMPILE (each is a kernel-light `rfl`).
  --
  -- BLOCKER (characterised precisely this iter; the genuine obstruction): the `X.Modules`/value-
  -- `ModuleCat` diamond. Every wrapper changes the OBJECT type (its domain ≠ codomain as `ModuleCat`
  -- objects — they agree ONLY on the carrier), so the per-layer collapse cannot be assembled:
  --   – `rw`/`simp` with a helper FAILS to fire on `γ_φ` and `B`: rewriting `γ_φ z → z` retypes `z`
  --     from `γ_φ`'s codomain object to its domain object, and the enclosing wrapper then fails to
  --     typecheck WITHOUT the heavy `restrictScalars ↔ pushforward∘Γ` object identity (motive-not-
  --     type-correct). (`A` and the inner `γ_ρ` DO fire — their junction sits under
  --     `restrictScalars.map` and stays syntactic.)
  --   – a term-mode `Eq.trans` chain through all layers (verified to elaborate under the LSP)
  --     EXPLODES on cold build — the junction defeqs are that heavy object identity at every step
  --     (`> 1.6M` heartbeats, verified timeout); even the bare `simp`+`rw [moduleCat_eqToHom…]`
  --     SETUP for that chain is a cold-build (kernel) deterministic timeout.
  --   – a single monolithic `rfl` (`rw [moduleCat_eqToHom…]; rfl`) is a VERIFIED cold-build KERNEL
  --     BOMB (`whnf` timeout) — it forces the whole structure-sheaf reduction at once.
  -- The carrier-rfl being CHEAP while the per-junction OBJECT-defeq is HEAVY is the essential
  -- tension. iter-013 PRE-COMMITTED corrective (PROGRESS.md): mathlib-analogist consult on
  -- collapsing this value-`ModuleCat` carrier-identity composite — route through `.val.app (op ⊤)`
  -- (`pushforwardComp_inv_app_val_app` EXISTS, `SheafOfModules`) at the sheaf level, where the
  -- objects are the uniform `N.val.obj ⊤` and the restrictScalars/globalSections junctions never form.
  sorry

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

/-- **Composition coherence of the pushforward Γ-comparison** (blueprint
`lem:gammaPushforwardNatIso_comp`). For ring maps `φ : R ⟶ S` and `ρ : S ⟶ T`, the comparison
`gammaPushforwardNatIso (φ ≫ ρ)` for the composite is the pasting of the two single-map comparisons
`gammaPushforwardNatIso φ` and `gammaPushforwardNatIso ρ`, glued on the domain side by the
pushforward composition isomorphism `pushforwardComp` (and the `Spec`-contravariance
`Spec.map_comp`) and on the codomain side by the restrict-scalars composition isomorphism
`restrictScalarsComp`. Every constituent is identity-on-carriers (as is `gammaPushforwardNatIso`
itself), so the proof is pointwise reflexivity. This is the foundation coherence whose conjugate
through the composite-adjunction mate equivalence produces the pseudofunctoriality of the
tilde-pullback dictionary used in `pullback_spec_tilde_iso_ring_square_mate_glue`. Project-local. -/
theorem gammaPushforwardNatIso_comp {R S T : CommRingCat.{u}} (φ : R ⟶ S) (ρ : S ⟶ T) :
    gammaPushforwardNatIso (φ ≫ ρ) =
      Functor.isoWhiskerRight (eqToIso (congrArg Scheme.Modules.pushforward (Spec.map_comp φ ρ)) ≪≫
          (Scheme.Modules.pushforwardComp (Spec.map ρ) (Spec.map φ)).symm)
        (moduleSpecΓFunctor (R := R)) ≪≫
      (Functor.associator _ _ _) ≪≫
      Functor.isoWhiskerLeft (Scheme.Modules.pushforward (Spec.map ρ)) (gammaPushforwardNatIso φ) ≪≫
      (Functor.associator _ _ _).symm ≪≫
      Functor.isoWhiskerRight (gammaPushforwardNatIso ρ) (ModuleCat.restrictScalars φ.hom) ≪≫
      (Functor.associator _ _ _) ≪≫
      Functor.isoWhiskerLeft (moduleSpecΓFunctor (R := T))
        (ModuleCat.restrictScalarsComp φ.hom ρ.hom).symm := by
  apply Iso.ext
  apply NatTrans.ext
  funext N
  -- Reduce per-component (no element expansion of the carriers — that overflows the kernel).
  -- The structural whiskering/associator lemmas collapse the RHS pasting to the concrete
  -- per-component composite, whose genuine coherence content is isolated in
  -- `gammaPushforwardIso_comp` (where the `Spec.map_comp` cast is reconciled by the three-fold
  -- ring coherence `globalSectionsIso_hom_comp3_specMap_appTop`).
  simp only [Iso.trans_hom, NatTrans.comp_app, Functor.isoWhiskerRight_hom,
    Functor.isoWhiskerLeft_hom, Functor.associator_hom_app, Functor.associator_inv_app,
    Iso.symm_hom, Functor.whiskerRight_app, Functor.whiskerLeft_app, Category.id_comp,
    Category.comp_id, Category.assoc, gammaPushforwardNatIso, NatIso.ofComponents_hom_app]
  exact gammaPushforwardIso_comp φ ρ N

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

/-- **Defining unit triangle of the affine pullback dictionary.** Since `pullback_spec_tilde_iso φ`
is, by construction, the adjoint conjugate (via `conjugateIsoEquiv`) of the `Γ`-pushforward natural
isomorphism `gammaPushforwardNatIso φ`, the inverse map `(pullback_spec_tilde_iso φ M).inv`
satisfies the defining unit triangle of `unit_conjugateEquiv_symm`: composing the composite-left-
adjoint unit with `gammaPushforwardNatIso φ` equals composing the algebraic
`extendScalars ⋙ tilde` unit with the right-adjoint image of `(pullback_spec_tilde_iso φ M).inv`.
This is the per-leg bridge `pullback_spec_tilde_iso ↝ gammaPushforwardNatIso` used in the ring-square
naturality crux `pullback_spec_tilde_iso_ring_square_natural`. Project-local: a direct corollary of
Mathlib's `unit_conjugateEquiv_symm` applied to the conjugate presentation of the dictionary. -/
lemma pullback_spec_tilde_iso_inv_unit_triangle {R R' : CommRingCat.{u}}
    (φ : R ⟶ R') (M : ModuleCat.{u} R) :
    ((tilde.adjunction (R := R)).comp
          (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map φ))).unit.app M ≫
        (gammaPushforwardNatIso φ).hom.app
          ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M))
      = ((ModuleCat.extendRestrictScalarsAdj φ.hom).comp
            (tilde.adjunction (R := R'))).unit.app M ≫
          (moduleSpecΓFunctor (R := R') ⋙ ModuleCat.restrictScalars φ.hom).map
            (pullback_spec_tilde_iso φ M).inv := by
  set adjL := (tilde.adjunction (R := R)).comp
    (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map φ)) with hadjL
  set adjR := (ModuleCat.extendRestrictScalarsAdj φ.hom).comp
    (tilde.adjunction (R := R')) with hadjR
  have hbridge : ((conjugateEquiv adjL adjR).symm (gammaPushforwardNatIso φ).hom).app M
      = (pullback_spec_tilde_iso φ M).inv := rfl
  rw [← hbridge]
  exact unit_conjugateEquiv_symm adjL adjR (gammaPushforwardNatIso φ).hom M

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

/-! ## Concrete per-chart base-change layer (FBC-B)

The two lemmas below are the CONCRETE per-affine-chart input to the global flat-base-change
assembly `baseChange_sheafConditionFork_tensorIso` (FlatBaseChangeGlobal.lean). Both work entirely
inside the affine tilde dictionary `pullback_spec_tilde_iso` (Stacks 01I9, part (1)) and Mathlib's
flatness-free `cancelBaseChange`; no abstract base-change map, no flatness, and no adjoint mate
enter. They are phrased at the affine-ring level (chart `V = Spec R`, base ring map `A → B`,
`F|_V = M^~`), matching the style of `pullback_spec_tilde_iso`; the global lane bridges them to
genuine scheme charts.

They are placed here, after `base_change_mate_regroupEquiv`, only so that they can reuse that
proved, axiom-clean `comm ≪≫ cancelBaseChange ≪≫ comm` cancellation (a DELIVERABLE, not part of the
dead mate keystone) instead of duplicating its ~100-line `map_smul'` induction. The mathematical
content is the affine pullback dictionary, exactly as the blueprint prescribes. -/

/-- **Per-chart base-change module isomorphism** (blueprint `lem:base_change_chart_tensor_iso`).
Let `φ : A → R` (the affine chart structure map) and `ψ : A → B` (the base change) be ring maps and
`M` an `R`-module, modelling an affine chart `V = Spec R` of a scheme over `A` with `Γ(V, F) = M`
(so `F|_V = M^~`). Base change preserves affineness, so `V_B = V ×_{Spec A} Spec B` is the affine
`Spec (R ⊗[A] B)` and the chart base-change map is `Spec ι` for `ι = includeLeftRingHom`; restricting
`F_B = (g')^* F` to `V_B` is pulling `F|_V = M^~` back along `Spec ι`. Hence the affine pullback
dictionary `pullback_spec_tilde_iso` (Stacks 01I9, part (1)) reads its global sections as
`(R ⊗[A] B) ⊗_R M`, and the base-change cancellation `base_change_mate_regroupEquiv` (whose core is
Mathlib's flatness-free `TensorProduct.AlgebraTensorModule.cancelBaseChange`) rewrites this
`B`-linearly as `B ⊗_A M = Γ(V,F) ⊗_A B` (in the `extendScalars`/`restrictScalars` packaging the
global lane consumes). Every step is affine; no abstract base-change map, no flatness, and no
adjoint mate enters. See blueprint. -/
noncomputable def baseChange_chart_tensorIso {A R B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (M : ModuleCat.{u} R) :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    (ModuleCat.restrictScalars
        (Algebra.TensorProduct.includeRight (R := (A : Type u)) (A := (R : Type u))
          (B := (B : Type u))).toRingHom).obj
      ((moduleSpecΓFunctor (R := CommRingCat.of ((R : Type u) ⊗[(A : Type u)] (B : Type u)))).obj
        ((Scheme.Modules.pullback
          (Spec.map (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))))).obj (tilde M)))
      ≅ (ModuleCat.extendScalars ψ.hom).obj ((ModuleCat.restrictScalars φ.hom).obj M) := by
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
  -- (1) Read the chart-pullback sections via the affine pullback dictionary
  -- `pullback_spec_tilde_iso` + the tilde–Γ unit: `Γ(V_B, F_B) ≅ (R ⊗[A] B) ⊗_R M`;
  -- (2) cancel the base change `B`-linearly to `B ⊗_A M` via `base_change_mate_regroupEquiv`.
  refine (ModuleCat.restrictScalars _).mapIso ?_ ≪≫ base_change_mate_regroupEquiv ψ φ M
  exact (moduleSpecΓFunctor
        (R := CommRingCat.of ((R : Type u) ⊗[(A : Type u)] (B : Type u)))).mapIso
      (pullback_spec_tilde_iso (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
        (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))) M) ≪≫
    (tilde.toTildeΓNatIso.app _).symm

/-- The `A`-algebra map underlying a chart restriction `ρ : R ⟶ R'` (with `R, R'` made `A`-algebras
via the chart structure maps `φ`, `φ ≫ ρ`). It is `ρ` itself, repackaged as an `A`-algebra hom. -/
noncomputable def chartRestrictionAlgHom {A R R' : CommRingCat.{u}} (φ : A ⟶ R) (ρ : R ⟶ R') :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    (R : Type u) →ₐ[(A : Type u)] (R' : Type u) :=
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
  { ρ.hom with commutes' := fun _ => rfl }

/-- The base change `ρ ⊗ id_B : R ⊗[A] B ⟶ R' ⊗[A] B` of a chart restriction `ρ : R ⟶ R'`. This is
the coordinate ring map of the base-changed open immersion `j_B : W_B ↪ V_B`. -/
noncomputable def chartBaseChangeRingMap {A R R' B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (ρ : R ⟶ R') :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    CommRingCat.of ((R : Type u) ⊗[(A : Type u)] (B : Type u)) ⟶
      CommRingCat.of ((R' : Type u) ⊗[(A : Type u)] (B : Type u)) :=
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
  letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
  CommRingCat.ofHom (Algebra.TensorProduct.map (chartRestrictionAlgHom φ ρ)
    (AlgHom.id (A : Type u) (B : Type u))).toRingHom

/-- **(b1) The chart base-change ring square.** The left tensor inclusion commutes with base change:
`incl_R ≫ ρ_B = ρ ≫ incl_R'` as ring maps `R → R' ⊗[A] B` (where `ρ_B = ρ ⊗ id_B` and
`incl_R : R → R ⊗[A] B`, `incl_R' : R' → R' ⊗[A] B`). This is `Algebra.TensorProduct`'s
`map_comp_includeLeft`, the algebraic core of "base change of an affine open immersion is the open
immersion of coordinate-ring base changes". -/
theorem chartBaseChange_ring_square {A R R' B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (ρ : R ⟶ R') :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
        (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u))) ≫
      chartBaseChangeRingMap ψ φ ρ
      = ρ ≫ CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
          (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u))) := by
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
  letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
  ext x
  -- `ρ_B (x ⊗ 1) = ρ x ⊗ 1`, i.e. `map_comp_includeLeft` on the element `x`.
  exact congr($(Algebra.TensorProduct.map_comp_includeLeft
    (chartRestrictionAlgHom φ ρ) (AlgHom.id (A : Type u) (B : Type u))) x)

/-- **(b1) Geometric comparison along the base-changed open immersion.** The base-changed chart
`j_B : W_B ↪ V_B` (coordinate map `ρ_B`) identifies the iterated pullback
`j_B^* (F_B|_{V_B}) = j_B^* (Spec ι_R)^* M^~` with the `W`-chart pullback
`(Spec ι_{R'})^* (Spec ρ)^* M^~ = F_B|_{W_B}`. Purely geometric: it is built from
the pullback pseudofunctor coherence `pullbackComp` and the base-change ring square
`chartBaseChange_ring_square` (no `tilde` dictionary enters), so it is the categorical incarnation
of "base change of an affine open immersion is the open immersion of coordinate base changes". -/
noncomputable def chartBaseChangeGeometricComparison {A R R' B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (ρ : R ⟶ R') (M : ModuleCat.{u} R) :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    (Scheme.Modules.pullback (Spec.map (chartBaseChangeRingMap ψ φ ρ))).obj
        ((Scheme.Modules.pullback (Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))))).obj (tilde M)) ≅
      (Scheme.Modules.pullback (Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u)))))).obj
        ((Scheme.Modules.pullback (Spec.map ρ)).obj (tilde M)) := by
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
  letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
  set inclR := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u))) with hinclR
  set inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u))) with hinclR'
  set ρB := chartBaseChangeRingMap ψ φ ρ with hρB
  -- The geometric base-change square `Spec ρ_B ≫ Spec ι_R = Spec ι_{R'} ≫ Spec ρ`, from the ring
  -- square `ι_R ≫ ρ_B = ρ ≫ ι_{R'}` (`chartBaseChange_ring_square`) by `Spec`-contravariance.
  have hsq : Spec.map ρB ≫ Spec.map inclR = Spec.map inclR' ≫ Spec.map ρ := by
    rw [← Spec.map_comp, ← Spec.map_comp]
    exact congrArg Spec.map (chartBaseChange_ring_square ψ φ ρ)
  exact (Scheme.Modules.pullbackComp (Spec.map ρB) (Spec.map inclR)).app (tilde M) ≪≫
    (Scheme.Modules.pullbackCongr hsq).app (tilde M) ≪≫
    (Scheme.Modules.pullbackComp (Spec.map inclR') (Spec.map ρ)).symm.app (tilde M)

/-- **(b2) Algebraic reassociation of the iterated base change.** Extending scalars to `R' ⊗[A] B`
in stages — first along `ι_R : R → R ⊗[A] B` then along `ρ_B`, versus first along `ρ : R → R'`
then along `ι_{R'} : R' → R' ⊗[A] B` — gives canonically isomorphic `(R' ⊗[A] B)`-modules, because
the two routes extend along the equal ring maps `ρ_B ∘ ι_R = ι_{R'} ∘ ρ`
(`chartBaseChange_ring_square`). Built from `ModuleCat.extendScalarsComp` (×2) and an `eqToIso` on
that ring equality. -/
noncomputable def chartBaseChangeModuleReassoc {A R R' B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (ρ : R ⟶ R') (M : ModuleCat.{u} R) :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    (ModuleCat.extendScalars (chartBaseChangeRingMap ψ φ ρ).hom).obj
        ((ModuleCat.extendScalars (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
          (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))).hom).obj M) ≅
      (ModuleCat.extendScalars (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
          (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u)))).hom).obj
        ((ModuleCat.extendScalars ρ.hom).obj M) := by
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
  letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
  set inclR := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u))) with hinclR
  set inclR' := CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
    (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u))) with hinclR'
  set ρB := chartBaseChangeRingMap ψ φ ρ with hρB
  have hRing : ρB.hom.comp inclR.hom = inclR'.hom.comp ρ.hom := by
    rw [← CommRingCat.hom_comp, ← CommRingCat.hom_comp]
    exact congrArg CommRingCat.Hom.hom (chartBaseChange_ring_square ψ φ ρ)
  exact ((ModuleCat.extendScalarsComp inclR.hom ρB.hom).app M).symm ≪≫
    eqToIso (by rw [hRing]) ≪≫
    (ModuleCat.extendScalarsComp ρ.hom inclR'.hom).app M

/-- **(b2) Ring-square naturality of the tilde-pullback dictionary**
(blueprint `lem:pullback_spec_tilde_iso_ring_square_natural`). The explicit affine tilde-pullback
isomorphism `pullback_spec_tilde_iso` is natural across the base-change ring square
`chartBaseChange_ring_square`: the forward map of the geometric comparison
`chartBaseChangeGeometricComparison` and the forward map of the algebraic reassociation
`chartBaseChangeModuleReassoc` agree once transported through the two per-chart dictionaries of
`pullback_spec_tilde_iso` for `V` and for `W`. This is the residual crux of
`pullback_spec_tilde_iso_restriction_naturality`.

ROUTE (blueprint b2): `pullback_spec_tilde_iso φ` is the `M`-component of the adjoint conjugate
(via `conjugateIsoEquiv`) of the `Γ`-pushforward natural isomorphism `gammaPushforwardNatIso φ`.
Its naturality across the ring square is therefore the naturality of `gammaPushforwardNatIso` under
the same square, transported through `conjugateEquiv` naturality. Concretely, after reducing to the
`.hom` equality and rearranging the two `pullback_spec_tilde_iso` legs to a common target
`tilde (extendScalars inclR' (extendScalars ρ M))`, both sides become isomorphisms
`Source ≅ tilde N`; transposing their inverses through the tilde–Γ adjunction
(`tilde.adjunction`) lands the identity in `ModuleCat (R' ⊗[A] B)`, where every constituent is the
identity-on-elements `gammaPushforwardIso`/`pushforwardComp`/`extendScalarsComp` repackaging, so the
two transposed maps coincide. -/
theorem pullback_spec_tilde_iso_ring_square_natural {A R R' B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (ρ : R ⟶ R') (M : ModuleCat.{u} R) :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    (chartBaseChangeGeometricComparison ψ φ ρ M ≪≫
        (Scheme.Modules.pullback (Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u)))))).mapIso
          (pullback_spec_tilde_iso ρ M))
      = ((Scheme.Modules.pullback (Spec.map (chartBaseChangeRingMap ψ φ ρ))).mapIso
            (pullback_spec_tilde_iso (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
              (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))) M) ≪≫
          pullback_spec_tilde_iso (chartBaseChangeRingMap ψ φ ρ)
            ((ModuleCat.extendScalars (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
              (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))).hom).obj M) ≪≫
          (tilde.functor _).mapIso (chartBaseChangeModuleReassoc ψ φ ρ M) ≪≫
          (pullback_spec_tilde_iso (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u))))
            ((ModuleCat.extendScalars ρ.hom).obj M)).symm) := by
  letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
  letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
  letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
  -- Reduce to a `.hom` equality of `(Spec (R' ⊗[A] B)).Modules` morphisms.
  apply Iso.ext
  simp only [Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
  -- Move the trailing `(pullback_spec_tilde_iso inclR' _).inv` to the left as its `.hom`, so both
  -- sides become honest morphisms `Source ⟶ tilde (extendScalars inclR' (extendScalars ρ M))`.
  rw [← Category.assoc, ← Category.assoc, Iso.eq_comp_inv]
  -- RESIDUAL CRUX (blueprint b2): naturality of the opaque `pullback_spec_tilde_iso` across
  -- `chartBaseChange_ring_square`, i.e. the pseudo-functoriality of the dictionary in the ring map.
  -- `Source = (tilde_R ⋙ pullback (Spec inclR) ⋙ pullback (Spec ρB)).obj M` is the value at `M`
  -- of the composite LEFT adjoint `L_tot`, whose right adjoint is
  -- `R_tot = pushforward (Spec ρB) ⋙ pushforward (Spec inclR) ⋙ Γ_R`. Both sides are morphisms
  -- out of `Source`, so transposing through the composite adjunction `L_tot ⊣ R_tot`
  -- (`tilde.adjunction.comp (ppAdj (Spec inclR)) |>.comp (ppAdj (Spec ρB))`) sends the identity to a
  -- `ModuleCat ↑R` equation `M ⟶ R_tot.obj (tilde N)`; under the `pushforward`/`Γ` dictionaries
  -- (`pushforward_spec_tilde_iso`, `gammaPushforwardIso`) `R_tot.obj (tilde N)` reads as a nested
  -- `restrictScalars` tower, and each `pullback_spec_tilde_iso` leg transposes — via
  -- `unit_conjugateEquiv` applied to its defining `conjugateIsoEquiv` — to the identity-on-elements
  -- `gammaPushforwardNatIso`, so the two transposed maps coincide. The geometric comparison
  -- transposes through `pushforwardComp` (`conjugateEquiv_pullbackComp_inv`) and the reassociation
  -- through `extendScalarsComp`, matching the same target tower. See task_results for the attempt log.
  -- First transpose peel: through the outermost adjunction `pullback (Spec ρB) ⊣ pushforward (Spec ρB)`.
  -- Both sides are morphisms out of `pullback (Spec ρB).obj X` (`X = pullback (Spec inclR) (tilde M)`),
  -- so `homEquiv`-injectivity reduces to an equation of morphisms `X ⟶ pushforward (Spec ρB) (tilde N)`;
  -- iterating through `pullback (Spec inclR) ⊣ pushforward (Spec inclR)` and `tilde ⊣ Γ` lands the
  -- identity in `ModuleCat ↑R`. (Remaining: push `homEquiv` through the composites and identify each
  -- `pullback_spec_tilde_iso` transpose with `gammaPushforwardNatIso` via `unit_conjugateEquiv`.)
  apply ((Scheme.Modules.pullbackPushforwardAdjunction
    (Spec.map (chartBaseChangeRingMap ψ φ ρ))).homEquiv _ _).injective
  -- Expand the transpose as `unit ≫ pushforward.map (…)`; both sides now share the leading unit and
  -- carry the three legs pushed through `pushforward (Spec ρB)`.
  simp only [Adjunction.homEquiv_unit, Functor.map_comp, Category.assoc]
  -- REMAINING: cancel the common `unit` prefix, then transpose twice more — through
  -- `pullback (Spec inclR) ⊣ pushforward (Spec inclR)` and `tilde ⊣ Γ` — to reach a `ModuleCat ↑R`
  -- equation `M ⟶ restrictScalars inclR (restrictScalars ρB N)`. There each `pullback_spec_tilde_iso`
  -- leg becomes `gammaPushforwardNatIso` (its defining conjugate, via `unit_conjugateEquiv`), the
  -- geometric comparison becomes `pushforwardComp` (`conjugateEquiv_pullbackComp_inv`), and the
  -- reassociation becomes `extendScalarsComp`; all are identity-on-elements, so the two sides agree
  -- by `gammaPushforwardIso`'s pointwise-`rfl` naturality. See task_results for the full route.
  -- Second transpose peel: through `pullback (Spec inclR) ⊣ pushforward (Spec inclR)`. Both sides are
  -- maps out of `X = pullback (Spec inclR) (tilde M)`, so injectivity reduces to an equation of maps
  -- `tilde M ⟶ pushforward (Spec inclR) (pushforward (Spec ρB) (tilde N))`.
  apply ((Scheme.Modules.pullbackPushforwardAdjunction (Spec.map (CommRingCat.ofHom
    (Algebra.TensorProduct.includeLeftRingHom
      (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))))).homEquiv _ _).injective
  simp only [Adjunction.homEquiv_unit, Functor.map_comp, Category.assoc]
  -- Third transpose peel: through `tilde ⊣ Γ`. Lands the identity in `ModuleCat ↑R` as a map
  -- `M ⟶ Γ_R (pushforward (Spec inclR) (pushforward (Spec ρB) (tilde N)))`.
  apply ((tilde.adjunction (R := R)).homEquiv _ _).injective
  simp only [Adjunction.homEquiv_unit, Functor.map_comp, Category.assoc]
  -- REMAINING (`ModuleCat ↑R` equation): each `pullback_spec_tilde_iso` leg transposes to
  -- `gammaPushforwardNatIso` via the verified brick `pullback_spec_tilde_iso_inv_unit_triangle`;
  -- the geometric comparison transposes through `pushforwardComp`; the reassociation through
  -- `ModuleCat.extendScalarsComp`. All identity-on-elements ⇒ coincide by `gammaPushforwardIso`'s
  -- pointwise `rfl` naturality.
  sorry

/-- **(b) Restriction-naturality of the affine pullback dictionary**
(blueprint `lem:pullback_tilde_restriction_natural`). For a chart restriction `ρ : R ⟶ R'`
(an affine open immersion `j : W ↪ V`), the per-chart base-change reading of
`baseChange_chart_tensorIso` for `V` and for `W` commute with restriction. Concretely, the two
isomorphisms
`j_B^* (F_B|_{V_B}) ≅ F_B|_{W_B}` — the *geometric* one
(`chartBaseChangeGeometricComparison`, built from pullback pseudofunctoriality and the base-change
ring square) and the *algebraic* one (the per-chart tilde dictionaries `pullback_spec_tilde_iso` for
`V` and `W`, glued by the reassociation `chartBaseChangeModuleReassoc`) — agree. This is the
"concrete functoriality" of the explicit tilde-pullback isomorphism (Stacks 01I9, part (1), the word
"functorially"): every arrow is an honest module map computed by localization/base change, **not**
the categorical mate. Applying `moduleSpecΓFunctor` and `base_change_mate_regroupEquiv` to this
identity yields the blueprint's `Γ`-level commuting square
`res ∘ (a_V) = (a_W) ∘ (ρ^# ⊗ id_B)`; that descent is assembled in the global lane.

PROOF STATUS: the statement is the naturality of `pullback_spec_tilde_iso` across the base-change
ring square `chartBaseChange_ring_square`. The two scaffolding comparisons are fully proved
(`chartBaseChangeGeometricComparison`, `chartBaseChangeModuleReassoc`,
`chartBaseChange_ring_square`); the residual is that the opaque dictionary `pullback_spec_tilde_iso`
(defined via `conjugateIsoEquiv`/`gammaPushforwardNatIso`) is natural in the ring map. The blueprint
flags this as the crux; next iter re-breaks it into (b1) done here + (b2) "the localization isos
commute with base change", to be discharged by the naturality of `gammaPushforwardNatIso` under the
ring square together with `conjugateEquiv` naturality. -/
theorem pullback_spec_tilde_iso_restriction_naturality {A R R' B : CommRingCat.{u}}
    (ψ : A ⟶ B) (φ : A ⟶ R) (ρ : R ⟶ R') (M : ModuleCat.{u} R) :
    letI : Algebra (A : Type u) (R : Type u) := φ.hom.toAlgebra
    letI : Algebra (A : Type u) (R' : Type u) := (φ ≫ ρ).hom.toAlgebra
    letI : Algebra (A : Type u) (B : Type u) := ψ.hom.toAlgebra
    -- geometric comparison, then the `W`-chart dictionary
    (chartBaseChangeGeometricComparison ψ φ ρ M ≪≫
        (Scheme.Modules.pullback (Spec.map (CommRingCat.ofHom
          (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u)))))).mapIso
          (pullback_spec_tilde_iso ρ M))
      = ((Scheme.Modules.pullback (Spec.map (chartBaseChangeRingMap ψ φ ρ))).mapIso
            (pullback_spec_tilde_iso (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
              (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))) M) ≪≫
          pullback_spec_tilde_iso (chartBaseChangeRingMap ψ φ ρ)
            ((ModuleCat.extendScalars (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
              (R := (A : Type u)) (A := (R : Type u)) (B := (B : Type u)))).hom).obj M) ≪≫
          (tilde.functor _).mapIso (chartBaseChangeModuleReassoc ψ φ ρ M) ≪≫
          (pullback_spec_tilde_iso (CommRingCat.ofHom (Algebra.TensorProduct.includeLeftRingHom
            (R := (A : Type u)) (A := (R' : Type u)) (B := (B : Type u))))
            ((ModuleCat.extendScalars ρ.hom).obj M)).symm) := by
  -- The statement is exactly the (b2) ring-square naturality of the tilde-pullback dictionary,
  -- isolated as `pullback_spec_tilde_iso_ring_square_natural`.
  exact pullback_spec_tilde_iso_ring_square_natural ψ φ ρ M

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
/-! ### Seam 2, conjugate-route foundation (iter-035 pivot)

The iter-034 direct-on-sections route for `base_change_mate_fstar_reindex_legs` bottoms out at the
cross-layer naturality of `gammaPushforwardIso ψ` under the `X.Modules` instance diamond. The pivot
(analogies/fbc-mate-reencode.md) re-encodes the comparison object natively in the composite-adjunction
conjugate calculus of `Mathlib.CategoryTheory.Adjunction.CompositionIso`, where the diamond never
forms because the lock-prone objects become metavariables via `conjugateEquiv.surjective`/`.injective`.
The first building block is the identification of the project's pseudofunctor coherence
`pullbackComp f g` with the abstract `leftAdjointCompIso` of the pushforward coherence `pushforwardComp f g`. -/

/-! ### Seam 2, step (ii): Γ-collapse of the transparent pushforward coherences

On global sections over `Spec R`, the two `pushforwardComp` composition coherences and the
`pushforwardCongr` congruence coherence appearing in the inner composite `θ_in` are transparent:
their section value at every open is the identity (`pushforwardComp_*_app_app = 𝟙`) or a presheaf
transport (`pushforwardCongr_hom_app_app`). Hence under `moduleSpecΓFunctor` they collapse to the
identity / an `eqToHom` repackaging. These are the blueprint step-(ii) atomic claims. -/

/-! ### Seam 2, step (iii): the mate-unwinding crux, cut into five atomic links

The five lemmas `base_change_mate_fstar_reindex_legs_{unitExpand, gammaDistribute, eCancel,
affineUnit, innerMatch}` decompose the step-(iii) obligation of
`base_change_mate_fstar_reindex_legs` into one mathematical move each. See blueprint
`lem:base_change_mate_fstar_reindex_legs_{unitExpand,…}`. -/

/-! ### Seam 2, conjugate chain (iter-035, the effort-breaker decomposition)

The codomain read and the leg-reindex coherence are re-expressed natively in the composite-adjunction
conjugate calculus. `base_change_mate_codomain_read_legs_param` abstracts the single pullback-composition
factor of `base_change_mate_codomain_read_legs`, so the conjugate-native read (conj-1a) is the same
construction with that factor taken as `leftAdjointCompIso` of the free legs; the two reads agree
(conj-1b) by `pullbackComp_eq_leftAdjointCompIso`. The leg-reindex coherence is then discharged on the
conjugate side (conj-2a, fed by conj-2b/2c/2d) and the target `_legs` is the thin wrapper. -/

set_option maxHeartbeats 4000000 in
set_option maxHeartbeats 4000000 in
set_option maxHeartbeats 4000000 in
set_option maxHeartbeats 1600000 in
/-! ### Seam 3, the gstar chain (effort-breaker `fbc-gstar`): five `\uses`-linked links

The `(g^* ⊣ g_*)`-transpose crux `base_change_mate_gstar_transpose` needs the inner pushforward
comparison `θ_in`, read on `Spec R` sections, to equal `ρ : m ↦ (1 ⊗ 1) ⊗ m`
(`base_change_mate_inner_value`). The chain cuts the ~150-LOC monolith into:
  • Seam A : `inner_unitReduce` (distribute) → `inner_eCancel` (cancel) → `inner_value_eq` (assemble);
  • Seam B : `gstar_generator_close` (the algebraic generator close); and
  • Seam C : `gstar_counit_transport` (the geometric→algebraic counit transport).
See blueprint `lem:base_change_mate_inner_unitReduce/_inner_eCancel/_inner_value_eq/`
`_gstar_generator_close/_gstar_counit_transport`. -/

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
  --   (b) the generator close `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv` — now PROVEN and
  --       axiom-clean as the standalone lemma `base_change_mate_extendScalars_inner_value_counit`
  --       (above, @~1999): `ext`/`extendScalars`/`Counit.map_apply_one_tmul` reduce the LHS to the
  --       affine inner value `ρ(x)`, which equals `regroupEquiv.inv (1 ⊗ x)` definitionally;
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
`regroupEquiv.inv` on generators (both sides `R'`-linear). This theorem's **body has no inline
`sorry`** (it unfolds `pushforwardBaseChangeMap` to its `(g^* ⊣ g_*)`-counit form
(`Adjunction.homEquiv_counit`) and is then exactly Seam 3, `base_change_mate_gstar_transpose ψ φ M`),
but it is **transitively `sorry`-backed** through `base_change_mate_gstar_transpose`. The single
residual obligation
of the whole Seam-3 chain — the mate-unwinding coherence over the generic pullback square — lives in
`base_change_mate_gstar_transpose` (and, beneath it, in the Seam-2 leg-reindex
`base_change_mate_fstar_reindex_legs`), NOT here. With that discharged,
`base_change_mate_generator_trace` is a one-line corollary. -/
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
`pullback_spec_tilde_iso`, landing on `cancelBaseChange⁻¹`. This theorem's **body has no inline
`sorry`** (it conjugates `base_change_mate_generator_trace` back through the domain/codomain reads),
but it is **transitively `sorry`-backed** through `base_change_mate_gstar_transpose`. The genuine
crux — the mate-unwinding coherence over the generic pullback square
`pullback (Spec.map φ) (Spec.map ψ)` — is the outstanding obligation carried by
`base_change_mate_gstar_transpose` (and, beneath it, `base_change_mate_fstar_reindex_legs`), NOT
here. -/
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
