# lean-vs-blueprint-checker directive (iter-254) — TS-inv

Bidirectional verification of ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(consolidated chapter; focus on the A-bridge block `lem:sheafofmodules_hom_of_local_compat` and the
dual-inverse chain blocks that correspond to DualInverse.lean).

## What changed this iter (focus)
- `homOfLocalCompat` (`lem:sheafofmodules_hom_of_local_compat`): the `hf` compatibility hypothesis
  was RE-SIGNED from an `HEq`-of-pullback-images form to a SECTIONWISE-equation form
  (the two `f i`/`f j` section maps agree, `eqToHom`-conjugated into the fixed group `M(V) ⟶ N(V)`).
  CRITICAL CHECK: does the blueprint's stated `hf`/compatibility condition match this sectionwise
  Lean signature? If the blueprint still describes the old `HEq` form, flag the chapter as needing a
  writer update (blueprint→Lean mismatch). Sub-step (a) is closed; sub-step (c) has one residual
  `sorry` (open-immersion ring-bridge). Confirm the chapter's sub-step decomposition matches.
- new helper `image_preimage_of_le` (down-set image identity `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`): is it
  represented in the chapter, or an undocumented infrastructure lemma?
- `dual_restrict_iso` (Step-4 sorry, untouched this iter): just confirm `\lean{}` pin still matches.

## Report
Bidirectional. Flag must-fix-this-iter items, especially any blueprint→Lean signature mismatch on
the re-signed `hf`.
