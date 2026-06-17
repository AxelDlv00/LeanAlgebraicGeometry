# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
015

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches the chapter's informal statement
- **Proof follows sketch**: yes — uses `Module.finitePresentation_of_finite` + `Module.FinitePresentation.exists_free_localizedModule_powers` at the fraction ring, exactly as the blueprint describes; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — derives flatness from freeness via `Module.Flat.of_free`
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes
- **Signature matches**: yes — `[Module.Finite A B]` (module-finite algebra) gives `Module.Finite A M` by transitivity
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes
- **Signature matches**: yes — `htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M)` correctly encodes `M_K = 0`
- **Proof follows sketch**: yes — takes product of annihilators of a finite generating set exactly as the Nitsure base-case proof describes; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — delegates to `LocalizedModule.map_injective/surjective/exact`; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes
- **Signature matches**: yes — `{f f' f'' : A} (hf : f = f' * f'')` matches the factorisation premise
- **Proof follows sketch**: yes — constructs the `A_{f'} → A_f` ring map via `IsLocalization.Away.awayToAwayLeft`; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses projectivity + splitting; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — assembles L3a + L3b + L3c exactly as the blueprint's proof describes; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (chapter: `lem:gf_clear_one_denominator`)
- **Lean target exists**: yes
- **Signature matches**: yes — blueprint comment documents the encoding difference (`IsLocalization.map (FractionRing A) (RingHom.id A) hle` in place of the literal `algebraMap (Localization.Away g) (FractionRing A)`, acknowledged in an in-blueprint `% NOTE`); mathematically identical
- **Proof follows sketch**: yes — uses `IsLocalization.exist_integer_multiples`; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes
- **Signature matches**: yes — the extra existential binder `(_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))` is documented in a `% NOTE` in the blueprint and is mathematically neutral; matches the landed decl
- **Proof follows sketch**: partial — Step 1 (Noether normalisation over `FractionRing A`) is present and axiom-clean; Step 2 (denominator-clearing fold over the finite generating set) is `:= sorry`
- **notes**: pre-existing sorry from earlier iters; the blueprint's Steps 2–3 are described but not yet formalized

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (chapter: `lem:gf_generic_rank_ses`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — generic-rank extraction via `Module.finrank`, denominator-clearing via `IsLocalization.exist_integer_multiples`, injectivity from linear independence; all axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (chapter: `lem:gf_torsion_annihilator`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — delegates to `Submodule.annihilator_top_inter_nonZeroDivisors`; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.T1}` (chapter: `def:gf_nagata_T1`)
- **Lean target exists**: yes (as `private noncomputable abbrev T1`)
- **Signature matches**: yes — parametrised by scalar `c : k`, sending `X_0 ↦ X_0`, `X_i ↦ X_i + c • X_0^{r_i}` for `i ≠ 0`, exactly as stated
- **Proof follows sketch**: N/A (definition)
- **notes**: `private` — the `\lean{...}` pin names a declaration inaccessible from outside the file; blueprint-tooling `\leanok` verification via `lean_decls` will fail for this and the other Nagata-section private declarations (see minor red flag below)

### `\lean{AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg}` / `\lean{AlgebraicGeometry.GenericFreeness.T}` / `\lean{AlgebraicGeometry.GenericFreeness.lt_up}` / `\lean{AlgebraicGeometry.GenericFreeness.sum_r_mul_ne}` / `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_zero_t}` / `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne}` / `\lean{AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t}` / `\lean{AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq}` / `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm}` / `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ}` (Nagata machinery block)
- **Lean target exists**: yes — all present in the `NagataNormalization` section, matching their blueprint entries
- **Signature matches**: yes for all
- **Proof follows sketch**: yes for all — degree bookkeeping follows the Mathlib `private`-lemma transcription described in the blueprint comment
- **notes**: all are `private`; same `\leanok` tooling caveat as `T1` above (minor)

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (chapter: `lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A : Type*) [CommRing A] [IsDomain A] (m : ℕ) (F : MvPolynomial (Fin (m+1)) A) (hF : F ≠ 0) : ∃ (g : A) (_ : g ≠ 0) (e : … ≃ₐ[A] …), IsUnit (…).leadingCoeff` matches the blueprint's `% LEAN SIGNATURE` block verbatim
- **Proof follows sketch**: yes — applies `T_leadingcoeff_eq`, picks `g := coeff v F`, uses `IsLocalization.Away.algebraMap_isUnit`; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (chapter: `lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes
- **Signature matches**: yes — encoded as `RingHom.Finite` of the composite ring map, as documented in the blueprint `% NOTE (iter-012 resync, F-3a)`
- **Proof follows sketch**: yes — rescales to a monic polynomial, invokes `Polynomial.Monic.finite_quotient`, transports along the `finSuccEquiv` algebra isomorphism; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}` / `\lean{AlgebraicGeometry.GenericFreeness.finite_of_pullbackModuleAddEquiv}` / `\lean{AlgebraicGeometry.GenericFreeness.pullback_isScalarTower}` (chapter: `lem:gf_pullback_module_transport`)
- **Lean target exists**: yes — all three Lean declarations match the three statements bundled under one blueprint block
- **Signature matches**: yes
- **Proof follows sketch**: yes — all axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` (chapter: `lem:gf_finite_of_quotient_ringequiv`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` (chapter: `lem:gf_islocalizedmodule_restrictscalars`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — verifies `IsLocalizedModule` three obligations manually; axiom-clean
- **notes**: none

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (chapter: `lem:gf_torsion_reindex`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d : ℕ) (hd : 0 < d) … (htors : Module.IsTorsion …) : ∃ (g : A) (_ : g ≠ 0) (m' : ℕ) (_ : m' < d) (⋯), Module.Finite …` matches the blueprint's `% LEAN SIGNATURE` block
- **Proof follows sketch**: yes — assembles L5b.1 + L5b.2 + L5b.3 + transport helpers in the order the blueprint's proof describes; axiom-clean
- **notes**: set_option `maxHeartbeats 4000000` / `synthInstance.maxHeartbeats 1000000` used (consistent with the known heartbeat-fragility annotation near L1146 in the directive); builds green under `lake build`

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A : Type u) … (d : ℕ) (N : Type u) … : ∃ f : A, f ≠ 0 ∧ Module.Free …` matches; shared universe `Type u` is load-bearing (as documented in the blueprint `% NOTE (iter-008 signature)`)
- **Proof follows sketch**: partial — base case (`d = 0`) and the torsion sub-case of the inductive step are present and axiom-clean; the IH+descent sub-step (Steps 3–4 of the blueprint's proof) is a single `sorry` at line 1417, labelled clearly as a residual obligation
- **notes**: the sorry is the subject of the iter-015 directive; see **Red flags** and **Blueprint adequacy** sections below

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free … M` matches
- **Proof follows sketch**: partial — primary route (module-finite over `A`) is present and axiom-clean; surviving residue (finite over a finite-type algebra) is `:= sorry` at line 1497
- **notes**: pre-existing sorry from earlier iters

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType] : ∃ (V : S.Opens), (V : Set S).Nonempty ∧ ∀ …, Module.Flat …` matches the blueprint's `% LEAN SIGNATURE HEADER`
- **Proof follows sketch**: partial — geometric assembly setup (`obtain` of the non-empty affine open `U₀`) is present; the remaining geometric-assembly content is `:= sorry` at line 1564
- **notes**: pre-existing sorry from earlier iters

---

## Red flags

### Placeholder / suspect bodies

- **`AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower`** at lines 1266–1306: body is `:= sorry`. This is a **new declaration added this iteration** (per the directive) and carries a detailed in-proof proof plan. The declaration is substantive: it packages the "descent of generic freeness across a tower of `Away` localisations" — exactly the Step 4 gap in `exists_free_localizationAway_polynomial`. There is **no corresponding `\lean{...}` entry anywhere in the blueprint chapter**. (Confirmed; the chapter has no lemma block or `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` pin.)

- **`AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial`** at line 516: `:= sorry` after Step 1 (Noether normalisation). Blueprint (`lem:gf_noether_clear_denominators`) claims a substantive three-step proof. Pre-existing from earlier iters.

- **`AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial`** at line 1417: the IH+descent sub-block is `:= sorry`. Pre-existing; the surrounding code for base case and torsion sub-case is axiom-clean.

- **`AlgebraicGeometry.genericFlatnessAlgebraic`** at line 1497: surviving-residue branch `:= sorry`. Pre-existing.

- **`AlgebraicGeometry.genericFlatness`** at line 1564: geometric assembly `:= sorry`. Pre-existing.

### Excuse-comments

None found. The proof-plan comments in `free_localizationAway_of_away_tower` and `exists_free_localizationAway_polynomial` are technical road-maps, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims

None introduced. `classical` is used in several proofs (L1, L5a, `gf_clear_one_denominator`, `gf_torsion_reindex`, `exists_free_localizationAway_polynomial`) appropriately for decidability; no `axiom` declarations.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have **no `\lean{...}` reference in the blueprint**:

1. **`AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower`** (lines 1266–1306) — **substantive, flagged**. This is the new iter-015 helper for the tower-localisation descent. Mathematical content: "if `LocalizedModule (powers h) (LocalizedModule (powers g) T)` is free over `Localization.Away h`, then there exists `f ∈ A`, `f ≠ 0`, with `LocalizedModule (powers f) T` free over `Localization.Away f`." This is not an implementation detail; it is the precise fact that the `exists_free_localizationAway_polynomial` IH+descent step (Step 4 in the blueprint's proof of `lem:gf_polynomial_core`) requires.

All other declarations without explicit `\lean{...}` pins are internal `private` helpers (`finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`, `T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`) — all of which *are* in fact referenced in the blueprint under their respective block headers (the Nagata-machinery blocks in § on Nagata change-of-variables machinery do carry `\lean{...}` pins for them, just that they are `private`). See the minor note below.

---

## Blueprint adequacy for this file

### Coverage
**23/24** substantive non-Mathlib Lean declarations have a corresponding `\lean{...}` block in the chapter. The single unreferenced substantive declaration is `free_localizationAway_of_away_tower` (new this iter).

Private Nagata-section declarations (11 items: `T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`) are all blueprint-referenced but are `private` in Lean; the blueprint `\lean{...}` pins will not resolve from outside the file, so automated `\leanok` checks via `lean_decls` will silently fail for them. This is a pre-existing minor issue noted here for completeness.

### Proof-sketch depth
**Under-specified** in one passage: the proof of `lem:gf_polynomial_core` (blueprint lines 1204–1209 in Step 4: "Descend the witness from `A_g` to `A`") states:

> "…thus freeness of `(T_g)_h` over `(A_g)_h` transports to freeness of `T_{g a}` over `A_{g a}` by the localisation-tower free-transport fact `\cref{lem:gf_splice_shortExact_free_transport}`."

**This is incorrect.** `lem:gf_splice_shortExact_free_transport` (`free_localizationAway_of_free_of_eq_mul`) handles a *single* localisation at `f = f' * f''` given freeness at `f'`. It does **not** handle the iterated-localisation case where the starting freeness is on the doubly-localised module `LocalizedModule (powers h) (LocalizedModule (powers g) T)` rather than the simply-localised `LocalizedModule (powers h) T`. The Lean prover needed to introduce a new, separate lemma (`free_localizationAway_of_away_tower`) specifically for this tower case, whose proof plan (lines 1274–1305) involves:
- extracting a numerator `a ∈ A` with `h ∼ a / g^k`,
- identifying `(A_g)_h ≅ A_{g·a}` via `IsLocalization.Away.mul_of_associated`,
- proving that the composite localisation map `T →ₗ[A] LocalizedModule (powers h) (LocalizedModule (powers g) T)` satisfies `IsLocalizedModule (powers (g·a))` (the "localisation-of-localisation" composition step that Mathlib does not yet package), and
- transporting freeness across the ring isomorphism and module identification.

None of this detail appears in the blueprint. A prover following the blueprint's Step 4 prose and attempting to apply `free_localizationAway_of_free_of_eq_mul` directly would find the types do not unify.

**The following blueprint blocks need expansion:**
- `lem:gf_polynomial_core` proof, Step 4: replace the reference to `lem:gf_splice_shortExact_free_transport` with a new named lemma block `lem:gf_free_localizationAway_of_away_tower` (see recommended actions below).

All other proof sketches (`lem:gf_torsion_base`, `lem:gf_torsion_reindex`, `lem:gf_generic_rank_ses`, the Nagata-machinery lemmas, transport helpers) are adequate — their Lean proofs follow the blueprint's stated argument faithfully.

### Hint precision
**Loose in one instance**: the blueprint `% LEAN SIGNATURE` block for `lem:gf_clear_one_denominator` shows `algebraMap (Localization.Away g) (FractionRing A)` but a `% NOTE` acknowledges this form doesn't typecheck; the landed Lean uses `IsLocalization.map (FractionRing A) (RingHom.id A) hle`. The mathematical content is identical and the note is accurate — no action needed.

Otherwise: **precise**. The blueprint carries verbatim `% LEAN SIGNATURE` blocks for every pinned declaration, and these agree with the landed code.

### Generality
**Matches need** for all formalized declarations.

### Recommended chapter-side actions (for a blueprint-writing subagent)

1. **[Critical] Add a new named lemma block `lem:gf_free_localizationAway_of_away_tower`** immediately before `lem:gf_polynomial_core` (or in a new "Tower-descent helper" subsection at the end of `sec:gf_devissage_chain`). Contents:
   - `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}`
   - `\uses{lem:gf_splice_shortExact_free_transport}` (or remove if the proof does not use it)
   - Statement: "If after inverting `g ∈ A` and then `h ∈ A_g = Localization.Away g` the `A`-module `T` becomes free, then `T` becomes free after inverting a single non-zero `f ∈ A` (specifically `f = g · a` where `a` is a numerator of `h`)."
   - Proof sketch: clear the denominator of `h = a / g^k`; the iterated localisation `(A_g)_h ≅ A_{ga}` and `(T_g)_h ≅ T_{ga}`; transport freeness via the ring isomorphism and the localisation-of-localisation composite-map identification.

2. **[Critical] Correct Step 4 of the proof of `lem:gf_polynomial_core`**: replace "`\cref{lem:gf_splice_shortExact_free_transport}`" with "`\cref{lem:gf_free_localizationAway_of_away_tower}`" and expand the sentence to describe the tower-descent argument rather than the single-product one.

3. **[Minor] Mark the Nagata-section `\lean{...}` pins as `private`** or annotate them with a comment noting they are file-scoped; this avoids silent `\leanok` verification failures for automated blueprint-doctor runs.

---

## Severity summary

| Finding | Severity |
|---|---|
| `free_localizationAway_of_away_tower` has no blueprint entry (`\lean{...}` pin + lemma block) despite being a named, substantive mathematical lemma used in the L5 assembly | **major** |
| Blueprint Step 4 of `lem:gf_polynomial_core`'s proof cites the wrong lemma (`lem:gf_splice_shortExact_free_transport`) for the tower-descent step; a prover following the blueprint cannot execute Step 4 as written because the types do not unify — this is a blueprint adequacy failure on a proof step currently blocking closure of `exists_free_localizationAway_polynomial` | **must-fix-this-iter** |
| `free_localizationAway_of_away_tower` body is `:= sorry` | informational (the declaration itself has no blueprint entry claiming it substantive; the sorry is the intended state this iter per the directive) |
| `exists_localizationAway_finite_mvPolynomial` body is `:= sorry` (Step 2 onward) — blueprint claims substantive proof | **must-fix-this-iter** (pre-existing; already in scope from prior iters) |
| `genericFlatnessAlgebraic` surviving-residue branch `:= sorry` | **must-fix-this-iter** (pre-existing) |
| `genericFlatness` geometric assembly `:= sorry` | **must-fix-this-iter** (pre-existing) |
| `exists_free_localizationAway_polynomial` IH+descent sub-step `:= sorry` at line 1417 | **must-fix-this-iter** (pre-existing; `lem:gf_polynomial_core` proof incomplete) |
| Nagata-section `private` declarations have blueprint `\lean{...}` pins that cannot be resolved by automated `lean_decls` tooling | **minor** |

**Overall verdict:** The Lean file faithfully follows the blueprint for all formalized declarations (signature and proof-strategy match throughout), and introduces one new well-named helper (`free_localizationAway_of_away_tower`) that is **not backed by any blueprint entry** and whose necessity exposes an inaccuracy in the blueprint's proof of `lem:gf_polynomial_core` Step 4 (citing a lemma that does not apply to the iterated-localisation case). The blueprint-writing subagent should add a lemma block for the tower-descent helper and correct the Step 4 citation before the next prover round attempts to close the L5 sorry.

Total declarations checked: 24 (excluding Mathlib anchors) + 11 private Nagata helpers = 35 total. Red flags: 1 new (missing blueprint entry for `free_localizationAway_of_away_tower`), 4 pre-existing must-fix sorries, 1 minor.
