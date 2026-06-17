# Lean ↔ Blueprint Check Report

## Slug
presheafcech

## Iteration
015

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/PresheafCech.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CeckHigherDirectImage.tex`
  (restricted audit: `def:cech_free_presheaf_complex`, `def:section_cech_complex`,
  `lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`,
  `lem:injective_cech_acyclic`, and the two Mathlib-ok helpers
  `lem:injective_of_adjoint` / `lem:mod_pmod_adjunction`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.injective_cech_acyclic}` (chapter: `lem:injective_cech_acyclic`)
- **Lean target exists**: no — the final `injective_cech_acyclic` declaration is not yet present.
  Part 1 of its proof has been extracted as the standalone helper
  `injective_toPresheafOfModules` (line 215). This is an intentional staged build
  (noted in directive as known/expected). The five-step plan in the in-file strategy
  comment (lines 34–195) makes the staging explicit.
- **Signature matches**: N/A (target not yet built; helper covers exactly Part 1 of the
  blueprint proof).
- **Proof follows sketch**: N/A for the target; see `injective_toPresheafOfModules` below.
- **Notes**: Missing `\lean{AlgebraicGeometry.injective_cech_acyclic}` in the file is
  expected this iteration. Blueprint proof sketch is clear and complete enough to
  guide the remaining work (Parts 2).

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: no — the full complex iso is not yet present.
  The per-term `Equiv` core `freeYonedaHomEquiv` (line 244) has been built as a
  deliberate partial step; the full additive/natural iso is not yet attempted.
- **Signature matches**: N/A (target not yet built; helper covers the single-multi-index
  bijection that the blueprint's proof describes as its first step).
- **Proof follows sketch**: N/A for the target; see `freeYonedaHomEquiv` below.
- **Notes**: Blueprint proof sketch is adequate to guide the remaining work (product
  over multi-indices, differential check, complex iso assembly).

### `\lean{AlgebraicGeometry.cechFreePresheafComplex}` (chapter: `def:cech_free_presheaf_complex`)
- **Lean target exists**: no — not yet built. Expected per directive.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.sectionCechComplex}` (chapter: `def:section_cech_complex`)
- **Lean target exists**: no — not yet built. Expected per directive.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (chapter: `lem:cech_free_complex_quasi_iso`)
- **Lean target exists**: no — not yet built. Expected per directive.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.

### `\lean{CategoryTheory.Injective.injective_of_adjoint}` (chapter: `lem:injective_of_adjoint`)
- **Lean target exists**: provided by Mathlib (`\mathlibok` in blueprint). No local
  declaration expected. Mathlib API usage in `injective_toPresheafOfModules` is correct.
- **Signature matches**: yes — blueprint says "L preserves monos ⟹ R carries injectives
  to injectives"; Lean call confirms this.
- **Proof follows sketch**: N/A (`\mathlibok`).

### `\lean{PresheafOfModules.sheafificationAdjunction}` (chapter: `lem:mod_pmod_adjunction`)
- **Lean target exists**: provided by Mathlib (`\mathlibok` in blueprint). No local
  declaration expected. Used directly in `injective_toPresheafOfModules`.
- **Signature matches**: yes — blueprint pins `sheafificationAdjunction (𝟙 _)` for the
  identity ring map; Lean uses `PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)`.
- **Proof follows sketch**: N/A (`\mathlibok`).

---

## Helper declarations (not top-level `\lean{...}` targets)

### `injective_toPresheafOfModules` (line 215)
LSP-confirmed signature:
```
AlgebraicGeometry.injective_toPresheafOfModules.{u} {X : Scheme} (I : X.Modules) [Injective I] :
  Injective ((Scheme.Modules.toPresheafOfModules X).obj I)
```
**Blueprint correspondence**: implements Part 1 of the `lem:injective_cech_acyclic`
proof sketch verbatim. Blueprint Part 1 says:
> Sheafification is left adjoint to the inclusion; its left adjoint is exact,
> hence preserves monomorphisms. By `lem:injective_of_adjoint` the right adjoint
> carries injective objects to injective objects.

Lean proof:
```lean
haveI : (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).PreservesMonomorphisms :=
  inferInstance
haveI : Injective (C := SheafOfModules X.ringCatSheaf) I := ‹Injective I›
exact Injective.injective_of_adjoint
  (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)) I
```
Step-for-step match with blueprint sketch. No sorries. LSP verify: axioms are
{`propext`, `Classical.choice`, `Quot.sound`} — standard Lean kernel axioms only,
no surprises.

### `freeYonedaHomEquiv` (line 244)
LSP-confirmed signature:
```
AlgebraicGeometry.freeYonedaHomEquiv.{u} {X : Scheme}
    (V : TopologicalSpace.Opens ↥X) (F : X.PresheafOfModules) :
  ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj V) ⟶ F) ≃
    (PresheafOfModules.presheaf F ⋙ forget Ab).obj (Opposite.op V)
```
**Blueprint correspondence**: blueprint `lem:cech_complex_hom_identification` proof says:
> The free–forgetful adjunction composed with Yoneda gives:
> `Hom(free(y V), F) ≅ Hom(y V, F) ≅ F(V)`

Lean proof:
```lean
PresheafOfModules.freeHomEquiv.trans yonedaEquiv
```
Direct one-liner that is exactly `freeHomEquiv ∘ yonedaEquiv`, matching the blueprint
description precisely. The target type `(F.presheaf ⋙ forget Ab).obj (op V)` is the
underlying set of the `O_X(V)`-module `F(V)` — appropriate for a bare `Equiv`; the
docstring correctly notes this is a set-level bijection, not yet additive/natural
(which is the explicitly planned next step). No sorries. LSP verify: axioms are
{`propext`, `Classical.choice`, `Quot.sound`}.

---

## Red flags

*(None found.)*

No placeholder bodies (`:= sorry`, `:= True`, `:= rfl` on nontrivial claims).  
No excuse-comments (`-- TODO replace`, `-- temporary`, `-- wrong but works`).  
No local `axiom` declarations.  
No suspicious `Classical.choice _` patterns on substantive claims — both uses of
`Classical.choice` trace to standard Mathlib via the inferred `PreservesMonomorphisms`
instance, which is the legitimate `inferInstance` path.  
Diagnostics: **zero errors, zero warnings** from the LSP over the whole file.

---

## Unreferenced declarations (informational)

Both Lean declarations in this file are helpers not yet covered by a `\lean{...}` tag:

| Declaration | Closest blueprint target | Status |
|---|---|---|
| `injective_toPresheafOfModules` | `lem:injective_cech_acyclic` (Part 1) | helper, intentional staged build |
| `freeYonedaHomEquiv` | `lem:cech_complex_hom_identification` (per-term core) | helper, intentionally partial |

Neither should be top-level blueprint blocks now, but both warrant a `\lean{...}`
tag once the parent target is formalized (or a `% NOTE:` cross-reference in the
corresponding proof block to document the split).

---

## Blueprint adequacy for this file

**Coverage**: 0/5 blueprint `\lean{...}` targets for PresheafCech.lean are yet
formalized (all 5 are expected-absent this iteration). The 2 helpers built are
sub-steps of those targets. Unreferenced helpers: 2 (both acceptable staged-build
sub-steps, not indications of coverage gaps).

**Proof-sketch depth**: **adequate**.

- `lem:injective_cech_acyclic` Part 1 sketch is detailed enough that the prover
  could (and did) extract a standalone helper in one try: the sketch names the exact
  Mathlib API (`sheafificationAdjunction`, `Injective.injective_of_adjoint`,
  `PreservesMonomorphisms`) and the three-step logical flow. The in-file strategy
  block (lines 156–182) is essentially an elaborated version of the same sketch.
- `lem:cech_complex_hom_identification` proof sketch names `freeHomEquiv`,
  `yonedaEquiv`, and the product-over-multi-indices step. The per-term core
  `freeYonedaHomEquiv` is a direct transcription of the first sentence of that sketch.
  The remaining steps (differential compatibility, complex assembly) are described
  but not yet formalized — that is expected.
- `lem:cech_free_complex_quasi_iso` proof sketch (objectwise homotopy, contracting
  homotopy via `i_fix`, `HomologicalComplex.Homotopy`) is detailed and actionable
  for the next iteration.
- `def:cech_free_presheaf_complex` and `def:section_cech_complex` definition blocks
  are complete with explicit degree-p formulas, differential sign convention, and
  pointer to the Stacks source.

**Hint precision**: **precise**. All `\lean{...}` hints name specific Lean 4 /
Mathlib 4 identifiers; none are ambiguous between multiple predicates. The strategy
comment in the Lean file has been pre-verified against the LSP (per the comment at
lines 186–194), so the Mathlib API names are confirmed to exist.

**Generality**: **matches need**. The blueprint works at the level of
`PresheafOfModules` / `X.PresheafOfModules` throughout, which is exactly the
generality needed by the Lean file.

**Recommended chapter-side actions**:
- Once `injective_cech_acyclic` (the full theorem) is built in Lean, add
  `\lean{AlgebraicGeometry.injective_toPresheafOfModules}` as a helper tag inside
  the `lem:injective_cech_acyclic` proof block (or add a `% NOTE:` cross-reference).
- Similarly, once `cechComplex_hom_identification` is built, add a helper tag or
  `% NOTE:` for `freeYonedaHomEquiv` in `lem:cech_complex_hom_identification`.
- Both are **minor** clean-up items for a future blueprint-writing subagent pass —
  not blocking.

---

## Severity summary

| Finding | Severity |
|---|---|
| `injective_toPresheafOfModules` not `\lean{...}`-tagged in blueprint | minor — helper sub-step, staging is intentional and documented |
| `freeYonedaHomEquiv` not `\lean{...}`-tagged in blueprint | minor — helper sub-step, partial build is explicitly planned |
| `freeYonedaHomEquiv` is a bare `Equiv`, not yet additive/natural | minor — intentional per directive; docstring acknowledges this |
| 5 blueprint targets not yet formalized | **informational** — all expected-absent this iteration |

**No must-fix-this-iter findings. No major findings.**

**Overall verdict**: both declarations built this iteration are clean, sorry-free,
and faithful to their respective blueprint proof sketches; the chapter provides
sufficient detail to guide the remaining 3 declarations in future iterations.
