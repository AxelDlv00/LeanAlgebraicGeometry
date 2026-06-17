# Iter-052 plan — 02KG residual SOLVED; discharge tops (Lane A) + re-route augmented resolution (Lane B)

## Entering state (verified)
iter-051 ran BOTH dispatched lanes:
- **Lane 1 (`CechAcyclic.lean`) SOLVED** — the 02KG residual `htilde` is now the axiom-clean theorem
  `sectionCech_homology_exact_of_localizationAway` (route B, change-of-ring; +3 public/private decls:
  `dDiff_exact_of_localizationAway`, `isLocalizedModule_comp_away`, private `sectionCechAbExact_loc`).
- **Lane 2 (`CechHigherDirectImage.lean`) PARTIAL** — augmented-complex OBJECT layer built (+6 axiom-clean:
  `cechAugmentedComplex`+5 companions). The exactness theorem `cechAugmented_exact` NOT added: the iter-051
  stalk-at-prime plan hit a genuine Mathlib gap (no `SheafOfModules.stalk`, no exact-iff-stalkwise). No sorry.

Project inline-sorry = 2 (both frozen/superseded: `CechHigherDirectImage.lean:780` protected P5b;
`CechAcyclic.lean:110` dead `affine`). Build GREEN. lean-auditor `iter051` 0 must-fix/0 major; both
lean-vs-blueprint checkers found the new Lean faithful but flagged blueprint coverage debt (9 new helpers).

## What I did this phase
1. Processed iter-051 results → `task_done.md` (Lane-1 SOLVED, Lane-2 object layer) + refreshed
   `task_pending.md` header + 02KG/P5a sections; cleared the two prover result files.
2. Ran the three read-only consults in parallel (all returned):
   - **mathlib-analogist `stalkwise`** (the key one) — recommended the **sections/sheafification route** for
     `cechAugmented_exact` over building a stalk functor; gave a 4-step decomposition + Mathlib citations.
     `analogies/stalkwise-exact-xmodules.md`.
   - **progress-critic `iter052`** — Route 1 CONVERGING, Route 2 UNCLEAR; must-fix: firm Lane B to a real
     lane this iter (don't start a two-step "wait for gate" avoidance pattern).
   - **strategy-critic `iter052`** — Route A SOUND; CHALLENGE on the old stalk sub-route (couples to the
     `PreservesFiniteColimits(toSheaf)` gap); the naive affine-basis route is CIRCULAR; STRATEGY format DRIFTED.
3. **Adjudicated the `cechAugmented_exact` route fork → sections/sheafification (Decision D1).**
4. Updated STRATEGY.md: 02KG → CLOSING; P5a row re-framed to the sections route; reframed the Mathlib gap;
   marked `PreservesFiniteColimits(toSheaf)` DONE; excised the completed `### 01I8` Routes subsection to a
   one-liner; collapsed multi-sentence table cells; scrubbed in-prose iter refs. Size 15.8 KB → 12.5 KB.
5. blueprint-writer `iter052` cleared the 9-helper coverage debt (route-B helper blocks + object-layer blocks)
   AND rewrote the `lem:cech_augmented_resolution` proof to the sections/sheafification route + fixed the two
   hint-precision defects. blueprint-clean `iter052` purified. **blueprint-reviewer `iter052` (whole-blueprint)
   HARD GATE CLEARS both lanes, 0 must-fix** (2 informational: name `combDifferential_exact` in Step 4; a
   `def:`-on-`lemma` cosmetic label).
6. Wrote PROGRESS `## Current Objectives` with the two lanes (both parser-validated: scaffold token on each
   `.lean`-path heading, 0 stop-markers anywhere in the section).

## Decision made

### D1 — `cechAugmented_exact` via sections/sheafification, NOT stalk reflection, NOT the naive affine-basis route.
- **Chosen:** the analogist's sections/sheafification route — reflect exactness through faithful `toSheaf`
  (`reflects_exact_of_faithful`, needs only `Faithful`+`PreservesZeroMorphisms`), `homologyIsoSheafify`
  (built) gives homology-sheaf = sheafify(presheaf homology), locally zero on the affine basis
  (`sectionCech_affine_vanishing`) ⟹ vanishes by `LocallyBijective` W-equivalences.
- **Why:** (a) it is the Mathlib-idiom specialist's explicit recommendation with named decls; (b) maximal
  reuse of already-built project infra (`homologyIsoSheafify`, `sectionCech_affine_vanishing`) — least novel
  construction; (c) it DODGES the `PreservesFiniteColimits(toSheaf)` coupling that the strategy-critic
  objected to in the stalk route (the reflection needs only faithful+zero-preserving, both present).
- **LOC/risk:** ~250–420 LOC; highest risk in step-3 mapHomology-vs-concrete-sections plumbing (diamond-prone,
  cf. [[keystone-tile-reconciliation-not-rfl]]). Fallback = strategy-critic's local "insert index i" homotopy
  over each `Uᵢ` + restriction-exactness (needs `SheafOfModules` restriction-exact, unconfirmed).
- **Reversal signal:** if the step-3 plumbing proves intractable AND `SheafOfModules` restriction-to-open is
  cheaply exact in Mathlib, switch to the local-homotopy fallback.

### Response to strategy-critic CHALLENGE (must-fix #1 + #2)
The critic challenged the *old stalk-reflection sub-route* (couples to `PreservesFiniteColimits(toSheaf)`).
I did NOT adopt that route — I adopted the sections/sheafification route, which the analogist surfaced and
which ALSO avoids the colimit coupling (via `reflects_exact_of_faithful`). This satisfies "either adopt the
cheaper route or rebut." On must-fix #2: `PreservesFiniteColimits(toSheaf)` is NOT orphaned — it is already
BUILT (`toSheaf_preservesFiniteColimits` in `AffineSerreVanishing.lean`) and powers `affine_surj_of_vanishing`
in the cover-system; the chosen `cechAugmented_exact` route simply doesn't depend on it. STRATEGY updated to
mark it DONE. On must-fix #3 (format DRIFTED): restructured in place (12.5 KB, one-line cells, iter refs
scrubbed, 01I8 subsection excised).

### Reconciling analogist vs strategy-critic (they do NOT actually conflict)
The strategy-critic warned the "section complex exact over each affine `V`" route is circular (section
homology over `V` = `Ȟᵖ(V,{U_s∩V})` ≠ 0). The analogist's route is NOT that: the presheaf homology IS
nonzero, but its *sheafification* vanishes because it is locally zero on REFINEMENTS (on small `W ⊆ Uᵢ` the
restricted cover contains `W` itself ⟹ contracting homotopy = `sectionCech_affine_vanishing`). Sheafification
needs only local vanishing, which the affine basis supplies. Both are the same mechanism; the critic's
"circular" caveat is against the naive non-sheafified reading, which I explicitly avoid.

## Decision — two lanes, both firm
- **Lane A** `AffineSerreVanishing.lean` (CRITICAL, mechanical ~20–40 LOC) — discharge the two 02KG tops.
- **Lane B** `CechHigherDirectImage.lean` (DEEP ~250–420 LOC) — `cechAugmented_exact` via the new route.
  Firmed per progress-critic must-fix (no more "wait for gate" deferral; the route + blueprint are ready).

## Subagent skips
- (none — all four highly-recommended/used subagents dispatched: blueprint-reviewer, progress-critic,
  strategy-critic, plus mathlib-analogist + blueprint-writer + blueprint-clean.)
