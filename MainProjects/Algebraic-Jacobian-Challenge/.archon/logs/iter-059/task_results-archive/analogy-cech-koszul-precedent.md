# Analogy Report

## Slug
cech-koszul-precedent

## Persistent file
analogies/cech-koszul-precedent.md

## Question addressed
What does Mathlib already provide for the iter-059+ obligations
`IsCechAcyclicCover (toModuleKSheaf C) (basicOpenCover s)` and
`HasCechToHModuleIso (toModuleKSheaf C) (basicOpenCover s)` on a
spanning subset `s ⊆ Γ(C.left, U)` of an affine open, and what is the
most economical Mathlib-faithful design for the project-local additions?

## Top-line recommendation
**Pursue the Čech-vs-derived comparison directly; do not try to bypass
it.** Mathlib has no acyclic-cover ⇒ Čech-iso-to-derived theorem and no
Čech-to-cohomology spectral sequence; the constituent ingredients exist
and combine cleanly:

- `ExtraDegeneracy.homotopyEquiv` (`AlgebraicTopology/ExtraDegeneracy.lean:328`)
  encapsulates the alternating-sum-cancellation argument the directive
  feared having to reproduce.
- `FormalCoproduct.extraDegeneracyCech`
  (`CategoryTheory/Limits/FormalCoproducts/ExtraDegeneracy.lean:92`)
  specialises it to Čech objects.
- `exact_of_isLocalized_span` (`RingTheory/LocalProperties/Exactness.lean:173`)
  is the spanning-set local-to-global exactness lemma.
- `IsAffineOpen.isLocalization_of_eq_basicOpen`
  (`AlgebraicGeometry/AffineScheme.lean:716`) plus the iter-057/058
  helpers identifies each `F(⨅_k 𝒰 (x k))` as a `Localization.Away` of
  `Γ(C.left, U)`.

Together they reproduce the Stacks 01ED proof (acyclicity of the
augmented Čech complex of a quasi-coherent sheaf on an affine cover) at
~150-250 LOC for Branch A (acyclicity) plus ~150-200 LOC for Branch B
(comparison), for a total of ~300-450 LOC — at the **low end** of the
directive's estimate.

The Čech-vs-derived comparison **must** be constructed project-locally,
but only as a direct "augmented Čech complex is a resolution of `F(U)`"
argument — not as a full Čech-to-cohomology spectral sequence (Stacks
03OU), which would balloon to ~600+ LOC and is out of scope for the
genus proof.

**Naming**: `Mathlib.CategoryTheory.Sites.SheafCohomology.Cech` import
still resolves; no rename. The iter-056 docstring at
`AlgebraicJacobian/Cohomology/MayerVietoris.lean:1441` references
`exact_of_localized_span` — both that name and `exact_of_isLocalized_span`
exist in Mathlib (`Exactness.lean:211` and `:173` respectively); the
iter-057 correction over-corrected.

## Strongest precedent
`ExtraDegeneracy.homotopyEquiv` at
`Mathlib/AlgebraicTopology/ExtraDegeneracy.lean:328`, combined with
`FormalCoproduct.extraDegeneracyCech` at
`Mathlib/CategoryTheory/Limits/FormalCoproducts/ExtraDegeneracy.lean:92`
and `exact_of_isLocalized_span` at
`Mathlib/RingTheory/LocalProperties/Exactness.lean:173`. Together these
collapse Branch A's alternating-sum-cancellation worry to bookkeeping
(localized-cover ⇔ Čech-of-`D(f)` identification, ~60-100 LOC).

## Caveats
The strongest weakness is op-duality bookkeeping: Mathlib's
`extraDegeneracyCech` is on augmented *simplicial* objects (so it
produces chain-complex null-homotopies), but the project's Čech complex
is a cochain complex built via `alternatingCofaceMapComplex` (the
cosimplicial dual). The op-passage is straightforward (~20-30 LOC) but
not free.

## Other open questions noticed
- The `noncomputable abbrev` design choice for `HModule` / `HModule'`
  (iter-009 / iter-014) may need re-auditing once Branch B starts
  producing `LinearEquiv`-valued comparisons at universe `u+1` — the
  iter-049 universe bridge may need to handle the augmentation universe.
- Whether the iter-046 `Functor.const_linear` / `Functor.const_additive`
  instances suffice for the `Linear k`-enrichment that Branch B's
  Hom-into-`F` complex will need.
- The Stacks 01ED proof is stated for quasi-coherent sheaves of
  `O_C`-modules; `toModuleKSheaf` is a sheaf of `k`-modules (constant
  base ring), not the structure sheaf as an `O_C`-module. The
  combinatorial alternating-sum cancellation carries over verbatim, but
  the blueprint should note the distinction.
