# blueprint-writer · jacobian-iter120

## Outcome

Replaced the single broken cross-reference at `blueprint/src/chapters/Jacobian.tex:6`.
No other line of `Jacobian.tex` was touched.

## Edit

Line 6 of `Jacobian.tex` previously read:

```latex
Because the Picard-scheme machinery (Chapter~\ref{chap:Picard_Functor}) is blocked at the level of monoidal-category infrastructure for $\mathcal O_X$-modules and the full FGA representability theorem, this chapter builds the Jacobian by an alternative ad-hoc route: the Albanese functor on smooth proper curves.
```

It was replaced verbatim with the suggested prose:

```latex
Because the Picard-scheme machinery (FGA representability for $\Pic_{C/k}$ and its Hilbert/Quot prerequisites) is blocked at the level of Mathlib infrastructure (see Theorem~\ref{thm:nonempty_jacobianWitness} Route~A below for the detailed gap analysis), this chapter builds the Jacobian by an alternative ad-hoc route: the Albanese functor on smooth proper curves.
```

The new `\ref{thm:nonempty_jacobianWitness}` resolves to the in-scope label at
`Jacobian.tex:241` (verified by grep).

## Cross-reference audit

`grep '\\ref{chap:' Jacobian.tex` after the edit yields only:

- `chap:Genus` (line 4)
- `chap:AbelJacobi` (lines 79, 197, 349)
- `chap:Rigidity` (line 327)

All three targets are `\input{...}`-ed in `blueprint/src/content.tex`:

```
\input{chapters/Genus}
\input{chapters/Jacobian}
\input{chapters/Rigidity}
\input{chapters/AbelJacobi}
```

so every remaining `\ref{chap:...}` in `Jacobian.tex` now resolves cleanly. The
orphan reference to `chap:Picard_Functor` is eliminated, and no new broken
references were introduced.

## Files written

- `blueprint/src/chapters/Jacobian.tex` (one-line replacement at line 6).

## Files NOT touched

- `blueprint/src/content.tex` (unchanged).
- Orphan chapters (`Picard_*.tex`, `Modules_Monoidal.tex`) — left in place as
  orphans per directive.
- All other chapter files.
