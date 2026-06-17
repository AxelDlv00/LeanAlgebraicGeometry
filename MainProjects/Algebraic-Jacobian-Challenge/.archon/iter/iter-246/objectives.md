# Iter-246 objectives — full prover recipes

Two parallel lanes. Both blueprint chapters cleared the HARD GATE this iter
(blueprint-reviewer ts246, complete+correct, no must-fix, RPF dispatch explicitly approved).

---

## Lane TS — `Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build] — A.1.c.sub critical path

**Goal:** continue the loc-triv comparison-iso build. iter-245 landed the reduction brick
`isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (L1335, axiom-clean): every remaining target funnels
through the single goal `IsIso (a_Y.map (δ (pullback φ') M.val N.val))`. Build the next bricks bottom-up,
axiom-clean, as far as reachable. No sorry pins (mathlib-build).

**PRIMARY — D2' the η-bridge (`lem:pullback_tensor_iso_unit`).** Goal:
`IsIso (a_Y.map (η (PresheafOfModules.pullback φ')))` — the sheafified presheaf unit comparison is an iso.
- Route (verified-to-compile up to this sub-goal by the iter-245 prover): apply
  `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` to reduce the unit-pair target to
  `IsIso (a_Y.map (δ 𝟙_ 𝟙_))`; `(SheafOfModules.unit _).val = 𝟙_` by `rfl` (iter-245 asserted this in a
  comment — **verify it first** via `lean_goal`/`rfl`; lean-auditor ts245 flagged it unverified). Then
  Mathlib `Functor.OplaxMonoidal.left_unitality_hom` (exists, `Mathlib/CategoryTheory/Monoidal/Functor.lean`)
  expresses `δ 𝟙_ 𝟙_` through `η (pullback φ')`, `λ_`, and `F.map (λ_ 𝟙_)`; the unitors are isos; so the
  target reduces to `IsIso (a_Y.map (η (pullback φ')))`.
- **The genuine content** = the sheafification-mate bridge: `a_Y.map (η (pullback φ'))` is morally the
  sheaf-level `pullbackUnitIso` (`f^*𝒪 ≅ 𝒪`, L1045, axiom-clean) through `pullbackValIso` + the
  sheafification counit. This is the UNIT-SIDE ANALOG of the PROVEN axiom-clean `pullbackObjUnitToUnit_comp`
  (L902, mate calculus via `unit_conjugateEquiv`/`conjugateEquiv_pullbackComp_inv`). ~60–120 LOC.
- Mathlib hints: `Functor.OplaxMonoidal.left_unitality_hom` [expected]; `Functor.OplaxMonoidal.η`/`δ`;
  the adjunction-mate API used by `pullbackObjUnitToUnit_comp` [verified, in-file].

**THEN (as far as reachable, same lane):**
- **D3' `lem:pullback_tensor_map_basechange`** — the sole genuinely-new sub-step: the sheafified δ commutes
  with the open-immersion base-change square `gᵢ : f⁻¹Uᵢ → Uᵢ`. Mate calculus, the TENSORATOR analog of the
  proven `pullbackObjUnitToUnit_comp`. Mathlib `Functor.OplaxMonoidal.comp_δ` (exists, Functor.lean L347).
  Needs D2's η-bridge available to close each chart. **REVERSING SIGNAL (armed):** if D3' proves materially
  harder than its proven unit analog `pullbackObjUnitToUnit_comp`, decompose D3' further — do NOT revive the
  abandoned general Lan build.
- **D4' `lem:pullback_tensor_iso_loctriv` (`pullbackTensorIsoOfLocallyTrivial`)** — chart-chase via
  `isIso_of_isIso_restrict` (L546) over the common trivialising cover (mirror `IsLocallyTrivial.pullback`,
  `LineBundlePullback.lean:156`): D3' localises δ, D1' (naturality) transports to the unit pair, D2' closes,
  `isIso_of_isIso_restrict` globalises. Then `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` upgrades to
  `IsIso (pullbackTensorMap f M N)`.
- **`IsInvertible.pullback` (`lem:isinvertible_pullback`, loc-triv-hypothesised)** — 3-line corollary if D4'
  lands: witness `f^*N`, iso `(pullbackTensorIsoOfLocallyTrivial)⁻¹ ≫ f^*e ≫ pullbackUnitIso`.

**Reuse (all proven axiom-clean):** `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`(L1335),
`pullbackTensorMap`(L1199), `pullbackUnitIso`(L1045), `pullbackObjUnitToUnit_comp`(L902),
`isIso_of_isIso_restrict`(L546), `tensorObj_isLocallyTrivial`(L515).

**Guardrails:** Do NOT revive the abandoned general `pullback₀=Lan` build (`pullback0_tensor_iso`, general
`pullback_tensor_iso`, `pullbackLanDecomposition` are retained off-path — do not extend them). Do NOT build
the forward bridge `IsInvertible⟹IsLocallyTrivial` (Mathlib-scale, off-path). NO stalkwise δ-iso. Do NOT
touch the deferred sorries (`exists_tensorObj_inverse` L672, `addCommGroup_via_tensorObj` L1403).

**Secondary (cheap, no proof risk) — fix the 2 MAJOR stale comments the lean-auditor ts245 flagged:**
- L1232–1235 (`PullbackLanDecomposition` section header): still calls D1 part of "the committed general
  strong-monoidal pullback build" — superseded; mark D1 axiom-clean but off-path (loc-triv route is active).
- L1167–1173 (Phase-2 status comment): "iso-ness is genuine geometric content requiring the concrete model"
  — superseded; for line bundles iso-ness comes via the chart-chase, no concrete inverse-image model.
- Also (minor) the L100–113 "three files" sub-module layout comment (a 4th file `StalkTensor` is imported);
  and the L990–1013 section note on `pullbackObjUnitToUnit_comp` (now consumed by D3' as the unit analog).

---

## Lane RPF — `Picard/RelPicFunctor.lean` [prover-mode: prove] — A.1.c.fun (PARALLEL, A.2.c-feeding)

**Goal:** replace the opaque `exact sorry` at L269 (`PicSharp.addCommGroup`) with the real four-step
loc-triv construction from the blueprint (`lem:rel_pic_sharp_groupoid`, just rewritten + gate-cleared),
authored in PARALLEL against typed-sorry bridges. Land as much axiom-clean structure as reachable; partial
structural progress (the `OnProduct` group + setoid reconciliation) is the win. Leave a precise handoff.

**Construction (blueprint `lem:rel_pic_sharp_groupoid`, four steps):**
1. **`AddCommGroup` on `LineBundle.OnProduct πC πT`.** Addition `[L]+[L'] := [tensorObjOnProduct L L']`
   (`tensorObjOnProduct` L704, built; stays loc-triv by `tensorObj_isLocallyTrivial`). Zero `= [𝒪]`.
   Assoc/comm/unitality from `tensorObj_assoc_iso`/`tensorObj_braiding`/`tensorObj_left/right_unitor` — mirror
   the absolute `picCommGroup` construction (L813). Inverse `-[L] := [Linv]` from `exists_tensorObj_inverse`
   (L672 — **already returns a loc-triv witness** `IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ 𝒪)`,
   so group closure stays in the carrier; this lemma is itself a deferred sorry → cite it, the taint is the
   tracked reverse-bridge `IsLocallyTrivial⟹IsInvertible`).
2. **`pullbackHom : T.LineBundle →+ OnProduct`.** `map_zero` ← `pullbackUnitIso` (axiom-clean). `map_add` ←
   the loc-triv comparison iso `π_T^*(N⊗N')≅π_T^*N⊗π_T^*N'`. Since `pullbackTensorIsoOfLocallyTrivial` (D4')
   is not yet built (Lane TS), **declare a local typed-sorry bridge** in this file for the projection-
   specialised iso `OnProduct.pullback_tensorObj_iso` (gated on Lane TS D4' — sanctioned Mathlib-gradient
   parallelization), and consume it for `map_add`. Model on Mathlib `CommRing.Pic.mapAlgebra`/`.functor`.
   `H_T := pullbackHom.range`.
3. **Setoid reconciliation (NAMED sub-step — budget explicit effort; progress-critic ts246 flag).** Prove
   `RelPicPresheaf.preimage_subgroup πC πT` coincides with `QuotientAddGroup.leftRel H_T` — both encode
   `L ~ L' ↔ [Linv ⊗ L'] ∈ H_T`. Uses only the tensor inverse + group law (NOT the comparison iso's
   computational content), so this is axiom-clean modulo the `exists_tensorObj_inverse` taint. If it hits a
   missing lemma over `LineBundlePullback.lean` defns, that is a separate smaller obstacle — report it.
4. **Transport.** `Quotient (preimage_subgroup) ≃ OnProduct ⧸ H_T`; the RHS has
   `QuotientAddGroup.Quotient.addCommGroup`; transport via `Equiv.addCommGroup`
   (Mathlib `Algebra.Group.TransferInstance`) [expected].

**After `addCommGroup`:** upgrade `PicSharp.functorial` off the `0` stub if reachable (it consumes the
group structure; `lem:rel_pic_sharp_functorial`).

**Typed-sorry bridges (both tracked, both explicit objectives elsewhere):**
- `OnProduct.pullback_tensorObj_iso` (local, gated on Lane TS D4' `pullbackTensorIsoOfLocallyTrivial`).
- `exists_tensorObj_inverse` (existing sorry in TensorObjSubstrate.lean — cite, do not re-declare).

**Guardrails:** Do NOT edit `TensorObjSubstrate.lean` or `LineBundlePullback.lean` (other lanes/0-sorry).
Do NOT introduce the abandoned general strong-monoidal route. The `addCommGroup` body becomes a real
construction modulo the two named bridges — NOT a fresh opaque `sorry`.
