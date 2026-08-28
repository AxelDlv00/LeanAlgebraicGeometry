Done. Report follows.

## 1. Measurement — re-derived, your numbers confirmed exactly

Own import-closure script (BFS from `AlgebraicJacobian.lean`, source-parsed imports):

| | |
|---|---|
| `.lean` on disk | **620** (619 library modules + root aggregator) |
| reachable from root | **526** |
| **UNROOTED** | **93** — 20,302 lines |
| dangling imports / cycles | 0 / 0 |

**New measurement you did not have — artifact state.** Using lake's own `.trace` records (each module's recorded `<dep>:importAllArts` hash vs. the value the *rooted* build records for the same dep), plus `.trace.nobuild` markers, mtime, and propagation through the unrooted import graph:

- **47 of 93 are dirty or absent.** 5 never elaborated at all (no olean/trace), 6 source-newer-than-olean, 3 with lake `.trace.nobuild` markers, 6 recording an import hash the rooted build disagrees with, +27 transitively downstream.
- **0 of 526 rooted modules fail the same test.**
- The row's prior claim ">= 22 of 89 dirty" was low by ~2x.

**Cost signal:** the 93 unrooted modules carry **551** raised `maxHeartbeats`/`maxRecDepth` options across 66 files; the 526 rooted carry **447** across 99. Rooting the tree more than doubles the heavy-elaboration surface.

**Contaminated surface:** hgraph holds **627 nodes** whose `file:` is one of the 93, **626 marked `lean_status: lean_ok`**. That flag is auto-synced, not evidence. The LaTeX blueprint is **clean** — 0 of 2047 `\lean{}` names and 0 of 1866 `blueprint/lean_decls` entries point into an unrooted module.

## 2. Three buckets (93 = 80 + 11 + 2)

| bucket | modules | lines | dirty |
|---|---|---|---|
| **LIVE-UNROOTED — named by a claim** | 22 | 6,427 | 12 |
| **LIVE-UNROOTED — only in a named one's import cone** | 58 | 12,091 | 24 |
| **SUPERSEDED** | 11 | 1,460 | 9 |
| **SCRATCH/BROKEN** | 2 | 324 | 2 |

## 3. LIVE-UNROOTED, named, with the claim at risk

| module (`AlgebraicJacobian/Picard/`) | claim at risk |
|---|---|
| `DivSchemeSeedUnivPointwiseGenerator` | `...ddr.rdn` **DONE**: "unconditional `ThetaGeneratorSeed.IsGenerator`… landed endpoints `pointwiseGeneratorSeed`/`isGenerator_pointwiseGeneratorSeed`" (:258,:274) — exist nowhere else |
| `DivSchemeSeedUnivPulledDegree` **[dirty]** | `...cert-assemble` (PENDING): "hdeg is ALREADY PROVED (…, :354)" |
| `DivSchemeSeedUnivPointwise` | `...ddr.rdn` DONE (`PointwiseSeedRDN` :145); `...chart-avoid` DONE (`pointwiseSide` :88); `spec-dd-r.md:502` |
| `DivSchemeHighWindowTransitionSaturation` **[dirty]** | `...coefficient-saturation` DONE: "public endpoint is `exists_…_mem_relation_of_mem_readIdeal`" (:424) |
| `DivSchemeHighWindowQuotientBridge` **[dirty]** + `DivSchemeRedesignChartReadIdeal` | `...quotient-bridge` DONE (`chartReadIdeal` :75) |
| `DivSchemeHighWindowRelationKoszulConjugacy` **[dirty]** + `…FibreModelInduction` **[dirty]** | `...koszul-flatness` DONE: "Endpoints are in <both>" |
| `DivSchemeHighWindowFibreModelBase` **[dirty]** | `...seed-fibre-models` DONE |
| `DivSchemeHighWindowFibreWindow` **[dirty]** | `...hw-foundation` DONE, "Evidence includes …" |
| `DivSchemeHighWindowSecondContainment` **[dirty]** | ACTIVE `...dat-d.ddr`: "universal second-window containment … complete" (:79,:114) |
| `DivSchemeHighWindowPointwiseGenerator` / `…PencilDivisor` / `…FibreNormalization` **[all dirty]** | I-0309 (OPEN) records them built green + axiom-clean |
| `EntryIdeal`, `DivSchemeFlatteningBridge` | `...flattening-fallback` (PENDING) pins its whole experiment on `entryIdeal_le_prime_iff` :379, `relMatrix_eq_zero_of_flat` :245, `exists_matrixPresentation_of_isLocalizedModule` :470 |
| `DivSchemeRedesignRDNChart` / `RDN` / `SeedFinish` | `informal/spec-dd4-fieldvanishing.md` **recommended repair** (:216,:251,:279) reuses "landed" `chartColengthModule_finite` (:119), `flat_chart_colength_divUniversalSeedK`, `chartColengthModuleBase_finite` |
| `DivSchemeRedesignSeedUniv` | `...chart-avoid` DONE (`seedUniv'` :180); `spec-dd-r.md:501` |
| `DivSchemeRedesignFibreCut` | cited from the **rooted** `DivSchemeRedesignHsub.lean:52` |
| `DivRepKit` **[dirty]** | `...ddr.divrep.lift` (ACTIVE), `...cert-relocalize`, `...c9b` cite `DivRepGlobalData` :68 / `representableBy` :113. **Untouched — other lane owns it and is rooting it.** |

**SUPERSEDED (11):** the κ(p)/κ(z) Redesign branch that `spec-dd4-fieldvanishing.md` §0 rules "a dead end" — `RedesignKappaZEquiv/Fibre/Purity/Seed`, `RedesignFlatIdealFibre`/`LocalIdealFibre`/`PointPrime` (never elaborated; `FlatIdealFibre`'s own docstring says the sharp route uses `RankOneFibre` instead), `RedesignRankOneChart`/`RankOneFibre`/`RangeFlatBridge`, `SeedUnivSecondWindowMap` (replaced by rooted `DivSchemeSeedUnivSecondWindow*`). No open row/worksheet/inbox item names a declaration in any of them. Replacement generation for the seed chain is the rooted-cited `DivSchemeSeedUnivPointwise*` (`...ddr.rdn` lands `pointwiseGeneratorSeed`, not `isGenerator_seedUniv'`).

**SCRATCH/BROKEN (2):** `ScratchChartLocal` (52 L, no licence header, one decl `test_chart_local`, imports two never-elaborated superseded files); `Pic0ThetaCocycle` (see below).

**Note on the HighWindow family:** it is **not** superseded. The ACTIVE parent row `AJCR.w4-rep.datum.dat-d.ddr` advertises it as the completed DD-R foundation. I verified this rather than inferring from the name.

## 4. Single most dangerous instance

`Picard/DivSchemeSeedUnivPulledDegree.lean:354`, `deg_presentationDivisor_pulledEquations_pointwiseGeneratorSeed`, cited by the **open** row `...ddr.certificate.cert-assemble` as "hdeg is **ALREADY PROVED**". It is unrooted **and** its olean is older than its source **and** lake left a `.trace.nobuild` marker on it. So it is not merely unchecked: the only artifact for it provably does not correspond to the current source, and an open plan's stated input rests on it. (Runner-up, larger in blast radius: `...ddr.rdn` is DONE on the RD-N keystone `isGenerator_pointwiseGeneratorSeed`, which exists only in unrooted code — the whole DD-R generator chain.)

## 5. What I wrote

- **Roadmap `AJCR.w4-rep.build-reach`** — retitled and summary replaced (9.9 kB) with the measurement, artifact-state table, three buckets, the named LIVE list with claims, and the rooting order. Prior load-bearing facts (Pic0ThetaCocycle correction, OOM constraint) carried forward.
- **Inbox `I-0361`** (`--kind issue --to horizon`) — one item naming all 22 LIVE-UNROOTED modules with the specific claim at risk for each, plus the four asks.
- **10 roadmap comments** on the rows whose own evidence is unrooted: `...dat-d.ddr` (parent), `.rdn`, `.cert-assemble`, `.coefficient-saturation`, `.quotient-bridge`, `.koszul-flatness`, `.seed-fibre-models`, `.hw-foundation`, `.flattening-fallback`, `AJCR.w7-functor.k1`. This is the "say it where the claim lives" half.

## 6. Recommended rooting order (not executed)

- **A — cheap, zero unrooted deps, high claim value:** `EntryIdeal` (634 L, cone = itself, Mathlib-only) + `DivSchemeFlatteningBridge` (128 L) — one line + one build decides `...flattening-fallback`; if the experiment fails, **delete** rather than root. Then `DivSchemeRedesignFibreCut` (160 L), `DivSchemeRedesignRDN` (112 L). (`DivRepKit` is in this class but is the other lane's.)
- **B — small cones (2–5):** `RedesignRDNChart`(2), `RedesignChartReadIdeal`(3), `RedesignSeedFinish`(3), `RedesignSeedUniv`(4), `HighWindowPencilDivisor`(3, 3 dirty), `HighWindowFibreNormalization`(4), `HighWindowFibreWindow`(5).
- **C — the RD-N keystone, before any further DD-R planning:** `SeedUnivPointwise` (cone 12 / 2,430 L, all artifact-clean) → `SeedUnivPointwiseGenerator` (16 / 3,183 L, all clean) → `SeedUnivPulledDegree` (24 / 4,739 L, 1 dirty). Risk here is elaboration cost, not breakage.
- **D — the high-window tower, LAST and in stages (where the dirt is):** `TransitionSaturation` (26, 9 dirty) → `RelationKoszulConjugacy` (40, 22) → `FibreModelInduction` (42, 24) → `QuotientBridge` (68, 32) → `PointwiseGenerator` (73, 33) → `SecondContainment` (74, 34).
- **E — delete:** the 11 superseded + `ScratchChartLocal`. **Human decision:** `Pic0ThetaCocycle` (split, or discard and rewrite — W7-K1 must not be planned against it as written), and whether `EntryIdeal` is ported-with-consumers or dropped.

Constraints honoured: no `lake build`, no `lake env lean`, no lock taken, nothing rooted, nothing deleted, no edit to `Picard/DivRepKit.lean` or `AlgebraicJacobian.lean` (no source file in the project was modified at all — only `/tmp` scripts and horizon state).
