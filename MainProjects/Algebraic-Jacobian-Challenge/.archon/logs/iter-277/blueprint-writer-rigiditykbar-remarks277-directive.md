# blueprint-writer — rigiditykbar-remarks277

## Chapter
`blueprint/src/chapters/RigidityKbar.tex` (NOT protected).

## Task — a precise, surgical structural edit (NOT a content rewrite)

The blueprint-reviewer (certify277) tagged two isolated blueprint leaves **`remove`**
via the gated removal flow, with the conservative form **"convert to a `\remark{}`
block"** (preserve the mathematics + Stacks citations, but remove the declaration from
the dependency graph so the isolated-blueprint count drops 2→0). Both are dead
scaffolding for the abandoned **path (b)** of `lem:constants_integral_over_base_field`
(superseded by the iter-152 alg-closed pivot; STRATEGY.md tracks no general-over-k
route; their only notional consumer — the path-(b) assembler — was dropped). They have
no honest consumer (`wire-up` is not available) and back a route the strategy does not
pursue.

Make EXACTLY these three edits and NOTHING else (do not touch any other lemma, proof,
`\uses{}`, or `\lean{}` in the chapter; do not re-prove anything; do not add `\leanok`):

### Edit 1 — convert `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` to a remark
The block currently begins `\begin{lemma}` with
`\label{lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable}` and
`\lean{Algebra.IsSeparable.of_isGeometricallyReduced_of_finite}` (around line 2250), followed
by a separate `\begin{proof} ... \end{proof}`.
- Replace the `\begin{lemma} ... \end{lemma}` + its following `\begin{proof} ... \end{proof}`
  with a single `\begin{remark} ... \end{remark}` block.
- **Delete** the `\label{...}` and `\lean{...}` lines (a remark must not carry them — that
  is what removes it from the leandag graph).
- **Preserve verbatim** all mathematical prose, the `% SOURCE:` / `% SOURCE QUOTE:` /
  `\textit{Source: ...}` citation block, and the `\emph{Literature.}` line. The remark
  should open with one sentence stating it documents the (S3.sep.2) fact
  (geometrically-reduced finite field extension ⇒ separable, Stacks 0BUG part 4) as
  off-critical-path documentation retained for a possible future general-over-k route /
  Mathlib PR, not as an active proof obligation.

### Edit 2 — convert `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` to a remark
Same treatment as Edit 1 for the block beginning `\begin{lemma}` with
`\label{lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange}` (around line 2357)
and its following proof: convert lemma+proof to one `\begin{remark} ... \end{remark}`,
delete `\label{}`/`\lean{}`, preserve all math prose + the Stacks 030K `% SOURCE` citation
block + `\emph{Literature.}` line, opening with one sentence framing it as off-critical-path
documentation (purely-inseparable-from-unique-minimal-prime, Stacks 030K).

### Edit 3 — repair the now-dangling cross-reference
At line ~2215 (inside the proof prose of `lem:S3_sep_1_smooth_geometrically_reduced_Gamma`)
there is a `\cref{lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable}`. After Edit 1 that
label no longer exists, so this `\cref` would break the build. Replace the
`(\cref{lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable})` parenthetical with plain
descriptive prose, e.g. "(geometric reducedness $\Rightarrow$ separability on a finite field
extension; see the off-critical-path remark below)". Do not introduce any new `\label`/`\cref`
that doesn't already resolve.

## Verification you must run before reporting
- `grep -n "S3_sep_2_geom_reduced_finite_field_ext_is_separable\|S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange" blueprint/src/chapters/RigidityKbar.tex`
  must show **no `\label{}` and no `\cref{}`** to either (only, at most, the remark prose
  text without the label macro).
- `leandag build` then confirm `Isolated (no edges)` dropped to **0 blueprint** (the 54
  lean-aux isolates are unrelated and stay), and the build report shows `unknown_uses: 0`
  (no broken refs introduced).

## Out of scope
- Do NOT touch `lem:S3_sep_1_...`, `lem:S3_pi_1_...`, `lem:constants_integral_over_base_field`,
  or any other declaration's statement/proof/uses.
- Do NOT address the chapter's `math-delim`/`literal-ref` rendering findings (separate pass).
- Do NOT add `\leanok` anywhere.
