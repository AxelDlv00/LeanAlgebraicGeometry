# Iter-164 objectives detail

## Lane 1 — `AbelianVarietyRigidity.lean` (no-regret cleanup; HARD GATE cleared `avr-fastpath2`)

Hygiene only — no new sorries, no touching proven proofs / the 3 scaffold bodies / protected sigs.

### (A) Docstring refresh (primary)
The file's comments describe the ABANDONED Thm-3.2/cube/𝔾_a-additive route. Refresh to current reality:
- `morphism_P1_to_grpScheme_const` docstring (≈L910-912) + file header (≈L32-33): drop "rests on the
  theorem of the cube" / Thm-3.2 framing → the 𝔾_m-scaling shortcut (proven Cor 1.5 + `ext_of_eqOnOpen`).
- ~6 now-false "lone residual `sorry`" / "Status (iter-160): sorry" comments on the PROVEN chain
  lemmas (per iter-163 lean-auditor: ≈L29, L239, L255, L408-410, L485, L644-645, L669-671, L757-759).
  The chain is sorry-free since iter-162.

### (B) Cor 1.5 / Cor 1.2 hyp generalization (optional; revert if it breaks the build)
Try dropping `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]` from the `A`-side of
`hom_additive_decomp_of_rigidity` (and the knock-on `B`-side of `av_regularMap_isHom_of_zero`) —
lean-auditor flagged them possibly-unused (only `GrpObj A` + `IsProper A.hom ⟹ IsSeparated` needed).
If removing breaks the build, REVERT — they were load-bearing.

## Deferred to iter-165 (gated on an api-alignment consult)
- Scaffold `ProjectiveLineBar`, `Gm`/`Ga`, `gmScalingP1` (σ_×) per `def:genus0_base_objects` /
  `def:gaTranslationP1`.
- Refine `morphism_P1_to_grpScheme_const` from the abstract `P1` proxy to the concrete
  `ProjectiveLineBar` (avr-fastpath2 "soon" note).
- Prove the scaling shortcut (Cor 1.5 + σ_× fixed point + `ext_of_eqOnOpen`).
