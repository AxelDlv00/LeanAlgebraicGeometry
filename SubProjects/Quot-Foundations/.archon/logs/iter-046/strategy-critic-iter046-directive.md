# Strategy-critic — iter-046

Read ONLY these (do NOT read iter sidecars, task_*.md, PROGRESS.md, or any per-iter narrative):
- `STRATEGY.md` (verbatim — the subject of your review).
- `references/summary.md` (reference index).
- Chapter titles (one per file): Cohomology_FlatBaseChange = "Flat base change for the pushforward of a
  quasi-coherent sheaf (i=0)"; Cohomology_RegroupHelper = "Regrouping iso for the affine base-change tensor
  tower"; Picard_FlatteningStratification = "Flattening Stratification of a Coherent Sheaf";
  Picard_GrassmannianCells = "The Grassmannian over ℤ: affine charts and gluing"; Picard_QuotScheme =
  "The Quot scheme"; Picard_RelativeSpec = "Relative Spec".

## Project goal (one paragraph)
Close the sorry-bearing nodes of the Čech-independent leg of the parent's `thm:fga_pic_representability`
cone (Kleiman FGA "The Picard scheme" §4): FBC (flat base change of f_* for i=0), GF (generic flatness),
QUOT (Hilbert polynomial, Quot functor, Grassmannian, representability). End-state: zero project sorry in
the ~29-node closure, kernel-only axioms.

## What changed in STRATEGY this iter (assess soundness)
- GF-geo row: was BLOCKED-on-gap2; now ACTIVE with the G1 finite-type BASE CASE as the live blocker
  (gap2 DONE iter-044, G1 locality half DONE iter-045). The base case = a Mathlib-absent geometric bridge
  (sheaf-epi ⟹ Γ-level module surjectivity) to be effort-broken then proved.
- QUOT-defs consumers row: gap2 FULLY CLOSED; annihilator characterization frontier-ready; P2 predicate defined.
- FBC-A1 row: PARKED but structural unknowns RESOLVED (keystoneAdjR/Beta built); residual = large mechanical
  transport; off critical path.
- gap2 row moved to ## Completed.

Challenge anything unsound: route ordering, whether the GF base-case is correctly framed, whether parking
FBC (vs. resuming) is defensible given it's off critical path, whether SNAP/QUOT-repr sequencing holds.
