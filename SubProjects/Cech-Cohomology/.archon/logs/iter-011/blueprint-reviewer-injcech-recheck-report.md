# Blueprint Review Report

## Slug
injcech-recheck

## Iteration
011

## Checks executed (directive-scoped fast-path)

1. `lem:injective_cech_acyclic` formalization-readiness (proof `\uses{}` rewired to new sub-lemmas)
2. Source-quote verbatim check for all new blocks against `references/stacks-cohomology.tex`
3. Faithfulness of the two new `\mathlibok` anchors (`IsGrothendieckAbelian.enoughInjectives`, `instIsGrothendieckAbelianModuleCat`)
4. `leandag build --json` — acyclicity + no broken `\uses{}`
5. Non-circularity: no `\uses{}` from `cech_to_cohomology_on_basis` back to `affine_serre_vanishing`
6. `archon blueprint-doctor --json` — rendering integrity

---

## Check results

### 1. `lem:injective_cech_acyclic` — now formalization-ready ✓

The prior iter-011 must-fix was that the proof referenced undeclared presheaf-level sub-lemmas. That placeholder has been replaced with:

- **New `\subsection{Presheaf-level Čech machinery}`** (lines 612–1119 of the chapter) containing 7 new declaration blocks:
  - `def:cech_free_presheaf_complex` — the $K(\mathcal{U})_\bullet$ complex of free presheaves
  - `lem:cech_complex_hom_identification` — $\mathrm{Hom}(K(\mathcal{U})_\bullet, \mathcal{F}) = \check{\mathcal{C}}^\bullet(\mathcal{U}, \mathcal{F})$
  - `lem:cech_free_complex_quasi_iso` — $K(\mathcal{U})_\bullet$ resolves $\mathcal{O}_{\mathcal{U}}[0]$
  - `lem:grothendieck_enough_injectives` — $\mathlibok$ via `CategoryTheory.IsGrothendieckAbelian.enoughInjectives`
  - `lem:module_cat_grothendieck` — $\mathlibok$ via `instIsGrothendieckAbelianModuleCat`
  - `lem:presheaf_modules_enough_injectives` — $\mathrm{PMod}(\mathcal{O}_X)$ has enough injectives (Archon-original proof via Grothendieck engine, not `\mathlibok`)
  - `lem:cech_delta_functor_presheaves` — Čech functors ≅ right-derived of $\check{H}^0$

The `lem:injective_cech_acyclic` statement carries `\uses{def:cech_complex}` and its proof block carries:
```
\uses{def:cech_complex, lem:cech_complex_hom_identification,
      lem:cech_free_complex_quasi_iso, lem:cech_delta_functor_presheaves,
      lem:presheaf_modules_enough_injectives}
```
All five labels are defined in the chapter. The proof text gives a complete, step-by-step derivation following `lemma-injective-trivial-cech` (Stacks) and `lemma-cech-cohomology-derived-presheaves`. **PASS.**

### 2. Source quotes — verbatim against `references/stacks-cohomology.tex` ✓

Checked all new blocks:

| Block | Source pointer | Verbatim check |
|---|---|---|
| `def:cech_free_presheaf_complex` | `lemma-cech-map-into` L1142–1162 | PASS — chain complex display and map description verbatim |
| `lem:cech_complex_hom_identification` statement | `lemma-cech-map-into` L1163–1169 | PASS |
| `lem:cech_complex_hom_identification` proof | `lemma-cech-map-into` proof L1171–1196 | PASS |
| `lem:cech_free_complex_quasi_iso` statement | `lemma-homology-complex` L1198–1216 | PASS |
| `lem:cech_free_complex_quasi_iso` proof | `lemma-homology-complex` proof L1217–1284 | PASS — contracting homotopy rule verbatim |
| `lem:presheaf_modules_enough_injectives` statement | `lemma-cech-cohomology-derived-presheaves` proof opening L1317–1319 | PASS |
| `lem:cech_delta_functor_presheaves` statement quote 1 | `lemma-cech-cohomology-delta-functor-presheaves` statement L1065–1074 | PASS |
| `lem:cech_delta_functor_presheaves` statement quote 2 | `lemma-cech-cohomology-derived-presheaves` statement L1286–1296 | PASS |
| `lem:cech_delta_functor_presheaves` proof | `lemma-cech-cohomology-derived-presheaves` proof L1317–1356 | PASS |
| `lem:injective_cech_acyclic` statement | `lemma-injective-trivial-cech` L1407–1421 | PASS |
| `lem:injective_cech_acyclic` proof source 1 | `lemma-injective-trivial-cech` proof L1422–1431 | PASS |
| `lem:injective_cech_acyclic` proof source 2 | `lemma-cech-cohomology-derived-presheaves` proof L1325–1340 | PASS |

All `(read from references/stacks-cohomology.tex)` parentheticals name a file that exists on disk. All visible `\textit{Source: ...}` lines are present and match their `% SOURCE:` pointers.

### 3. `\mathlibok` anchor faithfulness ✓

**`lem:grothendieck_enough_injectives`** → `\lean{CategoryTheory.IsGrothendieckAbelian.enoughInjectives}`

Verified in `.lake/packages/mathlib/Mathlib/CategoryTheory/Abelian/GrothendieckCategory/EnoughInjectives.lean` line 374:
```lean
instance enoughInjectives : EnoughInjectives C where
```
inside `namespace CategoryTheory.IsGrothendieckAbelian`. Full name matches. The stated form ("every Grothendieck abelian category has enough injectives") matches the instance. **FAITHFUL.**

**`lem:module_cat_grothendieck`** → `\lean{instIsGrothendieckAbelianModuleCat}`

Verified in `.lake/packages/mathlib/Mathlib/Algebra/Category/ModuleCat/AB.lean` line 52:
```lean
instance : IsGrothendieckAbelian.{u} (ModuleCat.{u} R) where
```
The auto-generated Lean 4 name for this anonymous instance is `instIsGrothendieckAbelianModuleCat`. The stated form ("$\mathrm{Mod}_R$ is a Grothendieck abelian category") matches the instance. **FAITHFUL.**

### 4. Dependency-graph integrity (`leandag build --json`) ✓

```
"unknown_uses": []
"conflicts": []
"isolated": 28   (all lean_aux — Lean helpers with no blueprint entry; not blueprint nodes)
```

Zero broken `\uses{}` edges. Zero isolated blueprint nodes. The 28 isolated nodes are all `lean_aux`-type (Lean-side helper declarations with no corresponding blueprint block), which is expected and not a blocking issue. **PASS.**

### 5. Non-circularity ✓

Tracing the `\uses{}` graph:

- `lem:affine_serre_vanishing` `\uses{lem:cech_acyclic_affine, lem:cech_to_cohomology_on_basis}`
- `lem:cech_to_cohomology_on_basis` proof `\uses{lem:injective_cech_acyclic, lem:ses_cech_h1, lem:cech_acyclic_affine}`
  - No reference to `lem:affine_serre_vanishing`. The proof text says explicitly: "The argument never uses affine sheaf-cohomology vanishing (Lemma~\ref{lem:affine_serre_vanishing})..."

The graph along the P3b bridge is acyclic:
```
cech_acyclic_affine
  ↓
lem:injective_cech_acyclic  ←  presheaf-level sub-chain (def:cech_free_presheaf_complex → 
lem:ses_cech_h1                lem:cech_complex_hom_identification →
                                lem:cech_free_complex_quasi_iso →
                                lem:cech_delta_functor_presheaves →
                                lem:presheaf_modules_enough_injectives)
  ↓
lem:cech_to_cohomology_on_basis
  ↓
lem:affine_serre_vanishing
```
No cycles. **PASS.**

### 6. `archon blueprint-doctor --json` ✓

Output:
```json
{
  "orphan_chapters": [],
  "broken_refs": [],
  "malformed_refs": [],
  "axiom_decls": [],
  "covers_problems": []
}
```
Zero rendering findings. **PASS.**

---

## Per-chapter

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:injective_cech_acyclic`: previously flagged must-fix resolved — proof now references the new presheaf-level sub-lemmas via explicit `\uses{}` with complete proof details. ✓
  - New `\subsection{Presheaf-level Čech machinery}` adds 7 well-cited declarations with verbatim source quotes from `stacks-cohomology.tex`. ✓
  - Both `\mathlibok` anchors (`lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck`) verified faithful against Mathlib source. ✓
  - `lem:presheaf_modules_enough_injectives` correctly NOT `\mathlibok`; it is a real project obligation routed through the Grothendieck engine with an Archon-original proof. ✓
  - Non-circularity confirmed: `cech_to_cohomology_on_basis` → `affine_serre_vanishing` is one-directional. ✓

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**Overall verdict**: The iter-011 must-fix on `Cohomology_CechHigherDirectImage.tex` is fully resolved; `lem:injective_cech_acyclic` now has a complete, sourced proof referencing 5 newly declared presheaf-level sub-lemmas, both `\mathlibok` anchors are Mathlib-faithful, all source quotes are verbatim, the dependency graph is acyclic with no broken `\uses{}`, and non-circularity is preserved — HARD GATE clears for `CechHigherDirectImage.lean`.
