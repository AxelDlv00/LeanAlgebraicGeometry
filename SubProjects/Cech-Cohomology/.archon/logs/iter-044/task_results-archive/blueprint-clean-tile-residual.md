# Blueprint-clean report — tile-residual (iter-044)

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, Sub-lemma B region:
`lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq`, `lem:tile_section_comparison`.

## Changes made

### `lem:tile_section_comparison` (was line 4468, removed)
Removed project-history note:
```
  % NOTE: the \lean{} pin is deferred until the Lean decl is built; sync will reconcile it.
```
This was pure process/iteration phrasing with no mathematical content.

### `lem:tile_section_comparison` (was lines 4480–4481, removed)
Removed Lean-identifier comment:
```
  % NOTE (Lean): Γ_{R_g}(−, F_(g)) is modulesSpecToSheaf.obj (ModuleCat R_g-valued);
  % Γ_R(−, F) the corresponding functor for F over R.
```
This exposed the internal Lean name `modulesSpecToSheaf.obj` inside blueprint prose; the
surrounding mathematical description (`Here Γ_{R_g}(−, F_(g)) is the global-ring section functor…`)
already supplies all the context a reader needs.

## No further action

- `lem:modulesSpecToSheaf_smul_eq` and `lem:modulesRestrictBasicOpen_smul_eq`: already clean — no
  tactic names, no Lean identifiers, no project-history comments.
- Routes (A)/(B) in `lem:tile_section_comparison`: already stated as mathematical strategies
  (Γ–Spec naturality; localization uniqueness), not tactic recipes.
- No `\uses{}`/`\label{}` formatting issues found in the three blocks.
- No `\leanok` markers added or removed.
- No `% SOURCE`/`% SOURCE QUOTE` lines added (these blocks are project-bespoke with no external
  source, as directed).
- All blocks outside the Sub-lemma B region left untouched.

## Status
DONE — two residual comments stripped; region is now pure mathematics.
