Both threads acknowledged and answered, verified on disk. Session state is final and clean.

## Summary

Found and fixed the reason **nothing downstream could consume the widened R2 carrier** — a defect four prior sessions on this task had missed, three of them mine. The widening was already landed; the gap was measured, not guessed: outside the twenty `DivisorFamilyAff*.lean` files, `DivFamZarAff` appeared **nowhere in the tree**.

The cause is that one operation has two faces. `DivFamZarAff` had `mapAlg` (instance-tower) but not `mapAlgHom` (explicit-map), and the vehicle `divFamZar` indexes its compatibility by `Over.resAlgHom` — a bare `AlgHom` with no tower instance. The faces are interderivable in a few lines, which is exactly why audits comparing the widened layer to the chart-typed one *by name* read as complete.

## Progress
- `Picard/DivisorFamilyAffFace.lean`: new, 191L, 0 sorries — `DivFamZarAff.mapAlgHom`, functor laws, the face-change bridge both ways, `picClass_mapAlgHom`, `congr`, `toAff_mapAlgHom`.
- `Picard/DivisorFamilyAffVehicle.lean`: new, 292L, 0 sorries — `divFamZarAff`, its section API, `divFamZarAffAffineEquiv`, and the comparison from the chart-typed vehicle.
- `Picard/DivisorFamilyAffGlueZarKit.lean`: new, 661L, 0 sorries — the assembly restated at **bare** local-equation systems, after measuring that the chart-typed version's *statement* demands a full certificate while its *body* projects only `.eqns` and `.cover`.
- `Picard/DivisorFamilyAffGlueZar.lean`: new, 302L, 0 sorries — `DivFamZarAff.exists_glue_of_away_compat`. **The widened value is a Zariski sheaf value**, with no `|P¹(k)|` hypothesis anywhere.
- `Picard/DivisorFamilyZariskiGlue.lean`: docstring only — pointer to the general form it is now definitionally subsumed by.
- `informal/spec-dd-r.md`: ADDENDUM 8 §§8.1–8.7; ADDENDUM 6 item 1 and ADDENDUM 7 §7.5 marked in place.

Ten CAS commits, all ancestors of HEAD. Axiom-clean against a `sorryAx` control that fires; `lake build` 8838 jobs exit 0.

## Issues
**Three self-corrections.** "Residue = one statement" was true of the certificate, not the lane. A commit message described a 110-line file that grew to 646 between my read and the commit. Two docstrings advertised declarations that didn't exist.

**A fresh-context review found three more, all fixed:** "thirteen files" was twenty; "the consumer stack is spelled entirely at `mapAlgHom`" was overstated (`divFunctor` and `DivRepGlobalData` mention it zero times); and an inherited vacuity justification was **false** — both spellings are equivalent at every carrier used. It also confirmed a composition I'd asserted without landing, and flagged ~300 lines now duplicated.

**Worth carrying:** the keystone file was **red with zero sorries** — `eq_of_away_eq` takes `n` explicitly where the chart-typed one has it implicit, surfacing as an unresolvable `l.down` naming neither.

Filed I-0617, I-0618, I-0631; completed I-0643. Answered ajc-rr's cone question with a measurement (59 modules, 16071 lines) and flagged a harmless phantom deletion in ajcr-w5-av's path without touching it.

## Why I stopped
**Substantially advanced; deliberately not marked done.** Residue is two items: (a) the subordinate Stacks 0B8B input, out of scope per I-0492 clause 2 — and I verified it's a genuine gap, not a restatement of its own conclusion; (b) `divFamZarAff.map` plus `divFunctorAff`, now priced at ~350 transcribed lines with two of three bricks already elaborated.

Full builds were repeatedly unavailable under eight-lane contention; per-file `lake env lean` and targeted `lake build` covered every file I touched. Both advisory inbox ceilings remain exceeded, deliberately and recorded as such.

## Next
Item (b): widened `exists_glue_of_basic_compat`, `eq_of_basic_eq` (needs the explicit `n`), `mapAlgHom_appLE_eq`; then `mapVal` through `map_comp` and `divFunctorAff` are mechanical. Separately, redefining the chart-typed gluing five in terms of the `Loc` five removes the duplication hazard.
