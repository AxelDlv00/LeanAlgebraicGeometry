# Blueprint-reviewer directive (iter-163) — whole-blueprint audit after the Route C pivot

Audit the WHOLE blueprint (all chapters under `blueprint/src/chapters/`) per your standard
per-chapter completeness + correctness checklist. This iter the **AbelianVarietyRigidity.tex**
chapter was substantially rewritten; pay particular attention there, but give the full
cross-chapter view as usual.

## What changed this iter (for your orientation — still audit everything)
The genus-0 base-case route was decided = **Route C (Milne, *Abelian Varieties*, §I.3)**, and the
chapter's base-case section was rewritten:
- The `\section{The theorem of the cube ...}` block (`thm:theorem_of_the_cube`) and
  `rmk:cube_is_load_bearing` were REMOVED. The prior claim that "ℙ¹→A constant rests on the
  theorem of the cube" was a MATHEMATICAL ERROR (corrected): Milne §I.3 derives it cube-free.
- A new section "The Milne §I.3 chain" was added with: `rmk:cube_not_needed`,
  `lem:hom_additivity_over_product` (Cor 1.5), `lem:av_regular_map_is_hom` (Cor 1.2),
  `lem:rational_map_to_av_extends` (Thm 3.2), `rmk:thm32_codim1_mathlib_gap`,
  `lem:hom_from_Ga_trivial` (Prop 3.9 core). `prop:morphism_P1_to_AV_constant` was rewritten.
- The plan agent then hand-corrected two blocks: `rmk:thm32_codim1_mathlib_gap` and the proof of
  `lem:hom_from_Ga_trivial`, to state correctly that the additive-defect map `ψ(x,y)=f(x+y)−f(x)
  −f(y)` lives on the surface `𝔾_a×𝔾_a` and must be extended to the complete `ℙ¹×ℙ¹` (Milne
  Thm 3.4 → Thm 3.2 surface case = Lemma 3.3) before the Rigidity Lemma applies — i.e. the surface
  rational-map-extension gap IS on the genus-0 path (NOT deferrable to Route A).

## Verify especially
1. Is the cube-excision mathematically correct (does any retained genus-0 block secretly need the
   cube/seesaw/square)? The proven Rigidity-Lemma chain blocks (`thm:rigidity_lemma` and its
   sub-lemmas) must read as untouched and still complete+correct.
2. Is `lem:hom_additivity_over_product` (Cor 1.5) — the intended next prover target — stated
   correctly and proved at formalizable detail from `thm:rigidity_lemma`? Are its hypotheses
   (V,W complete, V×W geom. irreducible, A a group object) faithful and load-bearing?
3. Is the `\uses` dependency graph forward-acyclic (no cycle reintroduced, no edge to the deleted
   `thm:theorem_of_the_cube`)?
4. Are the two hand-corrected blocks now mathematically sound and consistent with each other and
   with `lem:rational_map_to_av_extends`?
5. Citation discipline on the new blocks (Milne quotes present + faithful).

## Output
Your per-chapter checklist (complete? correct? proofs detailed enough? Lean targets well-formed?),
the dependency-graph acyclicity verdict, and any must-fix-this-iter findings. Report whether the
AbelianVarietyRigidity chapter clears the HARD GATE for a prover on `lem:hom_additivity_over_product`
(and `lem:av_regular_map_is_hom`) THIS iter.
