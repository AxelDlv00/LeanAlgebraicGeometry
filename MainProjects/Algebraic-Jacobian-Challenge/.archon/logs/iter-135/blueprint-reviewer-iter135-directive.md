# Directive — blueprint-reviewer iter-135

## Slug

iter135

## What to review

The whole blueprint at `blueprint/src/chapters/*.tex`. Per descriptor,
the blueprint-reviewer always reads the whole blueprint; this directive
does NOT scope you down to a subset.

## Mandatory reading

- `blueprint/src/content.tex` — top-level chapter inclusion order.
- All `blueprint/src/chapters/*.tex` files (currently 14 chapters).
- `blueprint/src/macros/common.tex` — macro definitions.

## Focus areas for this iter

You always produce the per-chapter checklist. In addition, pay attention
to these iter-134-surfaced items:

1. **`RigidityKbar.tex` § Piece (i.b)** statements `lem:GrpObj_mulRight_globalises`
   (line 282), `lem:GrpObj_omega_basechange_proj` (line 389),
   `lem:GrpObj_omega_restrict_to_identity_section` (line 451). The iter-134
   prover lane delivered tautological-iso placeholders in Lean; the
   iter-134 review-phase audits classified this as must-fix-this-iter
   under the strict rubric. The blueprint statements carry `\notready`
   markers correctly, but each statement block also carries a "NOTE iter-134
   review" comment block (lines 323–339, 418–430, 473–484) recording the
   audit verdicts and naming the iter-135 plan-agent decision as pending.
   The iter-135 plan agent is choosing **honest sorry-bodied scaffolds**
   (refactor lane this iter). Your job: assess whether the blueprint
   chapter remains `complete: true` / `correct: true` for the iter-135
   refactor-lane dispatch to land on. (No prover lane on this file this
   iter; the question is whether the chapter is hardened enough that a
   future prover lane against the honest-scaffold signatures can rely
   on the proof-sketch text.)

2. **Missing `lem:GrpObj_shearMulRight` block**. The iter-134
   lean-vs-blueprint-checker flagged that the substantive iter-134
   `shearMulRight` declaration (~30 LOC of `lift_lift_assoc` /
   `lift_comp_inv_*` calculus, classified as NEEDS_MATHLIB_GAP_FILL
   contribution candidate) has no dedicated `\begin{lemma}\lean{...}`
   block in `RigidityKbar.tex`. The iter-135 plan agent will dispatch a
   blueprint-writer to add this block. Confirm this is a real need.

3. **3 broken `\ref`s in `Cohomology_MayerVietoris.tex`** (lines 769 × 2
   + 917). Flagged as "soon" by `blueprint-reviewer-iter134`.

4. **Label-prefix asymmetry at `Cohomology_StructureSheafModuleK.tex:358`**.
   Flagged as informational by `blueprint-reviewer-iter134`; the
   iter-135 cleanup writer will fix.

5. **Stale Lean-line citations** at `RigidityKbar.tex:159, 493`. Flagged
   as soon by `blueprint-reviewer-iter134`.

6. **Add `\lean{positiveGenusWitness}` to `Jacobian.tex`** covering the
   iter-134 scaffold landed at `Jacobian.lean:211`. `Jacobian.tex`
   currently has no block for this new declaration.

## What you decide for each chapter

Per descriptor:

- `complete`: true | partial | false
- `correct`: true | partial | false
- per-chapter must-fix-this-iter findings (block iter-135 work on that
  chapter until addressed)
- per-chapter soon findings (iter-136+ but recorded)
- per-chapter informational findings

## HARD GATE for iter-135

**No prover lane is planned this iter.** Your HARD GATE verdict for
iter-135 is therefore vacuous on prover dispatch — the iter-135
plan agent has already pre-committed to a plan-only refactor + writer iter
(see `iter/iter-135/plan.md`). What you should still report:

- For each chapter whose blueprint is touched by an iter-135 writer
  dispatch (`RigidityKbar.tex`, `Cohomology_MayerVietoris.tex`,
  `Cohomology_StructureSheafModuleK.tex`, `Jacobian.tex`,
  `AlgebraicJacobian_Cotangent_GrpObj.tex`), is the planned writer
  edit shape (per § "Focus areas" above) the right one, or are
  additional items needed?
- For `Cotangent/GrpObj.lean`'s refactor lane (which will replace 3
  placeholder theorems with intended-type signatures + `sorry` bodies):
  does the blueprint provide enough mathematical content for the
  refactor to read the intended type from the chapter? (The intended
  types are pinned in signature stubs at `RigidityKbar.tex:298–305`,
  `384–399`, `427–441`.)

## NOT in scope

Do NOT propose blueprint edits yourself (you are read-only). Do NOT
read Lean files; this is a blueprint audit, not a Lean audit. Do NOT
read `iter/iter-NNN/{plan,review,objectives}.md` — your value is in
fresh per-chapter assessment.

## Output

Standard blueprint-reviewer report shape per
`.archon/subagents/blueprint-reviewer.md`. Save to
`.archon/task_results/blueprint-reviewer-iter135.md`.
