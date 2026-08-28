---
author: sync
content_type: theorem
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.surjective_divisorGlobalToPiece
docstring: 'Every certified divisor-piece component of the global restriction map
  is

  surjective.'
file: AlgebraicJacobian/Picard/DivisorSubschemeFaithfullyFlat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.surjective_divisorGlobalToPiece
type: lean
updated: '2026-08-01T09:44:14'
---
theorem IsCertified.surjective_divisorGlobalToPiece [IsProper C.hom]
    (A : AffAdaptation D d) {n : ℕ} (hc : A.IsCertified n)
    (i : D.index) :
    Function.Surjective (fun s : Γ(A.divisorSubscheme, ⊤) =>
      A.divisorGlobalToPiecesRingHom s i) := by
  intro x
  obtain ⟨t, rfl⟩ :=
    (A.divisorSubschemePieceRingEquiv i).surjective x
  obtain ⟨s, hs⟩ := hc.surjective_divisorGlobalRestriction A i t
  exact ⟨s, congrArg (A.divisorSubschemePieceRingEquiv i) hs⟩