# blueprint-clean — acyclic — Report

## Target
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## Status
PASS — all purity, citation, and LaTeX tasks completed.

---

## Changes applied

### 1. Lean notation stripped from setup paragraph
- Removed `G.\mathrm{rightDerived}\,n : \mathcal{A} \to \mathcal{B}` (Lean field access
  syntax) from the definition of `R^n G`.
- Replaced `(the Mathlib anchor \ref{...})` and `(anchor \ref{...})` with
  `(Lemma~\ref{...})` in two places.

### 2. Section heading and intro rewritten
- Renamed section **"Mathlib dependency anchors"** → **"Known results"**.
- Replaced the meta-commentary opening paragraph ("The development stands on three
  results that Mathlib already provides … explicit and the dependency graph resolves")
  with a neutral mathematical framing ("The following three well-known results underpin
  … the foundational inputs to the argument").

### 3. `lem:homology_long_exact_sequence` tail recast
- Removed "Mathlib provides no analogous long exact sequence directly at the level of
  the derived-functor objects \((R^n G)\), so the present development builds …".
- Replaced with timeless forward pointer: "The derived-functor long exact sequence used
  in the sequel is constructed from this complex-level result via a horseshoe lift; see
  Lemma~\ref{lem:acyclic_dimension_shift}."

### 4. `def:right_acyclic` remark stripped of Lean names
- Removed references to `\mathrm{IsZero}`, `\texttt{Limits.IsZero}`,
  `.obj`, and `\texttt{isZero\_rightDerived\_obj\_injective\_succ}`.
- Removed "so it is the recommended definitional form" (project meta).
- Retained the mathematical substance: two equivalent quantifier shapes and their
  alignment with `lem:right_derived_vanishes_injective`.

### 5. Horseshoe section intro cleaned
- Removed "Mathlib provides the building blocks (…) but does not appear to ship the
  lift itself, so it is recorded here as an explicit project obligation".
- Replaced with: "individual injective resolutions (provided by enough injectives)
  furnish the building blocks, and the horseshoe construction assembles them into the
  required lift."

### 6. `\uses{}` in horseshoe proof corrected
- Added `lem:homology_long_exact_sequence` to the `\uses{}` list of
  `\begin{proof}` for `lem:injective_resolution_of_ses`, which the proof body
  explicitly invokes for the acyclicity argument.

### 7. Comment before `lem:acyclic_dimension_shift` proof cleaned
- Removed "Mathlib provides no such delta-functor at the level of the
  right-derived-functor OBJECTS" and "the proof below is project-original" and
  "the route differs from the cited source's".
- Retained the mathematical note: Stacks uses derived-category δ-functor machinery;
  this proof uses the complex-level LES + horseshoe route.

### 8. Proof of `lem:acyclic_dimension_shift` opening sentence recast
- Removed "we must instead build by hand" framing.
- Replaced with: "In the classical treatment this sequence is supplied by the
  δ-functor structure …; here it is built directly from the complex-level homology
  long exact sequence via a horseshoe lift."

---

## Citation discipline check

| Block | Tags | SOURCE QUOTE | SOURCE QUOTE PROOF |
|---|---|---|---|
| `def:right_acyclic` | 0157, 015C | ✓ (two quotes) | n/a (definition) |
| `lem:acyclic_dimension_shift` | 015D | ✓ | ✓ (comment; no verbatim since route differs — correct) |
| `lem:acyclic_resolution_computes_derived` | 015E, 05TA | ✓ (two quotes) | ✓ |
| `\mathlibok` blocks (4) | Mathlib | "Provided by Mathlib" lines — no SOURCE QUOTE needed | ✓ |
| `lem:injective_resolution_of_ses` (horseshoe) | none / Weibel prose | Weibel pointer — no verbatim quote required | n/a |

All checks pass.

---

## Residual notes

- Lines 103–110 (`lem:homology_long_exact_sequence`, `\mathlibok` block): The field
  notation `S.X_1, S.X_2, S.X_3` and the mention of the Lean connecting-map name
  `\texttt{ShortComplex.ShortExact.\(\delta\)}` remain — they are inside the
  `\mathlibok` anchor, which the directive instructs to leave intact.
- No other Lean leakage, iter references, or project-history phrasing detected in the
  final file.
