# Reference-retriever directive — Stacks "Schemes" chapter (sections of $\widetilde M$ over basic opens)

## Slug
stacks-schemes

## What to fetch
The original LaTeX source of the Stacks Project chapter **"Schemes"** (`schemes.tex`),
from the Stacks Project GitHub repository (https://github.com/stacks/stacks-project,
file `schemes.tex`) or https://stacks.math.columbia.edu/.

## Why / what statement I need verbatim
I need the verbatim statement of the foundational fact that, for a ring $R$ and an
$R$-module $M$, the quasi-coherent sheaf $\widetilde M$ on $\operatorname{Spec} R$ has
sections over a basic open $D(f)$ equal to the away localisation $M_f$:
\[
  \Gamma(D(f), \widetilde M) \;=\; M_f .
\]
This is the construction of the sheaf $\widetilde M$ associated to a module. In the
Stacks "Schemes" chapter this is the lemma establishing that $\widetilde M$ is an
$\mathcal{O}_{\operatorname{Spec} R}$-module with $\widetilde M(D(f)) = M_f$ (the
"sheaf $\mathcal{F}_M$ / $\widetilde M$ on the spectrum" construction; near the
section "Quasi-coherent sheaves" / "The structure sheaf", tags around 01HR–01I8).
The base-ring case $\Gamma(\operatorname{Spec} R, \widetilde M) = M$ and the
$D(f)$-localisation case are what I will quote.

## Deliverable
- Download `schemes.tex` (original LaTeX) into `references/` as `references/stacks-schemes.tex`.
- Write the companion pointer `references/stacks-schemes.md` (citation pointer + a short
  table-of-contents stub with the line numbers of the lemma(s) stating
  $\widetilde M(D(f)) = M_f$ and $\Gamma(\operatorname{Spec} R, \widetilde M) = M$).
- Register it in `references/summary.md` if that is part of your normal flow.

If `schemes.tex` is unavailable, the Modules / Constructions chapter analogue of the
$\widetilde M$ construction is acceptable; report which file you fetched and the exact
line range of the $\widetilde M(D(f)) = M_f$ statement.
