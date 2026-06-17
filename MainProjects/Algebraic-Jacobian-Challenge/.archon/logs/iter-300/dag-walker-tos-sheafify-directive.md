# DAG Walker Directive

## Slug
tos-sheafify

## Seed
thm:pic_commgroup

## Mission (READ THIS FIRST)
The USER flagged that the DAG has 54 isolated `lean_aux` nodes (Lean decls in
`Picard/TensorObjSubstrate*` with no blueprint entry) plus 2 ∞-effort nodes, and
wants them wired into the goal cone with informal proofs written. This directive
assigns you **20 of them**, all in
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, covering the
sheafification/pullback unit-comparison machinery, the `tensorObj` transport
isos, and the `Pic` group operations — **including ONE ∞ node**
(`sheafificationCompPullback_comp_tail`) whose informal proof you must write.
Give each a blueprint block in
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` with `\label`,
`\lean{<full name>}`, accurate `\uses{}`, and a proof note/sketch, and wire each
into the cone (see "De-isolation"). Touch ONLY your 20 blocks plus the `\uses{}`
of their consumers; the other 34 isolated decls belong to sibling walkers on the
SAME file.

## The 20 assigned Lean declarations (all in `Picard/TensorObjSubstrate.lean`)
**19 are sorry-free** → proof env is a one-line "Proved directly in Lean; <phrase>."
**1 is ∞** (`sheafificationCompPullback_comp_tail`) → write a real finite informal
proof (sketch given below). These are PROJECT decls — do NOT `\mathlibok`.

Sheafify / pullback-value comparison isos:
- `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso` — sheafification is monoidal on the unit: `sheafify(𝟙) ≅ 𝟙` comparison (iso, def).
- `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_eq` — the `.hom` of the above expressed as a single sheafification of `η ⊗ η`.
- `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_eq'` — the pinned `(C := …⋙forget₂…)` variant of `_hom_eq` (same content, instance-pinned).
- `AlgebraicGeometry.Scheme.Modules.sheafifyUnitIso` — `sheafify (𝟙 R) (unit) ≅ unit` (the unit object is fixed by sheafification).
- `AlgebraicGeometry.Scheme.Modules.pullbackValIso` — `sheafify(pullback φ' M.val) ≅ (Scheme pullback f).obj M`: the value-level comparison between the presheaf pullback-then-sheafify and the sheaf pullback.
- `AlgebraicGeometry.Scheme.Modules.sheaf_unit_comp_pushforward_pullbackComp_inv` — the R0-peel bridge (`SheafOfModules`-spelled unit ∘ pushforward(pullbackComp.inv)).

Composite-adjunction unit comparison + cocycle:
- `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp` — the cocycle identity for the comparison `sheafificationCompPullback` under base composition `h ≫ f`.
- `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_tail` — **(∞)** the R1/R5/δ-collapse tail of the previous lemma (the reduced goal after the R0-peel and the two `← map_comp` merges).

Unit pullback comparison:
- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnitIso` — bundled `Iso` form of `pullbackObjUnitToUnit g` for a `Final` preimage functor (`(f^* 𝒪) ≅ 𝒪`).
- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnitIso_hom` — its `.hom` is `pullbackObjUnitToUnit g` (`@[simp]`).
- `AlgebraicGeometry.Scheme.Modules.isIso_pbu_of_final` — `pullbackObjUnitToUnit g` is an iso when `(Opens.map g.base).Final`.
- `AlgebraicGeometry.Scheme.Modules.pullbackSheafifyUnitEtaTriangle` — the unit/η triangle identity relating the sheafification unit and the pullback unit comparison.

`isIso` upgrade lemmas (δ ⇒ iso, via the sheafify-η hypothesis):
- `AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` — `pullbackTensorMap` is iso on the unit pair given the sheafify-η iso hypothesis.
- `AlgebraicGeometry.Scheme.Modules.isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` — the sheafify-`δ` is iso on the unit pair under the same hypothesis.
- `AlgebraicGeometry.Scheme.Modules.isIso_sheafify_tensorHom_pullbackValIso` — sheafification of `tensorHom` of two `pullbackValIso`'s is an iso.

`tensorObj` transport isos:
- `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` — `tensorObj` of two isos is an iso (`M ≅ M'`, `N ≅ N'` ⇒ `M⊗N ≅ M'⊗N'`).
- `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` — `tensorObj M 𝟙 ≅ M` (right unitor transport at the substrate level).

`Pic` group operations on iso-classes of invertible modules:
- `AlgebraicGeometry.Scheme.Modules.picSetoid` — the setoid on `{M // IsInvertible M}` with `M ~ M' := Nonempty (M ≅ M')` (instance).
- `AlgebraicGeometry.Scheme.Modules.picMul` — multiplication on `PicGroup X` by `tensorObj` (descended through the setoid).
- `AlgebraicGeometry.Scheme.Modules.picInv` — inverse on `PicGroup X` sending `[M]` to `[chosen N with M⊗N≅𝟙]`.

## Informal proof for the ∞ node `sheafificationCompPullback_comp_tail`
This is a **composite-adjunction unit cocycle identity**, not a novel theorem —
its Lean formalization is stuck only on `whnf`/`eqToHom` transport mechanics, the
mathematics is standard. Write the sketch in mathematical prose (no Lean):

Statement (prose): for composable scheme morphisms `Z --h--> Y --f--> X` and a
presheaf of modules `P` on `X`, the unit of the composite adjunction
`B_{h∘f} = (pullback–pushforward adjunction for (h∘f)) ∘ (sheafification adjunction
on Z)` at `P` equals the comparison-transported composite of the units of `B_f`
and `B_h`, glued by the pseudofunctor comparison `pushforwardComp` and the
sheafification comparison `sheafificationCompPullback` for `f` and for `h`
separately.

Proof sketch: The left-hand side is `B_{h∘f}.unit_P`, expanded by the
composite-adjunction unit formula (`comp_unit_app`) as
`(pullback–pushforward unit for φ'_{h∘f})_P` followed by the pushforward of the
`Z`-sheafification unit. The two `sheafificationCompPullback` factors `R1` and
`R5` appearing on the right are, by uniqueness of left adjoints
(`sheafification_comp_pullback_eq_leftadjointuniq`, `leftadjointuniq_app_unit_eta`),
exactly the units of `B_f` and `B_h`. Slide the pushforward-comparison
`pushforwardComp h f` past them using its naturality, then collapse the resulting
nested units by the naturality of the adjunction unit together with the
`comp_unit_app` formula a second time; this rewrites the composite of the `B_f`
and `B_h` units into the single `B_{h∘f}` unit, which is the left-hand side. The
remaining `pullbackComp`/`restrictScalars (𝟙)` factors are identities up to the
canonical pseudofunctor coherence, so they vanish. This is the
`sheafificationCompPullback` twin of the already-proved unit cocycle
`pullbackObjUnitToUnit_comp` (`lem:pullbackObjUnitToUnit_comp`); cite it as the
parallel model. `\uses{}` it, plus `lem:sheafification_comp_pullback_eq_leftadjointuniq`,
`lem:leftadjustuniq_app_unit_eta` (verify exact label:
`lem:leftadjointuniq_app_unit_eta` / `lem:leftadjointuniq_app_unit_eta_general`),
`lem:sheaf_unit_comp_pushforward_pullbackComp_inv` (your own new block),
and the `pushforwardComp` naturality you state.

## De-isolation
For each of your 20: write `\uses{}` to the labels its Lean proof invokes, AND
add the new label to the `\uses{}` of its existing consumer so the cone reaches
it. Verify consumers exist (`grep '\label{'`). Likely consumers already present:
- `lem:pullback_tensor_iso_unit`, `lem:isiso_pullbacktensormap_of_sheafifydelta`,
  `lem:pullback_tensor_map_natural` consume the `isIso_*sheafifyEta`/`pullbackValIso`/
  `sheafifyTensorUnitIso` family.
- `lem:pullback_unit_iso` consumes `pullbackObjUnitToUnitIso(_hom)` and `isIso_pbu_of_final`.
- `lem:sheafification_comp_pullback_eq_leftadjointuniq` / `lem:eta_bridge_unit_square`
  are neighbours of `sheafificationCompPullback_comp(_tail)` and the R0-peel bridge.
- `def:pic_carrier`, `thm:pic_commgroup` (seed), `lem:tensorobj_isoclass_commgroup`
  consume `picSetoid`/`picMul`/`picInv`.
- `lem:tensorobj_assoc_iso`, `lem:isinvertible_tensor`, `lem:tensorobj_unit_iso`
  (existing — distinct from the substrate `tensorObj_unit_iso` you are adding;
  reconcile labels carefully, the existing `\label{lem:tensorobj_unit_iso}`
  already pins `tensorObj_unit_iso`? VERIFY: if `lem:tensorobj_unit_iso` already
  `\lean{}`-pins `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso`, then that
  decl is NOT actually unmatched — skip it and report the discrepancy. Only add a
  block if the Lean name is genuinely unpinned.) consume `tensorObjIsoOfIso`.

## Scope boundary
- ONLY your 20 decls + their consumers' `\uses{}`. Do NOT touch the `extendScalars`/
  `restrictScalars_μ`/`pullbackComp_δ`/adjunction-infra cluster (sibling walker
  `tos-infra`) nor the `dual*` cluster (sibling walker `dual`).
- Prose only; no Lean tactic syntax. NEVER `\leanok`; no `\mathlibok` on project decls.
- Before adding any block, `grep` the chapter for the Lean name — if it is already
  `\lean{}`-pinned by an existing block, it is not unmatched; skip and report.

## Verification
Re-`leandag build` then `leandag show isolated`: none of your 20 Lean names may
remain isolated, and `leandag show gaps` must NOT list
`sheafificationCompPullback_comp_tail` as an ∞ blueprint source (your proof makes
it finite). Re-query and fix until converged.

## References
Project-internal category theory over Mathlib's sheafification / `PresheafOfModules`
pullback–pushforward adjunction API. Provenance line:
`\textit{Source: project-internal infrastructure over Mathlib's sheafification and
\texttt{PresheafOfModules} pullback–pushforward adjunction API; proved directly in
Lean.}` (for the ∞ node, instead: `\textit{Source: project-internal; standard
composite-adjunction unit cocycle, modelled on \cref{lem:pullbackObjUnitToUnit_comp}.}`).
No external `% SOURCE QUOTE`; do not fabricate citations.
