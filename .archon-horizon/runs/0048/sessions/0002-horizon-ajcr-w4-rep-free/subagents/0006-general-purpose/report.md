# Ground-truth inventory — AJCR.w4-rep critical path

Project root: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild`
Roadmap store: `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/`

---

## 1. The subtree: 60 rows, 19 open

`horizon roadmap list --focus AJCR.w4-rep --json` returns 60 items. Progress counters: `AJCR.w4-rep` 36/55, `.datum` 26/43, `.datum.dat-d` 17/27, `.ddr` 11/19, `.ddr.certificate` 3/8. **Zero `pinned_commits` anywhere except two rows**: `ddr.certificate` = `['c843eafd7','359c0a38d','2ff846d74','5e6d8ac6c']` and `ddr.certificate.chart-trace` = `['206967379','49866bdd1']`.

**Open rows (pending/blocked/active), 19 total.** 6 are certificate-subtree (container + 5 leaves); **13 are not.**

### Certificate subtree (6 rows — the lane)
| row | status/prio | needs | spec | blueprint | Lean |
|---|---|---|---|---|---|
| `.ddr.certificate` | active | container; route re-based 2026-07-25 | `informal/spec-dd-r.md` | none | 10 `DivSchemeCertZar*` files |
| `.chart-avoid` | pending/**high** | `supportLocus ⊆ V_0 ∩ V_1` after Away-shrink. Roadmap explicitly says it is FALSE for a general degree-g divisor → it is a **chart-design input**, not a lemma | no dedicated spec | none | none (target sites named only) |
| `.swallow-adapt` | pending/**high** | build the 2-piece-per-chart adaptation; inputs = chart-avoid + a global generator near the support | no dedicated spec | none | consumes `DivSchemeCertZarSwallow.lean` (landed) |
| `.cert-collapse` | pending/**urgent** | show (c2)/(c3)/(c4) free for swallow-or-miss; one technical colength-shrinking lemma | no dedicated spec | none | none |
| `.cert-assemble` | pending | compose into `isLocallyCertified_of_forall_prime_exists_certified_adaptation` (`DivSchemeCertZarPointwise.lean:162`) + **4 missing Away-transport bricks** | no | none | target exists |
| `.away-kerspan` | **blocked/low** | `hinj`; roadmap says "likely an artifact", fenced by 2 proved no-gos | no | none | `DivSchemeCertZarKerSpan.lean:63,123` |
| rejected: `.away-assemble`, `.leak-image`, `.tube-fibre`; also `ddr.flattening-fallback` (rejected with an EMPTY note, per away-kerspan's own summary) | | | | | |

**Live delta not yet in the roadmap:** `AlgebraicJacobian/Picard/DivSchemeCertZarTransport.lean` (90 L) appeared on disk during this recon — it proves `Scheme.LocalEquations.supportLocus_pullback` and `unitLocus_pullback`, i.e. **cert-assemble brick (1)** and exactly the lemma I-0328 called "the cheapest unblocking step … never been attempted". It is **uncommitted** (not in the ledger log) and **imported by nothing**.

### Non-certificate open rows (13)
| row | status | what it actually requires | (a) informal spec | (b) blueprint node | (c) Lean file | (d) sorry-free partial |
|---|---|---|---|---|---|---|
| `build-reach` | pending/**high** | add ~96 missing imports to `AlgebraicJacobian.lean` in dependency order, fix fallout | n/a (workspace kind) | n/a | n/a | n/a |
| `.datum` | active | container | `informal/w4-datum-worksheet.md`, `w4-datum-design.md` | — | — | — |
| `.datum.dat-b` | pending | B-5 `pic0_chartLocus_cover`, B-6 `IsLocallySurjective` instance | ✅ `informal/w4-datb-worksheet.md` (rows at :485-486) | ❌ | ❌ **planned `Picard/Pic0Coverage.lean` and `Pic0CoverageSurj.lean` do not exist** | landed pieces live in `Pic0ChartLocusOpen.lean`, `Pic0ChartLocusFibreField.lean`, `DivisorFamilyFieldSurj.lean` (all sorry-free) |
| `.datum.dat-c` | pending | C6–C9 + CERT-Σ | ✅ `informal/w4-datc-worksheet.md` (rows :510-519) | ❌ | ❌ **none of `DivSchemeH1Open.lean`, `DivSchemeChartFibre.lean`, `DivSchemeChartCert.lean`, `DivSchemeChartHf.lean` exist** | C0–C5 landed (`DivisorDatumInverse`, `DivisorFamilyH1Locus`, `DivisorDatumRankOne`, `EffectiveUniqueness`, `DivisorFamilyMonoH1`, `DivSchemeAbel`) |
| `.dat-c.c9-chartlocus` | pending/**urgent** | define `chartLocus` + the `(f, hf)` pair | ✅ only as worksheet §3.3 / row C9 | ❌ | ❌ | ❌ |
| `.datum.dat-d` | active | container | ✅ `informal/dat-d-worksheet.md` | partial | 177 `DivScheme*.lean` | — |
| `.dat-d.ddq` | **blocked** | its own summary: "nothing here to pick up: do not open before ddr.divrep closes" | — | owes DAT-D nodes | `DivSchemeQProj.lean` landed | yes |
| `.ddr` | active | container | ✅ `informal/spec-dd-r.md` | ❌ | — | — |
| `.ddr.divrep` | pending | F5 `divRepPullAt` glue, F6 `divRepAff`+2 laws, F7 the lift. `DivRepAffinePullback` (4 fields) and `DivRepGlobalData` (5 fields) have **zero references outside their own files**; no `def divRep`/`divRepAff` exists | ✅ `informal/w4-ddr9-worksheet.md` (§5, rows F1–F7 at :537-544) | ❌ | partial: `DivRepAffKit.lean:167`, `DivRepKit.lean:68`, `DivRepClassifyZar.lean:244` exist; **planned `DivRepPull.lean`, `DivRepAff.lean`, `DivRep.lean` do not** | F1–F4 landed sorry-free (`DivSchemeEpsCarve` 355 L, `DivSchemeKeyChart` 500 L, `DivSchemeAtlasFactor` 395 L, `DivRepClassifyZar` 277 L) |
| `.ddr.datum-tail` | pending | universal family + DAT-D/DAT-G assembly, post-divRep | only inside `spec-dd-r.md` / `w4-datum-worksheet.md` | ❌ | ❌ | ❌ |
| `.datum.dat-g` | pending | **see §2 — nothing** | ❌ | ❌ | ❌ | ❌ |
| `.datum.dat-glue` | pending | DG-1..DG-4; DG-3 = DAT-G0 (filtered-colimit compat + descent to a finite separable stage) | ✅ `informal/w4-datglue-worksheet.md` (rows :428-432), plus `informal/spec-datg0.md` for DG-3 | ✅ **the only one** — `def:pic0RepresentableByOfCharts`, `blueprint/src/chapters/PicardEtale.tex:10678`, with `\leanok`, but **conditional** on a chart family nothing produces | DG-0 = `Picard/PicRepDatum.lean` (structure only); `Pic0SigmaSheaf.lean:161` = `pic0RepresentableByOfCharts`. **`Pic0GlueAssembly.lean`, `Pic0FiniteSubfamily.lean`, `Pic0KsToKprime.lean`, `Pic0RepAssemble.lean` do not exist** | `Pic0SigmaSheaf.lean`, `PicRepDatum.lean`, `PicRepColimitMountain.lean` all sorry-free |
| `.datum.dat-j` | pending | DJ-1 Abel-image qc, DJ-2 `jacobianData C` producer, DJ-3 Challenge discharge | ✅ `informal/w4-datj-worksheet.md` (rows :402-405) | ✅ `Jacobian.tex` has ~36 nodes incl. `def:jacobian_data`, `cor:jacobianData_separated` | DJ-0 landed (`CompactImageQc.lean`); `JacobianData.lean` struct + `grpObj`/`homEquiv`/`uniqueUpToIso` landed. **`JacobianQuasiCompact.lean`, `JacobianDataProducer.lean` do not exist**; `jacobianData C` producer absent | yes for the landed parts |

**Off-roadmap obligation named in the parent summary but with no row of its own:** `Pic0PreservesFilteredBaseColimit` (`AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136`) — a bare `def … : Prop`, unproved, explicitly divRep-free, avatars pinned. Reduction landed in the same file + `PicRepColimitResidual.lean` + `PicRepColimitMountain.lean` (257 L, sorry-free).

**Blueprint owes, confirmed by grep:** there is **no** `\lean{}` node in the whole blueprint for `divRep`, `divRepAff`, `DivFamZar`, `divFunctor`, any `DivScheme*`, any certificate predicate, `chartLocus`, or DAT-G/Speiser descent. `PicardEtale.tex` (463 nodes, 777 `\leanok`) touches the Σ-side only at :10526/:10557/:10643/:10679. `Challenge.tex:35` `def:jacobian` has `\lean{AlgebraicGeometry.Jacobian}`, **no `\uses`, no `\leanok`**.

---

## 2. DAT-G specifically — confirmed: nothing

**Roadmap text** (`AJCR.w4-rep.datum.dat-g`), verbatim:
> title: `DAT-G (worksheet-first): finite-Galois/Speiser descent of the datum — $\Gamma$-semilinear chart action, $\mathrm{pic}^0(C,T) \cong (\mathrm{pic}^0(C_{k^\prime},T_{k^\prime}))^\Gamma$ through rigidified pairs only`
> summary: `Finite-Galois/Speiser descent of the PicRepDatum from a finite separable stage to the challenge field is not implemented. Keep pending behind DAT-G0 and divRep.`

**CONFIRMED — no spec, no worksheet, no Lean file, no blueprint node, no inbox item of its own:**

- **informal/**: 75 files. `ls informal/ | grep -i "datg\|dat-g"` → only `spec-datg0.md` (that is **DAT-G0**, the β1 colimit-compat probe — a different obligation) and `w4-datglue-worksheet.md` (**DAT-glue**). **There is no `spec-dat-g.md` and no `w4-datg-worksheet.md`**, while every sibling has one: `w4-datb-worksheet.md`, `w4-datc-worksheet.md`, `w4-datglue-worksheet.md`, `w4-datj-worksheet.md`, `dat-d-worksheet.md`, `spec-dat-a.md`, `spec-dd-r.md`, `w4-ddr9-worksheet.md`.
- **Lean**: `grep -rn "DAT-G\b" --include=*.lean` → 6 hits, **all docstrings**, in exactly two files: `AlgebraicJacobian/Picard/PicRepDatum.lean:9,18,80,136` and `AlgebraicJacobian/Picard/DivSchemeQProj.lean:42,243`. `grep -rn "Speiser"` in `.lean` → **1 hit**, `PicRepDatum.lean:18` (a docstring naming the downstream lane). No file named `*galois*`/`*semilinear*`/`*datg*` exists. `PicRepDatum.lean:65` docstring itself records the producer as absent: "The producer `picRepDatumKprime` (DG-4)…" — `grep picRepDatumKprime` over `.lean` returns nothing.
- **Blueprint**: no node, no `\lean`, no `\label` mentioning DAT-G, Galois descent, or Speiser.
- **Inbox**: 13 items mention "DAT-G" (I-0151, I-0177, I-0223, I-0225, I-0245, I-0248, I-0256, I-0259, I-0261, I-0263, I-0266, I-0270, I-0271) but every one I opened is about **DAT-G0** (the `Pic0PreservesFilteredBaseColimit` colimit mountain), not DAT-G's Galois descent.

So the only DAT-G artifact in the repository is the **handoff struct** `PicRepDatum k k' C'` (`AlgebraicJacobian/Picard/PicRepDatum.lean:89`), with `homEquiv`/`homEquiv_comp`/`uniqueUpToIso` — and zero producers on either side of it.

---

## 3. Sorries and axioms

`grep -rn "sorry" --include=*.lean AlgebraicJacobian/` → **37 raw hits**, of which **21 are docstring prose** ("sorry-free", "zero-sorry", "`sorry`"). 

**Real code sorries: 16, in 2 files.**
- `AlgebraicJacobian/Challenge.lean` — **15**: bare at lines **99** (the target `Jacobian`), 108, 113, 117, 121, 126, 134, 147, 248, 259, 272, 283; plus `map _ := sorry` (156), `map_id := sorry` (157), `map_comp := sorry` (158).
- `AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean:268` — **1** (`pic0Theta_comp`; file is deliberately unimported and has **no olean**).

**Axioms: 0.** `grep -rn "^axiom\|sorryAx"` → 4 hits, all docstring lines that merely begin with the word "axiom" (`Cohomology/GluedSheafQcoh.lean:185`, `Cohomology/QcohSections.lean:220`, `Cohomology/AffineVanishingQcoh.lean:35`, `Albanese/CodimOneStalkRegularity.lean:164`). `grep -rnE "^axiom [A-Za-z]"` → 1 hit, same false positive. **No `axiom` declaration and no `sorryAx` reference exists in the tree.**

**Build reachability (independently recomputed, transitive closure of `import` from `AlgebraicJacobian.lean`):** 611 modules total, **515 reachable, 96 unreachable** (roadmap said "about 95" — accurate). Of the 96: 94 under `Picard/`, 2 under `Algebra/` (`DirectLimitQuotient`, `FlatDirectLimit`). Breakdown: 38 `*HighWindow*`, 28 `*Redesign*`, 21 other `DivScheme*`, **all 3 `DivRep*Kit*` files** (`DivRepAffKit`, `DivRepAffKitZar`, `DivRepKit`), `EntryIdeal`, `DivSchemeFlatteningBridge`, `Pic0ThetaCocycle`, `ScratchChartLocal`, `DivSchemeCertZarConn`, `DivSchemeSeedUnivPulledDegree` (which holds the already-proved `hdeg` that cert-assemble consumes).

**Modules with no olean at all: 8** — `Picard/DivRepAffKitZar.lean`, `Picard/DivSchemeCertZarConn.lean`, `Picard/DivSchemeCertZarTransport.lean` (the new uncommitted one), `Picard/Pic0ThetaCocycle.lean`, `Picard/ScratchChartLocal.lean`, `Picard/DivSchemeRedesignPointPrime.lean`, `Picard/DivSchemeRedesignFlatIdealFibre.lean`, `Picard/DivSchemeRedesignLocalIdealFibre.lean`. The `DivSchemeCertZar*` chain otherwise has oleans (the `fd46fcf83` fix worked).

---

## 4. The "six independent mountains" recon

`grep -rl "SIX INDEPENDENT"` over the whole workspace matches exactly three places: `.archon-horizon/runs/0048/sessions/0002-horizon-ajcr-w4-rep-free/transcript.jsonl`, its `subagents/0006-general-purpose/transcript.jsonl`, and `.archon-horizon/roadmap/items/AJCR.w4-rep.yaml`. **There is no standalone recon `report.md` and no inbox item carrying it** — run 0048's session directory has no `report.md` at all (only `meta.json`, `transcript.jsonl`, `usage.json`, `notify_cache.json`). The finding survives only as a horizon note replayed into the 0048 brief and as the roadmap summary.

Verbatim, from the 0048 brief's `--- NOTES` block (`transcript.jsonl` line 184):

> **DIRECT ANSWER to the critical question: the certificate lane is ONE of at least SIX independent mountains, and it is not even the last one. Closing it tomorrow would advance the chain by one of ~12 links.**
>
> Ranking for the lead:
> - Cheapest real advance, available NOW, off the certificate critical path: `Pic0PreservesFilteredBaseColimit` (PicRepColimitCompat.lean:136). Explicitly divRep-free, M–L, mathlib avatars pinned, reduction landed. Nothing blocks it.
> - Cheapest bookkeeping win: mark `ddr.quotient-bridge` and `ddq` done/off-path (their own summaries say the remainder isn't needed), and re-title `ddr.certificate.tube-fibre` as REFUTED (DivSchemeCertZarSep.lean:257) with `leak-image` as its replacement.
> - Deepest wall on the certificate lane: `hinj` (away-kerspan), fenced by two proved no-gos.
> - **TRUE bottleneck for closing Challenge.lean:99: DAT-G. It is the only link with no spec, no worksheet, no Lean file, and an unfrozen handoff shape. Even a miracle on the certificate leaves DAT-C(4 files)+DAT-B(2 files)+DAT-G0(β)+DAT-G(nothing)+DAT-J.**

The upstream source of that ranking is the run-0047 recon report at `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0047/sessions/0002-horizon-ajcr-w4-rep-free/subagents/0002-general-purpose/report.md` (its §"If a certificate term existed tomorrow" lists the same 10 links; line 42: "**L** — DAT-B/DAT-C: `chartLocus` is *undefined*; … This is the largest unwritten block"; line 44: "**L** — DAT-G/DAT-G0 descent to `k` … + `PicRepDatum` producer").

The `AJCR.w4-rep` roadmap summary restates it with the ordering: 1. `ddr.certificate` ("NOT the last link"), 2. `ddr.divrep`, 3. `dat-c` C9, 4. `dat-b`, 5. `dat-g` ("the true bottleneck"), 6. `dat-j`, plus DAT-G0.β1 and the I-0234 windowS `b+2g → b+3g` refactor gating G-4.

---

## 5. Sizes, and the certificate-lane share

| scope | .lean files | lines |
|---|---|---|
| `AlgebraicJacobian/` (whole tree) | 609 (+ root `AlgebraicJacobian.lean`, 486 imports) | 167,369 |
| `AlgebraicJacobian/Picard/` | **389** | **103,968** |
| `Picard/DivScheme*` | 177 | 43,482 |
| `Picard/*HighWindow*` | 44 | 11,391 |
| `Picard/*Redesign*` | 40 | 6,574 |

**Certificate lane, by your name filter** (`Cert|Zar|Swallow|ChartTrace|Sep|Tube|Leak|Away|Kerspan`) → **46 files / 12,295 lines**. That regex over-collects badly; the honest split:

**DD-R certificate lane proper — 18 files / 4,415 lines:**
`DivSchemeCertZar{ChartTrace 175, Conn 163, KerSpan 149, Leak 278, Pointwise 196, Seed 158, Sep 307, Swallow 187, Transport 90, Tube 188}` = **10 files / 1,891 L**; `DivSchemeCert{FibreRank 85, ificateEngine 420, ificate 417, OverlapFinite 253, Seed 100, Univ 176}` = 6 files / 1,451 L; `SupportTube 348` + `SupportTubeFinite 331` = 679 L; `DivSchemeUnivFibreKerSpan 220` + `DivSchemeUnivFibreHinj 174` = 394 L.

**Caught by the regex but NOT the certificate lane (28 files / ~7,880 L):** `DivisorFamilyZar*` / `DivisorFamilyZariski*` (14 files / 3,957 L — the DD-2 `DivFamZar` sheaf layer), `DivRep*` (6 / 1,748 L — the divrep lane), `EtaleSeparatedness*`, `Separatedness`, `GrassmannianSeparated`, `CechPicClopenSep`, `Pic0ZariskiSheaf`, `PicEtAffZariski{Glue,Sep}`, `WitnessAway`, `DivisorFamilyPullbackCert`.

**So the DD-R certificate lane is ~4.2 % of `Picard/` by line count (4,415 / 103,968), or 1.9 % counting only the `DivSchemeCertZar*` tower.** I-0328 (open) records that as of run 0047 not one declaration in that tower was referenced outside itself.

---

## Two roadmap inaccuracies found

1. **`c9-chartlocus`'s stated anchor is wrong.** Its summary says "`chartLocus` is referenced at `Picard/Pic0SigmaSheaf.lean:162-164`". Lines 153-170 of that file are `pic0RepresentableByOfCharts`; the string `chartLocus` **does not occur in `Pic0SigmaSheaf.lean` at all**. The 8 tree-wide occurrences of `chartLocus` are all **docstring/comment lines** in `AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean` (:9,20,21,50,56) and `Pic0ChartLocusOpen.lean` (:13,32,75) — plus `informal/w4-datc-worksheet.md:391,397,398,406,408`. The "zero code hits, no definition, no producer, no consumer" conclusion is **correct**; the file:line pointer to follow is `Pic0ChartLocusOpen.lean:12-32` (worksheet §3.3 / row C9), not `Pic0SigmaSheaf.lean:162`.
2. **The certificate subtree has moved since the roadmap was written.** Ledger commit `40f357de8` ("the satisfiability verdict — a connected divisor is certifiable only inside one pinned chart", = `DivSchemeCertZarConn.lean`, 163 L, no olean, root-unreachable) postdates the `chart-trace` pins, and `DivSchemeCertZarTransport.lean` (cert-assemble brick 1) is on disk uncommitted and unimported.
