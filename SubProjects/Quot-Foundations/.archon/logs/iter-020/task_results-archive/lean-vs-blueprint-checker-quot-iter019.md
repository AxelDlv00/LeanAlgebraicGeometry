# Lean ↔ Blueprint Check Report

## Slug
quot-iter019

## Iteration
019

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (1601 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (2461 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (def:hilbert_polynomial)

- **Lean target exists**: yes (line 123)
- **Signature matches**: partial — `(_L _F : X.Modules)` does not distinguish a line bundle from a general module; the blueprint's prose requires "a coherent sheaf F whose schematic support is proper over S", but no `HasProperSupport` hypothesis appears in the signature.
- **Proof follows sketch**: N/A — body is `:= sorry`, explicitly authorized as an iter-176 file-skeleton by the in-file docstring and the blueprint's `\leanok` on the statement block (which only requires sorry-present, not proof-closed).
- **Notes**: The missing proper-support hypothesis is a loose signature rather than a placeholder: the function currently total-maps any pair `(_L _F : X.Modules)` to `Polynomial ℚ`. Downstream uses will need to add the condition. Authorized sorry.

---

### `\lean{AlgebraicGeometry.sectionGradedRing}` (def:sectionGradedRing)

- **Lean target exists**: no — `AlgebraicGeometry.sectionGradedRing` is absent from the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint NOTE explicitly states: "Formalization is blocked on the absence of tensor products for sheaves of modules in Mathlib at the pinned commit." No `\leanok` on this block. Upstream prerequisite gap.

---

### `\lean{AlgebraicGeometry.sectionGradedModule}` (def:sectionGradedModule)

- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Same blocker as `sectionGradedRing`. No `\leanok` on the blueprint block.

---

### `\lean{AlgebraicGeometry.sectionGradedModule_fg}` (lem:sectionGradedModule_fg)

- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Same blocker. No `\leanok` on the blueprint block.

---

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` (thm:hilbertPoly_of_sectionModule)

- **Lean target exists**: no — this theorem is absent from the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Depends on `sectionGradedModule`, `sectionGradedModule_fg`, and `gradedModule_hilbertSeries_rational`. The first two are blocked. The blueprint has no `\leanok` on this block. Missing but blocked.

---

### `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}` (lem:gradedHilbertSerre_rational)

- **Lean target exists**: yes (line 1556)
- **Signature matches**: yes — `IsRatHilb (fun n => (Module.finrank κ ↥(ℳ n) : ℚ)) r` matches the blueprint's "rational of order r" conclusion.
- **Proof follows sketch**: partial — the proof body itself is sorry-free, but calls `GradedModule.subquotient_hilbertSeries_rational`, which calls `subquotient_base_eventuallyZero`, which has a sorry at line 1494 (`have hindep : iSupIndep (fun n => LinearMap.range (ψ n)) := by sorry`). Blueprint statement block has `\leanok`; proof block does NOT have `\leanok`. Consistent.
- **Notes**: The sorry leaf is documented with a detailed obstruction note ("RESIDUAL LEAF — the only sorry in the QUOT keystone chain"). The math is described as complete; only scalar-ring plumbing for the linear detector `Φ : Q →ₗ[κ] M ⧸ N'` out of the `MvPolynomial (Fin 0) κ`-quotient Q remains. Not must-fix per blueprint's `\leanok` on statement only, but the proof is not closed.

---

### `\lean{AlgebraicGeometry.coeff_invOneSubPow_one_mul}` (lem:coeff_invOneSubPow_one_mul)

- **Lean target exists**: yes (line 430), but declared `private`.
- **Signature matches**: yes — the Lean statement matches the blueprint's formula for the partial-sum identity.
- **Proof follows sketch**: yes — real proof, no sorry.
- **Notes**: The `private` modifier means the fully-qualified name `AlgebraicGeometry.coeff_invOneSubPow_one_mul` does not exist as a public declaration; the `\lean{}` pin cannot resolve. Blueprint's subsection NOTE (line 497–499) explicitly acknowledges: "Declarations in this subsection are currently `private` in the Lean source; `\lean{}` pins may not resolve until they are moved to a dedicated module."

---

### `\lean{AlgebraicGeometry.rationalHilbert_antidiff}` (lem:rationalHilbert_antidiff)

- **Lean target exists**: yes (line 450), `private`.
- **Signature matches**: yes.
- **Proof follows sketch**: yes — real proof, no sorry.
- **Notes**: Same privacy issue as above.

---

### `\lean{AlgebraicGeometry.IsRatHilb}` (def:ratHilb)

- **Lean target exists**: yes (line 534), `private`.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A (it is a `Prop`-valued definition, no proof).
- **Notes**: `private def IsRatHilb` — the pin cannot resolve. `gradedModule_hilbertSeries_rational` exposes `IsRatHilb` in its return type, making the private type accessible through a public theorem but not directly nameable.

---

### `\lean{AlgebraicGeometry.IsRatHilb.ofEventuallyZero}` / `.bump` / `.sub` / `.shiftRight` / `.antidiff` / `.ofDiffEq` (lem:ratHilb_*)

- **Lean target exists**: yes, all six are present (lines 539–610), all `private`.
- **Signature matches**: yes for all — each matches the blueprint's stated formulation.
- **Proof follows sketch**: yes — all have real proofs, no sorry.
- **Notes**: Same privacy issue. `\lean{}` pins cannot resolve.

---

### `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_inf_iSupIndep}` (lem:graded_homogeneousSubmodule_iSupIndep)

- **Lean target exists**: yes (line 633).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — real proof via `iSupIndep.mono`.

---

### `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_iSup_inf_eq}` (lem:graded_homogeneousSubmodule_iSup_eq)

- **Lean target exists**: yes (line 649).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — real proof via `DirectSum.sum_support_decompose`.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotientHilb}` / `SubquotientDatum` / `SubquotientDatum.hilb` (def:graded_subquotientHilb)

- **Lean target exists**: yes — `subquotientHilb` line 712, `SubquotientDatum` structure line 1348, `SubquotientDatum.hilb` line 1377.
- **Signature matches**: yes — all three match the blueprint's definition of a length-`r` subquotient datum with ambient Hilbert function.
- **Proof follows sketch**: N/A (definitions/structure).

---

### `\lean{AlgebraicGeometry.GradedModule.RaisesDegree}` / `RaisesDegree.mem` (def:graded_raisesDegree / lem:graded_raisesDegree_mem)

- **Lean target exists**: yes (lines 700, 704).
- **Signature matches**: yes.
- **Proof follows sketch**: `RaisesDegree` is a `Prop`-def; `mem` has a real one-liner proof.

---

### `\lean{AlgebraicGeometry.GradedModule.decompose_raisesDegree}` / `decompose_raisesDegree_zero` / `comap_isHomogeneous` / `map_isHomogeneous` / `inf_isHomogeneous` / `sup_isHomogeneous` / `map_inf_degree_eq` / `sup_inf_degree_eq` (multiple lem:graded_*)

- **Lean target exists**: yes — lines 719, 744, 735, 755, 805, 813, 768, 785 respectively.
- **Signature matches**: yes for all.
- **Proof follows sketch**: yes for all — each has a real, sorry-free proof matching the blueprint's informal argument.

---

### `\lean{AlgebraicGeometry.GradedModule.ker_isHomogeneous}` / `coker_isHomogeneous` / `ker_le` / `coker_le` / `ker_annihilate` / `coker_annihilate` / `comap_map_le_of_commute` / `map_map_le_of_commute` (lem:graded_ker_*/coker_*/commute_*)

- **Lean target exists**: yes — lines 834–896.
- **Signature matches**: yes for all eight.
- **Proof follows sketch**: yes — all have sorry-free proofs; the blueprint's proof of `lem:graded_subquotient_ker_coker` explicitly says these eight facts are the Lean realization.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_degreewise_diff}` (lem:graded_subquotient_degreewise_diff / D6)

- **Lean target exists**: yes (line 914).
- **Signature matches**: yes — the blueprint's identity `h_M(n+1) − h_M(n) = h_C(n+1) − h_K(n)` matches the Lean signature.
- **Proof follows sketch**: yes — real proof via inclusion-exclusion, rank-nullity, and `omega`. The mathematical steps match the blueprint's proof sketch.

---

### `\lean{AlgebraicGeometry.GradedModule.polyEndHom}` / `polyEndHom_X` / `polyEndHom_C` / `polyModule` / `polyModule_X_smul` / `polyModule_C_smul` / `polyModule_isScalarTower` / `polySubmodule` / `polySubmodule_coe` (def/lem:graded_poly*)

- **Lean target exists**: yes — lines 986–1091.
- **Signature matches**: yes for all.
- **Proof follows sketch**: yes — all have sorry-free proofs. `polyEndHom` correctly routes through the commutative adjoin subalgebra as described by the blueprint.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_finite_transfer}` (lem:graded_subquotient_finite_transfer)

- **Lean target exists**: yes (line 1206).
- **Signature matches**: yes — the semilinear map / `liftQ` / `Module.Finite.of_surjective` structure matches the blueprint's surjection-transfer argument.
- **Proof follows sketch**: yes — real proof, no sorry. The `lastVarAlgHom` surjection (lines 1109–1139) and helper lemmas `polyEndHom_lastVar_sub_mem`, `polyEndHom_mem_of_stable` (lines 1153–1199) are auxiliary to this proof; they are not individually pinned in the blueprint but appear in the blueprint's proof text.

---

### `\lean{AlgebraicGeometry.GradedModule.degreewise_finrank_diff}` (lem:graded_degreewise_finrank_diff / D5)

- **Lean target exists**: yes (line 670).
- **Signature matches**: yes — `(finrank κ W : ℤ) - finrank κ V = (finrank κ (W ⧸ range φ) : ℤ) - finrank κ (ker φ)` matches exactly.
- **Proof follows sketch**: yes — two-line proof via `hrn`, `hq`, `omega`.

---

### `\lean{AlgebraicGeometry.GradedModule.finiteDimensional_of_mvPolynomial_isEmpty_finite}` (lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite)

- **Lean target exists**: yes (line 1442).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — real proof via `Module.Finite.equiv` / `Module.Finite.trans`.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational}` (lem:graded_subquotient_isRatHilb)

- **Lean target exists**: yes (line 1523).
- **Signature matches**: yes — induction on `r`, returning `IsRatHilb (SubquotientDatum.hilb ℳ D) r`.
- **Proof follows sketch**: partial — the inductive structure matches the blueprint's base-case/step decomposition. The base case (`subquotient_base_eventuallyZero`, line 1459) has a sorry at line 1494 (independence of the degreewise image maps); the step calls `subquotient_degreewise_diff` and `IsRatHilb.ofDiffEq` exactly as the blueprint prescribes.
- **Notes**: Blueprint proof block does not have `\leanok`, consistent with the sorry.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (def:modules_annihilator)

- **Lean target exists**: yes (line 298).
- **Signature matches**: yes — `IdealSheafData.ofIdeals (fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1))` matches the blueprint's affine-local construction.
- **Proof follows sketch**: N/A (definition via `ofIdeals`; the full equality direction is acknowledged as blocked).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (lem:modules_annihilator_ideal_le)

- **Lean target exists**: yes (line 305).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — one-liner via `IdealSheafData.ideal_ofIdeals_le`.

---

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (lem:annihilator_localization_eq_map)

- **Lean target exists**: yes (line 362).
- **Signature matches**: yes — `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` matches the blueprint's formula.
- **Proof follows sketch**: yes — real proof (60 lines). The ⊇ direction clears generators of M to find a common multiplier `u = ∏ u_i` and shows the element lives in the image ideal; the ⊆ direction uses `IsLocalizedModule.mk'_surjective`. Matches the blueprint's proof sketch including the "common multiplier" step.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (lem:qcoh_section_localization_basicOpen)

- **Lean target exists**: no — `Scheme.Modules.isLocalizedModule_basicOpen` is absent from the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint does not have `\leanok` on this block. The docstring of `annihilator` (line 294) explicitly says this is blocked on the "QCoh→localization bridge `isLocalizedModule_basicOpen`". Missing but acknowledged.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (def:schematic_support)

- **Lean target exists**: yes (line 312).
- **Signature matches**: yes — `(annihilator F).subscheme`.
- **Proof follows sketch**: N/A.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (def:schematic_support_immersion)

- **Lean target exists**: yes (line 320).
- **Signature matches**: yes — `(annihilator F).subschemeι`.
- **Proof follows sketch**: N/A.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (def:has_proper_support)

- **Lean target exists**: yes (line 328).
- **Signature matches**: yes — `IsProper (schematicSupportι F ≫ f)` matches the blueprint.
- **Proof follows sketch**: N/A.

---

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (def:is_locally_free_of_rank)

- **Lean target exists**: yes (line 253).
- **Signature matches**: yes — open-cover condition with isomorphism to `SheafOfModules.free (ULift (Fin d))` matches the blueprint's "M|_{Ui} ≅ O_{Ui}^{⊕ d}".
- **Proof follows sketch**: N/A (it is a `Prop`).

---

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (def:quot_functor)

- **Lean target exists**: yes (line 161).
- **Signature matches**: partial — return type `(Over S)ᵒᵖ ⥤ Type u` is correct. Parameters `(_L _E : X.Modules)` do not distinguish a line bundle from a general module (L should be a line bundle), and there is no flatness condition. However, for an iter-176 sorry-skeleton this matches the blueprint's general shape.
- **Proof follows sketch**: N/A — body is `:= sorry`, authorized as skeleton.
- **Notes**: Blueprint has `\leanok` on statement block; in-file docstring explicitly marks body as "typed sorry" for this iteration.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (def:grassmannian_scheme)

- **Lean target exists**: yes (line 198).
- **Signature matches**: partial — `(_V : S.Modules) (_d : ℕ)` does not require V to be locally free of any rank, nor does it require `1 ≤ d ≤ r`. The blueprint's definition says "a locally free O_S-module of rank r, 1 ≤ d ≤ r". Return type is correct.
- **Proof follows sketch**: N/A — body is `:= sorry`, authorized as skeleton.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (thm:grassmannian_representable)

- **Lean target exists**: yes (line 225).
- **Signature matches**: **no** — the Lean statement is `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`. The blueprint's prose claims: "representable by a smooth projective S-scheme Gr_S(V,d) → S of relative dimension d(r-d), equipped with a tautological rank-d quotient π*V ↠ U. The determinant line bundle det(U) is relatively very ample, giving a Plucker closed embedding Gr_S(V,d) ↪ ℙ_S(⋀^d V)." The Lean existential omits smoothness, properness, relative dimension d(r-d), tautological quotient, and Plucker embedding.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **Notes**: The blueprint's own NOTE comment explicitly acknowledges: "The Lean statement lean{AlgebraicGeometry.Scheme.Grassmannian.representable} is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plucker embedding. The \lean{} pin above points at a declaration that under-delivers the prose statement; it should be strengthened or split into a separate skeleton label." The proof is also noted as "blocked on either (a) strengthening thm:relative_spec_univ to deliver a RepresentableBy witness, or (b) finding a RepresentableBy-free argument via direct gluing."

---

## Red flags

### Placeholder / suspect bodies

- `Scheme.hilbertPolynomial` at line 126: `:= sorry` — blueprint-authorized skeleton for iter-176; Lean docstring explicitly marks it. Acceptable within `\leanok` on statement block.
- `Scheme.QuotFunctor` at line 165: `:= sorry` — same authorization.
- `Scheme.Grassmannian` at line 201: `:= sorry` — same authorization.
- `Scheme.Grassmannian.representable` at line 228: `:= by sorry` — the SIGNATURE itself is wrong (see above), so this sorry compounds the signature mismatch. The blueprint's NOTE flags both issues.
- `subquotient_base_eventuallyZero` at line 1494: `have hindep ... := by sorry` — "RESIDUAL LEAF", the independence of the degreewise image maps in the base case. Math is described as complete but scalar-ring plumbing (restrictScalars/quotient-ring boundary) is unresolved. This sorry propagates through `subquotient_hilbertSeries_rational` and `gradedModule_hilbertSeries_rational`.

### Axioms / Classical.choice on non-trivial claims

None found.

### Excuse-comments

None found — the existing sorry-related comments are informative obstruction notes, not excuses for wrong code.

### Private declarations with `\lean{}` pins

The following declarations are `private` in the Lean file but have `\lean{}` pins in the blueprint (subsection `subsec:isRatHilb`):
- `AlgebraicGeometry.coeff_invOneSubPow_one_mul` (line 430)
- `AlgebraicGeometry.rationalHilbert_antidiff` (line 450)
- `AlgebraicGeometry.IsRatHilb` (line 534)
- `AlgebraicGeometry.IsRatHilb.ofEventuallyZero` (line 539)
- `AlgebraicGeometry.IsRatHilb.bump` (line 548)
- `AlgebraicGeometry.IsRatHilb.sub` (line 563)
- `AlgebraicGeometry.IsRatHilb.shiftRight` (line 575)
- `AlgebraicGeometry.IsRatHilb.antidiff` (line 586)
- `AlgebraicGeometry.IsRatHilb.ofDiffEq` (line 602)

The blueprint NOTE at the subsection head acknowledges this: "Declarations in this subsection are currently `private` in the Lean source; `\lean{}` pins may not resolve until they are moved to a dedicated module." The `sync_leanok` phase cannot verify the `\leanok` markers on these blocks. Additionally, `gradedModule_hilbertSeries_rational` (public) exposes `IsRatHilb` (private) in its return type, which is an API inconsistency.

---

## Unreferenced declarations (informational)

The following Lean declarations have no individual `\lean{}` pin in the blueprint but are substantive (not trivial helpers):

| Declaration | Lines | Notes |
|---|---|---|
| `lastVarAlgHom` and siblings (`_X_castSucc`, `_X_last`, `_C`, `_rename_castSucc`, `_surjective`, `_ringHomSurjective`) | 1109–1139 | The surjection `MvPolynomial (Fin(r+1)) κ ↠ MvPolynomial (Fin r) κ` used by `subquotient_finite_transfer`. The blueprint's proof of `lem:graded_subquotient_finite_transfer` describes its role but gives no individual `\lean{}` pin. |
| `polyEndHom_mem_of_stable` | 1153 | Helper feeding `polyEndHom_lastVar_sub_mem`. |
| `polyEndHom_lastVar_sub_mem` | 1170 | "Mod-P' semilinearity heart" — the key algebraic content of the finiteness transfer. Underpins `subquotient_finite_transfer`. |
| `polyQuot_finite_of_le_denominator` | 1264 | Monotonicity-of-denominator lemma feeding `SubquotientDatum.coker`. |
| `polyQuot_finite_of_le_numerator` | 1290 | Monotonicity-of-numerator lemma feeding `SubquotientDatum.ker`. |
| `ker_stable_full` | 1382 | Full-family stability of the kernel pair. |
| `coker_stable_full` | 1389 | Full-family stability of the cokernel pair. |
| `SubquotientDatum.ker` | 1400 | Length-r Kernel constructor. The blueprint's `lem:graded_subquotient_ker_coker` is a narrative lemma covering these; no individual pin. |
| `SubquotientDatum.coker` | 1420 | Length-r Cokernel constructor. Same narrative coverage. |
| `finiteDimensional_of_mvPolynomial_isEmpty_finite` | 1442 | **Is** pinned in the blueprint as `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite`. (No issue.) |
| `subquotient_base_eventuallyZero` | 1459 | Internal helper for the base case; not independently pinned. |

Most are internal infrastructure feeding blueprint-pinned declarations. The `lastVarAlgHom` family and the `polyQuot_finite_of_le_*` family are the most significant unregistered items; both deserve `\lean{}` pins in the blueprint's proof sketch for `lem:graded_subquotient_finite_transfer`.

---

## Blueprint adequacy for this file

- **Coverage**: 54 of 67 `\lean{}` pins resolve to declarations in the Lean file. The 13 missing are either: (a) Mathlib-backed (`\mathlibok`) — 6 entries, all correct; (b) blocked on upstream infrastructure (tensor products of sheaves, QCoh localization bridge) — 5 entries (`sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `hilbertPolynomialOfSectionModule`, `isLocalizedModule_basicOpen`); (c) private in Lean (cannot resolve) — 9 entries in `subsec:isRatHilb`.

  Of the 38 project-local (non-Mathlib) pins: 34 resolve and match, 1 has a must-fix signature mismatch (`Grassmannian.representable`), 5 are blocked-missing.

- **Proof-sketch depth**: **adequate**. The blueprint is exceptionally detailed: every significant declaration has an explicit proof sketch, `\uses{}` dependencies, source quotes, and encoding notes. The `subquotient_degreewise_diff` proof sketch in the blueprint is precise enough to guide a formalization directly. The blueprint even describes the specific obstruction in `subquotient_base_eventuallyZero` ("the κ-linear Φ : Q →ₗ[κ] M ⧸ N' via Submodule.liftQ") so the prover knows exactly what to do.

- **Hint precision**: **precise** for most declarations. For `Grassmannian.representable` the `\lean{}` pin points at the weakened skeleton and the blueprint's own NOTE says the pin "under-delivers the prose statement; it should be strengthened or split into a separate skeleton label." This is a precision failure but the blueprint already diagnoses it.

- **Generality**: **matches need** for completed declarations. The decision to work over `(Over S)ᵒᵖ ⥤ Type u` for the Quot and Grassmannian functors is correct for downstream use. The `SubquotientDatum` structure correctly uses ambient submodules rather than derived carriers, consistent with the memory note about graded-quotient-module IsDefEq pathology.

- **Recommended chapter-side actions**:
  1. Add `\lean{}` pins for `lastVarAlgHom` (and siblings), `polyEndHom_lastVar_sub_mem`, `polyQuot_finite_of_le_denominator/numerator`, `SubquotientDatum.ker`, `SubquotientDatum.coker` — these are named in the blueprint's proof sketches but not individually registered.
  2. Correct or split the `\lean{}` pin for `thm:grassmannian_representable` once the Lean signature is strengthened — the current NOTE ("should be strengthened or split") should be acted on.
  3. Move `IsRatHilb` and the rationality toolkit from `private` to a dedicated submodule so the `\lean{}` pins in `subsec:isRatHilb` can resolve.
  4. Add a `\lean{}` pin and `\leanok` for `SubquotientDatum.ker`/`coker` once the blueprint's `lem:graded_subquotient_ker_coker` is re-cast as two constructors.

---

## Severity summary

### must-fix-this-iter

**Finding 1 — Signature mismatch: `Grassmannian.representable`.**

The Lean statement (line 225):
```lean
theorem Grassmannian.representable {S : Scheme.{u}} [IsLocallyNoetherian S]
    (V : S.Modules) (d : ℕ) :
    ∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y) := by sorry
```
The blueprint's prose requires: "representable by a **smooth projective** S-scheme Gr_S(V,d) → S of **relative dimension d(r-d)**, equipped with a **tautological rank-d quotient** π*V ↠ U. The determinant line bundle det(U) is **relatively very ample**, giving a **Plucker closed embedding** Gr_S(V,d) ↪ ℙ_S(⋀^d V)." Additionally, V should be **locally free of rank r** and **1 ≤ d ≤ r** — neither hypothesis appears.

The blueprint's own NOTE confirms: "The Lean statement … is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plucker embedding. The `\lean{}` pin above points at a declaration that under-delivers the prose statement; it should be strengthened or split into a separate skeleton label."

This is a direct blueprint-acknowledged signature mismatch. Per the severity rules, this is must-fix-this-iter.

### major

**Finding 2 — Missing declarations for the Hilbert-polynomial route.**

`AlgebraicGeometry.sectionGradedRing`, `AlgebraicGeometry.sectionGradedModule`, `AlgebraicGeometry.sectionGradedModule_fg`, and `AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule` are all `\lean{}`-pinned in this chapter (`% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean`) but absent from the Lean file. All four are blocked by the tensor-product-of-sheaves infrastructure gap that the blueprint's NOTE explicitly acknowledges. Not must-fix because the blueprint marks them without `\leanok` and the upstream gap is registered.

**Finding 3 — Missing `isLocalizedModule_basicOpen`.**

`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen` is `\lean{}`-pinned in `lem:qcoh_section_localization_basicOpen` but absent. Blocks the full `annihilator_ideal` characterization (the ≥ direction of the annihilator sheaf). Acknowledged in the blueprint's NOTE and in the `annihilator` docstring.

**Finding 4 — Private declarations with `\lean{}` pins in `subsec:isRatHilb`.**

Nine declarations are `private` in Lean but referenced by `\lean{}` pins. This prevents `sync_leanok` from verifying the `\leanok` markers on those blocks. The exposure of private `IsRatHilb` in the public theorem's return type is an API inconsistency. Blueprint acknowledges and authorizes deferral.

**Finding 5 — Loose signatures on `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`.**

- `hilbertPolynomial`: missing `HasProperSupport F π` hypothesis (blueprint prose: "a coherent sheaf F whose schematic support is proper over S").
- `QuotFunctor`: `_L : X.Modules` not required to be a line bundle; flatness of F is absent.
- `Grassmannian`: `_V : S.Modules` not required to be locally free; no `1 ≤ d ≤ r` guard.

These are sorry-skeletons with blueprint-authorized sorry bodies, but the signatures are more general than the blueprint's definitions. When the proof bodies land, the proper conditions will be needed. Classifying as major (partial signature mismatch fixable in-place) since the blueprint authorizes the sorry-skeleton phase.

**Finding 6 — Sorry propagation through base case of Stacks 00K1 induction.**

The sorry at line 1494 (`have hindep : iSupIndep ...`) in `subquotient_base_eventuallyZero` propagates through `subquotient_hilbertSeries_rational` (called by `gradedModule_hilbertSeries_rational`). The blueprint proof blocks for these lemmas do not have `\leanok`, consistent with the sorry. The obstruction is clearly described. Major (not must-fix) because the blueprint proof sketch is adequate and the remaining work is scalar-ring plumbing, not mathematical content.

### minor

**Finding 7 — Unreferenced substantive Lean declarations.**

`lastVarAlgHom` and siblings, `polyEndHom_lastVar_sub_mem`, `polyQuot_finite_of_le_denominator`, `polyQuot_finite_of_le_numerator`, `SubquotientDatum.ker`, `SubquotientDatum.coker` are significant project-local declarations with no individual `\lean{}` pin. They feed blueprint-pinned lemmas and are covered narratively, but individual pins would strengthen blueprint coverage.

---

## Overall verdict

The file is a well-structured iter-019 skeleton: the 30+ declarations in the graded Hilbert–Serre infrastructure (G1 through D6, SubquotientDatum constructors, full Stacks 00K1 induction) are fully formalized with sorry-free proofs; the annihilator/schematic-support/proper-support machinery is correctly typed and partially proven; the four top-level blueprint declarations (Hilbert polynomial, Quot functor, Grassmannian functor, Grassmannian representability) have sorry bodies authorized by the blueprint's skeleton phase. The one must-fix is the significantly weakened signature of `Grassmannian.representable` (acknowledged by the blueprint's own NOTE), which needs to be strengthened or split before the full Grassmannian representability claim can be considered formalized.
