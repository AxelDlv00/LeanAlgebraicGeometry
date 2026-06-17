# Progress Critic Directive

## Slug
route-signal

## Iter
005

## Active routes / files under review

### Route: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **Started at iter**: 001
- **Iters audited**: 001-004

#### Sorry counts per iter
- iter-001: 4 open after review
- iter-002: 4 open after review
- iter-003: no prover phase / no new route signal
- iter-004: no prover phase / no new route signal

#### Helpers added per iter
- iter-001: 0 new declared helpers on the route
- iter-002: 1 new declared helper (`dualUnitRingSwap_apply`)
- iter-003: 0 (no prover phase)
- iter-004: 0 (no prover phase)

#### Prover statuses per iter
- iter-001: PARTIAL — one infra tail restored and one helper closed, but the shared epsilon naturality and round-trip fields stayed open.
- iter-002: PARTIAL — `dualUnitRingSwap_apply` landed, but the same epsilon naturality / cancellation block remained open.
- iter-003: no prover phase — no new route signal.
- iter-004: no prover phase — no new route signal.

#### Prover count per iter (files dispatched)
- iter-001: 1 of 1 ready
- iter-002: 1 of 1 ready
- iter-003: 0
- iter-004: 0

#### Recurring blocker phrases
- "shared epsilon naturallity paste" / `restrictScalarsLaxε` + `NatTrans.naturality` appears in iter-001 and iter-002.
- "round-trip cancellation" through `f.appIso` / `image_preimage_of_le` remains the same open finish step.

#### Deferral language per iter (if present in signals)
- iter-003: plan-only / no prover dispatch
- iter-004: plan-only / no prover dispatch

#### Route status changes per iter
- iter-001: active
- iter-002: active
- iter-003: plan-only
- iter-004: plan-only

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim from the relevant `## Phases & estimations` row): ~3–5
- **Elapsed iters in current phase**: 4
- **Phase started at iter**: iter-001

#### Planner's current proposal for this iter
- Keep the route active and dispatch the two open routes this iter rather than adding more scaffolding. The concern to watch is whether the route has been in repeated plan-only mode long enough that the critic will call it avoidance rather than legitimate gating.

### Route: AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **Started at iter**: 001
- **Iters audited**: 001-004

#### Sorry counts per iter
- iter-001: 3 open after review
- iter-002: 3 open after review
- iter-003: no prover phase / no new route signal
- iter-004: no prover phase / no new route signal

#### Helpers added per iter
- iter-001: 0 new declared helpers on the route
- iter-002: 1 new declared helper scaffold (`hAssocComponent`)
- iter-003: 0 (no prover phase)
- iter-004: 0 (no prover phase)

#### Prover statuses per iter
- iter-001: PARTIAL — the associativity scaffold was recognized, but `sheafificationCompPullback_comp_tail` and the pasted basechange remained open.
- iter-002: PARTIAL — the mixed comparison scaffold was expanded, but the cocycle residual still did not close.
- iter-003: no prover phase — no new route signal.
- iter-004: no prover phase — no new route signal.

#### Prover count per iter (files dispatched)
- iter-001: 1 of 1 ready
- iter-002: 1 of 1 ready
- iter-003: 0
- iter-004: 0

#### Recurring blocker phrases
- "non-circular fallback" / `leftAdjointCompNatTrans_assoc` / `conjugateEquiv` remains the same blocked finish step.
- "mixed comparison splice" / `sheafificationCompPullback_comp_tail` is still the residual.

#### Deferral language per iter (if present in signals)
- iter-003: plan-only / no prover dispatch
- iter-004: plan-only / no prover dispatch

#### Route status changes per iter
- iter-001: active
- iter-002: active
- iter-003: plan-only
- iter-004: plan-only

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (verbatim from the relevant `## Phases & estimations` row): ~3–5
- **Elapsed iters in current phase**: 4
- **Phase started at iter**: iter-001

#### Planner's current proposal for this iter
- Keep the route active and dispatch the two open routes this iter rather than adding more scaffolding. If the critic reads the two plan-only iters as avoidance instead of valid gating, the corrective should be to fill all ready lanes now, not to widen the scaffolding again.

## PROGRESS.md proposal (this iter)

- **File count**: 2
- **Files**: `DualInverse.lean`, `TensorObjSubstrate.lean`
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: `DualInverse.lean`, `TensorObjSubstrate.lean`
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope

- `RelPicFunctor.lean` consumer assembly, because it is still gated on both upstream routes.
- scaffold-only seed targets that are not fill-sorry lanes yet.
