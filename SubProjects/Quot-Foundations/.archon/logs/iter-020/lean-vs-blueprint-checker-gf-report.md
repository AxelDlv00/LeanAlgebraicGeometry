# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
020

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (1901 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (1547 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (line 1767)
- **Signature matches**: yes — `(A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches blueprint prose and the `% INTENDED LEAN SIGNATURE` block exactly.
- **Proof follows sketch**: partial — the blueprint's three-case dévissage sketch is faithfully implemented:
  1. **Primary route** (`hAM : Module.Finite A M`): calls `GenericFreeness.exists_free_localizationAway_of_finite A M` — axiom-clean, matches blueprint. ✓
  2. **Subsingleton obligation**: calls `GenericFreeness.exists_free_localizationAway_of_torsion A B N` with `LocalizedModule.subsingleton_iff` witness — axiom-clean, **closed this iter**. ✓
  3. **SES obligation**: calls `GenericFreeness.exists_free_localizationAway_of_shortExact A B N₁ N₂ N₃ …` — axiom-clean, **closed this iter**. ✓
  4. **N ≅ B/𝔭 obligation**: `sorry` at line 1810 — known-open honest residual; comment accurately cites L4 + L5 as pending.
- **notes**: The `Module.compHom N (algebraMap A B)` pattern correctly installs the restricted A-action for the `induction_on_isQuotientEquivQuotientPrime` motive. The transport step `rw [hAinst] at key` (line 1824–1831) reconciles the `compHom`-induced module action with the ambient `IsScalarTower A B M` action — this is a Lean-encoding-specific step (a definitional equality proof), not in the blueprint prose, but mathematically trivial. The blueprint adequately previews the dévissage structure at the right level of detail; this step did not require blueprint guidance. The `\uses{}` list in the blueprint includes `lem:gf_noether_clear_denominators` and `lem:gf_polynomial_core`, which are correct for the intended complete proof even though they are not yet invoked (the B/𝔭 node is still sorry). This is not dishonest — it describes the intended proof plan.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (`lem:gf_finite_module`)
- **Lean target exists**: yes (line 105)
- **Signature matches**: yes — noetherian domain, finite A-module, yields f ≠ 0 with M_f free.
- **Proof follows sketch**: yes — uses `Module.finitePresentation_of_finite` + `exists_free_localizedModule_powers` at `nonZeroDivisors A` / `FractionRing A`, matching blueprint's "finitely presented + generic fibre free → descend via fp_free_descent."
- **notes**: Axiom-clean.

---

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (`lem:fp_free_descent`) — `\mathlibok`
- **Lean target exists**: referenced as Mathlib; consumed inside `exists_free_localizationAway_of_finite`. ✓

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (`lem:gf_torsion_base`)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes — `(htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M))` encoding `M_K = 0`.
- **Proof follows sketch**: yes — multiplies the annihilators of a finite B-generating set, matching Nitsure's base-case argument precisely.
- **notes**: Axiom-clean.

---

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (`lem:noeth_prime_filtration`) — `\mathlibok`
- **Lean target exists**: consumed at line 1790. ✓

---

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (`lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes — SES of B-modules, yields injective + surjective + exact localised maps.
- **Proof follows sketch**: yes — direct application of `LocalizedModule.map_injective/surjective/exact`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (`lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (line 248)
- **Signature matches**: yes — `(hf : f = f' * f'')`, N free at f' implies free at f.
- **Proof follows sketch**: yes — uses `IsLocalization.Away.awayToAwayLeft`, scalar tower, `IsBaseChange.of_comp`.
- **notes**: Axiom-clean. Elaborate proof (45 lines) correctly implements the blueprint's "A_f is a localisation of A_{f'}" argument.

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (`lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (line 336)
- **Signature matches**: yes — SES of R-modules with free ends yields free middle.
- **Proof follows sketch**: yes — `Module.projective_lifting_property` + `Function.Exact.splitSurjectiveEquiv` + `Module.Free.of_equiv`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (`lem:gf_splice_shortExact`)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes — assembles L3a + L3b + L3c with `f := f' * f''`.
- **Proof follows sketch**: yes — calls the three sub-lemmas in order.
- **notes**: Axiom-clean.

---

### `\lean{exists_finite_inj_algHom_of_fg}` (`lem:noether_normalization_fg`) — `\mathlibok`
- **Lean target exists**: consumed at line 526. ✓

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (`lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (line 409)
- **Signature matches**: yes — `p ∈ MvPolynomial (Fin n) (FractionRing A)`, yields g ≠ 0 with p in image of `MvPolynomial.map (IsLocalization.map …)`. The `% NOTE (encoding)` in the blueprint accurately documents the non-canonical encoding of the algebra map — matches landed Lean exactly.
- **Proof follows sketch**: yes — uses `IsLocalization.exist_integer_multiples` over the support, scaling by the unit `g⁻¹`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (`lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (line 505)
- **Signature matches**: yes — matches the `% LEAN SIGNATURE` block in the blueprint verbatim (including the `(_ : Algebra (Localization.Away g) …)` 3rd existential binder).
- **Proof follows sketch**: partial — the injectivity half of the proof is **closed axiom-clean** (lines 719–738): the blueprint's Steps 1–3b are fully implemented. The module-finiteness half (Step 3c, clearing integral-dependence denominators) is `sorry` at line 754 — **known-open honest residual** per directive.
- **notes**: The sorry is accompanied by a 20-line comment (lines 739–755) accurately describing the remaining assembly (fold `gf_clear_one_denominator` over integrality equations; refine g to `g0 * g1`; `Algebra.IsIntegral.finite`). This matches the blueprint's Step 3c description. The blueprint's `% NOTE (shared engine)` comment about reusing `gf_clear_one_denominator` is documented in the Lean comment too — fully aligned.

---

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective}` (`lem:gf_isLocalization_lift_injective`)
- **Lean target exists**: yes (line 472)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `IsLocalization.lift_injective_iff` reduces to `hSinj.eq_iff, hginj.eq_iff`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (`lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (line 768)
- **Signature matches**: yes — matches the `% LEAN SIGNATURE` block: `∃ (m : ℕ) (φ : (Fin m → MvPolynomial (Fin d) A) →ₗ[MvPolynomial (Fin d) A] N), Function.Injective φ ∧ Module.IsTorsion (MvPolynomial (Fin d) A) (N ⧸ LinearMap.range φ)`.
- **Proof follows sketch**: yes — `Module.finBasis K NK`, `IsLocalizedModule.surj` to lift basis vectors, `LinearIndependent.restrict_scalars`, `Fintype.linearCombination`, `IsLocalization.exist_integer_multiples` to clear denominators of the torsion witness.
- **notes**: Axiom-clean. Long proof (~100 lines) fully implements the "choose a K-basis, clear denominators, prove torsion" argument described in the blueprint.

---

### `\lean{Submodule.annihilator_top_inter_nonZeroDivisors}` (`lem:annihilator_meets_nonZeroDivisors`) — `\mathlibok`
- **Lean target exists**: consumed at line 882. ✓

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (`lem:gf_torsion_annihilator`)
- **Lean target exists**: yes (line 875)
- **Signature matches**: yes — `∃ F : MvPolynomial (Fin d) A, F ≠ 0 ∧ F ∈ Module.annihilator (MvPolynomial (Fin d) A) T`.
- **Proof follows sketch**: yes — direct application of `Submodule.annihilator_top_inter_nonZeroDivisors`.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.T1}` (`def:gf_nagata_T1`) — **PRIVATE**
- **Lean target exists**: yes, but declared `private noncomputable abbrev T1` (line 933). The `\lean{}` pin uses the public qualified name `AlgebraicGeometry.GenericFreeness.T1`, which is not accessible outside the file.
- **Signature matches**: yes (mathematically) — `aeval fun i ↦ if i = 0 then X 0 else X i + c • X 0 ^ r i`.
- **Proof follows sketch**: N/A (definition).
- **notes**: **MAJOR** — blueprint `\lean{}` pin uses the public name but the declaration is `private`. sync_leanok cannot track this. See Red Flags §Private declarations.

### `\lean{AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg}` (`lem:gf_t1_comp_t1_neg`) — **PRIVATE**
- **Lean target exists**: yes, `private lemma t1_comp_t1_neg` (line 938). Same naming issue.
- **Signature matches**: yes.
- **Proof follows sketch**: yes.

### `\lean{AlgebraicGeometry.GenericFreeness.T}` (`def:gf_nagata_T`) — **PRIVATE**
- **Lean target exists**: yes, `private noncomputable abbrev T` (line 942). Same naming issue.
- **Signature matches**: yes.

### `\lean{AlgebraicGeometry.GenericFreeness.lt_up}` (`lem:gf_lt_up`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.sum_r_mul_ne}` (`lem:gf_sum_r_mul_ne`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_zero_t}` (`lem:gf_degreeOf_zero_t`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne}` (`lem:gf_degreeOf_t_ne_of_ne`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t}` (`lem:gf_leadingCoeff_finSuccEquiv_t`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq}` (`lem:gf_T_leadingcoeff_eq`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm}` (`lem:gf_finSuccEquiv_map_comm`) — **PRIVATE**
### `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ}` (`lem:gf_finSuccEquiv_rename_succ`) — **PRIVATE**

All nine Nagata helper declarations above share the same private/public naming discrepancy. See Red Flags §Private declarations for assessment.

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (`lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes (line 1034) — NOT private.
- **Signature matches**: yes — `∃ (g : A) (_ : g ≠ 0) (e : MvPolynomial (Fin (m + 1)) A ≃ₐ[A] MvPolynomial (Fin (m + 1)) A), IsUnit (MvPolynomial.finSuccEquiv (Localization.Away g) m (MvPolynomial.map (algebraMap A (Localization.Away g)) (e F))).leadingCoeff`.
- **Proof follows sketch**: yes — calls `T_leadingcoeff_eq` to get the lead coefficient `c := coeff v F ≠ 0`, sets `g := c`, uses `finSuccEquiv_map_comm` + `leadingCoeff_map_of_leadingCoeff_ne_zero`.
- **notes**: Axiom-clean. Public. The private helpers it uses are correctly scoped.

---

### `\lean{Polynomial.Monic.finite_quotient}` (`lem:polynomial_monic_quotient_finite`) — `\mathlibok`
- **Lean target exists**: consumed inside `mvPolynomial_quotient_finite_of_monic_lastVar`. ✓

---

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (`lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes (line 1091)
- **Signature matches**: yes — `RingHom.Finite` of the composite `MvPolynomial (Fin n) R →+* MvPolynomial (Fin (n+1)) R ⧸ Ideal.span {p}`. The blueprint's `% NOTE (F-3a)` accurately documents the `RingHom.Finite` encoding vs the earlier `Module.Finite` sketch.
- **Proof follows sketch**: yes — rescales to monic via `Polynomial.leadingCoeff_C_mul_of_isUnit`, invokes `hmonic.finite_quotient`, transports via `Ideal.quotientEquiv` and `AlgEquiv.ofRingEquiv`, uses `finSuccEquiv_rename_succ` for the S-algebra compatibility.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (`lem:gf_torsion_reindex`)
- **Lean target exists**: yes (line 1265)
- **Signature matches**: yes — matches the `% LEAN SIGNATURE` block verbatim including the dropped `Module A_g T_g` existential (noted in the `% NOTE: the redundant canonical` comment).
- **Proof follows sketch**: yes — the proof implements the five-step assembly described in the blueprint: annihilator (L5b.1) → Nagata normalisation (L5b.2) → elimination (L5b.3) → localisation transport using `isLocalizedModule_restrictScalars`, `pullbackModuleAddEquiv`, `finite_of_quotientRingEquiv` → final `gf_torsion_reindex` conclusion.
- **notes**: Axiom-clean. The blueprint's "Action-diamond subtlety" section is correctly implemented via the `hθCA` + `towerAAgMC` derivation. This is the most elaborate landed proof this iter (~200 lines) and the blueprint's detailed transport description adequately guided it.

---

### `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}` + `finite_of_pullbackModuleAddEquiv` + `pullback_isScalarTower` (`lem:gf_pullback_module_transport`)
- **Lean target exists**: yes — all three at lines 1150, 1168, 1183.
- **Signature matches**: yes — blueprint describes all three aspects (module action, finiteness, scalar tower) of the pullback-along-additive-equiv construction.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean. The blueprint correctly maps these three declarations to one lemma block.

---

### `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` (`lem:gf_finite_of_quotient_ringequiv`)
- **Lean target exists**: yes (line 1200)
- **Signature matches**: yes.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` (`lem:gf_islocalizedmodule_restrictscalars`)
- **Lean target exists**: yes (line 1218)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — verifies the three `IsLocalizedModule` axioms directly.
- **notes**: Axiom-clean.

---

### `\lean{IsLocalization.Away.mul_of_associated}` (`lem:isLocalization_away_mul_of_associated`) — `\mathlibok`
### `\lean{Module.Free.of_ringEquiv}` (`lem:module_free_of_ringEquiv`) — `\mathlibok`
Both consumed inside `free_localizationAway_of_away_tower`. ✓

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` (`lem:gf_away_tower_descent`)
- **Lean target exists**: yes (line 1508)
- **Signature matches**: yes — `(A T : Type u)` shared universe (documented in blueprint `% NOTE (signature)`), `g ≠ 0`, `h ≠ 0` in `Localization.Away g`, `hfree : Module.Free (Localization.Away h) ((T_g)_h)` → `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (T_f)`.
- **Proof follows sketch**: yes — the `IsBaseChange.comp` route for `IsLocalizedModule (powers (g*a)) ψ` is correctly noted in the blueprint's `% NOTE` (superseding the earlier "no packaged lemma" remark).
- **notes**: Axiom-clean. Complex proof (~100 lines) that matches the blueprint's detailed description.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (`lem:gf_polynomial_core`)
- **Lean target exists**: yes (line 1630)
- **Signature matches**: yes — `(A N : Type u)` shared universe (documented in blueprint), strong induction on d generalising A and N.
- **Proof follows sketch**: yes — `Nat.strong_induction_on generalizing A N`, base case via `exists_free_localizationAway_of_finite`, inductive step via `exists_free_localizationAway_of_torsion` (torsion sub-case) and the five-step assembly (generic-rank SES → torsion-reindex → IH at A_g → tower-descent → splice).
- **notes**: Axiom-clean. The blueprint's `% LEAN PROOF STRUCTURE` comment about `generalizing A N` exactly matches the landed tactic.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (`lem:gf_flat_finite`)
- **Lean target exists**: yes (line 120)
- **Signature matches**: yes.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (`lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (`thm:generic_flatness`)
- **Lean target exists**: yes (line 1863)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType] : ∃ (V : S.Opens), (V : Set S).Nonempty ∧ ∀ {U} (IsAffineOpen U) (U ≤ V) {W} (IsAffineOpen W) (e : W ≤ p⁻¹ᵁ U), letI := …, Module.Flat Γ(S,U) Γ(F,W)`. Matches the blueprint's `% LEAN SIGNATURE HEADER` exactly.
- **Proof follows sketch**: partial — establishes the non-empty affine open `U₀` (line 1877–1879) but the geometric assembly (`sorry` at line 1898) is a known-open honest residual per directive.
- **notes**: The sorry comment (lines 1881–1897) accurately describes the remaining geometric assembly steps (finite cover, section modules, product `f = ∏ fⱼ`, flat-locality). Blueprint prose describes these same steps. Both are honest about the open status.

---

## Red flags

### Placeholder / suspect bodies

All three `sorry` bodies are **known-open honest residuals** per directive:

1. `exists_localizationAway_finite_mvPolynomial` (line 754): the `hfin` finiteness leaf. Comment accurately describes the denominator-clearing assembly still needed. Blueprint marks the step as pending. **Honest.**

2. `genericFlatnessAlgebraic` (line 1810): the `N ≅ B/𝔭` obligation. Comment accurately cites L4 finiteness + L5 as the pending dependencies. Blueprint's surviving-residue section agrees. **Honest.**

3. `genericFlatness` (line 1898): the geometric assembly. Comment accurately lists the four remaining geometric steps. Blueprint proof section agrees. **Honest.**

Per directive, none of these are flagged as must-fix.

### Private declarations with `\lean{}` blueprint pins

**11 declarations** in the Nagata machinery section (`section NagataNormalization`, lines 900–1061 and line 1067) are declared `private` in the Lean file, but their blueprint `\lean{}` pins use the unmangled public qualified names:

| Blueprint pin | Lean declaration |
|---|---|
| `AlgebraicGeometry.GenericFreeness.T1` | `private noncomputable abbrev T1` (line 933) |
| `AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg` | `private lemma t1_comp_t1_neg` (line 938) |
| `AlgebraicGeometry.GenericFreeness.T` | `private noncomputable abbrev T` (line 942) |
| `AlgebraicGeometry.GenericFreeness.lt_up` | `private lemma lt_up` (line 929) |
| `AlgebraicGeometry.GenericFreeness.sum_r_mul_ne` | `private lemma sum_r_mul_ne` (line 946) |
| `AlgebraicGeometry.GenericFreeness.degreeOf_zero_t` | `private lemma degreeOf_zero_t` (line 955) |
| `AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne` | `private lemma degreeOf_t_ne_of_ne` (line 971) |
| `AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t` | `private lemma leadingCoeff_finSuccEquiv_t` (line 978) |
| `AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq` | `private lemma T_leadingcoeff_eq` (line 999) |
| `AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm` | `private theorem finSuccEquiv_map_comm` (line 907) |
| `AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ` | `private theorem finSuccEquiv_rename_succ` (line 1067) |

**Impact:** `sync_leanok` resolves `\lean{X}` by looking up the qualified name. In Lean 4, `private` declarations get name-mangled (e.g., `_private.…`), so the public names in the blueprint pins won't resolve. This breaks `\leanok` tracking for all 11 declarations. The mathematical content of all 11 is correct and their proofs are axiom-clean; the issue is purely in the blueprint-tracking layer.

**Mitigation options:** (a) Remove `private` from these declarations (they are documented in the blueprint and their names are already in the public namespace convention of the file), or (b) remove the `\lean{}` pins from the blueprint for these internal helpers and reference them only informally. Option (a) is simpler and matches the blueprint's intent.

**Classification:** Major (pre-existing; not introduced this iter). These helpers have likely been private since they were first written; the blueprint pins were presumably added at the same time, creating the discrepancy.

---

## Unreferenced declarations (informational)

The following declarations have no corresponding `\lean{}` blueprint block but are present in the Lean file:

- `GenericFreeness.pullbackModuleAddEquiv` — referenced by `lem:gf_pullback_module_transport` alongside `finite_of_pullbackModuleAddEquiv` and `pullback_isScalarTower` (the blueprint maps three Lean declarations to one lemma block; all three have `\lean{}` pins).

Actually, upon careful inspection, **all substantive declarations** in the file are pinned in the blueprint. The only truly unreferenced helpers are the private ones within the Nagata section (which are referenced, just with broken name resolution as noted above).

---

## Blueprint adequacy for this file

### Coverage
43/43 substantive Lean declarations have corresponding `\lean{}` blocks in the blueprint. Coverage is complete.

### Proof-sketch depth
**Adequate** for all closed lemmas. Specifically:

- The `genericFlatnessAlgebraic` dévissage structure (the focus of this iter) is described with sufficient precision in the blueprint: the three-obligation structure via `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`, the motive with restricted A-action, and the handling of each case. The blueprint's proof section correctly anticipated the `Module.compHom` pattern (referring to "the restricted A-action through algebraMap A B").

- The `gf_torsion_reindex` proof sketch is the most detailed in the chapter and accurately describes the five-step assembly including the action-diamond subtlety — this level of detail was genuinely needed for a ~200-line proof.

- The `exists_free_localizationAway_polynomial` strong-induction proof sketch explicitly notes the "generalizing A N" requirement as load-bearing, which exactly matches the landed `generalizing A N` in the Lean tactic.

- For the two remaining sorry nodes (`exists_localizationAway_finite_mvPolynomial` finiteness leaf and `genericFlatnessAlgebraic` B/𝔭 node), the blueprint describes what remains with adequate precision (the folded denominator-clearing assembly for the former; L4 + L5 for the latter).

One minor gap: the `rw [hAinst] at key` definitional-equality transport at lines 1824–1831 (reconciling `compHom` module instance with the ambient `IsScalarTower A B M` action) is not previewed in the blueprint. However, this is a Lean-specific instance-coherence step without mathematical content, so the omission is appropriate.

### Hint precision
**Precise.** Every `\lean{}` pin names the correct Lean declaration. The `% LEAN SIGNATURE` and `% NOTE` comments in the blueprint correctly predict the landed signatures including subtle encoding choices (the 3rd existential binder in `exists_localizationAway_finite_mvPolynomial`; the `RingHom.Finite` vs `Module.Finite` encoding in `mvPolynomial_quotient_finite_of_monic_lastVar`; the dropped `Module A_g T_g` binder in `gf_torsion_reindex`; the `(A N : Type u)` shared universe in `exists_free_localizationAway_polynomial`). The blueprint is clearly being maintained in close sync with the Lean.

**Exception:** The 11 private declarations whose public names in the pins won't resolve (see Red Flags above). The hints are mathematically correct but technically broken for tracking purposes.

### Generality
**Matches need.** No parallel API was required; the blueprint's level of generality is exactly what the Lean proofs consume.

### Recommended chapter-side actions
1. **For the 11 private declarations**: either remove `private` from the Lean declarations and keep the `\lean{}` pins, or remove the `\lean{}` pins and make the blueprint references informal. Removing `private` is recommended since the declarations are already documented publicly in the blueprint.

---

## Severity summary

### must-fix-this-iter
None. (All `sorry` bodies are known-open honest residuals explicitly covered by the directive's known-issues list. No signature mismatches. No excuse-comments on claimed-closed declarations. No axioms introduced.)

### major
- **Pre-existing private/public naming discrepancy** for 11 Nagata-section helper declarations: `\lean{}` blueprint pins use unmangled public names, but the Lean declarations are `private`. Breaks `sync_leanok` tracking for these 11 blocks. Fix: remove `private` from the affected declarations (the simplest and least disruptive change, since the names are already in the blueprint's public namespace). Not introduced this iter — pre-existing.

### minor
- The blueprint proof of `genericFlatnessAlgebraic` does not preview the `rw [hAinst] at key` instance-equality transport step needed to reconcile the `compHom` module action with the ambient `IsScalarTower A B M` action. This is a Lean encoding detail; no blueprint expansion needed.
- The `% NOTE` at the bottom of the L5 proof (lines 1380–1388 of the blueprint, describing the OreLocalization instance-presentation issue) is still live text even though `gf_torsion_reindex` is now axiom-clean — the note accurately reflects this iter's resolution. The plan agent should consider removing or updating this note.

**Overall verdict:** The Lean file follows the blueprint faithfully across all 43 declarations; the dévissage structure for `genericFlatnessAlgebraic` landed this iter (subsingleton + SES obligations closed axiom-clean) matches the blueprint proof sketch precisely; the two remaining `sorry` bodies are honest residuals clearly acknowledged in both the Lean code and the blueprint. The only structural finding is a pre-existing major: 11 private Nagata helper declarations whose blueprint `\lean{}` pins use unresolvable public names, breaking `sync_leanok` tracking for those blocks.
