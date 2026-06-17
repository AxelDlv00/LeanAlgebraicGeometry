# Blueprint Writer Directive

## Slug
a2b-quot

## Target chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (NEW)

## Lean file
`AlgebraicJacobian/Picard/QuotScheme.lean` (NEW).

Add `% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean` at top.

## Strategy context

Route A.2.b — gated on A.2.a (`Picard_FlatteningStratification.tex`, written this iter) + A.1.a (`Picard_RelativeSpec.tex`, on disk). ~1500-2500 LOC, ~10-17 iters. **Load-bearing FGA piece** — band widened iter-174 per strategy-critic (Mathlib has no Grassmannian scheme).

This builds the Quot scheme: for a projective scheme `X/S` and a coherent sheaf `F` on `X`, the Quot functor parameterizes quotients of `F` with given Hilbert polynomial. Per Nitsure §5.

The output is consumed by A.2.c (FGA Pic representability assembly).

## Required content

### Definition: Hilbert polynomial of a coherent sheaf
For `f : X → S` projective with `S` Noetherian and `F` coherent on `X`, the Hilbert polynomial `P_F(n) := χ(F ⊗ O_X(n))` (Euler characteristic at twist `n`). State the standard polynomial-eventually property (Hartshorne III.5.2). Cite from `references/hartshorne-algebraic-geometry.pdf`.

### Definition: Quot functor
For a projective morphism `X/S` with a coherent sheaf `F` on `X` and a polynomial `P`, the functor
$$\mathrm{Quot}^P_{F/X/S} : (\mathrm{Sch}/S)^{\mathrm{op}} \to \mathbf{Set}$$
sends `T → S` to the set of equivalence classes of quotient sheaves `f_T^*F ↠ Q` where `Q` is coherent on `X_T`, `T`-flat, and the Hilbert polynomial of `Q` (over each fiber) is `P`.

### Theorem: Quot scheme representability
Statement (Nitsure §5, Theorem 5): the functor `Quot^P_{F/X/S}` is representable by a projective `S`-scheme `Quot^P_{F/X/S}`.

### Proof outline (Nitsure §5 verbatim, then project notation)

Quote Nitsure §5 verbatim. Then split into sub-steps:

1. **Boundedness**. Use cohomology-and-base-change (Stacks 02KH) to reduce to the case where all quotients `f_T^*F ↠ Q` are uniformly bounded.

2. **Grassmannian embedding**. Pick `m` large enough that twisting `F(m)` makes the Quot functor an open subfunctor of the Grassmannian `Gr_d(H^0(F(m)))` for appropriate `d`. **This requires a Grassmannian scheme — absent from Mathlib at the pinned commit, so a project-side sub-build is needed.**

3. **Locus of flat quotients is open in Grassmannian**. Use the flattening stratification (A.2.a) to identify the locus where the universal quotient is `T`-flat; this is a finite union of strata, hence a locally-closed subscheme of the Grassmannian. The open part of this stratification gives the desired open subfunctor.

4. **Closed in projective Grassmannian**. The flatness condition is closed, hence `Quot^P` is closed in the Grassmannian, hence projective.

### Sub-lemmas

- **`def:hilbert_polynomial`** — Hilbert polynomial of a coherent sheaf.
- **`def:quot_functor`** — the Quot functor as `(Sch/S)^op → Set`.
- **`def:grassmannian_scheme`** — the Grassmannian `Gr_d(V)` for a finite-rank free `O_S`-module `V`. **NEW sub-build, Mathlib gap.**
- **`thm:grassmannian_representable`** — Grassmannian is representable.
- **`thm:quot_representable`** — main statement.

### Lean signature targets

- `def:hilbert_polynomial` → `AlgebraicGeometry.Scheme.hilbertPolynomial`
- `def:quot_functor` → `AlgebraicGeometry.Scheme.QuotFunctor`
- `def:grassmannian_scheme` → `AlgebraicGeometry.Scheme.Grassmannian`
- `thm:quot_representable` → `AlgebraicGeometry.Scheme.QuotScheme`

## Required citations

Read verbatim from:
- `references/nitsure-hilbert-quot.pdf` §5 (Quot scheme construction).
- `references/nitsure-hilbert-quot.pdf` §4 (Grassmannian, if introduced separately).
- `references/stacks-coherent.md` for cohomology-and-base-change (Stacks 02KH).

`% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT touch `content.tex`.
- Do NOT re-prove flattening stratification — `\uses{thm:flattening_stratification_exists}`.
- Do NOT scope into Hilbert scheme separately (the Quot scheme subsumes Hilbert for `F = O_X`).

## Verification

`\input{...}` is the plan agent's job.

## Report format

Standard. Flag the Grassmannian scheme as a sub-prerequisite: it might warrant its own chapter `Picard_GrassmannianScheme.tex` (writer iter-175+). If you decide that splitting Grassmannian into a separate chapter is the cleaner organisation, note it under "Notes for Plan Agent".
