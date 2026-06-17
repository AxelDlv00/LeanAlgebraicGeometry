# Lean ↔ Blueprint Check Report

## Slug
fbc-iter045

## Iteration
045

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

The chapter contains 50 `\lean{...}` references. The checks below focus on the conj-2 region (the area touched this iteration) and sample-verify the earlier stable region. All stable declarations checked match their blueprint blocks; details are abbreviated for length.

### Stable region (L1–~1620): all clear

Declarations `pushforwardBaseChangeMap`, `gammaPushforwardIso`, `gammaPushforwardTildeIso`, `gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`, `IsLocalizedModule.powers_restrictScalars`, `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`, `pushforward_spec_tilde_iso`, `gammaPushforwardNatIso`, `pullback_spec_tilde_iso`, `base_change_map_affine_local`, `pullbackSpecIso`, `pullback_fst_snd_specMap_tensor`, `base_change_mate_domain_read`, `base_change_mate_codomain_read`, `base_change_mate_codomain_read_legs`, `pullbackIsoEquivalenceOfIso`, `pullback_isEquivalence_of_iso`, `base_change_mate_regroupEquiv`, `base_change_mate_unit_value`, `base_change_mate_inner_value`, `conjPullbackFactor`, `conjPullbackFactor_eq_pullbackComp`, `base_change_mate_codomain_read_legs_conj`, `base_change_mate_codomain_read_legs_conj_eq`, `base_change_mate_reindex_conj_pullbackLeg`, `base_change_mate_reindex_conj_crossLayer`, and all the Mathlib-pinned items (`unit_conjugateEquiv`, `conjugateEquiv`, `conjugateIsoEquiv`, `leftAdjointCompIso`, `conjugateEquiv_leftAdjointCompIso_inv`, `unit_conjugateEquiv_symm`, `conjugateEquiv_counit_symm`, `conjugateEquiv_comp`, `conjugateEquiv_symm_comp`, `Adjunction.comp_unit_app`, `Scheme.Modules.conjugateEquiv_pullbackComp_inv`, `iterated_mateEquiv_conjugateEquiv`):

- **Lean target exists**: yes (each)
- **Signature matches**: yes
- **Proof follows sketch**: yes / N/A
- **notes**: no issues found

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (chapter: lem:gammaMap_pushforwardComp_hom_eq_id)
- **Lean target exists**: yes (L≈1717)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (chapter: lem:gammaMap_pushforwardComp_inv_eq_id)
- **Lean target exists**: yes (L≈1740)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (chapter: lem:gammaMap_pushforwardCongr_hom)
- **Lean target exists**: yes (L≈1759, inside `base_change_mate_reindex_conj_pushforwardCollapse`)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pushforwardCollapse}` (chapter: lem:base_change_mate_reindex_conj_pushforwardCollapse)
- **Lean target exists**: yes (L1736)
- **Signature matches**: yes (bundles the three Γ-collapse sub-lemmas)
- **Proof follows sketch**: yes
- **notes**: all three collapse legs axiom-clean; `leanok` on statement block (correct — iter-044 landed)

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj}` (chapter: lem:base_change_mate_fstar_reindex_legs_conj, ~L2218 blueprint)
- **Lean target exists**: yes (L1802)
- **Signature matches**: yes — `sorry` at L1949 is the expected open crux; the statement is fully typed with explicit `g' f' hfst hsnd comm` hypotheses
- **Proof follows sketch**: **partial** — the blueprint proof sketch (§lem:base_change_mate_fstar_reindex_legs_conj) describes the conjugate injectivity strategy and lists the three legs (conj-2b/2c/2d) as sufficient, but does NOT name `keystoneAdjR`/`keystoneBeta` as named sub-declarations; the Lean proof correctly introduces them via `set` at L1932–1933
- **notes**: `\leanok` on statement block (correct, sorry present); proof block has NO `\leanok` (correct, proof open). Blueprint comment `% NOTE: all three supporting legs are axiom-clean (conj-2b …` at L2219 is accurate. No fake statements; the sorry is the documented open crux, not a hidden placeholder.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: lem:base_change_mate_fstar_reindex_legs, ~L2276 blueprint)
- **Lean target exists**: yes (L1962)
- **Signature matches**: yes (thin wrapper over `_conj`)
- **Proof follows sketch**: yes — one-line `exact … ▸ …` correctly bridges conj-1b back to the concrete codomain read
- **notes**: inherits the sorry from `_conj` via `exact`; correct and expected

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (chapter: lem:base_change_mate_fstar_reindex, ~L2331 blueprint)
- **Lean target exists**: yes (L≈2013)
- **Signature matches**: yes (concrete instantiation at `pullback.fst`/`pullback.snd`)
- **Proof follows sketch**: yes (instantiation of `_legs`)
- **notes**: inherits sorry; correct propagation

---

## Red flags

### Placeholder / suspect bodies
- `base_change_mate_fstar_reindex_legs_conj` at L1949: `sorry`. **This is explicitly the documented open crux for this iteration, not an unauthorized placeholder.** Blueprint statement block has `\leanok` (sorry present); proof block has no `\leanok`. The sorry propagates correctly to `_legs` (L1999) and `_reindex` (L≈2050). No surprise.

No other sorries or suspect bodies found in the conj-2 region or earlier stable region.

### Excuse-comments
None. The internal comments at L1839–1948 are progress-narrative (iter numbers, "parked residual") consistent with an open sorry, not excuse-comments masking wrong code. The mathematical claim is correctly stated and the comments describe the remaining proof gap honestly.

### Axioms / Classical.choice on non-trivial claims
None found in this file region. No unauthorized `axiom` declarations introduced this iteration.

---

## Unreferenced declarations (informational)

The following non-private declarations in `FlatBaseChange.lean` have **no** `\lean{...}` reference in the blueprint chapter:

### `keystoneAdjR` (L1755) — **MAJOR: missing blueprint block**
- `noncomputable def keystoneAdjR {R R' A : CommRingCat.{u}} (ψ : R ⟶ R') (φ : R ⟶ A) : _`
- The return type is inferred (depth-3 adjunction composite: `extendRestrictScalarsAdj inclA.hom` composed with `tilde.adjunction` composed with `pullbackPushforwardAdjunction e.hom`).
- Doc-string says "Project-local scaffold for `base_change_mate_fstar_reindex_legs_conj`."
- Blueprint mentions "keystone" only in a `%` comment at L2219 in the `.tex` file. No `\lean{}` block exists.

### `keystoneBeta` (L1772) — **MAJOR: missing blueprint block**
- `noncomputable def keystoneBeta {R R' A : CommRingCat.{u}} (ψ : R ⟶ R') (φ : R ⟶ A) : (pushforward (e.hom ≫ Spec.map inclA) ⋙ moduleSpecΓFunctor) ≅ (pushforward e.hom ⋙ moduleSpecΓFunctor) ⋙ restrictScalars inclA.hom`
- Built from `pushforwardComp e.hom (Spec.map inclA)` and `gammaPushforwardNatIso inclA`, whiskered by `Functor.associator`.
- Doc-string says "Project-local scaffold for `base_change_mate_fstar_reindex_legs_conj`."
- Not referenced by any `\lean{...}` block.

### Other helpers (acceptable — not flagged)
The following helpers are private or clearly internal scaffolding and do not warrant blueprint blocks: `base_change_mate_reindex_conj_pushforwardCollapse`'s three sub-sub-lemmas (anonymous), and the inlined `show`/`calc` chains inside `keystoneAdjR`/`keystoneBeta`. These are implementation details.

### Pre-existing known discrepancy: `pushforward_base_change_mate_sections_direct`
Blueprint L3290–3295 has `\lean{AlgebraicGeometry.pushforward_base_change_mate_sections_direct}` with a `% NOTE: the Lean target … was NOT added (correctly)`. The declaration does not exist in the Lean file. **This is intentional and documented.** It is not flagged as a new finding; the blueprint NOTE correctly records the abandoned route.

---

## Blueprint adequacy for this file

### Coverage
48/50 `\lean{...}` blocks verified against present Lean declarations. The two gaps are:
- `pushforward_base_change_mate_sections_direct` — intentionally absent (documented `% NOTE`), pre-existing.
- `keystoneAdjR` and `keystoneBeta` — newly absent: these are non-trivial project-local defs introduced this iteration that feed the still-open `_legs_conj` crux, with no blueprint block.

### Proof-sketch depth: **under-specified** for the conj-2a proof

The blueprint's `\begin{proof}` for `lem:base_change_mate_fstar_reindex_legs_conj` describes:
1. Apply `conjugateEquiv.injective` to both sides.
2. Split the composite into single-pair conjugate factors via `conjugateEquiv_symm_comp`.
3. Discharge each factor by its push-through law (conj-2b, conj-2c, conj-2d).

This is accurate as a mathematical route but **does not specify** that the conjugate pair's right adjunction requires a named depth-3 composite (`keystoneAdjR`) or that the right-adjoint comparison nat-iso requires a named non-monolithic gluing (`keystoneBeta`). A prover reading only the blueprint could not have derived that these needed to be broken out as standalone definitions — nor the specific construction (`extendRestrictScalarsAdj.comp (tilde.adj.comp pullbackPushforwardAdj)`) for `keystoneAdjR`, nor the `pushforwardComp`/`gammaPushforwardNatIso`-whisker assembly for `keystoneBeta`.

The blueprint also does not describe the `set adjR := keystoneAdjR` / `set β := keystoneBeta` idiom needed to make `conjugateEquiv` typecheck at the proof level — a subtlety that is not derivable from the prose.

### Hint precision: **precise** for all stable declarations
All `\lean{...}` pins in the chapter name the correct Lean identifiers with the correct namespaces. No hint uses a wrong Mathlib predicate.

### Generality: **matches need**
No parallel API gap found. The blueprint's generality level matches what the Lean file implements.

### Recommended chapter-side actions
1. **Add a `\lean{AlgebraicGeometry.keystoneAdjR}` blueprint block** (new lemma/def environment, e.g. `\begin{definition}\label{def:keystoneAdjR}`) describing the three-layer right-adjunction composite `(extend⊣restrict)_{inclA} ∘ (tilde⊣Γ_{A⊗R'}) ∘ (pullback e.hom ⊣ push e.hom)` with a note that it is the conjugate-pair right adjunction for `lem:base_change_mate_fstar_reindex_legs_conj`.
2. **Add a `\lean{AlgebraicGeometry.keystoneBeta}` blueprint block** describing the nat-iso comparison built from `pushforwardComp e.hom (Spec.map inclA)` and `gammaPushforwardNatIso inclA`, with the explicit functor-whiskering assembly, and noting it is the `β : R₁ ≅ R₂` component of the conjugate pair.
3. **Expand the proof sketch** for `lem:base_change_mate_fstar_reindex_legs_conj` to describe the two-stage assembly: (stage 1) close the A-level base-change identity via `huce`/`adjR.unit`/`adjL.unit` using the `keystoneAdjR`/`keystoneBeta` scaffolds; (stage 2) transport through the `gammaPushforwardNatIso φ`/`ψ` dictionaries with the ring-equation bridge from `base_change_mate_inner_value`.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `keystoneAdjR` (L1755): non-private def, no `\lean{}` block or blueprint environment | **major** |
| `keystoneBeta` (L1772): non-private def, no `\lean{}` block or blueprint environment | **major** |
| Blueprint proof sketch for `_legs_conj` under-specified (missing `keystoneAdjR`/`keystoneBeta` decomposition and two-stage assembly) | **major** |
| `base_change_mate_fstar_reindex_legs_conj` sorry at L1949 | informational (expected, correctly reflected by `\leanok` state) |
| `pushforward_base_change_mate_sections_direct` `\lean{}` pin with no Lean target | informational (pre-existing, documented `% NOTE`) |

The three **major** findings do not trigger the must-fix-this-iter gate (no fake statements, no signature mismatches, no excuse-comments, no unauthorized axioms). They are blueprint coverage gaps: the helpers exist and typecheck, but are undocumented in the chapter. Blocking status: these should be addressed before `_legs_conj` closes, so the blueprint can guide the two-stage assembly proof.

**Overall verdict**: The Lean file faithfully follows the blueprint for all stable declarations and correctly introduces the sorry-bearing `base_change_mate_fstar_reindex_legs_conj`; the two new project-local scaffolds `keystoneAdjR` and `keystoneBeta` are axiom-clean and correctly structured, but they have no blueprint blocks and the chapter's proof sketch for `_legs_conj` does not describe the two-stage assembly they enable, leaving the blueprint under-specified for closing the crux.
