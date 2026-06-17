# Lean Audit Report

## Slug
aud263

## Iteration
263

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L43–48 (module header `## Status (current)`): still names `sheafificationCompPullback_comp` as the sorry-carrying residual in slot (b). In iter-263 that lemma was closed and its sorry relocated to the new private helper `sheafificationCompPullback_comp_tail` (L2475). The header should refer to `sheafificationCompPullback_comp_tail`, not the now-closed caller. The sorry count (THREE) is still correct; only the named carrier is wrong. The header also still says "iter-262" as the freshness marker. **Major.**
  - L2475–2519 (`sheafificationCompPullback_comp_tail`): the helper carries the relocated sorry at L2519. Its statement is a distinct, non-trivial reduced goal (the unit-level identity after R0 is peeled), not a circular restatement of the caller. The relocation is honest.
  - L2532–2629 (`sheafificationCompPullback_comp`): sorry-free in its own proof body. The proof makes substantive forward progress (homEquiv injective, `sheafificationCompPullback_eq_leftAdjointUniq`, `homEquiv_leftAdjointUniq_hom_app`, `comp_unit_app`, `conv_rhs` distribution, `sheaf_unit_comp_pushforward_pullbackComp_inv` R0-peel, `reassoc_of%` splice) and concludes `exact sheafificationCompPullback_comp_tail h f P`. `#print axioms` on this lemma WOULD still flag `sorryAx` transitively via the helper. The lemma is `private` and nowhere claimed to be axiom-clean.
  - L720 (`exists_tensorObj_inverse`): one sorry, honestly documented and unchanged.
  - L2747 (`pullbackTensorMap_restrict`): one sorry, honestly documented and unchanged.
  - Total sorries in file: 3 (L720, L2519, L2747). Consistent with header's "THREE tracked typed-sorry residuals" (once the name in slot (b) is corrected).

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L36–38 (module header, `sliceDualTransport` status): "REMAINING (typed sorries): the `≃ₗ`-packaging fields (naturality, **map_add'**/map_smul' — blocked on an `internalHomObjModule`-add↦Hom-add bridge — and the reverse `invFun` + its `left_inv`/`right_inv` round-trips)." `map_add'` is now **closed** (iter-263, L341–349). The header still lists it as remaining and gives a stale blocker reason ("blocked on an `internalHomObjModule`-add↦Hom-add bridge"). The header implies 6 open fields in `sliceDualTransport`; the actual count is now 5 (naturality, map_smul', invFun, left_inv, right_inv). **Major.**
  - L41 (module header, `dual_isLocallyTrivial`): "depends on `dual_restrict_iso` Step-4 sorry at **~L254**". The sorry in `dual_restrict_iso` is at L524 in the current file, not ~L254. Stale line reference. **Minor.**
  - L341–349 (`map_add'` field of `sliceDualTransport`): closed without sorry as claimed. The `show (x + y).app _ = x.app _ + y.app _ from rfl` bridge is sound: addition on `PresheafOfModules.Hom` is defined pointwise, so the component-wise equality is definitional. `Functor.map_add` (additive functor) + `Preadditive.add_comp` (post-composition distributes over `+`) close the goal; the trailing `rfl` is on a syntactic equality. No `sorry`-via-`rfl`-on-a-false-defeq. Axiom-clean. ✓
  - L371–383 (`map_smul'` field of `sliceDualTransport`): reduced to a crux with a sorry at L383. The inline documentation accurately describes the two remaining steps (β-naturality ring identity `s = (β.app W').hom c` + linearity of `dualUnitRingSwap`). Not a laundering. ✓
  - L335 (naturality sorry): one sorry, honestly documented. ✓
  - L388, L391, L393 (`invFun`, `left_inv`, `right_inv`): three sorries, correctly documented as blocked on `invFun` construction. ✓
  - L524 (`dual_restrict_iso`): one sorry at the thin-poset naturality square of `PresheafOfModules.isoMk`, honestly documented as "cannot be discharged until `sliceDualTransport`'s body is concrete". ✓
  - Total sorries in file: 6 (L335, L383, L388, L391, L393 in `sliceDualTransport`; L524 in `dual_restrict_iso`).

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L163–165 (`pushPullObj`): axiom-clean pure definition. No sorry. `(pushforward Y.hom).obj ((Scheme.Modules.pullback Y.hom).obj F)` — straightforward object brick. ✓
  - L175–188 (`pushPullMap`): axiom-clean pure term-level definition. No sorry. The five-factor composite using adjunction unit, `pushforwardComp.hom`, `eqToHom` transports along `Over.w g`, `pullbackComp.hom`, and a second `eqToHom` is a pre-coherence brick with no functor laws invoked. ✓
  - L189–212 (`-- Deferred: the functor laws…` comment): the functor identity and composition laws for the push-pull functor are **explicitly** documented as deferred, with a clear mathematical explanation (mate calculus over pseudofunctor coherences) and a statement that the coherences are in Mathlib. This is NOT a silent stub — the deferred block is a named comment section, not a `sorry`-backed declaration. ✓
  - L97 (`CechNerve`): one sorry, honestly documented as the "single genuine hole" gated on push-pull functor laws. ✓
  - L285 (`CechAcyclic.affine`): one sorry, honestly documented (needs localisation description + module-level contracting homotopy, absent from Mathlib). ✓
  - L322 (`cech_computes_higherDirectImage`): one sorry, honestly documented (needs two spectral sequences for `Scheme.Modules`, absent from Mathlib). ✓
  - L384 (`cech_flatBaseChange`): one sorry, honestly documented (needs term-wise affine base change of the Čech complex + flatness of `- ⊗_A B` on `Scheme.Modules`, absent from Mathlib). ✓
  - `cechHigherDirectImage` (L340–342) and `relativeCechComplexOfNerve` (L223–228): both axiom-clean pure definitions. ✓
  - Total sorries in file: 4 (L97, L285, L322, L384). All honestly documented.

---

## Must-fix-this-iter

None. No laundered sorries, no weakened-wrong definitions, no excuse-comments, no axiom-clean misrepresentation.

---

## Major

- `TensorObjSubstrate.lean:43` — module header slot (b) names `sheafificationCompPullback_comp` as the sorry-carrying residual, but that lemma is now closed (iter-263). The sorry lives in `sheafificationCompPullback_comp_tail` (L2519). Header must be updated to the actual carrier name; the count (THREE) is still correct. Also says "iter-262" (stale iter marker).
- `DualInverse.lean:36–38` — module header lists `map_add'` as a remaining typed sorry in `sliceDualTransport` and gives the blocker reason "blocked on an `internalHomObjModule`-add↦Hom-add bridge". `map_add'` is now closed (iter-263); the implied count of 6 open fields overstates by 1 (correct count is 5: naturality, map_smul', invFun, left_inv, right_inv).

---

## Minor

- `DualInverse.lean:41` — `dual_isLocallyTrivial` description says "Step-4 sorry at ~L254". The sorry is at L524 in the current file. Stale line-number reference.

---

## Excuse-comments (always called out separately)

None. All status annotations are honest documentation of known open goals, not admissions that definitions are wrong.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 — both are stale module-header status comments misidentifying closed/open residuals
- **minor**: 1 — stale line-number reference
- **excuse-comments**: 0

Overall verdict: All three files are in an honest state. The relocation of the `sheafificationCompPullback_comp` sorry to the extracted helper `sheafificationCompPullback_comp_tail` is structurally sound and not a laundering; `map_add'` in `sliceDualTransport` is genuinely closed axiom-clean; `pushPullObj`/`pushPullMap` in `CechHigherDirectImage.lean` are axiom-clean pre-coherence bricks with functor laws explicitly and honestly deferred. Two module-header status comments require update to reflect iter-263 progress.
