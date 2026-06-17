# Reference Retriever Directive

## Slug
stacks-fga-iter151

## Topic
Algebraic geometry source material backing the Jacobian-challenge blueprint.
Two groups: (A) six Stacks Project results (fetch the exact `.tex` chapter
source from GitHub raw so the tag statements are verbatim), and (B) two
open-access arXiv papers on the Picard / Hilbert / Quot scheme machinery
(fetch BOTH the PDF and the LaTeX e-print).

## What the dispatcher will use this for
The blueprint chapters `RigidityKbar.tex` (the chart-algebra (S3.*) and
(BR.*) decomposition lemmas) and `Jacobian.tex` (Route A — Picard scheme via
FGA) cite these sources. A prior retrieval round produced only paraphrased
`.md` summaries with several wrong tag numbers; the project now needs the
genuine source files so blueprint-writers can quote them verbatim
(`% SOURCE QUOTE:`). The Kleiman PDF in particular will be read by the
plan agent this iter to decide whether Route A can be re-scoped to "only the
pieces needed for the Jacobian of a smooth proper curve over k" rather than
the full Picard-representability machinery — so map Kleiman's chapter
structure carefully (deep depth for Kleiman).

## Seeds

### Group A — Stacks Project (fetch raw `.tex` chapters from GitHub; confirm each tag's statement against the fetched source)

Stacks raw chapter URLs follow the pattern
`https://raw.githubusercontent.com/stacks/stacks-project/master/<chapter>.tex`.
The six tags and the chapter each lives in (verify by locating the tag's
`\label`/`\begin{lemma}` in the fetched file):

- **035U** — geometrically reduced schemes. Chapter `varieties.tex`
  (Chapter 33 "Varieties"). Backs (S3.sep.1). Save as
  `references/stacks-varieties.tex`.
- **04QM** — schemes smooth over fields (Section 33.25), incl. Lemma
  33.25.4 = tag 056T (smooth ⇒ geometrically regular/normal/reduced).
  Also in `varieties.tex`. Backs (S3.sep.1).
- **0BUG** — eight properties of `Γ(X, 𝒪_X)` for `X/k` proper (Lemma
  33.9.3), part (4) gives geom-reduced finite ⇒ separable. Also in
  `varieties.tex`. Backs (S3.sep.2) and the whole (S3.*) chain.
  (035U, 04QM, 0BUG all live in `varieties.tex` — one fetch covers all three;
  still confirm each tag's location.)
- **09HD** + **030K** — purely inseparable field extensions (Section 9.14;
  Lemma 9.14.6 = 030K decomposition). Chapter `fields.tex` (Chapter 9).
  Backs (S3.pi.2). Save as `references/stacks-fields.tex`.
- **00T7** — standard smooth ⇒ `Ω` free with basis `dx_{c+1},…,dx_n`
  (Lemma 10.137.6). Chapter `algebra.tex` (Chapter 10). Backs (BR.2)–(BR.5).
  Save as `references/stacks-algebra.tex`. (NOTE: `algebra.tex` is large;
  fetch it whole, then in the contents map point to the exact line/section
  of Lemma 10.137.6 and tag 00T7.)
- **02KH** — flat base change of higher direct images (Lemma 30.5.2);
  the `H^0` specialisation is (S3.pi.1). Chapter `coherent.tex` (Chapter 30
  "Cohomology of Schemes"). Save as `references/stacks-coherent.tex`.

For each tag, in the pointer file's contents map, give the exact location
(section number + the `\begin{lemma}\label{...}` line) inside the fetched
`.tex` so a writer can find and quote it. Write ONE pointer `.md` per fetched
chapter file (e.g. `references/stacks-varieties.md`), each listing which tags
it covers.

### Group B — arXiv (fetch PDF + LaTeX e-print)

- **Kleiman, "The Picard scheme"** — arXiv `math/0504020`. Fetch
  `https://arxiv.org/pdf/math/0504020` (PDF) and
  `https://arxiv.org/e-print/math/0504020` (e-print tar/tex). Save as
  `references/kleiman-picard.pdf` (+ `.tar.gz` / unpacked `-src/`).
  **Deep contents map**: map every chapter/section with page numbers, and
  flag the chapters relevant to constructing the Jacobian (= Pic^0) of a
  smooth proper curve over a field — the plan agent will read this to
  re-scope Route A.
- **Nitsure, "Construction of Hilbert and Quot Schemes"** — arXiv
  `math/0504590`. Fetch PDF + e-print. Save as
  `references/nitsure-hilbert-quot.pdf` (+ source). Medium contents map.

## Out of scope
- Do NOT re-fetch the classical paywalled textbooks (Hartshorne, Eisenbud,
  Matsumura) — the prior round confirmed no open copy; skip them entirely
  this round.
- No shadow-library / piracy sites.

## Contents-map depth expected
deep for Kleiman; medium for the Stacks chapters and Nitsure.
