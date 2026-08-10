---
author: sync
content_type: structure
created: '2026-08-10T10:38:33'
decl: AlgebraicGeometry.PicRankOneCanonicalEvaluationFamily
docstring: 'The data needed to assemble one arbitrary-scheme rank-one fibre.


  `familyValue` is the restriction of the displayed ambient family to `W`, and

  `nativePresentation` quantifies over every affine pullback of that value.  The map

  `canonicalEvaluationDivisor` is the evaluation-divisor classifier on the rank-one
  locus, with

  its Abel compatibility kept explicit.  The last field is the geometric factorisation
  statement

  for that divisor, rather than a field of `FibrePresented` itself.  Divisor uniqueness
  is not an

  extra hypothesis: it is recovered from Abel compatibility and the subtype inclusion.


  In particular, no field-fibre dimension witness, unrelated line bundle, or pre-existing

  `PicRankOneOpen.FibrePresented` is accepted by this contract.'
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PicRankOneCanonicalEvaluationFamily
type: lean
updated: '2026-08-10T11:14:02'
---
structure PicRankOneCanonicalEvaluationFamily
    {X : Scheme.{u}}
    (g : yoneda.obj X ⟶ rankOneAmbient (C := C)) where
  W : X.Opens
  familyValue : rankOneAmbient (C := C).obj (op (W : Scheme.{u}))
  familyValue_eq :
    familyValue =
      (yoneda.map W.ι ≫ g).app (op (W : Scheme.{u})) (𝟙 (W : Scheme.{u}))
  /-- The tied native presentation on every affine pullback of the actual family value. -/
  nativePresentation :
    ∀ (A : Type u) [CommRing A] [Algebra k A]
      (t : overSpec k A ⟶ Over.mk familyValue.1),
      Nonempty (PicRankOneNativePresentation pi
        ((picDegLayerFunctor C (genus C : ℤ)).map t.op familyValue.2))
  /-- The canonical evaluation divisor classifier on the public rank-one locus. -/
  canonicalEvaluationDivisor :
    rankOneLocus (C := C) (pi := pi) ⟶ genusDivisorYoneda (C := C)
  canonicalEvaluationDivisor_abel :
    canonicalEvaluationDivisor ≫ abelDivAffGenusSigma C =
      picRankOneOpenSigmaIncl pi
  /-- The canonical divisor factors through `W` whenever its Abel class is the displayed family. -/
  canonicalEvaluationDivisor_factor :
    ∀ (S : Scheme.{u})
      (v : rankOneLocus.obj (op S)) (w : S ⟶ X),
      (abelDivAffGenusSigma C).app (op S)
          (canonicalEvaluationDivisor.app (op S) v) =
        g.app (op S) w →
      ∃ u : S ⟶ (W : Scheme.{u}),
        u ≫ canonicalEvaluationDivisor.app
              (op (W : Scheme.{u}))
              (⟨familyValue.1, ⟨familyValue.2,
                mem_picRankOneOpen_of_nativePresentations pi
                  (fun A _ _ t => nativePresentation A t)⟩⟩) =
          canonicalEvaluationDivisor.app (op S) v ∧
        u ≫ W.ι = w

namespace PicRankOneCanonicalEvaluationFamily

variable {X : Scheme.{u}}
variable {g : yoneda.obj X ⟶ rankOneAmbient (C := C)}