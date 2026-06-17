# DAG Walker Directive

## Slug
tensorsubstrate-coverage

## Seed
chap:Picard_TensorObjSubstrate (the consolidated chapter `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`).
You are NOT walking up a single theorem cone here — your seed is the whole
`Scheme.Modules.tensorObj` substrate chapter. Your job is the **1-to-1 Lean↔blueprint
coverage gap** (completeness condition 3 of your descriptor): 54 Lean helper
declarations in this chapter's covered files have NO blueprint entry, so they are
isolated singletons in the DAG. Give each one a blueprint block and wire it.

## Strategy context
This chapter blueprints the abelian-group-valued relative Picard sheaf substrate
(`A.1.c.SubT`): the `tensorObj`/`dual`/pullback monoidal machinery on
`SheafOfModules` that gives the relative Picard functor its group structure. The
54 uncovered helpers are the internal lemmas the public theorems of this chapter
already depend on. They are the LAST blueprint nodes with no `\lean{}`-pinned
entry, and 52 of them are already proved sorry-free in Lean (so they need only a
faithful statement + accurate `\uses{}` + a one-line "proved directly in Lean"
note), while 2 carry `sorry` and currently have **infinite effort** — those two
need a genuine informal proof sketch (see below).

## Depth / scope
**Write-domain: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` ONLY.**
(Covered Lean files you read for ground truth:
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`,
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`,
and the sibling files `StalkTensor.lean`, `Vestigial.lean`, `PresheafInternalHom.lean`
for context on referenced names.)

Add a blueprint block (`\begin{lemma}`/`\begin{definition}` as fits, with
`\label{}`, `\lean{}` naming the EXACT Lean declaration incl. namespace, and a
`\uses{}` listing the project lemmas/defs the Lean proof actually invokes) for
each of the following 54 declarations. **Read each one's Lean source** to write a
faithful (purely mathematical, no Lean syntax) statement and an accurate `\uses{}`.

### Group A — 52 sorry-free helpers (statement + accurate `\uses{}` + one-line "Proved directly in Lean.")
From `TensorObjSubstrate.lean`:
W_of_isIso_sheafification, extendScalars, extendScalarsAdjunction,
forget_map_pushforward_map, forget₂_restrictScalars_μ_hom_tmul, isIso_pbu_of_final,
isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta,
isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta,
isIso_sheafify_tensorHom_pullbackValIso, picInv, picMul, picSetoid, pullback0,
pullback0Adjunction, pullbackComp_δ, pullbackObjUnitToUnitIso,
pullbackObjUnitToUnitIso_hom, pullbackSheafifyUnitEtaTriangle, pullbackValIso,
pushforwardComp_lax_μ, pushforward_map_restrictScalars_μ_app_tmul, pushforward_μ_eq,
pushforward₀IsRightAdjoint, restrictIsoUnitOfLE, restrictScalarsId_map,
restrictScalarsIsRightAdjoint, restrictScalars_μ_app, restrictScalars_μ_app_tmul,
sheaf_unit_comp_pushforward_pullbackComp_inv, sheafificationCompPullback_comp,
sheafifyTensorUnitIso, sheafifyTensorUnitIso_hom_eq, sheafifyTensorUnitIso_hom_eq',
sheafifyUnitIso, tensorObjIsoOfIso, tensorObj_middleFour, tensorObj_unit_iso,
toPresheaf_map_homMk, toRingCatSheafHom_comp_hom_reconcile.
(All under namespace `AlgebraicGeometry.Scheme.Modules.`)
From `DualInverse.lean`:
dualUnitRingSwap, dualUnitRingSwapHom, dualUnitRingSwapInv,
dualUnitRingSwapInv_comp_dualUnitRingSwap, dualUnitRingSwap_comp_dualUnitRingSwapInv,
image_preimage_of_le, isIso_ε_restrictScalars_appIso, isIso_ε_restrictScalars_appIso_hom,
presheafDualUnitIso, topSectionToHom, topSectionToHom_app
(namespace `AlgebraicGeometry.Scheme.Modules.`), plus
`PresheafOfModules.dualUnitIsoGen`, `PresheafOfModules.unitDualSectionEquiv`.

For each Group-A block: faithful mathematical statement, `\lean{}`, `\uses{}`
reflecting its real dependencies (read the Lean `:= by ...`/term body to see what
it calls), and a proof body that is exactly `\begin{proof} Proved directly in Lean. \end{proof}`.
Do NOT add `\leanok` (the sync phase owns it).

### Group B — 2 ∞ nodes that need a written informal proof sketch
- `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_tail`
  (sorry in `TensorObjSubstrate.lean`).
- `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv`
  (sorry in `DualInverse.lean`).

These are stuck in the Lean *formalization* (a `whnf`/`eqToHom`-transport wall),
but their **mathematical content is finite and writable**. Read the Lean
statement + the surrounding declarations and the in-file `/- ... -/` planner
comments, and write an honest informal proof sketch (mathematical prose) so the
node's effort becomes finite:
- `sheafificationCompPullback_comp_tail` is the residual "tail" of the proof that
  the sheafification∘pullback comparison respects composition of open immersions —
  i.e. the two composite comparison morphisms agree. Sketch the argument as a
  naturality/coherence identity of adjunction-mate (transpose) morphisms: the two
  sides are transposes of the same map under the pullback⊣pushforward adjunction,
  so they coincide by the mate/pentagon coherence (cite the relevant `\uses`
  blocks already in the chapter: the `pullbackComp`, `pushforwardComp`, unit/counit
  naturality blocks).
- `sliceDualTransportInv` is the inverse leg of the slice-dual transport
  equivalence: it transports the monoidal dual `(–)^∨` across the
  open-immersion slice reindexing, in the inverse direction, via conjugation by
  the `restrictScalars`-`ε` unit isomorphism (`dualUnitRingSwap*`,
  `isIso_ε_restrictScalars_appIso`). Sketch it as: the inverse is built from the
  Beck–Chevalley reindexing iso composed with the ring-iso dual equivalence, and
  is a two-sided inverse because each leg is an iso (cite the matching `\uses`
  blocks).

Keep each sketch to a short, honest paragraph. If you genuinely cannot reconstruct
the mathematical content from the Lean source, leave it `\notready`/unproved and
report it under "Could not complete" — but do TRY, since the math (a coherence
identity / an inverse-of-isos) is standard even though the Lean transport is hard.

## Out of scope
- Do NOT edit any other chapter.
- Do NOT touch protected blocks (none of these 54 are protected, but the chapter
  also contains other blocks — leave them alone).
- Do NOT add `\leanok`.

## References
- No external reference needed: every block here is internal category-theory
  infrastructure whose ground truth is the Lean source you read. Cite
  `\textit{Source: internal construction (proved/structured directly in Lean).}`
  where a `\textit{Source: ...}` line is expected.

## After editing
Re-run `leandag build` (read-only for you is fine via the CLI) is NOT required, but
in your report state how many of the 54 you covered, and confirm the 2 ∞ nodes now
have a proof sketch (finite) or are listed under "Could not complete".
