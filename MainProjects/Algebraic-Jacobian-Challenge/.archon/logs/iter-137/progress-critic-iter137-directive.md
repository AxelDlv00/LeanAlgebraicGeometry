# Progress Critic Directive

## Slug
iter137

## Active routes for iter-137 prover assignment

The iter-137 plan agent is considering one prover lane this iter, on
Route 4 (piece (i.b)). The other three routes are gated-by-design and
not under consideration for iter-137 prover assignment. Last K=5 iters
of signals per route follow.

---

### Route 1 — piece (i.a) in `AlgebraicJacobian/Cotangent/GrpObj.lean` (closed declarations)

Per-iter signals (last 5):

- **iter-132**: sorry count change −1 substantive (closed
  `cotangentSpaceAtIdentity_finrank_eq` at L256, kernel-only); prover
  status COMPLETE; helpers added 0; recurring blockers: none.
- **iter-133**: NO PROVER LANE this iter (blueprint hardening only);
  sorry count unchanged; piece (i.a) declarations untouched.
- **iter-134**: NO PROVER LANE on (i.a); piece (i.a) declarations
  untouched (META-PATTERN TRIPWIRE non-promise held).
- **iter-135**: NO PROVER LANE on (i.a); piece (i.a) declarations
  untouched (META-PATTERN TRIPWIRE held).
- **iter-136**: NO PROVER LANE on (i.a); piece (i.a) declarations
  untouched (META-PATTERN TRIPWIRE held).

**Stability claim**: closed iter-132, no regression in 4 subsequent
iters.

---

### Route 2 — M2.b genus-0 arm: `Jacobian.lean:197` `genusZeroWitness`

Per-iter signals (last 5):

- **iter-132**: NO PROVER LANE; scaffold body unchanged from
  iter-127 scaffold (sorry).
- **iter-133**: NO PROVER LANE; unchanged.
- **iter-134**: NO PROVER LANE; unchanged.
- **iter-135**: NO PROVER LANE; unchanged.
- **iter-136**: NO PROVER LANE; unchanged.

**By-design**: gated on M2.a body close (iter-151+) + terminal-object
instances (iter-153+). Off-limits iter-137.

---

### Route 3 — M2.b body-pile (M2.a): `RigidityKbar.lean:87` `rigidity_over_kbar`

Per-iter signals (last 5):

- **iter-132**: NO PROVER LANE; unchanged.
- **iter-133**: NO PROVER LANE; unchanged.
- **iter-134**: NO PROVER LANE; unchanged.
- **iter-135**: NO PROVER LANE; unchanged.
- **iter-136**: NO PROVER LANE; unchanged.

**By-design**: gated on shared cotangent-vanishing pile pieces
(i)+(ii)+(iii) closure. Off-limits iter-137.

---

### Route 4 — piece (i.b) in `AlgebraicJacobian/Cotangent/GrpObj.lean`

This is the iter-137 prover-target route. Last 5 iters of signals:

- **iter-132**: Route 4 NOT YET OPENED (piece (i.a) was the iter-128–132
  span); piece (i.b) staged as iter-133+ work.
- **iter-133**: NO PROVER LANE; blueprint hardening + mathlib-analogist
  on `mulRight_globalises_cotangent` returned PROCEED with sheaf-level
  RHS recommendation + 2 NEEDS_MATHLIB_GAP_FILL sub-pieces identified;
  blueprint chapter hardened for iter-134 dispatch.
- **iter-134**: prover lane FIRED on (i.b); status PARTIAL with
  must-fix. Step 1 (`shearMulRight` + 2 `@[simps]` companions + helper
  `schemeHomRingCompatibility`) substantively closed (~50 LOC, kernel-
  only). Steps 2 + 3 + Main shipped as 3 hollow placeholder theorems
  typed `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` (this is the iter-134
  must-fix flagged by both iter-134 review-phase audits as a
  hollow-tautology pattern). Sorry count delta: 0 new sorries (because
  the placeholders weren't `sorry`-bodied), but 3 hollow declarations
  shipped.
- **iter-135**: NO PROVER LANE; iter-135 plan phase dispatched
  `refactor-grpobj-and-jacobian-iter135` which REPLACED the 3 hollow
  placeholders with 3 honest sorry-bodied scaffolds typed against
  the intended sheaf-level RHS (using `Scheme.Hom.toRingCatSheafHom`
  per the iter-135 mathlib-analogist verdict). Net sorry delta: 4 → 6
  (+2 because the placeholders weren't `sorry` but the honest scaffolds
  are; also +1 net from a structural decomposition in
  `nonempty_jacobianWitness`'s body). This was classified by both
  iter-135 review audits as a "legitimate honesty improvement".
  Helpers added: 0 (refactor only swapped placeholders for scaffolds).
- **iter-136**: prover lane FIRED on Step 3
  (`relativeDifferentialsPresheaf_restrict_along_identity_section` at
  L496); status COMPLETE. Closed substantively via a new private
  helper `section_snd_eq_identity_struct` (~5 LOC) + ~22 LOC of body
  using `PresheafOfModules.pullbackComp` + `eqToIso` + `rw`. Net
  closure ~27 LOC, within predicted 30–80 LOC envelope. Kernel-only
  axioms via `lean_verify`. Sorry count 6 → 5. Both review-phase
  audits returned 0 must-fix / 0 major (3 minor docstring drift items
  flagged, none blocking). Helpers added: 1 small private helper
  (`section_snd_eq_identity_struct`), substantively consumed by the
  closure (not churn-shaped).

**Iter-137 prover-target candidate**: Step 2
`relativeDifferentialsPresheaf_basechange_along_proj_two` at
`Cotangent/GrpObj.lean:480` (the load-bearing NEEDS_MATHLIB_GAP_FILL
of (i.b); ~150–300 LOC closure predicted by the iter-133 mathlib-
analogist envelope, chaining `KaehlerDifferential.tensorKaehlerEquiv`
algebra-side with `PresheafOfModules.pullback` presheaf-side).

**Concurrent iter-137 Wave-1 dispatch**: a mathlib-analogist on this
exact bridge (`mathlib-analogist-kaehler-tensorequiv-presheafpullback-iter137`)
is being pre-dispatched in Wave 1 alongside this critic, with the
intent of giving the prover an `analogies/kaehler-tensorequiv-presheafpullback.md`
+ verdict ahead of the prover lane firing in Wave 2 (the same shape
that worked for iter-135 → iter-136 Step 3).

---

## What we ask of you

Per dispatcher_notes, render per-route verdicts (CONVERGING /
CHURNING / STUCK / UNCLEAR) and any must-fix-this-iter items into
`.archon/task_results/progress-critic-iter137.md`. For Route 4
specifically, the question is: does the iter-136 closure of Step 3
+ the iter-135 honest-scaffold refactor's success constitute enough
signal that Route 4 is CONVERGING, or is the signal still UNCLEAR
because only 2 of 3 substantive closures have landed?

Watch out for:

- **CHURNING patterns**: Route 4 has now spanned 4 iters (133–136); the
  iter-134 must-fix placeholder pattern (REPLACED iter-135) was the
  prototypical CHURNING risk, but it was caught early. Iter-136
  substantive closure on Step 3 is the corrective evidence — but
  judge whether 1 substantive close out of 3 targets is enough to flip
  from UNCLEAR to CONVERGING, or whether the iter-137 dispatch on
  Step 2 should be treated as still-to-be-confirmed.

- **Helper-churn**: Route 4 has accumulated ~600 LOC of file growth
  from iter-134 → iter-136 (3 of 4 declarations in piece (i.b) shipped,
  with Step 2 + Main remaining `sorry`). The strategy's LOC arm of
  trigger (a')/(c) caps cumulative (i.b)-side build at 600 LOC; iter-137
  Step 2 (~150–300 LOC) brings cumulative to ~466–616 LOC. Is this
  approaching the trigger, and if so, what should iter-137 plan do
  about it pre-emptively?

- **Sorry-stall**: sorry count went 4 → 6 → 6 → 5 across iter-134 →
  iter-135 → iter-136. The iter-135 increase is structural-decomposition
  (honest-scaffold refactor + by_cases structural move) and not stall-
  shaped, but a fresh-context read should still verify.

Render concrete corrective actions if any route flips CHURNING / STUCK.
