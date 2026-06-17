# Directive: blueprint-writer — new chapter Picard_Pic0AbelianVariety.tex

## Target file

`blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` (CREATE NEW)

## Background

Strategy phase **A.3.iii–vi + A.3.vii assembly** has no blueprint
coverage. This chapter has been deferred multiple iterations and is the
linchpin of Route A — without it, `thm:nonempty_jacobianWitness` Route A
remains a named gap.

`blueprint-reviewer iter192` proposed the chapter with a concrete
outline (cited verbatim below).

## Required content

Write a chapter `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`
following EXACTLY this outline:

```latex
\chapter{The identity component \(\Pic^0_{C/k}\) as an abelian variety}
\label{chap:Picard_Pic0AbelianVariety}
% archon:covers AlgebraicJacobian/Picard/Pic0AbelianVariety.lean

\section{Tangent space isomorphism}
% A.3.iii: H^1(O_C) ≅ T_0 Pic^0

\begin{theorem}[Tangent space at the identity: T_0 Pic⁰ ≅ H¹(O_C)]
\label{thm:pic0_tangent_space_iso}
\lean{AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso}
...
\end{theorem}

\section{Smoothness of \(\Pic^0_{C/k}\)}
% A.3.iv

\begin{theorem}[Smoothness of \(\Pic^0_{C/k}\)]
\label{thm:pic0_smooth}
\lean{AlgebraicGeometry.Scheme.Pic0.smooth}
...
\end{theorem}

\section{Properness of \(\Pic^0_{C/k}\)}
% A.3.v

\begin{theorem}[Properness of \(\Pic^0_{C/k}\)]
\label{thm:pic0_proper}
\lean{AlgebraicGeometry.Scheme.Pic0.proper}
...
\end{theorem}

\section{Geometric irreducibility of \(\Pic^0_{C/k}\)}
% A.3.vi

\begin{theorem}[Geometric irreducibility of \(\Pic^0_{C/k}\)]
\label{thm:pic0_geom_irred}
\lean{AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible}
...
\end{theorem}

\section{Assembly: \(\Pic^0_{C/k}\) is an abelian variety}
% A.3.vii: assembly

\begin{theorem}[\(\Pic^0_{C/k}\) is an abelian variety]
\label{thm:pic0_isAbelianVariety}
\lean{AlgebraicGeometry.Scheme.Pic0.isAbelianVariety}
\uses{thm:pic0_smooth, thm:pic0_proper, thm:pic0_geom_irred,
      thm:identity_component_is_subgroup_homomorphism}
...
\end{theorem}
```

Sources to cite verbatim per the citation-discipline rules (open the
files in `references/`):

- **Tangent space iso (A.3.iii)**: Kleiman §5 (`references/kleiman-picard.pdf`)
  + Mumford "Abelian Varieties" Ch. II §6 Thm.1
  (`references/mumford-abelian-varieties.pdf`) + Hartshorne III.12.
- **Smoothness (A.3.iv)**: Kleiman §5 cor:sm + cor:ch0
  (`references/kleiman-picard.pdf`) + Milne AV Prop. 3.4
  (`references/abelian-varieties.pdf`).
- **Properness (A.3.v)**: Kleiman §5 + Mumford AV Thm. 3.7 (Jacobian is
  complete).
- **Geometric irreducibility (A.3.vi)**: Kleiman §5 prp:P0 + Mumford
  AV §3 + Stacks tag 04KU.
- **Assembly (A.3.vii)**: Milne AV (defining axioms for abelian variety).

For each theorem block, provide:
- `% SOURCE:` line with file pointer.
- `% SOURCE QUOTE:` verbatim text from the source (open the file and
  copy the statement; do NOT paraphrase).
- `% SOURCE QUOTE PROOF:` immediately before `\begin{proof}` with the
  source's proof (when present).
- `\textit{Source: ...}` line at the top of the prose body.
- Detailed informal proof sketch (3-8 sentences each) sufficient to
  formalize.

Use the `\uses{...}` blocks to document the dependency graph
(thm:pic0_isAbelianVariety \uses thm:pic0_smooth, thm:pic0_proper,
thm:pic0_geom_irred).

## Authorization for reference retrieval

You are authorized to write to `references/**`. If a needed source
file is not yet present, dispatch a `reference-retriever` child to
download it BEFORE writing the citation block.

## Boilerplate

- Add the chapter `\input` to `blueprint/src/content.tex` at the
  appropriate position (after `Picard_IdentityComponent.tex`).

## Out of scope

- Do NOT touch `\leanok` or `\mathlibok` markers; `sync_leanok` and
  review own them.
- Do NOT write any Lean code; the chapter is informal-only.

## Report

Write to `task_results/blueprint-writer-pic0-abelian-variety-skeleton.md`
with the line count + theorem labels + reference citations confirmed.
