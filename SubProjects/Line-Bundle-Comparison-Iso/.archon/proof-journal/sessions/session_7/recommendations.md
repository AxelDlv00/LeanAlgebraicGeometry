# Recommendations — next plan iter (post iter-007)

## CONVERGING — keep DUAL on `prove` (do NOT pivot/refactor)
The route is converging, not churning. Last iter: RED→GREEN + forward naturality closed via the
dualnat006 recipe's first real execution. The reversal signal in iter-006/007 plans (make
`sliceDualTransport` the effort-breaker target if the recipe still doesn't move the residual) is
**NOT triggered** — the recipe worked.

### Top priority: `sliceDualTransportInv.naturality` (ROOT, SliceTransport.lean L444)
- It is the **mirror** of the now-closed `sliceDualTransport.toFun.naturality`. Use that closure
  as the executable template:
  1. Extract a standalone lemma `sliceDualTransportInv_naturality_apply` (parent def is at
     heartbeat limit — same reason the forward one was extracted).
  2. Close it pointwise via the already-proven helpers: `appIso_hom_naturality_apply`,
     `dualUnitRingSwap_apply`, `unitRelabelSwap_apply`, `dualUnitRingSwapHom_apply`, and
     `PresheafOfModules.naturality_apply` of the dual section. Inv-specific leg: route the
     codomain unit through `unitRelabelSwap` and discharge the `hβ` compat
     (`(β.app P).hom ∘ (f.appIso P).hom.hom = id`) via `Iso.hom_inv_id`.
  3. Delegate the `naturality` field to it (`apply ModuleCat.hom_ext; refine LinearMap.ext …`).
- **Do NOT** re-attempt the dead approaches: pointwise `inv ε` / `dualUnitRingSwap` through `whnf`
  (the ≥6-iter timeout, reproduced again this iter), `ext z; simp [dualUnitRingSwap_apply]`,
  `subsingleton` on this codomain (it is a restriction of the unit, not Subsingleton).

### Then: `left_inv` (L724) / `right_inv` (L726) — unblock once the root closes
Mirrors of `Iso.hom_inv_id` / `hom_inv_id` using the existing `@[simp]` round-trip cancellations
`dualUnitRingSwap_comp_dualUnitRingSwapInv` / `dualUnitRingSwapInv_comp_dualUnitRingSwap`. Cheap
after the root. Closing these three sorries finishes `SliceTransport.lean` and unblocks the DUAL
chain up to `exists_tensorObj_inverse` (still import-cycle gated — close downstream, never direct).

## Blueprint-writer dispatches (checker findings, `Picard_TensorObjSubstrate.tex`)
All blueprint-side; none block the prover but they degrade future prover guidance. Dispatch one
blueprint-writer:
- **B1 (major)** — `lem:slice_dual_transport_inv` (~L5008): document the `hβ` compatibility
  hypothesis (`(β.app P).hom ∘ (f.appIso P).hom.hom = id`, discharged via `Iso.hom_inv_id` when
  β is the open-immersion structure map). The Lean API is parametrized by `β`+`hβ`; the prose
  treats β as fixed → a reader can't arrive at the real signature.
- **B3 (minor)** — add the 4th leg `unitRelabelSwap` (codomain unit transport) to the
  `slice_dual_transport_inv` component formula (currently describes only 3 of 4 legs).
- **B4 (minor)** — mention the `sliceDualTransport_naturality_apply` extraction; and correct the
  surrounding prose at L4766–4774 that still describes a `restrictScalarsLaxε` natTrans the Lean
  does not use (I patched only the `% NOTE:` at L4764–4765; the body prose is the writer's job).

## Stale `.lean` comments (for the next prover touching these files — NOT a plan task)
The auditor flagged 3 stale comments. Review/plan agents can't edit `.lean`; ask the assigned
prover to fix in passing:
- `Vestigial.lean:15` — docstring claims `isLocallyInjective_whiskerLeft_of_W` has an open sorry;
  it's been proved (L352–446). Misleads.
- `DualInverse.lean:44` — "Step-4 isoMk naturality sorry at ~L546" — that sorry moved to
  `SliceTransport.lean` L724/726 in the split. Wrong file/line.
- `DualInverse.lean:200` — claims `sliceDualTransport.hom` is "currently a sorry"; its
  `naturality`/`map_add'`/`map_smul'` are now closed; only left/right_inv remain.

## Coverage debt — 1-to-1 blueprint entries for this session's new helpers
`archon dag-query unmatched` = 97 lean_aux nodes (large pre-existing backlog). The **7 new this
iter** (all in `SliceTransport.lean`, namespace `AlgebraicGeometry.Scheme.Modules` unless noted),
none referenced by any `\lean{...}` — author trivial blueprint blocks for these (planner writes
prose; not the review agent's job):
- `dualUnitRingSwap_apply` (L192) — pointwise: `(dualUnitRingSwap f W').hom x = (f.appIso W').hom.hom x`.
- `dualUnitRingSwapHom_apply` (L239) — hom-direction mirror.
- `isIso_ε_restrictScalars_presheafMap` (L263) — ε iso for the `eqToHom` relabel; feeds `unitRelabelSwap`.
- `unitRelabelSwap` (L275) — codomain unit transport (`inv ε` of the relabel); load-bearing.
- `unitRelabelSwap_apply` (L287) — pointwise for the above.
- `appIso_hom_naturality_apply` (L315) — ring-level naturality of `(f.appIso).hom`; load-bearing.
- `sliceDualTransport_naturality_apply` (L453) — extracted forward-naturality lemma (heartbeat split).

The remaining ~90 are older backlog (PresheafInternalHom / StalkTensor / PicSharp families); a
dedicated coverage pass is already scheduled in STRATEGY as the `Coverage + file-split cleanup`
phase — fold these 7 into it.

## D3′ (UNCLEAR) — scaffold the 3 effort-broken bricks
Last iter's effort-breaker split `pullbackTensorMap_restrict` (L3144, TensorObjSubstrate.lean) into
`lem:sheafify_pullbackcomp_hom_inv_cancel`, Sq3 `lem:sheafify_tensor_unit_iso_comp`, Sq4
`lem:pullback_val_iso_comp` + a `comp_δ` assembly (\uses wired, doctor clean). Next: scaffold these
3 into Lean (sorry bodies) and prove bottom-up. Running this in parallel with DUAL is fine — the two
lanes touch disjoint files. (Defer the `TensorObjSubstrate.lean` 3152-LOC split until D3′ is past
the central-import churn, per iter-007 plan.)
