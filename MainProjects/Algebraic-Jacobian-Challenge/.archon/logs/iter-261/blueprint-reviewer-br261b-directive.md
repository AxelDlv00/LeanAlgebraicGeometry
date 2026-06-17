# blueprint-reviewer directive — SCOPED fast-path re-review (slug br261b)

This is a SCOPED fast-path re-review of ONE chapter, `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`,
after a writer (bw-tos261) + clean (bc-tos261) round THIS iter. The prior whole-blueprint review (br261)
returned this chapter `correct: false` (HARD GATE FAIL) on exactly two must-fix items, which the writer
was directed to fix:

1. `lem:dual_restrict_iso` proof sketch: the `sliceDualTransport`/leg-(A) paragraph was rewritten from
   the dead route-(1) (consume `overEquivalence`/`restrictOverIso`/`unitOverIso`) to route-(2)
   (`sliceDualTransport` built by hand = leg-A `eqToHom`-conjugation across `f.opensFunctor` along
   `image_preimage_of_le`, naturality `Subsingleton.elim` ∘ leg-B `restrictScalarsRingIsoDualEquiv`).
   Stale `\uses` edges `def:sheafofmodules_over_equivalence`, `lem:sheafofmodules_restrict_over_iso`,
   `lem:sheafofmodules_unit_over_iso` removed from both statement and proof blocks.
2. `lem:pullback_tensor_map_basechange` Sq2b prose: the `pushforwardComp_lax_μ` proof description
   corrected from the overstated `extendScalarsComp` build to the short sectionwise pure-tensor collapse;
   Sq2b removed from the "genuinely missing ingredients" list (only Sq1 `sheafificationCompPullback` +
   Sq4 `pullbackValIso` remain).

Confirm ONLY for this one chapter: is it now `complete: true` AND `correct: true` with NO must-fix-this-iter
finding? Verify the route-(2) sketch is mathematically rigorous and adequate to guide a prover on
`DualInverse.lean` (`sliceDualTransport` + `dual_restrict_iso`), and that the corrected Sq2b prose is
accurate and adequate to guide a prover on `pullbackTensorMap_restrict` (Sq1/Sq4 paste). Output the
per-chapter verdict for `Picard_TensorObjSubstrate.tex` and any remaining must-fix.
