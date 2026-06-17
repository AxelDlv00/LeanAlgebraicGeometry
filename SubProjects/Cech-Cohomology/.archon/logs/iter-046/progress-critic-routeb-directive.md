# progress-critic directive — keystone Route B (section-localization), iters 041–045

## Active route under assessment

**Route B keystone — `tile_section_localization` (the last keystone-feeding leaf)** in
`AlgebraicJacobian/Cohomology/QcohTildeSections.lean`. This is the SINGLE critical path: 02KG affine
Serre vanishing tops, P5a vanishing inputs, and P5b assembly all gate on it. No honest off-keystone
parallel lane exists (the only off-keystone frontier node is gated on this route).

The keystone glue is the sheaf-axiom-equalizer descent. Leaves: `qcoh_section_equalizer` (DONE 041),
base-ring descent (DONE 041), Sub-lemma A `tile_image_opens_identities` (DONE 042), two rfl scalar
bridges (DONE 043), Sub-lemma B scalar core `tile_scalar_compat` (DONE 044). The remaining leaf is
`tile_section_localization` (final assembly) → then `qcoh_section_kernel_comparison` → keystone.

## Signals — last 5 iters (041–045), this route

| iter | sorry (file) | helpers added (axiom-clean) | prover status | recurring blocker phrase |
|---|---|---|---|---|
| 041 | 0 | +3 (`qcoh_section_equalizer`, base-ring descent, +1) | PARTIAL | "keystone glue / section-comparison" |
| 042 | 0 | +1 (Sub-lemma A `tile_image_opens_identities`) | PARTIAL | "section comparison NOT rfl / non-definitional" |
| 043 | 0 | +2 (two rfl scalar bridges) | PARTIAL | "reduced to one ring identity" |
| 044 | 0 | +5 (`tile_scalar_compat` + 4 route-(A) helpers) | PARTIAL | "ring identity CLOSED; assembly next" |
| 045 | 0 | +5 (`tile_scalar_compat'` + general-V companions + 2 private) | PARTIAL/BLOCKED | "W1/W2/W3 Lean-engineering wall" |

- The named final target `tile_section_localization` has been the stated objective across 044–045 and
  is still NOT landed. Every iter added genuinely load-bearing axiom-clean infra (no regression, no
  rotation between unrelated files), but the residual is the SAME leaf.
- **The obstruction shape CHANGED at iter-045**: through 044 the friction was mathematics
  (section-comparison non-definitionality → reduced to a ring identity → closed). At 045 the math went
  to ZERO remaining ingredients (the map identity is `rfl`, kernel-verified) and the blocker became
  pure Lean engineering: W1 (any `Spec`-dependent `letI`/`have` hoists to a noncomputable aux def, fails
  codegen), W2 (`IsScalarTower R R_g` won't elaborate — `SMul R` not synthesised on the tile carrier),
  W3 (`whnf`/`isDefEq` timeout at 4M heartbeats). Two concrete coding attempts reproduced W1/W2 verbatim.

## Strategy estimate vs elapsed

- STRATEGY.md `01I8` row: **Iters left = ~3**; the row notes throughput SLIPPING (~4–5 iters elapsed
  on this leaf vs ~2 originally estimated). The 01I8 section-localization phase entered its current
  shape ~iter-041 (the keystone re-route to the sheaf-axiom equalizer).

## This iter's proposed objective (for your dispatch-sanity check)

ONE prover lane on `QcohTildeSections.lean`. The planner is NOT re-dispatching the same
"assemble it via mathlib-build" objective — per iter-045 HIGH-1, the planner is FIRST dispatching a
mathlib-analogist (api-alignment) on the W1–W3 instance-install wall + a design-shape question (reshape
the descent onto the `F`-side carrier so no dynamic `Module R` install is needed), and only THEN
re-scoping the prover lane with the analogist's recipe + in-file cleanups (mangle a sync-fooling
commented sketch; delete a stale contradictory comment).

## What to assess

Is this route CONVERGING, CHURNING, or STUCK? Specifically:
- Is the 041–045 PARTIAL streak monotonic convergence (obstruction shrank to zero math + one named
  engineering wall) or genuine churn (helpers multiplying without the residual shrinking)?
- Is the planner's corrective (mathlib-analogist design-shape consult + re-scoped lane, NOT another
  identical mathlib-build round) the right response, or does the evidence point to a different corrective
  (route pivot, structural refactor, escalation)?
- Name the corrective TYPE if CHURNING/STUCK.
