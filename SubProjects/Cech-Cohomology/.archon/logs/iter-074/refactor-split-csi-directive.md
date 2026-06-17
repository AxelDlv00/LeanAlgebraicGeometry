# Refactor Directive

## Slug
split-csi

## Problem
`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` is **2475 LOC**. It no
longer verifies inline: `lake env lean` / `lake build <module>` on it OOM/timeout-kill
(exit 137/144; background `lean` >6 min). The two residual atomic sorries
(`coreIso_comm_leg` @≈1536, `sectionCechAugV_π` @≈2081) are sound and blueprint-complete,
but a prover cannot land an edit it cannot lake-verify, so the file is stuck on tooling.
Split it into smaller modules so each sorry-bearing leaf sits in its own small file that
builds in available memory on top of a cached upstream `.olean`. This also lets the two
leaves be proved by **parallel** provers.

## Mathematical Justification
The file is already a clean linear dependency chain. Three contiguous blocks, no
back-edges:
1. **Base** — all proved infrastructure: the `CategoryTheory`/`FinitaryPreExtensive`
   block, the geometric backbone (`cechBackbone_left_sigma`), the push-pull product
   decomposition (`pushPull_sigma_iso`, `pushPull_sigma_iso_π`, `pushPull_leg_sections`,
   `pushPull_eval_prod_iso`), the augmentation-iso helpers (`mapHC_augment_iso`,
   `augmentCochainIso`, `coverInterOpen_inf_eq_iInf_inf`), and the degreewise object iso
   `coreIso_objIso`. All sorry-free. Ends just before the `coreIso_comm` chain.
2. **Leg** — the `coreIso_comm` chain section: `abHom_finsetSum_apply`,
   `coreIso_comm_leg` (the sorry), `coreIso_comm_coface`, `coreIso_comm_sum`,
   `coreIso_comm`. Depends only on Base (`coreIso_objIso`, `pushPull_*`).
3. **Rest** — the section/augmentation + contractibility block: `sectionCechAugV`,
   `sectionCechAugV_comp_d`, `cechSection_complex_iso`, the `stub*`/`cechSection*`
   private engine, `sectionCechAugV_π` (the sorry), the Stub6 homotopy engine, and
   `cechSection_contractible`. Depends on Base AND Leg (`cechSection_complex_iso` and
   `sectionCechAugV_comp_d` call `coreIso_comm`).

Moving a contiguous block to a new upstream module changes no declaration name, type, or
namespace — only file location and `import` edges — so every `\lean{}` blueprint pin and
every downstream consumer (`CechAugmentedResolution.lean` uses `cechSection_complex_iso`
and `cechSection_contractible`) keeps resolving. No proof is touched; the two existing
sorries simply move with their declarations.

## Changes Requested

Create two new files and shrink the existing one. All three keep
`namespace AlgebraicGeometry` (and the inner `namespace CategoryTheory`/
`FinitaryPreExtensive` lives only in Base). Replicate the needed `open` lines
(`open CategoryTheory Limits Opposite`, `open Scheme.Modules`, `universe u`, etc.) in
each new file's header. Keep the Apache license header on each.

- **New file: `AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean`**
  - Imports: the same three the current file has
    (`CechHigherDirectImage`, `CechAcyclic`, `FreePresheafComplex`).
  - Content: current lines ≈ 6–1495 — the header docstring (trim the now-stale
    iter-072 status paragraph), the `CategoryTheory`/`FinitaryPreExtensive` block, and
    every `AlgebraicGeometry` declaration **up to and including `coreIso_objIso`**
    (last decl before the `coreIso_comm` chain section comment). Sorry-free.

- **New file: `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean`**
  - Imports: `AlgebraicJacobian.Cohomology.CechSectionIdentificationBase`.
  - Content: the entire `coreIso_comm` chain — `abHom_finsetSum_apply`,
    `coreIso_comm_leg`, `coreIso_comm_coface`, `coreIso_comm_sum`, `coreIso_comm`
    (current lines ≈ 1496–1746). Carries the `coreIso_comm_leg` sorry. ~250 LOC.

- **Edit (keep name): `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`**
  - Imports: `AlgebraicJacobian.Cohomology.CechSectionIdentificationLeg` (transitively
    Base). Drop the three original imports if Leg re-exports them transitively (it does);
    keep whichever Lean needs.
  - Content: `sectionCechAugV` through `cechSection_contractible`
    (current lines ≈ 1748–2475). Carries the `sectionCechAugV_π` sorry. ~730 LOC.

- **Edit: `AlgebraicJacobian.lean`** — add
  `import AlgebraicJacobian.Cohomology.CechSectionIdentificationBase` and
  `import AlgebraicJacobian.Cohomology.CechSectionIdentificationLeg` immediately before
  the existing `import AlgebraicJacobian.Cohomology.CechSectionIdentification` line.

- **`CechAugmentedResolution.lean`** — its `import …CechSectionIdentification` is
  unchanged (transitively pulls Base+Leg). Touch only if a name fails to resolve.

### Private-declaration visibility
Several helpers are `private`. A `private` decl is invisible across a file boundary. For
each `private` decl whose users now sit in a different module, move it **down** to the
lowest module that all its users can import (almost always: leave Base privates in Base;
if a Base private is used by Leg or Rest, either move it to Base and keep it `private`
within Base only if Base also uses it — otherwise drop `private` so downstream can see
it). Prefer keeping `private` where possible; only un-`private` a helper when a genuine
cross-module user requires it, and list every such case in your report.

## Affected Files
`CechSectionIdentification.lean` (shrunk), two new modules, `AlgebraicJacobian.lean`,
possibly `CechAugmentedResolution.lean`.

## Expected Outcome
- Three modules, each compiling. Base + the Stub6 engine portion of Rest are sorry-free.
- Exactly the two pre-existing sorries survive, unmoved in content:
  `coreIso_comm_leg` (now in `CechSectionIdentificationLeg.lean`) and
  `sectionCechAugV_π` (in the shrunk `CechSectionIdentification.lean`).
- **No new sorries.** If a cross-boundary break forces one, STOP and report it — that
  signals the cut line is wrong, not that a sorry is acceptable.
- `#print axioms` unchanged for the moved declarations (no kernel-soundness regression).

## Verification
Build each new module bottom-up so an OOM is localized: build Base first, then Leg, then
the shrunk CSI. If Base itself OOMs, report it (it would mean Base also needs splitting —
do NOT proceed blindly). Confirm `CechAugmentedResolution.lean` still elaborates.
Report per-module compile status and the exact final line of each sorry.
