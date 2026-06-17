# Blueprint Review — Iter 011 (whole-blueprint audit, prover-gate)

**Date:** iter-011  
**Reviewer:** blueprint-reviewer subagent  
**Scope:** All 6 chapters under `blueprint/src/chapters/`

---

## Diagnostic tool summary

### `leandag build --json`

| Metric | Value |
|---|---|
| blueprint_nodes | 85 |
| lean_aux_nodes | 1 |
| proved (no sorry) | 39 |
| mathlib_ok | 13 |
| with_sorry | 13 |
| edges | 121 |
| isolated | 1 |
| unknown_uses | **0** |
| conflicts | **0** |
| unmatched_lean (total) | 31 = 13 mathlib anchors + 18 project nodes with no declaration yet |

Zero unknown_uses and zero conflicts — the dependency graph is clean across all chapters.

### `leandag show isolated`

One isolated node: `lean:Alg…` (type `lean_aux`, no chapter, 0 deps, 0 impact). Cosmetic — this is the orphaned lean-aux registration from the RegroupHelper import fix. No blueprint defect.

### `archon blueprint-doctor --json`

| Metric | Value |
|---|---|
| labels_defined | 115 |
| broken_refs | **0** |
| malformed_refs | **0** |
| axiom_decls | **0** |
| covers_problems | **0** |
| orphan_chapters | **0** |
| chapters present / included | 6 / 6 |

Blueprint is fully linked and rendering-clean. No axiom introductions anywhere.

---

## Per-chapter verdicts

### Chapter 1 — `Cohomology_RegroupHelper`

```
complete: true
correct:  true
```

Single node (`lem:base_change_regroup_linearEquiv`). Both statement and proof carry `\leanok`. Dependency `lem:isPushout_cancelBaseChange_mathlib` is a mathlib_ok anchor. No open sorries, no defects.

**Formalizable targets with `% LEAN SIGNATURE`:** none (chapter fully closed).

---

### Chapter 2 — `Cohomology_FlatBaseChange`

```
complete: true
correct:  true
```

The entire supporting infrastructure is proved (`\leanok` confirmed on all of: `def:pushforward_base_change_map`, `lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:base_change_mate_regroupEquiv`, `lem:base_change_mate_generator_trace`, `lem:pushforward_base_change_mate_cancelBaseChange`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`, and all locality helpers). The only open sorry (non-mathlib) is the frontier node `lem:base_change_mate_section_identity`.

That node has:
- `\lean{AlgebraicGeometry.base_change_mate_section_identity}`
- Full `% LEAN SIGNATURE` block with explicit Lean type
- Detailed proof sketch (tilde-dictionary rewriting → section identity `Γ(θ) = lTensor R' η_M` → regroupEquiv post-composition)
- All `\uses{}` resolved: `lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:base_change_mate_regroupEquiv`

Mathlib anchors correctly marked (`\mathlibok`): `lem:pullbackSpecIso_mathlib`, `lem:cancelBaseChange_mathlib`, `lem:isPushout_cancelBaseChange_mathlib`. FBC-B Mathlib anchor `lem:flat_preserves_equalizer_mathlib` is present and correctly pointed at `LinearMap.tensorEqLocusEquiv`; not yet needed (FBC-B is NEXT phase).

**Formalizable targets with `% LEAN SIGNATURE`:**
- `lem:base_change_mate_section_identity` ✓ (signature + proof sketch + resolved deps)

---

### Chapter 3 — `Picard_FlatteningStratification`

```
complete: true
correct:  true
```

All GF-alg nodes from the iter-009 effort-break have `% LEAN SIGNATURE` blocks and proof sketches. Dependency graph clean (all Mathlib anchors marked `\mathlibok`). Several nodes already have matching declarations with sorry in `FlatteningStratification.lean` (`gf_noether_clear_denominators`, `gf_clear_one_denominator`, `gf_torsion_reindex`, `gf_generic_rank_ses`, `gf_polynomial_core`, `thm:generic_flatness_algebraic`, `thm:generic_flatness`); the four GF chain sub-lemmas from the directive are the bottom of that stack.

Mathlib anchors correctly placed: `lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`, `lem:annihilator_meets_nonZeroDivisors`, `lem:polynomial_monic_quotient_finite`.

**Formalizable targets with `% LEAN SIGNATURE`:**
- `lem:gf_torsion_annihilator` ✓ — unmatched (no decl yet); signature + proof sketch; `\uses{lem:annihilator_meets_nonZeroDivisors}` (mathlib_ok)
- `lem:gf_nagata_monic_lastVar` ✓ — unmatched; signature + proof sketch; no further project deps
- `lem:gf_mvPolynomial_quotient_finite_monic` ✓ — unmatched; signature + proof sketch; `\uses{lem:polynomial_monic_quotient_finite}` (mathlib_ok)
- `lem:gf_noether_clear_denominators` ✓ — matched with sorry (`exists_localizationAway_finite_mvPolynomial`); signature + Finset-fold sketch; `\uses{lem:noether_normalization_fg, lem:gf_clear_one_denominator}`
- `lem:gf_generic_rank_ses` ✓ — matched with sorry; has LEAN SIGNATURE; the generic-rank SES assembly lemma
- `lem:gf_torsion_reindex` ✓ — matched with sorry; assemble from the four sub-lemmas above

---

### Chapter 4 — `Picard_GrassmannianCells`

```
complete: true
correct:  true
```

`def:gr_affine_chart` has `\leanok`. All other nodes (`def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) are in `unmatched_lean` — none has a declaration in `GrassmannianCells.lean` yet. Each has a source citation and proof sketch. The "Out of scope" section correctly excludes GR-quot and GR-repr.

`def:gr_transition` (`AlgebraicGeometry.Grassmannian.transitionMap`) is the effort-break target this iter. See gate verdict below.

**Formalizable targets with `% LEAN SIGNATURE`:**
- `def:gr_transition` ✓ — after effort-break; type `{σ τ : Finset (Fin r)} → (transitionMap σ τ) : Uσ →[S] Uτ`
- `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` ✓ — prose and proof sketches present; downstream of `def:gr_transition`

---

### Chapter 5 — `Picard_QuotScheme`

```
complete: partial
correct:  true
```

**Proved and closed:** `lem:annihilator_localization_eq_map`, `def:hilbert_polynomial`, `def:is_locally_free_of_rank`, `def:quot_functor`, `def:grassmannian_scheme` (all `\leanok`). `thm:grassmannian_representable` has `\leanok` on the statement but the proof is a sorry (blocked on `RelativeSpec` → `RepresentableBy` strengthening, noted).

**Open and formalizable:** `lem:qcoh_section_localization_basicOpen` has a complete LEAN SIGNATURE block (added by iter-009 `quot-bridge-snap`) and proof sketch. `def:modules_annihilator` has a NOTE dependency on it but is otherwise described. `def:schematic_support` and `def:has_proper_support` are in unmatched_lean with proof sketches present (QUOT-defs predicate sub-builds P1/P2).

**The one genuine blueprint gap** (reason for `partial`): `def:sectionGradedRing` has `\lean{AlgebraicGeometry.sectionGradedRing}` but **no `% LEAN SIGNATURE` block**. The iter-007 blocking NOTE ("blocked on absent tensor/monoidal structure for SheafOfModules — deep infrastructure prerequisite") is still present. This blocks the entire SNAP lane: `def:sectionGradedModule`, `lem:sectionGradedModule_fg`, `thm:hilbertPoly_of_sectionModule` all depend on it. Note: `lem:gradedHilbertSerre_rational` (SNAP S2) does NOT depend on `def:sectionGradedRing` — it imports only Mathlib + the graded encoding and is separately authorable.

Mathlib anchors correctly placed: `lem:isLocalization_basicOpen_mathlib`, `lem:isProper_mathlib`, `lem:functor_is_representable_mathlib`, `lem:hilbertPoly_exists_mathlib`.

**Formalizable targets with `% LEAN SIGNATURE`:**
- `lem:qcoh_section_localization_basicOpen` ✓ — unmatched; complete signature block; `\uses{lem:isLocalization_basicOpen_mathlib}` (mathlib_ok)
- `lem:gradedHilbertSerre_rational` ✓ — unmatched; has LEAN SIGNATURE (`gradedModule_hilbertSeries_rational`); imports Mathlib only (SNAP S2, authorable now)
- `def:schematic_support`, `def:has_proper_support` ✓ — prose descriptions; prover needs to invent encoding within QUOT-defs P1 sub-build
- `def:sectionGradedRing` ✗ — **missing LEAN SIGNATURE; must-fix before prover dispatch on SNAP S1/S3**

---

### Chapter 6 — `Picard_RelativeSpec`

```
complete: true
correct:  true
```

All five main declarations have `\leanok` on both statement and proof: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`. Existing NOTE on `thm:relative_spec_univ`: Lean type is `IsAffineHom` rather than `RepresentableBy` (iter-174+ strengthening deferred). This is a known strategic limitation, not a blueprint defect. No nodes in unmatched_lean; zero with_sorry contribution from this chapter.

**Formalizable targets with `% LEAN SIGNATURE`:** none (chapter fully closed modulo the deferred RepresentableBy strengthening).

---

## Gate verdicts

### Gate 1 — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
**Frontier: `lem:base_change_mate_section_identity`**

> **GATE: GREEN — dispatch authorized**

Checklist:
- [x] Chapter `complete: true`, `correct: true`
- [x] `% LEAN SIGNATURE` block present with explicit Lean type
- [x] Proof sketch complete (tilde-dictionary → section identity → regroupEquiv)
- [x] All `\uses{}` deps have `\leanok` (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`, `base_change_mate_domain_read`, `base_change_mate_codomain_read`, `base_change_mate_regroupEquiv`)
- [x] `unknown_uses: []`, `conflicts: []`
- [x] No blocking NOTE on frontier node

No must-fix items.

---

### Gate 2 — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
**Frontier: `lem:gf_torsion_annihilator`, `lem:gf_nagata_monic_lastVar`, `lem:gf_mvPolynomial_quotient_finite_monic`, `lem:gf_noether_clear_denominators`**

> **GATE: GREEN — dispatch authorized on all four nodes**

Checklist:
- [x] Chapter `complete: true`, `correct: true`
- [x] `lem:gf_torsion_annihilator`: `% LEAN SIGNATURE` + proof sketch + dep resolved (mathlib_ok anchor); unmatched — prover writes from scratch
- [x] `lem:gf_nagata_monic_lastVar`: `% LEAN SIGNATURE` + proof sketch; no project deps; unmatched
- [x] `lem:gf_mvPolynomial_quotient_finite_monic`: `% LEAN SIGNATURE` + proof sketch + dep `lem:polynomial_monic_quotient_finite` (mathlib_ok); unmatched
- [x] `lem:gf_noether_clear_denominators`: `\lean{exists_localizationAway_finite_mvPolynomial}` already in `.lean` with sorry; `% LEAN SIGNATURE` + Finset-fold sketch; deps `lem:noether_normalization_fg` (mathlib_ok) + `lem:gf_clear_one_denominator` (also with sorry)
- [x] `unknown_uses: []`, `conflicts: []`

Note: `lem:gf_clear_one_denominator` is in `FlatteningStratification.lean` with sorry (matched, with_sorry). The prover should close `gf_torsion_annihilator` → `gf_nagata_monic_lastVar` → `gf_mvPolynomial_quotient_finite_monic` (bottom-up) before attempting `gf_noether_clear_denominators` / `gf_clear_one_denominator`.

---

### Gate 3 — `AlgebraicJacobian/Picard/QuotScheme.lean`
**Frontier: `lem:qcoh_section_localization_basicOpen` and `def:sectionGradedRing`**

> **`lem:qcoh_section_localization_basicOpen`: GATE GREEN — dispatch authorized**  
> **`def:sectionGradedRing`: GATE BLOCKED — must-fix required before dispatch**

**`lem:qcoh_section_localization_basicOpen` checklist:**
- [x] `% LEAN SIGNATURE` present (added by iter-009 `quot-bridge-snap`): `{X : Scheme.{u}} (F : X.Modules) [SheafOfModules.IsQuasicoherent F] {U : X.Opens} (hU : IsAffineOpen U) (f : Γ(X, U)) : IsLocalizedModule (Submonoid.powers f) ρ`
- [x] Proof sketch present (affine QCoh → IsLocalizedModule via hU.isLocalization_basicOpen)
- [x] `\uses{lem:isLocalization_basicOpen_mathlib}` resolved (mathlib_ok)
- [x] No blocking NOTE on this node
- [x] Downstream `def:modules_annihilator` has a NOTE but is described

**`def:sectionGradedRing` checklist:**
- [ ] `% LEAN SIGNATURE` block: **ABSENT**
- [ ] Proof sketch for tensor/monoidal encoding: **ABSENT** (iter-007 NOTE still in place)
- The iter-007 blocking NOTE reads: "blocked on absent tensor/monoidal structure for SheafOfModules. [...] deep infrastructure prerequisite (tensor product of sheaves of modules + lax-monoidal global sections)"

**Must-fix for `def:sectionGradedRing`:** A blueprint-writer must author (1) a `% LEAN SIGNATURE` block giving a concrete encoding that avoids the full tensor product of sheaves (e.g., using the affine-section graded ring `⊕_m Γ(U, F ⊗ L^m)` on a fixed affine open, or accepting `sorry`-based stub with explicit type), and (2) a proof sketch explaining which Mathlib instances supply the `GradedAlgebra` or `DirectSum` structure. Until that block is present, a prover cannot make progress on SNAP S1 or S3.

Note: SNAP S2 (`lem:gradedHilbertSerre_rational`) is **not** blocked by `def:sectionGradedRing` — it imports only Mathlib + the graded encoding — and is separately dispatchable.

---

### Gate 4 — `AlgebraicJacobian/Picard/GrassmannianCells.lean`
**Node: `def:gr_transition` (effort-break target)**

> **GATE: Report-only — effort-break supersedes prover dispatch this iter**

Chapter is `complete: true`, `correct: true` for all blueprinted content. `def:gr_affine_chart` is `\leanok`. The five remaining nodes (`def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) are all in `unmatched_lean` — no declarations in `GrassmannianCells.lean` yet. Each has a proof sketch and source citation. After the effort-break refines `def:gr_transition`'s LEAN SIGNATURE into smaller sub-targets, the chapter will be ready for a fresh prover dispatch on the refined nodes.

---

## Unstarted-phase blueprint proposals

### FBC-B — H⁰-equalizer globalization (NEXT, zero blueprint coverage)

No blueprint chapter exists for FBC-B. When the plan agent is ready to open FBC-B, the following nodes should be authored:

**Proposed nodes** (all within `Cohomology_FlatBaseChange.tex` or a new `Cohomology_FlatBaseChange_B.tex`):

1. **`lem:fbc_h0_equalizer`** — `H⁰(X, F)` is the equalizer `∏ᵢ Γ(Uᵢ, F) ⇉ ∏ᵢⱼ Γ(Uᵢⱼ, F)` for any finite affine cover `{Uᵢ}` and any `SheafOfModules F`; this is the Čech-degree-0 sheaf condition. Should carry `\lean{}` pointing at a wrapper around `SheafOfModules.isSheaf`. Already hinted in `STRATEGY.md` (FBC route paragraph).

2. **`lem:fbc_flat_lTensor_equalizer`** — flat `− ⊗[R] R'` preserves finite equalizers of modules; immediate from `Module.Flat.ker_lTensor_eq` + `LinearMap.tensorEqLocusEquiv` (both Mathlib). Should be marked `\mathlibok` with `\lean{LinearMap.tensorEqLocusEquiv}` (already present as `lem:flat_preserves_equalizer_mathlib` in the chapter — **this node already exists**; just needs its downstream connection authored).

3. **`thm:flat_base_change_h0`** — globalization: for a finite-type morphism `f : X → Y`, a quasi-coherent `F` on `X`, and a flat `g : Y' → Y`, the base-change map `g^* H⁰(X, F) → H⁰(X', g'^* F)` is an iso; proved by applying `lem:fbc_h0_equalizer` on a finite affine cover + `lem:fbc_flat_lTensor_equalizer` on each term. This is the main FBC-B target; re-signs `thm:flat_base_change_pushforward` at `i=0` in the H⁰-equalizer form.

`\uses{}` dependencies: FBC-B imports `lem:flat_preserves_equalizer_mathlib` (Mathlib, already present) and FBC-A's proved `thm:flat_base_change_pushforward` for the affine case.

### GF-geo — geometric generic flatness (NEXT after GF-alg, minimal blueprint gap)

The chapter has `thm:generic_flatness` with `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` and a LEAN SIGNATURE note. It is matched with sorry in `FlatteningStratification.lean`. Once GF-alg closes, this node needs only:
- A `\uses{thm:generic_flatness_algebraic}` dep edge added
- A proof sketch for the affine-open reduction (apply algebraic core on `Γ(W, F)` for a non-empty affine open `W`, then cover)

Blueprint work required: minimal (add `\uses{}` edge and expand the existing 2-line sketch). No new chapter needed.

### SNAP S2 — graded Hilbert–Serre rationality (authorable now)

`lem:gradedHilbertSerre_rational` (`AlgebraicGeometry.gradedModule_hilbertSeries_rational`) is already blueprinted in `Picard_QuotScheme.tex` with a LEAN SIGNATURE block. It does NOT depend on `def:sectionGradedRing`. The blueprint prose already describes the inductive argument on degree-1 generators of a f.g. graded module over a Noetherian graded ring. This node is **independently dispatchable now** (SNAP S2 — imports Mathlib only). The plan agent may consider dispatching a prover on this node in the current iter without waiting for the `def:sectionGradedRing` fix.

---

## Summary table

| Chapter | complete | correct | Gate verdict |
|---|---|---|---|
| Cohomology_RegroupHelper | true | true | n/a (closed) |
| Cohomology_FlatBaseChange | true | true | **GREEN** — `lem:base_change_mate_section_identity` |
| Picard_FlatteningStratification | true | true | **GREEN** — all four GF chain nodes |
| Picard_GrassmannianCells | true | true | report-only (effort-break this iter) |
| Picard_QuotScheme | **partial** | true | **GREEN** `lem:qcoh_section_localization_basicOpen`; **BLOCKED** `def:sectionGradedRing` (missing LEAN SIGNATURE) |
| Picard_RelativeSpec | true | true | n/a (closed) |

**Overall DAG health:** 0 unknown_uses, 0 conflicts, 0 broken_refs, 0 axiom_decls. One cosmetic isolated lean_aux node. Blueprint is structurally sound for iter-011 prover dispatch on FBC-A and GF-alg lanes.
