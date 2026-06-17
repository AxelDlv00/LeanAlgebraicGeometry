# blueprint-clean report — gr-l3 (iter-062)

**File:** `blueprint/src/chapters/Picard_GrassmannianQuot.tex`
**Blocks touched:** `lem:gr_scalarEnd_pullback`, `lem:gr_matrixEnd_pullback`,
`lem:gr_baseChange_bridge`, `lem:gr_bundleCocycle_transport`

## Changes applied

### `lem:gr_scalarEnd_pullback`
- **Statement:** Removed `= p_{\mathrm{appTop}}` from the comorphism annotation
  (Lean elaboration detail; `p^{\sharp}` is sufficient math notation).
- **Statement:** Removed `i.e.\ the comparison \(\mathrm{pullbackObjUnitToUnit}\)`
  from the description of `q` (Lean declaration name leaking into prose).
- Proof: no changes needed (math-only).

### `lem:gr_matrixEnd_pullback`
- **Statement:** Removed `= p_{\mathrm{appTop}}` from the comorphism description.
- **Statement:** Replaced `at the index type \(\mathrm{Fin}\,d\)` with
  `at the rank-\(d\) index set` (`Fin d` is Lean notation).
- Proof: no changes needed (math-only).

### `lem:gr_baseChange_bridge`
- **Statement:** Replaced the passage
  `through \(\Gamma\!\mathrm{SpecIso}\) naturality … the assembly of
  \(\mathrm{theGlueData}\)/\(\mathrm{chartTransition}\) from \(\mathrm{transitionMap}\)`
  with `through the natural identification of global sections of an affine scheme
  with its coordinate ring and the fact that the projections and triple transition
  are the \(\Spec\) morphisms of the coordinate-ring homomorphisms by which the
  Grassmannian glue datum (\cref{def:gr_the_glue_data}) is assembled`.
  (`theGlueData`, `chartTransition`, `transitionMap` are Lean declaration names;
  `ΓSpecIso` is a Lean lemma name.)
- **Statement:** Replaced `\(\mathrm{cocycleΘ}_{IJ}\)` with `\(\Theta_{IJ}\)`
  (pure math notation; cref to `def:gr_cocycle_theta_ij` retained).
- **Statement:** Replaced `\(\mathrm{cocycleΘ}/\mathrm{awayIncl}\) ring homomorphism`
  with `coordinate-ring homomorphism` (Lean slash-shorthand removed).
- **Proof:** Removed `by \(\Gamma\!\mathrm{SpecIso}\) naturality` and replaced
  with a plain mathematical statement of the global-sections identification.
- **Proof:** Replaced `this is exactly how \(\mathrm{chartTransition}\) and
  \(\mathrm{theGlueData}\) are assembled from \(\mathrm{transitionMap}\)` with
  `the precise form in which the chart transitions and glue datum are assembled
  from the transition maps`.
- **Proof:** Replaced `\(\mathrm{cocycleΘ}_{IJ}\)` with `\(\Theta_{IJ}\)`.

### `lem:gr_bundleCocycle_transport`
- **Proof:** Removed `now` from `This is now pure assembly` (project-history word).
- **Proof:** Replaced `\cref{lem:gr_bundleCocycle_matrix} rewrites the argument to`
  with `by the matrix cocycle identity \cref{lem:gr_bundleCocycle_matrix} the
  argument equals` (tactic verb `rewrites` → mathematical assertion).

## Invariants preserved
- All `\lean{}`, `\uses{}`, `\label{}`, and `\leanok`/`\mathlibok` annotations
  are unchanged.
- No blocks outside the four named targets were modified.
- No `% SOURCE` / `% SOURCE QUOTE` lines were added or removed (these are
  Archon-original infra blocks with no external source).
- Mathematical content and cross-reference structure are intact.

## Status
PASS — four blocks are now math-only prose, Lean-leakage free.
