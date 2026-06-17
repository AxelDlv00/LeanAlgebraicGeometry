# Strategy Critic Report

## Slug
iter036

## Iteration
036

## Routes audited

### Route: 01I8 `F≅~(ΓF)` via section-localization (Route B) — the iter-036 pivot

- **Goal-alignment**: PASS — delivers the unconditional `qcoh_iso_tilde_sections` that 02KG's gated top theorems consume; that feeds Route A acyclicity → the frozen target.
- **Mathematical soundness**: PASS — the keystone (section-restriction `Γ(X,F)→Γ(D(f),F)` is `IsLocalizedModule (.powers f)` for qcoh `F`) is the genuine irreducible core (Stacks 01HV / Hartshorne II.5.5). Non-circular: it bottoms out on per-`D(gᵢ)` presentations + tilde **right-**exactness (colimit preservation as a left adjoint) to identify `F|_{D(gᵢ)}≅~M_i`, then Mathlib tilde-on-basic-open sections; gluing uses the standard-cover Čech exactness of P3 (`sectionCech_affine_vanishing`), which is proved combinatorially WITHOUT affine vanishing. So no use of 02KG affine vanishing anywhere in the chain that produces it. See soundness clarification below.
- **Sunk-cost reasoning detected**: no — the pivot explicitly abandons the shipped Route-P `QcohRestrictBasicOpen`/`TildeExactness` work and demotes it to "dormant assets". That is the opposite of sunk-cost: it drops invested code because Route B is sounder.
- **Infrastructure-deferral detected**: no — the hardest prerequisite genuinely CHANGES across the pivot (Route P's hardest = absent-Mathlib tilde base-change `tilde_restrict_basicOpen` + `tildePreservesFiniteLimits` + qcoh-closed-under-kernels; Route B's hardest = 01HV section-localization via span-cover descent, built from the DONE P1b + P3). Route B trades avoidable absent-Mathlib walls for the irreducible mathematical core. This is a real pivot, not a rename of the same gap.
- **Phantom prerequisites**: none — `AlgebraicGeometry.Scheme.Modules.fromTildeΓ`, `isIso_fromTildeΓ_of_presentation`, `isIso_fromTildeΓ_iff_isLocalizing`, `IsLocalizing`/`isLocalizing_tilde`/`isLocalizing_of_isIso_app_top` all VERIFIED in `Mathlib.AlgebraicGeometry.Modules.Tilde`.
- **Effort honesty**: reasonable — ~3–5 iters / ~250–450 LOC is in the right ballpark; mild under-count risk lives in the "transfer through cokernel" + tilde-right-exactness identification (universe/defeq friction is the usual tax here), but the DONE P1b + P3 carry most of the weight.
- **Verdict**: SOUND

### Route: 02KG `affine_serre_vanishing` (cover-system + affine instantiation)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — cover-system chain complete + `Cov`-correctness fixed; two top theorems correctly gated on unconditional `qcoh_iso_tilde_sections` and explicitly held ("do NOT dispatch until 01I8 closes"), which is the right defense against FALSE-ready graph nodes.
- **Verdict**: SOUND

### Route: A — acyclic-resolution comparison (CHOSEN) + the acyclicity bridge

- **Goal-alignment**: PASS — ONE abstract lemma (P4, done) replaces spectral sequences; directly yields `Hⁱ(f_*C•)≅Rⁱf_*F`.
- **Mathematical soundness**: PASS — the torsor-free acyclicity bridge (P3 standard-cover vanishing → `injective_cech_acyclic`+`ses_cech_h1`+01EO dimension shift → affine sheaf vanishing) correctly breaks the circular regress by never invoking affine vanishing to prove affine vanishing. Bricks (1)(2) + 01EO done.
- **Verdict**: SOUND

### Route: B — two spectral sequences (REJECTED)

- **Verdict**: SOUND (correct rejection — both spectral sequences are absent from Mathlib / multi-thousand-LOC).

### Route: Absolute cohomology — Ext of corepresenting object (Form B)

- **Goal-alignment**: PASS — `H^p(U,F):=Ext^p(jShriekOU U,F)` keeps the SES inside `X.Modules`, so injective vanishing/LES/H⁰≅Γ are off-the-shelf; done iter-028.
- **Verdict**: SOUND

## Format compliance

- **Size**: ~120 lines / ~9 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — per-iter tags leak into prose cells outside the `## Completed` Iters column: `"PIVOT iter-036 (mathlib-analogist ...)"` and `"P1 (reframed iter-036)"` (Phases table, 01I8 row), `"Cov-correctness-fixed iter-035"` (Phases table, 02KG row), `"01I8 Route B (section-localization ...) — PIVOT iter-036"` (Open strategic questions). The pivot rationale may stay; the `iter-035`/`iter-036` tags are per-iter history and belong in the iter sidecar.
- **Accumulation detected**: no — completed phases are all in `## Completed` (6 rows, within bound); active table holds only ACTIVE/BLOCKED phases.
- **Table discipline**: FAIL — the `## Phases & estimations` "Risks" and "Key Mathlib needs" cells are multi-sentence paragraphs (the 01I8 Risks cell runs ~5 lines), violating "one short line per cell". Push the detail into `## Routes` / `## Open strategic questions`.
- **Format verdict**: DRIFTED

## Alternative routes (suggested)

### Alternative: route 01I8 through Mathlib's `IsLocalizing` Prop directly

- **What it looks like**: instead of "check `fromTildeΓ` on the basis `{D(f)}` by hand", use the verified Mathlib equivalence `isIso_fromTildeΓ_iff_isLocalizing : IsIso M.fromTildeΓ ↔ IsLocalizing (modulesSpecToSheaf.obj M)`, then discharge `IsLocalizing` (a Prop already shaped as "the `D(f)`-restriction maps are localizations") with the span-cover keystone, leaning on `isLocalizing_tilde`, `isLocalizing_of_isIso_app_top`, and `isLocalizing_iff_of_iso`.
- **Why it might be cheaper or sounder**: it replaces the project's bespoke "forget/toSheaf reflects isos ⟹ check basis ⟹ each component is `IsLocalizedModule.lift`" scaffold (P2/P3 of the Open-questions sketch) with one named Mathlib iff plus a Prop that is definitionally the keystone — fewer hand-built reflection steps, less defeq surface.
- **What the current strategy may have rejected**: unclear — the strategy/analogist never name `IsLocalizing` or `isIso_fromTildeΓ_iff_isLocalizing`, so this looks un-surveyed rather than rejected.
- **Severity of the omission**: minor (the strategy's path is equivalent; this is a leverage opportunity that de-risks the iso-reflection plumbing).

## Must-fix-this-iter

- Format: DRIFTED — strip per-iter tags (`iter-035`/`iter-036`, "PIVOT iter-036", "reframed iter-036") from the `## Phases` table and `## Open strategic questions` prose, and collapse the multi-sentence `## Phases` "Risks"/"Key Mathlib needs" cells to one short line each (move detail into `## Routes`). Restructure in place this iter.

## Overall verdict

The strategy is strategically SOUND. The iter-036 01I8 pivot from Route P (tilde base-change + `tildePreservesFiniteLimits` + kernel-qcoh, all absent-Mathlib walls) to Route B (section-localization keystone fed to Mathlib's `fromTildeΓ`) is a genuine pivot, not infrastructure-deferral: the hardest prerequisite changes from artifacts of a heavy packaging to the irreducible mathematical core (01HV section-localization), and that core is non-circular with the 02KG affine vanishing it feeds (it descends through the DONE P1b span-cover engine + P3 standard-cover Čech exactness, neither of which uses affine vanishing). All load-bearing Mathlib names are verified present. No infrastructure-deferral findings; no goal weakening (the `HasInjectiveResolutions → EnoughInjectives` connector reconciles the cone with the frozen target's weaker hypothesis). One soundness clarification worth recording explicitly in STRATEGY: the per-`D(gᵢ)` bottoming-out must identify `F|_{D(gᵢ)}≅~M_i` via tilde RIGHT-exactness (colimit preservation), NOT a left-exact-sections computation of an abstract cokernel — the latter would silently re-introduce affine `H¹`-vanishing and reopen the circularity. The only must-fix is format: DRIFTED (per-iter narrative in prose table cells + over-long table cells); fix in place this iter. Also consider leveraging `isIso_fromTildeΓ_iff_isLocalizing` / `IsLocalizing` (verified) to simplify the iso-reflection plumbing of Route B.
