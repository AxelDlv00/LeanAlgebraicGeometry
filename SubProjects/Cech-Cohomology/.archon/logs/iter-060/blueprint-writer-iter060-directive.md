# Blueprint-writer directive — iter-060

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter; it
`% archon:covers` both `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`).

## Strategy context (the slice that matters)
Two prover lanes are about to be dispatched against this chapter's two covered files. Iter-059
provers added 13 axiom-clean declarations whose blueprint coverage is now incomplete, and two
proof sketches are under-specified for the next prover round. Your job: clear the coverage debt
and expand the two thin sketches. Do NOT change any mathematical strategy — this is alignment +
detail work. Do NOT add `\leanok` anywhere (the deterministic `sync_leanok` phase owns it).

## Task 1 — Coverage debt: add `\lean{}` blocks / pins for new substantive declarations

### OpenImmersionPushforward side — four new public declarations need blueprint blocks
Add a `\begin{lemma}`/`\begin{proof}` block (statement in project notation, `\label`, `\lean{}`,
accurate `\uses{}`, one-line informal proof) for each. These are Archon-original (no external
source line needed). Suggested statements/sketches (from the lean-vs-blueprint check):

1. `AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` — new block, natural
   anchor between the Ext-homcomplex material and `lem:open_immersion_pushforward_comp`.
   Statement: for `q ≥ 1`, if every class `e : Ext P H q` is zero then
   `IsZero (((preadditiveCoyoneda.obj (op P)).rightDerived q).obj H)`.
   Sketch: identify the right-derived object with the homology at `q` of the Hom-cochain-complex
   `n ↦ (P ⟶ Iⁿ)` of an injective resolution `I` via `InjectiveResolution.isoRightDerivedObj`;
   that homology vanishes iff every `q`-cocycle is a coboundary, which is exactly
   `InjectiveResolution.extMk_eq_zero_iff` applied to the hypothesis.
   `\uses` the Ext-homcomplex anchor + `lem:modules_isoSpec_ext_transport` neighbours as appropriate.
   Bundle the private helper `AlgebraicGeometry.preadditiveCoyoneda_mapHomologicalComplex_d_apply`
   into this block's `\lean{...}` (it is the differential-apply plumbing).

2. `AlgebraicGeometry.subsingleton_ext_of_iso_fst` — new block.
   Statement: for `φ : A ≅ B` and `q`, `Subsingleton (Ext B Y q) → Subsingleton (Ext A Y q)`.
   Sketch: contravariant Ext-functoriality — `z = (mk₀ φ.hom).comp ((mk₀ φ.inv).comp z)`
   (`Ext.mk₀_comp_mk₀_assoc` + `φ.hom_inv_id` + `Ext.mk₀_id_comp`); the inner factor lands in the
   subsingleton `Ext B Y q`, so `z = 0` by `Ext.comp_zero`.

3. `AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso` — new block (the key assembled leaf).
   Statement: given `φ : U ≅ Spec R`, an affine open `V'`, an iso
   `Φ.functor.obj (jShriekOU V) ≅ jShriekOU V'` (= `lem:jshriek_transport_along_iso`), and
   `(Φ.functor.obj H).IsQuasicoherent` (= `lem:pushforward_iso_preserves_qcoh`), every
   `e : Ext (jShriekOU V) H q` is zero for `q ≥ 1`, where `Φ = pushforwardEquivOfIso φ`.
   Sketch: `pushforwardExtAddEquiv φ` (spectrum transport) + `EnoughInjectives.of_equivalence` for
   the Spec side + `subsingleton_ext_of_iso_fst` transferring Serre vanishing along the transport
   iso + `affine_serre_vanishing_general_open` (Need#2) over `Spec Γ(U)`; injectivity of the
   transport AddEquiv forces `e = 0`.
   `\uses{lem:modules_isoSpec_ext_transport, lem:jshriek_transport_along_iso,
   lem:pushforward_iso_preserves_qcoh, lem:affine_serre_vanishing_general_open,
   lem:enoughInjectives_of_hasInjectiveResolutions}` (add `subsingleton_ext_of_iso_fst`'s label).

4. `AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions` — short block (connector).
   Statement: `HasInjectiveResolutions C → EnoughInjectives C`.
   Sketch: the degree-0 term of a chosen injective resolution with its mono unit is an injective
   presentation (`InjectiveResolution.instMonoFNatι`).

### CechSectionIdentification side — two pins to add, one new block
5. Add `CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib` to the `\lean{}` pin of
   `lem:prod_coproduct_distrib` (it implements the coproduct-in-first-argument form the block's
   statement already claims).
6. Add a one-line block `lem:overProd_coproduct_distrib_right` for
   `CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib_right`
   (`A ⨯ (∐ᵢ Yᵢ) ≅ ∐ᵢ (A ⨯ Yᵢ)` in `Over S`, braiding-twin of `overProd_coproduct_distrib`),
   `\uses{lem:overProd_coproduct_distrib}`. Used in the `widePullback_coproduct_iso` induction.
7. Bundle the proof-internal helpers `CategoryTheory.FinitaryPreExtensive.pcd_hom_fst`,
   `pcd_hom_snd`, `cf_hom_fst`, and `overSigma_hom_eq` into the `\lean{...}` block of
   `lem:overProd_coproduct_distrib` (they are its structure-map-compat plumbing).

## Task 2 — Remove stale build-target comments (now FALSE)
The following `% NOTE: build target. The Lean declaration does not exist yet.` comments are stale
(the declarations are now proved). Update them to reflect reality or remove them:
- on `lem:overProd_coproduct_distrib` (~line 7654)
- on `lem:coproduct_distrib_fibrePower` (~line 7740)

## Task 3 — Expand two under-specified proof sketches

### `lem:pushforward_iso_preserves_qcoh` — currently too thin (no Lean/Mathlib API)
The proof says only "transports verbatim / covers go to covers under the homeomorphism." Expand
with concrete mathematical content the prover can formalize: quasi-coherence is a LOCAL property
given by a presentation `⊕ⱼ 𝒪 → ⊕ᵢ 𝒪 → F → 0` on an affine cover; under an iso of schemes
`φ : U ≅ Spec R`, the pushforward `Φ.functor.obj H` is the transport of `H`'s `QuasicoherentData`
across the homeomorphism (affine opens map to affine opens, the local presentations transport).
Note explicitly that `Scheme.Modules.pushforward` has NO general qcoh-preservation lemma in
Mathlib (it preserves qcoh only along iso / qcqs), so the proof must transport the local
`QuasicoherentData` presentation across the iso of ringed spaces by hand. Read
`references/stacks-coherent.md`/`references/stacks-schemes.md` for the qcoh-under-iso statement and
cite it (verbatim `% SOURCE QUOTE:` if you quote). If you need a source not present, you may spawn
a reference-retriever (your write-domain includes `references/**`).

### `lem:cech_backbone_left_sigma` — add the missing bridge step + API names
- Add the intermediate `lem:widePullback_overX_eq_prod` step to the proof sketch: after applying
  `widePullback_coproduct_iso` (whose σ-component output is the slice product `∏ᶜ`), one must
  convert via `widePullback_overX_eq_prod` before applying `lem:widePullback_openImm_inter` (which
  expects the wide-pullback form). State this explicitly.
- In the universe-reduction paragraph, name the Lean API: `Finite.equivFin` (or `Fintype.equivFin`)
  to get `𝒰.I₀ ≃ Fin n`, and `Sigma.whiskerEquiv` / `Equiv.arrowCongr` for the coproduct/index
  reindex transports (LHS coproduct-reindex `∐ 𝒰.X ≅ ∐ (𝒰.X∘e.symm)` and RHS index-reindex
  `(Fin(p+1)→Fin n) ≃ (Fin(p+1)→𝒰.I₀)`).
- Also add a prose note to `lem:coproduct_distrib_fibrePower`: in the Lean formalization the
  σ-component is the slice product `∏ᶜ (fun k => Over.mk (f (σ k)))` (connected to the wide fibre
  power by `lem:widePullback_overX_eq_prod`).

## Out of scope
- Do NOT add/remove `\leanok` or `\mathlibok` (sync_leanok / review own those).
- Do NOT alter any frozen-signature statement or change strategy.
- Do NOT touch other chapters.
