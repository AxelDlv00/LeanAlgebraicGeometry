# Blueprint Writer Directive

## Slug
a4c-thm32

## Target chapter
`blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` (NEW)

## Lean file
`AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` (NEW).

Add `% archon:covers AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` at top.

## Strategy context

Route A.4.c — gated on A.4.a (`Albanese_CodimOneExtension.tex`, written this iter) + A.4.b (`Albanese_AuslanderBuchsbaum.tex`, written this iter). ~600-900 LOC, ~5-8 iters.

This wires together the previous two chapters into Milne Theorem 3.2: any rational map from a smooth variety to an abelian variety extends to a regular morphism.

## Required content

### Theorem: Milne Theorem 3.2 — rational-map extension to an abelian variety
Statement (Milne *Abelian Varieties* §I.3, Theorem 3.2): Let `X` be a smooth variety over an algebraically closed field `k̄`, and let `f : X ⇢ A` be a rational map into an abelian variety `A`. Then `f` extends uniquely to a regular morphism `f̃ : X → A`.

### Proof sketch (Milne §I.3 verbatim, then project notation)

Quote the Milne proof verbatim. Then split into sub-steps:

1. **Codim-1 reduction**. Reduce to showing `f` has no codim-1 indeterminacy. Use Lemma 3.3 (A.4.a) to extend over codim-2 points once codim-1 is excluded.
2. **Exclusion of codim-1 indeterminacy via Auslander–Buchsbaum**. Suppose for contradiction `f` has a codim-1 indeterminacy point `x`. By A.4.b (Auslander–Buchsbaum on a smooth variety), the local ring `O_{X,x}` has depth ≥ 1, hence `f` extends across codim-1 points by Hartshorne III.8 / standard valuation argument.
3. **Combine**. Codim-1 + codim-2 extensions glue to give a global regular morphism `X → A`.

### Lean signature targets

- `thm:rational_map_to_av_extends` → `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` (matches the placeholder reserved Lean target in `AbelianVarietyRigidity.tex` if any; otherwise add a new declaration name).

This is the Lean target named in `Jacobian.tex` and used by A.4.d.

## Required citations

Read verbatim from:
- `references/abelian-varieties.pdf` §I.3 Theorem 3.2 + proof (pp. 18-20).

`% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT touch `content.tex`.
- Do NOT re-prove Lemma 3.3 or Auslander–Buchsbaum here — `\uses{thm:codim_one_extension, thm:auslander_buchsbaum}`.

## Verification

`\input{...}` is the plan agent's job.

## Report format

Standard.
