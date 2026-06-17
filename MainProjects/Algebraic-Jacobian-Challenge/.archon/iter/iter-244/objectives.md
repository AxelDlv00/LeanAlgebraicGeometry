# Iter-244 — prover objectives (detail)

One lane this iter. `[prover-mode: mathlib-build]` — bottom-up, no sorry pins (each step fully proved or
absent with a precise handoff). Lane 2 (FlatBaseChange) is HELD (see PROGRESS.md Held lanes).

---

## Lane 1 — `Picard/TensorObjSubstrate.lean` (CRITICAL PATH, A.1.c substrate)

**Route settled (analyst presheaf-pullback-strong + strategy-critic ts244 + progress-critic ts244):** the
substrate `IsInvertible.pullback` is Mathlib-scale via every route, so the project **commits to building the
concrete strong-monoidal inverse-image pullback** rather than hunting a cheaper surface route. This is genuine
Mathlib-absent infrastructure (the missing `SheafOfModules`/`PresheafOfModules` pullback `.Monoidal`). Build
it bottom-up. Blueprint: `chapters/Picard_TensorObjSubstrate.tex` § `sec:tensorobj_pullback_monoidality`
(HARD GATE CLEARS, blueprint-reviewer ts244). **Read that section — the D1–D4 decomposition is the recipe.**

Build in order (each new decl axiom-clean; go as far as you can; hand off a precise decomposition where blocked):

1. **D1 — `pullback_lan_decomposition`** (`lem:pullback_lan_decomposition`; self-name the Lean decl, suggested
   `pullbackLanDecomposition`): `PresheafOfModules.pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`
   (Mathlib `…/Presheaf/Pushforward.lean:86`), so taking left adjoints `PresheafOfModules.pullback φ ≅
   extendScalars φ ⋙ pullback₀`, where `pullback₀ = (pushforward₀ F R).leftAdjoint`. A NatIso of functors.
   Most self-contained brick; establish it first.

2. **D2 — scalar half is strong (free).** `extendScalars φ` is strong monoidal via
   `TensorProduct.AlgebraTensorModule.distribBaseChange` (`Mathlib/Algebra/Category/ModuleCat/Monoidal/
   Adjunction.lean`). Use it to reduce "presheaf δ is iso" to "`pullback₀` δ₀ is iso". (The comparison MAP
   `pullbackTensorMap` is already built; this is about iso-ness.)

3. **D3 — `pullback0_tensor_iso`** (`lem:pullback0_tensor_iso`, `\lean{…pullback0TensorIso}`): the GENUINE
   build. `pullback₀ = Lan (Opens.map f.base)ᵒᵖ`; pointwise `pullback₀(M⊗N)(V) = colim_{(F↓V)}(M(U)⊗N(U))`,
   and `(F↓V) = {U : f⁻¹V ⊆ U}` is up-directed (`U₁∪U₂` upper bound), so the diagonal is final and the
   tensor product commutes with the filtered colimit ⟹ δ₀ iso. This needs a concrete pointwise-colimit `Lan`
   model + filtered-colimit/⊗ interchange for `ModuleCat`-valued presheaves — **Mathlib-absent, the
   multi-hundred-LOC content.** Build bottom-up; if you stop, hand off the precise missing sub-lemma.
   - **Available bricks to leverage:** `SheafOfModules.pullbackObjFreeIso` (Mathlib, `…/Sheaf/PullbackFree.lean`
     — pullback of a free sheaf is free, gated `[F.Final]`) and `pullbackObjUnitToUnit` anchor the
     free/trivial case; `distribBaseChange` ✓, `leftAdjointUniq` ✓, `sheafifyTensorUnitIso` ✓,
     `pullbackTensorMap` ✓ (the map) are in hand.

4. **D4 — assemble `pullbackTensorIso`** (`lem:pullback_tensor_iso`, `\lean{…pullbackTensorIso}`) if D1–D3
   land: sheafify the presheaf iso (`sheafifyTensorUnitIso`) + transport the monoidal structure from the
   concrete model to the abstract `Scheme.Modules.pullback` via `Adjunction.leftAdjointUniq` (the iter-217
   `tensorObj_restrict_iso` device). Yields the general iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N`.

5. **`IsInvertible.pullback`** (`lem:isinvertible_pullback`) — the 3-line Stacks corollary if D4 lands:
   witness `f^*N`, iso `(pullbackTensorIso)⁻¹ ≫ (pullback f).mapIso e ≫ pullbackUnitIso` on `e : M⊗N≅𝒪`.

**Guardrails:**
- Do NOT seek a cheap δ-iso / "3-line proof without the build" — the build IS the content (analyst-confirmed).
- Do NOT pursue the locally-free/dual route (`LF1⟹IsInvertible`) — re-enters the shelved dual-gluing.
- Do NOT prove δ iso stalkwise (no presheaf-of-modules stalk in Mathlib).
- Do NOT touch the group-law section or the deferred dual-bridge sorries (`exists_tensorObj_inverse` L715,
  `addCommGroup_via_tensorObj` L1269).
- Stay axiom-clean; no sorry pins (mathlib-build invariant).

**Secondary cleanup (lean-auditor ts243 majors — do only if cheap, no proof risk):**
- `tensorObj_assoc_iso` docstring (~L302–340): strike the stale flatness-route text; the proof is
  UNCONDITIONAL (`W_whiskerRight/Left_of_W`, no flatness). 
- File header (~L43–45) + L302–303: remove the stale claim that `isLocallyInjective_whiskerLeft_of_W` is an
  open sorry-residual (it closed iter-237 in Vestigial.lean).
