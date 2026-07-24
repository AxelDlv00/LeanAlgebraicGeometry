---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.then
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLegTop.lean
generated: lean
lean_status: sorry
stale: true
title: AlgebraicGeometry.then
type: lean
updated: '2026-07-24T05:02:12'
---
   lemma then composes the `pls_eq`/`hstep` prefix with `exact <that lemma> …`. Re-verify EACH piece
   kernel-checks; `#print axioms coreIso_comm_leg` must stay sorry-free (kernel axioms only).
   ONLY if decomposition genuinely cannot bound it this iter, raise `maxHeartbeats` on JUST the
   offending declaration to the smallest passing value with a `-- KERNEL-BUDGET:` note (fallback;
   decomposition is preferred). Do NOT change the statement signatures of
   `pushPull_interLegHom_sections` or `coreIso_comm_leg` — both are consumed downstream (CSI/Aux). -/
-- KERNEL-BUDGET: same intrinsic cost as `pushPull_interLegHom_resid` — the kernel symbolically
-- expands `coverInterOpen` over the variable-length face while checking this concrete statement.
-- (heavy lemma: high heartbeat budget; respectTransparency knob restores v4.31.0 speed)
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 4000000 in
set_option synthInstance.maxHeartbeats 400000 in