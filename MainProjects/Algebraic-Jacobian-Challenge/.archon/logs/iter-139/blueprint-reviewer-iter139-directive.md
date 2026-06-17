# Blueprint Reviewer Directive — iter-139

## Scope

Whole-blueprint audit, per your standard rubric. The blueprint lives at
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/` and is
indexed by `blueprint/src/content.tex`.

## What to look for (the standard checklist applies)

For each chapter `<Slug>.tex`, report:

- `complete`: true / partial / false (does the chapter cover every
  declaration the corresponding Lean file needs to formalize?).
- `correct`: true / partial / false (is the mathematical content
  correct and aligned with the project's strategy?).
- `must-fix-this-iter`: list of items that block downstream prover
  work on the corresponding Lean file.
- Any `\ref{...}` / `\uses{...}` targets that resolve to non-existent
  labels (broken cross-references).
- Any `\lean{...}`-named declarations whose signature in the blueprint
  doesn't match the Lean target (where verifiable from prose).

## Iter-139-specific focus

Iter-138 closed the prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean` PARTIAL with substantive
structural body cut on
`relativeDifferentialsPresheaf_basechange_along_proj_two`
(`lem:GrpObj_omega_basechange_proj`). Two new helpers landed in Lean
(`basechange_along_proj_two_inv_derivation` and
`basechange_along_proj_two_inv`) without dedicated `\lean{...}` blocks
in `RigidityKbar.tex`. Three concrete sub-sorries remain inside
those helpers + the main:

- `Cotangent/GrpObj.lean:581` — `d_app` of the pointwise derivation
  (zero-on-φ_G-image).
- `Cotangent/GrpObj.lean:585` — `d_map` of the pointwise derivation
  (cross-open naturality).
- `Cotangent/GrpObj.lean:624` — `IsIso` of `basechange_along_proj_two_inv`.

Iter-139's plan is to dispatch a prover lane on the two derivation
sub-sorries (d_app + d_map) and a `mathlib-analogist` consult on the
two `IsIso` closure routes (Route (a) chart-unfolding-helper vs Route
(b'2) local-iso check) in parallel.

### Specific checks for this iter

1. **HARD GATE on `Cotangent/GrpObj.lean`**: confirm
   `AlgebraicJacobian_Cotangent_GrpObj.tex` AND `RigidityKbar.tex`
   (the two chapters carrying `\lean{...}` blocks for that file's
   declarations) are `complete: true` AND `correct: true` AND carry
   no must-fix-this-iter items touching them. **Without this, the
   iter-139 prover lane on the two derivation sub-sorries CANNOT
   dispatch.**

2. **`RigidityKbar.tex` §
   `lem:GrpObj_omega_basechange_proj`**: the iter-138 blueprint-writer
   landed a ~140-line `% NOTE iter-137:` block documenting Routes
   (a) + (b) for closing this lemma's iso. Now that iter-138 prover
   has chosen Route (b) and decomposed the lemma into 3 sub-sorries,
   is the chapter prose **adequate to guide the iter-139 prover** on
   the d_app + d_map closure? Specifically:
   - Does the chapter spell out the algebraic-coherence fact for
     d_app (factorisation through the categorical commutativity
     `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` in
     `Over (Spec k)`)?
   - Does the chapter spell out the cross-open naturality argument
     for d_map (chase of `Scheme.Hom.c.naturality` +
     `KaehlerDifferential.map_d`)?
   - If either is under-spec'd, flag it as must-fix-this-iter so a
     blueprint-writer can expand BEFORE the iter-139 prover lane
     dispatches.

3. **Possible `sync_leanok` mis-mark on
   `lem:GrpObj_omega_basechange_proj` proof block**: per the iter-138
   lean-vs-blueprint-checker MINOR 2: `RigidityKbar.tex:491` may
   carry `\leanok` on this proof block while the corresponding Lean
   has `letI : IsIso ... := sorry` at L624. The review prompt is
   strict: review-agent does NOT manage `\leanok` (the
   deterministic `sync_leanok` phase does). Flag if you see this
   mis-mark; the iter-139 plan-agent has been instructed to consult
   the `doctor` skill on `sync_leanok`'s handling of
   `letI ... := sorry`.

4. **Pin-pointer for the two new iter-138 helpers**: the
   lean-vs-blueprint-checker recommended adding dedicated
   `\lean{...}` blocks for `basechange_along_proj_two_inv_derivation`
   and `basechange_along_proj_two_inv` in `RigidityKbar.tex` (labels
   `lem:GrpObj_omega_basechange_proj_inv_derivation` and
   `lem:GrpObj_omega_basechange_proj_inv`). Confirm this assessment;
   if you agree, flag as a soon (this-iter-or-next) blueprint-writer
   task.

5. **Long-deferred status-text drift on Phase-C scaffolds** (per
   iter-138 auditor): `RigidityKbar.lean:87 rigidity_over_kbar`
   docstring says "gated on iter-129+ pile" (iter is now 139, 13
   iters of pile prep); `Jacobian.lean:186 genusZeroWitness`
   docstring says "deferred to iter-138+" (iter is now 139);
   `Cohomology/MayerVietorisCover.lean:667–668`
   `HasAffineCechAcyclicCover` forward-ref ~85 iters stale. These
   are Lean-side, not blueprint-side; mention them only if any of
   those drifts is also mirrored in a blueprint chapter.

## Format

Use the standard blueprint-reviewer per-chapter checklist plus a
summary of which chapters need a `blueprint-writer` dispatch this
iter. Apply the HARD GATE rule cleanly.
