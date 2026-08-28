Filed I-1282, I-1283 (issues) and I-1284 (memory).

## Findings

I read the statement of every new declaration in the ~20 files the four lanes added in the last 14 hours. **No vacuity of the `HasDivFunctor` kind exists in this round** — no binder that fails to occur in its body, no witness-discarding existential, no all-hypotheses-unused declaration, and no new `sorry` token. That failure mode is genuinely gone. What is wrong is different.

`Pic0Et.compactSpace` / `.specializingMap` / the four cover-transfer spellings — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0EtProperImage.lean:136,161,213,228,261,275` — 7 of the file's 11 declarations are labelled by their own docstrings as renamings ("a convenience name for a triviality", "one transfer lemma and none is a reduction"), and the other 4 are the converses proving the 7 add nothing.

`leafB_of_chartwise`, `leafB_iff_appLE`, `leafB_of_pointwise` — `.../AlgebraicJacobian/Picard/Pic0EtRelativeDimension.lean:242,198,264` — respectively `iff_appLE.mpr`, mathlib's `HasRingHomProperty.iff_appLE`, and the class's anonymous constructor; the file admits all three, one round after the same lane was refuted for the same shape.

Whole `Pic0Et` tower (62 decls, 4 files) — `Pic0EtProperImage.lean:115`, `Pic0EtStructure.lean:174`, `Pic0EtTangentSpace.lean:139ff`, `Pic0EtRelativeDimension.lean:147` — every declaration binds `[HasPicSchemeEt C]`, whose unconditional instance is `(fgaPicardRepresentability C).1`, a projection of the seam `sorry` at `Picard/FGAPicRepresentability.lean:644`. Axiom-clean as implications, `sorryAx` at any real use site. Accurately documented, and unchanged by this round.

`uniformBaseDivisor_of_exists_deg_le` — `.../AlgebraicJacobian/RiemannRoch/Ledger/BaseDivisorEveryField.lean:214` — its hypothesis is definitionally `UniformBaseDivisor C d` and the body is `fun κ _ _ => h κ`; the file says so ("the IDENTITY, not even bookkeeping") and ships it anyway.

`PullbackTensorRightUnit` — `.../AlgebraicJacobian/Picard/PullbackTensorOneSided.lean:240` — a no-instance gate carrying the file's real residue. Sound as a pattern (`pullbackTensorRightUnit_of_iso_unit` exhibits a witness, so not vacuous), but `pullbackTensorIsoOfTwist:208` supersedes its main consumer unconditionally, so the gated pair below it is mostly dead weight.

`Scheme.DivFamily.*_pushforward` (4 new theorems) — `.../AlgebraicJacobian/Picard/DivPushforwardFlat.lean:205,254,272,299` — true theorems about `Scheme.DivFamily`, which the file itself records as having 135 consumers and zero producers in the project. Real content, about an uninhabited carrier.

Genuine throughput, gate-free and substantial: `PicEtCrossBase.lean`'s presheaf-level cross-base face assembled to `picEt_crossBaseIso` unconditionally (`:690`), `exists_isGaloisQuotient_of_isAffine` (`Picard/GaloisQuotientAffineGeneral.lean:144`), `exists_finiteSeparable_level_factorization` (`Curve/FiniteLevelRationalPoint.lean:253`), and the p4 semicontinuity chain (`FiberRankSemicontinuity`, `TwoTermKernelSemicontinuity`, `PointRankSemicontinuity` + its witness), which is ordinary commutative algebra proved properly.

## Verdict

**Churning, with a real minority that will hold.** The three cross-base/Galois/finite-level files and the p4 semicontinuity chain are sound mathematics that will still be true and useful in a month. Against that, roughly 60% of the round's new declarations are either self-admitted renamings, iff-unfoldings, converse-pairs proving their siblings empty, or gate-bound statements about an object no curve inhabits — and of 73 commits, subjects beginning `docs(`/`fix(`/`retract(`/`board(` outnumber `feat(`. The seam `sorry` count is unchanged. The lanes have become excellent at documenting that their output adds nothing, which is precisely why no vacuity, sorry, or axiom check catches it.
