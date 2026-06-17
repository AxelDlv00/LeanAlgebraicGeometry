# blueprint-clean ts238 directive

Two chapters were edited this iter. Clean both: strip any Lean-syntax leakage, project-history /
iter-narrative verbosity, and fix/validate source quotes. Do NOT add or remove `\leanok` /
`\mathlibok` markers.

## Chapters to clean

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — the blueprint-writer `fbcdax` expanded the
   proof of `lem:pushforward_spec_tilde_iso` with an element-free `D(a)`-level transport recipe and
   added three Archon-original helper blocks (`lem:powers_restrictScalars`,
   `lem:fromTildeGamma_app_isIso_of_localized`, `lem:pushforward_spec_tilde_iso_conditional`). Confirm
   the new prose carries no Lean tactic strings, the three new blocks are correctly UNcited
   (Archon-original — no `% SOURCE` needed), and the pre-existing `% SOURCE QUOTE` blocks are
   byte-intact.

2. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — the plan agent repaired one malformed
   `\uses{}` brace in the proof of `lem:islocallyinjective_whiskerleft_via_stalk` (a stray `\leanok`
   that had been embedded inside the `\uses{...}` list was relocated to its own line before the
   `\uses`). Confirm the `\uses{}` now lists exactly the four labels
   (`lem:stalk_tensor_commutation`, `lem:stalk_linear_map`, `lem:W_implies_stalkwise_iso`,
   `lem:stalk_tensor_commutation_naturality_right`) and parses cleanly. Do not alter the group-law
   section. (This chapter was NOT otherwise edited this iter; only the brace repair.)

Authorized to spawn a reference-retriever if a missing source quote must be inserted (none expected).
