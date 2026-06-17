# Blueprint Writer Report

## Slug
rigiditykbar-iter144

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

- **Added paragraph** "Iter-144 chart-algebra pivot --- disposition" at the
  head of § "Piece (i)" (`RigidityKbar.tex:88`, between the introductory
  context-setting paragraph and the existing iter-128/iter-129 prover-lane
  re-scoping paragraph). Implements Edit 3 from the directive. The paragraph
  documents the iter-144 chart-algebra commitment, lists the four DESCOPED
  artefacts (piece (i.b) Step 2 d_app, the IsIso theorem, piece (i.b) Main
  `mulRight_globalises_cotangent`, piece (i.c) `omega_free` / `omega_rank_eq_dim`,
  piece (iii) scheme-Frobenius PHANTOM), the INFLATED piece (ii) pointer, and
  the preservation of piece (i.a) as standalone infrastructure (cf. directive
  verbatim text).

- **Added paragraph** "Iter-144 chart-algebra envelope for piece (ii)" at
  `RigidityKbar.tex:99` (immediately following the disposition paragraph above).
  Implements Edit 4 from the directive. Five-item envelope decomposition
  (α-helper ~80–150 LOC; β chart-translation-invariance ~150–300 LOC with the
  three-layer `df = 0` chain reproduced verbatim as a numbered list — chart-
  local + char-p Frobenius-iteration + no-Serre-duality — per STRATEGY.md
  § Soundness rules; algebra-level core
  `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` ~200–350 LOC;
  integrally-closed-constants helper ~50–100 LOC; scheme-level lift via
  `Scheme.Over.ext_of_eqOnOpen` ~100–150 LOC). Total ~600–1050 LOC, all
  numbers cited verbatim from the directive.

- **Added Rule 4** to the iter-142 Rules 1–3 NOTE block inside
  `\cref{lem:GrpObj_omega_basechange_proj}`'s proof, at
  `RigidityKbar.tex:852` (between Rule 3 closing and the "Step 3
  (adjunction-transpose) sub-recipe" header). Implements Edit 2 from the
  directive. Documents the iter-143 empirical lesson on
  `Pushforward.comp_eq` + `eqToHom` type-coercion, including the
  successful 1-LOC `have hw` Step 3.a closure and the residual chase blocker;
  closes with the iter-144 chart-algebra DESCOPE pointer.

- **Added first-class `\begin{lemma}` block** at `RigidityKbar.tex:1628`
  for `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso`,
  with label `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`. Sits
  adjacent to (just after) the proof of
  `\cref{lem:GrpObj_omega_basechange_proj_inv}` and just before the
  `\cref{lem:GrpObj_omega_restrict_to_identity_section}` block.
  Implements Edit 1 from the directive (the MUST-FIX from
  `blueprint-reviewer-iter144` + `lean-vs-blueprint-checker-cotangent-grpobj-review143`
  MAJOR). Statement extracts the per-open IsIso obligation from the
  iter-143 Wave 2 refactor; proof sketch consolidates the iter-139 Route (b'2)
  items 2–4 (chart-level `Algebra.IsPushout`-from-affine-product helper,
  `pullbackObjEquivTensor` chart-unfolding helper, per-open identification
  with `tensorKaehlerEquiv.symm`) previously living only as `%`-commented
  prose in `RigidityKbar.tex:1245–1320` inside `lem:GrpObj_omega_basechange_proj`.
  Final `\paragraph` notes the iter-144 chart-algebra DESCOPE of this
  declaration.
  - Proof sketch added: Y (three-item enumerated body, ~195–365 LOC envelope).

- **Replaced** the stale "Three concrete sub-sorries remain (iter-140
  prover-lane targets)" enumerated NOTE block inside
  `\cref{lem:GrpObj_omega_basechange_proj}`'s proof
  (`RigidityKbar.tex:601–620` originally) with an iter-143 status update:
  d_map CLOSED iter-142 substantively; d_app PARTIAL iter-143 (have hw
  Step 3.a landed, residual type-coercion blocker); IsIso refactored
  iter-143 into the named theorem
  `basechange_along_proj_two_inv_app_isIso` (now pinned as
  `\cref{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}` per Edit 1).
  Closes with an "Iter-144 chart-algebra pivot disposition" paragraph
  pointing forward to the chart-algebra envelope. Implements Edit 5
  from the directive (iter-138 status-text refresh).

## Cross-references introduced

- `\cref{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}` (NEW label
  in this chapter) — uses `lem:GrpObj_omega_basechange_proj_inv`,
  `lem:GrpObj_omega_basechange_proj`, `def:GrpObj_schemeHomRingCompatibility`,
  all already present in this chapter.

- Edit 3's piece (i.b) DESCOPE paragraph cross-references
  `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`
  (the NEW lemma label from Edit 1), `lem:GrpObj_mulRight_globalises`,
  `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`,
  `lem:GrpObj_cotangentSpace`, `lem:GrpObj_lieAlgebra_finrank` — all
  already present in this chapter.

- Edit 4's chart-algebra envelope for piece (ii) cross-references
  `thm:GrpObj_eq_of_eqOnOpen` (already present in Jacobian.tex as the
  iter-125-refactored `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`;
  this chapter already cites it at L46 via `\cref`). The new paragraph
  also cites `Scheme.Over.ext_of_diff_zero`, the canonical Lean target
  name flagged in the directive (no chapter-internal `\cref` since it
  is named as the target Lean declaration, not as an existing blueprint
  label).

- Edit 5's replacement NOTE block forward-references
  `\cref{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}` (the new
  label from Edit 1), and back-references `subsec:RigidityKbar_piece_i_decomposition`
  (already present).

## Macros needed (if any)
None. All commands used (`\paragraph`, `\textbf`, `\emph`, `\texttt`,
`\cref`, `\Over`, `\Spec`, `\Hom`, `\Scheme`, `\CommRingCat`, `\app`,
`\hom`, `\obj`, `\pr`, `\GrpObj`, `\finrank`) are present in
`macros/common.tex` (this chapter already uses them).

## Reference-retriever dispatches (if any)
None. The directive listed six analogies files (all already in
`analogies/` and read for context). No new external sources required.

## Notes for Plan Agent

- **Sync_leanok soft-flag from the directive (out-of-scope item).** The
  blueprint reviewer flagged `RigidityKbar.tex:406, 524, 1152` as
  potential `\leanok` mis-marks (proof blocks where the body still
  carries a sorry but `\leanok` is present). Per the directive's
  out-of-scope clause and CLAUDE.md § Blueprint Marker Vocabulary,
  these remain pending the deterministic `sync_leanok` phase that
  runs between prover and review each iter; this writer pass did not
  touch them. Line numbers have shifted post-edit: the iter-138 NOTE
  block I refreshed (Edit 5) now sits at L601+; the iter-144
  chart-algebra pivot paragraphs occupy ~150 new lines L88–243.
  `sync_leanok` should re-evaluate against the new line numbering.

- **Piece (ii) prose location convention.** The directive said "Find
  § "Piece (ii)" in `RigidityKbar.tex`", but the chapter currently has
  no `\subsection` or `\section` titled "Piece (ii)" — only an
  `\item[(ii)]` bullet at L68 inside the "shared cotangent-vanishing
  Mathlib pile" itemize. I placed Edit 4's chart-algebra envelope for
  piece (ii) as a `\paragraph` adjacent to Edit 3's disposition
  paragraph at the head of § "Piece (i)" (the only `\subsection` in
  the shared-pile area), so both iter-144 pivot paragraphs sit
  together at the chapter's chart-algebra decision point. The
  alternative — promoting `\item[(ii)]` to a `\subsection{Piece (ii)}`
  with the envelope inside — would have required restructuring the
  bulleted list at L65–79, which felt out of scope for this writer
  pass. If the plan agent prefers the section-promoted shape, that is
  a follow-up structural refactor.

- **Forward reference to `lem:GrpObj_omega_free` / `lem:GrpObj_omega_rank_eq_dim`
  in the chart-algebra DESCOPE prose.** Both lemmas remain in-tree at
  L1572–1596 (`omega_free` / `omega_rank_eq_dim`) with `\notready`
  markers and sketch-only proofs. The chart-algebra DESCOPE prose
  references them as DESCOPED-from-critical-path. The plan agent may
  want to consider whether the per-lemma proof blocks should be
  augmented with an inline `% NOTE iter-144 DESCOPED:` annotation; I
  left them as-is per the directive's "DO NOT delete the bundled-route
  prose" clause, since adding annotations to those specific blocks was
  not listed in the Required content.

- **`\paragraph` headings inside a `\begin{proof}` block.** Edit 1's
  new lemma's proof closes with `\paragraph{Iter-144 chart-algebra
  pivot --- disposition.}`. This is valid LaTeX (`\paragraph` is a
  sectioning command at the lowest level and can appear inside a
  proof environment) and matches the existing convention in this
  chapter (e.g. the iter-127 risk-register paragraphs at L397 and
  L399 are `\paragraph` inside `\begin{lemma}` / `\begin{proof}`).
  But the typesetting might look unusual; if undesirable, a
  re-typeset to `\emph{Iter-144 chart-algebra pivot --- disposition.}`
  inline would do the same job. Not changed in this pass.

## Strategy-modifying findings

None. The iter-144 chart-algebra pivot is already committed in
STRATEGY.md (per the directive's "DO NOT propose strategy changes"
clause); this writer pass only reflected the committed decision into
the chapter prose.
