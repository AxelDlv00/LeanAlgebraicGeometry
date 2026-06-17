# Blueprint Writer Report

## Slug
02kg

## Status
COMPLETE — both jobs done; leandag reports no unknown_uses, no conflicts (acyclic),
and zero isolated blocks in this chapter.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### JOB 1 — reconcile

- **Revised** `def:basis_cov_system` — rewrote prose to describe the ACTUAL five-field Lean
  structure (B, Cov, `faces_mem`, `surj_of_vanishing`, `injective_acyclic`). Replaced the
  false "cofinality datum stated in the shape consumed by `ses_cech_h1`" sentence with the
  `surj_of_vanishing` OUTPUT-field description; ADDED the fifth field `injective_acyclic`
  (injective Čech-acyclicity); DELETED the "carries no colimit or derived-functor machinery"
  claim and noted instead that the structure carries two sheaf-theoretic (Čech-cohomology)
  fields. Updated `\uses{}` → `def:cech_complex, lem:ses_cech_h1, lem:injective_cech_acyclic`.
  Appended `AlgebraicGeometry.CovDatum` to the `\lean{}` list (coverage debt). Documented the
  `CovDatum = Σ ι, ι → Opens X` helper inline.
- **Revised** `lem:absolute_cohomology_pos_vanishing` (L4) — (b) rewrote the geometric-input
  paragraph so section surjectivity `I(V_σ)→Q(V_σ)` comes from the `surj_of_vanishing` field
  applied to the SES, left-term Čech-vanishing supplied by `HasVanishingHigherCech`; kept the
  math identical (still notes `ses_cech_h1` as the field's packaged content). Added
  `AlgebraicGeometry.injSES, AlgebraicGeometry.injSES_shortExact` to the `\lean{}` list. (c)
  Added the `[EnoughInjectives X.Modules]` instance-hypothesis disclosure to the statement.
- **Revised** `lem:cech_to_cohomology_on_basis` (top) — (c) added the
  `[EnoughInjectives X.Modules]` disclosure (inherited from L4).
- **Revised** `lem:face_ses_of_sheaf_ses` — (d) added `AlgebraicGeometry.sectionsFunctor` to
  the `\lean{}` list (coverage debt).
- **Revised** `lem:cech_acyclic_affine` — (e) REMOVED the dead `AlgebraicGeometry.CechAcyclic.affine`
  from the `\lean{}` list and updated the explanatory comment to note the de-pin. (Confirmed via
  leandag: this dead decl is now correctly an orphaned `lean_aux` node — see Notes.)

### JOB 2 — decompose `lem:affine_serre_vanishing` (Tag 02KG)

- **Revised** `lem:affine_serre_vanishing` — added `[EnoughInjectives]` disclosure (c); rewrote
  `\uses{}` (statement + proof) to `def:affine_cover_system, lem:affine_cech_vanishing_qcoh,
  lem:cech_to_cohomology_on_basis, def:absolute_cohomology`; rewrote the proof to assemble the
  affine cover system, supply the qcoh seed as `HasVanishingHigherCech`, and apply the 01EO top
  lemma at each distinguished open (taking V=U for the whole affine).
- **Added** `\definition` `def:affine_cover_system` / `\lean{AlgebraicGeometry.affineCoverSystem}`
  — the affine `BasisCovSystem` (B = distinguished opens, Cov = standard covers); fields by
  sub-lemmas (2)(4)(5). `\uses{def:basis_cov_system, lem:affine_faces_mem,
  lem:affine_surj_of_vanishing, lem:affine_injective_acyclic}`.
- **Added** `\lemma` `lem:affine_faces_mem` / `AlgebraicGeometry.affine_faces_mem` — D(f)∩D(g)=D(fg);
  faces of a standard cover are standard. Source: Schemes `lemma-standard-open` prose. Proof sketch: Y.
- **Added** `\lemma` `lem:standard_cover_cofinal` / `AlgebraicGeometry.standard_cover_cofinal` —
  standard covers cofinal among open covers of a distinguished open. Sources: Schemes
  `lemma-standard-open`(2) + Sheaves Tag 009L `lemma-cofinal-systems-coverings-standard-case`. Proof: Y.
- **Added** `\lemma` `lem:affine_surj_of_vanishing` / `AlgebraicGeometry.affine_surj_of_vanishing` —
  discharges `surj_of_vanishing`. `\uses{lem:ses_cech_h1, lem:standard_cover_cofinal}`. Source:
  Cohomology `lemma-ses-cech-h1`. Proof: Y.
- **Added** `\lemma` `lem:cover_datum_bridge` / `AlgebraicGeometry.coverDatum_bridge` —
  project-bespoke CovDatum ↔ open-cover identification (no source). `\uses{def:basis_cov_system}`. Proof: Y.
- **Added** `\lemma` `lem:affine_injective_acyclic` / `AlgebraicGeometry.affine_injective_acyclic` —
  discharges `injective_acyclic`. `\uses{lem:injective_cech_acyclic, lem:cover_datum_bridge}`. Source:
  Cohomology `lemma-injective-trivial-cech`. Proof: Y.
- **Added** `\lemma` `lem:qcoh_iso_tilde_sections` / `AlgebraicGeometry.qcoh_iso_tilde_sections` —
  F ≅ ~(Γ F) on an affine, Γ(D(f),F)=M_f. Source: Schemes Tag 01HV `lemma-spec-sheaves` (+ 01I8). Proof: Y.
- **Added** `\lemma` `lem:affine_cech_vanishing_qcoh` / `AlgebraicGeometry.affine_cech_vanishing_qcoh` —
  the `HasVanishingHigherCech` SEED for qcoh F, by reduction to the tilde case. `\uses{lem:cech_acyclic_affine,
  lem:qcoh_iso_tilde_sections, def:affine_cover_system, def:has_vanishing_higher_cech}`. Source:
  Tag 02KG proof condition (3). Proof: Y.

All new `\lean{}` names are scaffold targets in the planned file
`AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` (do not yet exist; flagged for planner
confirmation per directive).

## Cross-references introduced
- All new `\uses{}` resolve (leandag `unknown_uses: []`). Targets used that live in this chapter:
  `def:basis_cov_system`, `lem:ses_cech_h1`, `lem:injective_cech_acyclic`, `lem:cech_acyclic_affine`,
  `def:standard_affine_cover`, `def:has_vanishing_higher_cech`, `lem:cech_to_cohomology_on_basis`,
  `def:absolute_cohomology` — all present in this same chapter.
- New intra-chain edges form an acyclic sub-DAG rooted at `lem:affine_serre_vanishing` (verified:
  leandag `conflicts: []`).

## References consulted
- `references/stacks-schemes.tex` — L513–517 (intersection of standard opens, `D(f)∩D(g)=D(fg)`)
  for `lem:affine_faces_mem`; L531–532 + L573–577 (`lemma-standard-open`(2), cofinality prose) for
  `lem:standard_cover_cofinal`; L691–719 (Tag 01HV `lemma-spec-sheaves`, Γ(D(f),~M)=M_f) for
  `lem:qcoh_iso_tilde_sections`.
- `references/stacks-sheaves.tex` — L3861–3879 (Tag 009L `lemma-cofinal-systems-coverings-standard-case`)
  for `lem:standard_cover_cofinal`.
- `references/stacks-cohomology.tex` — L1592–1605 (`lemma-ses-cech-h1`) for `lem:affine_surj_of_vanishing`;
  L1407–1422 (`lemma-injective-trivial-cech`) for `lem:affine_injective_acyclic`.
- `references/stacks-coherent.tex` — L160–163 (Tag 02KG proof, basis/Cov choice) for
  `def:affine_cover_system`; L172–173 (Tag 02KG proof, condition (3)) for `lem:affine_cech_vanishing_qcoh`.
- `references/summary.md` — source index.

## Macros needed (if any)
- None. All new prose uses existing macros / standard math; `\mathrm{...}` for field names.

## Reference-retriever dispatches (if any)
- None — all required sources were already local.

## Notes for Plan Agent
- **Dead Lean decl, planner/prover action:** after de-pinning, leandag shows exactly one isolated
  node project-wide: the `lean_aux` `AlgebraicGeometry.CechAcyclic.affine`
  (`CechAcyclic.lean:110`, carries a `sorry`, used by nothing). It is no longer pinned to any
  blueprint block. Recommend a prover delete the dead declaration from `CechAcyclic.lean` so the
  isolated node clears entirely; this is a `.lean` edit, out of my write-domain.
- **Scaffold `\lean{}` names to confirm:** the eight new 02KG sub-lemma/definition pins target the
  planned file `AffineSerreVanishing.lean` and do not yet exist in Lean. Names chosen:
  `affineCoverSystem`, `affine_faces_mem`, `standard_cover_cofinal`, `affine_surj_of_vanishing`,
  `coverDatum_bridge`, `affine_injective_acyclic`, `qcoh_iso_tilde_sections`,
  `affine_cech_vanishing_qcoh` (all in namespace `AlgebraicGeometry`). Confirm/adjust next iter.
- **EnoughInjectives:** the disclosure prose on L4/top/02KG matches the Lean file's
  `[EnoughInjectives X.Modules]` convention; if a real instance lands (via
  `IsGrothendieckAbelian (SheafOfModules R)`), these sentences should be pruned.

## Strategy-modifying findings
- None. The 02KG decomposition instantiates the completed 01EO criterion as the strategy assumes;
  no strategy-level gap surfaced.
