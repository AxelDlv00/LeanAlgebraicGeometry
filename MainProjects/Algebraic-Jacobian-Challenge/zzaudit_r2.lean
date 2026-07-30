import AlgebraicJacobian.Picard.PicEtDescentGoal

set_option autoImplicit false
universe u
open CategoryTheory AlgebraicGeometry Limits Opposite
open AlgebraicJacobian.GaloisDescent
namespace AlgebraicGeometry
namespace Scheme
namespace PicScheme

-- GEOMETRY-DELETION PROBE.
-- C, its two curve instances, and `picEt (baseChangeField C k')` are DELETED.
-- Instead: an arbitrary presheaf F on (Over (Spec k'))^op.
section Generic
variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
  {F : (Over (Spec (CommRingCat.of k')))ᵒᵖ ⥤ Type (u+1)}
  {X' : Over (Spec (CommRingCat.of k'))}
  (rep : F.RepresentableBy X')
  {Y : Over (Spec (CommRingCat.of k))}
  (e : Limits.pullback Y.hom (specMapAlgebra k k') ≅ X'.left)
  (he : e.hom ≫ X'.hom = pullback.snd Y.hom (specMapAlgebra k k'))

-- §2 verbatim, with F for picEt (C_{k'}) and no C:
noncomputable def gen_quotientIsoOver :
    (Over.pullback (specMapAlgebra k k')).obj Y ⟶ X' :=
  Over.homMk e.hom he

noncomputable def gen_descentMor (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    baseTest (k' := k') T ⟶ X' :=
  (Over.pullback (specMapAlgebra k k')).map u ≫ gen_quotientIsoOver e he

theorem gen_descentMor_left (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    (gen_descentMor e he T u).left
      = pullbackBaseChange k k' Y.hom T.hom u.left (Over.w u) ≫ e.hom := by
  refine congrArg (· ≫ e.hom) ?_
  have hL : ((Over.pullback (specMapAlgebra k k')).map u).left
      = Limits.pullback.lift
          (Limits.pullback.fst T.hom (specMapAlgebra k k') ≫ u.left)
          (Limits.pullback.snd T.hom (specMapAlgebra k k'))
          (by simp [Limits.pullback.condition, Over.w u]) := rfl
  refine hL.trans (Limits.pullback.hom_ext ?_ ?_)
  · rw [Limits.pullback.lift_fst, pullbackBaseChange_fst]
  · rw [Limits.pullback.lift_snd, pullbackBaseChange_snd]

theorem gen_descentMor_comp {T T' : Over (Spec (CommRingCat.of k))}
    (f : T ⟶ T') (g : T' ⟶ Y) :
    gen_descentMor e he T (f ≫ g)
      = ((Over.pullback (specMapAlgebra k k')).map f) ≫ gen_descentMor e he T' g := by
  change (Over.pullback (specMapAlgebra k k')).map (f ≫ g) ≫ gen_quotientIsoOver e he
      = _ ≫ (Over.pullback (specMapAlgebra k k')).map g ≫ gen_quotientIsoOver e he
  rw [Functor.map_comp]
  exact Category.assoc _ _ _

set_option maxHeartbeats 1000000 in
noncomputable def gen_quotientHomEquivOfIso
    (ρ : SemilinearGalAction k k' X'.left X'.hom)
    (heq : (pullbackSemilinearGalAction k k' Y.hom).IsEquivariant ρ e.hom)
    (huniv : ∀ (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of k))
      (h : Limits.pullback t (specMapAlgebra k k') ⟶ X'.left),
      h ≫ X'.hom = pullback.snd t (specMapAlgebra k k') →
      (pullbackSemilinearGalAction k k' t).IsEquivariant ρ h →
      ∃! u : {u : T ⟶ Y.left // u ≫ Y.hom = t},
        pullbackBaseChange k k' Y.hom t u.1 u.2 ≫ e.hom = h)
    (T : Over (Spec (CommRingCat.of k))) :
    (T ⟶ Y) ≃ {h : Limits.pullback T.hom (specMapAlgebra k k') ⟶ X'.left //
      h ≫ X'.hom = pullback.snd T.hom (specMapAlgebra k k') ∧
        (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ h} := by
  have hsnd : ∀ u : T ⟶ Y,
      (pullbackBaseChange k k' Y.hom T.hom u.left (Over.w u) ≫ e.hom) ≫ X'.hom
        = pullback.snd T.hom (specMapAlgebra k k') := fun u => by
    rw [Category.assoc, he, pullbackBaseChange_snd]
  have hfwd : ∀ u : T ⟶ Y,
      (pullbackSemilinearGalAction k k' T.hom).IsEquivariant ρ
        (pullbackBaseChange k k' Y.hom T.hom u.left (Over.w u) ≫ e.hom) := fun u =>
    SemilinearGalAction.isEquivariant_pullbackBaseChange_comp
      (g := Y.hom) (t := T.hom) ρ (he := heq) u.left (Over.w u)
  refine Equiv.ofBijective
    (fun u => ⟨pullbackBaseChange k k' Y.hom T.hom u.left (Over.w u) ≫ e.hom,
      hsnd u, hfwd u⟩) ⟨?_, ?_⟩
  · intro a b hab
    obtain ⟨w, -, hwu⟩ := huniv T.left T.hom
      (pullbackBaseChange k k' Y.hom T.hom b.left (Over.w b) ≫ e.hom)
      (hsnd b) (hfwd b)
    refine CategoryTheory.Over.OverMorphism.ext ?_
    exact congrArg Subtype.val
      ((hwu ⟨a.left, Over.w a⟩ (congrArg Subtype.val hab)).trans
        (hwu ⟨b.left, Over.w b⟩ rfl).symm)
  · rintro ⟨h, hh1, hh2⟩
    obtain ⟨w, hw, -⟩ := huniv T.left T.hom h hh1 hh2
    exact ⟨Over.homMk w.1 w.2, Subtype.ext hw⟩

-- §2's descentClass with an ARBITRARY natural iso in place of picEt_crossBaseIso,
-- and an arbitrary target presheaf G on (Over (Spec k))^op.
variable {G : (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type (u+1)}
  (Φ : F ≅ (coverFunctor (k := k) (k' := k')).op ⋙ G)

noncomputable def gen_descentClass (T : Over (Spec (CommRingCat.of k))) (u : T ⟶ Y) :
    G.obj (op ((coverFunctor (k := k) (k' := k')).obj T)) :=
  Φ.hom.app (op (baseTest (k' := k') T)) (rep.homEquiv (gen_descentMor e he T u))

set_option maxHeartbeats 1000000 in
theorem gen_descentClass_natural {T T' : Over (Spec (CommRingCat.of k))}
    (f : T ⟶ T') (g : T' ⟶ Y) :
    gen_descentClass rep e he Φ T (f ≫ g)
      = ((coverFunctor (k := k) (k' := k')).op ⋙ G).map f.op
          (gen_descentClass rep e he Φ T' g) := by
  have hstep : rep.homEquiv (gen_descentMor e he T (f ≫ g))
      = F.map ((Over.pullback (specMapAlgebra k k')).map f).op
          (rep.homEquiv (gen_descentMor e he T' g)) :=
    (congrArg rep.homEquiv (gen_descentMor_comp e he f g)).trans
      (rep.homEquiv_comp _ _)
  change Φ.hom.app (op (baseTest (k' := k') T))
      (rep.homEquiv (gen_descentMor e he T (f ≫ g))) = _
  rw [hstep]
  exact NatTrans.naturality_apply Φ.hom
    (X := op (baseTest (k' := k') T')) (Y := op (baseTest (k' := k') T))
    ((Over.pullback (specMapAlgebra k k')).map f).op
    (rep.homEquiv (gen_descentMor e he T' g))

end Generic

-- ===== CHOICE PROBE: data-valued form WITHOUT the Nonempty wrapper =====
section ChoiceProbe
variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']
  {C : Over (Spec (CommRingCat.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  {X' : Over (Spec (CommRingCat.of k'))}
  (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
  (ρ : SemilinearGalAction k k' X'.left X'.hom)
  {Y : Over (Spec (CommRingCat.of k))}

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
end ChoiceProbe

-- ===== NECESSITY PROBE: drop [Algebra.IsSeparable k k'] and [Module.Finite k k']
-- from representableBy_picEt_of_galoisQuotient; body verbatim. =====
section NecProbe
variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

set_option maxHeartbeats 1000000 in
noncomputable def nec_no_sep_fin
    {C : Over (Spec (CommRingCat.of k))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    (ro : SemilinearGalAction k k' X'.left X'.hom)
    {Y : Over (Spec (CommRingCat.of k))}
    (e : Limits.pullback Y.hom (specMapAlgebra k k') ≅ X'.left)
    (he : e.hom ≫ X'.hom = pullback.snd Y.hom (specMapAlgebra k k'))
    (heq : (pullbackSemilinearGalAction k k' Y.hom).IsEquivariant ro e.hom)
    (huniv : ∀ (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of k))
      (h : Limits.pullback t (specMapAlgebra k k') ⟶ X'.left),
      h ≫ X'.hom = pullback.snd t (specMapAlgebra k k') →
      (pullbackSemilinearGalAction k k' t).IsEquivariant ro h →
      ∃! u : {u : T ⟶ Y.left // u ≫ Y.hom = t},
        pullbackBaseChange k k' Y.hom t u.1 u.2 ≫ e.hom = h)
    (hcov : ∀ T : Over (Spec (CommRingCat.of k)), Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      etaleTopologyOver k (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (hmatch : ∀ T, IsInvariantMatch C rep ro T) :
    (picEt C).RepresentableBy Y :=
  representableBy_of_galInvariantEquiv (k' := k') C hcov
    (galInvariantEquivOfQuotient rep ro e he heq huniv hmatch)
    (fun {T T'} f g => by
      rw [galInvariantEquivOfQuotient_val, galInvariantEquivOfQuotient_val]
      exact descentClass_natural rep e he f g)
end NecProbe

end PicScheme
end Scheme
end AlgebraicGeometry

-- ===== NAME CHECKS =====
open AlgebraicGeometry.Scheme.PicScheme in
section
#check @AlgebraicGeometry.Scheme.PicScheme.quotientHomEquiv_uniform
#check @AlgebraicGeometry.Scheme.PicScheme.range_equivariantToClass
#check @AlgebraicGeometry.Scheme.PicScheme.semilinearGalActionOfRepresentableBy
#check @AlgebraicGeometry.Scheme.PicScheme.representableBy_of_galInvariantEquiv
#check @AlgebraicGeometry.Scheme.PicScheme.quotientHomEquiv
#check @AlgebraicGeometry.Scheme.PicScheme.picEt_crossBaseIso
#check @AlgebraicGeometry.locallyOfFiniteType_of_baseChange
#check @AlgebraicGeometry.isSeparated_of_representableBy_picEt
#check @AlgebraicGeometry.Scheme.PicScheme.representableByRestrict_of_baseChange
#check @AlgebraicJacobian.GaloisDescent.pullbackBaseChange_comp
end
