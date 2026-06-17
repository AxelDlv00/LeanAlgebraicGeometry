# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
ts219dual

## Design question

To finish the by-hand `CommGroup` on iso-classes of locally-trivial (invertible)
`𝒪_X`-modules (`X.Modules = SheafOfModules X.ringCatSheaf`), we need to exhibit, for a
locally-trivial `L`, an inverse object `Linv : X.Modules` with a contraction iso
`tensorObj L Linv ≅ 𝒪_X` (`exists_tensorObj_inverse`). The blueprint route sets
`Linv := ℋom_{𝒪_X}(L, 𝒪_X)` (the internal hom / dual) and uses the evaluation
`L ⊗ ℋom(L,𝒪_X) → 𝒪_X`. The iter-218 prover found this blocked at step 1: it cannot even
NAME `Linv` because Mathlib at `b80f227` has **no** `MonoidalClosed`/internal-hom/dual for
`PresheafOfModules R` or `SheafOfModules R`, and **no** object-level descent for
`SheafOfModules`.

**The question (one design question, with sub-parts that are all facets of the same "how
do we get the inverse object" decision):**

1. Does Mathlib already provide, anywhere (possibly under a different name / namespace), an
   internal-hom / dual / `ℋom`-object construction for `PresheafOfModules R` or
   `SheafOfModules R` that lands BACK in `(Presheaf|Sheaf)OfModules R` (NOT in
   `Sheaf J (Type _)` — `CategoryTheory.sheafHom` is known to land there and carries no
   module structure)? Include: `MonoidalClosed` instances, `ihom`, `linearYoneda`-style
   constructions, `PresheafOfModules.Hom`-as-an-object, sheaf-Hom-of-modules,
   `restrictScalars`/`pushforward`-built duals, or any abelian-category internal-hom that
   specializes here.

2. If no general internal hom exists, is there a **line-bundle-specific** shortcut for the
   INVERSE that avoids the full internal hom? Specifically: how does Mathlib's `CommRing.Pic`
   / `Module.Invertible R` obtain the inverse of an invertible module over a FIXED ring
   (the dual `M →ₗ[R] R`, or `Module.Dual`, or the `Invertible` two-sided-inverse witness)?
   Name the exact construction Mathlib uses for the inverse there, and assess whether its
   SHAPE can be ported sheaf-locally to the varying-`𝒪_X` setting (build the local dual on
   each trivialising affine where `L|_U ≅ 𝒪_U`, then assemble).

3. The blocker report offers an alternative primitive **(II) object-level descent for
   `SheafOfModules`**: take a cover `{U_i}`, objects `M_i : (U_i).Modules`, transition isos
   on overlaps satisfying cocycle, produce a global `M : X.Modules` with `M|_{U_i} ≅ M_i`.
   Does Mathlib have ANY object-gluing/descent for `SheafOfModules` or for sheaves valued in
   a category (`CategoryTheory.Sheaf` gluing of OBJECTS, not sections) — e.g. via
   `Sheaf`/`Stack` descent, `GrothendieckTopology` gluing data, limit/colimit over the
   cover diagram, or `glueSections`-style object assembly? If so, name it and assess fit.

4. **Verdict + cost**: for whichever of (1)/(2)/(3) is the realistic build path, render
   ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL and give a CONCRETE bounded build recipe
   (mirroring how `tensorObj` is the sheafification of `PresheafOfModules.Monoidal.tensorObj`
   — i.e. build the presheaf-level dual, then sheafify) with a rough LOC/iter estimate and a
   list of the exact Mathlib decls each step would lean on. State clearly whether this is a
   bounded one-to-few-iter `mathlib-build` (like the iter-217 H1 pushforward adjunction was)
   or a genuinely large multi-iter swath (like the previously-abandoned d.2 stalk-⊗ was).

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1390` — `exists_tensorObj_inverse` (the
  sorry; signature in the goal below).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:991` — `tensorObj` (the substrate tensor:
  sheafification of `PresheafOfModules.Monoidal.tensorObj`; the dual should mirror this build).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1257` — `tensorObj_restrict_iso` (CLOSED
  iter-217: `(M⊗N)|_f ≅ M|_f ⊗ N|_f` — available downstream for local-iso-⟹-global bookkeeping).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1080,1090` — `tensorObj_left/right_unitor`.
- `informal/exists_tensorObj_inverse.md` — the iter-218 source-derived blocker report with the
  full decomposition, the precise goal signature, and the two candidate missing primitives.
  **READ THIS FIRST.**

The goal signature:
```lean
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)
```

## Why now

iter-218's prover hit a pre-committed INCOMPLETE gate on `exists_tensorObj_inverse` and the
progress-critic explicitly scheduled this analogist consult before any further build. This is
the decisive feasibility/shape decision for the next phase of Lane TS (the sole active Route A
lane): before funding a multi-iter `mathlib-build` of the dual object, we need to know (a)
whether Mathlib already has it under another name, (b) whether the inverse can be gotten more
cheaply than the full internal hom (line-bundle-specific), and (c) the realistic shape + cost.

## Hints (optional)

- Namespaces to probe: `PresheafOfModules`, `SheafOfModules`, `CategoryTheory.MonoidalClosed`,
  `CategoryTheory.Abelian` (internal hom in abelian categories), `Module.Dual`,
  `Module.Invertible`, `CommRing.Pic`, `CategoryTheory.Sheaf` (object descent),
  `AlgebraicGeometry.Scheme.Modules`.
- The project DELIBERATELY does not build `MonoidalCategory (X.Modules)` for the varying
  structure sheaf (see memory `commring-pic-is-skeleton-route`,
  `rem:scheme_modules_monoidal_off_path`), so a rigid/dualizable-object route off a coherent
  monoidal category is NOT available — do not recommend it.
- iter-217 precedent: H1 (presheaf pushforward adjunction) was a bounded ~70–90 LOC
  `mathlib-build` by de-sheafifying existing sheaf-level decls + `leftAdjointUniq`. If the
  dual has a similarly bounded "presheaf-then-sheafify" build, that is the ideal outcome.
- KNOWN ABSENT (verified iter-218, do not re-report as findings): `MonoidalClosed
  (PresheafOfModules R)`, `MonoidalClosed (SheafOfModules R)`, `SheafOfModules` object descent.
  Your value is finding what DOES exist that we can lean on, or confirming the bounded build path.

## Severity expectation
high-stakes
