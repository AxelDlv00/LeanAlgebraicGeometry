# Lean ↔ Blueprint Check Report

## Slug
flatbasechange-ts236

## Iteration
236

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (line 76, `noncomputable def`)
- **Signature matches**: yes — maps `pullback g (pushforward f F) ⟶ pushforward f' (pullback g' F)`, adjoint mate of the pushforward-unit composite; matches prose exactly
- **Proof follows sketch**: yes — the body implements the exact adjunction-transpose construction described in the chapter
- **Blueprint `\leanok` status**: statement `\leanok` present, no proof `\leanok` (definition, not a theorem); correct

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 99)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso (stalkFunctor Ab x (toPresheaf X . map φ))`, matches the biconditional in the chapter
- **Proof follows sketch**: yes — forward direction uses functor-map-isIso; backward direction packages as `TopCat.Sheaf` Ab-morphism, applies stalkwise iso criterion, then reflects; matches prose exactly
- **Blueprint `\leanok` status**: statement and proof both `\leanok`; correct (no sorry in the Lean body)

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 125)
- **Signature matches**: yes — takes a `IsBasis (Set.range B)` proof, a morphism φ, and hypothesis `∀ i, IsIso (φ.app (B i))`, concludes `IsIso φ`; matches prose
- **Proof follows sketch**: yes — reduces to stalkwise bijectivity via `lem:modules_isIso_iff_stalk`, then injectivity from `stalkFunctor_map_injective_of_isBasis`, surjectivity from `germ_exist_of_isBasis`; matches the two-part basis-local argument
- **Blueprint `\leanok` status**: statement and proof both `\leanok`; correct

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`; matches prose
- **Proof follows sketch**: yes — forward via `inferInstance`, backward via `isIso_of_isIso_app_of_isBasis` with `isBasis_affineOpens`; matches the chapter's argument
- **Blueprint `\leanok` status**: statement and proof both `\leanok`; correct

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: no — the declaration `pushforward_spec_tilde_iso` does **not** appear in the Lean file; references in the file (lines 232, 258) are prose/comments naming the future target, not a definition
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **Blueprint `\leanok` status**: NO `\leanok` on statement or proof; correct — the lemma is genuinely unformalized
- **notes**: The chapter correctly signals this is open. See "Blueprint adequacy" section for issues with the proof sketch's QC dependency ordering.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (line 324)
- **Signature matches**: yes — `(h : IsPullback g' f' f g) [IsAffineHom f] (F : X.Modules) [F.IsQuasicoherent] : IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`; matches the chapter's statement (cartesian square, affine f, QC sheaf, conclusion iso)
- **Proof follows sketch**: partial — the first reduction `rw [Modules.isIso_iff_isIso_app_affineOpens]` lands and introduces the affine-open goal exactly as the chapter describes; the proof is then `sorry` with a comment describing the remaining affine computation. The sorry is documented and the chapter proof block has no `\leanok`.
- **Blueprint `\leanok` status**: statement `\leanok` present (correct per policy: declaration exists with sorry body), no proof `\leanok` (correct: proof is open)

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (line 357)
- **Signature matches**: yes — `(h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) [F.IsQuasicoherent] : IsIso (pushforwardBaseChangeMap f g f' g' h.w F)`; matches the chapter's theorem statement (flat g, qcqs f, QC sheaf, iso conclusion)
- **Proof follows sketch**: partial — body is `sorry` with a detailed comment explaining the Čech-complex strategy (affine reduction → Čech of 𝒰_B ≅ Čech of 𝒰 ⊗ B → flatness → H⁰ iso); the comment matches the chapter's proof sketch exactly. The sorry is documented.
- **Blueprint `\leanok` status**: statement `\leanok` present (correct), no proof `\leanok` (correct)

---

## Red flags

### Placeholder / suspect bodies
- `affineBaseChange_pushforward_iso` (line 348): body is `:= sorry` after `rw [Modules.isIso_iff_isIso_app_affineOpens]; intro U`. Blueprint correctly marks the proof open (no proof `\leanok`). The sorry is authorized by the chapter as a deliberate deferral pending `pushforward_spec_tilde_iso`. **Not a must-fix: the chapter is consistent.**
- `flatBaseChange_pushforward_isIso` (line 370): body is `:= sorry` with a multi-line comment sketching the Čech strategy. Blueprint correctly marks the proof open. **Not a must-fix: consistent.**

### Excuse-comments
None of the comments in the Lean file excuse wrong code. The sorry comments accurately describe the missing Mathlib ingredient (`pushforward_spec_tilde_iso` / Čech infrastructure) and do not claim the current code is "wrong" or "temporary." The detailed inline /-! ... -/ blocks are engineering documentation, not excuse-comments.

### Axioms / Classical.choice on non-trivial claims
None — the three new axiom-clean declarations (`globalSectionsIso_hom_comp_specMap_appTop`, `gammaPushforwardIso`, `gammaPushforwardTildeIso`) use no `axiom` or `Classical.choice` on substantive claims.

---

## Unreferenced declarations (informational)

The following three declarations exist in the Lean file but have **no `\lean{...}` reference in the blueprint chapter**:

| Declaration | Line | Assessment |
|---|---|---|
| `globalSectionsIso_hom_comp_specMap_appTop` | 265 | **Substantive** — the ring-level naturality theorem (`gsR.hom ≫ (Spec.map φ).appTop = φ ≫ gsR'.hom`); explicitly the ring equation underlying the whole affine pushforward identification; primary output of iter-236 |
| `gammaPushforwardIso` | 285 | **Substantive** — the Γ-fragment iso `Γ((Spec φ)_* N) ≅ restrictScalars φ (Γ N)`; the general version of the affine pushforward global-sections comparison; primary iter-236 output |
| `gammaPushforwardTildeIso` | 310 | **Substantive** — tilde specialisation of `gammaPushforwardIso`; `Γ((Spec φ)_*(M~)) ≅ restrictScalars φ M`; the specific Γ-fragment needed for `affineBaseChange_pushforward_iso`; primary iter-236 output |

All three are axiom-clean and non-trivial. None is a private helper — they are named, `noncomputable def`/`theorem` declarations at the `AlgebraicGeometry` namespace level. The blueprint chapter mentions the concepts inline in the `% NOTE:` comment inside `lem:affine_base_change_pushforward`'s proof block and extensively in the Lean file's own /-! ... -/ docstring sections, but carries no formal `\lean{...}` statement blocks for any of them.

**This is a major Lean→blueprint gap.** A future prover or reviewer cannot locate the current formalization of the Γ-fragment from the blueprint. The blueprint-writing subagent should add three new lemma/definition blocks.

---

## Blueprint adequacy for this file

### Coverage
- `\lean{...}` blocks in the chapter: 7 (one def, five lemmas, one theorem)
- Lean declarations with `\lean{...}` pins: 6 (all except `pushforward_spec_tilde_iso`, which is deliberately absent)
- Unreferenced declarations: 3 substantive (flagged above), 0 helpers
- **6/9 Lean declarations are pinned; 3 substantive declarations (iter-236 primary outputs) are unreferenced.**

### Proof-sketch depth
**Under-specified** for `lem:pushforward_spec_tilde_iso`.

The proof sketch has four movements (sections agree on top; comparison ring map is φ; assemble via tilde full-faithfulness; scalar compatibility). The sketch reads as if it closes the proof, but there is a **circular dependency** in movement 3:

> The chapter's remark says: "QC of the pushforward. The tilde of any module is quasi-coherent, and quasi-coherence of Spec(R)-modules is closed under isomorphism; hence (Spec φ)_*(M~) is quasi-coherent. In particular no separate 'pushforward preserves quasi-coherent' theorem is needed."

This argument uses the object isomorphism `(Spec φ)_*(M~) ≅ (restr_φ M)~` (already established in movement 3) to conclude QC of the pushforward by closure under iso. But the Lean formalization reveals the actual dependency order is **inverted**: the object iso is built via `fromTildeΓ (pushforward (M~)) : tilde(Γ(pushforward(M~))) ⟶ pushforward(M~)`, and this map is an iso **if and only if** `pushforward(M~)` is already quasi-coherent. QC of the pushforward is therefore a **prerequisite** for movement 3, not a corollary of it.

The Lean inline comment (lines 236–243) explicitly identifies quasi-coherence of the pushforward as the "sole remaining obligation" and lists three non-trivial alternative routes (SheafOfModules.Presentation; `IsQuasicoherent.of_coversTop` on basic opens; direct `isIso_of_isIso_app_of_isBasis` via `IsLocalizedModule`). The blueprint's remark contains a circular argument that would confuse a future prover trying to implement movement 3.

**Recommended fix**: The remark should be rewritten to flag QC of the pushforward as a prerequisite (the hard part), and the proof sketch should describe one of the non-circular routes (e.g., the `IsLocalizedModule` on basic opens strategy).

### Hint precision
**Precise** for all pinned declarations. The `\lean{...}` hints name the exact Lean declaration names; all signatures match what the prose says.

### Generality
**Matches need** — `gammaPushforwardIso` is stated for general `N : (Spec R').Modules` (not just tilde-modules), which is the right level; `gammaPushforwardTildeIso` then specialises. If/when these get blueprint blocks, the general form should be the primary one.

### Recommended chapter-side actions (for blueprint-writing subagent)
1. **Add a `\begin{lemma} ... \end{lemma}` block for `globalSectionsIso_hom_comp_specMap_appTop`** between the "locality of isomorphisms" subsection and the "affine computation" subsection. Lean hint: `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}`. Informal statement: the ring square `gsR.hom ≫ (Spec φ).appTop = φ ≫ gsR'.hom` commutes, where `gsR = StructureSheaf.globalSectionsIso R`.
2. **Add a `\begin{definition} ... \end{definition}` (or lemma) block for `gammaPushforwardIso`** immediately before `lem:pushforward_spec_tilde_iso`. Lean hint: `\lean{AlgebraicGeometry.gammaPushforwardIso}`. Informal statement: for any `N : (Spec R').Modules`, the `R`-module `Γ((Spec φ)_* N)` is canonically isomorphic to `restrictScalars φ (Γ N)` as `R`-modules. Proof sketch: both sides peel by `rfl` to nested `restrictScalars` towers; reconcile via `restrictScalarsComp'App` × 2 and the ring equation from the above lemma.
3. **Add a `\begin{definition} ... \end{definition}` (or lemma) block for `gammaPushforwardTildeIso`** as a corollary of `gammaPushforwardIso`. Lean hint: `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}`. Informal statement: for the tilde specialisation `N = M~`, compose `gammaPushforwardIso` with the unit iso `Γ(M~) ≅ M` to get `Γ((Spec φ)_*(M~)) ≅ restrictScalars φ M`.
4. **Fix the circular dependency in the remark after `lem:pushforward_spec_tilde_iso`**: replace "QC is closed under iso; hence the pushforward is QC" with a statement that QC of the pushforward must be established FIRST by an independent route (Presentation, IsLocalizedModule, or basic-open locality), and that closure-under-iso only applies thereafter.

---

## Severity summary

- **must-fix-this-iter**: none — no wrong `\leanok` markers, no sorry-bodies on claims the chapter marks as proved, no signature mismatches on pinned declarations, no axioms on substantive claims, no excuse-comments.
- **major (Lean → blueprint)**: 3 substantive declarations (`globalSectionsIso_hom_comp_specMap_appTop`, `gammaPushforwardIso`, `gammaPushforwardTildeIso`) have no `\lean{...}` blueprint pins despite being the primary formalization output of this iteration.
- **major (blueprint → Lean)**: the proof sketch for `lem:pushforward_spec_tilde_iso` contains a circular QC dependency (QC of the pushforward presented as a corollary of the object iso, when it is actually a prerequisite), which would mislead a future prover attempting to implement movement 3.
- **minor**: the `% NOTE:` comment inside `lem:affine_base_change_pushforward`'s proof block (blueprint lines ~326–331) references `globalSectionsIso_hom_comp_specMap_appTop` and `gammaPushforwardTildeIso` by name without a `\uses{}` dependency link to their (yet-to-be-added) statement blocks.

**Overall verdict**: The `\leanok` markers and sorry-vs-open classification are fully accurate across the chapter; two major gaps require blueprint-writing work before this chapter can guide future formalization of `pushforward_spec_tilde_iso` and `affineBaseChange_pushforward_iso` without confusion — the three unpinned iter-236 declarations and the circular QC dependency in the `pushforward_spec_tilde_iso` proof sketch.
