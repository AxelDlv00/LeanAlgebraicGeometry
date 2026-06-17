# Progress-critic directive — Route B keystone (QcohTildeSections.lean)

## Active route under assessment
**Route B — `01I8` quasi-coherent `F ≅ \tilde{Γ F}` via the sheaf-axiom equalizer keystone.**
Single active prover file across the last 5 iters: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`.
The proposed iter-044 objective is to RE-DISPATCH this same file (mathlib-build) a 5th consecutive iter,
to close the residual of Sub-lemma B `tile_section_comparison` and assemble `tile_section_localization`.

## Strategy estimate (lifted verbatim from STRATEGY.md `## Phases & estimations`, 01I8 row)
- `Iters left`: ~2
- Route entered its current phase (sheaf-axiom equalizer re-route): iter-041.
- Elapsed in current phase so far: iters 041, 042, 043 = 3 iters.

## Last-5-iters SIGNALS for QcohTildeSections.lean
- **Project inline sorry count:** iter-040: 2 → 041: 2 → 042: 2 → 043: 2. (Both sorries are
  frozen/superseded, NOT in this file; this file is 0-sorry throughout. `mathlib-build` mode forbids
  papering sorries, so "sorry count flat at 2" is the invariant, not a stall signal here.)
- **Axiom-clean decls ADDED to this file per iter** (the real throughput metric, since mathlib-build
  grows infrastructure rather than eliminating sorries):
  - iter-040: +4 (B-chain leaves B3 object-iso + B4 — in QcohRestrictBasicOpen, the sibling file).
  - iter-041: +3 (`qcoh_section_equalizer`, base-ring descent, private `res_trans_apply`).
  - iter-042: +1 (`tile_image_opens_identities` = Sub-lemma A).
  - iter-043: +2 (`modulesSpecToSheaf_smul_eq`, `modulesRestrictBasicOpen_smul_eq` — two rfl bridges).
- **Named-target landing status:** the iter's NAMED target `tile_section_localization` /
  `tile_section_comparison` has NOT landed in any of iters 041–043. Each iter instead landed an
  ingredient or a reduction and handed back a finer decomposition.
- **Prover statuses:** 041 PARTIAL (1 of 2 leaves landed, 2nd decomposed), 042 PARTIAL (Sub-lemma A
  landed, B confirmed non-definitional), 043 PARTIAL (2 rfl bridges landed, B reduced to one ring
  identity).
- **Recurring blocker phrase across 042→043:** "Sub-lemma B section comparison is non-definitional /
  cross-ring `ModuleCat R_g` vs `ModuleCat R`." BUT the framing demonstrably shrank: iter-042 = "~150 LOC
  non-definitional wall"; iter-043 = "two scalar bridges are rfl; carriers defeq on iterated-image open;
  residual = ONE structure-sheaf ring identity ~30–50 LOC, closable by `IsLocalization.Away` uniqueness or
  `ΓSpecIso` naturality."

## Question for you
Is this route CONVERGING (the obstruction is measurably shrinking each iter and a 5th dispatch on the
same file is justified), or is it CHURNING (the named target keeps NOT landing while helpers accumulate
and the residual is not actually shrinking)? The planner's read is CONVERGING — the obstruction went
150 LOC → 1 ring identity with two named closure routes — but the same-file-5th-time pattern is exactly
the case you exist to second-guess. If CHURNING/STUCK, name the corrective TYPE (blueprint expansion,
Mathlib-idiom consult via mathlib-analogist, structural refactor, route pivot). The blueprint sketch for
`tile_section_comparison` is being rewritten THIS iter (writer dispatched in parallel) to reflect the
two-rfl-bridges + one-ring-identity decomposition.
