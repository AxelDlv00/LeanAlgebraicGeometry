# Effort Breaker Report

## Slug
coreiso067

## Target
`lem:cechSection_complex_iso` (`AlgebraicGeometry.cechSection_complex_iso`) — specifically the
non-augmented `coreIso` residual + its degree-0 `hcompat` instance.

## Status
COMPLETE — the `coreIso` core is re-expressed as a 3-lemma chain cut at the real mathematical
seams (open-meet identity → degreewise object iso → differential commutation). The augmentation
peeling (`mapHC_augment_iso` / `map_augment_cond` / `augmentCochainIso`) was left untouched as
instructed.

## Effort before → after
- target node (archon dag): `effort 5388, deps 6` → `effort 5388, deps 9`. The displayed
  `effort` is the cone aggregate and is stable; the point of the break is that the **single
  opaque `coreIso` sorry** is now three independently-attackable typed lemmas with efforts
  595 / 1213 / 2242, each "close-or-fail-fast". The hardest residual (differential match,
  `coreIso_comm`, effort 2242) is isolated from the easy lattice fact (595) and the mechanical
  object iso (1213).
- sub-lemmas added: 3

## Chain added (target ← coreIso_comm ← coreIso_obj_iso ← coverInterOpen_inf_distrib)
- `\label{lem:coverInterOpen_inf_distrib}` `\lean{AlgebraicGeometry.coverInterOpen_inf_eq_iInf_inf}`
  — pure `Opens` lattice fact: `coverInterOpen 𝒰 σ ⊓ V = ⨅ₖ (coverOpen 𝒰 (σ k) ⊓ V)`
  (nonempty-index `inf` over `iInf` distribution). `\uses{def:cech_free_presheaf_complex}`
  (effort 595, used-by 3).
- `\label{lem:coreIso_obj_iso}` `\lean{AlgebraicGeometry.coreIso_objIso}` — degreewise object iso
  `Γ(V, pushPullObj F Y_p) ≅ ∏_σ Γ(⨅ₖ(coverOpen 𝒰 (σ k) ⊓ V), F)`, i.e.
  `((GV∘Ψ)Č(𝒰)).X p ≅ (Č(𝒰')).X p`. Proof = `pushPull_eval_prod_iso` post-composed with a
  `Pi.mapIso`/`eqToIso` reindex along seam 1.
  `\uses{lem:pushPull_eval_prod_iso, lem:coverInterOpen_inf_distrib}` (effort 1213, used-by 2).
- `\label{lem:coreIso_comm}` `\lean{AlgebraicGeometry.coreIso_comm}` — differential commutation
  square `(objIso p).hom ≫ d_{Č(𝒰')} = d_{(GV∘Ψ)Č(𝒰)} ≫ (objIso (p+1)).hom`, via
  `sectionCech_objD_apply` (alternating sum of `sectionCechFaceRestr`) read through
  `sectionCechProductEquiv`; matches each evaluated coface to the corresponding face restriction
  (same inclusion of intersection opens). Its proof body also states that the **degree-0 instance
  is exactly `hcompat`** (evaluated `cechAugmentation` through `objIso 0` = `ε`), so the prover
  discharges `hcompat` here rather than separately.
  `\uses{lem:coreIso_obj_iso, lem:section_cech_objd_apply, lem:section_cech_product_equiv,
  lem:coverInterOpen_inf_distrib}` (effort 2242, used-by 1).
- Target proof rewritten: a new "non-augmented core iso" paragraph names `objIso` (=
  `lem:coreIso_obj_iso`) and the differential match (= `lem:coreIso_comm`); the existing
  "Čech differentials" paragraph now opens "This is the content of Lemma~\ref{lem:coreIso_comm}".
  The three new labels were added to BOTH the target's statement `\uses` and proof `\uses`.

## Wiring note (statement vs proof `\uses`)
The archon dag tracks **statement-level** `\uses` only (verified: the augmentation helpers, which
sit only in the target's proof `\uses`, show `used-by 0` and are absent from `ancestors`). To
satisfy the directive's "no new node isolated" check AND register the chain edges, I mirrored the
three new labels into the target's **statement** `\uses` block as well — exactly as
`lem:pushPull_eval_prod_iso` / `lem:section_cech_objd_apply` / `lem:section_cech_product_equiv`
already appear in both blocks. This does not touch the mathematical statement, the `% NOTE:`, or
the `\lean{}` of the target (all preserved verbatim). Post-edit graph:
`coverInterOpen_inf_distrib` used-by 3, `coreIso_obj_iso` used-by 2, `coreIso_comm` used-by 1;
`isolated`/`unmatched` scans clean.

## Still hard (re-break candidates)
- `lem:coreIso_comm` (effort 2242) is the genuine remaining difficulty (the differential-match
  bookkeeping). It is already cut to a single mathematical claim — one `comm` square reusing
  `sectionCech_objD_apply` — so it is at the fine-granularity floor; if the prover still stalls,
  the next escalation is not a further blueprint break but a Lean-level helper extracting the
  per-coface "evaluated push–pull coface = `sectionCechFaceRestr`" identity. Flag for the planner.

## Could not decompose (strategy items)
- None. Every seam the original `coreIso` crossed (lattice identity, object iso, differential
  match, degree-0 augmentation) is covered by a named lemma; `hcompat` is folded into
  `coreIso_comm`'s p=0 case per the directive.

## References consulted
- None (no source-derived blocks added; all three lemmas are internal restructurings of existing
  project results — `pushPull_eval_prod_iso`, `sectionCech_objD_apply`, `sectionCechProductEquiv`,
  all verified present in `CechSectionIdentification.lean` / `CechAcyclic.lean`).

## Notes for dispatcher
- New `\lean{}` names assigned by convention (prover scaffolds these in the `AlgebraicGeometry`
  namespace):
  - `AlgebraicGeometry.coverInterOpen_inf_eq_iInf_inf` — `coverInterOpen 𝒰 σ ⊓ V = ⨅ k, (coverOpen 𝒰 (σ k) ⊓ V)`.
    Lean proof should be ~`simp [coverInterOpen]; exact iInf_inf.symm` (needs `[Nonempty (Fin (p+1))]`,
    automatic). Verify the exact Mathlib lemma name (`iInf_inf` requires `[Nonempty ι]`).
  - `AlgebraicGeometry.coreIso_objIso` — the degreewise `Ab` iso; `pushPull_eval_prod_iso 𝒰 F p V`
    `≪≫ Pi.mapIso (fun σ => eqToIso (congrArg (fun W => Fp.presheaf.obj (op W)) (coverInterOpen_inf_eq_iInf_inf …)))`.
  - `AlgebraicGeometry.coreIso_comm` — the per-`(p,p+1)` `comm` square; both `objIso` and the
    differentials are `Ab` maps, so check on elements via `sectionCechProductEquiv` + `sectionCech_objD_apply`.
- All three lean names confirmed FREE (no existing decl) before assignment.
- `coverInterOpen` / `coverOpen` live under `def:cech_free_presheaf_complex` (used as seam-1 `\uses`).
- The prover assembles `coreIso := HomologicalComplex.Hom.isoOfComponents coreIso_objIso coreIso_comm`
  inline in `cechSection_complex_iso` (the existing `have coreIso : … := sorry` at
  `CechSectionIdentification.lean:1489`), and discharges the `hcompat` sorry (line 1504) as the
  `p=0` component of the same `coreIso_comm` reasoning.
