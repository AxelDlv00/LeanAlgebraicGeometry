# Lean Audit Report

## Slug
iter028

## Iteration
028

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechToCohomology.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Line 9–14**: The module header says "L1/L2 chain" but the file now contains L1 through L4
    **plus** the top `cech_eq_cohomology_of_basis` theorem. The header was written when only the
    first two steps existed and was never updated. Minor stale documentation — does not affect
    correctness.
  - **Line 24** (`attribute [local instance] hasExtModules`): lean_verify flags this as a pattern
    of interest (source-scanner match). The accompanying comment honestly explains the reason:
    avoiding slow `HasSmallLocalizedHom` typeclass search. The attribute is file-local and does not
    mask a compilation failure; the same declarations verify clean when the instance is present via
    this route. No issue.
  - **Lines 57, 70, 135, 180**: Four uses of `show` where the linter recommends `change` (the
    tactic changes the goal, not merely annotates it). Linter warnings only; the proofs are correct.
  - **Line 79**: Exceeds the 100-character line-length limit. Single lint warning.
  - **Line 429** (`cech_eq_cohomology_of_basis`): The name implies an equality/isomorphism
    (Čech = cohomology), but the statement and docstring establish only one direction:
    absolute cohomology `Extᵖ(jShriekOU U, F) = 0` given `HasVanishingHigherCech`.
    The docstring is accurate; the identifier name is slightly misleading. See Major block below.

---

## Axiom verification

All public declarations in the file verified against the standard axiom set:

| Declaration | Axioms |
|---|---|
| `cech_eq_cohomology_of_basis` | `propext`, `Classical.choice`, `Quot.sound` |
| `absoluteCohomology_eq_zero_of_basis` | `propext`, `Classical.choice`, `Quot.sound` |
| `absoluteCohomology_one_eq_zero_of_basis` | `propext`, `Classical.choice`, `Quot.sound` |
| `faceShortComplex_shortExact_of_sheaf_ses` | `propext`, `Classical.choice`, `Quot.sound` |
| `cechComplex_shortExact_of_basis` | `propext`, `Classical.choice`, `Quot.sound` |
| `shortExact_piMap` | `propext`, `Classical.choice`, `Quot.sound` |
| `cechHomology_quotient_vanishing` | `propext`, `Classical.choice`, `Quot.sound` |
| `quotient_cech_vanishing_of_basis` | `propext`, `Classical.choice`, `Quot.sound` |

No unauthorized axioms. No `sorry`. No diagnostic errors.

---

## Focus-area analysis

### `BasisCovSystem` fields — vacuousness check

The structure is not vacuous:

- **`faces_mem`**: Genuine condition. Requires finite intersections of covering opens to land in `B`.
- **`surj_of_vanishing`**: Not trivially satisfiable. Even with `Cov = ∅` (where the Čech
  vanishing premise is vacuously true), the *conclusion* still demands `Function.Surjective` of
  `S.g(V)` for all `V ∈ B` and all short exact `S` — a non-trivial mathematical claim that cannot
  be discharged without proof. Constructing such a system with `Cov = ∅` would require genuinely
  proving surjectivity for every SES over every element of `B`.
- **`injective_acyclic`**: Genuine condition. Requires that injective modules have vanishing Čech
  cohomology for every cover in `Cov`. With `Cov = ∅` this is vacuous, but `surj_of_vanishing`
  prevents the degenerate instantiation anyway (see above).
- **`HasVanishingHigherCech`**: Non-vacuous. Demands `IsZero(Ȟᵖ(𝒰, F))` for every `𝒰 ∈ s.Cov`
  and every `p > 0`. This is a genuine module-theoretic condition.

### `[EnoughInjectives X.Modules]` hypothesis — genuine vs. vacuous?

**Genuine.** The hypothesis is actively used: `injSES F` constructs `Injective.under F` (line 363),
and the proof explicitly invokes `absoluteCohomology_eq_zero_of_injective` (line 290, 411) on
`(injSES F).X₂` to conclude injective vanishing. A vacuous strategy would not need the injective
at all. The accompanying comment (lines 352–356) correctly identifies the source of the gap:
`IsGrothendieckAbelian (SheafOfModules R)` is absent from Mathlib, so `EnoughInjectives X.Modules`
cannot be synthesized. Carrying it as an explicit hypothesis is the standard project convention
(cf. P5a lane) and is logically correct: the theorem is a conditional that becomes fully
applicable once that instance is supplied.

### `attribute [local instance] hasExtModules` (line 24)

Not masking a failure. The comment correctly describes the purpose: it re-activates the `HasExt`
instance from `AbsoluteCohomology.lean` locally to short-circuit the `HasSmallLocalizedHom`
typeclass search path, which is known to be slow in this context (see iter-026 memory record).
The `[local instance]` scoping is appropriate. All declarations in the file compile clean. This
is a documented performance annotation, not an excuse-comment.

### `injSES` / `injSES_shortExact`

Both are `private`. `injSES_shortExact` proof is one line:
```lean
ShortComplex.ShortExact.mk (ShortComplex.exact_cokernel _)
```
This is correct: `ShortComplex.exact_cokernel` establishes mid-exactness of `F → I → coker(F→I)`;
`Mono (Injective.ι F)` and `Epi (cokernel.π _)` are auto-synthesized instances. Axiom checks
on the public callers confirm these resolve cleanly.

### `cech_eq_cohomology_of_basis` — strength assessment

The top theorem is a thin wrapper:
```lean
fun _ hU _ hp e => absoluteCohomology_eq_zero_of_basis s hF hU hp e
```
It faithfully exposes `absoluteCohomology_eq_zero_of_basis` under the 01EO name. The statement
is `∀ U ∈ s.B, ∀ p > 0, ∀ e : Extᵖ(jShriekOU U, F), e = 0` — which captures "higher cohomology
vanishes on basis opens under 01EO conditions." This is weaker than a full Čech-to-cohomology
isomorphism (it does not exhibit a natural isomorphism `Ȟᵖ ≅ Hᵖ`), but it is the direct
consequence of 01EO that feeds into the higher-direct-image computation in
`CechHigherDirectImage.lean`. The formalized scope is honest; the naming is the only
(minor) issue.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `CechToCohomology.lean:9–14` — Module docstring header says "L1/L2 chain" but the file now
  contains the full L1–L4 chain plus `cech_eq_cohomology_of_basis`. The header is stale and
  should be updated to reflect the actual scope.
- `CechToCohomology.lean:429` — Declaration name `cech_eq_cohomology_of_basis` implies an
  equality or isomorphism between Čech and absolute cohomology, but the theorem only proves
  vanishing of absolute cohomology given Čech vanishing. The docstring is accurate; the name
  could mislead. Consider renaming to `absoluteCohomology_vanishing_of_basis` or annotating
  the name discrepancy prominently.
- `CechToCohomology.lean:57,70,135,180` — Four instances of `show` used as `change` (linter
  `style.show` warnings). No correctness impact; would be flagged by `leanProject lint`.
- `CechToCohomology.lean:79` — Line exceeds 100-character limit (linter `style.longLine`).

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The file is axiom-clean and proof-correct; all 10+ declarations verify against
the standard axiom set with no sorry and no errors. The four minor findings are a stale header,
a mildly misleading top-level name, and two categories of style linter warnings — none of which
affect correctness or downstream work.
