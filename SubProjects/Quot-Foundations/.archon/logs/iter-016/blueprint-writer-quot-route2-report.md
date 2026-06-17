# Blueprint Writer Report

## Slug
quot-route2

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Summary
Re-skeletoned the graded Hilbert–Serre rationality machinery from the old
G1–G5 graded-quotient-ring route to **Route 2: the ambient subquotient
induction** of `analogies/quot-hilbert-function-route.md`. Every derived object
is now an ambient family `n ↦ N_aux ∩ ℳn` of homogeneous submodules of the fixed
graded module `M`; no `DirectSum.Decomposition` on a subtype `↥p` / quotient
`M ⧸ p` carrier, no graded quotient ring `R/(x)`, and no regrading are ever
formed — structurally eliminating the `isDefEq`/`whnf` runaway recorded in
`memory/graded-quotient-module-isdefeq-pathology.md`.

`leandag build --json`: `isolated: 0`, `unknown_uses: []`, `conflicts: []`.
LaTeX environments balanced (66 begin / 66 end; lemma 31/31, definition 12/12,
proof 16/16). No `\leanok` added; no `REF` placeholders; no interleaved math
delimiters (`$…$` only in environment titles, matching the chapter's existing
`[$D_5$ …]` convention).

## Changes Made

### A. KEPT (unchanged)
- Statement of `lem:gradedHilbertSerre_rational` (pin
  `AlgebraicGeometry.gradedModule_hilbertSeries_rational`, conclusion) — only its
  `\uses{}`, proof, and Status paragraph changed.
- D5 `lem:graded_degreewise_finrank_diff` (landed) — kept; prose `\cref`s
  retargeted (see below).
- Mathlib anchors `submodule_isHomogeneous_mathlib`,
  `ideal_homogeneous_span_mathlib`, `finrank_range_add_finrank_ker_mathlib`,
  `fg_restrictScalars_of_surjective_mathlib`,
  `isHomogeneousElem_graded_smul_mathlib` — kept `\mathlibok`; their trailing
  `\cref`s retargeted to Route-2 labels.
- Entire `IsRatHilb` toolkit (`subsec:isRatHilb`) — untouched.

### B. SPLIT the G1 block
- **Removed** `lem:graded_homogeneousSubmodule_decomposition` (pin named a
  non-existent decl) and its `% NOTE`.
- **Added** `\label{lem:graded_homogeneousSubmodule_iSupIndep}` /
  `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep}`
  (independence half: `n ↦ ℳn ⊓ p` is `iSupIndep`), with proof.
- **Added** `\label{lem:graded_homogeneousSubmodule_iSup_eq}` /
  `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq}`
  (supremum half: `⨆ n, (ℳn ⊓ p) = p`), with proof. Both stated ambient in `M`.
- All `\cref`s that pointed at the old decomposition label retargeted to one or
  both split labels.

### C. RE-SKELETONED the proof of `lem:gradedHilbertSerre_rational`
- Rewrote the proof: keeps the degree-1-generation reduction (and its NOTE at
  ~L429), then instantiates the Route-2 induction
  (`lem:graded_subquotient_isRatHilb`) at `(N,N') = (⊤,⊥)` with the `r` endos =
  multiplication by a κ-basis of `R₁`; `dim_κ Mₙ = dim(⊤⊓ℳn) − dim(⊥⊓ℳn)` is the
  ambient hilb, giving `IsRatHilb(n ↦ dim_κ Mₙ, r)`.
- Updated proof `\uses{}` (dropped the three deleted G-blocks; added the Route-2
  blocks + split-G1 + retained toolkit/D5/mathlib anchors) and statement
  `\uses{}` at L349 (added `def:graded_subquotientHilb`,
  `lem:graded_subquotient_isRatHilb`).
- Rewrote the Status/`% NOTE` paragraph: the Mathlib gap is now **avoided** by the
  ambient subquotient route, not filled. Kept all `% SOURCE` /
  `% SOURCE QUOTE PROOF` (Stacks 00K1) comments.

### D. DROPPED G2/G3/G4/G5(old); ADDED Route-2 blocks
- **Removed** `lem:graded_quotient_decomposition` (G2),
  `lem:graded_quotientRing_gradedRing` (G3),
  `lem:graded_regrade_over_quotient` (G4), and the old
  `lem:graded_finite_transfer` (G5).
- **Removed** the now-unused `lem:quotSMulTop_mathlib` anchor (no remaining
  citers under Route 2; verified by grep).
- **Added** `def:graded_subquotientHilb` /
  `\lean{…GradedModule.subquotientHilb}` — subquotient datum (fixed `ℳ`,
  finite-dim components, homogeneous `N' ≤ N`, commuting degree-+1 endos
  `t : Fin r → M →ₗ[κ] M` preserving `N`,`N'`, `Module.Finite` witness) and the
  ambient hilb `n ↦ (finrank κ ↥(N⊓ℳn) − finrank κ ↥(N'⊓ℳn))` cast to ℚ. Uses
  split G1.
- **Added** `lem:graded_subquotient_ker_coker` /
  `\lean{…subquotient_ker_coker}` — the two subquotient pairs `K = (N⊓x⁻¹N', N')`,
  `C = (N, N'+x·N)`; homogeneity, preservation by the remaining endos, and
  annihilation by `x`; identifies them as `ker`/`coker` of `x` on `N/N'`.
- **Added** `lem:graded_subquotient_degreewise_diff` (D6) /
  `\lean{…subquotient_degreewise_diff}` — via `Q_n = (N⊓ℳn)/(N'⊓ℳn)` and D5,
  `hilb(n+1) − hilb(n) = h_C(n+1) − h_K(n)`. Carries the Stacks-00K1 SES
  `% SOURCE QUOTE PROOF`.
- **Added** `lem:graded_subquotient_finite_transfer` /
  `\lean{…subquotient_finite_transfer}` — the two subquotients are finite over
  `κ[t₀…t_{r-2}]` via Noetherian + annihilation by `x` +
  `Submodule.FG.restrictScalars_of_surjective`. R/(x)-free (ambient).
- **Added** `lem:graded_subquotient_isRatHilb` /
  `\lean{…subquotient_hilbertSeries_rational}` — induction on `r`:
  base `r=0` via `IsRatHilb.ofEventuallyZero`; step via blocks
  ker_coker + D6 + finite_transfer feeding `IsRatHilb.ofDiffEq` + `IsRatHilb.bump`.
  Carries the Stacks-00K1 induction `% SOURCE QUOTE PROOF`.
- D5 prose `\cref`s retargeted from G1/G2 to `lem:graded_subquotient_degreewise_diff`
  + split G1 + `isHomogeneousElem_graded_smul_mathlib`.
- Rewrote the `subsec:gradedModuleApi` intro + "Setting" prose to describe the
  ambient subquotient class instead of the R/(x) wrapper.

## Cross-references introduced
All resolve (leandag `unknown_uses: []`). Key new edges:
- `lem:gradedHilbertSerre_rational` (stmt+proof) → `def:graded_subquotientHilb`,
  `lem:graded_subquotient_isRatHilb`, split G1, retained toolkit/D5/anchors.
- `lem:graded_subquotient_isRatHilb` → `def:graded_subquotientHilb`,
  `lem:graded_subquotient_ker_coker`, `lem:graded_subquotient_degreewise_diff`,
  `lem:graded_subquotient_finite_transfer`, `lem:ratHilb_ofEventuallyZero`,
  `lem:ratHilb_ofDiffEq`, `lem:ratHilb_bump`.
- `lem:graded_subquotient_degreewise_diff` → `lem:graded_subquotient_ker_coker`,
  `lem:graded_degreewise_finrank_diff` (D5), split G1,
  `lem:isHomogeneousElem_graded_smul_mathlib`.
- `lem:graded_subquotient_ker_coker` → `def:graded_subquotientHilb`, split G1,
  `lem:ideal_homogeneous_span_mathlib`,
  `lem:isHomogeneousElem_graded_smul_mathlib`.
- `lem:graded_subquotient_finite_transfer` → `def:graded_subquotientHilb`,
  `lem:graded_subquotient_ker_coker`,
  `lem:fg_restrictScalars_of_surjective_mathlib`.

## References consulted
- `references/hilbert-serre-algebra.tex` — verbatim `% SOURCE QUOTE PROOF` for
  `lem:graded_subquotient_degreewise_diff` (Stacks 00K1 degreewise SES,
  L13939–L13947) and for `lem:graded_subquotient_isRatHilb` (Stacks 00K1
  induction set-up, L13908–L13914). The existing Stacks/Nitsure/Hartshorne quotes
  on the kept blocks were preserved verbatim, not re-fabricated.

## Macros needed
None. `\smash`, `\hat`, `\bigsqcup`, `\operatorname` are standard; `$…$` in
environment titles matches the chapter's existing convention.

## Reference-retriever dispatches
None.

## Notes for Plan Agent
- The iter-017 QUOT prover must CREATE the five new `AlgebraicGeometry.GradedModule.*`
  decls (`subquotientHilb`, `subquotient_ker_coker`, `subquotient_degreewise_diff`,
  `subquotient_finite_transfer`, `subquotient_hilbertSeries_rational`); the two
  split-G1 decls (`homogeneousSubmodule_inf_iSupIndep`,
  `homogeneousSubmodule_iSup_inf_eq`) already landed (one public, one private).
  If the prover needs `homogeneousSubmodule_iSup_inf_eq` public, that is a Lean-side
  visibility change, not a blueprint change.
- I reused the existing `fg_restrictScalars_of_surjective_mathlib` anchor for the
  finiteness transfer and did **not** add new `Module.Finite.quotient` /
  `Submodule.comap` anchors (directive listed them only as optional "e.g."), to
  avoid an unverified `\mathlibok`. If the prover finds the transfer needs a
  distinct Mathlib lemma, the review agent can add an anchor then.

## Strategy-modifying findings
None. Route 2 is a Lean-realization change within the existing strategy; the
mathematics (Stacks 00K1 induction) is unchanged.
