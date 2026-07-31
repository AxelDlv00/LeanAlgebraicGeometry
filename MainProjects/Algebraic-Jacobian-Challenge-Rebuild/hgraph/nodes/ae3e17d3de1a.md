---
author: sync
content_type: theorem
created: '2026-07-31T00:30:37'
decl: CategoryTheory.Sheaf.HModule.cokernelπ_app_surjective_of_subsingleton_h1
docstring: 'If `H¹(F)` vanishes, the cokernel projection of a monomorphism `F ⟶ G`
  is

  surjective on sections over a terminal object.'
file: AlgebraicJacobian/RiemannRoch/ChiSlice.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.HModule.cokernelπ_app_surjective_of_subsingleton_h1
type: lean
updated: '2026-07-31T20:15:28'
---
theorem cokernelπ_app_surjective_of_subsingleton_h1
    {F G : Sheaf J (ModuleCat.{u} R)} (ι : F ⟶ G) [Mono ι]
    {T : C} (hT : IsTerminal T) [Subsingleton (HModule F 1)] :
    Function.Surjective ((cokernel.π ι).hom.app (op T)).hom := by
  let S := ShortComplex.mk ι (cokernel.π ι) (cokernel.condition ι)
  have hS : S.ShortExact :=
    { exact := ShortComplex.exact_of_g_is_cokernel _ (cokernelIsCokernel ι) }
  exact surjective_app_g_zero hS hT

section FinitenessTransfer

variable {C : Type u} [SmallCategory C] {J : GrothendieckTopology C}
  {R : Type u} [Field R] [HasSheafify J (ModuleCat.{u} R)]
  {S : ShortComplex (Sheaf J (ModuleCat.{u} R))}