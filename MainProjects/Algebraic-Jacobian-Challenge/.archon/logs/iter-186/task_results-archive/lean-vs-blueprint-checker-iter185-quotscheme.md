# Lean ↔ Blueprint Check Report

## Slug
iter185-quotscheme

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes — L170
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsLocallyNoetherian S] (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _F : X.Modules) (_s : S) : Polynomial ℚ` matches blueprint's "function s ↦ Φ_{F,s} ∈ ℚ[λ]" over a noetherian S with finite-type π.
- **Proof follows sketch**: N/A (definition; body is `sorry`)
- **notes**: Blueprint has `\begin{definition}\leanok` — sorry body is consistent with the statement-level `\leanok` marker (declaration present, proof pending). Blueprint docstring explicitly labels this "iter-177+ file-skeleton."

---

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes — L208
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsLocallyNoetherian S] (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _E : X.Modules) (_Φ : Polynomial ℚ) : (Over S)ᵒᵖ ⥤ Type u` matches blueprint's contravariant functor `(Sch/S)^op → Set`.
- **Proof follows sketch**: N/A (definition; body is `sorry`)
- **notes**: Blueprint has `\begin{definition}\leanok`. Sorry body consistent with file-skeleton status.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes — L245
- **Signature matches**: yes — `(_V : S.Modules) (_d : ℕ) : (Over S)ᵒᵖ ⥤ Type u` matches blueprint's functor of rank-d quotients of V.
- **Proof follows sketch**: N/A (definition; body is `sorry`)
- **notes**: Blueprint has `\begin{definition}\leanok`. Sorry consistent with file-skeleton status.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes — L272
- **Signature matches**: partial — Lean states `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, which omits the smooth / projective / Plücker structure that the blueprint's theorem prose describes. Blueprint's Lean-encoding §Phase 2 explicitly authorizes this weakening: "the additional projective / smooth / Plücker structure is implicit in the construction and is iter-177+ refinement work (once the proof body lands)." **Blueprint-authorized weakness.**
- **Proof follows sketch**: partial — body is `sorry`; the blueprint's `\begin{proof}` gives a detailed 5-step sketch (affine charts, cocycle, properness via DVR, Plücker embedding, representability check). None of those steps are in the Lean body yet.
- **notes**: Blueprint has `\begin{theorem}\leanok` (statement), proof block lacks `\leanok` (proof not claimed closed). All consistent.

---

### `\lean{AlgebraicGeometry.Scheme.QuotScheme}` (chapter: `thm:quot_representable`)
- **Lean target exists**: yes — L326
- **Signature matches**: partial — uses `[IsProper π]` in place of `[IsProjective π]` (no `IsProjective` morphism property in Mathlib at the pinned commit) and the conclusion is `∃ (Q : Over S), Nonempty (...)` without encoding "projective S-scheme." Both weakenings are explicitly blueprint-authorized (Lean encoding §Phase 3 docstring: "the projectivity upgrades once `IsProjective` lands in Mathlib").
- **Proof follows sketch**: partial — body is `sorry`; blueprint's `\begin{proof}` sketches all 4 steps (boundedness → Grassmannian embedding → flattening stratification → valuative criterion). None are in the Lean body yet.
- **notes**: Blueprint has `\begin{theorem}\leanok` (statement), proof block lacks `\leanok`. All consistent.

---

### `\lean{AlgebraicGeometry.flatBaseChangeCohomology}` (chapter: `thm:flat_base_change_cohomology`)
- **Lean target exists**: yes — L771
- **Signature matches**: partial — Lean states the `i = 0` form only (`Nonempty (pullback g (pushforward f F) ≅ pushforward f' (pullback g' F))`); blueprint's full statement covers `g* R^i f_* F → R^i f'_* F'` for all `i ≥ 0`. Blueprint section (§Cohomology and base change) explicitly authorizes the `i = 0` restriction: "the `i = 0` form encoded here is the substantive content of `lemma-flat-base-change-cohomology(ii)` of Stacks 02KH, with the `i ≥ 1` form post-iter-177 work."
- **Proof follows sketch**: partial — body is sorry-free at the surface level (composes `canonicalBaseChangeMap_isIso` and wraps via `asIso`), but relies on sorry-carrying private helpers (`canonicalBaseChangeMap_app_app_isIso_of_affineCover`, `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen`, `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`). The mathematical content of Stacks 02KH is properly encapsulated in named typed-sorry helpers with clear description of the remaining Mathlib gap.
- **notes**: Blueprint has `\begin{theorem}\leanok` (statement); no proof-block `\leanok` claimed. Hover confirms signature. No compiler errors in file (LSP returned empty error list).

---

## Red flags

### Placeholder / suspect bodies

The following carry `sorry` or `exact sorry` bodies. All are **private** helpers or file-skeleton declarations with blueprint-authorized sorry status:

| Declaration | Line | Nature | Status |
|---|---|---|---|
| `hilbertPolynomial` | 173 | `:= sorry` | Blueprint `\leanok` at statement level — authorized |
| `QuotFunctor` | 212 | `:= sorry` | Blueprint `\leanok` at statement level — authorized |
| `Grassmannian` | 248 | `:= sorry` | Blueprint `\leanok` at statement level — authorized |
| `Grassmannian.representable` | 275 | `sorry` | Blueprint `\leanok` at statement; proof-block not `\leanok` — authorized |
| `QuotScheme` | 330 | `sorry` | Blueprint `\leanok` at statement; proof-block not `\leanok` — authorized |
| `pullback_app_isoTensor_isBaseChange` | 537 | `exact sorry` | **Private**; named typed-sorry per iter-185 known issue; mathematical content documented in 4-step comment |
| `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase` | 620 | `sorry` | **Private**; documented "Beck-Chevalley compatibility" gap, iter-184+ work |
| `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` | 670 | `sorry` | **Private**; documented "base-side Mayer-Vietoris" gap, iter-182+ work |
| `canonicalBaseChangeMap_app_app_isIso_of_affineCover` | 720 | `sorry` | **Private**; documented "Sheaf.Hom.isIso_iff_isIso_on_basis" gap |

Total: 9 sorries — consistent with directive's "9 sorries entering, 9 exiting (net 0)." No unnamed body sorries on public blueprint-pinned declarations.

### Excuse-comments
None found. All inline `-- TODO` / `-- iter-NNN+` comments describe mathematical work remaining (Tilde-isoTop route, Mayer-Vietoris, etc.) rather than excusing wrong code. The step-by-step comment block in `pullback_app_isoTensor_isBaseChange` (L510–536) is a proof plan, not an excuse.

### Axioms / `Classical.choice` on substantive claims
No `axiom` declarations in this file. No suspicious `Classical.choice _` patterns on non-trivial claims. The `pullback_app_isoTensor_unitAtV` private helper is confirmed axiom-clean (uses only the adjunction unit via `hom`).

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file without a formal `\lean{...}` pin in the blueprint chapter:

| Declaration | Visibility | Substantive? | Flag |
|---|---|---|---|
| `canonicalBaseChangeMap` | public | yes — the Beck-Chevalley NT, no-sorry body | **should be pinned** |
| `canonicalBaseChangeMap_app_app_isIso` | public | yes — Stacks 02KH(ii) section-wise result, no-sorry body | should be pinned |
| `canonicalBaseChangeMap_isIso` | public | yes — the full IsIso claim consumed by `flatBaseChangeCohomology`, no-sorry body | should be pinned |
| `Scheme.Modules.pullback_app_isoTensor` | public | yes — affine-open tensor-product iso, sorry-bearing | **should be pinned** (see major finding below) |
| `pushforward_pullback_section_eq_pullback_section` | private | trivial (`rfl`) | acceptable as unpinned |
| `pullback_app_isoTensor_unitAtV` | private | yes — axiom-clean adjunction unit step | acceptable as unpinned (iter-185 known issue) |
| `pullback_app_isoTensor_isBaseChange` | private | yes — substantive typed-sorry | acceptable as unpinned (iter-185 known issue) |
| `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase` | private | yes — affine-base case | acceptable as unpinned |
| `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` | private | yes — affine-open case | acceptable as unpinned |
| `canonicalBaseChangeMap_app_app_isIso_of_affineCover` | private | yes — Mayer-Vietoris descent | acceptable as unpinned |

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 blueprint-pinned (`\lean{...}`) declarations are present in the Lean file with matching signatures (modulo documented authorized weakenings). Additionally, 4 substantive public declarations in the Lean file have no blueprint `\lean{...}` pin.
- **Proof-sketch depth**: adequate for the file-skeleton stage. The blueprint's `\begin{proof}` blocks for `thm:grassmannian_representable` and `thm:quot_representable` give detailed multi-step sketches. `thm:flat_base_change_cohomology` has no standalone proof block in the chapter, but the Lean encoding section describes the proof route (mate equivalence, affine reduction, Mayer-Vietoris) in §"Cohomology and base change" prose — sufficient for a prover.
- **Hint precision**: precise for 6 pinned declarations.
- **Generality**: matches need for the current iter-176+ file-skeleton stage. The weaker Lean types (`IsProper` for projective, existential for representing object) are explicitly flagged as interim.

### Major finding — `Scheme.Modules.pullback_app_isoTensor` is not blueprint-pinned

The directive states: "§5 'Project-side typed-sorry' subsection (L851-856) already pins `Scheme.Modules.pullback_app_isoTensor`." Inspecting the actual blueprint text, **this is not the case.** The "Lean encoding" section's "Cohomology and base change" paragraph (around L845-851) mentions only `\texttt{AlgebraicGeometry.flat\_base\_change}` (a different Mathlib lemma) and does not contain a `\lean{Scheme.Modules.pullback_app_isoTensor}` pin. No such pin exists anywhere in the 904-line blueprint chapter.

`Scheme.Modules.pullback_app_isoTensor` is a load-bearing public declaration:
- it is called by `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase` (L607–608)
- it carries the entire algebraic Stacks 02KE / 01HQ tensor-product section formula
- it is the only non-private declaration in the Lane F sorry chain

A `\lean{...}` pin should be added to the blueprint chapter (under §Lean encoding or a new §"Project-side helpers" subsection), and a corresponding theorem block (with `\leanok` at the statement level, no proof-block `\leanok`) should describe the mathematical content.

Similarly, `canonicalBaseChangeMap`, `canonicalBaseChangeMap_app_app_isIso`, and `canonicalBaseChangeMap_isIso` are public sorry-free declarations that form the proof chain for `flatBaseChangeCohomology` and deserve `\lean{...}` pins for blueprint ↔ Lean maintainability (major, not must-fix).

### Recommended chapter-side actions
1. **Must address (major)**: Add a `\lean{AlgebraicGeometry.Scheme.Modules.pullback_app_isoTensor}` pin in the blueprint. The directive's belief that this pin already exists is incorrect per the current file.
2. **Should address (major)**: Add `\lean{...}` pins for `canonicalBaseChangeMap`, `canonicalBaseChangeMap_app_app_isIso`, and `canonicalBaseChangeMap_isIso`.
3. **Minor**: Consider a brief "Project-side helper declarations" subsection in §Lean encoding documenting the roles of these four unpinned public declarations; this would make the blueprint's coverage complete.

---

## Severity summary

- **must-fix-this-iter**: None. All sorry bodies are blueprint-authorized (either by `\leanok` at statement level, file-skeleton designation, or iter-NNN+ deferral). No excuse-comments. No axioms on substantive claims.
- **major** (2):
  - `Scheme.Modules.pullback_app_isoTensor` lacks a `\lean{...}` blueprint pin, contrary to the directive's assumption. This is a blueprint adequacy gap — the plan agent should dispatch the blueprint-writer subagent to add the pin.
  - `canonicalBaseChangeMap`, `canonicalBaseChangeMap_app_app_isIso`, `canonicalBaseChangeMap_isIso` (3 public declarations) are unpinned load-bearing intermediates. Combined into one finding.
- **minor** (1):
  - `Grassmannian.representable` and `QuotScheme` signatures are weaker than the blueprint's formal theorem statements (missing smooth/projective/Plücker structure). This is fully documented and blueprint-authorized; recorded only for awareness of the gap between the blueprint's ambition and the current Lean encoding.

**Overall verdict**: The file is a well-structured file skeleton that faithfully follows the blueprint for all 6 pinned declarations, with properly encapsulated typed-sorry helpers and no surprise weaknesses; the only actionable finding is the blueprint's missing `\lean{...}` pin for `Scheme.Modules.pullback_app_isoTensor` (the directive incorrectly claims this pin already exists) and three other unpinned public declarations in the proof chain.
