# Lean Audit Report

## Slug
iter007

## Iteration
008

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (namespace placement)
- **excuse-comments**: none
- **notes**:
  - **Line 823 — stale status comment.** The block beginning `### Status (iter-006): ...`
    says under TARGET 3 item (b): *"Cosyzygy SES infrastructure: `Zᵐ := ker(Jᵐ → Jᵐ⁺¹)` with
    `0 → Zᵐ → Jᵐ → Zᵐ⁺¹ → 0` short exact ... NOT yet built."* This is directly contradicted
    by the new `section Cosyzygy` (lines 685–820) which contains `Functor.cosyzygyShortExact`
    (the full short-exact structure), `Functor.cosyzygyShortComplex`, `cosyzygyKernelFork`,
    `Functor.cohomologyAppliedResolutionIso`, and `Functor.gHomologyZeroIso` — i.e. the bulk
    of what (b) describes. The heading also still reads `iter-006` while the file is now at
    iter-007/008. A reader arriving after the new section will be misled into believing (b) is
    unstarted when most of it is complete.
  - **Lines 729, 737 — namespace mismatch.** `Functor.cosyzygyShortComplex` and
    `Functor.cosyzygyShortExact` take a `CochainComplex 𝒜 ℕ` as their first argument; neither
    takes a functor. Placing them in the `Functor.` namespace is misleading — they belong in a
    `CochainComplex.` or top-level `CategoryTheory.` namespace. The downstream functor-bearing
    declarations (`gCosyzygyIsoCocycles`, etc.) that sit beside them *do* involve a functor, so
    the grouping is understandable, but the namespace choice misdescribes the domain of the
    first two.
  - **Lines 390, 489, 500, 504, 525, 548 — pre-existing linter warnings.**
    `linter.unusedSectionVars` fires on six lemmas inside `section OfShortExact` because
    `[HasInjectiveResolutions 𝒜]` is auto-included but unused. Each should carry
    `omit [HasInjectiveResolutions 𝒜] in`. Pre-existing; not introduced this iteration.
  - **Line 537 — pre-existing style warning.** `show` used where `change` is required (linter
    `style.show`). Pre-existing.
  - **All 11 new Cosyzygy declarations verified axiom-clean and sorry-free** (LSP
    `lean_verify` result: only standard Lean axioms `propext`, `Classical.choice`,
    `Quot.sound` for every declaration; no `sorryAx`).
  - `cosyzygy_iCycles_comp_toCycles`: correct — rewrites via `toCycles_i` and `iCycles_d`.
  - `epi_toCycles_of_exactAt`: correct — extracts the epimorphism from `homologyIsCokernel`
    under `IsZero` of homology; `ExactAt` hypothesis genuinely consumed.
  - `cosyzygyKernelFork`: correct — the kernel of `toCycles` equals the kernel of `d` because
    `d = toCycles ≫ iCycles`; `cyclesIsKernel` is reused soundly.
  - `Functor.cosyzygyShortComplex`: straightforward packaging; no issues.
  - `Functor.cosyzygyShortExact`: correct — uses `exact_of_f_is_kernel`, `infer_instance` for
    `Mono`, and `epi_toCycles_of_exactAt` for `Epi`; all three fields are filled non-vacuously.
  - `Functor.gCosyzygyIsoCocycles`: correct — uses `isLimitForkMapOfIsLimit'` to transfer the
    kernel limit through `G`; `PreservesFiniteLimits` hypothesis is genuinely required (it
    implies preservation of equalizers/kernels).
  - `Functor.gCosyzygyIsoCocycles_hom_iCycles`: correct — one-liner from
    `conePointUniqueUpToIso_hom_comp` at `WalkingParallelPair.zero`.
  - `Functor.gCosyzygyIsoCocycles_toCycles`: correct — cancels the mono `iCycles (m+1)` on
    both sides and uses `toCycles_i` + `G.map_comp`; `PreservesFiniteLimits` is consumed via
    `gCosyzygyIsoCocycles_hom_iCycles`.
  - `Functor.cohomologyAppliedResolutionIso`: correct — `cokernel.mapIso` rewrites the
    `toCycles` inside `homologyIsCokernel` via `gCosyzygyIsoCocycles_toCycles`; the iso chain
    is coherent; `PreservesFiniteLimits` is consumed.
  - `Functor.gHomologyZeroIso`: correct — two-step chain `gCosyzygyIsoCocycles K 0 ≪≫
    CochainComplex.isoHomologyπ₀`; `isoHomologyπ₀` identifies H⁰ of a ℕ-indexed cochain
    complex with its degree-0 cocycles (no incoming differential).

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 773–774 (`CechAcyclic.affine`) and 810–811 (`cech_computes_higherDirectImage`)
    carry `sorry`.** Both are explicitly documented as open gaps with proof sketches; the
    `sorry`s are expected and acknowledged. LSP confirms `sorryAx` is present.
    `cech_computes_higherDirectImage` is the frozen protected declaration; its `sorry` is
    the project's primary remaining obligation.
  - **`pushPullMap_comp` and `rawPushPullMap_comp` now closed** (lines 628–630, 536–620):
    LSP verifies both are axiom-clean (no `sorryAx`). The long comment block at lines
    245–449 describing the prior blocker and the resolution route is now accurate history
    rather than forward-looking analysis — not stale in the sense of being wrong, but
    increasingly a maintenance burden as the proof is complete.
  - Lines 257–259: pre-existing line-length linter warnings (100-char limit). Minor.

### `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Clean. Single declaration `higherDirectImage` is a straightforward `rightDerived`
    application; no sorry; no linter warnings.

### `AlgebraicJacobian.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Root re-export file. Three import lines only. Clean.

---

## Must-fix-this-iter

*(None.)*

No declaration has a sorry that was not already known and documented, no excuse-comment, no
weakened or wrong definition, and no non-standard axiom.

---

## Major

- `AcyclicResolution.lean:823` — Status comment says "Status (iter-006): ... REMAINING (TARGET 3)
  needs (b) Cosyzygy SES infrastructure ... NOT yet built." The cosyzygy SES infrastructure
  described as missing is now present in the same file (lines 685–820). The comment misleads a
  reader about what remains. Should be updated to reflect that the cosyzygy SES and
  `cohomologyAppliedResolutionIso`/`gHomologyZeroIso` are complete, while the remaining gap is
  the full `Hⁿ(G(J•)) ≅ (R¹G)(Zⁿ⁻¹)` identification and the augmentation `H⁰ ≅ G(A)` (as
  opposed to `G(Z⁰)`).

---

## Minor

- `AcyclicResolution.lean:729,737` — `Functor.cosyzygyShortComplex` and
  `Functor.cosyzygyShortExact` live in the `Functor.` namespace but neither involves a functor
  argument. `CochainComplex.cosyzygyShortComplex` or a top-level name under
  `CategoryTheory.` would be more descriptive.
- `AcyclicResolution.lean:390,489,500,504,525,548` — pre-existing `linter.unusedSectionVars`
  warnings; six lemmas inside `section OfShortExact` auto-include `[HasInjectiveResolutions 𝒜]`
  without using it.
- `AcyclicResolution.lean:537` — pre-existing `linter.style.show` warning.
- `CechHigherDirectImage.lean:257–259` — pre-existing line-length linter warnings.

---

## Excuse-comments (always called out separately)

None. No excuse-comment was found in any project source file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 4 (2 new + 2 pre-existing clusters)
- **excuse-comments**: 0

Overall verdict: The file is sound for this iteration — all 11 new Cosyzygy declarations are
sorry-free, axiom-clean, and correctly structured; the major finding is a stale status comment
that describes the cosyzygy SES as missing when it is now complete.
