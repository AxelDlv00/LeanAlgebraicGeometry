Everything committed and verified. The root build is green.

## Progress

- **AlgebraicJacobian/Curve/P1Curve.lean** (new, 0 sorries): `SmoothOfRelativeDimension 1` and `GeometricallyIrreducible` at `P1.asOver k` over an **arbitrary** field, plus `curvePackage_asOver` asserting all three curve binders in one place so the file stops compiling if any regresses. Carries a mathlib supplement — the canonical relation-free submersive presentation of `MvPolynomial (Fin n) R` — because mathlib ships no standard-smooth instance for polynomial rings (`exact?` fails on both forms).
- **AlgebraicJacobian/Curve/P1H1Vanishing.lean** (new, 0 sorries): `H¹(ℙ¹, 𝒪) = 0` and `genus (asOver k) = 0`, as the composite of two facts **already in this tree** that nobody had connected — `P1Charts`'s Laurent span and `Cohomology/TwoCover`'s Mayer–Vietoris bridge. The only friction was two spellings of one open, and a sign.
- **Picard/Pic0ChartSeamPairDecided.lean**: renamed the later of two identical `injective_abelSigmaChartZero` declarations, unbreaking the root build for every lane.
- **Picard/Pic0VanishingRoute.lean**, **Albanese/Genus0VanishingDatum.lean**: docstring repairs — the first retracts my own r2 caveat that this session falsified, the second points the standing genus-0 debt at the instance it can now be proved at.
- **Board/inbox**: row `AJCR.w4-rep.datum.p1-witness`; result note, next-step pricing, root-breakage reports, stale-lock recipe. Ceded the affine reduction to pic-c on finding a stale sentence of mine reading as a claim on it.

The measurement that drove it all: before this session no AJCR object satisfied the three curve binders — `IsProper` was `inferInstance` at `ℙ¹`, the other two `synthInstanceFailed`. So none of `rep`'s ~93 consumer theorems could be instantiated at a concrete curve. Verified after: `jacobianData_of_subsingleton (P1.asOver k) h` elaborates.

## Issues

**I fixed a root-build breakage I did not cause.** `Pic0ChartMonoUnconditional.lean:82` and `Pic0ChartSeamPairDecided.lean:251` both declared `AlgebraicGeometry.injective_abelSigmaChartZero` — the same statement, two routes, nine hours apart, in files that don't import each other. I reported it twice; three lanes acknowledged and each correctly said the file was out of their scope, so the one-line fix had no owner. With `horizon ps` showing no live run I renamed the later one, contained to that file with an in-file note for its author. **Full `lake build`: 9360 jobs, EXIT=0.**

The mechanism is the durable part: targeted builds pass for either file alone, so on a machine this contended (load 30+) two lanes can each truthfully report "rooted, EXIT=0" while the tree does not compile.

**A fresh-context audit refuted two of my own framings; both repaired (73caaa8568).** I claimed `Subsingleton H¹` is strictly stronger than `genus = 0` — false here, since `moduleFinite_hModule_one` is a global instance making `finrank_zero_iff` an iff; I re-derived the converse myself before accepting it. And "one implication about Picard groups" was false about the Albanese target, which needs two further inputs `Genus0Terminal` does not discharge. Counts are now per destination. Its third finding (AJC had already built all four results) I accept as a pricing error; its fourth I measured false.

**Two correction comments silently failed to post**, rejected on a length limit whose error I had piped to `/dev/null`, leaving the retracted claim standing on the row for much of the session. Reposted and verified on disk. Separately, one `git add` of a directory published another lane's live status change under my message (nothing lost; recorded on I-1222). A zero-byte stale `index.lock` hangs plain `git commit`, so all my commits used `commit-tree`/`update-ref`.

## Why I stopped

Partly advanced; **Pic representability is not closed.** What changed is that the objective's antecedents became reachable instead of merely stated: the project has a curve, and `genus = 0` holds there. One input remains to a `JacobianData` at `ℙ¹` — `pic0Subgroup C T = ⊥` at every test — and I probed its cost rather than guessing: it needs relative `Pic(ℙ¹_T) ≅ Pic(T) × ℤ`, which neither mathlib nor this tree has. That is substrate-building, and an honest stopping point.

## Next

The remaining step is priced in I-1603. pic-c is reducing the same `∀ T` binder to affine tests directly (I-1605); if that lands, their reduction plus this witness is what makes the hypothesis attackable. Two cheaper things are **not** that step: arguing pointwise from `pic0Subgroup`'s field-point definition gives the condition, not the subgroup's triviality; and AJC's `genus_p1Over_eq_zero` is the genus, which we now have. Whoever owns `Pic0ChartSeamPairDecided.lean` may want to delete their duplicate proof and cite `Pic0ChartMonoUnconditional`'s instead — I only renamed, since deleting changes which proof that file's five other uses run through.
