---
author: sync
content_type: class
created: '2026-07-24T17:02:48'
decl: killed
file: AlgebraicJacobian/Picard/SectionsDescent.lean
generated: lean
lean_status: lean_ok
stale: true
title: killed
type: lean
updated: '2026-07-29T11:07:22'
---
class killed by `cg^*` is corrected until its two pullbacks agree and then descended
through this file.

## Route

* `AlgebraicGeometry.Over.isPullback_whiskerLeft_snd`: for any `g : T' ⟶ T` over
  `Spec k`, the square `(C ◁ g).left, (snd C T').left, (snd C T).left, g.left` is a
  pullback — pasting of the two product squares `Over.isPullback_left`.
* `Module.FaithfullyFlat.existsUnique_tmul_one_eq` (imported from
  `AlgebraicJacobian.Descent.AmitsurEqualizer`): the degree-`0` Amitsur equalizer for
  `S₀ ⊗[A] B ⇉ S₀ ⊗[A] (B ⊗[A] B)`.
* The two mathlib pushout-sections squares (`isIso_pushoutSection_of_isAffineOpen`) for
  the pullback squares at `B` and `B ⊗[A] B`, re-cornered from `Γ(Spec A, ⊤)`/`Γ(Spec
  B, ⊤)` to `A`/`B` along `ΓSpecIso` and compared with the tensor-product pushout
  (`CommRingCat.isPushout_tensorProduct`); the two coprojection triangles identify the
  scheme-side pullbacks `u₁^♯, u₂^♯` with `id ⊗ inl, id ⊗ inr` on tensors.

The `A`-algebra structure on `Γ((C ⊗ Spec A).left, U)` used throughout is the composite
of the projection pullback with `ΓSpecIso` (`Over.sectionsAlgebraA`); it is a scoped