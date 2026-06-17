# Lean ↔ Blueprint Checker — FGAPicRepresentability iter199

## Files in scope

- Lean: `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
- Blueprint: `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`

## Iter-199 changes

Lean: carrier-soundness refactor on Sorry 4
(`smoothProperQuotient`, formerly L354). Added:
- typeclass `HasSmoothProperQuotient` (Prop, L320–L341)
- global default instance `instHasSmoothProperQuotient` (L346–L349)
  carrying a single `⟨sorry⟩` site
- rewrote `smoothProperQuotient` (L377–L391) to take
  `[HasSmoothProperQuotient α]` hypothesis and extract via the
  typeclass field. **Theorem body is now axiom-clean.**

File-level sorry count: 7 → 7. The free sorry at the old L354 moved
to a `⟨sorry⟩` instance constructor at the new L349 — same
carrier-soundness probe pattern as the other 6 sorries in this file.

Sorries 1, 2, 3 (instHasPicSharp, instHasDivFunctor, instHasAbelMap)
NOT addressed — prover explicitly rejected tautological
`Functor.const (PUnit)` closures as headline-laundering per the
iter-198 review CRIT-0 finding.

Blueprint: plan-phase iter-199 applied the `\cref{df:Pfs}` →
`\cref{def:rel_pic_sharp}` fix.

## What to check (bidirectional)

1. Does the chapter's `subsec:sorry_smooth_proper_quotient` accurately
   describe the carrier-soundness refactor that landed iter-199?
   I.e., does the chapter explain that the theorem body is now
   axiom-clean and the sorry lives in `instHasSmoothProperQuotient`?
2. Stale `\lean{...}` pins after the refactor?
3. The blueprint's Rank-2 closure path for Sorry 4 — is it still
   accurately describing the Mathlib gap (Altman-Kleiman + EGA IV
   8.11.5)?
4. The new typeclass `HasSmoothProperQuotient` — does it need a
   `\lean{...}` pin (it is private helper substrate, not necessarily
   pin-worthy)?
