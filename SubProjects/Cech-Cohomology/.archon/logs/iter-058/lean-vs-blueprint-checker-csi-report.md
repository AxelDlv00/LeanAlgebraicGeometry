# Lean ↔ Blueprint Check Report

## Slug
csi

## Iteration
058

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (§Sub-brick A / Stub-1 geometric backbone material)

---

## Per-declaration

### 9 new decls from iter-058: classification

#### `\lean{CategoryTheory.widePullback_overX_isLimit}` — no blueprint label
- **Lean target exists**: yes (line 54)
- **Blueprint reference**: none — pure lean_aux helper for `widePullback_overX_eq_prod`
- **Status**: acceptable lean_aux; not a blueprint block. The blueprint cites `lem:widePullbackCone_isLimitOfFan_mathlib` as the Mathlib anchor, but the project builds its own IsLimit fan directly (Mathlib has the terminal-base case, not the slice-base case). This helper fills the gap cleanly.

---

#### `\lean{CategoryTheory.widePullback_overX_eq_prod}` → `lem:widePullback_overX_eq_prod`
- **Lean target exists**: yes (line 81)
- **Signature matches**: yes — blueprint states "wide pullback over S = n-fold product in Over S"; Lean type is `Over.mk (WidePullback.base g) ≅ ∏ᶜ fun k => Over.mk (g k)` ✓
- **Proof follows sketch**: yes — implemented as `widePullback_overX_isLimit` + `productIsProduct`, directly matching the "fan from the legs is a limit of the wide-pullback diagram" sketch in the blueprint.
- **Notes**: Blueprint `% NOTE: build target. The Lean declaration does not exist yet` at line 7567 is **stale** — the declaration now exists and `\leanok` is set. Minor cleanup needed.

---

#### `\lean{CategoryTheory.overSigmaDescCofan}`, `overSigmaDescIsColimit`, `overSigmaDescIso` — abstract helpers, no direct blueprint label
- **Lean target exists**: yes (lines 89–125)
- **Blueprint reference**: blueprint `lem:coverArrow_over_sigma` (line 7835) references only the AlgebraicGeometry-namespace versions (`coverArrowOverCofan`, `coverArrowOverIsColimit`, `coverArrowOverSigmaIso`). The abstract `CategoryTheory.*` versions have no `\lean{...}` entry.
- **Status**: lean_aux abstract generalizations. The file also contains the AlgebraicGeometry-specific versions (lines 294–325) which ARE blueprint-referenced. The two sets are structurally identical modulo instantiation — the abstract versions are functionally unused internally (the AlgebraicGeometry versions are given directly rather than as `overSigmaDescCofan.spec`). Minor redundancy, acceptable.

---

#### `\lean{CategoryTheory.FinitaryPreExtensive.prod_coproduct_distrib}` → `lem:prod_coproduct_distrib`
- **Lean target exists**: yes (line 164)
- **Signature matches**: partial — blueprint states BOTH sides of distributivity:
  - (A) `A ×_S (∐_τ Y_τ) ≅ ∐_τ (A ×_S Y_τ)`
  - (B) `(∐_i X_i) ×_S B ≅ ∐_i (X_i ×_S B)`
  
  Lean provides only direction (A): `(∐ fun i => pullback a (g i)) ≅ pullback a (Limits.Sigma.desc g)`. The docstring title says "One-sided distributivity" — this is a deliberate scoping choice. The inductive proof of `widePullback_coproduct_iso` uses only direction (A), so the Lean is sufficient for the project's needs.
- **Proof follows sketch**: yes — uses `FinitaryPreExtensive.isIso_sigmaDesc_fst` + `pullbackLeftPullbackSndIso` as the blueprint's proof references `isIso_sigmaDesc_map` specialisation.
- **Notes**: Minor divergence — blueprint overstates what Lean provides (both sides vs one). Blueprint `% NOTE: build target` at line 7626 is stale.

---

#### `\lean{CategoryTheory.FinitaryPreExtensive.coproduct_fibrePower_reindex}` → `lem:coproduct_fibrePower_reindex`
- **Lean target exists**: yes (line 186)
- **Signature matches**: yes — blueprint: `∐_i ∐_τ F(cons i τ) ≅ ∐_σ F σ`; Lean: `(∐ fun i : ι => ∐ fun τ : Fin (p+1) → ι => F (Fin.cons i τ)) ≅ ∐ fun σ : Fin (p+2) → ι => F σ` ✓
- **Proof follows sketch**: yes — uses `sigmaSigmaIso ≪≫ Sigma.whiskerEquiv` with the `Fin.consEquiv` reindex, directly matching the blueprint's "sigmaSigmaIso then Fin.cons bijection" description.
- **Notes**: Blueprint `% NOTE: build target` at line 7659 is stale.

---

#### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso_zero}` → `lem:coproduct_distrib_fibrePower_zero`

**ARCHITECTURE DIVERGENCE FLAG — major**

- **Lean target exists**: yes (line 205)
- **Signature matches**: **partial** — TYPE MISMATCH on the σ-component.

  Blueprint statement (line 7602–7608):
  > `(∐_i X_i)^{×_S 1} ≅ ∐_{σ: Fin(1)→ι} X_{σ(0)}`, the σ-component being `X_{σ(0)}`

  Lean type conclusion:
  ```
  Over.mk (WidePullback.base (fun _ : Fin 1 => Limits.Sigma.desc f))
    ≅ ∐ (fun σ : Fin 1 → ι => ∏ᶜ (fun k : Fin 1 => Over.mk (f (σ k))))
  ```
  The Lean σ-component is `∏ᶜ (fun k : Fin 1 => Over.mk (f (σ k)))` — a **1-fold product in Over S** — rather than the blueprint's `X_{σ(0)}` (which at the Lean level would be `Over.mk (f (σ 0))`). These are isomorphic via `productUniqueIso`, but have distinct types.

- **Why**: The Lean docstring (lines 203–204) explicitly documents this as a deliberate choice: "This is the project's chosen (slice-product) normal form for the components, which minimizes the `HasWidePullback` instance bookkeeping in the induction." The same convention will apply to the full `widePullback_coproduct_iso` (not yet in the file).

- **Impact on downstream**: `cechBackbone_left_sigma` (Stub 1, line 368) has the correct final type `∐ fun σ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))` — the architecture divergence is in the intermediate form, not the final assembly.

- **Blueprint action needed**: A bridge note is needed in `lem:coproduct_distrib_fibrePower_zero` and `lem:coproduct_distrib_fibrePower` explaining that the Lean uses the slice-product form `∏ᶜ fun k => Over.mk (f (σ k))` (not the wide-pullback form `Over.mk (WidePullback.base ...)`) as the canonical σ-component, and that `widePullback_overX_eq_prod` bridges between the two at the assembly site.

- **Notes**: Blueprint `% NOTE: build target` at line 7598 is stale.

---

#### `\lean{CategoryTheory.FinitaryPreExtensive.prodFinSuccIso}` — no blueprint label
- **Lean target exists**: yes (line 134)
- **Blueprint reference**: none — lean_aux helper. The Lean docstring describes it as: "Mathlib has no Fin-succ categorical product split. This is the recursion that lets the wide fibre power `∏ᶜ (Fin(p+2) copies)` be peeled into `head ×_S ∏ᶜ (Fin(p+1) copies)` in the slice during the induction of `widePullback_coproduct_iso`."
- **Status**: acceptable lean_aux; serves the inductive step of `widePullback_coproduct_iso` (not yet in file).

---

## Red flags

### Placeholder / suspect bodies

The following 5 declarations carry `:= sorry` bodies; all are honest placeholders for substantive open obligations:

| Decl | Line | Blueprint lemma | Difficulty |
|------|------|-----------------|-----------|
| `cechBackbone_left_sigma` | 372 | `lem:cech_backbone_left_sigma` | HARD (single hardest leaf) |
| `pushPull_sigma_iso` | 422 | `lem:pushPull_sigma_iso` | HARD (new-infra leaf) |
| `pushPull_eval_prod_iso` | 513 | `lem:pushPull_eval_prod_iso` | LOW (blocked on Stub 2) |
| `cechSection_complex_iso` | 583 | `lem:cechSection_complex_iso` | MEDIUM |
| `cechSection_contractible` | 642 | `lem:cechSection_contractible` | MEDIUM |

All five have correct, blueprint-matching types (see Per-declaration sections below). No weakened-wrong or trivially-true placeholders. No excuse-comments on these declarations. **Stubs 5 and 6 specifically: confirmed re-signed to the AUGMENTED form — see dedicated section below.**

### `widePullback_coproduct_iso` — missing from file
- Blueprint `lem:coproduct_distrib_fibrePower` (line 7690) has `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso}` with `% NOTE: build target`. This declaration is **not present** in the Lean file. It is the inductive wrapper that consumes all four of the new helper lemmas. Its absence is expected (iter-058 built only the components; the inductive assembly is presumably iter-059 work).

---

## Stubs 5 and 6: augmented-form confirmation

### Stub 5 — `cechSection_complex_iso` (line 568–583)

Blueprint `% NOTE` (line 7994–7999):
> "The iso is to the AUGMENTED concrete section complex D'_aug := (sectionCechComplex U'·).augment ε hε, NOT to the bare section complex."

Lean conclusion type:
```lean
D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε
```
where `D` is the evaluated augmented Čech complex (built from `cechAugmentedComplex 𝒰 F` via `GV.mapHomologicalComplex`), and `sectionCechComplexV` is the non-augmented concrete complex. ✓

**The signature is correct and matches the blueprint augmented target.** No stale excuse block. The augmentation data `ε` and `hε` are explicit arguments (correct — they are supplied by the consumer `CechAugmentedResolution.lean`).

### Stub 6 — `cechSection_contractible` (line 635–642)

Blueprint `% NOTE` (line 8069–8074):
> "The contractible complex is the AUGMENTED section complex D'_aug = (sectionCechComplex U'·).augment ε hε, NOT the bare section complex D' (which is not contractible: a one-member cover {V} gives H⁰(D') = Γ(V,F) ≠ 0)."

Lean conclusion type:
```lean
Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0
```
✓ **Correct augmented form.** Parameters `i_fix : 𝒰.I₀`, `hiV : V ≤ coverOpen 𝒰 i_fix`, `ε`, `hε` are all explicit — matching the blueprint's stated preconditions.

No stale excuse block. No stale memory-058 `ARCHITECTURE DECISION` comments about the non-augmented form.

---

## Remaining sorry-signature checks

### `cechBackbone_left_sigma` (line 368)
Lean:
```lean
(coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p)) ≅
∐ fun σ : Fin (p + 1) → 𝒰.I₀ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))
```
Blueprint `lem:cech_backbone_left_sigma`: "Yₚ ≅ ∐_{σ: Fin(p+1)→I} U_σ in Over X, structure map Sigma.desc(σ ↦ j_σ)". ✓

### `pushPull_sigma_iso` (line 417)
Lean:
```lean
pushPullObj F ((coverCechNerveOver 𝒰).obj (op [p])) ≅
∏ᶜ fun σ : Fin (p + 1) → 𝒰.I₀ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))
```
Blueprint `lem:pushPull_sigma_iso`: "pushPullObj F Yₚ ≅ ∏_σ pushPullObj F (Over.mk j_σ) in X.Modules". ✓

### `pushPull_eval_prod_iso` (line 504)
Lean:
```lean
((SheafOfModules.forget …).obj (pushPullObj F ((coverCechNerveOver 𝒰).obj (op [p])))).presheaf.obj (op V) ≅
∏ᶜ fun σ : Fin (p+1) → 𝒰.I₀ =>
  ((SheafOfModules.forget …).obj F).presheaf.obj (op (coverInterOpen 𝒰 σ ⊓ V))
```
Blueprint `lem:pushPull_eval_prod_iso`: "Γ(V, pushPullObj F Yₚ) ≅ ∏_σ Γ(coverInterOpen 𝒰 σ ∩ V, F)". ✓ (Lean correctly unpacks to presheaf level.)

---

## Unreferenced declarations (informational)

### Substantive — should consider blueprint coverage
- `CategoryTheory.overSigmaDescCofan` / `overSigmaDescIsColimit` / `overSigmaDescIso` (lines 89–125): abstract analogues of the blueprint-referenced AlgebraicGeometry versions. These could be promoted to blueprint lemmas as they generalize `lem:coverArrow_over_sigma`. Currently redundant with `coverArrowOverCofan/IsColimit/SigmaIso` below.
- `CategoryTheory.FinitaryPreExtensive.prodFinSuccIso` (line 134): the `Fin(n+1)`-product splitting needed for the `widePullback_coproduct_iso` inductive step. Not in blueprint. If `widePullback_coproduct_iso` is formalized next iter, this helper should be promoted to a sub-lemma (`lem:prodFinSuccIso`) so the blueprint accurately describes the induction.

### Pure helpers (acceptable lean_aux)
- `CategoryTheory.widePullback_overX_isLimit` (line 54): direct auxiliary for `widePullback_overX_eq_prod`.
- `AlgebraicGeometry.mem_iInf_opens_of_finite` (line 245): private; finiteness-of-iInf lemma for `widePullback_openImm_inter`.
- `AlgebraicGeometry.sectionCechComplexV` (line 520): `abbrev`, the parameterized concrete section complex. Named and docstring-noted as the base for Stubs 5 and 6. Acceptable.

---

## Blueprint adequacy for this file

- **Coverage**: 8 of 12 Lean declarations have a `\lean{...}` entry in the chapter (6 blueprint-substantive + 2 AlgebraicGeometry-level instantiations `coverArrowOverCofan/IsColimit/SigmaIso`). The 4 uncovered are lean_aux helpers.
- **Proof-sketch depth**: **adequate** for completed declarations; **adequate with one gap** for stubs.
  - `lem:pushPull_leg_sections` sketch (three off-the-shelf steps) directly guided the Lean implementation at lines 455–475. ✓
  - `lem:cechSection_complex_iso` sketch (degreewise + differential match + augmentation node) is detailed. ✓
  - `lem:cechSection_contractible` sketch (dep* engine for p≥1, explicit augmentation-node computation) is the most detailed and accurately anticipates the two-part structure of the homotopy. ✓
  - `lem:cech_backbone_left_sigma` sketch (four-step assembly: unpack → distribute → intersect → identify) is clear. ✓
  - `lem:pushPull_sigma_iso` sketch (comparison map → faithfulness of toPresheaf → presheaf-level disjoint-union decomposition) is clear but defers the hardest step ("iterate the binary decomposition") without naming the exact Lean construction. Adequate for guidance, would benefit from naming `Sigma.desc`-based iteration.
- **Hint precision**: **loose** in one case (see architecture divergence below); **precise** otherwise.
- **Generality**: matches need.

### Recommended chapter-side actions

1. **Bridge note for σ-component normal form** (affects `lem:coproduct_distrib_fibrePower_zero` and prospectively `lem:coproduct_distrib_fibrePower`):
   > The Lean uses the *slice-product* normal form `∏ᶜ fun k => Over.mk (f (σ k))` (product in `Over S`) as the canonical form for σ-components, rather than the wide-pullback form `Over.mk (WidePullback.base ...)` or the informal `X_{σ(0)}`. The two forms are isomorphic via `widePullback_overX_eq_prod`; the conversion is applied at the final assembly site (`cechBackbone_left_sigma`). Update the statements of `lem:coproduct_distrib_fibrePower_zero` and `lem:coproduct_distrib_fibrePower` to reflect the slice-product type, and add a `\uses{lem:widePullback_overX_eq_prod}` note documenting the bridge.

2. **Stale `% NOTE: build target` cleanup** on `lem:widePullback_overX_eq_prod` (line 7567), `lem:coproduct_distrib_fibrePower_zero` (line 7598), `lem:prod_coproduct_distrib` (line 7626), `lem:coproduct_fibrePower_reindex` (line 7659): these say "The Lean declaration does not exist yet" but all four declarations now exist with `\leanok`. Remove or replace these notes.

3. **Add sub-lemma for `prodFinSuccIso`**: when `lem:coproduct_distrib_fibrePower` is formalized, the blueprint's inductive step should reference `prodFinSuccIso` (`Fin(n+1)` product splitting) as an explicit helper, since the induction peels the product at each step.

4. **Coverage for abstract `CategoryTheory` helpers**: consider whether `overSigmaDescCofan/IsColimit/Iso` warrant blueprint blocks (perhaps as a grouped mathlib-supplement lemma), or whether the AlgebraicGeometry-specific versions cover the intent sufficiently.

---

## Severity summary

- **must-fix-this-iter**: none. All sorry bodies are honest, all signatures are well-typed, no excuse-comments, no axioms.
- **major**:
  - `lem:coproduct_distrib_fibrePower_zero` σ-component type mismatch: blueprint states `X_{σ(0)}`, Lean has `∏ᶜ (fun k : Fin 1 => Over.mk (f (σ k)))`. Blueprint needs a bridge note documenting the slice-product normal form. (Lean is correct by architectural choice; blueprint does not accurately describe the Lean type.)
- **minor**:
  - `lem:prod_coproduct_distrib` blueprint over-claims two sides; Lean provides only one (one-sided, which is all the induction needs). Docstring correctly says "one-sided".
  - Stale `% NOTE: build target` comments on four now-existing declarations. Review-agent cleanup.
  - `prodFinSuccIso` and abstract `CategoryTheory` helpers are uncovered lean_aux; should be mentioned when `widePullback_coproduct_iso` is formalized.

**Overall verdict**: The file is mathematically sound and the 9 new declarations are honestly typed; Stubs 5/6 are correctly re-signed to the augmented form with no stale excuse blocks; the one material gap is a blueprint documentation issue — the σ-component normal form divergence in `lem:coproduct_distrib_fibrePower_zero` needs a bridge note before `widePullback_coproduct_iso` (the inductive assembly) is formalized.
