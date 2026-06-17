# Blueprint Clean Report — p3b-realign

**Target:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Scope:** Edited/new blocks in §"Presheaf-level Čech machinery" and `lem:injective_cech_acyclic`.

---

## Task 1 — Lean Leakage / Process Language

**Result: Nothing stripped.** A full scan of the edited/new blocks — the subsection preamble (lines 612–635), `def:cech_free_presheaf_complex`, `def:section_cech_complex`, `lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`, `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`, and `lem:injective_cech_acyclic` (statement + proof) — found no Lean-facing phrases ("scaffolder", "not yet built", "to-be-formalized", tactic names, typeclass notes, project-history references). All prose is timeless mathematical text.

The remark "This direct route uses neither enough-injectives in $\mathrm{PMod}(\mathcal{O}_X)$ nor a right-derived $\delta$-functor identification" (appears in both the subsection preamble and the proof of `lem:injective_cech_acyclic`) is a legitimate mathematical contrast with the alternative route; it is not process language.

---

## Task 2 — Source Quote Validation

All five edited/new blocks cross-checked verbatim against `references/stacks-cohomology.tex`.

### `def:cech_free_presheaf_complex`
- **Cited pointer:** `lemma-cech-map-into`, L1142–1162 (with $j_{p!}$ description at L1095–1135).
- **Line range:** Correct. Source label `\label{lemma-cech-map-into}` is at L1138; quoted content "Consider the chain complex $K(\mathcal{U})_\bullet$…is given by $(-1)^j$ times the canonical map." spans L1142–1162.
- **Quote verbatim:** ✓ Exact match.

### `def:section_cech_complex`
- **Cited pointer:** `\S Čech cohomology of presheaves`, L879–910.
- **Line range:** Correct. The formula "Set $\check{\mathcal{C}}^p…$" begins at L879; the differential and "It is straightforward to see that $d \circ d = 0$" conclude at L909–910.
- **Quote verbatim:** ✓ The blueprint uses `...` to elide the non-alternating cochains remark (L887–894), but all quoted fragments match the source exactly. (Minor: the source wraps the differential in `\begin{equation}…\end{equation}` with `\label{equation-d-cech}`; the blueprint quote uses `$$…$$`. This is a display-environment notation choice, not a content difference.)

### `lem:cech_complex_hom_identification`
- **Cited pointer:** `lemma-cech-map-into`, L1163–1196 (statement + proof).
- **Line range:** Correct. Statement "Then there is an isomorphism…" at L1163; proof ends L1195.
- **Quote verbatim:** ✓ "Then there is an isomorphism $\Hom_{\mathcal{O}_X}(K(\mathcal{U})_\bullet, \mathcal{F}) = \check{\mathcal{C}}^\bullet(\mathcal{U}, \mathcal{F})$ functorial in $\mathcal{F} \in \Ob(\textit{PMod}(\mathcal{O}_X))$." — exact match to L1163–1169.

### `lem:cech_free_complex_quasi_iso`
- **Cited pointer:** `lemma-homology-complex`, L1198–1284.
- **Line range:** Correct. Lemma at L1199–1216, proof L1218–1284.
- **Quote (statement):** ✓ "Let $\mathcal{O}_\mathcal{U} \subset \mathcal{O}_X$…" through the case matrix — exact match to L1200–1215.
- **Quote proof:** ✓ The `% SOURCE QUOTE PROOF` block quotes L1219–1227, L1236–1237, and L1253–1283 (with `...` elisions for the $I_1 = \varnothing$ case and the eqnarray computation). All quoted fragments are verbatim. The shorthand "$h(s)_{i_0\ldots i_{p+1}} = (i_0 = i_{\text{fix}}) s_{i_1\ldots i_p}$" matches L1268 exactly.

### `lem:injective_cech_acyclic`
- **Cited pointer:** `lemma-injective-trivial-cech`, L1407–1431.
- **Line range:** Correct. Lemma label at L1408, statement L1409–1421, proof L1424–1431.
- **Quote (statement):** ✓ "Let $X$ be a ringed space…" through the case matrix — exact match to L1409–1421.
- **First `% SOURCE QUOTE PROOF`:** ✓ "An injective $\mathcal{O}_X$-module is also injective as an object in the category $\textit{PMod}(\mathcal{O}_X)$…Hence we can apply Lemma \ref{lemma-cech-cohomology-derived-presheaves} (or its proof) to see the result." — exact match to L1425–1431.
- **Second `% SOURCE QUOTE PROOF`:** ✓ "Let $\mathcal{I}$ be an injective presheaf…$\check{H}^i(\mathcal{U}, \mathcal{I}) = 0$ for all $i > 0$." — sourced from the proof of `lemma-cech-cohomology-derived-presheaves` (L1327–1340); exact match.

---

## Task 3 — `\mathlibok` Anchors

Both new anchors carry **no `% SOURCE` block**, which is correct: the `\lean{}` target is the citation.

- `lem:injective_of_adjoint` (`\lean{CategoryTheory.Injective.injective_of_adjoint}`, `\mathlibok`): no `% SOURCE`. ✓
- `lem:mod_pmod_adjunction` (`\lean{PresheafOfModules.sheafificationAdjunction}`, `\mathlibok`): no `% SOURCE`. ✓

---

## Task 4 — `\uses{}`/`\label{}` Well-formedness and Acyclicity

All labels and uses in the edited/new blocks:

| Block | `\label` | `\uses` | Status |
|---|---|---|---|
| `def:cech_free_presheaf_complex` | `def:cech_free_presheaf_complex` | (none) | ✓ |
| `def:section_cech_complex` | `def:section_cech_complex` | `def:cech_complex` | ✓ |
| `lem:cech_complex_hom_identification` | `lem:cech_complex_hom_identification` | `def:cech_free_presheaf_complex, def:section_cech_complex` | ✓ |
| `lem:cech_free_complex_quasi_iso` | `lem:cech_free_complex_quasi_iso` | `def:cech_free_presheaf_complex` | ✓ |
| `lem:injective_of_adjoint` | `lem:injective_of_adjoint` | (none) | ✓ |
| `lem:mod_pmod_adjunction` | `lem:mod_pmod_adjunction` | (none) | ✓ |
| `lem:injective_cech_acyclic` (statement) | `lem:injective_cech_acyclic` | `def:cech_complex` | ✓ |
| `lem:injective_cech_acyclic` (proof) | — | `def:cech_complex, def:section_cech_complex, lem:cech_complex_hom_identification, lem:cech_free_complex_quasi_iso, lem:injective_of_adjoint, lem:mod_pmod_adjunction` | ✓ |

**Acyclicity:** The dependency graph on these nodes is a DAG with no cycles:
- `def:cech_free_presheaf_complex` ← (nothing in scope)
- `def:section_cech_complex` ← `def:cech_complex` (P3a block, out of scope)
- `lem:cech_complex_hom_identification` ← `def:cech_free_presheaf_complex`, `def:section_cech_complex`
- `lem:cech_free_complex_quasi_iso` ← `def:cech_free_presheaf_complex`
- `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction` ← (leaf nodes)
- `lem:injective_cech_acyclic` ← all of the above

No back-edges. ✓

---

## Summary

No changes were made to the blueprint file. All four tasks completed with no issues found:
- No Lean leakage or process language in the edited/new blocks.
- All five source-quote blocks (`def:cech_free_presheaf_complex`, `def:section_cech_complex`, `lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`, `lem:injective_cech_acyclic`) are verbatim against `references/stacks-cohomology.tex`; line-range pointers are correct.
- Two `\mathlibok` anchors correctly carry no `% SOURCE` block.
- `\uses{}`/`\label{}` graph is acyclic and well-formed.
