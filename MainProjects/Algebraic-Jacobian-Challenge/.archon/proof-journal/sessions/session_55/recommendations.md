# Recommendations for the next plan-agent iteration (iter-056)

## Headline

**Iter-055 closes the iter-053 → iter-054 → iter-055 scaffolding chain.** With the existence-form producer `hasAffineCechAcyclicCover_of_basicOpen` + `_curve` now in scope, **the Phase A step 6 *Path 2* / Serre-finiteness producer pipeline is fully wired on the scaffolding side**: any iter-056+ work supplying per-affine basic-open `IsCechAcyclicCover F (basicOpenCover s)` + `HasCechToHModuleIso F (basicOpenCover s)` evidence can call `hasAffineCechAcyclicCover_of_basicOpen_curve h` directly to produce the iter-053 carrier `HasAffineCechAcyclicCover (toModuleKSheaf C)`, which fires iter-053's producer instance for `IsAffineHModuleVanishing` automatically. Iter-056+ work pivots to **the substantive Koszul + Čech-derived comparison content branch**.

## Phase A iterations-remaining (held at ~5 per the iter-055 prompt)

The chain ahead:

- **iter-056 (basic-open Koszul acyclicity)** — Step 4.6.3, prove `IsCechAcyclicCover (toModuleKSheaf C) (basicOpenCover s)` for spanning `s`. Estimate: 2-4 iterations, ~150-250 LOC. Substantive computational step. The Čech complex on basic opens of an affine `Spec A` evaluates to the alternating-sum complex on localisations `n ↦ ⨁_{i_0..i_n ∈ s} M_{f_{i_0..i_n}}` for `M` the `Γ(C, U)`-module structure of `(toModuleKSheaf C).obj U`, exact when `f_i` generate the unit ideal. References: Hartshorne III.3.5, Stacks 02FQ, Eisenbud Commutative Algebra §17 Koszul resolution.
- **iter-058+ (Čech-vs-derived comparison)** — Step 4.6.4, the substantive multi-iteration construction of the comparison iso `cechCohomology C F 𝒰 n ≡ₖ HModule' k F n (⨆𝒰)` via the dual chain-level Mayer-Vietoris sheaf-resolution route (Stacks 01EO). Estimate: 4-6 iterations, ~200-400 LOC. **Should not start until iter-056/057 lands** — Koszul exactness is a prerequisite of step (1) of the construction (the sheaf-level complex is exact in positive degrees iff the local-section complex on each `𝒰_{i_0..i_p}` is the Koszul complex of localisations exact under unit-ideal hypothesis).
- **iter-064+ (final packaging + genus carrier assembly)** — instantiate `HasAffineCechAcyclicCover (toModuleKSheaf C)` via `hasAffineCechAcyclicCover_of_basicOpen_curve h` (iter-055's producer), which fires iter-053's `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` automatically. Then chain with iter-046's H⁰ ladder + iter-035/049 transport to derive the genus carrier `Module.Finite k (HModule k (toModuleKSheaf C) 1)` at universe `u+1`.

## Recommended primary track for iter-056

### Track 2A.3a (recommended, iter-056 prover lane): basic-open Koszul acyclicity

**Plan-agent should commission an analogy subagent first to scope Mathlib's existing Koszul / Localization-exactness machinery.** The 8x cost differential between Mathlib-backed wrapper (~10-20 LOC) and project-local introduction (~80-150 LOC) warrants an upfront audit. Specifically the analogy subagent should investigate:

1. `Mathlib.RingTheory.Spectrum.Prime.Sheaf` — basic-open localisation evaluation of structure-sheaf-flavoured presheaves.
2. `Mathlib.LinearAlgebra.Koszul` (if present) or `Mathlib.RingTheory.Localization.AtPrime` — Koszul complex of localisations in mathlib form.
3. `Mathlib.AlgebraicGeometry.Cech` (or any Mathlib Čech-machinery) — does Mathlib have a "Čech complex on basic opens of an affine reduces to Koszul complex" theorem already?
4. `Mathlib.Algebra.Homology.HomologicalComplex` and `Mathlib.LinearAlgebra.AlternatingMap` — Lean infrastructure for alternating-sum cochain complexes.

If a Mathlib-backed wrapper exists, iter-056 should be a thin wrapper iteration (~10-20 LOC, pattern-matching iter-054's three-line theorem bodies). If no Mathlib backing, iter-056 should sub-decompose into:
- **iter-056a (algebraic Koszul step, ~80-150 LOC)** — prove the alternating-sum complex `n ↦ ⨁_{i_0..i_n ∈ s} M_{f_{i_0..i_n}}` is exact under `Ideal.span s = ⊤`.
- **iter-056b (sectional identification, ~50-100 LOC)** — identify the Čech complex of `toModuleKSheaf C` on `basicOpenCover s` with the alternating-sum complex of localisations.
- **iter-056c (assembly, ~50-100 LOC)** — package as `IsCechAcyclicCover (toModuleKSheaf C) (basicOpenCover s)` instance under the iter-048 carrier shape.

Cleanly split into three sub-iterations following the iter-046 multi-block pattern.

## Alternative warm-up tracks (plan-agent's call)

### Track 2B (alternative, off-critical-path): finrank corollary of iter-046 producer

Explicit identity `Module.finrank k (HModule k (toModuleKSheaf C) 0) = Module.finrank k Γ(C, 𝒪_C)`. Plausibly single-iteration ~30-50 LOC. Off-critical-path; useful for direct genus computation in concrete cases. Could be slotted in between iter-056 and iter-057 if iter-056 lands quickly and the analogy subagent surfaces a Mathlib-backed Koszul wrapper.

### Track 2C (alternative, off-critical-path): sharper Mayer-Vietoris LES consumer

For the curve case. Plausibly single-iteration ~30-50 LOC. Off-critical-path; useful for diagnostic tooling but not required for the genus assembly.

### Track 2D (low-priority off-Archon side track): Mathlib upstream PRs

For the five new `CategoryTheory.*` declarations from iter-046, the `Ext.chgUnivLinearEquiv` from iter-034, and the iter-054 `IsAffineOpen.iSup_basicOpen_basicOpen_eq` candidate (n-fold intersections — needs upstream check whether Mathlib already has an equivalent under a different name).

## Reusable proof patterns (carry forward to iter-056+)

1. **Existence-bundling producer pattern** *(iter-055, generalises iter-053)* — when a universal abstract producer takes an existence hypothesis, the natural specialisation to a concrete cover form (here basic-open) is a thin destructure-and-bundle wrapper. Body shape: `obtain ⟨...⟩ := h hU; exact ⟨..., concreteCover s, concreteCover_supr_lemma hU s hs, ...⟩`. Reusable for any future producer that takes a basic-open form (or another concrete cover form) and lifts it to the iter-053 carrier shape.
2. **`where field {U} hU := by ...` clause for class instantiation with per-affine field** *(iter-055, new this iteration)* — when constructing a `Prop`-valued class instance whose single field is per-affine `∀ {U}, IsAffineOpen U → ∃ ...`, the canonical Lean 4 syntax is the `where field {U} hU := by ...` clause. Cleaner than the `instance` form when the producer takes user-supplied hypotheses.
3. **Term-mode one-liner `_curve` wrapper** *(iter-055, generalises iter-039 → iter-053)* — when specialising at `F := toModuleKSheaf C`, the term-mode one-liner `producer h` works directly without named-argument disambiguation. Cleanest `_curve` body shape; use this form by default for iter-056+ `_curve` companions.

## Process discipline carry-forward

- **Verbatim probe-confirmed body, single combined Edit, zero corrective Edits**: now nine iterations in a row (iter-047 → iter-055). Continue as default protocol.
- **Plan-agent `lean_run_code` probe before commissioning the prover**: confirmed scaling cleanly across nine consecutive iterations including iter-055's two-declaration heterogeneous cohort with `where` clause + term-mode one-liner. Keep doing this — the up-front probe cost is small and the saved corrective-Edit cost is large.
- **Blueprint-subsection / `\leanok`-pre-mark discipline**: now five iterations in a row (iter-051 → iter-055). Continue as default protocol.
- **`blueprint/lean_decls` clear-as-you-go**: now sixteen iterations in a row (iter-040 → iter-055). Continue.
- **LOC band trend**: iter-055 reverted to band-compliant (+50 vs `+40-60` plan band). Maintain `+40-60` band for thin scaffolding iterations; widen to `+100-300` for substantive iter-056+ Koszul iteration.

## Things NOT to do in iter-056

- Do **not** retry the 5 protected `Jacobian.lean` sorries — Phase C step 4 + `noncomputable` user-decision blocks them.
- Do **not** retry the 3 protected `AbelJacobi.lean` sorries — structurally downstream of `Jacobian C`.
- Do **not** close `PicardFunctor.representable` (line 190) — deferred per directive.
- Do **not** consolidate iter-053/054/055 scaffolding — the three-step decomposition mirrors iter-047's foundational pattern; consolidating would re-derive infrastructure at every call site.
- Do **not** promote iter-055's `hasAffineCechAcyclicCover_of_basicOpen` from `theorem` to `instance` — typeclass synthesis cannot supply the explicit per-affine `h` argument at call sites.
- Do **not** fold iter-055's `_curve` body to use a named-argument `(F := toModuleKSheaf C)` — Lean's elaborator infers `F` from the conclusion automatically, so the named-arg is unnecessary noise (contrast with iter-053's `_curve` body which kept the named-arg out of caution).
- Do **not** start the iter-058+ Čech-vs-derived comparison branch before iter-056+ Koszul acyclicity lands — Koszul exactness is a prerequisite of step (1) of the comparison construction.
