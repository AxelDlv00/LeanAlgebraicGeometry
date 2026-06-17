# progress-critic pc263 — convergence audit of the three active Route-A lanes

Assess convergence per route from the extracted signals below. Do NOT read STRATEGY/blueprint;
your question is convergence (sorry-elimination + structural advance over K iters), not strategy or
math correctness.

## Route DUAL — `Picard/TensorObjSubstrate/DualInverse.lean` (target `sliceDualTransport` → `dual_restrict_iso`)
Strategy: phase A.1.c.sub; current `Iters left` estimate ~8–14; route entered the route-2 (by-hand
`sliceDualTransport`) build at iter-261.
- iter-260: route-1 refuted as structurally insufficient; reduced 1 step; decl-sorry 2→2.
- iter-261: Module-instance wall RESOLVED (`set β`+pinned m₁/m₂); leg-A built categorically via `.map`;
  `sliceDualTransport` opened to skeleton + 7 typed sub-holes; decl-sorry 2→2.
- iter-262: leg-B ε-iso CLOSED via 2 new axiom-clean named decls (`isIso_ε_restrictScalars_appIso`,
  `dualUnitRingSwap`); codomainMap filled by defeq; `sliceDualTransport` internal holes 7→6; decl-sorry 2→2.
  The armed STUCK-watch BAR ("close the leg-B ε-iso") was MET this iter.
- Recurring blocker phrases: "internalHomObjModule-add vs Hom-add syntactic mismatch" (NEW iter-262,
  blocks map_add'/map_smul'); "invFun reverse construction ~150-250 LOC not yet built".
- Helpers added per iter: 0 / 1 (leg-A) / 2 (leg-B). Decl-sorry flat at 2 across 3 iters (monolithic
  decl — internal typed holes 7→6 this iter).

## Route D3′ — `Picard/TensorObjSubstrate.lean` (target Sq1 `sheafificationCompPullback_comp`)
Strategy: phase A.1.c.sub; current `Iters left` ~8–14; the Sq1 sub-target entered active prove at iter-261.
- iter-260: `pushforwardComp_lax_μ`+`pullbackComp_δ` CLOSED (Sq2b done); file-sorry 3→2.
- iter-261: `pullbackTensorMap_restrict` opened to 4-vs-10 factor identity; Sq1 extracted as NEW lemma
  `sheafificationCompPullback_comp` with partial proof; file-sorry 2→3 (genuine decomposition).
- iter-262: Sq1 R0 factor `(pullbackComp h f).inv` FULLY PEELED in compiling code (new axiom-clean helper
  `sheaf_unit_comp_pushforward_pullbackComp_inv` + `conv_rhs` + `erw`-splice); Sq1 still ends in sorry
  (R1/R5 collapse tail remains); file-sorry 3→3. This is the 2nd consecutive PARTIAL with no full Sq1 close.
- Recurring blocker phrases: "R1/R5 collapse tail" (the ~30-line analog of `pullbackObjUnitToUnit_comp`
  L969-996; building blocks named: `homEquiv_leftAdjointUniq_hom_app`, `pushforwardComp.hom.naturality`,
  `comp_unit_app`/`unit_naturality`).
- Helpers added per iter: 0 (Sq2b close) / Sq1-extracted / 1 (R0-peel helper). Sq1 sub-target: 2 PARTIAL
  rounds, no close.

## Route ENGINE — `Cohomology/CechHigherDirectImage.lean` (target `CechNerve`/`CechComplex`)
Strategy: phase A.2.c-engine; this lane opened iter-261 (scaffold), first real-content iter was 262.
- iter-261: NEW file scaffolded; 6 decls; 5 typed sorry + 1 real def; file-sorry n/a→5.
- iter-262: 3 axiom-clean decls added (`coverArrow`/`coverCechNerve`/`relativeCechComplexOfNerve`);
  `CechComplex` rewritten to a genuine body (honest reduction, not a disguised sorry); file-sorry 5→4.
  Lone remaining hole `CechNerve`'s push-pull functor `G`; its `map_id`/`map_comp` need the SAME
  coherence as Route D3′ (discovered coupled, NOT import-independent at the hard step).
- Recurring blocker phrases: "G's eqToHom-along-Over-triangle + pushforwardComp/pullbackComp coherence
  wall" (NEW iter-262); cheap independent brick `Gobj`/`Gmap` (no functor laws) can land.
- Helpers added per iter: scaffold / 3 axiom-clean decls. Genuine file-sorry reduction 5→4 in 1 content iter.

## This iter's proposed `## Current Objectives` (file count + basenames)
3 files: `Picard/TensorObjSubstrate.lean` (close ONLY the R1/R5 tail of Sq1, NOT the monolith),
`Picard/TensorObjSubstrate/DualInverse.lean` (close the internalHomObjModule add/smul bridge → map_add'/
map_smul' 6→4, then build invFun), `Cohomology/CechHigherDirectImage.lean` (mathlib-build the independent
`Gobj`/`Gmap` brick ONLY; defer `Gmap_id`/`Gmap_comp` to after D3′).

## Questions for you
1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the signals you rely on.
2. For D3′ specifically: is the planned "close ONLY the R1/R5 tail" round the right corrective, or has the
   2-PARTIAL pattern crossed into needing a fine-grained decomposition of that tail into its own named lemma?
3. For DUAL: does the 7→6 internal-hole motion (with the named, well-scoped next reduction) count as
   converging, or is the flat decl-sorry=2 still a STUCK signal?
4. Dispatch-sanity on the 3-file proposal (note the Picard import coupling: DualInverse imports
   TensorObjSubstrate; the engine file is import-independent).
