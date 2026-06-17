# Lean ↔ Blueprint Check Report

## Slug
quot

## Iteration
020

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (1696 lines)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (2882 lines)

---

## Per-declaration (keystone chain focus)

### `\lean{AlgebraicGeometry.GradedModule.subquotient_base_eventuallyZero}` (chapter: `lem:graded_subquotient_base_eventuallyZero`)

- **Lean target exists**: yes (line 1486)
- **Signature matches**: yes — `(D : SubquotientDatum ℳ 0) : ∃ K, ∀ n, K < n → subquotientHilb ℳ D.N D.N' n = 0` matches the blueprint's "there is K ∈ ℕ with hilb(n) = 0 for all n > K"
- **Proof follows sketch**: yes — blueprint describes route-(b): direct membership analysis reading off the degree-i homogeneous component inside Q₀, never building an outgoing κ-linear map from Q₀; Lean proof implements exactly this via `core` (ambient degree-i detection lemma, lines 1526–1545), `iSupIndep_map_of_mem_ker_sup` application (lines 1564–1589), then `Submodule.finite_ne_bot_of_iSupIndep` for finiteness of support, ending in eventual vanishing. Steps 1–3 in the blueprint proof correspond directly to the `hindep`, `hfinset`, and `hbot`/`hsub`/`heq`/`hfr` blocks in Lean.
- **notes**: Proof is complete (no sorry). The blueprint's `% NOTE: ROUTE (b)` comment (blueprint lines 2133–2141) correctly describes the landed approach.

  **Red flag — stale Lean comments**: Lines 1510–1519 in the Lean body say `-- (RESIDUAL LEAF — the only sorry in the QUOT keystone chain)` and `-- OBSTRUCTION: math is complete, only the restrictScalars/quotient-ring plumbing remains`. These comments describe the pre-route-(b) state; the `have hindep` proof immediately following is complete and has no sorry. The comments actively mislead about proof completeness. See §Red flags.

---

### `\lean{AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational}` (chapter: `lem:graded_subquotient_isRatHilb`)

- **Lean target exists**: yes (line 1618)
- **Signature matches**: yes — `∀ {r : ℕ} (D : SubquotientDatum ℳ r), IsRatHilb (SubquotientDatum.hilb ℳ D) r` matches the blueprint's "let (N,N') be a subquotient datum of length r; then IsRatHilb(hilb, r)"
- **Proof follows sketch**: yes, exactly
  - Base case `r = 0`: applies `subquotient_base_eventuallyZero` then `IsRatHilb.ofEventuallyZero` ✓
  - Inductive step: applies IH to `SubquotientDatum.coker ℳ D` and `SubquotientDatum.ker ℳ D`, then `IsRatHilb.ofDiffEq` with `subquotient_degreewise_diff` for the difference identity `h_M(n+1) - h_M(n) = h_C(n+1) - h_K(n)` ✓
  - The `N := 0` for `ofDiffEq` is correct: `subquotient_degreewise_diff` holds for all n, not just n > N.
- **notes**: Proof is complete (no sorry). Blueprint `\leanok` marker is correct.

---

### `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}` (chapter: `lem:gradedHilbertSerre_rational`)

- **Lean target exists**: yes (line 1651)
- **Signature matches**: yes — takes `(ℳ : ℕ → Submodule κ M) [DirectSum.Decomposition ℳ] [∀ n, FiniteDimensional κ ↥(ℳ n)] {r : ℕ} (t : Fin r → Module.End κ M) (hcomm) (hraise) (hfin : Module.Finite (MvPolynomial (Fin r) κ) M)` and returns `IsRatHilb (fun n => (Module.finrank κ ↥(ℳ n) : ℚ)) r`. The blueprint prose says "graded κ-module M = ⊕ Mₙ with finite-dimensional components, equipped with r pairwise-commuting degree-one endomorphisms for which M is finite over MvPolynomial(Fin r, κ); Hilbert function n ↦ dim_κ Mₙ is rational of order r" — match is exact (the "reduction to generation in degree 1" paragraph explains the `hraise`+`t : Fin r` abstraction; the Lean takes them as direct hypotheses, which is the right formalization of that informal argument).
- **Proof follows sketch**: yes
  - Builds `hfintop`: finiteness of the top datum (⊤, ⊥) over `MvPolynomial (Fin r) κ` via a surjective linear map from `M` (lines 1661–1671) ✓
  - Constructs datum `D` with `N := ⊤`, `N' := ⊥`, `hN := Submodule.mem_top`, `hN' := Submodule.bot` (lines 1672–1683) ✓
  - Applies `GradedModule.subquotient_hilbertSeries_rational ℳ D` (line 1684) ✓
  - Proves `SubquotientDatum.hilb ℳ D = fun n => (Module.finrank κ ↥(ℳ n) : ℚ)` via `top_inf_eq, bot_inf_eq, finrank_bot` (lines 1685–1693) ✓
- **notes**: Proof is complete (no sorry). Blueprint `\leanok` marker is correct. See blueprint adequacy for a stale `% NOTE` in this block.

---

## Additional per-declaration checks (non-keystone)

All non-skeleton blueprint `\lean{...}` blocks were verified for existence and signature match.
Below is a summary of non-trivial checks; all passed.

| Blueprint label | Lean declaration | Status |
|---|---|---|
| `def:hilbert_polynomial` | `Scheme.hilbertPolynomial` (line 123) | `:= sorry` — known skeleton |
| `def:quot_functor` | `Scheme.QuotFunctor` (line 161) | `:= sorry` — known skeleton |
| `def:grassmannian_scheme` | `Scheme.Grassmannian` (line 201) | `:= sorry` — known skeleton |
| `thm:grassmannian_representable` | `Grassmannian.representable` (line 225) | `:= sorry` — known skeleton |
| `def:is_locally_free_of_rank` | `SheafOfModules.IsLocallyFreeOfRank` (line 253) | complete def ✓ |
| `def:modules_annihilator` | `Scheme.Modules.annihilator` (line 298) | complete def ✓ |
| `lem:modules_annihilator_ideal_le` | `Scheme.Modules.annihilator_ideal_le` (line 305) | complete proof ✓ |
| `def:schematic_support` | `Scheme.Modules.schematicSupport` (line 312) | complete def ✓ |
| `def:schematic_support_immersion` | `Scheme.Modules.schematicSupportι` (line 320) | complete def ✓ |
| `def:has_proper_support` | `Scheme.Modules.HasProperSupport` (line 328) | complete def ✓ |
| `lem:annihilator_localization_eq_map` | `Module.annihilator_isLocalizedModule_eq_map` (line 362) | complete proof ✓ |
| `lem:coeff_invOneSubPow_one_mul` | `AlgebraicGeometry.coeff_invOneSubPow_one_mul` (line 430, private) | complete proof ✓ |
| `lem:rationalHilbert_antidiff` | `AlgebraicGeometry.rationalHilbert_antidiff` (line 450, private) | complete proof ✓ |
| `def:ratHilb` | `AlgebraicGeometry.IsRatHilb` (line 534, private) | complete def ✓ |
| `lem:ratHilb_ofEventuallyZero` | `IsRatHilb.ofEventuallyZero` (line 539, private) | complete proof ✓ |
| `lem:ratHilb_bump` | `IsRatHilb.bump` (line 548, private) | complete proof ✓ |
| `lem:ratHilb_sub` | `IsRatHilb.sub` (line 563, private) | complete proof ✓ |
| `lem:ratHilb_shiftRight` | `IsRatHilb.shiftRight` (line 575, private) | complete proof ✓ |
| `lem:ratHilb_antidiff` | `IsRatHilb.antidiff` (line 586, private) | complete proof ✓ |
| `lem:ratHilb_ofDiffEq` | `IsRatHilb.ofDiffEq` (line 602, private) | complete proof ✓ |
| `lem:graded_homogeneousSubmodule_iSupIndep` | `GradedModule.homogeneousSubmodule_inf_iSupIndep` (line 633) | complete proof ✓ |
| `lem:graded_homogeneousSubmodule_iSup_eq` | `GradedModule.homogeneousSubmodule_iSup_inf_eq` (line 649) | complete proof ✓ |
| `lem:graded_degreewise_finrank_diff` | `GradedModule.degreewise_finrank_diff` (line 670) | complete proof ✓ |
| `def:graded_raisesDegree` | `GradedModule.RaisesDegree` (line 700) | complete def ✓ |
| `def:graded_subquotientHilb` | `GradedModule.subquotientHilb`, `SubquotientDatum`, `SubquotientDatum.hilb` (lines 712, 1348, 1377) | complete defs ✓ |
| `lem:graded_decompose_raisesDegree` | `GradedModule.decompose_raisesDegree` (line 719) | complete proof ✓ |
| `lem:graded_comap_isHomogeneous` | `GradedModule.comap_isHomogeneous` (line 735) | complete proof ✓ |
| `lem:graded_decompose_raisesDegree_zero` | `GradedModule.decompose_raisesDegree_zero` (line 744) | complete proof ✓ |
| `lem:graded_map_isHomogeneous` | `GradedModule.map_isHomogeneous` (line 755) | complete proof ✓ |
| `lem:graded_map_inf_degree_eq` | `GradedModule.map_inf_degree_eq` (line 768) | complete proof ✓ |
| `lem:graded_sup_inf_degree_eq` | `GradedModule.sup_inf_degree_eq` (line 785) | complete proof ✓ |
| `lem:graded_inf_isHomogeneous` | `GradedModule.inf_isHomogeneous` (line 805) | complete proof ✓ |
| `lem:graded_sup_isHomogeneous` | `GradedModule.sup_isHomogeneous` (line 813) | complete proof ✓ |
| `lem:graded_ker_isHomogeneous` | `GradedModule.ker_isHomogeneous` (line 834) | complete proof ✓ |
| `lem:graded_coker_isHomogeneous` | `GradedModule.coker_isHomogeneous` (line 840) | complete proof ✓ |
| `lem:graded_ker_le` | `GradedModule.ker_le` (line 848) | complete proof ✓ |
| `lem:graded_coker_le` | `GradedModule.coker_le` (line 855) | complete proof ✓ |
| `lem:graded_ker_annihilate` | `GradedModule.ker_annihilate` (line 861) | complete proof ✓ |
| `lem:graded_coker_annihilate` | `GradedModule.coker_annihilate` (line 866) | complete proof ✓ |
| `lem:graded_comap_map_le_of_commute` | `GradedModule.comap_map_le_of_commute` (line 874) | complete proof ✓ |
| `lem:graded_map_map_le_of_commute` | `GradedModule.map_map_le_of_commute` (line 888) | complete proof ✓ |
| `lem:graded_subquotient_degreewise_diff` | `GradedModule.subquotient_degreewise_diff` (line 914) | complete proof ✓ |
| `def:graded_polyEndHom` | `GradedModule.polyEndHom` (line 986) | complete def ✓ |
| `lem:graded_polyEndHom_X/C` | `GradedModule.polyEndHom_X/C` (lines 999, 1009) | complete proofs ✓ |
| `def:graded_polyModule` | `GradedModule.polyModule` (line 1024) | complete def ✓ |
| `lem:graded_polyModule_X_smul/C_smul/isScalarTower` | `GradedModule.polyModule_*` (lines 1029–1056) | complete proofs ✓ |
| `def:graded_polySubmodule` | `GradedModule.polySubmodule` (line 1062) | complete def ✓ |
| `lem:graded_polySubmodule_coe` | `GradedModule.polySubmodule_coe` (line 1085) | complete proof ✓ |
| `lem:graded_lastVarAlgHom` | `GradedModule.lastVarAlgHom` + 6 simp/surj lemmas (lines 1109–1138) | complete defs/proofs ✓ |
| `lem:graded_polyEndHom_mem_of_stable` | `GradedModule.polyEndHom_mem_of_stable` (line 1153) | complete proof ✓ |
| `lem:graded_polyEndHom_lastVar_sub_mem` | `GradedModule.polyEndHom_lastVar_sub_mem` (line 1170) | complete proof ✓ |
| `lem:graded_subquotient_finite_transfer` | `GradedModule.subquotient_finite_transfer` (line 1206) | complete proof ✓ |
| `lem:graded_polyQuot_finite_of_le_denominator` | `GradedModule.polyQuot_finite_of_le_denominator` (line 1264) | complete proof ✓ |
| `lem:graded_polyQuot_finite_of_le_numerator` | `GradedModule.polyQuot_finite_of_le_numerator` (line 1290) | complete proof ✓ |
| `lem:graded_ker_stable_full` | `GradedModule.ker_stable_full` (line 1382) | complete proof ✓ |
| `lem:graded_coker_stable_full` | `GradedModule.coker_stable_full` (line 1389) | complete proof ✓ |
| `def:graded_subquotientDatum_ker` | `GradedModule.SubquotientDatum.ker` (line 1400) | complete noncomputable def ✓ |
| `def:graded_subquotientDatum_coker` | `GradedModule.SubquotientDatum.coker` (line 1420) | complete noncomputable def ✓ |
| `lem:graded_finiteDimensional_of_mvPolynomial_isEmpty_finite` | `GradedModule.finiteDimensional_of_mvPolynomial_isEmpty_finite` (line 1442) | complete proof ✓ |

---

## Red flags

### Stale excuse-comments on a completed proof

**`QuotScheme.lean:1510–1519`**: Inside the body of `GradedModule.subquotient_base_eventuallyZero`, preceding the `have hindep` block:

```
  -- (RESIDUAL LEAF — the only `sorry` in the QUOT keystone chain). For each `n`,
  -- ...
  -- OBSTRUCTION: building the κ-linear `Φ` *out of* the `MvPolynomial (Fin 0) κ`-quotient `Q`
  -- via `Submodule.liftQ` clashes on the scalar ring ...; the
  -- math is complete, only the `restrictScalars`/quotient-ring plumbing remains.
```

The declaration has **no sorry** and the proof is **complete**. These lines describe a pre-route-(b) analysis but the phrase "RESIDUAL LEAF — the only sorry" actively misleads any reader about the current proof state. The blueprint correctly marks this lemma `\leanok`. **The comments should be removed or rewritten** to say "route-(a) was bypassed in favor of route-(b); see below."

---

## Unreferenced declarations (informational)

**`private` helpers with no blueprint block (noted per directive — not must-fix):**
- `AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup` (line 1462) — abstract independence-modulo-kernel helper; its mathematical content is described inline in the `subquotient_base_eventuallyZero` proof comments.
- `AlgebraicGeometry.GradedModule.finrank_comap_subtype` (line 901) — preimage-to-ambient dimension helper used by `subquotient_degreewise_diff`; noted in the blueprint `% NOTE` at `lem:graded_subquotient_degreewise_diff`.

**`private` declarations that have blueprint `\lean{}` pins** (the blueprint notes these are private and `\lean{}` pins may not resolve until moved to a dedicated module; not a must-fix):
- `AlgebraicGeometry.IsRatHilb` + all closure lemmas (`ofEventuallyZero`, `bump`, `sub`, `shiftRight`, `antidiff`, `ofDiffEq`) — all complete, correct, pinned in `subsec:isRatHilb`.
- `AlgebraicGeometry.coeff_invOneSubPow_one_mul`, `AlgebraicGeometry.rationalHilbert_antidiff` — same status.

---

## Blueprint adequacy for this file

- **Coverage**: 59/63 Lean declarations (public + blueprint-pinned private) have a corresponding `\lean{...}` block. The 4 un-pinned items are the two `private` helpers noted above plus `AlgebraicGeometry.GradedModule.RaisesDegree.mem` (it is pinned as `lem:graded_raisesDegree_mem` ✓) and `AlgebraicGeometry.GradedModule.SubquotientDatum` (pinned via `def:graded_subquotientHilb` ✓). Effective coverage: excellent.

- **Proof-sketch depth**: **adequate**. All three keystone proofs (`subquotient_base_eventuallyZero`, `subquotient_hilbertSeries_rational`, `gradedModule_hilbertSeries_rational`) have detailed prose proof sketches that accurately preview the Lean structure. The route-(b) approach for the base-case independence step is explicitly documented in blueprint `% NOTE` comments inside `lem:graded_subquotient_base_eventuallyZero` (blueprint lines 2133–2141), giving a prover full guidance.

- **Hint precision**: **precise**. Every `\lean{...}` hint names the correct qualified Lean declaration. No hint points at a wrong type or wrong Mathlib predicate.

- **Generality**: **matches need**. The blueprint's ambient-submodule approach (avoiding graded quotient modules on derived carriers) is exactly what the Lean implements; no parallel API was written to fill a blueprint gap.

- **Recommended chapter-side actions**:
  1. **Minor**: Update the stale `% NOTE` inside `lem:gradedHilbertSerre_rational` (blueprint lines 406–410) that says "The present theorem is not yet a Lean declaration". The declaration `gradedModule_hilbertSeries_rational` landed with a complete proof; the note is obsolete and should be replaced with a note recording that the declaration is fully closed.
  2. **Minor**: The `% NOTE` inside `thm:grassmannian_representable` (blueprint lines 2737–2745) documents that the `\lean{}` pin "under-delivers the prose statement" (omits smoothness, properness, Plücker embedding). This is accurate and self-documented; no action needed beyond tracking as downstream iter work.

---

## Severity summary

| Severity | Finding | Location |
|---|---|---|
| **major** | Stale comment in completed proof says "RESIDUAL LEAF — the only sorry in the QUOT keystone chain"; proof has no sorry | `QuotScheme.lean:1510–1519` |
| **minor** | Blueprint `% NOTE` says `gradedModule_hilbertSeries_rational` "is not yet a Lean declaration"; it is, with a complete proof | `Picard_QuotScheme.tex:406–410` |
| **minor** | `IsRatHilb` and closure lemmas are `private` in Lean while the blueprint pins them in a public subsection; noted as temporary in the blueprint | `subsec:isRatHilb` |

**Overall verdict**: The three keystone-chain proofs (`subquotient_base_eventuallyZero`, `subquotient_hilbertSeries_rational`, `gradedModule_hilbertSeries_rational`) are all landed, complete, sorry-free, and mathematically faithful to the blueprint's informal proofs — the route-(b) ambient-membership approach for the base-case independence is correctly implemented and documented. 59 declarations checked, 1 major red flag (stale comment implying incomplete proof), 0 must-fix items.
