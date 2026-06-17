# Iter-245 — prover objectives (detail)

One lane this iter. `[prover-mode: mathlib-build]` — bottom-up, no sorry pins (each step fully proved or
absent with a precise handoff). FlatBaseChange HELD; RPF opens next iter (see PROGRESS.md).

---

## Lane 1 — `Picard/TensorObjSubstrate.lean` (CRITICAL PATH, A.1.c substrate) — ROUTE PIVOTED iter-245

**Route (settled this iter by two analyst passes, adversarially checked — `analogies/invertible-loctriv-bridge.md`
and `analogies/rpf-pullback-bridge-granularity.md`):** the iter-244 *general* strong-monoidal inverse-image
pullback build (`pullback₀ = Lan`, filtered-colimit/⊗ interchange) is **ABANDONED** — it is unnecessary. The
only consumer (the relative Picard functor) needs the comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N` only on
**locally-trivial (line-bundle) pairs**, where it is a chart-chase, not a general construction. Two errors in
the prior reasoning were corrected:
1. The forward bridge `IsInvertible ⟹ IsLocallyTrivial` is Mathlib-scale but **off-path** — the consumer
   carrier `OnProduct` (`LineBundlePullback.lean:130`) is `{M // IsLocallyTrivial M}`.
2. The "δ is not an iso" obstruction (`Γ(ℙ¹,𝒪(1))=0`) is about the LAX tensorator of PUSHFORWARD (right
   adjoint), NOT the OPLAX δ of PULLBACK (left adjoint). On locally-trivial objects, δ IS an iso.

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` § `sec:tensorobj_pullback_monoidality` (HARD GATE CLEARS,
blueprint-reviewer loctriv-regate). **Read that section — D1'–D4' is the recipe.**

Build in order (each new decl axiom-clean; go as far as you can; hand off a precise decomposition where blocked):

1. **D1' — `pullbackTensorMap_natural`** (`lem:pullback_tensor_map_natural`): naturality of the sheaf-level
   oplax comparison map `pullbackTensorMap` (= δ_sheaf, already a sorry-free `def` at L1199) in the pair
   `(M,N)`. Assemble from Mathlib `Functor.OplaxMonoidal.δ_natural` [expected] + the naturality of the
   sheafification reconciliation pieces (`sheafificationCompPullback`, `pullbackValIso`, `sheafifyTensorUnitIso`).
   ~40 LOC. Self-contained; first.

2. **D2' — `pullbackTensorMap_unit_isIso`** (`lem:pullback_tensor_iso_unit`): δ on the unit pair `(𝒪,𝒪)` is an
   isomorphism. Use `pullbackUnitIso` (`f^*𝒪 ≅ 𝒪`, axiom-clean, L1045) + the monoidal unitors + Mathlib
   `Functor.OplaxMonoidal.δ_comp_η_tensorHom` / `δ_comp_tensorHom_η` [expected] to exhibit δ_{(𝒪,𝒪)} as a
   composite of isos. ~40–80 LOC.

3. **D3' — `pullbackTensorMap_restrict`** (`lem:pullback_tensor_map_basechange`) — **THE SOLE genuinely-new
   sub-step.** δ commutes with the open-immersion base-change square `gᵢ : f⁻¹(Uᵢ) ⟶ Uᵢ`. This is the
   tensorator analog of the ALREADY-BUILT, axiom-clean `pullbackObjUnitToUnit_comp` (L902, ~85 LOC of mate
   calculus) — mirror its structure. Mathlib `Functor.OplaxMonoidal.comp_δ` [expected] +
   `conjugateEquiv_pullbackComp_inv`. ~80–150 LOC. If blocked, hand off the exact mate-calculus sub-goal —
   the unit analog being axiom-clean is strong evidence of feasibility.

4. **D4' — `pullbackTensorIsoOfLocallyTrivial`** (`lem:pullback_tensor_iso_loctriv`, the live target): for
   `M N : X.Modules` with `IsLocallyTrivial M`, `IsLocallyTrivial N`, the map `pullbackTensorMap` is an iso,
   giving `f^*(M⊗N) ≅ f^*M ⊗ f^*N`. Chart-chase over the common trivialising cover `{f⁻¹(Uᵢ)}` (the common
   refinement from `tensorObj_isLocallyTrivial`, L515): on each chart, D3' localises δ to `δ^{gᵢ}`, D1'
   (naturality) transports `(M|,N|)` to the unit pair `(𝒪,𝒪)`, D2' gives the iso there; conclude δ is an iso
   via `isIso_of_isIso_restrict` (✓ L546, restriction-detects-iso on a cover). Mirror the structure of
   `IsLocallyTrivial.pullback` (`LineBundlePullback.lean:156`). ~50–100 LOC.

5. **`IsInvertible.pullback`** (`lem:isinvertible_pullback`, now carries `IsLocallyTrivial M`, `IsLocallyTrivial N`
   hypotheses) — the corollary if D4' lands: for `e : M⊗N ≅ 𝒪`, witness `f^*N`, iso
   `(pullbackTensorIsoOfLocallyTrivial)⁻¹ ≫ (pullback f).mapIso e ≫ pullbackUnitIso`. ~15 LOC. (Not protected;
   the loc-triv hypotheses are new — the consumer-facing API can also be `pullbackTensorIsoOfLocallyTrivial`
   directly.)

**Reuse (all PROVEN, axiom-clean — do not rebuild):** `pullbackTensorMap` (L1199), `pullbackUnitIso` (L1045),
`isIso_of_isIso_restrict` (L546), `tensorObj_isLocallyTrivial` (L515), `pullbackObjUnitToUnit_comp` (L902).

**Guardrails:**
- Do NOT revive the general `pullback₀ = Lan` build, `pullback0_tensor_iso`, or the general `pullback_tensor_iso`
  — ABANDONED, off-path (blueprint blocks demoted with NOTEs).
- Do NOT build the forward bridge `IsInvertible ⟹ IsLocallyTrivial` (Mathlib-scale; off-path).
- Do NOT prove δ iso stalkwise (no presheaf-of-modules stalk in Mathlib).
- Do NOT touch the group-law section or the deferred dual-bridge sorries (`exists_tensorObj_inverse` L672,
  `addCommGroup_via_tensorObj` L1328).
- Stay axiom-clean; no sorry pins (mathlib-build invariant).

**Secondary cleanup (lean-auditor ts244 major — only if cheap, no proof risk):**
- File header (~L43–46): fix the misleading causal "so" linking `isLocallyInjective_whiskerLeft_of_W` (closed
  iter-237 in Vestigial.lean) to `tensorObj_assoc_iso` becoming unconditional — ROUTE (d) is independent of
  that lemma. (The 34 deprecated `Sheaf.val` warnings are a larger deferred polish pass — SKIP this iter.)
