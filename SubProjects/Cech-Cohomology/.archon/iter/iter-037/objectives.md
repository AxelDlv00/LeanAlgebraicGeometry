# Iter-037 objectives (dispatched)

## Lane 1 — `QcohRestrictBasicOpen.lean` [mathlib-build] — the bridge
Build (do not yet exist): B2 `presentationOverBasicOpen`, B3 `overBasicOpenIsoRestrict` (load-bearing),
B4 `presentationModulesRestrictBasicOpen`.
- Blueprint: `lem:presentation_over_basicOpen`, `lem:restrict_over_compat`,
  `lem:presentation_modulesRestrictBasicOpen`.
- B3 engine: `SheafOfModules.pushforwardPushforwardEquivalence` at the open-subscheme site equivalence.
  Distinct from `lemma-widetilde-pullback`; NOT discharged by `modulesRestrictBasicOpenIso`.
- B2/B4: `Presentation.map` / `Presentation.ofIsIso`. Independent of B3 (do them even if B3 stalls).
- Recipe + Mathlib citations: `analogies/bridge.md`.

## Lane 2 — `QcohTildeSections.lean` [mathlib-build] — over-picture extraction
Build (does not yet exist): B1 `qcoh_finite_presentation_cover`.
- Blueprint: `lem:qcoh_finite_presentation_cover`. Recipe: `analogies/bridge.md` step B1.
- `QuasicoherentData F` → `⨆ Uᵢ=⊤` → `exists_finite_basicOpen_subcover` → finite `D(gⱼ)⊆U_{φⱼ}`,
  `span{gⱼ}=R`, each with `Presentation (F.over U_{φⱼ})`. Independent of Lane 1 this iter.

## Gating evidence (all this iter)
- mathlib-analogist `bridge`: PROCEED, B0–B6, B3 single load-bearing lane, `IsLocalizing` absent.
- blueprint-reviewer `bchain`: HARD GATE PASS, both files clear.
- strategy-critic `iter037`: SOUND.
- progress-critic `iter037`: CHURNING → corrective = decompose+build (D1/D3 in plan.md).

## Deferred to iter-038
- Keystone assembly + Route B assembly (after B1–B4 land); add `import QcohRestrictBasicOpen` to
  QcohTildeSections then.
- Blueprint soon-fixes: B3 φ/ψ sketch detail; keystone `\uses` += `lem:restrict_obj_mathlib`; refresh
  `rem:o1i8_decomposition` item-1.
