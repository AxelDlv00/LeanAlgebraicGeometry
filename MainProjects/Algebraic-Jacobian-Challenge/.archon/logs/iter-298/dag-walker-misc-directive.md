# DAG Walker Directive

## Slug
misc-cluster

## Seed
chap:Albanese_AuslanderBuchsbaum (40 in-cone, 5 disconnected helpers) and
chap:RiemannRoch_OCofP (24 in-cone, 2 disconnected helpers). Wire both small clusters into
their chapters' goal cones.

## Strategy context
Auslander–Buchsbaum: the projective-dimension / depth machinery (`projective_dimension`,
the `hasProjectiveDimensionLT` induction lemmas) underpinning the codimension argument used in
the Albanese extension. RiemannRoch_OCofP: the line bundle `O_C(P)` and its global sections (RR.3);
the two disconnected lemmas are local-unit / local-lift facts about the order/valuation of sections
at the closed point P that the global-sections computation consumes.

## Depth / scope
For each cluster, read the chapter, find the consuming theorem, and add the missing `\uses{}` edges;
complete each helper's own `\uses{}`. Statements unchanged; `\uses{}` wiring only (plus a missing
block only if a `\uses` target has none).

### Clusters (Lean basenames; find blueprint labels)
Auslander–Buchsbaum (5): projective_dimension, hasProjectiveDimensionLT_ker_of_surjection,
hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker,
hasProjectiveDimensionLT_succ_of_projectiveDimension_eq, projectiveDimension_ker_eq_of_surjection
RiemannRoch_OCofP (2): lineBundleAtClosedPoint_functionField_localUnit_of_orderZero_at_primeDivisor,
lineBundleAtClosedPoint_localLift_of_log_ordFrac_eq_zero

## References
- `references/stacks-algebra.md` (depth, projective dimension) for Auslander–Buchsbaum if a
  statement needs a source. Prefer `\uses{}` wiring over rewrites.

## Out of scope
- Edit ONLY `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` and
  `blueprint/src/chapters/RiemannRoch_OCofP.tex`.
- No `\leanok`. Wiring (`\uses{}`) only, plus missing blocks if a `\uses` target is undefined.
