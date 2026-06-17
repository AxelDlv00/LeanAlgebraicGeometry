# Recommendations for the next plan-agent iteration (iter-135)

## PRIMARY DECISION — convention vs. rubric on `Nonempty (X ≅ X)` placeholder bodies

Both mandatory review-phase audits flagged the iter-134 prover lane's three placeholder declarations at `AlgebraicJacobian/Cotangent/GrpObj.lean:476/508/566` (`relativeDifferentialsPresheaf_basechange_along_proj_two`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `mulRight_globalises_cotangent`) as **must-fix-this-iter under the strict rubric**:

- `lean-auditor-review134`: 3 critical-severity must-fix items + 3 critical-severity excuse-comments. Reports the pattern as "weakened-wrong-definition: Lean defines a structurally-different stand-in" on load-bearing declarations.
- `lean-vs-blueprint-checker-cotangent-grpobj-review134`: 3 must-fix-this-iter under strict rubric. Reports the pattern as "signature mismatch with the blueprint's prose"; flags that `\leanok` was added by the deterministic `sync_leanok` phase to the proof blocks of these three lemmas (because the Lean compiles with no `sorry`) but is "technically-consistent but semantically misleading" — the closed `proof` matches a tautology, not the intended substantive statement.

The iter-134 plan agent **explicitly pre-committed** to this placeholder pattern (PROGRESS.md `## Current Objectives` does not name the convention, but the prover's task result records it as honored), and the blueprint blocks in `RigidityKbar.tex` correctly carry `\notready`. So the pattern is fully disclosed, not a hidden defect. But it emits **zero machine-readable incompleteness signal**: `sorry_analyzer` cannot distinguish a tautological-iso placeholder from a real closure, and a downstream consumer of `mulRight_globalises_cotangent` sees a named, signed theorem that returns a hollow `Iso.refl`.

**The iter-135 plan agent must make a PRIMARY DECISION**:

- **OPTION (i) — TIGHTEN THE RUBRIC** to exempt `\notready`-marked + docstring-intended-type placeholders for multi-iter Mathlib-gap work, formalizing the placeholder convention in `STRATEGY.md` and/or `.archon/CLAUDE.md` so future auditor / checker dispatches don't re-flag.
- **OPTION (ii) — REFACTOR THE LEAN** to carry the intended sheaf-level signatures with `sorry` bodies (mirroring the honest-scaffold pattern of `Jacobian.lean`'s `positiveGenusWitness` at L194–215, which **both** review-phase audits classified as **honest** because the type is the intended type and the `sorry` emits a downstream-visible incompleteness signal).

**Recommendation: ADOPT OPTION (ii).** Refactoring delivers four concrete benefits the auditor surfaced:

1. The unused `{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom]` parameters on the three placeholders (currently triggering Lean's unused-variable hints under strict settings) become USED once the body type matches the intended `PresheafOfModules.pullback (φ_str G)`-based RHS.
2. `sorry_analyzer` then sees the iter-134-introduced incompleteness and reports it consistently — both `sync_leanok` and the project's whole-project sorry-counting commands then correctly classify the placeholder pieces as incomplete (currently they read as "complete with kernel-only axioms" because `Iso.refl _` is a real term, not `sorry`).
3. The pattern aligns with the iter-127-onward project convention (per `positiveGenusWitness` iter-134, `genusZeroWitness` iter-127, `nonempty_jacobianWitness` Phase-C scaffold, `rigidity_over_kbar` iter-126) where multi-iter deferred work is encoded as `theorem foo : <intended-type> := sorry` or `noncomputable def foo : <intended-type> := sorry`, never as a tautological stand-in.
4. The iter-135 prover lane on Step 2 (the load-bearing 150–300 LOC body) can then directly replace the `sorry` body for `relativeDifferentialsPresheaf_basechange_along_proj_two` against its *intended* type, without first re-shaping the signature.

The cost of Option (ii) is one refactor-lane dispatch (~3 declarations × ~10–20 LOC of signature replacement = ~30–60 LOC; sorry count 4 → 7 temporarily until the iter-135+ prover work lands). The refactor lane should be dispatched parallel-with the iter-135 mandatory critics so the prover lane that follows hits the corrected signatures.

A concrete refactor-subagent directive for Option (ii) (suggested):

```
target: AlgebraicJacobian/Cotangent/GrpObj.lean lines 449–572 (3 placeholder theorems)

For each of the 3 placeholders, replace:
  theorem foo (args) : Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅
      Scheme.relativeDifferentialsPresheaf G.hom) := ⟨Iso.refl _⟩
with:
  noncomputable def foo (args) : <intended type per the docstring + blueprint>
      := sorry

For `mulRight_globalises_cotangent`:
  intended type per blueprint `lem:GrpObj_mulRight_globalises` lines 298–305:
    relativeDifferentialsPresheaf G.hom ≅
      (PresheafOfModules.pullback (φ_str G)).obj
        ((PresheafOfModules.pullback (φ_η G)).obj
          (relativeDifferentialsPresheaf G.hom))
  where φ_str : compatibility morphism for `G.hom : G.left ⟶ Spec (.of k)`
        φ_η  : compatibility morphism for `η[G].left : Spec (.of k) ⟶ G.left`
  Both via `((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat _).homEquiv _ _).symm <structure-sheaf comorphism>` — i.e., `schemeHomRingCompatibility G.hom` and
  `schemeHomRingCompatibility η[G].left`, both already provided in-file at line 417.

Same shape for the 2 helpers (intended types in blueprint lines 384–399 + 427–441).

`sorry` count: file 0 → 3. The refactor flips the iter-134 hollow placeholders to honest scaffolds so the iter-135+ prover lane fills in the bodies.
```

## HIGH — `shearMulRight` blueprint coverage (lean-vs-blueprint-checker MAJOR)

`shearMulRight` (the substantively-closed Step 1 of piece (i.b); ~30 LOC NEEDS_MATHLIB_GAP_FILL contribution candidate at `Cotangent/GrpObj.lean:349`) is currently described **only inline** in the proof of `lem:GrpObj_mulRight_globalises` at `RigidityKbar.tex` lines 344–352. No dedicated `\begin{lemma}\label{lem:GrpObj_shearMulRight}\lean{AlgebraicGeometry.GrpObj.shearMulRight}` block exists in the main chapter.

**Action for iter-135**: dispatch a `blueprint-writer` on `RigidityKbar.tex` § Piece (i.b) to add a new lemma block isolating `shearMulRight`. Estimated effort: ~40–60 LOC of LaTeX (statement + proof outline + `\uses{...}` + `\leanok` since the Lean is closed with kernel-only axioms). The writer should also (per the checker's minor findings):

- Add `schemeHomRingCompatibility` to the auxiliary chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` bulleted list (currently omitted).
- Add a sentence to the proof of `lem:GrpObj_mulRight_globalises` pinning the home file for the four `φ_*` compatibility morphisms (`φ_str`, `φ_η`, `φ_pr_two`, `φ_section`) — current options: in `Cotangent/GrpObj.lean` as in-file helpers (precedent: `schemeHomRingCompatibility`), in `AlgebraicJacobian/Differentials.lean`, or upstream as a Mathlib contribution.

If the iter-135 plan agent adopts Option (ii) of the PRIMARY DECISION, this blueprint-writer dispatch can run **in parallel with** the refactor lane (the refactor and the writer touch disjoint files).

## MEDIUM — iter-135 mandatory critics + writer pass on carry-over items

The iter-134 plan agent committed iter-135 to dispatch the 3 mandatory critics + a cleanup writer pass. Recommended directives:

- **`strategy-critic-iter135`**: re-verification per iter-134 plan.md "Watch criteria committed for iter-135" (4 substantive STRATEGY.md edits to confirm; LOC trigger arm on watchpoint; forward-merit-vs-switching-cost weighting; piece (i.a) sequencing row honest framing).
- **`blueprint-reviewer-iter135`**: confirm `RigidityKbar.tex` stays `complete: true` / `correct: true` after the iter-134 prover lane lands (and after the iter-135 blueprint-writer dispatch above completes if scheduled parallel). HARD GATE on per-file prover dispatch for any new declarations.
- **`progress-critic-iter135`**: resolve Route 4 (piece (i.b)) verdict — was UNCLEAR-favorable iter-134; the iter-134 prover lane returned **PARTIAL** (Step 1 closed substantively, Steps 2+3+main as placeholders). Recommendation: progress-critic should classify Route 4 as **PARTIAL/CONVERGING-with-corrective** if the PRIMARY DECISION above adopts Option (ii) (the refactor flips the placeholders to honest scaffolds, which is the corrective the auditor recommended); **CHURNING** if Option (i) is adopted without other action (a 2nd iter on the same file without forward motion); or **STUCK** if iter-135 does nothing on the convention question (the auditor's must-fix-this-iter would then carry into iter-135 unaddressed).
- **`blueprint-writer-rigiditykbar-cleanup-iter135`** (the iter-134-scheduled writer pass): 3 broken `\ref{...}` in `Cohomology_MayerVietoris.tex` (lines 769 × 2 + 917) + label-prefix asymmetry at `Cohomology_StructureSheafModuleK.tex:358` + stale Lean line numbers at `RigidityKbar.tex:159, 493` + `AlgebraicJacobian/Cotangent/GrpObj.lean:28, 30, 31–32` docstring lines.
- **Blueprint update for `positiveGenusWitness`**: iter-135 plan agent should add `\lean{positiveGenusWitness}` hint to `Jacobian.tex`. The new iter-134 scaffold currently has no blueprint coverage (the iter-134 blueprint-reviewer marked `Jacobian.tex` `complete: true` so this is iter-135 informational cleanup, not must-fix).

## LOW — `archon-protected.yaml` verification + sorry-counting

- `archon-protected.yaml` unchanged (9 protected signatures across `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`). `Cotangent/GrpObj.lean` has no protected signatures (verified by direct read). Iter-134 prover lane did not touch any protected declarations.
- Project-wide sorry count at iter-134 close: **4** (`Jacobian.lean:192` `genusZeroWitness` + `Jacobian.lean:215` `positiveGenusWitness` NEW iter-134 + `Jacobian.lean:236` `nonempty_jacobianWitness` Phase-C OFF-LIMITS + `RigidityKbar.lean:87` `rigidity_over_kbar`). The iter-134 prover lane introduced 0 sorries (the +1 delta is from the plan-phase Wave-2 refactor on M3, not from the prover); the lane closed 4 named declarations substantively and introduced 3 hollow-placeholder declarations whose ⟨Iso.refl _⟩ bodies are *not* sorries but are flagged by both review-phase audits as must-fix.

## On the iter-134 strategy-critic-iter134 watchpoint (CHALLENGE 1)

`strategy-critic-iter134` CHALLENGE 1 added a watchpoint to STRATEGY.md § "Direct over-k rigidity" trigger (a'): "> 2 iter slip OR > 600 LOC built without converging". Status at iter-134 close:

- Piece (i.b) iter count: **1 of 2–4** (within envelope).
- Piece (i.b) LOC built: **+278 LOC** (within 600-LOC arm; within 210–440 LOC piece envelope).
- Trigger (a') does NOT fire at iter-134 close.

**However**, if the iter-135 plan agent adopts Option (i) of the PRIMARY DECISION (tighten the rubric, no refactor), iter-135 will record **zero new lines** of substantive forward motion on Steps 2/3/main of piece (i.b) — the placeholders stay placeholders. Progress-critic-iter135 should then flag Route 4 as CHURNING, not CONVERGING. If iter-135 adopts Option (ii), the refactor lane is forward motion (it flips the type signatures to the intended sheaf-level RHS, which is the substantive enabling work for the iter-135+ prover bodies), AND the iter-135 prover lane on Step 2 can proceed against the corrected signature.

Either way, do **not** silently retry the iter-134 placeholder pattern on iter-135 — that would be a churn-without-convergence cycle on the same file in the same lane (cf. the META-PATTERN TRIPWIRE that fired iter-128→iter-131 on `cotangentSpaceAtIdentity`).

## On the unresolved iter-133 stale-anchor cleanup

The iter-133 `lean-auditor-review133` flagged 8 stale Lean-line-anchors in `Cotangent/GrpObj.lean` docstrings; iter-134 deferred a coordinated sync pass to iter-135. Iter-134 close brings the file from 296 → 574 LOC (so anchor drifts have **grown** — the line numbers cited at L28, L30, L31–32 now reference declarations that have moved further down in the file). Iter-135 cleanup writer pass should also re-sync the GrpObj.lean docstring anchors to the current (574 LOC) layout.
