# Blueprint Writer Report

## Slug
chartalgebras3-offpath

## Status
COMPLETE — status-marking pass done; all four (S3.*) labels and statements preserved, the four sub-claims reframed as DESCOPED/off-path under the alg-closed pivot.

## Target chapter
blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex

## Changes Made
- **Added** a `\textbf{Status (DESCOPED under the alg-closed pivot).}` paragraph
  to the chapter intro, stating all four (S3.*) sub-claims are the
  general-over-$k$ formulation, no longer on the M2.a critical path
  (`constants_integral_over_base_field` closes over $\bar k$ via
  `IsAlgClosed.algebraMap_bijective_of_isIntegral`), and retained as an
  auditable / upstream-Mathlib-PR record.
- **Revised** the "File scope (iter-149 Lane 1 scaffolding)" header → "File
  scope"; reframed the four sub-claims from "promoted ... build targets" to
  "off-path, retained records (see the DESCOPED status above)".
- **Revised** "Body status (iter-149 prover lane)" → "Body status (off-path
  under the alg-closed pivot)"; the prose no longer presents the four as active
  prover targets, and each closure-strategy bullet now carries a
  `[DESCOPED, off-path]` tag. Bodies described as recorded for the
  auditable/PR record only.
- **Revised** the iter-150 HYBRID `% NOTE` comment: the conditional "IF the
  user gate ... closes YES" framing replaced with an iter-152 UPDATE stating
  the pivot is now in force, so all four (S3.*) — not just (S3.pi.1)/(S3.pi.2)
  — are descoped.
- **Revised** the iter-150 `Algebra.IsSeparable.of_finite_of_perfectField`
  helper `% NOTE`: added an iter-152 UPDATE that the CharZero-propagation
  wiring plan is superseded by the pivot; helper retained as auditable record.
- **Added** the standard DESCOPED `\emph{...}` status sentence to each of the
  four `\paragraph{(S3.*)...}` blocks in the "Source citations" section
  (S3.sep.1, S3.sep.2, S3.pi.1, S3.pi.2), placed in the prose body after the
  `\cref{...}` canonical-statement pointer — NOT inside any `% SOURCE QUOTE`.

## Cross-references introduced
- Added `\cref{lem:constants_integral_over_base_field}` reference in the new
  intro Status paragraph — verify `lem:constants_integral_over_base_field`
  exists (it is referenced as existing in the prior chapter text and lives in
  RigidityKbar.tex / ChartAlgebra.tex; this writer did not edit those).

## Preservation verification
- All four `lem:S3_*` labels still present (intro itemize lines 31/33/35/37,
  Source-citations cross-refs lines 130–133, and per-paragraph `\cref`s).
- All six `% SOURCE QUOTE` blocks (035U, 056T, 0BUG, 02KH, 09HD, 030K) left
  byte-for-byte intact.
- No `\leanok` / `\mathlibok` added; no Lean tactics written; no other chapter
  touched.

## References consulted
- None opened this session. This was a STATUS-marking pass per directive; no
  new citation blocks were written and all existing `% SOURCE QUOTE` blocks
  were preserved verbatim without modification.

## Macros needed (if any)
- None. Used only `\textbf`, `\emph`, `\texttt`, `\cref`, `$\bar k$`.

## Notes for Plan Agent
- The chapter is a pointer chapter: it contains NO `\begin{lemma}` blocks of
  its own. The four (S3.*) "lemma blocks" referenced in the directive are the
  `\paragraph{(S3.*)...}` source-citation blocks here; the actual `\lemma`
  statements with `lem:S3_*` labels live in `RigidityKbar.tex`. I added the
  DESCOPED status to the paragraph blocks here. The corresponding `\lemma`
  blocks in RigidityKbar.tex were NOT touched (out of write-domain) — if you
  want the same DESCOPED status on the canonical statements themselves, dispatch
  a writer for RigidityKbar.tex.
- The intro Status paragraph cites `lem:constants_integral_over_base_field`;
  confirm that label resolves so the new `\cref` does not dangle.

## Strategy-modifying findings
None.
