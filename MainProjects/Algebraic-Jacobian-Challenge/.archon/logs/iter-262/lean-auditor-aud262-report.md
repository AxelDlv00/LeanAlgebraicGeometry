# Lean Audit Report

## Slug
aud262

## Iteration
262

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L720 (`exists_tensorObj_inverse`): `sorry` present and correctly documented — the cross-file
    gate comment accurately identifies the two remaining bridges (C-bridge `dual_restrict_iso`
    and A-bridge descent gluing). No stale language.
  - L2443–2458 (`sheaf_unit_comp_pushforward_pullbackComp_inv`, new this iter): Genuine axiom-clean
    proof via `unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv`; non-vacuous. Body ends
    `exact conj.symm` with no sorry. ✓
  - L2471–2565 (`sheafificationCompPullback_comp`, new this iter — partially proven): The `conv_rhs`
    distribution (L2524–2526) and R0-peel splice (L2539–2553) are applied and described accurately.
    The sorry at L2565 correctly identifies the remaining tail (R1/R5 collapse, the precise analog of
    `pullbackObjUnitToUnit_comp` L969–996) with a detailed and accurate roadmap. Progress is genuine.
  - L2680–2683 (`pullbackTensorMap_restrict`): Three-tactic prefix (`simp only`, `rw`, `simp only`)
    + `sorry` at L2683. The preceding inline comment at L2660–2679 accurately describes the paste-ready
    form and the four remaining squares (Sq1, Sq3, Sq4). No stale language.
  - **Sorry count**: Header (L39–50) claims THREE tracked sorries. Actual code has exactly 3 sorries
    (L720, L2565, L2683). ✓
  - L106–107: Minor historical note ("iter-247 import-cycle fix") in the header, accurate and
    unambiguous. Not stale in a misleading sense.

---

### `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`

- **outdated comments**: 1 flagged (see notes below)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (nested planner strategy in doc comments — see notes)
- **excuse-comments**: none
- **notes**:
  - L177–182 (`isIso_ε_restrictScalars_appIso`, new this iter): Genuine — one-line call to
    `restrictScalars_isIso_ε_of_bijective` fed `bijective_of_isIso`. Axiom-clean. ✓
  - L191–198 (`dualUnitRingSwap`, new this iter): Genuine — constructs the inverse of the
    lax-monoidal unit `ε` via `haveI + CategoryTheory.inv`. Axiom-clean. ✓
  - L293–356 (`sliceDualTransport`, partial): The `toFun` leg (L305–317) is genuinely built via
    the categorical `.map` idiom (leg-A) composed with `dualUnitRingSwap` (leg-B). The
    six typed sorries at L335, 343, 346, 351, 354, 356 are correctly identified with specific
    blockers. No progress is fabricated.
  - **STALE STATUS NOTE (MAJOR)** — `sliceDualTransport` body, ~L280–292: The iter-261
    STATUS NOTE still lists *"codomainMap (leg-B unit ring swap = `inv (ε …)`, blocked on a
    CommRing-instance recovery + a `𝟙_`-vs-`restr`-section defeq bridge)"* as remaining work.
    This claim is **no longer accurate**: iter-262 closed the codomainMap by filling it with
    `dualUnitRingSwap`. The correct iter-262 update at L324–327 does exist nearby, but the
    contradictory iter-261 claim at L289–290 is confusing to future readers and misrepresents
    what is actually blocked.
  - L487 (`dual_restrict_iso`, naturality sorry): One sorry in the own body; comment at L483–484
    accurately explains the dependency on `sliceDualTransport`'s body being concrete. ✓
  - **Sorry count**: Module header (L17–18) says "one sorry remains" for `dual_restrict_iso` (own
    body). Actual code: 1 sorry in `dual_restrict_iso` (L487) + 6 sorries in `sliceDualTransport`
    (L335, 343, 346, 351, 354, 356) = 7 total code sorries. The header's language is accurate when
    read as counting sorries in `dual_restrict_iso`'s own body; the 6 sliceDualTransport sorries
    are called out separately as "typed sorries" at L32–38. Consistent. ✓
  - **BAD PRACTICE (MAJOR)** — `dual_restrict_iso` (~L365–453), `dual_isLocallyTrivial`
    (~L517–561), `homOfLocalCompat` (~L694–743): Large `/- Planner strategy: … -/` blocks are
    **nested inside** the `/-- … -/` doc comment for each declaration. Lean 4 block comments are
    nestable, so this is syntactically valid, but it conflates implementation strategy notes with
    public API documentation. Doc comments are meant for human and IDE consumption; embedding
    multi-paragraph strategy prose inside them makes the declarations' docstrings
    developer-workflow documentation rather than user-facing specs. Should be separate `/-` block
    comments before the `noncomputable def`/`lemma`.
  - `dual_isLocallyTrivial` (L563–572): Body is genuine and correct (`intro x; obtain …; exact
    three-step chain`). Inherits the `dual_restrict_iso` sorry transitively; the comment at L553–554
    accurately flags this. ✓
  - `homOfLocalCompat` (L744–913): No sorry in code body. The comment at L800–805 accurately says
    "no sorry remains." ✓

---

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L89–97 (`CechNerve`): Single `sorry` with an honest explanation ("requires the nerve of the
    cover… currently absent from Mathlib for `Scheme.Modules`"). Not an excuse-comment; it
    accurately identifies the Mathlib gap. ✓
  - L130–131 (`coverArrow`, new this iter): `Arrow.mk (Sigma.desc 𝒰.f)` — genuine one-liner.
    Axiom-clean. Not vacuous. ✓
  - L139–141 (`coverCechNerve`, new this iter): `(coverArrow 𝒰).augmentedCechNerve` — applies
    existing `Arrow.augmentedCechNerve` Mathlib machinery. Genuine. Axiom-clean. ✓
  - L152–156 (`relativeCechComplexOfNerve`, new this iter): Coherence-free plumbing via
    `alternatingCofaceMapComplex`, `CosimplicialObject.whiskering`, and `Augmented.drop`.
    No `pushforwardComp`/`pullbackComp` coherence consumed. Genuine. Axiom-clean. ✓
  - L177–185 (`CechComplex`, rewritten this iter): Body is `relativeCechComplexOfNerve f
    (CechNerve 𝒰 F)`. This is **genuinely defined in terms of the nerve** — not a fresh `sorry`.
    The sorry from `CechNerve` propagates, but the structural linkage is real; closing `CechNerve`
    axiom-clean immediately yields an axiom-clean `CechComplex`. The comment at L184–185 correctly
    states this. ✓
  - L204–214 (`CechAcyclic.affine`): `sorry` with accurate explanation (prime-local contracting
    homotopy, absent from Mathlib for `Scheme.Modules`). ✓
  - L241–251 (`cech_computes_higherDirectImage`): `sorry` with accurate explanation (two spectral
    sequences absent from Mathlib). ✓
  - L269–271 (`cechHigherDirectImage`): `(CechComplex f 𝒰 F).homology i` — genuine unconditional
    definition; its sorry dependency is transitive from `CechNerve`. ✓
  - L301–313 (`cech_flatBaseChange`): `sorry` with accurate explanation (term-wise affine base
    change of the Čech complex, absent from Mathlib). ✓
  - **Sorry count**: Directive claims 4 code sorries (L97, L214, L251, L313). Confirmed. ✓
  - Module docstring at L36–58: Describes "six main declarations"; all six are present and
    correctly described. ✓

---

### `AlgebraicJacobian/Picard/LineBundleCoherence.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Zero code sorries in own code bodies**, confirmed by grep. ✓
  - Status comment at L28 ("iter-258: 1 sorry → 0 locally; redirected to shared root") is accurate:
    0 local sorries; the transitive sorry lives in `SheafOverEquivalence.lean` via the
    `Scheme.Modules.chartOverIso` redirect. The iter label is historical, not stale.
  - `chartOverIso` (L217–220): One-line redirect to `Scheme.Modules.chartOverIso U M e`.
    No local sorry. ✓
  - `IsLocallyTrivial.chartPresentation` (L228–233): `SheafOfModules.Presentation.ofIsIso`
    applied correctly; compiles modulo the transitive `chartOverIso` dependency. ✓
  - `IsLocallyTrivial.isFinitePresentation` (L250–272): Correct assembly — `QuasicoherentData`
    from cover, `shrink` into universe, `IsFinitePresentation.mk`. No sorry. ✓
  - `IsLocallyTrivial.isFiniteType` (L278–281): Correct one-liner via `infer_instance`. ✓
  - `IsLocallyTrivial.chart_free_rank_one` (L293–297): Trivial `exact hM x`. ✓
  - No suspicious patterns identified.

---

## Must-fix-this-iter

None.

---

## Major

- `DualInverse.lean:289–292` — **Stale STATUS NOTE**: The iter-261 "REMAINING" list inside
  `sliceDualTransport`'s body still names *"codomainMap (leg-B unit ring swap… blocked on a
  CommRing-instance recovery + a `𝟙_`-vs-`restr`-section defeq bridge)"* as an open obstacle.
  This is directly contradicted by the iter-262 update at L324–327 which records codomainMap
  as CLOSED. A reader encountering the iter-261 block first will misidentify codomainMap as
  still-blocked; the redundant pair of STATUS NOTES should be reconciled by removing or updating
  the stale iter-261 entry.

- `DualInverse.lean:368,517,694` (approx.) — **Planner strategy blocks nested in docstrings**:
  The declarations `dual_restrict_iso`, `dual_isLocallyTrivial`, and `homOfLocalCompat` each
  embed a multi-paragraph `/- Planner strategy: … -/` block nested inside their `/-- … -/`
  doc comment. This is syntactically valid (Lean 4 supports nested block comments) but is bad
  API documentation practice: IDEs and doc renderers surface the entire blob as the declaration's
  docstring. Strategy/implementation notes belong in separate `/-` block comments placed before
  the declaration, not inside the docstring.

---

## Minor

- `TensorObjSubstrate.lean:106–107` — The header mentions "iter-247 import-cycle fix" as an
  aside. Accurate and harmless, but slightly dated. Could be simplified to "now lives
  downstream in `RelPicFunctor.lean`" without the iteration number.

---

## Excuse-comments (always called out separately)

None found. All `sorry` explanations name a specific Mathlib gap or a specific remaining proof
obligation with a clear route to closure; none admit the code is wrong, placeholder, or
"temporary."

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 — stale STATUS NOTE (DualInverse.lean ~L289–292) + nested planner strategy in
  docstrings (DualInverse.lean, three declarations)
- **minor**: 1 — historical iteration reference in TensorObjSubstrate.lean header
- **excuse-comments**: 0

Overall verdict: All four files are in sound shape for this iteration — sorry counts match their
headers, the three new axiom-clean helpers (`sheaf_unit_comp_pushforward_pullbackComp_inv`,
`isIso_ε_restrictScalars_appIso`, `dualUnitRingSwap`) and the three new Čech infrastructure
declarations (`coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve`) are genuine, and
`CechComplex` is verifiably defined through the nerve (not a fresh sorry). The two major findings
are documentation hygiene issues, not mathematical defects.
