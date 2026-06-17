# Blueprint Review Report

## Slug
br255

## Iteration
255

## Top-level summaries

### Citation discipline

- `Picard_LineBundleCoherence.tex` / `thm:lbc_isFinitePresentation`: the `% SOURCE QUOTE:` cites Stacks Lemma 17.25.4 (Tag 0B8M) — "Any locally free $\mathcal{O}_X$-module of rank 1 is invertible…" — but the theorem states `IsLocallyTrivial M → M.IsFinitePresentation`. The cited quote establishes locally-free-of-rank-1 ⟹ invertible; it does not state the finite-presentation conclusion. The visible `\textit{Source: ...}` line correctly cites Tag 0B8M. The mismatch is that the theorem conclusion (IsFinitePresentation) goes beyond the cited lemma (IsInvertible). Since the chapter is new and informational this iter (not feeding a live prover lane this iteration), this is a **soon** finding. The writer should either point at the stacks definition of finite presentation (already quoted for `lem:lbc_chart_presentation`) or mark the theorem as Archon-original assembly and drop the 0B8M SOURCE QUOTE (which belongs to `lem:lbc_chart_presentation`, not the main theorem).

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

**HARD GATE VERDICT: complete + correct — GATE CLEARS.**

- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pullback_tensor_map_natural` (D1′, `pullbackTensorMap_natural`) — the rewritten proof sketch (lines 3311–3356) is **adequate**. It clearly identifies Square 2 (the only delicate case) as requiring a type-ascription of the ring map `φ'` to the canonical `⋙ forget₂ CommRingCat RingCat` form so that the presheaf monoidal structure resolves; explains that after this ascription the naturality identity `δ ∘ F(a⊗b) = (Fa⊗Fb) ∘ δ` matches the goal definitionally (no rw/erw of monoidal lemmas needed); and identifies Squares 1/3/4 plus bifunctoriality via `tensorHom_comp_tensorHom` as already-closed inputs. The device is explicitly described as proof-internal, with NO restatement of `pullbackTensorMap` (D2′ untouched). A prover can follow this directly. `\leanok` present.
  - `lem:sheafify_tensor_unit_iso_natural` (`sheafifyTensorUnitIso_hom_natural`) — the rewritten proof sketch (lines 3373–3415) is **adequate**. Three-step categorical route: (1) rewrite `.hom` as a single tensor of morphisms `a.map(η_P ⊗ η_Q)` in the canonical `⋙ forget₂` monoidal structure; (2) merge the two functor-image factors via `F(g) ∘ F(h) = F(g∘h)`; (3) close by the bifunctoriality interchange law `(f₁⊗f₂)∘(g₁⊗g₂) = (f₁∘g₁)⊗(f₂∘g₂)` plus the two single-component naturality squares of η. The obsolete TensorProduct-induction route is entirely replaced. `\leanok` present.
  - All other blocks in the chapter remain as previously reviewed; no new issues detected on this pass.

### `blueprint/src/chapters/Picard_LineBundleCoherence.tex`

**Informational only — not gating this iter per directive. Assessment for next pass:**

- **complete**: true
- **correct**: true
- **notes**:
  - NEW chapter (added this iter). Covers `AlgebraicJacobian/Picard/LineBundleCoherence.lean` (file does not yet exist — no `\leanok` markers). Blueprint has 5 well-formed declaration blocks (C1–C4 + rank/flatness corollary) with adequate proof sketches.
  - `sec:lbc_site_instances` / `rem:lbc_site_instances`: correctly flags the three required slice-topology instances (`HasSheafCompose`, `HasWeakSheafify`, `WEqualsLocallyBijective`) as the single instance-resolution item to verify when the Lean file is scaffolded. This is an honest and formalizer-actionable note.
  - **Citation-discipline (soon)**: `thm:lbc_isFinitePresentation`'s `% SOURCE QUOTE:` is from Tag 0B8M ("locally free of rank 1 is invertible") but the theorem concludes `IsFinitePresentation`. The 0B8M quote is not the source for the finite-presentation conclusion; it belongs in the motivating context. Recommend the writer either retarget the SOURCE QUOTE to the Stacks "modules of finite presentation" definition (already quoted under `lem:lbc_chart_presentation`) or mark the theorem as Archon-original and remove the 0B8M SOURCE QUOTE. Not blocking this iter.
  - `\uses{}` cross-references: `def:line_bundle_on_product` lives in `Picard_LineBundlePullback.tex` — valid cross-chapter reference. `rem:lbc_site_instances` is defined within this chapter and used by `thm:lbc_isFinitePresentation` — correct. Dependency order is sound.
  - `references/stacks-modules.tex` exists on disk — all `(read from references/stacks-modules.tex, ...)` citations are backed by an existing file.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_QuotScheme.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_IdentityComponent.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**: none.
- **soon** (1): `Picard_LineBundleCoherence.tex` / `thm:lbc_isFinitePresentation` — SOURCE QUOTE (Tag 0B8M) cites locally-free-implies-invertible but the theorem concludes IsFinitePresentation; writer should retarget quote or mark theorem Archon-original. Does not affect prover dispatch for `LineBundleCoherence.lean` (chapter is correct and complete; this is a citation-discipline cleanup).
- **informational**: `Picard_LineBundleCoherence.tex` — the three slice-topology instances in `rem:lbc_site_instances` are correctly flagged in the blueprint as the single entry-check for the prover; no further action needed at the blueprint level.

Overall verdict: `Picard_TensorObjSubstrate.tex` is **complete + correct** with no must-fix findings — the rewritten D1′ and unit-iso proofs are both adequate for prover dispatch. The HARD GATE CLEARS. The new chapter `Picard_LineBundleCoherence.tex` is also complete + correct (one soon-tier citation-discipline item, non-blocking) and is ready for prover dispatch in a future iteration once the Lean skeleton is created.
