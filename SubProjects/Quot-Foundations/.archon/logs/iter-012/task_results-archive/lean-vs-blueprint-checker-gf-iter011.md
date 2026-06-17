# Lean ↔ Blueprint Check Report

## Slug
gf-iter011

## Iteration
011

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (lem:gf_torsion_annihilator)
- **Lean target exists**: yes — `AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator` at Lean line 636
- **Signature matches**: yes
  - Blueprint LEAN SIGNATURE (tex lines 639–646): `(A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] (d : ℕ) (T : Type*) [AddCommGroup T] [Module (MvPolynomial (Fin d) A) T] [Module.Finite …] (htors : Module.IsTorsion …) : ∃ F : MvPolynomial (Fin d) A, F ≠ 0 ∧ F ∈ Module.annihilator … T`
  - Lean declaration (lines 636–646): verbatim match.
- **Proof follows sketch**: yes — the proof applies `Submodule.annihilator_top_inter_nonZeroDivisors` (Mathlib anchor `lem:annihilator_meets_nonZeroDivisors`), uses `nonZeroDivisors.ne_zero`, and rewrites via `← Submodule.annihilator_top`. This matches the blueprint's one-step argument: pick an element in annihilator ∩ nonZeroDivisors, observe non-zero-divisor = non-zero in a domain.
- **notes**: Axiom-clean. No sorry. The proof closely follows the blueprint sketch.

---

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (lem:gf_nagata_monic_lastVar)
- **Lean target exists**: yes — `AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar` at Lean line 795
- **Signature matches**: yes
  - Blueprint LEAN SIGNATURE (tex lines 684–694): uses bound variable `n`; Lean uses `m`. Mathematically identical. All types, constraints, and conclusion match verbatim once `n` is renamed `m`.
- **Proof follows sketch**: yes — the proof applies the private `T_leadingcoeff_eq` (which carries out the Nagata substitution over a domain), extracts the leading coefficient, puts `g := coeff v F`, and uses `IsLocalization.Away.algebraMap_isUnit` + `hgunit.map MvPolynomial.C` to establish the unit property. This faithfully encodes the blueprint's argument: the top-total-degree monomial's coefficient becomes a unit after inverting it.
- **notes**: Axiom-clean. No sorry. The private section (lines 661–822) contains the Nagata normalisation machinery transcribed from Mathlib field lemmas to a domain; all are `private` and appropriately not blueprint-pinned. The argument follows the blueprint proof prose closely.

---

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (lem:gf_mvPolynomial_quotient_finite_monic)
- **Lean target exists**: yes — `AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar` at Lean line 852
- **Signature matches**: yes — with a **known, annotated encoding difference**
  - Blueprint LEAN SIGNATURE (tex lines 754–769) sketches: `letI : Algebra (MvPolynomial (Fin n) R) (… ⧸ …) := …comp…toAlgebra; Module.Finite … …`
  - Landed Lean (lines 855–858): `(…Ideal.Quotient.mk…comp…rename Fin.succ…toRingHom : MvPolynomial (Fin n) R →+* (… ⧸ …)).Finite`
  - The blueprint has a `% NOTE` at tex lines 735–738 explicitly recording this: "the formalized decl encodes finiteness as `RingHom.Finite` of the composite ring map rather than the `Module.Finite` + `letI : Algebra …` form sketched in the LEAN SIGNATURE below. Same math content; the `\lean{}` pin resolves correctly."
  - **Is `RingHom.Finite` equivalent to the blueprinted claim?** Yes — `RingHom.Finite f` for `f : R →+* S` is defined as `Module.Finite R S` with the `R`-module structure induced by `f`, which is exactly `Module.Finite (MvPolynomial (Fin n) R) (…⧸…)` with the algebra from `f.toAlgebra`. The `letI` in the blueprint and the `toAlgebra` in `RingHom.Finite`'s unfolding are the same structure. The encoding does not narrow the statement.
- **Proof follows sketch**: yes — the proof (lines 859–905) rescales `finSuccEquiv p` by the inverse of its unit leading coefficient to obtain a monic polynomial generating the same ideal, invokes `Polynomial.Monic.finite_quotient` (Mathlib anchor `lem:polynomial_monic_quotient_finite`), and transports finiteness along the `MvPolynomial (Fin n) R`-algebra isomorphism induced by `finSuccEquiv`. This matches the blueprint's proof sketch verbatim.
- **notes**: Axiom-clean. No sorry. The private `finSuccEquiv_rename_succ` helper (line 828) is an internal compatibility lemma used by this proof; it is appropriately private and non-blueprint-pinned.

---

### All other `\lean{...}` blocks (informational — not this iter's work)

| Label | Lean decl | Status |
|-------|-----------|--------|
| thm:generic_flatness_algebraic | `genericFlatnessAlgebraic` (line 1071) | Exists; primary route closed, finite-type residue `sorry` (pre-existing) |
| lem:gf_finite_module | `exists_free_localizationAway_of_finite` (line 105) | Axiom-clean |
| lem:fp_free_descent | `Module.FinitePresentation.exists_free_localizedModule_powers` | Mathlib (`\mathlibok`) |
| lem:gf_torsion_base | `exists_free_localizationAway_of_torsion` (line 168) | Axiom-clean |
| lem:noeth_prime_filtration | `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` | Mathlib (`\mathlibok`) |
| lem:gf_splice_shortExact_localized_exact | `exact_localizedModule_powers_of_shortExact` (line 220) | Axiom-clean |
| lem:gf_splice_shortExact_free_transport | `free_localizationAway_of_free_of_eq_mul` (line 248) | Axiom-clean |
| lem:gf_splice_shortExact_split | `free_of_shortExact_of_free_free` (line 336) | Axiom-clean |
| lem:gf_splice_shortExact | `exists_free_localizationAway_of_shortExact` (line 360) | Axiom-clean |
| lem:noether_normalization_fg | `exists_finite_inj_algHom_of_fg` | Mathlib (`\mathlibok`) |
| lem:gf_clear_one_denominator | `gf_clear_one_denominator` (line 409) | Axiom-clean |
| lem:gf_noether_clear_denominators | `exists_localizationAway_finite_mvPolynomial` (line 486) | `sorry` at line 516 (pre-existing) |
| lem:gf_generic_rank_ses | `gf_generic_rank_ses` (line 529) | Axiom-clean |
| lem:annihilator_meets_nonZeroDivisors | `Submodule.annihilator_top_inter_nonZeroDivisors` | Mathlib (`\mathlibok`) |
| lem:polynomial_monic_quotient_finite | `Polynomial.Monic.finite_quotient` | Mathlib (`\mathlibok`) |
| lem:gf_torsion_reindex | `gf_torsion_reindex` (line 912) | `sorry` at line 949 (pre-existing, explicitly noted in directive) |
| lem:gf_polynomial_core | `exists_free_localizationAway_polynomial` (line 964) | `sorry` at line 1034 (blocked on `gf_torsion_reindex`) |
| lem:gf_flat_finite | `exists_flat_localizationAway_of_finite` (line 120) | Axiom-clean |
| lem:gf_free_moduleFinite | `exists_free_localizationAway_of_moduleFinite` (line 135) | Axiom-clean |
| thm:generic_flatness | `genericFlatness` (line 1133) | `sorry` at line 1168 (blocked on `genericFlatnessAlgebraic`) |

---

## Red flags

No new red flags this iteration.

The `sorry` bodies in `gf_torsion_reindex` (line 949), `exists_free_localizationAway_polynomial` (line 1034), `genericFlatnessAlgebraic` (line 1101), `exists_localizationAway_finite_mvPolynomial` (line 516), and `genericFlatness` (line 1168) are all pre-existing and consistent with the blueprint's `\leanok` markers (which only require a `sorry` body to be present, not a closed proof). The code comments around these sorries are informative assembly notes, not excuse-comments: they accurately describe the remaining plumbing and do not claim the sorry is a finished proof.

---

## Unreferenced declarations (informational)

All non-private declarations in the file have a corresponding `\lean{...}` blueprint block. The private declarations below are implementation helpers and appropriately not referenced:

- `finSuccEquiv_map_comm` (line 668): internal helper for the Nagata section.
- `T1`, `T` (lines 695, 703): the Nagata substitution maps (abbrev/def).
- `lt_up`, `t1_comp_t1_neg`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq` (lines 690–786): private degree-bookkeeping lemmas transcribed from Mathlib's field-only private originals.
- `finSuccEquiv_rename_succ` (line 828): private compatibility lemma for the `rename Fin.succ` / `finSuccEquiv` interaction used inside `mvPolynomial_quotient_finite_of_monic_lastVar`.

None of these have names suggesting they should be promoted to blueprint blocks.

---

## Blueprint adequacy for this file

- **Coverage**: All 19 public Lean declarations in this file have a corresponding `\lean{...}` block (or `\mathlibok` for Mathlib anchors). 8 private declarations have no block (all implementation helpers, appropriate). 0 substantive unreferenced declarations. Coverage is complete.

- **Proof-sketch depth**: **adequate** for the three new lemmas.
  - `lem:gf_torsion_annihilator`: prose and LEAN SIGNATURE comments at tex lines 627–666 give enough detail; the one-line proof is exactly what the blueprint describes.
  - `lem:gf_nagata_monic_lastVar`: tex lines 668–718 give a detailed Nagata-substitution argument, including the critical domain-vs-field distinction ("over a domain it is merely non-zero, and becomes a unit after inverting it"). The private helper chain directly follows this description.
  - `lem:gf_mvPolynomial_quotient_finite_monic`: tex lines 729–795 give a complete proof sketch (rescale to monic, invoke Mathlib, transport via `finSuccEquiv` iso). The Lean proof follows this verbatim.
  - The `lem:gf_torsion_reindex` assembly note (tex lines 848–879) is detailed enough to guide the remaining plumbing; the sorry comment at Lean line 939–948 accurately echoes the blueprint's assembly steps.

- **Hint precision**: **precise**. Every `\lean{...}` pin resolves to the correct declaration. The `mvPolynomial_quotient_finite_of_monic_lastVar` encoding discrepancy is already annotated in the blueprint with a `% NOTE` (tex lines 735–738), and the pin still resolves correctly.

- **Generality**: **matches need**. All three new lemmas are stated at the right level of generality: `gf_torsion_annihilator` works for any noetherian domain + MvPolynomial ring; `gf_nagata_monic_lastVar` works for any domain; `mvPolynomial_quotient_finite_of_monic_lastVar` works for any commutative ring. No parallel API was required.

- **Recommended chapter-side actions**:
  - The LEAN SIGNATURE comment for `lem:gf_mvPolynomial_quotient_finite_monic` still shows the old `Module.Finite` + `letI : Algebra` form (tex lines 754–769). The `% NOTE` says "The planner may resync the LEAN SIGNATURE to the `RingHom.Finite` encoding (math statement unchanged)." This is a **minor** cleanup (no math impact; the `\lean{}` pin resolves correctly). The plan agent may want to dispatch a blueprint-writing subagent to resync the LEAN SIGNATURE comment to avoid confusion for future provers reading the scaffold.
  - No other blueprint actions required this iter.

---

## Severity summary

### Placeholder / suspect bodies
*(none for iter-011 deliverables)*

The pre-existing `sorry` bodies (`gf_torsion_reindex`, `exists_free_localizationAway_polynomial`, `genericFlatnessAlgebraic` finite-type branch, `exists_localizationAway_finite_mvPolynomial`, `genericFlatness`) are known and accepted; `\leanok` marks their presence correctly per the project convention (statement is formalized with at least a `sorry`). These are **not** must-fix-this-iter findings since they were not the deliverable of this iter.

### Stale LEAN SIGNATURE comment
- `lem:gf_mvPolynomial_quotient_finite_monic` (tex lines 754–769): the LEAN SIGNATURE sketch still shows the `letI : Algebra` + `Module.Finite` form, while the landed code uses `RingHom.Finite`. The `% NOTE` already records this. Severity: **minor**.

### Must-fix-this-iter
None.

---

**Overall verdict**: The three iter-011 deliverables (`gf_torsion_annihilator`, `gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar`) faithfully match their blueprint blocks with no signature mismatches; the `RingHom.Finite` encoding is genuinely equivalent to the blueprinted `Module.Finite` claim and already annotated; blueprint coverage and proof-sketch depth are adequate for all three lemmas. The only finding is a minor stale LEAN SIGNATURE comment in the blueprint that should eventually be resynced. — 23 declarations checked (19 public Lean, 4 Mathlib anchors), 0 red flags.
