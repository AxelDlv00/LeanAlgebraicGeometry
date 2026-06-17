# Blueprint Review — iter-036

**Subagent:** blueprint-reviewer  
**Date:** 2026-06-08  
**Scope:** full blueprint audit + HARD-GATE verdict on 3 live-prover chapters  

---

## DAG Health

| metric | value |
|---|---|
| `unknown_uses` | **0** ✅ |
| `isolated` | **0** ✅ |
| `unmatched_lean` | **94** (expected for ongoing project) |
| blueprint-doctor orphans | 0 |
| blueprint-doctor broken refs | 0 |
| blueprint-doctor axiom decls | 0 |
| blueprint-doctor covers problems | 0 |
| labels defined | 420 |

All `\uses{}` edges resolve. No isolated nodes. No structural integrity issues.

---

## Per-Chapter Checklist

### 1. `Cohomology_RegroupHelper.tex`

```
complete: true
correct:  true
```

Single lemma `lem:base_change_regroup_linearEquiv` (`\leanok`).  
Routes through `lem:isPushout_cancelBaseChange_mathlib`.  
No must-fix items.

---

### 2. `Cohomology_FlatBaseChange.tex`  ← HARD-GATE

```
complete: true
correct:  true
must-fix: ANNOTATION (stale NOTE at conj-2a, lines 2207–2216) — does NOT defer prover dispatch
```

#### HARD-GATE verification

**Explicit-inverse blocks absent?**  
Grep for `base_change_mate_section_inverse` returns **no matches**. `def:base_change_mate_section_inverse`, `lem:base_change_mate_section_map_inverse_id`, `lem:base_change_mate_section_inverse_map_id` are confirmed absent. ✅

**`lem:base_change_mate_gstar_transpose` — `huce` calculus?**  
- `\leanok` present (statement block formalized, proof closed). ✅  
- Statement `\uses{}` routes through: `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:base_change_mate_regroupEquiv`, `lem:pullback_spec_tilde_iso`, `lem:base_change_mate_unit_value`, `lem:conjugateEquiv_counit_symm_mathlib`. ✅  
- Proof `\uses{}` routes through: `lem:base_change_mate_fstar_reindex_legs_unitExpand`, `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`, `lem:base_change_mate_unit_value`, `lem:pullbackPushforward_unit_comp`, `lem:base_change_mate_regroupEquiv`, `lem:conjugateEquiv_counit_symm_mathlib`, `lem:pullback_spec_tilde_iso`, `lem:gammaMap_pushforwardComp_hom_eq_id`, `lem:gammaMap_pushforwardComp_inv_eq_id`. ✅  
- Does **NOT** `\uses{}` the sorry-backed `lem:base_change_mate_fstar_reindex_legs` or conj-2a (`lem:base_change_mate_fstar_reindex_legs_conj`). ✅  

**Proof sketch detail for steps (a)/(b)/(c):**  
- (a) Inner reindex: named `…_legs_unitExpand` + `…_legs_gammaDistribute` + `gammaMap_pushforwardComp_*` + `unit_value` + `pullbackPushforward_unit_comp`. Each driver named; reproven inline from proved standalones. **Sufficiently granular for atomic extraction.** ✅  
- (b) One-generator close: evaluates `extₓ_ψ(ρ) ≫ ε^alg` on generator `r' ⊗ m`, matches `regroup⁻¹`; cites `lem:base_change_mate_regroupEquiv`. Clear single-tactic target. ✅  
- (c) Dictionary cancellation: identifies Π_ψ and tilde-counit factors in master identity against Θ_src/Θ_tgt dictionaries as mutually inverse; straightforward cancellation. ✅  

**`lem:pushforward_base_change_mate_cancelBaseChange` — conjugate route?**  
Statement and proof `\uses{}` both include `lem:base_change_mate_generator_trace`, `lem:base_change_mate_section_identity`, `lem:base_change_mate_gstar_transpose`. ✅  
NOTE correctly documents the Lean decl formalizes the `IsIso` corollary form, not the literal equality.

#### Must-fix annotation

`lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a, lines 2207–2216) carries a stale NOTE:

> "iter-036 executes the pre-scheduled explicit-inverse + element-ext affine-local refactor. conj-2b and conj-2d are not yet typed in Lean (gated on this node's normal form)."

This NOTE was written before the explicit-inverse approach was reverted. The actual outcome is: (i) explicit-inverse was rejected (documented dead end), (ii) `lem:base_change_mate_gstar_transpose` was closed by the `huce` calculus and is now `\leanok`. The NOTE is misleading to a future reader.

**Action for review agent:** Update the conj-2a NOTE to reflect the actual outcome (huce route succeeded; explicit-inverse route was the stale plan; conj-2a itself remains as an inert formalized sorry since the new proof does not depend on it).

This does **not** defer the FBC-A prover dispatch — the remaining open target is `pushforward_base_change_mate_cancelBaseChange`, and its proof route is correctly documented.

---

### 3. `Picard_RelativeSpec.tex`

```
complete: true
correct:  true
```

All 5 key declarations (`\leanok`): `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`. No must-fix items.

---

### 4. `Picard_FlatteningStratification.tex`

```
complete: true
correct:  true
```

34 `\leanok` markers. Main dévissage chain (`thm:generic_flatness_algebraic`, L4/L5 lemmas) is axiom-clean. `thm:generic_flatness` (geometric form) has `\leanok` on statement block. Two geometric bridge lemmas are unformalized:

- `lem:gf_qcoh_fintype_finite_sections` (G1) — no `\leanok`; gated on gap1 (`lem:qcoh_section_localization_basicOpen`)  
- `lem:gf_flat_locality_assembly` (G3) — no `\leanok`; downstream of G1  

The L5 polynomial-core sorry (`lem:gf_polynomial_core` proof open) is a **Lean-elaboration blocker** (OreLocalization instance presentations for the localized quotient), not a missing math step. The NOTE at lines 1437–1443 accurately documents this:

> "Do NOT re-dispatch a raw L5 prover round without that instance-alignment refactor first."

No must-fix items for this iter. The G1/G3 bridges are correctly labelled as gated.

---

### 5. `Picard_QuotScheme.tex`  ← HARD-GATE

```
complete: true
correct:  true
```

#### HARD-GATE verification

**`lem:eq_of_locally_eq_mathlib`:**  
`\mathlibok`, `\lean{TopCat.Sheaf.eq_of_locally_eq'}`. Correct Mathlib anchor. ✅

**`lem:section_localization_descent_of_cover` (cover-form keystone, iter-035 landed):**  
- New this iter; no `\leanok` yet (added after last `sync_leanok` run; next `sync_leanok` will add it since the decl is axiom-clean per iter-035 record). Expected state.  
- `\uses{lem:map_units_restrict_basicOpen, lem:existsUnique_gluing_mathlib, lem:eq_of_locally_eq_mathlib, lem:isLimitPullbackCone_mathlib, lem:isLocalization_flat_mathlib}` — all 5 deps exist and are either `\mathlibok` or `\leanok`. ✅  
- Proof sketch covers all three `IsLocalizedModule` fields (map_units, surj, exists_of_eq) with concrete finite-cover descent argument. Sufficiently detailed. ✅  

**`lem:pullback_gamma_top_iso` (iter-036 prover target, `gammaPullbackTopIso`):**  
- New this iter; no `\leanok` (decl does not yet exist; this is the live prover target).  
- Statement: `Γ((pullback j).obj M, ⊤) ≅ Γ(M, range j)` for open immersion j.  
- Proof `\uses{lem:modules_pullback_mathlib, lem:modules_restrictFunctor_mathlib, lem:modules_restrictFunctorIsoPullback_mathlib}` — 3 Mathlib anchors, all `\mathlibok`. ✅  
- Proof sketch: (1) `j^res` satisfies `Γ(j^res M, V) = Γ(M, j(V))` definitionally; (2) `j^res ≅ j^* = pullback j` by two Mathlib lemmas; (3) apply Γ at V=⊤. Three clear steps; formalizable directly. ✅  

**Minor `\uses{}` over-specification:** The statement block's `\uses{}` includes `lem:over_restrict_pullback_iso`, `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` — these are downstream consumers noted for context, not true logical dependencies of the statement itself. The proof block's `\uses{}` is accurate. No action required (not a correctness issue).

**`lem:section_localization_descent` (rewired named form):**  
`\uses{lem:section_localization_descent_of_cover, lem:pullback_gamma_top_iso, lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent, lem:exists_finite_basicOpen_cover_le_quasicoherentData, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ, lem:isLocalizedModule_tilde_restrict}` ✅  
Proof sketch correctly describes Hfr production via P1 transport chain and keystone instantiation. ✅

---

### 6. `Picard_GrassmannianCells.tex`  ← HARD-GATE

```
complete: true
correct:  true
```

#### HARD-GATE verification

**7 coverage blocks for landed scaffold (Properness section, cheap ingredients):**  
All 7 blocks added this iter, no `\leanok` yet (sync_leanok will add after formalization):
1. `lem:gr_compactSpace_scheme`  
2. `lem:gr_quasiCompact_toSpecZ`  
3. `lem:gr_locallyOfFiniteType_toSpecZ`  
4. `lem:gr_quasiSeparated_toSpecZ`  
5. `lem:gr_valuativeUniqueness_toSpecZ`  
6. `lem:gr_isProper_of_valuativeExistence`  
7. `lem:gr_valuativeExistence_toSpecZ`  

All route through pre-existing `\leanok` nodes (`lem:gr_separated_toSpecZ`, glue data, etc.). `\uses{}` chains are accurate.

**E1 well-formedness (`lem:gr_existence_chart_factorization`):**  
- `\lean{AlgebraicGeometry.Grassmannian.existence_chart_factorization}` ✅  
- Statement: ∃ I (hI : |I|=d) (f : ℤ[X^I] → K), i₁ = Spec(f) ≫ (glueData).ι ⟨I, hI⟩  
- `\uses{def:gr_the_glue_data, def:gr_glued_scheme, def:gr_affine_chart, lem:gr_chartIncl_isOpenImmersion}` — all `\leanok`. ✅  
- Statement is well-formed as a Lean target: existence of index and ring hom with stated factorization property. The argument (Spec K is a point, charts cover, open immersions factor uniquely) maps cleanly to Lean. ✅  

**E1–E4 `\uses{}` chain:**

| lemma | \uses{} chain | status |
|---|---|---|
| E1 `lem:gr_existence_chart_factorization` | glue data, glued scheme, affine chart, chartIncl_isOpenImmersion | ✅ |
| E2 `lem:gr_existence_minimal_valuation` | E1, minor_det, minorDet_self | ✅ E1→E2 |
| E3 `lem:gr_existence_factor_through_valuation_ring` | E2, transitionPreMap lemmas, mathlib_away_lift | ✅ E2→E3 |
| E4 `lem:gr_existence_lift` | E1, E3, glue_data, to_specZ, ι_toSpecZ | ✅ E1+E3→E4 |
| `lem:gr_valuativeExistence_toSpecZ` | E1, E2, E3, E4 | ✅ |
| `lem:gr_proper` | lem:gr_isProper_of_valuativeExistence, gr_valuativeExistence_toSpecZ | ✅ |

All edges resolve (`unknown_uses: 0` confirmed). Chain is clean.

**E3 sub-step note:** The proof sketch flags one sub-step as having "no pre-existing matrix-algebra scaffold": expanding the determinant of a column-substituted identity matrix to express free entries as ±minors (sign bookkeeping). The blueprint says this explicitly. The prover should either close it inline or extract a dedicated helper `lem:gr_entries_as_colSubst_minors`. Flagged as a **possible prover friction point**, not a must-fix blueprint issue.

---

## HARD-GATE Verdicts

| chapter | complete | correct | prover dispatch |
|---|---|---|---|
| `Cohomology_FlatBaseChange.tex` | ✅ | ✅ | **DISPATCH** (must-fix = annotation cleanup only; does not block) |
| `Picard_QuotScheme.tex` | ✅ | ✅ | **DISPATCH** (`gammaPullbackTopIso` is the iter-036 target) |
| `Picard_GrassmannianCells.tex` | ✅ | ✅ | **DISPATCH** (E1 is the primary API target) |

No chapter is `partial`/`false`. No prover lane is deferred.

---

## Incomplete-Proof Summary

Blocks without `\leanok` on their proof node, by chapter (key items only; full count covered by `unmatched_lean: 94`):

### FBC
- `lem:pushforward_base_change_mate_cancelBaseChange` — proof open; cascades from `gstar_transpose` (now `\leanok`). Prover target this iter.
- `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a) — sorry-bearing; intentionally inert (new proof does not depend on it).
- `lem:affine_base_change_pushforward` — statement `\leanok`; proof pending `cancelBaseChange`.

### GF
- `lem:gf_qcoh_fintype_finite_sections` (G1) — gated on gap1.
- `lem:gf_flat_locality_assembly` (G3) — gated on G1.
- `lem:gf_polynomial_core` proof (L5) — Lean elaboration blocker (OreLocalization instance alignment); math is complete.

### QUOT
- `lem:pullback_gamma_top_iso` — prover target (decl does not exist yet).
- `lem:section_localization_descent` — gated on `lem:pullback_gamma_top_iso`.
- `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) — gated on `lem:section_localization_descent`.

### GR
- All 7 cheap-properness blocks (`lem:gr_compactSpace_scheme` through `lem:gr_valuativeExistence_toSpecZ`) — new this iter, no sorry yet; prover targets.
- E1–E4 (`lem:gr_existence_chart_factorization` through `lem:gr_existence_lift`) — new this iter, no sorry yet.
- `lem:gr_proper` — terminal target; gated on `lem:gr_valuativeExistence_toSpecZ`.

---

## Lean-Target Well-Formedness Pass

All new lemmas introduced this iter have well-formed Lean-target signatures:

| lemma | `\lean{}` name | well-formed? | notes |
|---|---|---|---|
| `lem:section_localization_descent_of_cover` | `isLocalizedModule_basicOpen_descent_of_cover` | ✅ | landed axiom-clean iter-035 |
| `lem:eq_of_locally_eq_mathlib` | `TopCat.Sheaf.eq_of_locally_eq'` | ✅ | Mathlib |
| `lem:pullback_gamma_top_iso` | `gammaPullbackTopIso` | ✅ | iter-036 prover target |
| `lem:gr_existence_chart_factorization` | `Grassmannian.existence_chart_factorization` | ✅ | E1 primary API target |
| `lem:gr_existence_minimal_valuation` | `Grassmannian.existence_minimal_valuation` | ✅ | E2 |
| `lem:gr_existence_factor_through_valuation_ring` | `Grassmannian.existence_factor_through_valuationRing` | ✅ | E3; sign-bookkeeping sub-step flagged |
| `lem:gr_existence_lift` | `Grassmannian.existence_lift` | ✅ | E4 |
| `lem:gr_valuativeExistence_toSpecZ` | `Grassmannian.valuativeExistence_toSpecZ` | ✅ | |
| `lem:gr_compactSpace_scheme` through `lem:gr_isProper_of_valuativeExistence` (6 cheap) | Grassmannian.* names | ✅ | standard properness reductions |

No name-collision or universe-level issues detected.

---

## Unstarted-Phase Blueprint Proposals

**No phase listed in STRATEGY.md is entirely without blueprint coverage.** All 7 phases (FBC-A, FBC-B, GF-geo, GR-proper, QUOT-defs, SNAP-S1/S3, QUOT-repr) have existing blueprint chapters and stub/formalized nodes.

**Thin-coverage areas (not blocking, but worth a blueprint pass before dispatch):**

1. **GF-geo G1 proof detail** (`lem:gf_qcoh_fintype_finite_sections`):  
   The proof uses "finite generation is local on a cover" as an unnamed step. Extracting this as `lem:finite_of_locallyFinite_cover` (Stacks 00EJ) would decouple G1 from the Mathlib internals and give the prover a clean target. Currently it is stated inline in the proof block.

2. **SNAP-S1/S3 Open Q1** (`def:sectionGradedRing` tensor-powers convergence):  
   The blueprint has `def:sectionGradedRing` and `def:sectionGradedModule` with statements, but the key finiteness lemma (`sectionGradedRing_isFiniteType`: the section graded ring of a coherent sheaf on a projective variety is a finitely generated graded ring) is not yet a named blueprint node. This is the gating condition for SNAP-S1/S3. Proposing: add `lem:sectionGradedRing_isFiniteType` with `\lean{AlgebraicGeometry.sectionGradedRing_isFiniteType}` under `def:sectionGradedRing`, citing Serre's theorem (EGA III, 2.3.1 / Hartshorne III.5.2).

3. **GR-proper E3 matrix lemma** (inline sub-step):  
   The proof of E3 (`lem:gr_existence_factor_through_valuation_ring`) relies on a matrix identity (column-substituted identity determinant expansion) that has no dedicated lemma. If the prover finds this sticky, proposing: `lem:gr_entries_as_minor_expansion` (entries of `X^J` expressed as signed minors `P^J_{K'}`) would give a cleaner target.

---

## Review Agent Action Items

1. **Update stale NOTE at conj-2a** (`lem:base_change_mate_fstar_reindex_legs_conj`, lines 2207–2216 of `Cohomology_FlatBaseChange.tex`):  
   Current text says "iter-036 executes the pre-scheduled explicit-inverse + element-ext affine-local refactor". This is now incorrect: `lem:base_change_mate_gstar_transpose` was closed via the `huce` calculus (NOT explicit-inverse), and is `\leanok`. The NOTE should be updated to: "iter-036 closed `gstar_transpose` via the `huce` calculus (reverted from explicit-inverse); conj-2a remains as an inert sorry since the new proof does not depend on it."

2. **Confirm `\leanok` propagation for `lem:section_localization_descent_of_cover`** at next `sync_leanok` run. The decl `isLocalizedModule_basicOpen_descent_of_cover` is axiom-clean (landed iter-035) and the `\lean{}` tag was added this iter; `sync_leanok` will add `\leanok` to both the statement and proof blocks.

3. **Trim `\uses{}` over-specification in `lem:pullback_gamma_top_iso` statement block** (optional, minor): Remove `lem:over_restrict_pullback_iso`, `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` from the statement's `\uses{}` — they are downstream consumers, not logical dependencies of the statement itself. The proof block's `\uses{}` is already accurate.

---

## Summary

The blueprint is structurally sound (DAG clean, 0 unknown_uses, 0 isolated). All three HARD-GATE chapters are `complete=true, correct=true`. Prover dispatch is authorized for all three lanes. The only blocking item is an annotation cleanup (stale NOTE in conj-2a of FlatBaseChange), which the review agent can address without re-running the blueprint-writer or deferring any prover. The iter-036 primary prover targets are:

- **FBC-A:** `pushforward_base_change_mate_cancelBaseChange` (cascades from closed `gstar_transpose`)  
- **QUOT gap1-D:** `gammaPullbackTopIso` (section transport, 3-step sketch)  
- **GR-proper:** E1 `existence_chart_factorization` + cheap-properness blocks  
