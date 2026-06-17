# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review128

## Lean file
AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
blueprint/src/chapters/RigidityKbar.tex

## Known issues
- The Lean file is NEW this iter (iter-128). It carries a single declaration `AlgebraicGeometry.GrpObj.lieAlgebra : ModuleCat k`, body NOW CLOSED (no `sorry`).
- The blueprint chapter pins the Lean declaration via `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` at the `lem:GrpObj_lieAlgebra` block (chapter line 94).
- Blueprint chapter has a sibling lemma `lem:GrpObj_lieAlgebra_finrank` (chapter line 112) with `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}` — this declaration does NOT yet exist in the Lean file by design (iter-129+ deferral per the iter-128 plan-phase re-scoping). Treat as informational, not must-fix.
- Sibling lemmas (i.b), (i.c), and the omega lemmas in the chapter (`lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) are also `\notready` Lean-side; iter-129+ work, not iter-128 scope.
- The chapter's `\notready` on `lem:GrpObj_lieAlgebra` (line 95) is being stripped by the review agent THIS iter as part of marker maintenance (the Lean body just closed). Do not re-flag.

Please report bidirectionally:
- (A) Does the Lean body of `lieAlgebra` faithfully formalize the chapter's proof sketch at `lem:GrpObj_lieAlgebra`? In particular, does the body (`ModuleCat.extendScalars (η_G.appTop ≫ ΓSpecIso.hom).hom .obj (relativeDifferentialsPresheaf G.hom .obj (op ⊤))`) match the blueprint's "pullback of the relative cotangent presheaf along the identity section" construction, or is it a divergent argument?
- (B) Is the chapter detailed enough for this iter-128 close to have proceeded *as it did* (the prover ended up routing through `relativeDifferentialsPresheaf` evaluated at the top open + `ModuleCat.extendScalars`, NOT through the chapter's "$\eta_G^*\Omega_{G/k}$ as $\mathfrak m/\mathfrak m^2$ of the local ring at the identity" alternative phrasing). If those two phrasings yield different `ModuleCat k`'s up to non-canonical iso, flag the chapter as inadequate for downstream iter-129+ work.
