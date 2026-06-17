# blueprint-clean directive — iter-243

Two chapters were edited this iter by blueprint-writers. Clean them: strip any Lean-syntax leakage
(tactic strings, `\leanok`/`\mathlibok` markers — those are owned by sync/review, NOT the writer or you),
remove project-history verbosity / per-iter narrative from rendered prose (it may live in `% comments`),
and VALIDATE every `% SOURCE QUOTE:` against the named local reference file (re-read and confirm
character-for-character; insert a missing quote only if you can read it from the cited file). Do not change
the mathematical content.

## Chapters to clean
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — section `sec:tensorobj_pullback_monoidality`
   was substantially rewritten (Lane A pivot to the local-trivialization route). New/changed blocks:
   `lem:presheaf_pushforward_laxmonoidal`, `lem:presheaf_pullback_oplaxmonoidal`, `lem:pullback_tensor_map`,
   `lem:isinvertible_implies_locallytrivial`, the descoped `lem:pullback_tensor_iso` remark, and the
   rewritten `lem:isinvertible_pullback` proof. Source quotes are from `references/stacks-modules.tex`
   (lemma-invertible L4066–4079; lemma-invertible-is-locally-free-rank-1 L4159–4165 + proof L4186–4198;
   lemma-pullback-invertible L4142–4157).
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — added `lem:gammaPushforwardNatIso`,
   `lem:base_change_map_affine_local`, `lem:pushforward_base_change_mate_cancelBaseChange`, plus a new
   subsection heading. Source quotes are from `references/stacks-coherent.tex` (lemma-affine-base-change,
   L905–938).

You are authorised `references/**` so you may spawn a reference-retriever if a quote is missing — but both
writers reported all quotes were already present locally, so retrieval should not be needed.

Report any Lean-leakage strips, any quote that failed validation, and confirm LaTeX env balance.
