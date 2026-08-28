Measurement complete. Here is what the tree has.

## 1. The two P1 charts and their overlap ring

All chart/overlap identifications on the *scheme* `P1 k` are stated **over a field only** — `P1` itself is only defined for a field:

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/P1.lean:135` — `noncomputable def P1 (k : Type u) [Field k] : Scheme.{u} := Proj (homogeneousSubmodule (Fin 2) k)`, with `variable (k : Type u) [Field k]` at `:140`. There is no ring-based `P1`, so every downstream chart lemma inherits `[Field k]`.

Chart rings (field only), all in `Curve/P1.lean`:
- `:131` `awayAlgEquiv {i j : Fin 2} (hij : i ≠ j) : Away 𝒜 (X i) ≃ₐ[k] Polynomial k` (line numbering in the tail block: `AlgEquiv.ofAlgHom (awayToPoly k i) (polyToAway k i j) …`, at file lines 412–416)
- `:289` `polyToAway (i j : Fin 2) : Polynomial k →ₐ[k] Away 𝒜 (X i)`, `:311` `awayToPoly (i : Fin 2) : Away 𝒜 (X i) →ₐ[k] Polynomial k`
- `:262` `chartCoord (i j : Fin 2) : Away 𝒜 (X i)` — the coordinate `Xⱼ/Xᵢ`
- `:200` `chartOpen (i : Fin 2) : (P1 k).Opens := Proj.basicOpen 𝒜 (X i)`

Overlap ring, all in `Curve/P1Charts.lean`, all with `variable (k : Type u) [Field k]` (`:40`):
- `:99` `overlapRingEquiv : Away 𝒜 (X 0 * X 1) ≃+* LaurentPolynomial k`
- `:116` `overlapAlgEquiv : Away 𝒜 (X 0 * X 1) ≃ₐ[k] LaurentPolynomial k` — **over the field `k`, not over a general base**
- `:90` `instance : IsLocalization.Away (chartCoord k 0 1) (Away 𝒜 (X 0 * X 1))`
- `:131` `overlapAlgEquiv_awayToOverlapLeft` — left restriction is `t ↦ T`
- `:160` `overlapAlgEquiv_awayToOverlapRight` — right restriction is `t ↦ T⁻¹` (via `Polynomial.aeval (T (-1))`)
- `:144` `overlapAlgEquiv_awayToOverlapRight_chartCoord : … = LaurentPolynomial.T (-1)`
- `:177` `exists_awayToOverlap_add` — additive Laurent span on the overlap ring
- Section level: `:234` `chartSectionsEquiv₀ : Γ(P1 k, chartOpen k 0) ≃+* Polynomial k`, `:239` `chartSectionsEquiv₁` (same, chart 1), `:245` `overlapSectionsEquiv : Γ(P1 k, Proj.basicOpen 𝒜 (X 0 * X 1)) ≃+* LaurentPolynomial k`, with `:286` `overlapSectionsEquiv_res_left` and `:295` `overlapSectionsEquiv_res_right`
- `:315` `structure LaurentChartPair (k : Type u) [Field k]` — the bundled package, fields `Γ₀ : Γ(P1 k, U₀) ≃+* Polynomial k` (`:331`), `Γ₁` (`:333`), `Γ₀₁ : Γ(P1 k, U₀₁) ≃+* LaurentPolynomial k` (`:335`), `res_left`/`res_right` (`:337`, `:340`); canonical term `P1.laurentChartPair` at `:369`. **Field only.**

**Nothing in AJCR identifies a P1 chart or overlap ring over a general base ring `B`, and nothing identifies the overlap ring of `P1_B = (P1.asOver k ⊗ overSpec k B).left` at all.** The generic tooling that *would* do it exists but is not composed with the P1 charts:
- `Cohomology/SectionsBaseChange.lean:288` `Over.sectionsBaseChange … : Γ(X.left, V) ⊗[k] A ≃+* Γ((X ⊗ overSpec k A).left, fst ⁻¹ᵁ V)` (qcqs `V`; `:298` the affine-open form). Grep confirms zero call sites composing it with `chartSectionsEquiv₀/₁` or `overlapSectionsEquiv` (the only four files mentioning `overlapSectionsEquiv` are `P1Charts.lean`, `Cohomology/FinitenessP1.lean`, `Cohomology/Finiteness.lean`, `Curve/MapToP1.lean`, all field-only).
- `Curve/ProductCharts.lean:216`/`:226`/`:292` `productChartSectionsIso`/`productChartSections`/`productChartSectionsAlgEquiv : Γ(U) ⊗[k] Γ(V) ≃ Γ(𝔚 U V)` — generic, and its only consumers are `Curve/DiagonalChart.lean` / `Curve/DiagonalClosed.lean`, not P1.
- No `LaurentPolynomial k ⊗[k] B ≃ LaurentPolynomial B` anywhere (grep for `LaurentPolynomial k ⊗`, `⊗[k] LaurentPolynomial`: zero hits). `polyEquivTensor'` is used once, at `Curve/P1Curve.lean:269`, and only inside `isDomain_tensor_away` (`:261`) for a *field* extension `K/k`.

The one ring-level chart identification in the workspace lives in the **sibling** AJC (see §5).

## 2. Declarations computing/classifying a class in terms of an integer, degree, Laurent unit, or cocycle

Over an **arbitrary commutative ring `A`** (purely algebraic, no scheme):
- `AlgebraicJacobian/Algebra/LaurentUnits.lean:72` `LaurentPolynomial.isUnit_C_mul_T {c : R} (hc : IsUnit c) (n : ℤ) : IsUnit (C c * T n)` — any `CommRing R`
- `:85` `exp_unique {c d : R} (hc : c ≠ 0) {n m} (h : C c * T n = C d * T m) : n = m` — any `CommRing R`
- `:236` `coeff_unique` — any `CommRing R` (`omit [IsDomain R]`)
- `:122` `C_mul_T_apply (c : R) (n m : ℤ) : (C c * T n) m = if n = m then c else 0`
- `:208` `unitsHom : Rˣ × Multiplicative ℤ →* (LaurentPolynomial R)ˣ` — any `CommRing R`

Over a **domain** (`variable [IsDomain R]` at `:154`):
- `:161` `exists_eq_C_mul_T_of_isUnit {f} (hf : IsUnit f) : ∃ c n, IsUnit c ∧ f = C c * T n`
- `:185` `isUnit_iff_C_mul_T` — the iff
- `:269` `unitsEquiv : Rˣ × Multiplicative ℤ ≃* (LaurentPolynomial R)ˣ` — this is the `Rˣ × ℤ` statement

Two-chart cohomological consequence, `AlgebraicJacobian/Picard/LaurentTwoChartCoboundary.lean` (`variable {A : Type u} [CommRing A]` at `:73`):
- `:78` `rightChart (A) : Polynomial A →+* LaurentPolynomial A` (`X ↦ T (-1)`) — any ring
- `:92` `laurentCoboundaryUnits (A) : Subgroup (LaurentPolynomial A)ˣ` — any ring
- `:100` `C_unit_mem_laurentCoboundaryUnits (c : Aˣ)` — any ring
- `:118` `eq_C_of_mem_laurentCoboundaryUnits [IsDomain A]` — **domain**
- `:135` `mem_laurentCoboundaryUnits_iff [IsDomain A]` — **domain**; this is the closest thing to "degree classifies"
- `:157` `not_tUnit_mem_laurentCoboundaryUnits [IsDomain A] [Nontrivial A]` — `t` is not a coboundary

Scheme-level two-chart criterion, generic in `X` (`AlgebraicJacobian/Picard/TwoChartCechPicTrivial.lean`, `variable {X : Scheme.{u}} {V : Bool → X.Opens}` at `:66`):
- `:71` `twoChartCoboundaryUnits`, `:87` `cechPic_eq_one_of_chartTrivial_of_overlapUnits_coboundary`, `:100` `subsingleton_chartTrivial_of_overlapUnits_coboundary`, `:116` `…_of_not_isAffine`, `:151` `cechPic_eq_one_of_forall_presenting_coboundary`, `:162` `forall_presenting_of_forall_coboundary`

Degree-classifies-the-class at P1, but **over fields only** (`AlgebraicJacobian/Curve/P1DegreeZeroTrivial.lean`, `variable (k) [Field k] (K) [Field K] [Algebra k K]` at `:107`):
- `:115` `chi_baseChange_eq_one`, `:138` `eq_one_of_classDeg_eq_zero_baseChange (L : ((P1.asOver k) ⊗ overSpec k K).left.CechPic) (hL : classDeg K L = 0) : L = 1`, `:145` `classDeg_eq_zero_iff_baseChange`, `:156` `eq_of_classDeg_eq_baseChange`. The test object is `overSpec k K` for a **field** `K`.
- Curve-generic version: `Picard/Pic0VanishingFieldGenusZero.lean:109` `relPic_eq_one_of_relPicDeg_eq_zero_of_genus_zero (K) [Field K] [Algebra k K] (hg : genus C = 0) (y : relPic C (overSpec k K)) (hy : relPicDeg K y = 0) : y = 1`, and `:124` the iff. Again **field test only**. `relPicDeg` is at `RiemannRoch/RelPicDegree.lean:61`, defined only for `[Field K]`; `classDeg` at `RiemannRoch/Degree.lean:150` with `variable (K : Type u) [Field K]` (`:65`).

Ring-level triviality producers that are **not** degree-indexed:
- `Picard/UnitEquationsTrivialClass.lean:106` `Scheme.LocalEquations.picClass_eq_one_of_isUnit_eqn (d) (hu : ∀ x, IsUnit (d.eqn x)) : d.picClass = 1` — generic scheme, no ring hypothesis
- `:141` `DivFamZar.picClass_trivEqns`, `:158` `DivisorAdaptation.picClass_eq_one_of_isCertified_zero` — arbitrary test ring `R`, but the degree-0 input is a *rank clause on a certified adaptation*, not a Laurent exponent
- `Picard/DivisorFamilyDegreeZeroGeneral.lean:125` `isUnit_eqn_of_isCertified_zero`, `:152` `divEq_trivEqns_of_isCertified_zero` — arbitrary `R`

Ring-level `pic⁰` results that stop short of triviality: `Picard/Pic0RingEngineFromPic0.lean:202` `htriv_of_pic0`, `:234` `rigidEngine_of_pic0`, `:249`/`:313` `rankAtStalk_hModule_zero_eq_one_of_pic0` (the last at `P1.asOver k` over an arbitrary Noetherian `B`) — these give `H¹ = 0` and `π_*L` invertible, not `L = 1`.

`Picard/Pic0Chart*` (59 files): **none** mentions `LaurentPolynomial` or `Polynomial` at all (grep `-l` returns empty). There is no `Pic0Chart*` file computing a class via a Laurent unit.

## 3. "Laurent-unit cocycle trivial iff exponent 0" / "unit of B[T,T⁻¹] = unit of B[T] · Tⁿ · unit of B[T⁻¹]"

**Both absent.** What exists is the domain-only surrogate.

The nearest statement is `mem_laurentCoboundaryUnits_iff` (`Picard/LaurentTwoChartCoboundary.lean:135`), which under `[IsDomain A]` says a coboundary is exactly `C c` with `c` a unit. Combined with `isUnit_iff_C_mul_T` that *implies* "coboundary iff exponent 0" over a domain, but no declaration states it in exponent form, and there is no non-domain version. The factorization `(B[T,T⁻¹])ˣ = B[T]ˣ · Tⁿ · B[T⁻¹]ˣ` over a general ring is nowhere.

Greps run (all in `/home/axel/…/Algebraic-Jacobian-Challenge-Rebuild`):
- `grep -rn "T n.*coboundary\|coboundary.*T n\|tUnit.*mem\|mem.*tUnit"` — only the three known `not_tUnit_mem_laurentCoboundaryUnits` hits
- `grep -rn "toLaurent.*rightChart\|rightChart.*toLaurent"` — 2 hits, both inside `LaurentTwoChartCoboundary.lean` (`:97`, `:128`), i.e. the coboundary subgroup definition itself
- `grep -rn "= .*C c \* T n\|C c \* T n ="` — only `Algebra/LaurentUnits.lean`
- `grep -rn "exponent"` — only docstrings in `LaurentUnits.lean` and `LaurentTwoChartCoboundary.lean:35`
- `grep -rn "coboundary" | grep -i "iff\|zero\|exponent\|degree"` — no exponent-indexed statement

Also worth reporting: `laurentCoboundaryUnits` and `rightChart` have **zero consumers** outside their own file (grep `rightChart\|laurentCoboundary` excluding that file returns only a docstring mention at `TwoChartCechPicTrivial.lean:150`). The algebraic P1 unit computation is never connected to the scheme `P1 k`, to `CechPic`, or to `relPic`. `TwoChartCechPicTrivial.lean`'s own docstring (`:126-131`, `:145-151`) says exactly this: the payable hypothesis at P1 is "the presenting unit has exponent zero", and it is stated as prose, not as a lemma.

## 4. Units of `Polynomial B` and `B[T,T⁻¹]` over a non-domain

In AJCR, `Algebra/LaurentUnits.lean` — the **only** non-domain results are:
- `:72` `isUnit_C_mul_T` (any `CommRing R`)
- `:105` `isUnit_one_add_C_mul_T_of_sq_eq_zero {e : R} (he : e * e = 0) : IsUnit (1 + C e * T 1)` — any `CommRing R`
- `:131` `not_exists_eq_C_mul_T_one_add_C_mul_T [Nontrivial R] {e : R} (he : e ≠ 0) : ¬ ∃ c n, (1 + C e * T 1) = C c * T n`
- `:122` `C_mul_T_apply`, `:85` `exp_unique`, `:236` `coeff_unique`, `:208` `unitsHom`, `:199` `tUnit`

These two counterexample halves formalize that `IsDomain` cannot be dropped from the classification. There is **no** positive classification of `(LaurentPolynomial B)ˣ` over a non-domain in either project. Nothing anywhere in AJCR relates `Polynomial B` units to nilpotents.

In mathlib at this pin (**toolchain v4.31.0, mathlib rev `v4.31.0`, packages at `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`** — note `lakefile.toml` sets `packagesDir = "../../.lake-packages"`, so the project-local `.lake/packages` has no mathlib):

- `Mathlib/Algebra/Polynomial/Degree/Units.lean:48` `Polynomial.isUnit_iff : IsUnit p ↔ ∃ r : R, IsUnit r ∧ C r = p`, in `section Semiring` with `variable [Semiring R] [NoZeroDivisors R] {p q : R[X]}` (`:29`) — so it needs **NoZeroDivisors**, not just a `CommRing`. Its own docstring points at the nilpotent version.
- `Mathlib/Algebra/Polynomial/Coeff.lean:138` `Polynomial.isUnit_C {x : R} : IsUnit (C x) ↔ IsUnit x` — `variable [Semiring R]` (`:36`), **arbitrary semiring**, no domain.
- **`Polynomial.isUnit_iff_coeff_isUnit_isNilpotent` EXISTS at this pin**: `Mathlib/RingTheory/Polynomial/Nilpotent.lean:159`, in `section CommRing` with `variable [CommRing R] {P : R[X]}` (`:72`):
  `theorem isUnit_iff_coeff_isUnit_isNilpotent : IsUnit P ↔ IsUnit (P.coeff 0) ∧ (∀ i, i ≠ 0 → IsNilpotent (P.coeff i))`
  Its two halves are separately available: `:111` `isUnit_of_coeff_isUnit_isNilpotent`, `:135` `coeff_isUnit_isNilpotent_of_isUnit`. Also in that file: `:166` `@[simp] isUnit_C_add_X_mul_iff : IsUnit (C r + X * P) ↔ IsUnit r ∧ IsNilpotent P`, `:172` `isUnit_iff' : IsUnit P ↔ IsUnit (eval 0 P) ∧ IsNilpotent (P /ₘ X)`, and `:177`/`:189` `not_isUnit_of_natDegree_pos_of_isReduced` / `not_isUnit_of_degree_pos_of_isReduced` (both `[IsReduced R]`) — the last two are the reduced-ring generalization of `isUnit_iff` and would let a P1-over-a-reduced-ring computation run.
- Mathlib's whole Laurent `IsUnit` API is still the single lemma `Mathlib/Algebra/Polynomial/Laurent.lean:230` `isUnit_T (n : ℤ) : IsUnit (T n)`. The `LaurentUnits.lean` docstring claim at `:16-19` is accurate at this pin.
- Relevant but uncited: `Mathlib/RingTheory/TensorProduct/MonoidAlgebra.lean` has `AddMonoidAlgebra.tensorEquiv` (`:32` for the inverse) — the base-change equiv that would give `LaurentPolynomial k ⊗[k] B ≃ LaurentPolynomial B`. AJCR never references it.

**None of `isUnit_iff_coeff_isUnit_isNilpotent`, `isUnit_C_add_X_mul_iff`, `isUnit_iff'`, `not_isUnit_of_*_of_isReduced`, or `Polynomial.isUnit_C` is used anywhere in AJCR** (grep returns zero hits for all; the only `IsReduced` hits in the project are scheme-level `IsReduced X.left` in `Albanese/`). `Polynomial.isUnit_iff` is used twice: `LaurentUnits.lean:174` and `LaurentTwoChartCoboundary.lean:124-125`.

## 5. Sibling project AJC

**No Picard-group computation for P1 over a ring, and no `Pic(P1_B) = Pic B × Z` statement.** Greps for `Pic(ℙ¹`, `Pic(P1`, `ℙ¹_B`, `Pic(A) × ℤ`, `Pic B × ℤ`, `× ℤ`, `≃* ℤ` over `AlgebraicJacobian/` return no such declaration; `Pic.*P1|P1.*Pic` matches no `theorem`/`def`/`lemma`. AJC's `LaurentPolynomial` uses are all in `RiemannRoch/Ledger/` (`P1Charts.lean`, `FinitenessP1.lean`, `Finiteness.lean`, `P1.lean`) and are byte-for-byte the same field-only chart material as AJCR's — same line numbers, `LaurentPolynomial k`. AJC's `RelPicFunctor.lean` builds the relative Picard functor and its étale sheafification but computes nothing at P1.

The one thing AJC has that AJCR does not, and it is directly relevant:

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean` — **the P1 chart ring over an arbitrary commutative ring**, `variable (R : Type u) [CommRing R]` (`:122`), grading taken as an instance hypothesis `[GradedAlgebra (homogeneousSubmodule (ULift (Fin 2)) R)]`:
- `:346` `p1AwayAlgEquiv {i j : ULift (Fin 2)} (hij : i ≠ j) : Away (homogeneousSubmodule (ULift (Fin 2)) R) (X i) ≃ₐ[R] Polynomial R`
- `:220` `p1ChartCoord (i j)`, `:240` `p1PolyToAway`, `:251` `p1AwayToPoly`, `:352` `p1AwayAlgEquiv_p1ChartCoord`, `:357` `p1AwayAlgEquiv_symm_X`, `:361` `p1AwayAlgEquiv_p1PolyToAway`, `:366` `instIsDomainAwayP1 [IsDomain R]`

Its docstring (`:52-56`) states explicitly that no step uses invertibility of nonzero scalars. This is the **chart** ring only — there is no `p1AwayAlgEquiv`-analogue for the overlap `Away 𝒜 (X i * X j) ≃ₐ[R] LaurentPolynomial R` in AJC either (grep for `X i * X j` in AJC finds only `Picard/ProjectiveCoordinateChart.lean:262` and `Picard/SerreTwistSections.lean` Serre-twist section material over the integral base `ULift ℤ`, no Laurent identification).

AJC's `LaurentChartData` (`RiemannRoch/Adelic/FinitenessP1.lean:402`) is a bundled two-chart datum, but under `variable {k : Type u} [Field k]` (`:387`) and its spanning fields are `k`-module spans (`span_pow_x`, `span_pow_y`, `:449`/`:452`) — **field only**.

## Summary of the distance

Toward `relPic (P1.asOver k) (overSpec k B)` classified by degree, the tree has: the two chart rings and overlap ring of P1 identified as `k[t]`, `k[t]`, `k[T,T⁻¹]` **over the field only** (AJCR `P1Charts.lean`); the chart ring identified as `R[t]` **over an arbitrary ring** in the sibling but not the overlap ring (AJC `RigidPushforwardP1ChartRing.lean:346`); the Laurent unit group as `Bˣ × ℤ` and the two-chart coboundary subgroup as the constants **over a domain only** (AJCR `LaurentUnits.lean:269`, `LaurentTwoChartCoboundary.lean:135`), with the domain hypothesis proved necessary; a scheme-generic criterion turning "presenting unit is a coboundary" into class triviality (`TwoChartCechPicTrivial.lean:151`) that is never instantiated at P1; and degree-classifies-the-class at P1 for **field** tests only (`P1DegreeZeroTrivial.lean:138`, `Pic0VanishingFieldGenusZero.lean:109`). The three missing seams are (a) the overlap ring of `P1_B` as `LaurentPolynomial B` for a general `B` — no base-change composition exists, though `Over.sectionsBaseChange` (`SectionsBaseChange.lean:288`) and mathlib's `AddMonoidAlgebra.tensorEquiv` are both available; (b) a non-domain unit classification, for which mathlib's `Polynomial.isUnit_iff_coeff_isUnit_isNilpotent` (`RingTheory/Polynomial/Nilpotent.lean:159`) and `not_isUnit_of_degree_pos_of_isReduced` (`:189`) exist at this pin and are unused by the project; (c) any statement in exponent form ("coboundary iff exponent 0"), which lives only as prose at `LaurentTwoChartCoboundary.lean:35` and `TwoChartCechPicTrivial.lean:145-151`.
