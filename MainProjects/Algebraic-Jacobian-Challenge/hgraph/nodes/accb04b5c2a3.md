---
author: sync
content_type: theorem
created: '2026-07-31T19:37:12'
decl: AlgebraicGeometry.Scheme.Modules.isZero_iff_isEmpty_schematicSupport
docstring: '**A quasi-coherent sheaf is zero iff its schematic support is empty.**
  Packages the

  landed forward `isEmpty_schematicSupport_of_isZero` with the converse

  `isZero_of_isEmpty_schematicSupport` into the geometric characterisation of the
  zero sheaf:

  vanishing of the sheaf is exactly emptiness of the closed subscheme it is supported
  on. The

  companion of `isZero_iff_forall_subsingleton_sections`, in support vocabulary.'
file: AlgebraicJacobian/Picard/DivFamilyZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isZero_iff_isEmpty_schematicSupport
type: lean
updated: '2026-07-31T19:37:12'
---
theorem isZero_iff_isEmpty_schematicSupport {M : Y.Modules} [M.IsQuasicoherent] :
    IsZero M ↔ IsEmpty (Scheme.Modules.schematicSupport M : Type u) :=
  ⟨fun hM => isEmpty_schematicSupport_of_isZero hM, isZero_of_isEmpty_schematicSupport⟩

end Scheme.Modules

/-! ## §3. The empty divisor -/

namespace Scheme

variable {S X : Scheme.{u}} (π : X ⟶ S) (T : Over S)