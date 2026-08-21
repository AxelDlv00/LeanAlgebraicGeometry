## State Audit

- HEAD is `92f9d03cb5`, which explicitly refocuses this resumed round on universal Picard descent.
- Current directive: build one finite-stage universal package from `exists_finSubext_relPic_tensorStage`, choosing a common finite field stage for atlas charts and overlaps, descending universal classes plus equality/naturality witnesses, then constructing `RepresentableBy P.gluedOver`. Use LSP and narrow modules; do not spend this round on full builds, restating blockers, or additional conditional consumers.
- Run `0149` is live; `ajcr-reviewer-full` is correctly `running`.

Prior rounds durably landed:

- Canonical rank-one evaluation, `canonicalRankOneAbelIso`, `rankOneAbel_isOpenImmersion`, and `pic0_sepClosed_representableBy`.
- Finite-stage atlas and `GlueData`.
- Generic representability transport across object/base-change isomorphisms.
- Conditional finite-Galois representability and same-carrier `PicRepDatum`/`JacobianData` packaging.
- `92c130dce7`: finite-subextension descent of tensor-stage relative Picard classes, root-imported and narrowly built with axioms exactly `[propext, Classical.choice, Quot.sound]`.

Remaining critical gates:

- Simultaneous universal class/equivalence descent producing actual finite-stage `RepresentableBy`.
- Kernel certification of `GlueDataFace`, then `PreSnd`, `Snd`, and `GluedComparison`; source-level base-change exists but is not yet fully certified.
- Unconditional orbit-affineness/projectivity.
- `pic0_representableBy`, original-field `PicRepDatum`/`JacobianData`, and Phase 8 consumers.
- Sibling `Challenge.lean` retains its import-cycle boundary and 13 direct sorry-bearing declaration groups.
- No current full-build claim: the latest verified unit had only its exact module build.

Roadmap state is honest and warning-free:

- P7: `blocked`, 1/6 children done; `universal` is the active owned child.
- P8: `blocked`, 2/7 children done, downstream of P7.
- No unread conversations.

Binding inbox constraints:

- `I-0074`: preserve route conventions; never reintroduce a global `HasSmoothProperQuotient` or directly close the unconditional headline through the pointed route.
- `I-0491` is archived but remains the authoritative human decision: arbitrary field, no rational-point binder, never restore `hasRationalPoint_of_curve`, and use the etale-sheafified Picard functor. Conditional pointed/algebraically-closed results are not the headline.
- Archived `I-2017` confirms there is no existing Mathlib/project API that supplies the missing universal finite-stage representability or unconditional orbit-affineness producer.

Dirty-tree ownership assessment:

- No tracked Lean source diff and no staged changes.
- Shared generated state is very dirty: 22,037 dashboard files, 95 hgraph-node files, and 6 Archon runtime/search/task files are modified; 118 normal untracked entries exist.
- Treat these as publisher/runtime/shared-worktree state. Stage only explicit authored files through an isolated index; never `add -A`.
- Persistent Horizon `0.1.2` workspace versus `0.1.3` CLI drift remains. The user explicitly forbids automatic overwrite of deliberate local skill edits, so do not run an unconditional managed-file refresh.
