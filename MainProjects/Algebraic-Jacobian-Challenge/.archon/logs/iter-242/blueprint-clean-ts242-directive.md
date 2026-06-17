# Blueprint-clean directive — slug `ts242`

Two chapters received blueprint-writer edits this iter. Clean both: strip any Lean-syntax leakage
(tactic strings, `:=`, `by`, Lean lemma-combinator names used as prose), remove project-history /
per-iter narrative, trim verbosity, and VALIDATE that every `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF`
is byte-accurate against its named local source file under `references/`.

## Chapters
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — writer `tos-pullback` rewrote the proof of
   `lem:pullback_unit_iso` (now a one-liner) and the §`sec:tensorobj_pullback_monoidality` narrative +
   the proof of `lem:pullback_tensor_iso` (the concrete-`P` + `leftAdjointUniq` route). Check the kept
   `% SOURCE QUOTE` for `lem:pullback_tensor_iso` (Stacks Modules `lemma-tensor-product-pullback`,
   `references/stacks-modules.tex`) is still byte-accurate. The route prose names Mathlib identifiers
   (`distribBaseChange`, `extendScalars.Monoidal`, `leftAdjointUniq`, `sheafificationCompPullback`) — these
   are acceptable as named ingredients in a proof sketch; do NOT strip the mathematical content, only
   genuine tactic-level Lean syntax if any leaked.
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — writer `fbc-pullback` added
   `lem:pullback_spec_tilde_iso` (with a fresh `% SOURCE QUOTE` + `% SOURCE QUOTE PROOF` from
   `references/stacks-schemes.tex`, Tag 01I9 `lemma-widetilde-pullback`, L1241–1269), expanded the proof
   of `lem:affine_base_change_pushforward`, and demoted `lem:gammaPushforwardIsoAt_naturality` to a prose
   remark. **VALIDATE the new Stacks 01I9 quote byte-for-byte against `references/stacks-schemes.tex`**
   (this is a freshly-retrieved source this iter — confirm the quote matches and the `(read from
   references/stacks-schemes.tex)` parenthetical is present).

## Authorization
`references/**` is in your write-domain so a child reference-retriever may be spawned if a quote needs
re-fetching. Do NOT add/remove `\leanok`/`\mathlibok`.
