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
noncomputable local instance instOverCleftAffFieldMonoProbe2 :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩
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
/-- PROBE A: drop heps entirely, keep both hgens. -/
theorem probeA2 (g : ℕ)
    (F F' : CertifiedDivisorFamilyAff C K g)
    (hgen : ∀ z : relCurve C K,
      F.eqns.stalkIdeal z ≤ Ideal.span (eqnsWindowGermSet K hπ g F.eqns z))
    (hgen' : ∀ z : relCurve C K,
      F'.eqns.stalkIdeal z ≤ Ideal.span (eqnsWindowGermSet K hπ g F'.eqns z)) :
    F.eqns.DivEq F'.eqns := by
  refine Scheme.LocalEquations.divEq_of_stalkIdeal_eq fun z => ?_
  rw [le_antisymm (hgen z) (span_eqnsWindowGermSet_le hπ g F.eqns z),
    le_antisymm (hgen' z) (span_eqnsWindowGermSet_le hπ g F'.eqns z)]
  trace_state
  first
  | (rfl; trace "PROBE_A_RFL_CLOSED")
  | (congr 1; trace "PROBE_A_CONGR1_ONLY"; sorry)
  | (trace "PROBE_A_RFL_FAILED"; sorry)

set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in
/-- PROBE B: drop both hgen, keep heps. Try the obvious closers. -/
theorem probeB2 (g : ℕ)
    (F F' : CertifiedDivisorFamilyAff C K g)
    (heps : (F.eps hπ g).1 = (F'.eps hπ g).1) :
    F.eqns.DivEq F'.eqns := by
  first
  | (exact Scheme.LocalEquations.divEq_of_stalkIdeal_eq (fun z => by rw [heps]); trace "PROBE_B_HEPS_ALONE_CLOSED")
  | (trace "PROBE_B_HEPS_ALONE_FAILED"; sorry)

end AlgebraicGeometry
