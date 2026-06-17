# Lean ↔ Blueprint Check Report

## Slug
barescheme

## Iteration
196

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`)
- **Lean target exists**: yes — `ProjectiveLineBar` at L87
- **Signature matches**: yes — `def ProjectiveLineBar (kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`, consistent with "the projective line as an object of `Over (Spec (.of kbar))`"
- **Proof follows sketch**: N/A (definition body; the chapter gives the Proj-of-graded-ring setup, which the Lean faithfully implements)
- **notes**: Intermediate helper `ProjectiveLineBarScheme` (L73) is distinct from `ProjectiveLineBar` and unmentioned by a `\lean{...}` pin, though it is referenced in blueprint prose at L1732. Acceptable as an internal stepping stone.

### `\lean{AlgebraicGeometry.projectiveLineBar_smoothOfRelDim}` (chapter: `lem:projectiveLineBar_smoothOfRelDim`)
- **Lean target exists**: yes — `projectiveLineBar_smoothOfRelDim` at L336
- **Signature matches**: yes — `instance projectiveLineBar_smoothOfRelDim (kbar : Type u) [Field kbar] : SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom`, matching the chapter's claim "smooth of relative dimension 1"
- **Proof follows sketch**: partial — the blueprint sketch (L960-970) describes the cover reduction and per-chart closure correctly at a mathematical level. However:
  - Blueprint names `Smooth_iff_atOpens` as the open-cover gluing API; the Lean uses `IsZariskiLocalAtSource.of_openCover`. These are different Lean names (loose hint).
  - Blueprint says "each chart is standard smooth via the polynomial ring presentation" but does not name `mvPolynomialFin_isStandardSmoothOfRelativeDimension` or the 5-declaration substrate chain (see Focus Area 1 below).
  - Per-chart closure (`projectiveLineBar_smooth_chart_aux`, L316) is a `sorry` gated on ChartIso. Blueprint's sketch implies the per-chart step is straightforward, which understates the current sorry.
- **notes**: The cover-reduction structural step (`IsZariskiLocalAtSource.of_openCover`) is axiom-clean and complete. Only the per-chart gap (private helper) carries a sorry.

### `\lean{AlgebraicGeometry.projectiveLineBar_geomIrred}` (chapter: `lem:projectiveLineBar_geomIrred`)
- **Lean target exists**: yes — `projectiveLineBar_geomIrred` at L218
- **Signature matches**: yes — `instance projectiveLineBar_geomIrred (kbar : Type u) [Field kbar] : GeometricallyIrreducible (ProjectiveLineBar kbar).hom`
- **Proof follows sketch**: no — body is `:= sorry`; the blueprint sketch (L972-993) gives an informal mathematical argument but does NOT supply the formal Lean-level recipe the directive requires: namely, the explicit isomorphism `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` (Helper A) and the downstream helper chain (Helpers B-E)
- **notes**: Lean comment says "plan-marked acceptable for iter-165". The sorry predates iter-196 and is unchanged. The blueprint sketch is mathematically correct but insufficiently decomposed to guide Lean formalization — it does not name or reference the Proj base-change isomorphism needed as the Lean entry point.

### `\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` (chapter: `def:projlinebar_affine_cover`)
- **Lean target exists**: yes — `projectiveLineBarAffineCover` at L254
- **Signature matches**: yes — `def projectiveLineBarAffineCover (kbar : Type u) [Field kbar] : (ProjectiveLineBarScheme kbar).AffineOpenCover` via `Proj.affineOpenCoverOfIrrelevantLESpan` with `m := ![1, 1]`, consistent with blueprint description
- **Proof follows sketch**: yes — the non-trivial `hf` input (irrelevant ideal ≤ span{X₀, X₁}) is proved by monomial decomposition, matching the blueprint's stated argument ("writing any irrelevant element as a sum of monomials of strictly positive total degree, divisible by X₀ or X₁")
- **notes**: Two hoisted helpers (`projectiveLineBarAffineCover_fDeg` L230, `projectiveLineBarAffineCover_hm` L242) are unmentioned in the blueprint but are correctly private infrastructure.

---

## Red flags

### Placeholder / suspect bodies

- `projectiveLineBar_geomIrred` at L218-220: `:= sorry`. Blueprint `lem:projectiveLineBar_geomIrred` claims a substantive geometric-irreducibility result. The Lean comment cites "plan-marked acceptable for iter-165" but no prover work has been attempted in iter-196 and the blueprint proof sketch (L972-993) lacks the formal Lean recipe to close it.

- `projectiveLineBar_smooth_chart_aux` (private) at L316-330: `:= sorry`. This private helper gates the completeness of `projectiveLineBar_smoothOfRelDim`. The Lean comment accurately identifies the blocker (ChartIso iso, downstream file), so the sorry is correctly scoped. Since it is `private`, it is not a blueprint red flag, but it does mean the public instance `projectiveLineBar_smoothOfRelDim` ultimately rests on an unproven sorry.

---

## Unreferenced declarations (informational)

The following declarations in BareScheme.lean have no corresponding `\lean{...}` blueprint block:

| Declaration | Line | Category | Flag? |
|---|---|---|---|
| `projectiveLineBarGrading` | L46 | helper abbreviation | no |
| `projectiveLineBarGrading_gradedRing` | L50 | derived instance | no |
| `algebraKbarAway` | L59 | bridging instance | no |
| `ProjectiveLineBarScheme` | L73 | internal def (not the Over-wrapped version) | borderline |
| `projectiveLineBarScheme_canOver` | L78 | derived instance | no |
| **`projectiveLineBar_isProper`** | **L106** | **substantive properness instance** | **YES** |
| `mvPolyGenerators` | L165 | Mathlib supplement helper | no |
| `mvPolyPresentation` | L173 | Mathlib supplement helper | no |
| `mvPolyPreSubmersivePresentation` | L187 | Mathlib supplement helper | no |
| `mvPolySubmersivePresentation` | L196 | Mathlib supplement helper | no |
| **`mvPolynomialFin_isStandardSmoothOfRelativeDimension`** | **L207** | **key Mathlib supplement instance** | **YES** |
| `projectiveLineBarAffineCover_fDeg` | L230 | hoisted helper | no |
| `projectiveLineBarAffineCover_hm` | L242 | hoisted helper | no |
| `projectiveLineBar_smooth_chart_aux` (private) | L316 | private per-chart helper | no (private) |

**`projectiveLineBar_isProper` (L106)** is substantive: a full instance proof of `IsProper (ProjectiveLineBar kbar).hom` with a non-trivial 40-line argument (bijectivity of `algebraMap kbar ↥(𝒜 0)`, `IsScalarTower` + `Algebra.FiniteType` chain, `Spec.map` iso, composition). The blueprint's `def:genus0_base_objects` prose says "ℙ¹ is proper" but has no dedicated `\lean{...}` block for this instance.

**`mvPolynomialFin_isStandardSmoothOfRelativeDimension` (L207)** is the load-bearing instance for the per-chart smoothness step. It is the terminal result of the 5-declaration MvPolynomial substrate chain and directly enables `RingHom.Locally (IsStandardSmoothOfRelativeDimension 1)` in `projectiveLineBar_smooth_chart_aux`. The blueprint has no `\lean{...}` entry for it or its 4 supporting declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 4 of 18 declarations have a `\lean{...}` block. Of the 14 unblocked: 10 are helpers or private (acceptable); 2 are substantive (`projectiveLineBar_isProper`, `mvPolynomialFin_isStandardSmoothOfRelativeDimension`) and 1 is borderline (`ProjectiveLineBarScheme`).

- **Proof-sketch depth**: **under-specified** for two blocks:
  1. `lem:projectiveLineBar_smoothOfRelDim` (L951-970): the per-chart closure is described as "standard smooth via the polynomial ring presentation" — this is correct in spirit but does not name the 5-declaration Mathlib supplement that the Lean prover had to build, nor does it acknowledge the dependency on `ChartIso.homogeneousLocalizationAwayIso` (a downstream file). A fresh prover reading this sketch would not know a custom `Algebra.SubmersivePresentation` chain was required.
  2. `lem:projectiveLineBar_geomIrred` (L972-993): the proof sketch gives a correct informal argument but does not supply the Lean-level entry point: the Proj base-change isomorphism `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` (Helper A in the directive's recipe) plus the downstream helper chain. Without this, the sorry cannot be closed following the blueprint. This is the more critical gap since the sorry is unresolved.

- **Hint precision**: **loose** on one block:
  - `lem:projectiveLineBar_smoothOfRelDim`: blueprint names `Smooth_iff_atOpens` as the gluing API; Lean uses `IsZariskiLocalAtSource.of_openCover`. The concept is correct but the named Lean API is wrong.

- **Generality**: **matches need** — the `MvPolynomial (Fin n) R` instance is stated at the right generality (arbitrary `n` and `CommRing R`).

- **Recommended chapter-side actions**:
  1. **(must-fix)** Expand `lem:projectiveLineBar_geomIrred` (L972-993) with an explicit Lean recipe: state Helper A (`Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K`, i.e., the `Proj.base_change` or equivalent isomorphism), and Helpers B-E fleshing out how integral domain + base change + geometric irreducibility follow from it. The current informal prose is insufficient for a prover to close the sorry.
  2. **(major)** Add a dedicated `\lean{...}` block for `projectiveLineBar_isProper` referencing `AlgebraicGeometry.projectiveLineBar_isProper`, with a brief proof sketch noting the bijectivity-of-algebraMap argument and the `Proj.instIsProperToSpecZero` chain.
  3. **(major)** Add a `\lean{...}` block for `mvPolynomialFin_isStandardSmoothOfRelativeDimension` (e.g. as a `\mathlibok`-candidate sub-lemma of `lem:projectiveLineBar_smoothOfRelDim`). The prose should note: (a) Mathlib does not ship a direct `IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)` instance; (b) the project builds it via a 5-declaration `Algebra.SubmersivePresentation` chain (`mvPolyGenerators → mvPolyPresentation → mvPolyPreSubmersivePresentation → mvPolySubmersivePresentation → mvPolynomialFin_isStandardSmoothOfRelativeDimension`); (c) the chain terminates in `Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension` with dimension count `Nat.card (Fin n) - Nat.card PEmpty = n`.
  4. **(minor)** Correct the Lean API name in `lem:projectiveLineBar_smoothOfRelDim` from `Smooth_iff_atOpens` to `IsZariskiLocalAtSource.of_openCover` (or leave the name unstated and describe it as "the open-cover locality criterion for `SmoothOfRelativeDimension`").
  5. **(minor)** Add a footnote to `lem:projectiveLineBar_smoothOfRelDim`'s proof sketch noting that the per-chart closure is gated on `ChartIso.homogeneousLocalizationAwayIso` (a downstream file), so the per-chart step (`projectiveLineBar_smooth_chart_aux`) currently has a sorry pending that iso.

---

## Severity summary

- **must-fix-this-iter**:
  - Blueprint `lem:projectiveLineBar_geomIrred` (L972-993) is under-specified: missing the formal Proj base-change isomorphism recipe (Helper A: `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` + Helpers B-E). The sorry at L218 cannot be closed from the current blueprint prose alone.

- **major**:
  - `projectiveLineBar_isProper` (L106) — substantive properness instance with 40-line proof, no `\lean{...}` blueprint block.
  - `mvPolynomialFin_isStandardSmoothOfRelativeDimension` (L207) — load-bearing Mathlib supplement instance enabling per-chart smoothness; its 5-declaration supporting chain (L165-211) is entirely absent from the blueprint. A prover could not have anticipated building this chain from the chapter prose.

- **minor**:
  - Blueprint's smoothness sketch names `Smooth_iff_atOpens` but Lean uses `IsZariskiLocalAtSource.of_openCover` — loose hint.
  - Per-chart sorry dependency on ChartIso not acknowledged in the blueprint sketch for `lem:projectiveLineBar_smoothOfRelDim`.

**Overall verdict**: The Lean declarations that exist are mathematically correct and faithfully implement the blueprint's informal intent. The file's main issues are blueprint-side: the geometric-irreducibility proof sketch (L972-993) lacks the formal Lean recipe needed to close its sorry, and two substantive results (`projectiveLineBar_isProper`, `mvPolynomialFin_isStandardSmoothOfRelativeDimension`) have no blueprint entries.
