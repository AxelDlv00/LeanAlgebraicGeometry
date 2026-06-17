# Blueprint-clean directive — bc265

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — purity + structural pass over the regions
edited this iter by bw-tos265.

## Edited regions to clean
1. `lem:pullback_tensor_map_basechange` proof — the new Sq1-tail micro-assembly: the added
   `enumerate` (a)–(e) for `sheafificationCompPullback_comp_tail`, the new `\emph{The precise binding
   obligation.}` paragraph (the `forget ∘ pushforward = pushforward ∘ forget` compatibility bridge),
   and the new lemma block `lem:leftadjointuniq_app_unit_eta_general`
   (`\lean{...leftAdjointUniqUnitEta_app}`).
2. `lem:slice_dual_transport` proof — the step-(b) ε-naturality `% NOTE:` + prose naming
   `PresheafOfModules.restrictScalarsLaxε`.
3. Minor: the `presheafDualUnitIso` pin in `lem:dual_unit_iso`; the sequencing line in
   `lem:dual_restrict_iso`.

## What to enforce
- **Math-only prose.** Strip any Lean *tactic* language (e.g. "rw", "erw", "simp", "conv", "refine",
  "exact") if it leaked into the prose. Naming abstract lemmas / natural transformations as mathematical
  objects (e.g. `leftAdjointUniqUnitEta_app`, `comp_unit_app`, `unit_naturality`,
  `restrictScalarsLaxε`, `pushforwardComp`) is ALLOWED and intended — these are the named bricks the
  prover targets; keep them.
- **Structural validity.** The writer flagged a whole-file `\begin{lemma}`/`\end{lemma}` imbalance of
  +1 that it reports as PRE-EXISTING (delta 0 from its edits). VERIFY this: confirm the edits this round
  are internally balanced, and if you can cheaply locate and fix the stray pre-existing `\begin{lemma}`
  without altering any statement, do so; otherwise leave a `% NOTE:` flagging its approximate location
  for a later pass. Do not introduce any new imbalance.
- Do NOT add/remove `\leanok`/`\mathlibok`. Do NOT alter any statement body, `\lean{}` target, or
  `% SOURCE`/`% SOURCE QUOTE` block. Do NOT touch any other chapter.
