# Blueprint Writer Directive

## Slug
ts-etabridge

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Strategy context
This chapter blueprints the pullback–tensor comparison isomorphism on locally-trivial line bundles
(A.1.c.sub critical path). The decl chain is D2′ (`lem:pullback_tensor_iso_unit`, the comparison on the
unit pair `(𝒪,𝒪)`) → D3′ (`lem:pullback_tensor_map_basechange`) → D4′ (`lem:pullback_tensor_iso_loctriv`)
→ `IsInvertible.pullback`. D2′ is the only currently-active node. Its proof currently bottoms out in a
single morphism equation — the "unit square" — whose proof is a long mate-calculus telescope across three
nested adjunction layers. The prover has a complete informal recipe but cannot encode it as one
contiguous computation. **Your job: promote the telescope into a sequence of named, individually-provable
atomic lemma blocks**, so a fine-grained prover can close them one at a time rather than holding the whole
chain in context at once. This is project-bespoke categorical mate-calculus — **there is no external
source**; every block here stands on its proof sketch alone (omit all `% SOURCE` / `% SOURCE QUOTE` /
`\textit{Source:}` lines).

## Required content

All additions go in/around the existing D2′ block `\begin{lemma}...\label{lem:pullback_tensor_iso_unit}`
(currently at ~L3329) and its proof (~L3345–3372). Do NOT touch D3′/D4′ or any other section.

### Notation (already in the chapter / Lean file; restate locally as needed)
Let `f : Y → X` be a morphism of schemes, `φ = f.toRingCatSheafHom`, `φ' = φ.hom`. Write:
- `a_Y` = sheafification functor on `Y`-presheaves of modules; `𝟙ᵖ` = presheaf monoidal unit; `𝟙` = sheaf
  monoidal unit (= structure sheaf as a module).
- `η F` = the oplax-monoidal unit comparison of the **presheaf** pullback `F = pullback φ'` (a morphism
  `F.obj 𝟙ᵖ → 𝟙ᵖ`).
- `pullbackValIso`, `sheafifyUnitIso` = the (already-proven, iso) comparison morphisms relating the
  sheaf-level pullback value to the sheafification of the presheaf-level pullback (the file's
  `pullbackValIso f 𝒪_X`, `sheafifyUnitIso`).
- `pullbackObjUnitToUnit φ` = the **sheaf**-level unit comparison `f^*𝟙 → 𝟙`, proven iso for every `f`
  (= `pullbackUnitIso`, `lem:pullback_unit_iso`, via `Opens.map f.base` Final).
- `unitToPushforwardObjUnit φ`, `presheafAdj`, `sheafAdj` (presheaf/sheaf pullback–pushforward
  adjunctions), `sheafificationAdjunction` as in the file.

### (A) Two already-landed supplement blocks — add `\lean{}`-pinned lemma blocks
These two declarations already exist axiom-clean in the Lean file; add blueprint blocks so they are pinned
and the fine-grained prover can `\uses{}` them. Statement-only blocks with short proof sketches.

1. `\begin{lemma}[Presheaf-side unit mate identity]\label{lem:presheaf_unit_comp_map_eta}`
   `\lean{AlgebraicGeometry.Scheme.Modules.presheafUnit_comp_map_eta}`
   Statement: at the presheaf level,
   `presheafAdj.unit.app 𝟙ᵖ ≫ (pushforward φ').map (η (pullback φ')) = Functor.LaxMonoidal.ε (pushforward φ')`.
   Proof sketch: this is Mathlib's general adjunction-mate identity `Adjunction.unit_app_unit_comp_map_η`
   instantiated at the presheaf pullback–pushforward adjunction `pullbackPushforwardAdjunction φ'`; it
   holds because the project's `presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal`
   instances are `Adjunction.IsMonoidal`-compatible. `\uses{lem:presheaf_pushforward_laxmonoidal,
   lem:presheaf_pullback_oplaxmonoidal}`.

2. `\begin{lemma}[IsIso plumbing from the unit square]\label{lem:isiso_sheafifyeta_of_unitsquare}`
   `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafifyEta_of_unitSquare}`
   Statement: GIVEN the unit square
   `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit φ`,
   conclude `IsIso (a_Y.map (η (pullback φ')))`.
   Proof sketch: `pullbackObjUnitToUnit φ` is iso (every `f`; `Opens.map f.base` Final), and
   `pullbackValIso`, `sheafifyUnitIso` are isos; rearrange the square and chain the three isos.
   `\uses{lem:pullback_unit_iso}`.

### (B) The unit square and its transpose — the new atomic targets (the telescope)
Add a short subsection (after the D2′ proof, or as nested blocks the D2′ proof now `\uses{}`) presenting
the **unit square** as the goal and decomposing its proof into the atomic claims below. The square is:
```
(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit φ.
```
By `lem:isiso_sheafifyeta_of_unitsquare`, proving this square closes D2′.

Transpose the square across the **sheaf** pullback–pushforward adjunction `pullbackPushforwardAdjunction φ`
(apply `.homEquiv.injective`, then `homEquiv_unit`/`homEquiv_counit`), reducing it to the concrete
pushforward-side identity (∗∗):
```
sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map(
    (pullback φ).map(sheafCounit_X.inv)
    ≫ (sheafificationCompPullback φ).hom.app 𝟙ᵖ
    ≫ a_Y.map(η (pullback φ'))
    ≫ sheafCounit_Y.hom )
  = unitToPushforwardObjUnit φ,
```
where `sheafCounit_• = (sheafificationAdjunction (𝟙 •.ringCatSheaf.val)).counit` and
`sheafificationCompPullback φ = Adjunction.leftAdjointUniq A B` for the two composite adjunctions
- `A` with left adjoint `sheafification_X ⋙ pullback_sheaf`
  (`= (sheafificationAdjunction (𝟙 X)).comp (pullbackPushforwardAdjunction_sheaf φ)`),
- `B` with left adjoint `pullback_pre φ' ⋙ sheafification_Y`
  (`= (pullbackPushforwardAdjunction φ').comp (sheafificationAdjunction (𝟙 Y))`).

Then write the proof of (∗∗) as the following **7 numbered atomic steps**, each its own mathematical
sentence with the governing identity named. Where a step is a genuinely separable claim, give it a
standalone `\begin{lemma}` block with a `\lean{}` pin (proposed names below) and accurate `\uses{}`;
where a step is a single rewrite, state it inline as a numbered claim in the proof. Use your judgement on
granularity, but the three starred (★) steps below MUST become standalone pinned lemmas because they are
the load-bearing, non-mechanical content:

1. **Distribute** `pushforward.map` over the 4-fold composite `m` defining the transposed morphism, via
   functoriality (`Functor.map_comp`). (inline)
2. **Unit naturality**: pull `sheafCounit_X.inv` to the front using `Adjunction.unit_naturality` of
   `sheafAdj`, leaving the head `sheafAdj.unit.app (a_X 𝟙ᵖ) ≫ pushforward.map((sheafificationCompPullback φ).hom.app …)`.
   (inline)
3. ★ **Composite-adjunction homEquiv factorisation** —
   `\label{lem:comp_homequiv_factor_sheafify_pullback}`,
   `\lean{AlgebraicGeometry.Scheme.Modules.compHomEquivFactor}` (proposed): for the composite adjunction
   `A = adj₁.comp adj₂`, the hom-set bijection factors as `(adj₁.comp adj₂).homEquiv = adj₂.homEquiv` then
   `adj₁.homEquiv`; consequently the head of step 2 equals `(sheafAdj_pre_X.homEquiv).symm (A.homEquiv g)`
   with `g = (sheafificationCompPullback φ).hom.app 𝟙ᵖ`. State the precise factorisation identity for
   `Adjunction.comp` that the prover must use. `\uses{}` the two composite adjunctions.
4. ★ **leftAdjointUniq transport** — `\label{lem:leftadjointuniq_app_unit_eta}`,
   `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta}` (proposed): apply
   `Adjunction.homEquiv_leftAdjointUniq_hom_app A B 𝟙ᵖ` to rewrite `A.homEquiv((sheafificationCompPullback φ).hom.app 𝟙ᵖ)
   = B.unit.app 𝟙ᵖ`; then expand `B.unit.app 𝟙ᵖ` with `Adjunction.comp_unit_app` on `B` into
   `presheafAdj.unit.app 𝟙ᵖ ≫ pushforward_pre.map(toSheafify_Y (F.obj 𝟙ᵖ))`. `\uses{}` the leftAdjointUniq
   glue.
5. **comp_unit_app expansion** (the `B.unit` half) — may be folded into step 4 or stated inline; name
   `Adjunction.comp_unit_app`.
6. ★ **Apply the presheaf-side mate identity** `\cref{lem:presheaf_unit_comp_map_eta}` to rewrite
   `presheafAdj.unit.app 𝟙ᵖ ≫ pushforward_pre.map(η (pullback φ'))` into `Functor.LaxMonoidal.ε (pushforward φ')`
   (the presheaf-level unit ε_pre). (`η (pullback φ')` enters through `a_Y.map(η …)` in `m` together with the
   sheafification counits / `toSheafify` cancelling through `sheafCounit_Y`.) This is the step that consumes
   THIS chapter's `lem:presheaf_unit_comp_map_eta`.
7. **ε reconciliation** — `\label{lem:epsilon_presheaf_to_sheaf_unit}` (proposed standalone if it is more
   than a `rfl`): identify the presheaf-level `ε_pre` with the sheaf-level
   `ε_sheaf = unitToPushforwardObjUnit φ` (`Functor.LaxMonoidal.ε (pushforward φ) = unitToPushforwardObjUnit φ`
   by `rfl`), using the pushforward ↔ sheafification compatibility that defines the adjunctions, completing (∗∗).

Then **revise the existing `lem:pullback_tensor_iso_unit` proof** (~L3345–3372) so that it now reads:
"…the genuine remaining content is `IsIso(a_Y.map(η …))`; by `\cref{lem:isiso_sheafifyeta_of_unitsquare}`
it suffices to prove the unit square; the unit square is `\cref{lem:eta_bridge_unit_square}`" — i.e. add a
top-level `\begin{lemma}[The unit square]\label{lem:eta_bridge_unit_square}`
`\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (proposed) stating the square, whose proof
is the 7-step telescope above (its `\uses{}` listing the atomic steps 3/4/6/7 and
`lem:presheaf_unit_comp_map_eta`). Make the D2′ proof close by chaining
`lem:eta_bridge_unit_square` → `lem:isiso_sheafifyeta_of_unitsquare` → the iter-246 δ-wrapping reduction.

## Out of scope
- D3′ (`lem:pullback_tensor_map_basechange`) and D4′ (`lem:pullback_tensor_iso_loctriv`) — leave entirely.
- `exists_tensorObj_inverse`, the group-law section, the off-path D1 Lan decomposition — do not touch.
- Do NOT add/remove `\leanok` or `\mathlibok` markers anywhere (managed deterministically).
- Do NOT add any `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` — this is Archon-original content.
- Do NOT renumber or restructure unrelated sections.

## References
None. Project-bespoke categorical mate-calculus; no external source. Do not invent citations.

## Expected outcome
The D2′ region of the chapter now contains: two pinned blocks for the landed supplements
(`lem:presheaf_unit_comp_map_eta`, `lem:isiso_sheafifyeta_of_unitsquare`); a top-level unit-square lemma
`lem:eta_bridge_unit_square` whose proof is laid out as 7 numbered atomic steps; and standalone pinned
lemma blocks for the three load-bearing steps (composite-homEquiv factorisation, leftAdjointUniq transport,
ε reconciliation). The existing `lem:pullback_tensor_iso_unit` proof is revised to chain through these.
Every new block has accurate `\uses{}` and a rigorous (mathematical, non-Lean-syntactic) proof sketch a
fine-grained prover can formalize step by step. The chapter remains valid LaTeX.
