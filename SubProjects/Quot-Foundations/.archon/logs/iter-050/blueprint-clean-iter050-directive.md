Action: Post-writer purity pass on the chapters edited this iter:
  - blueprint/src/chapters/Picard_SectionGradedRing.tex (SNAP Analogue-1 re-route: crux
    lem:isIso_sheafification_whiskerRight_unit + cor:sheafTensorObjAssoc + lem:sheafTensorPow_add rewire)
  - blueprint/src/chapters/Picard_GrassmannianQuot.tex (new sec:grquot_infra:
    def:is_locally_free_of_rank, def:scheme_modules_glue)
  - blueprint/src/chapters/Picard_FlatteningStratification.tex (seam-1c prose generalised; an
    iter-049 NOTE comment was removed by the planner)
Strip any Lean tactic syntax, LEAN-STATUS/project-history leakage, and verbosity. Verify/insert
missing source quotes for any cited material (Nitsure for the gluing block, if cited). Do NOT touch
\leanok / \notready. Keep math content intact.
