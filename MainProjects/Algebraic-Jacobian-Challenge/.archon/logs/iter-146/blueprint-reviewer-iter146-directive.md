# Blueprint Reviewer Directive

## Slug
iter146

## Strategy snapshot

Project end-state: zero inline `sorry` in the project (PROVISIONAL on
piece (iii); now relaxed at the lower envelope under the iter-144
chart-algebra pivot — no residual named-gap on piece (iii)).

Genus-stratified body for `nonempty_jacobianWitness`:
* M2 — `genusZeroWitness C h` (genus = 0 arm).
* M3 — `positiveGenusWitness C (Nat.pos_of_ne_zero h)` (positive-genus
  arm; OFF-CRITICAL-PATH; COMMITTED to Route A — Picard scheme via FGA
  per iter-144 user-hint).

M2's body closure goes through `rigidity_over_kbar` (k-agnostic; over-k
commitment iter-127); this in turn needs the cotangent-vanishing pile.
Under the iter-144 chart-algebra pivot the pile is composed of:
* Piece (i.a) — DONE iter-128–iter-132 (`cotangentSpaceAtIdentity*`
  trio in `AlgebraicJacobian/Cotangent/GrpObj.lean`).
* Piece (i.b)+(i.c)+(iii) bundled-route artefacts — **DESCOPED +
  EXCISED iter-145** from `Cotangent/GrpObj.lean` (3 named + 2 cascade-
  chained deletions, 903 → 631 LOC).
* Piece (ii) — chart-algebra envelope ~600–1050 LOC across 5 sub-pieces
  scaffolded iter-145 as `: True := sorry` placeholders in NEW file
  `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`:
  (α) `algebra_isPushout_of_affine_product`,
  (β-core) `df_zero_factors_through_constant_on_chart`,
  (algebra-level core) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`,
  (integrally-closed helper) `constants_integral_over_base_field`,
  (scheme-level lift) `Scheme.Over.ext_of_diff_zero`.
  Iter-146 fires the first chart-algebra prover lane.
* Piece (iv) Serre duality — DEFERRED as named theorem; cohomological
  content `H^0(C, Ω_{C/k}^{⊕n}) = 0` IS invoked via chart-Čech
  Mayer–Vietoris reusing the project's existing `Cohomology_MayerVietoris.tex`
  infrastructure.

Chapters that bear on iter-146's planned prover lane:
* `blueprint/src/chapters/RigidityKbar.tex` — owns the M2.a chapter +
  the iter-145 NEW subsection "Chart-algebra piece (ii) first-class
  decomposition" (L1773–L1944, +173 LOC). This is the chapter that
  ChartAlgebra.lean's 5 declarations are tagged by `\lean{...}` from
  (not its own chapter file — see Known issues §1 below).
* `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` —
  pointer chapter; iter-145 EXCISE in the Lean file left 5 `\item`s
  here stale (per `lean-vs-blueprint-checker-cotangent-grpobj-review145`
  must-fix). Iter-146 blueprint-writer-pointer is the planned absorber.
* `blueprint/src/chapters/Jacobian.tex` — M2 + M3 chapter with iter-145
  reconciliation; iter-145 close had it `complete: true / correct: true`
  per `blueprint-reviewer-iter145`; please re-confirm.

## Routes

This project has one critical-path route into M2:
- Route C (chart-algebra): committed iter-144; piece (ii) PIN-path-(b)
  body via per-chart `Algebra.IsPushout` + Kähler-derivation kernel-
  extraction + chart-Čech Mayer–Vietoris glueing. Iter-146+ prover lane
  fires on `Cotangent/ChartAlgebra.lean`.

The bundled-route piece (i.b)/(i.c)/(iii) (formerly Routes A/B) is
DESCOPED. Off-critical-path M3 Route A (Picard scheme via FGA;
committed iter-144 per user-hint) is not iter-146 work.

## References
- `references/challenge.lean`: the formal Jacobian-challenge file by
  Christian Merten. Backs every protected declaration; cited from
  `Jacobian.tex`, `AbelJacobi.tex`, `Genus.tex`.

## Focus areas (optional)

1. **NEW iter-145 subsection in RigidityKbar.tex** (L1773–L1944,
   "Chart-algebra piece (ii) first-class decomposition"). Five
   first-class blocks landed by `blueprint-writer-rigiditykbar-iter145`.
   Per the iter-145 `lean-vs-blueprint-checker-chart-algebra-review145`
   audit there are TWO majors blocking iter-146+ KDM ring-side prover
   lane: (a) char-`p` step (p1) of
   `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` is
   under-specified ("by hand from the standard-smooth presentation"
   without a 3–5 sub-step recipe); (b) step (p3) appeals to a "chart of
   smooth proper geom-irr scheme" hypothesis that is NOT in the lemma
   statement (which states only finite-type / standard-smooth). Please
   confirm both findings and classify accordingly.

2. **Pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex`**: per
   the iter-145 lean-vs-blueprint-checker, 5 `\item`s describe
   declarations EXCISED iter-145 (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
   `basechange_along_proj_two_inv_derivation`,
   `basechange_along_proj_two_inv`, `basechange_along_proj_two_inv_app_isIso`,
   `mulRight_globalises_cotangent`). The chapter's iter-144-disposition
   paragraph at L10–L17 says "preserved as auditable record" but the
   declarations are no longer in-tree. Please classify the manifest-
   drift severity.

3. **Strategy-critic iter-145 Q4 mild residue**: the four M3 Route A
   prerequisite items (fppf/étale topology; Picard pre-functor;
   Grothendieck flattening stratification; coherent-of-finite-type)
   are bundled into A1/A2/A3 in `analogies/m3-route-a-refresh-iter145.md`;
   `Jacobian.tex` was updated to Route A COMMITTED. Please confirm
   `Jacobian.tex`'s Route A prose at L370–L377 is adequate or call
   out a `complete: partial` if the dependency list is misleading
   without the four prerequisite items being explicit.

## Known issues

1. **Non-standard slug mapping**: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
   should map to `blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebra.tex`
   per the convention, but iter-145 routed its 5 `\lean{...}`-tagged
   blocks into a subsection of `RigidityKbar.tex` instead. There is NO
   `AlgebraicJacobian_Cotangent_ChartAlgebra.tex` file and
   `blueprint/src/content.tex` does NOT `\input` one. The plan agent is
   AWARE; please report this as informational / soon rather than as a
   blocking must-fix unless the routing is genuinely incoherent.
   (Reasoning: putting the chart-algebra subsection inside the
   rigidity chapter keeps the piece (ii) decomposition next to its
   consumer `\lem:rigidity_over_kbar`, which is pedagogically clean;
   the cost is just one cross-file lookup for the plan agent.)

2. The iter-145 wave-2 writers added `\leanok` markers in the iter-145
   subsection on 5 statement blocks + 5 proof blocks. The `sync_leanok`
   phase between prover and review will strip the proof-level ones
   automatically (the bodies are `:= sorry`). DO NOT REPORT
   `\leanok`-status issues — they are owned by the deterministic
   `sync_leanok` phase, not your audit.

3. The `\notready` markers in `Jacobian.tex` at L389 + L424 are stale
   carry-overs from iter-127. Please flag them in informational rather
   than must-fix.

4. STRATEGY.md size compaction (Q5 deferred from iter-145; target
   ~400–450 LOC; current ~700 LOC) is the plan agent's iter-146 task,
   not yours.
