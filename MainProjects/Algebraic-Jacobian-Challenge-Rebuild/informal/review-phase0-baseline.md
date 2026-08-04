# August 2026 review: Phase 0 baseline

This ledger records the reproducible audit required by the binding execution plan in
`Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf`.
The review route is the AJCR-first rank-one atlas followed by finite-Galois descent. The old
high-degree direct-Abel and representation-free campaigns are not the objective of this audit.

## Pinned revisions

`pre-major-growth` is an operational pin, not a revision named by the PDF. It is the last
workspace revision before the first sustained AJCR source-growth interval beginning on 2026-07-28.
Daily net AJCR Lean growth then remained large through 2026-08-01. From this pin to task start,
403 AJCR Lean files changed by 90,571 insertions and 410 deletions.

| Label | Ledger revision | Provenance |
| --- | --- | --- |
| `pre-major-growth` | `8a5dc2a668bad0fc4b5c856c1dc52a4d81759a23` | Last revision before the sustained 2026-07-28 AJCR growth interval |
| `run0108` | `9adb1151738acc7ae54e6905c78feb253f2184b0` | Workspace state recorded by run 0108 |
| `run0109` | `8c9ea0abc7566c139e86a5ba1c6aa8f038766850` | Workspace state recorded by run 0109 |
| `task-start` | `c37b414342de8a9df92753c1eec71f9a5fcab5c7` | Run 0119 system baseline |
| `review-root` | `a4046bdead6237b9b802814303143b3c8d48ad28` | Rooted legacy-route guard plus its audit census |
| `affine-guard` | `e71f31f893b273bb93ac45cbe3cec8dda8ccd3db` | Rooted stop theorem for the live arbitrary-affine Abel map |

The AJCR Lean source trees at `run0108` and `run0109` are byte-identical. Their distinct pins are
retained because their Horizon provenance is distinct.

Reproduce the static audit without a checkout or the shared index:

```bash
python3 scripts/review_phase0_audit.py \
  pre-major-growth=8a5dc2a668bad0fc4b5c856c1dc52a4d81759a23 \
  run0108=9adb1151738acc7ae54e6905c78feb253f2184b0 \
  run0109=8c9ea0abc7566c139e86a5ba1c6aa8f038766850 \
  task-start=c37b414342de8a9df92753c1eec71f9a5fcab5c7 \
  review-root=a4046bdead6237b9b802814303143b3c8d48ad28 \
  affine-guard=e71f31f893b273bb93ac45cbe3cec8dda8ccd3db
```

The script reads immutable commit objects from `HORIZON_LEDGER_GIT_DIR`, strips Lean comments and
strings before token counts, and computes reachability from `AlgebraicJacobian.lean`.

## Static measurements

| Metric | Pre-major | Run 0108/0109 | Task start | Review root | Affine guard |
| --- | ---: | ---: | ---: | ---: | ---: |
| Library modules | 626 | 926 | 969 | 971 | 971 |
| Root-reachable modules | 558 | 909 | 950 | 952 | 952 |
| Unrooted modules | 68 | 17 | 19 | 19 | 19 |
| Lean lines, all/rooted | 172,445 / 156,958 | 254,009 / 251,259 | 262,949 / 259,926 | 263,109 / 260,086 | 263,320 / 260,297 |
| Rooted lexical `sorry` tokens | 15 | 15 | 15 | 15 | 15 |
| Rooted explicit `axiom` declarations | 0 | 0 | 0 | 0 | 0 |
| `maxHeartbeats` occurrences | 306 | 708 | 725 | 725 | 725 |
| `maxRecDepth` occurrences | 121 | 301 | 304 | 304 | 304 |
| `maxSynthPendingDepth` occurrences | 219 | 487 | 500 | 501 | 501 |

All 15 rooted `sorry` tokens are pre-existing in `AlgebraicJacobian/Challenge.lean`. The review
adds no `sorry` and no project axiom. `#print axioms` on the three divisor producers and the new
route guard reports only `propext`, `Classical.choice`, and `Quot.sound`. As a control,
`#print axioms AlgebraicGeometry.Jacobian` still reports `sorryAx` through the challenge file.

## Carrier and consumer census

| Carrier | Pre-major | Run 0108/0109 | Task start/review root | Affine guard |
| --- | --- | --- | --- | --- |
| `DivFamZar` | 21 files, 305 occurrences, 13 outside named implementation modules | 50 files, 516 occurrences, 42 outside | 51 files, 519 occurrences, 43 outside | 51 files, 523 occurrences, 43 outside |
| `DivFamZarAff` | absent | 30 files, 417 occurrences, 13 outside named implementation modules | 36 files, 431 occurrences, 19 outside | 36 files, 432 occurrences, 19 outside |

The widened arbitrary-affine carrier has therefore not superseded `DivFamZar`. The canonical
arbitrary-degree producer `divFunctorAff_representableBy_at` is rooted but has no consumer. The
genus producer still uses a duplicate diagonal construction, and the admissible producer calls
the lower-level representer directly. Phase 2 is not complete, and broad propagation must remain
frozen until one named consumer is installed.

## Critical root

`AlgebraicJacobian/Picard/Pic0CriticalPath.lean` is imported by the umbrella root. It checks the
three current divisor producers, retains the legacy stop theorem as a comparison input, and roots
the following proof chain for the live arbitrary-affine route:

1. `not_injective_abelSigmaChartAff_of_divFamZarAff` turns two distinct widened families with equal
   chart value into noninjectivity of `abelSigmaChartAff`, including its structure component.
2. `not_injective_chartValueAff_of_not_injective_chartValue` transports the field-dictionary
   obstruction through the injective old-to-widened vehicle and `chartValueAff_toAff`.
3. `not_isOpenImmersion_abelSigmaChartAff_of_not_injective_chartValueAff` consumes the first lemma
   and the injectivity consequence of a presheaf open immersion.
4. `not_isOpenImmersion_abelSigmaChartAff_of_genus_lt_degree` uses Riemann's inequality and an
   effective replacement to supply the noninjective pair whenever a degree-`n` divisor exists
   after a field extension and `genus C < n`.

The explicit divisor over the extension field is load-bearing: without a nonempty source, the
empty Abel map could be an open immersion. Every other explicit hypothesis in the main theorem is
used, and the theorem assumes no rational point on the curve. Five geometric and cohomological
`relCurve` instances are derived locally from the standing curve package rather than exposed as
caller obligations. The theorem's public type names the finite map used to obtain the pair, the
actual `divFunctorAff` representation, and the extension-field divisor. It is stronger than the
PDF's positive-genus guard because positivity is unnecessary. It is a rooted terminal stop
condition, not a consumed headline milestone.

The following required endpoints are still absent and receive no milestone credit:
`PicRankOneOpen`, `DivRankOneOpen`, `rankOneAbel`, `divisorOfRankOne`,
`rankOneAbelIso`, `rankOneAbel_isOpenImmersion`, `rankOne_translate_cover_sepClosed`,
`exists_translation_mem_picRankOneOpen`,
`pic0_sepClosed_representableBy`, `representableBy_of_finiteGalois_baseChange`,
`pic0_representableBy`, and `jacobianData`. The unrooted `DivSchemeRedesignRankOneFibre` and
`DivSchemeRedesignRankOneChart` files contain only fibrewise linear-algebra experiments, not the
family-level Picard loci or canonical inverse required by the plan.

## Kernel and resource gates

| Revision/tree | Command | Result | Wall time | Maximum RSS |
| --- | --- | --- | ---: | ---: |
| Review root | `lake build AlgebraicJacobian.Picard.Pic0ChartAbelNonInjective` | success | 16.17 s | 6,963,048 KB |
| Review root | `lake build AlgebraicJacobian.Picard.Pic0CriticalPath` | success | 22.27 s | 7,079,200 KB |
| Review root | `lake build AlgebraicJacobian` | success | 13.36 s | 7,171,836 KB |
| Affine guard (warm cache) | `lake build AlgebraicJacobian.Picard.Pic0CriticalPath` | success | 6.96 s | 971,360 KB |
| AJC current | `lake build AlgebraicJacobian.Picard.GaloisDescent.GaloisQuotientOverlap` | success | 21.57 s | 6.96 GB |
| AJC current | `lake build AlgebraicJacobian.Picard.PicEtDescentGoal` | success | 11.11 s | 6.91 GB |
| AJC current | `lake build AlgebraicJacobian.Picard.PicEtGaloisQuotient` | success | 9.49 s | 6.85 GB |

The historical revisions are immutable static-census pins, not separate kernel acceptance gates;
the earlier draft's three `in flight` rows had no retained result and are no longer presented as
running work. The executable gate is the current critical root. No new heartbeat or
recursion-depth raise was introduced. The route guard uses the project-wide
`maxSynthPendingDepth = 3` convention locally. AJC's quotient capstone adds no proof-budget raise;
`PicEtDescentGoal` retains four pre-existing local `maxHeartbeats 1000000` blocks.

## AJC descent inventory

AJC already has a rooted finite-Galois scheme quotient through
`GaloisDescent/GaloisQuotientOverlap.lean`: the capstone supplies `gluedQuotient`,
`gluedQuotientMap`, `gluedQuotientBaseChangeIso`, and the pinned
`gluedGaloisQuotientWitness`. AJCR should consume that explicit witness rather than choose a
quotient independently from a typeclass.

Representation descent is currently `picEt`-specific. The chain
`semilinearGalActionOfRepresentableBy`, `representableBy_of_galInvariantEquiv`, and
`representableBy_picEt_of_galoisQuotient` is consumed by `PicEtGaloisQuotient.lean`, which returns
both a quotient scheme and representability. There is no generic
`representableBy_of_finiteGalois_baseChange`: a generic version also needs an effective-descent
equivalence for the functor and compatibility with the representing action. Before that capstone,
the rank-one route must still spread a separable-closure representative and universal element to
a finite Galois level. No AJC source was changed in Phase 0.

## Decision

Phase 0 is complete: it has a reproducible ledger audit, a narrow rooted target, and a terminal
negative guard for the live arbitrary-affine Abel map. The final theorem kernel-checks and its axiom
audit reports only `propext`, `Classical.choice`, and `Quot.sound`. The future rank-one,
separably-closed, descent, and Jacobian endpoints remain absent and receive no credit. The next
honest production edge is the Phase 1 canonical `relCurve C A` interface and endgame contract,
followed by the capped Phase 2 producer specialization. The high-degree quotient fallback
conditions are not met, so that route remains closed.
