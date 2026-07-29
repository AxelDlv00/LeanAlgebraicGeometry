---
author: sync
content_type: theorem
created: '2026-07-20T05:01:15'
decl: AlgebraicGeometry.ThetaGeneratorSeed.hdvd_of_forall_smul_relThetaResSide_mem_span
docstring: '**`seedUniv''_h_fibre_cuts` — the DIRECT `hdvd` from the ann-based fibre-cutter**

  (redesign brick 3, `informal/spec-dd4-redesign.md` §1.3): if at every point `z`
  the seed''s

  cutter `h z` annihilates the base-ideal colength — i.e. `h z · (read ψ) ∈ ⟨read
  (sec z)⟩` in

  the *chart* `Γ(relPinnedChart (side z))` for every `ψ ∈ K` — then the seed''s divisibility

  clause `hdvd` holds on every piece `D(h z)`.  This feeds `isGenerator_of_fibre_ne_zero`

  (`DivSchemeSeed.lean:188`) directly: `h z` restricts to a unit on `D(h z)`, so the
  base

  ideal `J z` collapses to `⟨eqn z⟩` there.  No per-fibre `hfield`, no

  `isGenerator_of_fibrewise_ker_span_of_field_vanishing` capstone — the whole `hdvd`
  wall is

  dissolved by the ann containment (whose `z ∉ supp(N z)` premise is `RD-N`).'
file: AlgebraicJacobian/Picard/DivSchemeRedesignFibreCut.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.hdvd_of_forall_smul_relThetaResSide_mem_span
type: lean
updated: '2026-07-29T15:26:33'
---
theorem hdvd_of_forall_smul_relThetaResSide_mem_span
    (D : ThetaGeneratorSeed C R π a K)
    (hann : ∀ (z : relCurve C R) ⦃ψ : relThetaSections C R π a⦄, ψ ∈ K →
      D.h z * relThetaResSide a (D.side z) le_rfl ψ
        ∈ Ideal.span {relThetaResSide a (D.side z) le_rfl (D.sec z)}) :
    ∀ (z : relCurve C R) ⦃ψ : relThetaSections C R π a⦄, ψ ∈ K →
      relThetaResSide a (D.side z) (D.piece_le z) ψ ∈ Ideal.span {D.eqn z} := by
  intro z ψ hψ
  rw [show relThetaResSide a (D.side z) (D.piece_le z) ψ
        = (relCurve C R).resHom ((relCurve C R).basicOpen_le (D.h z))
            (relThetaResSide a (D.side z) le_rfl ψ) from
      (resHom_relThetaResSide a (D.side z) le_rfl (D.piece_le z) ψ).symm,
    show D.eqn z = (relCurve C R).resHom ((relCurve C R).basicOpen_le (D.h z))
            (relThetaResSide a (D.side z) le_rfl (D.sec z)) from
      (resHom_relThetaResSide a (D.side z) le_rfl (D.piece_le z) (D.sec z)).symm]
  exact Scheme.resHom_mem_span_singleton_of_mul_mem (D.h z)
    (relThetaResSide a (D.side z) le_rfl (D.sec z))
    (relThetaResSide a (D.side z) le_rfl ψ) (hann z hψ)