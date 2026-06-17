# Lean ↔ Blueprint Check Report

## Slug
coe-iter201

## Iteration
201

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (1537 lines post-iter-201)
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (1529 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (def:indeterminacy_locus)
- **Lean target exists**: yes (L146, public `def`)
- **Signature matches**: yes — `(f.domain : Set X)ᶜ` matches blueprint's `X \ Dom(f)`
- **Proof follows sketch**: N/A (definition)
- **notes**: Unchanged from iter-200; clean.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (def:codim_one_indeterminacy)
- **Lean target exists**: yes (L180, public `def`)
- **Signature matches**: yes — `∀ (x : X), Order.coheight x = 1 → x ∈ f.domain` matches blueprint
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` (lem:module_free_kaehler_localization)
- **Lean target exists**: yes (L325, private theorem)
- **Signature matches**: yes — matches blueprint statement
- **Proof follows sketch**: yes — `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule` as described
- **notes**: `private`; pre-existing `\lean{...}` pin on a private decl. No change from iter-200.

### `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` (lem:rank_kaehler_localization_eq_relative_dim)
- **Lean target exists**: yes (L351, private theorem)
- **Signature matches**: yes — `Module.rank Sₘ (Ω[Sₘ⁄R]) = n` under `IsStandardSmoothOfRelativeDimension n R S` + `IsLocalization M Sₘ`
- **Proof follows sketch**: yes
- **notes**: No change from iter-200.

### `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` (lem:smooth_algebra_krull_dim_formula / Stage 6.A)
- **Lean target exists**: no — this is the planned Mathlib upstream target; no `\leanok` on this block
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly unformalized. The blueprint's `\subsec:stage6_iib_substrate_iter200` (added by plan agent iter-201) now documents the 3-step decomposition. The iter-201 substrate work (3 new private lemmas) is partially covered in the recipe text; see Lean→Blueprint findings below.

### `\lean{AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue}` (lem:cotangent_kahler_over_field / Stage 6.B)
- **Lean target exists**: yes (L476, private noncomputable def)
- **Signature matches**: yes — `(RingHom.ker (algebraMap Sₘ κ)).Cotangent ≃ₗ[Sₘ] TensorProduct Sₘ κ Ω[Sₘ⁄R]` matches closed-point iso
- **Proof follows sketch**: yes — 3-step analogist recipe (retraction→injection, Ω[κ⁄R]=0+exactness→surjection, bijective→iso)
- **notes**: No change from iter-200. Companion siblings (L527–629) are axiom-clean.

### `lem:stage6_regular_stalk_assembly` (Stage 6.C — no `\lean{...}` pin)
- **Lean target exists**: N/A (no standalone decl; in-body closure pattern in `isRegularLocalRing_stalk_of_smooth`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Intentional; correctly described in the iter-199 blueprint NOTE.

### `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` (lem:smooth_to_regular_local_ring)
- **Lean target exists**: yes (L1055, private theorem)
- **Signature matches**: yes — `[Smooth X.hom] ... (z : X.left) : IsRegularLocalRing (X.left.presheaf.stalk z)` matches blueprint
- **Proof follows sketch**: partial — Stages 1–5b plus 6.B-RHS substrate axiom-clean in body; L1179 `sorry` represents the residual Stacks-00OE sub-gap (ii.B) Krull-dimension formula, plus the Stacks-00SW Jacobian-regular-sequence witness needed upstream
- **notes**: `\leanok` on statement block only — correct (declaration exists, proof incomplete). The iter-201 substrate lemmas (L854, L889, L924) narrow the remaining content but do not close the body.

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (lem:smooth_codim_one_dvr)
- **Lean target exists**: yes (L1268, public theorem)
- **Signature matches**: yes — `Order.coheight z = 1 → IsDiscreteValuationRing (X.left.presheaf.stalk z)` under smooth integral variety
- **Proof follows sketch**: yes — chains `isRegularLocalRing_stalk_of_smooth` + `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` + `IsDiscreteValuationRing.TFAE`
- **notes**: Inherits sorry from `isRegularLocalRing_stalk_of_smooth`. `\leanok` on statement block — correct.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (thm:codim_one_extension)
- **Lean target exists**: yes (L1337, public theorem)
- **Signature matches**: yes — `CodimOneFree f → ∃! (g : X.left ⟶ Y.left), g.toRationalMap = f` under smooth source + complete target
- **Proof follows sketch**: partial — Steps 1 and 2 are structural `sorry` at L1376; body comment accurately records both gaps (Stacks 0AVF + Stage 6 chain)
- **notes**: `\leanok` on statement block. 1 sorry. No change.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (lem:milne_codim1_indeterminacy)
- **Lean target exists**: yes (L1405, public theorem)
- **Signature matches**: yes — `indeterminacyLocus f = ∅ ∨ ∀ x ∈ indeterminacyLocus f, ∃ z, Order.coheight z = 1 ∧ x ∈ closure {z}`
- **Proof follows sketch**: partial — 4-substep proof is structural `sorry` at L1451; body comment documents Mathlib gaps
- **notes**: `\leanok` on statement block. 1 sorry. No change.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (lem:mem_domain_partial_map_reshuffle)
- **Lean target exists**: yes (L1517, public theorem)
- **Signature matches**: yes — `W.point ∈ f.domain ↔ ∃ g, g.toRationalMap = f ∧ W.point ∈ g.domain`
- **Proof follows sketch**: yes — definitional `rw [Scheme.RationalMap.mem_domain]` + conjunction swap
- **notes**: Axiom-clean. `\leanok` on both statement and proof blocks — correct.

---

## Red flags

### Blueprint API state claim contradicted by iter-201 empirical audit

The blueprint's Mathlib API state paragraph (within `\subsec:stage6_subgap_decomposition`, the bullet on `IsRegularLocalRing.localization_isRegularLocalRing`) reads:

> `\texttt{IsRegularLocalRing.localization\_isRegularLocalRing}` (preservation of regularity under localisation at a prime; Stacks \texttt{tag 00OF}) --- EXISTS; used as the closed-point-to-arbitrary-point promotion step once Stage 6.C is in scope.

The iter-201 prover explicitly grep'd `Mathlib/RingTheory/RegularLocalRing/` at commit `b80f227` and found only `Defs.lean` — `IsRegularLocalRing.localization` (or any variant) is **absent**. The blueprint's "EXISTS" claim is wrong. This blocks both the alternative "closed-point + 00OF" route mentioned in the `isRegularLocalRing_stalk_of_smooth` body comments and the Stage 6.C cascade.

Severity: **soon** (incorrect factual claim about Mathlib API state; current lane is not actively using this path, but the blueprint misleads the iter-202+ planner about a viable route).

### Iter-201 Step A2 sub-substrates absent from blueprint narrative

Three new axiom-clean `private` theorems landed in iter-201 are not mentioned anywhere in the blueprint chapter:

| Declaration | Line | Role |
|---|---|---|
| `submersivePresentation_relation_cotangent_mk_linearIndependent` | L854 | A2 sub-substrate: basis-form lin-indep → `Cotangent.mk` form |
| `submersivePresentation_relation_cotangent_mk_linearIndependent_localized` | L889 | A2 sub-substrate: transport lin-indep through localisation map |
| `ringKrullDim_quotient_localization_MvPolynomial_of_regular` | L924 | Steps 1+2+3 composite at polynomial-ring setting |

Being `private`, no `\lean{...}` pins are required. However, the blueprint's `\subsec:stage6_iib_substrate_iter200` (added in iter-201) describes the A2 step as monolithic ("transport `Algebra.SubmersivePresentation.basisCotangent`'s linear-independence statement from I/I² over S to m_A/m_A² over κ(m_A) on the localisation A = P.Ring_{m'}. Uses `LinearIndependent.of_isLocalizedModule_of_isRegular` … + the conormal-localisation iso") without distinguishing:
- the two A2 sub-substrates already axiom-clean (#1 and #2 above), from
- the residual A2 gap (the conormal-localisation iso for `AtPrime`, a separate Mathlib gap not landed this iter).

An iter-202+ prover reading the chapter cannot tell what fraction of A2 is done. Similarly, #3 (`ringKrullDim_quotient_localization_MvPolynomial_of_regular`) — which directly packages the iter-200 Steps 1+2+3 composite for the polynomial-ring setting — is not mentioned.

Severity: **soon**.

### Step A1 Mathlib gaps not flagged in blueprint recipe

The blueprint's `\subsec:stage6_iib_substrate_iter200` Step A1 recipe states the Matsumura helper proof by induction on c, with the ingredient "`IsSMulRegular` on the non-zero-divisor f₁ via `IsRegularLocalRing ⇒ IsDomain + f₁ ≠ 0`". This silently requires `IsRegularLocalRing → IsDomain` (Stacks 00NQ), which the iter-201 prover explicitly confirmed is **absent** from Mathlib `b80f227` (the only `IsRegularLocalRing` instance in Mathlib goes the reverse direction: PIDs are regular).

The prover also confirmed that `A / (f₁) → IsRegularLocalRing` preservation (the A1 inductive step's "ring stays regular") is absent from Mathlib.

Neither gap is flagged as a Mathlib gap in the blueprint recipe. An iter-202+ prover following the Step A1 recipe would hit both gaps without warning.

The blueprint's recipe says "\textbf{A1 — Matsumura helper} (~30--50 LOC, Mathlib upstream PR candidate)". This LOC estimate is now wrong: the two Mathlib gaps (Stacks 00NQ forward direction + RLR preservation under quotient by a regular element) are each ~100--200 LOC projects in their own right, for a realistic iter-202+ cost closer to 300--500 LOC total before A1 is axiom-clean.

Severity: **soon**.

---

## Unreferenced declarations (informational)

The following iter-201 `private` additions have no `\lean{...}` pin (acceptable for private decls) and are the core new content of this iter:

| Declaration | Line | Axiom-clean | Blueprint coverage |
|---|---|---|---|
| `submersivePresentation_relation_cotangent_mk_linearIndependent` | L854 | yes | absent (see Red Flags) |
| `submersivePresentation_relation_cotangent_mk_linearIndependent_localized` | L889 | yes | absent |
| `ringKrullDim_quotient_localization_MvPolynomial_of_regular` | L924 | yes | absent |

All previously-listed unreferenced declarations from iter-200 remain unchanged (see the iter-200 report for the full table).

---

## Blueprint adequacy for this file

- **Coverage**: 12/12 public `\lean{...}`-pinned declarations have a Lean target that exists (or are intentionally absent). 0 missing public targets. The 3 new iter-201 private additions are not pinned (correct for private decls). Coverage is adequate for `sync_leanok`.

- **Proof-sketch depth**: **under-specified** for the iter-202+ prover at the Step A level. The blueprint's `\subsec:stage6_iib_substrate_iter200` describes the A1+A2+A3 recipe but:
  - Does not flag `IsRegularLocalRing → IsDomain` (Stacks 00NQ) or `A/(f₁) → IsRegularLocalRing` as Mathlib gaps in the A1 recipe.
  - Does not identify which portions of A2 are axiom-clean (#1 and #2, landed iter-201) vs. which are still open (conormal-localisation iso for `AtPrime`).
  - Does not mention `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (#3), the direct Steps-1+2+3 composite consumer.
  - Incorrectly claims `IsRegularLocalRing.localization_isRegularLocalRing` (Stacks 00OF) EXISTS in Mathlib when it does not.
  - All other proof sketches (lemmas for the 6 public pinned declarations) are adequate.

- **Hint precision**: **loose for Stage 6.A recipe** (as flagged in iter-200 report, partially addressed by addition of `\subsec:stage6_iib_substrate_iter200` but not yet updated to reflect iter-201 partial A2 progress). All other pins are precise.

- **Generality**: matches need. No parallel API written outside the blueprint's generality.

- **Recommended chapter-side actions**:
  1. (**soon**) Correct the API state entry for `IsRegularLocalRing.localization_isRegularLocalRing`: change "EXISTS" to "MISSING at b80f227 (verified by iter-201 prover grep of `Mathlib/RingTheory/RegularLocalRing/`; only `Defs.lean` present)". This is a wrong factual claim, not a style issue.
  2. (**soon**) Add a note in Step A1 that `IsRegularLocalRing → IsDomain` (Stacks 00NQ) and `A/(f₁) → IsRegularLocalRing` preservation are Mathlib gaps at `b80f227`, estimated ~100--200 LOC each — not ~0 LOC "use existing API" steps. Revise the A1 LOC estimate to ~300--500 LOC total.
  3. (**soon**) Split the Step A2 description to distinguish: (a) what is axiom-clean (`submersivePresentation_relation_cotangent_mk_linearIndependent` and `…_localized`, both landed iter-201) vs. (b) what is still open (conormal-localisation iso for `IsLocalization.AtPrime`, a separate Mathlib gap, not `Localization.Away`).
  4. (**soon**) Mention `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (iter-201, L924) as the Step 1+2+3 composite consumer for the polynomial-ring setting: once Step A is in hand, this is the one-line close for the polynomial-ring Krull-dimension goal.
  5. (**minor**) The stale docstring name error at Lean L659 (`ringKrullDim_quotient_isRegular_eq_sub_length` vs. the actual `ringKrullDim_quotient_add_eq_of_regular_sequence`) was flagged iter-200; still present iter-201.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint API state: `IsRegularLocalRing.localization_isRegularLocalRing` marked "EXISTS" but empirically MISSING in Mathlib b80f227 | **soon** |
| Step A1 recipe omits `IsRegularLocalRing → IsDomain` (Stacks 00NQ) and `A/(f₁)→RLR` as Mathlib gaps; LOC estimate wrong by 5-10× | **soon** |
| 3 new iter-201 `private` substrate lemmas absent from blueprint narrative; A2 done-vs-open split not described | **soon** |
| Stale Lean docstring name at L659 (wrong decl name for Step 3 re-export — iter-200 carry-over) | **minor** |
| `\lean{...}` pins referencing `private` declarations (name-resolution caveat for `sync_leanok`, pre-existing) | **minor** |

**No must-fix-this-iter findings.** All 12 `\lean{...}`-pinned public declarations resolve to existing Lean targets with correct signatures. The 3 open sorries (L1179, L1376, L1451) are correctly tracked in both Lean and blueprint.

**Overall verdict**: Lean side is sound for iter-201 — 12/12 `\lean{...}`-pinned declarations resolved, 3 sorries correctly tracked, 3 new substrate lemmas axiom-clean. Blueprint is stale in the Step A recipe: it incorrectly flags a Mathlib declaration as existing (Stacks 00OF), underestimates A1 cost by omitting two substantive Mathlib gaps, and does not distinguish A2 done vs. open sub-pieces.
