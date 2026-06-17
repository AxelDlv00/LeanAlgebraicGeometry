# Blueprint Reviewer Directive — iter-136

You are the whole-blueprint reviewer. Read **every** chapter under
`blueprint/src/chapters/` plus `blueprint/src/content.tex` and the
macros file `blueprint/src/macros/common.tex`. Render a per-chapter
checklist of completeness + correctness, plus the standard
must-fix-this-iter / soon / informational summary.

## Scope

You always audit the whole blueprint. Do NOT scope-limit; the
cross-chapter view is the point of running you.

## Relevant Lean targets this iter

The iter-136 plan agent is considering dispatching a prover lane on
**`AlgebraicJacobian/Cotangent/GrpObj.lean`** targeting one or more
of the three iter-135-landed honest scaffolds:

- `relativeDifferentialsPresheaf_basechange_along_proj_two` (L468;
  piece (i.b) Step 2 base-change of differentials; ~150–300 LOC
  closure NEEDS_MATHLIB_GAP_FILL load-bearing)
- `relativeDifferentialsPresheaf_restrict_along_identity_section`
  (L496; piece (i.b) Step 3; ~30–80 LOC closure; CHEAPEST iter-136
  target)
- `mulRight_globalises_cotangent` (L560; piece (i.b) main lemma)

These map to `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i.b)
sub-lemma decomposition". Specifically:

- `lem:GrpObj_omega_basechange_proj` corresponds to L468.
- `lem:GrpObj_omega_restrict_to_identity_section` corresponds to L496.
- `lem:GrpObj_mulRight_globalises` corresponds to L560.
- `lem:GrpObj_shearMulRight` (new this iter) corresponds to
  `AlgebraicGeometry.GrpObj.shearMulRight` (already closed iter-134;
  no sorry).

**HARD GATE application**: per the per-file dispatch rule, for each
prover-target file, the chapter must be `complete: true` AND
`correct: true` AND have no must-fix-this-iter finding. Apply this
to `RigidityKbar.tex` for the 3 honest-scaffold targets and to
`AlgebraicJacobian_Cotangent_GrpObj.tex` for the per-Lean-file
auxiliary chapter listing.

Other prover-target candidates this iter:

- `Jacobian.lean` — 2 sorries (`genusZeroWitness` L193 +
  `positiveGenusWitness` L223), both gated on downstream M2/M3 work
  and not iter-136 targets per the strategy.
- `RigidityKbar.lean` — 1 sorry (`rigidity_over_kbar` L75), body
  gated on the M2.body-pile pieces (i)–(iii); not iter-136 target.

## Iter-135 close blueprint state (for reference)

- `RigidityKbar.tex` 586 LOC; iter-135 added `lem:GrpObj_shearMulRight`
  block + streamlined `lem:GrpObj_mulRight_globalises` Step 1 + 3
  iter-134 NOTE blocks rewritten + 3 line-citations de-pinned.
- `Cohomology_MayerVietoris.tex` 3 broken refs fixed at L769 + L917.
- `Jacobian.tex` new `\subsection{The positive-genus arm of the
  witness existence}` + `\lean{AlgebraicGeometry.positiveGenusWitness}`
  block + iter-135 body-restructure paragraph.
- `content.tex` added `\input{chapters/AlgebraicJacobian_Cotangent_GrpObj}`.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` updated bullet list with
  `schemeHomRingCompatibility` + `shearMulRight` companion `@[simps]`
  lemmas.

**Carry-over items from iter-135 close** (NOT must-fix-this-iter
unless severity warrants):

- `Jacobian.tex:400` stale citation `Jacobian.lean:120–126` (actual
  `134–140`) — iter-135 lean-vs-blueprint-checker MED-B (informational).
- `Cohomology_StructureSheafModuleK.tex` label-prefix asymmetry at
  L358/386/440 — iter-135 blueprint-reviewer "option (b) chosen,
  leave as-is" (informational).
- Iter-134 informational soft drifts in `Jacobian.tex` C.2.a–C.2.e —
  deferred.

## Output

Write your full report to
`.archon/task_results/blueprint-reviewer-iter136.md`. The wrapper
script manages the path; do not include a filename in your output
content. Use the per-chapter checklist format documented in the
blueprint-reviewer descriptor.

Render a HARD GATE verdict per chapter relevant to this iter's prover
candidates (clear-to-dispatch / defer-with-writer-pass).
