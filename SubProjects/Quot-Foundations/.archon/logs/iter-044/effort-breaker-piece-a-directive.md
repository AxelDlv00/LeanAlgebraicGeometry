# Effort-breaker directive — decompose Piece A (QC-pullback)

## Target
`lem:qcoh_pullback_fromSpec` in `blueprint/src/chapters/Picard_QuotScheme.tex`
(Lean target `AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec`).

## Granularity
One level — split the proof into a `\uses`-linked chain of named sub-lemmas, each a single buildable
mathlib-gradient step, so a `mathlib-build` prover can land them bottom-up across iters. Each NEW sub-lemma
gets its own `\begin{lemma}` block with `\label`, `\lean{<name below>}`, accurate `\uses`, and a one-paragraph
informal proof. Do NOT add `\leanok`/`\mathlibok` to the new project sub-lemmas. Keep the existing
`lem:qcoh_pullback_fromSpec` block as the assembled top; repoint its proof `\uses` to the new sub-lemmas.

## Proof structure (route 1 — verbatim from the iter-043 prover hand-off,
task_results/AlgebraicJacobian/Picard/QuotScheme.md, "Piece A … route 1")
`hU.fromSpec` is an open immersion, so prove the general "pullback of a quasi-coherent sheaf along an OPEN
IMMERSION `g` is quasi-coherent" (`isQuasicoherent_pullback_of_isOpenImmersion`), then specialize `g := hU.fromSpec`.
Cover `Y` by `W i := g ⁻¹ᵁ (q.X i)` for `q : M.QuasicoherentData`; reduce to `IsQuasicoherent (N.over (W i))`
via `IsQuasicoherent.of_coversTop`. Sub-steps to break out:
1. `overRestrictUnitIsoInv` — the INVERSE unit-iso dual to the existing `overRestrictUnitIso`:
   `(overRestrictEquiv V).inverse.obj (unit …ringCatSheaf) ≅ unit (X.ringCatSheaf.over V)`.
   FRICTION to flag in its proof prose (from the prover): `Functor.IsContinuous` for
   `(Opens.overEquivalence V).functor` does NOT auto-synth inside `unitToPushforwardObjUnit` (supply via `haveI`);
   then a `↥V` vs `↥↑V` coercion mismatch — state `R`/`K` via `V.toScheme.ringCatSheaf`'s ACTUAL space,
   mirroring `overRestrictPullbackIso`.
2. `overRestrictPresentationInv` — geometric→slice `Presentation` via `Presentation.map` along
   `(overRestrictEquiv V).inverse` + `Presentation.ofIsIso` across `(overRestrictPullbackIso V N).symm`.
3. The `k`-restriction of `presentationPullbackιOfQuasicoherentData` via `pullbackComp` +
   a scheme-iso transport `presentationPullbackOfSchemeIso` (`k ≫ (q.X i).ι = (W i).ι ≫ g`).
4. `coversTop` for the preimage cover `{g ⁻¹ᵁ q.X i}`.
5. assembly `isQuasicoherent_pullback_of_isOpenImmersion` via `IsQuasicoherent.of_coversTop`, then the
   specialization `isQuasicoherent_pullback_fromSpec` (`g := hU.fromSpec`).

## Constraints
Project-bespoke infra (no external citation needed). Use existing labels where they already exist
(`def:over_restrict_presentation`, `def:presentation_pullback_iota_of_quasicoherentData`,
`lem:presentation_map_mathlib`, `lem:modules_pullback_mathlib`, `lem:isQuasicoherent_quasicoherentData_mathlib`).
Pick `\lean{}` names matching the sub-step names above under namespace `AlgebraicGeometry.Scheme.Modules`.
