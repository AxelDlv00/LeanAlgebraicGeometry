# blueprint-clean directive — iter-233

Clean ONE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.

It was edited this iter to reroute the tensor associator onto the d.2 stalk-tensor
commutation (a new section `sec:tensorobj_stalk_tensor` with `lem:stalk_tensor_commutation`
+ `lem:islocallyinjective_whiskerleft_via_stalk`), to demote `lem:tensorobj_assoc_iso_invertible`
to a corollary (false flatness argument removed), and to annotate a deferred consumer.

Standard purity pass:
- Strip any Lean tactic syntax / Lean leakage from prose.
- Remove project-history verbosity and accumulated stale "route mismatch / deferred /
  historical record / superseded" narration where it no longer reflects the live proof
  graph (the live associator route is: presheaf associator transported through
  sheafification, with the single open left-whiskering obligation
  `lem:islocallyinjective_whisker_of_W` closed unconditionally via the d.2 lemma
  `lem:islocallyinjective_whiskerleft_via_stalk`). Do NOT delete live math content or
  the new d.2 section.
- Validate the new `% SOURCE:` / `% SOURCE QUOTE:` citation block on
  `lem:stalk_tensor_commutation` (it quotes references/stacks-modules.tex L2332-L2344,
  `lemma-stalk-tensor-product`); confirm the verbatim quote matches that file.
- Do NOT add or remove `\leanok`/`\mathlibok` markers.
- Flag (do not necessarily fix) any remaining internal contradiction about which
  whiskering route is "on the critical path".
