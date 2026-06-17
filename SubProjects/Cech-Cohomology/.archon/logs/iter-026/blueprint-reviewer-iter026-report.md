# Blueprint Reviewer Report — iter-026

**Date**: 2026-06-07  
**Scope**: Whole-blueprint audit (all chapters under `blueprint/src/chapters/`);
HARD GATE question for dispatching a prover to scaffold `AbsoluteCohomology.lean`.

---

## 1. Tooling diagnostics

### leandag

```
leandag build --json
```

- `unknown_uses: []`   — no broken `\uses{}` edges anywhere in the blueprint
- `isolated: 0`         — no isolated blueprint nodes
- `blueprint_nodes: 82` — full DAG has 82 nodes

### blueprint-doctor

- `malformed_refs: []` — no broken `\ref`, `\uses`, or `\proves` references
- `covers_problems: 1` — `Cohomology_CechHigherDirectImage.tex` lists `AbsoluteCohomology.lean`
  as a covered file but that file does not yet exist on disk.  
  **Status: expected** — this is the new file to be scaffolded this iteration. Not a blocker.

---

## 2. Per-chapter audit

### 2.1 `Cohomology_HigherDirectImage.tex`

| Check | Result |
|-------|--------|
| Completeness | ✓ — single definition `def:higher_direct_image` with `\leanok` |
| Correctness | ✓ — describes `R^i f_*` as sheafification of `V ↦ H^i(f⁻¹V, F\|_{f⁻¹V})`, correct |
| Lean target | ✓ — `\lean{AlgebraicGeometry.higherDirectImage}` well-formed |
| `\uses{}` | ✓ — no `\uses{}` needed (base definition), clean |
| Source quote | ✓ — Stacks cite correct |
| Overall | **complete: true · correct: true** |

### 2.2 `Cohomology_AcyclicResolution.tex`

| Check | Result |
|-------|--------|
| Completeness | ✓ — horseshoe lemma + acyclic resolution theorem fully blueprinted; all blocks have `\leanok` |
| Correctness | ✓ — dimension-shift + cosyzygy route is standard; proof details adequate for Lean |
| Lean targets | ✓ — all `\lean{}` names match axiom-clean declarations |
| `\uses{}` | ✓ — no `unknown_uses` reported |
| Overall | **complete: true · correct: true** |

### 2.3 `Cohomology_CechHigherDirectImage.tex`  ← HARD GATE chapter

This is a consolidated `% archon:covers` chapter covering 7 Lean files:
`CechHigherDirectImage.lean`, `CechAcyclic.lean`, `PresheafCech.lean`,
`FreePresheafComplex.lean`, `CechBridge.lean`, `HigherDirectImagePresheaf.lean`,
`AbsoluteCohomology.lean`.

Full section-by-section review below; absolute-cohomology section is the iter-026 focus.

#### Previously-stable sections (CechAcyclic, FreePresheafComplex, CechBridge,
#### HigherDirectImagePresheaf coverage)

All unchanged from iter-025 review. Still `\leanok` throughout; no regressions detected.
No `\uses{}` repairs needed (leandag `unknown_uses: []` confirms this globally).

---

## 3. Form-B absolute-cohomology section audit

### 3.1 `def:jshriek_ou`

```latex
\lean{AlgebraicGeometry.jShriekOU}
\uses{def:cech_free_presheaf_complex, lem:mod_pmod_adjunction,
      lem:cech_complex_hom_identification}
```

**Statement**: `jShriekOU U := sheafification(free(yoneda U)) ∈ X.Modules`

**`\uses{}` validity**:

| Label | Present in chapter? |
|-------|---------------------|
| `def:cech_free_presheaf_complex` | ✓ — defined in FreePresheafComplex section |
| `lem:mod_pmod_adjunction` | ✓ — sheafification adjunction, present |
| `lem:cech_complex_hom_identification` | ✓ — CechBridge, axiom-clean |

**Formalizability**: One-liner. `freeYoneda U` is the degree-0 generator of
`cechFreePresheafComplex`, already axiom-clean. Apply `sheafificationFunctor`.
No ambiguity in the definition. ✓

**Finding**: well-formed, no issues.

---

### 3.2 `lem:jshriek_corepr`

```latex
\lean{AlgebraicGeometry.jShriekOU_homEquiv}
\uses{def:jshriek_ou, lem:mod_pmod_adjunction, lem:cech_complex_hom_identification}
```

**Statement**: `Hom_{X.Modules}(jShriekOU U, F) ≅ F(U)`, natural (additive) in `F`.

**Proof path in blueprint**: `sheafificationAdjunction.homEquiv` (gives
`Hom(sheaf(P), F) ≅ Hom_Psh(P, F.toPresheaf)`) composed with `freeYonedaHomAddEquiv`
(gives `Hom_Psh(free(yoneda U), P) ≅ P(U)`). Both ingredients are axiom-clean in the
project; the composition is a one-liner in Lean.

**Additivity**: the composition of two `AddEquiv`s is additive. ✓

**`\uses{}` validity**: labels match 3.1 above; all present. ✓

**Finding**: well-formed, proof sketch adequate. ✓

---

### 3.3 `def:absolute_cohomology`

```latex
\lean{AlgebraicGeometry.absoluteCohomology}
\uses{def:jshriek_ou, lem:jshriek_corepr,
      lem:ext_bifunctor_mathlib, lem:ext_covariant_les_mathlib,
      lem:ext_eq_zero_of_injective_mathlib, lem:ext_homequiv_zero_mathlib,
      lem:hasext_standard_mathlib}
```

**Three-clause structure check** (Mathlib Ext API correctness):

#### Clause 1 — H⁰ = Γ via `Ext.homEquiv₀`

```
H⁰(U, F) := Ext⁰(jShriekOU U, F) ≅ Hom(jShriekOU U, F) ≅ F(U)
```

Mathlib: `CategoryTheory.Abelian.Ext.homEquiv₀ : Ext X Y 0 ≃ (X ⟶ Y)` (confirmed live).
Post-composition with `lem:jshriek_corepr` gives `Ext⁰(jShriekOU U, F) ≅ F(U)`. ✓

#### Clause 2 — Injective vanishing

```
I injective ⟹ H^p(U, I) = Ext^p(jShriekOU U, I) = 0 for p ≥ 1
```

Mathlib: `CategoryTheory.Abelian.Ext.eq_zero_of_injective` lives in
`Mathlib.Algebra.Homology.DerivedCategory.Ext.EnoughInjectives` with signature:
```
{X I : C} {n : ℕ} [Injective I] (hn : n ≠ 0) : Ext X I n = 0
```
(confirmed from Mathlib source). The injective `I` is the **second** argument. The
blueprint correctly places `I` as 2nd Ext arg, consistent with `Ext^p(jShriekOU U, I)`.
Form-A language (restriction, `I|_U`) absent from this clause. ✓

#### Clause 3 — Covariant LES

```
0 → F' → F → F'' → 0 short exact ⟹
... → H^p(U,F') → H^p(U,F) → H^p(U,F'') → H^{p+1}(U,F') → ...
```

Mathlib: `covariant_sequence_exact₁/₂/₃` with signatures (confirmed from Mathlib source
`ExactSequences.lean:140–158`):
```
covariant_sequence_exact₂ {n : ℕ} (x₂ : Ext X S.X₂ n)
    (hx₂ : x₂.comp (mk₀ S.g) (add_zero n) = 0) :
    ∃ (x₁ : Ext X S.X₁ n), x₁.comp (mk₀ S.f) (add_zero n) = x₂
```
The fixed first argument is `X` (= `jShriekOU U`); the SES is `0 → F' → F → F'' → 0` in
the second slot. This is exactly the covariant Ext LES at fixed first argument. ✓

**`\uses{}` validity**: all 7 labels present in chapter. ✓

**Finding**: three-clause structure reads off the Mathlib Ext API correctly. ✓

---

### 3.4 Five Ext `\mathlibok` anchors — declaration audit

All checked against Mathlib source in this review session.

| Blueprint anchor | `\lean{}` name(s) | Source file | Status |
|-----------------|-------------------|-------------|--------|
| `lem:ext_bifunctor_mathlib` | `CategoryTheory.Abelian.Ext` | `Ext/Basic.lean` | ✓ confirmed (live #check) |
| `lem:hasext_standard_mathlib` | `CategoryTheory.HasExt.standard` | `Ext/Basic.lean` | ✓ confirmed (live #check) |
| `lem:ext_homequiv_zero_mathlib` | `Ext.homEquiv₀`, `Ext.addEquiv₀` | `Ext/Basic.lean` | ✓ confirmed (live #check, types shown) |
| `lem:ext_eq_zero_of_injective_mathlib` | `Ext.eq_zero_of_injective` | `Ext/EnoughInjectives.lean:99` | ✓ confirmed (Mathlib source grep) |
| `lem:ext_covariant_les_mathlib` | `covariantSequence_exact`, `covariant_sequence_exact₁/₂/₃` | `Ext/ExactSequences.lean:131–155` | ✓ confirmed (Mathlib source grep) |

All five anchors carry `\mathlibok` in the blueprint (no Archon proof obligation). ✓

**Note on `#check` timeouts**: `eq_zero_of_injective` and `covariantSequence_exact*`
produced `HasSmallLocalizedHom` typeclass-synthesis timeouts in `lean_run_code` (#check
with abstract `C`). This is a known Mathlib derived-category elaboration issue — the
timeout is on TC synthesis with an open universe variable, NOT a missing-declaration
error. All names were independently confirmed via direct Mathlib source grep. The prover
should apply `letI := HasDerivedCategory.standard C` (same pattern as seen in
`covariant_sequence_exact₁'` proof at ExactSequences.lean:108) to discharge `HasExt`.

---

### 3.5 `lem:cech_to_cohomology_on_basis` (01EO proof) — Form-B self-consistency

**Lean target**: `\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}`

**`\uses{}`**: `def:cech_complex`, `lem:injective_cech_acyclic`, `lem:ses_cech_h1`,
`lem:cech_acyclic_affine`, `def:absolute_cohomology`, `lem:jshriek_corepr`,
`lem:ext_covariant_les_mathlib`, `lem:ext_eq_zero_of_injective_mathlib`,
`lem:ext_homequiv_zero_mathlib` — all labels present in chapter. ✓

**Form-B self-consistency check** (no leftover Form-A language):

The proof narrative was audited for residual Form-A references (`O_U`, `F|_U`,
`restrictFunctor`, `restrictToOpen`, "restriction taken"):

- Injective vanishing step: states `Ext^p(jShriekOU U_σ, I) = 0` with `I` as 2nd arg. ✓
- H⁰=Γ step: uses `Ext.homEquiv₀ ∘ jShriekOU_homEquiv`. ✓
- LES invocation: cites `covariant_sequence_exact*` at fixed `jShriekOU U_σ`. ✓
- No `O_{U_σ}`, `F|_{U_σ}`, or restriction language in the realization clauses. ✓

**Finding**: 01EO proof is self-consistent under Form B. ✓

---

## 4. HARD GATE verdict

**Chapter**: `Cohomology_CechHigherDirectImage.tex`  
**Gate target**: scaffold `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`

```
complete: true
correct:  true
```

**HARD GATE: CLEARS.**

The prover is cleared to scaffold `AbsoluteCohomology.lean` with targets:
- `AlgebraicGeometry.jShriekOU` — `def`; one-liner via `sheafificationFunctor ∘ freeYoneda`
- `AlgebraicGeometry.jShriekOU_homEquiv` — `AddEquiv`; composition of
  `sheafificationAdjunction.homEquiv` and `freeYonedaHomAddEquiv`
- `AlgebraicGeometry.absoluteCohomology` — `def` `H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)`
  with `letI := HasExt.standard X.Modules`
- H⁰=Γ iso wrapper (uses `Ext.homEquiv₀` + `jShriekOU_homEquiv`)
- Injective vanishing wrapper (uses `Ext.eq_zero_of_injective`; `I` is 2nd arg)
- Covariant LES wrappers (uses `covariant_sequence_exact₁/₂/₃` at fixed `jShriekOU U`)

**Prover note**: elaborate `HasExt` via `letI := HasExt.standard X.Modules` early
(type class search for `HasSmallLocalizedHom` times out without this hint).

**Must-fix-this-iter findings**: none.

**Expected cover warning**: `blueprint-doctor` reports `AbsoluteCohomology.lean` missing
from disk. This will resolve once the prover creates the file.

---

## 5. Unstarted-phase blueprint proposals

**None.**

All project phases have adequate blueprint coverage:

- **P3b** (ACTIVE): `def:jshriek_ou`, `lem:jshriek_corepr`, `def:absolute_cohomology`,
  `lem:cech_to_cohomology_on_basis` (01EO) all blueprinted. Remaining targets are in-progress.
- **P5a** (ACTIVE): `lem:open_immersion_pushforward_comp`,
  `lem:cech_term_pushforward_acyclic` blueprinted. Vanishing engine axiom-clean.
- **P5b** (BLOCKED): `lem:cech_computes_cohomology` (the goal theorem) blueprinted with
  full dependency graph. No coverage gap.

No phase has zero or near-zero blueprint coverage that would justify a new section proposal.
