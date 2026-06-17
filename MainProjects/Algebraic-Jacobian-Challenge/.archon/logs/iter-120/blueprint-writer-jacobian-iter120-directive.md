# Blueprint-writer directive — `Jacobian.tex` orphan-ref fix

## Target

`blueprint/src/chapters/Jacobian.tex` (single chapter, ONE small edit).

## What changed and why

The iter-120 blueprint-reviewer audit flagged a broken cross-reference
in `Jacobian.tex:6`:

```latex
Because the Picard-scheme machinery (Chapter~\ref{chap:Picard_Functor})
is blocked at the level of monoidal-category infrastructure for
$\mathcal O_X$-modules and the full FGA representability theorem, this
chapter builds the Jacobian by an alternative ad-hoc route: the
Albanese functor on smooth proper curves.
```

The target `chap:Picard_Functor` lives in `Picard_Functor.tex`, which
is an ORPHAN chapter (not included in `blueprint/src/content.tex`). The
compiled blueprint renders the `\ref` as `Chapter ??`, which is a
broken cross-reference.

The orphan corresponds to the iter-117 trim that deleted the Picard
scheme infrastructure files (`Picard/LineBundle.lean`, `Picard/Functor.lean`,
`Picard/FunctorAb.lean`, `Modules/Monoidal.lean`). The chapter files
are left on disk but excluded from content.tex. This single stray
`\ref` is the only leak from the active blueprint into the orphan
island.

## What you must do this iter

Replace the broken `\ref{chap:Picard_Functor}` at line 6 of
`Jacobian.tex` with descriptive prose. The replacement should:

1. Be honest about why the Picard-scheme route is blocked. The
   blueprint already documents the FGA / Hilbert-Quot Mathlib gap
   thoroughly in Section "Existence of an Albanese variety" (Routes
   A/B/C, L255–339). The line-6 prose should briefly point at that.
2. Not introduce any new broken `\ref`. Don't add references to
   orphan chapters or to labels that don't exist.

### Suggested replacement (use this verbatim or a close paraphrase)

```latex
Because the Picard-scheme machinery (FGA representability for $\Pic_{C/k}$
and its Hilbert/Quot prerequisites) is blocked at the level of Mathlib
infrastructure (see Theorem~\ref{thm:nonempty_jacobianWitness} Route~A
below for the detailed gap analysis), this chapter builds the Jacobian
by an alternative ad-hoc route: the Albanese functor on smooth proper
curves.
```

The cross-reference `\ref{thm:nonempty_jacobianWitness}` is to an
in-scope label (`Jacobian.tex:241`) and will resolve cleanly.

## What NOT to do

- Do NOT touch any other chapter file.
- Do NOT touch any line of `Jacobian.tex` other than line 6.
- Do NOT add any new chapters, definitions, theorems, or `\input{...}`
  lines.
- Do NOT modify orphan chapters (`Picard_*.tex`,
  `Modules_Monoidal.tex`). They stay as orphans.
- Do NOT modify `content.tex`.

## Output

Write to `blueprint/src/chapters/Jacobian.tex`. Report:
- Confirmation that line 6 was edited and no other line was touched.
- The exact replacement prose you used.
- Confirmation that no other broken cross-references exist in
  `Jacobian.tex` (you may want to run `grep '\\ref{chap:' Jacobian.tex`
  to be sure).

## Write-domain

`blueprint/src/chapters/Jacobian.tex` (single file).
