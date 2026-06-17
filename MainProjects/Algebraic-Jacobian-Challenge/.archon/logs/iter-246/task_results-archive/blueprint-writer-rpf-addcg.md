# Blueprint Writer Report

## Slug
rpf-addcg

## Status
COMPLETE — the proof sketch of `lem:rel_pic_sharp_groupoid` was rewritten as the
four-step loc-triv-substrate construction; the Kleiman §2 citation block and
`\textit{Source:…}` line were left verbatim.

## Target chapter
blueprint/src/chapters/Picard_RelPicFunctor.tex

## Changes Made
- **Revised** `lem:rel_pic_sharp_groupoid` (statement block) — added a
  statement-level `\uses{def:line_bundle_on_product, def:pullback_along_projection,
  thm:relative_pic_quotient_well_defined}`. The lemma statement text, the
  `% SOURCE:` / `% SOURCE QUOTE:` Kleiman §2 block, and the visible
  `\textit{Source: …}` line are UNCHANGED (verbatim, per directive).
- **Replaced** the proof block of `lem:rel_pic_sharp_groupoid` — the stale
  sketch (which framed addition as "[L]+[L'] := [L⊗L']" via the abstract
  tensor product and treated the construction as the standard quotient-group
  fact) is superseded by the explicit four-step construction over the
  locally-trivial carrier `OnProduct(πC, πT)`:
  1. **AddCommGroup on the carrier.** `[L]+[L'] := [L⊗L']` via the loc-triv
     descent of the scheme-level tensor product
     (`\cref{lem:tensorobj_lift_onproduct}`), staying in the carrier by
     `\cref{lem:tensorobj_preserves_locally_trivial}`; zero `= [𝒪]`;
     assoc/comm/unitality from `\cref{lem:tensorobj_assoc_iso,
     lem:tensorobj_comm_iso, lem:tensorobj_unit_iso}` as in
     `\cref{lem:tensorobj_isoclass_commgroup}`; inverse `-[L] := [L^inv]` from
     `\cref{lem:tensorobj_inverse_invertible}` (returns a loc-triv witness +
     `L⊗L^inv ≅ 𝒪`, so closure holds).
  2. **The pullback homomorphism `π_T^*`.** `map_zero` from
     `π_T^*𝒪_T ≅ 𝒪` (`\cref{lem:pullback_unit_iso}`); `map_add` from the
     loc-triv comparison iso `π_T^*(N⊗N') ≅ π_T^*N ⊗ π_T^*N'`
     (`\cref{lem:pullback_tensor_iso_loctriv}`); `H_T := im(π_T^*)`.
  3. **Setoid reconciliation.** The `preimage_subgroup` iso-class equivalence
     coincides with the left-coset relation of `H_T`; both encode
     `L ~ L' ⟺ [L^inv ⊗ L'] ∈ H_T`.
  4. **Transport.** The quotient is in canonical bijection with
     `OnProduct/H_T` (canonical quotient-of-abelian-group structure);
     transport along the Step-3 bijection gives the instance.
  The new proof carries a full `\uses{...}` and an explicit "authored in
  parallel" paragraph naming `\cref{lem:pullback_tensor_iso_loctriv}` (A.1.c.sub)
  and `\cref{lem:tensorobj_inverse_invertible}` as concurrently-built / deferred
  inputs, per directive.
- **Revised** the `sec:relpic_consistency_check` bullet for
  `lem:rel_pic_sharp_groupoid` so the internal `\uses`-chain summary reflects
  the new proof dependencies (statement deps + tensor-substrate lemmas +
  comparison iso). This keeps the chapter's own consistency section accurate.

## Cross-references introduced
All resolve to existing labels (verified by grep before editing):
- `def:line_bundle_on_product`, `def:pullback_along_projection`,
  `thm:relative_pic_quotient_well_defined` — `Picard_LineBundlePullback.tex`.
- `lem:tensorobj_lift_onproduct`, `lem:tensorobj_preserves_locally_trivial`,
  `lem:tensorobj_assoc_iso`, `lem:tensorobj_comm_iso`, `lem:tensorobj_unit_iso`,
  `lem:tensorobj_isoclass_commgroup`, `lem:tensorobj_inverse_invertible`,
  `lem:pullback_unit_iso`, `lem:pullback_tensor_iso_loctriv` —
  `Picard_TensorObjSubstrate.tex`.

## References consulted
- None opened this round: the task altered only the project-side proof sketch
  (Archon-original construction). The existing `% SOURCE:` / `% SOURCE QUOTE:`
  Kleiman §2 block and `\textit{Source: …}` line were preserved verbatim and
  NOT re-derived, so no new verbatim quote was authored and no `references/`
  file needed re-opening. (Label existence was verified via `grep` over
  `blueprint/src/chapters/`.)

## Macros needed (if any)
- None. Used only existing constructs (`\Pic`, `\cref`, `\mathrm`, `\emph`,
  `\(\)`, display math). `\mathrm{OnProduct}` etc. are plain `\mathrm`, no new
  macro required.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **Stale gate-annotation prose elsewhere in the chapter now contradicts the new
  proof sketch.** The directive scoped me to the proof sketch of
  `lem:rel_pic_sharp_groupoid` only, so I did NOT touch:
  - The `\paragraph{Gate annotation (iter-198 refresh).}` block
    (`Picard_RelPicFunctor.tex` ~L713–L766 after my edit) still describes the
    residual gate as the upstream "`Scheme.Modules` monoidal-structure gap" at
    Mathlib `b80f227` ("only `PresheafOfModules.Monoidal.tensorObj` is shipped").
    Per the directive's strategy context this framing is superseded
    (`Scheme.Modules.tensorObj` and `picCommGroup` are now built axiom-clean;
    the real inputs are the loc-triv comparison iso + `exists_tensorObj_inverse`).
    This paragraph should be refreshed in a follow-up writer pass.
  - The several `% NOTE (iter-199 plan agent): …` comments on `def:rel_pic_sharp`,
    `lem:rel_pic_sharp_functorial`, `thm:rel_pic_sharp_presheaf`,
    `def:rel_pic_etale_sheafification`, and
    `thm:rel_pic_etale_sheaf_group_structure` likewise still cite the
    monoidal-structure gap. These are `% NOTE` markers — review-agent domain per
    `CLAUDE.md` — so I left them untouched; flag for the review agent to refresh.
- I did NOT modify `lem:rel_pic_sharp_functorial` (out of scope; its `\uses`
  did not need the one-line addition this round since the comparison iso enters
  via the groupoid lemma it already `\uses`).

## Strategy-modifying findings
None. The four-step construction is a faithful project-notation account of the
directive's strategy; nothing surfaced that contradicts STRATEGY.md.
