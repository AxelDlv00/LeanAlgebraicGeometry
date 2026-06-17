# Blueprint Writer Report

## Slug
bw258-overeq

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_SheafOverEquivalence.tex (new file)

## Changes Made
- **Created new chapter** `Picard_SheafOverEquivalence.tex` with
  `\label{chap:Picard_SheafOverEquivalence}` and the coverage declaration
  `% archon:covers AlgebraicJacobian/Picard/SheafOverEquivalence.lean`.
- **Added strategy note** (comment header) explaining the shared-root role: both
  the `LineBundleCoherence` engine (`chart_over_iso`) and the `DualInverse` dual
  chain (`exists_tensorObj_inverse`/`dual_restrict_iso`) reduce to this varying-ring
  slice-site change of base, and why the project's fixed-value-category cousin
  `overSliceSheafEquiv` is inapplicable.
- **Added definition** `\definition`/`\label{def:sheafofmodules_over_equivalence}`/
  `\lean{AlgebraicGeometry.Scheme.Modules.overEquivalence}` — the modules-level lift
  of `Opens.overEquivalence U` via `SheafOfModules.pushforwardPushforwardEquivalence`,
  with `φ`/`ψ`/`H₁`/`H₂`. Proof sketch: Y — notes continuity legs resolve by
  inference (`overEquivInverseIsDenseSubsite` + Mathlib auto dense-subsite instance);
  only genuine content is the open-immersion ring morphism `φ` (mirrors
  `restrictFunctor`'s `(ι.appIso _).inv`).
- **Added lemma** `\label{lem:sheafofmodules_restrict_over_iso}`/
  `\lean{...restrictOverIso}` — equivalence carries `restrict ↦ over`. Proof sketch:
  Y — `M.restrict ι` is itself a pushforward, compose via `pushforwardComp`
  (`Iso.refl`) + `pushforwardNatIso` along `eqToIso` of the two `V ↦ V.left`
  functors; mirrors `restrictFunctorAdjCounitIso`. `\uses{def:...over_equivalence}`.
- **Added lemma** `\label{lem:sheafofmodules_unit_over_iso}`/`\lean{...unitOverIso}`
  — equivalence carries `unit ↦ unit` (pushforward-of-unit up to `φ`). Proof sketch:
  Y. `\uses{def:...over_equivalence}`.
- **Added lemma** `\label{lem:chart_over_iso}`/`\lean{...chartOverIso}` — the engine
  corollary; composite `(restrictOverIso).symm ≪≫ functor.mapIso e ≪≫ unitOverIso`,
  general in `M, U, e`. Proof sketch: Y — names the three-factor composite and notes
  it closes the categorical gap elided in `lem:lbc_chart_presentation`; prose notes
  the dual lane's `sliceDualTransport` consumes the same root.
  `\uses{lem:sheafofmodules_restrict_over_iso, lem:sheafofmodules_unit_over_iso}`.
- **Registered chapter** in `blueprint/src/content.tex`: added
  `\input{chapters/Picard_SheafOverEquivalence}` between
  `Picard_TensorObjSubstrate` and `Picard_LineBundleCoherence` (the Picard arc, as
  directed). See "Notes for Plan Agent" — this was an explicit directive
  instruction; my write-domain permitted the edit.

No `\leanok`/`\mathlibok` markers added (per descriptor; owned by `sync_leanok` /
review). The covered Lean file `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`
does not yet exist — expected; it is built next iter.

## Cross-references introduced
- `\uses{def:sheafofmodules_over_equivalence}` in both consumer lemmas and in the
  `chart_over_iso` proof — target is in THIS chapter.
- `\uses{lem:sheafofmodules_restrict_over_iso, lem:sheafofmodules_unit_over_iso}` in
  `lem:chart_over_iso` — targets in THIS chapter.
- Prose `\cref` to `lem:open_immersion_slice_sheaf_equiv`, `lem:lbc_chart_presentation`,
  `lem:dual_restrict_iso`, `chap:Picard_LineBundleCoherence`,
  `chap:Picard_TensorObjSubstrate` — all exist in sibling chapters (verified present
  in `Picard_TensorObjSubstrate.tex` and `Picard_LineBundleCoherence.tex`).

## References consulted
None opened for citation purposes. This chapter is Archon-original (assembling
existing Mathlib primitives), so per directive it carries no external-literature
`% SOURCE QUOTE`. The single `% SOURCE:` comment on the definition is a Mathlib
code-location provenance line (citing
`Mathlib/.../Sheaf/PushforwardContinuous.lean:305` and `Topology/Sheaves/Over.lean`),
mirroring the existing `overSliceSheafEquiv` block's provenance style — NOT a
literature citation. Grounding files read (not for quotes):
- `analogies/overeq258.md` — full construction skeleton, all Mathlib names/file:lines.
- `informal/chartOverIso.md` — engine problem statement / type analysis.
- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (L5498–5562) — the
  `overSliceSheafEquiv` provenance/prose style I mirrored.
- `blueprint/src/chapters/Picard_LineBundleCoherence.tex` (L146–216) — the
  `lem:lbc_chart_presentation` block whose elided bridge `chart_over_iso` closes.

## Macros needed (if any)
None. Used only existing macros (`\Scheme`, `\struct` not needed here; `\mathtt`,
`\widetilde`, `\xrightarrow`, `\cref` all standard / already in use).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **`content.tex` edit.** The directive explicitly instructed adding the `\input`,
  and my dispatched write-domain permitted the write (the edit succeeded). This
  overrides the writer descriptor's default "do not edit content.tex" rule for this
  orphan-registration case. If you prefer writers never touch `content.tex`, restrict
  the write-domain next time and add the `\input` yourself.
- **Naming caution for the prover (next iter).** The engine's local `chartOverIso`
  in `LineBundleCoherence.lean` (current open sorry-def) should be REDIRECTED to the
  new general `AlgebraicGeometry.Scheme.Modules.chartOverIso` here, which is general
  in `M, U, e`. Keep this one general; the engine consumes it by a one-liner.
- **Dual-lane wiring.** Prose flags (no separate block) that `sliceDualTransport`
  (DualInverse.lean) is a further consumer of `def:sheafofmodules_over_equivalence`
  — the internal-Hom commuting with the slice-site change — to be wired once the API
  lands. If you want that as its own blueprint lemma, dispatch a follow-up directive;
  I did not add a block for it (out of scope this round).
- **`\mathlibok` candidate.** The review agent may wish to consider whether
  `def:sheafofmodules_over_equivalence` warrants a `% NOTE:` flagging that its core
  is `SheafOfModules.pushforwardPushforwardEquivalence` (Mathlib), with only `φ`
  project-side — not a full `\mathlibok` (genuine project content remains).

## Strategy-modifying findings
None. The chapter is consistent with STRATEGY.md as conveyed: the over-equivalence
is the shared root, built from existing Mathlib primitives, with only the
open-immersion ring morphism `φ` as genuine content. No strategy-level issue
surfaced while writing.
