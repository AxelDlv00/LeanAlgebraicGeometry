# Blueprint Writer Directive

## Slug
quot-hfr

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Strategy context
gap1 (the QCoh≃Mod affine descent keystone: `IsQuasicoherent M → IsIso M.fromTildeΓ` on `Spec R`) is
decomposed C → P1 → D → assembly. C (`overRestrictIso`) and P1 (`isIso_fromTildeΓ_restrict_basicOpen`, the
per-affine local-tilde) are DONE. D (the section-localization descent, Stacks `lemma-invert-f-sections` /
Hartshorne II.5.3) landed this iter in **cover-hypothesis form** as the public, axiom-clean theorem
`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover`. The remaining gate to the
*named* form `isLocalizedModule_basicOpen_descent` (and hence gap1) is producing the per-piece data `Hfr`
via the **slice→`Spec R_r` SECTION transport**.

## Required content

1. **Add a dedicated block `lem:section_localization_descent_of_cover`** for the landed cover-form keystone
   (checker iter-035 flagged it as a public, fully-proved keystone with NO blueprint block — primary
   coverage finding). Pin `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover}`.
   Statement: for `M : (Spec R).Modules`, `f : R`, a finite basic-open cover `{D(r)}_{r∈t}` with
   `Ideal.span t = ⊤`, and per-piece data
   `Hfr : ∀ U, (∃ r ∈ t, U ≤ D(r)) → IsLocalizedModule (powers f) (Γ(M,U) → Γ(M, D(f) ⊓ U))`, the global
   section restriction `Γ(M,⊤) → Γ(M, D(f))` is `IsLocalizedModule (powers f)`. Proof sketch (the three
   `IsLocalizedModule` fields): `map_units` from `map_units_restrict_basicOpen` (arbitrary `M`); `surj` by
   per-`D(r)` surjectivity with a common power `N`, overlap agreement up to a further power `P`, then gluing
   the `f^P`-scaled family by the sheaf condition and concluding on `D(f)` by separatedness; `exists_of_eq`
   by a global section vanishing on `D(f)` being killed by a power of `f` (per cover element + finite sup +
   separatedness). It does NOT route through the global `QCoh≃Mod` equivalence (= gap1 itself).
   `\uses{lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent, lem:exists_finite_basicOpen_cover_le_quasicoherentData,
   lem:map_units_restrict_basicOpen}` plus Mathlib gluing anchors (see item 3). Keep the existing
   `lem:section_localization_descent` (named form) block as a future target with its `% NOTE`.

2. **Add the `Hfr` SECTION-TRANSPORT sub-lemma block** — the iter-036 prover target, the named ingredient
   that closes the gap. State the project infrastructure lemma:
   > For an open immersion `j : U ↪ X` of schemes (here `j = Opens.ι (q.X i)` a quasi-coherence chart) and
   > a module `M : X.Modules`, the global sections of the pullback module along `j` are naturally
   > isomorphic to the sections of `M` over the image: `Γ((pullback j).obj M, ⊤) ≅ Γ(M, range j)`, natural
   > in the open argument (intertwining the restriction maps).
   Then describe how chaining this through P1's two further pullbacks (`isoSpec.inv`, the basic-open ι's)
   identifies `Γ(M'_transported, ⊤) ≅ Γ(M, D(r))` and `Γ(M'_transported, D(f')) ≅ Γ(M, D(f) ⊓ D(r))`
   intertwining the restriction maps, which together with P1's `IsIso fromTildeΓ` and
   `isLocalizedModule_restrict_of_isIso_fromTildeΓ` yields `Hfr`. Note that once `Hfr` lands, the named
   `isLocalizedModule_basicOpen_descent` and gap1 (`isIso_fromTildeΓ_of_isQuasicoherent`) are both
   one-liners (`isLocalizedModule_basicOpen_descent_of_cover …` and
   `isIso_fromTildeΓ_of_isLocalizedModule_restrict`). This pullback-along-open-immersion section comparison
   is the slice→`Spec R_r` transport, Mathlib-absent at the pinned commit (the SECTION analogue of P1's
   OBJECT transport). `\uses{lem:over_restrict_iso, lem:over_restrict_pullback_iso,
   lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ}`
   (adjust to the real labels present in the chapter). This block is project-bespoke infrastructure (no
   external verbatim source for the construction itself — stands on its sketch).

3. **Optional Mathlib dependency anchors** (only if the chapter does not already have them) for the sheaf
   gluing facts the cover-form proof relies on, with `\mathlibok` and the real `\lean{}`:
   `TopCat.Sheaf.existsUnique_gluing'`, `TopCat.Sheaf.eq_of_locally_eq'`. If anchors already exist
   (`lem:existsUnique_gluing_mathlib`, `lem:eq_of_locally_eq_mathlib`), just `\uses{}` them — do not
   duplicate.

## Out of scope
- The 4 protected stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`).
- gap1 assembly proper (`isIso_fromTildeΓ_of_isQuasicoherent`) — a one-liner after Hfr, leave its NOTE.
- G1-core, the annihilator forward characterization, P2 local-freeness.
- The 5 private descent helpers (`descent_surj`/`descent_smul_eq_zero`/`descent_overlap_agree`/`res_comp`/
  `iSup_basicOpen_subtype_eq_top`) — private, owe no blueprint block by the project convention.
- Any `\leanok` marker.

## References
- `references/stacks-properties.md` → `references/stacks-properties.tex`: tag `lemma-invert-f-sections`
  (`\label` ~line 2153, §"Sections over principal opens"): for a qcqs scheme `X` and `f ∈ Γ(X,𝒪_X)`,
  `Γ(X,ℱ)_f ≅ Γ(X_f,ℱ)` for quasi-coherent `ℱ` (= Hartshorne II.5.3). Cite this verbatim for the
  `lem:section_localization_descent_of_cover` block. Use `Read offset:2150 limit:24`.
- `references/hartshorne-algebraic-geometry.md` (II.5.3) — background companion.

## Expected outcome
The chapter has a `lem:section_localization_descent_of_cover` block for the landed cover-form keystone
(verbatim Stacks `lemma-invert-f-sections` source quote) and a new project-bespoke block for the `Hfr`
section-transport ingredient (`Γ(pullback j M,⊤)≅Γ(M, range j)`), `\uses`-wired, that the iter-036
mathlib-build prover formalizes. The named `isLocalizedModule_basicOpen_descent` block remains a future
target. No `\leanok` touched.
