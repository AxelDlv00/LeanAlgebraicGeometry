All wrapped up. Final report:

## Summary
- **Two of the eight attackable Albanese sorries are closed, axiom-clean** (`propext, Classical.choice, Quot.sound` only): `gm_geometricallyReduced` (𝔾ₘ geometrically reduced, `Points.lean`) and `projectiveLineBar_geomIrred` (ℙ¹ geometrically irreducible, formerly `BareScheme.lean:220`, now proved in `ChartIso.lean`).
- Full `lake build` is **green**; Albanese sorry-carrying declarations drop **18 → 16**, all remaining ones are the blocked/hard set per `I-0007`/`I-0008`.

## Progress
- `Points.lean`: new `gmRing_tensor_isReduced` (`k̄[t,t⁻¹] ⊗[k̄] K` reduced via `cancelBaseChange` + `IsLocalization.tensor` + `isReduced_localizationPreserves`), feeding `gm_geometricallyReduced` via `pullbackSpecIso` (~55 LOC).
- `ChartIso.lean`: new section (~200 LOC) — topological lemma `irreducibleSpace_of_two_irreducible_opens`, `chartAway_tensor_isDomain`, per-chart `chartAway_geomIrred`, generic point `⟨⊥⟩`, and the `projectiveLineBar_geomIrred` instance (2-chart cover of the base change + surjectivity of the projection).
- `BareScheme.lean`: hoisted the inline cover span proof to the named `projectiveLineBarAffineCover_span` (needed by `Proj.iSup_basicOpen_eq_top`); scaffold instance replaced by a relocation NOTE (iter-197 precedent).
- Verified with `#print axioms`; ~8 build iterations, each 9–17 s.
- Inbox: progress comment on `I-0008`, resolution note on `I-0009` (harness works — this session ran), new memory `I-0013` with the full closure recipes and traps (namespace `IsReduced` clash, `open scoped TensorProduct in` placement, `ObjectProperty.prop_of_iso` eta-expansion trap, cover-index opacity workaround).

## Issues
- `CodimOneExtension` ×3 confirmed **not session-sized**: genuine Mathlib gaps (Stacks 00TT smooth⇒regular, 00OE smooth Krull-dimension, 0AVF depth-2 H¹ vanishing), each ~200+ LOC of new commutative algebra per the file's own analyses.
- `GmScaling` ×2 (cross01 closed-point check, `collapse_at_zero`) not attempted — the file's iter-184/189 notes mark them hardest; the chart-1 ring-map evaluation idiom is still missing.
- Blueprint: the Genus0 helper subsections (`sec:genus0_helpers`) are still empty placeholders; the new declarations should be pinned there in a blueprint pass. A stale iter-186 comment in `AbelianVarietyRigidity.tex` still calls `gm_geomIrred` sorry-bearing.
- Pre-existing (untouched): long-line lint at the iter-197 NOTE in `BareScheme.lean`; orphaned `RationalCurveIso.*` scratch in project root (janitor).

## Next
- Best remaining Albanese targets: `GmScaling` `collapse_at_zero` (a concrete iter-186 recipe exists in-file, ~30–50 LOC chart-1 section chase) before the cross01 sorry.
- `CodimOneExtension`/`Thm32` need a dedicated Mathlib-gap plan (00TT first — it gates both `localRing_dvr_of_codim_one` and Thm 3.2); `AlbaneseUP`/`FGA`/`WeilDivisor` stay gated on `AJC.pic0av`/`AJC.picrep`/upstream.
