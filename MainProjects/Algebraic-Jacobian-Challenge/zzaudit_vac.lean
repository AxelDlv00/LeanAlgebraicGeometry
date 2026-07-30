import AlgebraicJacobian.Picard.PicEtDescentGoal

set_option autoImplicit false
universe u
open CategoryTheory AlgebraicGeometry Limits Opposite
open AlgebraicJacobian.GaloisDescent
namespace AlgebraicGeometry
namespace Scheme
namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

#print axioms Scheme.fgaPicardRepresentability

/-- PROBE A: `IsInvariantMatch` is FREE when the Galois group is a subsingleton. -/
theorem probe_isInvariantMatch_of_subsingleton [Subsingleton (k' ≃ₐ[k] k')]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    (T : Over (Spec (CommRingCat.of k))) :
    IsInvariantMatch C rep ρ T := by
  intro c
  constructor
  · intro _ γ
    have h1 : γ = 1 := Subsingleton.elim _ _
    subst h1
    rw [twistTest_one]
    change ((picEt C).map (𝟙 (op _))) _ = _
    rw [CategoryTheory.Functor.map_id]
    rfl
  · intro _ γ
    have h1 : γ = 1 := Subsingleton.elim _ _
    subst h1
    change ((pullbackSemilinearGalAction k k' T.hom).act 1).hom ≫ _
      = _ ≫ (ρ.act 1).hom
    rw [map_one, map_one]
    change (Iso.refl _).hom ≫ _ = _ ≫ (Iso.refl _).hom
    rw [Iso.refl_hom, Category.id_comp, Iso.refl_hom, Category.comp_id]

end PicScheme
end Scheme
end AlgebraicGeometry

-- PROBE B: at the SAME site (Spec of the extension mono), hcov is free too, so the
-- whole theorem's conclusion follows from rep/e/he/heq/huniv with NEITHER hcov nor
-- the G1 match supplied.
namespace AlgebraicGeometry
namespace Scheme
namespace PicScheme
open AlgebraicJacobian.GaloisDescent
noncomputable def probe_degenerate
    {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
    [Algebra.IsSeparable k k'] [Module.Finite k k']
    [Mono (specMapAlgebra k k')] [Subsingleton (k' ≃ₐ[k] k')]
    {C : Over (Spec (CommRingCat.of k))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (e : Limits.pullback Y.hom (specMapAlgebra k k') ≅ X'.left)
    (he : e.hom ≫ X'.hom = Limits.pullback.snd Y.hom (specMapAlgebra k k'))
    (heq : (pullbackSemilinearGalAction k k' Y.hom).IsEquivariant ρ e.hom)
    (huniv : ∀ (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of k))
      (h : Limits.pullback t (specMapAlgebra k k') ⟶ X'.left),
      h ≫ X'.hom = Limits.pullback.snd t (specMapAlgebra k k') →
      (pullbackSemilinearGalAction k k' t).IsEquivariant ρ h →
      ∃! u : {u : T ⟶ Y.left // u ≫ Y.hom = t},
        pullbackBaseChange k k' Y.hom t u.1 u.2 ≫ e.hom = h) :
    (picEt C).RepresentableBy Y :=
  representableBy_picEt_of_galoisQuotient rep ρ e he heq huniv
    (fun T => etaleTopology_generate_coverSelfSection_of_mono T)
    (fun T => probe_isInvariantMatch_of_subsingleton C rep ρ T)

-- and k' = k IS such a site
example {k : Type u} [Field k] : Mono (specMapAlgebra k k) := by
  rw [specMapAlgebra_self]; infer_instance

example {k : Type u} [Field k] : Subsingleton (k ≃ₐ[k] k) := by infer_instance

end PicScheme
end Scheme
end AlgebraicGeometry

#print axioms AlgebraicGeometry.Scheme.PicScheme.representableBy_picEt_of_galoisQuotient
#print axioms AlgebraicGeometry.Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient
#print axioms AlgebraicGeometry.Scheme.PicScheme.nonempty_representableBy_picEt_of_isGaloisQuotient
