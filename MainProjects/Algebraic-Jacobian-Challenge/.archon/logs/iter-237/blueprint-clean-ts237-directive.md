# blueprint-clean directive — iter-237

Two chapters were edited by blueprint-writers this iter; clean them (math-only purity):

1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — writer `d2wiring` added a
   coverage line for Vestigial.lean, two new lemma blocks (`lem:W_implies_stalkwise_iso`,
   `lem:stalk_tensor_commutation_naturality_right`), and rewrote the proof sketch of
   `lem:islocallyinjective_whiskerleft_via_stalk` into three movements.
2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — writer `fbcqc` rewrote the
   `lem:pushforward_spec_tilde_iso` proof (non-circular route-iii) and added three Γ-fragment
   lemma blocks (`lem:globalSectionsIso_hom_comp_specMap_appTop`, `lem:gammaPushforwardIso`,
   `lem:gammaPushforwardTildeIso`).

Tasks:
- Strip any Lean syntax / tactic strings that leaked into the new prose.
- Strip project-history / iter-number narrative if any leaked in.
- Validate existing `% SOURCE QUOTE` blocks are byte-intact (do NOT alter them); the new
  blocks are project-bespoke (no external source) and correctly carry no SOURCE lines — leave
  them unmarked.
- Do NOT add/remove `\leanok` or `\mathlibok` markers.
- Do NOT delete the off-path duplicate `lem:islocallyinjective_whisker_of_W`.
- If a new block genuinely needs a source quote you can locate, insert it (you may spawn a
  reference-retriever); otherwise leave bespoke blocks unsourced.
