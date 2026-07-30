/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import AlgebraicJacobian.Picard.GaloisDescent.PicEtGaloisBridge
import AlgebraicJacobian.Picard.PicEtQuotientHom

/-!
# The Galois action on `picEt` of a base-changed curve, and on a scheme representing it

`AJC.picrep.etale-rep.galois-action`.

## The gap this file addresses, measured before it was written

Every statement of this project's `G2` cluster takes a
`AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom` as a
**hypothesis**: `Picard/PicEtQuotientHom.lean` at nine sites, the quotient
predicate `IsGaloisQuotient`, the gate `HasGaloisQuotient`, and the affine
discharge `hasGaloisQuotient_of_isAffine`.

A census **by result type** — not by name, which cannot see this — finds exactly
three producers of that structure in the whole project:

* `specSemilinearGalAction` (`Picard/FiniteGaloisQuotient.lean`) — `Spec A` for a
  ring with a semilinear `MulSemiringAction`;
* `pullbackSemilinearGalAction` (same file) — the canonical action on a base change
  `Y ×_{Spec k} Spec k'`, i.e. on an object already *descended*;
* `SemilinearGalAction.restrict` (`Picard/GaloisQuotientGlue.lean`) — restriction of
  an action to a stable open.

**None is at a scheme representing `picEt (C_{k'})`.** So the route's scoreboard
prices the *quotient* of the action and never the *action*, and if the action were
not free from the representation it would be a further deliverable that no board row
counts. That is the question this file answers.

## What is proved here, and what is not

**Proved, `sorry`-free**: the Galois action exists at the level of the **functor**,
free, and its transport to a representing object has a **free semilinearity
square**.

* `twistTestFunctor γ` — the `γ`-twist on `k'`-tests, `Over.map` along the base
  automorphism. Note this is `Over.map` along an **iso** of the base.
* `restrictTest_twistTestFunctor_iso` — the fact everything rests on: restricting a
  twisted `k'`-test to `k` gives back the same `k`-test. Its components are the
  **identity** on underlying schemes (`..._hom_app_left`). This is `specGal_comp`
  (`ajc-p1`, this round) fed to mathlib's `Over.mapComp` and `Over.mapCongr`.
* `galoisActionRestricted` / `galoisActionPicEt` — the resulting isomorphism
  `(twist γ)ᵒᵖ ⋙ picEt (C_{k'}) ≅ picEt (C_{k'})`, i.e. **the Galois action on the
  Picard functor of the base-changed curve**, for an arbitrary field `k`, an
  arbitrary extension `k'/k`, and an arbitrary smooth proper curve.
* `twistMor` — given *any* representation `rep` of `picEt (C_{k'})` by `X'`, the
  twist morphism at the representing object, obtained by transporting the functor
  action along `rep`. Since `Over.map` does not change the underlying scheme,
  `twistMor γ` has an **endomorphism of `X'.left`** as its underlying map
  (`twistMor_left_type`), which is the shape `SemilinearGalAction.act` needs.
* `twistMor_compat` — **the semilinearity square, free**: it is `Over.w` of a slice
  morphism. This is field `compat` of `SemilinearGalAction`, discharged for every
  `γ`, from `rep` alone.

**Also proved, `sorry`-free — INVERTIBILITY** (`§4`, `§5`). An earlier revision of
this docstring listed invertibility as owed, alongside multiplicativity, and
predicted the two would come together out of an `Over.mapComp` argument. That was
wrong in the cheap direction and the correction is the more useful half of this
file:

* `twistHomEquiv` — morphisms into `X'_γ` are morphisms out of `T_{γ⁻¹}`,
  *identically* on underlying maps. Pure slice-category bookkeeping; the twist's
  reversibility is consumed here as `toSpecAut`'s own cancellation lemmas.
* `representableByTwist` — **the twisted object represents `picEt (C_{k'})` too**,
  by composing `twistHomEquiv`, `rep`, and the §2 action at `γ⁻¹`.
* `twistIso` — hence `X'_γ ≅ X'`, by mathlib's
  `Functor.RepresentableBy.uniqueUpToIso`. Invertibility therefore costs one
  mathlib lemma and needs **no** multiplicativity.
* `twistIso_compat`, `twistIso_hom_left_isIso` — the semilinearity square for the
  iso (still `Over.w`), and the underlying scheme map as an `IsIso` instance, which
  is what `SemilinearGalAction.act` needs at each `γ`.

**NOT proved, and named rather than hidden**: `act` wants a group **homomorphism**
`(k' ≃ₐ[k] k') →* Aut X'.left`, and what this file supplies is an isomorphism
**for each `γ` separately**. The one remaining obligation is therefore

  `twistIso (γ * τ) = twistIso γ ∘ twistIso τ` (in the appropriate spelling),

and it is assumed nowhere below. This file constructs **no**
`SemilinearGalAction`. See `§6`.

## What this does NOT do

It closes no `sorry`. `Scheme.fgaPicardRepresentability` is untouched and appears in
this file's verification only as a `sorryAx` control. `rep` is a **hypothesis** — the
Milne–Kollár campaign's undischarged output — so nothing here is instantiable at a
curve today, and clause (1) field 1 of the seam is witnessed for no curve.

Per `I-0491` there is no `HasRationalPoint` binder, and no finiteness or
separability hypothesis on `k'/k` is used anywhere: `[Algebra k k']` throughout.

## Reuse note, following `I-1455`

`I-1455` established that `PicEtGaloisBridge.lean`'s `specGal` is `rfl`-equal to
`(toSpecAut … γ⁻¹).hom` from `Picard/FiniteGaloisQuotient.lean`, and that a census
scoped to a *directory* published an absence that was false of the project. This
file therefore spells the base action as `toSpecAut` — the landed **group
homomorphism** — rather than as `specGal`, precisely because the multiplicativity
`§6` still owes is the one property `toSpecAut` already has at the base and
`specGal` would have to re-derive. `baseAut_comp` is the one bridge lemma between
the two spellings.

## Measurement discipline

`lake env lean` on this file EXIT=0 with fresh oleans, and every declaration below
was probed in a scratch file first (`I-1057`: a stale-import environment reports
every probe as succeeding). The one open obligation of `§6` was left as an explicit
`sorry` in that scratch file and is **not** present here in any form.
-/

universe u

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §1. The twist on `k'`-tests, and why restriction does not see it -/

/-- **The base automorphism `Spec γ`, spelled as `toSpecAut`.**

`toSpecAut` (`Picard/FiniteGaloisQuotient.lean`) is a `MonoidHom` into
`Aut (Spec k')`, so this spelling carries multiplicativity and invertibility of the
base action for free. `PicEtGaloisBridge.lean`'s `specGal γ` is the same morphism at
`γ⁻¹` (`rfl`, per `I-1455`); `baseAut_comp` below is the only place the two spellings
meet. -/
theorem baseAut_comp (γ : k' ≃ₐ[k] k') :
    (toSpecAut (k' ≃ₐ[k] k') k' γ).hom ≫ specMapAlgebra k k' = specMapAlgebra k k' := by
  have h : (toSpecAut (k' ≃ₐ[k] k') k' γ).hom = specGal (k := k) γ⁻¹ := by
    rw [toSpecAut_hom]; rfl
  rw [h, specGal_comp]

/-- **The `γ`-twist of `k'`-tests**: post-compose the structure morphism with
`Spec γ`.

This is `Over.map` along an **isomorphism** of the base, which is what will make the
twist reversible; it leaves the underlying scheme of a test untouched. -/
noncomputable abbrev twistTestFunctor (γ : k' ≃ₐ[k] k') :
    Over (Spec (CommRingCat.of k')) ⥤ Over (Spec (CommRingCat.of k')) :=
  Over.map (toSpecAut (k' ≃ₐ[k] k') k' γ).hom

/-- **Restricting a twisted `k'`-test to `k` gives back the same `k`-test.**

This is the whole reason a Galois action on `picEt (C_{k'})` is free: `picEt` of the
base-changed curve *is* `picEt C` restricted along `restrictTest`
(`picEt_crossBaseIso`), and the twist is invisible to that restriction because `Spec γ`
is a morphism over `Spec k`.

Two mathlib bricks (`Over.mapComp`, `Over.mapCongr`) and `baseAut_comp`. No
finiteness, separability or Galois hypothesis on `k'/k`. -/
noncomputable def restrictTest_twistTestFunctor_iso (γ : k' ≃ₐ[k] k') :
    twistTestFunctor (k := k) γ ⋙ restrictTest k k' ≅ restrictTest k k' :=
  (Over.mapComp _ _).symm ≪≫ Over.mapCongr _ _ (baseAut_comp γ)

/-- **Every component of that iso is the identity on underlying schemes.**

Recorded because it is what makes the action below *bookkeeping* rather than
geometry: the twist moves only the structure morphism, so the comparison it induces
on classes is `picEt C` applied to a map whose underlying scheme map is `𝟙`. -/
@[simp]
theorem restrictTest_twistTestFunctor_iso_hom_app_left (γ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k'))) :
    ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app T).left = 𝟙 T.left := by
  simp [restrictTest_twistTestFunctor_iso, Over.mapComp, Over.mapCongr]

/-- Twisting by `γ * τ` is canonically the same as twisting first by `τ` and
then by `γ`. The order matches the contravariance of `Spec`: the base map for
`γ * τ` is the composite of the base maps for `τ` and `γ`. -/
noncomputable def twistTestFunctor_mulIso (γ τ : k' ≃ₐ[k] k') :
    twistTestFunctor (k := k) (γ * τ) ≅
      twistTestFunctor (k := k) τ ⋙ twistTestFunctor (k := k) γ :=
  Over.mapCongr _ _ (toSpecAut_mul_hom (k' ≃ₐ[k] k') k' γ τ) ≪≫
    Over.mapComp _ _

/-- The comparison between a product twist and the corresponding iterated twist
does not change the underlying scheme. -/
@[simp]
theorem twistTestFunctor_mulIso_hom_app_left (γ τ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k'))) :
    ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T).left = 𝟙 T.left := by
  simp [twistTestFunctor_mulIso, Over.mapComp, Over.mapCongr]

/-- The comparison identifying a twisted test after restriction satisfies the
group-law cocycle. This is an equality in the slice over `Spec k`; all three
maps have identity underlying scheme map. -/
theorem restrictTest_twistTestFunctor_iso_mul_hom_app (γ τ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k'))) :
    (restrictTest_twistTestFunctor_iso (k := k) (γ * τ)).hom.app T =
      (restrictTest k k').map ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T) ≫
        (restrictTest_twistTestFunctor_iso (k := k) γ).hom.app
          ((twistTestFunctor (k := k) τ).obj T) ≫
        (restrictTest_twistTestFunctor_iso (k := k) τ).hom.app T := by
  apply Over.OverMorphism.ext
  simp only [Over.map_obj_left, restrictTest_twistTestFunctor_iso_hom_app_left,
    Over.comp_left, Over.map_map_left, twistTestFunctor_mulIso_hom_app_left,
    Category.comp_id]
  rfl

/-! ## §2. The Galois action on the Picard functor -/

section Action

variable (C : Over (Spec (CommRingCat.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]

/-- **The Galois action on `picEt C` restricted to `k'`-tests.**

Twisting a `k'`-test by `γ` does not change it as a `k`-test, so `picEt C` cannot
tell the two apart — and that identification, read as an endomorphism of the
restricted functor, *is* the Galois action. -/
noncomputable def galoisActionRestricted (γ : k' ≃ₐ[k] k') :
    (twistTestFunctor (k := k) γ).op ⋙ ((restrictTest k k').op ⋙ picEt C)
      ≅ (restrictTest k k').op ⋙ picEt C :=
  (Functor.associator _ _ _).symm ≪≫
    Functor.isoWhiskerRight
      (NatIso.op (restrictTest_twistTestFunctor_iso (k := k) γ)).symm (picEt C)

/-- The action's component, computed: `picEt C` applied to the comparison of §1. -/
theorem galoisActionRestricted_hom_app (γ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k'))) :
    (galoisActionRestricted C γ).hom.app (Opposite.op T)
      = (picEt C).map ((restrictTest_twistTestFunctor_iso (k := k) γ).inv.app T).op := by
  change 𝟙 _ ≫ _ = _
  rw [Category.id_comp]
  rfl

/-- The inverse action component is `picEt C` applied to the forward comparison
between the restricted tests. This is the orientation used by `twistMor`. -/
theorem galoisActionRestricted_inv_app (γ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k'))) :
    (galoisActionRestricted C γ).inv.app (Opposite.op T)
      = (picEt C).map ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app T).op := by
  change _ ≫ 𝟙 _ = _
  rw [Category.comp_id]
  rfl

private theorem picEt_map_op_comp_comp_apply
    {W X Y Z : Over (Spec (CommRingCat.of k))}
    (f : W ⟶ X) (g : X ⟶ Y) (h : Y ⟶ Z)
    (x : (picEt C).obj (Opposite.op Z)) :
    (picEt C).map (f ≫ g ≫ h).op x =
      (picEt C).map f.op ((picEt C).map g.op ((picEt C).map h.op x)) := by
  rw [op_comp, op_comp, Functor.map_comp, Functor.map_comp]
  rfl

/-- The inverse restricted action satisfies the Galois cocycle. The final map
only identifies the product twist with the corresponding iterated twist. -/
theorem galoisActionRestricted_mul_inv_app (γ τ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k')))
    (x : ((restrictTest k k').op ⋙ picEt C).obj (Opposite.op T)) :
    (galoisActionRestricted C (γ * τ)).inv.app (Opposite.op T) x =
      (((restrictTest k k').op ⋙ picEt C).map
        ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T).op)
        ((galoisActionRestricted C γ).inv.app
          (Opposite.op ((twistTestFunctor (k := k) τ).obj T))
          ((galoisActionRestricted C τ).inv.app (Opposite.op T) x)) := by
  rw [galoisActionRestricted_inv_app, galoisActionRestricted_inv_app,
    galoisActionRestricted_inv_app]
  have h := congrArg (fun f => f.op)
    (restrictTest_twistTestFunctor_iso_mul_hom_app (k := k) γ τ T)
  rw [h]
  change _ = (picEt C).map (((restrictTest k k').map
    ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T)).op) _
  exact picEt_map_op_comp_comp_apply C
    ((restrictTest k k').map ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T))
    ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app
      ((twistTestFunctor (k := k) τ).obj T))
    ((restrictTest_twistTestFunctor_iso (k := k) τ).hom.app T) x

/-- **THE GALOIS ACTION ON `picEt` OF THE BASE-CHANGED CURVE.**

For a smooth proper curve `C` over an **arbitrary** field `k` and an **arbitrary**
extension `k'/k`, each `γ ∈ Gal(k'/k)` acts on the Picard functor of `C_{k'}`.

This is `galoisActionRestricted` transported along `picEt_crossBaseIso` (input 2 of
the descent repair, closed unconditionally by `Picard/PicEtCrossBase.lean`), and it
is the functor whose *representing object* the descent needs an action on.

No finiteness, separability or Galois hypothesis: `[Algebra k k']` only. In
particular `k' = k` is in the domain, where the group is trivial. -/
noncomputable def galoisActionPicEt (γ : k' ≃ₐ[k] k') :
    (twistTestFunctor (k := k) γ).op ⋙ picEt (Scheme.baseChangeField C k')
      ≅ picEt (Scheme.baseChangeField C k') :=
  Functor.isoWhiskerLeft _ (picEt_crossBaseIso C k') ≪≫
    galoisActionRestricted C γ ≪≫ (picEt_crossBaseIso C k').symm

/-- The inverse action on the base-changed Picard functor is the restricted
action conjugated by the cross-base identification. -/
theorem galoisActionPicEt_inv_app_apply (γ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k')))
    (x : (picEt (Scheme.baseChangeField C k')).obj (Opposite.op T)) :
    (galoisActionPicEt C γ).inv.app (Opposite.op T) x =
      (picEt_crossBaseIso C k').inv.app
        (Opposite.op ((twistTestFunctor (k := k) γ).obj T))
        ((galoisActionRestricted C γ).inv.app (Opposite.op T)
          ((picEt_crossBaseIso C k').hom.app (Opposite.op T) x)) := by
  rfl

/-- The inverse action on `picEt` satisfies the Galois cocycle. The comparison
map only changes the presentation of a product twist as an iterated twist. -/
theorem galoisActionPicEt_mul_inv_app (γ τ : k' ≃ₐ[k] k')
    (T : Over (Spec (CommRingCat.of k')))
    (x : (picEt (Scheme.baseChangeField C k')).obj (Opposite.op T)) :
    (galoisActionPicEt C (γ * τ)).inv.app (Opposite.op T) x =
      (picEt (Scheme.baseChangeField C k')).map
        ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T).op
        ((galoisActionPicEt C γ).inv.app
          (Opposite.op ((twistTestFunctor (k := k) τ).obj T))
          ((galoisActionPicEt C τ).inv.app (Opposite.op T) x)) := by
  simp only [galoisActionPicEt_inv_app_apply]
  rw [galoisActionRestricted_mul_inv_app]
  simp only [Iso.inv_hom_id_app_apply]
  exact NatTrans.naturality_apply (picEt_crossBaseIso C k').inv
    ((twistTestFunctor_mulIso (k := k) γ τ).hom.app T).op _

/-! ## §3. Transport to a representing object — and the free semilinearity square -/

variable {X' : Over (Spec (CommRingCat.of k'))}
  (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')

/-- **The twist morphism at a representing object.**

Given *any* scheme `X'` representing `picEt (C_{k'})` — the campaign's undischarged
output, a hypothesis here — the functor action of §2 transports to a morphism
`X'_γ ⟶ X'` in the slice over `Spec k'`, by taking the universal class of `X'`,
acting on it, and reading the result back as a morphism.

`X'_γ` is `Over.mk (X'.hom ≫ Spec γ)`, which has the **same underlying scheme** as
`X'`. So the underlying map of `twistMor γ` is an endomorphism of `X'.left` — the
shape `SemilinearGalAction.act` asks for. See `twistMor_left_type`. -/
noncomputable def twistMor (γ : k' ≃ₐ[k] k') :
    (twistTestFunctor (k := k) γ).obj X' ⟶ X' :=
  rep.homEquiv.symm
    ((galoisActionPicEt C γ).inv.app (Opposite.op X') (rep.homEquiv (𝟙 X')))

/-- The universal class of `twistMor γ` is the inverse functor action applied to
the universal class of the representing object. -/
@[simp]
theorem homEquiv_twistMor (γ : k' ≃ₐ[k] k') :
    rep.homEquiv (twistMor C rep γ) =
      (galoisActionPicEt C γ).inv.app (Opposite.op X') (rep.homEquiv (𝟙 X')) :=
  Equiv.apply_symm_apply _ _

/-- The canonical twist morphisms satisfy the Galois group law in the slice.
The product-twist comparison is the only bookkeeping map in the formula. -/
theorem twistMor_mul (γ τ : k' ≃ₐ[k] k') :
    twistMor C rep (γ * τ) =
      (twistTestFunctor_mulIso (k := k) γ τ).hom.app X' ≫
        (twistTestFunctor (k := k) γ).map (twistMor C rep τ) ≫
        twistMor C rep γ := by
  apply rep.homEquiv.injective
  rw [homEquiv_twistMor, rep.homEquiv_comp, rep.homEquiv_comp,
    homEquiv_twistMor]
  change _ = (picEt (Scheme.baseChangeField C k')).map
    ((twistTestFunctor_mulIso (k := k) γ τ).hom.app X').op
      (((twistTestFunctor (k := k) γ).op ⋙
        picEt (Scheme.baseChangeField C k')).map (twistMor C rep τ).op
          ((galoisActionPicEt C γ).inv.app (Opposite.op X')
            (rep.homEquiv (𝟙 X'))))
  rw [← NatTrans.naturality_apply (galoisActionPicEt C γ).inv
    (twistMor C rep τ).op (rep.homEquiv (𝟙 X'))]
  rw [← rep.homEquiv_eq, homEquiv_twistMor]
  exact galoisActionPicEt_mul_inv_app C γ τ X' (rep.homEquiv (𝟙 X'))

/-- **The underlying map of the twist IS an endomorphism of `X'.left`**, stated as a
proposition about types rather than left to the reader: `Over.map` does not touch the
underlying scheme, so no transport is needed to feed
`SemilinearGalAction.act`'s target. -/
theorem twistMor_left_type (γ : k' ≃ₐ[k] k') :
    ((twistTestFunctor (k := k) γ).obj X').left = X'.left := rfl

/-- **THE SEMILINEARITY SQUARE, FREE.**

`(twistMor γ).left ≫ X'.hom = X'.hom ≫ Spec γ` — which is *verbatim* field `compat`
of `AlgebraicJacobian.GaloisDescent.SemilinearGalAction`, with `toSpecAut` the same
group homomorphism that structure uses.

It costs nothing: `twistMor γ` is a morphism **in the slice** over `Spec k'`, so the
square is its `Over.w`. That the square is free is the finding — three board rows and
nine hypothesis sites treat the whole semilinear action as an input, and its
`compat` half follows from any representation with no geometry at all.

What is **not** free is `act`'s group-homomorphism property; see `§6`. -/
theorem twistMor_compat (γ : k' ≃ₐ[k] k') :
    (twistMor C rep γ).left ≫ X'.hom
      = X'.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ).hom :=
  Over.w (twistMor C rep γ)

end Action

/-! ## §4. The twist is an ISOMORPHISM -/

/-- **Morphisms into a twisted object are morphisms out of the inversely-twisted
source**, and *identically so* on underlying scheme maps (`twistHomEquiv_left` is
`rfl`).

This is the bijection that makes `§5` work, and it is where `toSpecAut`'s
invertibility is consumed — the two directions are `toSpecAut_hom_inv_hom` and
`toSpecAut_inv_hom_hom`, the cancellation lemmas the landed `MonoidHom` spelling
already ships. Note it needs no curve, no `picEt`, and no representation: it is a
statement about the slice category alone. -/
noncomputable def twistHomEquiv (γ : k' ≃ₐ[k] k')
    (T X' : Over (Spec (CommRingCat.of k'))) :
    (T ⟶ (twistTestFunctor (k := k) γ).obj X')
      ≃ ((twistTestFunctor (k := k) γ⁻¹).obj T ⟶ X') where
  toFun u := Over.homMk u.left (by
    have h : u.left ≫ X'.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ).hom = T.hom := Over.w u
    change u.left ≫ X'.hom = T.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ⁻¹).hom
    rw [← h, Category.assoc, Category.assoc, toSpecAut_hom_inv_hom, Category.comp_id])
  invFun u := Over.homMk u.left (by
    have h : u.left ≫ X'.hom = T.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ⁻¹).hom := Over.w u
    change u.left ≫ X'.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ).hom = T.hom
    rw [← Category.assoc, h]
    exact (Category.assoc _ _ _).trans
      ((congrArg (T.hom ≫ ·)
        (toSpecAut_inv_hom_hom (k' ≃ₐ[k] k') k' γ)).trans (Category.comp_id _)))
  left_inv u := by ext; rfl
  right_inv u := by ext; rfl

/-- `twistHomEquiv` is the identity on underlying scheme maps. -/
@[simp]
theorem twistHomEquiv_left (γ : k' ≃ₐ[k] k')
    (T X' : Over (Spec (CommRingCat.of k')))
    (u : T ⟶ (twistTestFunctor (k := k) γ).obj X') :
    (twistHomEquiv (k := k) γ T X' u).left = u.left := rfl

/-- Compatibility of `twistHomEquiv` with precomposition — the naturality input of
`§5`. `rfl` after `Over` extensionality, because the bijection does not move the
underlying map. -/
theorem twistHomEquiv_comp (γ : k' ≃ₐ[k] k')
    (T T' X' : Over (Spec (CommRingCat.of k'))) (f : T ⟶ T')
    (g : T' ⟶ (twistTestFunctor (k := k) γ).obj X') :
    twistHomEquiv (k := k) γ T X' (f ≫ g)
      = (twistTestFunctor (k := k) γ⁻¹).map f ≫ twistHomEquiv (k := k) γ T' X' g := by
  apply Over.OverMorphism.ext
  rfl

/-! ## §5. The twisted object represents `picEt` too, hence the twist is invertible -/

section Iso

variable (C : Over (Spec (CommRingCat.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  {X' : Over (Spec (CommRingCat.of k'))}
  (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')

/-- **The twisted object represents `picEt (C_{k'})` as well.**

Composing three bijections, each already available: `twistHomEquiv` (§4), the given
representation `rep`, and the functor action of §2 at `γ⁻¹`. Naturality is
`twistHomEquiv_comp` plus `rep`'s own naturality plus naturality of the action —
no new content.

This is the declaration that makes the twist invertible without proving
multiplicativity first, which is what the previous revision of this file's closing
section predicted would be needed. -/
noncomputable def representableByTwist (γ : k' ≃ₐ[k] k') :
    (picEt (Scheme.baseChangeField C k')).RepresentableBy
      ((twistTestFunctor (k := k) γ).obj X') where
  homEquiv {T} :=
    ((twistHomEquiv (k := k) γ T X').trans rep.homEquiv).trans
      ((galoisActionPicEt C γ⁻¹).app (Opposite.op T)).toEquiv
  homEquiv_comp := by
    intro T T' f g
    have hnat := (galoisActionPicEt C (k' := k') γ⁻¹).hom.naturality f.op
    simp only [Equiv.trans_apply, Iso.app_hom, Iso.toEquiv_fun]
    rw [twistHomEquiv_comp, rep.homEquiv_comp]
    exact congrArg (fun (h : _ ⟶ _) => (ConcreteCategory.hom h) (rep.homEquiv
      ((twistHomEquiv (k := k) γ T' X') g))) hnat

/-- **THE TWIST, AS AN ISOMORPHISM `X'_γ ≅ X'`.**

Two objects representing one functor are isomorphic, and mathlib says so:
`Functor.RepresentableBy.uniqueUpToIso`. So invertibility of the Galois twist at a
representing object costs **one mathlib lemma** applied to §5's second
representation, for an arbitrary field `k`, an arbitrary extension `k'/k` and any
representation. No `IsRepresentable` instance is needed and none is available. -/
noncomputable def twistIso (γ : k' ≃ₐ[k] k') :
    (twistTestFunctor (k := k) γ).obj X' ≅ X' :=
  (representableByTwist C rep γ).uniqueUpToIso rep

/-- **The semilinearity square for the isomorphism** — still `Over.w`, still free. -/
theorem twistIso_compat (γ : k' ≃ₐ[k] k') :
    (twistIso C rep γ).hom.left ≫ X'.hom
      = X'.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ).hom :=
  Over.w (twistIso C rep γ).hom

/-- **The underlying scheme map is an isomorphism.**

Read off the slice iso by applying `Over.Hom.left` to both triangle identities — no
geometric instance, and in particular not via open-immersion reasoning, which would
be a fact about a different morphism. This is the statement
`SemilinearGalAction.act` needs at each `γ`. -/
instance twistIso_hom_left_isIso (γ : k' ≃ₐ[k] k') :
    IsIso (twistIso C rep γ).hom.left :=
  ⟨(twistIso C rep γ).inv.left, by
      rw [← Over.comp_left, (twistIso C rep γ).hom_inv_id]; rfl,
    by rw [← Over.comp_left, (twistIso C rep γ).inv_hom_id]; rfl⟩

end Iso

/-! ## §6. The ONE thing still owed, stated rather than assumed

`SemilinearGalAction` has two fields, and the score after `§5` is:

* `compat` — **discharged** for every `γ`, from `rep` alone (`twistIso_compat`);
* `act : (k' ≃ₐ[k] k') →* Aut X'.left` — **not** discharged, but the gap is now one
  equation rather than two. Each `γ` has its automorphism (`twistIso` plus
  `twistIso_hom_left_isIso`); what is missing is that `γ ↦ twistIso γ` respects the
  **group law**.

**What that costs, honestly.** It is naturality of `uniqueUpToIso` in the twist
parameter: `twistTestFunctor (γ * τ)` and `twistTestFunctor γ ⋙ twistTestFunctor τ`
agree because `toSpecAut` is a `MonoidHom` and `Over.mapComp` transports that, and
one then has to see that the two representations `representableByTwist` builds along
the two routes are the *same* representation. The ingredients are all present;
the bookkeeping was not carried out and is **not** claimed to be cheap. It was left
as an explicit `sorry` in the scratch file that validated everything above, and no
declaration here depends on it.

**A prediction this file already got wrong, recorded because it is the reusable
part.** The previous revision listed invertibility and multiplicativity as two owed
obligations and argued they would be *one* argument via Yoneda. Half of that was
wrong in the expensive direction: invertibility does **not** need multiplicativity,
does not need Yoneda fullness, and does not need the `Over.mapComp` bookkeeping. It
needs the observation that the *twisted object also represents the functor*, after
which `Functor.RepresentableBy.uniqueUpToIso` — already in mathlib — finishes. The
tell was that the twist bijection `twistHomEquiv` is the identity on underlying
maps, so nothing had to be transported at all. Pricing a residue by the plan that
produced it, rather than by asking what the object is, is what cost the extra
paragraph.

**What this changes for the other lanes.** The semilinear action is *not* an
independent fifth deliverable of the descent route, which is what the total absence
of a producer at this object left open. Of the structure `PicEtQuotientHom.lean`
binds at nine sites and the `G2` gate binds too, everything except one group-law
equation is now free from the representation alone: no curve geometry, no
cohomology, no `picEt` property beyond representability. A lane budgeting
"construct the semilinear action on the `k'`-side representing scheme" as a
geometric step is over-budgeting. A lane reading this file as having *supplied* a
`SemilinearGalAction` is over-reading — it has not, and instance search will not
find one. -/

end PicScheme

end Scheme

end AlgebraicGeometry
