# Blueprint Writer Report

## Slug
bw-dual263

## Status
COMPLETE — both the linearity-step gap and the two leg-B `\lean{}` hints are addressed; edits confined to `lem:slice_dual_transport`.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made
- **Revised** `lem:slice_dual_transport` proof, "Inverse, linearity, and naturality" paragraph
  (~L5739–5778) — split the previous thin one-sentence linearity remark into an explicit
  two-step structure inside a new `enumerate`:
  - (i) a required *first* move identifying the `internalHomObjModule` add/scalar actions
    (the pointwise internal-hom module structure formed at the slice terminal object
    `Over.mk (id_{fV})`, \cref{def:presheaf_internal_hom_slice_value}) with the underlying
    `PresheafOfModules.Hom`-level pointwise add/scalar actions — an *a priori distinct*
    presentation of the same group of dual sections. Records that `map_add`/`map_smul`
    cannot be read off the change-of-rings compatibility until this identification is made.
  - (ii) on the morphism level, additivity/`\(\mathcal{O}_Y(V)\)`-linearity follow from
    functoriality of `restrictScalars β_W` on sums/scalar multiples plus the structure-scalar
    intertwining of the ring iso — the presheaf-level shadow of
    \cref{lem:restrictscalars_ringiso_dualequiv}.
  - Kept the existing inverse-equivalence sentence and the `Subsingleton.elim` naturality
    sentence intact.
- **Revised** `lem:slice_dual_transport` proof, Leg (B) paragraph (~L5730, L5733) — added two
  inline `\lean{}` hints on the sentences describing the named DualInverse.lean decls:
  - `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}` on the `codomainMap := inv ε`
    construction sentence.
  - `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}` on the
    "`ε` is invertible because `g` is a ring isomorphism" sentence.
  Both decl names verified against
  `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (defs at L177, L191, inside the
  `AlgebraicGeometry` › `Scheme` › `Modules` namespace stack, L162–166) — names match exactly.

## Cross-references introduced
- `\cref{def:presheaf_internal_hom_slice_value}` (the `internalHomObjModule` block) added in the
  linearity step — verified present in this same chapter at L5186/`\label{def:presheaf_internal_hom_slice_value}`.
- `\cref{lem:restrictscalars_ringiso_dualequiv}` reused (already in the block's `\uses`).

## References consulted
None — this is project-bespoke construction prose; no external citation block was added or
required (per directive's "Out of scope"). The existing Stacks citation on the sibling
`lem:dual_restrict_iso` was left untouched.

## Macros needed (if any)
None — used only existing macros (`\cref`, `\lean`, `\mathtt`, `\emph`, `enumerate`).

## Notes for Plan Agent
- The directive's `\cref{lem:...internalHomObjModule}` placeholder resolves to the existing
  `\definition` labelled `def:presheaf_internal_hom_slice_value` (the block whose `\lean{}` is
  `PresheafOfModules.InternalHom.internalHomObjModule`); I used that label.
- No `\leanok`/`\mathlibok` markers were touched. The block already carries a `\leanok` on the
  statement from a prior sync; left as-is (deterministic phase owns it).

## Strategy-modifying findings
None.
