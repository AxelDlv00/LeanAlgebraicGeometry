# Iter-100 (Archon canonical) / iter-103 (project narrative) objectives

## Single substantive prover lane

### Lane 1 — `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

**Target**: close `cechCofaceMap_pi_smul`'s post-S3 trailing sorry at L802.

**Sorry budget**: hard cap 7, target 6 (close L802 via Path A), acceptable
5 (close L802 + L590 via Paths A+B), fallback 7. FILE MUST COMPILE.

**Three-path option structure**:

- **Path A (PRIMARY)**: `show`-pivot def-eq strategy for scalar extraction
  on the existing `_sum_comp` call site. Bypasses discrimination tree
  pre-filter via def-eq check. NOT YET TRIED across iter-099/100/101.
- **Path B (BACKUP)**: fill `alternating_zsmul_pi_smul_aux_sum_comp` body
  at L590 (~5-10 LOC binder-level) + restructure call site at L772 with
  additional ascription / threading to avoid heartbeat timeout.
- **Path C (LAST RESORT)**: top-level R-linear composite helper. DO NOT
  attempt in iter-103.

**Blueprint**: `Cohomology_MayerVietoris.tex` § Čech acyclicity. No
blueprint edits expected.

**State preservation**: iter-101 S1-S3 cumulative chain at L772-L800 must
be preserved byte-for-byte. New lemma at L539-L590 is inert infrastructure
(Path B may fill).

## Off-limits this iteration

- `Differentials.lean` — `h_exact` deferred parallel to `instIsMonoidal_W`.
- `Modules/Monoidal.lean` `instIsMonoidal_W` — DEFERRED (Mathlib gap).
- `Jacobian.lean` `nonempty_jacobianWitness` — Phase C step C3, iter-104+.
- `Picard/Functor.lean` `representable` — gated on C0-C3.
- `AbelJacobi.lean`, `Genus.lean`, `Picard/LineBundle.lean`,
  `Picard/FunctorAb.lean` — DONE.
- BasicOpenCech L590 (new lemma body — Path B may fill, otherwise inert).
- BasicOpenCech L1436 (`g_R.map_smul'`), L1465 (`h_loc_exact`) — gated on
  Lane 1 closure.
- BasicOpenCech L894, L1218, L1246 — multi-iter Mathlib infrastructure.

## Streak escalation watch

This is the 4th consecutive prover lane on the `cechCofaceMap_pi_smul`
trailing-sorry slot (iter-099/100/101/102/103). The iter-102 refactor
attempt was the formal streak escalation; the call-site compilation
failure means iter-103 gets a "Path A first try" but the criterion
remains active. If iter-103 also stalls on Path A, iter-104 plan agent
MUST commit to Path B exclusively (no further tactic-only attempts on
the existing call site).

## Dispatcher target

Dispatcher fans out **1 prover** on:
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
