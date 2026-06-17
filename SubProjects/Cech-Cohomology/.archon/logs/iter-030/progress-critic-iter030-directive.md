# Progress critic — iter 030

Fresh-context convergence audit. Assess ONLY the trajectory signals below. Do NOT read
STRATEGY.md, blueprint chapters, or iter sidecars.

## Active routes under consideration for this iter's prover dispatch

### Route 1 — 02KG affine cover-system (files: AffineSerreVanishing.lean, and the
re-parameterization of FreePresheafComplex.lean)
Phase: 02KG affine instantiation. Entered this phase at iter-029. Strategy estimate when
it entered: ~2–3 iters left (now revised to ~3–4 after this iter's findings).

Signals (last 2 iters — this phase is young):
- iter-029: AffineSerreVanishing.lean NEW file scaffolded. +3 axiom-clean decls
  (`affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`).
  Status PARTIAL — stopped on genuine mathematics: 3 decls blocked
  (`standard_cover_cofinal`, `affine_surj_of_vanishing`, `affineCoverSystem`). No sorries
  (mathlib-build invariant). Blocker phrases: "design fork — injective_acyclic only covers
  ⊤-covers, field needs covers of D(f)"; "cofinality of standard covers — no Mathlib lemma";
  "epi of sheaves of modules ⇒ local surjectivity — genuine geometry".
- iter-030 (planned): re-parameterize FreePresheafComplex (mathlib-build) to dissolve the
  fork; AffineSerreVanishing's blocked decls deferred until the re-param lands.

### Route 2 — 01I8 tilde globalisation (file: QcohTildeSections.lean)
Phase: part of 02KG. Entered iter-029.
Signals:
- iter-029: NEW file scaffolded. +4 axiom-clean decls (conditional `qcoh_iso_tilde_sections`
  `[IsIso F.fromTildeΓ]` form + presentation form + 2 simp accessors). Status PARTIAL —
  stopped on ONE genuine gap: instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ`
  (affine global generation, ~few-hundred LOC, no Mathlib shortcut). Blocker phrase:
  "both essImage and global-presentation routes dead-end at the same gluing step".
- iter-030 (planned): mathlib-build lane to build the 3-step global-generation argument.

## Project-wide signals
- Total project sorry: 2 → 2 (both frozen/superseded, unchanged for many iters).
- iters 023–028: six consecutive first-attempt-COMPLETE iters.
- iter-029: FIRST iter where lanes stopped on real mathematics (not tactic failure);
  both handed off precise decompositions, zero sorries, zero churn.

## This iter's proposed objectives (file count + basenames)
2 prover lanes: `FreePresheafComplex.lean` (re-parameterization, mathlib-build) and
`QcohTildeSections.lean` (01I8 global generation, mathlib-build). Plus a small root-import
refactor and blueprint reconciliation (not prover lanes).

## Output
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). Key question: is this route
making genuine progress, or is "stopped on real math, handed off a decomposition" starting
to look like a route that keeps deferring the hard core? Name the corrective TYPE if any
route is CHURNING/STUCK.
