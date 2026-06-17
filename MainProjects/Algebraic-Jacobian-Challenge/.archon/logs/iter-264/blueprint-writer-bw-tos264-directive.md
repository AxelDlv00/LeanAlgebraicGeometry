# Blueprint-writer directive — bw-tos264

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (ONLY this chapter).

## Context (strategy slice)
This chapter blueprints the A.1.c.sub line-bundle comparison-iso substrate. Two active prover lanes
read it: the DUAL inverse chain (`DualInverse.lean`, `lem:slice_dual_transport` / `lem:dual_restrict_iso`)
and the D3′ Sq1 pullback-tensor base-change (`lem:pullback_tensor_map_basechange`). A bidirectional
Lean↔blueprint check (lvb-di263, lvb-tos263) found the chapter has 1 must-fix + 3 major proof-sketch
adequacy gaps that would mislead a prover. Fix exactly the items below; do NOT touch unrelated blocks,
do NOT add/remove `\leanok`/`\mathlibok` markers (a deterministic phase manages those).

## Required fixes

### 1. [MUST-FIX] `lem:slice_dual_transport` — naturality sketch is WRONG
The proof currently states naturality of the section family in `W` "holds by `Subsingleton.elim`,
`Opens Y` being a thin poset." This is wrong in scope. `Subsingleton.elim` discharges only the
uniqueness of the BASE morphisms in `(Over V.unop)ᵒᵖ` (thin poset, ≤ one inclusion between objects).
The actual naturality obligation is an equation between `𝒪_Y(V)`-MODULE maps, and that requires
additionally: the swap `dualUnitRingSwap` (= `inv ε(restrictScalars β_W)`, where `ε` is the lax-monoidal
unit of `restrictScalars`) is NATURAL with respect to the restriction maps of both source and target
presheaf — i.e. the ε-naturality of `restrictScalars` along the structure-ring iso `β_W`. Rewrite the
naturality paragraph to: (a) state base-morphism uniqueness by `Subsingleton.elim`; then (b) state that
the module-map equation reduces to the ε-naturality square of `restrictScalars` post-composed with the
`dualUnitRingSwap` definition. Make clear this ε-naturality step is a genuine, separate obligation the
thin-poset argument does NOT discharge.

### 2. [MAJOR] `lem:slice_dual_transport` — `invFun` description too thin
Expand the `invFun` paragraph to specify:
- The set-theoretic fact "every `W'' ≤ fV` lies in the image of `f.opensFunctor` (i.e. `W'' =
  f.opensFunctor(f⁻¹ W'')`) because `fV ⊆ range f` for the open immersion `f`." Name the underlying
  Mathlib `IsOpenImmersion` mechanism (open-image down-set is covered by the functor image of the
  preimage; the project's helper is `image_preimage_of_le`, the down-set identity `ι(ι⁻¹V)=V` for
  `V ≤ W`). State it as the lemma the inverse reindexing relies on.
- The component formula for the inverse `PresheafOfModules.Hom`: it mirrors `toFun` but uses
  `(f.appIso W'').hom` in place of its inverse, and the `ε`-codomain swap (not `inv ε`), reindexed by the
  inverse down-set bijection.
- The round-trip identities `left_inv`/`right_inv` close by `Iso.inv_hom_id`/`Iso.hom_inv_id` of
  `f.appIso` applied component-wise, together with the down-set bijection cancelling.

### 3. [MAJOR] `lem:slice_dual_transport` — `map_smul'` missing the β-naturality step
The current steps (i)+(ii) correctly identify the internal-hom scalar action and `𝒪_Y(V)`-linearity of
`restrictScalars β_W`. Add the missing bridge: the β-naturality RING identity `s = (β.app W').hom c`,
where `s` is the pushforward-restricted scalar (X-side) and `c` is the `𝒪_Y(V)`-scalar (Y-side),
obtained from `InternalHom.termRingMap_naturality` together with the naturality of `β` on the thin poset
`Opens Y`. Without this identity the X-side and Y-side scalars cannot be matched. Also name
`ModuleCat.restrictScalars.smul_def'` as the lemma that unfolds the `restrictScalars` smul so that
`map_smul` can fire.

### 4. [MINOR] tag `image_preimage_of_le`
In the `lem:scheme_modules_hom_local_section` proof, where the prose invokes the open-set equality
`ι_i(ι_i⁻¹(V)) = V`, add an inline `\lean{AlgebraicGeometry.Scheme.Modules.image_preimage_of_le}`
reference so the helper is cross-referenced.

### 5. [MAJOR, lvb-tos263] `lem:pullback_tensor_map_basechange` (D3′ Sq1) — specify the tail goal + Sq4
Two additions to the Sq1 discussion:
- (a) State explicitly the reduced TAIL goal that remains after the R0 factor `(pullbackComp h f).inv`
  is peeled (the Lean carrier is the helper `sheafificationCompPullback_comp_tail`). The goal is the
  composite-adjunction-unit identity `B_{h≫f}.unit.app P = sheafAdj_X.unit P ≫ (forget ⋙
  restrictScalars).map (U ≫ pushforward(h≫f).map (R1 ≫ R5 ≫ δ_pre))`, where `B_φ := (PrPbPushAdj φ').comp
  sheafAdj` is the two-layer composite adjunction (presheaf pullback-pushforward ∘ sheafification),
  `U` is the composite-unit prefix with `(pushforwardComp h f).hom`, and `R1 = (pullback h).map
  (sheafCompPb f .app P).hom`, `R5 = (sheafCompPb h .app _).hom`, `δ_pre = a_Z.map (pullbackComp φ'_f
  φ'_h .hom.app P)`. Describe the route: keep the LHS as the concrete `B.unit`; recover the two
  `sheafCompPb f/h` factors as the `f`/`h` sub-comparison units via the
  uniqueness-of-left-adjoints characterisation (`homEquiv_leftAdjointUniq_hom_app`), then reassemble
  into `B_{h≫f}.unit` by the unit-naturality of `pushforwardComp`/`pullbackComp`. This is the
  sheafification-laden analog of `unitToPushforwardObjUnit_comp`; UNLIKE that lemma it is NOT `rfl`
  sectionwise because `B_f`/`B_h` are composite adjunctions. **Record the dead-end:** transposing the
  whole equation back through `homEquiv` is CIRCULAR (it re-folds to the original statement) — do not
  describe that as a route.
- (b) State the Sq4 `pullbackValIso` composition-coherence sub-lemma (the `.val`-vs-helper-`.obj`
  connecting-object naturality used in `pullbackTensorMap_restrict`) as a standalone obligation to be
  built separately, so the prover knows it is a named brick, not folded into Sq1.

## Out of scope
- Do NOT edit any other chapter.
- Do NOT touch `\leanok`/`\mathlibok`.
- Do NOT add Lean tactic code; prose + `\lean{}`/`\uses{}` hints only.
- Keep all existing `% SOURCE`/`% SOURCE QUOTE` blocks intact.

## References available
The DUAL route-2 and D3′ Sq1 are project-bespoke constructions (no external textbook proof); cite no
new external source. If you believe a Stacks tag backs the ε-naturality of `restrictScalars` or the
open-immersion down-set coverage and want to quote it, you may dispatch a reference-retriever
(your write-domain includes `references/**`) — but it is optional; project-original prose is acceptable
for these.
