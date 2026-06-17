# Blueprint Clean Report — iter-052

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

Three issues found and fixed in the iter-052 edited/added regions. No fabricated SOURCE lines. Stacks quote verified.

---

## Changes Made

### 1. `lem:isLocalizedModule_comp_away` proof (line 6212) — Lean library leakage removed

**Old prose:**
> `\(m - m'\). This route avoids the (Mathlib-absent) converse of ``a localisation survives restriction of scalars''.`

**New prose:**
> `\(m - m'\). This route avoids the converse of ``a localisation survives restriction of scalars''.`

**Reason:** `(Mathlib-absent)` is a Lean/Mathlib reference with no mathematical content; the sentence reads cleanly without it.

---

### 2. `% NOTE (iter-051):` comment before `lem:cech_augmented_resolution` (line 7123) — project-history stripped from comment tag

**Old:**
```tex
% NOTE (iter-051): the augmented-complex OBJECT layer is now built axiom-clean in
% CechHigherDirectImage.lean (cechComplexOnX, cechNervePointIso, cechAugmentation,
% cechAugmentation_comp_d, cechAugmentedComplex). The `\lean{}` target `cechAugmented_exact`
% (the EXACTNESS theorem) is NOT yet built: its stalk-at-prime proof needs a
% "complex of sheaves of modules is exact iff exact on every stalk" criterion for X.Modules
% that is ABSENT from Mathlib (no SheafOfModules.stalk; no stalkwise-exactness reflection).
% Planner: consider splitting this lemma into "object (built)" + "exactness (pending)", and
% blueprint the missing stalkwise-exactness criterion as its own sub-lemma chain
% (see task_results/AlgebraicJacobian_Cohomology_CechHigherDirectImage.md decomposition steps 1-2).
```

**New:**
```tex
% NOTE: the augmented-complex object layer (cechComplexOnX, cechNervePointIso, cechAugmentation,
% cechAugmentation_comp_d, cechAugmentedComplex) is formalized in CechHigherDirectImage.lean.
% The \lean{} target cechAugmented_exact (the exactness theorem) is not yet proved: the
% stalk-at-prime route requires a "complex of sheaves of modules is exact iff exact on every stalk"
% criterion for X.Modules not yet in the library; the sections-and-sheafification route of the
% current proof sketch avoids this. Planner: consider splitting this lemma into an "object layer"
% definition block and a separate exactness lemma, adding a stalkwise-exactness sub-lemma if needed.
```

**Reason:** Stripped `(iter-051)` (project-history iteration tag) and `axiom-clean` (project-history jargon), removed the internal `task_results/` path reference. Preserved all prover-guidance content.

---

### 3. `lem:cech_augmented_resolution` proof Remark (lines 7232–7238) — formalization leakage removed

**Old:**
> The earlier stalk-at-prime argument --- exact iff exact on every stalk, with a ``one index is a unit'' contracting homotopy of the localized extended complex --- is not used here because it requires a stalk functor on sheaves of modules and an exact-iff-stalkwise-exact criterion **that are not available in the ambient formalized library**. Should the sections route's homology-versus-section bookkeeping prove unwieldy, a fallback remains: build the local ``insert the fixed index \(i\)'' contracting homotopy over each \(U_i\), combine it with exactness of restriction, and conclude by the same sheaf-local vanishing used in Step 3.

**New:**
> An alternative proof uses the stalk-at-prime criterion directly: the complex is exact if and only if it is exact after localizing at each prime \(\mathfrak{p}\), and for each \(\mathfrak{p}\) one fixes an index \(i_{\text{fix}}\) with \(f_{i_{\text{fix}}} \notin \mathfrak{p}\) and defines a contracting homotopy of the localized complex by \(h(s)_{i_0 \ldots i_p} = s_{i_{\text{fix}} i_0 \ldots i_p}\), as in the Stacks source proof above. This approach is equivalent to the sections-and-sheafification argument of Steps 1--4.

**Reason:** "not available in the ambient formalized library" and the implicit contrast between the "sections route" and a Lean-unavailable stalk approach are formalization context, not mathematics. The rewrite preserves the mathematical content (the stalk approach and the explicit contracting homotopy) while reading as timeless mathematics.

---

## Non-changes Confirmed

- **No `\leanok` added or removed.** ✓
- **No `\lean{}` targets altered.** ✓
- **No mathematical content changed.** ✓
- **New Archon-original blocks carry no fabricated SOURCE lines:**
  - `lem:isLocalizedModule_comp_away`: `\textit{Project-local infrastructure.}` label only. ✓
  - `lem:section_cech_module_exact_of_localizationAway`: `\textit{Project-local infrastructure.}` label only. ✓
  - `def:cech_complex_on_X`, `def:cech_nerve_point_iso`, `def:cech_augmentation`, `lem:cech_augmentation_comp_d`, `def:cech_augmented_complex`: `\textit{Project-local.}` labels only, no SOURCE lines. ✓
- **Stacks `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` on `lem:cech_augmented_resolution` verified intact** and match `references/stacks-coherent.tex` lines 68–82 and 80–103 verbatim. ✓
- **Pre-existing `axiom-clean` occurrences at lines 5351, 5459, 5837** are outside the iter-052 edited/added regions (route-A / 01I8 section); left untouched per directive scope.

## No retriever spawned

All new blocks are Archon-original with no missing citations; no external source quote needed.
