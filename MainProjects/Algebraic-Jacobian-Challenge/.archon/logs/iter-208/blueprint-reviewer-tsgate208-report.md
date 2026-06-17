# Blueprint Review Report

## Slug
tsgate208

## Iteration
208

## Top-level summaries

### Citation discipline
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`: `% SOURCE QUOTE PROOF:` line is present but reads `TODO retrieve from references/stacks-constructions.tex (proof of lemma-spec, L553-L600… Verbatim quote omitted for length)`. The verbatim proof quote is intentionally absent; this is a citation-discipline finding (missing verbatim proof text). Not in an active prover route → **soon** severity.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **F1 RESOLVED.** The proof of `lem:tensorobj_restrict_iso` is Route A (open-immersion sectionwise base change), not the former mate-δ route. The four-step proof:
    1. Reduces restriction along `f` to `PresheafOfModules.pullback φ` via `Scheme.Modules.restrictFunctorIsoPullback`.
    2. Commutes pullback with sheafification via `SheafOfModules.sheafificationCompPullback`.
    3. Identifies pullback sectionwise over `V` as base change along the ring isomorphism `f.appIso V`; uses `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` to conclude the comparison is an iso commuting with `⊗`. No flatness, no monoidal-closed structure.
    4. Assembles sectionwise isos into a presheaf iso via `PresheafOfModules.isoMk`, then transports through Steps 1-2.
  - The **one project-side ingredient** (sectionwise unfolding of `PresheafOfModules.pullback φ` along an open immersion — no Mathlib presheaf analogue of `restrictFunctorIsoPullback`) is explicitly identified, described as ~30–60 LOC mirroring `restrictFunctorIsoPullback` one layer down. NOT hand-waved.
  - **No residual contradiction.** The `lem:restrictscalars_laxmonoidal` supplement carries `% NOTE: ...it is NOT used by lem:tensorobj_restrict_iso`. Its `\uses{}` does not include `lem:tensorobj_restrict_iso`. No surviving prose in the chapter invokes `leftAdjointOplaxMonoidal`, `(restrictScalars φ).LaxMonoidal`, `MonoidalClosed`, or flatness for the iso proof. The LOC-estimates section (Piece 2) explicitly restates the Route A recipe.
  - **Statement correctly generalized.** `lem:tensorobj_restrict_iso` reads "Let M, N ∈ Scheme.Modules X be **arbitrary** O_X-modules… No local-freeness, flatness, or line-bundle hypothesis on M, N is required." `\uses{def:scheme_modules_tensorobj}` only — no `IsLocallyTrivial` dependency.
  - **`\uses` edges coherent.** All internal labels resolve. Cross-chapter labels `thm:relative_pic_quotient_well_defined` and `lem:rel_pic_sharp_groupoid` verified present in `Picard_LineBundlePullback.tex` and `Picard_RelPicFunctor.tex` respectively; `def:pullback_along_projection` present in `Picard_LineBundlePullback.tex`. The consistency-check section (§8) lists all dependencies and notes `def:pullback_along_projection` as "implicitly" used by `lem:pullback_compatible_with_tensorobj` — the formal `\uses{}` of that lemma's statement block does not list it (only `lem:tensorobj_lift_onproduct`), but this omission is minor and does not block the prover.
  - **Citation discipline clean.** `% SOURCE:` cites `references/kleiman-picard-src/kleiman-picard.tex` — file exists on disk (`references/kleiman-picard-src/kleiman-picard.tex`). `% SOURCE QUOTE:` verbatim text present. `\textit{Source:...}` visible line matches pointer.
  - **HARD GATE: CLEARS.**

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Five Lean declarations carry `\leanok` (added by `sync_leanok`) but the chapter's own `% NOTE (iter-199)` blocks explicitly warn that the Lean bodies are placeholder/constant-functor stubs awaiting the Scheme.Modules monoidal-structure gap to close. These are `sync_leanok`-managed markers, not blueprint-reviewer scope; the blueprint prose itself is accurate (it documents the gap and instructs the planner not to mark them formalised). No blueprint correctness issue.
  - `lem:rel_pic_sharp_groupoid` proof block lacks `\leanok` — consistent with the gate-annotation section stating the file carries a genuine sorry on `addCommGroup`; the marker is correctly absent.
  - Gate annotation section (Lean encoding §) is accurate and up to date with the A.1.c.SubT dependency chain.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:relative_spec_univ`: `% SOURCE QUOTE PROOF:` is present as a TODO stub ("Verbatim quote omitted for length"). Not in active prover lane → **soon** (reported in Citation discipline above).
  - `thm:relative_spec_univ` and `thm:relative_spec_affine_base` notes record that Lean bodies encode weaker statements than the blueprint prose (`IsAffineHom` vs `RepresentableBy`); this is a known iter-174+ pending refinement, documented in the chapter notes. Not a correctness issue for the blueprint.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

## Severity summary: HARD GATE CLEARS — no must-fix-this-iter findings.

**Soon (1):**
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`: missing verbatim `% SOURCE QUOTE PROOF:` (placeholder TODO present; source location cited but text not extracted). Not in active prover lane.

**Informational (1):**
- `Picard_TensorObjSubstrate.tex` / `lem:pullback_compatible_with_tensorobj`: the statement `\uses{}` lists only `lem:tensorobj_lift_onproduct` and does not formally list `def:pullback_along_projection` from `chap:Picard_LineBundlePullback`, though the chapter consistency-check section acknowledges it as "implicitly" used. The downstream prover will read the statement prose which names the dependency; no correctness impact.

**Overall verdict:** `Picard_TensorObjSubstrate.tex` is `complete: true` / `correct: true` with no must-fix finding — the HARD GATE clears for the A.1.c.SubT prover lane; the F1 must-fix (mate-δ route) is fully resolved by the Route A rewrite, all three confirmation items pass, and no other chapter has a must-fix finding.
