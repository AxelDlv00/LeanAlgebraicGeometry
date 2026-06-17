# Progress Critic Directive

## Slug
iter138

## Iter
138

## Active routes / files under review

### Route 1: piece (i.a) — `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` family in `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **Started at iter**: 128
- **Iters audited**: 134 to 137

#### Sorry counts per iter (file-level)
- iter-134: 0 (closed iter-132)
- iter-135: 0
- iter-136: 0
- iter-137: 0

#### Helpers added per iter
- iter-134: 0 (untouched)
- iter-135: 0 (untouched)
- iter-136: 0 (untouched)
- iter-137: 0 (untouched)

#### Prover statuses per iter
- iter-134: COMPLETE (closed iter-132, off-target this iter)
- iter-135: not assigned (off-target)
- iter-136: not assigned (off-target)
- iter-137: not assigned (off-target)

#### Recurring blocker phrases
- None.

#### Planner's current proposal for this iter
- No prover dispatch on piece (i.a). META-PATTERN TRIPWIRE non-promise
  binding: no 4th body reshape; the three iter-128→132 declarations
  (`cotangentSpaceAtIdentity` L161, `cotangentSpaceAtIdentity_eq_extendScalars`
  L210, `cotangentSpaceAtIdentity_finrank_eq` L256) are CLOSED and MUST
  NOT BE TOUCHED.

### Route 4: piece (i.b) — `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two` family in `AlgebraicJacobian/Cotangent/GrpObj.lean`

- **Started at iter**: 134
- **Iters audited**: 134 to 137

#### Sorry counts per iter (file-level, Cotangent/GrpObj.lean)
- iter-134: 3 (iter-134 prover landed Step 1 substantively closed; Steps 2/3/Main shipped as hollow `Nonempty (X ≅ X)` placeholders — file-level sorry count 0 because the placeholders had `:= ⟨Iso.refl _⟩` bodies, NOT `sorry`)
- iter-135: 3 (iter-135 plan-only refactor REPLACED the 3 hollow placeholders with honest sorry-bodied scaffolds typed against intended sheaf-level RHS; file-level sorry count rose 0 → 3 reflecting that `sorry_analyzer` can now see the incompleteness)
- iter-136: 2 (iter-136 prover lane closed Step 3 `_restrict_along_identity_section`, ~27 LOC, kernel-only; sorry count 3 → 2)
- iter-137: 2 (iter-137 prover lane on Step 2 returned PARTIAL — 4 docstring edits, 0 code edits, 0 new declarations, body still `sorry`)

#### Helpers added per iter
- iter-134: 5 new declarations (`shearMulRight` + 2 `@[simps]` companions + `schemeHomRingCompatibility` + 3 hollow placeholder theorems later replaced iter-135)
- iter-135: net +0 declarations (REPLACED 3 hollow placeholders 1:1 with honest sorry-bodied scaffolds; structurally restructured `nonempty_jacobianWitness` body but that's in `Jacobian.lean` not Route 4 file)
- iter-136: 1 new declaration (`section_snd_eq_identity_struct` private helper L452, ~5 LOC) — substantive close of Step 3 (~27 LOC total: helper + body)
- iter-137: 0 new declarations (4 docstring edits only on L506, L596-L597, L427-L432, L479-L499)

#### Prover statuses per iter
- iter-134: COMPLETE-with-caveats (Step 1 substantively closed; Steps 2/3/Main hollow placeholders flagged by both review audits as must-fix-this-iter)
- iter-135: plan-only (refactor lane, no prover; addressed iter-134 must-fix)
- iter-136: COMPLETE (Step 3 substantively closed, kernel-only axioms, ~27 LOC)
- iter-137: PARTIAL (Step 2 body still `sorry`; iter-137 mathlib-analogist's 5-step recipe blocked at recipe Step 2 — `PresheafOfModules.pullback` chart-opacity gap, anticipated by analogist Decision 4 but un-anticipated by blueprint prose; prover validated as compiling-typeable an inverse-direction-via-adjunction-transpose alternative skeleton that reduces closure to a single concrete ~100–200 LOC derivation construction sub-goal)

#### Recurring blocker phrases
- "`PresheafOfModules.pullback` opacity on `.obj`/`.map`" — appears in iter-137 prover task result + iter-137 mathlib-analogist Decision 4. ONE iter only (recipe was prescribed in iter-137; obstacle encountered same iter). NOT yet recurring.
- No other recurring blocker phrases across iter-134→iter-137.

#### Planner's current proposal for this iter
- Dispatch a prover lane on `Cotangent/GrpObj.lean` Step 2
  (`_basechange_along_proj_two`) using the iter-137 prover's validated
  inverse-direction-via-adjunction-transpose route (Attempt 2 in
  `task_results/Cotangent_GrpObj.lean.md`). The plan is to ship a
  substantive iter-138+ closure path consisting of: (a) build a
  ~30–60 LOC `PresheafOfModules.pullback` chart-unfolding helper
  (`pullbackObjEquivTensor` per the iter-137 task result's signature
  target), then (b) attempt Step 2 closure via the universal-property-
  at-presheaf-level route (per `analogies/kaehler-tensorequiv-presheafpullback.md`)
  OR fall back to the inverse-direction-via-adjunction-transpose route
  (Attempt 2). Concurrent blueprint-writer dispatch on `RigidityKbar.tex`
  to document the chart-opacity blocker + the two alternative closure
  paths so the chapter catches up with the iter-137 prover finding.

### Route 2 (off-critical-path this iter): M2.a body close `rigidity_over_kbar` in `AlgebraicJacobian/RigidityKbar.lean`
- DEFERRED to iter-151+ per STRATEGY.md (gated on shared cotangent-vanishing pile pieces (i)+(ii)+(iii) closure). No prover this iter.

### Route 3 (off-critical-path this iter): M2.b body close `genusZeroWitness` + M3 body close `positiveGenusWitness` in `AlgebraicJacobian/Jacobian.lean`
- M2.b body DEFERRED to iter-153+; M3 user-escalation-pending. No prover this iter.

## Out of scope

- All non-`Cotangent/GrpObj.lean` files (M2.a, M2.b, M3, M1, cohomology, rigidity).
- Strategic soundness of routes (strategy-critic's territory).
- Blueprint correctness (blueprint-reviewer's territory).

Render your verdict per Route. The verdict that matters most is Route 4.
