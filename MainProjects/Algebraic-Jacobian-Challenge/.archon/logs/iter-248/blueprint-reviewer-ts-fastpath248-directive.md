# Blueprint Reviewer Directive — scoped fast-path

## Slug
ts-fastpath248

## Context
This is a sanctioned same-iter fast-path re-review. This iter a blueprint-writer (`ts-etabridge`) + a
blueprint-clean pass edited ONE chapter — `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — to
atomize the D2′ η-bridge proof into named atomic lemma blocks (the progress-critic ts248 corrective for a
STUCK route). I need the HARD GATE verdict for THIS chapter so a fine-grained prover can be dispatched on
the new atomic targets this iter.

## What changed in the TS chapter
A new subsection "The unit square (D2′): a mate-calculus telescope" and six new/revised blocks:
- `lem:presheaf_unit_comp_map_eta` and `lem:isiso_sheafifyeta_of_unitsquare` — pinned to Lean decls that
  ALREADY exist axiom-clean (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`).
- `lem:eta_bridge_unit_square` (the unit square, target of the telescope) + three ★ standalone step
  lemmas (`lem:comp_homequiv_factor_sheafify_pullback`, `lem:leftadjointuniq_app_unit_eta`,
  `lem:epsilon_presheaf_to_sheaf_unit`) — pinned to PROPOSED Lean names not yet in the file (intended
  forward-pins for the fine-grained prover to create; no `\leanok` expected on them).
- The `lem:pullback_tensor_iso_unit` (D2′) proof revised to chain through the above.

## Your task
Run your normal whole-blueprint audit (do not skip the cross-chapter view). In your report, give a clear
per-chapter verdict, and in particular state for `Picard_TensorObjSubstrate.tex` whether it is
`complete: true / correct: true` with NO must-fix-this-iter finding — specifically:
1. Are the new η-bridge atomic blocks mathematically sound and detailed enough for a fine-grained prover
   to formalize each step (the 7-step mate-calculus telescope: distribute → unit-naturality →
   composite-homEquiv factorisation → leftAdjointUniq transport → composite-unit expansion →
   presheaf-mate identity → ε reconciliation)?
2. Are the `\uses{}` cross-references accurate and the forward `\lean{}` pins (to proposed-not-yet-existing
   decls) acceptable as honest forward-planning (no spurious `\leanok`)?
3. Any placeholder/fake/circular statement among the new blocks?

This is Archon-original categorical mate-calculus — there is NO external source, so the absence of
`% SOURCE` lines on these blocks is correct, not a defect.

Also confirm the three earlier `\uses{\leanok ...}` LaTeX bugs in this chapter (proof envs of
`lem:tensorobj_assoc_iso`, `IsInvertible.tensorObj`, `IsInvertible.inverse_unique`) are now fixed
(the `\leanok` token moved out of the `\uses{}` braces).
