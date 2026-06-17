# Blueprint-reviewer directive — iter-204 (slug iter204)

Perform your standard whole-blueprint audit. Read the entire blueprint
tree under `blueprint/src/chapters/` (chapters are `\input` via
`blueprint/src/content.tex`). No scope limiting — the cross-chapter view
is the point.

Deliver:
1. Your per-chapter checklist (`complete` / `correct` verdict per chapter,
   with the specific incompleteness or incorrectness flagged).
2. Any must-fix-this-iter findings, clearly tagged.
3. Your `## Unstarted-phase blueprint proposals` section — name every
   strategy phase with no blueprint coverage and give a concrete chapter
   outline for each.

Context for prioritisation (do NOT let it bias your audit):
- The only chapter feeding a LIVE prover lane this iter is
  `Picard_TensorObjSubstrate.tex` (Lane TS: `tensorObj_isLocallyTrivial`,
  `exists_tensorObj_inverse`, `monoidalCategory`). Please be especially
  careful that its proof sketches for those three are detailed enough to
  formalize.
- `Albanese_CodimOneExtension.tex` is being paused as a prover lane this
  iter (escalation), but please still audit it.
- Two chapters edited this iter: `Picard_TensorObjSubstrate.tex` (fixed a
  malformed `\uses{}`) and `Albanese_CodimOneExtension.tex` (corrected a
  drifted verbatim recipe signature in `subsec:stage6_iib_substrate_iter200`).
