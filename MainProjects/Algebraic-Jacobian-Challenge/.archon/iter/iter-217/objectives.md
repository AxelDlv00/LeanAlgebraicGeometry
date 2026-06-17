# Iter-217 objectives (detail)

## Lane TS — `Picard/TensorObjSubstrate.lean` [prover-mode: fine-grained]

**Goal:** build the de-risked H1 ingredient and CLOSE the substrate linchpin
`tensorObj_restrict_iso` — target a real sorry elimination (project count 81→80, the
first in 7 iters). Blueprint: `chapters/Picard_TensorObjSubstrate.tex`
(`lem:tensorobj_restrict_iso`, `lem:restrictscalars_ringiso_strongmonoidal`,
`lem:tensorobj_assoc_iso`). Exact recipe with on-disk decl paths: `analogies/ts217.md`.

### Ordered atomic targets (each a named lemma — close or fail fast)

1. `PresheafOfModules.pushforwardNatTrans` — de-sheafify the sheaf-level version
   `Mathlib/.../SheafOfModules/Sheaf/PushforwardContinuous.lean:154` minus `.val`
   (~15–25 LOC). [verified present at sheaf level by analogist ts217]
2. `PresheafOfModules.pushforwardCongr` — mirror `Sheaf/…:73` via
   `PresheafOfModules.isoMk` + `ModuleCat.restrictScalarsCongr` (exists) (~6–10 LOC).
3. `PresheafOfModules.pushforwardPushforwardAdj` — mirror `Sheaf/…:226` using the
   already-present presheaf `pushforwardId`/`pushforwardComp` + (1),(2); underlying
   `adj = IsOpenMap.adjunction`; `H₁`/`H₂` port the 6 lines at
   `AlgebraicGeometry/Modules/Sheaf.lean:346-353` (via `f.appIso`). (~40 LOC)
4. `pushforward β ≅ pullback φ := Adjunction.leftAdjointUniq (3)
   (PresheafOfModules.pullbackPushforwardAdjunction φ.hom)` — ~2 LOC. **Do NOT
   re-derive `pullbackPushforwardAdjunction`; it already exists (`Presheaf/Pullback.lean:50`).**
5. presheaf H2 lift: `(PresheafOfModules.restrictScalars α).Monoidal` via
   `Functor.Monoidal.ofLaxMonoidal` (`Monoidal/Functor.lean:696`) + app-wise iso ⇒
   presheaf iso (`PresheafOfModules.isoMk`), over the closed
   `restrictScalarsMonoidalOfRingEquiv`. Bounded, no Mathlib gap.
6. **CLOSE `tensorObj_restrict_iso`** via the chain `H1.symm ≫ H2 ≫ defeq` (Steps 1–3
   of its blueprint proof already in the Lean: reduce to pullback →
   `sheafificationCompPullback` → strip outer sheafification). → count 81→80.

### Bonus (only if budget remains after the count drops)

7. Re-route `tensorObj_assoc_iso` to rest on `tensorObj_restrict_iso` (glue the
   canonical local isos via "Hom-of-sheaves is a sheaf"), then DELETE the now-dead
   vestigial whiskering/stalk apparatus (`isLocallyInjective_whiskerLeft_of_W`,
   `W_whiskerLeft/Right_of_W`, `isIso_sheafification_map_of_W`, `stalkLinearMap*`) —
   confirm in-file-only first. → further −1 (removes the 6-iter wall sorry).

### Ride-along cleanup (lean-auditor ts216, 4 major — stale docstrings)
- Module `## Status` header still references the removed `monoidalCategory`.
- `tensorObj` / `tensorObj_functoriality` docstrings claim "typed sorry" on real bodies.
- `FlatWhisker` header contradicts the route pivot. Fix opportunistically while in-file.

### Reversal / INCOMPLETE gate
If targets (1)/(2) are NOT mechanical de-sheafifications — i.e. they need a further
Mathlib-absent primitive — STOP and return INCOMPLETE with the exact blocking decl.
Do NOT add the missing primitive as a new sub-build this iter; that would be the
iter-214 d.1 failure mode and triggers a substrate-design escalation next iter.

## Held this iter (rationale in PROGRESS.md / plan.md)
RPF, FGA (depend on the TS iso-class group); Quot/Cartier engine (gated A.2.c);
Route-2 Albanese (gated A.2.c); WeilDivisor (USER-blocked signature); all Route C +
A.3 lanes (USER standing directives). No un-gateable lane respects the standing
directives — TS is the sole ungated Route-A lane.
