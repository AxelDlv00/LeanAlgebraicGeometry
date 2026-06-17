# Lean Audit Report

## Slug
iter015

## Iteration
015

## Scope
- files audited: 6
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
  - Root import file; 5 imports, no declarations. Clean.

---

### AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single declaration `higherDirectImage` (L47): clean noncomputable `def` via
    `Functor.rightDerived`. Signature and body consistent with the stated purpose.
    No issues.

---

### AlgebraicJacobian/Cohomology/AcyclicResolution.lean
- **outdated comments**: **1 flagged**
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations from `quasiIso_τ₂` through `rightDerivedIsoOfAcyclicResolution`
    are proved axiom-clean with no `sorry`. The proof strategies (homology four-lemma,
    twisted biproduct, horseshoe recursion, staircase induction) are mathematically sound
    and match the blueprint structure.
  - **L924–963 — stale status block (major).** The block opens with
    `### Status (iter-006): … TARGET 3 (the acyclic-resolution staircase) remains.`
    and ends with `REMAINING (TARGET 3): CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`.
    However, `rightDerivedIsoOfAcyclicResolution` is *fully proved* at L893–923 (complete
    inductive staircase, no `sorry`). The status note was written in iter-006 when TARGET 3
    was open; it is now stale and claims work is outstanding that the file has since closed.
  - All helper lemmas and infrastructure declarations (`twistedBiprod*`, `horseshoe*`,
    `cosyzygy*`, `cohomologyAppliedResolutionIso`, `gHomologyZeroIso`) are complete and
    well-structured. No suspect bodies.

---

### AlgebraicJacobian/Cohomology/CechAcyclic.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`CechAcyclic.affine` (L74–93) — known tracked sorry.** The `sorry` at L93 is
    the known P3 open gap (L1 categorical bridge between `CechComplex` and the concrete
    module complex `∏_σ M_{s_σ}`).
  - **Judgment on the L79–92 comment block** (per directive focus area): this is an
    **honest scope note**, not an excuse-comment. It accurately reports what is done
    (L3 axiom-clean in `CombinatorialCech`), what is missing (L1 categorical
    identification), the precise name of the Mathlib entry-point (L2 via
    `exact_of_isLocalized_span`), and a pointer to where the gap is tracked
    (`task_results`). There is no "temporary / will fix later" language; the sorry is
    correctly classified as blocked on a real technical gap.
  - **`CombinatorialCech` namespace (L119–241) — 9 new private declarations, all
    axiom-clean.** Analysis of each:
    - `combDifferential` (L127): correct alternating coface differential.
    - `combHomotopy` (L133): correct contraction by `Fin.cons r`.
    - `combHomotopy_zero` (L136): trivially `simp`-proved. The explicit `(M := M) (n := n)`
      ascriptions are unnecessary (Lean can infer these), but harmless (minor).
    - `cons_comp_succAbove_succ` (L142): combinatorial bookkeeping identity, proved correctly.
    - `combHomotopy_spec` (L155): key homotopy identity `d ∘ h + h ∘ d = id`, proved via
      `Fin.sum_univ_succ` and `Finset.sum_eq_zero`. Argument is correct.
    - `combDifferential_eq_of_cocycle` (L172): clean consequence of `combHomotopy_spec`.
    - `combSign_flip` (L180): sign calculation for `d² = 0` via case split on castSucc
      ordering. Mathematically correct.
    - `combDifferential_comp` (L200): `d² = 0` by sign-reversing involution
      `(j, i) ↦ (j.succAbove i, i.predAbove j)` via `Finset.sum_involution`. The four
      side conditions (arg identity, non-fixed-point, involution, membership) all
      correctly discharged. Mathematically sound.
    - `combDifferential_exact` (L231): the `Function.Exact` form consumed by
      `exact_of_isLocalized_span` (planner L2). Correctly combines
      `combDifferential_comp` (`im ⊆ ker`) and `combDifferential_eq_of_cocycle`
      (`ker ⊆ im`).
  - All 9 declarations are `private` (appropriate: intended solely to close
    `CechAcyclic.affine` in this file). They are proved and ready; the only reason
    they are not yet consumed is the outstanding L1 sorry.

---

### AlgebraicJacobian/Cohomology/PresheafCech.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none (one minor code smell flagged below)
- **excuse-comments**: none
- **notes**:
  - The L32–195 planning block is a forward-looking design strategy, not an
    excuse-comment; it documents intended future declarations and methodological
    decisions. Not stale (the declarations it describes are simply not yet built —
    no false claims of existence).
  - **`injective_toPresheafOfModules` (L215–224) — new declaration, sound.**
    Applies `Injective.injective_of_adjoint` to `PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)`. The left adjoint (sheafification) preserves monomorphisms
    (standard: sheafification is a localization and hence left-exact), so the right adjoint
    (`toPresheafOfModules`) carries injectives to injectives. Mathematically correct.
    - L221–222: `haveI : Injective (C := SheafOfModules X.ringCatSheaf) I := ‹Injective I›`
      — this re-annotates the category to guide typeclass search. `X.Modules` is defined
      as `SheafOfModules X.ringCatSheaf`, so these are the same type; the annotation is a
      typeclass-unification workaround. Minor code smell (inference should find the right
      `Injective` instance without the annotation; if it doesn't, that suggests a mismatch
      in how `X.Modules` and `SheafOfModules X.ringCatSheaf` are represented at the
      instance level). Not wrong.
  - **`freeYonedaHomEquiv` (L244–248) — new declaration, sound.**
    Composed from `PresheafOfModules.freeHomEquiv` and `yonedaEquiv`. The type is
    correct: `Hom(free(yoneda V), F) ≃ (F.presheaf ⋙ forget Ab)(V)`. The one-line body
    is the canonical composition of these two standard equivalences. Clean.

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- **outdated comments**: **2 flagged** (major)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: **2 flagged** (elevated heartbeat options)
- **excuse-comments**: none
- **notes**:
  - **`cech_computes_higherDirectImage` (L771–778)**: the frozen/protected `sorry` per
    directive. Acknowledged; no re-belabour.
  - All other declarations are proved axiom-clean, including:
    - `coverArrow`, `coverCechNerve`, `coverCechNerveOver`, `coverCechNerveOverAug`:
      correct geometric backbone using `Arrow.augmentedCechNerve` and `Over.lift`.
    - `pushPullObj`, `pushPullMap`: correct pre-coherence bricks; bodies well-formed.
    - `pushPullMap_id` (L188–243): proved axiom-clean via `unit_conjugateEquiv`,
      `pseudofunctor_right_unitality`, and sectionwise `hom_ext`. Proof strategy matches
      the documentation.
    - `pushPull_unit_mate`, `pushPull_transport_cancel`, `pushPull_unit_comp`,
      `pushforwardComp_hom_app_id`: all proved axiom-clean; bricks are correct.
    - `rawPushPullMap`, `rawPushPullMap_self`, `rawPushPullMap_self_gen`: all proved; the
      `subst`+`simp`/`rfl` strategy matches the documented kernel-cheap approach.
    - `pushPull_pentagon` (L491–531): proved using `pseudofunctor_associativity` and iso
      cancellation. The `congrArg`/`trans` approach avoids the fragile `rw [HF]` matching.
    - **`rawPushPullMap_comp` (L536–619) and `pushPullMap_comp` (L627–630): BOTH PROVED
      axiom-clean.** `rawPushPullMap_comp` uses `subst wg wh` (kernel-cheap), then
      `pushPull_unit_comp`, `pushPull_pentagon`, and naturality; `pushPullMap_comp`
      reduces to it via `pushPullMap_eq_raw`. The composition law is **closed**.
    - `pushPullFunctor` (L640–644): correctly assembled from the id/comp laws.
    - `CechNerve` (L699–701): constructed (not a hole) via
      `CosimplicialObject.Augmented.whiskeringObj`.
    - `relativeCechComplexOfNerve`, `CechComplex`: clean coherence-free plumbing, correct.

  - **L245–260 — stale planning comment (major).**
    The comment opens `/- **Composition law of the push–pull functor G (contravariant) —
    remaining.** … is left for a focused follow-up pass; assembling pushPullFunctor needs
    it together with pushPullMap_id.` This was written when `pushPullMap_comp` was
    unproved. The proof is now closed at L627–630. The comment actively misrepresents the
    state of the file to any reader or agent.

  - **L410–449 — stale planning comment (major).**
    The comment opens `/- **Composition law pushPullMap_comp — reduced to an explicit clean
    pentagon, not yet closed.** … **Why it is not yet closed (next-prover dead-ends, all
    hit this iter):**…`. Again, `rawPushPullMap_comp` at L536–619 is closed axiom-clean.
    This block documents four failed proof attempts as if the proof were still open.
    Misleading to any automated or human reader.

  - **L404 — `set_option maxHeartbeats 1000000` on `pushPullMap_eq_raw` (minor).**
    The proof body is `rfl`. One million heartbeats for a reflexivity proof is unusual;
    either the elaboration is genuinely expensive (possible for a large `def`) or the limit
    was set defensively during a period of proof exploration. Not wrong, but should be
    reduced once the file stabilises.

  - **L467 — `set_option maxHeartbeats 4000000` on `rawPushPullMap_self_gen` (minor).**
    The proof is `subst w; rw [rawPushPullMap_self]; exact (Category.comp_id _).symm`.
    Four million heartbeats for a `subst`+`rw`+`exact` is very high; may indicate an
    elaboration bottleneck in the `eqToHom` transport or `Functor.map` unification. Worth
    profiling with `lean_profile_proof` in a follow-up pass.

  - L533: `set_option maxHeartbeats 1600000` on `rawPushPullMap_comp` (95-line proof)
    is plausible given the proof length; no flag.

---

## Must-fix-this-iter

None. No excuse-comments, no weakened-wrong definitions, no parallel Mathlib APIs,
no unauthorised axioms. The two known sorries (`CechAcyclic.affine:93`,
`cech_computes_higherDirectImage:778`) are tracked and authorized.

---

## Major

- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean:924–963` — Stale status block
  asserts `TARGET 3 (rightDerivedIsoOfAcyclicResolution) remains`, but the theorem is
  fully proved axiom-clean at L893–923 in the same file. Any automated reader (or plan
  agent) ingesting this comment will conclude there is outstanding work where there is
  none.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:245–260` — Stale planning
  comment labels `pushPullMap_comp` as "remaining" and "left for a focused follow-up
  pass." The proof is closed at L627–630 via `rawPushPullMap_comp`.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:410–449` — Stale planning
  comment labels `pushPullMap_comp` as "not yet closed" and documents "next-prover
  dead-ends." `rawPushPullMap_comp` is closed axiom-clean at L536–619. The dead-end
  documentation for four failed proof attempts is now inaccurate history embedded as
  present-tense commentary.

---

## Minor

- `AlgebraicJacobian/Cohomology/CechAcyclic.lean:138` — `combHomotopy_zero` explicitly
  ascribes `(M := M) (n := n)` in the `simp` attribution; these arguments are inferrable
  and the ascriptions are unnecessary. Cosmetic.

- `AlgebraicJacobian/Cohomology/PresheafCech.lean:221–222` — Category realignment
  `haveI : Injective (C := SheafOfModules X.ringCatSheaf) I := ‹Injective I›`. Correct
  but indicates a typeclass-unification gap between `X.Modules` and
  `SheafOfModules X.ringCatSheaf` at the instance level; worth investigating whether a
  simp-lemma or `@[reducible]` annotation would eliminate the need.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:404` — `set_option
  maxHeartbeats 1000000` on `pushPullMap_eq_raw` (proved by `rfl`). Unexpectedly high;
  should be profiled and lowered.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:467` — `set_option
  maxHeartbeats 4000000` on `rawPushPullMap_self_gen` (`subst`+`rw`+`exact`). Very high;
  should be profiled to confirm necessity or reduced.

---

## Excuse-comments (always called out separately)

None. The `sorry` at `CechAcyclic.lean:93` is documented by an honest scope note
(not an excuse-comment; see per-file analysis). No declaration in the project carries
language of the form "temporary", "will fix later", "placeholder", or "wrong but works."

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The project's Lean code is mathematically sound and axiom-clean
everywhere except the two tracked open sorries; the only issues are three stale
planning comments in `AcyclicResolution.lean` and `CechHigherDirectImage.lean` that
misrepresent already-closed work as outstanding, plus four minor code-quality notes.
