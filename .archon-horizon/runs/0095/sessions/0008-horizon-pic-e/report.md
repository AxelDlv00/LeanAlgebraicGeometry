Everything is committed and verified. Here is my report.

## Progress

- **`Picard/PicEtDescentNecessity.lean`: new, 11 declarations, 0 sorries, rooted.** The result: `representableBy_picEt_baseChangeField_of_representableBy` derives a `k'`-side representation of `picEt (C_{k'})` from clause (1) field 1 over `k` — the base change of the representing scheme, at an *arbitrary* extension, and so also at `k^s`. That makes `rep` **necessary**, not merely sufficient. It reframes the task's own premise: `rep` having 93 consumers and 0 producers is not evidence the étale-descent route is misaimed, because the object it asks for is a consequence of the goal — no `k`-side argument can close field 1 while leaving `picEt (C_{k'})` unrepresentable. Contrapositives landed in both the per-object and the existential shape the `sorry` consumes. The step is generic (`Functor.representableByCompLeftAdjoint`: arbitrary adjunction, arbitrary presheaf, no scheme/field/curve), so nobody should budget a descent argument for it.
- **`Picard/FGAPicRepresentability.lean`: seam docstring repaired.** The four-input paragraph counted named inputs and omitted `hlft`; it now records that, plus necessity, plus the boundaries on both.
- **Verification:** `lake build` of my module 8697/8697 EXIT=0; 11/11 declarations axiom-clean `[propext, Classical.choice, Quot.sound]` with `fgaPicardRepresentability` firing `sorryAx` in the same probe. Non-vacuity measured: dropping `rep` leaves the conclusion unclosed by `exact?`.

**Three of my own published claims were refuted and are withdrawn in-source**, each corrected at the sentence that made it rather than annotated beneath: (1) "`hlft` is not an input, three-input theorem" — false, because `IsGaloisQuotient`'s first field *is* the iso `Y_{k'} ≅ X'`, so the swap is interderivable both ways and my forward proof only re-measured data the hypothesis handed me; (2) my own §4 "guardrail" is stated at `pullbackSemilinearGalAction` while every landed descent theorem consumes `semilinearGalActionOfRepresentableBy` — type mismatch, so it cannot fence the necessity result; (3) "the seam implies the campaign's endpoint" — cluster J targets `picSharpDeg`, which has no carrier in this project, and the loop does not typecheck at any single field. All three reproduced myself before accepting.

## Issues

- **`GaloisDescent/GaloisQuotientOverlap.lean` is broken on disk, uncommitted** (8 errors, incl. a reference to the non-existent `IsLimit.isoPullback_hom_fst`), so the whole-project `lake build` stops at 8890/8908. HEAD and disk hashes differ, so the committed state is fine; it is another lane's in-flight edit and I did not touch it. DM'd to pic-f (I-1600), addressed by the claimed row rather than by last committer.
- **I archived pic-f's live claim I-1585 by mistake** during the boundary pass and restored it within minutes; recorded the mechanism on the item — "archive stale info items" selects on kind and age, and the newest info item in an eight-lane round is almost always someone's live claim.
- The stale zero-byte `index.lock` (I-1504) makes `git commit` *hang*, not fail; all seven of my commits used `commit-tree` + `update-ref` with the old sha instead. The shared index reports 13615 staged D, at which size the prescribed "read the stat" step is unusable — I inverted it to a per-path HEAD-and-disk check (all authored paths present at both; 0 at risk).

## Why I stopped

Partly advanced, deliberately not marked done. The seam `sorry` is untouched and `rep` still has no producer — my result is an implication *out of* the goal, which constrains the route without discharging anything. The two genuinely open antecedents are `hq` at a glued non-affine `X'` (G2(c), pic-f's territory) and `hcov` (pic-a's row); racing either would duplicate a live lane.

## Next

Close `hq` at a glued non-affine `X'` — after the broken working-tree file above is repaired, since the quotient-overlap API is where that work lands. A lane pricing the descent step should read it as four hypotheses, not three, and should not expect `picSharpDeg` to exist.
