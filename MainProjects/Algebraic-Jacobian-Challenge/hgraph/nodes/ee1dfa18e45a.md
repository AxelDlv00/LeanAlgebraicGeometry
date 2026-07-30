---
author: sync
content_type: theorem
created: '2026-07-30T16:21:06'
decl: AlgebraicGeometry.Scheme.Modules.coherentSheafFlat_of_isZero
docstring: '**A zero sheaf of modules is flat over any base morphism**, with no hypothesis
  on

  the morphism at all.


  `CoherentSheafFlat` asks each section module `Γ(M, V)` to be flat over `Γ(S, U)`.
  The

  section modules are subsingletons (`subsingleton_sections_of_isZero`), and a

  subsingleton module is flat.'
file: AlgebraicJacobian/Picard/DivFamilyZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.coherentSheafFlat_of_isZero
type: lean
updated: '2026-07-30T16:21:06'
---
theorem coherentSheafFlat_of_isZero {S' : Scheme.{u}} (g : Y ⟶ S') {M : Y.Modules}
    (hM : IsZero M) : Scheme.CoherentSheafFlat g M := by
  intro U _ V _ e
  letI : Module Γ(S', U) Γ(M, V) := Module.compHom _ (g.appLE U V e).hom
  haveI := subsingleton_sections_of_isZero hM V
  exact inferInstance