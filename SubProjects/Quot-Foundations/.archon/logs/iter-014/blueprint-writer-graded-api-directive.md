# Blueprint-writer directive — QUOT graded-grading wrapper for Stacks 00K1

## Chapter to edit
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this file).

## Goal
The power-series half of graded Hilbert–Serre rationality (`lem:gradedHilbertSerre_rational`,
`\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}`) is DONE in Lean (the `IsRatHilb`
toolkit + `IsRatHilb.ofDiffEq`, already blueprinted in subsec `isRatHilb`). The remaining
obstruction is the GRADED-MODULE side of the Stacks 00K1 inductive step. Author a new subsection
that blueprints a **thin graded-grading wrapper over EXISTING Mathlib scaffold** (NOT a from-scratch
graded API) — the sub-lemmas G1–G5 below + the degreewise rank-nullity identity — as a
`\uses`-linked chain feeding the existing `lem:gradedHilbertSerre_rational` proof. This sets up a
next-iter `mathlib-build` prover lane, so each block must have a precise `\lean{}` forward-pin and an
informal proof rigorous enough to formalize.

## Authoritative plan (read first)
`analogies/quot-graded-module-api.md` — the api-alignment analysis. It establishes:
- Mathlib ALREADY provides: `Submodule.IsHomogeneous`/`HomogeneousSubmodule`
  (`Mathlib.RingTheory.GradedAlgebra.Homogeneous.Submodule`), `QuotSMulTop x M` (= M/xM,
  `Mathlib.RingTheory.QuotSMulTop`), `HomogeneousIdeal`, `Ideal.homogeneous_span`,
  `SetLike.IsHomogeneousElem.graded_smul`, `DirectSum.Decomposition`, `SetLike.GradedSMul`,
  `GradedRing`, `LinearMap.finrank_range_add_finrank_ker`, `Submodule.finrank_quotient_add_finrank`,
  `Submodule.FG.restrictScalars_of_surjective`.
- Mathlib LACKS (the project gap-fill): `DirectSum.Decomposition` on a homogeneous submodule; on a
  quotient module; `GradedRing` on `R/I` for homogeneous `I`; the regrading; graded `Module.Finite`
  transfer; graded Hilbert series.

## Blocks to author (mirror the `HomogeneousIdeal`/`GradedRing` shape: unbundled
## `DirectSum.Decomposition` + `SetLike.GradedSMul` instances on the derived objects)

Setting throughout: a graded ring `R = ⨁ₙ 𝒜ₙ` with `𝒜₀ = κ` a field, generated in degree 1; a f.g.
graded `R`-module `M = ⨁ₙ ℳₙ` with finite-dimensional `ℳₙ`; `x ∈ 𝒜₁`.

1. **Mathlib dependency anchors** (`\mathlibok`, with the exact Mathlib `\lean{}` target each): state
   in project notation — `Submodule.IsHomogeneous`/`HomogeneousSubmodule`, `QuotSMulTop`,
   `Ideal.homogeneous_span`, `LinearMap.finrank_range_add_finrank_ker`,
   `Submodule.finrank_quotient_add_finrank`, `Submodule.FG.restrictScalars_of_surjective`,
   `SetLike.IsHomogeneousElem.graded_smul`. Mark `\mathlibok` ONLY on these anchors.

2. **G1 — grading on a homogeneous submodule.** `lem:graded_homogeneousSubmodule_decomposition`
   (propose `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_decomposition}` or similar):
   for `p : Submodule R M` with `p.IsHomogeneous ℳ`, the family `n ↦ (p ⊓ ℳ n)` carries a
   `DirectSum.Decomposition` + `SetLike.GradedSMul 𝒜`. Used for the kernel `K = ker(x⋆)`.

3. **G2 — grading on the quotient by a homogeneous submodule.**
   `lem:graded_quotient_decomposition`: for `p.IsHomogeneous ℳ`, `M ⧸ p` (specialize to
   `QuotSMulTop x M` = `M/xM`) carries `DirectSum.Decomposition` with components `(ℳ n).map p.mkQ`.
   Proof spine: `M = ⨁ ℳ n` internal, `p = ⨁ (p ⊓ ℳ n)` from G1 ⟹ `M/p = ⨁ ℳ n/(p ⊓ ℳ n)`.
   `\uses{G1}`.

4. **G3 — `GradedRing` on `R ⧸ (x)`** for `x ∈ 𝒜₁` (so `(x)` homogeneous via
   `Ideal.homogeneous_span`): components `(𝒜 n).map (Ideal.Quotient.mk (x))`. The heaviest block.

5. **G4 — regrade `C = M/xM` and `K = ker(x⋆)` over `R/(x)`**: `SetLike.GradedSMul` for the
   `R/(x)`-action on the G1/G2 component families (both are annihilated by `x`). `\uses{G1,G2,G3}`.

6. **G5 — graded `Module.Finite` transfer**: `C`, `K` are f.g. over `R` (sub/quotient of f.g. over
   Noetherian `R`) and annihilated by `(x)`, so f.g. over `R/(x)` via
   `Submodule.FG.restrictScalars_of_surjective` along `R ↠ R/(x)`. `\uses{G4, anchors}`.

7. **D5 — degreewise rank-nullity identity** `lem:graded_degreewise_finrank_diff`:
   `dim ℳ_{n+1} − dim ℳ_n = dim C_{n+1} − dim K_n`, PURE linear algebra on `xₙ : ℳₙ → ℳ_{n+1}` via
   rank-nullity (no graded objects). This is the `hdiff` input to `IsRatHilb.ofDiffEq`.

8. **Re-point the `lem:gradedHilbertSerre_rational` proof body** (already present, lines ~408–474):
   make the inductive step explicitly manufacture `K`, `C` as f.g. graded `R/(x)`-modules via
   G1–G5, build `hdiff` via D5, and feed `IsRatHilb hC d`, `IsRatHilb hK d` (from the IH on `R/(x)`,
   an `(r−1)`-generated ring) into `IsRatHilb.ofDiffEq` + `IsRatHilb.bump`. Update the proof's
   `\uses{}` to include G1–G5 + D5. Keep the existing Stacks 00K1 `% SOURCE QUOTE PROOF` block.

## Build order to note in the prose (for the next-iter prover)
G1 → G2 → G5 → G3 → G4 → assembly (G1/G2/G5 unblock the most with least risk; D5 lands independently).

## Hypothesis note (do NOT change the signature, just record)
The 00K1 reduction needs finitely many degree-1 generators. Add a `% NOTE:` flagging that this is
expected to follow from "f.g. κ-algebra + degree-1-generated" (so likely NO new hypothesis on
`gradedModule_hilbertSeries_rational`), to be confirmed when the prover formalizes G-assembly.

## Out of scope
- Do NOT touch `def:sectionGradedRing`, `lem:sectionGradedModule_fg`, or any geometric section
  object — those are the separate SNAP-S1 bridge phase.
- Do NOT add `\leanok` to anything (the sync phase owns it). `\mathlibok` ONLY on the block-1 anchors.
- Do NOT edit any chapter other than `Picard_QuotScheme.tex`.

## Citations
G1–G5 + D5 are project-bespoke building blocks realizing standard graded-algebra manipulations that
the existing 00K1 proof already cites — no NEW external source quote is required for them (the
`% SOURCE QUOTE PROOF` on `lem:gradedHilbertSerre_rational` already covers the assembly). If you find
you need a source for G3 specifically, you may consult `references/hilbert-serre-algebra.tex`.
