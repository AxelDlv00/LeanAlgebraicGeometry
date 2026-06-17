# Blueprint Writer Report

## Slug
ts216

## Status
COMPLETE — all four required edits applied to `Picard_TensorObjSubstrate.tex`; the
associator is re-routed to the direct gluing construction, H2 is recorded as closed
with H1 as the sole residual, the seven route-(e) blocks are marked superseded, and
the commutative-group lemma is framed `monoidOfSkeletalMonoidal`-style.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Rewrote `lem:tensorobj_assoc_iso` (statement + proof)** — directive item 1.
  - Statement: dropped the `\uses{lem:jw_ismonoidal}` / route-(e) framing (now
    `\uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}`); removed the
    "API-derived associator" NOTE; stated the iso is built for arbitrary modules and
    the `IsLocallyTrivial` pins are vestigial-to-the-construction.
  - Proof: replaced the `LocalizedMonoidal` / three-step-whiskering composite with
    the **direct gluing route** — on each cover member `U`, the canonical composite
    `((M⊗N)⊗P)|_U ≅ (M|_U⊗N|_U)⊗P|_U ≅ M|_U⊗(N|_U⊗P|_U) ≅ (M⊗(N⊗P))|_U` (two
    `tensorobj_restrict_iso` applications each side + the canonical presheaf
    associator `PresheafOfModules.monoidalCategoryStruct.associator`), overlap
    agreement by naturality of `restrict_iso` and of the presheaf associator, glued
    via "internal-Hom of sheaves of modules is a sheaf". Explicitly states NO
    whiskering, NO `(J.W).IsMonoidal`, NO stalks. Discharges the analogist caveat:
    the associator is **global data** (stronger than the pointwise-existence
    `lem:tensorobj_preserves_locally_trivial`), so the overlap-naturality
    compatibility is proved before gluing.

- **Rewrote `lem:tensorobj_restrict_iso` Step 3** — directive item 2.
  - H2 (strong-monoidal `restrictScalars` along a ring iso) recorded as **closed
    in-file** as `restrictScalarsRingIsoTensorEquiv`; removed the iter-215 plan-agent
    NOTE comment.
  - Residual now stated as **H1 alone**: presheaf-level `pushforward β ≅ pullback φ`
    via `Adjunction.leftAdjointUniq`, built from a presheaf-level pushforward
    adjunction (analogue of sheaf-level `SheafOfModules.pushforwardPushforwardAdj`),
    requiring presheaf-level `pushforwardNatTrans` / `pushforwardCongr` — stated
    honestly as Mathlib-absent (only sheaf versions exist;
    `Sheaf/PushforwardContinuous.lean`) with **uncertain, possibly multi-iter** depth.
  - Closing paragraph re-pointed: this lemma is consumed by the gluing associator
    `lem:tensorobj_assoc_iso` (twice per cover member), NOT by the now-vestigial
    `lem:islocallyinjective_whisker_of_W`.
- **Added lemma** `\label{lem:restrictscalars_ringiso_tensorequiv}` /
  `\lean{restrictScalarsRingIsoTensorEquiv}` — directive item 2. Statement-only block
  (no proof env, no marker): base change `a ⊗_R b ↦ a ⊗_S b` along a ring iso
  `e : R ≃ S` is an `R`-linear equivalence; `restrictScalars_e` is strong monoidal;
  notes the inverse is additive-not-`S`-linear. `\uses{lem:tensorobj_restrict_iso}`.

- **Marked 7 vestigial blocks** with a prepended prose supersession banner (NOT a
  marker; no `\leanok`/`\mathlibok` touched) — directive item 3:
  `lem:flat_whisker_localizer`, `lem:isiso_sheafification_map_of_W`,
  `sec:tensorobj_route_e` (section-level banner after the label),
  `lem:stalk_linear_map`, `lem:islocallyinjective_whisker_of_W`,
  `lem:whisker_of_W`, `lem:jw_ismonoidal`. Each banner states the coherent-monoidal /
  sheafification-whiskering route is superseded, that the group law needs only
  existence-of-iso, that the associator is now built by direct gluing, and that the
  block is historical-only and must NOT be formalized.

- **Aligned `lem:tensorobj_isoclass_commgroup`** to `monoidOfSkeletalMonoidal` —
  directive item 4. Statement prose now spells out the four axioms each fed a single
  iso (`one_mul := hC⟨λ⟩`, `mul_one := hC⟨ρ⟩`, `mul_assoc := hC⟨α⟩`,
  `mul_comm := hC⟨β⟩`), cites `Mathlib/CategoryTheory/Monoidal/Skeleton.lean` and
  `CommRing.Pic` (`Mathlib/RingTheory/PicardGroup.lean`), and states pentagon/etc.
  are never invoked. Proof body given the same four-field framing.

## Cross-references introduced
- `\uses{lem:tensorobj_restrict_iso}` in `lem:tensorobj_assoc_iso` (statement +
  proof) — target exists in this chapter.
- `\uses{lem:tensorobj_restrict_iso}` in new `lem:restrictscalars_ringiso_tensorequiv`
  — target exists in this chapter.
- New label `lem:restrictscalars_ringiso_tensorequiv` referenced by `\cref` from the
  rewritten `tensorObj_restrict_iso` Step 3 — defined in this chapter.
- The vestigial-block banners `\cref` `lem:tensorobj_isoclass_commgroup`,
  `lem:tensorobj_assoc_iso`, `lem:tensorobj_restrict_iso` — all in this chapter.
- Removed the only live `\uses{lem:jw_ismonoidal}` (from the associator); the
  `lem:jw_ismonoidal` label is retained (block kept as historical), so other `\cref`s
  to it (unit-iso proof prose, commgroup fallback) remain resolvable.

## References consulted
- `analogies/ts-picard-direct-216.md` — the mathlib-analogist audit; basis for the
  group-law-needs-only-existence-of-iso framing, the `monoidOfSkeletalMonoidal`
  axiom-field mapping, and the gluing caveat (global data vs. pointwise Prop).
- `informal/tensorObj_restrict_iso.md` — the H1/H2 decomposition; basis for the Step-3
  rewrite (H2 = `restrictScalarsRingIsoTensorEquiv`, H1 = presheaf
  `pushforwardPushforwardAdj` from `pushforwardNatTrans`/`pushforwardCongr`, all
  Mathlib-absent at presheaf level).
- No new `references/<file>.md` opened; no new external `% SOURCE`/`% SOURCE QUOTE`
  citation blocks were added. All new citations are Mathlib decls referenced by
  path+name (per the directive's citation-discipline allowance). The pre-existing
  Stacks-tag-01CR verbatim source blocks were left untouched.

## Macros needed (if any)
None. All commands used (`\Scheme`, `\MonoidalCategory`, `\cref`, `\emph`, `\mathtt`,
etc.) are already in use elsewhere in the chapter.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Residual route-(e) promotion in earlier sections (out of my directive scope).**
  `sec:tensorobj_motivation` (≈L86–135), `sec:tensorobj_api_survey` (≈L136–279), and
  `rem:scheme_modules_monoidal_off_path` (≈L370–423) still present route~(e) /
  `LocalizedMonoidal` as *the* (cheap) way to obtain the monoidal structure and frame
  `J.W.IsMonoidal` as "the sole genuinely-new obligation". This now contradicts the
  direct-gluing associator and the supersession banners. The directive listed only
  the 7 blocks above, so I did not edit these. Recommend a follow-up writer pass to
  demote the route-(e) narrative in those three places for chapter-wide consistency.
- `lem:tensorobj_unit_iso` proof prose still offers the route-(e) unitor "equivalently
  ... components of the route~(e) monoidal structure `lem:jw_ismonoidal`" as an
  alternative. It is harmless (the primary `mapIso` route is stated first and the
  label still resolves), but a future cleanup could drop the route-(e) clause.
- The new `lem:restrictscalars_ringiso_tensorequiv` is statement-only per the
  directive ("statement only; no marker"). When the deterministic `sync_leanok` pass
  runs against `\lean{restrictScalarsRingIsoTensorEquiv}`, it should pick up `\leanok`
  if that decl is closed in the Lean file (the directive/recipe say it is).

## Strategy-modifying findings
None. The edits realign the chapter with the already-decided strategy (direct gluing
associator + H1-only residual); nothing surfaced that contradicts STRATEGY.md.
