# Blueprint-clean report — Picard_RelPicFunctor.tex (iter-246, slug rpf246)

## Summary of changes

Four surgical edits to `blueprint/src/chapters/Picard_RelPicFunctor.tex`.

### 1. Removed stale gate-annotation paragraph (PRIMARY TASK)

Deleted the entire `\paragraph{Gate annotation (iter-198 refresh).}` block
(previously ~55 lines in the "Lean encoding" section). That block falsely
described the residual Lean blocker as the "Mathlib `Scheme.Modules`
monoidal-structure gap at commit `b80f227`" — a condition that is now resolved
(the project has built `Scheme.Modules.tensorObj` and `picCommGroup`
axiom-clean). The mathematical slogan paragraph that immediately followed
("The relationship with `\cref{chap:Picard_FGAPicRepresentability}` …") was
preserved verbatim; it contains no stale claims.

### 2. Stripped iter-198 stamp from visible prose

`\textbf{Verification flag (resolved, iter-198).} The Mathlib API names are now pinned.`
→ `\textbf{Lean API note.} The big étale Grothendieck topology …`

The substantive Mathlib API information that follows (topology name, sheafification
entry point, fallback pattern) was fully preserved.

### 3. Cleaned deferral language in `thm:rel_pic_etale_sheaf_group_structure`

The theorem body previously ended with:
> "The forward-looking statement is deferred until the upstream Mathlib
> `Scheme.Modules` monoidal-structure gap **discussed at the end of this chapter**
> is closed …"

This cross-referenced the now-deleted gate annotation paragraph and cited a
condition that is no longer true. Replaced with a clean close:
> "… is recorded separately as `\cref{thm:rel_pic_etale_sheaf_unit_canonical}` below."

Also removed the "In the iteration of the formalisation currently on disk, this block
records" project-history preamble, replacing it with "This block records".

### 4. Cleaned deferral language in the internal-consistency check

The bullet for `\cref{thm:rel_pic_etale_sheaf_unit_canonical}` previously ended:
> "it stands deferred until the upstream Mathlib `Scheme.Modules`
> monoidal-structure gap **identified in the section 'Lean encoding'** is closed,
> at which point the bare existence content of `thm:rel_pic_etale_sheaf_group_structure`
> can be upgraded …"

Replaced with: "This block records the canonical sheafification unit and its
universal property; it carries no `\lean{…}` pin and is not yet tracked by the
deterministic `sync_leanok` phase."

## Invariants confirmed

- All `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` blocks and
  all `\textit{Source:…}` lines are untouched.
- All `% NOTE (iter-199 plan agent): …` semantic comment markers are untouched.
- All `\leanok` / `\mathlibok` markers are untouched.
- All `\uses{}` / `\label{}` / `\lean{}` entries for the six formalised
  declarations are intact and correctly formatted.
- Cross-references between this chapter and `chap:Picard_LineBundlePullback` /
  `chap:Picard_FGAPicRepresentability` are all commentary (`\cref{}` in prose),
  not `\uses{}` targets — correct as before.

## Pre-existing issue (not introduced by these edits, not changed)

`\begin{theorem}[Canonical sheafification unit …]` (`thm:rel_pic_etale_sheaf_unit_canonical`)
has no `\uses{}` block in its theorem or proof environment. The internal-consistency
section narratively lists its dependencies, but the blueprint markup does not
reflect them. Since the theorem has no `\lean{}` pin (forward-looking, no
`sync_leanok` tracking), this omission has no impact on the Lean side. A future
blueprint-writer round could add the `\uses{}` block when the theorem is pinned.
