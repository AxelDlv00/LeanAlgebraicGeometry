# Orientation

- Useful context: the rebuild lane (`AJCR.picard`) has produced no Lean/blueprint/roadmap change since session `0002-horizon-rebuild`; sessions `0006/0010/0014/0018/0022/0026/0030` are all zero-token Fable-5-limit no-ops (see `I-0141`). Real progress needs Fable-5 credits restored or the lane re-pointed to another model.

- Relevant files: `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/.../Picard/Separatedness.lean` (brick 3 `prPullback_injective`) and `informal/wave3-picard-design.md` §9 (OPEN-1). The Layer-2 gate is the "one-plus is a Zariski sheaf on affines" corollary of C1 — file 13 before file 12 per `I-0140`.

- Highest-value next piece when a session can run: the sheaf-on-affines corollary (`I-0140`) unblocks `PicEt` over all of `Over (Spec k)`; it is a genuine construction, not an avoided hard core — the last real Horizon output (`cechPicEquivPic`, affine `X`) landed it for affine `X` only.

- Environment note: blueprint chapter `sec:PicardEtale` (55 nodes) is fully `\leanok` and honest against `PicEtAff`; Rebuild DAG reads 259/280 proved, `0 dangling`. No consistency drift found this round.
