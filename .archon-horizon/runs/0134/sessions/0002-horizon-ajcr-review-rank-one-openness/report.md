# Ground Review: AJCR Phase 3 Rank-One Openness

The Phase 3 lane is converging honestly: the roadmap, task handoff, public locus/open APIs, and native producer contract all agree that the sole structural blocker is the arbitrary-affine, lambda-tied native presentation family with all-cartesian pushforward base change.

Evidence:

- `Pic0RankOneLocus.lean` defines membership by `forall` affine pullbacks and tied `PicRankOneLocalPresentation`; its `IsOpen` and `FibrePresented` declarations are acceptance/consumer contracts and have no producer.
- `Pic0RankOneNativePresentation.lean` only adapts a supplied native datum. Its uninhabited fields are exactly native pushforward `IsIso` on every cartesian square, H1 vanishing, finite/projective H0, and stalk rank one.
- `DivRankOneOpen.lean` derives a carrier only from a supplied `PicRankOneOpen.IsOpen`; chart/fibre files prove only pointwise tensor/ideal-span consequences, not family gluing or base change.

No honest edit in the owned files can construct the missing family without adding an unrelated witness or an assumption, both forbidden by the standing protections. The next highest-value action is producer-lane construction of the native family and its all-cartesian base-change theorem, followed by immediate consumption in this API.

Verification note: narrow `lake env lean` checks currently stop at a missing generated object (`DivSchemeHighWindowRelations.olean`), so this session cannot independently certify a fresh kernel build. The shared ledger also has a large generated/untracked Horizon working set; no cleanup is appropriate while runs are live.
