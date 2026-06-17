# Lean Audit Report

## Slug
iter058

## Iteration
058

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L47–53 (MAJOR)**: Module-level docstring says Mathlib "does **not** yet contain the
    polynomial-ring core (generic freeness for a finite module over `A[X₁,…,X_d]`)".
    Both `GenericFreeness.exists_localizationAway_finite_mvPolynomial` (L506) and
    `GenericFreeness.exists_free_localizationAway_polynomial` (L1838) are now **fully proved
    in this file**.  The comment reads as if the gap remains open when it does not.
  - **L1957 (MAJOR)**: Section comment "**Surviving residue** (`sorry` this iter): when `M`
    is finite over the *finite-type* algebra `B` but not module-finite over `A`…" is STALE.
    `genericFlatnessAlgebraic` (L1982–2142) is **fully closed** — the B/𝔭-dévissage branch is
    implemented with no `sorry`.  The phrase "`sorry` this iter" actively misleads any reader
    about what `genericFlatnessAlgebraic` contains.
  - **L21–24 (MINOR)**: Module docstring "Each blueprint-pinned declaration carries…a `sorry`
    body where the proof is not yet supplied" is partially stale; `genericFlatnessAlgebraic`
    no longer has a sorry body.  `genericFlatness` still does, so the comment is not entirely
    wrong, just imprecise.
  - **L3344 (MINOR)**: Comment "NO Mathlib gap remains" appears in the block that describes
    the one surviving `sorry` at L3585.  Technically accurate (the semilinearity goal does
    not need a new Mathlib lemma), but jarring phrasing alongside an open sorry.
  - **L3585 (sorry — load-bearing)**: The `sorry` is the STEP-3 semilinearity subgoal
    `∀ c x, l (c • x) = c • l x` inside `genericFlatness`, after
    `refine flat_of_ringEquiv_semilinear (RingEquiv.refl _) l ?_`.  The goal closes `genericFlatness`
    entirely.  The surrounding recipe comment (L3563–3584) is honest: it documents the
    `Scheme.Modules.map_smul` + `map_appLE`/`appLE_map` route, confirms `l` typechecks, and
    gives a concrete proof sketch.  Not an excuse-comment — the description is accurate and
    the content is genuine.
  - **Four new helpers (L2810–2970) — CLEAN**:
    - `gf_flat_isLocalizedModule_sameBase` (L2810): signature correct; proof via
      `IsLocalizedModule.iso.symm.restrictScalars R` + `Module.Flat.of_linearEquiv` is sound.
    - `flat_of_ringEquiv_semilinear` (L2827): long proof via `IsBaseChange.of_equiv` +
      `Module.Flat.isBaseChange`; algebra is correct, inverse map `jfun` is well-formed.
    - `flat_localization_models` (L2886): uses `IsLocalization.algEquiv` + `IsLocalizedModule.linearEquiv`;
      the semilinearity argument (cancel by a denominator `s ∈ S`, use `mk'_spec`) is correct.
    - `isLocalizedModule_powers_restrictScalars` (L2928): all three fields (`map_units`, `surj`,
      `exists_of_eq`) correctly descend from `powers (algebraMap A B f)` to `powers f` using
      the scalar-tower identity `(f^k : A) • m = (algebraMap A B f)^k • m`.
    - No vacuous hypotheses; no laundering; signatures are honest.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L660–712 (MAJOR)**: Large block titled "Action / projection natural transformations of
    the coequalizer rows — DEFERRED (handoff)" describes `relTensorActL` and `relTensorActR`
    as **BLOCKED** by a carrier/whnf wall, lists "~12 distinct attempts" that all failed, and
    enumerates next-iteration strategies.  But both `relTensorActL` (L552–585) and
    `relTensorActR` (L594–624) are **fully proved** in the file above this block — no `sorry`,
    complete `naturality` proofs using `objRestrict` to resolve the carrier gap.  This block
    is **entirely stale** and actively misleads about the project state: any reader hitting the
    comment after reading the code will find it contradicts the code.  The fix (option 1 in
    the "NEXT-ITER HANDLES" list — a distinct `ℤ`-linear restriction with `↥(P.obj U)`
    carriers) was implemented as `objRestrict` and IS what closed the proofs.
  - **L715–796 (MINOR)**: Block explicitly labeled "(superseded handoff notes — retained for
    the additional `inferInstanceAs` detail)".  A second description of the same carrier-gap
    blocker, from an earlier understanding (before the root cause was isolated).  Lower
    severity because it is flagged as superseded, but it is still noise alongside now-closed code.
  - **L658 (sorry — documented blocker)**: `relTensorProj.naturality` has one `sorry`.  The
    blocker note at L639–657 is accurate and specific: bridging `tensorObj_map_tmul` (stated
    for `ModuleCat.Hom.hom` of the module-presheaf restriction) to the abelian-presheaf apex
    restriction trips instance synthesis on the `CommRingCat`-vs-`RingCat` carrier of
    `projL`'s base ring.  The `app U` component typechecks "only because `ofHom` checks the
    codomain up to defeq without re-synthesising the instance" (L655–656) — an honest
    observation about fragile defeq reliance, documented in place.  Not an excuse-comment.
  - **`relTensorActL` / `relTensorActR` (L552–624) — CLEAN**:
    - Both fully proved.  The `objRestrict` helper (L448–454) — a ℤ-linear restriction with
      syntactic `↥(P.obj U) → ↥(P.obj V)` carriers — correctly resolves the carrier gap that
      blocked earlier iterations.
    - Naturality proofs use `TensorProduct.ext'` + `TensorProduct.induction_on`, with the key
      step `PresheafOfModules.map_smul P f s m` (resp. on `Q`).  The `key` linear-map equality
      is transported to the categorical square by `AddCommGrpCat.hom_ext` + `LinearMap.congr_fun`.
      Sound.
  - **`objRestrict_id` / `objRestrict_comp` (L461–474) — CLEAN**:
    Both proved by `ext x` + `simp` with the appropriate `CategoryTheory.Functor.map_id`,
    `map_comp`, `AddCommGrpCat.hom_id`, `hom_comp` lemmas.  Correct.
  - **`relTensorProj.app` (L636–637)**: Typechecks by defeq of `↥(P.obj U ⊗[CommRingCat-carrier] Q.obj U)`
    vs the abelian-presheaf apex object.  The defeq reliance is documented; the `app` component
    is correct.

---

## Must-fix-this-iter

*None.*  No excuse-comments, no weakened definitions, no project-unauthorized axioms, no `:= True`/`:= rfl` bodies on substantive claims.  The two sorries (`FlatteningStratification.lean:3585` and `SectionGradedRing.lean:658`) are honest and accurately documented.

---

## Major

- `FlatteningStratification.lean:47–53` — Module docstring asserts Mathlib/project "does NOT
  yet contain the polynomial-ring core of generic freeness".  `exists_free_localizationAway_polynomial`
  (L1838) and `exists_localizationAway_finite_mvPolynomial` (L506) are both present and
  axiom-clean in this file.  The comment should be updated to reflect the closed state.
- `FlatteningStratification.lean:1957` — Section comment "**Surviving residue** (`sorry` this
  iter):" attached to a proof (`genericFlatnessAlgebraic`) that now has **no sorry**.  Misleads
  readers about the proof's completeness.
- `SectionGradedRing.lean:660–712` — Entire block titled "DEFERRED" with exhaustive blocker
  description for `relTensorActL`/`relTensorActR` naturality — both proofs are complete in
  the same file, above this block.  The block contradicts the code directly above it and
  should be removed or replaced with a summary of what was done.

---

## Minor

- `FlatteningStratification.lean:21–24` — "Each blueprint-pinned declaration carries…a `sorry`
  body" — partially stale; `genericFlatnessAlgebraic` no longer has a sorry.
- `FlatteningStratification.lean:3344` — "NO Mathlib gap remains" is technically accurate but
  jarring next to a live sorry.  A reader seeing this before reaching L3585 may think the
  proof is closed.
- `SectionGradedRing.lean:715–796` — Explicitly-labeled "superseded" block describing an
  earlier (now-resolved) understanding of the blocker; harmless but noisy.

---

## Excuse-comments (always called out separately)

*None.*  All `sorry` occurrences are accompanied by honest blocker documentation, not by
"temporary wrong definition" / "will fix later" / "works for now" language.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are substantively sound — four new helpers are honest and correct,
`relTensorActL`/`relTensorActR` are genuinely proved, and the two remaining sorries are
honestly documented — but three stale comments (one in each file plus the module-level docstring
in FlatteningStratification) significantly misrepresent project state and should be cleaned up.
