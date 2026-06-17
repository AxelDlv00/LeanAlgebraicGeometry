# Iter-134 objectives (per-attempt detail)

## Objective 1 — `AlgebraicJacobian/Cotangent/GrpObj.lean` — piece (i.b) `mulRight_globalises_cotangent`

**Goal**: Land the named declaration `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` per the iter-133 blueprint-writer's hardened block in `blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b) `lem:GrpObj_mulRight_globalises`.

**Lean target signature** (per the iter-133 blueprint-writer's Lean-comment block in `RigidityKbar.tex` lines 298–321; sheaf-level RHS per `analogies/mulright-globalises-cotangent.md` Decision 4 ALIGN_WITH_MATHLIB):

The lemma asserts that for `G : GrpObj (Over (Spec k))` smooth of relative dimension `n`, the relative differentials sheaf `Ω_{G/k}` pulled back along the right-multiplication map `mulRight_g : G ⟶ G` (for any `g`) is isomorphic to `Ω_{G/k}` itself; equivalently, `Ω_{G/k}` is built from `Ω_{(G ×_k G)/G}` via the shear iso `σ = lift (fst G G) μ : G ⊗ G ≅ G ⊗ G` and base-change along `pr_1`, then restricted along `⟨id_G, η_G⟩`.

The recommended sheaf-level RHS is:
```
Ω_{G/k} ≅ pr_1^* (η_G^* Ω_{G/k})    -- at the presheaf-of-modules level
```

**Closure path** (per `analogies/mulright-globalises-cotangent.md` + the iter-133 blueprint-writer's § Piece (i.b)):

1. **Shear iso** `σ = lift (fst G G) μ : G ⊗ G ≅ G ⊗ G` (~30–60 LOC NEEDS_MATHLIB_GAP_FILL; template `CategoryTheory.GrpObj.mulRight` [verified]) — name the helper as needed; do NOT inline.
2. **Base-change-of-differentials helper** `lem:GrpObj_omega_basechange_proj`: `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}` (~150–300 LOC NEEDS_MATHLIB_GAP_FILL; chain `TopCat.Presheaf.pullback` [expected] + `KaehlerDifferential.tensorKaehlerEquiv` [verified iter-134]). Suggested Lean name: `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`.
3. **Section-restriction helper** `lem:GrpObj_omega_restrict_to_identity_section`: restrict pullback along `⟨id_G, η_G⟩` (~30–80 LOC; uses `PresheafOfModules.pullbackComp` [expected] + `PresheafOfModules.pullbackId` [expected]).
4. **Main lemma body**: compose (1)+(2)+(3) at the presheaf-of-modules level. Use the MED-C rewrite-pattern paragraph (`RigidityKbar.tex` lines 484–497): direct `change`-route is primary; `obtain`+`rw [heq]` route is the alternative for consumers whose goal does not unify with the underlying `TensorProduct` carrier.

**Envelope**: 210–440 LOC over 2–4 iter (iter-133 mathlib-analogist verdict). The iter-134 lane should not promise a one-shot close — the analogist envelope is multi-iter by design.

**Hard constraints for the iter-134 prover**:
- **MUST use the sheaf-level RHS** per the iter-133 analogist + iter-134 plan-agent pre-commitment. If the prover chooses value-level-stalk RHS instead, trigger (a') fires and the over-k vs over-`k̄` decision is formally re-opened in iter-135 — DO NOT pivot to value-level-stalk RHS without an explicit plan-agent escalation.
- **MUST NOT reshape the `cotangentSpaceAtIdentity` body** (META-PATTERN TRIPWIRE non-promise commitment from iter-132). The piece (i.b) prover lane works WITH the iter-131 `Classical.choose`-chain body shape via the chart-localisation identification pushed into piece (i.c); it does NOT touch `cotangentSpaceAtIdentity` itself.
- **MUST NOT introduce new axioms** (per `archon-protected.yaml` discipline + iter-134 strategy-critic's prerequisite-verification chain).
- **MUST verify ≤ 600 LOC of (i.b)-side build** in the iter-134 deliverable; if the lane ships > 600 LOC, the iter-135 plan agent will fire trigger (a')/(c) per the iter-134 watchpoint.

**Expected outcome**:
- COMPLETE (one-iter close): `mulRight_globalises_cotangent` body + 2 helper sub-lemmas all land kernel-clean; per-file sorry count stays at 0 on `Cotangent/GrpObj.lean` (NEW declaration, no `sorry`). Iter-135 progress-critic flips Route 4 UNCLEAR → CONVERGING.
- PARTIAL (one or two helpers land; main lemma stays as `sorry`): per-file sorry count rises ~1–2 on `Cotangent/GrpObj.lean`. Iter-135 progress-critic flips Route 4 UNCLEAR → CONVERGING (helpers buy measurable progress on the closure path).
- INCOMPLETE (no helpers land; lane stuck on sheaf-level RHS recipe): iter-135 plan agent dispatches follow-up mathlib-analogist on the specific stuck sub-piece + blueprint expansion. Iter-135 progress-critic flips Route 4 UNCLEAR → CHURNING.

## Objective 2 — `AlgebraicJacobian/Jacobian.lean` — `positiveGenusWitness` scaffold (LANDED iter-134 plan-phase)

**Status**: LANDED iter-134 via `refactor-positiveGenusWitness-scaffold-iter134` (Wave-2 parallel with the iter-134 plan-phase setup). The stub `positiveGenusWitness C (hg : 0 < genus C)` was inserted at `AlgebraicJacobian/Jacobian.lean:194–215` with a `sorry` body; per-file sorry count rose 2 → 3; project sorry count 3 → 4. No prover dispatch needed on this file iter-134.

**Iter-135 follow-up**: iter-135 plan agent adds a `\lean{positiveGenusWitness}` hint + brief block to `Jacobian.tex` so the blueprint covers the new scaffold (iter-134 blueprint-reviewer marked `Jacobian.tex` `complete: true` so this is an iter-135 informational cleanup, NOT iter-134 must-fix). The body closure is M3 work (off-critical-path; user-escalation-pending per `analogies/m3-route-audit.md`).

## Off-limits this iteration (no prover dispatch on these files)

- `AlgebraicJacobian/Jacobian.lean` — `genusZeroWitness` body (iter-127 scaffold; closure iter-153+ after M2.a body lands + terminal-object instances); `positiveGenusWitness` body (iter-134 scaffold; M3 off-critical-path); `nonempty_jacobianWitness` (Phase-C OFF-LIMITS; foundational existence hypothesis). NO PROVER WORK iter-134.
- `AlgebraicJacobian/RigidityKbar.lean` — `rigidity_over_kbar` body (iter-126 scaffold; closure iter-151+ after pieces (i.b)+(i.c)+(ii)+(iii) land).
- `AlgebraicJacobian/Cotangent/GrpObj.lean` — `cotangentSpaceAtIdentity` body + `cotangentSpaceAtIdentity_eq_extendScalars` + `cotangentSpaceAtIdentity_finrank_eq` (piece (i.a); DONE iter-132; META-PATTERN TRIPWIRE non-promise binds — NO body reshape on `cotangentSpaceAtIdentity` under any future iter). NEW declaration `mulRight_globalises_cotangent` is in-scope for this iter; the iter-131 body of `cotangentSpaceAtIdentity` is consumed read-only.
- All Cohomology files (M5–M8 scaffolding) — DONE; not active prover lanes.
- `AlgebraicJacobian/Rigidity.lean` — closed iter-125 refactor.
- `AlgebraicJacobian/Differentials.lean` — excised iter-126; standalone utilities preserved.
