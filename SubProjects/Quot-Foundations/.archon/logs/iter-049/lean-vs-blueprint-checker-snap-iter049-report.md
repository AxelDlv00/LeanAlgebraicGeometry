# Lean ↔ Blueprint Check Report

## Slug
snap-iter049

## Iteration
049

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

### `\lean{PresheafOfModules.monoidalCategory}` (lem:presheafModule_monoidal_mathlib)
- **Lean target exists**: yes — Mathlib (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`)
- **Signature matches**: yes — `\mathlibok`, no Archon obligation
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`. No action required.

### `\lean{PresheafOfModules.sheafification}` (lem:presheafModule_sheafification_mathlib)
- **Lean target exists**: yes — Mathlib (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`)
- **Signature matches**: yes — `\mathlibok`, no Archon obligation
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`. No action required.

### `\lean{SheafOfModules.unit}` (lem:moduleUnit_mathlib)
- **Lean target exists**: yes — Mathlib (`Mathlib.AlgebraicGeometry.Modules.Sheaf`)
- **Signature matches**: yes — `\mathlibok`, no Archon obligation
- **Proof follows sketch**: N/A
- **notes**: Correctly tagged `\mathlibok`. The private `unitModule` abbrev in the Lean file wraps this Mathlib decl; it is correctly kept private (not `\lean{...}`-tagged in the blueprint).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:sheafTensorObj)
- **Lean target exists**: yes — line 79, `noncomputable def tensorObj (F G : X.Modules) : X.Modules`
- **Signature matches**: yes — sheafification of the objectwise presheaf tensor product, exactly as the blueprint states
- **Proof follows sketch**: N/A (definition, no proof body)
- **notes**: `\leanok` present in blueprint. Axiom-clean (implied by file structure; no sorry).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (def:sheafTensorPow)
- **Lean target exists**: yes — line 93, `noncomputable def tensorPow (L : X.Modules) : ℕ → X.Modules`
- **Signature matches**: yes — recursive definition: `tensorPow L 0 = unitModule X`, `tensorPow L (m+1) = tensorObj (tensorPow L m) L`, matching blueprint's `L^⊗0 = O_X`, `L^⊗(m+1) = L^⊗m ⊗ L`
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (def:sheafModuleTwist)
- **Lean target exists**: yes — line 105, `noncomputable def moduleTensorPow (F L : X.Modules) (m : ℕ) : X.Modules`
- **Signature matches**: yes — `tensorObj F (tensorPow L m)`, i.e. `F(m) = F ⊗ L^⊗m`
- **Proof follows sketch**: N/A
- **notes**: `\leanok` present. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (lem:sheafTensorPow_add)
- **Lean target exists**: no — declaration intentionally absent (not sorry-backed)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly carries NO `\leanok` on this block. The Lean file's handoff comment (lines 190–254) documents the two blocked routes (principled LocalizedMonoidal route; bespoke local-iso route) and confirms the absence is intentional. Consistent state. Blueprint adequacy concern raised below.

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (def:sectionMul) — **NEW THIS ITER**
- **Lean target exists**: yes — line 181, `noncomputable def sectionsMul (F G : X.Modules) : ...`
- **Signature matches**: yes — see detailed check below
- **Proof follows sketch**: yes — body is the sheafification unit applied to the tensor presheaf, evaluated at `op ⊤`; exactly the blueprint's "global-sections component of η" construction
- **notes**: `\leanok` present. `lean_verify` confirms axiom set `{propext, Classical.choice, Quot.sound}` — standard Lean 4 axioms, **no sorry, no project-specific axiom**. Fully clean.

**Detailed signature check for `sectionsMul`:**

LSP hover (line 181, col 23) returns:
```
AlgebraicGeometry.Scheme.Modules.sectionsMul.{u} {X : Scheme} (F G : X.Modules) :
  ((toPresheafOfModules X).obj F ⊗ (toPresheafOfModules X).obj G).obj (Opposite.op ⊤) ⟶
    (F.tensorObj G).val.obj (Opposite.op ⊤)
```

Blueprint `def:sectionMul` states:
> "the Γ(X,O_X)-bilinear map Γ(X,F) ⊗_{Γ(X,O_X)} Γ(X,G) → Γ(X, F⊗G)"

Mapping:
- Domain `((toPresheafOfModules X).obj F ⊗ (toPresheafOfModules X).obj G).obj (op ⊤)` = evaluation of the presheaf tensor product at the top open = `Γ(X,F) ⊗_{Γ(X,O_X)} Γ(X,G)` by the objectwise formula of `PresheafOfModules.monoidalCategory` ✓
- Codomain `(F.tensorObj G).val.obj (op ⊤)` = `Γ(X, F ⊗ G)` ✓
- The `⟶` is a morphism in `ModuleCat (Γ(X,O_X))`, encoding `Γ(X,O_X)`-linearity (= bilinearity of the underlying map from the tensor product) ✓
- Body = `(sheafificationAdjunction.unit.app (tensorPresheaf F G)).app (op ⊤)` = the sheafification unit η applied to the tensor presheaf, at the top open ✓

**Verdict on `sectionsMul`: perfect match.**

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit}` (lem:sectionMul_coherent)
- **Lean target exists**: no — not yet in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint carries no `\leanok`. Not in this iter's scope. Consistent.

### `\lean{AlgebraicGeometry.sectionGradedRing_gcommSemiring}` (lem:sectionGradedRing_gcommSemiring)
- **Lean target exists**: no — not yet in the Lean file
- **Signature matches**: N/A
- **notes**: No `\leanok`. Not in scope. Consistent.

### `\lean{AlgebraicGeometry.sectionGradedModule_gmodule}` (lem:sectionGradedModule_gmodule)
- **Lean target exists**: no — not yet in the Lean file
- **Signature matches**: N/A
- **notes**: No `\leanok`. Not in scope. Consistent.

### `\lean{DirectSum.GCommSemiring}` (lem:directSum_gcommSemiring_mathlib)
- **Lean target exists**: yes — Mathlib (`Mathlib.Algebra.DirectSum.Ring`)
- **Signature matches**: yes — `\mathlibok`
- **notes**: No Archon obligation.

### `\lean{DirectSum.Gmodule}` (lem:directSum_gmodule_mathlib)
- **Lean target exists**: yes — Mathlib (`Mathlib.Algebra.Module.GradedModule`)
- **Signature matches**: yes — `\mathlibok`
- **notes**: No Archon obligation.

---

## Red flags

None found.

### Placeholder / suspect bodies
(none)

### Excuse-comments
(none)

### Axioms / Classical.choice on non-trivial claims
(none — `lean_verify` on `sectionsMul` returns only `{propext, Classical.choice, Quot.sound}`, which are standard Lean 4 kernel axioms present in every development)

---

## Unreferenced declarations (informational)

The 10 private helpers are all `private` and correctly have no `\lean{...}` tags in the blueprint:

| Declaration | Type | Notes |
|---|---|---|
| `sheafification` | `private noncomputable def` | Internal wrapper for `PresheafOfModules.sheafification`; Mathlib decl is blueprint-tagged |
| `MonoidalPresheaf` | `private abbrev` | Type alias for synthesis; pure implementation detail |
| `unitModule` | `private noncomputable abbrev` | Wraps Mathlib `SheafOfModules.unit`, which IS blueprint-tagged via `\mathlibok` |
| `tensorPow_zero` | `private @[simp] lemma` | Computational unfolding lemma |
| `tensorPow_succ` | `private @[simp] lemma` | Computational unfolding lemma |
| `moduleTensorPow_zero` | `private @[simp] lemma` | Computational unfolding lemma |
| `sheafificationCounitIso` | `private noncomputable def` | Launching-pad helper for `tensorPowAdd` |
| `tensorObjUnitIso` | `private noncomputable def` | Launching-pad helper for `tensorPowAdd` |
| `tensorObjRightUnitor` | `private noncomputable def` | Launching-pad helper for `tensorPowAdd` |
| `tensorBraiding` | `private noncomputable def` | Launching-pad helper for `tensorPowAdd` |

All 10 are in-file helpers that support the deferred `tensorPowAdd`. Making them private is appropriate: they have no standalone mathematical identity that the blueprint needs to reference. When `tensorPowAdd` is formalized (same file, same namespace), they will be accessible.

The 4 public declarations (`tensorObj`, `tensorPow`, `moduleTensorPow`, `sectionsMul`) are all `\lean{...}`-tagged in the blueprint. Coverage is complete for the scope of this file.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 Lean declarations have a corresponding `\lean{...}` block in the blueprint. 10 private helpers are appropriately not `\lean{...}`-tagged. No substantive unreferenced public declarations.
- **Proof-sketch depth**: adequate for `def:sheafTensorObj`, `def:sheafTensorPow`, `def:sheafModuleTwist`, `def:sectionMul` (all formalized). Under-specified in one respect for `lem:sheafTensorPow_add` (see below).
- **Hint precision**: precise for all formalized blocks. The `\lean{...}` hints precisely name the target declarations.
- **Generality**: matches need.

### Blueprint adequacy issue: `lem:sheafTensorPow_add` proof sketch (minor)

The blueprint's `\begin{proof}` for `lem:sheafTensorPow_add` (lines 247–348) describes a **bespoke local-iso route** as a viable alternative to the principled LocalizedMonoidal route. Its final "Remark on the principled route" (lines 340–348) flags only the principled route as deferred, with a clear statement of its single missing brick (`MonoidalClosed (PresheafOfModules _)`).

The Lean handoff note (SectionGradedRing.lean lines 230–254, written this iter) documents that the **bespoke route is also blocked** on two additional Mathlib-absent primitives:
1. An `IsLocallyFreeOfRank` / invertibility predicate for `X.Modules`.
2. A "morphism of sheaves of modules is an iso iff locally an iso" criterion.
3. Typing friction forming `η_P ▷ Q` across the `MonoidalPresheaf` vs `X.ringCatSheaf.obj` ring-expression defeq gap.

A future prover reading only the blueprint would conclude the bespoke route is straightforward ("on trivialising opens, everything becomes trivial") and spend iterations on it. The blueprint should be updated to mirror what the Lean handoff note says: both routes are currently blocked, with their respective missing bricks enumerated.

**Recommended chapter-side action** (for blueprint-writing subagent):
- In the proof of `lem:sheafTensorPow_add`, add a `% NOTE:` after the "bespoke local-iso route" paragraph and the "Remark on the principled route" remark: both routes are blocked on Mathlib-absent infrastructure; see the in-file handoff note in `SectionGradedRing.lean` for the exact missing bricks. The declaration stays absent until one route's missing bricks are supplied.

---

## Severity summary

| Finding | Severity |
|---|---|
| `sectionsMul` axiom-clean, signature matches blueprint exactly | CLEAN (positive) |
| 10 private helpers invisible to blueprint as intended | CLEAN |
| `tensorPowAdd` absent without sorry; blueprint `\leanok`-free | CLEAN |
| Blueprint proof sketch for `lem:sheafTensorPow_add` implies bespoke route is feasible when it is also blocked | **minor** |
| Inconsistent namespace hints: `sectionsMul_assoc_unit` uses `Scheme.Modules.` prefix; `sectionGradedRing_gcommSemiring` / `sectionGradedModule_gmodule` use bare `AlgebraicGeometry.` (relevant only when those are formalized) | **minor** |

**must-fix-this-iter**: 0
**major**: 0
**minor**: 2 (blueprint prose gaps; no action blocks current iter work)

**Overall verdict**: The Lean file is fully faithful to the blueprint for all formalized declarations; `sectionsMul` is axiom-clean and its signature matches `def:sectionMul` exactly. No blocking issues.
