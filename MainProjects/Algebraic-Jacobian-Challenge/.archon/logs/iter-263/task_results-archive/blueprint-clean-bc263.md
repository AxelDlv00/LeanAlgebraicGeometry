# blueprint-clean bc263 — Report

**Status:** PASS — four purity issues found and fixed across the two files.

---

## File 1: `Picard_TensorObjSubstrate.tex` — `lem:slice_dual_transport` block

### Issues found and fixed

**Issue A — Redundant Lean lemma name in parenthetical after `\lean{}` tag (leg-B paragraph).**
The line
```
\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}
(\(\mathtt{restrictScalars\_isIso\_}\varepsilon\mathtt{\_of\_bijective}\)), so
```
had a bare Lean lemma name `restrictScalars_isIso_ε_of_bijective` in a `\mathtt{}`-parenthetical directly after the `\lean{}` hint that already attributed the lemma. The parenthetical was removed; the `\lean{}` tag remains.

**Issue B — Inline Lean definition name before `\lean{}` tag (leg-B paragraph).**
The line
```
the dual-of-unit isomorphism \(\mathtt{dualUnitIsoGen}\)\lean{PresheafOfModules.dualUnitIsoGen}.
```
used `\mathtt{dualUnitIsoGen}` in rendered prose — a Lean definition name — immediately before the `\lean{}` tag that already carries it. Replaced with a mathematical description: "the dual-of-unit isomorphism for the unit section\lean{...}".

**Issue C — Lean name leakage in lead-in paragraph of "Inverse, linearity, and naturality".**
Three Lean identifiers were used in rendered prose via `\mathtt{}`:
- `\mathtt{internalHomObjModule}` — a Lean definition name. Replaced with "the \(\mathcal{O}_Y(V)\)-module structure on the internal-hom object".
- `\mathtt{Over.mk}\,(\mathrm{id}_{fV})` — a Lean constructor call. Replaced with "the terminal object \(\mathrm{id}_{fV}\) of the slice over \(fV\)".
- `\mathtt{PresheafOfModules.Hom}` — a Lean type name. Replaced with "morphisms of presheaves of modules".

**Issue D — Lean proof-obligation names in the new enumerate item (i).**
The new enumerate item (i) used:
- `\mathtt{map\_add}` and `\mathtt{map\_smul}` (Lean lemma obligation names) → replaced with "additivity and scalar-compatibility obligations".
- `\mathtt{internalHomObjModule}` (again) → replaced with "internal-hom module structure".
- `\mathtt{PresheafOfModules.Hom}` → replaced with "presheaf morphism-level operations".

### What was left unchanged
- All `\lean{}` tags, `\leanok` markers, `\cref{}` cross-references.
- The rest of the large chapter (outside `lem:slice_dual_transport` proof block) was not touched.
- Mathematical content unchanged.

---

## File 2: `Cohomology_CechHigherDirectImage.tex` — edited regions

### Issues found and fixed

**Issue E — Lean names `pushforwardComp`/`pullbackComp` in push-pull functor paragraph (`sec:cech_three_part`).**
The paragraph originally closed with:
```
the comparison isomorphisms \(\mathrm{pushforwardComp}\), \(\mathrm{pullbackComp}\) and the unit-transport
identities of that development)
```
These are Lean identifier names for the composition comparison isomorphisms. The preceding sentence already used the mathematical notation `(p \circ q)_* \cong p_* q_*` and `(p \circ q)^* \cong q^* p^*`. The parenthetical was rewritten to backreference those: "these same comparison isomorphisms, together with the unit-transport identities of that development".

### Items verified clean (no changes needed)
- `def:cech_nerve` — cosimplicial variance paragraph uses only standard mathematical terminology.
- `sec:cech_three_part` backbone paragraph (1) — purely mathematical, no Lean leakage.
- `sec:cech_three_part` plumbing paragraph (3) — purely mathematical.
- Absent-Mathlib notes on `lem:cech_acyclic_affine`, `lem:cech_computes_cohomology`, `lem:cech_flat_base_change` — all describe absent Mathlib infrastructure in mathematical terms only.
- No `\leanok`/`\mathlibok` markers were added or removed.
- All `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks are intact (verified by grep: 20 such blocks present in Cohomology file).
- No project-history phrasing ("iter-NNN", etc.) found in edited regions.
