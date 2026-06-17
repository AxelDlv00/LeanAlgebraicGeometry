# Blueprint-clean directive — `Picard_TensorObjSubstrate.tex` (iter-249)

Clean ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. This iter's plan-phase edits touched the
§ "The unit square (D2′): a mate-calculus telescope" region:

1. A new lemma block `lem:sheafification_comp_pullback_eq_leftadjointuniq` (the `rfl` linchpin) was added
   immediately before `lem:leftadjointuniq_app_unit_eta`.
2. `lem:epsilon_presheaf_to_sheaf_unit` (step 7) was retyped from a sheaf-level `Functor.LaxMonoidal.ε`
   statement to a `.val`-level (underlying-presheaf) reconciliation.
3. `lem:leftadjointuniq_app_unit_eta` got the linchpin added to its `\uses{}`.
4. The assembly lemma `lem:eta_bridge_unit_square` step-7 narrative sentence was rephrased to the `.val`-level
   form.
5. A `\uses{}` reflow on the proof of `lem:pullback_tensor_iso_unit` (removed a stray `\leanok` lodged inside
   the multi-line `\uses{}` braces).

## What to enforce (math-only purity)
- Strip any Lean syntax leakage that crept into the new/edited prose: bare `.val`, `_root_`, `:=`, tactic
  names, instance/typeclass jargon (`Functor.LaxMonoidal`, `IsIso`, `instance`), `#print`, file/line refs.
  Where the math genuinely needs to name a Lean object (e.g. the `(-).val` forgetful, `unitToPushforwardObjUnit`,
  `sheafificationCompPullback`, `leftAdjointUniq`), keep it in `\mathtt{}` as the rest of the chapter does — do
  NOT delete the mathematical content, just ensure it reads as mathematics, not as a code dump.
- Remove any project-history / iteration-narrative phrasing introduced in the new blocks ("iter-248", "the prover
  flagged", "landed axiom-clean", "this iter"), if any.
- Verify LaTeX balance (`\begin`/`\end`, braces, `\(`/`\)`, `\[`/`\]`) across the edited region.
- Do NOT add or remove `\leanok`/`\mathlibok` markers. Do NOT touch any block outside the D2′ telescope region.
- This material is Archon-original (no external source); do NOT insert `% SOURCE` quotes and do NOT spawn a
  reference-retriever — there is no source to fetch.

## Report back
Confirm the edited region is math-only and LaTeX-balanced; list anything you stripped; confirm no markers were
touched and no `\uses{}` edges were broken.
