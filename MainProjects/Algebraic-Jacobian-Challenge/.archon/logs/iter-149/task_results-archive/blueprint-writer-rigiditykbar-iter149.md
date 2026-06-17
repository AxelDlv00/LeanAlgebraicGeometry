# Blueprint Writer Report

## Slug
rigiditykbar-iter149

## Status
COMPLETE — all four directive items landed.

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

### 1. Promoted the four (S3.*) sub-claims to first-class lemma blocks
Inserted four new `\begin{lemma}` blocks immediately before
`lem:constants_integral_over_base_field`, each with `\label{}`, `\lean{}`
hint, `\uses{}` field (where applicable), statement, scope sentence, and a
proof sketch ending in an `\emph{Literature.}` citation block:

- **Added lemma** `\label{lem:S3_sep_1_smooth_geometrically_reduced_Gamma}`
  / `\lean{AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth}` —
  smooth proper $\Rightarrow$ $\Gamma$ geometrically reduced over $k$.
  Proof sketch built from Stacks Tags **0334** + **04QM** + flat base
  change identification to \cref{lem:S3_pi_1_...}.
  `\uses{}` empty on the lemma block (gateway sub-claim, per directive);
  proof block declares `\uses{lem:S3_pi_1_...}` for depgraph correctness.
  - Proof sketch added: Y; ~80–150 LOC envelope.
- **Added lemma** `\label{lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable}`
  / `\lean{Algebra.IsSeparable.of_isGeometricallyReduced_of_finite}` —
  geometrically reduced finite field extension is separable.
  Proof sketch via Artinian decomposition + embedding count, citing Stacks
  Tag **0BJF** + Bourbaki *Algèbre* V §15 N° 3.
  `\uses{lem:S3_sep_1_...}` on both lemma and proof blocks.
  - Proof sketch added: Y; ~30–50 LOC envelope.
- **Added lemma** `\label{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}`
  / `\lean{AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper}` —
  flat base change of $\Gamma$ for proper schemes ($\Gamma(X) \otimes_k K
  \cong \Gamma(X_K)$).
  Proof sketch via Čech equaliser + Stacks Tag **00DS** flat-base-change-for-affines
  chart-by-chart, with an in-proof *Honesty note* explicitly recording
  that this is the SAME content as path (a) step (e), not bypassed by
  path (b). Cites the literature-crosscheck-iter149.md finding.
  `\uses{}` empty (per directive); load-bearing sub-claim.
  - Proof sketch added: Y; ~150–250 LOC envelope.
- **Added lemma** `\label{lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange}`
  / `\lean{Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange}` —
  finite field ext with unique-minimal-prime base-change to $\bar k$ is
  purely inseparable.
  Proof sketch via Artinian-local + algebraically-closed-residue-field
  argument, citing Stacks Tag **05DH** + Bourbaki *Algèbre* V §7 N° 7.
  `\uses{lem:S3_pi_1_...}` on both lemma and proof blocks.
  - Proof sketch added: Y; ~50–100 LOC envelope.

### 2. Restructured the (p2) primary path of KDM as an itemized list with (BR.1)–(BR.5) labels
- **Revised** the (p2) primary-path paragraph inside the proof of
  `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` — replaced
  the single monolithic paragraph with an `\item[(BR.1)]` … `\item[(BR.5)]`
  itemized list mirroring the existing (p1.a)–(p1.f) structuring.
  - **(BR.1)** Signature inflation `[CharZero k] + [IsStandardSmoothOfRelativeDimension k B n]` — signature edit only.
  - **(BR.2)** Basis selection via `Algebra.IsStandardSmooth.free_kaehlerDifferential` (existing Mathlib lemma; ~0 LOC).
  - **(BR.3)** Coefficient-derivation extraction `∂_i : B → B`; suggested
    Lean target `KaehlerDifferential.coordinateDeriv`; ~30–50 LOC.
  - **(BR.4)** `Differential B` instance per `∂_i`; suggested target
    `KaehlerDifferential.coordinateDerivDifferentialInstance`; ~10–20 LOC.
  - **(BR.5)** `Differential.ContainConstants` instance in `CharZero + IsStandardSmooth`;
    suggested target `KaehlerDifferential.coordinateDeriv_containConstants_of_charZero`;
    ~40–80 LOC.
  - Added a wrap-up paragraph after (BR.5) explaining how the sub-steps
    compose to close the (p2) forward direction (aggregate ~80–150 LOC),
    and an explicit note that (BR.3)–(BR.5) are *not* promoted to
    first-class blueprint lemmas (they live inside the (p2) proof body).
  - The strategy-critic CHALLENGE on `Differential.ContainConstants`
    parametrisation (abstract `Differential B`, *not* universal
    `KaehlerDifferential.D`) is now spelled out inline, with the (BR.3)–(BR.5)
    bridge explicitly labelled as project-internal infrastructure, not
    Mathlib infrastructure.

### 3. Added Stacks Tag + literature citations as `\emph{Literature.}` blocks
- **Revised** `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` proof —
  added `\emph{Literature.}` block citing Stacks Tags **0334**, **04QM**, Hartshorne III.10.
- **Revised** `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`
  proof — added `\emph{Literature.}` block citing Stacks Tag **0BJF**,
  Bourbaki *Algèbre* V §15 N° 3.
- **Revised** `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper` proof —
  added `\emph{Literature.}` block citing Stacks Tags **02KH**, **0AY8**,
  Hartshorne III.9.3.
- **Revised** `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`
  proof — added `\emph{Literature.}` block citing Stacks Tags **05DH**,
  **030V**, Bourbaki *Algèbre* V §7 N° 7.
- **Revised** `lem:constants_integral_over_base_field` proof — appended a
  final `\emph{Literature.}` block citing Stacks Tag **0BUG**, Stacks
  Tag **02KH**, Hartshorne III.5.2, with cross-refs to the four (S3.*)
  sub-claims as path (b)'s factorisation.
- **Revised** `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  proof — appended a final `\emph{Literature.}` block citing Stacks Tag
  **07F4** (the char-`p` Cartier-direction inclusion), Eisenbud
  *Commutative Algebra with a View Toward Algebraic Geometry* §16, and
  Mathlib's `Differential.ContainConstants` class, with explicit note
  that the (BR.1)–(BR.5) bridge is project-internal infrastructure.

### 4. Revised path (b) framing — replaced the iter-148 NOTE block
- **Revised** the NOTE block at the head of the proof of
  `lem:constants_integral_over_base_field` (formerly L2030–2066). The new
  block is iteration-agnostic (no "iter-148 review" prefix), trims the
  inline restatement of the four (S3.*) sub-claims down to single-sentence
  `\cref{}` cross-references (now that the sub-claims are first-class
  citizens just above the lemma), and explicitly retracts the
  "path (b) bypasses step (e)" framing, replacing it with "path (b)
  re-packages the flat-base-change content of step (e) into a single
  named Mathlib request". Cites
  `references/literature-crosscheck-iter149.md` § Target 1, bullet
  "Implication for iter-149+ plan", as the literature-cross-check
  authority for the retraction.
- Also added a brief one-sentence parenthetical to the chain's
  introductory paragraph (just before the `\begin{enumerate}` of steps
  (a)–(g)) reinforcing the path-(b) re-packaging framing.

## Cross-references introduced
- `\uses{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}` added in
  proof of `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` — verify
  `lem:S3_pi_1_...` exists in this same chapter (it does).
- `\uses{lem:S3_sep_1_smooth_geometrically_reduced_Gamma}` added on both
  the lemma and proof blocks of `lem:S3_sep_2_...` — verified.
- `\uses{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}` added on
  both the lemma and proof blocks of `lem:S3_pi_2_...` — verified.
- `\uses{lem:S3_sep_1_..., lem:S3_sep_2_..., lem:S3_pi_1_..., lem:S3_pi_2_...}`
  added on the proof block of `lem:constants_integral_over_base_field`
  (so the depgraph records path (b)'s consumption of all four sub-claims)
  — all four `\label{}`s verified present in this chapter.
- The lemma block of `lem:constants_integral_over_base_field` itself was
  *not* given a `\uses{}` field; the dependency lives at the proof-block
  level, consistent with the existing pattern on
  `lem:chart_algebra_df_zero_factors_through_constant_on_chart`.

Verified by `awk` that `\begin/\end` pairs balance:
- `lemma` 20/20, `theorem` 4/4, `proof` 23/23, `itemize` 18/18,
  `enumerate` 8/8.

## Macros needed (if any)
None. All commands used (`\cref`, `\emph`, `\texttt`, `\mathtt`,
`\mathrm`, `\textbf`, `\Spec`, `\Gamma`-shapes) are already in use
throughout this chapter.

## Reference-retriever dispatches (if any)
None — the directive's authoritative reference
(`references/literature-crosscheck-iter149.md`) was already present in the
project's `references/` directory and supplied every Stacks Tag / Bourbaki
section / Hartshorne / Eisenbud citation used in the new prose. No
additional source was needed.

## Notes for Plan Agent
- The new `\lean{}` hints for the four (S3.*) lemmas
  (`AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`,
  `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`,
  `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`,
  `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`) name target
  Lean declarations that do not yet exist in
  `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (or anywhere in the
  Lean tree). This is expected — the directive established these targets
  for the iter-149+ prover lane to attach to. The `sync_leanok` phase
  will leave these blocks unleaned until the Lean declarations land; the
  review agent will add `\mathlibok` if any of the four are later
  realized as thin Mathlib aliases rather than in-tree project lemmas.
- Naming asymmetry: the four (S3.*) `\lean{}` hints span two namespaces
  — `AlgebraicGeometry.*` for the two scheme-facing lemmas (S3.sep.1 and
  S3.pi.1) and `Algebra.*` for the two purely-commutative-algebra lemmas
  (S3.sep.2 and S3.pi.2). This matches the iter-149 directive's stated
  namespaces and the existing chapter conventions on similar lemmas; the
  prover may adjust namespaces to match the project's
  `AlgebraicGeometry.GrpObj.*` / `AlgebraicGeometry.*` conventions if
  needed.
- The chart-algebra piece (ii) decomposition section is now ~390 LOC long
  (from L1828 to ~L2400). Splitting into a separate file is *not*
  warranted yet: the section still composes a coherent shared pile per
  the chapter's existing structure. But this is a watchpoint — if
  iter-150+ adds more first-class lemma blocks, a sub-file split may
  become attractive.
- The (BR.3)–(BR.5) sub-steps are intentionally left as proof-body items
  per the directive ("they live as sub-steps inside the (p2) bridge proof
  ... A prover that wants per-sub-step Lean lemmas can extract them
  locally"). If a future iter wants per-sub-step depgraph edges, a
  promotion round on these three would parallel the (S3.*) promotion
  done here.

## Strategy-modifying findings
None. Writing this chapter did not surface any strategy-level issue
beyond what the strategy-critic and the literature-crosscheck-iter149.md
already recorded. The path-(b) "does not bypass step (e)" finding was
explicitly absorbed into the chapter prose per directive instructions;
no new STRATEGY.md edit is implied by this writer's work.
