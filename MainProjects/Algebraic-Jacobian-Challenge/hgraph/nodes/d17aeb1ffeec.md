---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule'_zero_sectionsLinearEquiv_naturality_map
docstring: '**Naturality of the H⁰-sections bridge in the object `U` (consumable

  form).**  For `g : V ⟶ U` in `C`, the restriction map

  `(HModule''_cohomologyPresheaf k F 0).map g.op` — the exact shape of the four

  structure maps of the degree-0 corner of the Mayer-Vietoris LES slice, via

  `HModule''_toBiprod_apply` and `HModule''_fromBiprod_biprodIsoProd_inv_apply` —

  corresponds, under `HModule''_zero_sectionsLinearEquiv`, to the presheaf

  restriction `(F.obj.map g.op).hom`.


  For `C := Opens X` and `g := homOfLE h`, the right-hand side is definitionally

  `sectionRestrict F h` (`RiemannRoch/Adelic/Cokernel.lean`), so this lemma

  identifies the degree-0 MV corner maps with `sectionDiff`''s constituents.


  Blueprint: the diagram `H⁰(U, F) → H⁰(V, F)` versus restriction

  `Γ(U, F) → Γ(V, F)` commutes.


  **Statement audit: consumable shape CONFIRMED against the MV degree-0

  corners.**  `HModule''_toBiprod`/`HModule''_fromBiprod`

  (`MayerVietorisCore.lean`) are `biprod.lift`/`biprod.desc` of literally

  `(HModule''_cohomologyPresheaf k F n).map S.f₂₄.op` (resp. `f₃₄`, `f₁₂`,

  `−f₁₃`), and their elementwise formulas `HModule''_toBiprod_apply` /

  `HModule''_fromBiprod_biprodIsoProd_inv_apply` expose exactly

  `(….map g.op) x` terms — the LHS here.  The RHS is `sectionRestrict F h`

  definitionally when `C := Opens X`, `g := homOfLE h`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/SectionsBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule'_zero_sectionsLinearEquiv_naturality_map
type: lean
updated: '2026-07-24T03:02:10'
---
lemma HModule'_zero_sectionsLinearEquiv_naturality_map
    (F : Sheaf J (ModuleCat.{u} k)) {U V : C} (g : V ⟶ U) (x : HModule' k F 0 U) :
    HModule'_zero_sectionsLinearEquiv k F V
        ((HModule'_cohomologyPresheaf k F 0).map g.op x) =
      (F.obj.map g.op).hom (HModule'_zero_sectionsLinearEquiv k F U x) := by
  rw [HModule'_cohomologyPresheaf_map_apply]
  exact HModule'_zero_sectionsLinearEquiv_naturality k F g x

set_option backward.isDefEq.respectTransparency false in