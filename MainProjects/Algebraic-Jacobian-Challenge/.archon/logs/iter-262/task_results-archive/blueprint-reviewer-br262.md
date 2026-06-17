# Blueprint Review Report

## Slug
br262

## Iteration
262

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:dual_restrict_iso` proof: the `\lean{sliceDualTransport}` hint is **absent** from the proof body; only the outer `lem:dual_restrict_iso` and `lem:restrictscalars_ringiso_dualequiv` are tagged. A prover dispatched to `DualInverse.lean` cannot identify the target Lean declaration from the blueprint.
- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` proof (D3′): the composition-coherence paste's Sq1 ingredient is described only as "a standalone project sub-lemma (mate-calculus style)" without giving its 4-term signature. The prose at lines 4074–4076 says "the genuinely missing ingredients are the composition coherences Sq1 and Sq4" — this is **stale**: both are now proved (Sq1 as `private lemma sheafificationCompPullback_comp` at L2439; PROGRESS.md confirms all four sub-lemmas proved). The paste roadmap is not updated to reflect this.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:dual_restrict_iso` proof, "The leg-(A) atom `sliceDualTransport`": the prose describes `sliceDualTransport` as (a) a leg-(A)-**only** construction and (b) built via `eqToHom`-conjugation across `f.opensFunctor`. The Lean implementation (as captured in the chapter's own `% NOTE (review iter-261)` at lines 5780–5791) builds it as the **combined leg A∘B** packaging into one `LinearEquiv.toModuleIso`, with leg-(A)'s forward component as a categorical `(ModuleCat.restrictScalars β_W).map (φ.app …)` (NOT eqToHom — the `.map` form is load-bearing; `ofHom` reduces the carrier and loses the `restrictScalars`/`pushforward₀` module instance). Two open codomainMap frictions are also undocumented in the proof text: (a) CommRing-instance loss on `forget₂ CommRingCat RingCat`-imaged section rings blocks `restrictScalars_isIso_ε_of_bijective`; (b) the `𝟙_`-vs-`restr`-section defeq bridge needed for `exact inv (ε …)`. A prover reading only the prose would build the wrong atom.

### Citation discipline

No citation-discipline findings. All `% SOURCE:` lines on blocks feeding active prover routes include `(read from references/<file>.md/.tex)` parentheticals, named files exist on disk, and verbatim `% SOURCE QUOTE:` text matches the source language and notation.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: partial
- **correct**: partial
- **notes**:
  - **Missing `\lean{sliceDualTransport}` hint** — the proof of `lem:dual_restrict_iso` names `sliceDualTransport` as the leg-(A) atom but has no `\lean{...}` tag for it; prover cannot identify the Lean target.
  - **Stale eqToHom description** — the "leg-(A) atom" paragraph (lines 5757–5791) describes the forward/inverse maps as `eqToHom`-conjugation; the Lean uses categorical `.map` form. A `% NOTE (review iter-261)` comment at lines 5780–5791 already identifies the 4 required writer actions (retag as A∘B, replace eqToHom with `.map`/`inv ε`, add `\lean` hint, document frictions) — these must be applied to the prose.
  - **Leg A∘B packaging mismatch** — blueprint frames `sliceDualTransport` as leg-(A) alone, while the Lean packages both legs as one `LinearEquiv.toModuleIso`; the Step-4 residual paragraph and the isoMk description (lines 5793–5797) partially cover leg B but do not reflect the combined atom.
  - **Two codomainMap frictions undocumented** — (a) CommRing-instance loss blocking `restrictScalars_isIso_ε_of_bijective`; (b) `𝟙_`-vs-`restr`-section defeq bridge — both recorded only in the NOTE comment, not in the proof prose.
  - **Sq1 paste description stale** — D3′ proof sketch at lines 4074–4076 still says Sq1 and Sq4 composition coherences are "missing"; both are now proved. Sq1 composition coherence `sheafificationCompPullback_comp` (private, L2439) should have its 4-term form stated so the paste roadmap is accurate.
  - **Gate status**: `correct: partial` on the `dual_restrict_iso`/`sliceDualTransport` prose (wrong description of the Lean atom) and `complete: partial` on the D3′ paste roadmap (stale "missing" statement). Both gated files (`DualInverse.lean`, `TensorObjSubstrate.lean`) are affected. **HARD GATE FAILS for both active prover lanes.** Blueprint-writer directed THIS iter; re-review scoped to this chapter via fast-path is the recovery action.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct.
**Prover lane may open.** Six declarations (`def:cech_nerve`, `def:cech_complex`, `lem:cech_acyclic_affine`, `lem:cech_computes_cohomology`, `def:cech_higher_direct_image`, `lem:cech_flat_base_change`) all carry `\leanok`, `\lean{...}` hints matching the six Lean scaffold declarations, and detailed proof sketches adequate for formalization. Stacks citations are verbatim, `references/stacks-coherent.tex` exists on disk, visible `\textit{Source:}` lines match `% SOURCE:` pointers, `% SOURCE QUOTE:` and `% SOURCE QUOTE PROOF:` blocks present where applicable. `\uses{}` cross-references are DAG-clean (bw-cech261 fixed broken Stacks-internal `\ref{}` targets). **HARD GATE CLEARS for `CechHigherDirectImage.lean`.**

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - One `Theorem~REF` cross-reference placeholder (informational; no active prover lane on this chapter).

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.
(Named gap `rigidity_over_kbar` with sorry body is correctly disclosed; off critical path per STRATEGY.md.)

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two `Chapter~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Six `Chapter~REF`/`Definition~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Twenty-nine `Theorem~REF`/`Definition~REF` cross-reference placeholders (informational; all mathematical content is present).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Twenty-three `Chapter~REF`/`Definition~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - The `\lean{AlgebraicGeometry.higherDirectImage}` Lean target carries a `[HasInjectiveResolutions X.Modules]` conditional hypothesis not reflected in the blueprint statement; the chapter's own NOTE (iter-233) records this correctly. The file is an orphan module (not imported by the aggregator). Since the chapter has no active prover lane and this discrepancy is documented, this is a **soon**-severity finding (not must-fix-this-iter).

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Eleven `Section~REF`/`Theorem~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two `Theorem~REF` cross-reference placeholders (informational; A.2.c chapter, gated behind A.1.c).

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - One truncated sentence ending in `see~\)` at section setup (line 44 of read window) — incomplete parenthetical reference; informational.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Twenty-four `Definition~REF`/`Theorem~REF`/`Lemma~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Twenty-three `Definition~REF`/`Lemma~REF`/`Corollary~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - One `Theorem~REF` placeholder (informational).

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Four `Section~REF`/`sub-step~REF` placeholders (informational).

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Ten `Section~REF`/`Definition~REF` cross-reference placeholders (informational).

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter; no mathematical content of its own.)

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.
(Route C — paused per USER directive; content correct for future use.)

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

## Severity summary

### Must-fix-this-iter

1. **`Picard_TensorObjSubstrate.tex` — `correct: partial`, `complete: partial`** (HARD GATE FAILS for both active prover lanes this iter)
   - **DualInverse lane gate**: `\lean{sliceDualTransport}` hint missing from `lem:dual_restrict_iso` proof; the leg-(A)/A∘B packaging description is wrong (eqToHom vs `.map` form); two codomainMap frictions undocumented; combined A∘B structure not reflected. Blueprint-writer must apply the 4 actions listed in the `% NOTE (review iter-261)` comment (lines 5780–5791) to the prose.
   - **TensorObjSubstrate D3′ lane gate**: D3′ paste roadmap states Sq1 and Sq4 composition coherences as "missing" (stale — both proved); Sq1's 4-term signature for `sheafificationCompPullback_comp` not stated in the proof sketch. Blueprint-writer must update the "genuinely missing ingredients" sentence and add the Sq1 equation form.
   - **Action**: dispatch `blueprint-writer` for `Picard_TensorObjSubstrate.tex` THIS iter (already planned per directive); then re-dispatch me scoped to this chapter only (fast-path gate clearance).

### Soon

1. `Cohomology_HigherDirectImage.tex` — `correct: partial`: `[HasInjectiveResolutions X.Modules]` hypothesis in the Lean target not reflected in the blueprint statement; orphan module. Document in a follow-up writer pass when the chapter's prover lane opens.

### Informational

- **§REF cross-reference placeholders** in 12 inactive chapters: `Rigidity`, `Cohomology_SheafCompose`, `Cohomology_StructureSheafAb`, `Cohomology_StructureSheafModuleK`, `Cohomology_MayerVietoris`, `Picard_RelativeSpec`, `Picard_FGAPicRepresentability`, `Picard_FlatteningStratification`, `Albanese_AuslanderBuchsbaum`, `AbelJacobi`, `Jacobian`, `Differentials`. None block any active route; tracked as `§REF` backlog.
- `Picard_QuotScheme.tex`: truncated sentence ending in `see~\)` — minor typo, inactive lane.

**Overall verdict**: 1 chapter (`Picard_TensorObjSubstrate.tex`) fails the HARD GATE on both active prover lanes due to a stale/wrong `sliceDualTransport` description and an outdated D3′ paste roadmap; a blueprint-writer fast-path repair followed by a scoped re-review is the recovery. `Cohomology_CechHigherDirectImage.tex` is complete + correct — HARD GATE CLEARS for the engine `Rⁱf_*` prover lane. No unstarted phases (all strategy phases have adequate blueprint coverage). 37/38 chapters clean, 1 must-fix.
