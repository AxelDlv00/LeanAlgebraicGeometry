# Reference Retriever Report

## Slug
stacks-schemes

## Status
COMPLETE

All directive items downloaded and verified. The Stacks Project `schemes.tex` LaTeX
source was retrieved from the official GitHub mirror and confirmed to be real LaTeX
(not an HTML error page). The key `lemma-spec-sheaves` (tag 01HV, lines 692–728)
containing $\Gamma(\operatorname{Spec} R, \widetilde{M}) = M$ and $\Gamma(D(f), \widetilde{M}) = M_f$
was located and recorded with exact line numbers.

## Sources fetched

- "Stacks Project — Schemes chapter" (`schemes.tex`)
  — URL: https://raw.githubusercontent.com/stacks/stacks-project/master/schemes.tex
  — Downloaded: `references/stacks-schemes.tex` (174 402 bytes, 4914 lines), LaTeX verified
    (file begins with `\input{preamble}`)
  — No PDF available separately for a single chapter; LaTeX source is the canonical form
    for the Stacks Project
  — Pointer: `references/stacks-schemes.md`

## Key lemma locations confirmed

| Tag | Label in `.tex` | Line range | Statement |
|-----|-----------------|------------|-----------|
| **01HV** | `lemma-spec-sheaves` | 692–728 | Items (2) and (4): $\Gamma(\operatorname{Spec} R, \widetilde M) = M$ (line 698) and $\Gamma(D(f), \widetilde M) = M_f$ (lines 701–702) |
| *(prose)* | construction of $\widetilde M$ | 593–603 | $\widetilde M(D(f)) := M_f$ by definition |
| *(prose)* | stalk computation | 616–629 | $\widetilde M_x = M_{\mathfrak p}$ |
| *(prose)* | sheaf condition check | 633–652 | exactness of Čech sequence for a standard covering |

The construction section begins at line 593 in §5 "Affine schemes" (line 502).
The secondary relevant section is §7 "Quasi-coherent sheaves on affines" (line 1067),
with `lemma-quasi-coherent-affine` (line 1279) and `lemma-equivalence-quasi-coherent`
(line 1390) giving the full quasi-coherence equivalence.

## Index updates
- `references/summary.md` — appended 1 entry: `stacks-schemes`

## Notes for Dispatcher
- The Stacks Project does not distribute per-chapter PDFs; the LaTeX source
  (`schemes.tex`) is the complete and authoritative artifact. A planner quoting
  from it should `Read` with `offset: 692, limit: 40` to get the verbatim lemma.
- The section "Quasi-coherent sheaves on affines" (§7, line 1067) is also directly
  relevant if the blueprint needs the full $R$-mod ↔ QCoh($\operatorname{Spec} R$)
  equivalence (tags around 01I3–01I8).
- No pre-existing `references/` entry was modified.
