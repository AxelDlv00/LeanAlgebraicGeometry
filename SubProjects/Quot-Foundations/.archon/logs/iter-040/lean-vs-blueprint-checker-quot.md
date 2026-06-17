# lean-vs-blueprint-checker directive — iter-040

## Lean file (absolute path)
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter (absolute path)
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

## Context
This iter the prover added 4 axiom-clean declarations toward the gap1 "section-transport producer":
- `compositeBasicOpenImmersion` (def, ~line 1950) — composite open immersion
  `j = isoSpec.inv ≫ ι_W ≫ ι_{q.X i} : Spec Γ(q.X i, ι⁻¹ᵁ D(s)) ⟶ Spec R`. Prover reports this is a
  NEW `lean_aux` def with no dedicated blueprint block.
- `pullback_composite_immersion_isIso_fromTildeΓ` (theorem, ~1969) — producer (a); prover says it
  corresponds to existing block `lem:pullback_composite_immersion_isIso_fromTildeΓ`.
- `compositeBasicOpenImmersion_isOpenImmersion` (instance, ~1991) — NEW `lean_aux`, no block.
- `compositeBasicOpenImmersion_opensRange` (theorem, ~2002) — the RANGE half of
  `lem:composite_immersion_range_basicOpen`. The blueprint block bundles a fuller statement (range +
  f-locus + σ); only the range identity `j.opensRange = D(s)` is in Lean so far.

## What to report (bidirectional)
1. Lean → blueprint: do the 4 new decls' Lean statements match their blueprint blocks? Flag any
   fake/placeholder statement or signature mismatch with the pinned `\lean{...}`.
2. blueprint → Lean: is `lem:composite_immersion_range_basicOpen` mis-pinned (its `\lean{}` points at
   the full bundled statement but only the range half exists in Lean)? Should it get a `% NOTE`
   flagging partial formalization?
3. Coverage debt: the two NEW `lean_aux` decls (`compositeBasicOpenImmersion`,
   `compositeBasicOpenImmersion_isOpenImmersion`) have no blueprint entry. Confirm and name them.
4. Is the blueprint chapter detailed enough to guide the still-blocked TOP producer
   (`section_localization_hfr_basicOpen`), or too thin?

Report must-fix-this-iter items separately from coverage debt.
