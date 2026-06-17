# Lean Audit Report

## Slug
iter258

## Iteration
258

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`
- **outdated comments**: 1 flagged (minor — module docstring slightly overclaims)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L22** — Module docstring says `chartOverIso` "closes the outstanding sorry in
    `AlgebraicJacobian/Picard/LineBundleCoherence.lean`". More precisely it *relocates*
    the sorry: `LineBundleCoherence.lean` is locally sorry-free, but `chartOverIso` here is
    transitively sorry via `restrictOverIso` and `unitOverIso`. The phrasing could be read as
    claiming the full chain is closed. Severity: minor.
  - **L104-118 (`overEquivInverseIsContinuous` / `overEquivFunctorIsContinuous`)** — The
    `change`-to-subtype pattern (`change … ↥U …; infer_instance`) is correct and
    well-commented (L92-102 explains the discrimination-tree mismatch). No sorry. ✓
  - **L137-147 (`phiOver`)** — Naturality proof uses `erw [← Functor.map_comp, ← Functor.map_comp]; congr 1`. On the thin poset `Opens`, `congr 1` correctly discharges the residual by proof irrelevance. No sorry. ✓
  - **L160-176 (`psiOver`)** — Naturality closes via the `Subsingleton.elim` term pattern
    `(Functor.map_comp _ _ _).symm.trans ((congrArg _ (Subsingleton.elim _ _)).trans (Functor.map_comp _ _ _))`. Consistent with the project's established idiom. No sorry. ✓
  - **L178-206 (`overEquivalence`)** — H₁ and H₂ discharged by `simp`/`rw`/`change`/`congr` with a final `Subsingleton.elim`. No hidden sorry. ✓
  - **L233-235 (`restrictOverIso`)** — Body is `exact sorry`. Honest open stub; the preceding
    planner block (L210-232) describes the proof route. No inline "OPEN SORRY" annotation at
    the sorry line itself, but the context is clear. Severity: minor.
  - **L249-277 (`unitOverIso`)** — Contains one `sorry` at L276, inside the `haveI` block
    for `IsIso (SheafOfModules.unitToPushforwardObjUnit (phiOver U))`. The comment at L251-275
    honestly describes what remains ("The remaining leaf is exactly `IsIso` of (the additive
    map underlying) that sectionwise ring isomorphism"). Honest typed stub. ✓
  - **L258-265 (`hφ` sub-proof)** — `IsIso (phiOver U)` is proved via
    `NatTrans.isIso_iff_isIso_app` reducing to `IsIso (X.ringCatSheaf.obj.map (eqToHom …))`,
    discharged by `inferInstanceAs` on an `eqToHom`-image. Then reflected through
    `isIso_of_reflects_iso`. Sound. ✓
  - **L299-302 (`chartOverIso`)** — Defined as `(restrictOverIso U M).symm ≪≫ (overEquivalence U).functor.mapIso e ≪≫ unitOverIso U`. Sorry-transitive (inherits both open
    stubs), as correctly noted at L285-298. Planner's "Next iter" note is accurate. ✓
  - **Dead `chartPresentationOLD` check** — No `*OLD*` declaration present in this file. ✓

---

### `AlgebraicJacobian/Picard/LineBundleCoherence.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L7** — Import redirect `import AlgebraicJacobian.Picard.SheafOverEquivalence` in
    place. ✓
  - **L28-104 (status block)** — Claims "locally `sorry`-free" and "Once those three close,
    this engine becomes fully axiom-clean." Both statements are accurate: there is no `sorry`
    in this file; all declarations are sorry-transitive via the shared root. ✓
  - **L217-220 (`chartOverIso` redirect)** — `Scheme.Modules.chartOverIso U M e`; no local
    `sorry`. Body and docstring are consistent. ✓
  - **L228-233 (`IsLocallyTrivial.chartPresentation`)** — Uses `SheafOfModules.Presentation.ofIsIso`. Sorry-transitive. No local sorry. ✓
  - **L235-239 (`IsFinite` instance for `chartPresentation`)** — `dsimp only [IsLocallyTrivial.chartPresentation]; infer_instance`. Clean. ✓
  - **L250-272 (`isFinitePresentation`)** — No local sorry; the `q.shrink` universe reduction
    and `IsFinitePresentation.mk` call look correct. ✓
  - **L278-282 (`isFiniteType`)** — `haveI := hM.isFinitePresentation; infer_instance`. Clean. ✓
  - **L293-297 (`chart_free_rank_one`)** — `exact hM x`. Axiom-clean. ✓
  - **L130-141 (`exists_trivializing_cover`)** — No sorry; the cover is built by `X` as
    index and `(hM x).choose`. ✓
  - **`freeUnitIso` / `unitPresentation` / `IsFinite` instance (L156-190)** — All
    axiom-clean. ✓
  - **Dead `chartPresentationOLD` check** — No `*OLD*` declaration present. ✓

---

### `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- **outdated comments**: 1 flagged (major — stale advice in `dual_restrict_iso` outer strategy)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L184-235 (`sliceDualTransport` sorry at L235)** — Honest typed stub. The STATUS note
    at L222-234 correctly says the lane is HELD pending `overEquivalence`, that an empirical
    probe confirms `refine LinearEquiv.toModuleIso ?_` reduces the goal cleanly, and that the
    closing move is a one-liner consumer of `overEquivalence`. The "broken dependency" note
    from a prior iter is explicitly retired. ✓
  - **L341-348 (`dual_restrict_iso` Step-4, sorry at L348)** — The `isoMk` naturality square
    sorry is explicitly tied to `sliceDualTransport`'s unfinished body ("its `.hom` is
    currently a `sorry`, so the square cannot be discharged yet"). Honest. ✓
  - **L287-315 (`dual_restrict_iso` outer planner strategy — "WARM-CONTEXT WARNING")** —
    **STALE ADVICE.** The warning was written before the iter-258 pivot. Its factual claim
    ("NOT covered by `overSliceSheafEquiv`") remains accurate, but the advice section is
    superseded:
      - "this is a genuine new build, not a missing import" — the iter-258 plan explicitly
        says the closing move is a *one-liner consumer* of the existing `overEquivalence`
        construct, so "genuine new build" is no longer accurate.
      - "If the sectionwise ring-iso build resists, consult: (i) the iter-230 C-wiring
        diagnostic in TensorObjSubstrate.lean (~L613–656)" — the iter-230 diagnostic concerns
        the `overSliceSheafEquiv` approach, which has been superseded. A prover reading only
        this outer strategy would follow the wrong path.
    The file header (L24-35) correctly documents the new approach, but the outer strategy
    of `dual_restrict_iso` was not updated to reflect the iter-258 pivot. Severity: **major**.
  - **L39-41 (`dual_isLocallyTrivial` status — "TRANSITIVELY PARTIAL")** — Accurate; the
    code at L424-433 assembles the chain and compiles, inheriting the `dual_restrict_iso`
    sorry. ✓
  - **L605-774 (`homOfLocalCompat`)** — No `sorry` in the entire proof body; the inline
    "CLOSED (iter-256), axiom-clean" note at L658-665 is accurate. All sub-steps (connection
    lemma, scalar bridge `hbridge`, native linearity `hfl_native`, `congr 1` reconcile) are
    in place. ✓
  - **`presheafDualUnitIso` / `dual_unit_iso` (L355-371)** — Both axiom-clean one-liners. ✓
  - **`dualUnitIsoGen` / `unitDualSectionEquiv` (L79-156)** — Long but genuine proofs;
    `left_inv` uses `PresheafOfModules.naturality_apply` and `unit_map_one`; `right_inv`
    uses `globalSMul_hom_apply` + `termRingMap_terminal`. No sorry. ✓
  - **`homLocalSection` (L447-495)** — Naturality closes via `Subsingleton.elim`; the `rw`/
    `erw` chain for M-side and N-side legs is standard thin-poset reasoning. ✓

---

## Must-fix-this-iter

None.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:287–315` — Stale advice
  inside the `dual_restrict_iso` planner strategy ("WARM-CONTEXT WARNING"). The claim "this
  is a genuine new build, not a missing import" and the recommendation to consult "the
  iter-230 C-wiring diagnostic in TensorObjSubstrate.lean" are both superseded by the
  iter-258 pivot (the closing move is now a one-liner consumer of `overEquivalence`). A
  future prover reading only the outer `dual_restrict_iso` strategy (without reading
  `sliceDualTransport`'s body) would follow the wrong path.

---

## Minor

- `AlgebraicJacobian/Picard/SheafOverEquivalence.lean:22` — Module docstring says
  `chartOverIso` "closes the outstanding sorry in `LineBundleCoherence.lean`". More
  precisely it relocates the sorry to the shared root; the full chain is still
  sorry-transitive. Could be read as overclaiming.
- `AlgebraicJacobian/Picard/SheafOverEquivalence.lean:233–235` — `restrictOverIso` body
  is bare `exact sorry` with no inline stub annotation. The preceding planner block explains
  the route; an explicit `-- OPEN: see planner block above` at the sorry site would improve
  navigability.

---

## Excuse-comments (always called out separately)

None found. All `sorry` stubs are accompanied by honest rationales; none use "placeholder",
"will fix later", "temporary", or structurally-wrong bodies.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: Three files are structurally clean; `SheafOverEquivalence.lean` has 2
honest open stubs (`restrictOverIso` L235, `unitOverIso` L276) with genuine planner rationales;
`DualInverse.lean` has 2 honest open stubs with correct HELD/STATUS context; the single
actionable finding is the stale "WARM-CONTEXT WARNING" advice in `dual_restrict_iso`'s outer
planner strategy, which should be updated to reference the new `overEquivalence` consumer
path.
