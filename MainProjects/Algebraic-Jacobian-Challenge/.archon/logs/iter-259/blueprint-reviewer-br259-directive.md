# blueprint-reviewer directive — br259

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Produce your standard
per-chapter checklist (complete / correct on both axes, must-fix-this-iter findings, proof-sketch
adequacy) plus the unstarted-phase proposals section.

## HARD-GATE focus for this iter
Two files are queued for prover dispatch this iter; their chapters must clear the gate:
- `Picard/SheafOverEquivalence.lean` → `Picard_SheafOverEquivalence.tex`
  (the `unitOverIso` proof sketch was expanded this iter by a writer to name
  `unitToPushforwardObjUnit` + the iso-reflection chain; `overEquivalence` + `chartOverIso` already closed).
- `Picard/TensorObjSubstrate.lean` → `Picard_TensorObjSubstrate.tex`
  (D3′ `pullbackTensorMap_restrict` / the Sq2/Sq2b `pullbackComp`-monoidality paragraph).

Confirm whether each chapter is `complete:true` + `correct:true` with no must-fix-this-iter finding
(the gate condition for adding the file to objectives).

## Context (prior verdict)
The iter-258 scoped re-review (br258-regate) cleared BOTH chapters `complete:true`, `correct:true`,
0 findings. This iter only additive maintenance edits landed (SheafOverEquivalence `unitOverIso`
sketch expansion; a stale-comment fix in `Picard_LineBundleCoherence.tex`). Flag any regression.

## Note
Known deferred/forward-spec items in non-active chapters (e.g. `Cohomology_CechHigherDirectImage.tex`
covers a `.lean` file not yet scaffolded; internal `Theorem~REF`/`Section~REF` placeholders in HELD
chapters) are tracked and do NOT block active routes — report them but mark non-blocking.
