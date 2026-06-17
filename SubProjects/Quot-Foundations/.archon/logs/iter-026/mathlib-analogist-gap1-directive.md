# mathlib-analogist directive — iter-026 (Quot-Foundations)

## Mode: api-alignment

## Question
We need to build, axiom-clean in the project, the lemma (gap1):

  `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent` :
    for `M : (Spec R).Modules` with `M.IsQuasicoherent`, `IsIso M.fromTildeΓ`.

Equivalently (by Mathlib `isIso_fromTildeΓ_iff`): a quasi-coherent module sheaf on `Spec R` lies in the
essential image of `tilde : ModuleCat R ⥤ (Spec R).Modules`. This is the hard direction of the affine
equivalence QCoh(Spec R) ≃ Mod R.

What Mathlib provides at the pinned commit (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`):
- `isIso_fromTildeΓ_iff : IsIso M.fromTildeΓ ↔ (tilde.functor R).essImage M`.
- `isIso_fromTildeΓ_of_presentation (M) (P : M.Presentation) : IsIso M.fromTildeΓ` — needs a GLOBAL
  `SheafOfModules.Presentation` (a cokernel-of-free-sheaves diagram).
- `presentationTilde` / `instance : (tilde M).IsQuasicoherent` — the EASY direction.
- The source comment says the QCoh = essential-image identification "will later be shown" (i.e. absent).

`IsQuasicoherent` (`SheafOfModules.IsQuasicoherent` / `QuasicoherentData`) gives only LOCAL
cokernel-of-frees presentations on an open cover.

## What I need from you (api-alignment)
1. **Does Mathlib already have a route from `IsQuasicoherent` (or `QuasicoherentData`) to a global
   `SheafOfModules.Presentation` on an affine / quasi-compact-quasi-separated scheme?** Search for:
   `Presentation`, `IsQuasicoherent`, `QuasicoherentData`, `essImage`, global-generation /
   `Module.Finite`-free-presentation lemmas, and any `AffineScheme`/`Spec`-specific quasi-coherent
   descent. Name exact declarations (full names + file) if they exist.
2. If no single lemma exists, **what is the canonical Mathlib idiom/decomposition** to assemble a global
   presentation from local cokernel-of-frees data on `Spec R` (qcqs)? E.g. is there a "globally generated
   on affine", "sections generate", `Γ`-adjunction counit-epi, or a `quasiSeparated`/`quasiCompact`
   gluing-of-presentations lemma? Give the concrete chain of Mathlib declarations a prover would compose.
3. **Is there a SHORTER route** that avoids constructing a `Presentation` at all — e.g. proving
   `(tilde.functor R).essImage M` directly from `IsQuasicoherent M` via the unit/counit of
   `tilde.adjunction`, or via `M.fromTildeΓ` being a local iso (iso on each basic-open stalk/section) and
   then iso globally? Name the Mathlib lemmas (local-iso ⟹ iso for sheaf morphisms, `isIso_of_isIso_app`,
   stalk-wise iso, etc.).
4. Verdict: is gap1 a **single-lemma** build, a **short chain** (name it), or **genuine multi-step
   descent** with no current Mathlib idiom (in which case give the cleanest decomposition into named
   sub-lemmas a mathlib-build lane should target)?

The output seeds the gap1 blueprint sketch (`lem:qcoh_affine_isIso_fromTildeΓ` in
`Picard_QuotScheme.tex`), which the blueprint-reviewer flagged as hand-waving the globalization. Write a
persistent `analogies/<slug>.md` so the next iter's planner has the concrete route.
