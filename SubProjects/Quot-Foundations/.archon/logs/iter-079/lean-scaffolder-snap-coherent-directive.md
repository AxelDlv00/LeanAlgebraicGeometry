# lean-scaffolder — snap-coherent

Target: `AlgebraicJacobian/Picard/SectionGradedRing.lean`

Action: Add ONE new declaration `AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit` with a
`sorry` body, realizing blueprint `lem:sectionMul_coherent` (`Picard_SectionGradedRing.tex`,
L1291–1326): the section multiplications `sectionsMul` are (a) ASSOCIATIVE — the two composites
`Γ(F)⊗Γ(G)⊗Γ(H) → Γ((F⊗G)⊗H) ≅ Γ(F⊗(G⊗H))` agree after transport along the `tensorObjAssoc`
associator — and (b) UNITAL — `1 ∈ Γ(X,𝒪_X)` (public `unitModule`) acts as a two-sided identity after
the `O_X`-unitor `tensorObjUnitIso`. Design the exact signature (triple-tensor section carriers at
`op ⊤`; pick the cleanest formulation, e.g. separate `_assoc` / `_unit` fields or a structure — your call).

Place a rich `/- Planner strategy: -/` comment above the `sorry` capturing:
- Proof route (blueprint): reduce to the tensor-product PRESHEAF level where Γ-at-top is strictly
  monoidal (`lem:presheafModule_monoidal_mathlib`), so associator/unitor act on elementary tensors by
  the usual formulas; the sheafification unit `η` is natural so commutes with associator/unitor
  (`lem:presheafModule_sheafification_mathlib`); apply `Γ(X,-)` to the naturality squares.
- Hard-won engineering caveats (from iter-078 task result): spell `P⊗Q` as
  `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q`; pass `IsIso` EXPLICITLY to `asIso`
  inside long `≪≫` chains (`@asIso _ _ _ _ f h`, NOT `haveI`+`asIso`); do NOT use `whiskerRightIso`
  with an iso typed in `X.PresheafOfModules` (use morphism-level `whiskerRight` + `Iso.mk`);
  positional `rw`/`simp` of comp-nodes FAILS under the `X.Modules` diamond — term-mode/`change` only.

Constraints: file MUST compile (`lake build AlgebraicJacobian.Picard.SectionGradedRing`) with the body
left as `sorry`; change NO existing signature; no proofs. `unitModule` is already public.
