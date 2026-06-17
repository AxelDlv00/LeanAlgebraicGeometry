# Lean Audit Report

## Slug
iter199

## Iteration
199

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none flagged (all sorries are documented gaps)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L300–314 `order_neg`** (new iter-199): `@[simp]` lemma stating `order Y (-f) = order Y f`. Proof uses the squaring identity `(-f)^2 = f^2`, applies `map_pow` on `Ring.ordFrac`, then `WithZero.log_pow` on both sides, then `smul_right_injective ℤ (2 : ℕ) ≠ 0` to cancel the `2 •` factor. Mathematically sound. Hypothesis minimality correct: `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` is required by the `order` definition; `[IsIntegral X]` + `[IsLocallyNoetherian X]` are inherited from the definition. No over-constraint.
  - **L327–338 `order_pow_of_ne_zero`** (new iter-199): `ord_Y(f^n) = n * ord_Y(f)` for `hf : f ≠ 0`. Proof by induction: zero case uses `simp [Scheme.RationalMap.order]`; succ case uses `pow_succ` + `order_mul_of_ne_zero Y (pow_ne_zero k hf) hf` + `ih` + `push_cast; ring`. Correct. The `hf : f ≠ 0` hypothesis is necessary (for `pow_ne_zero` and for `order_mul_of_ne_zero`); no over-constraint.
  - L362 `rationalMap_order_finite_support`: `f = 0` branch closed axiom-clean (L368–373); `f ≠ 0` branch is `sorry` at L415 with a detailed comment citing Stacks 02RV and a resolution path. Expected.
  - L694–723 `principal_degree_zero`: constant branch closes via `Finsupp.sum_zero_index`; non-constant branch is `sorry` at L723, gated on `morphismToP1OfGlobalSections`. Expected.
  - L935–1152 `isRegularInCodimOneProjectiveLineBar`: correctly demoted from `instance` to `theorem` (iter-196 must-fix addressed). The body closes the DVR chain through the affine cover; the residual `hy_ne_bot` proof (L1101–1146) is now axiom-clean via the generic-point coheight argument. The former inline `sorry` for the maximality bridge is replaced by an axiom-clean proof of `hy_ne_bot`. This is a genuine iter-197 advance.
  - L1189–1293 `degree_positivePart_principal_eq_finrank`: typed-sorry at L1293 after Steps A–C push-through. Expected gap; function-field-correspondence bridge is the blocker.

---

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (sorries are in expected places)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L1198–1276 `exists_minimalSurjection_finite_localRing`** (new iter-199): signature `∃ n f, Function.Surjective f ∧ n = finrank κ (κ ⊗ M) ∧ ker f ≤ 𝔪 • ⊤`. Proof uses `Module.finBasis`, `TensorProduct.mk_surjective`, `IsLocalRing.span_eq_top_of_tmul_eq_basis`, `LinearIndependent`, and `IsLocalRing.residue_eq_zero_iff`. Axiom-clean as claimed. Hypotheses: `[CommRing R] [IsLocalRing R]` and `[Module.Finite R M]` are all needed; no `[IsNoetherianRing R]` is required (correct — finiteness alone suffices for the Nakayama lift). Well-constrained.
  - The `depth_eq_smallest_ext_index` theorem (L295–619) appears fully closed without residual sorries — both forward and backward directions are substantively implemented. This is a significant prior-iter advance.
  - `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` (L1020–1123) and `exists_isSMulRegular_of_one_le_depth` (L1136–1171): both axiom-clean, no issues.
  - `auslander_buchsbaum_formula_succ_pd` (L1398–1432): single typed `sorry` at L1432 with documented substrate gaps (1)–(3) remaining; gap (4) closed. Expected.
  - `auslander_buchsbaum_formula` (L1452–1516): base case `pd = 0` is axiom-clean via `depth_pi_const_eq_depth_of_nonempty`; inductive step delegates to `auslander_buchsbaum_formula_succ_pd`. Expected state.
  - `CohenMacaulay` class (L1538–1543): definition is correct — `depth(R) = ringKrullDim R` with the numeric coercion to `WithBot ℕ∞`.
  - `finrank_cotangentSpace_quot_span_singleton_succ` (beyond L1657): complex partial proof with structural sorry for Steps 4–7 of the cotangent dim-drop. Expected.

---

### AlgebraicJacobian/Albanese/CodimOneExtension.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (residual sorries are documented)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L476–513 `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`** (new iter-199): constructs `(RingHom.ker (algebraMap Sₘ κ)).Cotangent ≃ₗ[Sₘ] κ ⊗_{Sₘ} Ω[Sₘ⁄R]`. Three-step proof: (1) injection via `FormallySmooth.iff_split_injection`; (2) surjection via `exact_kerCotangentToTensor_mapBaseChange` + `Subsingleton.elim` collapsing `mapBaseChange x = 0`; (3) `LinearEquiv.ofBijective`. All typeclass parameters are necessary: `[IsLocalRing Sₘ]` for `ResidueField`; `[FormallySmooth R Sₘ]` for the injection retraction; `[FormallySmooth R (ResidueField Sₘ)]` for `iff_split_injection` at the residue-field level; `[Subsingleton (Ω[κ⁄R])]` for the surjection. **No over-constraint**.
  - **L527–539 `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue`** (new iter-199): repackages the above by rewriting `ker(algebraMap Sₘ κ) = maximalIdeal Sₘ` via `IsLocalRing.ker_residue`. Axiom-clean. No issues.
  - **L563–592 `finrank_cotangentSpace_of_formallySmooth_residue`** (new iter-199): composes the maximal-ideal iso with `LinearEquiv.extendScalarsOfSurjective` (promotion to κ-linear via the residue surjection), `LinearEquiv.finrank_eq`, and the 6.B-RHS substrate. Axiom-clean. Hypotheses correctly include `[Nontrivial Sₘ]` (needed for `finrank_eq_of_rank_eq`) and `[Module.Free Sₘ (Ω[Sₘ⁄R])]` (needed for the rank computation). **No over-constraint**.
  - **L615–629 `finrank_cotangentSpace_of_bijective_algebraMap_residue`** (new iter-199): bundled form replacing the three typeclass hypotheses with `hbij : Function.Bijective (algebraMap R (ResidueField Sₘ))`. Derives `FormallySmooth R (ResidueField Sₘ)` via `RingHom.formallySmooth_algebraMap.mp (RingHom.FormallySmooth.of_bijective hbij)` and `Subsingleton (Ω[κ⁄R])` via `KaehlerDifferential.subsingleton_of_surjective R _ hbij.surjective`. Axiom-clean. The `hbij` hypothesis correctly replaces three separate instances. **No over-constraint**.
  - **L751–875 `isRegularLocalRing_stalk_of_smooth`** (not new, carries `sorry` at L875): Stage 6 sub-gap (ii.B) — smooth-algebra Krull-dim formula (Stacks 00OE) — remains the single residual `sorry`. The four new iter-199 helpers (`cotangent_iso_*`, `finrank_cotangentSpace_*`) are correctly wired into the proof body but don't yet close the `sorry` because sub-gap (ii.B) is a distinct gap (not resolvable by the cotangent-iso helpers alone). Documented at L826–874.
  - `extend_of_codimOneFree_of_smooth` (L1033–1072): `sorry` at L1072. Expected — gated on Stage 6 + Stacks 0AVF.
  - `indeterminacy_pure_codim_one_into_grpScheme` (L1101–1147): `sorry` at L1147. Expected — Krull principal ideal scheme-level intersection bridge missing.
  - `mem_domain_iff_exists_partialMap_through_point` (L1213–1227): axiom-clean definitional reshuffle. Correct.

---

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (all bodies are `⟨sorry⟩` in Prop-valued instances — correctly isolated)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L346–349 `instHasSmoothProperQuotient`** (directive focus): `instance instHasSmoothProperQuotient ... : HasSmoothProperQuotient α := ⟨sorry⟩`. This is the carrier-soundness probe pattern **correctly applied**: `HasSmoothProperQuotient` is a `Prop`-valued typeclass (L338–341) with a single field `is_representable : P.IsRepresentable`. The `⟨sorry⟩` provides a sorry-inhabiting instance of the `Prop` wrapper. The theorem `smoothProperQuotient` at L377–391 extracts `HasSmoothProperQuotient.is_representable (_α := α)` — the theorem body itself contains no `sorry`. Consumers that hypothesize `[HasSmoothProperQuotient α]` **explicitly** remain kernel-clean. This is semantic improvement over baking the sorry into the theorem body: the theorem body is axiom-clean and the sorry is localised.
  - The same `⟨sorry⟩`-instance pattern is applied to `instHasPicSharp` (L147–149), `instHasDivFunctor` (L174–176), `instHasPicScheme` (L232–236), `instHasAbelMap` (L290–294), `instPicSharpRepresentable` (L442–446), `instPicSchemeGroupObject` (L498–502). All consistent with the carrier-soundness probe.
  - **SorryAx-via-instance-synthesis audit**: `instHasSmoothProperQuotient` is a typeclass instance (not `noncomputable`). Since `HasSmoothProperQuotient` is `Prop`-valued, all sorry propagation stays in `Prop`-land and does not contaminate `Type`-valued computations. The `smoothProperQuotient` theorem auto-synthesises `instHasSmoothProperQuotient` whenever `[HasSmoothProperQuotient α]` is not explicitly supplied, which introduces `sorryAx` transitively into any use of `smoothProperQuotient` without an explicit typeclass argument. This is **intentional and documented** (L323–326). It is not a new leak; it is the same pattern used for all six other `instHas*` instances in the file, and the pattern was validated by the iter-196 carrier-soundness probe (verdict CONFIRMED iter-199 per the docstring).
  - The carrier `def picSharp` (L139–142) and `def divFunctor` (L167–170) extract via `Classical.choice` from the `Prop`-valued nonemptiness witnesses. These are `noncomputable` and kernel-clean: the choice does not produce `sorryAx` — it only produces a possibly-underspecified term; the sorry is in the instance providing the `Nonempty (...)` witness, which is `Prop`-valued and hence erased.

---

## Must-fix-this-iter

**(none)**

No declaration in the four audited files meets the must-fix threshold:
- No excuse-comments ("temporary wrong def", "placeholder", "will fix later") found.
- No weakened-wrong definitions: all skeleton bodies are either axiom-clean or a `⟨sorry⟩` in a Prop-valued constructor, correctly documented.
- No parallel APIs of existing Mathlib created.
- All `sorry` occurrences are in expected positions consistent with the documented blockers (Hartshorne 6.1, Stacks 00OE, Stage 6 cotangent bridge, Altman–Kleiman descent).
- The `instHasSmoothProperQuotient ⟨sorry⟩` pattern is the carrier-soundness probe correctly applied; the sorry is semantically isolated in a `Prop`-valued typeclass, not baked into a `Type`-valued body.

---

## Major

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:300–314` — `order_neg` proof uses a squaring detour (`(-f)^2 = f^2 → 2•ord(-f) = 2•ord(f) → ord(-f) = ord(f)`) rather than the more direct `order_inv` route (since `-f = (-1) * f` and `order_inv` gives `ord(f^{-1}) = -ord(f)` for the unit `-1`). The squaring proof is mathematically valid, but the direct route via `order_mul_of_ne_zero` + `order_units_inv` on `-1 : K(X)ˣ` would be shorter and avoid the `2 ≠ 0` cancellation subtlety. Not a correctness issue — a code-quality note for future simplification.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:751–875` — `isRegularLocalRing_stalk_of_smooth` still ends in `sorry` at L875. The four new iter-199 helpers (cotangent iso + finrank) are correctly wired as side-build but do not yet close the helper; the residual Stage 6 gap (ii.B) — Stacks 00OE smooth-algebra Krull-dim formula — is the sole remaining blocker. The "Closure pattern (post-(ii.B))" pseudo-code at L864–869 is an accurate, actionable recipe. Not a must-fix (the sorry is documented and appropriately scoped) but blocks `localRing_dvr_of_codim_one` and all downstream A.4.a content.

---

## Minor

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:28–35` — The "Status (iter-172 file-skeleton)" header comment is stale in the sense that the file is no longer a bare skeleton (many declarations are now filled). The comment has accumulated accurate per-declaration status in the `##` sections; the top-level framing could be updated to reflect the iter-199 state.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:28–43` — Same stale top-level "Status (iter-178 update)" note; iter-199 has significantly advanced the file. Not harmful, cosmetic.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:39–66` — "Status (iter-177 Lane 6 file-skeleton)" header; several declarations have partial or full axiom-clean bodies now. Cosmetic.

---

## Excuse-comments (always called out separately)

**(none)**

No excuse-comments found in any of the four audited files. All "TODO" and "iter-N+" annotations in comments are tracking notes (naming which iteration will address the gap) or technical descriptions of the Mathlib substrates needed, not excuses for leaving code wrong.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: iter-199 is clean — the 7 new declarations (2 in WeilDivisor, 1 in AuslanderBuchsbaum, 4 in CodimOneExtension) are well-formed with correct hypothesis minimality; the FGAPicRepresentability carrier-soundness refactor at L346 correctly applies the probe pattern; no sorryAx-via-synthesis leaks beyond the documented and intentional Prop-valued instance pattern.
