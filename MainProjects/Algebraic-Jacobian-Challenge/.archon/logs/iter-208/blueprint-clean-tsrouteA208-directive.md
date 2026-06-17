# Blueprint-clean directive — iter-208 — chapter Picard_TensorObjSubstrate.tex

Post-write purity gate on `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
after an iter-208 route rewrite. The lemma `lem:tensorobj_restrict_iso` was
re-proved from the abstract-adjoint mate-δ route to "Route A" (open-immersion
sectionwise base change along the structure-sheaf ring iso), and
`lem:restrictscalars_laxmonoidal` was demoted to an off-path supplement.

Tasks:
- Strip any Lean tactic syntax, project-history / iter-number leakage, and
  verbose dead-route narrative that survived the rewrite (the chapter must read
  as timeless mathematics).
- Confirm no residual claim that the tensor-restriction iso is proved via the
  oplax δ / `leftAdjointOplaxMonoidal` / `(restrictScalars φ).LaxMonoidal`
  instance / flatness of line bundles — that route is abandoned; the active
  proof is open-immersion sectionwise base change (true for arbitrary M, N).
- The retained `lem:restrictscalars_laxmonoidal` block legitimately keeps its
  lax-monoidal content (it is a real axiom-clean supplement, now off-path) — do
  not delete it; only ensure its prose says it is off the critical path.
- Validate `% SOURCE` discipline: this chapter's rewritten proof is
  Archon-bespoke substrate plumbing with no external math source, so no
  `% SOURCE QUOTE` is expected for it; do not invent one.
- If you find a section needing a source quote you cannot supply, you may spawn
  reference-retriever (write-domain includes references/**), but none is expected.
