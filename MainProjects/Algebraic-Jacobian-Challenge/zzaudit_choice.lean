import AlgebraicJacobian.Picard.PicEtDescentGoal

set_option autoImplicit false
universe u
open CategoryTheory AlgebraicGeometry Limits Opposite
open AlgebraicJacobian.GaloisDescent
namespace AlgebraicGeometry
namespace Scheme
namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']
  {C : Over (Spec (CommRingCat.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  {X' : Over (Spec (CommRingCat.of k'))}
  (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
  (ρ : SemilinearGalAction k k' X'.left X'.hom)
  {Y : Over (Spec (CommRingCat.of k))}

/-- PROBE C: the DATA-valued form directly from the bundled `IsGaloisQuotient`,
i.e. WITHOUT the `Nonempty` wrapper the file says is required. -/
noncomputable def probe_data_from_isGaloisQuotient
    (hq : IsGaloisQuotient ρ Y.hom)
    (hcov : ∀ T : Over (Spec (CommRingCat.of k)), Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      Scheme.etaleTopologyOver k (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (hmatch : ∀ T, IsInvariantMatch C rep ρ T) :
    (picEt C).RepresentableBy Y :=
  representableBy_picEt_of_galoisQuotient rep ρ hq.choose hq.choose_spec.1
    hq.choose_spec.2.1 hq.choose_spec.2.2 hcov hmatch

#print axioms probe_data_from_isGaloisQuotient
#print axioms nonempty_representableBy_picEt_of_isGaloisQuotient

end PicScheme
end Scheme
end AlgebraicGeometry
