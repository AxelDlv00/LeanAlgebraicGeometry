# Lean ↔ Blueprint Check Report

## Slug
HigherDirectImagePresheaf

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (blueprint `\lean{...}` blocks targeting this file)

The chapter covers this file via the `% archon:covers` annotation (line 8). Searching all `\lean{...}` blocks in the chapter for declarations that belong to `HigherDirectImagePresheaf.lean` yields exactly **one** block:

### `\lean{AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology}` (chapter: `\lem:higher_direct_image_presheaf`)

- **Lean target exists**: **no** — this declaration is absent from `HigherDirectImagePresheaf.lean`. The closest declaration is `AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology` (line 158), which is the resolution-dependent form of the same statement (Stacks 01XJ) rather than the named target.
- **Signature matches**: **no** — the named target has never been built; the built declaration has a different name and a slightly different type (it takes an explicit `InjectiveResolution G` argument and expresses the iso in terms of the presheaf-level homology of the pushed-forward resolution, not yet identified with `V ↦ Hⁿ(f⁻¹(V), G)`).
- **Proof follows sketch**: **N/A** — the named declaration does not exist.
- **Notes**: This is a documented design fork (flagged in the directive). The prover stopped at the resolution form and noted that the remaining identification of `(pushforwardResolutionPresheafComplex f I).homology n` with the absolute cohomology presheaf is a hand-off step. The blueprint prose in `lem:higher_direct_image_presheaf` accurately describes what the named target should say; the gap is in the Lean side not yet reaching it.

---

## Red flags

No red flags of the hard-stop variety.

### Placeholder / suspect bodies
*(none)* — all 6 declarations in the file have complete proof/definition bodies; LSP diagnostics: 0 errors, 0 warnings, 0 sorries.

### Excuse-comments
The file docstring (lines 33–36) and the declaration docstring for `higherDirectImage_iso_sheafify_presheafHomology` (lines 155–157) note that "the remaining step … is handed off." These are accurate informational notes explaining the scope limit, not excuse-comments hiding incorrect or incomplete code; the built declarations are fully proved. No red flag.

### Axioms / Classical.choice on non-trivial claims
*(none)* — no `axiom` declarations; no `Classical.choice` on non-trivial claims; the memory record for this file confirms all 6 declarations are axiom-clean.

---

## Unreferenced declarations (informational)

All 6 declarations in the Lean file lack a `\lean{...}` blueprint pointer. Categorised below:

| Declaration | Namespace | Assessment |
|---|---|---|
| `CategoryTheory.Functor.mapHomologyIso'` (line 56) | `CategoryTheory.Functor` | Helper — lifts `ShortComplex.mapHomologyIso` to `HomologicalComplex` degreewise. Acceptable as un-blueprinted helper. |
| `PresheafOfModules.sheafificationAdditive` (line 80) | `PresheafOfModules` | Helper — instance enabling `mapHomologicalComplex`. Acceptable. |
| `PresheafOfModules.counitComplexIso` (line 92) | `PresheafOfModules` | Helper — complex-level counit iso. Acceptable; it is a sub-lemma consumed only internally. |
| `PresheafOfModules.homologyIsoSheafify` (line 112) | `PresheafOfModules` | **Substantive** — the "engine for Stacks 01XJ": sheaf homology = sheafify of presheaf homology. This is the core categorical fact referenced in the blueprint prose for `lem:higher_direct_image_presheaf` but has no `\lean{...}` pointer. Should get a blueprint block. |
| `AlgebraicGeometry.pushforwardResolutionPresheafComplex` (line 135) | `AlgebraicGeometry` | **Substantive** — defines the presheaf complex whose sheafification is `Rⁿ f_* G`. Directly consumed by the main theorem and has no `\lean{...}` pointer. Should get a blueprint block. |
| `AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology` (line 158) | `AlgebraicGeometry` | **Substantive (main theorem, design fork)** — the resolution form of `lem:higher_direct_image_presheaf`. The blueprint `\lean{...}` hint points to the missing named target instead. Needs a `\lean{}` block of its own, or the blueprint hint must be updated. |

---

## Blueprint adequacy for this file

- **Coverage**: 0 / 6 Lean declarations have a `\lean{...}` blueprint pointer (counting the one block that exists, it points to a non-existent Lean name). Unreferenced: 3 helpers (acceptable per directive) + 3 substantive (flagged above).
- **Proof-sketch depth**: **adequate for the intended target** — the prose and proof sketch in `lem:higher_direct_image_presheaf` are detailed enough to guide the formalization of `higherDirectImage_isSheafify_presheafCohomology` had the prover built it. The sketch's two-step structure (sheafify of objectwise homology via exactness of sheafification + right-derived-functor computation) is exactly the two-step composition in `higherDirectImage_iso_sheafify_presheafHomology`. No depth failure.
- **Hint precision**: **wrong (stale)**. The `\lean{...}` hint for `lem:higher_direct_image_presheaf` names `higherDirectImage_isSheafify_presheafCohomology`, which does not exist. The actual built declaration is `higherDirectImage_iso_sheafify_presheafHomology`. The hint must be updated.
- **Generality**: **matches need** for the infrastructure built. The three helper declarations (`homologyIsoSheafify`, `counitComplexIso`, `sheafificationAdditive`) plus `pushforwardResolutionPresheafComplex` are all consumed by the main theorem and at the right level of generality for the project.
- **Recommended chapter-side actions**:
  - Update the `\lean{...}` hint on `lem:higher_direct_image_presheaf` to replace `higherDirectImage_isSheafify_presheafCohomology` with `higherDirectImage_iso_sheafify_presheafHomology` once the planner signs off on the design fork, or add both names with a `% NOTE:` explaining the gap.
  - Add a blueprint definition block (inside the presheaf-description section) for `PresheafOfModules.homologyIsoSheafify` — the key categorical engine — with a `\lean{}` pointer.
  - Add a blueprint definition block for `AlgebraicGeometry.pushforwardResolutionPresheafComplex` — the construction this iter built.
  - Add a blueprint `% NOTE:` or sub-definition block for `AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology` with its current type (resolution-dependent form) so coverage is documented and the design-fork decision is recorded in the blueprint.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{higherDirectImage_isSheafify_presheafCohomology}` names a declaration absent from the Lean file (design fork, known) | **major** |
| `PresheafOfModules.homologyIsoSheafify` lacks a `\lean{...}` blueprint pointer (substantive, engine-level decl) | **major** |
| `AlgebraicGeometry.pushforwardResolutionPresheafComplex` lacks a `\lean{...}` blueprint pointer (substantive) | **major** |
| `AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology` lacks a `\lean{...}` blueprint pointer; stale hint on `lem:higher_direct_image_presheaf` | **major** |
| `mapHomologyIso'`, `sheafificationAdditive`, `counitComplexIso` lack `\lean{...}` pointers (helpers) | **minor** (acceptable per directive) |

No **must-fix-this-iter** findings: no sorry/placeholder bodies, no axioms, no excuse-comments on live declarations, no signature mismatches on built declarations (signatures on all 6 declarations are internally consistent and the proofs close without sorry), and no blueprint-adequacy failure of the type "chapter too thin to guide formalization." The sole must-fix-adjacent issue is the stale `\lean{...}` hint, but since this is a documented design fork acknowledged in the directive, it is classified **major** (blueprint pointer update required in the next iter).

**Overall verdict**: The Lean file is axiom-clean and sorry-free with 6 fully proved declarations, but the blueprint is behind — the named target `higherDirectImage_isSheafify_presheafCohomology` was not built (design fork), and 3 substantive declarations (`homologyIsoSheafify`, `pushforwardResolutionPresheafComplex`, `higherDirectImage_iso_sheafify_presheafHomology`) lack blueprint coverage; the blueprint's `\lean{...}` hint for `lem:higher_direct_image_presheaf` needs updating.
