All checks pass. Final sanity: three commits are ancestors of HEAD, the file at HEAD is byte-identical to disk, the import line is at HEAD, `lake build` of the module succeeded (8850/8850, olean produced), and `representableBy` reduces to `propext`/`Classical.choice`/`Quot.sound` with no `sorryAx`.

## Summary

L11 is closed. `DivRepAffinePullback.toGlobalData` and the payoff corollary `representableBy` are landed, sorry-free, rooted, and kernel-checked.

## Progress

New file `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepGlobalClassify.lean` (318 lines), all sorry-free:

- `classifyGlobal` :204 — the general-test classifier
- `fromSpecAffine_classifyGlobal` :232 — its characterizing property
- `pullGlobal_classifyGlobal` :252 — the `pull_classify` field
- `classifyGlobal_pullGlobal` :269 — the `classify_pull` field
- `toGlobalData` :288 — **the objective**
- `representableBy` :306 — the payoff, collapsing L9–L13
- private helpers: `isoSpec_hom_fromSpec` :64, `hom_ext_fromSpecAffine` :72, `overSpecMap_comp_divRepClassifyZar` :127, `classifyPiece` :146, `homOfLE_classifyPiece` :159, `classifyPiece_over` :180, `classifyPiece_trans` :188, `ι_classifyGlobal` :215

Rooted by one import line in `AlgebraicJacobian.lean` (verified to be the only changed line in that shared file at commit time).

Commits: `31930badb` (file, honestly marked unverified), `aeb77e174` (heartbeat fix, single-file green), `00f4125fa` (import line, build-verified).

## The two things that made it cheap

**The overlap problem does not exist.** Mathlib has `Scheme.directedAffineCover` — the cover by *all* affine opens, carrying a `Cover.LocallyDirected` instance — and `Scheme.OpenCover.glueMorphismsOverOfLocallyDirected`, which glues **directly in the `Over` category** from compatibility with the transition maps `X.homOfLE` alone. No pullback hypothesis, hence no need to reduce non-affine intersections to an affine basis, and no bespoke gluing infrastructure.

**Classifier naturality is forced, not proved.** There is no base-change lemma for `divRepClassifyZar` or `IsDivRepClassify` in the tree. None is needed: `D.pull` is injective and natural, so its inverse is natural — eight lines via `D.isDivRepClassify_pull` at the base-changed morphism.

## Claims I found to be FALSE

- The brief's central prediction — that discharging `glueMorphisms`' pullback hypothesis "IS the work" — is wrong; that route is entirely avoidable (above). Anyone planning from it will overestimate this link badly.
- The brief's mathlib path `<project>/.lake/packages/mathlib/` does not exist (coordinator corrected mid-flight; my survey had already used the right one, so nothing rested on it).
- The brief presumed a naturality lemma for `divRepClassifyZar` along `Over.resAlgHom`. No such lemma exists.
- `IsAffineOpen.fromSpec_range` and `Scheme.isBasis_affine_open` do not exist; the real names are `IsAffineOpen.range_fromSpec` and `Scheme.isBasis_affineOpens`.
- Verified **true**: every file:line claim in the brief about `DivRepKit.lean`, `DivRepAffKit.lean` and `DivRepGlobalLift.lean` checked out exactly. `DivRepGlobalLift.lean`'s docstring correctly disclaims the half it does not contain.

## Issues

One deliberate `set_option maxHeartbeats 1600000` on `homOfLE_classifyPiece` (LSP accepted it at default budget; `lake build` did not). Documented in-file with the project's precedent. Remaining build warnings are pre-existing in `DescentClassRepBuild.lean`, not mine.

## Why I stopped

The objective is fully complete and verified. Nothing outstanding on L11.

result: L11 closed — `DivRepAffinePullback.toGlobalData` and `representableBy` landed sorry-free, kernel-checked and rooted (commits 31930badb, aeb77e174, 00f4125fa); the affine-to-general lift needed no new gluing infrastructure because mathlib's locally-directed affine cover glues Over-morphisms with no overlap condition.
