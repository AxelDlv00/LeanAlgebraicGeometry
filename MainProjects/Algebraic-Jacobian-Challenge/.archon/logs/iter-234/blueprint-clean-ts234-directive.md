# blueprint-clean directive — slug ts234

Two chapters were edited this iter by blueprint-writers and need a purity + citation gate:

1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — writer `d2-sketch` expanded the proof
   sketch of `lem:stalk_tensor_commutation` into five named sub-steps, added a new partial-pin block
   `lem:stalk_tensor_desc_forward` (`\lean{PresheafOfModules.stalkTensorDesc}`, Archon-original — no
   external source, like `lem:stalk_linear_map`), and consolidated the associator narration onto the
   d.2 account.
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — writer `fbc-locality` added a
   "Locality of isomorphisms" supplement subsection with three `\lean{}`-pinned project-local lemma
   blocks (Archon-original supplements — no external source required) and updated the affine
   base-change proof sketch's first-reduction step.

## Tasks
- Strip any Lean tactic syntax / code leakage, project-history narration, or excess verbosity
  introduced by these edits (identifier names for lemmas/maps in prose are acceptable, as the
  chapters already use them).
- Validate that the verbatim `% SOURCE QUOTE` on `lem:stalk_tensor_commutation` (the Stacks
  `lemma-stalk-tensor-product` quote) was NOT altered — it must remain byte-for-byte as before.
- Confirm the new Archon-original blocks (`lem:stalk_tensor_desc_forward` and the three locality
  lemmas) correctly carry NO `% SOURCE`/`% SOURCE QUOTE` (they are project-bespoke; the source lines
  are correctly omitted) — do NOT fabricate a citation for them.
- Do NOT add or remove `\leanok` / `\mathlibok`.
- Report any residual contradiction in the associator narration (the writer flagged that the chapter
  still carries a dead duplicate whisker lemma `lem:islocallyinjective_whisker_of_W` with a competing
  proof body; note whether it still reads as a contradiction, but do NOT delete the lemma block —
  structural deletion is deferred to an explicit refactor pass).
