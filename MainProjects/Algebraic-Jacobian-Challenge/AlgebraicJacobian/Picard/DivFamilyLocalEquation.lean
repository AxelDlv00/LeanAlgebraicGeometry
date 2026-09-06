import AlgebraicJacobian.Picard.DivFunctorDef

set_option autoImplicit false

universe u

open CategoryTheory Limits

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

end AlgebraicGeometry.Scheme.DivFamily
