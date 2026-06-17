# Lean Audit Report

## Slug
ts240

## Iteration
240

## Scope
- files audited: 2
- files skipped (per directive): 0 — all files listed in directive were read in full

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L39–50 (`## Status (current)` header block)**: stale with respect to iter-240.
    The header lists only `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`, and the
    route-(e) residual as outstanding. It does NOT reflect the three axiom-clean declarations
    added this iter (`unitToPushforwardObjUnit_comp`, `pullbackObjUnitToUnit_comp`,
    `sheafifyTensorUnitIso`) nor the new §6 pullback-monoidality section. A reader of the
    header alone would undercount the iter-240 progress.
  - **L44–50 (header, dual-block paragraph)**: describes `InternalHom.internalHom`, `dual`,
    `evalLin`, `internalHomEvalApp`, and `internalHomEval` as if they belong to this file's
    status section, but per the sub-module layout (L108) all of them live in
    `PresheafInternalHom.lean`. The paragraph is accurate about project state but
    misleadingly placed in this file's header.
  - **L710–711 (`exists_tensorObj_inverse` body comment)**: stale sorry-count claim
    `"closing this sorry (80→79)"`. The current project sorry-count (per earlier audit logs)
    is well below 80; this is a leftover number from a prior iteration's internal
    bookkeeping that was never cleaned up.
  - **L882–894 (`unitToPushforwardObjUnit_comp`) — NEW decl, GENUINE**: the proof is a
    literal `ext`-chain ending in `rfl`. The docstring claims "sectionwise it is just
    functoriality of the structure-sheaf ring maps, hence `rfl` after the `ext`-chain" —
    exactly matches the proof. Non-vacuous: the `rfl` is at a concrete computation level.
    No issues.
  - **L923–1009 (`pullbackObjUnitToUnit_comp`) — NEW decl, GENUINE**: ~87-line proof
    entirely via adjunction-mate transport (`homEquiv.injective`, `unit_conjugateEquiv`,
    `conjugateEquiv_pullbackComp_inv`, `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`
    — all confirmed to exist in Mathlib via filesystem search). Multiple `erw` steps are
    explained in the docstring ("defeq-but-not-syntactic" SheafOfModules compositions).
    Docstring accurately describes the adjunction-mate transport route. Forward reference
    to `pullbackUnitIso` (docstring L913) is a non-existent-yet declaration; HANDOFF 1
    explains why. Non-vacuous and honest.
  - **L913 (`pullbackObjUnitToUnit_comp` docstring)**: says "Consumed by `pullbackUnitIso`".
    `pullbackUnitIso` does not yet exist in any project Lean file. The HANDOFF block at
    L1011 explains this explicitly, so the forward reference is not actively misleading, but
    a reader of the docstring alone would expect a downstream consumer that doesn't yet exist.
  - **L1011–1049 (HANDOFF 1 — `pullbackUnitIso`)**: correctly reports that
    `pullbackObjUnitToUnit_comp` IS landed (verified above). The described blocker
    (instance-synthesis failure for `IsIso (pbu U.ι)` inside a rich context) is plausible
    and consistent with known `SheafOfModules.pullbackObjUnitToUnit` implicit-argument
    fragility. References `instIsIsoPullbackObjUnitToUnitOfFinal` (L1019) — confirmed
    **absent from Mathlib and from all project `.lean` files** (it appears only in the
    blueprint tex and an analogy file). The HANDOFF uses it only as a name in the sketch,
    not as a Lean tactic, so it doesn't break compilation; but the name may not be the
    correct Mathlib name (or may not exist). Worth a targeted `lean_local_search` next iter.
  - **L1063–1097 (`sheafifyTensorUnitIso`) — NEW private decl**: proof mirrors
    `tensorObj_assoc_iso`'s technique (`W_whiskerRight/Left_of_W` +
    `isIso_sheafification_map_of_W`). No sorry. HANDOFF 2 correctly identifies this as the
    RHS-reconciliation brick for the eventual `pullbackTensorIso`. Honest.
  - **L1099–1151 (HANDOFF 2 — `pullbackTensorIso`/`IsInvertible.pullback`)**: correctly
    describes that the abstract-pullback wall (no sectionwise formula) prevents the
    plan-agent's `extendScalars`-Monoidal recipe. Pivot suggestions (local-chart-finality,
    flat-restricted route) are structurally sound given the context. Note at L1149:
    "Informal agent unavailable this iter: MOONSHOT key 401, no other key set" — operational
    detail appropriate for a proof-journal comment, odd in a Lean file but not misleading.
  - **`exists_tensorObj_inverse` sorry (L715)**: correctly marked, body comment correctly
    states two remaining bridges (C and A). No overstating of completion.
  - **`addCommGroup_via_tensorObj` sorry (L1184)**: correctly marked. Docstring accurately
    says it is the iter-204+ closure target.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (dead code / unused `have`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L535–661 (`pushforward_spec_tilde_iso`) — scaffold audit**: The proof structure is
    genuine. The call chain is: `pushforward_spec_tilde_iso_of_isLocalizedModule` (reduces
    to `hloc` discharge) → `algebraize [φ.hom]` (algebra instance setup) → construction of
    `σmor`, `mTop`, `mDa`, `tTop`, `tDa`, `hσloc`, `himg`, `hGloc`, `Gmor`, `ρ`, `e₁`,
    `e₂` → `have hsq : ... := by ... sorry` → then uses `hsq` at L651 (`hρ : ρ = ...`)
    → `key` → `hstep` (L657–658, `IsLocalizedModule.of_linearEquiv_right`) →
    final `IsLocalizedModule.of_linearEquiv` (L660–661). All steps after the sorry are
    genuine mathematical content. The sorry is exactly one thing: the naturality square
    `ρ ≫ e₂.hom = e₁.hom ≫ Gmor` (the `hsq` claim, L629). Not sorry-padded; the scaffold
    is real.
  - **L625–628 (`nat1` in `pushforward_spec_tilde_iso`)**: `nat1` is set up via
    `ModuleCat.restrictScalarsComp'App_inv_naturality` (confirmed in Mathlib
    `ChangeOfRings.lean`) but is **never used** in the body of `hsq`'s `sorry`-proof.
    The comment at L624 says "(Verified to typecheck; ready for the next iteration.)" —
    this is honest but `nat1` is currently dead code. Lean will emit an unused-variable
    warning. Mild code smell: the `have` should be deferred to the iter when it can
    actually be wired up, or kept as a `-- have nat1 := ...` comment.
  - **L639–648 (obstacle comment around `hsq` sorry)**: accurately identifies the blocker
    ("representational/universe-level mismatch between the App that `gammaPushforwardIsoAt`
    bakes in and a freshly-applied `restrictScalarsComp'App`"). The proposed fix ("repackage
    `gammaPushforwardIsoAt` as a genuine `NatTrans`/`NatIso`") is structurally consistent
    with how the iso is built. No overstatement.
  - **L540–561 (preceding comment block about `of_linearEquiv` strategy)**: says "The two
    bricks for this discharge are now in place and axiom-clean." Both
    `gammaPushforwardIsoAt` (L328) and `tildeRestriction_isLocalizedModule` (L480) are
    indeed in the file and carry no sorry. Accurate.
  - **`affineBaseChange_pushforward_iso` sorry (L693)**: correctly marked, surrounded by
    an accurate docstring describing the missing affine-dictionary infrastructure.
  - **`flatBaseChange_pushforward_isIso` sorry (L715)**: correctly marked, comment
    describes Čech-cohomology strategy, makes no false claim of progress.
  - **Module header (L1–46)**: accurately names the three main declarations and their
    sources. Does not claim any of the sorry'd declarations are proved. Consistent with
    the actual file body.

---

## Must-fix-this-iter

None.

No declaration has a body that contradicts its signature. No sorry is surrounded by a comment claiming it is closed. No excuse-comment ("will fix later / temporary / placeholder") is attached to a load-bearing definition. The two new declarations in TensorObjSubstrate.lean are genuine axiom-clean proofs.

---

## Major

- `TensorObjSubstrate.lean:39–50` — The **`## Status (current)` header block is stale** with
  respect to iter-240. It does not mention `unitToPushforwardObjUnit_comp`,
  `pullbackObjUnitToUnit_comp`, `sheafifyTensorUnitIso`, or the new §6 pullback-monoidality
  section. A reader relying on this block to gauge file state sees an under-report of
  iter-240 progress. Should be updated to name the three new axiom-clean declarations and
  note the §6 work-in-progress.

- `TensorObjSubstrate.lean:44–50` — The header reports on `PresheafInternalHom.lean`
  declarations (`InternalHom.internalHom`, `dual`, `internalHomEval`) as part of this file's
  status section, with no attribution to the sub-module that owns them. Mixes per-file and
  per-project status in a way that can mislead about what *this file* provides.

---

## Minor

- `TensorObjSubstrate.lean:710–711` — stale sorry-count annotation `"closing this sorry (80→79)"` inside `exists_tensorObj_inverse` body comment. The project sorry-count is well below 80 at this iteration.

- `TensorObjSubstrate.lean:913` — `pullbackObjUnitToUnit_comp` docstring references `pullbackUnitIso` as an extant consumer; that declaration does not yet exist. HANDOFF 1 clarifies, but the docstring alone is a dangling forward reference.

- `TensorObjSubstrate.lean:1019` — HANDOFF 1 references `instIsIsoPullbackObjUnitToUnitOfFinal` by name. This name is **not found in any Mathlib `.lean` file** in the pinned `.lake/packages` tree (grep confirmed). It appears only in the blueprint tex and analogy files. If the next-iter prover uses this name blindly it will get an unknown-identifier error. The correct Mathlib name (or its absence) should be verified with `lean_local_search` before the proof attempt.

- `FlatBaseChange.lean:625–628` — `nat1` is a live `have` whose value (`ModuleCat.restrictScalarsComp'App_inv_naturality` applied to specific arguments) is never referenced in the `sorry`-body that follows. Dead code; will produce an unused-variable warning. Consider commenting it out until the sorry is resolved.

---

## Excuse-comments (always called out separately)

None found. No declaration in either file carries a comment of the form "temporary", "placeholder", "will fix later", or "wrong but works."

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: Both files are in sound shape for a sorry-in-progress formalization project; the two newly-added declarations are genuine axiom-clean proofs, the one new sorry (`hsq`) in FlatBaseChange is correctly identified and properly scoped, and no declaration lies about its completion status. The stale `Status (current)` header in TensorObjSubstrate.lean is the most actionable finding.
