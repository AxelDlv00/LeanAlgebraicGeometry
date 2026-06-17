# Lean ↔ Blueprint Check Report

## Slug
grcells-iter007

## Iteration
007

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Grassmannian.affineChart}` (chapter: `def:gr_affine_chart`)

- **Lean target exists**: yes (`AlgebraicGeometry.Grassmannian.affineChart` at line 60)
- **Signature matches**: partial — see note on cardinality below
- **Proof follows sketch**: N/A (this is a `def`, not a theorem; no blueprint proof body to compare)
- **notes**:
  - Body is `AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`.
    This is precisely the blueprint recipe `Spec ℤ[x^I_{p,q}]_{q ∉ I}`: the polynomial ring in
    the `d(r-d)` free entries, indexed by `(p : Fin d, q : Fin r | q ∉ I)`. Mathematical content
    matches the Nitsure source quote and the blueprint definition verbatim. ✓
  - LSP diagnostics: zero errors, zero warnings, zero sorries. `lean_verify` reports only the
    standard Lean/Mathlib axioms `{propext, Classical.choice, Quot.sound}` — no unauthorized
    axioms introduced. ✓
  - `\lean{...}` hint in blueprint names the declaration exactly; `\leanok` marker already
    present at `def:gr_affine_chart` line 39 of the chapter. ✓
  - **Cardinality gap (minor)**: the blueprint specifies `I ⊆ {1,...,r}` *with `#(I) = d`*
    as a precondition, but the Lean signature is `(I : Finset (Fin r))` with no cardinality
    constraint in the type. The definition is therefore more general (computes the spectrum for
    any `I`, giving a ring of dimension `d * (r - #I)` rather than `d * (r - d)` when `#I ≠ d`).
    Mathematically this is a safe generalization, but it does not enforce the intended invariant.
    The blueprint should note this or the Lean declaration should add a `(hI : I.card = d)`
    parameter; for now, no downstream proof is broken. ✓/⚠ (minor)
  - **Stale docstring note (minor)**: the docstring contains the planner note "For the iter-007
    file-skeleton the body is a typed `sorry`." This was written when the body was still a
    skeleton. The body has now been filled and this sentence is factually wrong. It is not an
    excuse-comment (does not claim the code is incorrect or temporary), but it will confuse
    future provers reading the file. Should be removed. (minor)

---

## Red flags

### Stale / misleading comments

- `GrassmannianCells.lean:59`: docstring line "For the iter-007 file-skeleton the body is a
  typed `sorry`." contradicts the actual filled body on line 61. This is not an excuse-comment
  under the must-fix rule, but it is actively misleading documentation left over from before
  the body was filled. **Severity: minor.**

No placeholder / sorry bodies, no excuse-comments excusing wrong code, no axiom declarations
beyond the standard Lean/Mathlib foundation.

---

## Unreferenced declarations (informational)

The Lean file has exactly **one** declaration (`affineChart`), and it is `\lean{...}`-referenced
from the blueprint. No unreferenced declarations.

The blueprint chapter, by contrast, references **five additional declarations** that do not yet
appear in the Lean file:

| `\lean{...}` hint | Blueprint label |
|---|---|
| `AlgebraicGeometry.Grassmannian.transitionMap` | `def:gr_transition` |
| `AlgebraicGeometry.Grassmannian.cocycleCondition` | `lem:gr_cocycle` |
| `AlgebraicGeometry.Grassmannian.scheme` | `def:gr_glued_scheme` |
| `AlgebraicGeometry.Grassmannian.isSeparated` | `lem:gr_separated` |
| `AlgebraicGeometry.Grassmannian.isProper` | `lem:gr_proper` |

These are clearly future-iteration work (the file header explicitly states it "contains the
single blueprint-pinned declaration"). This is expected and not a gap for iter-007.

---

## Blueprint adequacy for this file

A bidirectional check on whether the chapter gave a prover enough detail to formalize the file.

- **Coverage**: 1/1 Lean declarations have a corresponding `\lean{...}` block in the chapter.
  The 5 additional blueprint declarations are future work; no substantive Lean code is missing a
  blueprint block.
- **Proof-sketch depth**: N/A for `affineChart` (a definition, not a theorem). The definition
  body is explicit in the blueprint prose and source quote; no proof sketch is needed.
- **Hint precision**: precise. `\lean{AlgebraicGeometry.Grassmannian.affineChart}` pins the
  exact Lean name; the blueprint's source quote from Nitsure specifies the exact ring
  (`ℤ[x^I_{p,q}]`, i.e. `MvPolynomial`) and the exact index type (`(p,q)` with `q ∉ I`).
  The `CommRingCat.of` wrapper is implicit Lean plumbing and requires no blueprint guidance.
- **Generality**: matches need. The definition is stated for the absolute base ℤ; the blueprint
  notes the relative/base-change version is explicitly out of scope for this chapter.
- **Recommended chapter-side actions**:
  - (Minor) Consider adding a note to `def:gr_affine_chart` that the Lean signature takes
    `I : Finset (Fin r)` with cardinality unconstrained, and downstream users should apply
    it only with `I.card = d`.
  - (Informational) The five future declarations (`transitionMap`, `cocycleCondition`,
    `scheme`, `isSeparated`, `isProper`) are well-blueprinted with source quotes and full proof
    sketches; no chapter expansion is needed before their prover work begins.

---

## Severity summary

| Finding | Severity |
|---|---|
| Stale docstring line "the body is a typed sorry" (factually wrong post-fill) | **minor** |
| Lean signature `(I : Finset (Fin r))` does not enforce blueprint's `#I = d` precondition | **minor** |
| 5 blueprint declarations not yet in Lean file | informational (future work) |

**No must-fix-this-iter or major findings.**

**Overall verdict**: The filled `affineChart` body correctly formalizes the blueprint recipe
(`Spec ℤ[x^I_{p,q}]_{q ∉ I}`) with standard axioms only; two minor clean-up items remain
(stale docstring note and unenforced cardinality precondition), neither blocking further work
on this file or chapter.
