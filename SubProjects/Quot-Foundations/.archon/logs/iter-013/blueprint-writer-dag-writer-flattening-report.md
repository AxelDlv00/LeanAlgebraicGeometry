# Blueprint Writer Report

## Slug
dag-writer-flattening

## Status
COMPLETE

All 11 Nagata-machinery helper declarations now have concise blueprint blocks, each with
`\label`/`\lean`/`\uses` and a short proof or "Proved directly in Lean." note. They are
wired (both ways) into the existing GF Nagata lemmas. `leandag build --json` reports zero
`unknown_uses`, zero unmatched-lean for the `GenericFreeness` cluster, and zero isolated
nodes in this chapter.

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made
Added a new subsubsection `\label{sec:gf_nagata_machinery}` ("Nagata change-of-variables
machinery") immediately before `lem:gf_nagata_monic_lastVar`, containing 11 blocks:

- **Added definition** `def:gf_nagata_T1` / `\lean{…GenericFreeness.T1}` — the parametrized
  Nagata substitution `X_0 ↦ X_0`, `X_i ↦ X_i + c·X_0^{r_i}` (`i≠0`), `r_i = up^i`,
  `up = 2 + totalDegree f`. Source pointer added. (Directive's "X_0 ↦ X_0 + c" description
  was inaccurate; I followed the actual Lean def as instructed.)
- **Added lemma** `lem:gf_t1_comp_t1_neg` / `t1_comp_t1_neg` — `T_1(c) ∘ T_1(-c) = id`.
  `\uses{def:gf_nagata_T1}`. Short sketch.
- **Added definition** `def:gf_nagata_T` / `T` — automorphism `T := T_1(1)` with inverse
  `T_1(-1)`. `\uses{def:gf_nagata_T1, lem:gf_t1_comp_t1_neg}`. Source pointer added.
- **Added lemma** `lem:gf_lt_up` / `lt_up` — exponent-bound bookkeeping. "Proved directly
  in Lean."
- **Added lemma** `lem:gf_sum_r_mul_ne` / `sum_r_mul_ne` — injectivity of the base-`up`
  radix encoding. `\uses{lem:gf_lt_up}`.
- **Added lemma** `lem:gf_degreeOf_zero_t` / `degreeOf_zero_t` — `X_0`-degree of
  `T(a·X^v)` equals `∑ r_i v_i`. `\uses{def:gf_nagata_T}`.
- **Added lemma** `lem:gf_degreeOf_t_ne_of_ne` / `degreeOf_t_ne_of_ne` — distinct support
  monomials get distinct `X_0`-degrees under `T`. `\uses{lem:gf_degreeOf_zero_t,
  lem:gf_sum_r_mul_ne}`.
- **Added lemma** `lem:gf_leadingCoeff_finSuccEquiv_t` / `leadingCoeff_finSuccEquiv_t` —
  leading coeff (in `X_0`) of `T(c_v X^v)` is the constant `c_v`. `\uses{def:gf_nagata_T,
  def:gf_nagata_T1}`.
- **Added lemma** `lem:gf_T_leadingcoeff_eq` / `T_leadingcoeff_eq` — for `f≠0`, leading
  coeff of `T(f)` is `C(c_v)` for the unique top monomial `v` (`c_v ≠ 0`), so `T(f)` is
  monic up to a unit. `\uses{lem:gf_degreeOf_t_ne_of_ne, lem:gf_leadingCoeff_finSuccEquiv_t}`.
- **Added lemma** `lem:gf_finSuccEquiv_map_comm` / `finSuccEquiv_map_comm` — naturality of
  `finSuccEquiv` under coefficientwise `map φ`. "Proved directly in Lean by induction."
- **Added lemma** `lem:gf_finSuccEquiv_rename_succ` / `finSuccEquiv_rename_succ` —
  `finSuccEquiv(rename succ s) = C(s)`. "Proved directly in Lean by induction."

- **Fixed dependencies** `lem:gf_nagata_monic_lastVar` — was missing any `\uses{}`; added
  `\uses{def:gf_nagata_T, lem:gf_T_leadingcoeff_eq, lem:gf_finSuccEquiv_map_comm}` (matches
  the Lean proof, which invokes `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, and uses the
  automorphism `T F`).
- **Fixed dependencies** `lem:gf_mvPolynomial_quotient_finite_monic` — appended
  `lem:gf_finSuccEquiv_rename_succ` to the existing `\uses{}` (the Lean proof calls
  `finSuccEquiv_rename_succ`).

`gf_torsion_reindex` was checked: its Lean proof calls only `gf_torsion_annihilator`,
`gf_nagata_monic_lastVar`, and `mvPolynomial_quotient_finite_of_monic_lastVar` — none of
the new raw helpers — so no new edge was added there (its existing `\uses{}` is correct).

## Cross-references introduced
All new `\uses{}` targets resolve within this same chapter (verified by `leandag`: zero
`unknown_uses`). Edge spine: `def:gf_nagata_T1` → `lem:gf_t1_comp_t1_neg` →
`def:gf_nagata_T` → {`degreeOf_zero_t`, `leadingCoeff_finSuccEquiv_t`}; `lt_up` →
`sum_r_mul_ne`; {`degreeOf_zero_t`,`sum_r_mul_ne`} → `degreeOf_t_ne_of_ne`;
{`degreeOf_t_ne_of_ne`,`leadingCoeff_finSuccEquiv_t`} → `T_leadingcoeff_eq` →
`gf_nagata_monic_lastVar`; `finSuccEquiv_map_comm` → `gf_nagata_monic_lastVar`;
`finSuccEquiv_rename_succ` → `gf_mvPolynomial_quotient_finite_monic`.

## Verification (leandag)
- Before: `blueprint_nodes 104`, `lean_aux_nodes 44`, `isolated 44`.
- After:  `blueprint_nodes 115` (+11), `lean_aux_nodes 33` (−11, all helpers now matched),
  `isolated 33` (−11), `edges 176` (+15).
- `unknown_uses: []`; no `GenericFreeness` decl remains unmatched-lean.
- `leandag query --isolated --chapter Picard_FlatteningStratification` → 0 results; none of
  the new helper labels appear in `leandag show isolated`.
- LaTeX balance verified: `definition` 2/2, `lemma` 30/30, `theorem` 2/2, `proof` 27/27.

## References consulted
No new external citation blocks were written. These helpers are project-internal Archon
transcriptions of the Nagata trick; per the directive only a one-line
`\textit{Source: Nitsure \S4 (Nagata change of variables).}` pointer was added to the two
definitions (`T`, `T1`) — no `% SOURCE QUOTE:` block required. The Nitsure §4 reference
(`references/nitsure-hilbert-quot-src/…`) is already cited by the surrounding GF lemmas; I
did not need to open it for verbatim text this round.

## Macros needed (if any)
None. All blocks use existing macros / standard LaTeX (`\deg`, `\mathrm{…}`, `\cref`).

## Notes for Plan Agent
- The directive's prose description of `T1` ("single-variable companion shift X_0 ↦ X_0 + c")
  does not match the landed Lean definition, which is the full triangular Nagata
  substitution `X_i ↦ X_i + c·X_0^{r_i}` (`i≠0`), `X_0 ↦ X_0`. I wrote the block to match
  the actual Lean def (directive instructed "read the def for the exact substitution").
- `lem:gf_nagata_monic_lastVar` previously carried NO `\uses{}` at all (its three helper
  edges were missing); it is now correctly wired. Worth a glance in the next blueprint
  review to confirm the new spine reads as intended.

## Strategy-modifying findings
None.
