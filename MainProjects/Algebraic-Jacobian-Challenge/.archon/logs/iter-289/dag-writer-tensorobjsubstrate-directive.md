# Blueprint-writer directive — Picard_TensorObjSubstrate.tex 1-to-1 helper coverage

## Target chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the consolidated chapter; its
`% archon:covers` lines already cover `TensorObjSubstrate.lean`, `.../StalkTensor.lean`,
`.../Vestigial.lean`, `.../DualInverse.lean`, `.../PresheafInternalHom.lean`).

This chapter is NOT mathematician-protected — you may edit it freely.

## Goal (single, bounded task)
The `leandag` 1-to-1 coverage check (`archon dag-query unmatched`) reports **54 Lean
declarations in this chapter's covered files that have NO blueprint entry**. Your job is to
add one blueprint block per uncovered declaration so the chapter is 1-to-1 with the Lean.
These are internal categorical-infrastructure helpers (change-of-rings / sheafification /
pullback-comparison / dual-transport machinery) supporting the chapter's already-written
public theorems. Closing this gap makes the whole project blueprint COMPLETE — so accuracy of
`\lean{}` names and `\uses{}` edges matters.

Add a new section near the end of the chapter, e.g.

```
\section{Supporting infrastructure helpers (1-to-1 Lean coverage)}
\label{sec:tensorobj_infra_helpers}
```

with mathematically-grouped subsections (one per source file / topic). Do NOT modify, reorder,
or delete any existing block. Do NOT touch any other chapter. Do NOT add `\leanok` (the
deterministic sync phase owns it). These helpers are project-internal — they need NO external
`% SOURCE` citation; where a helper is a direct mirror of a Mathlib construction (e.g.
`extendScalars`, `restrictScalars`, adjunction-uniqueness), say so in one prose sentence.

## Per-block requirements
For EACH declaration below add a block (`\begin{definition}` for `def`/`instance`/`abbrev`,
`\begin{lemma}` for `lemma`):
- a `\label{...}` (use a stable kebab slug, e.g. `def:tensorObjIsoOfIso`, `lem:pullbackComp_delta`);
- a `\lean{<exact full name>}` (names given verbatim below — keep the namespace);
- a concise **mathematical** statement in prose (no Lean syntax, no tactic names). Read the
  declaration's signature and docstring in the `.lean` file to extract the math. Keep each to
  1–4 sentences — these are helpers, not headline results;
- a `\uses{...}` listing the OTHER blueprint labels its statement/proof genuinely depends on.
  Wire to existing chapter labels where the helper builds on an already-blueprinted construction,
  and to sibling helpers you are adding in this same pass. A best-effort honest `\uses{}` is
  required; do not invent labels.

### The 52 sorry-FREE declarations — proof body is exactly:
`\begin{proof} Proved directly in Lean. \end{proof}`
(They are already formalized sorry-free; the entry only records the statement + dependency edges.)

### The 2 sorry-BEARING declarations — write a genuine informal proof sketch
These two carry a `sorry` in Lean (blocked on a Lean-kernel `whnf`/`eqToHom`-transport wall, NOT
on open mathematics — the underlying maths is a routine coherence/naturality square). Write a
faithful finite informal proof (a real `\begin{proof}` sketch, ~4–10 lines), drawn from the
declaration's in-file docstring and the listed `analogies/` notes. Do NOT write a vague
placeholder and do NOT mark them done — just give the honest mathematical argument so the node
is finite rather than ∞.

1. `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_tail`
   (in `TensorObjSubstrate.lean` ~L2536; see its docstring + `analogies/d3-mate271.md`,
   `analogies/ma-d3264.md`). Math: the comparison isomorphism relating sheafification-then-pullback
   for a composite `h ≫ f` is compatible with the pseudofunctorial composition coherence — i.e. the
   "tail" naturality square of `sheafificationCompPullback_comp` commutes. Proof is a mate/adjunction-
   transpose calculation: expand both adjunction units via the leftAdjoint-uniqueness comparison and
   identify them using the pushforward composition iso `pushforwardComp` and the pentagon
   (`pullbackComp`) coherence.

2. `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv`
   (in `DualInverse.lean` ~L273; see its docstring + `analogies/dualstep4-257.md`,
   `analogies/dual252.md`). Math: the reverse slice transport — the inverse of `sliceDualTransport`
   — sending an `Over V` dual section of the pushed-forward module to the `Over fV` dual section of
   the module, where `fV = f.opensFunctor.obj V`. Built component-wise by conjugating the forward
   transport with the `eqToHom`s coming from the propositional preimage round-trip
   `f''ᵁ(f⁻¹ᵁ W') = W'` and the change-of-rings reconciliation `restrictScalars`-collapse using the
   ring identity `(β.app P) ≫ (f.appIso P).hom = 𝟙`, with codomain swap `dualUnitRingSwapHom`.

## The 54 exact `\lean{}` names (group your subsections by these)

### From `TensorObjSubstrate.lean` (namespace `AlgebraicGeometry.Scheme.Modules`)
tensorObjIsoOfIso, tensorObj_unit_iso, tensorObj_middleFour, restrictIsoUnitOfLE,
picSetoid, picMul, picInv, pullbackObjUnitToUnitIso, pullbackObjUnitToUnitIso_hom,
pullbackValIso, pullback0, pullback0Adjunction, extendScalars, extendScalarsAdjunction,
pullback0... (use exact names) pushforward₀IsRightAdjoint, restrictScalarsIsRightAdjoint,
isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta,
isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta,
isIso_sheafify_tensorHom_pullbackValIso, sheafifyUnitIso, restrictScalarsId_map,
pullbackSheafifyUnitEtaTriangle, sheafifyTensorUnitIso, sheafifyTensorUnitIso_hom_eq,
sheafifyTensorUnitIso_hom_eq', pullbackComp_δ, pushforwardComp_lax_μ, pushforward_μ_eq,
pushforward_map_restrictScalars_μ_app_tmul, restrictScalars_μ_app, restrictScalars_μ_app_tmul,
forget₂_restrictScalars_μ_hom_tmul, sheaf_unit_comp_pushforward_pullbackComp_inv,
sheafificationCompPullback_comp, toRingCatSheafHom_comp_hom_reconcile,
forget_map_pushforward_map, isIso_pbu_of_final, W_of_isIso_sheafification,
toPresheaf_map_homMk, isIso_ε_restrictScalars_appIso, sheafificationCompPullback_comp_tail
(the 1st of the 2 sorry-bearing).

### From `DualInverse.lean`
- namespace `AlgebraicGeometry.Scheme.Modules`: isIso_ε_restrictScalars_appIso_hom,
  dualUnitRingSwap, dualUnitRingSwapHom, dualUnitRingSwapInv,
  dualUnitRingSwap_comp_dualUnitRingSwapInv, dualUnitRingSwapInv_comp_dualUnitRingSwap,
  presheafDualUnitIso, topSectionToHom, topSectionToHom_app, image_preimage_of_le,
  sliceDualTransportInv (the 2nd of the 2 sorry-bearing).
- namespace `PresheafOfModules`: dualUnitIsoGen, unitDualSectionEquiv.

NOTE: a couple of names above (e.g. `isIso_ε_restrictScalars_appIso` /
`isIso_ε_restrictScalars_appIso_hom` may both live in DualInverse) — verify each name's home file
and exact namespace by grepping the `.lean` files before writing its `\lean{}`. If you find a name
in my list whose declaration you cannot locate, list it in your report rather than inventing a
statement. The authoritative list is whatever `archon dag-query unmatched` reports for this chapter
— you may run it to self-check (every entry has the form
`lean:<fullname> \lean{<fullname>}`).

## Verification before returning
- Run `archon dag-query unmatched` (or `leandag build && leandag query --isolated`) and confirm the
  uncovered-count for these files has dropped to 0 (or report exactly which names remain and why).
- Confirm no existing block was modified (only additions).
- Report the count of blocks added and the two informal proofs written.
