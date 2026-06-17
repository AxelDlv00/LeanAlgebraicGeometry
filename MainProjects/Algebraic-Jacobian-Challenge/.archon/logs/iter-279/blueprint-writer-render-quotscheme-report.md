# Rendering cleanup report — Picard_QuotScheme.tex

**Iteration:** 279 · **Slug:** render-quotscheme · **Defect class:** `math-delim` only
(no `literal-ref`, `bare-label`, or `undefined-macro` defects present in rendered prose).

## Summary

Normalised **16** math-delimiter sites to the `\(...\)` style (math inside `\(...\)`,
prose outside). Of these, **6** were the genuine inverted/interleaved defects
`$MATH\( prose \)MATH$` flagged by the doctor; the other **10** were single-style
`$...$` formulas (including the two directive-named sites 431 and 799) converted for
consistency. All edits are delimiter-only — **no** statement text, proof mathematics,
`\lean{}`, `\label{}`, or `\uses{}` semantics were altered; no `\leanok`/`\mathlibok`
added or removed; no blocks added/removed/reordered.

## Edits (line numbers pre-edit)

| Line(s) | Kind | Before → After |
|---|---|---|
| 242–243 | interleaved | `$\mathrm{Grass}(V,d)=…\( (the Quot functor for \)X=S\(, \)E=V$` → `\(\mathrm{Grass}(V,d)=…\) (the Quot functor for \(X=S\), \(E=V\)` |
| 297–298 | plain `$…$` | `$\mathrm{Gr}_S(V,d)\hookrightarrow…\right)$` → `\(…\right)\)` |
| 331–332 | interleaved | `$u:…\mathcal{U}\( is given on \)U^I\( by the matrix \)X^I$` → `\(u:…\mathcal{U}\) is given on \(U^I\) by the matrix \(X^I\)` |
| 345–346 | interleaved | `$T\to U^I\subset\mathrm{Gr}(r,d)\(. Base change from \)\mathbb{Z}$` → `\(T\to U^I\subset\mathrm{Gr}(r,d)\). Base change from \(\mathbb{Z}\)` |
| 404–405 | plain `$…$` | `$m=m(\mathrm{rank}\,V,\mathrm{rank}\,W,\Phi)$` → `\(…\)` |
| 431–432 | plain `$…$` (directive-named) | `$T\to\mathrm{Gr}_S(W\otimes\mathrm{Sym}^r V,\Phi(r))$` → `\(…\)` |
| 437–438 | plain `$…$` | `$T_0=\mathrm{Gr}_S(…)$` → `\(…\)` |
| 441–443 | plain `$…$` | `$h:\pi_{T_0}^*\mathcal{K}\hookrightarrow…E_{T_0}$` → `\(…\)` |
| 459–460 | plain `$…$` | `$\mathrm{Gr}_S\hookrightarrow\mathbb{P}_S(…)$` → `\(…\)` |
| 508–509 | interleaved | `$\Quot…\xrightarrow{\sim}\Quot…\( with \)\Psi(\lambda)=\Phi(\lambda+\nu)$` → `\(…\) with \(\Psi(\lambda)=\Phi(\lambda+\nu)\)` |
| 546–547 | interleaved | `$\ker(\phi)|_{X_T}\hookrightarrow…\mathcal{F}\(. Because \)\mathcal{F}\( is \)T$-flat` → `\(…\mathcal{F}\). Because \(\mathcal{F}\) is \(T\)-flat` |
| 668–669 | interleaved | `$\pi_*E(r)\cong…\mathrm{Sym}^r V\( gives the source) and \emph{injective} on \)T$-points` → `\(…\) gives the source) and \emph{injective} on \(T\)-points` |
| 679–680 | plain `$…$` | `$(\pi_T)^*…= \pi_{T_0}^*(W\otimes\mathrm{Sym}^r V)_T$` → `\(…\)` |
| 799–800 | plain `$…$` (directive-named) | `$H^i(X,\mathcal{F})\otimes_A B=H^i(X',\mathcal{F}')$` → `\(…\)` |
| 1328 | plain `$\sim$` | `($\sim$10--30 LOC…)` → `(\(\sim\)10--30 LOC…)` (matches `\(\sim\)` already used at line 1325) |
| 1511–1512 | plain `$…$` | `$s\mapsto\Phi_{\mathcal{F},s}\in\mathbb{Q}[\lambda]$` → `\(…\)` |

## Verification

- `grep '\$'` over non-comment lines → **NONE** remaining.
- `grep -E '\$[^%]*\\\('` (interleaved pattern) over non-comment lines → **NONE**.
- `grep -w REF` over non-comment lines → **NONE** (all `REF` tokens live only inside
  `% SOURCE QUOTE` comments — verbatim Nitsure/Stacks source text, non-rendering, out of
  scope; no `\cref` introduced, none required).
- No `\cref{}` was introduced (no `literal-ref`/`bare-label` defects existed), so no
  dangling-label risk.

## Notes / unresolved

- No defects resolved by rewording (no excised-target cross-references in this chapter).
- No unresolved defects.
- `REF` placeholders inside `%`-comment SOURCE-QUOTE blocks were intentionally left
  untouched: they are commented-out verbatim source excerpts, do not render, and editing
  them is outside the rendering-cleanup scope (and would alter the recorded source quote).
