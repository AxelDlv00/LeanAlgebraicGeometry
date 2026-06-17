# Blueprint Clean Report — injcech

**Target:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Iteration:** 011

## Summary

Three edits applied; source-quote audit passed; dependency order verified acyclic.

---

## Task 1 — Lean leakage / project-history phrasing

**Three instances found and fixed:**

### 1a. `lem:presheaf_modules_enough_injectives` proof (lines ~915–919)

**Removed:**
```
The sole project-side obligation is therefore the
\(\mathrm{IsGrothendieckAbelian}\) instance for the presheaf-of-modules category;
once it is in place, enough injectives follows formally. (This instance is not yet
available off the shelf and is the core to be constructed; the two Mathlib results
cited above supply the surrounding engine.)
```
**Replaced with:**
```
Hence \(\mathrm{PMod}(\mathcal{O}_X)\) is Grothendieck abelian, and
therefore has enough injectives by Lemma~\ref{lem:grothendieck_enough_injectives}.
```
This rewrites the process/prover framing ("project-side obligation", "not yet available", "to be constructed") as a plain mathematical conclusion.

### 1b. `lem:injective_cech_acyclic` statement

**Removed** the Lean-facing parenthetical `(in the project, a scheme with its \(\mathcal{O}_X\)-modules \(X.\mathrm{Modules}\))` from the statement body. The statement now reads as timeless: "Let \(X\) be a ringed space, let \(\mathcal{U} : U = \bigcup_{i \in I} U_i\) be any open covering…"

### 1c. `lem:cech_to_cohomology_on_basis` statement

**Replaced** `"it is what the formalisation returns"` with `"it is all the statement establishes"` — removing the prover/process connotation of "formalisation returns".

---

## Task 2 — Source-quote audit

All five new derived blocks audited against `references/stacks-cohomology.tex`. Results:

| Block | Cited lines | Verdict |
|-------|-------------|---------|
| `def:cech_free_presheaf_complex` | L1142–1162 | ✓ verbatim match |
| `lem:cech_complex_hom_identification` | L1163–1196 | ✓ verbatim match (statement + proof) |
| `lem:cech_free_complex_quasi_iso` | L1198–1284 | ✓ verbatim match (statement + proof with ellipsis compression) |
| `lem:presheaf_modules_enough_injectives` | L1317–1319 | ✓ verbatim match |
| `lem:cech_delta_functor_presheaves` | L1065–1074 and L1286–1356 | ✓ verbatim match (two quotes) |

The two `\mathlibok` anchors (`lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck`) carry no source block, which is correct per the directive.

---

## Task 3 — `\uses{}`/`\label{}` formatting and acyclicity

All `\label{}` and `\uses{}` entries in the new subsection are well-formed. Dependency order within the subsection (as declared):

```
def:cech_free_presheaf_complex
  ↓ used by lem:cech_complex_hom_identification
  ↓ used by lem:cech_free_complex_quasi_iso

lem:grothendieck_enough_injectives  }
lem:module_cat_grothendieck         } → lem:presheaf_modules_enough_injectives

lem:cech_complex_hom_identification   }
lem:cech_free_complex_quasi_iso       } → lem:cech_delta_functor_presheaves
lem:presheaf_modules_enough_injectives}

lem:cech_delta_functor_presheaves → lem:injective_cech_acyclic (proof \uses{})
```

No cycles detected. ✓

The statement-level `\uses{def:cech_complex}` on `lem:injective_cech_acyclic` is appropriate (the statement mentions the Čech complex); the additional proof-level dependencies appear in the proof `\uses{}`. ✓

---

## Tasks 4 and 5 — Preservation constraints

- `\leanok` markers: **not touched**.
- `\mathlibok` markers on `lem:grothendieck_enough_injectives` and `lem:module_cat_grothendieck`: **preserved**.
- No mathematics altered.
- No blocks outside the new subsection and the two edited blocks (`lem:injective_cech_acyclic`, `lem:cech_to_cohomology_on_basis`) were touched.

---

## Files modified

- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — three targeted edits (see above).
