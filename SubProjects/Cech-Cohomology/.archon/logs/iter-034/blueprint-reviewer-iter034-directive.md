# Blueprint-reviewer directive — iter-034

Audit the WHOLE blueprint (do not scope-narrow). Produce your usual per-chapter
completeness + correctness checklist and the unstarted-phase proposals section.

Context for the HARD GATE (which chapters feed live prover lanes THIS iter):
- Two prover lanes are queued, both on the consolidated chapter
  `Cohomology_CechHigherDirectImage.tex` (covers `AffineSerreVanishing.lean`,
  `TildeExactness.lean`, and the rest of the Čech-higher-direct-image cone):
  1. `AffineSerreVanishing.lean` — 02KG cover-system build. Target blocks:
     `lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`,
     `lem:affine_surj_of_vanishing`, `def:affine_cover_system`
     (supporting: `lem:standard_cover_cofinal`, `lem:affine_injective_acyclic`, both DONE).
  2. `TildeExactness.lean` — 01I8 Route-P P3. Target block `lem:tilde_preserves_kernels`
     (`\lean{AlgebraicGeometry.tildePreservesFiniteLimits}` + 3 newly-bundled helper names).
- These target blocks were gate-cleared at iter-033 (toSheaf via fast-path re-review; tilde directly).
  The only blueprint change since is a mechanical `\lean{}` coverage addition (3 tilde helper names
  bundled into `lem:tilde_preserves_kernels`). Confirm the gate still holds for both lanes.

Report which chapters are complete+correct vs partial/false, and flag any must-fix-this-iter
finding touching the two target blocks above. Note: `lem:isQuasicoherent_restrict_basicOpen` (P1a)
is a KNOWN gap awaiting decomposition this iter (effort-breaker) — it is NOT a live prover lane,
so an incomplete verdict on it does not gate this iter's two lanes; still report it accurately.
