# Blueprint-writer directive — decompose the section-Čech coface match + clear coverage debt

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this file).

## Strategy context (the slice that matters)

Route P3 proves `sectionCech_affine_vanishing` = positive-degree homology vanishing of the
absolute section Čech complex on `Spec R`. The chain is:
`dDiff_exact` (un-localised module complex `D•` exact, DONE) → identify the section Čech
complex with `D•` degreewise → transport exactness → homology vanishes.

The iter-021 prover landed the **abstract** half of the identification but is blocked on the
**tilde F-bridge**: the section Čech complex `sectionCechCosimplicial` reads sections via the
`AddCommGrp`-valued accessor `((toPresheafOfModules (Spec R)).obj G).presheaf.obj (op (D s_σ))`,
whereas the proved localisation facts (`qcohSectionsAwayLocalized`) speak of the `ModuleCat`-valued
`modulesSpecToSheaf`/`tilde.toOpen` sections. Reconciling these into a per-coordinate `AddEquiv` +
naturality square is the one remaining ingredient. The current blueprint presents
`lem:section_cech_coface_match` as a MONOLITH (single `\lean{sectionCechCofaceMatch}`), which gives
the prover no roadmap for the abstract-vs-tilde split — this is the documented adequacy gap (iter-021
lean-vs-blueprint-checker) and the direct cause of the stall.

## Decision already made (encode it; do NOT re-open it)

Prove the coface match and homology vanishing for **`F = tilde M` first** (the gap-free case),
using `qcohRestriction_eq_comparison` directly. The general quasi-coherent `F` via `F ≅ tilde(ΓF)`
(Stacks 01I8) is a separately-deferred globalisation gap — keep the existing `% NOTE:` about it but
make clear the active target is the tilde case.

## Required edits

### 1. Decompose `lem:section_cech_coface_match` into TWO sub-steps, with a NEW sub-lemma for the abstract half.

Add a new lemma block BEFORE `lem:section_cech_coface_match`:

- **`lem:section_cech_objd_apply`** — "Abstract cosimplicial unfold of the section Čech
  differential." `\lean{AlgebraicGeometry.sectionCech_objD_apply, AlgebraicGeometry.sectionCechFaceRestr}`.
  `\uses{def:section_cech_complex, lem:section_cech_product_equiv}`. State: read through the product
  equivalence (`sectionCechProductEquiv`), the underlying group action of the degree-`q` differential
  `objD q` of `alternatingCofaceMapComplex (sectionCechCosimplicial U F)` is
  `∑ᵢ (-1)ⁱ • (sectionCechFaceRestr U F σ i)(x (σ ∘ (δ i).toOrderHom))`, where
  `sectionCechFaceRestr` is the `i`-th presheaf face restriction
  `F.presheaf.obj(op(⨅_l U(σ(δᵢ l)))) ⟶ F.presheaf.obj(op(⨅_k U(σ k)))`. PURELY cosimplicial — NO
  sheaf/localisation identification. Proof sketch: unfold `objD` (alternating sum of cosimplicial
  cofaces, each a `Pi.lift` projecting to `σ ∘ d_j`), push through `sectionCechProductEquiv_apply`
  and `Concrete.productEquiv_apply_apply`. This is the abstract shape of `SectionCechModule.dDiff`.

Then REWRITE `lem:section_cech_coface_match` (keep `\lean{AlgebraicGeometry.sectionCechCofaceMatch}`,
still aspirational/to-be-built) so it `\uses{lem:section_cech_objd_apply, def:qcoh_sections_localized,
def:section_cech_module_complex}` and its proof EXPLICITLY layers:
  (i) the abstract unfold of `lem:section_cech_objd_apply` (gives the alternating sum of
      `sectionCechFaceRestr`), then
  (ii) the **tilde F-bridge**: for `F = tilde M`, each `sectionCechFaceRestr σ i` equals, under a
      per-coordinate `AddEquiv` `φ_σ : ToType(((toPresheafOfModules (Spec R)).obj (tilde M)).presheaf.obj
      (op (D s_σ))) ≃+ LocalizedModule (powers s_σ) M`, the localisation coface
      `SectionCechModule.dCoface`. Spell out that `φ_σ` is the canonical `IsLocalizedModule` iso
      (both sides localise `M` at `Submonoid.powers s_σ`; `qcohSectionsAwayLocalized` +
      `basicOpen_sprod` + `IsLocalizedModule.iso`/uniqueness), and the naturality square
      `φ_σ ∘ sectionCechFaceRestr σ i = dCoface ∘ φ_{σ∘δᵢ}` is `qcohRestriction_eq_comparison`.
      Note the accessor reconciliation `((toPresheafOfModules …).obj G).presheaf.obj` vs.
      `modulesSpecToSheaf`/`tilde.toOpen` ModuleCat sections is the new infrastructure this step owns.

### 2. Rewrite `lem:section_cech_ab_exact` to expose the homological precursor.

Add `AlgebraicGeometry.sectionCech_isZero_homology_of_objD_exact` and the private helper
`AlgebraicGeometry.ab_hom_finsetSum_apply` to its `\lean{...}` list (alongside the still-aspirational
`AlgebraicGeometry.sectionCechAbExact`). Update the proof sketch to a two-layer form:
  - `sectionCech_isZero_homology_of_objD_exact` (DONE): `IsZero (homology (q+1))` *given*
    `Function.Exact` of the underlying maps of two consecutive `objD` — via
    `exactAt_iff_isZero_homology` + `HomologicalComplex.exactAt_iff'` +
    `ShortComplex.ab_exact_iff_function_exact`.
  - the unconditional `sectionCechAbExact` discharges that hypothesis by the LADDER transport
    (`Function.Exact.of_ladder_addEquiv_of_exact`, `Mathlib.Algebra.Exact.Basic`): the degreewise
    AddEquiv `e_p = sectionCechProductEquiv ▸ ∏_σ φ_σ`, the two commuting squares from
    `lem:section_cech_objd_apply` (decl `sectionCech_objD_apply`) + the coface match
    (`lem:section_cech_coface_match`), and `H = dDiff_exact` (`lem:section_cech_module_exact`).

### 3. Add the missing `\lean{...}` coverage for the remaining debt decls.

- Add `AlgebraicGeometry.sectionCechProductEquiv_apply` to the `\lean{...}` of
  `lem:section_cech_product_equiv`.
- (`sectionCechFaceRestr`, `sectionCech_objD_apply` handled by step 1's new
  `lem:section_cech_objd_apply` block.)
- (`sectionCech_isZero_homology_of_objD_exact`, `ab_hom_finsetSum_apply` handled by step 2.)

After your edits ALL FIVE of these currently-unmatched Lean decls must be named in some block's
`\lean{...}`: `ab_hom_finsetSum_apply`, `sectionCechFaceRestr`, `sectionCechProductEquiv_apply`,
`sectionCech_isZero_homology_of_objD_exact`, `sectionCech_objD_apply`.

### 4. Keep `lem:section_cech_homology_exact` and `lem:cech_acyclic_affine` (§section form) consistent.

These already `\uses` the sub-lemmas; just make sure their `\uses` lists reference the new
`lem:section_cech_objd_apply` where the abstract unfold is needed, and the prose mentions the tilde
case is the active target (general `F` deferred to 01I8).

## Citation discipline

The relevant Stacks tags (01HV for `Γ(D(f), M^~) = M_f`, 01I8 for `F ≅ tilde(ΓF)`) are already
cited in this chapter. If you add a `% SOURCE QUOTE` for the localisation-of-sections fact, quote
verbatim from `references/stacks-schemes.tex` (tag 01HV, lines ~692–728). Do NOT invent quotes; if
you need a source you do not have, you are authorized (`references/**` in your write domain) to spawn
a reference-retriever, but this should not be necessary — the facts are already cited.

## Out of scope
- Do NOT touch the FreePresheafComplex blocks (`lem:cech_free_*`, `lem:free_cech_engine`) — that lane
  is independently gate-cleared.
- Do NOT add `\leanok` anywhere (deterministic sync owns it).
- Do NOT renumber or rewrite the P5a/P5b/P4 blocks.

## If a strategy-level issue surfaces
Report it under "Strategy-modifying findings" — do not silently encode a route change.
