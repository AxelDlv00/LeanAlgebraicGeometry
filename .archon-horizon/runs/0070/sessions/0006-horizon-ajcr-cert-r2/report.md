Both threads acknowledged and my reconciliation is on the record. Final state verified: everything committed, root build green, nothing dirty in my files.

## Summary

Executed human decision I-0492 (R2). The two predecessor sessions landed the widened `DivFamZarAff` and had it audited; I found it was **a type with no functoriality** — nothing could base-change a widened class along `R → R'`, while the chart-typed `DivFamZar` owned an entire S5b layer. Built that layer, then closed the widened lane's producer gap. Eleven commits, six new files, all sorry-free and axiom-clean; root build green at 9164 jobs, exit 0.

Why it was cheap generalizes: the chart route reaches a piece *through* its chart (freeness, then localize at a generator), and both steps die on an arbitrary affine open — but `Over.pieceRingEquiv` was already in the tree from an unrelated lane at exactly the right generality (`IsAffineOpen` only, via mathlib's affine `pushoutSection`), with its cover map `rfl`-equal to `relCurveMap`.

## Progress
- `Picard/DivisorFamilyAffSections.lean`: new — `relSectionsBaseChangeAff` / `relQuotBaseChangeAff` at an **arbitrary** affine open; one declaration subsumes both chart-typed transports, since an overlap of affine opens is affine.
- `Picard/DivisorFamilyAffBaseChange.lean`: new — cover base change by **preimage**, making `pieces_baseChange` and the overlap identity `rfl` and deleting the whole `ovlGen` apparatus; plus `AffAdaptation.pullback` and the `hreg` discharge.
- `Picard/DivisorFamilyAffCert.lean`: new — **all seven** certificate clauses transport (`isCertified_pullback`).
- `Picard/DivisorFamilyAffMapAlg.lean`: new — `DivFamZarAff.mapAlg` + laws, `eq_of_away_eq`, `toAff_mapAlg` (so `toAff` is natural), and obligation 4(i) restated on the fibre curve.
- `Picard/DivisorFamilyAffExtraction.lean`: new — `exists_affAdaptation_of_isProper`: **every** system has a widened adaptation, no chart, no partitions. This was I-0539's actual complaint.
- `Picard/DivisorFamilyAffStraddle.lean`: new — `SwallowedBy` reduced to the Stacks 0B8B input alone (the "other pieces miss the support" half is free: the support is closed); the endpoint `exists_isCertified_of_swallowing_affineOpen`; a non-vacuity witness.
- `informal/spec-dd-r.md`: ADDENDUM 6. Roadmap `certificate` + `away-kerspan` rewritten; I-0565 files the residue, I-0563 the durable lesson.

## Issues
Two of my own claims were wrong; I caught both by probing my commits rather than trusting green files. The swallowed-cover producer **did not compose** with the adaptation constructor (subordination is required, containment isn't enough), and I recorded clean `#print axioms` as evidence before checking trap (c) of I-0442.

The root build was red at HEAD for part of the session from a sibling lane's parse error. My first green measurement used HEAD's blob swapped in — deliberate, to isolate my work — which is why this thread briefly carried both readings; I posted the reconciliation. Also worth knowing: `lake build` replayed a cached olean and kept reporting warnings I had already fixed, so grep the source before believing a warning or its absence.

## Why I stopped
**Partly advanced, deliberately not marked done.** The objective is substantively complete and the residue is now exactly two named geometric statements. But both helpers I dispatched ran over an hour without returning — the same failure the s0002 session hit — so the eleven commits are **self-checked only**. Review-priority notes are on the task.

## Next
The two remaining inputs (I-0565): the 0B8B statement in its *subordinate* form, and `hfib` from the seed's degree data. Everything between them and a certified class is landed.
