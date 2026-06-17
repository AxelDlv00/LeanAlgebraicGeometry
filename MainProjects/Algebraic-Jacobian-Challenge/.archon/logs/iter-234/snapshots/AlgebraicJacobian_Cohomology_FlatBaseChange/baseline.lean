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

/-- **Affine base change.** If `f` is an affine morphism and the square is
cartesian, then the base-change map for the pushforward is an isomorphism. In the
affine-local picture this is the associativity isomorphism
`(R' ⊗_R A) ⊗_A M ≅ R' ⊗_R M`, which needs no flatness.

Source: Stacks Project, Cohomology of Schemes, Lemma "Affine base change". -/
theorem affineBaseChange_pushforward_iso (h : IsPullback g' f' f g) [IsAffineHom f]
    (F : X.Modules) :
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
    [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) :
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
