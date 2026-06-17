# Lean ↔ Blueprint Check Report

## Slug
gf-iter006

## Iteration
006

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes
- **Signature matches**: yes — blueprint comment block (lines 73–78) gives the exact intended signature; Lean decl at L550–556 matches verbatim.
- **Proof follows sketch**: yes/partial — primary route (module-finite A-module case) is closed using `GenericFreeness.exists_free_localizationAway_of_finite`; finite-type residue is `sorry`, matching the blueprint's "surviving residue" section.
- **Notes**: `\leanok` on statement block is correct (declaration formalized with a sorry body for the residue). No fake statement; the sorry is the honest gap the blueprint acknowledges.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`.
- **Proof follows sketch**: yes — proof is axiom-clean; uses `Module.finitePresentation_of_finite` then `Module.FinitePresentation.exists_free_localizedModule_powers`, exactly the route described in the blueprint.
- **Notes**: `\leanok` on statement and proof blocks is correct.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes
- **Signature matches**: yes — same hypotheses as the free variant but conclusion is `Module.Flat`.
- **Proof follows sketch**: yes — two lines: obtain the free case, then `Module.Flat.of_free`. Matches blueprint proof verbatim.
- **Notes**: `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes
- **Signature matches**: yes — takes `[Module.Finite A B]` (module-finite A-algebra B) and `[Module.Finite B M]`, derives `Module.Finite A M` internally.
- **Proof follows sketch**: yes — uses `Module.Finite.trans B M` then calls the finite-module leaf. Blueprint says exactly this.
- **Notes**: `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes
- **Signature matches**: yes — `htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M)` is the correct Lean encoding of `M_K = 0`; the docstring explains the equivalence explicitly.
- **Proof follows sketch**: yes — finds annihilator product via `LocalizedModule.subsingleton_iff`, takes product over a finite B-generating set, proves fM = 0 by span induction, concludes `M_f` subsingleton hence free. Matches the Nitsure §4 base-case step-by-step.
- **Notes**: `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes
- **Signature matches**: yes — returns a conjunction `Injective ∧ Surjective ∧ Exact` for the localised maps, which is the correct encoding of "localised SES is exact in all three positions".
- **Proof follows sketch**: yes — three-way refine via `LocalizedModule.map_injective`, `.map_surjective`, `.map_exact`.
- **Notes**: `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes
- **Signature matches**: yes — `{f f' f'' : A} (hf : f = f' * f'')` encodes the factorisation; conclusion is `Module.Free (Localization.Away f) ...`.
- **Proof follows sketch**: yes — constructs the ring map `A_{f'} → A_f`, the A'-linear map `N_{f'} → N_f`, and deduces freeness via `IsBaseChange.of_comp`. Blueprint says "a localisation of a free module is free over the localised base ring"; the Lean proof uses the base-change API to make this precise.
- **Notes**: Blueprint says "N be a B-module" informally but the Lean decl takes a plain A-module; this is a minor prose imprecision in the blueprint (N only needs the A-structure for localisation), not a mismatch. `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes
- **Signature matches**: yes — fully generic over `R`, takes free `P` and `T`, concludes free `Q`.
- **Proof follows sketch**: yes — `Module.projective_lifting_property` gives a section; `Function.Exact.splitSurjectiveEquiv` gives `Q ≃ₗ P × T`; `Module.Free.of_equiv`. Blueprint says "free quotient is projective, sequence splits, Q ≅ P ⊕ T".
- **Notes**: `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes
- **Signature matches**: yes — takes `f' ≠ 0`, `f'' ≠ 0`, `M'_{f'}` free, `M''_{f''}` free; existentially returns `f := f' * f''` with `M_f` free.
- **Proof follows sketch**: yes — applies L3b to both ends (with `hf := rfl` and `mul_comm f' f''` respectively), then L3a for exactness, then L3c.
- **Notes**: `\leanok` correct; closed axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes
- **Signature matches**: yes — **confirmed match** with the `% LEAN SIGNATURE` block in the blueprint (lines 366–374):
  ```
  ∃ (n : ℕ) (g : A) (_ : g ≠ 0)
    (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))
    (φ : MvPolynomial (Fin n) (Localization.Away g)
          →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)),
    Function.Injective φ ∧
    (letI := φ.toAlgebra;
     Module.Finite (MvPolynomial (Fin n) (Localization.Away g))
                   (Localization.Away (algebraMap A B g)))
  ```
  The blueprint note "NOTE (resolved iter-006)" is accurate; the third existential binder `(_ : Algebra ...)` is present in both.
- **Proof follows sketch**: partial — Step 1 (Noether normalisation over `K` via `exists_finite_inj_algHom_of_fg`) is landed with comments. Step 2 (denominator-clearing) is `sorry`.
- **Notes**: `\leanok` on statement block is correct. The sorry is at L445, correctly flagged as "the genuine remaining content of L4." No excuse-comment; the comment accurately describes the construction that is absent from Mathlib.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d : ℕ) (N : Type*) [Module (MvPolynomial (Fin d) A) N] [Module.Finite (MvPolynomial (Fin d) A) N] [Module A N] [IsScalarTower A (MvPolynomial (Fin d) A) N] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) N)`.
- **Proof follows sketch**: partial — the induction skeleton `induction d using Nat.strong_induction_on generalizing N` is correctly set up (the structural fix this iter); the IH universally quantifies over the module type. Base case `d = 0` is closed via `exists_free_localizationAway_of_finite`. Torsion sub-case (`N_K = 0`) is closed via `exists_free_localizationAway_of_torsion`. The non-torsion inductive step (generic-rank SES construction) is `sorry`.
- **Notes**: `\leanok` on statement block is correct. The comment at L495–512 accurately identifies the surviving residue ("the generic-rank SES construction `0 → A_g[X]^⊕m → N_g → T → 0` together with the Noether-normalisation reindex of T"). This is a workflow note, not an excuse-comment.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType]`, with the flatness conclusion quantified over affine opens U ≤ V of S and affine opens W ≤ p⁻¹U. Matches the blueprint's LEAN SIGNATURE HEADER comment exactly.
- **Proof follows sketch**: partial — the non-empty affine open `U₀` is extracted via `exists_isAffineOpen_mem_and_subset` (matching Step 1 in the blueprint); geometric assembly (Steps 2–4 of the blueprint's proof) is `sorry`.
- **Notes**: `\leanok` on statement block is correct. The sorry is legitimate and the Lean comment (L627–647) outlines exactly the geometric assembly needed.

---

## Red flags

### Placeholder / suspect bodies
- `GenericFreeness.exists_localizationAway_finite_mvPolynomial` at L445: body is `sorry` (Step 2, denominator-clearing). **Legitimate** — blueprint acknowledges this as the "genuine remaining content of L4", Mathlib-absent.
- `GenericFreeness.exists_free_localizationAway_polynomial` at L513: body is `sorry` (generic-rank SES, non-torsion inductive step). **Legitimate** — blueprint acknowledges this as the "genuine Mathlib-absent residue."
- `genericFlatnessAlgebraic` at L580: body is `sorry` (finite-type module case). **Legitimate** — blueprint's "surviving residue" section.
- `genericFlatness` at L647: body is `sorry` (geometric assembly). **Legitimate** — blueprint describes the full assembly needed.

*None of the above are fake statements or weakened-wrong definitions. All four sorrys represent genuinely hard Mathlib-absent content that the blueprint explicitly documents as the open gap.*

### Excuse-comments
None. All inline comments are accurate mathematical descriptions of missing constructions, not rationalizations of wrong code.

### Axioms / Classical.choice on non-trivial claims
None found. `classical` is used inside `exists_free_localizationAway_of_torsion` (L193) for a `Finset.prod_erase_mul` application, which is standard Lean practice for decidability on finite sets, not an axiom.

---

## Unreferenced declarations (informational)

All declarations in the Lean file have a corresponding `\lean{...}` reference in the blueprint:

| Lean declaration | Blueprint reference |
|---|---|
| `exists_free_localizationAway_of_finite` | `lem:gf_finite_module` |
| `exists_flat_localizationAway_of_finite` | `lem:gf_flat_finite` |
| `exists_free_localizationAway_of_moduleFinite` | `lem:gf_free_moduleFinite` |
| `exists_free_localizationAway_of_torsion` | `lem:gf_torsion_base` |
| `exact_localizedModule_powers_of_shortExact` | `lem:gf_splice_shortExact_localized_exact` |
| `free_localizationAway_of_free_of_eq_mul` | `lem:gf_splice_shortExact_free_transport` |
| `free_of_shortExact_of_free_free` | `lem:gf_splice_shortExact_split` |
| `exists_free_localizationAway_of_shortExact` | `lem:gf_splice_shortExact` |
| `exists_localizationAway_finite_mvPolynomial` | `lem:gf_noether_clear_denominators` |
| `exists_free_localizationAway_polynomial` | `lem:gf_polynomial_core` |
| `genericFlatnessAlgebraic` | `thm:generic_flatness_algebraic` |
| `genericFlatness` | `thm:generic_flatness` |

Coverage is complete. No substantive declarations are missing from the blueprint.

---

## Blueprint adequacy for this file

### (A) Adequacy for closed declarations
**Verdict: adequate.** The blueprint proof sketches for the 9 axiom-clean declarations were sufficient to guide correct formalization. All signatures match, all proof structures are faithful to the chapter, and `\leanok` markers are correctly set.

### (B) Adequacy for the two surviving sorry steps

#### L4 Step 2 — denominator-clearing (`exists_localizationAway_finite_mvPolynomial`)

The blueprint proof sketch (lines 424–442) gives the correct mathematical outline:
1. Apply Noether normalisation over K.
2. Represent each `b̄_j ∈ B_K` as `1 ⊗ b_j` for `b_j ∈ B`.
3. Fix finitely many integral-dependence equations; let g be a common denominator.
4. After inverting g, `B_g` is finite over `A_g[b_1,…,b_n]`.

**Missing for formalization:**
- No guidance on the Lean API for extracting `b_j ∈ B` from a TensorProduct element `b̄_j ∈ K ⊗_A B` (likely via `TensorProduct.exists_representation` or a custom lemma about elements of `FractionRing A ⊗ B`).
- No guidance on formalizing "common denominator" — specifically, a sub-lemma of the form `∀ (s : Finset (K ⊗_A B)), ∃ (g : A), g ≠ 0 ∧ ∀ x ∈ s, g • x ∈ ...`.
- No guidance on constructing the `Algebra (Localization.Away g) (Localization.Away (algebraMap A B g))` instance existential from g (this instance is non-trivial to conjure without knowing the right Lean path).
- No guidance on showing `Module.Finite` under `letI := φ.toAlgebra` once the integral-dependence equations are cleared.

**Assessment: under-specified for formalization.** A blueprint-writer expansion should extract the denominator-clearing step as an explicit sub-lemma (with its own `\lean{...}` pin and signature comment) before the next prover iteration attempts to close this sorry.

#### L5 generic-rank SES and T-reindex (`exists_free_localizationAway_polynomial`, non-torsion inductive step)

The blueprint proof sketch (lines 476–494) gives the correct mathematical outline:
1. Let m = generic rank of N over A[X_1,…,X_d] (i.e., dim_{K(X)} N_K).
2. Choose m elements of N whose images form a K(X_1,…,X_d)-basis of N_K.
3. Clear denominators to get g and the SES `0 → A_g[X]^⊕m → N_g → T → 0`.
4. T is torsion over A_g[X]; support dimension < d; reindex T onto MvPolynomial (Fin m') A with m' < d.
5. Apply IH to T; splice with L3.

**Missing for formalization:**
- How to **define/compute generic rank** in Lean: likely `Module.finrank (FractionField (MvPolynomial (Fin d) A)) (LocalizedModule ... N)` — the blueprint does not name a Lean API.
- How to **construct the SES**: choosing m elements of N, showing their images are K(X)-linearly independent, building the injection `A_g[X]^⊕m → N_g`, defining T as the quotient, proving T is torsion — none of these are named with Lean API pointers. These likely require a sub-lemma of the form "if rank m elements span N_K, there exists g ≠ 0 such that ..." which is Mathlib-absent and needs its own blueprint entry.
- How to **reindex T** onto `MvPolynomial (Fin m') A` with m' < d: the blueprint says "T is finite over a polynomial ring in fewer variables after a further inversion" but does not explain the reindex construction (the relevant structural result about the Krull dimension of support of a torsion module over a polynomial ring).
- How to **invoke the IH**: the IH in the `Nat.strong_induction_on generalizing N` has the form `∀ m < d, ∀ N' [...], ∃ f ≠ 0, Free A_f N'_f`. The blueprint does not guide how to transport T's instances into the `MvPolynomial (Fin m') A`-module form that the IH expects.

**Assessment: under-specified for formalization.** This step should be broken into at least two sub-lemmas with their own blueprint entries before the next prover iteration:
1. A sub-lemma constructing the generic-rank SES (pinning the type of the free part, the definition of T, and T's torsion property).
2. A sub-lemma showing T (after the reindex) has a `MvPolynomial (Fin m') A`-module structure with m' < d.

---

- **Coverage**: 12/12 Lean declarations have a corresponding `\lean{...}` block in the chapter. 0 unreferenced substantive declarations.
- **Proof-sketch depth**: **under-specified** for the two open sorry steps (L4 Step 2, L5 generic-rank SES + T-reindex). Adequate for all closed declarations.
- **Hint precision**: **precise** — every `\lean{...}` pin names the correct declaration with the correct fully-qualified namespace. The L4 `% LEAN SIGNATURE` block matches the landed declaration exactly.
- **Generality**: **matches need** — all declarations are at the right level of generality for their roles.
- **Recommended chapter-side actions**:
  - Extract L4 Step 2 (denominator-clearing) as a standalone sub-lemma with a `\lean{...}` pin, explicit Lean signature comment, and Lean API pointers for `TensorProduct` element extraction and "common denominator" construction.
  - Extract L5 Step A (generic-rank SES construction: `0 → A_g[X]^⊕m → N_g → T → 0`) as a standalone sub-lemma with a `\lean{...}` pin, defining the free part, the torsion quotient T, and the generic rank m.
  - Extract L5 Step B (T-reindex: T finite over `MvPolynomial (Fin m') A` with m' < d) as a standalone sub-lemma or corollary of the SES step.
  - Both expansions should include explicit Lean API suggestions (e.g., `Module.finrank` over the fraction field of the polynomial ring, the relevant `LocalizedModule` exactness API for constructing T).

---

## Severity summary

- **must-fix-this-iter**: None. All signatures match, no fake statements, no excuse-comments, no unauthorized axioms.
- **major**:
  - **Blueprint adequacy (L4 Step 2)**: `lem:gf_noether_clear_denominators`'s proof sketch does not provide enough Lean API guidance for the denominator-clearing construction. A prover attempting this step next iter would need to guess the key formalization choices. Needs blueprint-writer expansion before the next prover iteration on L4.
  - **Blueprint adequacy (L5 SES + reindex)**: `lem:gf_polynomial_core`'s proof sketch does not name the sub-lemmas for (a) the generic-rank SES construction and (b) the T-reindex onto a polynomial ring in fewer variables. These are the genuine Mathlib-absent residues, and without sub-lemma extraction the next prover cannot make targeted progress.
- **minor**: `lem:gf_splice_shortExact_free_transport` blueprint says "N be a B-module" but the Lean decl takes a plain A-module; this is a prose imprecision in the chapter that is not a mismatch (only A-structure is needed for the localisation).

**Overall verdict**: The Lean file faithfully follows the blueprint in every respect — all 12 declarations are present with matching signatures, proof structures follow the mathematical content of the chapter, `\leanok` markers are correctly set, the L4 `% LEAN SIGNATURE` block is confirmed to match the landed declaration, and the four `sorry` bodies are all legitimate documented gaps. The chapter is adequate for the closed work; the two surviving sorry steps (L4 Step 2 and L5 generic-rank SES + T-reindex) need blueprint-writer sub-lemma extraction before the next prover iteration can make targeted progress on them.
