# Iter-232 objectives (per-task detail)

## Lane FBC — `Cohomology/FlatBaseChange.lean` (NEW) [prover-mode: prove] — DISPATCHED

**Stall-independent engine parallel lane** (strategy-critic de-gate CHALLENGE + USER parallelism).
Blueprint `chapters/Cohomology_FlatBaseChange.tex` — blueprint-reviewer ts232: complete + correct,
"adequate to back a parallel engine prover lane." Stacks 02KH.

File-skeleton dispatch (file does not exist yet):
1. Scaffold `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` with the 3 chapter decls (sorry bodies):
   - `AlgebraicGeometry.pushforwardBaseChangeMap` (def:pushforward_base_change_map) — frontier-ready.
   - `AlgebraicGeometry.affineBaseChange_pushforward_iso` (lem:affine_base_change_pushforward).
   - `AlgebraicGeometry.flatBaseChange_pushforward_isIso` (thm:flat_base_change_pushforward).
   Add imports + namespace boilerplate.
2. Then prove `pushforwardBaseChangeMap` (the canonical base-change map) and
   `affineBaseChange_pushforward_iso` (affine case = tensor associativity, per chapter).
3. The deep `flatBaseChange_pushforward_isIso` (Čech + flatness) may be left as sorry if not reached.

## Lane TS-carrier — `Picard/TensorObjSubstrate.lean` + `…/PresheafInternalHom.lean` — DEFERRED 1 iter

**Carrier pivot** (strategy-critic CHALLENGE, ADOPTED). Build the relative Picard group on
`IsInvertible` (tensor-invertibility) — inverse FREE from the membership witness. Blueprint section
written this iter (`def:pic_carrier`, `lem:isinvertible_*`, `thm:pic_commgroup`,
`lem:tensorobj_assoc_iso_invertible`); dual demoted to deferred bridge.

DEFERRED because `Picard_TensorObjSubstrate.tex` was just rewritten and needs the mandatory
blueprint-reviewer re-clear (HARD GATE) before a prover. Re-engages next iter on gate clear. Spec:
- `thm:pic_commgroup`: `CommGroup` on iso-classes of `IsInvertible` modules; one_mul/mul_one (unitors),
  mul_comm (braiding), mul_assoc (`lem:tensorobj_assoc_iso_invertible`), inv = witness (free).
- `lem:tensorobj_assoc_iso_invertible`: flat-restricted associator — use `W_whisker*_of_flat` (sorry-clean,
  in Vestigial.lean) instead of `W_whisker*_of_W` (sorry-transitive). invertible ⟹ locally free ⟹ flat.

## Structural / blueprint actions this iter (DONE)

- **File-split** `TensorObjSubstrate.lean` → `{PresheafInternalHom, Vestigial}.lean` + main (refactor
  COMPLETE, build GREEN, 0 new sorries, parallel-ready).
- **STRATEGY.md** rewritten: carrier pivot + engine de-gate + format.
- **blueprint-writer carrier**: `Picard_TensorObjSubstrate.tex` invertibility group section + dual
  demotion + stale-rationale fix (Stacks 01CX/01CR/0B8M, verbatim).
- **blueprint-writer hdi**: new `Cohomology_HigherDirectImage.tex` (`R^i f_*`, Stacks 02KE/02KG/02KH).
- **content.tex**: all 35 chapters wired (orphan resolved; both engine chapters in).
- **blueprint-clean ts232**: purity pass on the 2 written chapters.

## Status snapshot
- Project sorry: 80 canonical (refactor build shows 81 = pre-existing working-tree delta, not new).
- Build: GREEN (full `lake build` exit 0 post-split).
- Sorries: `Vestigial.lean` L267 (`isLocallyInjective_whiskerLeft_of_W`, vestigial),
  `TensorObjSubstrate.lean` L694 (`exists_tensorObj_inverse`, now deferred-bridge),
  L759 (`addCommGroup_via_tensorObj`, RPF consumer).

## Consults
- progress-critic ts232: STUCK; corrective refactor executed; route-II must-fix rebutted (carrier supersedes).
- strategy-critic ts232: CHALLENGE — carrier pivot + engine de-gate, both ADOPTED.
- blueprint-reviewer ts232: cleared FlatBaseChange; TensorObjSubstrate C-bridge items deferred (dual bridge).
