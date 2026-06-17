# Strategy-critic directive — iter-048

Fresh-eyes audit of the strategy below. Two routes (GF-G1, SNAP-S0) just hit Mathlib-absent walls now precisely named in the strategy; confirm the decomposition routes are sound and the walls aren't a sign of a wrong design.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the Čech-independent leg of the parent's `thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): flat base change i=0 (FBC), generic flatness (GF), and the Quot/Grassmannian foundations (QUOT). End-state: zero project sorry in the 29-node closure, zero project axioms, kernel-only axioms. Labels mirror the parent so finished work merges back.

## STRATEGY.md (verbatim)
<see .archon/STRATEGY.md — read it in full>

## Reference index
<see references/summary.md — read it in full>

## Blueprint chapter titles (one per file)
- Cohomology_FlatBaseChange — Flat base change for the pushforward of a qcoh sheaf (i=0)
- Cohomology_RegroupHelper — Regrouping iso for the affine base-change tensor tower
- Picard_FlatteningStratification — Flattening stratification of a coherent sheaf (generic flatness)
- Picard_GrassmannianCells — The Grassmannian over ℤ (cells/glue/sep/proper — DONE)
- Picard_QuotScheme — The Quot scheme (gap1/gap2/annihilator DONE)
- Picard_RelativeSpec — Relative Spec
- Picard_SectionGradedRing — Section graded ring infra: tensor powers and graded sections

## Specific questions
1. GF-G1 wall = seam-1 (refine `SheafOfModules.IsFiniteType`'s abstract cover to a finite basic-open cover, Stacks 01PB) + X.Modules↔Spec transport. Is decomposing seam-1 into the 3 primitives the right move, or does the whole GF-G1 affine base case have a cheaper route (e.g. work entirely over `Spec Γ(X,W)` from the start, avoiding the X.Modules transport)?
2. SNAP-S0 wall = the sheaf-level associator (strong-monoidality of `PresheafOfModules.sheafification`). Two candidate routes named (stalkwise-iso criterion vs `Localization.Monoidal`). Is building this associator the right investment, or is there a way to define `L^{⊗m}` and the graded ring that sidesteps needing the full sheaf-monoidal associator?
3. Any route in the active table now mis-estimated by >30%, or any phase that should be reordered given both live frontiers are Mathlib-infra builds?
