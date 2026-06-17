# blueprint-reviewer directive — iter-237 (scoped re-review / HARD-GATE fast path)

Run your standard whole-blueprint audit. The GATE DECISION this iter concerns ONLY the two
chapters edited this iter by blueprint-writers + blueprint-clean; confirm each is `complete: true`
AND `correct: true` with no must-fix-this-iter finding, so the two prover lanes can dispatch THIS
iter (fast path). Report per-chapter as usual, but pay particular attention to:

## Chapter 1 — `Picard_TensorObjSubstrate.tex` (covers TensorObjSubstrate.lean, StalkTensor.lean,
and now Vestigial.lean — coverage line added this iter)

Edited this iter to support the next critical-path prover lane (closing
`lem:islocallyinjective_whiskerleft_via_stalk` = `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`
in Vestigial.lean, now that the d.2 iso `stalkTensorIso` is built axiom-clean). Verify:
- The new coverage line for `Vestigial.lean` is present and well-formed.
- The two NEW lemma blocks are mathematically correct and detailed enough to formalize:
  `lem:W_implies_stalkwise_iso` (d.1-bridge: `J.W g ⟺ stalkwise iso` on `Opens X`) and
  `lem:stalk_tensor_commutation_naturality_right` (B-naturality of `stalkTensorIso`, identifying
  `(A◁g)_x` with `LinearMap.lTensor A_x g_x`).
- The rewritten proof sketch of `lem:islocallyinjective_whiskerleft_via_stalk` (three movements:
  d.1-bridge → whiskered-stalk identification → flatness-free `lTensor` conclusion) is coherent and
  its `\uses{}` resolve. Confirm the Mathlib lemmas it cites are plausibly the right idiom.
- The StalkTensor section (`sec:tensorobj_stalk_tensor`) is unchanged and remains correct.

## Chapter 2 — `Cohomology_FlatBaseChange.tex`

Edited this iter to fix the two findings from the iter-236 lean-vs-blueprint check:
- The CIRCULAR QC dependency in `lem:pushforward_spec_tilde_iso`'s proof was rewritten to the
  non-circular route-(iii) (basic-open locality via `lem:modules_isIso_of_isBasis` + IsLocalizedModule;
  QC stated AFTER the object iso, as a corollary). Verify the new sketch is genuinely non-circular and
  formalizable.
- Three Γ-fragment lemma blocks were added (`lem:globalSectionsIso_hom_comp_specMap_appTop`,
  `lem:gammaPushforwardIso`, `lem:gammaPushforwardTildeIso`) pinning the iter-236 decls. Verify the
  `\lean{}` pins match the formalized declarations and the statements are correct.

## Output
Whole-blueprint checklist as usual. For the gate, state clearly per the two chapters above whether
each is complete+correct with no must-fix. If either still fails, name the specific residual.
