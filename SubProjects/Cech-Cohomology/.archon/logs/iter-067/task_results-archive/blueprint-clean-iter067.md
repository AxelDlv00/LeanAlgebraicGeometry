# Blueprint-clean report — iter067

## Scope covered

Regions edited this iteration in
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:
- New helper blocks: `lem:mapHC_augment_iso`, `lem:map_augment_cond`, `lem:augmentCochainIso`
- New coreIso chain: `lem:coverInterOpen_inf_distrib`, `lem:coreIso_obj_iso`, `lem:coreIso_comm`
- Expanded proof body of `lem:cechSection_complex_iso`

## Lean leakage found and stripped

Four instances of Lean-syntax leakage were removed:

| Location | Original | Replacement |
|---|---|---|
| `lem:mapHC_augment_iso` proof (was line 8649) | `Build the isomorphism with \(\operatorname{isoOfComponents}\), taking every component to be the identity` | `Define the isomorphism by taking every degreewise component to be the identity` |
| `lem:map_augment_cond` proof (was line 8671) | `by functoriality of \(\Phi\) on composites and \(\Phi.\!\operatorname{map\_zero}\)` | `by functoriality of \(\Phi\) on composites and its preservation of zero` |
| `lem:augmentCochainIso` proof (was lines 8690, 8695) | `Build the isomorphism with \(\operatorname{isoOfComponents}\): ...` + `the naturality square \(\varphi.\!\operatorname{comm}(n, n+1)\) of \(\varphi\)` | `Define the isomorphism degreewise: ...` + `the commutativity condition of \(\varphi\) at degree \(n\)` |
| `lem:cechSection_complex_iso` proof (was line 8889) | `It is built as \(\operatorname{isoOfComponents}\) from its degreewise object isos` | `It is assembled componentwise from its degreewise object isos` |

The two `\!\operatorname{...}` dot-notation instances (`Phi.map_zero` and `φ.comm`) were
the clearest violations — Lean accessor syntax in prose. The three
`Build ... with \(\operatorname{isoOfComponents}\)` uses were replaced because they read as
tactic instructions rather than mathematical statements.

**Retained** (appropriate use):
- Line 8775: `\(\mathrm{coreIso} := \operatorname{isoOfComponents}(\mathrm{objIso},\,\cdot)\)` —
  definitional notation naming a specific mathematical object; kept in `\operatorname{}`.
- All `\operatorname{sectionCechProductEquiv}` and `\operatorname{sectionCechFaceRestr}` usages —
  pre-existing named constructions throughout the file; unchanged.

## Project-history / verbosity

None found in the edited regions. The new lemmas and the expanded proof are written in
timeless mathematical style; no iteration-narrative references detected.

## `\ref` / `\uses` reference audit

All cross-references in the edited regions resolve:

| Referenced label | Defined at |
|---|---|
| `lem:map_augment_cond` | line 8658 |
| `lem:pushPull_eval_prod_iso` | line 8602 |
| `lem:coverInterOpen_inf_distrib` | line 8699 (new, in scope) |
| `def:cech_free_presheaf_complex` | line 1382 |
| `lem:section_cech_product_equiv` | line 800 |
| `lem:section_cech_objd_apply` | line 859 |
| `lem:coreIso_obj_iso` | line 8722 (new, in scope) |
| `lem:coreIso_comm` | line 8760 (new, in scope) |
| `lem:mapHC_augment_iso` | line 8629 (new, in scope) |
| `lem:map_augment_cond` | line 8657 (new, in scope) |
| `lem:augmentCochainIso` | line 8673 (new, in scope) |
| `def:cech_augmented_complex` | line 7119 |
| `def:cech_augmentation` | line 7083 |
| `lem:cech_augmentation_comp_d` | line 7096 |
| `lem:pushPull_leg_sections` | line 8565 |
| `lem:evaluation_preserves_products_mathlib` | line 9062 |
| `lem:cechSection_complex_iso` | line 8812 (forward ref in `lem:coreIso_comm` proof note — valid) |

No broken references. The forward reference from `lem:coreIso_comm`'s proof to
`lem:cechSection_complex_iso` is a prose pointer (not a `\uses` dependency) and resolves
correctly.

## Protected markers

No `\leanok` or `\mathlibok` markers were touched. No `% NOTE:` annotations were altered.
`lem:cechSection_contractible` was not touched.

## Outcome

**PASS.** Five targeted edits applied; no mathematical content altered. The edited regions
are now Lean-leakage-free and all cross-references are confirmed to resolve.
