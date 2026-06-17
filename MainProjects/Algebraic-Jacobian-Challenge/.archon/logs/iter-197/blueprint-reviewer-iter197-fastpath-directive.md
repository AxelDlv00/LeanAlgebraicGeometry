# blueprint-reviewer directive — iter-197 same-iter fast-path

## Slug
`iter197-fastpath`

## Scope: SAME-ITER FAST-PATH SCOPED REVIEW

This is a SCOPED-FAST-PATH dispatch per the blueprint-reviewer's
`dispatcher_notes` "Same-iter fast path" rule. The plan-phase
iter-197 ran three blueprint-writer dispatches to address the
must-fix-this-iter findings from the iter-196
lean-vs-blueprint-checker reports. `lake build` is GREEN
post-writers (verified, 8361 jobs replayed). The plan agent now
needs to know whether the writers' patches CLEAR the HARD GATE on
the chapters/files involved.

## Chapters to re-review (FOCUS — do NOT do a whole-blueprint pass)

- **`blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`** — patched
  by writer `h1v-mustfix-iter197`. Originally flagged 3 must-fixes +
  3 majors by `lean-vs-blueprint-checker-h1v` iter-196. Gates
  `H1Vanishing.lean` (Lane H) iter-197 prover.
- **`blueprint/src/chapters/AbelianVarietyRigidity.tex`** — patched
  by writer `avr-barescheme-mustfix-iter197`. Originally flagged 1
  must-fix + 4 majors (`avr` reviewer) + 1 must-fix + 2 majors
  (`barescheme` reviewer). Gates `AbelianVarietyRigidity.lean`
  (Lane E) AND `BareScheme.lean` (Lane BareScheme) iter-197 prover.
- **`blueprint/src/chapters/RiemannRoch_OCofP.tex`** — patched by
  writer `ocofp-pin-cleanup-iter197`. Originally flagged 0
  must-fixes + 3 majors. Gates `OCofP.lean` (Lane A) iter-197 prover.
  Also: the plan agent applied the 1-line `\leanok`-inside-`\uses`
  fix directly (blueprint-doctor finding). Verify both fixes
  present.

## What I need from you

For EACH chapter listed above, verify:

1. **Each prior must-fix-this-iter finding is addressed.** Cross-
   reference against the prior `lean-vs-blueprint-checker-{h1v,avr,barescheme,ocofp}.md`
   reports under `task_results/` (the originating findings).
2. **No NEW must-fix-this-iter findings emerged** from the patches.
3. **Every `\lean{...}` pin resolves** to either:
   - An existing Lean declaration in the project tree (you may
     verify by `lean_local_search` for the fully-qualified name OR
     reading the relevant `.lean` file), OR
   - A FUTURE substrate target whose pin block has a `% NOTE:` or
     similar prose stating it is unformalized (this is acceptable
     by the writer descriptor — writers leave future-target pins
     for the prover to land).
4. **No `\leanok` or `\mathlibok` markers were added by writers**
   (those are managed by sync_leanok / the review agent — adding
   them is a writer-rule violation).
5. **No new `\uses{...}` cycles or broken cross-refs.**

For chapter `AbelianVarietyRigidity.tex` specifically: confirm
that BOTH the AVR-targeted must-fix (`Proj.basicOpenIsoSpec_inv_app_top`
block) AND the BareScheme-targeted must-fix (`projectiveLineBar_geomIrred`
recipe expansion) landed. Since this is a consolidated chapter (declares
`% archon:covers ...`), one chapter audit covers two files for the
HARD GATE.

## Verdict format

Per-chapter, return: `complete: true | partial | false` AND
`correct: true | partial | false` AND `must-fix-this-iter: [list or
empty]`.

Final verdict block at the end:

```
HARD GATE clearance for iter-197 prover re-dispatch:
- `RiemannRoch_H1Vanishing.tex` → H1Vanishing.lean: CLEAR | BLOCKED
- `AbelianVarietyRigidity.tex` → AbelianVarietyRigidity.lean: CLEAR | BLOCKED
- `AbelianVarietyRigidity.tex` → BareScheme.lean (and ChartIso.lean): CLEAR | BLOCKED
- `RiemannRoch_OCofP.tex` → OCofP.lean: CLEAR | BLOCKED
```

The plan agent will use this verdict to add or HOLD the per-file
prover dispatches in iter-197 PROGRESS.md `## Current Objectives`.

## Out of scope

- Whole-blueprint audit (do NOT walk every chapter).
- Strategy-modifying findings (those are the strategy-critic's
  territory).
- Suggesting NEW must-fix items for chapters not patched this iter
  (`WeilDivisor.tex`, `RationalCurveIso.tex`, etc.) — those will be
  re-audited by the next full blueprint-reviewer dispatch.
- Auditing STRATEGY.md or PROGRESS.md.

## References

- Prior reviewer reports:
  - `task_results/lean-vs-blueprint-checker-h1v.md`
  - `task_results/lean-vs-blueprint-checker-avr.md`
  - `task_results/lean-vs-blueprint-checker-barescheme.md`
  - `task_results/lean-vs-blueprint-checker-ocofp.md`
- Writer reports landed iter-197 plan-phase:
  - `task_results/blueprint-writer-h1v-mustfix-iter197.md`
  - `task_results/blueprint-writer-avr-barescheme-mustfix-iter197.md`
  - `task_results/blueprint-writer-ocofp-pin-cleanup-iter197.md`
- Lean source files (you may read for `\lean{...}` pin resolution).

Report at `task_results/blueprint-reviewer-iter197-fastpath.md`.
