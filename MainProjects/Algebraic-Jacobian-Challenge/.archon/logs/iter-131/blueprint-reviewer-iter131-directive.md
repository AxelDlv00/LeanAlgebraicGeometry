# Blueprint Reviewer Directive

## Slug
iter131

## Strategy snapshot

The project's end-state is **zero inline `sorry` in the project**, no named axioms. The active critical path is M2 (genus-0 witness via the over-k cotangent-vanishing rigidity pile, COMMITTED iter-127), composed of:

- **Piece (i.a)** `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`: cotangent space at identity as a `k`-vector space.
  - Definition lemma `lem:GrpObj_cotangentSpace` — LANDED in `Cotangent/GrpObj.lean` iter-130 with Replacement (B) chart-base-change body. BUT iter-130 lean-auditor flagged a structural opacity defect (body wraps witness in `Classical.choice` → `Nonempty` sandwich, discarding rank-`n`-free content).
  - Bridge lemma `lem:GrpObj_cotangent_bridge` to `Ideal.IsLocalRing.CotangentSpace` — `\notready`; deferred iter-130+.
  - Rank lemma `lem:GrpObj_lieAlgebra_finrank` — `\notready`; deferred iter-130+. Cannot close against the current iter-130 body without a body-shape refactor (`Classical.choice` → `Classical.choose`-chain).
- **Piece (i.b)** `mulRight_globalises_cotangent` (shear-iso globalisation) — `\notready`; iter-131+ build.
- **Piece (i.c)** `omega_free` + `omega_rank_eq_dim` — `\notready`; iter-134+ build.
- **Piece (ii)** `Scheme.Over.ext_of_diff_zero` — not yet blueprint-staged; iter-141+ build.
- **Piece (iii)** char-`p` absolute Frobenius iteration — not yet blueprint-staged; iter-144+ build. **Project must construct scheme-level `AlgebraicGeometry.Scheme.absoluteFrobenius` from scratch** (no Mathlib precedent in b80f227; Stacks Tag 0CC4).
- **Piece (iv)** Serre duality — DEFERRED as named gap (not on iter-127 over-k commitment's critical path).

M2.a `rigidity_over_kbar` (scaffold in `RigidityKbar.lean`) body lands iter-150+ once pieces (i)+(ii)+(iii) close. M2.b `genusZeroWitness` (scaffold in `Jacobian.lean`) body lands iter-152+ once M2.a body + terminal-object instance cluster on `Spec k` lands. M2 final closure (genus-stratified `nonempty_jacobianWitness` body) iter-156+ once M3 scaffolding lands.

M3 (positive-genus witness) is off iter-by-iter critical path until M2 closes.

## Routes

Single route in active execution: M2 via the over-k cotangent-vanishing pile (pieces (i)+(ii)+(iii), piece (iv) deferred). The strategy's revert trigger (a') auto-monitors piece (i.b) closure for shear-iso functoriality failure; the strategy's hedge route (ℙ¹-specific rigidity for the C(k) ≠ ∅ branch) is documented but not active. The chart-base-change replacement (B) is the committed iter-129+ body shape; replacements (A) stalk-side and (C) sheafified are deferred.

## References

- `references/challenge.lean` — authoritative formal signature source for the nine protected declarations.
- `analogies/lieAlgebra-rank-bridge.md` — iter-129 mathlib-analogist's analysis of the iter-128 zero-collapse defect + Replacement (B) construction + closure-chain for the rank lemma. Source-of-truth for piece (i.a) body sketch.
- `analogies/cotangent-vanishing-pile-over-k.md` — iter-127 over-k commitment justification (pieces (i)+(ii)+(iii) build over arbitrary `k`).

## Focus areas (optional)

- **`RigidityKbar.tex` § Piece (i.a) trio** — verify the iter-130 prose re-alignment (Replacement (B) framing) is now coherent with the iter-130 Lean body. The iter-130 lean-vs-blueprint-checker flagged 2 major mismatches:
  - `lem:GrpObj_cotangent_bridge` proof Step 1 (line 151) still describes the iter-128 global-sections LHS framing, not the chart-base-changed iter-130 LHS that the lemma statement (line 144) now pins.
  - `lem:GrpObj_lieAlgebra_finrank` proof's "Iter-130 closure path under Replacement (B)" paragraph (line 203) does not flag the `Classical.choice` opacity — a prover dispatched against this sketch would attempt a direct `Module.finrank_baseChange` rewrite that fails.

  Both lemmas are `\notready` so non-blocking for iter-131; please confirm both as "must-fix-soon (iter-131 if blueprint-writer dispatched)" rather than "must-fix-this-iter".

- **`Jacobian.tex` and `AbelJacobi.tex`** — iter-130 lean-auditor flagged 2 stale "single remaining sorry" docstrings in `Jacobian.lean` (L195 + L226). Please cross-check whether the corresponding chapter prose has the same staleness.

- **HARD GATE check**: the iter-131 plan agent intends to **defer the prover round** on `Cotangent/GrpObj.lean` to iter-132 and dispatch a refactor lane this iter instead (body-shape fix: `Classical.choice` → `Classical.choose`-chain). NO prover lane this iter, so the HARD GATE only needs to confirm that `RigidityKbar.tex` § Piece (i.a) is in a state where, AFTER the iter-131 refactor lane lands the body-shape fix, the iter-132 prover lane on the rank lemma can proceed (i.e. `lem:GrpObj_lieAlgebra_finrank` proof sketch is realistic against the iter-131 refactored body — which the iter-130 checker flagged as "not realistic" against the current body).

## Known issues

- 4 orphan blueprint chapters deleted iter-129 (`Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`). Don't re-flag.
- M1 bridge declarations excised iter-126 from `Differentials.tex` prose. Don't re-flag the deletion.
- Iter-130 must-fix items (RigidityKbar.tex Piece (i) prose drift to Replacement (B)) were addressed by `blueprint-writer-rigiditykbar-piecei-realign-iter130`; please confirm the writer's edits are sufficient.
