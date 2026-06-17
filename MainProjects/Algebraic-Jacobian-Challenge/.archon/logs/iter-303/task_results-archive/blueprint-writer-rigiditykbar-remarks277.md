# Blueprint Writer Report

## Slug
rigiditykbar-remarks277

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made
- **Converted to remark** `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`
  — the `\begin{lemma}...\end{lemma}` + following `\begin{proof}...\end{proof}` are now a
  single `\begin{remark}...\end{remark}` block. Deleted the `\label{}` and
  `\lean{Algebra.IsSeparable.of_isGeometricallyReduced_of_finite}` lines (this is what
  drops it from the leandag graph). Opened with one sentence framing it as off-critical-path
  documentation of the (S3.sep.2) fact (geometrically-reduced finite field extension ⇒
  separable, Stacks Tag 0BUG part (4)) retained for a possible future general-over-`k`
  route / Mathlib PR. Preserved verbatim all mathematical prose, the
  `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: ...}` citation block, and the
  `\emph{Literature.}` line. Also removed the now-redundant project-history descoping
  `% NOTE (iter-152, alg-closed pivot)` comment (it referenced the dependency relationship
  the conversion removes and is superseded by the new framing sentence; it is a non-rendered
  comment, not math prose or a citation).
- **Converted to remark** `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`
  — same treatment: lemma+proof merged into one `\begin{remark}...\end{remark}`, deleted
  `\label{}` and `\lean{Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange}`, opened
  with an off-critical-path framing sentence (purely-inseparable-from-unique-minimal-prime,
  Stacks Tag 030K). Preserved all math prose + the Stacks 030K / 09HD `% SOURCE` citation
  blocks (including the iter-151 render-fix CAVEAT comment that documents the citation) +
  `\emph{Literature.}` line. Removed the two project-history descoping `% NOTE` comments
  (iter-152 pivot note and iter-150 HYBRID-DEFERRED note) for the same reason as above.
- **Repaired dangling cross-reference** in the statement prose of
  `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` (line ~2215): replaced the parenthetical
  `(\cref{lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable})` — which would break the
  build after the label removal — with plain descriptive prose `(see the off-critical-path
  remark below)`. The surrounding sentence already states the math content ("geometric
  reducedness ⇒ separable on a finite field extension"), so no information is lost and no new
  `\label`/`\cref` was introduced.

## Cross-references introduced
- None. No new `\label`/`\cref`/`\uses` added. The two remark blocks carry no `\label` (by
  design). The S3.pi.2 remark still contains the pre-existing `\cref{lem:S3_pi_1_...}` and
  `\cref{lem:constants_integral_over_base_field}` inside preserved prose — both targets still
  exist and resolve.

## Verification run
- `grep -n "S3_sep_2_geom_reduced_finite_field_ext_is_separable\|S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange" RigidityKbar.tex`
  → **no matches** (exit 1): no `\label{}` and no `\cref{}` to either label remains anywhere
  in the chapter.
- Environment balance: `\begin{remark}`/`\end{remark}` = 5/5; `\begin{lemma}`/`\end{lemma}`
  = 20/20; `\begin{proof}`/`\end{proof}` = 24/24. `remark` env is defined in
  `macros/common.tex:19` (`\newtheorem{remark}[theorem]{Remark}`) and used across many sibling
  chapters.
- `leandag build`: succeeds; DAG saved. `leandag show isolated` → **54 isolated nodes, all
  `lean_aux` (Chapter `—`)** — the two blueprint isolates dropped to **0 blueprint** as
  intended; the 54 lean-aux isolates are unrelated and unchanged. No `unknown`/`broken`/
  `unresolved`/`dangling` lines in the build output — **no broken refs introduced
  (unknown_uses: 0)**.

## References consulted
- None opened this session. No new citation blocks were authored; all `% SOURCE:` /
  `% SOURCE QUOTE:` / `\textit{Source: ...}` / `\emph{Literature.}` material in both remarks
  was preserved verbatim from the pre-existing blocks (originally sourced from
  `references/stacks-varieties.tex` for 0BUG and `references/stacks-fields.tex` for 030K/09HD,
  as recorded in those blocks' own `(read from ...)` parentheticals).

## Macros needed
- None.

## Notes for Plan Agent
- Both former lemmas had `\lean{}` hints pointing at `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`
  and `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`. Those Lean declarations (if
  they exist as TODO stubs) are now unreferenced by the blueprint DAG — if they were carried
  only to back these two blueprint leaves, they can be retired from the Lean side at the plan
  agent's discretion (out of this writer's scope).
- The conversion deliberately removed the per-block project-history `% NOTE` descoping comments
  (iter-150/iter-152) as part of producing clean, standalone remark prose. The retained
  iter-151 render-fix CAVEAT comment in the S3.pi.2 remark is citation-discipline documentation
  (it explains the 030K verbatim quote is the factorisation lemma, not a direct "local iff
  purely inseparable" statement) and was preserved.
- Did NOT touch `lem:S3_sep_1_...`, `lem:S3_pi_1_...`, `lem:constants_integral_over_base_field`,
  the chapter's `math-delim`/`literal-ref` rendering findings, or add any `\leanok`, per scope.

## Strategy-modifying findings
None.
