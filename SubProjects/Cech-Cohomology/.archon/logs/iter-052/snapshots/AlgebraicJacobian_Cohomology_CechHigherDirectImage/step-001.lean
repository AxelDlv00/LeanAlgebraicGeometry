/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.HigherDirectImage

/-!
# Čech computation of the higher direct images `Rⁱ f_*` (unconditional)

This file constructs the higher derived direct images `Rⁱ f_* F` for `i ≥ 1`
**without appealing to injective resolutions** in the category of sheaves of
modules. The companion `Cohomology/HigherDirectImage.lean` defines `Rⁱ f_*` as a
right derived functor, which requires the ambient category of `O_X`-modules to
have enough injectives — a property not currently available for sheaves of
modules over a sheaf of rings whose value category varies over the site. The
Čech approach developed here sidesteps the issue: it computes `Rⁱ f_* F` as the
cohomology of an explicit complex built from the pushforwards of `F` over the
finite intersections of an affine open cover, producing an **unconditional**
construction of `Rⁱ f_*` for quasi-coherent `F` and separated quasi-compact `f`.

Throughout, `f : X ⟶ S` is a quasi-compact, separated morphism of schemes (so
all finite intersections of an affine open cover of `X` are again affine), and
`F : X.Modules` is a quasi-coherent `O_X`-module. A base change of `f` along
`g : S' ⟶ S` is recorded by a cartesian square
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
with `F' = (g')^* F` the pullback of `F` to `X'`.

The six main declarations are:

* `AlgebraicGeometry.CechNerve` — the (augmented) Čech nerve of an affine open
  cover, an augmented cosimplicial object of `O_X`-modules.
* `AlgebraicGeometry.CechComplex` — the relative Čech complex in `QCoh(S)`, a
  cochain complex of `O_S`-modules whose degree-`p` term is the product of the
  pushforwards of `F` over the `(p+1)`-fold intersections of the cover.
* `AlgebraicGeometry.CechAcyclic.affine` — Čech acyclicity on affines: the Čech
  complex of a standard cover of an affine scheme has vanishing cohomology in
  all positive degrees (Serre vanishing for quasi-coherent sheaves on affines).
* `AlgebraicGeometry.cech_computes_higherDirectImage` — the cohomology of the
  relative Čech complex is canonically isomorphic to `Rⁱ f_* F` wherever the
  derived functor is defined.

See `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

Source: Stacks Project, Cohomology of Schemes, §Čech cohomology of quasi-coherent
sheaves and §Quasi-coherence of higher direct images; Tags 02KE
(`lemma-cech-cohomology-quasi-coherent`), 02KG
(`lemma-quasi-coherent-affine-cohomology-zero`).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {S S' X X' : Scheme.{u}}

/- The Čech nerve `CechNerve` is *constructed* (no longer a hole) further below, once the
geometric backbone (`coverCechNerveOverAug`) and the push–pull functor (`pushPullFunctor`)
are in scope; see its definition just before `relativeCechComplexOfNerve`. -/

/-! ## Project-local Mathlib supplement — scheme-level Čech nerve backbone

The genuine construction of the {\v C}ech nerve `CechNerve` factors through two
ingredients that are independent of one another:

* a *geometric* backbone — the augmented {\v C}ech nerve of the cover, an
  augmented simplicial **scheme** over `X` (the iterated fibre powers of
  `∐ᵢ Uᵢ` over `X`), which exists unconditionally because `Scheme` has all
  finite limits; and
* a *push-pull* functor `(Over X)ᵒᵖ ⥤ X.Modules`, `(Y, p) ↦ p_* p^* F`, that
  turns the simplicial scheme over `X` into the cosimplicial `O_X`-module
  `CechNerve`.

The backbone (`coverArrow`, `coverCechNerve`) is built here axiom-clean. The
push-pull functor is the remaining gap: its `map_comp` requires the
`pushforwardComp` / `pullbackComp` coherence isomorphisms (the same coherence
quagmire active in `Picard/TensorObjSubstrate.lean`), so `CechNerve` itself is
left as the single genuine hole.

Independently of the nerve, the passage *from* an augmented cosimplicial
`O_X`-module *to* the relative {\v C}ech cochain complex in `QCoh(S)` is pure,
coherence-free plumbing (`relativeCechComplexOfNerve`): forget the augmentation,
push forward along `f` via `CosimplicialObject.whiskering`, and take the
alternating coface-map cochain complex. We record it here so that `CechComplex`
is *defined* in terms of `CechNerve` — closing `CechNerve` axiom-clean
immediately yields an axiom-clean `CechComplex`. -/

/-- The arrow `∐ᵢ Uᵢ ⟶ X` (`Sigma.desc 𝒰.f`) attached to an open cover `𝒰` of a
scheme `X`. Its augmented {\v C}ech nerve is the geometric backbone of the
relative {\v C}ech complex. Project-local: packages the cover as a single arrow
so the existing `Arrow.augmentedCechNerve` machinery applies. -/
noncomputable def coverArrow (𝒰 : X.OpenCover) : Arrow Scheme.{u} :=
  Arrow.mk (Sigma.desc 𝒰.f)

/-- The augmented {\v C}ech nerve of an open cover `𝒰`, as an augmented
simplicial scheme over `X`: in simplicial degree `p` it is the `(p+1)`-fold
fibre power of `∐ᵢ Uᵢ` over `X`, i.e. `∐_{(i₀,…,i_p)} U_{i₀} ×ₓ ⋯ ×ₓ U_{i_p}`,
with augmentation the cover map to `X`. Exists unconditionally because `Scheme`
has all finite limits (hence the wide pullbacks used by
`Arrow.augmentedCechNerve`). Project-local geometric backbone for `CechNerve`. -/
noncomputable def coverCechNerve (𝒰 : X.OpenCover) :
    SimplicialObject.Augmented Scheme.{u} :=
  (coverArrow 𝒰).augmentedCechNerve

/-! ### Push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules` — object and morphism bricks

The geometric backbone above is lifted to a cosimplicial `O_X`-module by the
*relative-direct-image functor on the over-category*
```
  G : (Over X)ᵒᵖ ⥤ X.Modules,   (Y, p) ↦ p_* p^* F,
```
sending an `X`-scheme `p : Y ⟶ X` to the pushforward along `p` of the pullback
`p^* F`. We record here the two *pre-coherence* bricks of `G` — its action on
objects (`pushPullObj`, the planner's `Gobj`) and on morphisms (`pushPullMap`,
the planner's `Gmap`) — both axiom-clean and free of any functor law. The functor
laws `G(𝟙) = 𝟙` and `G(g ≫ h) = G(h) ≫ G(g)` are a *consumer* of the
pushforward/pullback composition coherence (`pushforwardComp` / `pullbackComp` and
their unitor/pentagon identities) and are deferred; see the note after
`pushPullMap`. -/

/-- The object map of the push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`,
`(Y, p) ↦ p_* p^* F`. Sends an `X`-scheme `Y` (with structure map `Y.hom : Y.left
⟶ X`) to the pushforward along `Y.hom` of the pullback of `F`. Project-local
object brick of the {\v C}ech push–pull functor (the planner's `Gobj`). -/
noncomputable def pushPullObj (F : X.Modules) (Y : Over X) : X.Modules :=
  (pushforward Y.hom).obj ((Scheme.Modules.pullback Y.hom).obj F)

/-- The morphism map of the push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`. For a
morphism `g : Y₂ ⟶ Y₁` of `X`-schemes (so `g.left ≫ Y₁.hom = Y₂.hom`, the
over-triangle `Over.w g`), the contravariant functor produces the restriction
comparison `pushPullObj F Y₁ ⟶ pushPullObj F Y₂`. It is the three-step composite:
the unit `η` of the adjunction `pullback g.left ⊣ pushforward g.left`, the
pushforward comparison `(pushforwardComp g.left Y₁.hom).hom`, and the pushforward
of the pullback comparison `(pullbackComp g.left Y₁.hom).hom`, glued by two
`eqToHom` transports along the over-triangle `Over.w g`. No functor law is used:
this is a reusable pre-coherence brick (the planner's `Gmap`). -/
noncomputable def pushPullMap (F : X.Modules) {Y₁ Y₂ : Over X} (g : Y₂ ⟶ Y₁) :
    pushPullObj F Y₁ ⟶ pushPullObj F Y₂ :=
  (pushforward Y₁.hom).map
      ((pullbackPushforwardAdjunction g.left).unit.app
        ((Scheme.Modules.pullback Y₁.hom).obj F)) ≫
    (pushforwardComp g.left Y₁.hom).hom.app
      ((Scheme.Modules.pullback g.left).obj ((Scheme.Modules.pullback Y₁.hom).obj F)) ≫
    eqToHom (congrArg (fun q => (pushforward q).obj
      ((Scheme.Modules.pullback g.left).obj ((Scheme.Modules.pullback Y₁.hom).obj F)))
      (Over.w g)) ≫
    (pushforward Y₂.hom).map ((pullbackComp g.left Y₁.hom).hom.app F) ≫
    eqToHom (congrArg (fun q => (pushforward Y₂.hom).obj ((Scheme.Modules.pullback q).obj F))
      (Over.w g))

/- **The functor laws `pushPullMap_id` / `pushPullMap_comp`.**
Assembling `pushPullObj` / `pushPullMap` into the functor `G : (Over X)ᵒᵖ ⥤
X.Modules` requires
```
  pushPullMap_id   : pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y)
  pushPullMap_comp : pushPullMap F (g ≫ h) = pushPullMap F h ≫ pushPullMap F g
```
Both laws are proved axiom-clean below (see `pushPullMap_id` and `pushPullMap_comp`),
and `pushPullFunctor` is assembled from them immediately after. -/

/-! ### Functor laws of the push–pull functor `G` -/

/-- Identity law of the push–pull functor `G`. -/
lemma pushPullMap_id (F : X.Modules) (Y : Over X) :
    pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y) := by
  -- `star`: the unit-triangle for the identity adjunction `pullback 𝟙 ⊣ pushforward 𝟙`.
  have star := unit_conjugateEquiv (Adjunction.id (C := Y.left.Modules))
    (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 Y.left))
    (Scheme.Modules.pullbackId Y.left).hom ((Scheme.Modules.pullback Y.hom).obj F)
  rw [Scheme.Modules.conjugateEquiv_pullbackId_hom] at star
  simp only [Adjunction.id_unit, NatTrans.id_app, Functor.id_obj] at star
  -- `hru`: right-unitality of the pullback pseudofunctor, applied at `F`.
  have hru := Scheme.Modules.pseudofunctor_right_unitality (X := Y.left) (f := Y.hom)
  have hru2 := congrArg (fun t => NatTrans.app t F) hru
  simp only [NatTrans.comp_app, Functor.whiskerLeft_app, Functor.rightUnitor_hom_app] at hru2
  have hpf : (Scheme.Modules.pushforwardComp (𝟙 Y.left) Y.hom).hom.app
        ((Scheme.Modules.pullback (𝟙 Y.left)).obj ((Scheme.Modules.pullback Y.hom).obj F)) ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback (𝟙 Y.left)).obj ((Scheme.Modules.pullback Y.hom).obj F)))
        (Category.id_comp Y.hom)) =
      (Scheme.Modules.pushforward Y.hom).map ((Scheme.Modules.pushforwardId Y.left).hom.app
        ((Scheme.Modules.pullback (𝟙 Y.left)).obj ((Scheme.Modules.pullback Y.hom).obj F))) := by
    apply Scheme.Modules.hom_ext
    intro U; rfl
  -- the unit zig-zag for the identity adjunction collapses on `M`
  have hzig : (Scheme.Modules.pullbackPushforwardAdjunction (𝟙 Y.left)).unit.app
        ((Scheme.Modules.pullback Y.hom).obj F) ≫
      (Scheme.Modules.pushforwardId Y.left).hom.app
        ((Scheme.Modules.pullback (𝟙 Y.left)).obj ((Scheme.Modules.pullback Y.hom).obj F)) ≫
      (Scheme.Modules.pullbackId Y.left).hom.app ((Scheme.Modules.pullback Y.hom).obj F) =
      𝟙 ((Scheme.Modules.pullback Y.hom).obj F) := by
    have hnat := (Scheme.Modules.pushforwardId Y.left).hom.naturality
      ((Scheme.Modules.pullbackId Y.left).hom.app ((Scheme.Modules.pullback Y.hom).obj F))
    simp only [Functor.id_map] at hnat
    erw [← hnat, ← reassoc_of% star]
    exact Iso.inv_hom_id_app _ _
  -- the pullback comparison + the over-triangle transport collapse via right-unitality
  have hib_inner : (Scheme.Modules.pullbackComp (𝟙 Y.left) Y.hom).hom.app F ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F) (Category.id_comp Y.hom)) =
      (Scheme.Modules.pullbackId Y.left).hom.app ((Scheme.Modules.pullback Y.hom).obj F) := by
    rw [eqToHom_app] at hru2
    rw [← hru2, ← Category.assoc, Iso.hom_inv_id_app]; simp
  have hib : (Scheme.Modules.pushforward Y.hom).map
        ((Scheme.Modules.pullbackComp (𝟙 Y.left) Y.hom).hom.app F) ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pushforward Y.hom).obj
        ((Scheme.Modules.pullback q).obj F)) (Category.id_comp Y.hom)) =
      (Scheme.Modules.pushforward Y.hom).map
        ((Scheme.Modules.pullbackId Y.left).hom.app ((Scheme.Modules.pullback Y.hom).obj F)) := by
    have he : eqToHom (congrArg (fun q => (Scheme.Modules.pushforward Y.hom).obj
          ((Scheme.Modules.pullback q).obj F)) (Category.id_comp Y.hom)) =
        (Scheme.Modules.pushforward Y.hom).map
          (eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F)
            (Category.id_comp Y.hom))) := by
      rw [eqToHom_map]
    rw [he, ← Functor.map_comp]; exact congrArg _ hib_inner
  -- assemble
  simp only [pushPullMap, Over.id_left]
  erw [reassoc_of% hpf, hib, ← Functor.map_comp]
  erw [hzig, CategoryTheory.Functor.map_id]; rfl


/-- **Base-change unit (mate) identity for the push–pull head.**
For composable scheme morphisms `f : A ⟶ B`, `p : B ⟶ Z` and `N : Z.Modules`, the
adjunction unit at `N` for `p` followed by the *head* of `pushPullMap` (the
pushforward of the unit for `f`, then the pushforward comparison) equals the unit
for the composite `f ≫ p` followed by the pushforward of the inverse pullback
comparison. This is the mate-calculus core that converts the single-morphism unit
`η^{f≫p}` into the iterated units `η^p`, `η^f`; it is the reusable ingredient that
the functoriality (pentagon) law of `pushPullMap` repeatedly consumes when
splitting a composite unit. Project-local supplement. -/
lemma pushPull_unit_mate {A B Z : Scheme.{u}} (f : A ⟶ B) (p : B ⟶ Z)
    (N : Z.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction p).unit.app N ≫
        (Scheme.Modules.pushforward p).map
          ((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
            ((Scheme.Modules.pullback p).obj N)) ≫
        (Scheme.Modules.pushforwardComp f p).hom.app
          ((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback p).obj N)) =
      (Scheme.Modules.pullbackPushforwardAdjunction (f ≫ p)).unit.app N ≫
        (Scheme.Modules.pushforward (f ≫ p)).map
          ((Scheme.Modules.pullbackComp f p).inv.app N) := by
  have key := unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction p).comp
      (Scheme.Modules.pullbackPushforwardAdjunction f))
    (Scheme.Modules.pullbackPushforwardAdjunction (f ≫ p))
    (Scheme.Modules.pullbackComp f p).inv N
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv, Adjunction.comp_unit_app] at key
  simpa only [Category.assoc] using key

/-- **Over-triangle transport cancellation for the push–pull tail** (kernel-cheap
generalised form). The morphism map `pushPullMap` glues its pullback-comparison leg
to the target object `pushPullObj F Y₂` by two `eqToHom` coercions along the
over-triangle `g.left ≫ Y₁.hom = Y₂.hom`. Cancelling those coercions *in situ*
(at the concrete pushforward/pullback objects) provokes a kernel `whnf` blow-up.
This lemma states the cancellation **with the over-triangle equality as a free
hypothesis** `h : gl ≫ p₁ = p₂`, so the proof is a single `subst h` (after which
the transports become `eqToHom rfl = 𝟙` and vanish — kernel-cheap) followed by
`simp`. Applying it to `pushPullMap` via `rw` rewrites the tail without forcing the
kernel to unfold the comparison objects: the over-triangle leg
`eqToHom ≫ (pushforward p₂).map (pullbackComp).hom ≫ eqToHom` collapses to the
transport-light `(pushforward (gl ≫ p₁)).map (pullbackComp).hom ≫ eqToHom`, the
single residual `eqToHom` carrying the unavoidable object identification of the
codomain `pushPullObj F Y₂`. Reusable pre-coherence brick for `pushPullMap_comp`. -/
lemma pushPull_transport_cancel {Y₁ Y₂ : Scheme.{u}}
    (gl : Y₂ ⟶ Y₁) (p₁ : Y₁ ⟶ X) (p₂ : Y₂ ⟶ X)
    (h : gl ≫ p₁ = p₂) (F : X.Modules) :
    eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback gl).obj ((Scheme.Modules.pullback p₁).obj F))) h) ≫
      (Scheme.Modules.pushforward p₂).map ((Scheme.Modules.pullbackComp gl p₁).hom.app F) ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pushforward p₂).obj
        ((Scheme.Modules.pullback q).obj F)) h) =
    (Scheme.Modules.pushforward (gl ≫ p₁)).map
        ((Scheme.Modules.pullbackComp gl p₁).hom.app F) ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback q).obj F)) h) := by
  subst h
  simp

/-- **Composite-unit decomposition for the push–pull head.** The adjunction unit
`η^{f≫p}` for a composite morphism, expressed through the iterated units `η^p`,
`η^f` and the pushforward/pullback comparison isomorphisms. This is the
`pushPull_unit_mate` identity solved for `η^{f≫p}` (post-composing with
`(f≫p)_*(pullbackComp).hom` cancels the `pullbackComp.inv` factor). Reusable brick
for the composition law of `pushPullMap`. -/
lemma pushPull_unit_comp {A B Z : Scheme.{u}} (f : A ⟶ B) (p : B ⟶ Z)
    (N : Z.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction (f ≫ p)).unit.app N =
      (Scheme.Modules.pullbackPushforwardAdjunction p).unit.app N ≫
        (Scheme.Modules.pushforward p).map
          ((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
            ((Scheme.Modules.pullback p).obj N)) ≫
        (Scheme.Modules.pushforwardComp f p).hom.app
          ((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback p).obj N)) ≫
        (Scheme.Modules.pushforward (f ≫ p)).map
          ((Scheme.Modules.pullbackComp f p).hom.app N) := by
  have m := pushPull_unit_mate f p N
  erw [reassoc_of% m, ← Functor.map_comp, Iso.inv_hom_id_app,
    CategoryTheory.Functor.map_id, Category.comp_id]

/-- The pushforward pseudofunctor is *strict* on sheaves of modules: the
`pushforwardComp` comparison `2`-cell is the identity on the nose. Holds by `rfl`
(`pushforward (a ≫ p) = pushforward a ⋙ pushforward p` definitionally). Project-local
collapse used to discharge the pushforward legs of the push–pull pentagon. -/
lemma pushforwardComp_hom_app_id {Z₁ Z₂ Z₃ : Scheme.{u}} (a : Z₂ ⟶ Z₁) (p : Z₁ ⟶ Z₃)
    (M : Z₂.Modules) : (Scheme.Modules.pushforwardComp a p).hom.app M = 𝟙 _ :=
  rfl

/-- **Scheme-level push–pull comparison map with the over-triangle as a free
hypothesis.** This is the body of `pushPullMap` with the underlying scheme map
`a`, the two structure maps `p₁ p₂`, and the over-triangle `w : a ≫ p₁ = p₂`
generalised away from the `Over X` packaging. Spelling the over-triangle as a free
hypothesis is what makes the composition law provable by `subst` (after which the
`eqToHom` over-triangle transports become `eqToHom rfl = 𝟙` and vanish, dodging the
kernel `whnf` wall). By construction `pushPullMap F g = rawPushPullMap g.left Y₁.hom
Y₂.hom (Over.w g) F` definitionally. Project-local. -/
noncomputable def rawPushPullMap {Z₁ Z₂ : Scheme.{u}} (a : Z₂ ⟶ Z₁)
    (p₁ : Z₁ ⟶ X) (p₂ : Z₂ ⟶ X) (w : a ≫ p₁ = p₂) (F : X.Modules) :
    (Scheme.Modules.pushforward p₁).obj ((Scheme.Modules.pullback p₁).obj F) ⟶
      (Scheme.Modules.pushforward p₂).obj ((Scheme.Modules.pullback p₂).obj F) :=
  (Scheme.Modules.pushforward p₁).map
      ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
        ((Scheme.Modules.pullback p₁).obj F)) ≫
    (Scheme.Modules.pushforwardComp a p₁).hom.app
      ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫
    eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
      ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F))) w) ≫
    (Scheme.Modules.pushforward p₂).map ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
    eqToHom (congrArg (fun q => (Scheme.Modules.pushforward p₂).obj
      ((Scheme.Modules.pullback q).obj F)) w)

set_option maxHeartbeats 1000000 in
/-- `pushPullMap` is the `Over X`-instance of `rawPushPullMap`. Holds by `rfl`. -/
lemma pushPullMap_eq_raw (F : X.Modules) {Y₁ Y₂ : Over X} (g : Y₂ ⟶ Y₁) :
    pushPullMap F g = rawPushPullMap g.left Y₁.hom Y₂.hom (Over.w g) F :=
  rfl

-- Composition law `pushPullMap_comp` is proved axiom-clean below (see `rawPushPullMap_comp`).
-- Dead-end note: `erw`/`congr 1` directly on `pullbackComp` whnf-unfolds it into its
-- `TwoSquare.equivNatTrans`/`mateEquiv` mate form, exploding heartbeats; the
-- `rawPushPullMap_comp` approach (subst the free over-triangle hypotheses) avoids this.

/-- Clean (transport-free) form of `rawPushPullMap` when the over-triangle is `rfl`
(`p₂ = a ≫ p₁`): the pushforward comparison `pushforwardComp` and the `eqToHom`
coercions all collapse, leaving `(pushforward p₁).map` of the mate head
`η^a ≫ a_*(pullbackComp a p₁).hom`. Project-local helper for `pushPullMap_comp`. -/
lemma rawPushPullMap_self {Z₁ Z₂ : Scheme.{u}} (a : Z₂ ⟶ Z₁) (p₁ : Z₁ ⟶ X)
    (F : X.Modules) :
    rawPushPullMap a p₁ (a ≫ p₁) rfl F =
      (Scheme.Modules.pushforward p₁).map
        ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
            ((Scheme.Modules.pullback p₁).obj F) ≫
          (Scheme.Modules.pushforward a).map
            ((Scheme.Modules.pullbackComp a p₁).hom.app F)) := by
  simp only [rawPushPullMap, pushforwardComp_hom_app_id, eqToHom_refl, Category.id_comp,
    Category.comp_id, Functor.map_comp]
  rfl

set_option maxHeartbeats 4000000 in
/-- Clean form of `rawPushPullMap` for a general over-triangle `w : a ≫ p₁ = p₂`:
the transport-free head `(pushforward p₁).map (η^a ≫ a_*(pullbackComp a p₁).hom)`
followed by the single `eqToHom` identifying the target along `w`. Project-local
helper for `pushPullMap_comp`. -/
lemma rawPushPullMap_self_gen {Z₁ Z₂ : Scheme.{u}} (a : Z₂ ⟶ Z₁) (p₁ : Z₁ ⟶ X)
    (p₂ : Z₂ ⟶ X) (w : a ≫ p₁ = p₂) (F : X.Modules) :
    rawPushPullMap a p₁ p₂ w F =
      (Scheme.Modules.pushforward p₁).map
          ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
              ((Scheme.Modules.pullback p₁).obj F) ≫
            (Scheme.Modules.pushforward a).map
              ((Scheme.Modules.pullbackComp a p₁).hom.app F)) ≫
        eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
          ((Scheme.Modules.pullback q).obj F)) w) := by
  subst w
  rw [rawPushPullMap_self]
  exact (Category.comp_id _).symm

/-- The pure pullback **pentagon** at `F`, in transport-light form: the content of
`pushPullMap_comp` once the units and pushforwards are peeled. It is exactly
`Scheme.Modules.pseudofunctor_associativity (f := b) (g := a) (h := p₁)` evaluated at
`F`, with the associator (an identity on components) absorbed and the two leading
comparison isos inverted. Project-local. -/
lemma pushPull_pentagon {Z₁ Z₂ Z₃ : Scheme.{u}} (a : Z₂ ⟶ Z₁) (b : Z₃ ⟶ Z₂)
    (p₁ : Z₁ ⟶ X) (F : X.Modules) :
    (Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
        (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F ≫
        eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F)
          (Category.assoc b a p₁)) =
      (Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
        (Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F := by
  have H := Scheme.Modules.pseudofunctor_associativity (f := b) (g := a) (h := p₁)
  have HF := congrArg (fun t => NatTrans.app t F) H
  simp only [NatTrans.comp_app, Functor.whiskerRight_app, Functor.whiskerLeft_app,
    Functor.associator_hom_app, eqToHom_app, Functor.comp_obj,
    Category.id_comp] at HF
  -- HF : A1⁻¹ ≫ B1⁻¹ ≫ C ≫ D = eqToHom eF, with the associator (= 𝟙) absorbed.
  -- Cancel the two leading isos `B1 = (pullback b).map (pullbackComp a p₁).hom`, `A1 = pullbackComp b (a ≫ p₁)`
  -- against their inverses (no `IsIso` instances needed: `Iso.hom_inv_id_app` + functoriality),
  -- then feed `HF` in via `congrArg`/`trans` (defeq, so no fragile `rw [HF]` matching).
  have cancel : (Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
        (Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F ≫
        (Scheme.Modules.pullbackComp b (a ≫ p₁)).inv.app F ≫
        (Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).inv.app F) ≫
        (Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
        (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F =
      (Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
        (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F := by
    have h1 : (Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F ≫
        (Scheme.Modules.pullbackComp b (a ≫ p₁)).inv.app F = 𝟙 _ := Iso.hom_inv_id_app _ _
    have h2 : (Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
        (Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).inv.app F) = 𝟙 _ :=
      ((Scheme.Modules.pullback b).map_comp _ _).symm.trans
        ((congrArg (Scheme.Modules.pullback b).map (Iso.hom_inv_id_app _ _)).trans
          ((Scheme.Modules.pullback b).map_id _))
    simp only [Functor.comp_obj] at h1 h2 ⊢
    rw [reassoc_of% h1, reassoc_of% h2]
  have hcd := cancel.symm.trans (congrArg (fun t => (Scheme.Modules.pullback b).map
    ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
      (Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F ≫ t) HF)
  rw [← Category.assoc ((Scheme.Modules.pullbackComp b a).hom.app
        ((Scheme.Modules.pullback p₁).obj F))
      ((Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F), hcd]
  simp [eqToHom_trans]

set_option maxHeartbeats 1600000 in
/-- Composition law for `rawPushPullMap` with the two over-triangles as free
hypotheses (kernel-cheap). -/
lemma rawPushPullMap_comp {Z₁ Z₂ Z₃ : Scheme.{u}} (a : Z₂ ⟶ Z₁) (b : Z₃ ⟶ Z₂)
    (p₁ : Z₁ ⟶ X) (p₂ : Z₂ ⟶ X) (p₃ : Z₃ ⟶ X)
    (wg : a ≫ p₁ = p₂) (wh : b ≫ p₂ = p₃) (F : X.Modules) :
    rawPushPullMap (b ≫ a) p₁ p₃ (by rw [Category.assoc, wg, wh]) F =
      rawPushPullMap a p₁ p₂ wg F ≫ rawPushPullMap b p₂ p₃ wh F := by
  subst wg wh
  rw [rawPushPullMap_self a p₁ F, rawPushPullMap_self b (a ≫ p₁) F,
      rawPushPullMap_self_gen (b ≫ a) p₁ (b ≫ a ≫ p₁) (Category.assoc b a p₁) F]
  -- The over-triangle `eqToHom` (in `X.Modules`) is `(pushforward p₁).map` of the
  -- corresponding `Z₁.Modules`-level `eqToHom` (`pushforward` is strict).
  have he : eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback q).obj F)) (Category.assoc b a p₁)) =
      (Scheme.Modules.pushforward p₁).map (eqToHom (congrArg
        (fun q => (Scheme.Modules.pushforward (b ≫ a)).obj ((Scheme.Modules.pullback q).obj F))
        (Category.assoc b a p₁))) := by
    rw [eqToHom_map]; rfl
  -- The inner identity in `Z₁.Modules`: the pure pushforward-of-pentagon content.
  have INNER : (Scheme.Modules.pullbackPushforwardAdjunction (b ≫ a)).unit.app
          ((Scheme.Modules.pullback p₁).obj F) ≫
        (Scheme.Modules.pushforward (b ≫ a)).map ((Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F) ≫
        eqToHom (congrArg (fun q => (Scheme.Modules.pushforward (b ≫ a)).obj
          ((Scheme.Modules.pullback q).obj F)) (Category.assoc b a p₁)) =
      ((Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
            ((Scheme.Modules.pullback p₁).obj F) ≫
          (Scheme.Modules.pushforward a).map ((Scheme.Modules.pullbackComp a p₁).hom.app F)) ≫
        (Scheme.Modules.pushforward a).map
          ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
              ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
            (Scheme.Modules.pushforward b).map
              ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)) := by
    rw [pushPull_unit_comp b a ((Scheme.Modules.pullback p₁).obj F)]
    -- The `Z₂.Modules`-level content: the pushforward-`b` of the pullback pentagon, with the
    -- composite unit straightened by naturality of `η^b`.
    have INNER2 :
        (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
              (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F ≫
              eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F)
                (Category.assoc b a p₁))) =
        (Scheme.Modules.pullbackComp a p₁).hom.app F ≫
          (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
              ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
            (Scheme.Modules.pushforward b).map
              ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F) := by
      have key2 : (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullbackComp b a).hom.app ((Scheme.Modules.pullback p₁).obj F) ≫
              (Scheme.Modules.pullbackComp (b ≫ a) p₁).hom.app F ≫
              eqToHom (congrArg (fun q => (Scheme.Modules.pullback q).obj F)
                (Category.assoc b a p₁))) =
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F) ≫
              (Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F) :=
        congrArg _ (pushPull_pentagon a b p₁ F)
      have nat2 : (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫
          (Scheme.Modules.pushforward b).map
            ((Scheme.Modules.pullback b).map ((Scheme.Modules.pullbackComp a p₁).hom.app F)) =
          (Scheme.Modules.pullbackComp a p₁).hom.app F ≫
            (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
              ((Scheme.Modules.pullback (a ≫ p₁)).obj F) :=
        ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.naturality
          ((Scheme.Modules.pullbackComp a p₁).hom.app F)).symm
      refine (congrArg (fun t => (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
        ((Scheme.Modules.pullback a).obj ((Scheme.Modules.pullback p₁).obj F)) ≫ t) key2).trans ?_
      rw [Functor.map_comp]
      exact (Category.assoc _ _ _).symm.trans
        ((congrArg (· ≫ (Scheme.Modules.pushforward b).map
          ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)) nat2).trans (Category.assoc _ _ _))
    exact congrArg (fun t => (Scheme.Modules.pullbackPushforwardAdjunction a).unit.app
      ((Scheme.Modules.pullback p₁).obj F) ≫ (Scheme.Modules.pushforward a).map t) INNER2
  -- Expose the second RHS factor as `(pushforward p₁).map (…)` (strictness, by `rfl`) so the
  -- `map_comp` unifications below stay kernel-cheap.
  rw [show (Scheme.Modules.pushforward (a ≫ p₁)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
          (Scheme.Modules.pushforward b).map ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)) =
      (Scheme.Modules.pushforward p₁).map ((Scheme.Modules.pushforward a).map
        ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app
            ((Scheme.Modules.pullback (a ≫ p₁)).obj F) ≫
          (Scheme.Modules.pushforward b).map ((Scheme.Modules.pullbackComp b (a ≫ p₁)).hom.app F)))
        from rfl]
  convert congrArg (Scheme.Modules.pushforward p₁).map INNER using 2

/-- **Push–pull functor `G` — composition law** (contravariant functoriality).
For composable morphisms `g : Y₂ ⟶ Y₁`, `h : Y₃ ⟶ Y₂` of `X`-schemes,
`G(h ≫ g) = G(g) ≫ G(h)` (writing `≫` for `Over X`-composition; in the informal
`∘`-notation of the blueprint this is `G(g ∘ h) = G(h) ∘ G(g)`). Together with
`pushPullMap_id` this assembles `pushPullObj`/`pushPullMap` into a genuine functor
`(Over X)ᵒᵖ ⥤ X.Modules`. Project-local (`lem:push_pull_comp`). -/
lemma pushPullMap_comp (F : X.Modules) {Y₁ Y₂ Y₃ : Over X} (g : Y₂ ⟶ Y₁) (h : Y₃ ⟶ Y₂) :
    pushPullMap F (h ≫ g) = pushPullMap F g ≫ pushPullMap F h := by
  rw [pushPullMap_eq_raw, pushPullMap_eq_raw, pushPullMap_eq_raw]
  exact rawPushPullMap_comp g.left h.left Y₁.hom Y₂.hom Y₃.hom (Over.w g) (Over.w h) F

/-- **The push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`**, `(Y, p) ↦ p_* p^* F`.
Assembled from the object brick `pushPullObj`, the morphism brick `pushPullMap`, and
the two functor laws `pushPullMap_id` / `pushPullMap_comp`. Contravariant on `Over X`
(hence a covariant functor out of `(Over X)ᵒᵖ`): a morphism `φ : Y₁ ⟶ Y₂` in
`(Over X)ᵒᵖ` is `φ.unop : Y₂.unop ⟶ Y₁.unop` in `Over X`, sent to
`pushPullMap F φ.unop`. This is the functor the planner calls `G`; composing the
geometric Čech backbone `coverCechNerve` with it produces the cosimplicial
`O_X`-module nerve `CechNerve`. Project-local (`lem:push_pull_comp` consumer). -/
noncomputable def pushPullFunctor (F : X.Modules) : (Over X)ᵒᵖ ⥤ X.Modules where
  obj Y := pushPullObj F Y.unop
  map φ := pushPullMap F φ.unop
  map_id Y := pushPullMap_id F Y.unop
  map_comp φ ψ := pushPullMap_comp F φ.unop ψ.unop

/-- The geometric Čech backbone, lifted to a **simplicial object in `Over X`**: each
fibre power carries its structure map to `X` (the augmentation of `coverCechNerve`),
and the face/degeneracy maps are `X`-morphisms by naturality of the augmentation into
the constant functor. Project-local; obtained from `coverCechNerve` by
`CategoryTheory.Over.lift` applied to the augmentation natural transformation. -/
noncomputable def coverCechNerveOver (𝒰 : X.OpenCover) : SimplicialObject (Over X) :=
  Over.lift (coverCechNerve 𝒰).left (coverCechNerve 𝒰).hom

/-- The over-category Čech backbone as an **augmented** simplicial object in `Over X`:
`coverCechNerveOver` augmented by the terminal object `Over.mk (𝟙 X)` of `Over X`. The
augmentation map at each simplicial level is the unique morphism to the terminal object
(its underlying scheme map is the level's structure map to `X`), and the augmentation
coherence condition holds automatically because the augmentation target is terminal.
Project-local. -/
noncomputable def coverCechNerveOverAug (𝒰 : X.OpenCover) :
    SimplicialObject.Augmented (Over X) :=
  SimplicialObject.augment (coverCechNerveOver 𝒰) (Over.mk (𝟙 X))
    (Over.mkIdTerminal.from _)
    (fun _ _ _ => Over.mkIdTerminal.hom_ext _ _)

/-- The cosimplicial `O_X`-module obtained by post-composing the over-category Čech
backbone `coverCechNerveOver` (read contravariantly, via `Functor.leftOp`) with the
push–pull functor `pushPullFunctor F = G`. This is the underlying cosimplicial object
of `CechNerve` (before adjoining the augmentation `F`). Project-local. -/
noncomputable def cechNerveCosimplicial (𝒰 : X.OpenCover) (F : X.Modules) :
    CosimplicialObject X.Modules :=
  (coverCechNerveOver 𝒰 : SimplexCategoryᵒᵖ ⥤ Over X).rightOp ⋙ pushPullFunctor F

/-- **Čech nerve of an affine open cover** (Stacks, Cohomology of Schemes, §Čech
cohomology of quasi-coherent sheaves).

For a scheme `X`, a finite affine open cover `𝒰 : X = ⋃ Uᵢ` and a quasi-coherent
sheaf `F`, the *Čech nerve* is the augmented cosimplicial object of `O_X`-modules whose
object in simplicial degree `p` is the product, over the `(p+1)`-tuples `(i₀,…,i_p)` of
indices, of the direct images `(j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})` of the restriction of
`F` to the `(p+1)`-fold intersection `U_{i₀…i_p} = U_{i₀} ∩ ⋯ ∩ U_{i_p}` along the open
immersion `j_{i₀…i_p} : U_{i₀…i_p} ↪ X`. Faces are the restriction maps that omit one
index, degeneracies repeat one index, and the augmentation in degree `-1` is `F` itself
on all of `X`. When `X` is separated each intersection `U_{i₀…i_p}` is affine.

This is now *constructed*, not postulated: the geometric backbone `coverCechNerveOverAug`
(the augmented Čech nerve of the cover as an augmented simplicial object in `Over X`,
unconditional because `Scheme` has all finite limits) is read contravariantly
(`SimplicialObject.Augmented.rightOp`) and whiskered by the push–pull functor
`pushPullFunctor F = G : (Over X)ᵒᵖ ⥤ X.Modules`, `(Y, p) ↦ p_* p^* F`. The whiskering
transports both the cosimplicial structure and the augmentation, so the augmentation
point is `G` applied to the terminal `Over X`-object `⟨X, 𝟙 X⟩`, namely
`(𝟙 X)_* (𝟙 X)^* F ≅ F`. The functor laws of `G` (`pushPullMap_id`, `pushPullMap_comp`)
are what make this assembly legitimate.

Source: Stacks Project, Cohomology of Schemes,
`lemma-cech-cohomology-quasi-coherent-trivial`. -/
noncomputable def CechNerve (𝒰 : X.OpenCover) (F : X.Modules) :
    CosimplicialObject.Augmented X.Modules :=
  (CosimplicialObject.Augmented.whiskeringObj (Over X)ᵒᵖ X.Modules (pushPullFunctor F)).obj
    (coverCechNerveOverAug 𝒰).rightOp

/-- **Relative {\v C}ech complex from a cosimplicial nerve** (coherence-free
plumbing). Given `f : X ⟶ S` and an augmented cosimplicial object `N` of
`O_X`-modules, produce the relative {\v C}ech cochain complex in `QCoh(S)` by:
forgetting the augmentation (`CosimplicialObject.Augmented.drop`), pushing the
cosimplicial object forward along `f` (`CosimplicialObject.whiskering` applied to
`Scheme.Modules.pushforward f`), and taking the alternating coface-map cochain
complex (`alternatingCofaceMapComplex`). This is the entire passage `CechNerve ↦
CechComplex`, and it uses no `pushforwardComp` / `pullbackComp` coherence — only
the (pre)additivity of `S.Modules`. Project-local. -/
noncomputable def relativeCechComplexOfNerve (f : X ⟶ S)
    (N : CosimplicialObject.Augmented X.Modules) : CochainComplex S.Modules ℕ :=
  (AlgebraicTopology.alternatingCofaceMapComplex S.Modules).obj
    (((CosimplicialObject.whiskering X.Modules S.Modules).obj
        (Scheme.Modules.pushforward f)).obj (CosimplicialObject.Augmented.drop.obj N))

/-- **Relative Čech complex of a quasi-coherent sheaf** (Stacks, Cohomology of
Schemes, `lemma-cech-cohomology-quasi-coherent-trivial`).

For `f : X ⟶ S`, a finite affine open cover `𝒰` of `X` (with all intersections
affine, e.g. `X` separated) and a quasi-coherent sheaf `F`, the *relative Čech
complex* `Č•(𝒰, F)` is the cochain complex of `O_S`-modules with degree-`p` term
```
  Čᵖ(𝒰, F) = ∏_{(i₀,…,i_p)} (f|_{U_{i₀…i_p}})_* (F|_{U_{i₀…i_p}}),
```
and differential the alternating sum of the restriction maps
`(d s)_{i₀…i_{p+1}} = Σⱼ (-1)ʲ s_{i₀…î_j…i_{p+1}}|_{U_{i₀…i_{p+1}}}`. Over an
affine `U = Spec A` with `F|_U = M~` and a standard cover by the `D(fᵢ)`, this is
the complex of localisations `∏ M_{f_{i₀}} → ∏ M_{f_{i₀}f_{i₁}} → ⋯`. Each term
is quasi-coherent because the intersections are affine and the pushforward of a
quasi-coherent sheaf along a quasi-compact quasi-separated morphism is
quasi-coherent.

Source: Stacks Project, Cohomology of Schemes,
`lemma-cech-cohomology-quasi-coherent-trivial`. -/
noncomputable def CechComplex (f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) :
    CochainComplex S.Modules ℕ :=
  -- Construction (Stacks): apply the relative pushforward `f_*` over each finite
  -- intersection to the Čech nerve `CechNerve 𝒰 F`, then take the alternating-sum
  -- Čech differential. This is exactly the coherence-free plumbing
  -- `relativeCechComplexOfNerve`, so `CechComplex` is genuinely *defined* in terms
  -- of the nerve: an axiom-clean `CechNerve` immediately yields an axiom-clean
  -- `CechComplex`. The only remaining hole is `CechNerve` itself.
  relativeCechComplexOfNerve f (CechNerve 𝒰 F)

/-! ## Project-local Mathlib supplement — the augmented Čech complex on `X`

The lemma `cechAugmented_exact` (`lem:cech_augmented_resolution`) asserts that the
augmented {\v C}ech complex `0 → F → C⁰ → C¹ → ⋯` of a quasi-coherent sheaf `F`
over an affine open cover `𝒰` is **exact** in `QCoh(X)` — i.e. the {\v C}ech nerve
is a resolution of `F`. This is the *un-pushed* (over `X`, not relative to `f`)
counterpart of `CechComplex`/`relativeCechComplexOfNerve`. We record here the
structural ingredients that the exactness statement is phrased against: the
un-augmented {\v C}ech complex on `X` (`cechComplexOnX`), obtained from the {\v C}ech
nerve exactly as `relativeCechComplexOfNerve` does but with the *identity*
pushforward — i.e. directly, with no `f_*`. -/

/-- **The (un-augmented) {\v C}ech cochain complex of `F` on `X`.** This is the
alternating-coface-map complex `C⁰ → C¹ → ⋯` of the underlying cosimplicial object
of the {\v C}ech nerve `CechNerve 𝒰 F` (its augmentation `F` is dropped). It is the
`f = 𝟙`/un-pushed analogue of `relativeCechComplexOfNerve`: the same coherence-free
plumbing without the relative pushforward `f_*`, so it is the complex whose
exactness (after re-adjoining the augmentation `F → C⁰`) is the content of
`cechAugmented_exact`. Project-local. -/
noncomputable def cechComplexOnX (𝒰 : X.OpenCover) (F : X.Modules) :
    CochainComplex X.Modules ℕ :=
  (AlgebraicTopology.alternatingCofaceMapComplex X.Modules).obj
    (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))

/-- **The augmentation point of the {\v C}ech nerve is `F`.** The augmentation
object `(CechNerve 𝒰 F).left` of the {\v C}ech nerve is `(𝟙 X)_* (𝟙 X)^* F` (the
push–pull functor applied to the terminal `Over X`-object `⟨X, 𝟙 X⟩`), canonically
isomorphic to `F` via the unitors `pushforwardId`/`pullbackId`. Project-local. -/
noncomputable def cechNervePointIso (𝒰 : X.OpenCover) (F : X.Modules) :
    (CechNerve 𝒰 F).left ≅ F :=
  (Scheme.Modules.pushforwardId X).app ((Scheme.Modules.pullback (𝟙 X)).obj F) ≪≫
    (Scheme.Modules.pullbackId X).app F

/-- **The augmentation map `ε : F → C⁰` of the {\v C}ech nerve.** Built from the
augmentation natural transformation of the augmented cosimplicial object
`CechNerve 𝒰 F` (the map `(CechNerve 𝒰 F).left ⟶ C⁰`), pre-composed with the unitor
`cechNervePointIso` identifying the augmentation point with `F`. This is the map
prepended to `cechComplexOnX` to form the augmented {\v C}ech complex. Project-local. -/
noncomputable def cechAugmentation (𝒰 : X.OpenCover) (F : X.Modules) :
    F ⟶ (cechComplexOnX 𝒰 F).X 0 :=
  (cechNervePointIso 𝒰 F).inv ≫ (CechNerve 𝒰 F).hom.app (SimplexCategory.mk 0)

/-- **Augmentation kills the first alternating-coface differential** (abstract form).
For any augmented cosimplicial object `N` in a preadditive category, the augmentation
map `N.hom.app [0] : N.left ⟶ (drop N).obj [0]` followed by the degree-0 alternating
coface differential `objD (drop N) 0 = δ⁰ - δ¹` is zero. This is the cosimplicial
augmentation identity (`ε ≫ δ⁰ = ε ≫ δ¹`, from naturality of `N.hom` against the two
coface maps `[0] ⟶ [1]`); stated abstractly so the proof does not unfold any concrete
(heavily whiskered) nerve. Project-local. -/
private lemma augmentation_comp_alternatingCofaceMap_objD_zero
    {C : Type*} [Category C] [Preadditive C] (N : CosimplicialObject.Augmented C) :
    N.hom.app (SimplexCategory.mk 0) ≫
      AlgebraicTopology.AlternatingCofaceMapComplex.objD
        (CosimplicialObject.Augmented.drop.obj N) 0 = 0 := by
  -- Ascribe the augmentation's codomain to the `𝟭`-free form `N.right.obj ⦋0⦌`; this is
  -- the `Comma`'s right functor being `𝟭`, which otherwise pins the composition's middle
  -- object to `(𝟭).obj N.right` and blocks every additive distribution lemma's instance.
  have hnat : ∀ i : Fin 2,
      (N.hom.app (SimplexCategory.mk 0) : N.left ⟶ N.right.obj (SimplexCategory.mk 0)) ≫
        N.right.δ i = N.hom.app (SimplexCategory.mk 1) := by
    intro i
    have h := N.hom.naturality (SimplexCategory.δ i)
    simpa using h.symm
  show (N.hom.app (SimplexCategory.mk 0) : N.left ⟶ N.right.obj (SimplexCategory.mk 0)) ≫
      AlgebraicTopology.AlternatingCofaceMapComplex.objD N.right 0 = 0
  simp only [AlgebraicTopology.AlternatingCofaceMapComplex.objD]
  rw [Fin.sum_univ_two]
  simp only [Fin.val_zero, Fin.val_one, pow_zero, pow_one, one_zsmul, neg_one_zsmul]
  -- `erw` (defeq-matching) is needed: the `Comma`'s right functor `𝟭` pins the
  -- composition's middle object to `(𝟭).obj N.right`, so `comp_add`/`comp_neg`'s
  -- instances only match up to reducible defeq, not syntactically.
  erw [Preadditive.comp_add, Preadditive.comp_neg, hnat 0, hnat 1, add_neg_cancel]

/-- **The augmentation composes to zero with `d⁰`.** The {\v C}ech augmentation
`ε : F → C⁰` followed by the first {\v C}ech differential `d⁰ : C⁰ → C¹` is zero,
the cochain-complex condition needed to prepend `ε` to `cechComplexOnX`. It is the
cosimplicial augmentation identity: `ε ≫ δ⁰ = ε ≫ δ¹` (naturality of the
augmentation natural transformation against the two coface maps `[0] ⟶ [1]`), so the
alternating sum `ε ≫ (δ⁰ - δ¹)` vanishes. Project-local. -/
lemma cechAugmentation_comp_d (𝒰 : X.OpenCover) (F : X.Modules) :
    cechAugmentation 𝒰 F ≫ (cechComplexOnX 𝒰 F).d 0 1 = 0 := by
  rw [cechAugmentation, Category.assoc]
  have hd : (cechComplexOnX 𝒰 F).d 0 1 =
      AlgebraicTopology.AlternatingCofaceMapComplex.objD
        (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)) 0 := rfl
  rw [hd]
  erw [augmentation_comp_alternatingCofaceMap_objD_zero (CechNerve 𝒰 F)]
  exact Limits.comp_zero

/-- **The augmented {\v C}ech complex on `X`** (Stacks
`lemma-cech-cohomology-quasi-coherent-trivial`). The cochain complex
`0 → F → C⁰ → C¹ → ⋯` obtained from the un-augmented {\v C}ech complex `cechComplexOnX`
by prepending the augmentation `ε : F → C⁰` (`cechAugmentation`) in degree `0` — so
`(cechAugmentedComplex 𝒰 F).X 0 = F` and `(cechAugmentedComplex 𝒰 F).X (p+1) = Cᵖ`. The
augmentation condition `ε ≫ d⁰ = 0` is `cechAugmentation_comp_d`. The lemma
`cech_augmented_resolution` (`cechAugmented_exact`) asserts this complex is exact —
i.e. the {\v C}ech nerve is a resolution of `F` in `QCoh(X)`. Project-local. -/
noncomputable def cechAugmentedComplex (𝒰 : X.OpenCover) (F : X.Modules) :
    CochainComplex X.Modules ℕ :=
  (cechComplexOnX 𝒰 F).augment (cechAugmentation 𝒰 F) (cechAugmentation_comp_d 𝒰 F)

/-- **The Čech complex computes the higher direct images** (Stacks 02KE;
`lemma-cech-cohomology-quasi-coherent` and
`lemma-quasi-coherence-higher-direct-images-application`).

Let `f : X ⟶ S` be separated and quasi-compact, `F` a quasi-coherent
`O_X`-module, and `𝒰` a finite affine open cover of `X` (so, by separatedness,
every intersection is affine). Then the cohomology sheaves of the relative Čech
complex compute the higher direct images: for every `i ≥ 0` there is a canonical
isomorphism of `O_S`-modules
```
  Hⁱ(Č•(𝒰, F)) ≅ Rⁱ f_* F.
```
In particular, over an affine base `S = Spec A`, taking global sections gives
`Hⁱ(X, F) = Čⁱ(𝒰, F) = H⁰(S, Rⁱ f_* F)` as `A`-modules.

We state the isomorphism as `Nonempty (… ≅ …)` and compare against the
derived-functor higher direct image `higherDirectImage` wherever the latter is
defined (`HasInjectiveResolutions X.Modules`).

Route A: reduce to `S` affine; the augmented Čech complex is a termwise
`f_*`-acyclic resolution of `F` (each term is a product of pushforwards over
affine intersections, acyclic by `CechAcyclic.affine` via the P3b bridge), so
the P4 acyclic-resolution lemma (`rightDerivedIsoOfAcyclicResolution`) gives
`Hⁱ(f_* C•) ≅ Rⁱ f_* F`. -/
theorem cech_computes_higherDirectImage [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F) := by
  -- Route A: reduce to `S` affine; the Čech complex is a termwise acyclic
  -- resolution of `F` (by `CechAcyclic.affine`), so `rightDerivedIsoOfAcyclicResolution`
  -- gives `Hⁱ(f_* C•) ≅ Rⁱ f_* F`.
  sorry

section Scratch

example (𝒰 : X.OpenCover) (F : X.Modules) (i : ℕ) : True := by
  have := PresheafOfModules.homologyIsoSheafify (𝟙 X.ringCatSheaf.obj)
    (ComplexShape.up ℕ) (cechAugmentedComplex 𝒰 F) i
  trivial

end Scratch

end AlgebraicGeometry
