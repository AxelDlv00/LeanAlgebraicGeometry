# Blueprint Writer Report

## Slug
quot-bridge-snap

## Status
COMPLETE
Both directive tasks fully specified: `lem:qcoh_section_localization_basicOpen`
(TASK 1) and `lem:gradedHilbertSerre_rational` (TASK 2) now carry rigorous
`% LEAN SIGNATURE` blocks and source-backed proof material. Every `% SOURCE
QUOTE:` is verbatim from a local file opened this session.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### TASK 1 — `lem:qcoh_section_localization_basicOpen` (QCoh→IsLocalizedModule bridge)
- **Added `% LEAN SIGNATURE` block** to
  `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}`. Pins the
  intended scaffold target: for `F : X.Modules` with
  `[SheafOfModules.IsQuasicoherent F]`, an affine open `U` (`IsAffineOpen U`), and
  `f : Γ(X, U)`, the section-restriction `ρ : Γ(F, U) →ₗ[Γ(X,U)] Γ(F, D(f))` is
  `IsLocalizedModule (Submonoid.powers f) ρ`. States the scalar tower
  `Γ(X,U) → Γ(X,D(f)) → Γ(F,D(f))`, the `ρ = F.presheaf.map (homOfLE …).op`
  encoding, and points the ring half at `lem:isLocalization_basicOpen_mathlib`.
- **Refined statement + proof prose**: dropped the spurious *finite-type*
  hypothesis from the localization conclusion. The `M~` localization-of-sections
  fact holds for ANY quasi-coherent sheaf (finiteness is not used here); the
  finite-type hypothesis genuinely enters only downstream in
  `def:modules_annihilator` via `lem:annihilator_localization_eq_map`. Added an
  explicit NOTE recording this so the prover isn't misled into carrying an unused
  hypothesis. (This block is not `\leanok`; refining its statement is in scope.)
- `\uses{lem:isLocalization_basicOpen_mathlib}` unchanged (already correct);
  source quote (Stacks "Schemes" tag, `lemma-spec-sheaves` item (4), from
  `references/stacks-schemes.tex`) was already verbatim-correct and is retained.

### TASK 2 — `lem:gradedHilbertSerre_rational` (graded Hilbert–Serre rationality)
- **Added `% LEAN SIGNATURE` block** to
  `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}`. Pins a graded
  `κ`-algebra encoding (`𝒜 : ℕ → Submodule κ A`, `[GradedAlgebra 𝒜]`, `𝒜 0` the
  scalars so `S₀ = κ`), f.g. graded module (`ℳ`, `[GradedModule 𝒜 ℳ]`,
  `[Module.Finite A M]`, each `ℳ n` finite-dim over κ), degree-1 generation
  (`Algebra.adjoin κ (↑(𝒜 1)) = ⊤`), and the conclusion in the EXACT
  rational-series form consumed by Mathlib's `Polynomial.existsUnique_hilbertPoly`
  (`lem:hilbertPoly_exists_mathlib`): `∃ p d N, ∀ n > N,
  (finrank κ (ℳ n) : ℚ) = (↑(toPowerSeries p) * ↑(invOneSubPow ℚ d)).coeff n`.
  Verified the `PowerSeries.invOneSubPow` interface against the Mathlib source so
  the conclusion shape matches `existsUnique_hilbertPoly` (which uses
  `(p * invOneSubPow F d : F⟦X⟧).coeff n`).
- **Replaced the SOURCE/SOURCE QUOTE** for this block: was a Nitsure Snapper's-Lemma
  quote (about χ being polynomial); now cites the precise rationality statement —
  Stacks Project "Commutative Algebra" Tag **00K1**
  (`proposition-graded-hilbert-polynomial`), quoted verbatim from the newly
  retrieved `references/hilbert-serre-algebra.tex` (L13893–L13905). `\textit{Source}`
  updated accordingly (cf. Nitsure/Hartshorne kept as secondary pointers).
- **Added `% SOURCE QUOTE PROOF:`** before the proof env: verbatim Stacks 00K1
  inductive step (the degree-1 multiplication SES
  `0 → M_d → M_{d+1} → M̄_{d+1} → 0` giving `[M_{d+1}] − [M_d] = [M̄_{d+1}]`),
  from `references/hilbert-serre-algebra.tex` L13938–L13947. The existing
  in-project proof sketch (Veronese reduction + induction, rational-series form)
  is retained as the project-notation restatement the prover formalizes.
- `\uses{def:sectionGradedRing, def:sectionGradedModule, lem:sectionGradedModule_fg}`
  unchanged — correct per directive (the `hilbertPoly` extraction that consumes
  `lem:hilbertPoly_exists_mathlib` lives in `thm:hilbertPoly_of_sectionModule`,
  not in this rationality lemma, so no new arc added here).

## Cross-references introduced
- No new `\uses{}` arcs added; both target blocks already carried the correct
  edges. `leandag build --json`: `unknown_uses: []`; `leandag query --isolated
  --chapter Picard_QuotScheme`: 0 results. Begin/end balance 25/25.

## References consulted
- `references/stacks-schemes.tex` (L680–710) — confirmed the existing verbatim
  quote for `lem:qcoh_section_localization_basicOpen` (`lemma-spec-sheaves` item
  (4), `Γ(D(f), M~) = M_f`) is character-exact against the local file.
- `references/hilbert-serre-algebra.tex` (L13856–L13948) — verbatim source for
  `lem:gradedHilbertSerre_rational`: Tag 00K1 proposition statement (L13893–13905)
  and inductive-step proof SES (L13938–13947). Newly retrieved this session.
- `references/hartshorne-algebraic-geometry.md` — confirmed it is only a
  page-map (no theorem text); the PDF has no text layer, so Hartshorne I.7.5 is
  NOT verbatim-quotable locally (hence the Stacks retrieval).
- Mathlib source (read for signature accuracy, not cited):
  `Mathlib/RingTheory/Polynomial/HilbertPoly.lean` (`existsUnique_hilbertPoly`
  shape), `Mathlib/RingTheory/PowerSeries/WellKnown.lean` (`invOneSubPow` type),
  `Mathlib/AlgebraicGeometry/Modules/{Sheaf,Tilde}.lean`
  (`X.Modules`, `Γ(M,U)` notation, `SheafOfModules.IsQuasicoherent`,
  `fromTildeΓ`), and `AlgebraicJacobian/Picard/QuotScheme.lean`
  (`annihilator_isLocalizedModule_eq_map` for the project `IsLocalizedModule`
  idiom).

## Reference-retriever dispatches
- slug `hilbert-serre`: requested the Hilbert–Serre rationality theorem (Stacks
  Algebra Hilbert-function section / A–M Ch.11). Status: COMPLETE. Downloaded
  `references/hilbert-serre-algebra.tex` (Stacks `algebra.tex`, TeX, verified);
  pointer `references/hilbert-serre.md`; registered in `references/summary.md`.
  Key location: Tag 00K1, L13893–13948. (Retriever corrected the directive's
  seed: tag 00P4 is unrelated; the theorem is 00K1.)

## Macros needed
- None. (One transient use of a nonexistent `\propname` was caught and replaced
  with plain text before finalizing.)

## Notes for Plan Agent
- The two `\mathlibok` anchors named in the directive
  (`lem:isLocalization_basicOpen_mathlib`, `lem:hilbertPoly_exists_mathlib`)
  already existed and were left untouched; no duplication.
- `def:sectionGradedRing` remains BLOCKED (S1/S3 tensor-powers infrastructure)
  as instructed — not specified. Note that both newly-specified lemmas sit
  *downstream* of `def:sectionGradedRing` in the graph (TASK 2's lemma `\uses` it),
  so a prover dispatched on `lem:gradedHilbertSerre_rational` will still hit the
  graded-encoding gap at the `R(X_s,L_s)`/`M(X_s,F_s,L_s)` construction. The
  rationality lemma's LEAN SIGNATURE is written against the *abstract* graded
  encoding (`GradedAlgebra 𝒜` / `GradedModule 𝒜 ℳ`), so it CAN be proved as a
  standalone Mathlib-only statement now; the wiring of `R(X_s,L_s)` into that
  abstract form is what stays gated on the tensor-powers sub-build.
- TASK 1's signature uses `SheafOfModules.IsQuasicoherent`, which exists in
  Mathlib at the pinned commit (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`).
  The precise `IsFiniteType` predicate for `X.Modules` was deliberately NOT used
  (not needed for this bridge); if the scaffolder wants it elsewhere it should
  confirm the exact Mathlib name.

## Strategy-modifying findings
None. The architecture (graded rational-series form feeding Mathlib's
`existsUnique_hilbertPoly`) is sound and matches the retrieved source. One minor
observation, not strategy-breaking: Stacks 00K1 proves the *numerical-polynomial*
conclusion directly via the same SES, without forming the rational series — so
`lem:gradedHilbertSerre_rational` could in principle be reformulated to conclude
"numerical polynomial" directly and skip `lem:hilbertPoly_exists_mathlib`. The
current rational-series factoring is retained as it is the chosen Mathlib
interface and is fully correct.
