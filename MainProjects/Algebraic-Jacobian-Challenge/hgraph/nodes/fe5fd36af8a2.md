---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Grassmannian.representable_restrict
docstring: '**Local representability over a trivialising open**: over an open

  `U ⊆ S` on which `V` trivialises, the restriction of the Grassmannian

  functor to `Sch/U` is representable.  Complete proof: compose the

  restriction comparison `restrictIso` with the trivialised case

  `representable_of_iso_free` (the trivialisation index is re-normalised from

  `ULift (Fin r)` to `Fin r` through the free functor).'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.representable_restrict
type: lean
updated: '2026-07-16T21:14:27'
---
theorem representable_restrict {V : S.Modules} {r : ℕ} (U : S.Opens)
    (e : (Scheme.Modules.pullback U.ι).obj V ≅
      SheafOfModules.free (R := U.toScheme.ringCatSheaf) (ULift.{0} (Fin r)))
    {d : ℕ} (hd : 1 ≤ d) (hdr : d ≤ r) :
    ∃ Y : Over U.toScheme,
      Nonempty (((Over.map U.ι).op ⋙ Scheme.Grassmannian V d).RepresentableBy Y) := by
  obtain ⟨Y, ⟨hY⟩⟩ := representable_of_iso_free
    (e ≪≫ (SheafOfModules.freeFunctor (R := U.toScheme.ringCatSheaf)).mapIso
      (Equiv.toIso Equiv.ulift)) hd hdr
  exact ⟨Y, ⟨hY.ofIso (restrictIso U.ι V d).symm⟩⟩