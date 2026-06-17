# lean-vs-blueprint-checker directive — iter-235

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`

## The one blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

The relevant section is `§sec:tensorobj_stalk_tensor` (the d.2 stalk–tensor commutation,
`lem:stalk_tensor_commutation` / `PresheafOfModules.stalkTensorIso`), which lays out five
named stages (i)–(v). This iter the prover built **stage (iv) — the reverse map** as a
nested double-colimit descent (`revInnerLeg`/`revInner`/`revOuterLeg`/`revBihom` plus germ
characterizations), all `private` internal infrastructure, axiom-clean, 0 sorries. The
SOLE residual is the balancing lemma `revBihom_balanced` (and its consumer `stalkTensorRev`),
which was intentionally NOT added — a large in-file comment block describes the blocker
(a `restrictScalars`/CommRingCat-vs-RingCat carrier-duality wall on the section-level smul).

## What to check (bidirectional)

1. **Lean → blueprint:** do the landed `private` reverse-map declarations faithfully
   implement the stage-(iv) reverse map as described in the blueprint prose (the
   `germ_U a ⊗ germ_V b ↦ germ_{U⊓V}(a|⊗b|)` bilinear descent)? Any divergence between
   what the Lean builds and what stage (iv) specifies?
2. **Blueprint → Lean:** is the stage-(iv) prose detailed enough to have guided this
   formalization, or is it too thin (e.g. does it mention the balancing condition / the
   `restrictScalars` carrier-duality obstacle that the Lean actually hit)? Does the
   blueprint adequately describe what still remains (balancing + stage (v) bundle)?
3. Is the `% NOTE: forward-looking \lean{} pin — stalkTensorIso is NOT YET BUILT` annotation
   on `lem:stalk_tensor_commutation` still accurate (the iso is genuinely not built)?
4. Is the stage-(iii) pin `lem:stalk_tensor_linear_map` / `\lean{stalkTensorLinearMap}`
   correctly matched to the Lean declaration of that name?

Report any must-fix-this-iter findings (signature mismatch, fake/placeholder statement,
broken pin) separately from soft observations.
