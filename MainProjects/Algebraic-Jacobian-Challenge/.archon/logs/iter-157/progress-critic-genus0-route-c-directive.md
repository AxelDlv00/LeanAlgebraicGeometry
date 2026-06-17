# Progress Critic Directive

## Slug
genus0-route-c

Assess convergence of the active routes below from the extracted signals. Do NOT read
STRATEGY.md, blueprint chapters, or full iter sidecars — only the signals here.

## Route 1 — genus-0 rigidity (`rigidity_over_kbar` / `genusZeroWitness.key`) [CRITICAL PATH, ACTIVE]

This is the genus-0 keystone: "every pointed morphism from a genus-0 curve to an abelian
variety is constant." Last 5 iters' signals:

- **iter-153**: prover STUCK. Chart-algebra `df=0` route; residual step FT.3 classified a
  Mathlib gap behind a bright-line. Genus-0 keystone sorry: open.
- **iter-154**: prover COMPLETE on the *chart envelope* (KDM lemma closed, axiom-clean);
  global sorry 8→7. But this closed the *converse* (`df=0 ⟹ constant`), NOT the keystone.
  Keystone sorry: still open.
- **iter-155**: prover PARTIAL. Deleted orphan ChartAlgebraS3 (7→3 sorry); decomposed
  `genusZeroWitness` from bare `sorry` into a terminal-object skeleton (6/7 fields closed,
  only the `key` rigidity equation open). A mathlib-analogist consult REFUTED the `df=0`
  route as irreducibly needing global-sections / Serre duality. Keystone sorry: still open.
- **iter-156**: prover INCOMPLETE (verified-gated, no closure; 3→3 sorry). Route PIVOTED
  from the differential/`df=0` route to route (c): a characteristic-free AV-rigidity stack
  (theorem of the cube → rigidity → unirational⟹constant), confirmed feasible from Milne.
  Prover verified THREE out-of-file blockers on `key`: (a) import cycle
  (`RigidityKbar → Rigidity → Jacobian`, so the keystone can't be consumed), (b) char-`p`
  gap (`rigidity_over_kbar` carries `[CharZero]`), (c) no base-change functor.
- **iter-157 (planned)**: NO critical-path proof prover. Plan-phase work: register 3 new
  canonical references (Mumford/Hartshorne/FGA), blueprint the route-(c) AV-rigidity stack
  to prover-ready detail grounded in Mumford, decide+execute the architecture (new upstream
  Lean file to break the import cycle), scaffold that file (declarations as `sorry`).

Helpers added per iter: 154 +2 private helpers (chart envelope, since closed); 155 −1
file deleted + skeleton; 156 +0 (comment-only). Recurring blocker phrases across iters:
"rigidity_over_kbar never closed (149–155)", "df=0 irreducible / needs Serre duality",
"import cycle", "char-p gap", "base-change functor missing".

Strategy estimate for this route: **Iters left ~6–12**, ~1500–3500 LOC; the route ENTERED
its current phase (route (c), AV-rigidity stack) at **iter-156** (pivot iter) — so it has
~1 iter of trajectory on the *new* route, but ~5+ iters of stuck history on the *old*
(`df=0`) framing of the same keystone.

## Route 2 — positive-genus object (`positiveGenusWitness`, Route A / FGA) [CRITICAL PATH, DORMANT]
Sorry open since the iter-134 scaffold; no prover work; gated on the FGA representability
engine (not yet blueprinted to prover-ready detail). Strategy estimate ~40–70 iters,
~5100+ LOC. No trajectory to assess — flag as not-yet-started, not churning.

## Plan's current-objectives proposal for iter-157
File count: **0 critical-path proof lanes**. The plan proposes a plan/blueprint/architecture
iter: 3 reference registrations (subagent), route-(c) blueprint enrichment (blueprint-writer),
and a structural refactor that creates a new upstream Lean file scaffolding the AV-rigidity
declarations as `sorry` (breaking the import cycle) — so the FOLLOWING iter has a
prover-ready, importable target. No `genusZeroWitness.key` / `rigidity_over_kbar` proof
prover this iter.

## The question for you
Is the genus-0 route CONVERGING, CHURNING, or STUCK? Specifically:
- The keystone sorry has been open for ~8 iters. Iter-156 PIVOTED the route (df=0 → route
  c). Is the pivot + this iter's blueprint/architecture work genuine forward motion, or is
  it churn dressed as a pivot (i.e. are we about to sink budget into a theorem-of-the-cube
  formalization that itself stalls for many iters)?
- Is "no critical-path proof prover this iter, build the importable scaffold instead" the
  right call, or is it another plan-phase-only stall?
- If you judge the route at risk, name the corrective TYPE (blueprint expansion / Mathlib-
  idiom consult / structural refactor / route pivot / cheaper-route search).

## Output
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + corrective type if at risk.
Write to your `task_results/` report.
