# Blueprint Writer Report

## Slug
carrier

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### New section: `\section{The invertibility-carrier Picard group}` (`\label{sec:tensorobj_pic_carrier}`)
Inserted between `lem:tensorobj_isoclass_commgroup` and the Consumer section. Opens
with prose explaining the pivot: the group law is now carried on
`IsInvertible` (where the inverse is the membership witness — free, no inverse
object) rather than on `IsLocallyTrivial` (which forces the dual build). Six new
declaration blocks, ordered for dependency flow (associator first, theorem last):

- **Added lemma** `lem:tensorobj_assoc_iso_invertible` / `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` — the associator `(M⊗N)⊗P ≅ M⊗(N⊗P)` for `\otimes`-invertible (hence locally free rank 1, hence flat) modules.
  - Proof sketch added: Y. Prose explicitly notes the general associator `lem:tensorobj_assoc_iso` is sorry-transitive through the flatness-free open obligation `lem:islocallyinjective_whisker_of_W` (`W_whiskerLeft_of_W`), and that the invertible/flat case routes instead through the sorry-clean flat-whiskering lemma `lem:flat_whisker_localizer` (`W_whiskerLeft_of_flat`/`W_whiskerRight_of_flat`), bypassing the open sorry. Stalks of a scheme are local ⟹ invertible = locally free rank 1 ⟹ flat (Stacks 0B8M).
- **Added definition** `def:pic_carrier` / `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` — `Pic X` := quotient of the subtype `{M // IsInvertible M}` by the "exists an iso" setoid.
- **Added lemma** `lem:isinvertible_tensor` / `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` — closure: `IsInvertible M → IsInvertible M' → IsInvertible (M⊗M')`, witness `N⊗N'` via associator+braiding+unitor.
  - Proof sketch added: Y.
- **Added lemma** `lem:isinvertible_unit` / `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` — `IsInvertible 𝒪_X`, witness `𝒪_X` via `tensorObj_unit_iso`.
  - Proof sketch added: Y.
- **Added lemma** `lem:isinvertible_inverse_welldef` / `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` — `M⊗N≅𝒪 ∧ M⊗N'≅𝒪 ⟹ N≅N'` (the `N ≅ N⊗𝒪 ≅ N⊗(M⊗N') ≅ (N⊗M)⊗N' ≅ 𝒪⊗N' ≅ N'` chain), making the inverse well-defined on classes.
  - Proof sketch added: Y.
- **Added theorem** `thm:pic_commgroup` / `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` — `Pic X` is an abelian group: `mul=⊗`, `one=[𝒪_X]`, `inv [M]=[N]` (witness, no construction); `one_mul`/`mul_one` ← unitors, `mul_comm` ← braiding, `mul_assoc` ← invertible associator, `mul_left_inv` ← witness iso.
  - Proof sketch added: Y.

### Demotion note in the dual section (`sec:tensorobj_dual_infra`)
- **Revised** `sec:tensorobj_dual_infra` intro — added an `\emph{Status: deferred, off the group's critical path.}` paragraph naming `lem:dual_restrict_iso`, `lem:dual_isLocallyTrivial`, `lem:sheafofmodules_hom_of_local_compat`, `rem:dual_discharges_inverse` (and the `dual` object) as the **deferred `IsInvertible ⟺ IsLocallyTrivial` bridge** (Stacks 0B8M), needed only by a downstream consumer requiring the locally-trivial inverse form — not by the group law. Blocks left fully intact. No blocks deleted.

### Reviewer must-fix (false common-root claim)
- **Revised** proof of `lem:sheafofmodules_hom_of_local_compat` (~L3172) — removed the false claim that the C-bridge (`lem:dual_isLocallyTrivial`) shares `lem:open_immersion_slice_sheaf_equiv` as a common root with the A-engine. Replaced with: the A-engine uses the sheaf-site equivalence `lem:open_immersion_slice_sheaf_equiv`, while the C-bridge uses a per-open presheaf-level slice comparison over the varying ring `𝒪_X(V)`, so the two are independent and built separately.
- **Revised** (consistency) the later "true cost is bounded below by building that **shared** bridge" phrasing in the same proof → "that **sheaf-site equivalence**", to avoid re-implying a shared root.

## Out-of-scope items respected
- Did NOT add `lem:dual_unit_iso` or the per-`V` slice-equivalence block.
- Did NOT delete any dual / C-bridge block.
- Did NOT edit any other chapter or add `\leanok`/`\mathlibok`.

## Cross-references introduced
- `lem:tensorobj_assoc_iso_invertible` `\uses{lem:tensorobj_restrict_iso, lem:flat_whisker_localizer, def:scheme_modules_isinvertible, def:scheme_modules_tensorobj}` — all exist in this chapter.
- `def:pic_carrier` `\uses{def:scheme_modules_tensorobj, def:scheme_modules_isinvertible}` — exist.
- `lem:isinvertible_tensor` / `lem:isinvertible_unit` / `lem:isinvertible_inverse_welldef` `\uses{... lem:tensorobj_unit_iso, lem:tensorobj_comm_iso, lem:tensorobj_assoc_iso_invertible ...}` — all exist (new + existing in this chapter).
- `thm:pic_commgroup` `\uses{def:pic_carrier, lem:isinvertible_tensor, lem:isinvertible_unit, lem:isinvertible_inverse_welldef, lem:tensorobj_unit_iso, lem:tensorobj_comm_iso, lem:tensorobj_assoc_iso_invertible}` — all new in this section.
- Dual-section note `\cref`s `sec:tensorobj_pic_carrier`, `thm:pic_commgroup` (new) and existing dual labels.

## References consulted
- `references/stacks-modules.tex` — verbatim quotes for all new citation blocks:
  - `definition-pic` (Tag 01CX, L4350–4357) → `def:pic_carrier`, `thm:pic_commgroup`.
  - `lemma-constructions-invertible` (Tag 01CR, L4200–4213) → `lem:isinvertible_tensor`, `thm:pic_commgroup`.
  - `lemma-invertible` (Tag 01CR, L4066–4079) → `lem:isinvertible_unit`, `lem:isinvertible_inverse_welldef`.
  - `lemma-invertible-is-locally-free-rank-1` (Tag 0B8M, L4159–4165) → `lem:tensorobj_assoc_iso_invertible` (flatness routing) and the dual-section demotion note (invertible⟺locally free rank 1).

## Macros needed (if any)
- None. Uses existing `\Scheme`, `\Pic`, `\AddCommGrpCat`, `\Spec`, `\Hom`, `\SheafHom`, `\cref` etc. already in the chapter.

## Reference-retriever dispatches (if any)
- None — all required source material was already on disk in `references/stacks-modules.tex`.

## Notes for Plan Agent
- LaTeX environment balance verified: 90 `\begin` / 90 `\end` outside comments. The raw count shows one extra `\begin` but it lives inside a pre-existing `%`-comment SOURCE QUOTE (an elided `[\dots]` enumerate); not introduced by this round.
- `thm:rel_pic_addcommgroup_via_tensorobj` (the consumer) still `\uses{lem:tensorobj_isoclass_commgroup}` (the locally-trivial group). If the strategy intends the consumer to be fed by the new invertibility-carrier `thm:pic_commgroup`, the consumer's `\uses` and its proof prose in `sec:tensorobj_consumer_acg` will need a follow-up edit to repoint — left untouched this round (directive scoped to this chapter's carrier section + dual demotion + the must-fix; repointing the consumer was not requested).
- `lem:tensorobj_inverse_invertible` and `lem:tensorobj_isoclass_commgroup` remain on the PRIMARY locally-trivial path with their existing `\leanok`/critical-path prose. They now coexist with the invertibility-carrier group; the prose in `sec:tensorobj_pic_carrier` frames `thm:pic_commgroup` as the analogue that drops the dual obligation. No contradiction, but a future cleanup could mark the locally-trivial group as the deferred-bridge consumer too.

## Strategy-modifying findings
- None. The carrier pivot is realizable as directed: the invertibility predicate carries the inverse existentially, `lem:isinvertible_inverse_welldef` is provable from the coherence isomorphisms alone, and the invertible-case associator legitimately bypasses the open whiskering sorry via the sorry-clean flat-whiskering lemma (invertible ⟹ locally free rank 1 ⟹ flat on a scheme, Stacks 0B8M).
