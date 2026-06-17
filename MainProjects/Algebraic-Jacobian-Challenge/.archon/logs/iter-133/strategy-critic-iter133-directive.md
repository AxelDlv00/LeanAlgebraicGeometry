# Strategy Critic Directive

## Slug
iter133

## Iter
133

## Re-verification context

STRATEGY.md was substantively edited iter-132 in 4 places (per `strategy-critic-iter132` adoptions). Iter-132 prover lane on `cotangentSpaceAtIdentity_finrank_eq` closed cleanly. Iter-133 has NOT yet re-edited STRATEGY.md; the same STRATEGY.md you would see this iter is the iter-132-revised version. Please re-verify the iter-132 STRATEGY.md edits + render fresh CHALLENGE/SOUND verdicts on the strategic routes.

Iter-133 will, post-your-return, perform a small STRATEGY.md edit to:
- (a) reinstate over-k ground (iv) as iter-132 (not iter-131) tractability evidence (the iter-132 rank-lemma close is the validation event that the strikethrough waited for);
- (b) mark piece (i.a) phase 1 status (definition + rank lemma) as DONE on the sequencing table;
- (c) record the fibre-free unconditional evaluation decision (made by the plan agent this iter based on the iter-132 close).

Your verdict should focus on whether the iter-132 STRATEGY.md edits adequately addressed the iter-132 must-fix items AND whether the 3 iter-133 edits I plan to land are warranted.

## Project's stated final goal

The project formalizes Christian Merten's algebraic-Jacobian challenge: 9 protected declarations covering `AlgebraicGeometry.genus`, `AlgebraicGeometry.Jacobian` (with `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`), and `Jacobian.ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp`. All 9 signatures are frozen by the mathematician; agents are read-only on them. The headline statement is `nonempty_jacobianWitness`: for every smooth proper geometrically irreducible curve `C` over a field `k` with relative dimension 1, there exists a `JacobianWitness C`. End-state: zero inline `sorry`, no named axioms; every Mathlib gap closed in-tree.

## STRATEGY.md (verbatim — read this in full)

(file path: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`)

Please read this file directly via the Read tool. It is 549 lines; the full content is the primary subject of your review.

## References index

(file path: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`)

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint chapter summary (1-line topic per chapter)

| Chapter | Topic |
| ---- | ---- |
| `AbelJacobi.tex` | Abel–Jacobi map; all blocks consume the Albanese universal property packaged in `IsAlbanese C P (Jac C)`. |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris LES + Čech-acyclicity machinery for affine basic-open covers (engine for Serre finiteness, Phase A step 6). |
| `Cohomology_SheafCompose.tex` | Sheaf condition along structure-sheaf forget composite (Phase A step 1; unblock `H¹(C, O_C)` as abelian group). |
| `Cohomology_StructureSheafAb.tex` | Structure sheaf as sheaf of abelian groups; sheafification + Ext (Phase A steps 2–4). |
| `Cohomology_StructureSheafModuleK.tex` | Sheaves of k-modules: sheafification + Ext + structure sheaf as sheaf of k-modules (Phase A step 5; introduces no protected decls). |
| `Differentials.tex` | Relative cotangent presheaf `Ω_{X/S}` of a morphism of schemes (presheaf-level inverse-image; ring-side Kähler input). |
| `Genus.tex` | Genus of a smooth proper curve (`finrank k H¹(C, O_C)`); protected `AlgebraicGeometry.genus`. |
| `Jacobian.tex` | Jacobian as an abelian variety (protected `Jacobian`, `instGrpObj`, etc.) + scaffolded `genusZeroWitness` and `nonempty_jacobianWitness` (1+1 sorry). |
| `Rigidity.tex` | Mumford rigidity for pointed proper smooth scheme morphisms — `Scheme.Over.ext_of_eqOnOpen`. |
| `RigidityKbar.tex` | Rigidity over a base field `k` (post iter-127 over-k commitment): morphisms from a genus-0 smooth proper geom-irr curve to a smooth proper geom-irr group scheme are constant. Hosts the piece (i.a)/(i.b)/(i.c) sub-lemma decomposition for `cotangentSpaceAtIdentity` / `mulRight_globalises` / `omega_free` / `omega_rank_eq_dim`. Currently 1 `sorry` (`rigidity_over_kbar` body). |

## Specific questions for the iter-133 re-verification

1. **Iter-132 edit absorption.** The iter-132 STRATEGY.md edits were:
   - § "Over-k re-defense on revised numbers": struck ground (iv) (iter-131 bootstrap circularity) with explicit strikethrough + reinstatement criterion ("if iter-132 closes `cotangentSpaceAtIdentity_finrank_eq` cleanly, ground (iv) reinstates as iter-132 tractability evidence"). Were the strikethrough framing and reinstatement criterion adequately specified? Is the iter-133 reinstatement (now that the rank lemma closed) warranted, or does the reinstatement bury another sunk-cost flag?
   - § "Fibre-free piece (i) reformulation": criterion re-stated as unconditional evaluation at iter-132 close. Iter-133 will execute the evaluation (comparing (i.b)+(i.c) under (B) at 300–800 LOC vs fibre-free at ~400–800 LOC). Is the comparison framework adequate, or are there other considerations (canonicity, downstream API shape, blueprint alignment) the planner should weigh?
   - § "Mathlib gap inventory — Gap (scheme-level absolute Frobenius)": 800–1500 LOC commitment marked PROVISIONAL pending iter-140+ no-Frobenius mathlib-analogist consult. The schedule is iter-140+ (analogist consult before piece (iii) work begins iter-144+). Is this scheduling honest about the time-to-decision, or does it kick the can on a decision that should fire sooner?
   - § "C(k) ≠ ∅ branch ℙ¹-specific rigidity hedge": schedule moved to iter-140+ scheduled mathlib-analogist consult. Is the iter-140+ schedule adequate? Or should iter-133 already dispatch this hedge analogist while the pile is fresh?

2. **Active-route soundness check.** Per the iter-132 close, the piece (i.a) definition + rank lemma is DONE. Iter-133 active route is piece (i.b) `mulRight_globalises_cotangent`. The iter-131 strategy-critic Q3 must-fix scheduled a mathlib-analogist consult on piece (i.b) BEFORE the iter-133+ prover lane. Iter-133 plans to dispatch that analogist this iter. Is the consult question shape correct, or are there other piece-(i.b)-related strategic questions the planner has been overlooking?

3. **5000-LOC fallback rule for M3.** STRATEGY.md states "if both routes exceed 5000 LOC of estimated upstream-Mathlib work, escalate to the user" for M3 (Route A ~6500 LOC / Route B ~9000 LOC). The iter-126 user hint resolved the escalation in favor of "do-the-Mathlib-work". M3 stays off the critical path until M2 closes (~iter-157+). Is the iter-126 user-hint endorsement of the long-LOC path still load-bearing iter-133+? Or should iter-133 surface this as a re-check candidate?

4. **Iter-132 META-PATTERN TRIPWIRE outcome.** The iter-128 → iter-132 5-iter watch on `cotangentSpaceAtIdentity` body closed without arming a 3rd opacity-class defect. Per the iter-130 + iter-131 + iter-132 progress-critic verdicts (CHURNING → CHURNING → CONVERGING at iter-132 outcome), Route 1 has converged. Iter-133 will declare Route 1 CONVERGING. Any concerns about the convergence claim — e.g., the iter-131 `Classical.choose`-chain body shape introduces follow-on costs to piece (i.b)+(i.c) that the route-pivot framework should account for?

5. **Sunk-cost re-check on over-k commitment.** With iter-132 ground (iv) reinstatement on the table, the over-k defense rests on (ii) cleanliness + (iii) auto-revert + (iv) iter-132 tractability. Is the quantitative case (net savings 0–500 LOC, lower bound zero) genuinely defensible, or is the qualitative wrapping a sunk-cost?

## Format expected

Per `.archon/subagents/strategy-critic.md`: report the verdict (SOUND / CHALLENGE / REJECT) per route + a list of must-fix items, alternatives, and sunk-cost flags. Write to `task_results/strategy-critic-iter133.md`.
