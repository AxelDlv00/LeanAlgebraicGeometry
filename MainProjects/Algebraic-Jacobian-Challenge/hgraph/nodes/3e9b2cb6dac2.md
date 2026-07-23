---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.isFinitePresentation_of_finite_sections
docstring: '**The noetherian coherence criterion** (finite sections ⟹ finitely

  presented; Stacks 01XZ-grade bookkeeping).  A quasi-coherent sheaf of

  modules on a locally noetherian scheme whose section modules over all

  affine opens are finite over the respective section rings is finitely

  presented: assemble the per-affine finite slice presentations

  (`exists_finite_presentation_over_of_finite_sections`) over the affine

  opens cover into a `QuasicoherentData` witnessing

  `SheafOfModules.IsFinitePresentation`.'
file: AlgebraicJacobian/Picard/RigidPushforwardTransfer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isFinitePresentation_of_finite_sections
type: lean
updated: '2026-07-16T21:14:27'
---
theorem isFinitePresentation_of_finite_sections
    [IsLocallyNoetherian Y] (N : Y.Modules) [N.IsQuasicoherent]
    (hfin : ∀ V : Y.Opens, IsAffineOpen V → Module.Finite Γ(Y, V) Γ(N, V)) :
    N.IsFinitePresentation := by
  have h := fun V : Y.affineOpens =>
    exists_finite_presentation_over_of_finite_sections N hfin V.2
  choose P hP using h
  let q : N.QuasicoherentData :=
    { I := Y.affineOpens
      X := fun V => V.1
      coversTop := by
        intro W y hy
        obtain ⟨V, hVaff, hyV, hVW⟩ :=
          TopologicalSpace.Opens.isBasis_iff_nbhd.mp (Scheme.isBasis_affineOpens Y) hy
        refine ⟨V, homOfLE hVW, ?_, hyV⟩
        rw [CategoryTheory.Sieve.mem_ofObjects_iff]
        exact ⟨⟨V, hVaff⟩, ⟨𝟙 V⟩⟩
      presentation := P }
  have hsh : q.shrink.IsFinitePresentation := by
    apply SheafOfModules.QuasicoherentData.IsFinitePresentation.mk
    intro i
    exact hP _
  exact { exists_quasicoherentData := ⟨q.shrink, hsh⟩ }

end Scheme.Modules

/-! ## §3. `hfp` — the finite pushforward of a line bundle is finitely presented -/

namespace Adelic

open Scheme

variable {k : Type u} [Field k]
variable (A : Type u) [CommRing A] [Algebra k A]
variable (C : Over (Spec (CommRingCat.of k)))

set_option maxHeartbeats 800000 in
-- Heartbeat headroom for the pullback/pushforward instance synthesis on the
-- base-changed projective line, as elsewhere in the B3 lane.
set_option synthInstance.maxHeartbeats 400000 in