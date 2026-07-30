import AlgebraicJacobian.Picard.PicEtDescentGoal

set_option autoImplicit false
universe u
open CategoryTheory AlgebraicGeometry Limits Opposite
open AlgebraicJacobian.GaloisDescent
namespace AlgebraicGeometry
namespace Scheme
namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

-- NECESSITY PROBE 1: drop [Algebra.IsSeparable k k'] and [Module.Finite k k']
-- from the headline theorem, body verbatim.
set_option maxHeartbeats 1000000 in
noncomputable def nec_no_sep_fin
    {C : Over (Spec (CommRingCat.of k))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (e : Limits.pullback Y.hom (specMapAlgebra k k') ≅ X'.left)
    (he : e.hom ≫ X'.hom = pullback.snd Y.hom (specMapAlgebra k k'))
    (heq : (pullbackSemilinearGalAction k k' Y.hom).IsEquivariant ρ e.hom)
    (huniv : ∀ (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of k))
      (h : Limits.pullback t (specMapAlgebra k k') ⟶ X'.left),
      h ≫ X'.hom = pullback.snd t (specMapAlgebra k k') →
      (pullbackSemilinearGalAction k k' t).IsEquivariant ρ h →
      ∃! u : {u : T ⟶ Y.left // u ≫ Y.hom = t},
        pullbackBaseChange k k' Y.hom t u.1 u.2 ≫ e.hom = h)
    (hcov : ∀ T : Over (Spec (CommRingCat.of k)), Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      etaleTopologyOver k (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (hmatch : ∀ T, IsInvariantMatch C rep ρ T) :
    (picEt C).RepresentableBy Y :=
  representableBy_of_galInvariantEquiv (k' := k') C hcov
    (galInvariantEquivOfQuotient rep ρ e he heq huniv hmatch)
    (fun {T T'} f g => by
      rw [galInvariantEquivOfQuotient_val, galInvariantEquivOfQuotient_val]
      exact descentClass_natural rep e he f g)

end PicScheme
end Scheme
end AlgebraicGeometry
