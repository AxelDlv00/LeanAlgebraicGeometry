# Blueprint Writer Report

## Slug

rigiditykbar-iter145

## Status

COMPLETE

## Target chapter

blueprint/src/chapters/RigidityKbar.tex

## Summary

Lifted the iter-144 chart-algebra envelope for piece (ii) (previously prose
bullets at L99--L114) into a new subsection
`\subsection{Chart-algebra piece (ii) first-class decomposition}` containing
five first-class declaration blocks with pre-committed Lean target names,
detailed proof sketches (5--8 steps each), and Mathlib status tags
([verified]/[expected]/[gap]). The subsection lands as a sibling to
`\subsection{Piece (i): sub-lemma decomposition for iter-128+ build}` inside
`\section{The shared cotangent-vanishing Mathlib pile}`, immediately before the
`Honest pile cost` summary paragraph. Chapter grew 1790 → 1963 lines (+173).

Per directive, no `\leanok` markers added or removed, no
`\mathlibok` markers touched, no macros defined; Edit 2 (stale `\leanok`
sync_leanok issues) skipped silently as instructed; Edit 3 (Step 3 descope
NOTE) already present at L882--L887 of the pre-edit chapter, no further work
needed.

## Changes Made

- **Added subsection** `\subsection{Chart-algebra piece (ii) first-class
  decomposition}` (`\label{subsec:RigidityKbar_piece_ii_chart_algebra_decomposition}`)
  inside `\section{The shared cotangent-vanishing Mathlib pile}`, after the
  piece (i) subsection and before the `Honest pile cost` summary. Intro
  paragraph orients the reader to the bottom-up dependency order of the five
  blocks. A second `\paragraph{Strategy-critic Q3 absorption (iter-145)}`
  block articulates the honest framing of what cohomological content the
  chart-algebra ($\beta$) helper invokes (option (a) of the iter-145
  strategy-critic dichotomy: $H^0(C, \Omega_{C/k}^{\oplus n}) = 0$ via a
  two-chart \v Cech / Mayer--Vietoris computation, reusing the project's
  existing `Cohomology_MayerVietoris.tex` infrastructure that already drives
  the $H^1(C, \mathcal O_C) = 0$ computation in `Genus.lean`; piece (iv)
  Serre duality remains a named-gap, but is not on the critical path).

- **Added lemma** `\label{lem:chart_algebra_isPushout_of_affine_product}`
  `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` —
  sub-piece ($\alpha$); affine-product `Algebra.IsPushout` helper.
  - Statement: for affine charts $U_1 = \Spec B_1, U_2 = \Spec B_2$ over
    $\Spec k$, the product chart $W = U_1 \times_k U_2$ identifies with
    $\Spec(B_1 \otimes_k B_2)$ and exhibits an
    `Algebra.IsPushout`\,$k$\,$B_1$\,$B_2$\,$B$ structure.
  - Proof sketch: 3 steps (`pullbackSpecIso` →
    `isPullback_SpecMap_of_isPushout` → `CommRingCat.isPushout_iff_isPushout`),
    with explicit Mathlib status [verified] for each lemma in snapshot
    `b80f227`.
  - LOC envelope: ~80--150.

- **Added theorem** `\label{lem:chart_algebra_df_zero_factors_through_constant_on_chart}`
  `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}`
  — sub-piece ($\beta$-core); the load-bearing per-chart translation-invariance
  K\"ahler-derivation helper.
  - Statement: for $f \colon C \to A$ in $\Over\,(\Spec k)$ with $\mathrm df = 0$,
    on chart pairs $(W = \Spec B \subseteq A.\mathrm{left}, V = \Spec R \subseteq
    C.\mathrm{left})$, the chart-restriction $f^{\sharp} \colon B \to R$
    factors through $k \hookrightarrow R$.
  - **Strategy-critic Q3 absorption (per directive)**: an explicit
    paragraph in the statement and the proof articulate that the helper
    invokes $H^0(C, \Omega_{C/k}^{\oplus g}) = 0$ via a two-chart Mayer--Vietoris
    computation on $\Omega_{C/k}^{\oplus g}$ (the cotangent variant of the
    project's $H^1(C, \mathcal O_C) = 0$ computation in `Genus.lean`),
    explicitly **not** as a named Serre-duality call. The "Serre duality is
    NOT invoked" disclaimer narrows to "the named Serre-duality theorem is
    not invoked; the cohomological content IS invoked via a chart-\v Cech
    computation".
  - Proof sketch: 5 steps (chart-level $\mathrm df = 0$ unpacks against
    standard-smooth basis → extend to all $b \in B$ → chart-\v Cech Mayer--Vietoris
    on $\Omega_{C/k}^{\oplus g}$ → ring-side kernel extraction via
    `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` →
    integrally-closed-constants closure via
    `constants_integral_over_base_field`).
  - LOC envelope: ~150--300; Step 3 (Mayer--Vietoris) is the dominant cost
    (~60--120 LOC).

- **Added lemma** `\label{lem:constants_integral_over_base_field}`
  `\lean{AlgebraicGeometry.constants_integral_over_base_field}` —
  sub-piece ($\beta$-aux); the constants-are-the-base-field wrapper.
  - Statement: for a smooth proper geometrically irreducible $X / k$,
    $\Gamma(X, \mathcal O_X) = \operatorname{range}(\mathtt{algebraMap}\,k\,\Gamma(X, \mathcal O_X)) \cong k$.
  - Proof sketch: 3 sub-facts (properness gives finite-dim $k$-algebra
    via coherent-pushforward; geometric irreducibility + reduced gives
    integral-domain $\Gamma$; finite integral domain over field → field,
    and the base-change identity
    $\Gamma(X, \mathcal O_X) \otimes_k \bar k \cong \Gamma(X_{\bar k}, \mathcal O_{X_{\bar k}}) = \bar k$
    forces $\dim_k = 1$).
  - LOC envelope: ~50--100.

- **Added theorem** `\label{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}`
  `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}`
  — sub-piece ($\beta$-core ring-side); the ring-level kernel-of-$D$
  characterisation.
  - Statement: for $B$ a finitely-generated $k$-algebra (or standard-smooth
    of relative dimension $n$) and $D \colon B \to \Omega_{B/k}$ the
    universal K\"ahler derivation, $D b = 0 \Rightarrow b \in
    \operatorname{range}(\mathtt{algebraMap}\,k\,B)$.
  - Proof sketch: case-split on characteristic. Char-0 via
    `Differential.ContainConstants` typeclass (~60--120 LOC). Char-$p$ via
    3-step Frobenius-iteration: (p1) `Cartier-isomorphism direction
    $\ker D = B^p$ (chart-side; marked [gap] in snapshot `b80f227` for the
    chart-finite finitely-generated case); (p2) Frobenius iteration via
    `RingHom.iterateFrobenius_comm`; (p3) descent to
    $\operatorname{range}(\mathtt{algebraMap}\,k\,B)$ via Frobenius-stability of the
    base-field image. Char-$p$ half is ~140--230 LOC, dominant cost.
  - LOC envelope: ~200--350 total.

- **Added theorem** `\label{lem:Scheme_Over_ext_of_diff_zero}`
  `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` — sub-piece
  (scheme-level lift); packages the chart-algebra chain into
  `Scheme.Over.ext_of_eqOnOpen` shape.
  - Statement: for $f, g \colon C \to A$ in $\Over\,(\Spec k)$ with
    $\mathrm df = \mathrm dg$ and agreement on a non-empty open
    $U \subseteq C$, $f = g$ globally. Specialises to the C.2.d
    keystone of `\thm{thm:rigidity_over_kbar}` when $g$ is the constant
    morphism at $\eta_A$.
  - Proof sketch: 3 steps (reduce to $h := \mu \circ \langle f, \iota \circ g \rangle$
    with $\mathrm dh = 0$ via K\"ahler additivity → chart-by-chart application of
    \cref{lem:chart_algebra_df_zero_factors_through_constant_on_chart} →
    constant value identification via Step 1's $U$-agreement and the
    $\GrpObj$ cancellation identity), then packaged via
    \cref{thm:GrpObj_eq_of_eqOnOpen}.
  - LOC envelope: ~100--150.

## Cross-references introduced

All `\uses{...}` references use labels that already exist in the project
blueprint (verified via grep against `blueprint/src/chapters/*.tex`):

- `\uses{def:relative_kaehler_presheaf}` (defined at
  `Differentials.tex:14`) — used by the ($\alpha$) helper.
- `\uses{lem:chart_algebra_isPushout_of_affine_product}` (defined in this
  edit) — used by ($\beta$-core), ($\beta$-core ring-side).
- `\uses{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}` (defined
  in this edit) — used by ($\beta$-core).
- `\uses{lem:constants_integral_over_base_field}` (defined in this edit) —
  used by ($\beta$-core).
- `\uses{thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact}`
  (defined at `Cohomology_MayerVietoris.tex:520`) — used by ($\beta$-core)
  proof for the Mayer--Vietoris Step 3.
- `\uses{thm:GrpObj_eq_of_eqOnOpen}` (defined at `Rigidity.tex:12`) — used
  by the scheme-level lift.
- `\uses{chap:Cohomology_MayerVietoris}` — used in the Q3 absorption notes
  (label defined at `Cohomology_MayerVietoris.tex:2`).

Forward `\cref` references inside the new subsection (e.g., a block citing
a later sibling block in `\uses{}`) are intentional — blueprint dependency
graphs handle forward references gracefully — and are documented in each
block's own `\uses{...}` line.

## Macros needed (if any)

None new; the chapter already uses `\Over`, `\Spec`, `\Hom`, `\GrpObj`,
`\genus`, `\Scheme`, `\CommRingCat`, `\Opens`, `\op`, `\struct`, all
defined in `blueprint/src/macros/common.tex` (or, per project convention
for `\fst`/`\snd`/`\pr`/`\Hom`/`\app`/`\obj`/`\Scheme`/`\GrpObj`, rendered
as their literal names — directive explicitly says not to touch macros).

## Reference-retriever dispatches (if any)

None. The directive named the Mathlib infrastructure pieces (`Algebra.IsPushout`,
`pullbackSpecIso`, `KaehlerDifferential.D`, `RingHom.iterateFrobenius_comm`,
`Algebra.IsStandardSmooth.free_kaehlerDifferential`,
`Scheme.Over.ext_of_eqOnOpen`) as already verified by the iter-145 planner;
no further reference-retriever consult required.

## Edit-by-edit disposition

- **Edit 1 (MAIN MUST-FIX)** — COMPLETE. All five first-class blocks lifted
  with pre-committed Lean target names, `\uses{...}` cross-references, and
  detailed proof sketches per directive. Q3 absorption articulated in the
  ($\beta$-core) block statement and proof per directive recommendation
  (option (a): cohomological content $H^0(C, \Omega_{C/k}^{\oplus n}) = 0$
  invoked via two-chart Mayer--Vietoris on $\Omega_{C/k}^{\oplus n}$,
  Serre duality not named).
- **Edit 2 (sync_leanok carry-overs)** — SKIPPED SILENTLY per directive (it
  states "the writer must NOT touch them").
- **Edit 3 (Step 3 sub-recipe descope NOTE)** — already present at
  L882--L887 of the pre-edit chapter (the `Iter-144 chart-algebra pivot
  disposition` block already declares the Step 3 chase DESCOPED with the
  one-sentence summary directive requested). No further work needed; this
  is consistent with the directive's "already present per iter-144 writer
  L882--L887 inline comment; if missing, surface explicitly" framing.

## Notes for Plan Agent

- The new subsection is internally consistent with the existing
  `\paragraph{Iter-144 chart-algebra envelope for piece (ii)}` block at
  L99--L114; the envelope's prose bullets and the new first-class blocks
  agree on the LOC envelopes (the new block-level estimates collectively
  sum to ~580--1050 LOC, inside the envelope's ~600--1050 total) and on the
  Mathlib references called out.
- The chart-algebra ($\beta$-core) helper's Step 3 (chart-\v Cech
  Mayer--Vietoris on $\Omega_{C/k}^{\oplus g}$) is a load-bearing
  cohomological invocation; the project's existing
  `Cohomology_MayerVietoris.tex` infrastructure is reused without
  modification. The plan agent may want to confirm in a later iter that
  the project's
  `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
  instantiates cleanly on $\Omega_{C/k}^{\oplus g}$ (the existing instance
  in `Genus.lean` is on $\mathcal O_C$, not $\Omega_{C/k}$). If a chart-side
  bridge to the cotangent case is needed, it is a small wrapper helper, not
  a new theorem.
- The ($\beta$-core ring-side) char-$p$ step (p1) (`Cartier-isomorphism
  direction $\ker D = B^p$ for a standard-smooth chart-finite $k$-algebra
  in char $p$`) is flagged as a Mathlib [gap] in snapshot `b80f227` per
  the proof sketch. The plan agent may want to add this to STRATEGY.md's
  shared-pile build inventory as a sub-gap of piece (ii) (~30--60 LOC)
  that the iter-146+ prover lane must close in-tree before the
  ($\beta$-core ring-side) helper is provable.
- The new subsection brings the chapter to 1963 lines (from 1790; +173 LOC
  of LaTeX). The chapter is now visibly large; a future split into
  `RigidityKbar_ChartAlgebraPieceII.tex` (or similar) is a reasonable
  refactor candidate, but is out of scope for this iter.

## Strategy-modifying findings

None.

The Q3 contradiction flagged by the iter-145 strategy-critic in STRATEGY.md
L441--L445 is absorbed at the blueprint level by the explicit articulation
inside \cref{lem:chart_algebra_df_zero_factors_through_constant_on_chart}'s
statement and proof. The honest framing is now: "the named Serre-duality
theorem is not invoked; the cohomological content $H^0(C, \Omega_{C/k}) = 0$
on a genus-$0$ curve IS invoked via a two-chart \v Cech computation matching
the project's $H^1(C, \mathcal O_C) = 0$ idiom in `Genus.lean`". The plan
agent may want to mirror this clarification into STRATEGY.md L441--L445
to align the two documents, but this is a clarification (not a
strategy-modifying finding) and does not gate any further Lean work this
iter.
