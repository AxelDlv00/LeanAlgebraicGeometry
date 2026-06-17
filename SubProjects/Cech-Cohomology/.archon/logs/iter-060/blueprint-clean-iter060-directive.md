# Blueprint-clean directive — iter-060 purity pass

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` received two writer rounds this iter:
1. `blueprint-writer-iter060` — coverage-debt blocks (isZero_coyoneda_rightDerived, subsingleton_ext,
   enoughInjectives, ext_jShriekOU, overProd_coproduct_distrib_right) + expanded sketches for
   `lem:cech_backbone_left_sigma`, `lem:coproduct_distrib_fibrePower`.
2. `blueprint-writer-need1-route` — rewrote `lem:jshriek_transport_along_iso` (hjt) to the coyoneda-
   corepresentability route, rewrote `lem:pushforward_iso_preserves_qcoh` (hqc) to the `of_coversTop`/R1
   route, added 4 Mathlib anchors + `lem:pushforward_commutes_restriction` (R1), deleted 3 obsolete
   sub-lemmas (`pushforward_commutes_free/_sheafify`, `yoneda_transport_along_homeo`).

## Your job
Standard purity pass on the chapter: strip any Lean syntax / tactic strings that leaked into prose,
remove project-history verbosity ("this iter", "the prover", iter numbers, route-pivot narrative) from
the math blocks, confirm `% SOURCE`/`% SOURCE QUOTE` discipline on the touched blocks, and verify the
math-only invariant. Do NOT add or remove `\leanok`/`\mathlibok`. Do NOT change mathematical content or
`\uses{}` edges. Verify `leandag build --json` stays clean (`unknown_uses: []`, no isolated) after your
edits.
