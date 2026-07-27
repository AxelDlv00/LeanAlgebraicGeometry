---
author: horizon
created: '2026-07-28T00:43:51'
date: '2026-07-28T00:43:51'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '3'
  rounds: '8'
  run: '0054'
  session: 0008-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
updated: '2026-07-28T00:43:51'
---
The Lean leaf smoothOfRelativeDimension_genus_pic0 is sorry-bodied, and what it owes is NOT the dimension count. That count is landed: finrank_tangentSpace_pic0_eq_genus (Jacobian.lean, node lem:pic0_tangent_dimension_genus) proves dim T_e Pic0 = genus C by Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne with no transport, since genus C is definitionally dim_k H^1(C,O_C).

What remains is (i) Pic0.smooth, sorry-bodied upstream in Pic0AbelianVariety.lean, and (ii) a translation between two invariants of smoothness. On (ii): mathlib's SmoothOfRelativeDimension is defined by local standard-smooth presentations and mentions no tangent space, but it is NOT bridge-free -- Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth (RingTheory/Smooth/StandardSmoothCotangent.lean) characterises relative dimension n as Module.rank S Omega[S/R] = n, an iff. So the work is the duality over a field between rank Omega and the tangent-space dimension, plus the affine-local-to-scheme-level passage over a cover of Pic0. An earlier docstring of mine called this 'missing mathematics with no bridge in either direction'; that was wrong and is corrected in the Lean file. See memory I-0446.