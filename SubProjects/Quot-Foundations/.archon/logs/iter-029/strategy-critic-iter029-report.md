# Strategy Critic Report

## Slug
iter029

## Iteration
029

## Routes audited

### Route: FBC (affine lemma + globalization)

- **Goal-alignment**: PARTIAL — produces `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`, but whether the *canonical-map-is-iso* form (Seam 3) is actually demanded is an unresolved upstream question (Open Q2), and that question gates the single most expensive piece of work.
- **Mathematical soundness**: PASS — section-level triangle (domain/codomain read + g^*-transpose = regroupEquiv⁻¹) is a faithful rendering of Stacks 02KH part 2; the tilde dictionaries and regroupEquiv are closed.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags.
- **Phantom prerequisites**: none in FBC (all verified).
- **Effort honesty**: under-counted (optimism) — FBC-A revised *down* to 1–2 iters after a 10+-iter overrun, justified by "the diamond mechanism is concrete" rather than by demonstrated velocity.
- **Verdict**: CHALLENGE

### Route: GF (generic flatness, geometric wrapper)

- **Goal-alignment**: PASS — wraps the DONE algebraic core into `genericFlatness` re-signed with the coherence encoding.
- **Mathematical soundness**: PASS — affine-open passage + finite affine source cover + flat-at-every-maximal conclusion is the standard Nitsure §4 geometrisation.
- **Infrastructure-deferral detected**: no (the G1 keystone IS scheduled — built QUOT-side as gap1's `isLocalizedModule_basicOpen`, with a concrete sub-build).
- **Phantom prerequisites**: `LocallyOfFiniteType.finiteType_appLE` — exact decl name NOT found (see Prerequisite verification); the *capability* exists via `AlgebraicGeometry.HasRingHomProperty.appLE` (LocallyOfFiniteType is a HasRingHomProperty), so this is a naming caveat, not a phantom.
- **Effort honesty**: reasonable, with a caveat — GF-geo is marked `ACTIVE` but its principal bridge G1 is gated on the QUOT keystone; only G3 (flat-locality) is independently workable. The 2–4 estimate is contingent on the keystone landing first.
- **Verdict**: SOUND (with the appLE naming caveat and the ACTIVE-status caveat below)

### Route: QUOT (Hilbert polynomial / Quot / Grassmannian / repr)

- **Goal-alignment**: PARTIAL — GR-glue/GR-repr (the actual `thm:grassmannian_representable`, with constant Φ_d) need neither the Serre canonicity nor tensor-power infra and are sound. But `def:hilbert_polynomial` (a named goal item) and the SNAP/general-Quot lane sit behind two *alternative* hard prerequisites — SheafOfModules tensor powers (geometric route) OR a Serre `m≫0` agreement (algebraic-presentation route) — both currently unscheduled.
- **Mathematical soundness**: PASS — Route-2 ambient-subquotient rationality engine (DONE, axiom-clean) correctly sidesteps the quotient-carrier isDefEq pathology; the gap1 reduction is a genuine decomposition, not a renaming pivot (see below).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — SheafOfModules tensor powers of `L_s` + lax-monoidal Γ (blocking `def:sectionGradedRing` ⟹ SNAP) is named as a gap "owed before SNAP" with NO sub-build decomposition and NO iter estimate. See Infrastructure-deferral findings.
- **Phantom prerequisites**: none — `Polynomial.existsUnique_hilbertPoly`, `IsAffineOpen.isLocalization_basicOpen`, `Functor.representableByEquiv`, `Scheme.GlueData`, `Scheme.IdealSheafData`, `DirectSum.Decomposition.ofLinearMap` all VERIFIED.
- **Effort honesty**: GR-glue under-counted — `## Completed` shows GR-cells (charts+cocycle alone) realized ~600 LOC over 2 iters; GR-glue's "build glued scheme → separated → proper" at 1–3 iters / ~120–320 LOC is optimistic, especially properness of the Grassmannian (valuative criterion / universal closedness — thin in Mathlib). The table Risks cell says "→ proper" while the Routes prose scopes GR-glue as glue+separated only; reconcile.
- **Parallelism under-exploited**: no — GR-glue and GF-G3 are correctly identified as keystone-independent lanes that proceed while gap1 is built; the shared keystone is correctly built once in QuotScheme rather than duplicated.
- **Verdict**: CHALLENGE (on the `def:hilbert_polynomial` prerequisite scheduling; the Grassmannian sub-lane itself is SOUND)

## Format compliance

- **Size**: 166 lines / 17388 bytes — **over budget** (~250 lines OK, but ~12 KB exceeded by ~45%).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — e.g. `"was OVER_BUDGET: entered iter-018, est 2–4, 10+ elapsed"` (Phases table), `"now reduced (iter-028)"`, `"confirmed iter-026"`, `"iter-028 established (source-grep verified)"`, `"Decision (iter-024)"`, and two `"…this iter"` clauses. Bare iter numbers in `## Completed`'s ledger are fine, but these are in the active Phases table and Routes prose — they belong in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no completed phase left in the active table; `## Completed` has 7 rows (within bound). The bloat is prose density, not accumulation of finished phases.
- **Table discipline**: FAIL — multiple cells are multi-sentence paragraphs rather than "one short line": the FBC-A `Iters left` cell, the FBC-A and QUOT-defs `Risks` cells. This is the main driver of the byte overage.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: SheafOfModules tensor powers of `L_s` (+ lax-monoidal `Γ`) ⟹ `def:sectionGradedRing`

- **Required by goal**: partially — required for a *geometric* `def:hilbert_polynomial` (graded ring ⊕ Γ(L_s^m)) and for SNAP. NOT required for `thm:grassmannian_representable` (constant Φ_d). Whether the goal's `def:hilbert_polynomial` item must be the geometric/canonical one is exactly Open Q1.
- **Current plan for building it**: none with structure — "Mathlib-gradient sub-build, owed before SNAP." No decomposition, no anchor lemmas named, no iter estimate.
- **Timeline**: absent (SNAP carries a 3–6 estimate, but the tensor-power prerequisite is not surfaced inside it).
- **Verdict**: CHALLENGE — decompose the tensor-power/lax-monoidal-Γ build into concrete sub-steps with an iter estimate, OR resolve Open Q1 to confirm `def:hilbert_polynomial` is goal-satisfiable via the algebraic-presentation route (which instead needs the Serre `m≫0` agreement — itself currently unscheduled, so the deferral is not escaped, only relocated).

Note: the geometric route (tensor powers) and the algebraic-presentation route (Serre `m≫0` agreement) are two *alternative* hard prerequisites for the SAME goal item. Both are presently deferred. At least one must acquire a concrete build plan before any SNAP/Hilbert-polynomial prover effort is justified.

## Alternative routes (suggested)

### Alternative: lean harder on Mathlib's Mates calculus to shortcut FBC Seam 3

- **What it looks like**: The project already builds `conjugateEquiv_counit_symm` atop Mathlib's `CategoryTheory.conjugateEquiv` (the mates API, VERIFIED present in `Adjunction/Mates.lean`). Before hand-assembling the 5-lemma gstar chain, check whether the mate/conjugate naturality squares (`conjugateEquiv_comm`, `conjugateEquiv_comp`, VERIFIED present) discharge the g^*-transpose coherence directly, identifying the canonical base-change map with regroupEquiv⁻¹ via the mates square rather than via manual counit transport.
- **Why it might be cheaper or sounder**: it would replace the bespoke, instance-diamond-prone term-mode splicing (the `X.Modules` composed-⋙ vs nested-obj diamond) with library lemmas that are already diamond-tested.
- **What the current strategy may have rejected**: plausibly already tried — the residual 5-lemma chain may be exactly what the mates calculus does NOT give for `SheafOfModules` pushforward. Unclear from prose.
- **Severity of the omission**: minor.

## Sunk-cost flags

- `"the gstar route is structurally advancing (step-1 + scaffold landed, now a 5-lemma chain), so continue it; revisit only if the chain stalls ≥2 iters"` — Why this is sunk-cost: it justifies continuing the longest-overdue lane (10+ iters over its 2–4 estimate) by appeal to accumulated scaffolding and a "now concrete" mechanism, while the *cheap* upstream check that could moot the entire chain (Open Q2: does the parent consume "the canonical map is iso" or merely "∃ natural iso"?) is left open and not scheduled first. Recommendation: resolve Open Q2 by reading the parent cone's exact statement of `lem:affine_base_change_pushforward` THIS iter (a reference/source read, ~0 prover cost) before committing another 1–2 prover iters to Seam 3. If the parent states "the base-change map is an isomorphism" (the standard 02KH form, likely), Seam 3 is genuinely unavoidable and the chain is justified on merits — but confirm it; if it only needs ∃-iso, regroupEquiv (DONE) already suffices and Seam 3 is dead weight.
- `"1–2 (was OVER_BUDGET ... now revised down — the diamond mechanism is concrete)"` — Why this is sunk-cost: an estimate revised *downward* after a 10+-iter overrun, justified by mechanism-concreteness rather than by realized velocity, is optimism, not evidence. Recommendation: justify the 1–2 with a demonstrated step landing, or widen it.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED
- `IsAffineOpen.isLocalization_basicOpen`: VERIFIED (as `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`)
- `CategoryTheory.Functor.representableByEquiv`: VERIFIED
- `Module.flat_of_isLocalized_maximal`: VERIFIED
- `Module.Flat.ker_lTensor_eq` / `Module.Flat.eqLocus_lTensor_eq` (module `Mathlib.RingTheory.Flat.Equalizer`): VERIFIED
- `CategoryTheory.Adjunction.comp_counit_app`: VERIFIED
- `CategoryTheory.conjugateEquiv` (+ `_comm`, `_comp`): VERIFIED (base for project's `conjugateEquiv_counit_symm`)
- `IsIntegral.exists_multiple_integral_of_isLocalization`: VERIFIED
- `AlgebraicGeometry.Scheme.GlueData`: VERIFIED
- `AlgebraicGeometry.Scheme.IdealSheafData`: VERIFIED
- `DirectSum.Decomposition.ofLinearMap`: VERIFIED
- `LocallyOfFiniteType.finiteType_appLE`: MISSING (as named) — capability present via `AlgebraicGeometry.HasRingHomProperty.appLE`; rename/re-anchor before relying on it.

## Must-fix-this-iter

- Route FBC: CHALLENGE — resolve Open Q2 (parent's consumption of `lem:affine_base_change_pushforward`: canonical-iso vs ∃-iso) via a source read BEFORE sinking another 1–2 prover iters into the gstar Seam 3 chain; it could moot the chain. Re-justify the down-revised 1–2 estimate on velocity, not mechanism-concreteness.
- Route QUOT: infrastructure-deferral CHALLENGE — `def:hilbert_polynomial`/SNAP sits behind two unscheduled hard prerequisites (SheafOfModules tensor powers OR a Serre `m≫0` agreement). Decompose at least one with an iter estimate, or resolve Open Q1 to confirm the goal's `def:hilbert_polynomial` item is satisfiable without it.
- Phantom prerequisite `LocallyOfFiniteType.finiteType_appLE`: re-anchor to `HasRingHomProperty.appLE` (exact name absent).
- Format: DRIFTED — file is 17.4 KB (>12 KB) and carries per-iter narrative in the active Phases table and Routes prose (`OVER_BUDGET`/`iter-018`/`iter-024`/`iter-026`/`iter-028`/`this iter`). Compress the multi-sentence `Iters left`/`Risks` cells to one short line each and move the iter-by-iter narrative to `iter/iter-029/plan.md`. In-place trim this iter.

## Overall verdict

The strategy is fundamentally sound: the decomposition into FBC/GF/QUOT leaves is clean, parallelism is well-exploited (GR-glue and GF-G3 correctly routed around the shared gap1 keystone, which is correctly built once in QuotScheme rather than duplicated), the rationality engine is DONE axiom-clean, and every load-bearing Mathlib name I checked is real — no phantom infrastructure. The gap1 reduction is a legitimate mathlib-contributor decomposition (it confirmed the hard qcoh affine-descent globalization cannot be dodged and shrank the surround to one named sub-build), not an avoidance pivot. Three things must be addressed before committing this iter's prover effort: (1) FBC-A shows live sunk-cost reasoning — a 10+-iter-overdue lane whose estimate was revised *down* on mechanism-concreteness, while the cheap upstream check (Open Q2) that could moot its hardest piece is left unscheduled; do that read first. (2) The strategy defers the SheafOfModules tensor-power construction (and, on the alternative route, the Serre `m≫0` agreement), which is required for the goal item `def:hilbert_polynomial`/SNAP, with no concrete sub-build or timeline for either alternative — decompose one or resolve Open Q1. (3) Format is DRIFTED: 17.4 KB over the 12 KB budget with per-iter narrative leaking into the active table and Routes prose; trim in place. None of these is a REJECT — the Grassmannian representability sub-lane in particular is unblocked and sound.
