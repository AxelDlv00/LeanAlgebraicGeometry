# iter-074 objectives

2 PARALLEL prover lanes (separate small modules, build wall resolved), default `prove` mode.

1. `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` — close `sectionCechAugV_π` (sorry 370).
   Degree-0 augmentation seam; PARTIAL BAR (must close). Blueprint `lem:sectionCechAugV_π`.
2. `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean` — close `coreIso_comm_leg` (sorry 68).
   The per-leg naturality wall (effort ≈1602). Blueprint `lem:coreIso_comm_leg`.

Both depend only on the proved `CechSectionIdentificationBase` module and unwind through the PROVED
`pushPull_sigma_iso_π` + `pushPull_leg_sections` seams. Verify with `lake build <module>` / `lake env lean`.
Reference anchor: Stacks `lemma-cech-cohomology-quasi-coherent-trivial` (the `i_fix` projection homotopy).
