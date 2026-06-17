# Blueprint-writer directive — iter-063

**Chapter to edit (ONLY this file):** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(the consolidated chapter; `% archon:covers` includes both `CechSectionIdentification.lean` and
`OpenImmersionPushforward.lean`).

This is a **blueprint-expansion corrective** for two CHURNING routes (progress-critic iter-063). Two
prover sessions worked out the complete proofs in-file but the blueprint proofs are (Route B) wrong for
the general case and (Route A) under-decomposed for a ~200–300 LOC assembly. Bring both into line so a
prover can follow them, and clear the coverage debt. Do NOT add `\leanok` anywhere (sync_leanok owns it).
You MAY add `\mathlibok` ONLY on genuine Mathlib dependency anchors (see below).

---

## TASK 1 (Route B, MUST-FIX) — rewrite the WRONG proof of `lem:pushforward_slice_pullback_iso`

**Block:** `\label{lem:pushforward_slice_pullback_iso}` (currently ~lines 9855–9885). Statement is fine;
the **proof** (currently ~9874–9885) is mathematically WRONG: it claims `pullbackObjUnitToUnit ψ_r`
(the unit/free-module comparison) gives the iso for general `H`. It does not — that map only handles the
unit module. Three independent reviewers + the iter-062 prover confirmed this is the blocking inadequacy.

**Replace the proof with the prover-verified `leftAdjointUniq` route.** The correct argument:

1. Let `φ'' = sliceStructureSheafHom φ.symm Vᵢ` be the **reverse** slice structure-sheaf ring map
   (the SAME construction of Lemma~\ref{lem:slice_structureSheaf_hom} applied to `φ.symm`).
2. Build the two-pushforward adjunction
   `adjA : pushforward φ'' ⊣ pushforward ψ_r` via Mathlib's `pushforwardPushforwardAdj adj φ'' ψ_r H₁ H₂`
   (`Mathlib/.../ModuleCat/Sheaf/PushforwardContinuous.lean`), where `adj` is the opens-site adjunction
   between `Over.post (Opens.map φ.inv.base)` and `Over.post (Opens.map φ.hom.base)`, and `H₁,H₂` are the
   two compatibility squares relating `φ''`, `ψ_r` to that adjunction.
3. `Adjunction.leftAdjointUniq (pullbackPushforwardAdjunction ψ_r) adjA : pullback ψ_r ≅ pushforward φ''`
   (uniqueness of left adjoints).
4. The remaining `pushforward φ'' (H.over Uᵢ) ≅ (Φ H).over Vᵢ` is a **`rfl`-clean section identity**
   (`Scheme.Modules.pushforward_obj_obj`: both sides are `Γ(H, φ.hom⁻¹ᵁ W.left)`). Compose 3 + 4.

**You MUST surface the genuine remaining coherence work as an explicit proof step, not hide it** (this is
why the previous "two-line" sketch was inadequate): the source adjunction's natural witness
`Over.postEquiv eOpens` has `inverse = Over.post (Opens.map φ.hom.base) ⋙ Over.map (unitIso.inv)` — an
`Over.map` **correction** forced because the open identity `φ.hom⁻¹ᵁ φ.inv⁻¹ᵁ Uᵢ = Uᵢ` is **NOT `rfl`**
(`Over.post (Opens.map φ.hom.base)` lands in `Over (φ.hom⁻¹ᵁ Vᵢ)`, not `Over Uᵢ`). So `φ''`, `H₁`, `H₂`
carry `eqToHom`/`Over.map`-correction bookkeeping. State this as the substantive content of the proof.

**Decompose** this into a `\uses`-linked chain so the prover has named sub-targets (the assembly is
~100–150 LOC delicate coherence — a monolithic node is what churned). Suggested cut (adjust if a cleaner
seam exists):
- a new sub-lemma `lem:pushforward_slice_two_adjunction` — statement: the two-pushforward adjunction
  `pushforward φ'' ⊣ pushforward ψ_r` exists, carrying the `Over.map (unitIso.inv)` correction in its
  `H₁,H₂` data; proof = `pushforwardPushforwardAdj` applied to `Over.postEquiv eOpens`'s adjunction with
  the correction. `\lean{}` left as a build target (no Lean decl yet).
- `lem:pushforward_slice_pullback_iso` then assembles steps 3 + 4 from it.

Add Mathlib anchors (with `\mathlibok`, `\lean{}` naming the real Mathlib decl) for any of these NOT
already anchored in the chapter: `Adjunction.leftAdjointUniq`, `pushforwardPushforwardAdj`,
`CategoryTheory.Over.postEquiv`, `SheafOfModules.pullbackPushforwardAdjunction`. Check first — several
`*_mathlib` anchors already exist; do not duplicate.

Update the `\uses{}` of `lem:pushforward_slice_pullback_iso` (statement AND proof) to reflect the new
chain (`lem:pushforward_slice_two_adjunction`, the `leftAdjointUniq` anchor, the section-identity), and
DROP `lem:pullbackObjUnitToUnit_mathlib` from its proof `\uses` if the unit comparison is no longer the
route (the prover confirmed it is not the general-H route).

---

## TASK 2 (Route A, churning corrective) — expand/decompose `lem:pushPull_binary_coprod_prod`

**Block:** `\label{lem:pushPull_binary_coprod_prod}` (~lines 8029–8098). The current proof describes only
the **sections-level disjoint-union** argument — which is exactly the now-DONE leaf
`isIso_coprodDecompMap` (the decomposition `M ⟶ inl_*(M|inl) ⨯ inr_*(M|inr)` in `(A⨿B).Modules`). The
iter-062 prover discovered L2 is bigger: L2's statement is in `X.Modules` about `q_*(q^*F)`
(`q = coprod.desc Y₀.hom Y₁.hom`), and bridging `coprodDecompMap (q^*F)` to that needs the full
**`q_*`-coherence assembly**. The blueprint must reflect this so the prover (or its successor if it
stalls partway) has named sub-targets.

**Expand the proof** to the prover-verified reduction (transcribe the math; no Lean tactics):
- Define the comparison as the **canonical** `asIso (prod.lift (pushPullMap F overInl) (pushPullMap F overInr))`
  (this exact framing is MANDATORY — downstream Stub 4/5 require the `.hom` to be `prod.lift (pushPullMap …)`;
  a non-canonical chain iso is a dead end. Note this in the proof.)
- Prove it `IsIso` by matching against the chain iso
  `chainIso := (pushforward q).mapIso (asIso coprodDecompMap) ≪≫ PreservesLimitPair.iso (pushforward q) P Q
   ≪≫ prod.mapIso idiso₀ idiso₁`, where `idiso₀ : (pushforward q).obj (inl_*(q^*F|inl)) ≅ pushPullObj F Y₀`
  comes from `innerIso₀ := restrictFunctorIsoPullback ≪≫ pullbackComp ≪≫ pullbackCongr w₀` pushed forward
  along `pushforward q`, plus an `eqToIso` for the codomain (the KEY DEFEQ: `pushforwardComp` is
  identity-on-objects, so `q_*(inl_* N) = (inl ≫ q)_* N` holds by `rfl`, making `idiso₀`'s codomain
  transport mostly `rfl`). Match `.hom` via `prod.hom_ext`.

**Add a named sub-lemma `lem:pushPull_binary_leg_coherence`** for the per-leg coherence (★) — the actual
proof obligation: `pushPullMap F overInl = (pushforward q).map u₀ ≫ idiso₀.hom` (and the `inr` twin),
where `u₀` is the `inl`-component of `coprodDecompMap`. Informal proof: unfold the LHS via
`pushPullMap_eq_raw` + `rawPushPullMap_self_gen`; rewrite the adjunction unit via
`Adjunction.unit_leftAdjointUniq_hom_app` (using
`restrictFunctorIsoPullback = (restrictAdjunction).leftAdjointUniq (pullbackPushforwardAdjunction)`); the
remainder collapses to an `eqToHom = eqToHom` proof-irrelevance via `Functor.map_comp` + `eqToHom_map`.
Give it `\lean{}` as a build target (no Lean decl yet) and a `\uses{}` listing the named Mathlib pieces.

**Coverage debt (Route A):** add the two now-existing private helpers
`AlgebraicGeometry.isIso_coprodDecompMap` and `AlgebraicGeometry.isIso_map_prodLift_of_isLimit` to the
`\lean{...}` list of `lem:pushPull_binary_coprod_prod` (they are currently unmatched isolated nodes).

The downstream `lem:pushPull_coprod_prod` (induction) and `lem:pushPull_sigma_iso` (specialization) blocks
are already adequate — leave their proofs, but verify their `\uses{}` still point at the (possibly
re-decomposed) `lem:pushPull_binary_coprod_prod`.

---

## TASK 3 (coverage debt, Route B) — bundle the 4 new OpenImm instances

Add to the `\lean{...}` list of `lem:slice_structureSheaf_hom` (currently only names
`AlgebraicGeometry.sliceStructureSheafHom`) the four supporting instances that are currently unmatched
isolated nodes (the `IsRightAdjoint` clause is already described in the lemma's statement text):
- `AlgebraicGeometry.opensMapInvBase_isEquivalence`
- `AlgebraicGeometry.overPost_slice_isContinuous`
- `AlgebraicGeometry.sliceStructureSheafHom_pre_isRightAdjoint`
- `AlgebraicGeometry.sliceStructureSheafHom_isRightAdjoint`

---

## Out of scope
- Do NOT touch any other chapter or any `.lean` file.
- Do NOT add/remove `\leanok` (sync_leanok owns it).
- Do NOT re-open the dead `pushforwardPushforwardEquivalence` quadruple route (superseded by `pullback ψ_r`).
- The CSI Stubs 4/5/6 blocks (`pushPull_eval_prod_iso`, `cechSection_complex_iso`,
  `cechSection_contractible`) are downstream and already adequate — leave them.

## Sources (already cited in-chapter; re-quote only if you move a citation)
- Stacks Project, Schemes "Functoriality for quasi-coherent modules" (pushforward-along-iso qcoh) — at
  `references/stacks-schemes.tex` L4729–4767 (already quoted on `lem:pushforward_iso_preserves_qcoh`).
- Stacks 02KE/02KG (coproduct/disjoint-union sheaf decomposition) for Route A.
You have `references/**` in your write-domain in case a child reference-retriever is needed; it should not be.
