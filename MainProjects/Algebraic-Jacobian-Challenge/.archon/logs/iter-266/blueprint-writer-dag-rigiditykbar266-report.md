# Blueprint Writer Report

## Slug
dag-rigiditykbar266

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made
- **Added proof block** for `thm:rigidity_over_kbar` — inserted a
  `\begin{proof} ... \end{proof}` immediately after `\end{theorem}` (and before
  `rem:rigidity_over_kbar_dim_dichotomy`, which now sits below the proof). The
  theorem previously had a full statement + `\section{Proof decomposition}` but
  **no proof environment**, so leandag saw an empty body and the node was an
  ∞-node (isolated). The new proof is a faithful high-level assembly of the
  existing decomposition:
  - **(C.2.b)** reduction to the project's rigidity lemma
    `thm:GrpObj_eq_of_eqOnOpen` (reduced source `C` smooth, separated target
    `A` proper);
  - **(C.2.c)** image-dimension dichotomy via
    `rem:rigidity_over_kbar_dim_dichotomy` (g=0 vacuous; image is a point or
    1-dimensional);
  - **(C.2.d)** keystone "proper rational curves on an abelian variety are
    constant", reduced to `df = 0`, presented as a global-sections fact:
    group-cotangent triviality (piece (i), `lem:GrpObj_omega_free` +
    `lem:GrpObj_omega_rank_eq_dim`, resting on `lem:GrpObj_cotangentSpace` and
    `lem:GrpObj_lieAlgebra_finrank`) gives `f^*Ω_{A/k̄} ≅ O_C^{⊕g}`, so
    `df = 0 ⟺ H^0(C,Ω)=0` (piece (iv), via the two-chart Čech/Mayer–Vietoris
    computation `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`,
    **not** a packaged Serre-duality theorem). Stated **conditionally on the
    route (a)/(b) gating choice** per the directive. The converse
    `df = 0 ⇒ f constant` (piece (ii)) is supplied by
    `lem:chart_algebra_df_zero_factors_through_constant_on_chart` (delegating to
    KDM `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` and
    `lem:constants_integral_over_base_field`) and globalised by
    `lem:Scheme_Over_ext_of_diff_zero`. The `[CharZero kbar]` / `[IsAlgClosed
    kbar]` hypotheses are tied to exactly where those two helpers consume them
    (char-0 makes the piece-(iii) Frobenius layer vacuous; alg-closed collapses
    the constants lemma).
  - **(C.2.e)** promotion of set-level to scheme-morphism equality, integrated
    into the `thm:GrpObj_eq_of_eqOnOpen` application.
  - Proof shape: ~115 lines, mathematical prose only, no Lean tactics, **no
    `\leanok`** (the Lean body remains a gated named gap / `sorry`).

## Cross-references introduced
The proof's `\uses{}` lists 11 labels; all resolve (leandag `unknown_uses: []`):
- `thm:GrpObj_eq_of_eqOnOpen` — cross-chapter, in `Rigidity.tex` (verified present).
- `rem:rigidity_over_kbar_dim_dichotomy` — this chapter.
- `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`,
  `lem:GrpObj_cotangentSpace`, `lem:GrpObj_lieAlgebra_finrank` — piece (i),
  this chapter.
- `lem:Scheme_Over_ext_of_diff_zero`,
  `lem:chart_algebra_df_zero_factors_through_constant_on_chart` — piece (ii),
  this chapter.
- `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
  `lem:constants_integral_over_base_field` — KDM + constants, this chapter.
- `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` — cross-chapter,
  in `Cohomology_MayerVietoris.tex` (verified present); the H^0(C,Ω)=0
  cohomological input (piece (iv)).

leandag build: no conflicts, no unknown_uses; `thm:rigidity_over_kbar` is no
longer isolated (verified via `leandag query --isolated --chapter RigidityKbar`).

## References consulted
None opened this session. No new citation block was authored: the proof is a
project-internal **assembly** of the chapter's own decomposition (C.2.b–C.2.e +
shared cotangent pile pieces (i)–(iv)), all of which already live in the
chapter. The keystone classical input (C.2.d) is attributed to Mumford,
*Abelian Varieties*, II §4, which is **unbundled (paywalled)** — the existing
`% SOURCE` / `\textit{Source: Mumford, Abelian Varieties, II §4.}` lines were
left exactly as-is, and a `% SOURCE QUOTE PROOF:` comment was added that
explicitly records the quote is **not retrieved** (no fabricated verbatim text),
per citation discipline.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Piece (iv) has no `\label` of its own.** The Serre-duality / genus-0
  H^0(C,Ω)=0 bullet at `sec:RigidityKbar_shared_pile` item (iv) (≈L120) is prose
  inside an `itemize`, not a labelled declaration. I therefore anchored the
  H^0=0 input on the cohomological-content provider actually invoked by the
  chart-Čech route — the cross-chapter
  `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` — plus the
  in-chapter `lem:chart_algebra_df_zero_factors_through_constant_on_chart` that
  consumes it. If you want piece (iv) to appear as a first-class DAG node, it
  needs its own labelled `\lemma` block (a "genus-0 cotangent cohomology
  vanishing" statement); that is a structural add beyond this directive's scope.
- The proof is stated **conditionally on the route (a)/(b) choice** as directed;
  it does not commit to either. The `\uses{}` deliberately points only at
  declarations that exist today, so the node is finite regardless of which route
  is eventually built.
- The theorem statement, the iter-152 alg-closed-pivot prose, and all `% SOURCE`
  blocks were left untouched.

## Strategy-modifying findings
None.
