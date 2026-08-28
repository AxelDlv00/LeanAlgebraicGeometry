import StacksPart06Lib.ProductExtension

namespace StacksPart06Lib

universe u v w

section

variable {R : Type u} {M : Type v} {N : Type w}
variable [CommRing R]
variable [AddCommGroup M] [Module R M] [Module Rᵐᵒᵖ M] [IsCentralScalar R M]
variable [AddCommGroup N] [Module R N] [Module Rᵐᵒᵖ N] [IsCentralScalar R N]

abbrev SquareZeroExtensionProductAlgebra :=
  AlgHom.equalizer
    ((squareZeroExtensionProjection (R := R) (M := M)).comp
      (AlgHom.fst R (SquareZeroExtension R M) (SquareZeroExtension R N)))
    ((squareZeroExtensionProjection (R := R) (M := N)).comp
      (AlgHom.snd R (SquareZeroExtension R M) (SquareZeroExtension R N)))

def squareZeroExtensionProductAlgebraMap :
    SquareZeroExtension R (M × N) →ₐ[R]
      SquareZeroExtensionProductAlgebra (R := R) (M := M) (N := N) := by
  let f : SquareZeroExtension R (M × N) →ₐ[R]
      SquareZeroExtension R M × SquareZeroExtension R N :=
    (squareZeroExtensionMap (LinearMap.fst R M N)).prod
      (squareZeroExtensionMap (LinearMap.snd R M N))
  exact f.codRestrict _ (by
    intro x
    change squareZeroExtensionProjection (R := R) (M := M)
        (squareZeroExtensionMap (LinearMap.fst R M N) x) =
      squareZeroExtensionProjection (R := R) (M := N)
        (squareZeroExtensionMap (LinearMap.snd R M N) x)
    rw [squareZeroExtensionMap_projection, squareZeroExtensionMap_projection])

/- The equalizer carrier is also an `R`-algebra: both coordinates receive the
same scalar through the canonical inclusions. -/
def squareZeroExtensionFiberProductAlgebraMap :
    R →+* SquareZeroExtensionFiberProduct (R := R) (M := M) (N := N) :=
  (RingHom.prod
      (squareZeroExtensionInclusion (R := R) (M := M))
      (squareZeroExtensionInclusion (R := R) (M := N))).codRestrict _ (by
    intro r
    rw [RingHom.mem_eqLocus]
    rfl)

instance squareZeroExtensionFiberProductAlgebra :
    Algebra R (SquareZeroExtensionFiberProduct (R := R) (M := M) (N := N)) :=
  RingHom.toAlgebra (squareZeroExtensionFiberProductAlgebraMap
    (R := R) (M := M) (N := N))

@[simp]
theorem squareZeroExtensionFiberProduct_algebraMap_apply (r : R) :
    algebraMap R (SquareZeroExtensionFiberProduct (R := R) (M := M) (N := N)) r =
      (squareZeroExtensionInclusion (R := R) (M := M) r,
       squareZeroExtensionInclusion (R := R) (M := N) r) := by
  rfl

/-- The product equivalence respects the canonical `R`-algebra structures. -/
noncomputable def squareZeroExtensionProductAlgEquiv :
    SquareZeroExtension R (M × N) ≃ₐ[R]
      SquareZeroExtensionFiberProduct (R := R) (M := M) (N := N) :=
  AlgEquiv.ofRingEquiv
    (squareZeroExtensionProductRingEquiv (R := R) (M := M) (N := N)) (by
      intro r
      apply Subtype.ext
      exact squareZeroExtensionProductRingEquiv_inclusion
        (R := R) (M := M) (N := N) r)

@[simp]
theorem squareZeroExtensionProductAlgEquiv_apply
    (x : SquareZeroExtension R (M × N)) :
    (squareZeroExtensionProductAlgEquiv (R := R) (M := M) (N := N) x :
      SquareZeroExtension R M × SquareZeroExtension R N) =
      (squareZeroExtensionMap (LinearMap.fst R M N) x,
       squareZeroExtensionMap (LinearMap.snd R M N) x) := by
  rfl

end

end StacksPart06Lib
