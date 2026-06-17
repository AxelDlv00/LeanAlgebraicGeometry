# Blueprint-reviewer directive — iter-064

Whole-blueprint audit (your standard per-chapter checklist). Focus this iter's HARD-GATE decision on the
consolidated chapter `Cohomology_CechHigherDirectImage.tex`, which covers both files about to receive prover
work: `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`.

## What changed this iter (verify these are complete + correct)
A blueprint-writer + blueprint-clean pass decomposed two terminal monolithic lemmas into fine-grained,
`\uses`-linked sub-lemmas (so a fine-grained prover can close one atomic claim per step), and corrected one
provably-wrong definition:

Part A (CSI route) — `lem:pushPull_coprod_prod` split into: `lem:sigmaOptionIso`, `lem:pushPullObjCongr`,
`lem:over_sigmaOptionIso`, `lem:piOptionIso`, `lem:pushPull_coprod_prod_empty`, plus coverage
`lem:pushPullCoprodLegIso`; the parent's proof rewritten as an `induction_empty_option`.

Part B (OpenImm route) — `lem:pushforward_slice_two_adjunction` split into `lem:slice_overs_equiv_continuity`
(6-helper coverage anchor), `lem:slice_reverse_ring_map` (the φ'' construction), `lem:pushforward_slice_adjunction_h1`,
`lem:pushforward_slice_adjunction_h2`; φ'' was CORRECTED (the old `sliceStructureSheafHom φ⁻¹ Vᵢ` was a
type-mismatch; new φ'' is the object-level-correction-free over-pullback of `φ.hom.toRingCatSheafHom`,
correction living only in H₁/H₂). 4 `\mathlibok` anchors added. Correction propagated to
`lem:pushforward_slice_pullback_iso`.

## Decision needed
Report, per the chapter checklist, whether `Cohomology_CechHigherDirectImage.tex` is `complete: true` and
`correct: true` with no must-fix-this-iter finding. In particular check:
- the new sub-lemma statements are well-formed targets (real provable claims, faithful signatures);
- the φ'' correction is mathematically coherent and consistently propagated;
- no broken `\uses{}`; the decompositions' dependency edges are accurate;
- coverage debt for this iter's built helpers is now blueprinted.
Flag any sub-lemma whose statement is false-as-written or whose `\lean{}` target shape is wrong.
