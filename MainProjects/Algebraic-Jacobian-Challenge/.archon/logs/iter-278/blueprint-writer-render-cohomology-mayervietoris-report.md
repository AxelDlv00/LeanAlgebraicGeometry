# Blueprint Writer Report — render-cohomology-mayervietoris

## Slug
render-cohomology-mayervietoris

## Chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Outcome
**All 29 `literal-ref` occurrences repaired.** Zero literal `REF` tokens remain in the
file (`grep REF` → exit 1). No mathematics, `\lean{}`, `\label{}`, `\leanok`, or
`\uses{}` edge was altered — pure rendering / cross-reference repair pass.

The blueprint-doctor listed only `literal-ref` for this chapter. Verified there were no
`math-delim`, `bare-label`, or `undefined-macro` defects: the chapter uses `\( ... \)`
consistently (no `$...$`/`\(\)` interleaving), prose contains no raw label ids, and no
undefined macros are introduced.

## Repairs by occurrence (29 total)

Each `Definition~REF` / `Lemma~REF` / `Theorem~REF` / `Chapter~REF` / `Section~REF` was
resolved to the intended labelled block by reading the surrounding prose and (where
present) the nearby `\uses{}` set:

| Line | Token(s) | Resolved to |
|---|---|---|
| 5 | `Chapter~REF` | `\cref{chap:Cohomology_StructureSheafModuleK}` (where `H^n`, `H'^n` carriers are defined) |
| 7 | `Definition~REF` | `\cref{def:genus}` (`H^1(C,O_C)` = genus carrier, Genus.tex) |
| 43 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_cohomologyPresheafFunctor}` (prev. def) |
| 178 | `Lemma~REF` | `\cref{lem:Scheme_HModule_prime_isPushoutModuleCatFreeSheaf}` (this def's `\uses`) |
| 209 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_shortComplex}` |
| 224 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_shortComplex}` |
| 239 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_shortComplex}` |
| 254 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_shortComplex}` |
| 260 | `Lemma~REF`×3 | f_mono, g_epi, exact (matches the `\uses` of `..._shortExact`) |
| 275 | `Lemma~REF` | `\cref{lem:Scheme_HModule_prime_shortComplex_shortExact}` |
| 290 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_delta}` (the def introducing `n_0,n_1`) |
| 378 | `Definition~REF`, `Lemma~REF` | `..._sequence`, `..._shortComplex_shortExact` |
| 401 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_sequence}` |
| 407 | `Definition~REF` | `\cref{def:Scheme_HModule_prime_sequenceIso}` |
| 447 | `Theorem~REF` | `\Cref{thm:Scheme_HModule_prime_sequence_exact}` (sentence-initial) |
| 560 | `Definition~REF` | `\cref{def:Scheme_AffineCoverMVSquare_HModule_prime_sequence}` |
| 567 | `Theorem~REF` | `\cref{thm:Scheme_HModule_prime_sequence_exact}` |
| 585 | `Definition~REF` | `\cref{def:Scheme_AffineCoverMVSquare_HModule_prime_sequence_curve}` |
| 592 | `Theorem~REF` | `\cref{thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact}` |
| 609 | `Definition~REF`×2 | `\cref{def:Scheme_HModule}`, `\cref{def:Scheme_HModule_prime}` |
| 1011 | `Definition~REF` | `\cref{thm:Scheme_IsAffineHModuleVanishing}` (the predicate's label) |
| 1041 | `Chapter~REF`, `Section~REF`, `Section~REF`, `Chapter~REF` | `chap:Cohomology_StructureSheafModuleK` (finiteness chain / `H^0` ladder), `sec:cech_acyclicity`×2 (subsections named in prose) |

## Verification
- `grep REF` → no matches (exit 1).
- Every `\cref{}` target confirmed to be an existing `\label{}`:
  - 14 within-chapter labels each present exactly once.
  - cross-chapter: `chap:Cohomology_StructureSheafModuleK`, `def:Scheme_HModule`,
    `def:Scheme_HModule_prime`, `thm:Scheme_IsAffineHModuleVanishing`
    (all in `Cohomology_StructureSheafModuleK.tex`), `def:genus` (`Genus.tex`),
    `sec:cech_acyclicity` (this chapter, line 851).
- No new `\uses{}` edges; semantic dependency set unchanged.
- The two `\cref{}`-containing lines flagged by a raw grep (474, 476) are inside a
  pre-existing `%`-comment (the iter-266 NOTE about a removed lemma) — not rendered, not
  touched.

## Notes for Plan Agent
- Line 7's "construction of `H^1(C,O_C)`" was pointed at `\cref{def:genus}` (the genus
  carrier definition), since `H^1(C,O_C)` is exactly the genus carrier (cf. line 1041
  "delivers `Module.Finite k H^1(C,O_C)` — the genus carrier"). This is a cross-chapter
  prose `\cref`, not a `\uses` edge, so it adds no dependency.
- Line 1041's two `Section~REF` tokens referred to subsections ("Comparison-iso
  typeclass carrier", "Affine Čech-acyclic cover carrier") that carry no `\label`; they
  are pointed at the enclosing `\cref{sec:cech_acyclicity}` with the subsection still
  named in prose. If finer granularity is wanted, those two subsections could be given
  their own `\label`s in a future pass (out of scope here).

## Macros needed
None. No undefined macros encountered; nothing to promote to `macros/common.tex`.
