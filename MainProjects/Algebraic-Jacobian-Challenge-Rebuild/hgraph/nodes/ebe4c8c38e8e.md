---
author: sync
content_type: theorem
created: '2026-08-02T21:35:45'
decl: AlgebraicGeometry.Scheme.Modules.isZero_of_epi_unit_of_finrank_zero
docstring: 'A finite-dimensional epimorphic quotient of the structure sheaf whose

  global-section dimension is zero is the zero sheaf.'
file: AlgebraicJacobian/Picard/FiberDegreeZeroVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isZero_of_epi_unit_of_finrank_zero
type: lean
updated: '2026-08-02T21:35:45'
---
theorem isZero_of_epi_unit_of_finrank_zero
    {k : Type u} [Field k] {M : X.Modules}
    [Module k Γ(M, ⊤)] [FiniteDimensional k Γ(M, ⊤)]
    (q : SheafOfModules.unit X.ringCatSheaf ⟶ M) [Epi q]
    (h : Module.finrank k Γ(M, ⊤) = 0) : IsZero M := by
  letI : Subsingleton Γ(M, ⊤) :=
    ⟨fun a b => (finrank_zero_iff_forall_zero.mp h a).trans
      (finrank_zero_iff_forall_zero.mp h b).symm⟩
  exact isZero_of_epi_unit_of_subsingleton_sections q