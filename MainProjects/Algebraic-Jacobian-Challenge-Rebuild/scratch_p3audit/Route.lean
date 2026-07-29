import AlgebraicJacobian.Picard.DivisorFamilyAffFieldMono

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory
namespace AlgebraicGeometry
attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]
variable {π : C.left ⟶ P1 k} [IsFinite π]
noncomputable local instance instOCLR : C.left.Over (Spec (.of k)) := ⟨C.hom⟩
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 1)]

set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in
/-- ROUTE PROBE: hgen for a BARE `d` that is DivEq to a chart-typed family's eqns. -/
theorem hgen_of_chart_divEq (g : ℕ)
    (d : (relCurve C K).LocalEquations)
    (G : CertifiedDivisorFamily C K π g)
    (hDE : Scheme.LocalEquations.DivEq G.eqns d)
    (hOk : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχk : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hOK : Sheaf.h0 ((relCurve C K).moduleKSheaf K) = 1)
    (hχK : Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (g : ℤ))
    (z : relCurve C K) :
    d.stalkIdeal z ≤ Ideal.span (eqnsWindowGermSet K hπ g d z) := by
  have hstalk : d.stalkIdeal z = G.eqns.stalkIdeal z :=
    (Scheme.LocalEquations.stalkIdeal_eq_of_divEq hDE z).symm
  have hset : eqnsWindowGermSet K hπ g d z = eqnsWindowGermSet K hπ g G.eqns z := by
    unfold eqnsWindowGermSet
    rw [divisorWindow_eq_of_divEq hDE]
  rw [hstalk, hset, ← eqnsWindowGermSet_divFam hπ g G z]
  exact CertifiedDivisorFamily.stalkIdeal_le_span_windowGerm_of_field hπ g G
    hOk hχk hOK hχK z

set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in
/-- ROUTE PROBE 2: the same, specialised to a WIDENED certified family. -/
theorem hgen_aff_of_chart_divEq (g : ℕ)
    (F : CertifiedDivisorFamilyAff C K g)
    (G : CertifiedDivisorFamily C K π g)
    (hDE : Scheme.LocalEquations.DivEq G.eqns F.eqns)
    (hOk : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχk : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hOK : Sheaf.h0 ((relCurve C K).moduleKSheaf K) = 1)
    (hχK : Sheaf.chi ((relCurve C K).moduleKSheaf K) = 1 - (g : ℤ)) :
    ∀ z : relCurve C K,
      F.eqns.stalkIdeal z ≤ Ideal.span (eqnsWindowGermSet K hπ g F.eqns z) :=
  fun z => hgen_of_chart_divEq hπ g F.eqns G hDE hOk hχk hOK hχK z

end AlgebraicGeometry
