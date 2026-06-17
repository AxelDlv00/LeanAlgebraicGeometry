# Blueprint-reviewer directive — br265 (scoped fast-path re-review)

This is a HARD-GATE fast-path re-review. The consolidated chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` was expanded this iter (bw-tos265 + bc265) to
fix two proof-sketch adequacy gaps that a prior per-file check (iter-264) flagged as MAJOR and that the
progress-critic (pc265) confirmed are contributing to a STUCK route:

1. The D3′ **Sq1-tail micro-assembly** in `lem:pullback_tensor_map_basechange` was under-specified: it
   named the route but omitted the explicit step ordering. It now has an ordered (a)–(e) assembly, a new
   pinned recovery brick `lem:leftadjointuniq_app_unit_eta_general`
   (`\lean{...leftAdjointUniqUnitEta_app}`), and a named binding obligation (the
   `forget ∘ pushforward = pushforward ∘ forget` compatibility bridge) flagged as the sub-lemma to isolate
   before assembly.
2. The DUAL **`sliceDualTransport.naturality` step (b)** lacked the Lean helper name; it now names
   `PresheafOfModules.restrictScalarsLaxε`.

## What I need from you
Confirm the HARD GATE for `Picard_TensorObjSubstrate.tex` (the consolidated chapter, which covers both
active prover lanes `TensorObjSubstrate.lean` and `DualInverse.lean` this iter):
- `complete: true/false`, `correct: true/false`, and any `must-fix-this-iter` findings touching THIS
  chapter.
- Specifically verify: (i) the new (a)–(e) Sq1-tail assembly is mathematically coherent and actionable
  (a prover could follow it without consulting the closed analog directly); (ii) the new lemma block
  `lem:leftadjointuniq_app_unit_eta_general` is well-formed (label, `\lean{}`, `\uses{}`); (iii) the
  DUAL ε-helper note is correct; (iv) no `\begin{lemma}`/`\end{lemma}` imbalance was introduced this round
  (a +1 imbalance was reported as pre-existing — confirm it is not newly introduced and is not a broken
  block that would mis-typeset the new content).

You read the whole blueprint as always, but the verdict that matters for this gate is on
`Picard_TensorObjSubstrate.tex`. Report per-chapter checklist as usual; flag any cross-chapter breakage
the edits may have caused (broken `\cref`/`\uses`).
