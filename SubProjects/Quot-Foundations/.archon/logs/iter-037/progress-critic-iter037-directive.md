# Progress-Critic Directive — iter-037 (Quot-Foundations)

Fresh-context convergence audit. For each route below: is it converging, churning (helpers without
residual reduction), or stuck (no sorry-elimination / structural advance in K iters)? K window = iters
033–036 (4 iters). Note: QUOT/GR carry protected-stub or 0-sorry counts where the real progress signal
is axiom-clean keystones landed, not the file sorry count.

## Route: FBC-A — Cohomology/FlatBaseChange.lean

- Sorry trajectory: 4 → 4 → 4 → 4 (iter-033..036). Flat. The file's 4 sorries = `_legs` (dead, off
  critical path), `gstar_transpose` (TARGET), + 2 gated downstream.
- Helpers added per iter: +2 (033), +2 (034, conj-0 foundation), +7 (035, atomized conjugate chain),
  +1 (036, step (b) `extendScalars_inner_value_counit`/`gstar_generator_close` — PROVED axiom-clean).
- Prover status: PARTIAL, PARTIAL, PARTIAL, PARTIAL.
- Recurring blocker phrases: "section-composite→conjugateEquiv reframing" (033, 034, 035 — 3 consecutive);
  CHANGED at 036: that `_legs`/conj-2a cluster declared DEAD/off-critical-path; remaining work re-scoped to
  "inline step-(a) reindex (from the now-PROVED `inner_eCancel_*` atoms + Seam-1) + dictionary cancellation
  glue" on `gstar_transpose` directly. At iter-036 ALL named sub-ingredients (steps (a)-atoms, (b), (c)
  master identity `huce`) are PROVED standalone; the only open work is assembly glue.
- Strategy Iters-left est: 1–2. Conjugate sub-phase entered ~iter-034; route-level ~iter-022.
- iter-037 proposal: [prover-mode: fine-grained] — assemble the proved atoms (inline step-(a) reindex
  bypassing the dead `_legs`, plug step (b) `gstar_generator_close` + step (c) `huce`, dictionary
  cancellation) to close `gstar_transpose`. Escalation tripwire pre-set: if this closes nothing AND no
  inline step-(a) lemma lands, iter-038 = mathlib-analogist on the cancellation (NOT another vehicle, NOT
  user escalation).

## Route: QUOT — Picard/QuotScheme.lean

- Sorry trajectory: 4 → 4 → 4 (iter-035..036), all 4 = pre-existing PROTECTED stubs (out of scope); every
  gap1 deliverable is NEW axiom-clean decls (flat stub count is a known false-negative here).
- Helpers added per iter: +6 (035, gap1-D cover-form keystone, COMPLETE), +3 (036, `gammaPullbackTopIso` +
  general-in-V `gammaPullbackImageIso` + naturality, COMPLETE — the entire `lem:pullback_gamma_top_iso`).
- Prover status: COMPLETE (035), COMPLETE-on-primary-objective (036; the downstream Hfr chaining was
  correctly assessed as a multi-ingredient build, not deferred churn).
- Recurring blocker phrases: "slice→Spec R_r transport" — object form resolved 034, SECTION form
  (`gammaPullbackTopIso`) resolved 036; now two NAMED Mathlib-absent ingredients remain ((I) ring-iso-
  semilinear `IsLocalizedModule` transport, (II) base-change-of-localization R→R_r). A decreasing,
  resolving list, not a repeated wall.
- Strategy Iters-left est: 3–6. gap1 phase entered ~iter-031.
- iter-037 proposal: [prover-mode: mathlib-build] — build (I) then (II), chain to Hfr, instantiate the
  landed `_of_cover` keystone to close named descent + gap1.

## Route: GR — Picard/GrassmannianCells.lean

- Sorry trajectory: 0 → 0 → 0 (034..036). 0-sorry discipline maintained; progress signal = axiom-clean
  keystones.
- Helpers added per iter: +7 (034, isSeparated COMPLETE), +7 (035, isProper reduced to E1–E4 PARTIAL),
  +3 (036, E1 chart factorization + E2 minimal valuation + E3 ratio core, COMPLETE on E1 target).
- Prover status: COMPLETE (034), PARTIAL (035), COMPLETE-on-target (036; E1 was the assigned target and
  fully proved, plus E2 + E3 ratio core fully proved — no sorry stubs).
- Recurring blocker phrases: E1 chart factorization (named 035, RESOLVED 036); now E3-full bottoms at the
  blueprint-FLAGGED cofactor-expansion matrix gap (det of a column-substituted identity = entry up to
  sign) — a single concrete missing-Mathlib lemma, scoutable.
- Strategy Iters-left est: 1–3. GR-proper phase entered ~iter-035.
- iter-037 proposal: [prover-mode: mathlib-build] — build the cofactor helper, close E3-full
  `existence_factor_through_valuationRing`, then E4 → valuativeExistence → isProper.

## PROGRESS.md Current Objectives proposal (this iter)

3 files (cap 10): FlatBaseChange.lean [fine-grained], QuotScheme.lean [mathlib-build],
GrassmannianCells.lean [mathlib-build]. Import-independent. No protected-stub files dispatched for stub
fills; no ready-but-skipped lanes (FBC-B/GF gated on FBC-A affine / gap1 respectively).
