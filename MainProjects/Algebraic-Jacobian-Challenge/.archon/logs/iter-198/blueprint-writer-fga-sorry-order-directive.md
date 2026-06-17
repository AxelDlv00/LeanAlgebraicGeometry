# Directive — blueprint-writer, FGA sorry-by-sorry closure order (iter-198)

## Mode
Update one chapter (`blueprint/src/chapters/Picard_FGAPicRepresentability.tex`) to add a precise sorry-by-sorry closure order for the 7 sorries currently in `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (1 free `sorry` at L354 + 6 `⟨sorry⟩` carrier-soundness instances at L149, L176, L236, L294, L409, L465). Iter-198 progress-critic verdict: CHURNING (5-iter zero-dispatch). The carrier-soundness probe alone does not constitute a progress plan.

## Strategy context (the slice that matters)

A.2.c — FGA Pic_{C/k} representability. The iter-196 carrier-soundness refactor isolated the 6 representability carriers as Prop-valued typeclasses (`HasPicSharp`, `HasDivFunctor`, `HasPicScheme`, `HasAbelMap`, `PicSharpRepresentable`, `PicSchemeGroupObject`). Iter-198 review-phase will run the abort verdict (`lean_verify`) on the typeclass consumers. The probe's purpose is structural soundness, NOT sorry closure.

Per STRATEGY.md "Pic representability is genuinely substrate-blocked on Route C (RR) for both Quot and Sym^d paths". The carrier-soundness probe permits downstream Route A work under typeclass abstraction. But the FGA file's 7 sorries themselves remain open. The blueprint chapter must spell out which sorry closes first, when, and what it requires — so iter-199+ provers know what to dispatch.

## Required content

Expand the `Picard_FGAPicRepresentability.tex` chapter with a new
section `§"Sorry-by-sorry closure order"` that, for each of the 7
sorries, states:

1. **Sorry location** (Lean file line; identifier name).
2. **Mathematical content** — what the sorry proves (one paragraph,
   project-notation).
3. **Mathlib prerequisites** — which Mathlib lemmas / definitions
   are required; state each as `exists` / `missing` /
   `needs-bridge` against Mathlib b80f227.
4. **Route C substrate dependency** — does this sorry require RR
   substrate to close? If yes, name the specific RR theorem
   (Hartshorne II.6.10, IV.1.3, etc.). If no, give the iter-199+
   closure recipe.
5. **Closure-order rank** — `1` (independent, closeable first) /
   `2` (depends on prior carriers + Mathlib gap) / `3` (depends on
   Route C re-engagement).

### Sorries (Lean L#'s, names from file inspection):

- **L149** — `⟨sorry⟩` for `HasPicSharp` instance:
  asserts `Pic^♯_{(C/k)ét}` is representable.
- **L176** — `⟨sorry⟩` for `HasDivFunctor` instance:
  divisor functor representability.
- **L236** — `⟨sorry⟩` for `HasPicScheme` instance:
  Pic scheme exists.
- **L294** — `⟨sorry⟩` for `HasAbelMap` instance:
  Abel–Jacobi map existence.
- **L354** — free `sorry` (the only one NOT inside an instance
  constructor) — `Functor.IsRepresentable` body for `representable`
  (the main A.2.c representability theorem).
- **L409** — `⟨sorry⟩` for `PicSharpRepresentable`:
  Pic^♯ is representable as a scheme.
- **L465** — `⟨sorry⟩` for `PicSchemeGroupObject`:
  Pic carries a group object structure.

For each, fill the 5-point checklist. The order matters: the
chapter should rank by feasibility, identifying which sorry to
attempt first when RR substrate becomes available (or, if any are
RR-independent, which to attempt under the carrier-soundness
probe in iter-199+).

## Citation discipline (mandatory)

For every external citation, include:
1. `% SOURCE: <pointer> (read from references/<file>)`.
2. `% SOURCE QUOTE:` — verbatim text from the source.
3. `\textit{Source: …}` as the first visible prose line.

Key references:
- **Kleiman, "The Picard scheme"** (FGA Explained Ch. 9):
  `references/kleiman-picard.pdf` (arXiv version) and
  `references/fga-explained.pdf` (book version; pp. 237+). §4
  (existence), §5 (Pic⁰).
- **Nitsure, "Construction of Hilbert and Quot Schemes"** (FGA
  Explained Ch. 5): `references/nitsure-hilbert-quot.pdf`. §5
  Quot construction.
- **Milne**, `references/abelian-varieties.pdf`, III.6 Prop 6.1
  / 6.4 (Pic⁰ / Albanese UP).
- **Mumford**, `references/mumford-abelian-varieties.pdf`, §10–14
  (Cartier-divisor representability for curve case).

## Out-of-scope

- Do NOT add `\leanok` or `\mathlibok` markers.
- Do NOT touch any other chapter.
- Do NOT modify Lean files.
- Do NOT propose a re-architecture of the carrier-soundness probe;
  it stands until the iter-198 review-phase abort verdict.

## --write-domain (passed by dispatcher)

- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- `references/**`
