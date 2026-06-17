# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review129

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

## Known issues

- Both files were edited THIS iter (iter-129) by independent parallel subagents — the refactor lane renamed and relaxed the Lean declaration, while the blueprint-writer lane updated the chapter's `\lean{...}` hint, signature stub, and proof prose. Focus your check on whether the rename and signature relaxation are coherent across the two files:
  - Lean: `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` with signature `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k`.
  - Blueprint: lemma `lem:GrpObj_cotangentSpace` with the matching `\lean{...}` hint and inline signature stub.
- A new blueprint-only lemma `lem:GrpObj_cotangent_bridge` was added this iter (Lean target `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent`). This is intentionally an iter-130+ target with no Lean counterpart yet; flag it only if the chapter is *missing* the cross-references that justify its iter-130 target status, not because the Lean is absent.
- The rank lemma `lem:GrpObj_lieAlgebra_finrank` (label kept) targets the iter-130+ Lean name `cotangentSpaceAtIdentity_finrank_eq` — also intentionally not yet in Lean.
- A separate critical finding (from `mathlib-analogist-lieAlgebra-rank-bridge-iter129`) is that the iter-128 body of `cotangentSpaceAtIdentity` is mathematically degenerate (computes the zero `k`-module for the target class). This finding is OUT OF SCOPE for the file-vs-chapter check — the iter-130 prover lane is staged to swap the body via Replacement (B). Do not re-derive the finding. But: if the chapter still claims the iter-128 body is the *canonical* cotangent space (rather than a placeholder targeted for iter-130 replacement), flag the drift. The chapter SHOULD reflect that the rank-pinning bridge enters via the new `lem:GrpObj_cotangent_bridge`, with the iter-128 body documented as the current Lean encoding (not as a canonically-correct sheaf object).
- Pre-existing long-line linter warning at the bottom of the file is known; do not re-flag.

## Output

Report bidirectionally: Lean → blueprint AND blueprint → Lean. Sections per severity (must-fix-this-iter / major / minor / informational). Write to `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review129.md`.
