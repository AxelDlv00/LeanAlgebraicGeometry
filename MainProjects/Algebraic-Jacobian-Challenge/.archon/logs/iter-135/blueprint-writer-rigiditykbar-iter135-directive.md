# Blueprint Writer Directive — `RigidityKbar.tex` iter-135 cleanup

## Slug

rigiditykbar-iter135

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context

This chapter holds piece (i) of the cotangent-vanishing pile, the core
of the iter-128+ critical path. Piece (i.a) is DONE iter-132 (rank
lemma closed against the iter-131 chart-base-changed body). Piece (i.b)
opened iter-134: Step 1 (`shearMulRight`) substantively closed, Steps
2 / 3 / Main delivered as **tautological-iso placeholders** that both
iter-134 review-phase audits classified as must-fix-this-iter under
the strict rubric.

The iter-135 plan-agent decision is to **refactor the Lean side** to
honest sorry-bodied scaffolds typed against the intended sheaf-level
RHS (using Mathlib's `Scheme.Hom.toRingCatSheafHom`, per the iter-135
mathlib-analogist verdict in
`analogies/phi-compatibility-morphisms.md`). The iter-135 refactor
is dispatched in parallel with this writer call (see
`.archon/logs/iter-135/refactor-grpobj-and-jacobian-iter135-directive.md`).

Your job is to update `RigidityKbar.tex` to (a) add a missing
`lem:GrpObj_shearMulRight` block, (b) rewrite the three iter-134
NOTE blocks to reflect the iter-135 honest-scaffold resolution, and
(c) de-pin or refresh stale Lean-line citations.

## Required content / changes

### Change A — add a `lem:GrpObj_shearMulRight` block

The substantive iter-134 declaration `AlgebraicGeometry.GrpObj.shearMulRight`
(at `AlgebraicJacobian/Cotangent/GrpObj.lean:348-393`; ~30 LOC of
`lift_lift_assoc` / `lift_comp_inv_*` calculus + 2 `@[simps]`-spawned
companions `shearMulRight_hom_fst` / `shearMulRight_hom_snd`) currently
has NO `\begin{lemma}\lean{...}` block in `RigidityKbar.tex`. It is
only referenced descriptively inside the proof body of
`lem:GrpObj_mulRight_globalises` Step 1 (line ~369).

Per the iter-134 lean-vs-blueprint-checker (major flag) and the
iter-135 blueprint-reviewer (must-fix), this declaration deserves its
own block in `RigidityKbar.tex` so it appears in the dependency graph
and can be cited as a `\uses{...}` premise.

ADD a new `\begin{lemma}` block just BEFORE the existing
`\begin{lemma}[(i.b) Shear-iso globalisation of the cotangent]` block
(around line 282 — i.e. as the FIRST sub-lemma of piece (i.b), with
label `lem:GrpObj_shearMulRight`). The block should:

- Have label `\label{lem:GrpObj_shearMulRight}`.
- Pin the Lean target via `\lean{AlgebraicGeometry.GrpObj.shearMulRight}`.
- Have appropriate `\uses{...}` chains (likely `\uses{lem:GrpObj_cotangentSpace}`
  for the typeclass dependencies; pulling from `lem:GrpObj_mulRight_globalises`'s
  current uses is fine).
- State, as a Lemma, that for any `GrpObj G` in a `CartesianMonoidalCategory C`,
  there is a self-iso $\sigma \colon G \otimes G \cong G \otimes G$ given by
  $\sigma_{\mathrm{hom}} = \mathtt{lift\,(fst\,G\,G)\,\mu}$ with inverse
  $\sigma_{\mathrm{inv}} = \mathtt{lift\,(fst\,G\,G)\,(lift\,(fst\,G\,G\,\circ\,\iota)\,(snd\,G\,G)\,\circ\,\mu)}$.
- State the companion identifications $\sigma_{\mathrm{hom}} \circ \pr_1 = \pr_1$
  and $\sigma_{\mathrm{hom}} \circ \pr_2 = \mu$ (the
  `shearMulRight_hom_fst` / `shearMulRight_hom_snd` `@[simps]`-spawned
  companion lemmas).
- Mark `\leanok` (the proof body is fully closed iter-134).
- Have a `\begin{proof} ... \end{proof}` block sketching the inverse-pair
  verification via `lift_lift_assoc` + `lift_comp_inv_left` /
  `lift_comp_inv_right` + `lift_comp_one_left`, modelled on
  `CategoryTheory.GrpObj.mulRight` (`Mathlib.CategoryTheory.Monoidal.Grp_:277-281`).
  Mark `\leanok` on the proof too. Use the proof prose already in the
  Step 1 part of `lem:GrpObj_mulRight_globalises`'s proof (lines ~361–369)
  as the source — extract it into the new sub-lemma's proof rather than
  duplicate it.

Then UPDATE the existing `\begin{lemma}[(i.b) Shear-iso globalisation
of the cotangent]` block (around line 282) so its `\uses{...}` chain
references `lem:GrpObj_shearMulRight` instead of inlining the shear-iso
prose: in the proof body, replace the Step 1 sub-section with a
one-line "By \cref{lem:GrpObj_shearMulRight}, ..." pointer.

### Change B — rewrite the three iter-134 NOTE blocks

`RigidityKbar.tex` currently carries three "NOTE iter-134 review"
comment blocks recording the placeholder/audit situation:

- Lines ~323–339 (inside `lem:GrpObj_mulRight_globalises`)
- Lines ~418–430 (inside `lem:GrpObj_omega_basechange_proj`)
- Lines ~473–484 (inside `lem:GrpObj_omega_restrict_to_identity_section`)

The iter-135 refactor (in flight, in parallel with this writer call)
replaces the placeholder tautological-iso bodies with intended-type
sorry-bodied scaffolds using Mathlib's `Scheme.Hom.toRingCatSheafHom`.
After the refactor lands:

- The Lean signature for each of the 3 declarations IS the intended
  sheaf-level RHS, not a tautology.
- The body is `:= sorry`, machine-readable as incomplete.
- The `\notready` blueprint marker is correct for the iter-135 state
  (proof body unformalized).
- The previously-set `\leanok` markers on the *proof* blocks of those
  three lemmas (added by `sync_leanok` when the Lean compiled with
  the tautological `Iso.refl` body) will be REMOVED by `sync_leanok`
  after the refactor lands sorry bodies — so the proof blocks should
  NOT carry `\leanok` after iter-135.

REWRITE each of the 3 NOTE blocks to reflect the iter-135 resolution.
Each new NOTE block should:

- Be much shorter (2–4 lines vs the current 15–18 lines).
- Record that iter-135 refactored the Lean side to honest sorry-bodied
  scaffolds with the intended sheaf-level RHS signature using
  `Scheme.Hom.toRingCatSheafHom` (Mathlib's canonical helper).
- Reference `analogies/phi-compatibility-morphisms.md` (the iter-135
  mathlib-analogist persistent file) for the design rationale.
- DROP the "iter-135 plan agent must decide between (i) tightening the
  rubric to exempt …" language — that decision has been made.
- Cite the Lean declaration name without a line number (de-pin to
  prevent future drift).

Example (for the `lem:GrpObj_mulRight_globalises` block):

```latex
  % NOTE iter-135: the Lean target
  % \lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent} ships
  % as an honest sorry-bodied scaffold; the signature is the intended
  % sheaf-level RHS displayed above (constructed via Mathlib's
  % `Scheme.Hom.toRingCatSheafHom` as the compatibility morphism for
  % `PresheafOfModules.pullback`, per the iter-135 mathlib-analogist
  % verdict in `analogies/phi-compatibility-morphisms.md`). The proof
  % body is `sorry`; `sync_leanok` removes the prior iter-134 `\leanok`
  % from the proof block accordingly. Body closure is iter-136+ work
  % per the Step 1/2/3/Compose outline below.
```

Adapt the wording for the other two NOTE blocks similarly (with the
appropriate intended type).

### Change C — de-pin stale Lean-line citations

Two stale Lean-line citations in the chapter (per iter-134 +
iter-135 blueprint-reviewers):

- Line 159: cites `AlgebraicJacobian/Cotangent/GrpObj.lean:198--219`
  for the body of `cotangentSpaceAtIdentity_eq_extendScalars`. Actual
  current location: lines 210–231 (per iter-134
  lean-vs-blueprint-checker spot-check).
- Line 493: cites `AlgebraicJacobian/Cotangent/GrpObj.lean:508` for
  the section-restriction declaration.

Plus the three iter-134 NOTE blocks cite `:566`, `:476`, `:508` for
the placeholder declarations. After the iter-135 refactor, those line
numbers will shift.

**Preferred fix: DE-PIN ALL of these line numbers.** Replace each
citation of `AlgebraicJacobian/Cotangent/GrpObj.lean:NNN` with the
declaration name only (e.g. "the Lean body of
`cotangentSpaceAtIdentity_eq_extendScalars`" instead of "the body at
lines 198–219"). This prevents future drift.

The line-citation in `AlgebraicJacobian/Differentials.lean:60--66`
inside the Step 2 helper proof (around line 446) is OK to keep —
that file is more stable.

The line-citations in proof prose like
`Mathlib.CategoryTheory.Monoidal.Grp_.lean:277--281` are OK — those
are Mathlib citations that drift on Mathlib bumps, but de-pinning
them would lose information; keep them.

### Change D (optional cleanup)

If you notice any other minor blueprint-side rot during your edits
(e.g. a paragraph that refers to "the iter-134 placeholder pattern"
elsewhere in the chapter), you may de-stale it in the same pass.
Do NOT do larger structural edits.

## Out of scope

- Do NOT touch any `.lean` file. The Lean refactor is dispatched in
  parallel as `refactor-grpobj-and-jacobian-iter135`.
- Do NOT touch any other blueprint chapter
  (`Cohomology_MayerVietoris.tex`, `Cohomology_StructureSheafModuleK.tex`,
  `Jacobian.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex`,
  `Differentials.tex`, ...). They are handled by other writer calls or
  the plan agent directly.
- Do NOT add `\leanok` markers to any block. That's the
  `sync_leanok` script's job.
- Do NOT remove or modify the existing iter-127 over-k commitment text
  (lines 351 area) or the iter-131 Classical-choose-chain documentation
  section.
- Do NOT decide whether to drop the `Nonempty (...)` wrapper from the
  Lean signature. That decision is for the iter-135 refactor agent
  (informed by the iter-135 mathlib-analogist's informational note);
  your blueprint prose should describe the intended **iso** without
  committing to wrapper or no-wrapper.

## References

- `analogies/phi-compatibility-morphisms.md` (NEW — iter-135 mathlib-
  analogist persistent file; not yet on disk if the analogist's
  `analogies/` write hasn't been committed; if absent, refer to
  `task_results/mathlib-analogist-phi-compatibility-morphisms-iter135.md`
  instead).
- `analogies/mulright-globalises-cotangent.md` (iter-133 mathlib-
  analogist on the sheaf-level RHS decision for piece (i.b)).
- `task_results/lean-auditor-review134.md` (iter-134 auditor reporting
  the placeholder pattern as critical-severity).
- `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review134.md`
  (iter-134 checker reporting strict-rubric must-fix on placeholder
  signature mismatch).

## Expected outcome

- New `lem:GrpObj_shearMulRight` block in place; `lem:GrpObj_mulRight_globalises`
  proof body's Step 1 streamlined to a "By \cref{lem:GrpObj_shearMulRight}, ..."
  pointer.
- Three NOTE blocks rewritten to reflect iter-135 honest-scaffold
  resolution (2–4 lines each, down from 15–18 lines).
- All Lean-line citations in the chapter de-pinned (replaced with
  declaration names; Mathlib-line citations preserved).
- Chapter compiles via `leanblueprint` (or at least `\begin{lemma}` /
  `\label{...}` / `\lean{...}` / `\uses{...}` are syntactically clean).
- LOC delta: probably +30 to +50 LOC for the new lemma block,
  minus the ~30 LOC saved by shortening the 3 NOTE blocks. Net
  expected: roughly 560 → 580 LOC.

Save your report to `.archon/task_results/blueprint-writer-rigiditykbar-iter135.md`.
