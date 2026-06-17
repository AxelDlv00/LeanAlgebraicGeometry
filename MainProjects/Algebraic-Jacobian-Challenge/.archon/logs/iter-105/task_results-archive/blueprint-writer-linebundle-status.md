# Blueprint Writer Report

## Slug
linebundle-status

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_LineBundle.tex

## Changes Made

- **Added status-note paragraph** immediately after `\end{definition}` of `\def:Scheme_LineBundle`. The note documents the Lean-state mismatch on four axes per directive:
  (a) the current Lean body in `AlgebraicJacobian/Picard/LineBundle.lean` is `CommRing.Pic (Γ(X, ⊤))` rather than the geometric definition;
  (b) Stacks~`0AGS` is cited for the affine-vs-non-affine bifurcation (equality on affine, strict subgroup otherwise);
  (c) the projective-space counter-witness — `Pic(ℙⁿ_k) ≅ ℤ` vs. the trivial `CommRing.Pic(k)` from the current Lean body;
  (d) the Phase~C1 refactor target — `MonoidalCategory.Invertible` of `X.Modules` — with an explicit warning that the two `\leanok`s downstream will need re-confirmation.
  The note also cites the cross-chapter acknowledgements: forward-compatibility note in `\ref{chap:Picard_Functor}` and the `W.IsMonoidal` status remark in `\ref{chap:Modules_Monoidal}`, and reminds the reader that `\ref{thm:Pic_representable}` remains a `sorry` rather than weakening to the approximation.
  Format: `\paragraph{Status note (Phase C1).}` followed by ~3 paragraphs of prose (~15 lines).
- **Added `% NOTE:` line above `\thm:Scheme_Pic_commGroup`** (new L35, immediately preceding `\begin{theorem}\leanok` on L36). Flags that `\leanok` certifies closure against the approximation-level Lean body and points to the status note above for context.
- **Added `% NOTE:` line above `\thm:Scheme_Pic_pullback`** (new L53, immediately preceding `\begin{theorem}\leanok`). Identical phrasing for parallel structure.

No other content in the chapter was modified. In particular:
- `\def:Scheme_LineBundle`'s prose, label, and `\lean{...}` hint are untouched (per directive: the geometric definition is the post-C1 target the chapter should describe).
- Both theorem-statement-level and proof-level `\leanok` markers are preserved verbatim (per directive: `\leanok` removal would falsely suggest a `sorry`).
- `\thm:Scheme_Pic_pullback` proof, `\thm:Scheme_Pic_commGroup` proof, "Use in the project" section, and "Mathlib gap" section are unchanged.

## Cross-references introduced

- `\ref{chap:Picard_Functor}` — verified exists at `blueprint/src/chapters/Picard_Functor.tex` L2.
- `\ref{chap:Modules_Monoidal}` — verified exists at `blueprint/src/chapters/Modules_Monoidal.tex` L2.
- `\ref{thm:Pic_representable}` — already cross-referenced elsewhere in the same chapter (L4 of original); not newly introduced.
- `\ref{thm:Scheme_Pic_commGroup}` and `\ref{thm:Scheme_Pic_pullback}` — internal to this chapter; both labels are below the status note in the same file.

## Macros needed (if any)

None added by me. I initially wrote `\stacks{0AGS}` and `\path{AlgebraicJacobian/...}` reflexively, but `grep`d the macros and found neither is defined in `blueprint/src/macros/` and neither is used elsewhere in `blueprint/src/chapters/`. The closest precedent in `Rigidity.tex` L63 spells "Stacks 0BFD" inline, and `Modules_Monoidal.tex` L78–100 uses `\texttt{...}` for file paths.

I therefore rewrote the two undefined macro calls as:
- `\stacks{0AGS}` → `Stacks~\texttt{0AGS}` (matches Rigidity.tex precedent + small typographic polish on the code).
- `\path{AlgebraicJacobian/Picard/LineBundle.lean}` → `\texttt{AlgebraicJacobian/Picard/LineBundle.lean}` (matches Modules_Monoidal.tex precedent).

No macro file edits needed.

## Reference-retriever dispatches (if any)

None. The directive's "References: None" line was accurate — the status note is documentary and grounded in the existing Lean docstring and cross-chapter acknowledgements that the plan agent identified.

## Notes for Plan Agent

- The blueprint marker vocabulary documented in `.archon/CLAUDE.md` lists `% NOTE:` as a *review-agent* responsibility ("write (markers only: `\leanok`, `\mathlibok`, `% NOTE:`, `\lean{...}` corrections)"). My directive nevertheless explicitly instructed me to add two `% NOTE:` lines above the theorem-level `\leanok`s, and the blueprint-writer prompt body only forbids me from adding/removing `\leanok`/`\mathlibok` themselves. I followed the directive. If the project wants stricter separation, this directive class should be re-routed to the review agent (or the prompt body should explicitly authorize writer-side `% NOTE:` additions under directive). Flagging for your awareness; no action required.
- The post-edit chapter introduces a forward reference style I should flag: the status-note paragraph references `\ref{chap:Picard_Functor}` § "Forward-compatibility note" by section title (English prose) rather than by `\label`. If you want a stable hyperlink, those two sections in `Picard_Functor.tex` and `Modules_Monoidal.tex` would need their own `\label{sec:...}`s and the status note would need updating. This is cosmetic — the prose pointer is unambiguous as written — but worth noting if blueprint navigation is being polished.
- The chapter still reports under "Mathlib gap" (L84–97) that what is "missing and supplied by this chapter" includes "a scheme-side type of invertible quasi-coherent sheaves". This is consistent with the post-C1 target the chapter describes, but inconsistent with the *current* Lean body (which supplies only `CommRing.Pic` re-export, not the invertible-QC sheaves construction). The directive explicitly restricts changes to (1) the status note and (2) the two `% NOTE:` lines, so I did not touch this section. If you want the Mathlib-gap section also reconciled with the current Lean body, that would be a follow-up directive.

## Strategy-modifying findings

None. The writing did not surface any need to change project strategy; the directive was internally consistent with the Phase~C1 plan as described.
