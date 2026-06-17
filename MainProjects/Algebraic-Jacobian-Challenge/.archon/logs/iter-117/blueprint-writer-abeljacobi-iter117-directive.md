# Blueprint Writer Directive

## Slug

abeljacobi-iter117

## Target chapter

blueprint/src/chapters/AbelJacobi.tex

## Strategy context (iter-117 post-trim)

The project's `Jacobian` definition has been the witness-based form
`Jacobian C := (jacobianWitness C).J` since iter-073. The three
protected declarations in `AbelJacobi.lean`
(`Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
`Jacobian.exists_unique_ofCurve_comp`) all reduce to projections from
`(jacobianWitness C).isAlbaneseFor P : IsAlbanese C P (jacobianWitness C).J`.

The current `AbelJacobi.tex` chapter describes the Pic^0-line-bundle
classifying-morphism construction (`O_{C×C}(Δ − p_1^* P)` etc.) but
the Lean implementation uses the **Albanese-witness projection**
route. The blueprint-reviewer flagged this as a `correct: partial`
mathematical-content drift: a prover or reader working from the
chapter would build the wrong formalisation route.

## Required content

### MUST-FIX: rewrite `def:ofCurve` to lead with the Albanese-projection definition

The current definition block describes the line-bundle classifying-
morphism construction (Pic^0 + the universal line bundle on `C × C`).
This is **classical content**, but the Lean implementation route is
the Albanese projection:

```lean
def ofCurve P : C ⟶ Jacobian C :=
  ((jacobianWitness C).isAlbaneseFor P).ofCurve
```

Rewrite the definition block so the **leading mathematical content
is the Albanese-projection definition** (citing
`thm:nonempty_jacobianWitness` and the universal-property field
`isAlbaneseFor`). Move the line-bundle classifying-morphism
description into a separate `\begin{remark}` block titled
"Classical description (Pic-scheme route)" that documents the
classical mathematical content as forward-looking reference, with a
clear "Lean implementation does not follow this route; see
Layer~I of Chapter~\ref{chap:Jacobian}" cross-reference.

### MUST-FIX: rewrite `lem:comp_ofCurve` proof to mirror the Albanese projection

The current proof describes the line-bundle restriction argument
("restricting to the section (P, id) gives the trivial line bundle").
The Lean closure is the one-line projection
`((jacobianWitness C).isAlbaneseFor P).comp_ofCurve`.

Rewrite the proof block as a short paragraph:

> The Lean closure is the field projection from the Albanese-witness's
> `isAlbaneseFor P` data: the field `comp_ofCurve` of the
> `IsAlbanese` predicate (Definition~\ref{def:IsAlbanese}) is precisely
> the assertion that the universal morphism sends `P` to the identity.

Move the line-bundle restriction argument to a `\begin{remark}` block
titled "Classical description" mirroring the treatment in
`def:ofCurve`.

### MUST-FIX: rewrite `thm:exists_unique_ofCurve_comp` proof block

Same situation: the Lean closure is the field projection
`((jacobianWitness C).isAlbaneseFor P).exists_unique_ofCurve_comp f hf`.
The current proof sketch is a classical universal-property argument.

Rewrite the proof block as a structured two-step argument:

1. **Lean closure**: by Definition~\ref{def:IsAlbanese} of
   `IsAlbanese C P J`, the existence-and-uniqueness assertion is
   precisely the `(Classical.choose_spec h).2 f hf` projection from
   the universal-property field of the Albanese witness.

2. **Classical description (remark)**: the classical proof goes
   through the Pic-scheme representability + Stein factorisation of
   the Abel-Jacobi morphism. Documented in
   Chapter~\ref{chap:Jacobian} `thm:nonempty_jacobianWitness` Route A.

### Keep with minor revisions

- The chapter's introductory paragraphs framing the Abel-Jacobi map
  and the Albanese universal property.
- The cross-reference chain to Chapter~\ref{chap:Jacobian}.

## Out of scope

- Do NOT add new declaration blocks beyond the three already
  protected.
- Do NOT modify `Jacobian.tex` (the planner is dispatching a
  separate writer for that).
- Do NOT modify Lean files. The Lean implementation already uses
  the Albanese-projection route.

## References

- Mathlib `Mathlib.AlgebraicGeometry` for the scheme-theoretic
  setup. The project file `AlgebraicJacobian/AbelJacobi.lean` (status
  docstring at L14–28) describes the witness-projection reduction in
  natural language.
- The companion chapter `Jacobian.tex` `def:IsAlbanese` and
  `thm:nonempty_jacobianWitness` for the witness-pattern formalism.

## Expected outcome

The chapter's three protected-declaration blocks lead with the
Albanese-projection mathematical content (the route the Lean
formalisation actually follows). The classical Pic-scheme /
line-bundle prose is preserved as `\begin{remark}` blocks for
forward-looking reference. Total chapter length is similar to the
current; the content shape is the Layer-I/Layer-II split that
`Jacobian.tex` already uses.
