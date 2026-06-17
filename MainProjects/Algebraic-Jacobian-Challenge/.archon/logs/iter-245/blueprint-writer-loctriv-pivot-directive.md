# blueprint-writer directive — iter-245 (slug: loctriv-pivot)

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, the section
`\section{Pullback-monoidality: invertibility under a general scheme morphism}`
(`\label{sec:tensorobj_pullback_monoidality}`, ~L2567 through ~L3320, ending before the next
`\section`).

## Why (strategy context — the slice that matters)

The section currently encodes a now-ABANDONED route: build a *general* concrete strong-monoidal
inverse-image pullback (`lem:pullback_lan_decomposition` D1, `lem:pullback0_tensor_iso` D2/D3 via
`pullback₀ = Lan (Opens.map f.base).op` + a Mathlib-absent filtered-colimit/⊗ interchange,
`lem:pullback_tensor_iso` D4) to obtain the comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N` for ALL
modules, then `lem:isinvertible_pullback` as a corollary "without ever invoking local triviality."

This was overturned iter-245 (adversarial analyst check, recorded in
`analogies/invertible-loctriv-bridge.md` — READ IT; it has the full decomposition and citations).
Two errors in the old reasoning, which the rewrite must correct:

1. **The general build is unnecessary.** The only consumer of the comparison iso is the relative
   Picard functor, whose carrier `OnProduct` (`LineBundlePullback.lean:130`) is
   `{M // IsLocallyTrivial M}` — it only ever needs the iso on **locally-trivial (line-bundle)**
   pairs, never general modules.
2. **The "δ is not an iso" obstruction was misattributed.** The counterexample `Γ(ℙ¹,𝒪(1)) = 0`
   concerns the **lax** tensorator of **pushforward** (a right adjoint / global sections), NOT the
   **oplax** comparison δ of **pullback** (a left adjoint). Pullback PROVABLY preserves local
   triviality (`IsLocallyTrivial.pullback`, axiom-clean, `LineBundlePullback.lean:156`), so on
   locally-trivial objects δ IS an iso.

## What to write (the new route)

Rewrite the section so the load-bearing result is the comparison iso **restricted to locally-trivial
pairs**, established by upgrading the ALREADY-BUILT oplax comparison MAP to an isomorphism via a
chart-chase — NOT by any general filtered-colimit / Lan construction. Concretely:

- Keep `lem:pullback_unit_iso` (`pullbackUnitIso`, `f^*𝒪 ≅ 𝒪` for all `f`, DONE, axiom-clean) and
  `lem:pullback_tensor_map` (`pullbackTensorMap` = the sheaf-level oplax comparison MAP
  `δ : f^*(M⊗N) ⟶ f^*M ⊗ f^*N`, DONE) as the inputs.
- State the new target as a comparison ISO on locally-trivial pairs (give it a fresh label, e.g.
  `lem:pullback_tensor_iso_loctriv`, and a `\lean{}` hint name the prover may self-adjust, e.g.
  `AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial`): for
  `M N : X.Modules` with `IsLocallyTrivial M`, `IsLocallyTrivial N`,
  `f^*(M⊗N) ≅ f^*M ⊗ f^*N`, realized by promoting `pullbackTensorMap` to an iso.
- Decompose the proof into these sub-lemmas (each its own block with `\uses{}`), per the analyst:
  - **(D1') δ sheaf-level naturality in (M,N)** — assemble naturality of `pullbackTensorMap` from
    the naturality of its pieces (Mathlib `Functor.OplaxMonoidal.δ_natural`, plus
    `sheafificationCompPullback`, `pullbackValIso`, `sheafifyTensorUnitIso`). ~40 LOC.
  - **(D2') δ on the unit pair `(𝒪,𝒪)` is an iso** — via `pullbackUnitIso` + the Mathlib monoidal
    coherence `δ_comp_η_tensorHom` / `δ_comp_tensorHom_η` + unitors. ~40–80 LOC.
  - **(D3') δ commutes with the open-immersion base-change square** `gᵢ : f⁻¹(Uᵢ) ⟶ Uᵢ` — the
    tensorator analog of the already-built axiom-clean `pullbackObjUnitToUnit_comp`
    (`TensorObjSubstrate.lean:902`, mate calculus), backed by Mathlib `Functor.OplaxMonoidal.comp_δ`
    and `conjugateEquiv_pullbackComp_inv`. This is the only genuinely new sub-step; flag it as such.
    ~80–150 LOC.
  - **(D4') chart-chase assembly** — on a common affine cover `{Uᵢ}` trivialising both `M` and `N`
    (the common refinement, as in the proven `tensorObj_isLocallyTrivial`,
    `TensorObjSubstrate.lean:515`), use δ-naturality (D1') to reduce each `f⁻¹(Uᵢ)` to the unit pair
    (D2'), with the base-change-square coherence (D3') aligning the restriction; conclude `δ` is an
    iso via the already-proven `isIso_of_isIso_restrict` (`TensorObjSubstrate.lean:546`,
    restriction-detects-iso on a cover). Mirror the structure of `IsLocallyTrivial.pullback`'s chase.
    ~50–100 LOC.
  - **(D5') `lem:isinvertible_pullback`** — re-route its proof: for `M` with `e : M⊗N ≅ 𝒪`
    (`IsInvertible`), and with `M,N` locally trivial, the witness is `f^*N` and the iso is
    `pullbackTensorIso_loctriv⁻¹ ≫ (pullback f).mapIso e ≫ pullbackUnitIso`. ~15 LOC.

- **Demote, do not delete the math, but remove from the critical path:** `lem:pullback0_tensor_iso`
  (the Lan/filtered-colimit general build, D2/D3) — mark it explicitly as an ABANDONED general route
  that the consumer does not need (a short `% NOTE`-style prose paragraph is fine; do not delete the
  block if it is referenced, but strike its `\uses{}` edges from the live `lem:isinvertible_pullback`
  / `lem:pullback_tensor_iso` path). `lem:pullback_lan_decomposition` (D1, already PROVEN
  axiom-clean) is retained as off-path general infrastructure — note it is no longer load-bearing.
- **Update `lem:pullback_tensor_iso`** (the old general iso, ~L2734): either retarget it to the
  loc-triv-restricted statement or supersede it by the new `lem:pullback_tensor_iso_loctriv` and
  demote it with a NOTE. Make the live `\uses{}` graph consistent: `lem:isinvertible_pullback` must
  `\uses` the loc-triv comparison iso, `lem:pullback_tensor_map`, `lem:pullback_unit_iso`,
  and (transitively) `tensorObj_isLocallyTrivial`'s cover and `isIso_of_isIso_restrict`.
- **`lem:isinvertible_implies_locallytrivial`** (the forward bridge, ~L3150): keep it OFF-path and
  add a NOTE that it is Mathlib-scale AND unnecessary (the consumer carries `IsLocallyTrivial`
  directly; only the easy reverse `exists_tensorObj_inverse` is used).

## Citations / sources

- The new route's geometric content is Stacks `lemma-pullback-invertible`
  (`references/stacks-modules.tex`, ~L4142, already cited in the section) and `01HH` (pullback of a
  locally trivial / invertible sheaf is locally trivial). Keep/reuse the existing verbatim
  `% SOURCE QUOTE` blocks; if you restate, the verbatim quote must remain byte-faithful. Do NOT
  fabricate new quotes — if you need a quote not already present, open `references/stacks-modules.tex`
  and copy it verbatim (you have `references/**` write access for a child reference-retriever if a
  source is genuinely missing).
- The Mathlib idioms (`Functor.OplaxMonoidal.δ_natural`, `δ_comp_η_tensorHom`, `comp_δ`,
  `conjugateEquiv_pullbackComp_inv`) are implementation hints for the prover — name them in prose as
  the expected Mathlib API, not as cited theorems.

## Out of scope
- Do NOT touch other sections of the chapter (the group-law engine §, the d.2 stalk-tensor §, the
  Route-(e) §, the OnProduct lift §).
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed by sync_leanok / review).
- Do NOT write Lean tactic code — mathematical prose only.
- Do NOT edit `RelPicFunctor`/`LineBundlePullback` chapters this pass (RPF authoring is a later iter;
  the carrier-pivot rewrite is RETRACTED — no RPF chapter change is needed).
