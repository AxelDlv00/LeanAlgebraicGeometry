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

**NOT proved, and named rather than hidden**: field `act` of
`SemilinearGalAction` asks for a group homomorphism into `Aut X'.left`, and what is
built here is a **family of endomorphisms**. Two things are therefore owed and are
stated as such in `§4`, with no declaration in this file assuming them:

1. `twistMor γ` is invertible;
2. `γ ↦ twistMor γ` is multiplicative.

Neither is assumed anywhere below, and this file constructs **no**
`SemilinearGalAction`. See `§4` for why the two are expected to be one argument
rather than two, and what the route to them is.

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
that `§4` still owes is a property `toSpecAut` already has at the base and
`specGal` would have to re-derive. `baseAut_comp` is the one bridge lemma between
the two spellings.

## Measurement discipline

`lake env lean` on this file EXIT=0 with fresh oleans, and every declaration below
was probed in a scratch file first (`I-1057`: a stale-import environment reports
every probe as succeeding). The two open obligations of `§4` were left as explicit
`sorry` in that scratch file and are **not** present here in any form.
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

What is **not** free is `act`'s group-homomorphism property; see `§4`. -/
theorem twistMor_compat (γ : k' ≃ₐ[k] k') :
    (twistMor C rep γ).left ≫ X'.hom
      = X'.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ).hom :=
  Over.w (twistMor C rep γ)

end Action

/-! ## §4. What is still owed, stated rather than assumed

This file builds **no** `SemilinearGalAction`, and the reason is precise. That
structure has two fields:

* `compat` — discharged for every `γ`, from `rep` alone, by `twistMor_compat`;
* `act : (k' ≃ₐ[k] k') →* Aut X'.left` — **not** discharged. What §3 produces is a
  *family of endomorphisms* `γ ↦ (twistMor γ).left`, and two things separate a family
  of endomorphisms from a group homomorphism into `Aut`:

  1. each `twistMor γ` is invertible;
  2. `γ ↦ twistMor γ` is multiplicative.

**These are expected to be one argument, not two, and the route is worth recording
because it explains why the twist was spelled with `Over.map` along an iso.**
`twistTestFunctor γ` is `Over.map` along an isomorphism of the base, hence an
**equivalence** of test categories, with `twistTestFunctor γ⁻¹` its inverse. So the
functor action of §2 can be read as an isomorphism between two Yoneda functors, and
Yoneda's full faithfulness then delivers an *isomorphism* of representing objects
rather than a bare morphism — multiplicativity coming from `toSpecAut`'s own
multiplicativity threaded through `Over.mapComp`. That is exactly why §1 spells the
base action as the landed `MonoidHom` `toSpecAut` rather than as `specGal`
(`I-1455`): the property that is owed here is one `toSpecAut` already has.

**Not claimed to be free.** The paragraph above is a route, not a measurement: it was
*not* carried out, and the two obligations were left as explicit `sorry` in the
scratch file that validated the rest of this module. A lane picking this up should
expect the `Over.mapComp` bookkeeping between `twistTestFunctor (γ * τ)` and
`twistTestFunctor γ ⋙ twistTestFunctor τ` to be the real cost, and should not read
"expected to be one argument" as "expected to be cheap".

**What this changes for the other lanes regardless.** The action is *not* an
independent fifth deliverable of the descent route, which is what the absence of any
producer at this object left open. Its base-compatibility half is free from the
representation, and what remains is a statement about the group law of a family that
is already constructed — no curve geometry, no cohomology, no `picEt` property
beyond representability itself. A lane budgeting "construct the semilinear action on
the `k'`-side representing scheme" as a geometric step is over-budgeting; a lane
reading this file as having *supplied* the action is over-reading. -/

end PicScheme

end Scheme

end AlgebraicGeometry
