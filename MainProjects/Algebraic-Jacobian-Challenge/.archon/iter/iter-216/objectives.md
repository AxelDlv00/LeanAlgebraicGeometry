# Iter-216 objectives

## Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT) — PIVOT iter, prover DEFERRED to 217

**This iter (plan-only on this lane):** strategy pivot + blueprint rewrite + critic resolution +
metadata fixes + USER escalation. No prover dispatch (blueprint HARD GATE: chapter `complete: partial`
after the rewrite; gate clears at iter-217's mandatory review).

**Diagnosis (analogist ts216):** the 6-iter stall (`isLocallyInjective_whiskerLeft_of_W` open since
iter-213) was building a VESTIGIAL monoidal-category apparatus. The group law on iso-classes needs only
*existence* of the assoc/unit/braiding isos — the whiskering / `(J.W).IsMonoidal` / stalk(d.1) / d.2
machinery is unnecessary. Single linchpin = `tensorObj` restriction-compatibility on a FREE cover.

**Open sorries (4, unchanged at 81 global / 4 file-local this iter):**
- `isLocallyInjective_whiskerLeft_of_W` — VESTIGIAL, to be DELETED iter-217 (count −1 expected).
- `tensorObj_restrict_iso` — the linchpin; H2 closed (`restrictScalarsRingIsoTensorEquiv`, iter-215);
  residual H1 (presheaf `pushforwardPushforwardAdj`) avoidable on the free cover (make-or-break).
- `exists_tensorObj_inverse` — dual on a trivializing cover (via restrict-compat).
- `addCommGroup_via_tensorObj` — RPF consumer; needs the by-hand `tensorObjIsoclassCommMonoid`.

**iter-217 make-or-break:** prove the restriction-compatibility on the FREE cover via
`restrictScalarsRingIsoTensorEquiv` WITHOUT the general presheaf-pushforward adjunction H1. If it needs
H1, the pivot relocated the gap → revert to `J.W.IsMonoidal`→`Sheaf.monoidalCategory`.

## Blueprint metadata fixes applied this iter (plan agent, within write-domain)
- Removed circular `\uses{lem:tensorobj_restrict_iso}` from `lem:restrictscalars_ringiso_tensorequiv`.
- Added `lem:restrictscalars_ringiso_tensorequiv` to `lem:tensorobj_restrict_iso`'s `\uses`.
- Added `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` to
  `lem:pullback_compatible_with_tensorobj` (downstream RPF-consumer; prover may refine the name).

## Held / no-dispatch (unchanged)
RPF, FGA, A.2.c engine, Albanese (Route 1 excised / Route 2 gated), WD, RCI, A.3.* — all per the
held-lanes rationale in PROGRESS.md and the standing USER directives (ROUTE C PAUSE; A.2.c bottom-up;
no A.3 before A.2.c).
