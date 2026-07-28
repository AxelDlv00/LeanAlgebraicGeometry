---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.hom_ext_fromSpecAffine
docstring: '**Separation of test objects over their affine-open test objects**: two
  morphisms

  out of a test object `T` agreeing on every affine-open test object `Over.fromSpecAffine
  T U`

  are equal.  The affine opens cover `T.left`, and `fromSpecAffine T U` differs from
  the

  open immersion of `U` by the comparison isomorphism of `U`.'
file: AlgebraicJacobian/Picard/DivRepGlobalClassify.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.hom_ext_fromSpecAffine
type: lean
updated: '2026-07-28T17:25:23'
---
private theorem hom_ext_fromSpecAffine {T Y : Over (Spec (CommRingCat.of k))} (a b : T ⟶ Y)
    (h : ∀ U : T.left.affineOpens,
      Over.fromSpecAffine T U ≫ a = Over.fromSpecAffine T U ≫ b) :
    a = b := by
  refine Over.OverMorphism.ext ?_
  refine Scheme.Cover.hom_ext T.left.directedAffineCover _ _ fun U => ?_
  have hU : U.2.fromSpec ≫ a.left = U.2.fromSpec ≫ b.left :=
    congrArg CategoryTheory.Over.Hom.left (h U)
  change U.1.ι ≫ a.left = U.1.ι ≫ b.left
  rw [← isoSpec_hom_fromSpec U.2, Category.assoc, Category.assoc, hU]

end Separation

section Curve

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

noncomputable local instance instOverCleftDivRepGlobalClassify :
    C.left.Over (Spec (CommRingCat.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [IsDominant pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
variable (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
variable (r1 r2 : ℕ)
variable (b1 : Module.Basis (Fin r1) k
  ↥(divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(divisorSections k
    ((windowM_choice pi hpi g + windowS_choice pi hpi g) • fiberWeilDivisor pi) ⊤))

local notation "DivOver" =>
  divSchemeOver k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm)

namespace DivRepAffinePullback

/-! ## Naturality of the affine classifier -/