# Blueprint Writer Report

## Slug
bw258-d3

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Scope
Touched ONLY the D3′ proof sketch of `lem:pullback_tensor_map_basechange`
(`\lean{...pullbackTensorMap_restrict}`): the Sq2 paragraph, the in-place `% NOTE:` directive
(iter-257 review), the proof's `\uses`, and the closing summary sentence that listed the Sq2
reconciliation as a missing ingredient. No other block or chapter touched. The
`lem:dual_restrict_iso` / `sliceDualTransport` block was left untouched.

## Changes Made
- **Revised** Sq2 paragraph of `lem:pullback_tensor_map_basechange` proof — the ring-map
  reconciliation
  `(toRingCatSheafHom (h∘f)).hom = φ'_f ; (Opens.map f.base)ᵒᵖ ◁ φ'_h` is now stated as
  **definitional** (closes by `rfl` at default transparency; named as the project lemma
  `toRingCatSheafHom_comp_hom_reconcile`). The former "non-trivial / transported by pseudofunctor
  coherence / discharged by the `pullbackId`/`pullback_assoc`/… bookkeeping atoms" prose was
  removed; those atoms are now stated as **not** required for the reconciliation. The paragraph now
  ends by pointing forward to Sq2b as the genuine content. **(correction (a))**
- **Added** Sq2b sub-step `\emph{Sq2b (monoidality of pullbackComp — the genuinely new
  ingredient)}` — a clearly-delimited sub-step inside the proof (per directive's "or a
  clearly-delimited sub-step inside the proof" option; a free-standing `\lemma` block would be
  invalid LaTeX inside `\begin{proof}` and would exceed the "D3′ proof sketch only" scope).
  States the monoidality of `PresheafOfModules.pullbackComp`: the connecting iso intertwines the
  single composite pullback's oplax tensorator δ with the composite tensorator `comp_δ =
  (pullback φ'_h).map δ^{φ'_f} ; δ^{φ'_h}`, displayed as the explicit δ = inv ; comp_δ ; (hom⊗hom)
  identity. Proof route written per the analogist (`analogies/d3sq2b258.md`): η→δ port of
  `pullbackObjUnitToUnit_comp`, using that δ of `leftAdjointOplaxMonoidal` is the transpose
  `homEquiv⁻¹((η⊗η);μ)`; transpose via `conjugateEquiv_pullbackComp_inv` +
  `unit_conjugateEquiv` + `Adjunction.comp_unit_app`; residual = lax-μ composition coherence of
  `pushforward` across `pushforwardComp` (sectionwise, η-twin `unitToPushforwardObjUnit_comp` is
  `rfl`); two-argument `tensorHom`/`δ_natural` shuffle per `Adjunction.isMonoidal_comp`. States it
  is proved at the **PresheafOfModules level** (φ' pinned), dissolving the three iter-257 frictions
  (forget₂ monoidal-instance metavars, the `(F:=F∘G)` factorization, the reconcile not firing).
  **(correction (b))**
- **Added** record-correction paragraph — scopes the existing "the unit-coherence mirror does not
  apply" remark to the FULL four-fold `pullbackTensorMap`; notes it does NOT bind Sq2b, whose inner
  δ genuinely is a transpose, so the η→δ mirror of `lem:pullbackObjUnitToUnit_comp` is the correct
  route for Sq2b specifically.
- **Revised** closing summary sentence — "genuinely missing ingredients" now = Sq2b
  (`pullbackComp` monoidality) + Sq1 (`sheafificationCompPullback`) + Sq4 (`pullbackValIso`); the
  Sq2 reconciliation is flagged definitional (`rfl`, no obligation). Assembly line updated to "Sq1,
  Sq2b, and Sq4 in hand".
- **Removed** the iter-257 `% NOTE:` directive block (acted on; its instructions are now reflected
  in the prose).

## Cross-references introduced
- `\uses{lem:pullbackObjUnitToUnit_comp}` added to the proof of
  `lem:pullback_tensor_map_basechange` — Sq2b is the δ-twin of that unit coherence and mirrors its
  proof, so it is now a genuine dependency. Label verified present in this chapter (L3196).
- Sq2b prose also `\cref`s `lem:presheaf_pullback_oplaxmonoidal` (the project's
  `leftAdjointOplaxMonoidal` of the pullback–pushforward adjunction) — already in `\uses`.

## References consulted
None under `references/`. This is an Archon-original / project-bespoke categorical lemma with no
external literature source (no `% SOURCE`/`% SOURCE QUOTE` lines exist on this block or were added —
none invented). Internal documents read for grounding (not citations):
- `analogies/d3sq2b258.md` — the cross-domain analogist's Sq2b proof route (η→δ port of
  `pullbackObjUnitToUnit_comp`; the three Mathlib bridges `leftAdjointOplaxMonoidal_δ`,
  `conjugateEquiv_leftAdjointCompIso_inv`, `isMonoidal_comp`).

## Macros needed (if any)
None. All notation used (`\mathtt`, `\mathrm`, `\bigl/\bigr`, `\otimes`, `\circ`, `\mathbin{;}`,
`\varphi`, `\eta`, `\mu`, `\delta`, `\mathcal{S}/\mathcal{R}`) is already in use elsewhere in the
chapter.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Overview `(D3′)` item (L2683–2699) is now slightly out of step with the corrected proof.** That
  bullet still says the comparison "is instead established as a paste of four
  composition-coherence squares, decomposing δ … via `Functor.OplaxMonoidal.comp_δ` and …
  `conjugateEquiv_pullbackComp_inv`", and that "the unit-coherence mate calculus of
  `lem:pullbackObjUnitToUnit_comp` does not transfer". The first half is still accurate; the
  "does not transfer" clause is now nuanced by Sq2b (it does not transfer for the *full* tensorator
  but the inner δ-core *is* a transpose and is closed by the η→δ mirror). Per directive I did not
  touch that block (it is outside the D3′ proof sketch); flagging for a future consistency pass if
  desired.
- The lemma `\lean{}` target `pullbackTensorMap_restrict` retains 2 sorries per the iter-257 memory;
  Sq2b is the named obligation a prover should attack first (the analogist estimates ~100–180 LOC,
  same skeleton as the compiling `pullbackObjUnitToUnit_comp`).

## Strategy-modifying findings
None. The corrections refine the proof-sketch accuracy of an existing critical-path lemma; they do
not alter the strategy (the loc-triv group-law route and the D1′–D4′ decomposition are unchanged).
