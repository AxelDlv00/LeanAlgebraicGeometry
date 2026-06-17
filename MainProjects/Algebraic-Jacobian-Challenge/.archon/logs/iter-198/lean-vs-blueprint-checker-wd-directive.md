# lean-vs-blueprint-checker — WeilDivisor (slug wd-iter198)

## File

`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

## Blueprint chapter

`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Context (minimal)

iter-198 added 6 new axiom-clean substrate lemmas in §2 and §4
(non-Route-C parts of the file):
- §2: `Scheme.RationalMap.order_zero` (L233),
  `Scheme.RationalMap.order_mul_of_ne_zero` (L242),
  `Scheme.RationalMap.order_inv` (L258),
  `Scheme.RationalMap.order_units_inv` (L274).
- §4: `Scheme.WeilDivisor.degree_neg` (L488),
  `Scheme.WeilDivisor.degree_sub` (L497).

`rationalMap_order_finite_support` (now L325) non-zero branch was
NOT closed. The prover documented a structural blocker:
`[IsLocallyNoetherian X]` is insufficient — the proof needs
`[IsNoetherian X] = [IsLocallyNoetherian X] + [CompactSpace X]`.
A ~30-line explanatory comment was added at the sorry site.

L538 `principal_degree_zero` non-constant branch and L1108
`degree_positivePart_principal_eq_finrank` were UNTOUCHED per the
Route C PAUSE directive.

## Questions

- **Lean → blueprint**: do the chapter's §1 / §2 (general substrate
  sections) list the 6 new lemmas? Do they have `\lean{...}` pins?
- **Blueprint → Lean**: does the chapter discuss the
  `[IsLocallyNoetherian X]` vs `[IsNoetherian X]` typeclass gap
  the prover surfaced? If not, this is a chapter-side gap.
- Is the chapter's RR.1-specific section (Hartshorne II.6, §6
  positive-part / principal) clearly demarcated from the
  general-substrate sections?

## What to flag

- Missing `\lean{...}` pins for the 6 new lemmas.
- `\leanok` mismatches (sync_leanok ran iter=198 — but it did NOT
  touch `RiemannRoch_WeilDivisor.tex`; that's curious given the new
  decls — flag if `\leanok` should be there but isn't).
- Chapter prose that overstates closure of L325.
- Any chapter-side discussion of L249/L325 that still says "use
  `IsLocallyNoetherian X`" — that's now contradicted by the
  prover's finding.
