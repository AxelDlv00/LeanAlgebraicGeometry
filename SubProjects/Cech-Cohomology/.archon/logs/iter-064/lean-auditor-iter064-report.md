# Lean Audit Report

## Slug
iter064

## Iteration
064

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: 1 flagged (line 698 — residual count one too high after option-step closure)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (line 1165 — unexplained heartbeat override)
- **excuse-comments**: none
- **notes**:
  - **4 honest sorries** (total sorry count confirmed at 4, consistent with the iter-064 "5→4" claim):
    - `CechSectionIdentification.lean:983` — inside `hX` in `pushPull_coprod_prod_empty`:
      `refine (… map_isZero …).isTerminal; sorry`. Obligation: `IsZero` of the pulled-back module over
      the initial scheme `∐ PEmpty`. Correctly typed; genuine wall (MEMORY: "empty (`IsZero` over `∐PEmpty`)").
    - `CechSectionIdentification.lean:999` — entire body of `coprodToProd_isIso_of_equiv`. Obligation:
      transport the `α`-comparison across coproduct/product reindexing isos. Correctly typed; genuine wall
      (MEMORY: "reindex (`whiskerEquiv` transport)").
    - `CechSectionIdentification.lean:1358` — entire body of `cechSection_complex_iso`. Correctly typed
      (promoted complex iso from degreewise isos); Stub 5.
    - `CechSectionIdentification.lean:1417` — entire body of `cechSection_contractible`. Correctly typed
      (contracting homotopy on the augmented concrete section complex); Stub 6.
  - **`coprodToProd_isIso_option` (lines 1036–1100)** — fully proved, no sorry. The "iter-064 Option-step
    CLOSED" claim is confirmed. The `hcanon` sub-proof (lines 1058–1098) is axiom-clean.
  - **CSI helpers genuineness** (all requested helpers verified genuine):
    - `coprodOverIncl` (line 949): correct over-inclusion into the descent object.
    - `coprodToProdMap` (line 957): correct Pi.lift of push-pull maps.
    - `coprodToProdMap_comp_π` (line 1007): correct, `simp`-proved from `Pi.lift_π`.
    - `coprodToProd_isIso_option` (line 1036): fully proved Option step — no sorry.
    - `isIso_coprodToProdMap` (line 1104): uses `Finite.induction_empty_option`; axiom-clean structure,
      but TRANSITIVELY depends on 2 sorries (`pushPull_coprod_prod_empty` inner sorry + `coprodToProd_isIso_of_equiv`).
    - `pushPull_coprod_prod` (line 1118): `asIso` wrapper; transitively depends on the same 2 sorries.
    - `pushPull_sigma_iso` (line 1166): three-step `≪≫` chain; transitively depends on 2 sorries through
      `pushPull_coprod_prod`.
    - `pushPull_eval_prod_iso` (line 1260): assembles functor-preservation steps; transitively depends on
      the same 2 sorries through `pushPull_sigma_iso`.
    - `piOptionIso_inv_π_none` (line 1015): `simp`-proved; genuine.
    - `piOptionIso_inv_π_some` (line 1023): `simp`-proved; genuine.
    - `pushPullObjCongr_hom` (line 1002): `:= rfl`; genuine.
    - `pushPull_binary_coprod_prod_hom` (line 875): `:= rfl`; genuine.
  - **Transitive dependency tracking** — `pushPull_sigma_iso` and `pushPull_eval_prod_iso` are advertised
    as Stub 2 / Stub 4 results, but each depends transitively on 2 open sorries. No declaration falsely
    presents itself as axiom-clean; the sorry walls are correctly attributed in their own enclosing
    functions.
  - **Heartbeat overrides with comments** — `set_option maxHeartbeats 1600000` at line 366 (comment
    explains 6-layer whnf chain for `widePullback_coproduct_iso`) and line 1031 (comment explains
    `erw`-induced whnf cost for `coprodToProd_isIso_option`) are legitimate with explanations.
  - **`set_option synthInstance.maxHeartbeats 800000` at line 1165** (`pushPull_sigma_iso`) — no
    accompanying comment explaining why instance synthesis is slow. Minor bad practice.
  - **`Iso.refl _` at line 568** (`cechBackbone_obj_widePullback`) — claims definitional equality
    between the Čech nerve backbone and `Over.mk (WidePullback.base …)`. The comment ("all the
    identifications are definitional") is accurate; `Iso.refl _` requires genuine defeq and Lean
    would reject it if not.
  - **`erw` uses** (lines 1073, 1078, 1093, 1096 in `coprodToProd_isIso_option`) — the accompanying
    comment explains these are needed because projection/fold steps drive `whnf` on push-pull composites
    past the default budget. Not suspicious.

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: 0
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (line 472 — linter suppression)
- **excuse-comments**: none (see note below on "PARTIAL" label)
- **notes**:
  - **5 honest sorries**:
    - `OpenImmersionPushforward.lean:607` — `sliceReverseRingMap` body: `sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui) ≫ sorry`.
      First factor is pinned to the blueprint-correct value; the `≫ sorry` is the codomain bridge (a ~40–80
      LOC object-relabel iso + `sheafPushforwardContinuousComp'` step). Correctly typed; the RESIDUAL
      STATE comment (lines 609–636) precisely describes both subproblems.
    - `OpenImmersionPushforward.lean:649` — entire body of `pushforwardSliceAdjunctionH1`. Blocked on
      concrete φ'' per RESIDUAL STATE comment. Correctly typed.
    - `OpenImmersionPushforward.lean:660` — entire body of `pushforwardSliceAdjunctionH2`. Same blocker.
      Correctly typed.
    - `OpenImmersionPushforward.lean:692` — `pushforwardSlicePullbackIso`: `… ≪≫ sorry`. First factor
      (`Adjunction.leftAdjointUniq …`) is concrete; the `≪≫ sorry` is the rfl-clean section identity
      blocked on concrete φ''. Correctly typed.
    - `OpenImmersionPushforward.lean:934` — entire body of `higherDirectImage_openImmersion_comp`.
      Documented as waiting on Part (1)'s residuals. Correctly typed.
  - **`higherDirectImage_openImmersion_acyclic` transitive sorry analysis** — the theorem body (lines
    797–893) contains NO inline sorry. However, `case hqc` (line 868) dispatches via
    `exact pushforward_iso_preserves_qcoh U.isoSpec H hH`, which transitively depends on 4 sorried
    sub-lemmas:
      • `sliceReverseRingMap` (≫ sorry, line 607)
      • `pushforwardSliceAdjunctionH1` (sorry, line 649)
      • `pushforwardSliceAdjunctionH2` (sorry, line 660)
      • `pushforwardSlicePullbackIso` (≪≫ sorry, line 692)
    The RESIDUAL STATE comment at lines 609–636 is fully transparent about these 4 open holes and
    correctly notes that `case hqc` "has NO inline sorry." This is accurate language.
  - **MAJOR**: Inline comment at lines 861–862 in the body of `higherDirectImage_openImmersion_acyclic`:
    > `` `hqc : (Φ H).IsQuasicoherent` … discharged **in full** by `pushforward_iso_preserves_qcoh` ``
    The phrase "in full" misrepresents the status — `pushforward_iso_preserves_qcoh` transitively depends
    on 4 open sorries (all downstream of φ''). The correct framing is "discharged **modulo the 4 leaf
    sorries** (φ'', H₁, H₂, section identity) by `pushforward_iso_preserves_qcoh`." A reader seeing
    only the local case-handling context would falsely believe this obligation is axiom-clean. The
    broader RESIDUAL STATE comment mitigates this, but the inline comment should carry the caveat.
  - **Heartbeat overrides with comments** — `set_option maxHeartbeats 2000000` / `synthInstance 1000000`
    at lines 414–415 (for `pushforward_iso_qcoh_of_slice_qcoh`, synthesis of doubly-sliced
    `HasSheafify`/`WEqualsLocallyBijective`), `maxHeartbeats 4000000` / `synthInstance 2000000` at lines
    493–494 (for `sliceStructureSheafHom_isRightAdjoint`), and same pair at lines 694–695 (for
    `pushforward_iso_preserves_qcoh`) — all carry explanatory comments. Legitimate.
  - **`set_option linter.style.longLine false` at line 472** — suppresses the line-length linter for
    `sliceStructureSheafHom`. The affected declaration is a meaningful `def`; suppressing the linter
    here is cosmetic and low-impact.
  - **"PARTIAL" comment at line 594** — this is a status label inside the body of `sliceReverseRingMap`
    noting which part of the composition is pinned and which is the residual. Not an excuse-comment
    (it describes design facts, not a known-wrong placeholder); acceptable project workflow documentation.
  - **`pushforward_iso_preserves_qcoh` genuineness** — the logic of the proof (lines 708–722) is
    structurally correct: it obtains `qcd`, calls `pushforward_iso_qcoh_of_slice_qcoh`, and for each
    slice constructs a presentation via `pullback ψ_r` then transports across `pushforwardSlicePullbackIso`.
    The chain is mathematically sound; the open holes are precisely the 4 typed sorries, not structural gaps.

---

## Must-fix-this-iter

No findings meet the must-fix criteria. All sorries have correctly-typed statements. No weakened/trivialized types. No excuse-comments. No axiom laundering. No Parallel-Mathlib API copies.

*(None)*

---

## Major

- `OpenImmersionPushforward.lean:861–862` — Inline comment says `case hqc` is "discharged **in full** by `pushforward_iso_preserves_qcoh`" without noting that this called lemma transitively depends on 4 open sorried sub-lemmas (`sliceReverseRingMap:607`, `pushforwardSliceAdjunctionH1:649`, `pushforwardSliceAdjunctionH2:660`, `pushforwardSlicePullbackIso:692`). The RESIDUAL STATE block (lines 609–636) correctly documents these holes, but the local case comment does not carry the "modulo leaves" caveat. A reader auditing only the `acyclic` proof body would be misled into believing `case hqc` is axiom-clean.

---

## Minor

- `CechSectionIdentification.lean:698` — Status comment claims "residual = the **three** `coprodToProd_isIso_*` induction steps" but `coprodToProd_isIso_option` is now fully proved (no sorry). Residual is 2 steps (empty + equiv), not 3. Stale by one.
- `CechSectionIdentification.lean:1165` — `set_option synthInstance.maxHeartbeats 800000` on `pushPull_sigma_iso` has no accompanying comment explaining the source of the synthesis pressure (contrast with every other heartbeat override in both files, which carry explicit explanations).
- `OpenImmersionPushforward.lean:472` — `set_option linter.style.longLine false` suppresses a style linter globally for the `sliceStructureSheafHom` declaration. Low impact; the suppression is contained to the one line.

---

## Excuse-comments (always called out separately)

None found. The "PARTIAL" label at `OpenImmersionPushforward.lean:594` and the various "RESIDUAL" / "Status: L2 DONE" markers are project-workflow documentation of the factual state, not admissions of wrong-but-shipped code.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (misleading "in full" language on `case hqc` at OpenImm:861–862)
- **minor**: 3 (stale residual count CSI:698; unexplained heartbeat override CSI:1165; linter suppression OpenImm:472)
- **excuse-comments**: 0

Overall verdict: Both files are structurally sound and honest about their sorry holes; the 9 open sorries (4 in CSI, 5 in OpenImm) are all correctly typed and accurately documented, with the single notable blemish being one inline comment in the body of `higherDirectImage_openImmersion_acyclic` that presents a transitively sorry-dependent case as resolved "in full."
