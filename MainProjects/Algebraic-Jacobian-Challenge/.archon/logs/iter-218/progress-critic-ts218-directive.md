# Progress-critic directive — slug ts218

Assess convergence of the single active prover route below. Verdict per route
(CONVERGING / UNCLEAR / CHURNING / STUCK) with the corrective TYPE if not converging.

## Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (A.1.c.SubT, ⊗-substrate / group law)

This is the sole active prover lane (all other lanes HELD/PAUSED by standing USER
directives). It supplies the ⊗-substrate for a by-hand `CommGroup` on locally-trivial
line-bundle iso-classes, feeding the relative Picard functor.

### Per-iter signals (last 5 iters, K=5)

| Iter | Project sorry count | Prover status | Helpers/decls added | Recurring blocker phrase |
|------|---------------------|---------------|---------------------|--------------------------|
| 213  | 81 | PARTIAL | +helpers (substrate bricks) | "H1/d.2 Mathlib-absent; residual is a sorry" |
| 214  | 81 | PARTIAL | +4 stalk d.1 decls (axiom-clean) | "d.1 needs new stalk infra; residual unchanged" |
| 215  | 81 | PARTIAL | +1 (restrictScalarsRingIsoTensorEquiv, H2 bottom) | "free-cover close not statable; residual a sorry" |
| 216  | 81 | PARTIAL | +6 (ModuleCat H2 core) | "make-or-break NEGATIVE: free-cover does NOT avoid H1" |
| 217  | **80** | **COMPLETE (target met)** | +5 presheaf H1/H2 decls; **CLOSED `tensorObj_restrict_iso`** | none — linchpin eliminated, first −1 in 7 iters |

Key facts:
- iters 211–216 were net-zero (count flat at 81): each landed real axiom-clean bricks
  while the named critical-path residual `tensorObj_restrict_iso` stayed a `sorry`.
- iter-216's pre-committed "make-or-break" returned NEGATIVE (the free-cover shortcut does
  NOT avoid the H1 presheaf pushforward adjunction; H1 is genuinely on the critical path).
- iter-217 planner REBUTTED a prior STUCK verdict on the strength of an on-disk
  mathlib-analogist de-risking (H1 ~70–90 LOC, every sub-step present,
  `pullbackPushforwardAdjunction` already exists) and dispatched a fine-grained round
  structured to DROP the count. Result: `tensorObj_restrict_iso` CLOSED axiom-clean,
  count 81→80. Independently confirmed by lean-auditor + lean-vs-blueprint-checker.

### Strategy estimate for this phase (verbatim from STRATEGY.md `## Phases & estimations`)
- Phase "A.1.c.SubT — ⊗-group law": Iters left = ~2–4. Phase has been active across the
  ~211–217 window (entered its current ⊗-invertibility realization ~iter 209/210).

### This iter's (218) proposed objective (single file)
`Picard/TensorObjSubstrate.lean` — PRIMARY: prove `exists_tensorObj_inverse` (the ⊗-dual
L⁻¹ = Hom(L,O_X) + local contraction iso, the next group-law building block). SECONDARY:
re-route `tensorObj_assoc_iso` onto the now-closed `tensorObj_restrict_iso` and delete the
dead whiskering/stalk apparatus (→ 80→79). Ride-along: stale-docstring + deprecated-API
cleanup. Mode: prove.

### Question for you
Given the count finally moved on the critical path (217: 81→80) after a 6-iter flat
window, is this route CONVERGING, or is the −1 a one-off and the route still at risk of
re-stalling on the NEXT residual (`exists_tensorObj_inverse`, then the iso-class group,
then `addCommGroup_via_tensorObj`)? Is the proposed iter-218 objective the right next
step, or is the planner about to spend budget on cleanup (the assoc re-route / vestigial
deletion) that does not advance the group law? Name the corrective TYPE if not CONVERGING.
