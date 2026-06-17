# Lean ↔ Blueprint Check Report

## Slug
sectiongradedring-iter047

## Iteration
047

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

The blueprint has four project-level `\lean{...}` references in this chapter (Mathlib-backed lemmas `\mathlibok` are excluded from per-declaration checks):

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:sheafTensorObj`, `\leanok` set)
- **Lean target exists**: yes — line 79
- **Signature matches**: yes — `(F G : X.Modules) : X.Modules`, exactly as the blueprint describes F ⊗ G for two sheaves of O_X-modules
- **Proof follows sketch**: yes — body is `sheafification.obj (MonoidalCategory.tensorObj ...)`, i.e. sheafification of the presheaf-level monoidal product of the underlying presheaves; this is exactly the Stacks Tag 01CA construction described in the definition
- **Notes**: no sorry, no placeholder; `\leanok` is correctly set

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (chapter: `def:sheafTensorPow`, `\leanok` set)
- **Lean target exists**: yes — line 93
- **Signature matches**: yes — `(L : X.Modules) : ℕ → X.Modules`, matching the blueprint's recursive definition for non-negative powers only
- **Proof follows sketch**: yes — pattern match: `0 ↦ unitModule X`, `m+1 ↦ tensorObj (tensorPow L m) L`; matches the blueprint's `L^{⊗0} = O_X`, `L^{⊗(m+1)} = L^{⊗m} ⊗ L` recursion exactly
- **Notes**: no sorry, no placeholder; `\leanok` is correctly set

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (chapter: `def:sheafModuleTwist`, `\leanok` set)
- **Lean target exists**: yes — line 105
- **Signature matches**: yes — `(F L : X.Modules) (m : ℕ) : X.Modules`, matching `F(m) = F ⊗ L^{⊗m}`
- **Proof follows sketch**: yes — body is `tensorObj F (tensorPow L m)`, agreeing with the definition
- **Notes**: no sorry, no placeholder; `\leanok` is correctly set

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (chapter: `lem:sheafTensorPow_add`, no `\leanok`)
- **Lean target exists**: no — declaration is intentionally absent; a block comment at lines 163–201 explains the deferral and identifies the single missing ingredient (strong-monoidality of the module sheafification functor / sheaf-level associator)
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A
- **Notes**: Blueprint correctly lacks `\leanok`. The absence is the intended approach: the file header and handoff note document this explicitly as deferred rather than sorry'd. The blueprint proof sketch at `lem:sheafTensorPow_add` is accurate (induction on m, base case = left unitor, step = associator + braiding + inductive hypothesis), and the Lean handoff note matches it — confirming the gap is correctly characterised. **No finding.**

---

### Blueprint sections 2–3 declarations (absent from this Lean file)

The blueprint's `sec:sgr_lax_sections` and `sec:sgr_graded_assembly` carry four more `\lean{...}` references:

| Blueprint label | `\lean{...}` target | `\leanok`? | In Lean file? |
|---|---|---|---|
| `def:sectionMul` | `Scheme.Modules.sectionsMul` | no | no |
| `lem:sectionMul_coherent` | `Scheme.Modules.sectionsMul_assoc_unit` | no | no |
| `lem:sectionGradedRing_gcommSemiring` | `AlgebraicGeometry.sectionGradedRing_gcommSemiring` | no | no |
| `lem:sectionGradedModule_gmodule` | `AlgebraicGeometry.sectionGradedModule_gmodule` | no | no |

All four are correctly marked as unformalized (no `\leanok`) in the blueprint. The Lean file header explicitly states it covers only "Layer 1 (`sec:sgr_tensor_powers`)" and defers Layers 2–3. **No finding.**

---

## Red flags

*(None.)*

No `:= sorry` bodies appear anywhere in the file. No `axiom` declarations. No excuse-comments (`-- TODO replace`, `-- temporary`, `-- placeholder`, `-- wrong but`). The handoff comment block is a design note documenting what remains to be built and why — it is not an excuse for wrong code; there is no wrong code.

---

## Unreferenced declarations (informational)

Ten declarations in the Lean file have no corresponding `\lean{...}` block in the blueprint. The directive identifies these as "coverage debt":

| Declaration | Kind | Nature |
|---|---|---|
| `sheafification` | `def` | Scheme-level sheafification functor; infrastructure helper wrapping `PresheafOfModules.sheafification` |
| `MonoidalPresheaf` | `abbrev` | Presentation alias needed to synthesise the `PresheafOfModules.monoidalCategory` instance |
| `unitModule` | `abbrev` | Alias for Mathlib's `SheafOfModules.unit`; `lem:moduleUnit_mathlib` (`\mathlibok`) covers the concept but not this abbrev |
| `tensorPow_zero` | `@[simp] lemma` | Definitional unfolding helper |
| `tensorPow_succ` | `@[simp] lemma` | Definitional unfolding helper |
| `moduleTensorPow_zero` | `@[simp] lemma` | Definitional unfolding helper |
| `sheafificationCounitIso` | `def` | Counit iso; launching pad for `tensorPowAdd` base case |
| `tensorObjUnitIso` | `def` | Left-unitor iso; launching pad for `tensorPowAdd` base case |
| `tensorObjRightUnitor` | `def` | Right-unitor iso; launching pad |
| `tensorBraiding` | `def` | Braiding iso; launching pad for `tensorPowAdd` inductive step |

None of these are substantive claims that a reader of the blueprint would expect to find explicitly referenced. They are internal infrastructure and launching-pad preparations for the deferred `tensorPowAdd`. Coverage debt noted, severity **minor**.

---

## Blueprint adequacy for this file

- **Coverage**: 3/3 formalized declarations have a `\lean{...}` block with `\leanok`. 10 helpers are unreferenced (all acceptable — see above). The 4 Sections-2/3 declarations are in blueprint but correctly unformalized.
- **Proof-sketch depth**: **adequate** for Layer 1. The three definition blocks (`def:sheafTensorObj`, `def:sheafTensorPow`, `def:sheafModuleTwist`) provide enough prose to guide correct formalization. The `lem:sheafTensorPow_add` proof sketch is accurate (induction, base case = left unitor, step = associator + braiding); the Lean handoff note mirrors it precisely.
- **Hint precision**: **precise**. Each `\lean{...}` tag names the exact fully-qualified declaration.
- **Generality**: **matches need** for the current scope (Layer 1 only). The file restricts to ℕ-indexed powers, which is all the section graded ring needs; the blueprint notes this restriction explicitly.
- **Recommended chapter-side actions**:
  - (Optional, minor) Add a brief unnumbered remark or `\textit{Auxiliary definitions}` block listing `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding` with their roles as launching-pad definitions for `tensorPowAdd`. This would convert 4 of the 10 "coverage debt" helpers into referenced, blueprint-visible infrastructure. Not blocking.
  - (Optional, minor) `sheafification` and `MonoidalPresheaf` could similarly be noted as local wrappers in a remark. Not blocking.
  - No action needed for the three simp-lemma helpers (`tensorPow_zero/succ`, `moduleTensorPow_zero`).

---

## Severity summary

| Finding | Severity |
|---|---|
| 10 helpers with no `\lean{...}` blueprint block | minor |
| 4 Layers-2/3 declarations absent from Lean file (correctly not \leanok in blueprint) | no finding |
| `tensorPowAdd` absent (intentionally deferred, correctly no \leanok) | no finding |

**Overall verdict**: PASS — all 3 blueprint-formalized declarations match in existence, signature, and mathematical content; zero red flags; the blueprint chapter is adequate to have guided this Layer 1 formalization.
