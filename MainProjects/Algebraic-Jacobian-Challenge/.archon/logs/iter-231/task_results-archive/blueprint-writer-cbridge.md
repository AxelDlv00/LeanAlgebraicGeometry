# Blueprint Writer Report

## Slug
cbridge

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Added lemma** `\lemma` / `\label{lem:dual_restrict_iso}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` — inserted immediately before
  `lem:dual_isLocallyTrivial`. States the C-bridge: for an open immersion `f : Y ↪ X` (image
  `U ⊆ X`) and `M ∈ X.Modules`, a natural iso `(dual M)|_f ≅ dual (M|_f)` of `𝒪_Y`-modules.
  - Proof sketch added: Y, the CORRECT route (NOT `overSliceSheafEquiv`). Built at the
    presheaf-of-modules level, objectwise in the open `V ⊆ U`, from the three ingredients the
    directive specified:
    (a) the per-`V` slice equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)` — the per-open
    shadow of `TopologicalSpace.Opens.overEquivalence`, valid because `f` is an open immersion
    so `f.opensFunctor` is fully faithful with image `{W ≤ U}`;
    (b) the codomain is the structure sheaf, which agrees on opens `≤ U`;
    (c) the ring-iso transport: `β_V = (toRingCatSheafHom f).hom_V` is a sectionwise ring iso,
    so `restrictScalars β` is an equivalence (`restrictScalars_isEquivalence_of_ringEquiv`),
    whose ModuleCat-level shadow on duals is `lem:restrictscalars_ringiso_dualequiv`.
    The sketch states explicitly this is a genuine natural iso (NOT `rfl` / not "literally
    equal" / not "identity on values"), the favorable open-immersion case where flat +
    finitely-presented hypotheses are automatic, with the substantive content concentrated in
    the module-structure transport (c) while the slice-reindexing coherence (a) is light
    (thin poset, `Subsingleton.elim`).
  - Citation: `% SOURCE:` + verbatim `% SOURCE QUOTE:` of Stacks
    `lemma-pullback-internal-hom` (`f^*ℋom(F,G) ≅ ℋom(f^*F, f^*G)` for `f` flat, `F` finitely
    presented), copied character-by-character from `references/stacks-modules.tex`
    L3710–L3721, plus visible `\textit{Source: ...}` line.

- **Revised** `lem:dual_isLocallyTrivial` proof body — REPLACED the empirically-falsified
  `overSliceSheafEquiv`-discharge paragraph (and the stale `% NOTE … EMPIRICALLY FALSIFIED`
  route note) with the correct three-step chain:
  `(dual L)|_U ≅ dual(L|_U)` [by `lem:dual_restrict_iso`]
  `≅ dual 𝒪_U`     [by `dualIsoOfIso`, `def:scheme_modules_dual_iso_of_iso`]
  `≅ 𝒪_U`          [by `dual_unit_iso`, evaluation at 1].
  The falsified "first three steps run verbatim as for the tensor / residual is the pushforward
  comparison" narrative is gone; the crux is now the single named lemma `lem:dual_restrict_iso`.

- **Revised** `\uses{}` of `lem:dual_isLocallyTrivial` (statement AND proof) — dropped
  `lem:tensorobj_restrict_iso`; now `lem:internal_hom_isSheaf, lem:dual_restrict_iso,
  def:scheme_modules_dual_iso_of_iso, lem:restrictscalars_ringiso_dualequiv`. No
  `lem:open_immersion_slice_sheaf_equiv` reference remains in either C-bridge block.

## Cross-references introduced
- `\uses{lem:dual_restrict_iso}` in `lem:dual_isLocallyTrivial` — target now exists in this chapter.
- `\uses{def:scheme_modules_dual_iso_of_iso}` in `lem:dual_isLocallyTrivial` (the `dualIsoOfIso`
  step) — exists in this chapter (line ~2825).
- `\uses{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}` in
  `lem:dual_restrict_iso` — both exist in this chapter.
- `dual_unit_iso` (third chain step) is referenced by its Lean name in prose only; it has NO
  blueprint label, so no `\cref`/`\uses` was added for it (see Notes).

## References consulted
- `references/stacks-modules.tex` — verbatim `% SOURCE QUOTE` for `lem:dual_restrict_iso` is
  `lemma-pullback-internal-hom`, L3710–L3721 (`f^*ℋom(F,G) ≅ ℋom(f^*F,f^*G)`, `f` flat, `F`
  finitely presented); also read `\S Internal Hom` (L3490–L3535) for the internal-hom /
  evaluation provenance.
- `references/stacks-modules.md` — confirmed chapter 17 "Modules on Ringed Spaces" provenance
  and that the internal-hom section sits in tag area 01CM / 01CR neighbourhood.

## Macros needed (if any)
- None. `\hookrightarrow`, `\xrightarrow`, `\SheafHom` (in comment only), `\Scheme`,
  `\mathtt`, etc. are all already used elsewhere in this chapter.

## Notes for Plan Agent

- **Directive label `def:scheme_modules_dual` does not exist.** The directive asked for
  `\uses{def:scheme_modules_dual, ...}` on `lem:dual_restrict_iso`. There is no such label in
  the blueprint; the scheme-level dual `AlgebraicGeometry.Scheme.Modules.dual` is defined inside
  `lem:internal_hom_isSheaf` (`\lean{...Scheme.Modules.dual}`, line ~2680). I used
  `lem:internal_hom_isSheaf` in the `\uses` instead. If a standalone `def:scheme_modules_dual`
  label is desired, that would be a separate edit.

- **`dual_unit_iso` has no blueprint declaration block.** The required chain step
  `dual 𝒪_U ≅ 𝒪_U` (evaluation at 1) is referenced only by Lean name in the
  `lem:dual_isLocallyTrivial` proof prose. There is currently no `\lemma`/`\label` for it in
  this chapter (memory indicates it is an in-progress Lean decl blocked on `𝟙_` unit-`1`
  plumbing). Consider adding a `lem:dual_unit_iso` block so the dependency graph is complete;
  the directive did not ask me to add it, so I left it as a prose reference.

- **Now-stale cross-claim in the A-engine block (OUT OF SCOPE, not edited).** The proof of
  `lem:sheafofmodules_hom_of_local_compat` (lines ~3172–3175 and ~3204–3206) still asserts that
  "the dual restriction-iso (`lem:dual_isLocallyTrivial`) consumes the functor-direction face of
  the same equivalence; that the two share `lem:open_immersion_slice_sheaf_equiv` as a common
  root is why the shared bridge unblocks both at once." After this rewrite that is **false** —
  the C-bridge no longer uses `overSliceSheafEquiv` at all. My directive explicitly forbade
  rewriting the A-engine block beyond `\uses` corrections, so I left these two sentences intact.
  They should be corrected (the "shared root unblocks both" rationale no longer holds) in a
  follow-up A-engine pass; the A-engine's own use of `overSliceSheafEquiv` is unaffected and
  remains valid.

## Strategy-modifying findings
None. The rewrite reflects the iter-230 empirical finding (already settled) that the C-bridge
residual is a presheaf-level, varying-ring-module comparison and is discharged by the objectwise
slice + ring-iso route, not by the fixed-value-category sheaf-site equivalence. This is a
proof-recipe correction within the existing route, not a strategy change.
