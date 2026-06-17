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
* `AlgebraicGeometry.cechHigherDirectImage` — the **unconditional** `i`-th higher
  direct image, defined as the `i`-th cohomology sheaf of the relative Čech
  complex (no enough-injectives hypothesis required).
* `AlgebraicGeometry.cech_flatBaseChange` — flat base change for the
  unconditional Čech higher direct images.

See `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

Source: Stacks Project, Cohomology of Schemes, §Čech cohomology of quasi-coherent
sheaves and §Quasi-coherence of higher direct images; Tags 02KE
(`lemma-cech-cohomology-quasi-coherent`), 02KG
(`lemma-quasi-coherent-affine-cohomology-zero`), 02KH
(`lemma-flat-base-change-cohomology`).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {S S' X X' : Scheme.{u}}

/-- **Čech nerve of an affine open cover** (Stacks, Cohomology of Schemes, §Čech
cohomology of quasi-coherent sheaves).

For a scheme `X`, a finite affine open cover `𝒰 : X = ⋃ Uᵢ` and a quasi-coherent
sheaf `F`, the *Čech nerve* is the augmented cosimplicial object of
`O_X`-modules whose object in simplicial degree `p` is the product, over the
`(p+1)`-tuples `(i₀,…,i_p)` of indices, of the direct images
`(j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})` of the restriction of `F` to the
`(p+1)`-fold intersection `U_{i₀…i_p} = U_{i₀} ∩ ⋯ ∩ U_{i_p}` along the open
immersion `j_{i₀…i_p} : U_{i₀…i_p} ↪ X`. Faces are the restriction maps that
omit one index, degeneracies repeat one index, and the augmentation in degree
`-1` is `F` itself on all of `X`. When `X` is separated each intersection
`U_{i₀…i_p}` is affine.

Source: Stacks Project, Cohomology of Schemes,
`lemma-cech-cohomology-quasi-coherent-trivial`. -/
noncomputable def CechNerve (𝒰 : X.OpenCover) (F : X.Modules) :
    CosimplicialObject.Augmented X.Modules :=
  -- Construction (Stacks): the augmented cosimplicial object
  -- `[p] ↦ ∏_{(i₀,…,i_p)} (j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})` with faces the
  -- index-omitting restriction maps, degeneracies the index-repeating maps, and
  -- augmentation `F`. Requires the nerve of the cover (intersection products of
  -- pushforwards) as a functor out of `SimplexCategory`, currently absent from
  -- Mathlib for `Scheme.Modules`.
  sorry

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
  pushPullMap_id   : pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y)          -- DONE (below)
  pushPullMap_comp : pushPullMap F (g ≫ h) = pushPullMap F h ≫ pushPullMap F g  -- remaining
```
Both are pure pushforward/pullback *coherence* statements with no sectionwise
content of their own. The route is the adjunction-mate calculus: the
`unit ≫ pushforwardComp.hom` head of `pushPullMap` is governed by `unit_conjugateEquiv`
and `conjugateEquiv_pullbackComp_inv` / `conjugateEquiv_pullbackId_hom`, and the `eqToHom`
transports are discharged against the pseudofunctor unitor/pentagon identities
(`pseudofunctor_right_unitality` for `id`, `pseudofunctor_associativity` for `comp`, all in
`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`).

`pushPullMap_id` is closed axiom-clean below. A plain `simp` (even with the coherence lemmas)
makes no progress on the head `unit ≫ pushforwardComp.hom`, and the sectionwise `ext` route
exposes the pullback adjunction unit (not sectionwise trivial); the working proof instead routes
through `unit_conjugateEquiv` of the identity adjunction (`star`), the right-unitality of the
pullback comparison (`hru`), and a `Scheme.Modules.hom_ext; intro U; rfl` collapse of the
sectionwise-trivial pushforward coercion (`hpf`). `pushPullMap_comp` follows the same template
with `pseudofunctor_associativity` (the pentagon) in place of right-unitality — see the comment
above its (currently unfilled) statement. -/

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

/- **Composition law of the push–pull functor `G` (contravariant) — remaining.**
The identity law `pushPullMap_id` above is closed axiom-clean by the mate calculus
(`unit_conjugateEquiv` + `conjugateEquiv_pullbackId_hom` + `pseudofunctor_right_unitality`).
The composition law
```
  pushPullMap_comp : pushPullMap F (g ≫ h) = pushPullMap F h ≫ pushPullMap F g
```
follows the *same* template one step up — but with the pentagon
`Scheme.Modules.pseudofunctor_associativity (f := g.left) (g := h.left) (h := Y₁.hom)`
(verified to typecheck) in place of `pseudofunctor_right_unitality`, the composite-adjunction
unit expansion `Adjunction.comp_unit_app` for `η_{g.left ≫ h.left}`, and
`Adjunction.unit_naturality` to slide the inner unit past the outer pushforward. The pushforward
coercions (`pushforwardComp ≫ eqToHom`) collapse sectionwise by `Scheme.Modules.hom_ext; intro U; rfl`
exactly as the `hpf` helper of `pushPullMap_id`. It is a longer (~150-LOC) pentagon calculation and is
left for a focused follow-up pass; assembling `pushPullFunctor` needs it together with `pushPullMap_id`.

The mate core that splits the composite unit is isolated as the reusable lemma
`pushPull_unit_mate` below (axiom-clean): it rewrites the head
`p_*(η^f) ≫ pushforwardComp` as `η^{f≫p} ≫ (f≫p)_*(pullbackComp⁻¹)`.

**iter-271 breakthrough — the kernel `whnf` wall is now BYPASSED.** The earlier
blocker was a kernel `whnf` blow-up when cancelling `pushPullMap`'s two over-triangle
`eqToHom` transports *in situ* (at the concrete `pushforward`/`pullback` comparison
objects). The reusable brick `pushPull_transport_cancel` below resolves it: it states
the cancellation with the over-triangle equality `h : gl ≫ p₁ = p₂` as a **free
hypothesis**, proven by a single `subst h` on *abstract* objects (transports become
`eqToHom rfl = 𝟙`, kernel-cheap), and is applied to `pushPullMap` via `erw` — which
rewrites the tail without forcing the kernel to unfold the comparison objects. (Plain
`rw` does not fire: `SheafOfModules` comps are defeq-not-syntactic, so `erw` is
mandatory.) Applying `erw [pushPull_transport_cancel …]` to all three `pushPullMap`
occurrences (LHS once, RHS twice) was verified to fire with NO kernel blow-up, leaving
both sides transport-light. `pushforwardComp` is `Iso.refl` (strictly functorial), so
its comparison factor is `𝟙` and is absorbed by the same `erw`.

**Remaining work for `pushPullMap_comp` — a clean post-`subst` pentagon (no kernel
issues).** After the three `erw`s, `subst`-ing the two free over-triangles (via a
generalised auxiliary lemma with `p₂, p₃` and the over-triangles as free hypotheses,
mirroring `pushPull_transport_cancel`) clears the remaining transports except the
single associativity cell `eqToHom ((kl≫gl₂)≫p₁ = kl≫(gl₂≫p₁))`. The residual goal is
the pure pseudofunctor pentagon: it closes by `pushPull_unit_mate kl gl₂` (to convert
the composite unit `η^{kl≫gl₂}`) together with
`Scheme.Modules.pseudofunctor_associativity (f := kl) (g := gl₂) (h := p₁)` — whose four
`pullbackComp` 2-cells (`pullbackComp kl (gl₂≫p₁)`, `pullbackComp gl₂ p₁`,
`pullbackComp kl gl₂`, `pullbackComp (kl≫gl₂) p₁`) match exactly the four appearing in
the goal. The decompositions `pushforward (a≫b) = pushforward a ⋙ pushforward b` and
`(pushforward (a≫b)).map φ = (pushforward b).map ((pushforward a).map φ)` both hold by
`rfl`. The only friction left is the whiskered-pentagon + `eqToHom` bookkeeping (the
standard defeq-not-syntactic `erw` grind), a ~60-100 LOC follow-up; the kernel obstacle
that blocked five prior iterations is gone. -/

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
  have cancel : (Scheme.Modules.pushforward (f ≫ p)).map
        ((Scheme.Modules.pullbackComp f p).inv.app N) ≫
      (Scheme.Modules.pushforward (f ≫ p)).map
        ((Scheme.Modules.pullbackComp f p).hom.app N) = 𝟙 _ := by
    rw [← Functor.map_comp, Iso.inv_hom_id_app, CategoryTheory.Functor.map_id]
  have key := congrArg
    (· ≫ (Scheme.Modules.pushforward (f ≫ p)).map
      ((Scheme.Modules.pullbackComp f p).hom.app N)) m
  sorry

/-- Composition law of the push–pull functor `G` (contravariant). -/
lemma pushPullMap_comp (F : X.Modules) {Y₁ Y₂ Y₃ : Over X}
    (g : Y₂ ⟶ Y₁) (h : Y₃ ⟶ Y₂) :
    pushPullMap F (h ≫ g) = pushPullMap F g ≫ pushPullMap F h := by
  sorry

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

/-- **Čech acyclicity on affines** (Stacks 02KG;
`lemma-cech-cohomology-quasi-coherent-trivial` and
`lemma-quasi-coherent-affine-cohomology-zero`).

Let `X = Spec A` be affine, `F` a quasi-coherent `O_X`-module, and `𝒰` a finite
standard open cover (the `fᵢ ∈ A` generate the unit ideal). Then the relative
Čech complex (here with `f` an affine morphism) has vanishing cohomology in all
positive degrees: `Hᵖ = 0` for `p ≥ 1`, equivalently `Hᵖ(X, F) = 0` for `p > 0`
(Serre vanishing for quasi-coherent sheaves on affines).

The proof (Stacks): write `F|_X = M~`; the Čech complex of the standard cover is
the complex of localisations, and `Hᵖ = 0` for `p > 0` is equivalent to exactness
of the extended complex `0 → M → ∏ M_{f_{i₀}} → ⋯`. Exactness is checked after
localising at an arbitrary prime `𝔭`; choosing `i_fix` with `f_{i_fix} ∉ 𝔭`, the
prescription `h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}` is a contracting homotopy, so the
localised complex is exact, hence so is the complex. The Čech-to-cohomology
comparison on the basis of affine opens then gives the sheaf statement. -/
theorem CechAcyclic.affine [IsAffine X] (f : X ⟶ S) [IsAffineHom f]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) :
    IsZero ((CechComplex f 𝒰 F).homology p) := by
  -- Proof (Stacks 02KG): on the affine `X = Spec A` the Čech complex of the
  -- standard cover is the complex of localisations; positive-degree exactness
  -- follows from the prime-local contracting homotopy `h(s)_{i₀…i_p} =
  -- s_{i_fix i₀…i_p}` (where `f_{i_fix} ∉ 𝔭`), giving `(dh + hd) = id`. Needs the
  -- explicit localisation description of `CechComplex` on affines and the
  -- module-level homotopy, currently absent from Mathlib for `Scheme.Modules`.
  sorry

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

The proof (Stacks 02KE): the question is local on `S`, reducing to `S` affine; by
affine acyclicity (`CechAcyclic.affine`) the higher cohomology of `F` over each
affine intersection vanishes, so the Čech-to-cohomology spectral sequence
collapses to its `q = 0` row, identifying Čech cohomology with sheaf cohomology;
over affine `S` the Leray spectral sequence then degenerates (Serre vanishing for
the quasi-coherent `Rⁱ f_* F`), giving the stated isomorphism. -/
theorem cech_computes_higherDirectImage [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F) := by
  -- Proof (Stacks 02KE): reduce to `S` affine; affine acyclicity
  -- (`CechAcyclic.affine`) collapses the Čech-to-cohomology spectral sequence to
  -- its `q = 0` row, and the Leray spectral sequence degenerates by Serre
  -- vanishing for the quasi-coherent `Rⁱ f_* F`, yielding the comparison iso.
  -- Needs the two spectral sequences for `Scheme.Modules`, currently absent from
  -- Mathlib.
  sorry

/-- **The unconditional higher direct image via Čech** (Stacks
`lemma-quasi-coherence-higher-direct-images-application`; unconditional packaging
is Archon-original).

For `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent and a finite affine
open cover `𝒰` of `X`, the *(unconditional) `i`-th higher direct image* is the
`i`-th cohomology sheaf of the relative Čech complex,
```
  Rⁱ f_* F := Hⁱ(Č•(𝒰, F)) ∈ QCoh(S).
```
This requires **no** enough-injectives hypothesis: the right-hand side is the
cohomology of an explicit complex of quasi-coherent sheaves. By
`cech_computes_higherDirectImage` it agrees with the derived-functor higher
direct image wherever the latter is defined, and is independent of the chosen
affine cover up to canonical isomorphism. For `i = 0` one recovers the ordinary
pushforward `R⁰ f_* F = f_* F`. -/
noncomputable def cechHigherDirectImage (f : X ⟶ S) (𝒰 : X.OpenCover)
    (F : X.Modules) (i : ℕ) : S.Modules :=
  (CechComplex f 𝒰 F).homology i

/-- **Flat base change for the Čech higher direct images** (Stacks 02KH,
`lemma-flat-base-change-cohomology`).

Given the cartesian square
```
  X' --g'--> X
  |f'        |f
  v          v
  S' --g---> S
```
with `f` separated and quasi-compact, `F` quasi-coherent, `F' = (g')^* F`, and
`g` flat, for every `i ≥ 0` the canonical base-change map between the
unconditional Čech higher direct images is an isomorphism
```
  g^*(Rⁱ f_* F) ≅ Rⁱ f'_* ((g')^* F).
```
Equivalently, for `S = Spec A`, `S' = Spec B` with `A → B` flat, the comparison
`Hⁱ(X, F) ⊗_A B → Hⁱ(X', F')` of `B`-modules is an isomorphism.

We state the isomorphism as `Nonempty (… ≅ …)`; `𝒰` and `𝒰'` are finite affine
covers of `X` and `X' = X ×_S S'` (the latter the base change of the former).

The proof (Stacks 02KH): local on `S'`, reduce to `S = Spec A`, `S' = Spec B`,
`A → B` flat. Base changing the cover, the affine base change for the `i = 0`
direct image identifies each term of the base-changed Čech complex with the
original tensored over `A` with `B`, giving `Č•(𝒰_B, F_B) ≅ Č•(𝒰, F) ⊗_A B`;
flatness of `A → B` makes `- ⊗_A B` exact, so it commutes with `Hⁱ`, yielding the
isomorphism. -/
theorem cech_flatBaseChange
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (𝒰' : X'.OpenCover) [Finite 𝒰'.I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i) := by
  -- Proof (Stacks 02KH): local on `S'`, reduce to `S = Spec A`, `S' = Spec B`,
  -- `A → B` flat; base change of the cover and the affine `i = 0` base change give
  -- `Č•(𝒰_B, F_B) ≅ Č•(𝒰, F) ⊗_A B`, and flatness makes `- ⊗_A B` commute with
  -- `Hⁱ`. Needs the term-wise affine base change of the Čech complex and exactness
  -- of `- ⊗_A B` on `Scheme.Modules`, currently absent from Mathlib.
  sorry

end AlgebraicGeometry
