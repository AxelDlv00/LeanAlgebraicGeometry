# Blueprint Writer Report — rr-broken-uses-fix (iter-175)

## Summary

Closed both broken `\uses{cor:nonconstant_function_genus_zero}`
references in `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
via **Branch A** (the directive's strongly-preferred resolution): added
a second `\label{cor:nonconstant_function_genus_zero}` as an alias on
the existing `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`
corollary block in `blueprint/src/chapters/RiemannRoch_OCofP.tex`. No
content duplication, no edits to `RationalCurveIso.tex`.

## Diagnosis

The blueprint-doctor's broken-refs flag tracked `\uses{}` references
to `cor:nonconstant_function_genus_zero` at two sites in
`RiemannRoch_RationalCurveIso.tex`:

- L334: inside `\thm:genus_zero_curve_iso_p1`'s `\uses{...}` annotation
  (the headline theorem block)
- L379: inside the matching `\begin{proof}` block's `\uses{...}`
  annotation

The intended target was the RR.3 corollary that produces a non-constant
rational function on a genus-0 curve from `dim_{k̄} H⁰(C, O_C(P)) = 2`.
That corollary already lives in `RiemannRoch_OCofP.tex` L481--514 under
the verbose label `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`.
The RR.4 writer used a shorter mnemonic short-name; the dependency
graph reader saw no matching `\label`.

## Resolution

Branch A: in `RiemannRoch_OCofP.tex` between L485--486 I inserted a
second `\label{cor:nonconstant_function_genus_zero}` immediately after
the existing `\label{cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero}`,
with a brief LaTeX comment explaining the alias. Both labels now
resolve to the same corollary block (leanblueprint accepts
multiple-label aliasing on a single environment; both feed the
dependency graph identically).

### Why Branch A over Branch B (renaming the `\uses{}` in RR.4)

Branch A preserves the RR.4 writer's intent verbatim — the
`RationalCurveIso.tex` short name is the more human-readable label of
the dependency-graph node, and the alias additionally documents the
RR.3 → RR.4 wiring inside RR.3 itself (the `% Alias label consumed
under the shorter name by ...` comment).

Branch B would have required two edits in `RationalCurveIso.tex` (L334,
L379) and left RR.3 unaware of its downstream consumer. Branch A is a
single additive edit in RR.3 with zero edits in RR.4 — strictly
fewer touchpoints and aligned with the directive's stated preference.

## Edits

Exactly one file touched:

- `blueprint/src/chapters/RiemannRoch_OCofP.tex` — inserted three lines
  (one alias `\label` + a two-line comment) immediately after the
  existing `\label{cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero}`
  at L485.

No other files were modified. `RationalCurveIso.tex` is untouched.
No `\lean{...}`, `\leanok`, or `\mathlibok` markers were modified.

## Out-of-scope items honored

- Did not rewrite chapter prose in either file.
- Did not add unrelated declarations.
- Did not touch any `\leanok`/`\mathlibok` markers.
- Did not change other chapters.
- Did not modify any `\lean{...}` pins or other `\label{...}` lines.

## Expected blueprint-doctor outcome (iter-176)

- `broken_refs` count for the `RationalCurveIso.tex` ⇄ `OCofP.tex`
  pair drops from 2 to 0 (the two `\uses{cor:nonconstant_function_genus_zero}`
  on RR.4 L334 and L379 now resolve to the aliased label on RR.3 L487).
- The new `cor:nonconstant_function_genus_zero` label points to a
  block with a valid `\lean{}` pin, so the dep-graph node carries the
  correct Lean target.

## Verification trace

After the edit, the relevant grep state is:

- `nonconstant_function_genus_zero` (the short name) appears on:
  - `RiemannRoch_RationalCurveIso.tex:334` — `\uses{...}` consumer (theorem block)
  - `RiemannRoch_RationalCurveIso.tex:379` — `\uses{...}` consumer (proof block)
  - `RiemannRoch_OCofP.tex:487` — the new `\label{}` producer (alias)

The producer-to-consumer triangle is now complete.
