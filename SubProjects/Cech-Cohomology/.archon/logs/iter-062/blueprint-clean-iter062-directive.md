# Blueprint-clean directive — iter-062

Chapter just edited by blueprint-writer this iter:
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

Edits made this iter (verify purity around these regions):
1. `lem:pushPull_binary_coprod_prod` — a `% NOTE:` documenting two Lean-level formalization blockers
   (instance trap, Ab→ModuleCat bridge) was added inside the proof; two helper names bundled into `\lean{}`.
2. NEW node `lem:pushforward_iso_qcoh_of_slice_qcoh` (with a bundled private helper).
3. `lem:pushforward_iso_preserves_qcoh` retargeted to the `pullback ψ_r` route; two NEW build-target
   sub-lemmas added (`lem:slice_structureSheaf_hom`, `lem:pushforward_slice_pullback_iso` or similar names).
4. `lem:pushforward_commutes_restriction` demoted (`% NOTE: superseded`); two dead coyoneda anchor blocks
   (`lem:compCoyonedaIso_mathlib`, `lem:coyoneda_fullyFaithful_mathlib`) DELETED with reworded prose.

Your job: enforce blueprint purity on this chapter.
- Strip any Lean tactic syntax / code leakage that crept into the new prose (the `% NOTE:` LaTeX comments
  documenting Mathlib lemma names like `SheafOfModules.evaluation`, `isLimitOfReflects`,
  `SheafOfModules.pullback`, `Over.post_forget_eq_forget_comp` are ACCEPTABLE inside `%`-comments and in
  `\lean{}`/`\uses{}` — those are not prose leakage; only flag Lean *tactics* or code blocks in the
  rendered prose body).
- Remove project-history verbosity ("iter-061 prover handed off…", "the prover discovered…") if any
  landed in the rendered prose (move rationale into `%` comments if it must stay).
- Verify every `\uses{}` you can resolve points at a real `\label`; flag broken refs from the coyoneda
  deletions if any remain.
- Confirm LaTeX is balanced and the chapter still compiles structurally.
- Do NOT touch `\leanok`. Do NOT alter the mathematical content of the sketches.

You may spawn a reference-retriever (write-domain authorized) only if you find a `% SOURCE QUOTE:` that
is missing and needs fetching — but the `ψ_r` material is Archon-original and needs no source.
