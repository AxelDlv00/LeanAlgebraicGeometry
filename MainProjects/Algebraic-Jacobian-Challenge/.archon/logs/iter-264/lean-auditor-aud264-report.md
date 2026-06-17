# Lean Audit Report

## Slug
aud264

## Iteration
264

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - `pushPullMap_id` (L216–271): **genuinely proved**, no `sorry` anywhere in the proof body.
    The proof routes through `unit_conjugateEquiv`/`conjugateEquiv_pullbackId_hom` (`star`),
    `pseudofunctor_right_unitality` (`hru`/`hru2`), a sectionwise collapse helper `hpf`
    (`hom_ext; intro U; rfl`), and an assembly via two `erw` calls.  All goals are closed.
  - Four honest `sorry`-declarations: `CechNerve` (L89–97), `CechAcyclic.affine` (L350–360),
    `cech_computes_higherDirectImage` (L387–397), `cech_flatBaseChange` (L447–459).
    All carry detailed Stacks-reference comments describing the missing Mathlib infrastructure;
    none uses wrong-type signatures or trivial bodies.
  - Inline block comment at L189–212 correctly marks `pushPullMap_id` as "DONE (below)" and
    `pushPullMap_comp` as "remaining" — matches the actual code state.
  - Minor bad practice (L175–188): `pushPullMap` uses two `eqToHom` transports for the
    over-triangle `Over.w g`.  This is documented ("No functor law is used") and is necessary
    since the over-triangle appears as a propositional equality on the underlying morphisms,
    not a definitional one.  The transport is coherent and does not hide a sorry.
  - `coverArrow` / `coverCechNerve` / `relativeCechComplexOfNerve` / `cechHigherDirectImage`
    are definitions without sorry and with reasonable bodies.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged (1 major, 1 minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - **`leftAdjointUniqUnitEta_app`** (L1668–1697): **genuinely proved**, no `sorry`.
    The proof sets `A`/`B` composite adjunctions, identifies `sheafificationCompPullback.hom.app P`
    with `(A.leftAdjointUniq B).hom.app P` by `rfl`, applies
    `Adjunction.homEquiv_leftAdjointUniq_hom_app`, rewrites via `comp_unit_app`, and closes by
    `rfl`.  The claim in iteration-264 prover notes (and memory entry ts264-d3-tail-recovery-brick)
    that this is the "P-general recovery brick, axiom-clean" is confirmed.
  - **`sheafificationCompPullback_comp_tail`** (L2514–2578): 1 `sorry` at L2578. The proof
    executes the documented structural setup (`rw [restrictScalarsId_map]`,
    `conv_rhs => rw [Functor.map_comp]`) and then stops.  The sorry is honest — the comment
    (L2537–2577) names the remaining route precisely (R1/R5 recovery via
    `leftAdjointUniqUnitEta_app` + `hinner`/`hcomp'` chain).  This is not dead-end: the
    structural steps are correct and the remaining work is well-scoped.
  - **`sheafificationCompPullback_comp`** (L2591–2688): no inline `sorry`; it closes by calling
    `sheafificationCompPullback_comp_tail h f P` (L2688), so the sorry propagates transitively.
    This is transparent: the file docstring lists this sub-lemma as one of the three remaining
    residuals.
  - **`pullbackTensorMap_restrict`** (L2711–2806): `sorry` at L2806 after structural unfolding
    (`simp only [pullbackTensorMap, tensorObjIsoOfIso]` + three `rw [Functor.map_comp]` +
    `simp only [Category.assoc]`).  The comment (L2783–2802) is accurate about what the sorry
    replaces (the four-square paste: Sq1 waits on `sheafificationCompPullback_comp`, Sq4 is
    unbuilt).  Not dead-end.
  - **`exists_tensorObj_inverse`** (L698–720): lone `sorry`, long-standing honest residual.
    Comment describes the two remaining bridges (C and A) correctly.
  - **STALE COMMENT (major)** at L44: the file header says *"There are now THREE tracked typed-
    `sorry` residuals (iter-262)"*.  The iteration reference is stale (now iter-264).  More
    importantly, the description of residual (b) names `sheafificationCompPullback_comp` as
    the sorry-holder, but the sorry now lives in the extracted helper
    `sheafificationCompPullback_comp_tail`; `sheafificationCompPullback_comp` itself only has a
    transitively-sorry body.  The count of three is still accurate but the location description
    is stale and potentially misleading for a reader checking per-declaration sorry status.
  - **STALE COMMENT (minor)** at L44: "iter-262" should be "iter-264" for the current-state claim.
  - Minor bad practice (L1745, L1787, L1946, L1983, L2046): multiple `set_option maxHeartbeats`
    bumps (1600000–3200000).  Each is accompanied by an explanatory comment about which tactics
    trigger the heartbeat cost.  Legitimate workarounds but worth flagging as performance debt.
  - Minor bad practice (L731, L1708, L2171, L2186, L2205, L2222):
    `set_option backward.isDefEq.respectTransparency false in` is a non-default transparency mode.
    Each occurrence is scoped to a single declaration (via `in`) and carries a comment.  A reader
    should be aware that removing these might break proofs silently if defeq behaviour changes.
  - Minor bad practice: several `erw` steps in `pullbackEtaUnitSquare` (L1797–1889),
    `pullbackTensorMap_natural` (L2046–2159), and `sheafificationCompPullback_comp` (L2591–2688)
    are used where defeq-but-not-syntactic composites (`Functor.obj` vs computed carrier,
    `Sheaf.val`/`.obj`) block plain `rw`.  Each `erw` is documented.  Some could potentially be
    replaced by `show … from` casts + `rw` at the cost of verbosity.  Not a correctness risk.
  - **`leftAdjointUniqUnitEta`** (L1623–1658, the `P := 𝟙_` specialisation): also genuinely
    proved, no sorry.  Correctly stated in the docstring of `leftAdjointUniqUnitEta_app` as
    the prior `𝟙_` case of which the new lemma is the general form.
  - **D2′ chain** (`pullbackEtaUnitSquare` → `pullbackTensorMap_unit_isIso`): no sorry anywhere
    in this chain.  D2′ is correctly claimed CLOSED.
  - **D1′** (`pullbackTensorMap_natural`): no sorry.  Correctly claimed CLOSED.
  - All `private lemma` declarations (`pushforward_μ_eq`, `pullbackComp_δ`, etc.) are either
    genuinely proved or genuinely sorry-ed; none uses a trivial body to hide content.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 2 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: none
- **notes**:
  - **`sliceDualTransport.map_smul'`** (L373–405): **genuinely proved**, no `sorry`.
    The proof opens with `PresheafOfModules.hom_ext` + `intro W`, reshapes the goal with
    `change`/`erw [PresheafOfModules.comp_app]`, descends to `LinearMap.ext`, applies `simp
    only` to expose the sectionwise crux, reduces the RHS value via
    `conv_rhs => arg 2; change …` (projection-tolerant value reduction), proves
    `dualUnitRingSwap.hom`-linearity via
    `(congrArg … (?_ : _ = _)).trans ((dualUnitRingSwap …).hom.map_smul _ _)`,
    and closes the scalar identity by `congr 1` + `simp only [termRingMap, …]` +
    `exact (ConcreteCategory.congr_hom (Scheme.Hom.appIso_inv_naturality f …) m).symm`.
    All goals are closed; this matches the memory entry ts264-dual-mapsmul-closed.
  - **`sliceDualTransport.map_add'`** (L343–351): also genuinely proved (iter-263, no sorry).
  - **`sliceDualTransport`** (L219–415): 4 genuine `sorry`s at the expected positions:
    - L337: naturality of the `toFun` family in `W` (thin-poset coherence; blocked on
      ε-naturality of `restrictScalars` along the structure ring iso — honest residual).
    - L410: `invFun` (reverse reindexing with `(f.appIso W').hom`; full `PresheafOfModules.Hom`
      build over the X-slice `Over fV` — honest residual).
    - L413: `left_inv` (blocked on `invFun`).
    - L415: `right_inv` (blocked on `invFun`).
    None of these sorries hide closed content or relocate content from elsewhere.
  - **`dual_restrict_iso`** (L514–546): 1 `sorry` at L546 (`intro V W g; sorry` — the `isoMk`
    naturality square).  This cannot be discharged until `sliceDualTransport`'s naturality
    sorry (L337) is closed.  The sorry is correctly placed and not a relocation.
  - **`dual_isLocallyTrivial`** (L622–631): no inline `sorry`; it closes via
    `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`,
    inheriting the `dual_restrict_iso` sorry transitively.  This is documented ("TRANSITIVELY
    PARTIAL") in the file header.
  - **`homOfLocalCompat`** (L803–972): no `sorry` anywhere.  The proof is complete and
    axiom-clean.  The claim "CLOSED (iter-256), axiom-clean" is confirmed.
  - **STALE COMMENT (minor)** at L15: "PARTIAL (held iter-258)" for `dual_restrict_iso` —
    the iteration reference is stale (now iter-264, with significant progress in between).
    The content description still matches the code.
  - **STALE COMMENT (minor)** at L466: "STATUS NOTE (iter-260; the shared root IS now green…)"
    — stale iteration reference; content is accurate.
  - Minor bad practice: the `conv_rhs => arg 2; change …` idiom at L392 is unusual (it uses
    `arg 2` to navigate inside a `·` bullet application, then `change` to project through the
    `ModuleCat`/`restrictScalars` instance wrapper).  This is documented in the surrounding
    comment (L385–392) and correct, but a future reader may find the `arg 2` fragile.  The
    pattern is also referenced in the memory entry ts264-dual-mapsmul-closed as the
    "projection-tolerant value reduce".

---

## Must-fix-this-iter

None.

---

## Major

- `TensorObjSubstrate.lean:44` — file header says *"there are now THREE tracked typed-`sorry` residuals (iter-262)"*; the iteration number is stale (iter-264) and the location description of residual (b) is inaccurate: the sorry now lives in the extracted helper `sheafificationCompPullback_comp_tail` (L2578), not directly in `sheafificationCompPullback_comp`.  A reader checking per-declaration sorry status from the header will find a misleading description of where the sorry lives.

---

## Minor

- `TensorObjSubstrate.lean:44` — "iter-262" should be "iter-264" for the current-state timestamp.
- `DualInverse.lean:15` — "held iter-258" for `dual_restrict_iso` is stale; should reference the current iteration.
- `DualInverse.lean:466` — "STATUS NOTE (iter-260; …)" — stale iteration reference; harmless.
- `TensorObjSubstrate.lean:1745,1787,1946,1983,2046` — `set_option maxHeartbeats` bumps up to 3200000; performance debt, each documented.
- `TensorObjSubstrate.lean:731,1708,2171,2186,2205,2222` — `set_option backward.isDefEq.respectTransparency false in` usage; non-default transparency mode; each scoped and documented but represents fragility debt.
- `CechHigherDirectImage.lean:175–188` — `eqToHom`-style over-triangle transport in `pushPullMap`; documented as intentional ("No functor law is used"), not a correctness issue.
- `DualInverse.lean:392` — `conv_rhs => arg 2; change …` idiom; fragile position-based navigation; documented.

---

## Excuse-comments (always called out separately)

None. Every `sorry` in all three files is accompanied by an honest description of the missing ingredient or blocking dependency, not by language admitting the code is wrong-but-tolerated.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (stale + inaccurate sorry-location description in TensorObjSubstrate.lean header)
- **minor**: 7
- **excuse-comments**: 0

Overall verdict: All three focus-area claims are confirmed — `pushPullMap_id`, `leftAdjointUniqUnitEta_app`, and `sliceDualTransport.map_smul'` are genuinely proved with no sorry; all remaining sorries are honest documented residuals; one major stale comment in TensorObjSubstrate.lean header mis-describes the location of the Sq1 sorry.
