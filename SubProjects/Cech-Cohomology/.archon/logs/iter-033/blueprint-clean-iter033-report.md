# Blueprint-clean report — iter033

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

Standard purity pass completed. Two project-history NOTE blocks stripped. All `\uses{}` references
for the new lemmas verified. SOURCE quotes for `lem:standard_cover_cofinal` verified verbatim
against local reference files.

---

## Edits made

### 1. Stripped `% NOTE (iter-032):` from `lem:to_sheaf_preserves_epi`

**Location:** immediately after `\uses{lem:toSheaf_preservesFiniteColimits, ...}`, before
`\textit{Project-bespoke gap-fill (instance).}`

**Reason:** The 7-line comment block contained:
- Explicit iteration reference `(iter-032)` — project-history verbosity.
- Lean backtick-quoted identifiers: `` `(SheafOfModules.toSheaf R).PreservesFiniteColimits` ``,
  `` `PreservesFiniteLimits` ``, `` `forget` ``.
- Internal Mathlib file path: `Mathlib.Algebra.Category.ModuleCat.Sheaf.Limits:118`.
- Internal analogy file reference: `analogies/tosheaf-epi.md`.

The mathematical content of the note (why `toSheaf` is not a left adjoint; the correct
finite-colimit route) is fully captured by the new lemma bodies themselves
(`lem:toSheaf_preservesFiniteColimits` and its proof).

### 2. Stripped `% NOTE (decomposed iter-032):` from `lem:qcoh_localized_sections`

**Location:** after `\uses{lem:exists_finite_basicOpen_subcover, ...}`, before `% SOURCE:`.

**Reason:** The 8-line comment block contained:
- Explicit iteration references `iter-032` and `iter-031` — project-history verbosity.
- Internal decomposition labels `(P1a)`, `(P1b)` with "DONE iter-032, axiom-clean" status notes.
- Lean-specific type names: `(Spec R_{f_j}).Modules`, `IsQuasicoherent F`,
  `SheafOfModules-restriction-to-basic-open`.

The structural information (which sub-lemmas discharge which sub-goals) is already encoded
in the `\uses{}` list; the iteration-status notes have no mathematical content.

---

## Citation verification

### `lem:standard_cover_cofinal` SOURCE QUOTES

Both quotes verified verbatim against local reference files:

| Quote | Reference file | Lines | Status |
|---|---|---|---|
| "Any open covering of $D(f)$ can be refined to a finite open covering…" | `references/stacks-schemes.tex` | L531–532 | ✓ verbatim |
| "Moreover, we showed in Sheaves, Lemma … it suffices to check on the finite coverings by standard opens." | `references/stacks-schemes.tex` | L571–577 | ✓ verbatim |
| "Let $X$ be a topological space. Let $\mathcal{B}$ be a basis … restricts to $s_i$ on $U_i$." | `references/stacks-sheaves.tex` | L3861–3879 | ✓ verbatim |

### New Mathlib anchors (no SOURCE QUOTE needed)

- `lem:sheafificationCompToSheaf_mathlib` (`\mathlibok`): no external source required ✓
- `lem:preservesEpi_of_preservesColimitsOfShape_mathlib` (`\mathlibok`): no external source required ✓

### Project-bespoke lemmas (no SOURCE QUOTE needed per directive)

- `lem:toSheaf_preservesFiniteColimits`: correctly has no `% SOURCE` ✓
- `lem:to_sheaf_preserves_epi`: correctly has no `% SOURCE` ✓

---

## `\uses{}` resolution for new lemmas

| Lemma | `\uses{}` entries | All labels resolve? |
|---|---|---|
| `lem:sheafificationCompToSheaf_mathlib` | (none) | ✓ |
| `lem:preservesEpi_of_preservesColimitsOfShape_mathlib` | (none) | ✓ |
| `lem:toSheaf_preservesFiniteColimits` | `lem:sheafificationCompToSheaf_mathlib` | ✓ (L3476) |
| `lem:to_sheaf_preserves_epi` | `lem:toSheaf_preservesFiniteColimits`, `lem:preservesEpi_of_preservesColimitsOfShape_mathlib` | ✓ (L3508, L3496) |

---

## Duplicate `\label` check

No genuine duplicate labels. The string `\label{equation-extended}` appears twice, but both
occurrences are inside `%`-comment SOURCE QUOTEs (lines 128, 5151 in the pre-edit file)
— these are not active LaTeX labels.

---

## Items NOT changed (out of scope for this pass)

Several other `% NOTE` comments in the chapter contain Lean declaration names but no iteration
references and no project-history verbosity. They are TeX comments (not rendered prose) and were
not introduced by the tosheaf slug writer this iter; they are deferred to a future broad purity pass:

- L925: proof-sketch note with `operatorname{qcohRestriction_eq_comparison}` reference
- L1182: Lean target name note for `lem:cech_acyclic_affine`
- L1833: FreeCechEngine copy rationale (implementation architecture)
- L2256/2320: transport-derived lemma explanations
- L2676: degree-0 vs degree-\(p\) scope note on `injective_cech_acyclic`
- L3736: conditional-form status note on `qcoh_iso_tilde_sections`
- L3985/4236: Mathlib-gap notes on restriction and tilde functor

These do not affect the mathematical correctness or readability of the rendered blueprint.
