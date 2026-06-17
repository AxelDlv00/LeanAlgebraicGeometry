# Lean Audit Report

## Slug
iter007

## Iteration
007

## Scope
- files audited: 9
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Root import file (7 lines). Imports the 6 sub-modules; no declarations.

---

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `IsLocallyTrivial.pullback` has a complete 7-step chart proof (`i1`–`i7`); no sorry.
  - `OnProduct`, `pullbackAlongProjection`, `preimage_subgroup` all carry real proof bodies.
  - 329 lines; zero sorry instances; clean.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `PicSharp` is a deliberate `Functor.const PUnit` stub, documented as gated on D4′
    `pullback_tensor_iso_loctriv`. This is not an excuse-comment: the stub is the mathematically
    correct placeholder at a known dependency boundary (the declaration exists to satisfy
    import structure; no false claim is made about its value).
  - `addCommGroup` instance has a real body using upstream substrate; no sorry.
  - Only sorry reachable transitively is the upstream `exists_tensorObj_inverse` (tracked,
    per known-issues).
  - 644 lines; zero file-local sorry instances; clean.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L712** — `exists_tensorObj_inverse`: body is `sorry` with an extensive documented
    comment explaining the two remaining bridges (C-bridge `dual_isLocallyTrivial` and
    A-bridge `homOfLocalCompat`) and the import-cycle gating. Per known-issues directive;
    not flagged as an issue here.
  - **L3144** — `pullbackTensorMap_restrict`: `sorry` with a three-step plan comment
    (Sq1 unit reassembly → Sq4 → interleaved merge). Per known-issues directive; not
    flagged here.
  - All other declarations are sorry-free and axiom-clean per the module docstring.
  - 3152 lines; 2 open sorries (both per directive known-issues).

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Sections: `RestrictScalarsRingIsoTensor`, lax-monoidal `restrictScalars` lift,
    `PushforwardAdj` (H1), `StrongMonoidalRestrictScalars` (H2), `InternalHom` namespace
    (globalSMul, homModule, restr, internalHomObjModule, restrictionMap,
    internalHomPresheaf, internalHom), `Dual` section (dual, evalLin, internalHomEvalApp,
    internalHomEval, dualPrecompEquiv, dualIsoOfIso).
  - `internalHomEval` naturality closed (iter-224).
  - 1087 lines; zero sorry instances; fully closed and axiom-clean.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Implements forward `stalkTensorDesc` and reverse `stalkTensorRev`; full isomorphism
    `stalkTensorIso : (A ⊗ᵖ B).stalk x ≃ₗ A.stalk x ⊗_{R.stalk x} B.stalk x`.
  - 544 lines; zero sorry instances; fully closed.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L15** — Module docstring bullet claims: "one open sorry
    `isLocallyInjective_whiskerLeft_of_W`". This is **stale**: the declaration has a
    complete proof body at L352–L446 (iter-237 close). The comment actively misleads a
    reader into thinking a proof obligation is open when it is not.
  - `OverSliceSheafEquiv` section at the end is a stub (only `variable` + `end`, no
    declarations) — this is an acceptable architectural placeholder, not an issue.
  - 532 lines; zero sorry instances; route-(e) whisker work fully closed.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L44** — Docstring says "Step-4 `isoMk` naturality sorry at `~L546`". The location
    is **stale**: the sorry no longer lives at ~L546 of this file. After the SliceTransport
    split this iter, the open sorries (left_inv / right_inv) are in
    `DualInverse/SliceTransport.lean` (L724, L726). A reader following this cross-ref lands
    on the wrong file and wrong line.
  - **L200** — Comment says "`sliceDualTransport`'s body is concrete (its `.hom` is
    currently a `sorry`, so the square closes trivially by `subsingleton`)". This is
    **partially stale** after iter-007 progress: `sliceDualTransport`'s `naturality`,
    `map_add'`, and `map_smul'` fields are all now CLOSED (not sorry). Only `left_inv`
    and `right_inv` remain sorry. The comment overstates the sorry footprint and the
    "trivially by subsingleton" remark now applies only to the outer `isoMk` naturality
    square (which still holds), not to `sliceDualTransport`'s internals.
  - `dual_restrict_iso` naturality square (outer `isoMk` call, L202–206) closes by
    `subsingleton` — thin-poset coherence — which is mathematically correct and not a
    code smell here.
  - `homOfLocalCompat` is fully proved (iter-256); no sorry; no issue.
  - Cross-file `~L` references in docstrings (L162, L163, L239, L242, L244, L268, L276,
    L416, L418, L451, L452) use approximate blueprint line numbers, not Lean line numbers —
    these are clearly labelled approximations and are acceptable.
  - 638 lines; zero file-local sorry instances (all sorry via imported SliceTransport).

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - New this iter. Contains `§0` (presheaf dual-of-unit iso, namespace `PresheafOfModules`)
    and `§A` (C-bridge slice transport helpers, namespace `AlgebraicGeometry.Scheme.Modules`).
  - **L444** — `sliceDualTransportInv.naturality`: `sorry -- REPAIR: sorry inserted at
    broken proof site; fill via analogies/dualnat006.md`. Per directive known-issues;
    not flagged as an excuse-comment. The `-- REPAIR:` annotation is a workflow navigation
    aid pointing to the active analogy file, not an admission that the definition is wrong.
  - **L724** — `sliceDualTransport` left_inv: same pattern; per directive known-issues.
  - **L726** — `sliceDualTransport` right_inv: same pattern; per directive known-issues.
  - iter-007 progress in this file: `sliceDualTransport`'s `naturality`, `map_add'`, and
    `map_smul'` are all CLOSED. `sliceDualTransport_naturality_apply` (standalone extracted
    helper lemma) is CLOSED.
  - All other declarations (`unitDualSectionEquiv`, `dualUnitIsoGen`, `isIso_ε_*` family,
    `dualUnitRingSwap*`, `unitRelabelSwap*`, `appIso_hom_naturality_apply`) are fully
    proved; no sorry.
  - 733 lines; 3 open sorries (all per directive known-issues).

---

## Must-fix-this-iter

None.

No excuse-comments, no weakened-wrong definitions, no parallel Mathlib APIs, no unauthorized
axioms, no suspect bodies on load-bearing claims. The 5 open sorries are all per known-issues
and all carry either a tracked REPAIR annotation (SliceTransport) or an extensive documented
explanation (TensorObjSubstrate). None represent code lying about its correctness.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean:15` — Module docstring claims
  an open sorry on `isLocallyInjective_whiskerLeft_of_W`, but that declaration has been fully
  proved (L352–446, iter-237). The stale claim could mislead the plan agent into treating a
  closed goal as open, or into wasting audit/prover time on a non-issue.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:44` — Docstring locates
  "Step-4 `isoMk` naturality sorry at ~L546" of this file. The sorry is no longer in this
  file at all — it moved to `DualInverse/SliceTransport.lean` (L724/L726) in the split this
  iter. A reader or agent following this cross-reference will look for a sorry that does not
  exist at the stated location.

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:200` — Comment says
  `sliceDualTransport`'s `.hom` is "currently a `sorry`". After iter-007 progress,
  `sliceDualTransport`'s `naturality`, `map_add'`, and `map_smul'` are all CLOSED; only
  `left_inv`/`right_inv` remain sorry. The comment overstates the sorry coverage and may
  mislead future provers or the plan agent about the state of the C-bridge.

---

## Minor

None.

---

## Excuse-comments (always called out separately)

None. The `-- REPAIR: sorry inserted at broken proof site; fill via analogies/dualnat006.md`
annotations in `SliceTransport.lean` are workflow navigation pointers, not excuse-comments.
They do not claim the definition is wrong or that a wrong value is being used; they flag
a typed sorry at a specific proof obligation and point to the analogy file that motivates
the fill strategy.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 0
- **excuse-comments**: 0

Overall verdict: The codebase is structurally sound with no must-fix issues; three major stale
comments require updating — two in `DualInverse.lean` (sorry location pointer and sorry
coverage claim, both obsoleted by the SliceTransport split this iter) and one in
`Vestigial.lean` (closed sorry falsely reported as open).
