# Lean ↔ Blueprint Check Report

## Slug
cechterm

## Iteration
077

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: `lem:cech_term_pushforward_acyclic` @L11636, `lem:rightAcyclic_finite_prod` @L11820)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechTerm_pushforward_acyclic}` (chapter: `lem:cech_term_pushforward_acyclic`)

- **Lean target exists**: yes — `CechTermAcyclic.lean:699`
- **Signature matches**: **no** — critical mismatch (see Red Flags)
- **Proof follows sketch**: partial — the three-step structure (product decomposition → per-factor acyclicity → rightAcyclic_finite_prod) matches the blueprint's proof sketch at L11671-11706. However the proof routes through `higherDirectImage_affineHom_acyclic` (affine morphism from affine, not just open immersion) and `isQuasicoherent_pullback_opens`, neither of which appears in the blueprint's proof steps.
- **notes**: No sorries. The `leanok` marker is absent from the blueprint statement block — consistent with pre-sync state.

### `\lean{AlgebraicGeometry.rightAcyclic_finite_prod}` (chapter: `lem:rightAcyclic_finite_prod`)

- **Lean target exists**: yes — `CechTermAcyclic.lean:120`
- **Signature matches**: partial — the mathematical content matches (finite product of acyclic objects is acyclic). The Lean carries `[HasFiniteProducts 𝒜]` and `[Abelian ℬ]` not mentioned in the blueprint. Both are implicit in the "abelian category" language, but `[HasFiniteProducts 𝒜]` is a separate typeclass hypothesis beyond `[Abelian 𝒜]`.
- **Proof follows sketch**: yes — uses biproduct decomposition + additivity of right-derived functor, matching the blueprint's one-paragraph proof.
- **notes**: No sorries.

---

## Red flags

### Blueprint statement FALSE — signature mismatch on `cechTerm_pushforward_acyclic`

**Blueprint (L11648-11657) asserts:**
> Let `f : X → S` be separated and quasi-compact, `F` a quasi-coherent O_X-module, and `𝔘` a finite affine open cover of `X` with all intersections affine. Then every degree-p Čech term is right `f_*`-acyclic.

**Lean signature (CechTermAcyclic.lean:699-704):**
```lean
lemma cechTerm_pushforward_acyclic [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ)
    (hres : ∀ σ : Fin (p + 1) → 𝒰.I₀,
      HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules) :
    (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X p)
```

The Lean carries **three hypotheses absent from the blueprint**:

1. **`[X.IsSeparated]`** — separatedness of the total space X. The blueprint says only "f separated"; that is insufficient.
2. **`[S.IsSeparated]`** — separatedness of the base S. The blueprint says nothing about S.
3. **`hres : ∀ σ, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules`** — injective resolutions on each intersection scheme. The blueprint is silent on this Mathlib gap.
4. **`[HasInjectiveResolutions X.Modules]`** — injective resolutions on X. The blueprint does not mention this.

The module docstring (CechTermAcyclic.lean:14-37) provides a **concrete counterexample** demonstrating the blueprint statement is false without `[S.IsSeparated]`:

> "Let S = affine plane with doubled origin, X = 𝔸², f : X → S an open immersion. Then 𝒰 = {𝟙 X} is a finite affine cover with X affine and separated. The one-element Čech complex is just f_* F in degree 0, so the claim specializes to R^k f_* F = 0 for k ≥ 1. But for F = O_X the stalk of R^1 f_* O_X at the doubled origin is H²_𝔪(A) ≠ 0."

The underlying geometric error: for affine U ⊆ X and affine V ⊆ S, the intersection U ∩ f⁻¹(V) ≅ U ×_S V is affine only when **the diagonal of S is affine** (S separated), not merely f separated.

This is a **must-fix** finding: the blueprint states a theorem that is provably false without `[X.IsSeparated]` and `[S.IsSeparated]`.

### Excuse-comments

- `CechTermAcyclic.lean:14-37`: The module docstring says "IMPORTANT signature correction (iter-077 prover)" and explicitly acknowledges the blueprint statement is false. This is not an excuse for wrong code — the Lean is correct and the blueprint is wrong — but it confirms this discrepancy is known and must be fixed in the blueprint.

---

## Unreferenced declarations (informational)

The file contains 30 declarations; only 2 have `\lean{...}` blueprint entries. The following are unreferenced. They are grouped by significance:

### Substantive — should be blueprinted (coverage debt)

| Declaration | Line | Significance |
|---|---|---|
| `higherDirectImage_affineHom_acyclic` | 183 | Key generalization of `lem:open_immersion_pushforward_acyclic` from affine open immersions to arbitrary affine morphisms from affine schemes. Directly used in the proof of `cechTerm_pushforward_acyclic`. Blueprint uses it implicitly in proof prose (L11693 "relative affine vanishing") but provides no standalone `\lean{}` block. |
| `pushPullObj_opens_pushforward_acyclic` | 654 | Single-factor acyclicity lemma — the main per-σ step. Identified in code as "the single-σ case of cechTerm_pushforward_acyclic." No blueprint entry. |
| `isQuasicoherent_pullback_opens` | 623 | Theorem: restriction of a quasi-coherent module to an open subscheme is quasi-coherent (Stacks 01XZ-adjacent). Not in Mathlib; proved here via the full RestrictOverBridge infrastructure. No blueprint entry. |
| `modulesOverOpensEquivalence` | 379 | The "general-opens restrict–over bridge engine" — equivalence between modules on an open subscheme and sheaves on the over-site. Substantial new construction. No blueprint entry. |
| `presentationRestrictSliceOfOver` | 565 | Per-slice presentation for a restriction to an open subscheme. Drives `isQuasicoherent_pullback_opens`. No blueprint entry. |
| `presentationOverOpens` | 425 | Over-restriction of presentations. No blueprint entry. |
| `presentationRestrictOfOver` | 517 | Presentation of restriction from an over-presentation. No blueprint entry. |
| `overOpensInverseUnitIso` / `overOpensFunctorUnitIso` | 476 / 496 | Unit comparison isos for the bridge engine. No blueprint entry. |
| `pullbackObjUnitToUnit_isIso_of_isIso` / `restrictIsoUnitIso` | 534 / 545 | Presentation transport along scheme isomorphisms. No blueprint entry. |
| `isAffineOpen_coverInterOpen` | 296 | Proves intersections of affine cover elements of a separated scheme are affine. Used in proof but not blueprinted as its own lemma. |

### Infrastructure / helpers (acceptable)

| Declaration | Line | Notes |
|---|---|---|
| `injectiveResolutions_additive` (instance) | 64 | Project-local Mathlib supplement. Helper. |
| `rightDerived_additive` | 79 | Project-local Mathlib supplement. Helper. |
| `isZero_biproduct` | 88 | Project-local helper. |
| `isRightAcyclic_of_iso` | 96 | Project-local helper. |
| `isAffineHom_of_isAffine_of_isSeparated` | 153 | Parallel to `isAffineHom_of_affine_separated` in OpenImmersionPushforward.lean (noted in code). Helper. |
| `isAffineOpen_iInf_fin` (private) | 270 | Private induction helper. |
| `opens_ι_image_overEquivalence_functor` (private) | 322 | Private over-site helper. |
| `overEquivalence_functor_isContinuous_opens` (instance) | 329 | Port of over-site continuity instance. |
| `overEquivalence_inverse_isContinuous_opens` (instance) | 336 | Port of over-site continuity instance. |
| `overOpensForgetIso` / `overOpensForgetInvIso` | 344 / 362 | Structural components of the bridge. |
| `overOpensRingHom` / `overOpensRingInvHom` | 352 / 368 | Structure-sheaf comparisons for bridge. |
| `overOpensIsoRestrict` | 403 | Bridge object iso. |
| `pushforward_overOpensRingHom_isRightAdjoint` (instance) | 451 | Right-adjoint instance for bridge engine. |
| `pushforward_overOpensRingInvHom_isRightAdjoint` (instance) | 461 | Right-adjoint instance for bridge engine. |

---

## Blueprint adequacy for this file

### Coverage
2/30 Lean declarations have a corresponding `\lean{...}` block in the chapter.
- 2 blueprinted: `cechTerm_pushforward_acyclic`, `rightAcyclic_finite_prod`
- ~10 unreferenced but substantive (flagged above)
- ~18 helpers/infrastructure (acceptable)

### Proof-sketch depth
**under-specified** for `lem:cech_term_pushforward_acyclic`. The proof sketch's step 2 (per-factor acyclicity) asserts "the composite f∘j_s : U_s → S is an affine morphism" and cites `lem:open_immersion_pushforward_acyclic`, but:
- The actual Lean proof routes through a new theorem `higherDirectImage_affineHom_acyclic` (more general than `lem:open_immersion_pushforward_acyclic` which is only for open immersions).
- The proof also requires `isQuasicoherent_pullback_opens` (QCoh stability under restriction), which represents a large infrastructure block not mentioned anywhere in the blueprint sketch.
- The step "U_σ is affine" is asserted in the proof but the supporting lemma `isAffineOpen_coverInterOpen` (and its `isAffineOpen_iInf_fin` helper) is not blueprinted.

The blueprint proof prose (L11671-11706) is accurate as a mathematical sketch but omits enough detail that a prover needed to build substantial unlisted infrastructure.

### Hint precision
**loose** for `lem:cech_term_pushforward_acyclic`. The `\lean{...}` hint correctly names the target, but the `\uses{}` list references `lem:open_immersion_pushforward_acyclic` where the Lean actually uses the new generalization `higherDirectImage_affineHom_acyclic`. The cross-reference is misleading.

### Generality
**too narrow** — the blueprint's statement of `lem:cech_term_pushforward_acyclic` is strictly weaker than what the Lean proves (the blueprint omits necessary hypotheses that make the stated theorem false). This is the most critical adequacy failure.

### Recommended chapter-side actions

1. **[CRITICAL]** Update `lem:cech_term_pushforward_acyclic` statement (L11648-11657) to add:
   - `X` separated (`X.IsSeparated`)
   - `S` separated (`S.IsSeparated`)
   - `hres` hypothesis: `∀ σ, HasInjectiveResolutions (U_σ).Modules`
   - `HasInjectiveResolutions X.Modules`
   Include the counterexample (or a reference to the module docstring) explaining why `S`-separatedness is necessary.

2. **[MAJOR]** Add a blueprint lemma for `higherDirectImage_affineHom_acyclic` (generalization of relative Serre vanishing from affine open immersions to arbitrary affine morphisms from affine schemes). Update the `\uses{}` of `lem:cech_term_pushforward_acyclic` to reference it instead of `lem:open_immersion_pushforward_acyclic`.

3. **[MAJOR]** Add blueprint entries for `pushPullObj_opens_pushforward_acyclic` (the single-σ factor acyclicity step), `isQuasicoherent_pullback_opens`, and summarize the RestrictOverBridge infrastructure at least as a "project-local bridge" block pointing to the key result `modulesOverOpensEquivalence`.

4. **[MINOR]** Add `HasFiniteProducts 𝒜` and `[Abelian ℬ]` to the `lem:rightAcyclic_finite_prod` statement (or note they are implicit in the type-class search).

---

## Severity summary

- **must-fix-this-iter (1)**:
  - `cechTerm_pushforward_acyclic` blueprint statement is mathematically false as written — missing `[X.IsSeparated]`, `[S.IsSeparated]`, and `hres`. A concrete counterexample is documented in the Lean module docstring. The blueprint chapter must be updated before this block's `\leanok` can be relied on downstream.

- **major (4)**:
  - `higherDirectImage_affineHom_acyclic` (line 183): substantive theorem used by the main result, no blueprint entry.
  - `pushPullObj_opens_pushforward_acyclic` (line 654): key intermediate step, no blueprint entry.
  - `isQuasicoherent_pullback_opens` (line 623): substantial theorem + large infrastructure block (RestrictOverBridge), no blueprint entry.
  - `lem:cech_term_pushforward_acyclic` proof sketch: `\uses{}` points to `lem:open_immersion_pushforward_acyclic` but the Lean routes through a different, more general theorem; the cross-reference is misleading.

- **minor (2)**:
  - `rightAcyclic_finite_prod` signature: `[HasFiniteProducts 𝒜]` and `[Abelian ℬ]` implicit in blueprint but explicit in Lean.
  - `isAffineOpen_coverInterOpen` (line 296): geometric helper for "intersections are affine" used in proof, no blueprint entry.

**Overall verdict**: The Lean proof of `cechTerm_pushforward_acyclic` is correct and sorry-free, but the blueprint statement is provably false as written (missing separatedness hypotheses on X and S, and the `hres` caveat); the proof infrastructure (≈28 unlisted declarations including a key generalization of relative Serre vanishing and QCoh stability under restriction) is absent from the blueprint — 2 declarations checked, 1 must-fix + 4 major + 2 minor red flags.
