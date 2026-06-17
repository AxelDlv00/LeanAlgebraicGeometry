# Lean ↔ Blueprint Check Report

## Slug
csi

## Iteration
056

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (Sub-brick A section, lines ~7455–7758)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechBackbone_left_sigma}` (chapter: `lem:cech_backbone_left_sigma`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(coverCechNerveOver 𝒰).obj (op (mk p)) ≅ ∐ fun σ … Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))` in `Over X`. Matches blueprint exactly.
- **Proof follows sketch**: N/A — body is `:= sorry`; `\leanok` on statement block is correct.
- **notes**: Blueprint proof sketch (fibre products distribute over coproducts, each factor is an intersection open) is adequate for a prover to pick up.

---

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `pushPullObj F Y_p ≅ ∏ᶜ fun σ … pushPullObj F (Over.mk j_σ)` in `X.Modules`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **notes**: Blueprint proof sketch (transport via Stub 1, build comparison map from coproduct inclusions, check iso on underlying presheaf via `isProductOfDisjoint` + `coprodPresheafObjIso`) is adequate.

---

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ⊓ V, F)` as `Ab` objects (via `SheafOfModules.forget`). Matches blueprint.
- **Proof follows sketch**: yes (partial route collapse) — Blueprint prescribes three steps: (1) pushforward_obj_obj (rfl), (2) restrictFunctorIsoPullback, (3) restrict_obj (rfl) + image-preimage equality. The Lean proof folds steps 1 and 3 (both definitional) into a single `eqToIso` and constructs step 2 explicitly via `(Scheme.Modules.toPresheaf …).mapIso (restrictFunctorIsoPullback j).app F.symm`. The collapse is mathematically valid and the Lean proof is **axiom-clean** (no `sorry`). The blueprint notes these two steps are `rfl`, which is consistent with their collapse.
- **notes**: Stub 3 is the only fully closed declaration in this file. No issues.

---

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `Γ(V, pushPullObj F Y_p) ≅ ∏ᶜ fun σ … Γ(coverInterOpen 𝒰 σ ⊓ V, F)`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **notes**: Assembly of Stubs 2 and 3 plus `evaluationPreservesLimitsOfShape`; adequate blueprint sketch.

---

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes
- **Signature matches**: partial / WRONG — see Red Flags §1 below. The Lean signature faithfully transcribes the blueprint statement, but the blueprint statement is internally inconsistent with `def:cech_augmented_complex`. Specifically:
  - `def:cech_augmented_complex` (blueprint, lines 7107–7125) states: "its degree-0 term is F and its degree-(p+1) term is C^p".
  - `lem:cechSection_complex_iso` (blueprint, line 7674) describes `D` as "the cochain complex with `D^p = Γ(V, pushPullObj F Y_p)`" — OMITTING the augmentation node at degree 0.
  - Consequence: `D.X 0 = Γ(V, F)` (from the augmented complex definition) but `D'.X 0 = ∏_i Γ(U_i ∩ V, F)` (from `sectionCechComplex`). These are NOT equal in general (they differ exactly by the sheaf property). The stated iso `D ≅ D'` is therefore **false**.
- **Proof follows sketch**: N/A — body is `:= sorry`; Lean file NOTE (lines 224–258) documents the falsity.
- **notes**: The blueprint's own description of D contradicts `def:cech_augmented_complex` — the blueprint is the primary source of the mis-specification. The corrected target is `D ≅ D'.augment ε hε` (augmented sectionCechComplex), which is NOT in the blueprint.

---

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes
- **Signature matches**: no — statement is provably false as written (see Red Flags §2).
  - The Lean and blueprint both claim `Homotopy (𝟙 D') 0` for `D' = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp`, the **non-augmented** section Čech complex.
  - The non-augmented `sectionCechComplex` has `H^0(D') = Fp(V)` by the sheaf equalizer (the sheaf property forces ker(d^0) = Fp(V)). A contracting homotopy `h` on a cochain complex requires `h^1 ∘ d^0 = id_{D'.X 0}` at degree 0 (since `h^0 = 0` in a cochain complex), which forces `d^0` to be injective, hence `ker(d^0) = 0`, i.e. `Fp(V) = 0`. FALSE for non-trivial F and V.
  - Counterexample: one-member cover `{V}` gives `D'.X 0 = Fp(V)`, `d^0 = 0`, `H^0(D') = Fp(V) ≠ 0`. Any contracting homotopy would force `Fp(V) = 0`. Contradiction.
- **Proof follows sketch**: N/A — body is `:= sorry`; unfillable as stated.
- **notes**: The corrected target is `Homotopy (𝟙 D'_aug) 0` where `D'_aug = D'.augment ε hε` (augmented sectionCechComplex). Additionally, even for the corrected target, the blueprint proof sketch is UNDER-SPECIFIED: the `depHomotopy` engine handles only positive degrees (≥ 1); the augmentation node (degree 0) requires a separate argument via the sheaf equalizer to show `ε` is a split mono in the contractible case. The blueprint proof mentions only the engine and the prepend-identity property, with no discussion of the augmentation node.

---

## Red flags

### Placeholder / suspect bodies
- `cechSection_complex_iso` at line 314: body is `:= sorry`, and the Lean file's NOTE block (lines 224–258) documents that the statement is **mathematically false** as written — the sorry cannot be filled. This is not a deferral; the declaration is a wrong-statement placeholder.
- `cechSection_contractible` at line 372: body is `:= sorry`, and the NOTE block documents that the statement is **provably false** (the non-augmented sectionCechComplex is not contractible). Cannot be filled.

### Excuse-comments
- `CechSectionIdentification.lean:224–258`: the multi-paragraph `⚠ PROVER FINDING` NOTE block explicitly documents that Stubs 5 and 6 "cannot be closed as stated" and that "the original Stub 5/6 sorries below are left untouched". Per the checker's rules this constitutes an excuse-comment on declarations whose blueprint claims them to be substantive (both carry `\lean{...}` + `\leanok` in the blueprint). However, the NOTE is substantively different from a "TODO: replace with real def" style comment — it constitutes a mathematical disproof of the stated claim, which is a **required** prover finding. The finding is legitimate; the red flag is that the underlying statements remain wrong and need blueprint correction before they can be re-attempted.

### Blueprint internal inconsistency (critical)
- **`lem:cechSection_complex_iso` vs `def:cech_augmented_complex`** (blueprint lines 7671–7674 vs 7115–7124): `def:cech_augmented_complex` states the augmented complex has degree-0 term F and degree-(p+1) term C^p; `lem:cechSection_complex_iso` describes the same complex as having `D^p = Γ(V, pushPullObj F Y_p)` for all p, omitting the augmentation node. This is a BLUEPRINT-SIDE internal inconsistency that is the root cause of the Lean false statement.

### Axioms / Classical.choice
- None introduced.

---

## Unreferenced declarations (informational)

All six declarations in the Lean file have corresponding `\lean{...}` blueprint blocks. There are no helper declarations. Coverage is complete at the reference level (though two declarations carry wrong statements).

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 Lean declarations have a `\lean{...}` block in the chapter.
- **Proof-sketch depth**: **adequate for Stubs 1–4; under-specified for Stub 6; silent on corrected Stubs 5–6**.
  - Stubs 1–4: proof sketches are detailed enough for a prover to follow.
  - Stub 5 (`lem:cechSection_complex_iso`): the sketch is internally inconsistent with `def:cech_augmented_complex` — it says degreewise iso is `pushPull_eval_prod_iso` for ALL p, but this cannot match D.X 0 = Γ(V,F).
  - Stub 6 (`lem:cechSection_contractible`): the sketch describes applying `depHomotopy` to the non-augmented D', but even for the corrected target D'_aug, the engine covers only degrees ≥ 1. The augmentation node is unaddressed.
  - Corrected Stubs 5' and 6': ABSENT from the blueprint entirely. No prose, no `\lean{...}` hint, no `def:` for D'_aug. Pure coverage debt.
- **Hint precision**: **partially wrong for Stubs 5–6**. The `\lean{...}` hints name the correct Lean declarations (the ones that will eventually carry the corrected statements), but the informal statements pinned by the blueprint are false.
- **Generality**: matches need for Stubs 1–4. Stubs 5–6 need to be re-scoped to the augmented complex.
- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. **Fix `lem:cechSection_complex_iso`**: change the statement to describe `D` correctly as the evaluated augmented complex: `D.X 0 = Γ(V, F)` and `D.X (p+1) = Γ(V, pushPullObj F Y_p)`, and replace `D ≅ D'` with `D ≅ D'_aug := (sectionCechComplex …).augment ε hε`. Add a `def:` block for the augmentation map ε: Γ(V,F) → ∏_i Γ(U_i ∩ V, F) (restriction product) and `hε : ε ≫ d^0 = 0`. Update the proof sketch: degreewise iso holds in degree 0 by `hε`+augmentation functoriality, and for degree `p+1` by `pushPull_eval_prod_iso`.
  2. **Fix `lem:cechSection_contractible`**: change the target to `Homotopy (𝟙 D'_aug) 0`. Update the proof sketch to address BOTH the augmentation node (degree 0, needing the sheaf equalizer to show ε is a split mono, which holds because V ≤ U_{i_fix} makes restriction to any U_j ∩ V factor through Γ(V,F) via the diagonal map) AND the positive degrees (dep engine applies unchanged).
  3. **Fix `lem:cechSection_isZero_homology`**: the proof already has the right structure; update the uses of Stubs 5–6 to point at the corrected lemmas.
  4. All three fixes should maintain the `\leanok` state (declarations exist) but should add `% NOTE:` annotations documenting the prior false statements until the Lean sorries are closed.

---

## Severity summary

| Declaration | Lean | Blueprint | Severity |
|---|---|---|---|
| `cechBackbone_left_sigma` | sorry (OK) | adequate | none |
| `pushPull_sigma_iso` | sorry (OK) | adequate | none |
| `pushPull_leg_sections` | **proved, axiom-clean** | adequate | none |
| `pushPull_eval_prod_iso` | sorry (OK) | adequate | none |
| `cechSection_complex_iso` | sorry, statement is false | **internal inconsistency with def:cech_augmented_complex; wrong statement** | **must-fix-this-iter** |
| `cechSection_contractible` | sorry, statement is provably false | **false claim, under-specified proof sketch** | **must-fix-this-iter** |

**Blueprint adequacy**: the chapter is the PRIMARY source of the Stubs 5–6 mis-specification; it is internally inconsistent. This is itself a `must-fix-this-iter` blueprint finding.

**Overall verdict**: Stubs 1–4 are clean (Stub 3 is proved axiom-clean; Stubs 1, 2, 4 have correct sorry stubs); Stubs 5 and 6 carry provably-false statements that originate from a blueprint internal inconsistency between `def:cech_augmented_complex` and `lem:cechSection_complex_iso` — the blueprint must be re-written before these stubs can be closed. 2 declarations checked with correct proofs or stubs; 2 declarations with wrong statements blocking progress.
