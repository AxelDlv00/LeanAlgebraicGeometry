# Blueprint Review Report

## Slug
ts237-rescope

## Iteration
237

## Gate Decision (Summary)

**Chapter 1 — `Picard_TensorObjSubstrate.tex`**: GATE CLEARS. `complete: true`, `correct: true`, no must-fix. The Vestigial.lean coverage line is present, the two new lemma blocks are mathematically correct and formalizable, the three-movement proof sketch is coherent, all `\uses{}` resolve, and the StalkTensor section is unchanged and correct.

**Chapter 2 — `Cohomology_FlatBaseChange.tex`**: GATE CLEARS. `complete: true`, `correct: true`, no must-fix. The circular QC dependency is genuinely fixed, the three Γ-fragment lemma blocks are well-specified with matching `\lean{}` pins, and all `\uses{}` resolve.

Both prover lanes may dispatch this iter.

---

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:stalk_tensor_commutation_naturality_right`: The proof checks the naturality square on germ generators and invokes both `stalkTensorLinearMap_germ_tmul` and `stalkLinearMap_germ`. The reverse direction is mentioned ("the inverse direction … is checked the same way") without being made fully explicit. This is minor and does not block the prover — the forward direction is complete and the reverse is symmetric. **Informational only.**

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:W_implies_stalkwise_iso`: The `\lean{PresheafOfModules.isIso_stalkFunctor_map_of_W}` pin names a declaration that does not yet exist in the Lean files (confirmed by grep). This is expected — the lemma is a new prover target. The proof cites `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` and the local-bijectivity ↔ stalkwise-iso equivalence, which are correct Mathlib idioms for the topological site. **Informational: non-issue for dispatch; the lean hint is a well-formed forward declaration.**

- `Picard_TensorObjSubstrate.tex` / `lem:stalk_tensor_commutation_naturality_right`: Similarly, `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` does not yet exist. Same status as above. **Informational.**

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Coverage line `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean` is present at line 5. The Lean file `Vestigial.lean` exists on disk; confirmed.
  - `lem:W_implies_stalkwise_iso` (`\lean{PresheafOfModules.isIso_stalkFunctor_map_of_W}`): new block, no `\leanok` (correct — not yet formalized). Statement is the iff characterisation of J.W-membership by stalkwise isomorphism on the topological site Opens X, using W.WEqualsLocallyBijective. Proof sketch cites `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`, `app_injective_iff_stalkFunctor_map_injective`, and the locally-bijective↔stalkwise characterisation — all plausible Mathlib idioms. `\uses{lem:stalk_linear_map}` resolves (label exists at line ~1113). Statement correct: the iff holds on the topological site because local injectivity = stalkwise injective and local surjectivity = stalkwise surjective there.
  - `lem:stalk_tensor_commutation_naturality_right` (`\lean{PresheafOfModules.stalkTensorIso_naturality_right}`): new block, no `\leanok` (correct — not yet formalized). Statement is the commutative square: stalkTensorIso is natural in the second factor, with the bottom map being LinearMap.lTensor A_x g_x. `\uses{lem:stalk_tensor_commutation, lem:stalk_linear_map}` — both labels exist. Proof checks on germ generators via TensorProduct.induction_on + stalk_hom_ext, citing stalkTensorLinearMap_germ_tmul and stalkLinearMap_germ. The identification of (A◁g)_x with LinearMap.lTensor A_x g_x is correct: the whiskered morphism acts as id⊗g sectionwise. Mathematically sound.
  - `lem:islocallyinjective_whiskerleft_via_stalk` (`\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}`): has `\leanok` on the statement block (skeleton with sorry body exists in Vestigial.lean at line 267, confirmed by read). Proof block (no `\leanok`) correctly documents the intended proof. Three movements: (a) d.1-bridge via `lem:W_implies_stalkwise_iso` → stalkwise iso g_x, (b) B-naturality via `lem:stalk_tensor_commutation_naturality_right` → (F◁g)_x = LinearMap.lTensor F_x g_x, (c) lTensor of an isomorphism is an isomorphism by `LinearEquiv.lTensor` (flatness-free, needs only functoriality). Proof `\uses{lem:stalk_tensor_commutation, lem:stalk_linear_map, lem:W_implies_stalkwise_iso, lem:stalk_tensor_commutation_naturality_right}` — all four labels exist in this chapter. The three-movement logic is coherent. The `LinearEquiv.lTensor` idiom is precisely the right Mathlib handle for "lTensor of an equivalence is an equivalence" without flatness.
  - `\cref{lem:islocallyinjective_whisker_of_W}` in the statement of `lem:islocallyinjective_whiskerleft_via_stalk` resolves — label exists at line 1177.
  - `sec:tensorobj_stalk_tensor`: unchanged from prior iters. `lem:stalk_tensor_commutation` has `\leanok` on statement (confirmed by memory: d.2 iso axiom-clean); `lem:stalk_tensor_desc_forward` and `lem:stalk_tensor_linear_map` both have `\leanok`. Section remains correct.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pushforward_spec_tilde_iso` proof is now non-circular: it builds the comparison map α directly, reduces to basic opens via `lem:modules_isIso_of_isBasis` (the basis-local criterion), computes sections over D(a) showing (restr_φ M)[1/a] ≅ M[1/φa] as R[1/a]-modules, then states QC as a corollary of the object isomorphism. This is the correct "route-(iii)" order: object iso first, QC second. The iter-236 worry (QC used as a prerequisite before the iso was established) is resolved. `\uses{lem:modules_isIso_of_isBasis, lem:gammaPushforwardTildeIso}` — both labels exist in this chapter. No circular dependency: `lem:modules_isIso_of_isBasis` → `lem:modules_isIso_iff_stalk` (no deps on pushforward); `lem:gammaPushforwardTildeIso` → `lem:gammaPushforwardIso` → `lem:globalSectionsIso_hom_comp_specMap_appTop` (no deps on pushforward).
  - `lem:globalSectionsIso_hom_comp_specMap_appTop` (`\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}`): Lean declaration confirmed in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (grep match). No `\leanok` in blueprint — expected, since this is a new blueprint block (the Lean decl was built in iter-236 but had no blueprint entry; sync_leanok will add `\leanok` once this iter's sync runs). Statement (ring equation: gs_R ∘ (Spec φ)^♯_top = φ ∘ gs_R') is the correct naturality statement for the Γ⊣Spec adjunction unit at the top open. Proof sketch invokes Γ⊣Spec naturality — adequate.
  - `lem:gammaPushforwardIso` (`\lean{AlgebraicGeometry.gammaPushforwardIso}`): confirmed in same file. No `\leanok` — same reason. `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}` resolves. Statement Γ((Spec φ)_* N) ≅ restr_φ(Γ N) is correct: global sections of the affine pushforward equal restriction of scalars of global sections. Proof correctly identifies both sides as carrying the same underlying abelian group, with the R-action reconciled via the ring equation of `lem:globalSectionsIso_hom_comp_specMap_appTop`.
  - `lem:gammaPushforwardTildeIso` (`\lean{AlgebraicGeometry.gammaPushforwardTildeIso}`): confirmed in same file. No `\leanok` — same reason. `\uses{lem:gammaPushforwardIso}` resolves. Statement Γ((Spec φ)_* M̃) ≅ restr_φ M is correct: specialise `lem:gammaPushforwardIso` to N = M̃ and compose with the tilde unit iso Γ(M̃) ≅ M.
  - Existing `\leanok` declarations (`lem:modules_isIso_iff_stalk`, `lem:modules_isIso_of_isBasis`, `lem:modules_isIso_iff_affineOpens`, `def:pushforward_base_change_map`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`) are unchanged and correctly marked.
  - `lem:pushforward_spec_tilde_iso` itself has no `\leanok` — correct, it's the next prover target.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

---

Severity summary: HARD GATE CLEARS — no findings.

Overall verdict: Both chapters edited this iter are `complete: true` and `correct: true` with no must-fix findings; both prover lanes (Vestigial.lean whiskering and FlatBaseChange pushforward_spec_tilde_iso) may dispatch this iter. No unstarted-phase proposals; all strategy phases have adequate blueprint coverage.
