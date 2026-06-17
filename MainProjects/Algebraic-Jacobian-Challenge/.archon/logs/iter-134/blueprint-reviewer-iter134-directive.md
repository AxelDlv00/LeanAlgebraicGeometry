# Blueprint Reviewer Directive

## Slug
iter134

## Strategy snapshot

The project's iter-127-committed over-k path closes M2.a (`rigidity_over_kbar` in
`AlgebraicJacobian/RigidityKbar.lean`) by building the shared
cotangent-vanishing pile pieces (i)+(ii)+(iii) directly over an arbitrary base
field `k`. The over-k commitment is documented in `STRATEGY.md` § "Direct over-k
rigidity" and `analogies/cotangent-vanishing-pile-over-k.md`. The protected
goal is the formalization of `nonempty_jacobianWitness` etc.

**Piece (i.a) is DONE iter-132**: the `GrpObj.cotangentSpaceAtIdentity` body
plus its rank lemma `cotangentSpaceAtIdentity_finrank_eq` are closed (kernel-only
axioms; ~300 LOC empirical). Iter-133 plan-phase blueprint-writer hardened
`RigidityKbar.tex` § Piece (i.b) to prepare the iter-134+ prover lane on
`mulRight_globalises_cotangent` (the chart-translation lemma), per the iter-133
mathlib-analogist's PROCEED + ALIGN_WITH_MATHLIB on sheaf-level RHS verdict.

The iter-134 plan agent's intended prover dispatch this iter is on
`AlgebraicJacobian/Cotangent/GrpObj.lean` for piece (i.b)
`mulRight_globalises_cotangent`, contingent on **your iter-134 verdict
flipping `RigidityKbar.tex` to `complete: true` / `correct: true`** after the
iter-133 writer's edits (which: hardened `lem:GrpObj_mulRight_globalises` with
the full Lean signature stub + `mulRight`-vs-σ option (i) paragraph + 3-step
proof + Mathlib name summary; added 2 helper sub-lemmas
`lem:GrpObj_omega_basechange_proj` ~150–300 LOC NEEDS_MATHLIB_GAP_FILL and
`lem:GrpObj_omega_restrict_to_identity_section` ~30–80 LOC; bundled MED-B
`lem:GrpObj_cotangentSpace_extendScalars_witness` companion block; MED-C
rewrite-pattern paragraph re-cast direct `change`-route as primary).

Iter-133 plan-phase refactor lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`
(285 → 296 LOC; 5 docstring refreshes + 1 style nit `set ... with _def → let`;
no semantic change; 0 sorries; kernel-only axioms unchanged).

## Routes

The strategy currently runs a single critical-path route over `k`. The M2.d
"Riemann–Roch" fallback is documented but NOT ACTIVE. M3 (`positiveGenusWitness`)
is user-escalation-pending (route choice between Route A Picard via FGA and
Route B Sym^n + Stein — both exceed the 5000-LOC hard-fallback threshold);
M3 stays off iter-by-iter critical path until M2 closes. So "single route" with
two upstream gates (M3 user escalation; M2.b body close).

## References
- `references/challenge.lean`: original challenge file with the 9 protected signatures.
- `analogies/cotangent-vanishing-pile-over-k.md`: over-k pile verification (iter-127).
- `analogies/cotangent-body-shape.md`: iter-131 `Classical.choose`-chain body shape rationale.
- `analogies/mulright-globalises-cotangent.md`: iter-133 piece (i.b) closure chain + sheaf-level RHS recommendation + 2 NEEDS_MATHLIB_GAP_FILL sub-pieces.
- `analogies/relative-differentials-presheaf-bridge.md`: M1.d off-loop Mathlib-PR candidate `kaehler_quotient_localization_iso` (informational only; not on iter-134 critical path).
- `analogies/lieAlgebra-rank-bridge.md`: iter-129 bridge verdict (informational; consumed by piece (i.a) close iter-132).
- `analogies/serre-duality.md`: 3000–8000 LOC standalone estimate (informational; deferred).
- `analogies/m3-route-audit.md`: iter-123 M3 route audit (informational; user-escalation pending).

## Focus areas (this iter)

1. **`RigidityKbar.tex`** — does this chapter now pass the HARD GATE (`complete: true` / `correct: true`) after iter-133 writer's edits? Specifically:
   - Is `lem:GrpObj_mulRight_globalises` adequately specified for prover dispatch (signature stub, proof prose detail, Mathlib names, sub-lemma factoring)?
   - Are the 2 new helper sub-lemmas (`lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`) well-formulated and consistent with the analogist's recommendations?
   - Does the MED-B `lem:GrpObj_cotangentSpace_extendScalars_witness` block correctly link the iter-131 Lean `cotangentSpaceAtIdentity_eq_extendScalars` declaration?
   - Does the MED-C rewrite-pattern paragraph correctly describe the direct `change`-route as primary for iter-134+ prover use?
   - Verify the 2 minor blueprint-side line-number drifts flagged by `lean-vs-blueprint-checker-cotangent-grpobj-review133` at `RigidityKbar.tex` lines 159 and 493 (citing stale Lean line ranges) — still present, or fixed by sync_leanok / writer?

2. **`Jacobian.tex`** — the iter-132+iter-133 reviewers flagged C.2.a–C.2.e soft drift (over-`k̄` historical scaffolding) as `correct: partial`. The iter-133 plan agent deferred this as a soft cleanup writer pass (informational; no active prover route consumes the sub-step prose). Re-verify: is the C.2.f explicit DROP of the descent step still in place as the safety mechanism that keeps the chapter internally consistent? If so, the `correct: partial` can stay informational (NOT must-fix). If C.2.f is missing or weakened, flag as must-fix.

3. **`Cohomology_MayerVietoris.tex`** — the iter-133 reviewer flagged 3 broken `\ref{...}` cross-refs at lines 769 (× 2) and 917 (`sec:basic_open_acyclicity`, `sec:basic_open_infrastructure`, and a `def:Scheme_IsAffineHModuleVanishing`-vs-`thm:` prefix mismatch). The iter-133 plan agent deferred this as a routine cleanup pass (soon, not blocker — surface-rendering bugs only; no `\uses{...}` integrity violation). Re-verify whether the broken refs are still there.

4. **`Cohomology_StructureSheafModuleK.tex`** — the iter-133 reviewer flagged a label-prefix asymmetry (`def:Scheme_IsAffineHModuleVanishing` vs `thm:`) causing one of the `Cohomology_MayerVietoris.tex` broken refs. Re-verify.

5. **Iter-137+ pre-prover hardening on piece (i.c)** — the iter-133 reviewer flagged `lem:GrpObj_omega_free` and `lem:GrpObj_omega_rank_eq_dim` as needing blueprint hardening before iter-137+ prover lane. This is iter-137+ scheduled, NOT iter-134 must-fix. Confirm the chapter currently flags these as `\notready` / iter-137+ to-do.

## Known issues

- The iter-133 plan agent's deferred items are: (a) `Jacobian.tex` C.2.a–C.2.e soft drift; (b) `Cohomology_MayerVietoris.tex` 3 broken `\ref{...}` (and the related `Cohomology_StructureSheafModuleK.tex` label-prefix asymmetry); (c) iter-137+ pre-prover hardening on piece (i.c). Do not re-classify these as must-fix unless your iter-134 read materially changes the severity (e.g., the broken refs corrupt a `\uses{}` graph, or C.2.a–C.2.e has lost its C.2.f safety guard).
- Stable convergence on `Cotangent/GrpObj.lean` per `Cotangent/GrpObj.lean` 0-sorry status; do NOT re-flag iter-128/130/131-era opacity concerns (those were resolved via the iter-131 `Classical.choose`-chain body shape + iter-132 rank-lemma close + iter-133 docstring refresh).
- `analogies/mulright-globalises-cotangent.md` is your authoritative source for what the iter-134 prover lane should be implementing; cross-check `RigidityKbar.tex` § Piece (i.b) against it.

Apply the HARD GATE per your dispatcher_notes verbatim. If `RigidityKbar.tex` passes, the iter-134 plan agent will dispatch the piece (i.b) prover lane. If it fails, the iter-134 plan agent will defer the prover lane and dispatch a follow-up blueprint-writer.
