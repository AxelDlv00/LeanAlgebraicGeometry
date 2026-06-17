# Lean Audit Report

## Slug
aud260

## Iteration
260

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 4 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (both residual `sorry`s are acknowledged and tracked)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L39–134 (header `## Status (current)`)**: Claims "There is now ONE tracked typed-`sorry` residual:
    the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L690, cross-file gated)".  The file
    actually contains **two** `sorry`s: `exists_tensorObj_inverse` at L715 and
    `pullbackTensorMap_restrict` at L2521.  The header count is wrong.  Severity: **major**.
  - **L2332–2363 (inside `pullbackComp_δ` proof body)**: Comment block reads
    "The remaining reduction (verified on paper; the wiring `rw`s are mechanical but fragile…) the
    *only* genuine gap is `pushforwardComp_lax_μ`…" and "The mate-`rw` wiring of the steps above is
    left for the follow-up (each step's Mathlib lemma is named); the reduction itself is complete.
    The LHS step (U) is wired here:".  The proof IS complete (no `sorry`), but the "left for the
    follow-up" phrasing falsely signals unfinished work to a reader.  These are planning notes from
    iter-259 that were never cleaned up after the close.  Severity: **major**.
  - **L44 (header)**: The status block mentions D1′ CLOSED (iter-255) and D2′ CLOSED (iter-250),
    but does not record the iter-261 milestones: `pushforwardComp_lax_μ` CLOSED and
    `pullbackComp_δ` CLOSED.  Severity: **minor** (missing milestone, not incorrect).
  - **L2360–2363 (inside `pullbackComp_δ`)**: "Pinned as `pushforwardComp_lax_μ` above" — the
    "pinned" phrasing was appropriate when `pushforwardComp_lax_μ` was still an open sorry; now
    that it is closed the sentence reads as if a sorry is still active in that role.  Minor
    misleading residue.  Severity: **minor**.
  - **`pushforwardComp_lax_μ` (L2246–2291)**: Proof is honest — `hom_ext` + `tensor_ext` +
    `Functor.LaxMonoidal.comp_μ` + `pushforward_μ_eq` (×2) + sectionwise pure-tensor collapse via
    `forget₂_restrictScalars_μ_hom_tmul` (inner) and `pushforward_map_restrictScalars_μ_app_tmul`
    (outer).  No `sorry`, no `admit`, no `native_decide`.  Final `erw [houter]` closes the goal.
    ✓ CLEAN.
  - **`pullbackComp_δ` (L2307–2426)**: Proof is honest — mate calculus through
    `Adjunction.unit_app_tensor_comp_map_δ`, `hconj`/`hmate`/`htri`, `pushforwardComp_lax_μ`,
    `Functor.LaxMonoidal.μ_natural`, `MonoidalCategory.tensorHom_comp_tensorHom`, closes with
    `exact Category.assoc _ _ _`.  No `sorry`, no laundering.  ✓ GENUINELY CLOSED.
  - **Private helpers for `pushforwardComp_lax_μ`** (`pushforward_μ_eq` at L2213,
    `restrictScalars_μ_app` at L2134, `forget₂_restrictScalars_μ_hom_tmul` at L2152,
    `restrictScalars_μ_app_tmul` at L2168, `pushforward_map_restrictScalars_μ_app_tmul` at L2186):
    All proofs are honest. `pushforward_μ_eq` is `rfl` (correct — `pushforward = pushforward₀ ⋙
    restrictScalars` definitionally, so the composite μ is defeq to the `restrictScalars` μ on the
    `pushforward₀` objects). The remaining helpers use `rw`/`erw` on atomic objects to avoid
    whnf-explosion.  ✓ CLEAN.
  - **`set_option backward.isDefEq.respectTransparency false in`** usages (L1664, L2127, L2142,
    L2161, L2178, L2127): All are scoped to individual declarations (`… in lemma …` syntax) and
    their docstrings explain the justification (whnf-wall on sheafification-laden composites or
    `restrictScalars`-over-CommRingCat instance lookup).  No global option-setting found.  ✓ OK.
  - **`maxHeartbeats` bumps** (L1701: 1600000, L1743: 3200000, L1902: 1600000, L1939: 1600000,
    L2002: 3200000): All are scoped `set_option maxHeartbeats N in` before a single declaration and
    the accompanying comment explains why (sheafification-laden defeq matching, mate-calculus
    telescope).  ✓ OK.
  - **`pullbackTensorMap_restrict` (L2449–2521)**: Ends in a `sorry` at L2521.  The preceding
    comment block (L2459–2519) is an accurate diagnosis of the four-square composition coherence
    that is still needed (Sq1, Sq2b, Sq3, Sq4), including the iter-257 findings.  The sorry is
    acknowledged and justified; the diagnostic comment is not stale.  ✓ OK (sorry explicitly
    tracked).
  - **`exists_tensorObj_inverse` (L715)**: `sorry` present.  Body comment accurately describes the
    two remaining bridges (C and A) and the reason the `sorry` is retained.  ✓ OK.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (residual `sorry`s are honest)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L1–54 (file header)**: The header says `sliceDualTransport` is "**HELD** (iter-258)" and
    `dual_restrict_iso` is "**PARTIAL** (held iter-258)".  Both declarations were partially updated
    in iter-260 (`sliceDualTransport` body now contains the executed `refine LinearEquiv.toModuleIso ?_`
    reduction; `dual_restrict_iso` body contains an iter-260 STATUS NOTE).  The header's iteration
    label is stale by two iterations.  Severity: **major**.
  - **L1–54 (file header), `dual_restrict_iso` entry**: Says "one `sorry` remains at the identified
    Step-4 presheaf residual".  The actual code has **two** directly-typed `sorry` points:
    (1) `sliceDualTransport` at L257 (`LinearEquiv.toModuleIso ?_; sorry`) and (2) the naturality
    square in `dual_restrict_iso` at L388 (`intro V W g; sorry`).  These are logically one residual
    (fixing the ≃ₗ would make the naturality automatic on the thin poset), but the raw `sorry` count
    in the file body is two.  Severity: **minor**.
  - **`sliceDualTransport` (L184–257)**: Body has `refine LinearEquiv.toModuleIso ?_; sorry`.  The
    in-body diagnostic comment (L222–256) is accurate and current for iter-260: it correctly
    identifies route-(1)'s structural insufficiency (that `restrictOverIso`/`unitOverIso` say nothing
    about `dual`/internal-hom, because producing the commutation of `dual` with slice reindexing from
    the shared root would require the `MonoidalClosed (PresheafOfModules R₀)` structure the project
    deliberately avoids), and correctly describes route-(2) (the ~150–250 LOC sectionwise build) as
    the genuine close.  ✓ DIAGNOSIS ACCURATE.
  - **`dual_restrict_iso` (L356–388)**: The planner-strategy comment block (L267–355 inside the
    proof) reflects the iter-260 finding accurately (shared root IS green; route (1) insufficient;
    route (2) is the genuine close).  The proof body executes Steps 1–3 and H1 honestly, then
    assembles via `PresheafOfModules.isoMk` with two typed `sorry`s (the component ≃ₗ from
    `sliceDualTransport` and the naturality square).  ✓ HONEST.
  - **`dual_isLocallyTrivial` (L464–473)**: Proof is complete (`dual_restrict_iso ≪≫ (dualIsoOfIso
    eL).symm ≪≫ dual_unit_iso`); no direct `sorry`.  Transitively inherits the `dual_restrict_iso`
    sorry — accurately stated in the file header.  ✓ OK.
  - **`homOfLocalCompat` (L645–814)**: No `sorry`.  Docstring says "CLOSED (iter-256), axiom-clean"
    which is accurate.  Proof structure is honest: `homLocalSection` + `existsUnique_gluing` +
    `topSectionToHom` + `homMk` + the `hbridge`/`hfl_native` ring-bridge.  ✓ CLEAN.
  - **`set_option backward.isDefEq.respectTransparency false in` at L573**: Scoped to `homOfLocalCompat`;
    justified by the heavy `presheafHom`/sheaf-condition synthesis at the overlap compatibility step.
    ✓ OK.
  - **`dualUnitIsoGen` (L121–155)**: Proof is honest — `PresheafOfModules.isoMk` + `unitDualSectionEquiv`
    with the evaluation-at-`1` naturality.  ✓ CLEAN.

---

## Must-fix-this-iter

None.  No weakened-wrong definitions, no laundering (no `sorry`/`admit`/`native_decide` masquerading
as a proof), no axiom on load-bearing claims beyond the explicitly-tracked sorries, no
excuse-comments that confess the code is wrong.  Both `pushforwardComp_lax_μ` and
`pullbackComp_δ` are genuinely closed.

---

## Major

- `TensorObjSubstrate.lean:39–134` — Header claims "ONE tracked typed-`sorry` residual" but the
  file contains **two** `sorry`s: `exists_tensorObj_inverse` (L715) and `pullbackTensorMap_restrict`
  (L2521).  The count is wrong and will mislead a downstream reader tracking open obligations.

- `TensorObjSubstrate.lean:2332–2363` (inside `pullbackComp_δ` proof) — Planning commentary
  from iter-259 left in place despite the proof now being complete: "the wiring `rw`s are
  mechanical but fragile, and the *only* genuine gap is `pushforwardComp_lax_μ`…  The mate-`rw`
  wiring of the steps above is **left for the follow-up**".  The proof is complete and has no
  `sorry`, so "left for the follow-up" is factually wrong.

- `DualInverse.lean:1–54` — Header states `sliceDualTransport` is "**HELD** (iter-258)" and
  `dual_restrict_iso` is "**PARTIAL** (held iter-258)".  Both were materially updated in iter-260
  (the `refine LinearEquiv.toModuleIso ?_` step was executed; the in-body STATUS NOTE says
  "iter-260").  The header's iteration label is two iterations stale.

---

## Minor

- `TensorObjSubstrate.lean:44` — The header's D1′/D2′ CLOSED milestones are recorded but
  D3′ milestones (`pushforwardComp_lax_μ` CLOSED, `pullbackComp_δ` CLOSED, both iter-261) are
  absent.

- `TensorObjSubstrate.lean:2360–2363` — "Pinned as `pushforwardComp_lax_μ` above" reads as though
  a sorry is still active at `pushforwardComp_lax_μ`; it was correct in iter-259 but is misleading
  now that `pushforwardComp_lax_μ` is closed.

- `DualInverse.lean:1–54 (dual_restrict_iso entry)` — "one `sorry` remains" — the actual body has
  two directly-typed `sorry` sites (component ≃ₗ in `sliceDualTransport` + naturality square in
  `dual_restrict_iso`).  Logically one residual, but the literal sorry count is two.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are proof-honest with no laundering; the three major findings are all stale
documentation (wrong sorry count in one header, an obsolete "left for the follow-up" planning
comment inside a now-closed proof, and a stale iteration label in the other file's header).
