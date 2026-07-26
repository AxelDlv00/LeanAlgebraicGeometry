# `informal/` — index of design worksheets, specs, and recon dumps

76 files, ~26k lines. This index exists so a new session can tell **which file is still
authoritative** without reading them. Created 2026-07-27 (janitor pass, run 0048 round 5).

**How the status column was derived — read this before trusting it.** Each entry's title comes
from reading the file's header. `SUPERSEDED-BY` is recorded **only** where the file itself (or its
successor) says so in writing; it was not inferred from dates. `LANDED` means the roadmap wave the
file serves is `done`, so the file is a historical record of shipped work, not a live instruction.
The 26k lines were *not* read end to end — a `CURRENT` mark means "no evidence of supersession was
found", not "audited line by line".

**Two standing cautions that apply to every file here.**

- **Line references drift.** These worksheets cite `File.lean:NNN` heavily and the citations are
  not maintained. Always re-locate by name, never by line number.
- **A worksheet naming a declaration is not evidence it exists** (inbox `I-0349`). Worksheets
  *reserve* names for bricks not yet built. Before claiming one, read the signature the worksheet
  gives it (inbox `I-0354`) and check the tree with
  `"$HORIZON_BIN" search "<name>" --json`.

---

## Read first (a new session, in this order)

| File | What it is |
|---|---|
| `route-decision.md` | **CURRENT.** The mathematical architecture of the rebuild, in one paragraph plus justification. The north star; nothing else here overrides it. |
| `w4-rep-critical-path.md` | **CURRENT, and the most recent file in the directory.** What `Challenge.lean:99` actually reduces to, with evidence. Carries a ROUND-5 AMENDMENT: **its §1 table is stale — read §7 first**, which holds the corrections. See also `I-0367` (§7.3 is a second, weaker witness, not a corroboration) and `I-0368` (§7.5's "finite Zariski atlas" understates the obligation). |
| `protocol-concurrent-lanes.md` | **CURRENT, BINDING.** Private-index + compare-and-swap ledger commits, the mkdir `lake.lock` protocol, `/tmp` quota. Any session running two or more lanes must follow it. |
| `session-handoff-2026-07-15.md` | **CURRENT** (latest handoff). Supersedes `-07-14b` for STATE. |

## Wave 4 — representability of Pic⁰ (`AJCR.w4-rep`, **active** — this is the live campaign)

The DD-R authority chain is explicit in the files and runs
**`dat-d-worksheet.md` → `spec-dd-r.md` (+ ADDENDUM 4) → `w4-ddr9-worksheet.md`**.
Each declares the one above it as its BINDING parent. When two disagree, the parent wins.

| File | What it is |
|---|---|
| `dat-d-worksheet.md` | **CURRENT — the binding worksheet** for `AJCR.w4-rep.datum.dat-d` (Div^g-lite representability). Binding parent of every `spec-dd-*`. Designers read it first; provers work only from specs derived from it. |
| `spec-dd-r.md` | **CURRENT — the relative endgame** (`Z(♦)`, the universal family, `divRep`). Binding parent: `dat-d-worksheet.md` §3.2–§3.6. Largest file here (63k). **ADDENDUM 4 is the load-bearing part**: the on-stratum witness, and the sharp iff for the field-size bound (`I-0346`). §99 flags one earlier spec as superseded for DD-R. |
| `w4-ddr9-worksheet.md` | **CURRENT.** The `divRepAff`/`divRep` assembly, Addendum-1 form. Binding parent: `spec-dd-r.md` §3. |
| `w4-datum-worksheet.md` | **CURRENT** for the `RepresentableBy` DATUM (w4-6) — the carrier shape, the one-openness-mechanism discovery, RE-5's cocycle-datum spelling. Serves `AJCR.w4-rep.datum`, still active. |
| `w4-datum-design.md` | **CURRENT (design, narrower).** The twist-normalization decision only. Superset context is `w4-datum-worksheet.md`. |
| `w4-datb-worksheet.md` | **CURRENT.** DAT-B coverage + injectivity. §1.6 **CO-SIGNS** `chartLocus c λ` with two amendments the DAT-C lane must acknowledge before either lane builds — that co-sign is still outstanding and is why roadmap `chart-u` cannot start. |
| `w4-datc-worksheet.md` | **CURRENT.** The Σ-charts, h¹-vanishing open, canonical-section normalization. §3.3 is CHART-U(a). |
| `w4-datglue-worksheet.md` | **CURRENT.** The 01JJ `RepresentableBy` assembly: feed the chart family, glue at `K_s`, transfer to `k'`. |
| `w4-datj-worksheet.md` | **CURRENT.** The `JacobianData` assembly and the frozen `Jacobian`/`instGrpObj` discharge. |
| `w4-g4-worksheet.md` | **CURRENT.** The universal-family slice. Its §0 records that a "not yet landed" docstring elsewhere is stale. |
| `w4-g5-worksheet.md` | **CURRENT.** The ε frame-locus cover and the morphism stitch (DDR-9 backward assembly). |
| `w4-rigid-engine-worksheet.md` | **LANDED** — `AJCR.w4-rep.rigid` is `done` (re0–re5). Keep as the record of the rigid two-term pushforward engine's scoping decision. |
| `w4-flv-worksheet.md` | **LANDED** — `AJCR.w4-rep.flv` is `done`. Fibrewise large-twist vanishing. |
| `w4-cbc-recon.md` | **LANDED** — `AJCR.w4-rep.cbc` is `done`. Early-warning recon for cohomology-and-base-change-lite. |
| `spec-w4-gates.md` | **PARTLY STALE by its own header** — it says the "landed" claim it was written against is stale (`DivFamZar.mapAlg` is total). Read `w4-ddr9-worksheet.md` for the current gate picture. |
| `spec-datg0.md` | **CURRENT.** The `K_s → k'` transfer of the representing datum (DAT-glue's hard part), with a feasibility verdict in §0. |
| `spec-dat-a.md` / `spec-dat-1.md` / `spec-dat-6.md` | **CURRENT** brick specs for `dat-a` (**done**), `dat1` (**done**), `dat6` (**done**) — so all three are now records of landed work rather than instructions. |
| `spec-dd-1.md`, `spec-dd-2.md`, `spec-dd-3.md` | **LANDED** — `dd1`, `dd2`, `dd3` are all `done`. `spec-dd-3.md` §0 notes a search find that superseded half of its own planned part 3b. |
| `spec-dd1-pt-seam.md` | **LANDED.** Adjudication of the pt-transport seam; its verdict is absorbed into `spec-dd-2.md` §0. |
| `spec-dd4-redesign.md` | **CURRENT.** The relative-achiever / relative-BPF feasibility verdict. **Explicitly supersedes `spec-dd4-seam.md`.** |
| `spec-dd4-seam.md` | **SUPERSEDED-BY `spec-dd4-redesign.md`** (stated in the successor; its Route 2 is withdrawn). |
| `spec-dd4-fieldvanishing.md` | **CURRENT.** The verdict on the G-4 seed's last wall; §0 carries the recommendation. |
| `dd-f-probe-verdict.md` | **LANDED** — probe verdict GREEN, `ddf` is `done`. |
| `m33-spec.md` | **CURRENT but off the live path** — Milne Lemma 3.3, serves `AJCR.w6-albanese` (`pending`). |

## Wave 3 / Picard + degree (`AJCR.picard`, **done**)

All **LANDED** — historical records of shipped work. Useful for "how did we decide this", not for
"what to do next".

| File | What it is |
|---|---|
| `wave3-picard-design.md` | The Picard-functor lane design spec (72k, the largest historical doc). Decisions-at-a-glance in §0. |
| `wave3-mathlib-survey.md` | Mathlib v4.31.0 inventory for the Picard lane (étale site, sheafification, subcanonicity). Dated to that toolchain. |
| `c1-etale-separatedness-assembly.md` | (C1) étale separatedness. **Supplements `wave3-picard-design.md` §4.4; does not supersede it** (says so in its own header). |
| `pic-affine-dictionary-design.md` | `X.CechPic ≃* CommRing.Pic Γ(X,⊤)` via Zariski descent along a basic cover. |
| `old-draft-picard-recon.md` | Read-only extraction from the pre-rebuild draft: how it modelled line bundles and why it burned. |
| `degree-pic0-recon.md` | The degree / `Pic⁰` interface recon. §2.7 pins a carrier shape still cited by `w4-datum-worksheet.md`. |
| `deg-d4-recon.md`, `deg-d4b-worksheet.md`, `deg-d5b-worksheet.md`, `deg-d2-meromorphic-worksheet.md`, `spec-deg-d2-w1-w4.md`, `spec-g-d8.md` | The degree-lane bricks (graph/diagonal local equations, base-field shuffle, meromorphic bridge, the Abel element). `deg-d5b` notes the recon was stale in the lane's favour. |
| `spec-layer2-picEt.md` | Layer 2: the étale-sheafified Picard functor `picEt`. |

## Wave 2 — χ-ledger and rigidity (`AJCR.w2-chi`, `AJCR.w2-rigidity`, both **done**)

All **LANDED**.

| File | What it is |
|---|---|
| `chi-ledger-design.md` | The χ-ledger / degree-lane design spec (Wave-2 item 7). Decisions in §0. |
| `chi-ledger-notes.md` | Pre-design ground truth that fed the above. Consumed by `chi-ledger-design.md`. |
| `zeta-w2b-chi-recon.md` | Wave-2b χ-ledger / RR-lite recon, including a staleness audit (§1). |
| `spec-chi-g8-g9.md` | G8 (h⁰/h¹/χ + finiteness dévissage) and G9 (Riemann–Roch-lite). Pins the two-convention junction. |
| `api-chi-cohomology.md`, `api-chi-devissage.md`, `api-chi-divisors.md`, `api-chi-genus.md` | Four API recon dumps (2026-07-14) over the χ/genus interface. **Note: `api-chi-cohomology.md` and `api-chi-genus.md` carry identical titles** — they are near-duplicate dumps of the genus/Challenge interface. |
| `zeta-c2-rigidification-recon.md`, `zeta-c2-effectivity-recon.md`, `c2-effectivity-assembly.md`, `spec-c2-e1.md` | The (C2) rigidification and fppf-effectivity campaign. The two `-recon` files are the recon half only; the assembly and E1 spec are the design half. |
| `zeta2ii-api-recon.md`, `spec-zeta2i-close.md`, `spec-zeta2iia-tensor-away.md`, `spec-zeta2iib-pi-assembly.md`, `spec-zeta3-close.md` | The ζ2/ζ3 brick specs (coherent Čech witness, tensor-Away algebra, pi-assembly, `PicEtAff.unit_injective`). |
| `finiteness-plan.md` | The two-lattice plan for finiteness of H¹(C,𝒪_C) — Wave-1 finale. |

## Waves 5–7 — not yet started (`AJCR.w5-av`, `w6-albanese`, `w7-functor` all **pending**)

These are **CURRENT but unconsumed** — design work done ahead of the lanes. Inbox `I-0357` records
that the eight `AJCR.w5-av` leaves have title-only summaries and no briefing, so these files are
the only briefing that exists.

| File | What it is |
|---|---|
| `w5-recon.md` | Wave-5 recon — the `Pic⁰` abelian-variety package. Headline in §0. |
| `w5-worksheet.md` | Wave-5 BINDING worksheet. §0 is the lane protocol (mandates `protocol-concurrent-lanes.md`). |
| `w5-t4-worksheet.md` | W5-T4: the étale-plus/Zariski kernel crossing at `k[ε]` (risk R1). |
| `w6-albanese-port-recon.md` | Wave-6 Albanese PORT recon — what the old work offers vs what must be rebuilt. **STATUS: RECON, not design** (its own header). Verified against the tree 2026-07-16. |
| `w6-port-worksheet.md` | Wave-6 BINDING port worksheet — the Albanese algebra/rational-map layer. |
| `w7-recon.md` | Wave-7 recon — functoriality and base change of fields. |
| `w7-worksheet.md` | Wave-7 BINDING worksheet. |
| `w7-ev-worksheet.md` | E-v: degree multiplicativity under pullback. |
| `w7-k1-worksheet.md` | K-1: the θ-cocycle coherence. **Caution:** the file it targets, `Picard/Pic0ThetaCocycle.lean`, is not elaborable as written (>34 GB RSS, inbox `I-0359`) and is unrooted. |

## Protocol and session handoffs

| File | What it is |
|---|---|
| `protocol-concurrent-lanes.md` | **CURRENT, BINDING.** See "Read first". |
| `session-handoff-2026-07-15.md` | **CURRENT.** The latest handoff; supersedes `-07-14b` for STATE. |
| `session-handoff-2026-07-14b.md` | **SUPERSEDED-BY `session-handoff-2026-07-15.md`** for state. Its protocol amendments (the concurrency update that replaced "one prover at a time") were folded into `protocol-concurrent-lanes.md`. |
| `session-handoff-2026-07-14.md` | **SUPERSEDED-BY `session-handoff-2026-07-14b.md`.** |
| `session-handoff-2026-07-12.md` | **SUPERSEDED** by the chain above. Retains the user's standing operating model. |
| `session-prompt-2026-07-13.md` | **HISTORICAL.** The `rebuild` task launch prompt; its "next actions" were superseded the same week. |
