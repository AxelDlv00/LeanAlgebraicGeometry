# Lean Audit Report

## Slug
iter027

## Iteration
027

## Scope
- files audited: 2 (directive-scoped to the two modified files + helpers read for context)
- files skipped: all other project `.lean` files — directive explicitly named only the two
  modified files; helpers (`PresheafCech.lean`, `FreePresheafComplex.lean`, `CechBridge.lean`)
  were read for context but not formally audited (no per-file checklist required by the directive)

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor — erw in a local proof)
- **excuse-comments**: 0 flagged
- **notes**:
  - **Line 25–26 (`hasExtModules`)** — `local instance hasExtModules : HasExt.{u+1,u,u+1} X.Modules := HasExt.standard _`. The comment justifies this as a performance shortcut ("avoid the slow `HasSmallLocalizedHom` typeclass search"). Since the whole file is axiom-clean, this introduces no new axioms; the instance is genuinely non-vacuous (`HasExt.standard` constructs a real Ext from the injective-resolution machinery). No issue.
  - **Line 40–48 (`sheafificationHomAddEquiv.map_add'`)** — proof uses `erw [Functor.map_add, Preadditive.comp_add]`. The `erw` is needed because the goal's composition is not syntactically at the right universe/functor layer for `rw`. Correct but slightly fragile; a future Mathlib refactor could allow `rw`. **Minor** bad practice.
  - **Line 67–71 (`absoluteCohomologyZeroAddEquiv`)** — `AddEquiv.mk'` with an `Ext.homEquiv₀.symm.injective` additivity proof. The pattern is: reduce `a + b` goal to `Ext.homEquiv₀.symm.injective` via the simp lemmas `Ext.mk₀_add` and `Ext.mk₀_homEquiv₀_apply`. Non-vacuous; the three-simp chain corresponds to genuine additive naturality of `Ext.homEquiv₀`.
  - **Line 77–78 (`absoluteCohomology_eq_zero_of_injective`)** — thin wrapper around `Ext.eq_zero_of_injective`. The naming and type signature are consistent with Mathlib's convention (injective second argument). No issue.
  - **Lines 83–107 (three `absoluteCohomology_covariant_exact*`)** — all are one-liner wrappers around the corresponding Mathlib `Ext.covariant_sequence_exact*`. The hypotheses are fully general (real `ShortExact` input); none are weakened or vacuous. The comments accurately describe what each wrapper does.
  - **Line 116–118 (`homEquiv₀_comp_mk₀`)** — proof by `conv_lhs`/`rw`/`rw`/`Equiv.apply_symm_apply`. Genuine: it first massages the LHS into `Ext.homEquiv₀ (Ext.mk₀ _ ∘ Ext.mk₀ g)` via `mk₀_comp_mk₀`, then applies the symm-apply round-trip. Non-trivial and correct.
  - **Lines 127–130 (`freeYonedaHomEquiv_naturality`)** — proof by `rw [freeYonedaHomEquiv_apply, freeYonedaHomEquiv_apply, PresheafOfModules.comp_app, ModuleCat.comp_apply]`. Straightforward unfolding of the generator formula; non-trivial because `freeYonedaHomEquiv_apply` expresses the equiv as evaluation on the free generator, making naturality concrete.
  - **Lines 137–141 (`sheafificationHomAddEquiv_naturality`)** — one-liner delegating to `Adjunction.homEquiv_naturality_right`. The proof is definitionally correct: `sheafificationHomAddEquiv` is the adjunction hom-equiv packaged as an `AddEquiv`, and naturality in the right argument is exactly `homEquiv_naturality_right`.
  - **Lines 147–154 (`jShriekOU_homEquiv_naturality`)** — assembles the two preceding private lemmas. The `change` unpacks `jShriekOU_homEquiv = freeYonedaHomEquiv ∘ sheafificationHomAddEquiv` definitionally; then the two rewrites and `rfl` close it. Genuine.
  - **Lines 162–169 (`absoluteCohomologyZeroAddEquiv_naturality`)** — the focus-area claim. The statement asserts that `absoluteCohomologyZeroAddEquiv U F₂ (e.comp (Ext.mk₀ g) _) = g_U (absoluteCohomologyZeroAddEquiv U F₁ e)`, i.e. the `H⁰ ≅ Γ` isomorphism intertwines composition-with-`Ext.mk₀ g` on the left with the sections map `g_U` on the right. This is a **real commuting-square statement**, not a tautology: LHS is `jShriekOU_homEquiv ∘ Ext.homEquiv₀` applied after composing with `Ext.mk₀ g`; RHS is the sections map applied after `jShriekOU_homEquiv ∘ Ext.homEquiv₀`. The proof uses `change` + `homEquiv₀_comp_mk₀` + `jShriekOU_homEquiv_naturality` + `rfl`; both rewrites discharge real non-trivial steps, and `rfl` closes the resulting defeq residual. **Not vacuous.**
  - **Line 160 (comment)** — "In particular, when `g_U` is surjective so is `H⁰(U, g)` — the transfer used by the surjectivity step of `lem:absolute_cohomology_one_vanishing`." This is a forward reference to a blueprint entry not yet formalized. It is aspirational documentation, not a stale comment (it references a future step, not a removed one). **Minor** — could mislead a reader into thinking the referenced lemma already exists.

---

### AlgebraicJacobian/Cohomology/CechToCohomology.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor — silent reliance on an AB4* instance for Mono)
- **excuse-comments**: 0 flagged
- **notes**:

  **Functoriality infrastructure (`sectionCechCosimplicialMap`, `sectionCechCosimplicialFunctor`, `sectionCechComplexFunctor`, `sectionCechComplexMap`):**
  - All four are non-vacuous constructions. The `naturality` proofs in `sectionCechCosimplicialMap` use `Pi.hom_ext` + `simp` + a `congr` on the naturality square of `(toPresheaf _).map φ` — correct. The functor coherence proofs (`map_id`, `map_comp`) use `NatTrans.ext` + `funext` + `show`-blocks to expose the `Pi.map` goal, then `Pi.map_id` / `Pi.map_comp_map.symm`. Genuine.

  **`cechCohomology` (line 95–97):**
  - Thin definitional wrapper; accurate docstring ("thin wrapper so the 01EO chain can refer to `Ȟ^p` uniformly"). No issues.

  **`pi_π_map_apply` (line 101–104):**
  - Private lemma; proved by `rw [← ConcreteCategory.comp_apply, Pi.map_π, ConcreteCategory.comp_apply]`. Genuine.

  **`shortExact_piMap` (lines 110–152) — primary focus area:**
  - **Zero term in the ShortComplex constructor (inline `by`):** Proved by `Pi.map_comp_map` + pointwise `zero` + `Pi.map` of zero = 0 via `ext`+`simp`. Genuine.
  - **Epi half (lines 118–127):** The comment says "Epi of the product map: surjectivity, chosen componentwise." `hepi` is **not** by `inferInstance` — it is manually proved via `AddCommGrpCat.epi_iff_surjective`, constructing a preimage using `Concrete.productEquiv.symm` applied to componentwise `choose` witnesses from each `(h σ).ab_surjective_g`. The correctness check uses `Concrete.productEquiv.injective` + `pi_π_map_apply` + `Concrete.productEquiv_symm_apply_π`. **Fully genuine; the epi is really discharged.**
  - **Mono half (line 128):** `haveI hmono : Mono (Pi.map (fun j => (S j).f)) := inferInstance`. This relies on the previously set `haveI : ∀ j, Mono (S j).f := fun j => (h j).mono_f` in scope and on Mathlib having an instance that `Pi.map` of a family of monomorphisms is a monomorphism in an AB4* category (Ab). Since the file compiles, this instance exists. The use of `inferInstance` here is legitimate but **minor** bad practice: it invisibly depends on a non-trivial instance being derivable; naming the instance explicitly or using a helper lemma (e.g. `Pi.map_mono`) would be clearer. No correctness concern.
  - **`Function.Exact` proof (lines 131–152):** Both directions are genuine:
    - Forward: componentwise extraction via `pi_π_map_apply` → per-component `ab_exact_iff_function_exact` → assemble preimage via `Concrete.productEquiv.symm`. Correct.
    - Backward: `← ConcreteCategory.comp_apply` + `Pi.map_comp_map` + rewrite `f ≫ g = 0` + `Pi.map` of zero. Correct.
  - Overall: the proof is **genuine, not vacuous**.

  **`faceShortComplex` (lines 159–165):**
  - Definition of the per-face section short complex. The zero-morphism proof uses `← NatTrans.comp_app`, `← Functor.map_comp`, `P.zero`, `Functor.map_zero`; all are honest rewrites. Definition is correct.

  **`sectionCechComplexShortComplex` (lines 170–184):**
  - Zero-morphism proof uses `HomologicalComplex.hom_ext` degreewise, then `show` to expose the `Pi.map f ≫ Pi.map g = 0` goal, then `Pi.map_comp_map` + pointwise `zero`. Genuine.

  **`cechComplex_shortExact_of_basis` (lines 192–198) — primary focus area:**
  - Hypothesis `hface : ∀ (p : ℕ) (σ : Fin (p + 1) → ι), (faceShortComplex U P σ).ShortExact` is honest: `faceShortComplex U P σ` is the genuine section short complex over `⨅ₖ U(σ k)`, not a hidden `True` or triviality. The proof applies `HomologicalComplex.shortExact_of_degreewise_shortExact` and then `shortExact_piMap`. The degreewise short complex at degree `i` is definitionally `ShortComplex.mk (Pi.map (fun σ => faceShortComplex U P σ .f)) (Pi.map …) …`, matching what `shortExact_piMap` produces. No spurious defeq gaps. **Honest.**

  **`cechHomology_quotient_vanishing` (lines 209–217):**
  - `hrel : (ComplexShape.up ℕ).Rel p (p + 1) := rfl` — correct: `Rel p (p+1) ↔ p+1 = p+1` holds by `rfl`. The `δIso` application gives `T.X₃.homology p ≅ T.X₁.homology (p+1)` from vanishing of `T.X₂.homology p` and `T.X₂.homology (p+1)` via the connecting isomorphism in the LES. Then `(hF (p+1) _).of_iso hiso` transfers zero-ness across the isomorphism. Proof is a genuine application of the homology LES; **not vacuous**.

  **`quotient_cech_vanishing_of_basis` (lines 224–230) — primary focus area:**
  - One-liner wrapper around `cechHomology_quotient_vanishing` instantiated at `sectionCechComplexShortComplex U P`. The defeq claim `cechCohomology U P.X₂ p = (sectionCechComplexShortComplex U P).X₂.homology p` holds definitionally: `cechCohomology U P.X₂ p = (sectionCechComplex U P.X₂).homology p` and `(sectionCechComplexShortComplex U P).X₂ = sectionCechComplex U P.X₂` (middle term of the short complex of chain maps). Similarly for `X₁` and `X₃`. **Defeq claims are genuine.**
  - Hypotheses `hI` and `hF` are non-trivial input conditions (they require positive-degree vanishing for the middle and left terms of the short exact sequence respectively). **Hypotheses are honest.**

---

## Must-fix-this-iter

*None.* Both files are axiom-clean and no definition is suspect, weakened, or carries an excuse-comment.

---

## Major

*None.*

---

## Minor

- `AbsoluteCohomology.lean:47` — `erw [Functor.map_add, Preadditive.comp_add]` in `sheafificationHomAddEquiv.map_add'`. Correct, but `erw` indicates a universe/defeq mismatch that a future Mathlib improvement might fix cleanly. Not blocking.
- `AbsoluteCohomology.lean:160` — Forward reference in the docstring of `absoluteCohomologyZeroAddEquiv_naturality` to `lem:absolute_cohomology_one_vanishing`, which is not yet formalized. Aspirational, not stale, but could mislead a reader into assuming that lemma exists. Consider marking with a `-- blueprint: planned` annotation or removing until the target exists.
- `CechToCohomology.lean:128` — `haveI hmono : Mono (Limits.Pi.map (fun j => (S j).f)) := inferInstance` silently synthesizes the `Mono` from the `haveI : ∀ j, Mono (S j).f` instance in scope. Correct (Ab is AB4*), but explicit use of a named lemma like `inferInstance` with a comment would improve readability and future-proofing.

---

## Excuse-comments (always called out separately)

*None found in either file.*

---

## Focus area verdict

| Focus area | Verdict |
|---|---|
| `shortExact_piMap` — Epi half | **Genuine**. Epi is manually proved via `AddCommGrpCat.epi_iff_surjective` + componentwise `Concrete.productEquiv`; not by `inferInstance`. |
| `shortExact_piMap` — overall | **Genuine**. Both directions of `Function.Exact` are non-vacuous. The Mono uses `inferInstance` (legitimate, minor). |
| `cechComplex_shortExact_of_basis` — hypothesis honesty | **Honest**. `hface` asserts genuine section short-exactness; `faceShortComplex` is a real construction. |
| `quotient_cech_vanishing_of_basis` — defeq claims | **Genuine**. `cechCohomology U P.Xₖ p` = `(sectionCechComplexShortComplex U P).Xₖ.homology p` is definitionally true. |
| `absoluteCohomologyZeroAddEquiv_naturality` — real commutativity | **Genuine, not a tautology**. LHS ≠ RHS before the two rewrites; `rfl` only closes a definitional residual after non-trivial equational reasoning. |
| Stale comments | **None found** in either file. Section headers are accurate. The forward reference at line 160 is aspirational but not factually wrong. |

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are clean, genuine, and axiom-free beyond the standard `{propext, Classical.choice, Quot.sound}`; all focus-area claims confirmed non-vacuous. Three minor code-quality observations, none blocking.
