# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
016

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (`lem:gf_finite_module`)
- **Lean target exists**: yes (line 105)
- **Signature matches**: yes — `[CommRing A] [IsDomain A] [IsNoetherianRing A] [Module A M] [Module.Finite A M]`, conclusion `∃ f, f ≠ 0 ∧ Module.Free (Away f) (Loc (powers f) M)`
- **Proof follows sketch**: yes — `Module.finitePresentation_of_finite` then `Module.FinitePresentation.exists_free_localizedModule_powers` at `nonZeroDivisors A`, exactly the blueprint's finite-presentation free-descent route
- **notes**: closed, no sorry

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (`lem:gf_flat_finite`)
- **Lean target exists**: yes (line 120)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `exists_free_localizationAway_of_finite` then `Module.Flat.of_free`
- **notes**: closed

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (`lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes — adds `[Algebra A B] [Module.Finite A B] [Module B M] [Module.Finite B M] [IsScalarTower A B M]`
- **Proof follows sketch**: yes — `Module.Finite.trans B M` then `exists_free_localizationAway_of_finite`
- **notes**: closed

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (`lem:gf_torsion_base`)
- **Lean target exists**: yes (line 168)
- **Signature matches**: yes — `(htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M))`
- **Proof follows sketch**: yes — constructs the product `f := ∏ generators annihilators` via `LocalizedModule.subsingleton_iff`, exactly the blueprint's torsion-product argument
- **notes**: closed; the `hcomm` step handles scalar-commutativity transparently

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (`lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes
- **Proof follows sketch**: yes — direct one-liner via `LocalizedModule.map_injective/map_surjective/map_exact`
- **notes**: closed

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (`lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (line 248)
- **Signature matches**: yes — `{f f' f'' : A} (hf : f = f' * f'')`
- **Proof follows sketch**: yes — assembles `IsLocalization.Away.awayToAwayLeft`, the `A_{f'}`-linear map `φ`, then `IsBaseChange.of_comp.free`
- **notes**: closed; blueprint says "a basis of N_{f'} maps to a basis of N_f" — Lean uses `hbcA'.of_comp hbcAf` to achieve the same

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (`lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (line 336)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Module.projective_lifting_property` → `splitSurjectiveEquiv` → `Module.Free.of_equiv`
- **notes**: closed

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (`lem:gf_splice_shortExact`)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes
- **Proof follows sketch**: yes — takes `f := f' * f''`, invokes L3b on both ends, then L3c
- **notes**: closed; blueprint's "apply L3b to M' with f=f'f''" and "apply L3b to M'' with f=f''f'" both appear at lines 378–383

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (`lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (line 409)
- **Signature matches**: yes — uses `IsLocalization.map (FractionRing A) (RingHom.id A) hle` (note in blueprint acknowledges this encoding of the canonical map)
- **Proof follows sketch**: yes — `IsLocalization.exist_integer_multiples` over the support, then rescales by the unit `g⁻¹`
- **notes**: closed; blueprint notes that the canonical `algebraMap (Away g) (FractionRing A)` doesn't exist; the encoding comment in the blueprint is correct and matches the landed code

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (`lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (line 486)
- **Signature matches**: yes — existential includes `(_ : Algebra (Away g) (Away (algebraMap A B g)))` as the blueprint pinned signature shows
- **Proof follows sketch**: partial — step 1 (Noether normalisation over K) is present via `exists_finite_inj_algHom_of_fg`; **step 2 (denominator-clearing fold) has `sorry`** (line 516)
- **notes**: blueprint acknowledges this as "genuine remaining content of L4" with no `\leanok`; `sorry` is documented and consistent with blueprint status

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (`lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (line 529)
- **Signature matches**: yes — `[IsNoetherianRing A] (d : ℕ) (N : Type*)` with all module structures
- **Proof follows sketch**: yes — detailed 5-sub-step implementation: `Module.finBasis K NK` for the K-basis, denominator clearing via `IsLocalizedModule.surj`, linear-independence descent from K to P_d, torsion cokernel proof via `IsLocalization.exist_integer_multiples`
- **notes**: closed; one of the most detailed proofs in the file

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (`lem:gf_torsion_annihilator`)
- **Lean target exists**: yes (line 636)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Submodule.annihilator_top_inter_nonZeroDivisors` then `nonZeroDivisors.ne_zero`
- **notes**: closed

### Nagata machinery helpers (`lem:gf_nagata_T1/T/t1_comp_t1_neg/lt_up/sum_r_mul_ne/degreeOf_zero_t/degreeOf_t_ne_of_ne/leadingCoeff_finSuccEquiv_t/T_leadingcoeff_eq/finSuccEquiv_map_comm/finSuccEquiv_rename_succ`)
- **Lean targets exist**: yes — all present as `private` declarations with blueprint-pinned names
- **Signatures match**: yes for all
- **Proofs follow sketches**: yes — the detailed degree-bookkeeping lemmas (`degreeOf_zero_t`, `T_leadingcoeff_eq`) match the blueprint's radix-encoding argument; `t1_comp_t1_neg` proved by `simp` on generators as blueprint indicates
- **notes**: all closed; `private` status is fine for helper lemmas the blueprint identifies as infrastructure

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (`lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes (line 795)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `T_leadingcoeff_eq` to get the top coefficient `c`, sets `g := c`, uses `IsLocalization.Away.algebraMap_isUnit` and `leadingCoeff_map_of_leadingCoeff_ne_zero`
- **notes**: closed

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (`lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes (line 852)
- **Signature matches**: yes — `RingHom.Finite` of the composite map (blueprint notes encoding as `RingHom.Finite` rather than `Module.Finite + letI`)
- **Proof follows sketch**: yes — rescales to a monic polynomial via `hp.unit⁻¹`, invokes `Polynomial.Monic.finite_quotient`, transports across the `S`-algebra isomorphism induced by `finSuccEquiv`
- **notes**: closed

### Transport helpers (`lem:gf_pullback_module_transport`, `lem:gf_finite_of_quotient_ringequiv`, `lem:gf_islocalizedmodule_restrictscalars`)
- **Lean targets exist**: yes — `pullbackModuleAddEquiv` (def, line 911), `finite_of_pullbackModuleAddEquiv` (line 929), `pullback_isScalarTower` (line 944), `finite_of_quotientRingEquiv` (line 961), `isLocalizedModule_restrictScalars` (line 979)
- **Signatures match**: yes for all five
- **Proofs follow sketches**: yes — proofs match blueprint's descriptions (transport axioms termwise, transitivity for finite transport, universal property verification)
- **notes**: all closed

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (`lem:gf_torsion_reindex`)
- **Lean target exists**: yes (line 1026)
- **Signature matches**: yes — outputs the full `∃ g, g ≠ 0, m', m' < d, Module (...) T_g, Module A_g T_g, IsScalarTower A_g R T_g, Module.Finite R T_g` tuple
- **Proof follows sketch**: yes — 5-phase implementation matching blueprint's "Annihilator → Nagata → Elimination → Localisation transport → Action-diamond subtlety"
- **notes**: closed; the `set_option synthInstance.maxHeartbeats 1000000` and `set_option maxHeartbeats 4000000` pragmas are documented with explanations (not red flags)

---

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` (`lem:gf_away_tower_descent`) ← **FOCUS LEMMA**
- **Lean target exists**: yes (line 1270)
- **Signature matches**: yes — `(A T : Type u) [CommRing A] [IsDomain A] [AddCommGroup T] [Module A T] {g : A} (hg : g ≠ 0) {h : Localization.Away g} (hh : h ≠ 0)`, conclusion `∃ f : A, f ≠ 0 ∧ Module.Free (Away f) (Loc (powers f) T)`
- **Proof follows sketch**: **yes — complete match** (see detailed analysis below)
- **notes**: CLOSED this iteration, axiom-clean

**Detailed verification of `free_localizationAway_of_away_tower`:**

The blueprint specifies:
> *"Witness `f := g·a`, single product. Use `IsLocalization.surj` to clear the denominator of `h` → get `a ∈ A`, `s ∈ powers g` with `h · ā_s = ā_a`; then `ā_a` associated to `h`, `a ≠ 0`, `f := g·a ≠ 0`. Apply `IsLocalization.Away.mul_of_associated`. The composite `ψ = mk_{powers h} ∘ mk_{powers g}` satisfies `IsLocalizedModule (powers (g·a)) ψ` (verified from three axioms). Transport freeness via `Module.Free.of_ringEquiv` / `Basis.mapCoeffs`."*

Lean implementation (lines 1278–1373):

1. **Witness `f := g·a`**: `obtain ⟨⟨a, s⟩, hs⟩ := IsLocalization.surj (Submonoid.powers g) h` → `hf0 : g * a ≠ 0` → `refine ⟨g * a, hf0, ?_⟩` ✓

2. **`IsBaseChange.comp` route** (blueprint: "verify from three axioms"): 
   ```
   hbcψ : IsBaseChange (Away h) ψ :=
     (IsLocalizedModule.isBaseChange (powers g) (Away g) (mk g T)).comp
       (IsLocalizedModule.isBaseChange (powers h) (Away h) (mk h (T_g)))
   ```
   Then `isLocalizedModule_iff_isBaseChange.mpr hbcψ` gives `IsLocalizedModule (powers (g*a)) ψ`. The blueprint says "no packaged lemma supplies it" — the Lean found `IsBaseChange.comp`, which is cleaner than hand-verifying the axioms but mathematically identical. ✓

3. **`Module.Basis.mapCoeffs` route** (transport freeness):
   ```
   Module.Free.of_basis
     ((Module.Free.chooseBasis (Away h) D).mapCoeffs σ.symm.toRingEquiv hcompat)
   ```
   This maps the `A_h`-basis to an `A_{g·a}`-basis via the ring iso `σ.symm`. ✓

4. **`LinearEquiv.extendScalarsOfIsLocalization` route** (upgrade module isomorphism):
   ```
   εL := LinearEquiv.extendScalarsOfIsLocalization (powers (g*a)) (Away (g*a)) ε
   exact Module.Free.of_equiv' hDfree εL.symm
   ```
   ✓

All three key elements named in the directive are present and correctly used.

**Minor discrepancy** (informational only): blueprint says the `IsLocalizedModule (powers (g·a)) ψ` step "is verified directly from the defining properties; no packaged lemma supplies it." The Lean uses `IsBaseChange.comp`, which is a packaged Mathlib composition. This is an improvement over hand-verification, not a deviation.

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (`lem:gf_polynomial_core`) ← **PARTIAL**
- **Lean target exists**: yes (line 1392)
- **Signature matches**: yes — `(A : Type u) [CommRing A] [IsDomain A] [IsNoetherianRing A] (d : ℕ) (N : Type u)` with shared universe (blueprint notes this is load-bearing)
- **Proof follows sketch**: partial — see red flags below
- **notes**: Steps 1 (generic-rank SES), 2 (reindex), 5 (splice) are fully assembled; steps 3–4 have `sorry`

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (`thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (line 1567)
- **Signature matches**: yes — full signature with `[IsNoetherianRing A]`, `[Algebra.FiniteType A B]`, `[Module.Finite B M]`, `[IsScalarTower A B M]`
- **Proof follows sketch**: partial — primary route (module-finite over A) is closed; surviving residue `sorry`
- **notes**: blueprint has no `\leanok`, consistent with partial status

### `\lean{AlgebraicGeometry.genericFlatness}` (`thm:generic_flatness`)
- **Lean target exists**: yes (line 1629)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType]`, conclusion with `(V : S.Opens)` nonempty and affine flatness condition
- **Proof follows sketch**: partial — extracts `U₀` non-empty affine open, then `sorry` for the geometric assembly (affine cover, product of f_i, flatness-from-freeness)
- **notes**: blueprint has no `\leanok`, consistent with partial status

---

## Red flags

### Placeholder / suspect bodies

- `GenericFreeness.exists_localizationAway_finite_mvPolynomial` at line 516: `:= sorry` at step 2 (denominator-clearing fold over the finite generating set). Blueprint has no `\leanok` for this lemma; documented as "genuine remaining content of L4."

- `GenericFreeness.exists_free_localizationAway_polynomial` at line 1517: `:= sorry` at steps 3–4 (IH application at base `A_g` + descent via `free_localizationAway_of_away_tower`). **Blocked by OreLocalization instance-presentation diamond** (see diagnosis below). Blueprint has no `\leanok`. Detailed diagnosis present in code comments.

- `genericFlatnessAlgebraic` at line 1597: `:= sorry` for the surviving-residue branch (finite-type-algebra case beyond module-finite-over-A). Blueprint has no `\leanok`; assembly route is documented in the Lean comment.

- `genericFlatness` at line 1664: `:= sorry` for the geometric assembly. Blueprint has no `\leanok`; the remaining geometric steps are described in the comment.

**None of these are must-fix per the severity rules**: no `\leanok` exists in the blueprint for any of them, so the blueprint does not claim them complete. All sorries are documented with precise explanations and are consistent with the blueprint's acknowledged open items.

### OreLocalization instance diamond in `exists_free_localizationAway_polynomial` (step 3–4)

The sorry at line 1517 has a detailed diagnosis (lines 1499–1516). The three mismatching layers are:
1. `CommSemiring A_g`: `OreLocalization.instCommSemiring` (helper) vs `CommRing.toCommSemiring` (IH path)
2. `AddCommMonoid T_g`: `OreLocalization.instAddCommMonoidOreLocalization` vs `OreLocalization.instAddCommGroup.toAddCommMonoid`
3. `Module/SMul A_g T_g`: `OreLocalization.instModule/instSMul` (helper direct) vs `hmod2/DistribMulAction.toDistribSMul.toSMul` (reindex)

The two clean resolutions are:
- Make `gf_torsion_reindex` emit over the canonical `OreLocalization.*` instances (change confined to that lemma's final `exact`)
- Restate `free_localizationAway_of_away_tower`'s `hfree` hypothesis over the `CommRing.toCommSemiring`/`hmod2` presentation

This is a purely Lean-elaboration issue; the mathematics is complete.

### Excuse-comments
None. All comments adjacent to sorries are precise mathematical diagnoses or forward-looking assembly notes. No "this is wrong but works for now" patterns.

### Axioms / Classical.choice
None detected. The `classical` tactic is used in several proofs but only for decidability; no non-standard axioms introduced.

---

## Unreferenced declarations (informational)

All substantive declarations in the Lean file have corresponding `\lean{...}` references in the blueprint. Confirmed:
- `pullbackModuleAddEquiv` / `finite_of_pullbackModuleAddEquiv` / `pullback_isScalarTower` → `lem:gf_pullback_module_transport`
- `finite_of_quotientRingEquiv` → `lem:gf_finite_of_quotient_ringequiv`
- `isLocalizedModule_restrictScalars` → `lem:gf_islocalizedmodule_restrictscalars`

Private Nagata helpers (`T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`) are all blueprint-pinned with their full qualified names.

---

## Blueprint adequacy for this file

- **Coverage**: 35/35 project declarations have a `\lean{...}` block in the chapter (plus 7 Mathlib-backed via `\mathlibok`). 0 substantive unreferenced declarations.

- **Proof-sketch depth**: **adequate**. Closed lemmas: proof sketches are detailed and correct. Partial lemmas: the blueprint accurately delineates the boundary between closed and open work. Specifically:
  - `lem:gf_away_tower_descent`: fully detailed 4-step proof matching the closed Lean proof
  - `lem:gf_polynomial_core` step 4: correctly documents the `free_localizationAway_of_away_tower` call and the single-product witness `f = g·a`
  - The OreLocalization diamond is NOT a blueprint gap: it is a Lean type-theory elaboration issue orthogonal to the mathematical content. The chapter's documentation of step 3 (IH at base `A_g`) and step 4 (descent) is mathematically correct and sufficient.

- **Hint precision**: **precise**. All `\lean{...}` hints name exactly the Lean declarations that exist in the file with matching signatures. The encoding notes for non-trivial signatures (L4a's `IsLocalization.map` encoding, L4's extra `Algebra` existential binder) correctly annotate the blueprint.

- **Generality**: **matches need**. No parallel API was written to cover a blueprint-generality gap.

- **Recommended chapter-side actions**:
  1. (minor) Add a `% NOTE:` in `lem:gf_polynomial_core`'s proof at step 3 flagging the OreLocalization instance-presentation diamond and the two clean resolution paths. This would help future provers understand why the otherwise-immediate IH application is blocked.
  2. (minor) Update `lem:gf_away_tower_descent`'s LEAN DEPS comment to reflect that `IsBaseChange.comp` is used rather than direct axiom verification (the current comment says "no packaged lemma supplies it").

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 2 (blueprint comment improvements — diamond note at L5 step 3; IsBaseChange.comp remark at `lem:gf_away_tower_descent`)

**Overall verdict**: `free_localizationAway_of_away_tower` is closed and its proof correctly implements all three blueprint-specified routes (IsBaseChange.comp, Basis.mapCoeffs, extendScalarsOfIsLocalization) with witness `f = g·a`; the L5 sorry at steps 3–4 is a Lean-layer OreLocalization diamond that is correctly diagnosed and does not reflect a blueprint inadequacy; the file faithfully follows the chapter throughout, with all 35 project declarations present and signature-correct.
