# blueprint-reviewer br257-regate — fast-path scoped re-gate (iter-257)

This is a SCOPED re-review (HARD GATE fast path) of the two chapters that failed your br257 gate and have
since been fixed by blueprint-writers (bw257-d3, bw257-eng) + cleaned (bc257). The `lake build` is GREEN.
Give a focused complete/correct verdict on EXACTLY these two chapters and confirm whether the specific
br257 must-fixes are now resolved. (Read the rest of the blueprint as needed for cross-refs, but report
only on these two.)

## Chapter 1: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Confirm the two br257 must-fixes on D3′ `lem:pullback_tensor_map_basechange` are resolved:
- **MF-1 (statement form):** the STATEMENT must now describe the GENERAL composition coherence of the
  pullback tensorator δ for any `h : Z → Y`, `f : Y → X`, `M N : X.Modules` (δ for `h∘f` factoring through
  the δ's for `f` and `h` conjugated by `pullbackComp h f`), matching the Lean signature of
  `pullbackTensorMap_restrict` — NOT the old base-change-square specialization. The square form should
  appear only as a derived remark/corollary.
- **MF-2 (proof sketch):** the proof sketch must now describe the 4-square comp_δ route (Sq1
  `sheafificationCompPullback`-comp, Sq2 δ-core via `comp_δ`+`pullbackComp`+ring-map reconciliation, Sq3
  `sheafifyTensorUnitIso`, Sq4 `pullbackValIso`-comp), naming Sq1/Sq4 as the two deferred project
  sub-lemmas, with the disproven "same mate calculus as pullbackObjUnitToUnit_comp" framing removed.

Also confirm the `lem:dual_restrict_iso` proof sketch (leg-A `sliceDualTransport` pin) remains
complete+correct, and that this consolidated chapter (covers `Picard/TensorObjSubstrate.lean` AND
`Picard/TensorObjSubstrate/DualInverse.lean`) is now `correct: true` so BOTH covered files clear the gate.

## Chapter 2: `blueprint/src/chapters/Picard_LineBundleCoherence.tex`

Confirm the two br257 must-fixes are resolved:
- **MF-3 (finiteness bridge):** the `lem:lbc_chart_presentation` / `thm:lbc_isFinitePresentation` proof
  sketches must now name the `Presentation.ofIsIso` + automatic `IsFinite` instance bridge (so the prover
  knows how `mk` is fed and that no 6th declaration is needed).
- **MF-4 (false `\leanok`):** the erroneous proof-block `\leanok` on `chartPresentation` must be gone.

## Deliverable

For each chapter: `complete: true|false`, `correct: true|false`, and an explicit list of any REMAINING
must-fix findings. If both chapters are `complete:true` + `correct:true` with no must-fix, say so plainly —
that clears the gate for `Picard/TensorObjSubstrate.lean`, `Picard/TensorObjSubstrate/DualInverse.lean`,
and `Picard/LineBundleCoherence.lean` to enter this iter's prover objectives.
