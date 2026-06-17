# Blueprint-writer directive — QUOT graded-rationality re-skeleton to Route 2 (iter-016)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (edit ONLY this file).

## Read first (source of truth)
`analogies/quot-hilbert-function-route.md` — the mathlib-analogist's iter-016 verdict.
It replaces the iter-014 G1–G5 plan with **Route 2: an ambient subquotient induction**
that structurally eliminates the `isDefEq`/`whnf` runaway that blocked G2–G4 in iter-015
(non-terminating at 2M heartbeats — see `memory/graded-quotient-module-isdefeq-pathology.md`).
Your job is to re-skeleton the chapter's graded-rationality machinery around that route.
Follow its "Residual build list (Route 2), ordered" (items 1–6) as the new block structure.

## Why this change (context, do not transcribe verbatim)
The old proof of `lem:gradedHilbertSerre_rational` builds `K = ker x` and `C = M/xM` as
graded modules over the quotient ring `R/(x)` (blocks G2/G3/G4). Instantiating the
inductive hypothesis on those carriers forces a `DirectSum.Decomposition` on a
quotient/subtype module — the toxic case. Route 2 ranges the induction over **pairs of
homogeneous submodules `N' ≤ N` of a single FIXED ambient graded `κ`-module `M`** with
`r` pairwise-commuting degree-+1 `κ`-endomorphisms preserving `N`, `N'`; the Hilbert
function is the AMBIENT difference `n ↦ dim_κ(N ⊓ ℳn) − dim_κ(N' ⊓ ℳn)`. The class is
closed under ker/coker of a degree-1 endo (both expressed as ambient subquotient pairs),
so no derived-carrier graded object is ever formed. Every object has the shape
`fun n => Naux ⊓ ℳ n` — exactly what the landed G1 proved safe.

## Edits required

### A. KEEP (landed / still valid)
- The statement of `lem:gradedHilbertSerre_rational` (~L346) is UNCHANGED (same Lean pin
  `AlgebraicGeometry.gradedModule_hilbertSeries_rational`, same conclusion). Only its
  PROOF, its `\uses{}`, and its `% NOTE`/`Status` paragraph change (see C).
- The two landed G1 halves and D5 (see B for the G1 pin split).
- All Mathlib dependency anchors that Route 2 still uses: `submodule_isHomogeneous_mathlib`,
  `ideal_homogeneous_span_mathlib`, `finrank_range_add_finrank_ker_mathlib`,
  `fg_restrictScalars_of_surjective_mathlib`, `isHomogeneousElem_graded_smul_mathlib`. KEEP
  their `\mathlibok`.

### B. SPLIT the G1 block (HIGH #3 — pin currently names a non-existent decl)
Replace the single `lem:graded_homogeneousSubmodule_decomposition` block (~L870, whose pin
`...homogeneousSubmodule_decomposition` does NOT exist) with TWO blocks matching the landed
axiom-clean decls:
- `\label{lem:graded_homogeneousSubmodule_iSupIndep}` /
  `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep}` — the
  independence half: the family `n ↦ ℳn ⊓ p` is `iSupIndep`.
- `\label{lem:graded_homogeneousSubmodule_iSup_eq}` /
  `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq}` — the supremum
  half: for `p` homogeneous, `⨆ n, (ℳn ⊓ p) = p`.
Together they are "the internal direct sum `p = ⨁ (ℳn ⊓ p)`", stated AMBIENT in `M`
(no `Decomposition ↥p`). Drop the old NOTE comment. Update any `\cref` that pointed at
`lem:graded_homogeneousSubmodule_decomposition` to the appropriate new label.

### C. RE-SKELETON the proof of `lem:gradedHilbertSerre_rational`
- Rewrite `\begin{proof}…\end{proof}` (~L408–491) so it proves the result by instantiating
  the new ambient-subquotient induction lemma (Route 2 item 6) at `(N,N') = (⊤,⊥)`, with
  the `r` endos = multiplication by a κ-basis of `R₁` (the degree-1 generators; cite the
  existing degree-1-generation NOTE at L429–435 for where `r` comes from). The κ-dimension
  `dim_κ Mₙ = dim_κ(⊤ ⊓ ℳn) − dim_κ(⊥ ⊓ ℳn)` is the ambient hilb of the `(⊤,⊥)` pair.
- Update the proof `\uses{}` (and the statement `\uses{}` at L349) to the Route 2 blocks:
  drop `lem:graded_quotient_decomposition`, `lem:graded_quotientRing_gradedRing`,
  `lem:graded_regrade_over_quotient`; add the new Route 2 lemma labels (B + D below) plus
  the retained `def:ratHilb, lem:ratHilb_ofEventuallyZero, lem:ratHilb_ofDiffEq,
  lem:ratHilb_bump, lem:graded_degreewise_finrank_diff`, the split G1 labels, and
  `lem:ideal_homogeneous_span_mathlib`, `lem:isHomogeneousElem_graded_smul_mathlib`,
  `lem:fg_restrictScalars_of_surjective_mathlib`.
- Update the `Status`/`% NOTE` paragraph (~L384–394): the Mathlib gap is now AVOIDED by the
  ambient subquotient route (no graded quotient ring / quotient-module Decomposition is
  built); the residual is the short ambient bookkeeping build of D below. Keep the SOURCE
  QUOTE / SOURCE QUOTE PROOF comments (Stacks 00K1) intact — the math is the same Stacks
  induction, only the Lean realization changed.

### D. DROP G2/G3/G4; ADD the Route 2 blocks
- DELETE blocks `lem:graded_quotient_decomposition` (G2, ~L916), `lem:graded_quotientRing_gradedRing`
  (G3, ~L950), `lem:graded_regrade_over_quotient` (G4, ~L979). Their `\lean{}` pins name
  decls that were never built; nothing on the Lean side corresponds, so removal is clean.
  Also DROP the now-unused `lem:quotSMulTop_mathlib` anchor (~L799) IF nothing else cites it
  (Route 2 uses the ambient identity `x·M ⊓ ℳn = x·ℳ(n-1)`, not `QuotSMulTop`); if some
  other block still `\uses` it, keep it.
- REPLACE the old G5 block `lem:graded_finite_transfer` (~L1012) with the **ambient**
  finiteness-transfer (Route 2 item 4): the two ambient subquotients (`N⊓x⁻¹(N')` over `N'`,
  and `N` over `N'+x·N`) are f.g. over `κ[t_0,…,t_{r-2}]` via Noetherian + `Submodule.FG`
  + annihilation by `x` (`Submodule.FG.restrictScalars_of_surjective`, `Module.Finite.quotient`).
  Keep an `R/(x)`-free statement — finiteness is about ambient submodules, never a
  derived-carrier grading. Choose a fresh label/pin
  `\label{lem:graded_subquotient_finite_transfer}` /
  `\lean{AlgebraicGeometry.GradedModule.subquotient_finite_transfer}`.
- KEEP D5 `lem:graded_degreewise_finrank_diff` (~L1041, landed). Update its prose `\cref`s
  that referenced the dropped G2/old-G1 to the split-G1 labels.
- ADD new Route 2 blocks (tex precedes Lean — the iter-017 QUOT prover will CREATE these
  `AlgebraicGeometry.GradedModule.*` decls; give each `\label`, `\lean{}`, accurate `\uses{}`,
  statement, and a textbook informal proof; do NOT add `\leanok`):
  1. **SubquotientHilb data + ambient hilb** — `\label{def:graded_subquotientHilb}`,
     `\lean{AlgebraicGeometry.GradedModule.subquotientHilb}`: fixed `ℳ` with
     `[DirectSum.Decomposition ℳ]`, finite-dim components; homogeneous `N' ≤ N ⊆ M`;
     commuting degree-+1 endos `t : Fin r → M →ₗ[κ] M` preserving `N`,`N'`; `Module.Finite`
     witness; `hilb n := ((finrank κ ↥(N ⊓ ℳn) : ℤ) − finrank κ ↥(N' ⊓ ℳn))` cast to ℚ.
     Uses the split G1.
  2. **ker/coker closure** — `\label{lem:graded_subquotient_ker_coker}`,
     `\lean{AlgebraicGeometry.GradedModule.subquotient_ker_coker}`: build the two
     subquotient pairs `K = ker x ↦ (N ⊓ x⁻¹(N'), N')` and `C = coker x ↦ (N, N'+x·N)`;
     prove homogeneity of `N ⊓ x⁻¹(N')` and `N'+x·N` (split G1 +
     `isHomogeneousElem_graded_smul_mathlib`), that the remaining endos preserve them, and
     that `x` kills both. (NOTE: subquotients, not submodules — `xN` is not killed by `x`,
     so `IsRatHilb.sub` on `h_N − h_{xN}` is unavailable; the closure is exactly subquotients.)
  3. **Degreewise difference D6** — `\label{lem:graded_subquotient_degreewise_diff}`,
     `\lean{AlgebraicGeometry.GradedModule.subquotient_degreewise_diff}`: identify the
     component dims of the K/C subquotients with `ker(x:ℳn→ℳ(n+1))` and `ℳ(n+1)/im x`, then
     apply the landed D5 to get `hilb_M(n+1) − hilb_M(n) = hilb_C(n+1) − hilb_K(n)`.
     Uses D5 + split G1.
  4. (the finiteness transfer of D's third bullet — `lem:graded_subquotient_finite_transfer`).
  5. **The induction P(r)** — `\label{lem:graded_subquotient_isRatHilb}`,
     `\lean{AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational}`: by induction
     on `r`, `IsRatHilb (subquotientHilb …) r`. Base `r=0` via `IsRatHilb.ofEventuallyZero`
     (finite-dim subquotient ⇒ hilb eventually 0); step via blocks 2+3+4 feeding the landed
     `IsRatHilb.ofDiffEq` + `IsRatHilb.bump`. This is the lemma `lem:gradedHilbertSerre_rational`
     instantiates at `(⊤,⊥)`.

## Citation discipline
Keep the existing `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` (Stacks 00K1,
Nitsure §1, Hartshorne I.7) — the mathematics is unchanged. The new ambient-subquotient
blocks are a project-bespoke Lean realization of the SAME Stacks induction; their informal
proofs stand on the sketch (cite Stacks 00K1 where the SES `0→Mₙ→M_{n+1}→C_{n+1}→0` is used).
Record Mathlib lemma names in `% LEAN DEPS:` comments, not in rendered prose.

## Markers
Do NOT add or remove `\leanok`. You MAY mark `\mathlibok` only on genuine Mathlib
dependency anchors (the kept anchors already are; if you add a new anchor, e.g.
`Module.Finite.quotient` or `Submodule.comap`, verify it exists in Mathlib via loogle
before marking).

## Out of scope
- `def:hilbert_polynomial`, `def:sectionGradedRing`, the QUOT-defs stubs, GR blocks.
- Do not touch other chapters.
