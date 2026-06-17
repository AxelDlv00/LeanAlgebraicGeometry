# Lean ↔ Blueprint Check Report

## Slug
gf

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (1722 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (1471 lines)

---

## Per-declaration

The blueprint has 43 `\lean{...}` references. Seven are `\mathlibok` (Mathlib-provided, skipped below). The remaining 36 project-owned declarations are checked.

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (thm:generic_flatness_algebraic)
- **Lean target exists**: yes — `theorem genericFlatnessAlgebraic` at line 1622
- **Signature matches**: yes — `(A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches blueprint comment block exactly
- **Proof follows sketch**: partial — primary route (finite-`A`-module case) is closed; surviving residue (finite-type `B`, not module-finite over `A`) is `sorry` at line 1652
- **notes**: Known issue per directive; gated on L4 (`exists_localizationAway_finite_mvPolynomial`). The sorry body carries a detailed assembly roadmap comment explaining the prime-filtration route. Not a placeholder; the closed half is axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (lem:gf_finite_module)
- **Lean target exists**: yes — line 105
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed, no sorry; uses `Module.finitePresentation_of_finite` + `exists_free_localizedModule_powers` at the fraction ring exactly as blueprint describes

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (lem:gf_torsion_base)
- **Lean target exists**: yes — line 168
- **Signature matches**: yes — `(htors : Subsingleton (LocalizedModule (nonZeroDivisors A) M))` encoding matches blueprint's `M_K = 0` hypothesis
- **Proof follows sketch**: yes — closed; proof exactly follows the finite-generating-set + product-of-annihilators route described in blueprint

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (lem:gf_splice_shortExact_localized_exact)
- **Lean target exists**: yes — line 220
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; single application of `LocalizedModule.map_injective/map_surjective/map_exact` as sketched

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (lem:gf_splice_shortExact_free_transport)
- **Lean target exists**: yes — line 248
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; localisation factorisation via `IsLocalization.Away.awayToAwayLeft` and `IsBaseChange.of_comp` exactly as sketch says

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (lem:gf_splice_shortExact_split)
- **Lean target exists**: yes — line 336
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; projective-quotient splitting route

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (lem:gf_splice_shortExact)
- **Lean target exists**: yes — line 360
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; assembles L3a+L3b+L3c as blueprint describes

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (lem:gf_clear_one_denominator)
- **Lean target exists**: yes — line 409
- **Signature matches**: yes — blueprint NOTE (line 352) explicitly documents the encoding difference (`IsLocalization.map ... hle` rather than a direct `algebraMap`); the NOTE acknowledges this is mathematically identical
- **Proof follows sketch**: yes — closed; `IsLocalization.exist_integer_multiples` over the support as described

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (lem:gf_noether_clear_denominators, **L4**)
- **Lean target exists**: yes — line 486
- **Signature matches**: yes — matches the `% LEAN SIGNATURE` block in the blueprint exactly (3-existential form with `Algebra A_g B_g` binder)
- **Proof follows sketch**: partial — six `have` steps F1–F6 are proved at lines 503–610; the `sorry` at line 610 is the denominator-clearing assembly (Step 2 + AlgHom assembly of Step 3 in the blueprint proof)
- **notes**: The L4 assessment is the primary focus of this directive; see "Blueprint adequacy" section below.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (lem:gf_generic_rank_ses)
- **Lean target exists**: yes — line 623
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; proof constructs the `finrank`-indexed basis, clears denominators, uses `LinearIndependent.restrict_scalars` + `IsFractionRing.injective`, and clears denominators of the cokernel generator exactly as the blueprint describes

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (lem:gf_torsion_annihilator)
- **Lean target exists**: yes — line 730
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed

### `\lean{AlgebraicGeometry.GenericFreeness.T1}` (def:gf_nagata_T1)
- **Lean target exists**: yes — line 788, BUT as `private noncomputable abbrev T1`
- **Signature matches**: yes (per file)
- **Proof follows sketch**: N/A (definition)
- **notes**: `private` — `AlgebraicGeometry.GenericFreeness.T1` is not an accessible qualified name; `sync_leanok` will fail to verify this pin. See Red Flags.

### `\lean{AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg}` (lem:gf_t1_comp_t1_neg)
- **Lean target exists**: yes — line 793, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.T}` (def:gf_nagata_T)
- **Lean target exists**: yes — line 797, BUT `private noncomputable abbrev T`
- **Signature matches**: yes
- **Proof follows sketch**: N/A (definition)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.lt_up}` (lem:gf_lt_up)
- **Lean target exists**: yes — line 784, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.sum_r_mul_ne}` (lem:gf_sum_r_mul_ne)
- **Lean target exists**: yes — line 801, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_zero_t}` (lem:gf_degreeOf_zero_t)
- **Lean target exists**: yes — line 810, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne}` (lem:gf_degreeOf_t_ne_of_ne)
- **Lean target exists**: yes — line 826, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t}` (lem:gf_leadingCoeff_finSuccEquiv_t)
- **Lean target exists**: yes — line 833, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq}` (lem:gf_T_leadingcoeff_eq)
- **Lean target exists**: yes — line 854, BUT `private lemma`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm}` (lem:gf_finSuccEquiv_map_comm)
- **Lean target exists**: yes — line 762, BUT `private theorem`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ}` (lem:gf_finSuccEquiv_rename_succ)
- **Lean target exists**: yes — line 922, BUT `private theorem`
- **Signature matches**: yes
- **Proof follows sketch**: yes (closed)
- **notes**: Same `private` issue.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (lem:gf_nagata_monic_lastVar)
- **Lean target exists**: yes — line 889 (public)
- **Signature matches**: yes — the `Fin (m+1)` vs `Fin (n+1)` naming difference is immaterial (blueprint uses `n`, Lean uses `m`); structure identical
- **Proof follows sketch**: yes — closed; `T_leadingcoeff_eq` + unit inversion via `IsLocalization.Away.algebraMap_isUnit` exactly as described

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (lem:gf_mvPolynomial_quotient_finite_monic)
- **Lean target exists**: yes — line 946
- **Signature matches**: yes — `RingHom.Finite` encoding noted in blueprint `% NOTE (iter-012)` block; the Lean uses this exact form
- **Proof follows sketch**: yes — closed; rescales to monic via `Polynomial.Monic.finite_quotient`, transports via `AlgEquiv.ofRingEquiv`, as sketched

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (lem:gf_torsion_reindex)
- **Lean target exists**: yes — line 1120
- **Signature matches**: yes — note the blueprint `% NOTE (iter-017)` documents that the redundant `Module A_g T_g` existential was dropped; the landed Lean matches this revised form
- **Proof follows sketch**: yes — closed; detailed assembly (L5b.1 + L5b.2 + L5b.3 + localisation transport + pullback) follows the blueprint's "Localisation transport" narrative faithfully

### `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}`, `\lean{AlgebraicGeometry.GenericFreeness.finite_of_pullbackModuleAddEquiv}`, `\lean{AlgebraicGeometry.GenericFreeness.pullback_isScalarTower}` (lem:gf_pullback_module_transport)
- **Lean targets exist**: yes — lines 1005, 1023, 1038
- **Signature matches**: yes (all three)
- **Proof follows sketch**: yes — all closed

### `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` (lem:gf_finite_of_quotient_ringequiv)
- **Lean target exists**: yes — line 1055
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` (lem:gf_islocalizedmodule_restrictscalars)
- **Lean target exists**: yes — line 1073
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; three `IsLocalizedModule` axioms discharged as blueprint describes

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` (lem:gf_away_tower_descent)
- **Lean target exists**: yes — line 1363
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; note blueprint `% NOTE (iter-016)` updates that `IsBaseChange.comp` was used rather than the hand-crafted three-axiom proof; the blueprint prose has been updated accordingly

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (lem:gf_polynomial_core)
- **Lean target exists**: yes — line 1485
- **Signature matches**: yes — shared-universe `(A N : Type u)` form as documented in blueprint `% NOTE (iter-008 signature)`
- **Proof follows sketch**: yes — closed; `Nat.strong_induction_on generalizing A N` as the blueprint `% LEAN PROOF STRUCTURE` comment prescribes; base case, torsion sub-case, and five-step inductive assembly all match

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (lem:gf_flat_finite)
- **Lean target exists**: yes — line 120
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; `Module.Flat.of_free` applied after `exists_free_localizationAway_of_finite`

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (lem:gf_free_moduleFinite)
- **Lean target exists**: yes — line 135
- **Signature matches**: yes
- **Proof follows sketch**: yes — closed; `Module.Finite.trans B M` + `exists_free_localizationAway_of_finite`

### `\lean{AlgebraicGeometry.genericFlatness}` (thm:generic_flatness)
- **Lean target exists**: yes — line 1684
- **Signature matches**: yes — includes coherence encoding `[F.IsQuasicoherent] [F.IsFiniteType]` as documented in blueprint `% NOTE (re-signed iter-002)`
- **Proof follows sketch**: partial — the affine-open extraction (`exists_isAffineOpen_mem_and_subset`) is done at line 1700; the geometric assembly (finite affine cover, `genericFlatnessAlgebraic` per patch, product witness `V`) is `sorry` at line 1719
- **notes**: Known issue per directive; gated on L4.

---

## Red Flags

### Private declarations with `\lean{...}` blueprint pins

Eleven declarations inside the `NagataNormalization` section are marked `private` in Lean but are pinned by `\lean{...}` references in the blueprint chapter. In Lean 4, `private` removes the declaration from its standard qualified name, making it unreachable by `#check AlgebraicGeometry.GenericFreeness.T1` etc. The `sync_leanok` phase (which uses `lake env lean` / `lean_verify` to look up each `\lean{...}` name) will fail to find these declarations and will incorrectly mark their blueprint blocks as unformalized:

| Lean qualified name (pinned) | Line | Declaration |
|---|---|---|
| `AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm` | 762 | `private theorem` |
| `AlgebraicGeometry.GenericFreeness.lt_up` | 784 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.T1` | 788 | `private noncomputable abbrev` |
| `AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg` | 793 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.T` | 797 | `private noncomputable abbrev` |
| `AlgebraicGeometry.GenericFreeness.sum_r_mul_ne` | 801 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.degreeOf_zero_t` | 810 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne` | 826 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t` | 833 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq` | 854 | `private lemma` |
| `AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ` | 922 | `private theorem` |

All eleven proofs are closed (no sorry), so the math is correct; the issue is purely that the blueprint tracking system cannot verify them. Fix: either remove the `private` modifier on these 11 declarations (preferred — the math is sound and they serve as building blocks), or replace the `\lean{...}` pins in the blueprint with `% NOTE` comments acknowledging they are file-private helpers.

---

## Unreferenced declarations (informational)

All substantive declarations in the file are `\lean{...}`-referenced. No suspect unreferenced declarations were found.

---

## Blueprint adequacy for this file — L4 focus

The directive asks specifically whether the L4 blueprint block (`lem:gf_noether_clear_denominators`) gives enough detail to guide closing the residual `sorry` in `exists_localizationAway_finite_mvPolynomial`.

**Coverage**: 36/36 project-owned declarations have `\lean{...}` references (plus 11 unreachable due to `private`). Coverage is nominally complete; the private-declaration issue is the gap.

**Proof-sketch depth for L4**: **under-specified** on the injectivity and AlgHom-assembly sub-steps.

Detail:

The blueprint proof of `lem:gf_noether_clear_denominators` has three steps:

- *Step 1* (Noether normalisation over K): adequate — invokes `lem:noether_normalization_fg`, which is Mathlib. The Lean scaffolding (F2 + `hgK_inj`/`hgK_fin`) directly matches.

- *Step 2* (clear integral-dependence denominators): adequate at the mathematical level — the blueprint says "fold `gf_clear_one_denominator` over the finite (generator, coefficient-polynomial) pairs, multiply the `g_i`, get a single `g`." The Lean roadmap comment at lines 585–588 says the same thing. A prover familiar with Lean's `Finset.prod`/`Finset.fold` API could implement this.

- *Step 3* (AlgHom assembly): **under-specified**. The blueprint says:

  > "The algebra homomorphism φ of the statement is the A_g-algebra map A_g[X] → B_g sending X_j ↦ b_j; the algebraic independence of the b_j over A_g (inherited from their independence over K) makes φ injective."

  This says *what* to conclude but not *which Lean lemmas* establish it. The Lean roadmap comment (lines 596–609) is the actual guide: it names `AlgHom.algebraicIndependent_iff`, `AlgebraicIndependent.restrictScalars`, the injection `ν : B_g → B_K := IsLocalization.Away.lift (algebraMap A B g) _`, and the construction `b_j := (unit(algebraMap A B g0))⁻¹ • algebraMap B B_g β_j`. None of these API names appear in the blueprint prose. A prover working *from the blueprint alone* — without the Lean roadmap comment that was added during iter-018 — would not know which Mathlib lemmas to use for the injectivity sub-proof. The `AlgebraicIndependent.restrictScalars` step and the `ν`-construction are non-trivial Lean discoveries that took prover effort.

  The finiteness route (`Algebra.IsIntegral.finite`) is mentioned in the blueprint and is a clean API name; that part is adequate.

**Hint precision**: precise — the `\lean{...}` pins match the landed declarations.

**Generality**: matches need — the statement at `A_g`/`B_g` level is the right level of generality.

**Recommended chapter-side actions** to close the L4 sorry:

1. **Add an AlgHom-assembly sub-step** to the Step 3 prose of `lem:gf_noether_clear_denominators` that names: (a) the injection `ν : B_g → B_K` via `IsLocalization.Away.lift`; (b) the lift `b_j ∈ B_g` of the Noether-normalisation generators via the `g_0`-unit; (c) the injectivity route via `AlgHom.algebraicIndependent_iff` + `AlgebraicIndependent.restrictScalars` along the injection `A_g ↪ K`.

2. The Lean roadmap comment (lines 579–610) already contains the complete assembly guide in the form of Lean API names. The blueprint-writing subagent should translate that roadmap comment directly into blueprint prose for Step 3.

---

## Severity summary

**must-fix-this-iter**:
- **Blueprint adequacy failure at L4** (`lem:gf_noether_clear_denominators`): the Step 3 proof sketch is under-specified for the injectivity assembly. A prover cannot formalize the `exists_localizationAway_finite_mvPolynomial` injectivity sub-step from the blueprint prose alone; the Lean roadmap comment inside the proof is the actual guide. The blueprint-writing subagent should expand Step 3 to name `AlgHom.algebraicIndependent_iff`, `AlgebraicIndependent.restrictScalars`, and the construction of `ν` via `IsLocalization.Away.lift`.

**major**:
- **11 private declarations are `\lean{...}`-pinned** in the blueprint (T1, T, lt_up, sum_r_mul_ne, degreeOf_zero_t, degreeOf_t_ne_of_ne, leadingCoeff_finSuccEquiv_t, T_leadingcoeff_eq, t1_comp_t1_neg, finSuccEquiv_map_comm, finSuccEquiv_rename_succ). Their proofs are axiom-clean and closed; the `private` modifier prevents `sync_leanok` from verifying them. Fix: remove `private` from these 11 declarations, or annotate the blueprint blocks with a note that they are file-private.

**informational** (known issues, not re-reported as findings):
- `exists_localizationAway_finite_mvPolynomial` sorry at line 610 (REMAINING ASSEMBLY, iter-018 work in progress).
- `genericFlatnessAlgebraic` sorry at line 1652 — by design, gated on L4.
- `genericFlatness` sorry at line 1719 — by design, gated on L4.

**Overall verdict**: The file is substantially formalized — 33 of 36 project-owned declarations are closed and axiom-clean — but has two cross-cutting structural issues: 11 private declarations break blueprint tracking, and the L4 proof blueprint is under-specified for the injectivity assembly step that the residual sorry requires.
