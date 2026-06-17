Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex
Action: Add the two project-local infrastructure blocks the analogist (analogies/grquot-infra.md)
  identified as Mathlib-ABSENT and required by `def:gr_universal_quotient_sheaf`,
  `def:tautological_quotient`, `def:grassmannian_functor`. These are foundational defs the
  existing 5 blocks \uses but which currently have no block.

(1) Predicate block (project-bespoke, model on Mathlib's QuasicoherentData cover+local-iso shape):
  \label{def:is_locally_free_of_rank}
  \lean{AlgebraicGeometry.Scheme.Modules.IsLocallyFreeOfRank}
  `IsLocallyFreeOfRank (M : X.Modules) (d : ℕ) : Prop` — there exists an open cover {U_i} of X
  with `M.over (U_i) ≅ SheafOfModules.free (Fin d)` for each i. Informal: the loc-free-of-rank-d
  condition; phrase the existence of a trivialising cover. Used by the functor's quotient condition.

(2) Module-gluing primitive block (project-bespoke; Mathlib has only abstract Sites/Descent IsStack,
  NOT instantiated for modules — so this is built project-side over the existing `Scheme.GlueData`):
  \label{def:scheme_modules_glue}
  \lean{AlgebraicGeometry.Scheme.Modules.glue}
  Given a `Scheme.GlueData` D, per-chart modules `M_i : (D.U i).Modules`, and a GL_d cocycle of
  isos on overlaps compatible with D's gluing, produce a glued `M : D.glued.Modules` restricting to
  each `M_i`, together with the glued morphism (descent of Hom). State the universal/restriction
  property. Informal proof: descent of objects+morphisms along the open cover; cite Nitsure §5 for
  the bundle-gluing of the tautological quotient if a source quote is wanted.

Wire `def:gr_universal_quotient_sheaf`/`def:tautological_quotient`/`def:grassmannian_functor`
  \uses{} to reference these two new labels accurately.

Constraints: NO Lean tactic code. NO \leanok / \notready markers. Prose only. If you cite Nitsure
  for the gluing, read references/nitsure-hilbert-quot* and quote verbatim per citation discipline;
  otherwise treat as project-bespoke (no source lines). Keep the existing 5 blocks' statements intact.
