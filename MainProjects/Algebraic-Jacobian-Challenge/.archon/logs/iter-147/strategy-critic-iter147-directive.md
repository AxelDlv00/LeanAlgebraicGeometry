# Directive — strategy-critic (iter-147)

## Project final goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge (`references/challenge.lean`), in particular
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness`,
the existence of an Albanese / Jacobian object uniform over the
$k$-rational pointing of a smooth proper geometrically irreducible
curve $C / k$, **without** assuming $C(k) \neq \emptyset$.

## References index (`references/summary.md`)

```
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary (chapter titles + topic)

- `AbelJacobi.tex` : The Abel–Jacobi map.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` : Cotangent space at the
  identity (piece (i.a) Lean-file pointer).
- `Cohomology_MayerVietoris.tex` : Mayer–Vietoris long exact sequence
  for sheaf cohomology with $k$-module coefficients.
- `Cohomology_SheafCompose.tex` : Sheaf condition along the
  structure-sheaf forget composite.
- `Cohomology_StructureSheafAb.tex` : Structure sheaf as sheaf of
  abelian groups; sheafification + Ext.
- `Cohomology_StructureSheafModuleK.tex` : Sheaves of $k$-modules;
  sheafification + Ext + structure sheaf as sheaf of $k$-modules.
- `Differentials.tex` : Relative cotangent presheaf.
- `Genus.tex` : Genus of a smooth proper curve.
- `Jacobian.tex` : The Jacobian as an abelian variety.
- `Rigidity.tex` : Rigidity for morphisms of schemes (scheme-level
  form; Mumford §4 in the abelian-variety case).
- `RigidityKbar.tex` : Rigidity over a base field $k$: morphisms from
  a genus-0 curve to a group scheme are constant.

## STRATEGY.md (full content; current iter-147 plan-phase entry)

`STRATEGY.md` is at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`. Read it directly.

## Iter-146 → iter-147 carry-over for re-verification

You are mandatory every iter even when STRATEGY.md is unchanged. The
following iter-146 strategy-critic findings remain partially live:

1. **Iter-146 strategy-critic finding "Format NON-COMPLIANT"**:
   STRATEGY.md was 701 LOC, ~3× over the 250-line bound. Iter-146
   plan agent absorbed via 2 mechanical edits (per-iter narrative
   excise L561–629 + M2 decomposition table reconciliation), bringing
   the file 701 → 624 LOC. The iter-147 plan agent's user-hint demand
   is to **complete the canonical-skeleton restructure THIS ITER**
   (target ~250 LOC, per the user hint absorbed iter-147 plan phase
   into a planned restructure). Verify the iter-147 restructure (when
   it lands) takes STRATEGY.md to the canonical skeleton (`## Goal`,
   `## Phases & estimations`, `## Routes`, `## Open strategic questions`,
   `## Mathlib gaps & new material`) under the ~250 LOC bound, with
   per-iter narrative removed.
2. **Iter-146 strategy-critic finding "M2 CHALLENGE"**: was about the
   iter-127 bundled-route decomposition table still describing the
   bundled pile as active when the iter-144 pivot had descoped most
   sub-pieces. Iter-146 plan agent absorbed via in-place table
   reconciliation. Verify the M2 sequencing is now coherent with
   the chart-algebra commitment (piece (ii) PIN-path-(b) inflated,
   pieces (i.b)+(i.c)+(iii) DESCOPED + EXCISED iter-145).
3. **Iter-146 strategy-critic findings "SOUND on chart-algebra
   commitment + SOUND on M3 Route A commitment"**: are the SOUND
   verdicts still defensible in light of iter-146 prover-lane outcome
   (2 of 3 scoped sub-pieces sorry-free, 1 partial)? Confirm or
   challenge.

## What I want from you this iter

1. **STRATEGY.md format audit**. The user hint flagged the 624-LOC
   STRATEGY.md as non-compliant (~2.5× over the 250-line skeleton
   bound). If the iter-147 plan agent's restructure is in place when
   you read STRATEGY.md, audit:
   - Does the file use the canonical skeleton headings exactly?
   - Is per-iter narrative excised? (No "iter-N tried X" / decision
     history blocks; those belong in `iter/iter-N/plan.md`.)
   - Is the table in § Phases & estimations bounded to 4–10 rows
     with concise one-line cells?
   - Are the "Soundness rules" / inline rule blocks pared back to
     the rules that actively constrain the next ~5 iters (not
     iter-138/139/140 historical sunk-cost guardrails)?
   - Total LOC under ~250?
2. **Strategic soundness audit**. Per your descriptor's items 1–6.
3. **Sunk-cost smell flags**. Per your descriptor: call out any
   "we already did X" reasoning where "X is the right way" would
   be the better justification.

Do NOT read iter sidecars / `task_*.md` / proof-journal / iter-NNN
narrative. Your value depends on the fresh view of the strategy text
as written.

## Output

Standard report format per your descriptor. Plan agent will absorb
must-fix items into the iter-147 close.
