# Iter 006 — Objectives detail

## Completeness audit evidence (user-requested)
- AJC `dag-query cone` for the 3 seeds: 52 / 36 / 32 nodes; union = 108. All 108 blueprint ids
  present in local graph (`comm -23` empty). Local cone sizes recomputed = 52/36/32 (exact match
  ⇒ dependency edge structure faithful).
- Decl diff (local vs AJC):
  - `DualInverse.lean`: 19 local vs 18 AJC; only extra is `dualUnitRingSwap_apply`. COMPLETE.
  - `TensorObjSubstrate.lean`: missing 7 = `extendScalars`, `extendScalarsAdjunction`, `pullback0`,
    `pullback0Adjunction`, `pullbackLanDecomposition`, `restrictScalarsIsRightAdjoint`, bare
    `pushforward`. AJC lines 1271–1314; AJC comment L1253 "route … does NOT consume extendScalars/
    pullback₀"; `awk` over AJC L>1320 shows ZERO downstream uses → dead code. NOT ported.
  - `LineBundlePullback.lean` / `RelPicFunctor.lean`: diffs = `functorial`, `pullback_pullback_eq`,
    `PicSharp.etSheaf`, `etSheaf_group_structure` = Route-A representability / Picard functoriality
    (Kleiman §2) = OUT OF SCOPE (A.2.c, parent). Not in any seed cone.
- Scaffold seeds `pullbackTensorIsoOfLocallyTrivial`, `PicSharp.addCommGroup_via_tensorObj` absent
  from AJC Lean too (AJC blueprint `% NOTE: pin target absent as of iter-271`). Local not behind.

## Ground-truth build (overrides prover self-reports)
- `lake build …TensorObjSubstrate` → exit 0, 8321 jobs, sorries L690/L2467/L2824. GREEN.
- `lake build …DualInverse` → exit 1. Errors: L407 ext-misapplied, L436/L566 whnf heartbeat timeout,
  L556 function-expected, L799 `Unknown identifier sliceDualTransport`, L803 subsingleton. RED.

## Recipes handed to provers
- DUAL: `analogies/dualnat006.md` — morphism-level `IsIso.inv_comp_eq` rotation; never `inv ε`
  pointwise. Holes ~L398 (Inv) and ~L547 (forward). Repair to GREEN first.
- D3′: `analogies/d3cocycle006.md` — `conjugateEquiv_comp` at NatTrans level; template
  `pullbackObjUnitToUnit_comp` (L920–993); then `isMonoidal_comp`/`comp_δ`/`pullbackComp_δ` for
  `pullbackTensorMap_restrict`.
