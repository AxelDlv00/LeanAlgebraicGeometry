# Lean Audit Report

## Slug
iter054

## Iteration
054

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (duplicate lemma across files — see Major)
- **excuse-comments**: none
- **notes**:
  - Line 205 — sorry in `cechAugmented_exact`. Confirmed honest hole. Goal state:
    `⊢ Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) 0`
    This is the contracting (prepend-`i_fix`) homotopy for the section Čech complex over `V ≤ coverOpen 𝒰 i`. Surrounding reduction is non-circular and well-typed; LSP reports only the expected sorry warning.
  - Lines 52–59 — `isZero_of_faithful_preservesZeroMorphisms` (in namespace `AlgebraicGeometry`). Identical body to the copy in `OpenImmersionPushforward.lean` (which lives in `CategoryTheory.Functor`). The docstring of the OIP copy acknowledges the duplication at line 40. See Major.
  - Lines 76–81 — `isZero_homology_of_homotopy_id_zero`. Proof verified via LSP: goal before the three-step rewrite is `𝟙 (D.homology p) = 0`; `goals_after` is empty. The chain `homologyMap_id → ho.homologyMap_eq → homologyMap_zero` is exactly correct.
  - Lines 97–127 — `isZero_presheafToSheaf_of_locally_isZero`. Proof is sound: local injectivity of `0 : Q → Z` uses Subsingleton on zero-group fibers; local surjectivity is free since `Z = const PUnit`. Terminal call to `isZero_presheafToSheaf_obj_of_isLocallyBijective` is correct.
  - Lines 129–148 — `/- Planner strategy: ... -/` inline comment block. Not an excuse-comment; the code below it is well-formed. See Minor.
  - Lines 162–220 — `cechAugmented_exact`. Sieve construction (lines 207–220) is sound: downward closure by transitivity, covering by `⨆ Uᵢ = ⊤` via `Scheme.OpenCover.iSup_opensRange`, member-vanishing by `hSec`. LSP confirms no errors in the reduction steps beyond the sorry.
  - Lines 162–164 — `hF : F.IsQuasicoherent` parameter. The hypothesis is not referenced anywhere in the compiled proof body (the sorry is explicitly documented as "F-agnostic" in the comment at line 202). The theorem is thus over-specified in its current form. When filled, the sorry's proof (a pure combinatorial homotopy) also requires no QC. See Minor.

---

### `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (duplicate lemma — see Major)
- **excuse-comments**: none
- **notes**:
  - Lines 42–49 — `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms`. Duplicate of the copy in `CechAugmentedResolution.lean`; acknowledged in docstring line 40. See Major.
  - Lines 71–101 — `isZero_presheafToSheaf_of_sections_locally_zero`. Clean proof; the key improvement over the CechAugmentedResolution version is the `x - y` trick for local injectivity. LSP confirms `sub_eq_zero.mp h0` closes the relevant goal correctly. No soundness issues.
  - Lines 111–122 — `/- Planner strategy: ... -/` inline comment. See Minor.
  - Lines 137–143 — `isAffineHom_of_affine_separated` (private). Proof uses `IsAffineHom.of_comp` (LSP-verified signature: `[IsAffineHom (f ≫ g)] [IsSeparated g] : IsAffineHom f`). Both instance args are provided via `have hcomp` and `have hg`; Lean 4 synthesizes Prop-valued instances from local hypotheses. LSP shows `goals_after: []`, no diagnostics in lines 137–144.
  - Lines 150–155 — `pushforwardSectionsFunctor` definition. The 5-fold composite `pushforward j ⋙ forget ⋙ restrictScalars 𝟙 ⋙ toPresheaf ⋙ eval W` correctly computes `Γ(W, j_* -)` as sections over `j⁻¹W`. Type-checks without issues.
  - Lines 157–177 — `pushforwardSectionsFunctor_additive`. Explicit `instAdditiveComp` chain build. LSP confirms the final `@CategoryTheory.Functor.instAdditiveComp ... (pushforward j) hpf ... i2` closes the goal (goals_after: []). The explicit `@` passing of `i2` is sound and necessary. No masking of a wrong instance.
  - Line 224 — sorry in `higherDirectImage_openImmersion_acyclic`. Confirmed honest hole. Goal:
    `⊢ IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)`
    This is Serre vanishing on the affine `j⁻¹W` (q ≥ 1). Non-circular; all prior reductions are well-typed.
  - Lines 212–216 — `hcomplex : ... = rfl`. The definitional equality proof via `rfl` is checked by the kernel, not a `change`-style escape.
  - Lines 246–249 — sieve restriction proof. `congr 1` at line 247 is used on `g.op = (homOfLE hAU ≫ homOfLE hVA).op` after `rw [← op_comp]`. LSP confirms `goals_after: []`. This is NOT a subsingleton-coherence trap: `congr 1` reduces `Opposite.op a = Opposite.op b` to `a = b` where the hom-type in `Opens X` is a Prop (thin preorder category), so the goal is closed by proof irrelevance — fully kernel-sound.
  - Lines 244–245 — `Subsingleton.elim ((ConcreteCategory.hom (Q.map (homOfLE hAU).op)) s) 0`. The subsingleton is established from `IsZero (Q.obj (Opposite.op A))` via `AddCommGrpCat.subsingleton_of_isZero`, which is a legitimate application to a genuine zero object. Not a soundness trap.
  - Line 290 — sorry in `higherDirectImage_openImmersion_comp`. Confirmed honest hole. Goal:
    `⊢ higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`
    The full comparison isomorphism. The proof sketch in comments (lines 272–289) is detailed and correctly identifies all residuals as downstream of Part (1)'s sorry. Non-circular; `this : IsAffineHom j` is in place.

---

## Must-fix-this-iter

None.

---

## Major

- `CechAugmentedResolution.lean:52` / `OpenImmersionPushforward.lean:42` — `isZero_of_faithful_preservesZeroMorphisms` is defined independently in both files (namespaces `AlgebraicGeometry` and `CategoryTheory.Functor` respectively). The OIP docstring explicitly acknowledges this as a workaround for import restrictions. The lemma bodies are identical. When the import structure is resolved or a shared utility file is introduced, one definition must be removed or the names will collide if the import graph closes. Flag for extraction into a shared file (e.g., `Cohomology/Utils.lean`).

---

## Minor

- `CechAugmentedResolution.lean:129` — Inline `/- Planner strategy: ... -/` block (20 lines). This is navigation/planning commentary, not Lean documentation. It accurately describes the proof route but belongs in a sidecar rather than the source file. Not an excuse comment; no correctness impact.
- `OpenImmersionPushforward.lean:111` — Same: inline `/- Planner strategy: ... -/` block. Same observation.
- `CechAugmentedResolution.lean:164` — `hF : F.IsQuasicoherent` is bound but unused in the current proof. The sorry (line 205) is explicitly noted as "F-agnostic, cover-agnostic" in the surrounding comment. If the intended fill is truly a pure homotopy argument, the theorem holds without QC and the hypothesis over-specifies it. No correctness harm; the stated theorem is mathematically valid. Mention in review for post-sorry cleanup.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (duplicate lemma definition across two files)
- **minor**: 3 (inline planner strategy blocks ×2, unused `hF` parameter ×1)
- **excuse-comments**: 0

Overall verdict: Both files are structurally sound — all three sorries are honest holes with verified goal states, no compilation errors beyond expected sorry warnings, no soundness traps in `congr 1` / `Subsingleton.elim` / `change` steps, and the explicit `instAdditiveComp` chain is kernel-sound. The one notable issue is the duplicated `isZero_of_faithful_preservesZeroMorphisms` lemma across both files.
