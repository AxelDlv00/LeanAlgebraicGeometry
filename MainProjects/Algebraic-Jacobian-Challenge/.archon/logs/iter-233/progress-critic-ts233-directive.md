# Progress-critic directive — iter-233

Assess convergence per active route. Two routes are live this iter.

## Route TS — relative-Picard ⊗-group law (`Picard/TensorObjSubstrate.lean` + split sub-files)
Strategy `Iters left` for this phase (A.1.c.SubT): ~3–5. Phase entered: ~iter-217.

Signals, last 5 iters (canonical project sorry count from meta.json):
- iter-228: 80. C-bridge tripwire fired (genuine hard-block at H2′). PARTIAL. Helpers added: ~3 (dualIsoOfIso family).
- iter-229: 80. Built shared root `overSliceSheafEquiv` axiom-clean (~3 decls). No sorry closed. PARTIAL.
- iter-230: 80. Binding probe — shared root does NOT serve the C-bridge consumer (3-axis refutation). 0 edits committed (probe in scratch). PROBE/DOES-NOT-CLOSE.
- iter-231: 80. Re-scoped C-bridge to minimal objectwise lemma behind hard gate. 0 code edits. NO-EDIT STALL. Gate FAILED.
- iter-232: 80. STRATEGY PIVOT: carrier changed from locally-trivial to tensor-invertibility `IsInvertible` (inverse = free membership witness); dual/`exists_tensorObj_inverse` demoted to deferred bridge; file split 3 ways. No group-law decl built yet (deferred to iter-233 pending blueprint re-clear).
- Recurring blocker phrases (now demoted): "dual_restrict_iso presheaf-level over varying ring 𝒪(V)", "no packaged dual-commutes-with-pushforward".
- iter-233 PROPOSAL: scaffold + prove the NEW group-law decls on the `IsInvertible` carrier (`picCommGroup`, `IsInvertible.tensorObj`, `isInvertible_unit`, `IsInvertible.inverse_unique`, `tensorObj_assoc_iso_invertible`, `PicGroup`). Inverse is free (witness); associator restricted to flat=invertible modules to bypass the vestigial flatness-free whiskering sorry. This is the FIRST group-law build on the new carrier — categorically different work from the 15-iter dual stall.

## Route Engine — cohomology foundations (parallel, de-gated iter-232)
Strategy `Iters left` for A.2.c-engine: ~30–60. Phase entered: iter-232.
- iter-232: NEW lane `Cohomology/FlatBaseChange.lean`. Built `pushforwardBaseChangeMap` axiom-clean (0 sorry); 2 honest sorries (`affineBaseChange_pushforward_iso` PARTIAL real reduction, `flatBaseChange_pushforward_isIso` deferred). File orphan (not imported) — being wired this iter.
- iter-233 PROPOSAL: wire the import (mechanical, via refactor); scaffold the next engine file `Cohomology/HigherDirectImage.lean` from its (already-written) chapter.

## Your job
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). For TS: is the carrier pivot a genuine route change (categorically different work) or cosmetic re-labeling of the same stall? Name the corrective TYPE if CHURNING/STUCK. For Engine: too early to judge (UNCLEAR ok). Be concrete.
