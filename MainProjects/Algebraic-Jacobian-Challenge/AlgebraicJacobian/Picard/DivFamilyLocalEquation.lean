import AlgebraicJacobian.Picard.DivFunctorDef
import AlgebraicJacobian.Picard.CartierKernelLocalEquation

/-!
# Affine local equations of relative effective divisors

The invertible kernel of a divisor quotient gives regular local equations.
On an affine trivializing chart, the quotient's sections are the coordinate
ring modulo its equation, compatibly with the original quotient map.
This is the local ideal description in Kleiman, *The Picard scheme*,
section 3, `sb:ediv`, used by the divisor-to-Grassmannian construction.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme.DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- The pulled-back source of a divisor quotient is the unit on an open chart. -/
noncomputable def chartSourceIso (_x : DivFamily π T) (U : (pullback π T.hom).Opens) :
    (Modules.pullback U.ι).obj
        ((Modules.pullback (pullback.fst π T.hom)).obj
          (SheafOfModules.unit X.ringCatSheaf)) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf :=
  (Modules.pullback U.ι).mapIso
      (Modules.pullbackUnitIso (pullback.fst π T.hom)) ≪≫
    Modules.pullbackUnitIso U.ι

/-- Restriction of a divisor quotient to an open chart with its canonical unit source. -/
noncomputable def chartQuotient (x : DivFamily π T) (U : (pullback π T.hom).Opens) :
    SheafOfModules.unit (U : Scheme).ringCatSheaf ⟶
      (Modules.pullback U.ι).obj x.F :=
  (chartSourceIso x U).inv ≫ (Modules.pullback U.ι).map x.q

instance chartQuotient_epi (x : DivFamily π T) (U : (pullback π T.hom).Opens) :
    Epi (chartQuotient x U) := by
  letI : Epi x.q := x.epi
  letI : PreservesColimitsOfSize.{u, u} (Modules.pullback U.ι) :=
    (Modules.pullbackPushforwardAdjunction U.ι).leftAdjoint_preservesColimits
  exact epi_comp' (IsIso.epi_of_iso (chartSourceIso x U).inv)
    (Functor.map_epi (Modules.pullback U.ι) x.q)

/-- A chart trivialization of the original kernel trivializes the kernel of the chart quotient. -/
noncomputable def chartKernelIso (x : DivFamily π T) (U : (pullback π T.hom).Opens)
    (e : (kernel x.q).restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    kernel (chartQuotient x U) ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf := by
  let P := Modules.pullback U.ι
  letI : Epi x.q := x.epi
  letI : IsIso (Modules.pullbackKernelComparison U.ι x.q) :=
    Modules.isIso_pullbackKernelComparison_of_mono U.ι x.q (Functor.map_mono _ _)
  exact kernelIsIsoComp (chartSourceIso x U).inv (P.map x.q) ≪≫
    (asIso (Modules.pullbackKernelComparison U.ι x.q)).symm ≪≫
    ((Modules.restrictFunctorIsoPullback U.ι).app (kernel x.q)).symm ≪≫ e

/-- Every divisor quotient has affine charts on which its kernel is trivial. -/
theorem exists_chart_kernel_iso (x : DivFamily π T) (z : (pullback π T.hom : Scheme.{u})) :
    ∃ U : (pullback π T.hom).Opens, z ∈ U ∧ IsAffineOpen U ∧
      Nonempty (kernel (chartQuotient x U) ≅
        SheafOfModules.unit (U : Scheme).ringCatSheaf) := by
  obtain ⟨U, hzU, hU, ⟨e⟩⟩ := x.kerLocallyTrivial z
  exact ⟨U, hzU, hU, ⟨chartKernelIso x U e⟩⟩

/-- The canonical equation of an actual divisor-family kernel on a trivializing
chart, together with its scalar action on every chart section. -/
noncomputable def chartLocalEquation (x : DivFamily π T)
    (U : (pullback π T.hom).Opens)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    Γ((U : Scheme), ⊤) :=
  CartierKernel.localEquation (chartQuotient x U) (Iso.refl _) e

/-! The local equation is useful only once its scalar action is exposed.  The
generic Cartier-kernel lemma supplies exactly that bridge for the chart
quotient, with no additional regularity assumptions. -/

/-- The chart local equation recovers the kernel inclusion as scalar
multiplication on the chart unit. -/
theorem chartLocalEquation_scalar (x : DivFamily π T)
    (U : (pullback π T.hom).Opens)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    Grassmannian.scalarEnd (chartLocalEquation x U e) =
      e.inv ≫ kernel.ι (chartQuotient x U) ≫ (Iso.refl _).hom := by
  exact CartierKernel.localEquation_scalar (chartQuotient x U) (Iso.refl _) e

/-- Evaluation of the chart kernel inclusion on a section is multiplication by
the canonical local equation. -/
theorem chartLocalEquation_apply (x : DivFamily π T)
    (U : (pullback π T.hom).Opens)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf)
    (s : (U : Scheme).ringCatSheaf.obj.obj (op ⊤)) :
    ((e.inv ≫ kernel.ι (chartQuotient x U) ≫ (Iso.refl _).hom).val.app (op ⊤)) s =
      s * (U : Scheme).ringCatSheaf.obj.map (homOfLE le_top).op
        (chartLocalEquation x U e) := by
  exact CartierKernel.localEquation_apply_of_scalar
    (chartQuotient x U) (Iso.refl _) e (chartLocalEquation_scalar x U e) ⊤ s

set_option backward.isDefEq.respectTransparency false in
/-- The equation on a divisor chart is a non-zero-divisor in its coordinate ring. -/
theorem chartLocalEquation_mul_injective (x : DivFamily π T)
    (U : (pullback π T.hom).Opens)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    Function.Injective (fun s : Γ((U : Scheme), ⊤) => s * chartLocalEquation x U e) := by
  intro s t h
  apply CartierKernel.localEquation_mul_injective (chartQuotient x U) (Iso.refl _) e ⊤
  simpa [chartLocalEquation] using h

set_option backward.isDefEq.respectTransparency false in
/-- The ideal of sections killed by the chart quotient is generated by its equation. -/
theorem chartQuotient_ker_eq_span (x : DivFamily π T)
    (U : (pullback π T.hom).Opens)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    LinearMap.ker ((chartQuotient x U).val.app (op ⊤)).hom =
      Ideal.span {chartLocalEquation x U e} := by
  ext s
  change (chartQuotient x U).val.app (op ⊤) s = 0 ↔
    s ∈ (Ideal.span {chartLocalEquation x U e} : Ideal Γ((U : Scheme), ⊤))
  rw [Ideal.mem_span_singleton (α := Γ((U : Scheme), ⊤))]
  simpa [chartLocalEquation] using
    CartierKernel.quotient_eq_zero_iff_dvd_localEquation
      (chartQuotient x U) (Iso.refl _) e ⊤ s

set_option backward.isDefEq.respectTransparency false in
/-- A divisor quotient is surjective on sections of an affine trivializing chart. -/
theorem chartQuotient_surjective (x : DivFamily π T)
    (U : (pullback π T.hom).Opens) (hU : IsAffineOpen U)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    Function.Surjective ((chartQuotient x U).val.app (op ⊤)).hom := by
  letI : IsAffine (U : Scheme) := hU
  letI : Epi (chartQuotient x U) := chartQuotient_epi x U
  letI : ((Modules.pullback U.ι).obj x.F).IsFinitePresentation :=
    Modules.pullback_isFinitePresentation U.ι x.F x.isFinitePresentation
  letI : (kernel (chartQuotient x U)).IsQuasicoherent :=
    (SheafOfModules.isQuasicoherent (U : Scheme).ringCatSheaf).prop_of_iso e.symm
      (Modules.unit_isQuasicoherent (U : Scheme))
  exact section_surjective_of_epi_qcoh (chartQuotient x U) (isAffineOpen_top _)

set_option backward.isDefEq.respectTransparency false in
/-- The coordinate module of an affine divisor chart is the ring modulo its equation. -/
noncomputable def chartQuotientEquiv (x : DivFamily π T)
    (U : (pullback π T.hom).Opens) (hU : IsAffineOpen U)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    (Γ((U : Scheme), ⊤) ⧸ Ideal.span {chartLocalEquation x U e}) ≃ₗ[Γ((U : Scheme), ⊤)]
      Γ((Modules.pullback U.ι).obj x.F, ⊤) :=
  (Submodule.quotEquivOfEq _ _ (chartQuotient_ker_eq_span x U e).symm).trans
    (((chartQuotient x U).val.app (op ⊤)).hom.quotKerEquivOfSurjective
      (chartQuotient_surjective x U hU e))

set_option backward.isDefEq.respectTransparency false in
/-- The affine quotient-ring comparison carries a residue class to the original quotient section. -/
@[simp] theorem chartQuotientEquiv_mk (x : DivFamily π T)
    (U : (pullback π T.hom).Opens) (hU : IsAffineOpen U)
    (e : kernel (chartQuotient x U) ≅
      SheafOfModules.unit (U : Scheme).ringCatSheaf) (s : Γ((U : Scheme), ⊤)) :
    chartQuotientEquiv x U hU e (Ideal.Quotient.mk _ s) =
      (chartQuotient x U).val.app (op ⊤) s := by
  rfl

end AlgebraicGeometry.Scheme.DivFamily
