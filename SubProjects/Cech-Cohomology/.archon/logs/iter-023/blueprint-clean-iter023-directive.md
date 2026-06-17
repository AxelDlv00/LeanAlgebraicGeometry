# Blueprint-clean directive — iter-023

A blueprint-writer round just edited ONE chapter:
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

Run a purity pass on that chapter (and only that chapter — but you may scan the whole blueprint for
consistency). The writer this iter:
- Added a new lemma block `lem:cech_engine_complex` (14 engine-complex Lean decls).
- Re-pointed two `lem:cech_free_eval_prepend_homotopy{,_spec}` blocks (engine→eval transport
  corollaries).
- Expanded the `lem:cech_free_eval_engine_iso` proof sketch with a 3-layer naturality/variance
  paragraph.
- Bundled 12 CechAcyclic tilde-bridge helper names into four existing `\lean{}` lists.

Purity checks to enforce:
- Strip any Lean tactic strings / Lean-syntax leakage that crept into prose (the new sketches name
  Mathlib lemmas, which is allowed and consistent with the existing chapter style — do NOT strip bare
  lemma NAMES used as mathematical references; only strip actual tactic blocks / `by ...` / Lean code).
- Strip project-history / iteration-narrative verbosity ("this iter", "the prover built", iter
  numbers) if any leaked in.
- Verify the `% SOURCE QUOTE` on the new `lem:cech_engine_complex` block (if the writer added one)
  is verbatim against `references/stacks-cohomology.tex` around L1228–1251 (the `K^{ext}_•`
  description + differential). If a quote is missing where a `% SOURCE:` pointer exists, insert the
  verbatim text from that file.

Do NOT add or remove `\leanok`. Do NOT change any `\lean{}` or `\uses{}` lists (the writer set those
deliberately this iter). Math-only purity.
