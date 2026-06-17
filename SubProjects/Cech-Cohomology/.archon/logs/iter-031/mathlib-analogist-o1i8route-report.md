# Mathlib Analogist Report

## Mode
api-alignment

## Slug
o1i8route

## Iteration
031

## Question
For `F : (Spec R).Modules`, pick the Mathlib-aligned route to
`[IsQuasicoherent F] → IsIso F.fromTildeΓ` (Stacks 01I8), the last input upgrading
`qcoh_iso_tilde_sections` to its unconditional qcoh form; name the first atomic sub-lemma; flag
missing Mathlib API — or find a Mathlib shortcut the prover missed.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Mathlib shortcut exists? | NO — absent | informational |
| Route choice (G vs P vs descent) | NEEDS_MATHLIB_GAP_FILL — build **Route P** | informational |

## Shortcut check — NEGATIVE (high confidence)
No `[IsQuasicoherent F]→IsIso fromTildeΓ`, no `→ essImage tilde`, no `QCoh(Spec R) ≃ Mod R` in
Mathlib. The `IsQuasicoherent` section of `Tilde.lean` ends at `isIso_fromTildeΓ_of_presentation`
(line 398); the only `IsIso fromTildeΓ` producers are structure sheaf / free / **global**
`Presentation`. `Quasicoherent.lean`'s `QuasicoherentData.bind` + `IsQuasicoherent.of_coversTop`
glue *local qcoh → global qcoh* (wrong direction). No `LocalGeneratorsData→GeneratingSections`
globalizer, no qcoh kernel/cokernel closure. The prover's grep was correct.

## Informational

**Route P (global generation, Hartshorne II.5.14-17) is the choice** — NEEDS_MATHLIB_GAP_FILL but
the lowest-LOC, best-reuse, lowest-risk path:
- Reuses Mathlib `isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) AND the project's already-built
  `isIso_fromTildeΓ_of_genSections` (QcohTildeSections.lean:116).
- Local→tilde is **free**: a `QuasicoherentData` presentation of `F.over (basicOpen f)` is a
  presentation on `Spec R_f`, so `isIso_fromTildeΓ_of_presentation` gives `F.over D(f) ≅ tilde Mᵢ`
  with zero new work.

**Route G (module gluing) REJECTED**: no `Module.GlueData` in Mathlib; the only module descent
(`ModuleCat/Descent.lean`) proves extension-of-scalars is *comonadic* only — the effective-descent
**equivalence** is an explicit Mathlib TODO. Route G = build that equivalence + FF-ness of
`R→∏R_{fᵢ}` + sheaf→descent-data translation: the biggest, riskiest option.

**First lane for iter-032** (pure topology, fully axiom-clean-able, prerequisite of P1/P2/P3):
```lean
lemma exists_finite_basicOpen_subcover {ι : Type*} (U : ι → (Spec R).Opens)
    (hU : ⨆ i, U i = ⊤) :
    ∃ (n : ℕ) (f : Fin n → R) (φ : Fin n → ι),
      (∀ j, PrimeSpectrum.basicOpen (f j) ≤ U (φ j)) ∧ Ideal.span (Set.range f) = ⊤
```
Builds on `PrimeSpectrum.isBasis_basic_opens` (Topology.lean:587), `PrimeSpectrum.compactSpace`
(Topology.lean:291), `PrimeSpectrum.iSup_basicOpen_eq_top_iff` (Topology.lean:628). Then sequence
P1 (localized sections) → P2 (global generation) → P3 (kernel qcoh) → P4 (= `isIso_fromTildeΓ_of_genSections`).

**Genuine Mathlib gaps to log as a chain** (not blind sorries):
1. Localized sections for qcoh `Γ(D(f),F)=Γ(X,F)_f` — present only for `tilde M` (Tilde.lean:115).
2. `tilde` preserves kernels / exactness — Mathlib has additive + colimit-preserving + cokernels,
   no `PreservesFiniteLimits`.
3. qcoh closed under kernels — recoverable from (2) + `IsQuasicoherent.of_coversTop` (Quasicoherent.lean:377).

## Persistent file
- `analogies/o1i8-qcoh-tilde-route.md` — full route analysis + decomposition for future iters.

Overall verdict: no Mathlib shortcut exists; build Stacks-01I8 via **Route P (global generation)**,
first lane the pure-topology `exists_finite_basicOpen_subcover`, with P1/tilde-exactness/kernel-qcoh
flagged as the explicit downstream gap chain.
