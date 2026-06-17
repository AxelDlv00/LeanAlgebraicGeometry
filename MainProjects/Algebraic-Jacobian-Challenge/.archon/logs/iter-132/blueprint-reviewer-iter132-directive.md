# Blueprint Reviewer Directive

## Slug
iter132

## Strategy snapshot

The project's iter-127 over-k pivot is unchanged. The active critical path
this iter is the M2.body-pile piece (i.a) closure on
`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`:

- **Iter-128**: definition scaffolded + body landed, but body was
  mathematically degenerate (collapses to zero `k`-module).
- **Iter-129**: signature relaxed `[SmoothOfRelativeDimension 1 G.hom]`
  → `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`; renamed
  `lieAlgebra` → `cotangentSpaceAtIdentity`; orphan blueprint chapters
  deleted; `RigidityKbar.tex` Piece (i.a) rewritten to (A)-flavoured
  framing.
- **Iter-130**: body swapped to Replacement (B) chart-base-change form
  (extract chart `V ⊆ G.left` containing the identity-section image
  via `smooth_locally_free_omega`, build `ψ_V : Γ(G, V) → k`, set body
  to `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[…])`).
  Body closed kernel-clean BUT opaque (`Classical.choice` wrapping).
- **Iter-130 same-iter blueprint-writer** `rigiditykbar-piecei-realign-iter130`
  re-aligned `RigidityKbar.tex` § Piece (i.a) prose from (A)-framing
  to Replacement (B) chart-base-change framing.
- **Iter-131 (plan-only)**: refactor `Cotangent/GrpObj.lean` body to
  pure-term `noncomputable def` using `Classical.choose`-chain pattern
  (Mathlib precedent: `Polynomial.SplittingFieldAux`). Added strong
  acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars`
  (closes by `refine … rfl⟩`). 3 docstring blocks refreshed. Sorry
  count unchanged at 3. **The iter-131 blueprint-reviewer flagged
  `RigidityKbar.tex` § Piece (i.a) as `correct: partial`** — bridge proof
  Step 1 (~line 151) + rank proof Step 1 (~line 191) + line 203 closure-path
  paragraph carry iter-128/iter-130-era prose drift. **The iter-131
  blueprint-writer for `RigidityKbar.tex` was DEFERRED to iter-132** per
  directive-override (the refactor lane needed to land first; the
  iter-132 writer aligns prose against the post-refactor body in a
  single coherent pass).
- **Iter-132 (THIS ITER)**: plan agent will dispatch the deferred
  `blueprint-writer-rigiditykbar-piecei-realign-iter132` and stage a
  prover lane on the rank lemma `cotangentSpaceAtIdentity_finrank_eq`
  against the iter-131 refactored body.

The iter-131 changes also realigned `blueprint/src/chapters/AbelJacobi.tex`
to remove three Galois-descent paragraphs (lines ~82, ~87, ~89) per the
iter-127 over-k commitment. The iter-131 blueprint-reviewer marked
`AbelJacobi.tex` as `correct: partial` for this drift; the iter-131
blueprint-writer `blueprint-writer-abeljacobi-galois-iter131` returned
COMPLETE so AbelJacobi.tex should now be `correct: true`.

## Routes

Single route (over-k, post-iter-127 commitment; over-`k̄` baseline + M2.c
removed). Sub-route variants documented in STRATEGY.md as fallbacks but
NOT active:

- Replacement (A) — stalk-side `Ideal.IsLocalRing.CotangentSpace` body
  with regular-local bridge cost; deferred.
- Replacement (B′) — chart-level `m_V / m_V²` body; analogist verified
  shares (A)'s regular-local bridge gap; deferred.
- Fibre-free piece (i) reformulation — global free `Ω_{G/k}` rank-`n`
  without naming a "cotangent at identity" object; iter-132 evaluation
  criterion ("if (B)'s rank lemma closes ≤ 100 LOC at iter-132").

## References

- `references/challenge.lean`: authoritative protected signatures
  (`Jacobian`, `nonempty_jacobianWitness`, `genus`, Abel–Jacobi).
- `analogies/cotangent-body-shape.md`: iter-131 mathlib-analogist verdict
  on the `Classical.choose`-chain body shape; full 6-step rank-lemma
  closure chain end-to-end (all `[verified]` in Mathlib `b80f227`).
- `analogies/lieAlgebra-rank-bridge.md`: iter-129 mathlib-analogist
  verdict on the iter-128 zero-collapse defect + Replacement (B)
  recommendation.
- `analogies/cotangent-vanishing-pile-over-k.md`: iter-127 over-k
  analogist's OK_OVER_K verdict on pile pieces (i)+(ii)+(iii).

## Focus areas (optional)

- **`RigidityKbar.tex` § Piece (i.a)** — primary focus for this iter's
  reviewer dispatch. The plan agent will dispatch a deferred
  blueprint-writer THIS iter to align prose against the iter-131
  refactored body. Please flag specifically which prose blocks in
  `lem:GrpObj_cotangent_bridge` proof Step 1 (~line 151) and
  `lem:GrpObj_lieAlgebra_finrank` proof Step 1 (~line 191) + closure-path
  paragraph (~line 203) carry iter-128/iter-130-era drift, and what
  prose changes are needed to align with the iter-131 body shape.
  Specifically the rank-lemma proof currently says "Step 1: bridge to
  the local-ring cotangent space" which under Replacement (B) is
  vestigial (the bridge lemma is `\notready`; the live closure should
  go through Step 4's cross-check route directly: `rank_kaehlerDifferential`
  + `Module.finrank_baseChange` against the `cotangentSpaceAtIdentity_eq_extendScalars`
  rewrite handle).

- **`AbelJacobi.tex`** — confirm the iter-131 writer's edits closed the
  Galois-descent drift cleanly and the chapter is now `correct: true`.

- **`Jacobian.tex`** — sanity check no Galois-descent residue remains
  in the M2.b / `genusZeroWitness` prose; the chapter should be over-k
  end-to-end.

## Known issues

- `Jacobian.lean` docstring staleness at L195 + L226 was a Lean-side
  matter (iter-131 refactor lane piggybacked it; not blueprint).
- The iter-131 `rigiditykbar-piecei-realign` writer was deferred to
  iter-132 by the iter-131 plan agent. Please apply the HARD GATE
  per-file prover dispatch rule for iter-132's planned prover lane on
  `Cotangent/GrpObj.lean` (the rank lemma) — the plan agent intends to
  dispatch the writer in parallel with the prover lane (writer
  finishes first; or the rank lemma scaffold-only is acceptable).
- No new chapters are needed this iter. The 4 orphans deleted iter-129
  are not coming back.
- The `\notready` markers on `lem:GrpObj_cotangent_bridge`,
  `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_mulRight_globalises`,
  `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim` are
  intentional (iter-131 deferred targets).
