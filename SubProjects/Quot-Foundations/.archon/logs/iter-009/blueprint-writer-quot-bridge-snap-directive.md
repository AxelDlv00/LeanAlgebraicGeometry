# Blueprint Writer Directive — QUOT-A QCoh bridge + SNAP-S2 rationality

## Slug
quot-bridge-snap

## Chapter to edit
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this chapter). You may also read/write
`references/**` to spawn a reference-retriever if a source you need is absent.

Two independent tasks in this one chapter (kept in one writer to avoid a write conflict).

## TASK 1 (MUST-FIX) — specify `lem:qcoh_section_localization_basicOpen`
The block `lem:qcoh_section_localization_basicOpen`
(`\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}`, ~line 560) currently has a
Lean name and prose but NO `% LEAN SIGNATURE` block and no closed proof strategy. It is the
QCoh→`IsLocalizedModule` bridge that the entire QUOT-A predicate chain
(`def:modules_annihilator` → `def:schematic_support` → `def:has_proper_support`) depends on. Make
it a fully formalizable prover target:

- Add a rigorous `% LEAN SIGNATURE` block (project convention) for
  `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`. The statement: for a
  quasi-coherent sheaf of modules `F` on a scheme `X`, an affine open `U = Spec R ⊆ X`, and
  `f ∈ R = Γ(U, O_X)`, the restriction map `Γ(U, F) → Γ(D(f), F)` exhibits `Γ(D(f), F)` as the
  localization of the `R`-module `Γ(U, F)` at `Submonoid.powers f` (i.e. an `IsLocalizedModule
  (Submonoid.powers f)` instance/witness on that restriction map).
- Write a complete informal proof: reduce to the affine model via quasicoherence (the QCoh datum
  identifies `F|_U` with `(Γ(U,F))~`), then invoke the Mathlib anchor
  `lem:isLocalization_basicOpen_mathlib` (`AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`,
  the structure-sheaf statement) and the tilde-module localization of sections to transport the
  localization property to `F`. State precisely how the quasicoherence isomorphism intertwines the
  restriction map with the module localization map.
- Set `\uses{lem:isLocalization_basicOpen_mathlib}` (statement-level) plus any QCoh-datum block it
  needs; confirm no broken `\uses{}`.
- Cite the source: the relevant Stacks tag for "sections of a quasi-coherent sheaf on a basic open
  are the localization" — read the local file (`references/stacks-schemes.tex` covers tag 01I9 =
  the `M~`-pullback/pushforward lemma; the QCoh-on-affine localization is the adjacent
  `lemma-standard-open` / tag for `Γ(D(f), F~) = M_f`). Add a verbatim `% SOURCE QUOTE:` from the
  local file; if the precise tag is not in `references/stacks-schemes.tex`, spawn a
  reference-retriever for it rather than quoting from memory.

## TASK 2 (unstarted-phase proposal) — specify SNAP-S2 `lem:gradedHilbertSerre_rational`
The block `lem:gradedHilbertSerre_rational`
(`\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}`) is the Mathlib-absent graded
Hilbert–Serre rationality bridge — STRATEGY.md marks SNAP-S2 "authorable now" (imports only Mathlib
+ the graded encoding). Give it a `% LEAN SIGNATURE` + proof sketch so a prover can be dispatched:

- Add a `% LEAN SIGNATURE` block: for a finitely-generated graded module `M = ⊕_n M_n` over a
  Noetherian graded ring generated in degree 1 over a field `κ`, the Hilbert/Poincaré series
  `∑_n dim_κ(M_n) · X^n` is a rational function of the form `p(X)·(1-X)^{-d}` with `p ∈ ℤ[X]`
  (equivalently the form `Polynomial.existsUnique_hilbertPoly` consumes). Pin the cleanest type you
  can that matches Mathlib's `Polynomial.existsUnique_hilbertPoly` interface (see
  `lem:hilbertPoly_exists_mathlib`).
- Proof sketch (the reviewer's seed): Noetherian induction on the f.g. graded module; base case a
  graded field/finite-length module; inductive step via the SES
  `0 → M(-1) → M → M/M(-1) → 0` from multiplication by a degree-1 generator and additivity of
  dimension on short exact sequences, giving the `(1-X)^{-1}` factor.
- Source: Hartshorne I.7.5 (Hilbert polynomial / rationality of the Hilbert series) — read
  `references/hartshorne-algebraic-geometry.pdf` (the I.§7 pages; body offset +17). Add a verbatim
  `% SOURCE QUOTE:` from the local file. (Atiyah–Macdonald Ch.11 is the classical alternative; if
  Hartshorne's statement is awkward to quote, a reference-retriever for A–M Ch.11 is acceptable.)
- `\uses{}` should reference only the graded encoding blocks already in the chapter +
  `lem:hilbertPoly_exists_mathlib` if it feeds the extraction. No new external dependencies.

## Hard constraints
- Do NOT add or remove `\leanok` (sync owns it). `\mathlibok` only on genuine Mathlib anchors
  (the anchors `lem:isLocalization_basicOpen_mathlib`, `lem:hilbertPoly_exists_mathlib` already
  exist — do not duplicate).
- Citation discipline: every `% SOURCE QUOTE:` must be verbatim from a local file you opened this
  session. No quoting from memory.
- Do NOT touch the GrassmannianCells, FBC, or GF chapters. Do NOT alter the already-`\leanok`
  blocks in QuotScheme (`def:quot_functor`, `def:grassmannian_scheme`, `def:hilbert_polynomial`,
  etc.) except to fix a `\uses{}` arc that legitimately needs the newly-specified labels.

## Out of scope
Proving anything (you only write blueprint). The `def:sectionGradedRing` monoidal-infrastructure
gap (S1/S3) stays BLOCKED — do NOT attempt to specify it; it needs a separate tensor-powers
sub-build that is not authorable yet.
