# Blueprint Reviewer Directive

## Slug
cyclefix283

## Strategy snapshot
Single overarching goal: formalize Christian Merten's Jacobian challenge
(`references/challenge.lean.ref`) — the Jacobian of a smooth proper geometrically
integral curve, via the Route-A Picard substrate, while Riemann–Roch stays frozen
by the permanent USER Route-C pause.

### Phases & estimations (verbatim from STRATEGY.md)
| Phase | Status | Iters left |
|-------|--------|-----------|
| A.1.c.sub — comparison iso on line bundles (loc-triv) | ACTIVE. D3′ STUCK; dual route-2 `sliceDualTransport` CHURNING | ~18–30 |
| A.1.c.fun — RelPic functor on `IsLocallyTrivial` (PARALLEL) | OPENING | ~7–12 |
| A.2.c — representability scaffolding | HELD behind A.1.c | ~12–16 |
| A.2.c-engine — Quot/Cartier (RR-free), `Rⁱf_*` Čech lane | OPEN; DOMINANT pole | ≈85–140 |
| A.3 — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 |
| A.4 — Albanese UP (Route 1 RR-free primary) | gated A.2.c | ~12–20 |
| genusZero + witness body | gated A.3 | ~5–7 |

The actively-worked prover lane is **A.1.c.sub** (`Picard/TensorObjSubstrate.lean`
+ `TensorObjSubstrate/DualInverse.lean`), covered by the consolidated chapter
`Picard_TensorObjSubstrate.tex`. The dominant rate-limiting lane is **A.2.c-engine**
(Čech `Rⁱf_*` — `Cohomology/CechHigherDirectImage.lean` + `Picard/QuotScheme.lean`).

## Routes
Single route (Route A — Picard substrate). Route C (Riemann–Roch) is permanently
USER-paused; Route B-style alternatives are not active.

## References
- `references/summary.md`: full index. Most relevant to the chapters edited this
  iter: `kleiman-picard.md` (Picard scheme existence + group structure, FGAPic),
  `stacks-constructions.md` (relative-spectrum tags 01LL–01LT, RelativeSpec),
  `nitsure-hilbert-quot.md` (Quot construction, QuotScheme), Stacks 090V / Matsumura
  19.1 (Auslander–Buchsbaum), Mathlib `pushforwardPushforwardEquivalence` provenance
  (SheafOverEquivalence).

## Focus areas
This iter the DAG agent made SEVEN surgical `\uses{}` dependency-edge corrections to
break genuine circular-dependency cycles that were crashing `leanblueprint web`
(plastexdepgraph infinite recursion on the proof-edge graph; `leandag`'s
statement-`\uses`-only graph never surfaced them). Each cut was verified against the
actual Lean definitional order. Please pay extra attention to whether the corrected
`\uses{}` sets in these six chapters are now both ACCURATE and COMPLETE (no genuine
edge wrongly removed, no missing edge), reading the prose/math against the Lean:

1. `Albanese_AuslanderBuchsbaum.tex` — `lem:auslander_buchsbaum_formula_succ_pd`
   statement `\uses`: removed `thm:auslander_buchsbaum` (the inductive-step lemma
   takes the AB formula for pd≤k as a HYPOTHESIS, not a dependency on the full thm;
   thm→lem is the genuine direction).
2. `Picard_FGAPicRepresentability.tex` — `def:pic_scheme` `\uses` reduced to
   `{def:has_pic_scheme}` only (Lean `PicScheme := (HasPicScheme.has_pic_scheme C).choose`;
   removed `thm:pic_is_group_scheme` and `thm:fga_pic_representability`, both of which
   are built ON TOP of the bare scheme). Also corrected the Lean-encoding prose bullet.
3. `Picard_RelativeSpec.tex` — `thm:relative_spec_univ` statement `\uses`: removed
   `thm:relative_spec_base_change` (univ is the primitive proved by affine-gluing;
   base_change→univ is the genuine direction).
4. `Picard_QuotScheme.tex` — `def:pullback_app_isoTensor_sigma` `\uses`: replaced
   `def:quot_pullback_app_isoTensor` with `def:quot_pullback_app_isoTensor_baseMap`
   (Lean `...sectionLinearEquiv` references the baseMap, not the high-level final iso).
5. `Picard_SheafOverEquivalence.tex` — `def:over_equiv_inverse_is_continuous`:
   removed its only `\uses` entry `def:sheafofmodules_over_equivalence` (continuity of
   the site equivalence's inverse functor is a PREREQUISITE for the modules-level
   equivalence; the `\uses` annotation was dropped entirely, not left empty).
6. `Cohomology_CechHigherDirectImage.tex` — `lem:push_pull_functor` `\uses`: removed
   `def:cech_nerve` (the functor laws `pushPullMap_id`/`pushPullMap_comp` don't mention
   `CechNerve`; `CechNerve` is built FROM the push-pull functor).

Each edited block carries an inline `% NOTE iter-283:` explaining the cut and citing
the Lean line. The dependency graph is now ACYCLIC and `leanblueprint web` builds
EXIT 0 (verified this iter); `leandag build` clean (878 nodes, 1484 edges).

## Known issues (do NOT re-report)
- The 54 uncovered `lean-aux` in `TensorObjSubstrate.lean` (18) + `DualInverse.lean`
  (13), incl. the 2 ∞-effort sorry targets `sheafificationCompPullback_comp_tail`,
  `sliceDualTransportInv`: internal prover-lane helpers below blueprint granularity,
  deferred by standing policy until the lane's sorry count + helper set stabilise.
- The ~127 `malformed_refs` (`literal-ref` placeholders + `math-delim`) are ALL in
  mathematician-protected (`Jacobian`, `AbelJacobi`) or permanently-USER-paused
  Route-C (`RiemannRoch_*`) chapters. CONFIRMED THIS ITER they are cosmetic only —
  they do NOT block `leanblueprint web` (the build now succeeds with them present;
  the crash was the 7 cycles, NOT these). Out of scope (protected / paused governance).
  Triage them in your report grouped per chapter as usual, but they are not in-scope
  fixes for any active or non-protected chapter.
- `certify280` (iter-280) certified all 38 chapters `complete + correct`; the only
  chapter edits since are this iter's 6 `\uses` corrections + the iters 278–279
  rendering passes (already certified by certify280).
