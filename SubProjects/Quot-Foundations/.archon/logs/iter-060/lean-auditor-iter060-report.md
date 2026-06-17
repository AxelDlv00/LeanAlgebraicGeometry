# Lean Audit Report

## Slug
iter060

## Iteration
060

## Scope
- files audited: 2 (per directive)
- files skipped (per directive): all others — directive scoped to two iter-touched files

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L308-310] Stale scaffold NOTE on `glue`** — the `/-! ## Gluing a sheaf of modules
    along a scheme glue datum -/` section comment (lines 299-310) makes two claims that
    are no longer true: (a) lines 304-306 say the construction path uses
    `overRestrictPullbackIso` / `existsUnique_gluing'`, but the actual body (line 444)
    uses `equalizer a b` (equalizer of pushforwards — the descent-equalizer route), and
    (b) the NOTE at lines 308-310 says "the body and the module-cocycle hypotheses on `g`
    are still to be filled" — but the body IS present, C1/C2 are present as parameters
    `_hC1`/`_hC2`, and the construction is closed (axiom-clean). Severity: **major**.
  - **[L1141-1142] "open obstacle" inside a completed proof** — the inline comment at
    lines 1139-1142 inside `functor.map_id` ends with "That coherence between
    `SheafOfModules.pullbackObjFreeIso` and Mathlib's `pullbackId` is the open
    obstacle." But the proof immediately below (lines 1143-1151) resolves this coherence
    via `← Scheme.Modules.pullbackFreeIso_id` and `Iso.inv_hom_id_assoc`, and closes
    with no sorry. Calling a resolved obstacle "open" inside a complete proof is stale.
    Severity: **major**.
  - **[L684] `bundleTransition_cocycle` sorry** — honest and clearly documented. The
    comment at lines 655-663 accurately describes the remaining work: matrix-to-module
    transport of the Cramer-inverse cocycle over triple overlaps. Not a laundering issue.
  - **[L704] `universalQuotient` sorry** — honest. NOTE at lines 693-702 correctly
    states the dependency on the bundle cocycle and describes the intended construction.
  - **[L715] `tautologicalQuotient` sorry** — honest. NOTE at lines 710-715 correctly
    documents it rides on `universalQuotient`.
  - **[L1209] `represents` sorry** — honest. NOTE at lines 1198-1209 correctly documents
    it rides on `tautologicalQuotient` (hence on the bundle cocycle).
  - **`bundleTransition_self` (lines 612-641) — proof is genuine.** The
    `set_option maxHeartbeats 1000000` override is absent (confirmed). The proof:
    (1) builds `hφ` by `rw [chartTransition_self, Category.id_comp]`; (2) proves `hB`
    (matrix-iso = `Iso.refl _`) by `Iso.ext; rw [matrixToFreeIso_hom, Iso.refl_hom,
    universalMinorInv_self, map_one, matrixEnd_one]`; (3) closes with
    `simp only [bundleTransition]; erw [hB, Iso.refl_trans]; exact
    pullbackFreeIso_trans_symm_eqToIso hφ (Fin d)`. The `erw` is necessary and
    documented (bridges the `chartOverlap`/`Spec` base-scheme defeq). No laundering.
  - **`pullbackFreeIso_trans_symm_eqToIso` (lines 503-509) — new helper is clean.**
    Statement: `pullbackFreeIso φ I ≪≫ (pullbackFreeIso ψ I).symm = eqToIso (…)` proved
    by `subst h; simp`. The key design point — proved over variable `φ`, `ψ` so the
    kernel never whnfs concrete immersions — is sound.
  - **No `axiom` declarations** — confirmed via grep.
  - **`functor` (lines 1128-1196) — both `map_id` and `map_comp` are complete.** No
    sorry. The term-mode proofs close via `pullbackFreeIso_id` / `pullbackFreeIso_comp`.
    The stale "open obstacle" comment at L1142 is a documentation issue (see above), not
    a code issue.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L668-721] Stale DEFERRED/BLOCKER block comment** — the block comment at lines
    668-721 is headed "### Action / projection natural transformations of the
    coequalizer rows — DEFERRED (handoff)" and contains a detailed BLOCKER note dated
    iter-056. But `relTensorActL` (lines 552-585), `relTensorActR` (lines 587-624), and
    `relTensorProj` (lines 626-666) are ALL fully proved — including naturality — using
    `objRestrict`, which is exactly NEXT-ITER HANDLES option (1) described in the BLOCKER
    note. The heading "DEFERRED" and the BLOCKER description are stale and will mislead
    future agents into thinking this work remains. Severity: **major**.
  - **[L723-805] Superseded handoff notes — explicitly labeled** — the block comment at
    lines 723-805 is headed "(superseded handoff notes — retained for the additional
    `inferInstanceAs` detail)". This is self-labeled as superseded but adds ~80 lines of
    historical noise to the file. Severity: **minor**.
  - **[L716] "opaque at L716" — not a Lean declaration** — the directive asks to verify
    legitimacy of "opaque at L716". Line 716 of this file is inside the block comment
    at lines 668-721 and reads: "(3) Escalate: this is the documented diamond/whnf
    friction (memory `quot-gap1-closed-opaque-immersion`)". The word "opaque" here is a
    reference to a memory slug, not a Lean `opaque` declaration. There is no `opaque`
    declaration anywhere in SectionGradedRing.lean. No issue.
  - **`relTensorProj.naturality` (lines 638-666) — proof is genuine.** The `key`
    ℤ-linear-square (lines 651-661) closes by `apply TensorProduct.ext'; intro m n; rfl`.
    This is sound: on an elementary tensor `m ⊗ₜ n`, both composites definitionally
    produce `(objRestrict P f m) ⊗ₜ[R(V)] (objRestrict Q f n)` because `projL_tmul` and
    `tensorObj_map_tmul` both evaluate to the same term. The `rfl` is not trivially
    suspicious; it relies on the `S = X.sheaf.obj.obj V` vs `R.obj V` carrier being a
    `forget₂`-identity (noted in the comment at lines 646-650). Transport to the
    categorical square uses `LinearMap.congr_fun key z` + `simpa` — standard and clean.
  - **0 sorries** — confirmed via grep. `relTensorActL`, `relTensorActR`, `relTensorProj`
    all have closed bodies. `tensorPowAdd` is left absent (no `sorry`) as per the
    mathlib-build discipline, documented in the handoff at lines 808-922.
  - **`objRestrict` private helper (lines 448-474)** — legitimate; it defines a
    ℤ-linear restriction with syntactic `↥(P.obj U) → ↥(P.obj V)` carriers, exactly the
    fix described as NEXT-ITER option (1) in the now-stale BLOCKER. Clean design.
  - **No `axiom` declarations** — confirmed via grep.
  - **`RelativeTensorCoequalizer` namespace (lines 279-422)** — all previously closed.
    No new changes this iter; still axiom-clean.
  - **`tensorPowAdd` DEFERRED comment (lines 807-922)** — accurately describes the single
    missing ingredient (strong-monoidality of module sheafification) and the current
    state of the launching pad. Not stale.

---

## Must-fix-this-iter

None. All issues are stale documentation; the Lean code itself is correct (no wrong
definitions, no laundered proofs, no unauthorized axioms, no excuse-comments on
definitions).

---

## Major

- `GrassmannianQuot.lean:299-310` — Section comment for `glue`: (a) describes wrong
  implementation path (`overRestrictPullbackIso`/`existsUnique_gluing'` vs actual
  `equalizer a b`); (b) NOTE says body "still to be filled" when body is complete.
- `GrassmannianQuot.lean:1141-1142` — Inline comment in `functor.map_id` calls
  `pullbackFreeIso`/`pullbackId` coherence "the open obstacle" inside a proof that
  resolves it via `pullbackFreeIso_id`.
- `SectionGradedRing.lean:668-721` — Block comment headed "DEFERRED (handoff)"
  + BLOCKER note from iter-056; all three naturality proofs (`relTensorActL`,
  `relTensorActR`, `relTensorProj`) are now complete.

---

## Minor

- `SectionGradedRing.lean:723-805` — "(superseded handoff notes — retained for the
  additional `inferInstanceAs` detail)": self-labeled but still ~80 lines of stale
  historical noise.

---

## Excuse-comments (always called out separately)

None. The `sorry` declarations in GrassmannianQuot.lean carry honest NOTE comments
documenting remaining work; none use "wrong but works", "temporary", or "will fix
later" language on actual definitions. The stale comments are documentation failures,
not self-admitted lies about correctness.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: both files are code-correct — 4 honestly-documented sorries remain in
GrassmannianQuot.lean (all in the GL_d cocycle / universal-quotient chain), 0 in
SectionGradedRing.lean; `bundleTransition_self` and `relTensorProj.naturality` are
genuine proofs with no laundering — but three major stale comments (one in each file)
incorrectly represent completed work as open/deferred and should be pruned.
