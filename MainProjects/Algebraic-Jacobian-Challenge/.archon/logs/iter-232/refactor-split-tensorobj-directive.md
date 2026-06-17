# Refactor directive — split `Picard/TensorObjSubstrate.lean`

## Goal
Split the 2375-line `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` into
semantically-coherent sub-files. Motivation: (a) USER standing directive
"PARALLELISM VIA FILE SPLITTING"; (b) isolate the live ⊗-inverse C-bridge build
into a small dedicated file so future provers do not pay the 2375-line context
cost (the iter-231 prover named this as the practical blocker); (c) quarantine
the vestigial d.2 apparatus + the dead slice-site root.

## Critical context (low-risk split)
- The file is a **LEAF**: the only importer is the root aggregator
  `AlgebraicJacobian.lean` line 20 (`import AlgebraicJacobian.Picard.TensorObjSubstrate`).
  No other `.lean` imports it. So the split cannot break any downstream consumer.
- **No protected declarations** live in this file (verified against `archon-protected.yaml`).

## Hard constraints
1. **Preserve the public import surface.** Keep `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
   as the file that the root imports; have it `import` the new sub-files at its top
   so `import AlgebraicJacobian.Picard.TensorObjSubstrate` continues to transitively
   expose **every** declaration it currently exposes.
2. **NO new sorries.** The file currently has exactly **3 code sorries**:
   `isLocallyInjective_whiskerLeft_of_W` (≈L691), `exists_tensorObj_inverse` (≈L2210),
   `addCommGroup_via_tensorObj` (≈L2256). They MOVE verbatim with their declarations.
   Total project sorry count must stay **80**. Do NOT insert any new sorry anywhere.
3. **Pure moves only.** Do not rename, re-type, reorder arguments, or alter any
   declaration body. Preserve all `namespace ... end` / `section ... end` nesting
   correctly across the new files (re-open the same namespaces in each file).
4. **`lake build` GREEN at the end.** Run `lake build` (or `lake env lean` on each
   affected file) and confirm exit 0. If a move would break the build and you cannot
   fix it by wiring imports, STOP and report — do NOT paper over it with a sorry or a
   `maxHeartbeats` bump.

## Proposed decomposition (follow the SEMANTIC `/-! … -/` section + `namespace`/`section`
## grouping; the line numbers are estimates — group by the section headers, not literals)

Place new files under `AlgebraicJacobian/Picard/TensorObjSubstrate/`.

### File 1 — `TensorObjSubstrate/Vestigial.lean`  (QUARANTINE; keep, do NOT delete)
Move these sections out of the main file:
- `FlatWhisker` + `WhiskerOfW` (≈L426–748): `toPresheaf_whiskerLeft_*`,
  `isLocallySurjective_whiskerLeft`, `isLocallyInjective_whiskerLeft_of_flat`,
  `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`,
  `isLocallyInjective_whiskerLeft_of_W` (carries the ≈L691 sorry),
  `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`, `isIso_sheafification_map_of_W`.
- `StalkLinearMap` (≈L750–867): `stalkLinearMap`, `stalkLinearMap_germ`,
  `stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso`.
- `OverSliceSheafEquiv` (≈L2264–2375): `overEquiv_image_cover_iff`,
  `overEquivInverseIsDenseSubsite`, `overSliceSheafEquiv` (axiom-clean; serves only
  the not-yet-built A-engine — quarantine but keep intact).

### File 2 — `TensorObjSubstrate/PresheafInternalHom.lean`  (foundational presheaf layer + C-bridge substrate)
Move:
- `RestrictScalarsRingIsoTensor` (≈L103–340).
- `restrictScalars` lax-monoidal (≈L342–424): `restrictScalarsLaxε/μ`.
- `PushforwardNatTrans`/`PushforwardCongr`/`PushforwardAdj` (≈L869–988).
- `StrongMonoidalRestrictScalars` (≈L990–1028): `isIso_of_isIso_app`,
  `restrictScalarsMonoidalOfBijective`.
- The whole `InternalHom` + `Dual` block (≈L1030–1611).
This file is where the upcoming incremental C-bridge sub-build will land.

### File 3 — `TensorObjSubstrate.lean`  (remaining; the public API + consumer)
Keep here (and add `import`s of File 1 + File 2 at the top, plus File 1 only if a
kept decl genuinely references it — e.g. if `tensorObj_assoc_iso` uses
`W_whiskerLeft_of_W`; determine from actual references):
- `AlgebraicGeometry.Scheme.Modules`: `tensorObj`, `tensorObj_functoriality`,
  `IsInvertible`, `Scheme.Modules.dual`, `dualIsoOfIso`, unitors/braiding/assoc
  (≈L1613–2030), `tensorObj_restrict_iso`, `tensorObj_isLocallyTrivial`,
  `isIso_of_isIso_restrict`, `homMk`/`toPresheaf_map_homMk`, `exists_tensorObj_inverse`
  (≈L2210 sorry), `tensorObjOnProduct`, `PicSharp.addCommGroup_via_tensorObj` (≈L2256 sorry).
- You MAY delete the dead iter-230 diagnostic COMMENT block (≈L2118–2161) IF it is a
  pure `/-! … -/` comment containing no declaration and removal is obviously safe;
  otherwise leave it untouched.

## Import order
PresheafInternalHom is foundational (no dependency on the main file). The main file
depends on PresheafInternalHom. Vestigial is likely standalone. Resolve exact import
edges by reading the actual cross-references before wiring.

## Report
Final file list; which declarations landed in which file; the new location of each of
the 3 sorries; confirmation of `lake build` exit 0 and unchanged total sorry count (80).
