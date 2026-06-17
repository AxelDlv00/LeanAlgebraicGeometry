# Blueprint-clean report — iter-020

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Scope
Post-write purity pass over the newly added/edited blocks:
- 6-link quasi-iso chain (`lem:quasiIso_of_evaluation`, `lem:cech_free_eval_sectionwise`,
  `lem:cech_free_eval_empty`, `lem:cech_free_eval_prepend_homotopy`,
  `lem:cech_free_eval_prepend_homotopy_spec`, `lem:cech_free_eval_nonempty`,
  `lem:cech_free_complex_quasi_iso`)
- Two new D• blocks (`def:section_cech_module_complex`, `lem:section_cech_module_exact`)

---

## Changes made

### 1. `lem:cech_free_eval_prepend_homotopy` — statement (line ~1477)
**Removed** project-internal file reference `in \texttt{CechAcyclic.lean}` from:
> "the combinatorial content of `CombinatorialCech.combHomotopy` in `CechAcyclic.lean` (the prepend-…)"

→ becomes:
> "the combinatorial content of `CombinatorialCech.combHomotopy` (the prepend-…)"

### 2. `lem:cech_free_eval_prepend_homotopy_spec` — proof (line ~1532)
**Removed** project-internal file reference `in \texttt{CechAcyclic.lean}` from:
> "the same alternating-sum cancellation as `CombinatorialCech.combHomotopy_spec` in `CechAcyclic.lean` (…)"

→ becomes:
> "the same alternating-sum cancellation as `CombinatorialCech.combHomotopy_spec` (…)"

### 3. `lem:cech_free_complex_quasi_iso` — proof (lines ~1684–1691)
**Removed** project-internal file reference and Lean implementation-strategy sentence:

Before:
> "The contracting homotopy is built … the same combinatorial content as `CombinatorialCech.combHomotopy` / `combHomotopy_spec` in `CechAcyclic.lean` used for the affine vanishing … — and is *not* routed through `SimplicialObject.Augmented.ExtraDegeneracy`, which is the documented fallback only (the prepend map is a section-level homotopy after evaluation, not an augmented-simplicial extra degeneracy)."

After:
> "The contracting homotopy is built … the same combinatorial content as `CombinatorialCech.combHomotopy` / `combHomotopy_spec` used for the affine vanishing Lemma~\ref{lem:cech_acyclic_affine}."

The `ExtraDegeneracy` non-route sentence was pure Lean implementation strategy ("documented fallback only") with no mathematical content and was removed.

### 4. `def:section_cech_module_complex` (line ~736)
**Changed** Lean visibility modifier "private" to the neutral term "auxiliary":
> `the private \(\mathtt{spanIdx}\)` → `the auxiliary \(\mathtt{spanIdx}\)`

---

## Source-quote audit

All six sub-lemmas of the quasi-iso chain verified to have correct `% SOURCE` and `% SOURCE QUOTE` annotations:

| Block | % SOURCE | % SOURCE QUOTE | % SOURCE QUOTE PROOF | Notes |
|-------|----------|----------------|----------------------|-------|
| `lem:quasiIso_of_evaluation` | ✓ | ✓ | — | Statement only; proof is proof block |
| `lem:cech_free_eval_sectionwise` | ✓ | ✓ | — | OK |
| `lem:cech_free_eval_empty` | ✓ | ✓ | — | OK |
| `lem:cech_free_eval_prepend_homotopy` | ✓ | ✓ | — | OK |
| `lem:cech_free_eval_prepend_homotopy_spec` | ✓ | — | ✓ | Statement not separately stated in Stacks; proof quote is sufficient (the statement *is* the computation) |
| `lem:cech_free_eval_nonempty` | ✓ | ✓ | — | OK |
| `lem:cech_free_complex_quasi_iso` | ✓ | ✓ | ✓ (outside block) | OK |

All quotes were verified verbatim against `references/stacks-cohomology.tex` L1198–1285.

### D• blocks — no `% SOURCE` needed
- `def:section_cech_module_complex`: organisational construction, not a statement from a reference. Source is indirectly attributed via `\uses{def:standard_affine_cover, def:qcoh_sections_localized}`, where `def:qcoh_sections_localized` already cites Tag 01HV. No `% SOURCE` gap.
- `lem:section_cech_module_exact`: consequence of the combinatorial exactness already captured in `lem:cech_acyclic_affine`. Not a standalone Stacks statement. No `% SOURCE` gap.

---

## No-touch confirmation
- `\leanok` markers: untouched.
- Math statements, `\lean{}` lists, `\uses{}` wiring: untouched.
- All other blocks (not in scope of this iter): untouched.

## Status
**CLEAN** — no missing source quotes, no fabricated quotes, four targeted Lean-leakage / project-history removals applied.
