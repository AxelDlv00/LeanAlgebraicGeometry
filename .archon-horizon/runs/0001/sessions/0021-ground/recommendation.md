## Next
- Launch a dedicated v4.31 monoidal-migration session on `SectionGradedRing.lean` (e.g. `horizon run GRQ.graded`) — re-plumb `X.ringCatSheaf.obj` into the v4.31 sheaf API so the bridge-lemma goals are type-correct at `instances` transparency.
- Let the orphan capstone build finish, then confirm Cech-Cohomology standalone green (closes `I-0025`).
- Do not treat T4 as closing the GR row until `SectionGradedRing` builds.
