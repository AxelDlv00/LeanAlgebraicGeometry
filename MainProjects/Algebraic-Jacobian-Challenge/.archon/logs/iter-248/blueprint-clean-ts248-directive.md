# Blueprint Clean Directive

## Slug
ts248

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Focus
A blueprint-writer round (slug `ts-etabridge`) just added an η-bridge / D2′ unit-square subsection
("The unit square (D2′): a mate-calculus telescope") with six new lemma blocks
(`lem:presheaf_unit_comp_map_eta`, `lem:isiso_sheafifyeta_of_unitsquare`, `lem:eta_bridge_unit_square`,
`lem:comp_homequiv_factor_sheafify_pullback`, `lem:leftadjointuniq_app_unit_eta`,
`lem:epsilon_presheaf_to_sheaf_unit`) and revised the proof of `lem:pullback_tensor_iso_unit`.

Clean ONLY the newly-added/revised material around the D2′ unit-square subsection:
1. Strip any Lean-syntactic leakage (tactic names, `erw`/`simp` mentions, typeclass-resolution notes,
   Lean term-level details) from the new prose — keep it mathematical (adjunction units/counits,
   hom-set bijections, monoidal unit comparisons). Named *Mathlib lemma identifiers* used as the
   mathematical justification of a step (e.g. `Adjunction.unit_app_unit_comp_map_η`,
   `homEquiv_leftAdjointUniq_hom_app`, `comp_unit_app`) may remain as the cited governing identity — do
   not delete those, they anchor the formalization — but remove any prose that reads as a Lean tactic
   plan or implementation aside.
2. Remove any project-history phrasing ("iter-", "landed", "this iter", "handoff") if present.
3. This is Archon-original mate-calculus — there is NO external source. Do NOT add any
   `% SOURCE` / `% SOURCE QUOTE` / `\textit{Source:}` lines, and do not flag their absence.
4. Fix any LaTeX syntax issues in the new blocks (balanced braces in `\label`/`\uses`/`\lean`, matched
   `\begin`/`\end`, valid `equation`/`enumerate` environments).

## Out of scope
- Do NOT touch any block outside the D2′ unit-square subsection and the `lem:pullback_tensor_iso_unit`
  proof. Leave D3′, D4′, the group-law section, and all other sections untouched.
- Do NOT add/remove `\leanok` or `\mathlibok` markers.
- Do NOT alter the `\lean{}` pins (some name proposed-not-yet-existing Lean decls — that is intended
  forward-pinning).
