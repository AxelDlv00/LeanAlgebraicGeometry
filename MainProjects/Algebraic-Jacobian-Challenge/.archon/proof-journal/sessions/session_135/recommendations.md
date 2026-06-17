# Recommendations for the next plan-agent iteration (iter-136)

## HIGH — iter-136 PRIMARY DECISION: dispatch piece (i.b) Step 3 prover lane

The iter-135 honest-scaffold refactor was, per both
review-phase audits, a **legitimate honesty improvement**:

- `lean-auditor-review135`: "the project's `.lean` source is internally
  consistent and the iter-135 refactor is a legitimate honesty
  improvement (3 typed lies replaced by 3 honest scaffolds, 1 inline
  `sorry` decomposed into 2 delegations); the 6 outstanding load-bearing
  `:= sorry` bodies are the project's known mathematical-content
  scaffolds, all openly documented with iter-aligned closure plans".
- `lean-vs-blueprint-checker-cotangent-grpobj-review135`: "this Lean
  file follows its blueprint chapter faithfully, the three honest-scaffold
  `sorry` bodies are the explicitly-authorized iter-135 pattern
  (intended-type signatures pinned, `\notready` markers correct,
  closure targets documented)".
- `lean-vs-blueprint-checker-jacobian-review135`: "the iter-135
  plan-phase refactor (body restructure of `nonempty_jacobianWitness`
  via `by_cases`, plus the new `positiveGenusWitness` subsection and
  updated proof block) is faithful, well-documented, and bidirectionally
  consistent".

**Iter-136 PRIMARY ACTION**: dispatch a prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean` targeting
`relativeDifferentialsPresheaf_restrict_along_identity_section` at L496
(the iter-135 honest scaffold for piece (i.b) Step 3, ~30–80 LOC
closure).

Per PROGRESS.md watch criterion 4:

> Attack Step 3 (`relativeDifferentialsPresheaf_restrict_along_identity_section`,
> ~30–80 LOC) FIRST as the smallest substantive piece. The closure
> path is documented in `blueprint/src/chapters/RigidityKbar.tex` §
> Piece (i.b) `lem:GrpObj_omega_restrict_to_identity_section` proof
> (uses `PresheafOfModules.pullbackComp` + `PresheafOfModules.pullbackId`
> on the categorical identity `pr_2 ∘ s = η_G ∘ π_G`). If Step 3
> closes within iter-136, attempt Step 2
> (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
> ~150–300 LOC) iter-137; if iter-136 stalls on Step 3, escalate via
> blueprint-writer expansion before assigning iter-137.

This is the cheapest substantive iter-135-landed scaffold to close;
success confirms the iter-135 honest-scaffold pattern + the
`Scheme.Hom.toRingCatSheafHom` idiom transports to actual body
closure.

## HIGH — iter-136 mandatory critic dispatches

Per the standard plan-phase protocol:

1. **`strategy-critic-iter136`** — re-verification dispatch. Per
   iter-135 plan.md's "Watch criteria committed for iter-136"
   item 3, the iter-136 critic should NOT re-issue iter-135 Alt 2
   (temporary-axiom pile-composition smoke test); if it does, ratify
   the iter-135 rebuttal in the iter-136 sidecar rather than
   re-litigate. Iter-135 Alt 1 (genus-stratified body restructure)
   LANDED iter-135 — no carry-over.

2. **`blueprint-reviewer-iter136`** — confirm `RigidityKbar.tex` stays
   `complete: true` / `correct: true` after the iter-135 writer pass
   added `lem:GrpObj_shearMulRight` block + 3 NOTE rewrites. Apply the
   HARD GATE per-file rule for the iter-136 prover dispatch on the 3
   iter-135 honest scaffolds in `Cotangent/GrpObj.lean`.

3. **`progress-critic-iter136`** — apply the iter-135-committed
   PASS / FAIL criteria for Route 4 (piece (i.b)):
   - **PASS (iter-135 progress-critic criterion)**: ≥ 2 of 3
     placeholders refactored to non-`Nonempty (X ≅ X)` types — already
     satisfied (3 of 3 via iter-135 refactor).
   - **Iter-136 next-tier PASS**: iter-136 prover round substantively
     closes ≥ 1 of the 3 honest-scaffold bodies (Step 3 ~30–80 LOC is
     the cheapest target).
   - **FAIL (flips Route 4 to CHURNING)**: any iter-136 prover round
     that adds further declarations whose declared types do not match
     docstring intent only at the prose level (the same placeholder
     pattern). The iter-135 plan agent has codified this in the
     refactor's `Cotangent/GrpObj.lean` section docstring + the new
     RigidityKbar.tex iter-135 NOTE blocks — the convention is
     **honest scaffolds, never tautological-iso placeholders**.

## MED-A — Stale `\leanok` markers (auto-cleared on next sync_leanok)

Per PROGRESS.md iter-135-close watch criterion 6, three `\leanok`
markers on the proof blocks of the iter-134 placeholder lemmas
remain in the blueprint:

- `RigidityKbar.tex:402` — proof block of `lem:GrpObj_mulRight_globalises`
- `RigidityKbar.tex:473` — proof block of `lem:GrpObj_omega_basechange_proj`
- `RigidityKbar.tex:524` — proof block of `lem:GrpObj_omega_restrict_to_identity_section`

These were added by the deterministic `sync_leanok` phase after the
iter-134 prover lane shipped `⟨Iso.refl _⟩` bodies (which compile
without `sorry`); the iter-135 refactor swapped those bodies for
`:= sorry`, but `sync_leanok` did NOT re-run this iter (no prover
phase → no sync trigger). The review prompt forbids the review agent
from touching `\leanok` ("Do not add or remove `\leanok` yourself"),
so the markers stay until `sync_leanok` next runs.

**iter-136 plan agent**: verify that the next `sync_leanok` run (after
iter-136's prover phase, if any) removes these three `\leanok`
markers. If the iter-136 prover lane substantively closes one of the
three scaffolds, the corresponding `\leanok` correctly returns; if
not, it should stay removed.

## MED-B — Minor blueprint citation drift (`Jacobian.tex:400`)

`lean-vs-blueprint-checker-jacobian-review135` flagged a stale
line-range citation: `Jacobian.tex:400` cites
`Jacobian.lean:120–126` for the witness type; the actual location is
`Jacobian.lean:134–140` (the iter-127 → iter-135 line shifts pushed
the declaration down by 14 lines). Trivial blueprint-writer fix in
iter-136 if desired; informational, not blocking.

## MED-C — Stale Lean-line anchors in `Cotangent/GrpObj.lean` docstring

`lean-vs-blueprint-checker-cotangent-grpobj-review135` flagged 5 stale
"line N below" references in the file-header docstring at L61, L107,
L146, L155, L160 (read "line 244 below" / "line 198 below" — actual
lines are 256 / 210). The iter-135 refactor's Change 1.6 de-pinned the
file-header docstring but only partially (L28–32 were updated; the
in-body references at L61/L107/L146/L155/L160 were missed).

**iter-136 action**: optional one-shot docstring refactor (~5 lines
of edits, in `Cotangent/GrpObj.lean`). Not blocking — these are
documentation-rot only with no compilation impact, but they will
continue to drift on the next non-trivial file edit. Per
`lean-auditor-review135` minor finding (classified per directive as
NOT must-fix).

## LOW — Verbose `_curve` wrapper-doubling pattern (cohomology files)

`lean-auditor-review135` flagged a minor pattern observation:

- `Cohomology/StructureSheafModuleK.lean` and
  `Cohomology/MayerVietorisCover.lean` each carry a verbose
  `_curve` dot-notation wrapper pattern across iter-029 through
  iter-052 (each iter ships two forms: an abstract version and a
  `_curve`-specialised version).
- "Functionally correct but a candidate for a later refactor pass
  if the file becomes a navigation burden. Not blocking."

This is a cleanup candidate for a future polish phase or a quiet
iter. No iter-136 action required; informational.

## Watch criteria for iter-136

(carried forward from PROGRESS.md; copied here for the next plan-agent
convenience)

1. **HONEST-SCAFFOLD CONVENTION CODIFIED**: the iter-135 refactor's
   `Cotangent/GrpObj.lean` section docstring at L421 + the iter-135
   RigidityKbar.tex iter-135 NOTE blocks state the project convention
   that multi-iter Mathlib-gap targets MUST use intended-type
   signatures with `sorry` bodies, NEVER tautological-iso placeholders.
   Iter-136 prover lanes MUST honor this; auditor/checker reports will
   flag violations as must-fix-this-iter under the strict rubric.

2. **META-PATTERN TRIPWIRE (iter-132 non-promise)**: no 4th body
   reshape on `cotangentSpaceAtIdentity` under any future iter. Iter-135
   held. Iter-136 must not reshape this declaration's body.

3. **Trigger (a')/(c) LOC arm** (per strategy-critic-iter134 CHALLENGE 1):
   600 LOC built without converging triggers (a')/(c). Iter-135 added 0
   LOC to (i.b)-side build (refactor was signature change, not new pile
   build). Iter-136+ accumulates against this arm.

4. **PROGRESS.md watch criterion 4 sequencing**: Step 3 first, then
   Step 2 (if Step 3 closes within iter-136), then composition into
   the main lemma. If iter-136 stalls on Step 3, escalate via
   blueprint-writer expansion before assigning iter-137 prover lane.

## Reusable patterns surfaced this iter

(no new substantive proof patterns — refactor was a signature change,
not a closure of new mathematical content)

One workflow re-confirmation:

- **`lean_run_code` elaboration check via mathlib-analogist (D)**
  is a valid lighter-weight integration spike that replaces a separate
  type-check spike iter. Use this pattern for future multi-iter
  Mathlib-gap targets: type-check the intended signature via
  `lean_run_code` in a mathlib-analogist dispatch BEFORE the refactor
  lane lands the intended types as sorry-bodied scaffolds.

## What NOT to retry

- **`Nonempty (X ≅ X) := ⟨Iso.refl _⟩` placeholder pattern**: do NOT
  retry under any iter. This is codified as the project's known
  anti-pattern (Knowledge Base entry "The `Nonempty (X ≅ X)`
  tautological-placeholder anti-pattern") and enforced via the
  `lean-auditor` / `lean-vs-blueprint-checker` strict rubrics.
- **Temporary-axiom pile-composition smoke test** (iter-135
  strategy-critic Alt 2 REJECTED-WITH-EXPLICIT-REBUTTAL): do NOT
  re-propose. The iter-121 user directive bans new axioms, and the
  iter-135 type-elaboration check via `lean_run_code` already serves
  as a lighter-weight integration spike. Per the iter-135 rebuttal
  in `iter/iter-135/plan.md`, if iter-136's strategy-critic re-issues
  this, the iter-136 plan agent ratifies the iter-135 rebuttal in the
  iter-136 sidecar rather than re-litigating.
- **4th body reshape on `cotangentSpaceAtIdentity`**: META-PATTERN
  TRIPWIRE non-promise iter-132. Forbidden.

## Reports archive

- `task_results/lean-auditor-review135.md` — review-phase audit (6
  must-fix all scaffolds, 0 excuse-comments, 0 major, 3 minor;
  iter-135 refactor classified as honesty improvement).
- `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review135.md`
  — PASS, 0 must-fix / 0 major / 1 minor (partial line-anchor
  de-pinning at L61/L107/L146/L155/L160).
- `task_results/lean-vs-blueprint-checker-jacobian-review135.md` —
  clean, 0 must-fix / 0 major / 1 minor (stale citation
  `Jacobian.tex:400`).
