# Lean Audit Report

## Slug
iter009

## Iteration
009

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three-line top-level import module; no declarations. Clean.

---

### `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `AlgebraicGeometry.higherDirectImage` (line 47): definition is `((pushforward f).rightDerived i).obj F`. Standard Mathlib, correct.
  - Docstring accurately reflects the file contents.

---

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- **outdated comments**: 4 flagged (lines 71–96, 161–183, 245–293, 410–449)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (excessive `maxHeartbeats` overrides)
- **excuse-comments**: none
- **notes**:
  - **Line 71–96** (section doc `## Project-local Mathlib supplement — scheme-level Čech nerve backbone`): Asserts "The push-pull functor is the remaining gap" and "CechNerve itself is left as the single genuine hole." Both are now false: `pushPullMap_comp` is proved (line 627), `pushPullFunctor` is assembled (line 640), and `CechNerve` is fully constructed (line 698). Outdated; misleads future readers about project state.
  - **Line 161–183** (paragraph within `pushPullMap_id`/`pushPullMap_comp` section doc): Ends "see the comment above its (currently unfilled) statement." The composition law `pushPullMap_comp` is filled (line 627). Stale.
  - **Line 245–293** (titled "Composition law of the push–pull functor `G` (contravariant) — remaining."): Explicitly states the composition law is "left for a focused follow-up pass." The proof `rawPushPullMap_comp` + `pushPullMap_comp` appear immediately below (lines 533–630). Outdated.
  - **Line 410–449** (block starting "Composition law `pushPullMap_comp` — reduced to an explicit clean pentagon, not yet closed."): Sub-block titled "Why it is not yet closed (next-prover dead-ends, all hit this iter)" lists specific dead-ends. Immediately following this comment, the composition law IS closed (`rawPushPullMap_comp` line 533–619, `pushPullMap_comp` line 627–630). The "not yet closed" assertion is false. This is the most misleading comment block in the file.
  - **Line 404**: `set_option maxHeartbeats 1000000` on `pushPullMap_eq_raw` which is proved by `rfl`. One million heartbeats for definitional equality suggests a compilation-time performance problem; worth investigating but does not affect correctness.
  - **Line 467**: `set_option maxHeartbeats 4000000` on `rawPushPullMap_self_gen`, a proof that reduces to `subst w; rw [...]; exact (Category.comp_id _).symm`. Four million heartbeats is exceptional for a `subst`-based proof; again a performance red flag.
  - **Line 774**: `sorry` in `CechAcyclic.affine` — see Must-fix section.
  - **Line 811**: `sorry` in `cech_computes_higherDirectImage` — see Must-fix section.
  - Module-doc line 36 says "The six main declarations are:" but lists only four. Minor inaccuracy.
  - All other declarations (lines 102–746, 762–773, 800–812): Signatures and proof structures are sound. The push-pull machinery (`pushPullMap_id`, `pushPull_unit_mate`, `pushPull_transport_cancel`, `pushPull_unit_comp`, `rawPushPullMap_comp`, `pushPull_pentagon`, etc.) is axiom-clean, no `sorry`, no abuse of `Classical.choice`. The `CochainComplex`, `CosimplicialObject`, and `pushPullFunctor` assembly is mathematically standard.

---

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **outdated comments**: 2 flagged (module-doc lines 8–36; status block lines 924–963)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 8–36** (module-doc "Declarations" section): Uses phrasing "will be constructed by the prover in `mathlib-build` mode" for `InjectiveResolution.ofShortExact`, `rightDerivedShiftIsoOfAcyclic`, and `rightDerivedIsoOfAcyclicResolution`. All three are now defined and proved in this very file (lines 643, 661, 893). Additionally, the new declaration `Functor.rightDerivedOneIsoCokerOfAcyclic` (line 689) — a substantial new lemma bridging the horseshoe bottom to the cokernel description — is absent from the listed declarations. The module-doc does not reflect the current state of the file.
  - **Lines 924–963** ("Status (iter-006)" block): This block asserts:
    - "TARGET 3 (the acyclic-resolution staircase) remains." — FALSE. `rightDerivedIsoOfAcyclicResolution` is proven at lines 893–922.
    - "REMAINING (TARGET 3): `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`" — FALSE.
    - "(a) Part-2 base case of the dimension shift: `(R¹ G)(A) ≅ coker(G(J) → G(Z))`. The current `rightDerivedShiftIsoOfSplitResolutionSES` only delivers the `δIso` for `k ≥ 1`; the `δ⁰`-epi/coker identification … is separate homological work." — FALSE. This is exactly `rightDerivedOneIsoCokerOfAcyclic` (line 689), which is now proven.
    - "(b) Cosyzygy SES infrastructure" — FALSE. This is the `Cosyzygy` section (lines 739–873), fully proved.
    The whole block is a lie about the current state of the file. This is the most critical outdated comment: it is a "Status" block whose every "remaining" claim refers to work that IS present and sorry-free above it.
  - **New declaration `rightDerivedOneIsoCokerOfAcyclic` (lines 689–725)**: The signature `(G.rightDerived 1).obj ses.X₁ ≅ cokernel (G.map ses.g)` for a SES `0 → A → J → Z → 0` with `J` right-`G`-acyclic is mathematically correct (Leray base case). The proof is substantive: it extracts the cokernel from the connecting morphism `δ⁰` using `hSG.epi_δ` (epimorphism of `δ⁰` from vanishing `H¹(G(I_J))`) and then matches domain/codomain via `isoRightDerivedObj` and `rightDerivedZeroIsoSelf`. No `sorry`. The `classical` tactic at line 693 is appropriate to obtain `HasInjectiveResolution` instances. The proof is axiom-clean.
  - **New declaration `rightDerivedIsoOfAcyclicResolution` (lines 893–922)**: The signature `(G.rightDerived n).obj A ≅ H^n(G(K•))` for an acyclic resolution `K•` of `A` is the correct statement of Leray's acyclicity lemma. The proof:
    - Degree 0: `rightDerivedZeroIsoSelf ≫ G.mapIso e ≫ gHomologyZeroIso`. Correct.
    - Degree m+1: staircase `stairGen m 0` reducing `(R^{m+1} G)(A)` to `(R¹ G)(Z^m)`, then `rightDerivedOneIsoCokerOfAcyclic` applied to the `m`-th cosyzygy SES, then `cohomologyAppliedResolutionIso K m`. The index arithmetic is handled by `omega` at `0 + m = m` and `s + 1 + m = s + (m + 1)`. Mathematically sound. No `sorry`. No axiom leakage.
  - All other declarations (`quasiIso_τ₂`, horseshoe infrastructure, `twistedBiprod`, `cosyzygy*`, `gCosyzygyIsoCocycles`, `cohomologyAppliedResolutionIso`, `gHomologyZeroIso`): No `sorry`. Proofs are on-track: `quasiIso_τ₂` uses the homology four-lemma (`composableArrows₅`); horseshoe proofs use standard biproduct and injective lifting lemmas; cosyzygy proofs use `cyclesIsKernel` and `homologyIsCokernel`.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:774` — `sorry` in `CechAcyclic.affine`. This is a load-bearing theorem (the acyclicity input for the Čech-to-cohomology spectral sequence collapse in the main theorem). Why must-fix: sorry on a substantive claim.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:811` — `sorry` in `cech_computes_higherDirectImage`. This is the project's primary theorem and carries a **frozen protected signature** (`archon-protected.yaml`). Why must-fix: sorry on the project's top-level load-bearing claim.

---

## Major

- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean:924-963` — "Status (iter-006)" block comprehensively claims TARGET 3 (`rightDerivedIsoOfAcyclicResolution`) and its two sub-ingredients are "remaining," when all three are present and sorry-free in the same file above the block (lines 689–922). A reader skimming the end of the file concludes the acyclic-resolution theorem is unproved.
- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean:8-36` — Module-doc uses "will be constructed" for three declarations already constructed; does not mention `rightDerivedOneIsoCokerOfAcyclic` (a significant new declaration at line 689).
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:71-96` — Section header asserts "push-pull functor is the remaining gap" and "CechNerve itself is left as the single genuine hole." Both are closed in the same file.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:245-293` — Titled "Composition law … remaining." The composition law is proved immediately below.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:410-449` — Sub-block explicitly titled "not yet closed (next-prover dead-ends)" for `pushPullMap_comp`. Proof follows immediately below at lines 533–630.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:161-183` — Phrase "currently unfilled" about `pushPullMap_comp` within the `pushPullMap_id` section doc; the statement is filled.

---

## Minor

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:404` — `set_option maxHeartbeats 1000000` for `pushPullMap_eq_raw`, proved by bare `rfl`. One million heartbeats for a definitional equality check indicates a fragile compilation profile; may regress under Lean/Mathlib version updates.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:467` — `set_option maxHeartbeats 4000000` for `rawPushPullMap_self_gen` whose proof is `subst w; rw [...]; exact (Category.comp_id _).symm`. Four million heartbeats is exceptional. Same fragility risk.
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:36` — Module-doc says "The six main declarations are:" but lists four.

---

## Excuse-comments (always called out separately)

None. The sorry bodies carry informative "Needs X, currently absent from Mathlib" notes which describe genuine proof obstacles; they are not "TODO: replace with real def" excuse-comments.

---

## Severity summary

- **must-fix-this-iter**: 2 — `sorry` on `CechAcyclic.affine` (line 774) and `cech_computes_higherDirectImage` (line 811); both load-bearing, the latter protected.
- **major**: 6 — five outdated comment/status blocks that actively misrepresent the project's formalization state (four in `CechHigherDirectImage.lean`, two in `AcyclicResolution.lean`).
- **minor**: 3 — two excessive `maxHeartbeats` overrides and one module-doc count inconsistency.
- **excuse-comments**: 0

Overall verdict: The two new declarations (`rightDerivedOneIsoCokerOfAcyclic` and `rightDerivedIsoOfAcyclicResolution`) are mathematically sound, sorry-free, and axiom-clean; the main issues are stale "remaining"/"not yet closed"/"TARGET N remains" comment blocks that now contradict the actual proof state, most critically the `AcyclicResolution.lean` Status (iter-006) block and the `CechHigherDirectImage.lean` lines 410–449 — all should be deleted or updated.
