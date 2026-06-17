Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex
Action: ONE focused fix. The block `def:scheme_modules_glue`
  (\lean{AlgebraicGeometry.Scheme.Modules.glue}) is correct but lacks a Lean implementation path,
  which blocks the prover. Add a concrete construction-path note (as prose, NOT Lean tactics) to
  its proof/definition body so a prover knows the route.

Implementation path to encode (project-bespoke; Mathlib has NO turn-key module gluing over a
Scheme.GlueData — confirmed by analogies/grquot-infra.md):
  - This is an Archon-original construction. State that explicitly.
  - Route: given the Scheme.GlueData D (already built as Grassmannian.theGlueData) with glued scheme
    D.glued and its canonical open cover by the charts, a glued sheaf of modules is assembled from
    the per-chart modules M_i together with the transition isomorphisms on the pairwise overlaps
    satisfying the cocycle condition. The glued module is characterised by restriction isos
    M.over(chart_i) ≅ M_i compatible with the transitions. Realise the restriction-to-a-chart
    using the project's existing geometric restriction bridge (the open-immersion pullback /
    overRestrictPullbackIso machinery from QuotScheme gap1), which is the same primitive that gives
    an equivalence between the sheaf category on an open and the slice; the cocycle isos descend a
    Hom by the uniqueness of gluing of sections (eq_of_locally_eq' / existsUnique_gluing' shape).
  - The morphism-descent half: a family of chart morphisms agreeing on overlaps glues to a unique
    global morphism by the same locality-of-sections argument.
  Phrase this as a construction sketch giving the prover the primitives to build from; do NOT
  promise a single Mathlib lemma exists. Note it is the hardest decl in the chapter and is expected
  to be a multi-step build.

Constraints: NO Lean tactic code (mathematical/prose construction sketch only). NO \leanok / \notready.
  Touch ONLY def:scheme_modules_glue. Keep all other blocks intact.
