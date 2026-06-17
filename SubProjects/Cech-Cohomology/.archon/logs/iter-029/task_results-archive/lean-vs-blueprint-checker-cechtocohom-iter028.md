# Lean ↔ Blueprint Check Report

## Slug
cechtocohom-iter028

## Iteration
028

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechToCohomology.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (sections covered: `def:section_cech_functoriality`, `def:cech_cohomology_accessor`,
  `def:face_short_complex`, `def:section_cech_short_complex`, `def:basis_cov_system`,
  `def:has_vanishing_higher_cech`, `lem:short_exact_pi_map`, `lem:cech_ses_of_basis`,
  `lem:face_ses_of_sheaf_ses`, `lem:cech_homology_quotient_vanishing`,
  `lem:quotient_vanishing_cech`, `lem:absolute_cohomology_one_vanishing`,
  `lem:absolute_cohomology_pos_vanishing`, `lem:cech_to_cohomology_on_basis`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.sectionCechCosimplicialMap}` (chapter: `def:section_cech_functoriality`)
- **Lean target exists**: yes (line 34)
- **Signature matches**: yes — coordinatewise `Pi.map` over `(PresheafOfModules.toPresheaf).map φ` applied at each intersection open; matches blueprint's "acts on sections over each V_σ coordinatewise"
- **Proof follows sketch**: N/A (chapter has no proof body for this definition; Lean gives the explicit `naturality` dispatch)
- **notes**: none

### `\lean{AlgebraicGeometry.sectionCechCosimplicialFunctor}` (chapter: `def:section_cech_functoriality`)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `X.PresheafOfModules ⥤ CosimplicialObject Ab.{u}`; matches blueprint description
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.sectionCechComplexFunctor}` (chapter: `def:section_cech_functoriality`)
- **Lean target exists**: yes (line 85)
- **Signature matches**: yes — defined as `sectionCechCosimplicialFunctor U ⋙ alternatingCofaceMapComplex`; matches "composing with the alternating-coface-map complex functor"
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.sectionCechComplexMap}` (chapter: `def:section_cech_functoriality`)
- **Lean target exists**: yes (line 91)
- **Signature matches**: yes — `sectionCechComplex U F ⟶ sectionCechComplex U G`; matches "the induced chain map"
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.cechCohomology}` (chapter: `def:cech_cohomology_accessor`)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — `(sectionCechComplex U F).homology p`; matches blueprint's `H^p(𝒰,F) = H^p(Č(𝒰,F))` taken in `Ab`
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.pi_π_map_apply}` (chapter: `lem:short_exact_pi_map`)
- **Lean target exists**: yes (line 105), but declared **`private`**
- **Signature matches**: yes (mathematically correct — Pi.π g σ (Pi.map φ x) = φ σ (Pi.π f σ x))
- **Proof follows sketch**: N/A (utility lemma, no blueprint proof body)
- **notes**: The `\lean{}` pin names it `AlgebraicGeometry.pi_π_map_apply`, but the Lean declaration is `private`, so its actual resolved name is a private mangled identifier. The `\lean{}` pin cannot be verified by `lean_verify` under that name. **See minor flag below.**

### `\lean{AlgebraicGeometry.shortExact_piMap}` (chapter: `lem:short_exact_pi_map`)
- **Lean target exists**: yes (line 114)
- **Signature matches**: yes — `(S : J → ShortComplex Ab) → (∀ j, (S j).ShortExact) → (ShortComplex.mk (Pi.map f) (Pi.map g) ...).ShortExact`; matches blueprint's "product of short exact sequences is short exact"
- **Proof follows sketch**: yes — blueprint says: mono automatic; middle-exactness componentwise preimage; epi by coordinatewise surjectivity assembled through `Concrete.productEquiv`. Lean proof follows exactly this structure (lines 120–155)
- **notes**: none

### `\lean{AlgebraicGeometry.faceShortComplex}` (chapter: `def:face_short_complex`)
- **Lean target exists**: yes (line 163)
- **Signature matches**: yes — `ShortComplex.mk (F.app ...) (G.app ...) ...` over `Opposite.op (⨅ k, U (σ k))`; matches blueprint's "P evaluated at sections over V_σ = ⋂ U(σk)"
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.sectionCechComplexShortComplex}` (chapter: `def:section_cech_short_complex`)
- **Lean target exists**: yes (line 174)
- **Signature matches**: yes — `ShortComplex (CochainComplex Ab ℕ)` with maps `sectionCechComplexMap U P.f` and `sectionCechComplexMap U P.g`; matches blueprint
- **Proof follows sketch**: N/A (definition; zero condition proved inline via `Pi.map_comp_map`)
- **notes**: none

### `\lean{AlgebraicGeometry.cechComplex_shortExact_of_basis}` (chapter: `lem:cech_ses_of_basis`)
- **Lean target exists**: yes (line 196)
- **Signature matches**: yes — `hface : ∀ p σ, (faceShortComplex U P σ).ShortExact` implies `(sectionCechComplexShortComplex U P).ShortExact`; matches blueprint
- **Proof follows sketch**: yes — Lean applies `HomologicalComplex.shortExact_of_degreewise_shortExact` then `shortExact_piMap`; blueprint says "checked degreewise" via AB4* product lemma
- **notes**: none

### `\lean{AlgebraicGeometry.faceShortComplex_shortExact_of_sheaf_ses}` (chapter: `lem:face_ses_of_sheaf_ses`)
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — `(S : ShortComplex X.Modules)`, `hS : S.ShortExact`, `hsurj : ∀ p σ, Function.Surjective (hom (faceShortComplex ... σ).g)`, conclusion `(faceShortComplex ... σ).ShortExact`; matches blueprint
- **Proof follows sketch**: yes — uses `sectionsFunctor`, shows `PreservesFiniteLimits`, applies `ShortComplex.Exact.map_of_mono_of_preservesKernel`, adds epi from `hsurj`. Blueprint says "left-exactness of sections functor (right adjoint) carries exactness; epi from hypothesis". ✓
- **notes**: none

### `\lean{AlgebraicGeometry.cechHomology_quotient_vanishing}` (chapter: `lem:cech_homology_quotient_vanishing`)
- **Lean target exists**: yes (line 213)
- **Signature matches**: yes — `(T : ShortComplex (CochainComplex Ab ℕ))`, `hT : T.ShortExact`, `hI : ∀ p > 0, IsZero (T.X₂.homology p)`, `hF : ∀ p > 0, IsZero (T.X₁.homology p)` implies `∀ p > 0, IsZero (T.X₃.homology p)`; matches blueprint
- **Proof follows sketch**: yes — `hT.δIso p (p+1) hrel hI_p hI_{p+1}` gives `H^p(T.X₃) ≅ H^{p+1}(T.X₁)`, then `hF (p+1)` closes. Blueprint says "connecting map gives H^p(T₃) ≅ H^{p+1}(T₁) = 0" ✓
- **notes**: none

### `\lean{AlgebraicGeometry.quotient_cech_vanishing_of_basis}` (chapter: `lem:quotient_vanishing_cech`)
- **Lean target exists**: yes (line 228)
- **Signature matches**: yes — thin wrapper instantiating `cechHomology_quotient_vanishing` at `sectionCechComplexShortComplex U P`; matches blueprint's "apply abstract homological core"
- **Proof follows sketch**: yes — single-line wrapper, matches blueprint
- **notes**: none

### `\lean{AlgebraicGeometry.absoluteCohomology_one_eq_zero_of_basis}` (chapter: `lem:absolute_cohomology_one_vanishing`)
- **Lean target exists**: yes (line 284)
- **Signature matches**: yes — `U : Opens X`, `hS : S.ShortExact`, `[Injective S.X₂]`, `hsurj : Function.Surjective (hom (((toPresheafOfModules).map S.g).app (op U)))`, `e : Ext (jShriekOU U) S.X₁ 1` implies `e = 0`; matches blueprint
- **Proof follows sketch**: yes — uses `absoluteCohomology_eq_zero_of_injective` to kill `H¹(I)`, uses `absoluteCohomologyZeroAddEquiv_naturality` to identify `H⁰` with sections, uses Ext LES (`absoluteCohomology_covariant_exact₁`), kills connecting map by surjectivity. Blueprint proof says: run covariant Ext LES, H¹(I) = 0 (injective), H⁰(I)→H⁰(Q) surjective → δ = 0, get H¹(F) = 0. ✓
- **notes**: none

### `\lean{AlgebraicGeometry.BasisCovSystem}` (chapter: `def:basis_cov_system`)
- **Lean target exists**: yes (line 323)
- **Signature matches**: **partial** — the structure exists with `B`, `Cov`, `faces_mem` matching blueprint conditions (1) and the basis/covering fields; however see **major finding #1** below for the `surj_of_vanishing` and `injective_acyclic` field discrepancy
- **Proof follows sketch**: N/A (definition)
- **notes**: **Major structural divergence** between blueprint prose and Lean encoding — see Red Flags section

### `\lean{AlgebraicGeometry.HasVanishingHigherCech}` (chapter: `def:has_vanishing_higher_cech`)
- **Lean target exists**: yes (line 346)
- **Signature matches**: yes — `∀ c ∈ s.Cov, ∀ p, 0 < p → IsZero (cechCohomology c.2 ((toPresheafOfModules X).obj F) p)`; matches blueprint's "Ȟ^p(𝒰, F) = 0 for every 𝒰 ∈ s.Cov and p > 0". The blueprint specifies this should be for arbitrary O_X-modules (not just qcoh), and the Lean definition takes `F : X.Modules` (which is all sheaves, not just quasi-coherent). ✓
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.absoluteCohomology_eq_zero_of_basis}` (chapter: `lem:absolute_cohomology_pos_vanishing`)
- **Lean target exists**: yes (line 376)
- **Signature matches**: **partial** — the statement carries `[EnoughInjectives X.Modules]` as a typeclass hypothesis that is **absent** from the blueprint statement; see **major finding #3** below
- **Proof follows sketch**: yes — induction on `n` with `key` quantified over all F, matches blueprint's "induction on p ≥ 1 quantified over all F simultaneously"; base case applies `absoluteCohomology_one_eq_zero_of_basis`, inductive step uses Ext LES + IH on Q, matches blueprint proof sketch exactly ✓
- **notes**: `EnoughInjectives` hypothesis gap in blueprint statement

### `\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}` (chapter: `lem:cech_to_cohomology_on_basis`)
- **Lean target exists**: yes (line 429)
- **Signature matches**: **partial** — also carries `[EnoughInjectives X.Modules]`, absent from blueprint; the statement otherwise matches conditions (1)–(3) of the lemma as packaged in `BasisCovSystem` and `HasVanishingHigherCech` ✓
- **Proof follows sketch**: yes — single-line delegation to `absoluteCohomology_eq_zero_of_basis`; blueprint says "thin assembly via the cover-system encoding" ✓
- **notes**: see finding #3

---

## Red Flags

### Placeholder / suspect bodies
None. All declarations are fully proved with no `sorry`.

### Excuse-comments
None. All TODO-style comments are accurate architecture notes (e.g. the `EnoughInjectives` explanation at lines 351–354, which correctly explains why the hypothesis is explicit rather than synthesized).

### Axioms / Classical.choice on non-trivial claims
None found. No `axiom` declarations introduced.

---

## Unreferenced declarations (informational)

| Declaration | Kind | Notes |
|-------------|------|-------|
| `sectionsFunctor` (line 242) | `def` | Helper for `faceShortComplex_shortExact_of_sheaf_ses`; used only to package left-exactness of sections. Docstring names its role. Blueprint `lem:face_ses_of_sheaf_ses` refers to "the sections functor" without a `\lean{}` pin. Should be pinned for completeness, but private-helper character justifies its absence. **Minor.** |
| `CovDatum` (line 309) | `abbrev` | `Σ ι : Type u, ι → Opens X`; type abbreviation for the `Cov` field of `BasisCovSystem`. Not blueprint-pinned. Utility abbreviation only. **Minor.** |
| `injSES` (line 361) | `private def` | The injective-embedding SES `0 → F → I → I/F → 0` for the 01EO induction. Private, not blueprint-pinned. Legitimate private helper. |
| `injSES_shortExact` (line 365) | `private lemma` | Short-exactness of `injSES F`. Private, not blueprint-pinned. Legitimate private helper. |

---

## Blueprint adequacy for this file

- **Coverage**: 14/14 named public Lean declarations have a corresponding `\lean{...}` block (with the notable exception of `sectionsFunctor` and `CovDatum`, which are helpers). 2 private helpers (`injSES`, `injSES_shortExact`) rightly have no blueprint blocks.
- **Proof-sketch depth**: **adequate** overall — the blueprint proof sketches for `shortExact_piMap`, `cechComplex_shortExact_of_basis`, `cechHomology_quotient_vanishing`, `quotient_cech_vanishing_of_basis`, `absoluteCohomology_one_eq_zero_of_basis`, and `absoluteCohomology_eq_zero_of_basis` are sufficiently detailed that the Lean proofs follow them directly step-by-step. No proof in the Lean file went through reasoning that the blueprint omits.
- **Hint precision**: **loose** in two respects — see findings #1 and #3.
- **Generality**: **matches need** for all declarations except the `BasisCovSystem` encoding, where the blueprint describes a combinatorial (cofinality-level) field for condition (2) but the Lean implements a sheaf-theoretic (surjectivity-output) field.

### Recommended chapter-side actions for blueprint-writing subagent

1. **Update `def:basis_cov_system` prose** to describe the actual Lean structure's fields:
   - Field `surj_of_vanishing` encodes the section-surjectivity consequence of cofinality + `ses_cech_h1`, **not** the raw cofinality datum. The prose currently says "cofinality datum stated in precisely the shape consumed by Lemma~\ref{lem:ses_cech_h1}", but the Lean field is the output (surjectivity produced by that lemma). Update to describe `surj_of_vanishing` as the derived section-surjectivity field, conditioned on Čech vanishing of the left term.
   - Add description of the **fifth field** `injective_acyclic`: the injective Čech-acyclicity condition for the system's coverings (Stacks `lemma-injective-trivial-cech`). Currently entirely absent from the blueprint description.
   - Correct the claim "carries no colimit or derived-functor machinery": the Lean structure carries two sheaf-theoretic (Čech cohomology vanishing) fields.
   - Remove stale `% NOTE: not yet formalized — scaffold this iter` (blueprint line 3307).

2. **Remove stale `% NOTE:` annotations**:
   - `def:has_vanishing_higher_cech`: remove `% NOTE: not yet formalized — scaffold this iter` (blueprint line 3328); the declaration is now formalized.
   - `lem:face_ses_of_sheaf_ses`: remove `% NOTE: target not yet formalized — scaffold this iter` (blueprint line 3459); now formalized.

3. **Add `[EnoughInjectives X.Modules]` hypothesis** to the statements of:
   - `lem:absolute_cohomology_pos_vanishing` (pinning `absoluteCohomology_eq_zero_of_basis`)
   - `lem:cech_to_cohomology_on_basis` (pinning `cech_eq_cohomology_of_basis`)
   
   The blueprint prose invokes "embed F ↪ I into an injective O_X-module" without noting that this requires `[EnoughInjectives X.Modules]` as a Lean hypothesis (the instance is absent in Mathlib for sheaves of modules). Add a parenthetical note matching the Lean file's comment at lines 351–354.

4. **Add `\lean{}` pin for `sectionsFunctor`** to `lem:face_ses_of_sheaf_ses` or create a short inline remark, since the lemma's proof references it explicitly by name.

5. **Correct the `\lean{}` pin for `pi_π_map_apply`**: the declaration is `private` in the Lean file (line 105), so the public name `AlgebraicGeometry.pi_π_map_apply` is unreachable by `lean_verify`. Either drop it from the `\lean{}` list or note it is a private helper. **Minor.**

---

## Severity summary

- **must-fix-this-iter**: 0 findings. All Lean declarations are fully proved, axiom-clean, carry no `sorry`, and are mathematically correct.

- **major** (3 findings):
  1. **`BasisCovSystem` structural divergence** (blueprint `def:basis_cov_system`): The Lean structure's `surj_of_vanishing` field encodes the section-surjectivity *output* of `ses_cech_h1 + cofinality`, not the raw cofinality *input* the blueprint describes. The Lean adds a fifth field `injective_acyclic` entirely absent from the blueprint. The blueprint's "no derived-functor machinery" claim is wrong for the actual Lean encoding. Blueprint must be rewritten to match the Lean implementation.
  2. **Stale `% NOTE: not yet formalized` annotations** in `def:basis_cov_system`, `def:has_vanishing_higher_cech`, and `lem:face_ses_of_sheaf_ses`: these block `sync_leanok` from applying `\leanok` markers and mislead future readers about formalization status.
  3. **`[EnoughInjectives X.Modules]` missing from blueprint statements** of `lem:absolute_cohomology_pos_vanishing` and `lem:cech_to_cohomology_on_basis`: the Lean signatures carry this hypothesis but the blueprint does not acknowledge it, making the blueprint statements not self-contained.

- **minor** (2 findings):
  4. `pi_π_map_apply` is `private` in Lean but the blueprint `\lean{}` pin names it with the public identifier `AlgebraicGeometry.pi_π_map_apply` (unreachable by `lean_verify`).
  5. `sectionsFunctor` and `CovDatum` lack `\lean{}` pins; the former is significant enough (used in the proof of a pinned lemma) to warrant a reference.

**Overall verdict**: `CechToCohomology.lean` is axiom-clean and the proofs faithfully realize the blueprint's mathematical content; the major issues are all blueprint-lag (the prose has not been updated to describe the actual Lean encoding of `BasisCovSystem` and carries three stale `% NOTE:` annotations), plus missing `[EnoughInjectives]` disclosure in two blueprint statements — 14 declarations checked, 0 Lean red flags.
