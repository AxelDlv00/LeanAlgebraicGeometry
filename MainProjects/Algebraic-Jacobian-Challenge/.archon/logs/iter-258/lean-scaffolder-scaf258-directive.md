# lean-scaffolder scaf258

## Task
Create a NEW Lean file `AlgebraicJacobian/Picard/SheafOverEquivalence.lean` with `sorry`-body
declaration stubs for the SHARED-ROOT construction, plus rich `/- Planner strategy: ... -/` block
comments above each stub carrying the construction recipe. The file MUST COMPILE (sorry stubs allowed,
zero errors). Do NOT prove anything. Do NOT edit any other file (no root-import edit this iter — the
file builds standalone; consumers wire it next iter).

## Source of truth
- Blueprint chapter `blueprint/src/chapters/Picard_SheafOverEquivalence.tex` (NEW this iter; HARD-GATE
  cleared). Declaration `\lean{}` pins + `\uses{}` DAG are there.
- `analogies/overeq258.md` — the FULL construction skeleton (all Mathlib names confirmed with file:line).
  Quote its step list verbatim into the strategy comments.

## Declarations to stub (in this order, matching the chapter `\lean{}` pins)
Namespace `AlgebraicGeometry.Scheme.Modules` (match the project's existing `Scheme.Modules.*` decls; the
chapter uses `AlgebraicGeometry.Scheme.Modules.overEquivalence` etc.). For `{X : Scheme.{u}} (U : X.Opens)`:

1. `overEquivalence` : the equivalence
   `SheafOfModules ((↑U : Scheme).ringCatSheaf) ≌ SheafOfModules (X.ringCatSheaf.over U)` (or the
   orientation the analogist's `pushforwardPushforwardEquivalence e φ ψ H₁ H₂` produces — follow
   `analogies/overeq258.md` step 4 for the exact orientation). Strategy comment: steps 1–4 of the
   analogist skeleton (continuity free via `overEquivInverseIsDenseSubsite`; `φ` = open-immersion
   structure-sheaf ring iso sectionwise `U.ι.appIso`, mirroring `Scheme.Modules.restrictFunctor`).
2. `restrictOverIso` (M : X.Modules) : `overEquivalence.functor.obj (M.restrict U.ι) ≅ M.over U`.
   Strategy comment: analogist step 5 (`pushforwardComp` = `Iso.refl` + `pushforwardNatIso` along the
   `eqToIso` of the two `Over U ⥤ Opens X` functors; verbatim mirror of `restrictFunctorAdjCounitIso`,
   `Modules/Sheaf.lean:335`).
3. `unitOverIso` : `overEquivalence.functor.obj (SheafOfModules.unit (↑U).ringCatSheaf) ≅ SheafOfModules.unit (X.ringCatSheaf.over U)`.
   Strategy comment: analogist step 6.
4. `chartOverIso` (M : X.Modules) (e : M.restrict U.ι ≅ SheafOfModules.unit (↑U).ringCatSheaf) :
   `M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U)` :=
   `(restrictOverIso M).symm ≪≫ overEquivalence.functor.mapIso e ≪≫ unitOverIso`.
   Strategy comment: analogist step 7 (this one is a one-liner once 1–3 land; it is the general form of
   the engine's local `chartOverIso` sorry-def, to be redirected next iter).

## Imports
Add the minimal imports the signatures need (confirm via the LSP, e.g.
`Mathlib.Algebra.Category.ModuleCat.Sheaf.PushforwardContinuous`,
`Mathlib.Topology.Sheaves.Over`, and the project's `AlgebraicJacobian.Picard.LineBundlePullback` or
whatever provides `Scheme.ringCatSheaf`/`Scheme.Modules.restrict`/`SheafOfModules.over` —
`restrictFunctor` lives in `AlgebraicGeometry/Modules/Sheaf.lean`; the project's
`overEquivInverseIsDenseSubsite` lives in `Picard/TensorObjSubstrate/Vestigial.lean`, so an import of
that may be needed for the dense-subsite instance — check). Keep imports minimal and ensure the file
compiles with the sorries.

## Verify
Confirm the file compiles (`lake env lean` on the file, or LSP diagnostics = only the expected `sorry`
warnings, no errors). Report the final signatures + any signature the LSP forced you to adjust.
