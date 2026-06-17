# Lean ↔ Blueprint Check Report

## Slug
coe-iter200

## Iteration
200

## Files audited
- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (1420 lines)
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (1372 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` (def:indeterminacy_locus)
- **Lean target exists**: yes (L146, public `def`)
- **Signature matches**: yes — `(f.domain : Set X)ᶜ` matches blueprint's `X \ Dom(f)`
- **Proof follows sketch**: N/A (definition, not a theorem)
- **notes**: Companion `isClosed_indeterminacyLocus` lemma at L151 (axiom-clean) is present but not blueprint-pinned — acceptable as a helper.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` (def:codim_one_indeterminacy)
- **Lean target exists**: yes (L180, public `def`)
- **Signature matches**: yes — `∀ (x : X), Order.coheight x = 1 → x ∈ f.domain` matches blueprint encoding
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}` (lem:module_free_kaehler_localization)
- **Lean target exists**: yes (L325, **private** theorem)
- **Signature matches**: yes — `Module.Free S (Ω[S⁄R]) → ... → Module.Free Sₘ (Ω[Sₘ⁄R])` matches blueprint statement
- **Proof follows sketch**: yes — proof uses `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule`, exactly as the blueprint describes
- **notes**: Declaration is `private`; `\lean{...}` pin uses the non-mangled name. If `sync_leanok` resolves private names from within the same module, this is fine; if it requires a public name, the `\leanok` marker may silently mis-track. Pre-existing issue since iter-193.

### `\lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}` (lem:rank_kaehler_localization_eq_relative_dim)
- **Lean target exists**: yes (L351, **private** theorem)
- **Signature matches**: yes — `Module.rank Sₘ (Ω[Sₘ⁄R]) = n` under `IsStandardSmoothOfRelativeDimension n R S` + `IsLocalization M Sₘ`; matches blueprint
- **Proof follows sketch**: yes — uses `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` + `Module.lift_rank_of_isLocalizedModule_of_free`, as blueprint describes
- **notes**: Same `private`-name caveat as the previous entry.

### `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` (lem:smooth_algebra_krull_dim_formula / Stage 6.A)
- **Lean target exists**: no — this name does NOT appear in the Lean file; it is the planned Mathlib upstream declaration
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: Blueprint block carries no `\leanok`, which is correct (not yet formalized). The block description still says "MISSING in Mathlib; NEEDS-BRIDGE; ~200-300 LOC" but iter-200 landed Steps 1 and 2 of this chain axiom-clean (see Red Flags below). No blocking issue for this declaration entry itself, but the prose is stale.

### `\lean{AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue}` (lem:cotangent_kahler_over_field / Stage 6.B)
- **Lean target exists**: yes (L476, **private noncomputable def**)
- **Signature matches**: yes — produces `(RingHom.ker (algebraMap Sₘ κ)).Cotangent ≃ₗ[Sₘ] TensorProduct Sₘ κ Ω[Sₘ⁄R]` under `[FormallySmooth R Sₘ] [FormallySmooth R κ] [Subsingleton Ω[κ⁄R]]`; matches the closed-point Stacks-02JK iso in blueprint
- **Proof follows sketch**: yes — three-step recipe (retraction → injection, Ω[κ⁄R]=0 + exactness → surjection, bijective → iso) matches the analogist recipe referenced in the docstring
- **notes**: `private noncomputable def`. Same name-resolution caveat. The `\lean{...}` comment notes the four iter-199 companion siblings (`…maximalIdeal…`, `finrank_cotangentSpace_of_formallySmooth_residue`, `…of_bijective_algebraMap_residue`); these are axiom-clean at L527–L629 and support the assembly in `isRegularLocalRing_stalk_of_smooth`.

### `lem:stage6_regular_stalk_assembly` (Stage 6.C — intentionally no `\lean{...}` pin)
- **Lean target exists**: N/A (no standalone decl; per the iter-199 NOTE the closure is the body of `isRegularLocalRing_stalk_of_smooth`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The iter-199 blueprint NOTE at this block correctly describes the situation: the planned `_aux` extraction was not made; the in-body closure pattern within `isRegularLocalRing_stalk_of_smooth` is the operative record. This is accurate and intentional.

### `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` (lem:smooth_to_regular_local_ring)
- **Lean target exists**: yes (L937, **private** theorem)
- **Signature matches**: yes — `[Smooth X.hom] ... (z : X.left) : IsRegularLocalRing (X.left.presheaf.stalk z)` matches blueprint's "smooth over k̄ ⇒ regular local stalk"
- **Proof follows sketch**: partial — Stages 1–5b plus the Stage 6.B-RHS substrate are axiom-clean in the body; the remaining `sorry` at L1061 represents the Stacks-00OE sub-gap (ii.B) Krull-dimension formula, which the blueprint correctly tracks as the open gap
- **notes**: `private` declaration, same caveat. `\leanok` on statement block only (correct — declaration is skeletonized, proof incomplete). The body is well-commented with the closure pattern for post-(ii.B).

### `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` (lem:smooth_codim_one_dvr)
- **Lean target exists**: yes (L1150, **public** theorem)
- **Signature matches**: yes — `Order.coheight z = 1 → IsDiscreteValuationRing (X.left.presheaf.stalk z)` under smooth integral variety hypotheses; matches blueprint
- **Proof follows sketch**: yes — chains `isRegularLocalRing_stalk_of_smooth` + `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` + `IsDiscreteValuationRing.TFAE`, as the blueprint's proof sketch describes
- **notes**: Inherited sorry from `isRegularLocalRing_stalk_of_smooth`. The `\leanok` on the statement block is correct.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` (thm:codim_one_extension)
- **Lean target exists**: yes (L1219, **public** theorem)
- **Signature matches**: yes — `CodimOneFree f → ∃! (g : X.left ⟶ Y.left), g.toRationalMap = f` under smooth source + complete target; matches blueprint
- **Proof follows sketch**: partial — Step 1 (DVR + valuative criterion) and Step 2 (depth-≥2 local-cohomology) are both structural sorries at L1258; the body comment accurately records both gaps (Stacks 0AVF + Stage 6 chain)
- **notes**: `\leanok` on statement block. Body has 1 `sorry`.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` (lem:milne_codim1_indeterminacy)
- **Lean target exists**: yes (L1287, **public** theorem)
- **Signature matches**: yes — `indeterminacyLocus f = ∅ ∨ ∀ x ∈ indeterminacyLocus f, ∃ z, Order.coheight z = 1 ∧ x ∈ closure {z}`; matches blueprint
- **Proof follows sketch**: partial — 4-substep proof is a structural `sorry` at L1333; body comment documents substeps and the Mathlib gap (function-field pullback + Krull HPP intersection with diagonal)
- **notes**: `\leanok` on statement block. Body has 1 `sorry`.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` (lem:mem_domain_partial_map_reshuffle)
- **Lean target exists**: yes (L1399, **public** theorem)
- **Signature matches**: yes — `W.point ∈ f.domain ↔ ∃ g, g.toRationalMap = f ∧ W.point ∈ g.domain`; matches blueprint reshuffle lemma
- **Proof follows sketch**: yes — definitional `rw [Scheme.RationalMap.mem_domain]` + conjunction swap; matches blueprint description
- **notes**: Axiom-clean. `\leanok` correctly appears on both statement and proof blocks (proof is a 2-LOC tautological reshuffle).

---

## Red flags

### Stale name reference in Lean module docstring
- `CodimOneExtension.lean:659–661`: The module-level docstring inside the Stage 6 sub-gap section says the iter-200 Step 3 output is `ringKrullDim_quotient_isRegular_eq_sub_length`, but the actual declaration at L807 is `ringKrullDim_quotient_add_eq_of_regular_sequence`. The name in the docstring is wrong; the actual Lean code uses the correct name. Informational stale-comment in the header block.

### 7 iter-200 substrate decls missing from blueprint
All seven new `private` substrate theorems added in iter-200 are absent from the blueprint chapter:
- `ringKrullDim_localization_eq_height_atPrime` (L673)
- `MvPolynomial.maximalIdeal_height_ge_card_of_field` (L698)
- `MvPolynomial.maximalIdeal_height_le_natCard_of_field` (L717)
- `MvPolynomial.maximalIdeal_height_eq_card` (L727)
- `MvPolynomial.maximalIdeal_height_eq_natCard` (L743)
- `ringKrullDim_localization_atMaximal_MvPolynomial` (L774)
- `ringKrullDim_quotient_add_eq_of_regular_sequence` (L807)

Being `private`, they would not normally require individual `\lean{...}` pins. However, the prover handoff for iter-200 explicitly recommended (a) adding pins with `AlgebraicGeometry.Scheme.` prefix, (b) adding subsection `\subsec:stage6_iib_substrate_iter200`, and (c) updating the Stage 6.A description. None of these three actions were carried out in the blueprint. The practical consequence: the blueprint's `lem:smooth_algebra_krull_dim_formula` block still reads "MISSING in Mathlib; NEEDS-BRIDGE; ~200-300 LOC" when Steps 1 and 2 are fully axiom-clean in the project file and Step 3 is partially scaffolded.

### Blueprint Stage 6.A description stale post iter-200
The `lem:smooth_algebra_krull_dim_formula` Mathlib API state paragraph (blueprint L459–517) says the Stacks 00OE bridge "NEEDS-BRIDGE; project build of ~200-300 LOC." This is now misleading: iter-200 closed Step 1 (trivial 1-line re-export) and Step 2 (polynomial-ring height by `Fin n` induction + general finite ι transport) fully axiom-clean. Only Step 3 (the Jacobian-criterion regular-sequence witness) is residual. The prose overstates the remaining work by roughly an order of magnitude.

---

## Unreferenced declarations (informational)

The following non-trivial `private` declarations in the Lean file have no `\lean{...}` pin but are substantive contributions (all iter-191–200 substrate):

| Declaration | Line | Status | Notes |
|---|---|---|---|
| `stalkMap_flat_of_smooth` | 227 | axiom-clean | Stage 1, iter-191; helper to `isRegularLocalRing_stalk_of_smooth` |
| `exists_isStandardSmooth_at_of_smooth` | 244 | axiom-clean | Stage 2, iter-191 |
| `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth` | 273 | axiom-clean | Stage 3, iter-192 |
| `module_free_kaehlerDifferential_of_isStandardSmooth` | 304 | axiom-clean | Stage 4, iter-192 |
| `module_free_kaehlerDifferential_localization` | 325 | axiom-clean | Stage 5a, **already `\lean{...}`-pinned** |
| `rank_kaehlerDifferential_localization_eq_relativeDimension` | 351 | axiom-clean | Stage 5b, **already pinned** |
| `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` | 393 | axiom-clean | Stage 6.B-RHS, iter-198 |
| `finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension` | 423 | axiom-clean | Stage 6.B-RHS alt, iter-198 |
| `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` | 476 | axiom-clean | Stage 6.B, **already pinned** |
| `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue` | 527 | axiom-clean | Stage 6.B-repackaged, iter-199 |
| `finrank_cotangentSpace_of_formallySmooth_residue` | 563 | axiom-clean | Stage 6.B-finrank, iter-199 |
| `finrank_cotangentSpace_of_bijective_algebraMap_residue` | 615 | axiom-clean | Stage 6.B-bundled, iter-199 |
| `ringKrullDim_localization_eq_height_atPrime` | 673 | axiom-clean | **iter-200 Step 1** |
| `MvPolynomial.maximalIdeal_height_ge_card_of_field` | 698 | axiom-clean | **iter-200 Step 2 LB** |
| `MvPolynomial.maximalIdeal_height_le_natCard_of_field` | 717 | axiom-clean | **iter-200 Step 2 UB** |
| `MvPolynomial.maximalIdeal_height_eq_card` | 727 | axiom-clean | **iter-200 Step 2 Fin n** |
| `MvPolynomial.maximalIdeal_height_eq_natCard` | 743 | axiom-clean | **iter-200 Step 2 general** |
| `ringKrullDim_localization_atMaximal_MvPolynomial` | 774 | axiom-clean | **iter-200 Steps 1+2 capstone** |
| `ringKrullDim_quotient_add_eq_of_regular_sequence` | 807 | axiom-clean | **iter-200 Step 3 additive re-export** |
| `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth` | 834 | axiom-clean | Stage 6 sub-gap (i) resolution, iter-198 |
| `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` | 1082 | sorry (inherited) | helper to `localRing_dvr_of_codim_one` |

The 7 iter-200 additions (bold) are substantive enough to warrant documentation in the blueprint given the prover handoff's explicit recommendation.

---

## Blueprint adequacy for this file

- **Coverage**: 12/12 `\lean{...}`-pinned declarations have a corresponding Lean target that exists (or are intentionally absent with `no \leanok`); all 6 public blueprint-pinned declarations exist. **0 missing public targets.** The 7 iter-200 `private` additions are not pinned (prover-recommended but not required per normal convention). Coverage is adequate for `sync_leanok` purposes; the uncovered iter-200 substrate is a documentation gap.

- **Proof-sketch depth**: **under-specified** for the iter-201+ target. Specifically:
  - `lem:smooth_algebra_krull_dim_formula` (Stage 6.A): the blueprint's proof sketch says "NEEDS-BRIDGE; ~200-300 LOC" without the Step 1/2/3 breakdown visible in the Lean docstring. An iter-201+ prover reading only the blueprint would not know that Steps 1+2 are done and Step 3 needs a Jacobian-criterion regular-sequence witness.
  - The Jacobian witness ingredients (`Algebra.SubmersivePresentation.jacobian_isUnit`, `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`, Stacks 00SW/00OW) are documented in the Lean module docstring (L631–662 and L1021–1060) but appear nowhere in the blueprint chapter.
  - All other proof sketches (`lem:smooth_codim_one_dvr`, `lem:milne_codim1_indeterminacy`, `lem:mem_domain_partial_map_reshuffle`, etc.) are adequate.

- **Hint precision**: **loose for Stage 6.A**. The `\lean{...}` pin `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension` names a planned Mathlib upstream target; the actual project-side building blocks are the 7 private iter-200 helpers (and predecessors). The blueprint does not help a prover understand which private helpers are already axiom-clean vs. still open. All other pins are precise.

- **Generality**: **matches need** for all existing declarations. No parallel API written outside the blueprint's generality.

- **Recommended chapter-side actions**:
  1. (**soon**) Add a new subsection (e.g. `\subsec{Stage 6.A Stacks 00OE substrate — iter-200}`) documenting the 3-step breakdown of the Stacks 00OE chain, noting Steps 1+2 are axiom-clean (citing the 7 private helpers by name for reference) and Step 3 is the residual.
  2. (**soon**) Update the "Mathlib API state" paragraph inside `lem:smooth_algebra_krull_dim_formula` to reflect that "NEEDS-BRIDGE; ~200-300 LOC" is now inaccurate: Steps 1+2 are done; Step 3 requires the Jacobian-regular-sequence witness (~50–100 LOC involving `SubmersivePresentation.jacobian_isUnit`).
  3. (**soon**) Sketch the Jacobian-witness recipe for iter-201+ in the chapter: cite Stacks 00SW/00OW, name the Mathlib hooks (`Algebra.SubmersivePresentation.jacobian_isUnit`, `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`), and indicate that `ringKrullDim_quotient_add_eq_of_regular_sequence` (L807) is ready to consume the witness once it lands.
  4. (**minor**) Optionally add `\lean{...}` pins (with `AlgebraicGeometry.Scheme.` prefix) to the 7 new `private` helpers, or at minimum add a `% NOTE:` enumerating their names, so future blueprint-doctor runs can track them.
  5. (**minor**) Fix the stale name in the Lean module docstring at L659: `ringKrullDim_quotient_isRegular_eq_sub_length` → `ringKrullDim_quotient_add_eq_of_regular_sequence`. (This is a Lean-side doc fix, not a blueprint fix.)

---

## Chapter completeness for iter-201+ prover (Directive item 3)

**Short answer: NO — the chapter does not currently sketch the Jacobian-regular-sequence recipe. Flag for plan-agent expansion.**

The iter-201+ substantive Lane COE effort is to close `isRegularLocalRing_stalk_of_smooth`'s L1061 `sorry` by providing the Jacobian-criterion regular-sequence witness. The Lean file's module docstring (L631–662) and in-body comment (L1021–1060) document this clearly:

> The Jacobian-criterion regular-sequence witness is the substantive residual obligation; landing it requires `Algebra.SubmersivePresentation.jacobian_isUnit` + `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal` scaffolding which is iter-201+ Lane COE substrate.

The blueprint chapter, by contrast, provides only the generic "Stacks 00OE, NEEDS-BRIDGE" description under `lem:smooth_algebra_krull_dim_formula`. An iter-201+ prover reading the blueprint in isolation would not know:
- That Step 1 (trivial) and Step 2 (polynomial height induction) are already done
- That Step 3 is specifically about a regular-sequence witness for the standard-smooth presentation, not a transcendence-degree computation
- Which Mathlib declarations to target (`SubmersivePresentation.jacobian_isUnit`, etc.)
- That `ringKrullDim_quotient_add_eq_of_regular_sequence` (iter-200, axiom-clean) is the ready consumer

**Recommendation for plan-agent**: dispatch blueprint-writer to add the Step 3 recipe to the chapter. The Lean docstring at L631–662 is the authoritative source; the blueprint should replicate (in informal prose) the same 3-step breakdown and name the residual Mathlib hooks.

---

## Severity summary

| Finding | Severity |
|---|---|
| 7 iter-200 `private` substrate decls missing from blueprint (no pins, no subsection) | **soon** |
| Blueprint Stage 6.A description stale ("NEEDS-BRIDGE; ~200-300 LOC" after Step 1+2 closed) | **soon** |
| No Jacobian-witness recipe in blueprint for iter-201+ prover | **soon** |
| Stale name in Lean module docstring (L659: wrong decl name for Step 3 re-export) | **minor** |
| `\lean{...}` pins to `private` declarations (name-resolution caveat, pre-existing) | **minor** |

**No must-fix-this-iter findings.** All 6 public pinned Lean declarations exist with correct signatures. The 3 open sorries are correctly tracked. The only failures are blueprint-adequacy failures for the iter-201+ prover.

**Overall verdict**: Lean side is sound for iter-200 — 12/12 `\lean{...}`-pinned declarations resolved, 3 sorries unchanged and correctly tracked, all 7 new iter-200 substrate lemmas axiom-clean. Blueprint is lagging: Stage 6.A description is stale after iter-200 progress, and the chapter gives no recipe for the iter-201+ Jacobian-witness target. Plan agent should dispatch a blueprint-writer to add the Step 3 Jacobian recipe and update the Stage 6.A description.
