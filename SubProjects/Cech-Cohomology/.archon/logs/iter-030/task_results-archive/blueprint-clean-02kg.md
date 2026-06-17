# Blueprint-clean 02KG report (iter-030)

Chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Lean leakage stripped

### `lem:hom_into_injective_exact` — statement body
- Removed `\operatorname{preadditiveYoneda}.\mathrm{obj}\,I` from the functor description; replaced with `\operatorname{Hom}(-, I)`.
- Removed parenthetical Lean declaration names `(preadditiveYoneda_obj_preservesFiniteColimits_of_injective)` and `(quasiIso_map_preadditiveYoneda_of_injective)`.

### `lem:hom_into_injective_exact` — proof body
- The proof body was entirely Lean declaration names (`Injective.injective_iff_preservesEpimorphisms_preadditiveYoneda_obj`, `Functor.preservesFiniteColimits_iff_forall_exact_map_and_epi`, `PreservesHomology`, `Functor.preservesHomologyOfExact`, `quasiIsoAt_map_of_preservesHomology`). Replaced with mathematical prose: "For injective $I$, injectivity gives that $\operatorname{Hom}(-,I)$ carries epimorphisms to epimorphisms. Combined with the automatic preservation of finite limits (left exactness), the short-exact-sequence criterion shows it preserves finite colimits; hence, being also left exact, it preserves homology. A functor that preserves homology sends quasi-isomorphisms of chain complexes to quasi-isomorphisms degreewise, which is the second statement."

### `lem:injective_cech_acyclic` — statement body (last paragraph)
- "The formalized positive-degree clause" → "The positive-degree vanishing".
- `U : \iota \to \mathrm{Opens}(X)` (Lean type annotation) → `\{U_i\}_{i \in \iota}` (mathematical notation).
- `\{i : x \in U_i\}` (Lean set-builder) → `\{i \mid x \in U_i\}`.
- "discharges its `injective_acyclic` field directly" → "establishes the injective acyclicity condition for the affine cover system".
- "a covering only fixes the identity ... never the exactness. Consequently the lemma applies verbatim to the standard covering data of the affine cover system and discharges its field directly, without any restriction to coverings of the whole space." → cleaned to avoid "verbatim" and "discharges its field".

### `lem:injective_cech_acyclic` proof — "Categorical assembly" paragraph
Lean-specific function names replaced:
- `\operatorname{cechFreeComplexAug}\mathcal{U}` → "the free Čech augmentation"
- `\operatorname{HomologicalComplex.op}` machinery → "forming its opposite complex"
- `\operatorname{preadditiveYoneda}.\mathrm{obj}\,\mathcal{I}` → `\operatorname{Hom}(-,\mathcal{I})`
- `(\operatorname{quasiIso\_map\_preadditiveYoneda\_of\_injective}, Lemma~\ref{...})` → `Lemma~\ref{...}`
- `\operatorname{homCechComplexMapOpIso}` (Lemma ref) → "the opposite-transport isomorphisms (Lemma~\ref{lem:cech_complex_op_identification} and Lemma~\ref{lem:section_cech_complex_mapop_iso})"
- `\operatorname{sectionCechComplexMapOpIso}` → folded into the above reference

---

## Project-history / changelog `% NOTE` comments trimmed

### `lem:cover_datum_bridge`
Removed: "RESOLVED (open-level identity). The earlier design fork … is gone: … so it discharges that field directly with no bridge. What survives here is only …. It is no longer on the discharge path."  
Replaced with a concise two-line pointer: what the lemma provides and which lemma discharges the injective acyclicity condition.

### `lem:affine_injective_acyclic`
Removed: "RESOLVED (demoted to a special case). The earlier ⊤-vs-D(f) scope fork is closed: … The decl … is a valid special case but is NO LONGER required to discharge the field."  
Replaced with a concise pointer: this covers the whole-affine case; the general field is discharged by the family-form lemma.

### `def:affine_cover_system`
Removed: "the ⊤-vs-D(f) design fork is RESOLVED. The injective_acyclic field is discharged DIRECTLY … The single remaining build blocker is the surj_of_vanishing geometry … NOT the injective field."  
Replaced with a two-line field-discharge summary (no RESOLVED/fork language).

### `lem:qcoh_iso_tilde_sections`
Removed: heavy Lean type-annotation syntax (`(F : (Spec R).Modules) [IsIso F.fromTildeΓ] : F ≅ tilde (Γ F)`, `inv F.fromTildeΓ`, `F.fromTildeΓ` as rendered simp-accessor text).  
Replaced with: concise English description of the conditional form and a pointer to the presentation-driven discharge and decomposition remark.

---

## Source quote verification

### `lem:qcoh_iso_tilde_sections_of_presentation` — Statement quote
Claimed source: `references/stacks-schemes.tex` L1279–1285 (`lemma-quasi-coherent-affine`).  
Blueprint quote (lines 3609–3613):
> "Let $(X, \mathcal{O}_X) = (\Spec(R), \mathcal{O}_{\Spec(R)})$ be an affine scheme. Let $\mathcal{F}$ be a quasi-coherent $\mathcal{O}_X$-module. Then $\mathcal{F}$ is isomorphic to the sheaf associated to the $R$-module $\Gamma(X, \mathcal{F})$."

`stacks-schemes.tex` L1280–1284 reads verbatim the same text.  
**VERIFIED ✓**

### `rem:o1i8_decomposition` — Proof quote
Claimed source: `references/stacks-schemes.tex` L1287–1387 (`lemma-quasi-coherent-affine` proof).  
Blueprint fragments (with ellipses for omitted intermediate text):

| Blueprint fragment | File location | Status |
|---|---|---|
| "Let $\mathcal{F}$ be a quasi-coherent $\mathcal{O}_X$-module. Since every standard open $D(f)$ is quasi-compact we see that $X$ is locally quasi-compact …" | L1288–1290 | ✓ verbatim |
| "Hence by Modules, Lemma \ref{modules-lemma-quasi-coherent-module} for every prime $\mathfrak p \subset R$ corresponding to $x \in X$ there exists an open neighbourhood $x \in U \subset X$ such that $\mathcal{F}|_U$ is isomorphic to the quasi-coherent sheaf associated to some $\mathcal{O}_X(U)$-module $M$." | L1293–1297 | ✓ verbatim |
| "Now Algebra, Lemma \ref{algebra-lemma-glue-modules} shows that there exist an $R$-module $M$ such that $M_i = M_{f_i}$ compatible with the morphisms $\psi_{ij}$." | L1355–1357 | ✓ verbatim |
| "By construction this map reduces to the isomorphisms $\varphi_i^{-1}$ on each $D(f_i)$ and hence is an isomorphism." | L1385–1386 | ✓ verbatim |

**VERIFIED ✓**

### `lem:affine_surj_of_vanishing` — Statement quote
Claimed source: `references/stacks-cohomology.tex` L1592–1605 (`lemma-ses-cech-h1`).  
Blueprint quote (lines 3315–3325) matches `stacks-cohomology.tex` L1594–1604 verbatim.  
**VERIFIED ✓**

### Existing Stacks quotes (affine/injective-acyclic blocks)
The `affine_injective_acyclic` and `injective_cech_acyclic` SOURCE QUOTE blocks (from `stacks-cohomology.tex`) were not modified by the writer and remained intact; they were not re-verified in this pass (they passed the prior iter-025/028 clean pass).

---

## Unchanged by policy

- No `\leanok` markers added or removed.
- No `\lean{}` pins or `\uses{}` edges changed.
- No `\mathlibok` anchors moved.
- LaTeX syntax errors: none found in the edited blocks.
- Structure-field names (`\mathrm{faces\_mem}`, `\mathrm{surj\_of\_vanishing}`, `\mathrm{injective\_acyclic}`) in the rendered definition and lemma statement bodies were left as-is: they are the mathematical names of the three proof obligations of `def:basis_cov_system` and are appropriate for a formalization-facing blueprint.
