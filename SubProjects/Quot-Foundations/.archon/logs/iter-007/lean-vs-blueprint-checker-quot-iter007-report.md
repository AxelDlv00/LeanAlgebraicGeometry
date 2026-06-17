# Lean ↔ Blueprint Check Report

## Slug
quot-iter007

## Iteration
007

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsLocallyNoetherian S] (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _F : X.Modules) (_s : S) : Polynomial ℚ` correctly encodes the finite-type morphism over a noetherian base, two module arguments, a base-point, returning `Polynomial ℚ`.
- **Proof follows sketch**: N/A — body is `:= sorry` (intended file-skeleton state; docstring says "iter-177+: body unfolds to graded-Euler-characteristic once χ and Snapper are in scope"). Blueprint carries `\leanok` on the statement block only.
- **notes**: `_L` and `_F` are both typed `X.Modules` with no invertibility/coherence constraint enforced at the type level — Mathlib limitation, not a blueprint-hint failure. The sorry is consistent with the blueprint's marker protocol.

### `\lean{AlgebraicGeometry.sectionGradedRing}` (chapter: `def:sectionGradedRing`)
- **Lean target exists**: no — `AlgebraicGeometry.sectionGradedRing` is absent from the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state. Blueprint has `% NOTE (iter-007): blocked on absent tensor/monoidal structure for SheafOfModules`. No `\leanok` marker on the statement block, which is correct.

### `\lean{AlgebraicGeometry.sectionGradedModule}` (chapter: `def:sectionGradedModule`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state; depends on `sectionGradedRing` infrastructure.

### `\lean{AlgebraicGeometry.sectionGradedModule_fg}` (chapter: `lem:sectionGradedModule_fg`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state; depends on graded-ring infrastructure.

### `\lean{Polynomial.existsUnique_hilbertPoly}` (chapter: `lem:hilbertPoly_exists_mathlib`)
- **Lean target exists**: yes (Mathlib); `\mathlibok` — no project obligation.
- **Signature matches**: yes (Mathlib-supplied)
- **Proof follows sketch**: N/A
- **notes**: Mathlib block, no project-side verification needed.

### `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}` (chapter: `lem:gradedHilbertSerre_rational`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state; project-side Hilbert–Serre rationality lemma, not yet formalized.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` (chapter: `thm:hilbertPoly_of_sectionModule`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state; depends on `gradedHilbertSerre_rational` and `sectionGradedModule`.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: `def:modules_annihilator`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Explicitly blocked with `% NOTE (iter-007): blocked on missing QCoh → IsLocalizedModule bridge`. The algebra engine (`Module.annihilator_isLocalizedModule_eq_map`) was landed this iter but the sheaf-level wrapper is still absent due to the `M(U) → M(D(f))` `IsLocalizedModule` gap on general `X.Modules`.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: `def:schematic_support`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state; depends on `Modules.annihilator`.

### `\lean{AlgebraicGeometry.IsProper}` (chapter: `lem:isProper_mathlib`)
- **Lean target exists**: yes (Mathlib); `\mathlibok`.
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Mathlib block.

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: `def:has_proper_support`)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Expected blocked state; depends on `schematicSupport` and `IsProper`.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: `def:is_locally_free_of_rank`) ← **NEW THIS ITER**
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — LSP confirms `{X : Scheme} (M : X.Modules) (d : ℕ) : Prop`; blueprint prose says "sheaf of modules M on scheme X, d ∈ ℕ, returns Prop". Exact match.
- **Proof follows sketch**: N/A (definition, not a theorem)
- **notes**: Body is substantive — see §Red flags analysis below. `\leanok` on statement block is correct; no sorry in the definition body.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u` correctly encodes `(Sch/S)^op → Set`.
- **Proof follows sketch**: N/A — body is `:= sorry` (file-skeleton). Blueprint `\leanok` on statement block.
- **notes**: Signature is faithful; sorry is consistent with `\leanok`-only marking.

### `\lean{CategoryTheory.Functor.IsRepresentable}` (chapter: `lem:functor_is_representable_mathlib`)
- **Lean target exists**: yes (Mathlib); `\mathlibok`.
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Mathlib block.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `{S : Scheme.{u}} [IsLocallyNoetherian S] (_V : S.Modules) (_d : ℕ) : (Over S)ᵒᵖ ⥤ Type u`.
- **Proof follows sketch**: N/A — body is `:= sorry` (file-skeleton). Blueprint `\leanok` on statement block.
- **notes**: Consistent with intended skeleton state.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225)
- **Signature matches**: **partial** — Lean states `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`. Blueprint claims representability by a *smooth projective S-scheme of relative dimension d(r-d)* with a *tautological quotient π*V ↠ U* and *Plücker closed embedding into ℙ_S(⋀^d V)*. The Lean statement drops all geometric structure: no smoothness predicate, no projectiveness, no relative dimension, no tautological quotient, no Plücker embedding.
- **Proof follows sketch**: N/A — body is `by sorry`.
- **notes**: The Lean docstring explicitly documents the weakening as intentional: "the additional projective / smooth / Plücker structure is implicit in the construction and is iter-177+ refinement work". The weakening is therefore tracked and expected, but it is a formal statement mismatch against the blueprint prose.

---

## Red flags

### Placeholder / suspect bodies

The following four declarations have `:= sorry` / `by sorry` bodies:
- `hilbertPolynomial` (line 123) — body `:= sorry`
- `QuotFunctor` (line 161) — body `:= sorry`
- `Grassmannian` (line 198) — body `:= sorry`
- `Grassmannian.representable` (line 225) — body `by sorry`

**Classification: not must-fix.** All four are explicitly marked as file-skeleton sorries via their docstrings ("For the iter-176 file-skeleton the body is a typed `sorry`"). The blueprint's `\leanok` marker on each statement block uses the protocol meaning "at least a sorry present" — not "proof closed". There are no proof-closed `\leanok` claims on proof blocks for these four. The sorries are fully consistent with the project's stated skeleton workflow and blueprint-marker vocabulary.

### Excuse-comments
None found. The docstring language ("iter-177+:", "For the iter-176 file-skeleton") is a roadmap marker, not an excuse-comment in the sense of "this is wrong but works for now" or "TODO replace with real def".

### Axioms / Classical.choice on non-trivial claims
- `Module.annihilator_isLocalizedModule_eq_map`: axioms confirmed by LSP as `[propext, Classical.choice, Quot.sound]` — the three standard Lean 4 kernel axioms. No `sorryAx`. The proof is axiom-clean.
- `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank`: axioms `[propext, Classical.choice, Quot.sound]`. No `sorryAx`. The definition is axiom-clean.
- No non-standard axioms introduced anywhere in the file.

---

## Detailed analysis: the two new iter-007 declarations

### `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank`

**Body** (lines 253–256):
```
def IsLocallyFreeOfRank {X : Scheme.{u}} (M : X.Modules) (d : ℕ) : Prop :=
  ∃ (ι : Type u) (U : ι → X.Opens), (⨆ i, U i = ⊤) ∧
    ∀ i, Nonempty ((Scheme.Modules.pullback (U i).ι).obj M ≅
      _root_.SheafOfModules.free (R := (U i).toScheme.ringCatSheaf) (ULift.{u} (Fin d)))
```

**Fidelity to blueprint** (`def:is_locally_free_of_rank`, lines 544–566):
Blueprint prose: "there exists an open cover {U_i} of X together with isomorphisms M|_{U_i} ≅ O_{U_i}^{⊕ d} for each i."

- Open cover condition: `∃ (ι : Type u) (U : ι → X.Opens), (⨆ i, U i = ⊤)` — existential index type + open-valued family whose supremum is ⊤ (the top open, i.e., all of X). This is the standard Lean encoding of "open cover of X". ✓
- Restriction: `(Scheme.Modules.pullback (U i).ι).obj M` — pullback of M along the open immersion `(U i).ι : (U i).toScheme ⟶ X`. This is the correct encoding of `M|_{U i}`. ✓
- Target: `_root_.SheafOfModules.free (R := (U i).toScheme.ringCatSheaf) (ULift.{u} (Fin d))` — the free sheaf of modules of rank d over the structure sheaf of the open subscheme, indexed by `ULift (Fin d)`. The `ULift` universe-lift is required for universe polymorphism; `|Fin d| = d`, so this is `O_{U_i}^{⊕ d}`. ✓
- Isomorphism as `Nonempty (... ≅ ...)`: the `Nonempty` truncation is appropriate for a `Prop`-valued predicate (we need existence of an isomorphism, not a chosen one). ✓

**Substantiveness check**: The predicate is non-vacuously satisfiable (a locally free sheaf of rank d satisfies it) and non-trivially restrictive (an incoherent/non-locally-free module does not). The cover condition `⨆ i, U i = ⊤` is not trivially satisfied by the empty cover. The isomorphism condition is a genuine categorical witness. The predicate is substantive. ✓

**Verdict**: `IsLocallyFreeOfRank` faithfully and substantively encodes `def:is_locally_free_of_rank`. No issues.

---

### `Module.annihilator_isLocalizedModule_eq_map`

**Statement** (lines 289–295):
```
theorem annihilator_isLocalizedModule_eq_map
    {R : Type*} [CommRing R] (S : Submonoid R)
    {Rₚ : Type*} [CommRing Rₚ] [Algebra R Rₚ] [IsLocalization S Rₚ]
    {M : Type*} [AddCommGroup M] [Module R M] [Module.Finite R M]
    {Mₚ : Type*} [AddCommGroup Mₚ] [Module R Mₚ] [Module Rₚ Mₚ] [IsScalarTower R Rₚ Mₚ]
    (f : M →ₗ[R] Mₚ) [IsLocalizedModule S f] :
    Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)
```

**Fidelity to standard algebra** (`Ann(S⁻¹M) = (Ann M)·S⁻¹R` for finitely generated M):
- `IsLocalization S Rₚ` + `IsLocalizedModule S f` is the abstract localization setup — Lean's canonical way to express "S⁻¹R and S⁻¹M". ✓
- `Module.Finite R M` is "finitely generated M" — non-vacuous, genuinely required (the theorem is false without it). ✓
- Conclusion `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` is exactly `Ann(S⁻¹M) = (Ann R M)·S⁻¹R` where `Ideal.map (algebraMap R Rₚ)` is the ideal extension along the localization map. ✓
- Axiom check: `[propext, Classical.choice, Quot.sound]` — standard kernel axioms only, no sorry. Full proof at lines 297–349. ✓

**Substantiveness check**: The hypothesis set `[CommRing R, IsLocalization S Rₚ, Module.Finite R M, IsLocalizedModule S f]` is the minimal standard setup. No hypothesis is trivially true or makes the statement vacuous. The equality is non-trivial (it can fail without `Module.Finite`, e.g., for infinite-rank free modules over non-Noetherian rings). ✓

**Blueprint coverage gap**: There is **no** `\lean{Module.annihilator_isLocalizedModule_eq_map}` block anywhere in `Picard_QuotScheme.tex`. The only mention of this theorem is in the `% NOTE` comment inside `def:modules_annihilator` (line 444): "The algebraic engine `Module.annihilator_isLocalizedModule_eq_map` (Ann(S^-1 M) = (Ann M)*S^-1 R for f.g. M) was landed this iter and supplies the algebra half." This is a prose annotation inside a NOTE comment, not a blueprint declaration block with `\lean{...}`. The theorem has no standalone blueprint home.

---

## Unreferenced declarations (informational)

| Declaration | Blueprint reference? | Classification |
|---|---|---|
| `Module.annihilator_isLocalizedModule_eq_map` | **No** | **Substantive** — engine lemma for `def:modules_annihilator`. Should have a blueprint block. |

All other declarations in the Lean file (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`, `IsLocallyFreeOfRank`) are `\lean{...}`-referenced in the blueprint.

---

## Blueprint adequacy for this file

### Coverage
5/6 Lean declarations have a corresponding `\lean{...}` block in the chapter. `Module.annihilator_isLocalizedModule_eq_map` is the uncovered declaration. Of the blueprint's many `\lean{...}` targets not yet in the Lean file, all are acknowledged as blocked (infrastructure gaps with `% NOTE` annotations).

### Proof-sketch depth
- `def:is_locally_free_of_rank` (lines 544–566): **adequate**. The prose gives the complete predicate (open cover + rank-d isomorphisms), which directly guided the Lean encoding.
- `def:quot_functor` (lines 571–644): adequate for the statement skeleton; the proof sketch for the sorry-body is deferred to iter-177+.
- `thm:grassmannian_representable` (lines 720–839): detailed — the full Nitsure construction (gluing, separatedness, properness, tautological quotient, Plücker) is spelled out in the proof sketch. However, the Lean statement only claims bare representability (`∃ Y, RepresentableBy Y`), so the sketch is effectively over-specified for the current Lean target. This will matter when the sorry is filled.
- Blocked blocks (`sectionGradedRing`, `sectionGradedModule`, etc.): `% NOTE` annotations adequately communicate the infrastructure blockers.

### Hint precision
**mostly precise**. All `\lean{...}` names that correspond to existing Lean declarations match the actual fully qualified names (verified via LSP hover). One precision note: `def:hilbert_polynomial` does not specify which Mathlib type to use for "line bundle" (`_L`), leaving the prover to default to `X.Modules` — this is a forced choice given Mathlib's current state and not a blueprint failure.

### Generality
**matches need** for the declared declarations. The blocked declarations (`sectionGradedRing`, `Modules.annihilator`) would need additional infrastructure but this is a Mathlib gap, not a blueprint generality issue.

### Recommended chapter-side actions
1. **Add a blueprint block for `Module.annihilator_isLocalizedModule_eq_map`** — a `\begin{lemma}...\end{lemma}` block with `\lean{Module.annihilator_isLocalizedModule_eq_map}` and `\leanok` (the proof is already clean). The block should state: for a finitely generated R-module M, if `f : M →ₗ[R] Mₚ` is an S-localization of M and `Rₚ = S⁻¹R`, then `Ann_{Rₚ}(Mₚ) = (Ann_R M) · Rₚ`. Place it in §"Support and freeness predicates" between `def:modules_annihilator` and `def:schematic_support`, since it is the engine lemma for `def:modules_annihilator`.
2. **Track the `Grassmannian.representable` statement weakening** — add a `% NOTE` comment in the `thm:grassmannian_representable` block noting that the current Lean statement is the bare representability skeleton and the smooth/projective/dimension/Plücker structure is deferred to iter-177+. This is informational but prevents a future reviewer from being surprised.

---

## Severity summary

### must-fix-this-iter
*None.*

### major
1. **`Module.annihilator_isLocalizedModule_eq_map` has no blueprint block.** The theorem is substantive (axiom-clean full proof, engine lemma for `def:modules_annihilator`), lives in the project-local supplement section of the Lean file, and should be blueprinted. The `% NOTE` inside `def:modules_annihilator` mentions it but that is not a `\lean{...}` block. Classification basis: "missing `\lean{...}` references to declarations that the blueprint should reference."

2. **`Grassmannian.representable` Lean statement drops substantial geometric structure.** Blueprint claims: smooth projective S-scheme, relative dimension d(r-d), tautological quotient π*V ↠ U, Plücker embedding into ℙ_S(⋀^d V). Lean states: `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`. The docstring documents this as intentional skeleton simplification for iter-177+. This is a partial signature mismatch (the Lean statement is implied by but strictly weaker than the blueprint claim). Classification basis: "partial signature mismatch that is fixable in-place."

### minor
1. `hilbertPolynomial` uses `X.Modules` for `_L` (line bundle) without an invertibility constraint — a Mathlib-forced limitation, worth noting in the blueprint as a hint-precision gap when the sorry body is eventually filled.

---

**Overall verdict**: The two iter-007 new declarations (`IsLocallyFreeOfRank` and `annihilator_isLocalizedModule_eq_map`) are both axiom-clean and correctly encoded; `IsLocallyFreeOfRank` faithfully matches its blueprint definition; the primary outstanding issue is the missing blueprint block for `annihilator_isLocalizedModule_eq_map` (major, not blocking), plus the documented intentional weakening of `Grassmannian.representable`'s Lean statement (major, tracked). 6 declarations checked, 0 red flags (sorries are skeleton-protocol-consistent), 2 major findings.
