# Blueprint-writer directive (iter-163) — purge the theorem-of-the-cube narrative from Jacobian.tex (align route (c) with Route C = Milne §I.3)

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Jacobian.tex`

## Why
The genus-0 base-case route was decided this iter = **Route C (Milne §I.3 rigidity completion)**,
which is **cube-free**: reading Milne §I.3 (Prop 3.9/3.10) showed "ℙ¹→A constant" is derived from
the Rigidity Lemma (= the project's proven `thm:rigidity_lemma`) via Cor 1.5 (additivity) + Cor 1.2
(AV maps are homs) + Thm 3.2 (rational-map extension, valuative criterion) + the 𝔾_a/𝔾_m
incompatibility — with NO theorem of the cube. The cube block was DELETED from
`AbelianVarietyRigidity.tex` this iter (the label `thm:theorem_of_the_cube` no longer exists).
`Jacobian.tex` still describes route (c) throughout as the "rigidity-lemma + theorem-of-the-cube
chain" and contains broken `\cref{thm:theorem_of_the_cube}` references and the now-FALSE claim that
"the cube is required" / "the Rigidity Lemma alone does not suffice for the base case".

## Required fixes (all occurrences — there are ~8; grep for `theorem_of_the_cube`, `theorem of the cube`, `cube`)
Replace the cube narrative with the correct Route C / Milne §I.3 description everywhere it appears,
specifically:
- **Remove every `\cref{thm:theorem_of_the_cube}`** (the label is deleted — these are broken refs).
- **Line ~6 (chapter intro):** change "via the rigidity-lemma + theorem-of-the-cube chain" to
  "via the Milne §I.3 rigidity chain (Rigidity Lemma + additivity Cor 1.5 + Cor 1.2 + rational-map
  extension), cube-free".
- **Item (c) at line ~397** and **the section heading at line ~448**
  (`\subsection{Route (c): rigidity via the theorem of the cube ...}`) and **its body at line ~453**:
  rewrite so route (c) is "rigidity via Milne §I.3 (cube-free)". The corrected mathematical content:
  the base case "ℙ¹→A constant" is NOT supplied by the theorem of the cube; it is supplied by the
  𝔾_a/𝔾_m incompatibility argument (Milne Prop 3.9), in which the additive-defect map
  ψ(x,y)=f(x+y)−f(x)−f(y) on 𝔾_a×𝔾_a is extended to the complete surface ℙ¹×ℙ¹ (Milne Thm 3.4 →
  Thm 3.2) and collapsed by the Rigidity Lemma. Cite `\cref{prop:morphism_P1_to_AV_constant}` and
  `\cref{thm:rigidity_genus0_curve_to_AV}` (these labels still exist in AbelianVarietyRigidity.tex);
  you MAY also cite the new sub-lemma labels `lem:hom_from_Ga_trivial`, `lem:hom_additivity_over_product`,
  `lem:rational_map_to_av_extends` from that chapter.
- **Lines ~417, ~434, ~481, ~523:** replace each "rigidity-lemma + theorem-of-the-cube chain" phrase
  with "Milne §I.3 rigidity chain (cube-free)"; keep the surrounding correct statements (decoupling
  from Route A, the [IsAlgClosed]/no-[CharZero] hypotheses, the fallback-(a) artifact note, the
  descent C.2.f narrative) intact — only the cube phrasing is wrong.
- Note the riskiest sub-build is now the surface rational-map-extension gap (Milne Lemma 3.3,
  pure-codim-1 indeterminacy on ℙ¹×ℙ¹ — no Mathlib Weil-divisor theory), per
  `AbelianVarietyRigidity.tex` `rmk:thm32_codim1_mathlib_gap`. Do NOT re-introduce any cube claim.

## Out of scope
- Do NOT touch `AbelianVarietyRigidity.tex` (already corrected this iter).
- Do NOT change protected signatures (`thm:nonempty_jacobianWitness`, `def:genusZeroWitness`,
  `def:positiveGenusWitness`, `Jacobian.*`) — only the prose describing route (c).
- Marker management (`\leanok`/`\mathlibok`): do not add/remove. You may keep/adjust `\lean{}` hints.

## Citation discipline
The cube-free derivation is sourced from Milne §I.3 (already quoted verbatim in
`AbelianVarietyRigidity.tex`); you do NOT need new verbatim quotes here (Jacobian.tex is a routing
narrative). If you state a NEW sourced claim, follow citation discipline (read
`references/abelian-varieties.pdf` via pypdf). Report any "Strategy-modifying findings".
