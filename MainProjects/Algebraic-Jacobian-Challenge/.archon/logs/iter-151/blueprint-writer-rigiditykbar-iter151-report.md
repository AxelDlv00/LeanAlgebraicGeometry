# Blueprint Writer Report

## Slug
rigiditykbar-iter151

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

### 1. (MUST-FIX) Route-(C) promoted to first-class (BR.5′) prose in the KDM proof
- **Rewrote the KDM proof intro paragraph** (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`).
  It now leads with "Live route (the iter-150+ Lean body): the HYBRID route
  (C), itemised as (BR.5′) below", states that the Lean declaration carries
  `[CharZero k]` and follows the MvPolynomial joint-kernel-collapse +
  `SubmersivePresentation` lift + `KaehlerDifferential.map_D` reduction, and
  explicitly marks the old (p2)/(BR.1)–(BR.5) and (p1) char-p itemisations as
  **SUPERSEDED alternatives** retained for audit.
- **Added a first-class `\emph{Live route (C) --- HYBRID joint-kernel transfer
  (BR.5$'$).}` block** with an `itemize` of (C.a)–(C.d), parallel in style to
  the existing (BR.1)–(BR.5) / (p1.a)–(p1.f):
  - (C.a) FREE-CASE — `D f = 0 ⇒ f ∈ MvPolynomial.C.range` in char 0, via
    `mvPolynomialBasis` + the shifted-coefficient identity. Marked **closed in
    Lean** (names the three `_mvPoly_*` private lemmas).
  - (C.b) Standard-smooth presentation via `Algebra.IsStandardSmooth.out` +
    `Generators.algebraMap_surjective`. Marked **closed in Lean**.
  - (C.c) Lift + `KaehlerDifferential.map_D` functoriality. Marked **closed in
    Lean** (the `_hFunct` step).
  - (C.d) The residual `sorry` transfer step, with the `ker_map_of_surjective`
    kernel description, the Leibniz absorption, and the two closure paths
    (S5.a) explicit-unfold (~30 LOC) / (S5.b) `subsingleton_h1Cotangent`
    bypass (~10–20 LOC).
  - Closes with a plain statement that (C.a)–(C.c) are closed and the single
    residual `sorry` is exactly (C.d); directs provers at (C.d), not (BR.5).
- **Marked the (p2) header** "Superseded path (p2)" and **the (p1) header**
  "Superseded alternative path (p1)" with one-line superseded notes.
- **Rewrote the "Closure end state and ordering" paragraph** to describe the
  live route (C) end-state (residual `sorry` at (C.d)) instead of the obsolete
  `if CharZero k then (p2) else (p1)` case-split.
- **Trimmed the long iter-150 `% NOTE`** (≈47 lines) to a 10-line provenance
  pointer, since its content is now first-class prose.

### 2. Retargeted dangling `references/*.md` pointers in `% NOTE` comments
All pointers to files that do not exist on disk were retargeted to the bundled
genuine sources (or dropped where the source is unbundled):
- `hartshorne-ag.md` (intro NOTE) → dropped (Hartshorne not bundled); the
  companion `stacks-04QM.md` → retargeted to `references/stacks-varieties.tex`
  (Tag 04QM, lemma-smooth-geometrically-normal).
- `stacks-0334.md` (×2, S3.sep.1) → `references/stacks-varieties.tex` (Tag 035U).
- `stacks-0BJF.md` + `stacks-0BUG.md` (S3.sep.2) → `references/stacks-varieties.tex`
  (Tag 0BUG).
- `stacks-05DH.md` (×2, S3.pi.2) → `references/stacks-fields.tex` (Tags 030K/09HD).
- `stacks-07F4.md` (×2, KDM proof) → `references/stacks-algebra.tex` (Tag 00T7).
- `literature-crosscheck-iter149.md` (×2: S3.pi.1 Honesty note, constants-lemma
  NOTE) → **dropped entirely** (file was a fabrication, removed); finding
  restated inline.
Remaining textual occurrences of the old `.md` names are now only inside
explanatory comments stating "that file never existed" — they are no longer
actionable pointers.

### 3. Verbatim source-citation blocks added to 6 high-value declarations
Each got `% SOURCE:` (tag + bundled `.tex` + line), `% SOURCE QUOTE:` (verbatim,
character-for-character from the bundled file, original notation preserved),
and a visible `\textit{Source: ...}` line:
- **KDM lemma** (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`) —
  Tag **00T7** (Lemma 10.137.6, part (2): "the $S$-module $\Omega_{S/R}$ is free
  on $\text{d}x_{c+1}, \ldots, \text{d}x_n$") from `stacks-algebra.tex` L37258.
- **(S3.sep.1)** (`lem:S3_sep_1_smooth_geometrically_reduced_Gamma`) — Tags
  **035U** (Definition 33.6.1, geometrically reduced) + **04QM** (smooth ⇒
  geom. regular/normal/reduced) from `stacks-varieties.tex` L330 / L4616.
- **(S3.sep.2)** (`lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`) —
  Tag **0BUG** parts (3)-(4) from `stacks-varieties.tex` L1932.
- **(S3.pi.1)** (`lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`) — Tag
  **02KH** ("Flat base change", part (2): `H^i(X,F) ⊗_A B = H^i(X',F')`) from
  `stacks-coherent.tex` L947.
- **(S3.pi.2)** (`lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`)
  — Tags **09HD** (Definition, purely inseparable) + **030K** (separable-then-
  inseparable factorisation) from `stacks-fields.tex` L1580 / L1703.
- **`thm:rigidity_over_kbar`** — Mumford, *Abelian Varieties*, Ch. II §4:
  `% SOURCE:` flagged "verbatim text not yet retrieved — paywalled" with **no**
  `% SOURCE QUOTE:`, plus visible `\textit{Source: Mumford, Abelian Varieties,
  II §4.}`. No quote fabricated.

## Cross-references introduced
- None new. No `\uses{...}` / `\lean{...}` / `\label{...}` changed. All edits are
  prose, `% NOTE`/`% SOURCE` comments, and visible `\textit{Source:}` lines.

## References consulted
- `references/summary.md` — tag → file index.
- `references/stacks-algebra.tex` (L37258, lemma-standard-smooth) — verbatim
  Tag 00T7 part (2) for the KDM lemma.
- `references/stacks-varieties.tex` (L330 definition-geometrically-reduced;
  L4616 lemma-smooth-geometrically-normal; L1932
  lemma-proper-geometrically-reduced-global-sections) — verbatim Tags 035U,
  04QM, 0BUG.
- `references/stacks-coherent.tex` (L947 lemma-flat-base-change-cohomology) —
  verbatim Tag 02KH part (2).
- `references/stacks-fields.tex` (L1580 definition-purely-inseparable; L1703
  lemma-separable-first) — verbatim Tags 09HD, 030K.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (read-only) — to ground the
  route-(C) prose against the actual Lean body (the `_mvPoly_*` helpers, the
  `SubmersivePresentation` extraction, `_hFunct`, and the residual `sorry` at
  the (C.d) transfer step).

## Macros needed (if any)
- None. Used only standard commands (`\mbox`, `\textbf`, `\emph`, `\texttt`,
  `\operatorname`, existing project macros).

## Reference-retriever dispatches (if any)
- None. All required verbatim sources were already bundled under `references/`.

## Notes for Plan Agent
- **Tag-030K description mismatch (citation-accuracy finding, not a math
  change).** The S3.pi.2 prose previously asserted Tag 030K = "a finite field
  extension is purely inseparable iff its base change to k̄ is local; Lemma
  9.14.6". The bundled `stacks-fields.tex` entry for Tag 030K is the
  **separable-then-purely-inseparable factorisation** lemma
  (lemma-separable-first), which matches `summary.md`'s own description of 030K,
  NOT an "iff local" statement. I quoted the genuine 030K (factorisation) +
  09HD (definition) verbatim and corrected the Literature parenthetical to
  describe what 030K actually states; I left the `\textbf{030K}` tag in place
  (it is the right tag for the bundled source). The "single closed point /
  local" criterion the proof uses is the proof's own elementary Artinian
  argument, not a direct 030K citation — I noted this in an inline
  `% NOTE ... CAVEAT` comment. The S3.pi.2 lemma statement and Lean target are
  unchanged. If the original "iff local" claim intended a different Stacks tag,
  the plan agent may want a reference-retriever to fetch that specific tag; I
  did not invent one.
- The KDM proof now has a clean live/superseded split. The two superseded
  itemisations (p2/(BR.1)–(BR.5) and p1/(p1.a)–(p1.f)) are long; a future round
  may want to compress them into a single "superseded routes (archived)"
  appendix if the chapter length becomes a concern. I left them in full per the
  directive ("keep the abandoned routes but clearly mark them as superseded").
- `% SOURCE QUOTE:` blocks for 00T7 and 0BUG are intentionally truncated with
  "..." mid-enumerate (quoting only the relevant parts (2) / (3)-(4)); this
  leaves a commented `\begin{enumerate}` without a commented `\end{enumerate}`,
  so a raw `grep` of begin/end counts shows +2 begins. These are all inside `%`
  comments and do not affect LaTeX compilation (uncommented environments are
  balanced: itemize 19/19, enumerate 4/4).

## Strategy-modifying findings
None. The route-(C) promotion aligns the prose with the already-committed Lean
strategy; it does not change the strategy itself. The Tag-030K finding above is
a citation-accuracy correction, not a strategy-level issue.
