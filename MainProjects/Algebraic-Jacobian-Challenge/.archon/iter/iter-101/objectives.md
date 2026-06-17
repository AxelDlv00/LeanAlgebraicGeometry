# Iter-101 (Archon canonical) / iter-103 (project narrative) objectives

## Single substantive prover lane

### Lane 1 — `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

**Target**: close `cechCofaceMap_pi_smul`'s post-S3 trailing sorry at L802.

**Sorry budget**: hard cap 7, target 6 (close L802 via Path A), acceptable
5 (close L802 + L590 via Paths A+B), fallback 7. **FILE MUST COMPILE.**

**Three-path option structure** (full directive in PROGRESS.md):

- **Path A (PRIMARY)** — `show`-pivot def-eq strategy. The iter-101
  (project) S4 failures all used `rw`/`simp_rw`/`simp only` which trigger
  Lean's discrimination-tree pre-filter. `show` invokes def-eq check
  directly (kernel-level), bypassing the discrimination tree.
  - A1: peel `ConcreteCategory.hom` via `show ... .hom = ...` (rfl).
  - A2: peel `(-1)^↑i •` from morphism composition via `show` def-eq.
  - A3: `rw [smul_comm ((-1 : ℤ)^(↑i : ℕ)) r']`.
  - A4: `congr 1` to cancel `(-1)^↑i •`.
  - A5: discharge per-coord R-linearity via `Pi.lift_π_apply` +
    eqToHom-naturality + `presheafMap_restrict_collapse`.
- **Path B (BACKUP)** — fill new lemma body at L590 (~5-10 LOC
  binder-level) + restructure call site at L772 with additional
  ascription / threading. Heartbeat-heavy; iter-102 (project) hit a
  12800000 deterministic whnf timeout on the σ-split call-site
  application — the prover must consider partial inlining or alternative
  threading.
- **Path C (LAST RESORT)** — top-level R-linear composite helper bundling
  Pi.lift + eqToHom + Pi.π into a single sign-free declared morphism.
  **DO NOT attempt in iter-103** — escalate to iter-104.

**Blueprint**: `Cohomology_MayerVietoris.tex` § Čech acyclicity. No
blueprint edits expected.

**State preservation (byte-for-byte)**:

- iter-101 (project) S1-S3 cumulative chain at L772-L800 — MUST preserve.
- `alternating_sum_pi_smul_aux` body at L478-L494 — iter-097 (project).
- `alternating_sum_pi_smul_aux_sum_comp` body at L513-L537 — iter-099 (project).
- `alternating_zsmul_pi_smul_aux_sum_comp` signature + body sorry at
  L539-L590 — iter-102 (project) inert infrastructure; Path B may fill.
- `cechCofaceMap_pi_smul` body prelude at L661-L771 — iter-092 through
  iter-101 cumulative.

## Off-limits this iteration

- `Differentials.lean` — `h_exact` deferred parallel to `instIsMonoidal_W`.
- `Modules/Monoidal.lean` `instIsMonoidal_W` — DEFERRED (Mathlib gap).
- `Jacobian.lean` `nonempty_jacobianWitness` — Phase C step C3, iter-104+.
- `Picard/Functor.lean` `representable` — gated on C0-C3.
- `AbelJacobi.lean`, `Genus.lean`, `Picard/LineBundle.lean`,
  `Picard/FunctorAb.lean` — DONE.
- BasicOpenCech L590 (Path B may fill; otherwise inert).
- BasicOpenCech L1436 (`g_R.map_smul'`), L1465 (`h_loc_exact`) — gated on
  Lane 1 closure.
- BasicOpenCech L894, L1218, L1246 — multi-iter Mathlib infrastructure
  gap.

## Streak escalation watch

This is the **4th consecutive prover lane** on the
`cechCofaceMap_pi_smul` trailing-sorry slot (iter-099/100/101 project +
this iter-103 project). The iter-102 (project) refactor pair was the
formal streak escalation per iter-101's mandate; the call-site
compilation failure means iter-103 effectively gets a "Path A first
attempt", but the criterion remains active.

If iter-103 (project) stalls on Path A, iter-102 (Archon canonical) /
iter-104 (project narrative) plan-agent MUST:

1. Commit unconditionally to Path B (fill new lemma body + restructure
   call site).
2. Forbid further tactic-only attempts on the existing `_sum_comp` call
   site.
3. If Path B compounds the heartbeat issue, escalate to Path C
   (top-level R-linear composite helper) — accept that closing this slot
   may need multi-iter cascading refactor work.

## Dispatcher target

Dispatcher fans out **1 prover** on:
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
