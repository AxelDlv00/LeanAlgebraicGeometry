# Iter-178 (Archon canonical) — review

## Outcome at a glance

- **The "7-lane post-HARD-STOP recovery iter; build restored
  GREEN after 2 consecutive broken-build iters; Lane 5 process-change
  audit verified WORKING; 1 sorry retired kernel-clean + 2 PARTIAL
  body advances + 1 directive dead-end documented" iter.**
- **`lake build AlgebraicJacobian` GREEN** — 8355/8355 jobs, 0
  errors, 70 sorry warnings. (Was 71 warnings + 1 error iter-177
  close.)
- **First green build in 3 iters.** The iter-178 plan's
  "signature-mutating lane" process-change checklist correctly
  classified Lane 5 (RatCurveIso) as the only mutating lane and
  verified zero current consumer breakage. The 4-minute
  parallel-signature-race that broke iter-176 and iter-177 was
  averted.
- **Lane 1 (FIX-BUILD #2) RESOLVED**: 1-LOC instance binder threading
  closed the iter-177 elaboration error in `OCofP.lean:335`.
- **Lane 7 (AB-PROJDIM) RESOLVED kernel-clean**:
  `Module.projectiveDimension` 1-line re-export of
  `CategoryTheory.projectiveDimension`. File 6 → 5 sorries.
- **Lane 4 (CodimOne-BODIES) — 1 RESOLVED + 1 PARTIAL**:
  `extend_iff_order_nonneg` closed kernel-clean (~3 LOC via
  `Scheme.RationalMap.mem_domain` swap-pair `Iff.intro`);
  `localRing_dvr_of_codim_one` main body lands with the Mathlib
  gap factored into 1 named helper sorry. File 4 → 3.
- **Lane 5 (RatCurveIso-FIX+BODY) PART A RESOLVED, PART B PARTIAL**:
  signature mutation on `iso_of_degree_one` from `≅` to `≃+*` (the
  auditor MUST-FIX); `morphismToP1OfGlobalSections` body now
  concrete `Over.homMk (Proj.fromOfGlobalSections …)` form,
  residual sorry on section-condition closure
  (undischargeable-from-current-signature; iter-179+ signature
  mutation queued).
- **Lane 6 (QS-IsIso) PARTIAL (structural)**:
  `canonicalBaseChangeMap_isIso` body now structural one-liner via
  `Scheme.Modules.Hom.isIso_iff_isIso_app`; substantive content
  factored into 1 named helper sorry carrying Stacks 02KH(ii) IsIso
  claim. File 6 → 6 (-1 +1).
- **Lane 3 (WD-DEGREE) PARTIAL**: `principal_degree_zero` constant
  branch closed axiom-clean; non-constant branch deferred (gated
  on Lane 5 Pin 1 + Hartshorne II.6.9). File 2 → 2 (one sorry now
  PARTIAL).
- **Lane 2 (AVR-IOTAGM) PARTIAL+DEAD-END**: directive's recipe
  `exact IsOpenImmersion.isDominant _` is a DEAD END — Mathlib has
  no such lemma. 5 attempts failed. Structural reduction to
  `DenseRange` landed for iter-179+ pickup. File 2 → 2.
- **No new project axioms** introduced this iter. Two iter-177 TEMP
  axioms remain (per the iter-181 RETIRE-OR-ESCALATE schedule).

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| 1 | FIX-BUILD #2 | RiemannRoch/OCofP.lean | SUCCESS | 0 (5 → 5) | build restored to green |
| 2 | AVR-IOTAGM | AbelianVarietyRigidity.lean | PARTIAL+DEAD-END | 0 (2 → 2) | directive recipe dead-end |
| 3 | WD-DEGREE | RiemannRoch/WeilDivisor.lean | PARTIAL | 0 (2 → 2) | constant branch closed |
| 4 | CodimOne-BODIES | Albanese/CodimOneExtension.lean | PARTIAL+SUCCESS | −1 (4 → 3) | 1 sorry kernel-clean closed |
| 5 | RatCurveIso-FIX+BODY | RiemannRoch/RationalCurveIso.lean | PARTIAL+SUCCESS | 0 (3 → 3) | sig fix + concrete body |
| 6 | QS-IsIso | Picard/QuotScheme.lean | PARTIAL (structural) | 0 (6 → 6) | helper-with-substantive-type |
| 7 | AB-PROJDIM | Albanese/AuslanderBuchsbaum.lean | SUCCESS | −1 (6 → 5) | kernel-clean one-liner |

**Net**: −1 sorry; build restored; 0 new project axioms.

## Build state diagnostics

```
$ lake build AlgebraicJacobian
…
warning: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:210:8: declaration uses `sorry`
…
✔ [8354/8355] Built AlgebraicJacobian (3.5s)
Build completed successfully (8355 jobs).
```

70 warnings (all `declaration uses 'sorry'`), 0 errors. Per-file:

- `AbelianVarietyRigidity.lean` — 2 (86, 321) — Lane 2 PARTIAL kept count
- `RigidityKbar.lean` — 1 (off critical path)
- `Genus0BaseObjects/BareScheme.lean` — 2 (Mathlib gap)
- `Genus0BaseObjects/GmScaling.lean` — 2 (off-target Mathlib gaps)
- `Genus0BaseObjects/Points.lean` — 1 (Mathlib gap)
- `Picard/LineBundlePullback.lean` — 5 (gated)
- `Picard/RelPicFunctor.lean` — 6 (gated on A.1.b)
- `Picard/FlatteningStratification.lean` — 7 (gated)
- `Picard/QuotScheme.lean` — 6 (Lane 6 −1+1)
- `Picard/FGAPicRepresentability.lean` — 7 (gated)
- `RiemannRoch/WeilDivisor.lean` — 2 (Lane 3 PARTIAL kept count)
- `RiemannRoch/OCofP.lean` — 5 (Lane 1 build only)
- `RiemannRoch/RationalCurveIso.lean` — 3 (Lane 5)
- `RiemannRoch/RRFormula.lean` — 3 (gated)
- `Jacobian.lean` — 2 (gated)
- `Albanese/AuslanderBuchsbaum.lean` — 5 (Lane 7 −1)
- `Albanese/Thm32RationalMapExtension.lean` — 1 (gated)
- `Albanese/CodimOneExtension.lean` — 3 (Lane 4 −1)
- `Albanese/AlbaneseUP.lean` — 7 (gated)

## Blueprint-doctor findings

1. **2 axiom declarations** (known): `gmScalingP1_chart_data_temp`,
   `gmScalingP1_collapse_at_zero_temp` in
   `Genus0BaseObjects/GmScaling.lean`. iter-181 RETIRE-OR-ESCALATE
   trigger live; the iter-178 `gmscaling-cover-bridge` consult
   produced the iter-179 refactor + body recipe.
2. **1 broken cross-reference** in `Albanese_CodimOneExtension.tex`
   L594-L596: `\leanok` macro is tucked inside a `\uses{...}`
   block; should be on its own line *after* the closing `}`.
   Review agent did NOT touch this (per `\leanok` ownership rule);
   recorded in recommendations.md for iter-179 blueprint-writer
   dispatch.

## Lessons learned this iter

### Process change validation

The iter-178 plan-agent's "signature-mutating lane" checklist
WORKED as intended:
1. Lane 5 audited as the only mutating lane (changes
   `iso_of_degree_one`'s hypothesis from `≅` to `≃+*`).
2. Downstream-consumer audit: `iso_of_degree_one` has no current
   consumer in any other file (only chained inside still-`sorry`
   `genusZero_curve_iso_P1`). Safe.
3. Build remains green.

**Recommendation**: keep this checklist as a permanent fixture of
the plan-agent's objectives-composition phase.

### Directive recipe quality control

Lane 2 (AVR-IOTAGM) exposed a directive recipe (`exact
IsOpenImmersion.isDominant _`) that was wrong on the math (the
implication is false for non-irreducible targets) AND wrong on the
Mathlib facts (no such lemma exists). The prover exhaustively
falsified the recipe across 5 attempts (~30 min of work) and the
file is in better-documented PARTIAL form. **Future plan-agent
directives that prescribe a one-liner via a specific Mathlib lemma
should verify the lemma exists before writing the directive** —
`lean_local_search` is free and fast.

### Gold standard for non-laundering pattern

Lane 6 demonstrates the gold-standard for "helper-with-sorry as
honest scaffold" (already KB-recorded iter-177):

- Main body: 1-liner via canonical Mathlib idiom
  (`Scheme.Modules.Hom.isIso_iff_isIso_app`).
- Substantive content: factored into a named helper with a
  *substantive `IsIso` type* (NOT a tautology, NOT `:= 𝟙 X`).
- Blueprint readers can see exactly which Stacks tag is the
  remaining work item (02KH(ii)).

Contrast iter-176 RelativeSpec laundering (placeholder bodies
`:= X` / `:= 𝟙 X`). Lane 6 belongs in the iter-179 KB review as
fresh evidence the pattern works.

## Subagents dispatched this phase

- `lean-auditor` (slug: `iter178-touched`) — whole-project audit
  (38 files) with focus on iter-178 file changes. Background
  dispatch at review-phase start; report at
  `task_results/lean-auditor-iter178-touched.md`.
  **Verdict**: 3 must-fix-this-iter, 9 major, 6 minor, 3
  excuse-comments. The 3 must-fix landed at TOP of
  `recommendations.md`:
  - **178A** (CRITICAL): `RationalCurveIso.lean:226-243` Lane 5
    Part B EXCUSE-COMMENT confessing the signature is
    mathematically insufficient (recurrence of iter-175 KB
    `chart-bridge-prover-bypass` pattern).
  - **178B** (CRITICAL): `CodimOneExtension.lean:391-406` Lane 4
    `extend_iff_order_nonneg` body shallow + UNUSED KrullDimLE
    binder + docstring overclaims.
  - **178C** (MUST-FIX, low effort): `AuslanderBuchsbaum.lean:165-167`
    Lane 7 stale docstring + module status block.

  The major-class findings are largely stale "Status (iter-NNN)"
  annotations across 9 files — bundled status-hygiene refactor
  recommended for iter-179.

## Subagent skips

- **lean-vs-blueprint-checker**: not dispatched per-file. 7
  prover-touched files but every closure/advance is on an existing
  chapter pin with no semantic chapter-redesign requirement.
  Lane 5 Part A signature change (`≅` → `≃+*`) matches the
  iter-178 plan auditor-driven intent and is already covered in
  the chapter prose. lean-auditor covers the cross-cutting layer.

## TO_USER.md content

Refreshed with: iter-178 consult outcomes
(`gmscaling-cover-bridge` Steps 1-2-3 plan;
`relative-spec-encoding` 4-option Blocks A/B/C plan); confirmation
the iter-178 process-change averted the parallel-signature-race;
the iter-181 RETIRE-OR-ESCALATE trigger remains armed.
