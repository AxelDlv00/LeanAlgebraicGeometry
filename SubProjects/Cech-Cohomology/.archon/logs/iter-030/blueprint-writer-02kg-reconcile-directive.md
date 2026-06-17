# Blueprint-writer — 02KG reconcile + design-fork resolution

You edit ONE chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(the consolidated chapter covering FreePresheafComplex, CechBridge, AffineSerreVanishing,
QcohTildeSections, CechToCohomology, …). Do NOT touch other chapters. You may spawn a
reference-retriever if you genuinely need a source not already in `references/` (write-domain
includes `references/**`). Do NOT add `\leanok` anywhere (the deterministic sync owns it).

## Strategic context (what changed this iter)
A read-only strategy-critic + a mathlib-analogist confirmed a **design-fork resolution** that
the chapter must now reflect. Background:

- The 02KG affine cover system's `injective_acyclic` field is used over standard covers of
  *arbitrary* distinguished opens `D(f)`, but the shipped `injective_cech_acyclic` was tied to
  `X.OpenCover` (covers ⊤). RESOLUTION: the free Čech resolution machinery
  (`FreePresheafComplex.lean`) is being **re-parameterized** from `X.OpenCover` to a raw finite
  family of opens `{ι}[Finite ι](U : ι → Opens X)`, making `injective_cech_acyclic` **cover-agnostic**.
  This is sound: the augmented free Čech resolution is exact *stalkwise* (at `x` it is the augmented
  simplicial chain complex of the full simplex on `{i : x ∈ U_i}`, coefficients `O_{X,x}`); covering
  only fixes the identity of the augmentation target `O_𝒰 := image(cechFreeAug)`, never exactness.
  Mathlib indexes its Čech complexes the same way (`CategoryTheory.cechComplexFunctor`,
  `Limits.FormalCoproduct.cech` — raw family, no covering hypothesis).
- Consequence: the `injective_acyclic` field is discharged **DIRECTLY** by the family-form
  `injective_cech_acyclic` applied to each covering datum `c.2` — no `X.OpenCover` bridge, no
  ⊤-restriction. The iter-029 helpers `affine_injective_acyclic` (⊤-case) and `coverDatum_bridge`
  are no longer load-bearing for this field.
- `surj_of_vanishing` route (confirmed by the analogist): `ses_cech_h1` + local section surjectivity
  of an `O_X`-module epimorphism via `CategoryTheory.Presheaf.IsLocallySurjective`
  (`isLocallySurjective_iff`), which is unlocked by ONE small gap-fill instance
  `SheafOfModules.toSheaf.PreservesEpimorphisms` (epi of `O_X`-modules ⇒ epi of the underlying
  abelian sheaf), then `Sheaf.isLocallySurjective_iff_epi'`; the per-point lift cover is refined to
  affine/basic opens via `Scheme.isBasis_affineOpens` to land a standard cover in `Cov`.

## Edits required (be precise; keep all existing verbatim SOURCE QUOTES intact)

### A. `lem:cover_datum_bridge` (≈L3328) — fix the dangling `\lean{}` pin (lvb-affine MAJOR)
The pin `\lean{AlgebraicGeometry.coverDatum_bridge}` names a non-existent decl. The landed
axiom-clean decl is `AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan`, proving the open-level
identity `coverOpen 𝒰 i = D(s_i)` for the standard affine cover. Repin `\lean{}` to
`AlgebraicGeometry.coverOpen_affineOpenCoverOfSpan` and revise the statement/prose to the
open-level equality (drop the "full section-Čech-complex identification" claim). Update the iter-029
`% NOTE` to state this is resolved (open-level identity, used to relate standard covers to `D(f)`).
This lemma stays useful (it identifies a standard cover's opens with `D(s_i)`), but is no longer on
the `injective_acyclic` discharge path.

### B. `lem:injective_cech_acyclic` (≈L2579) — record the family-form generalization
The blueprint statement is already general ("any open covering `U = ⋃_{i∈I} U_i`"). The Lean is
being re-parameterized to match: `injective_cech_acyclic {ι}[Finite ι](U : ι → Opens X)(I)[Injective I]
(p)(hp:0<p) : IsZero ((sectionCechComplex U (toPresheaf I)).homology p)` — a finite family of opens,
NO covering hypothesis. Keep the `\lean{}` pin name `AlgebraicGeometry.injective_cech_acyclic`.
Add a short prose sentence: the formalization holds over an arbitrary finite family of opens (the
augmented free Čech resolution is exact stalkwise; covering is not needed), so it discharges the
cover-system field directly. You may add a `\mathlibok` dependency-anchor block naming Mathlib's
raw-family Čech precedent `CategoryTheory.cechComplexFunctor` to keep the alignment visible (optional).

### C. `lem:affine_injective_acyclic` (≈L3361) — demote to a special case
Update the iter-029 SCOPE-GAP `% NOTE`: the fork is RESOLVED. State that the
`BasisCovSystem.injective_acyclic` field is now discharged DIRECTLY by the family-form
`lem:injective_cech_acyclic` (no ⊤-restriction); the landed `affine_injective_acyclic` (⊤-case) is a
valid special case but is no longer required for the field. Soften the overclaiming prose to the
⊤-case it actually proves.

### D. `def:affine_cover_system` (≈L3409) — rewrite the `injective_acyclic` discharge + remove "NOT YET BUILDABLE"
- Replace the iter-029 "NOT YET BUILDABLE / design fork" `% NOTE` with: the fork is resolved; the
  `injective_acyclic` field is discharged directly by family-form `lem:injective_cech_acyclic`, and
  `surj_of_vanishing` by `lem:affine_surj_of_vanishing` (see E). The remaining blocker is the
  `surj_of_vanishing` geometry, not the injective field.
- Update `\uses{}`: the `injective_acyclic` discharge now uses `lem:injective_cech_acyclic` (drop
  `lem:affine_injective_acyclic`, `lem:cover_datum_bridge` from this field's justification). Keep
  `lem:affine_faces_mem`, `lem:affine_surj_of_vanishing`.
- Fix the prose: it says "five fields" but `BasisCovSystem` has B, Cov, and **three** proof fields
  (`faces_mem`, `surj_of_vanishing`, `injective_acyclic`). State the three proof fields correctly.

### E. `lem:affine_surj_of_vanishing` (≈L3295) — rewrite the proof sketch with the local-surjectivity route
Rewrite the proof to the analogist-confirmed route:
1. `S.g` epi in `X.Modules` ⟹ (via the gap-fill `SheafOfModules.toSheaf.PreservesEpimorphisms`)
   epi of the underlying abelian sheaf ⟹ `Presheaf.IsLocallySurjective` of the section map
   (`Sheaf.isLocallySurjective_iff_epi'`, then `TopCat.Presheaf.isLocallySurjective_iff`).
2. For a section `t ∈ S₃(V)` over `V ∈ B`, local surjectivity gives a cover `{W_x}` of `V` with
   local lifts; refine to basic/affine opens (`Scheme.isBasis_affineOpens`) to obtain a standard
   cover `𝒰 ∈ Cov` of `V` carrying local lifts `sLoc`.
3. Since `S.X₁` has vanishing higher Čech over all `c ∈ Cov` (the field hypothesis), `Ȟ¹(𝒰, S.X₁)=0`;
   feed `𝒰`, `sLoc`, and the `Ȟ¹=0` to `ses_cech_h1` (already general over a raw family) to obtain a
   global lift of `t` over `V`. This is the surjectivity.
Add a new lemma block (or `\mathlibok` anchor) for the gap-fill
`lem:to_sheaf_preserves_epi` with `\lean{AlgebraicGeometry.???}` (the prover will name it; pin a
plausible name e.g. `AlgebraicGeometry.toSheaf_preservesEpimorphisms` and note the prover confirms),
citing the underlying-abelian-sheaf exactness; and a block for the local-surjectivity step. Use
`\mathlibok` ONLY on genuine Mathlib re-exports (`Presheaf.IsLocallySurjective`,
`Sheaf.isLocallySurjective_iff_epi'`, `Scheme.isBasis_affineOpens`) — name them as Mathlib anchors.

### F. `lem:standard_cover_cofinal` (≈L3241) — reconcile to the refinement role
The cofinality content is now the "refine the local-surjectivity cover to a basic-open standard
cover in `Cov`" step inside E. Either fold it into E's sketch, or keep `lem:standard_cover_cofinal`
as the standalone "any open cover of `D(f)` is refined by a standard cover" statement that E invokes.
Keep its statement/`\lean{}` pin; adjust prose so it is clearly the refinement E uses (via
`Scheme.isBasis_affineOpens`), not an unused lemma.

### G. `lem:qcoh_iso_tilde_sections` (≈L3445) — coverage debt + 01I8 decomposition (lvb-qcoh MAJORs)
- The landed Lean is the CONDITIONAL form `[IsIso F.fromTildeΓ] → F ≅ ~(ΓF)`. The existing `% NOTE`
  already discloses this — keep it accurate.
- Add a new lemma block for `qcoh_iso_tilde_sections_of_presentation` with
  `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}`: discharges `[IsIso F.fromTildeΓ]`
  from a global `F.Presentation` via Mathlib `isIso_fromTildeΓ_of_presentation` (mark that Mathlib
  decl as a `\mathlibok` anchor). Bundle the two simp accessors `qcoh_iso_tilde_sections_hom`,
  `qcoh_iso_tilde_sections_inv` into the `\lean{...}` list of the main block (to clear coverage debt).
- In the proof block, add a short note that the current Lean body is the one-liner conditional proof
  `(asIso F.fromTildeΓ).symm`; the unconditional qcoh proof follows once the 01I8 instance lands.
- Add a remark/sub-block documenting the **01I8 3-step decomposition** (the route to
  `[IsQuasicoherent F] → IsIso F.fromTildeΓ`): (1) global generation — `[IsQuasicoherent F]` on
  `Spec R` ⟹ a global epi `free I ⟶ F` from `QuasicoherentData` + `Spec R` compactness +
  localisation-of-sections; (2) the kernel is again quasi-coherent ⟹ `F.Presentation`; (3) feed to
  `isIso_fromTildeΓ_of_presentation`. Cite Stacks Tag 01I8 / Hartshorne II.5 (use the source quote
  already present, or fetch via reference-retriever if you need the exact Hartshorne II.5.16/II.5.17
  text — verbatim only, never paraphrase as a quote).

## Out of scope
- Do NOT modify the 01EO chain blocks (L1–L4, top) — they are complete and correct.
- Do NOT change `def:basis_cov_system` field semantics (the 5-field encoding is correct).
- Do NOT add `\leanok`.

## Report
List each block you edited, what changed, and any `\uses{}` you re-wired. Flag any block where you
were unsure of the prover's eventual Lean name (so the planner can confirm the pin next iter). If you
spawned a reference-retriever, name the new `references/` file.
