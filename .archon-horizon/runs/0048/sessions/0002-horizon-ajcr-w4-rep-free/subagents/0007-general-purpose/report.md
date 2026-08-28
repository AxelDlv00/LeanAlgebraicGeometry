## 1. Roadmap items (verbatim)

Retrieved via `/home/axel/.archon-env/bin/horizon roadmap list --focus AJCR.w4-rep.datum.dat-d.ddr.certificate --json` (there is no `roadmap show` subcommand; only `list`/`set`/`add`/`comment`/`remove`). The focus returned 12 items; the 5 you asked for are below, plus I include `cert-collapse` (asked) and note the 3 sibling leaves that exist but you didn't name.

### Metadata table (whole subtree, as returned)

| id | status | priority | owner | pinned_commits |
|---|---|---|---|---|
| `...ddr.certificate` | **active** | normal | `''` (empty) | c843eafd7, 359c0a38d, 2ff846d74, 5e6d8ac6c |
| `...certificate.away-assemble` | **done** | normal | `''` | — |
| `...certificate.away-kerspan` | **blocked** | **low** | `''` | — |
| `...certificate.cert-assemble` | pending | normal | `''` | — |
| `...certificate.cert-collapse` | **pending** | **urgent** | `''` | — |
| `...certificate.chart-avoid` | pending | **urgent** | `''` | — |
| `...certificate.chart-trace` | done | normal | **`ajcr-w4-rep-free`** | 40f357de8, 206967379, 49866bdd1 |
| `...certificate.leak-image` | **rejected** | normal | `''` | — |
| `...certificate.sep-nogo` | done | normal | `''` | — |
| `...certificate.swallow-adapt` | pending | **high** | `''` | — |
| `...certificate.tube-fibre` | **rejected** | normal | `''` | — |
| `...certificate.zar-gate` | done | normal | `''` | — |

All are `kind: proof`, `scope.projects: [Algebraic-Jacobian-Challenge-Rebuild]`, `depends_on: []`, `inbox_refs: []`, `milestone: ''`. The parent item reports `subtree_done: 4`, `subtree_total: 9`.

---

### 1a. `AJCR.w4-rep.datum.dat-d.ddr.certificate`
**title:** "DD-R certificate: inherited certificate, epsilon projection, U1/U2, and inverse laws"
**status:** `active` · **priority:** `normal` · **owner:** `''` · **parent:** `AJCR.w4-rep.datum.dat-d.ddr`

> ROUTE RE-BASED (2026-07-25, run 0048) — the lane's gate is now a single geometric statement
> about the divisor, and it is PROVED to be irreducible.
>
> THE NECESSITY (landed, kernel-checked, commit 49866bdd1, Picard/DivSchemeCertZarChartTrace.lean).
> A FinCoverData carries a partition of unity on each pinned chart, so the chart-b pieces cover
> ALL of V_b and the union of their traces is the whole chart trace supportLocus cap V_b. A finite
> union of closed sets is closed, hence
>
>   the assembler's hnoLeak at every piece  ==>  supportLocus cap V_0 and supportLocus cap V_1 are
>   CLOSED in the relative curve
>
> (isClosed_supportLocus_inter_chart_of_forall_noLeak). That mentions neither the adaptation nor its
> pieces. Contrapositive not_forall_noLeak_of_not_isClosed_chart0: a system whose chart trace is not
> closed admits NO adaptation satisfying the assembler's hypothesis. So refining the cover can only
> add constraints, and shrinking the base only re-states the same condition over the smaller base.
>
> THE SUFFICIENCY (landed, commit 206967379, Picard/DivSchemeCertZarSwallow.lean). If every piece
> either SWALLOWS the support (supportLocus subset pieces j) or MISSES it, then no-leak holds at every
> piece and clause (c1)-finite follows, with no fibre, no tube and no packet idempotent. A missing
> piece has a UNIT equation, so its colength module VANISHES
> (subsingleton_colength_of_disjoint_supportLocus) and needs no fibrewise regularity input either.
> The two dichotomy theorems pin the shape: a swallow-or-miss adaptation exists only for a divisor
> inside a pinned chart or disjoint from it, so (V_0 sup V_1 = top) a nonempty support lies in
> V_0 cap V_1 — the divisor avoids BOTH vertical fibres of pi — or is confined to one of them.
>
> CONSEQUENCE FOR THE OLD LEAVES. tube-fibre and leak-image are both superseded: their common
> obligation is exactly chart-trace closedness, which is a CHART-DESIGN input, not something the
> support tube / idempotent packets / base shrinking can manufacture. away-kerspan (hinj) is
> suspected to be an ARTIFACT of certifying the arbitrary `.some` extraction adaptation: for a
> swallow-or-miss adaptation the Cech complex has at most one nontrivial piece per chart and its
> difference map is surjective onto the off-diagonal overlaps, so (c3)/(c4) should be free — see the
> new cert-collapse leaf. That is the single highest-value experiment in the lane.
>
> THE NEW CHAIN: chart-avoid -> swallow-adapt -> cert-collapse -> cert-assemble.

---

### 1b. `...certificate.cert-collapse`
**title:** "Cert-collapse: (c2)/(c3)/(c4) — and the hinj wall — are free for a swallow-or-miss adaptation"
**status:** `pending` · **priority:** `urgent` · **owner:** `''`

> THE SINGLE HIGHEST-VALUE EXPERIMENT IN THE LANE: show that clauses (c2)/(c3)/(c4) — and therefore
> the hinj wall of away-kerspan — are FREE for a swallow-or-miss adaptation.
>
> WHY THIS SHOULD WORK. The lane has been certifying `(exists_divisorAdaptation ...).some`
> (ThetaGeneratorSeed.divisorAdaptation, Picard/DivSchemeFamily.lean:367) — an adaptation about which
> NOTHING is known, so every clause had to be proved for an arbitrary finite cover. The pointwise gate
> accepts ANY adaptation over the shrunken base, so choose one. For the swallow-or-miss shape:
>
>  * every MISSING piece has a subsingleton colength AND subsingleton overlap colengths
>    (subsingleton_colength_of_disjoint_supportLocus,
>    subsingleton_ovlColength_of_disjoint_supportLocus), so it contributes 0 to chartProd and to
>    ovlProd;
>  * only the two SWALLOWING pieces survive, one per chart, and every overlap colength among them is
>    Gamma of the SAME divisor subscheme (the support is inside every one of those opens);
>  * hence delta_left - delta_right is, up to the identifications, (a, b) |-> a - b, which is
>    SURJECTIVE onto the off-diagonal overlap components. Its kernel W(d) is the diagonal, so
>    W(d) iso colength, and coker(delta) is the diagonal part prod_j ovlColength j j iso prod_j
>    colength j plus one leftover copy — all finite projective by (c1), hence FLAT.
>
> So (c2) reduces to (c1) plus the rank, (c3)/(c4) are flatness of finite projective modules, and
> hinj — provably equivalent to (c4) — is discharged by construction rather than by a fibrewise
> flatness argument over a nonreduced base. If this lands, away-kerspan is retired, not solved.
>
> THE ONE TECHNICAL LEMMA NEEDED: colength is invariant under shrinking a piece to a smaller open
> that still contains the trace. Ring-level core: if V(g) cap V(h) = empty in a commutative ring then
> h is a UNIT mod (g) (from 1 in span{g, h}), so Gamma(V)/(g) iso Gamma(V)_h/(g) = Gamma(D(h))/(g)
> via IsAffineOpen.isLocalization_basicOpen. Applied with g the piece equation and h cutting out the
> smaller open, this identifies all the colength and overlap-colength modules of the swallowing
> pieces. Watch the Opens-level `inf` bookkeeping (pieces i inf pieces j is not syntactically
> symmetric).

---

### 1c. `...certificate.away-kerspan`
**title:** "Away-kerspan / hinj = certificate clause (c4): blocked, and likely an artifact of the .some adaptation"
**status:** `blocked` · **priority:** `low` · **owner:** `''`

> BLOCKED / LIKELY AN ARTIFACT — do not grind it before cert-collapse is tried (2026-07-25, run 0048).
>
> STATUS OF THE MATHEMATICS. hinj (residue-fibre injectivity of the injectivized Cech difference,
> Picard/DivSchemeCertZarKerSpan.lean:63,123) is not a decomposition of the certificate: it is
> PROVABLY EQUIVALENT to clause (c4) itself, Module.Flat R (ovlProd / range (deltaLeft - deltaRight)),
> via ker_rTensor_le_range_subtype_iff_liftQ_rTensor_injective (DivSchemeHighWindowSyzygy.lean:56) plus
> SlicingFlatKernel.lean. Two landed no-gos fence it: a cleverer submodule L cannot help (the L-free
> form is already the general one), and support-separated pieces cannot help
> (DivSchemeCertZarSep.lean:201/:257). Over a field it is free (every module is projective,
> DivisorFamilyFieldSurj.lean); over a nonreduced base the escape is unavailable.
>
> WHY IT IS PROBABLY AN ARTIFACT. Every attempt so far certified
> ThetaGeneratorSeed.divisorAdaptation = (exists_divisorAdaptation ...).some
> (Picard/DivSchemeFamily.lean:367) — an adaptation about which nothing whatsoever is known, so (c4)
> had to be proved for an arbitrary finite cover, where it is a genuine relative-flatness statement.
> The pointwise gate accepts ANY adaptation over the shrunken base. For the swallow-or-miss adaptation
> of swallow-adapt only two pieces have nonzero colength and the Cech difference is surjective onto the
> off-diagonal overlaps, so its cokernel is a product of finite projective modules and (c4) is free.
> See cert-collapse for the argument and the one technical lemma it needs.
>
> IF cert-collapse FAILS, the fallback lead is the flattening route: the original project's
> flatLocusStratification_universal has a sorry-free 28-module cone, and its commutative-algebra heart
> Picard/EntryIdeal.lean is ALREADY present byte-identical in this tree as an UNWIRED ORPHAN (landed
> run 0042, never imported), alongside DivSchemeFlatteningBridge.lean. ddr.flattening-fallback was
> rejected on 2026-07-23 with an EMPTY note, two days before the route change that created this
> obligation; that rejection should be revisited rather than inherited.

---

### 1d. `...certificate.away-assemble`
**title:** "Away-assemble: compose tube-fibre + away-kerspan + the landed degree-g theorem into isLocallyCertified_of_forall_prime_exists_certified_adaptation"
**status:** `done` · **priority:** `normal` · **owner:** `''`

> DONE AS WRITTEN, FRAMING SUPERSEDED (2026-07-25, run 0048). The composition target this leaf named is fully proved: isLocallyCertified_of_forall_prime_exists_certified_adaptation (Picard/DivSchemeCertZarPointwise.lean:162) with its DivFamZar packaging divFamZar_of_forall_prime_away_certified (:181). Its two named inputs are both retired — tube-fibre is superseded by chart-avoid, away-kerspan is blocked and likely an artifact — so nothing is left to compose here. The genuine remaining composition, plus the four Away-transport bricks this leaf never recorded, is the new leaf cert-assemble.

---

### 1e. `...certificate.tube-fibre`
**title:** "Tube-fibre: at one base prime, put the family support of the pointwise seed system inside a single adaptation piece"
**status:** `rejected` · **priority:** `normal` · **owner:** `''`

> REJECTED 2026-07-25 (run 0048) — SUPERSEDED, not merely refuted-as-stated.
>
> The goal ("put the support inside a SINGLE adaptation piece") was already refuted in run 0047 r6
> (not_exists_unique_support_piece, Picard/DivSchemeCertZarSep.lean:257). Run 0048 shows the intended
> reformulation ("per-piece, for each j the fibre of the closure of the piece trace stays in the
> piece") is EQUIVALENT to a statement with no pieces in it at all: the chart traces
> supportLocus cap V_b must be closed in the relative curve
> (isClosed_supportLocus_inter_chart_of_forall_noLeak, Picard/DivSchemeCertZarChartTrace.lean). So
> there is nothing left for this leaf to own; the obligation lives in chart-avoid and the production
> rule in chart-trace / swallow-adapt.
>
> WHAT SURVIVES AND IS STILL USED: exists_away_supportLocus_subset_of_fibre_subset and
> forall_noLeak_of_forall_supportLocus_subset (Picard/DivSchemeCertZarTube.lean) — spreading one-fibre
> containment in an OPEN to a basic-open base neighbourhood, and containment-to-hnoLeak. They are
> consumed by swallow-adapt with U the swallowing piece.

---

### 1f. Three sibling leaves you did not name (they carry the new chain)

- **`...certificate.chart-avoid`** — pending / **urgent** / owner `''` — "Chart-avoid: is the DD-R chart's divisor confined to ONE pinned chart? (lemma, carve, or redesign)". Key lines: *"THE GEOMETRIC INPUT OF THE CERTIFICATE — and by Picard/DivSchemeCertZarConn.lean (commit 40f357de8) now known to be NECESSARY AND SUFFICIENT for a connected divisor, not merely convenient."* … *"spec-dd-r.md ADDENDUM 1 asserts \"the universal family of DDR-3/4 is honestly certified over each Z(diamond)-chart ring\". If that is true, the chart ALREADY confines its divisors and this leaf is a bookkeeping lemma"* … *"THIS IS THE DECISION POINT OF THE WHOLE LANE: lemma, carve, or redesign."*
- **`...certificate.swallow-adapt`** — pending / **high** — 2 pieces per chart (swallowing piece `D(h_b)` + complementary `D(s_b)` with equation 1), two honest inputs (chart-avoid; a global generator near the support), comaximality step `sigma + tau = 1`.
- **`...certificate.cert-assemble`** — pending / normal — lists the **FOUR TRANSPORT BRICKS the away route still owes** (`supportLocus_pullback`; `DivisorAdaptation.pullbackOfIsOpenImmersion`; `hregular`/`hovlFlat` in seed-free Away form; `hdeg` base-changed) and the note *"isCertified_of_noLeak_of_forall_liftQ_injective needs [IsNoetherianRing (Localization.Away r)] — confirm the instance fires."*

---

## 2. Session reports for `ajcr-w4-rep-free`

**Which runs/sessions worked this task.** Only two runs ever have: **0047** (rounds 0–6, sessions `0002/0004/0006/0008/0010/0012/0014-horizon-ajcr-w4-rep-free`) and **0048** (round 0, session `0002-horizon-ajcr-w4-rep-free`, `status: "running"`, `started_at: 2026-07-25T13:24:44.868953+00:00`, `workspace_sha 885608a298c91cfae92bc2059fec03ccf18a0a7e`). The odd-numbered `*-system` sessions in run 0047 are run-loop bookkeeping ("## Checklist"), not agent reports.

**IMPORTANT NEGATIVE FINDING: there are no "Progress" / "Why I stopped" / "Next" sections anywhere for this task.** I grepped every transcript text record — zero hits for "Why I stopped". Only two sessions produced substantive prose at all, and the mechanism of record for this lane is the **task comments** (§3), not `report.md`.

Concretely:
- `0047/0002-horizon-ajcr-w4-rep-free/report.md` — 2925 bytes, real (round 0).
- `0047/{0004,0006,0008,0010,0012}-horizon-.../report.md` — **each exactly 101 bytes**, and the content of all five is verbatim:
  > `[Your previous response had no visible output. Please continue and produce a user-visible response.]`
- `0047/0014-horizon-ajcr-w4-rep-free/` — **no `report.md` at all** (`meta.json` still says `"status": "running"`; last transcript record is a `tool_result` at `2026-07-25T13:23:10` from a `work-reviewer` subagent — the session was killed).
- `0048/0002-horizon-ajcr-w4-rep-free/` — **no `report.md`** (in flight).

### LAST 4 SESSIONS (chronological)

**(i) run 0047, session `0008-horizon-ajcr-w4-rep-free` (round 3)**
Started `2026-07-25T09:36`, ended `09:45:12` (~9 min). Usage: `tokens_in 3399638, tokens_out 2728, cost_usd 10.889459999999998`, 31 tool calls.
Report body, verbatim and complete: `[Your previous response had no visible output. Please continue and produce a user-visible response.]`
Its only substantive in-session statements (verbatim text records):
> "Sessions 0004 and 0006 produced no commits and empty reports. Let me check what they were doing."
> "Session 0006 burned 70 minutes on three scouts and lost the findings (no commits, empty report). Let me recover their reports from the transcript."
> "Scouts were killed before reporting — their findings are lost. Going direct to state."
No Lean edits; it was reading `DivSchemeCertZarKerSpan.lean`, `structure DivisorAdaptation`, `structure FinCoverData` when it ended.

**(ii) run 0047, session `0010-horizon-ajcr-w4-rep-free` (round 4)**
`09:45:38` → `10:38:08` (~53 min). Usage: `tokens_in 8505394, tokens_out 4586, cost_usd 30.489914999999986`, 59 tool calls. Report body verbatim: `[Your previous response had no visible output. Please continue and produce a user-visible response.]`
Substantive verbatim texts (these are the closest thing to a "Progress"/"Next" it left):
> "Rounds 1–3 produced no commits at all — they burned ~7M input tokens reading files and never landed an edit. So the live front is still session 0002's. Let me get straight to the Lean state."
> "Now let me look at the extraction machinery that builds adaptations, since that's where the isolating cover would have to come from."
> "The route through the certificate is now clear enough to attack. Let me check how the support locus behaves under the away-chart immersion."
> "A much better route is available than the roadmap's current one. Let me verify the pieces."
> "Now I'll check the specific lemmas needed for the route I've identified: collapsing the adaptation to the two pinned charts."
Then it hit the empty-output terminator. No commits.

**(iii) run 0047, session `0012-horizon-ajcr-w4-rep-free` (round 5)**
`10:38:35` → `11:03:41` (~25 min). Usage: `tokens_in 5925989, tokens_out 4444, cost_usd 20.77344`, 47 tool calls. Report body verbatim: `[Your previous response had no visible output. Please continue and produce a user-visible response.]`
Substantive verbatim texts:
> "Hand-off from round 4, which just ended. Reading its report plus recent ledger history."
> "Reports are empty. Going to the ledger and roadmap instead."
> "Now I have enough orientation. Let me check the subagents skill briefly, then dispatch parallel investigation while I work the math."
Ended immediately after. No commits.

**(iv) run 0047, session `0014-horizon-ajcr-w4-rep-free` (round 6) — THE SUBSTANTIVE ONE**
`11:04:03` → killed (last activity `13:23:10`); `meta.json` still `"status": "running"`, `workspace_sha 0d302651a220056659c01bfd97282ec3a7fbe326`. Usage: `tokens_in 21869154, tokens_out 701, cost_usd null`, 553 tool calls, 4 subagents. **No `report.md` was ever written.** Its record of work is task comment **C-0002** (quoted in full in §3 below, timestamped `2026-07-25T13:02:50.152749+00:00`), which is structured as "1. TESTED THE OBVIOUS ESCAPE AND PROVED IT BOUNDED / 2. IDENTIFIED THE REAL CONDITION / 3. BUILT THE MISSING BRICK'S ALGEBRAIC CORE / 4. FOUND AND FIXED A BUILD GAP / WHAT REMAINS". Its final long transcript text (`13:13:46`, 5520 chars) is a **janitor/hygiene** summary, not lane math — it opens:
> "`roadmap.md` and all project READMEs verify clean against the source. Cleanup done."
and reports "open `memory` 11 → 10", archival of `I-0190`, "No parent/child inconsistency anywhere ... across all 206 roadmap items", and "The `ddr.certificate` subtree now shows 5 children (`sep-nogo` landed done, `leak-image` added)".

**(v, for context) run 0048, session `0002-horizon-ajcr-w4-rep-free` (round 0)** — currently running, no report. Its record so far is task comment **C-0003** (`2026-07-25T14:06:14`), quoted in §3.

**Also worth having: run 0047 round 0 (`0002-horizon-.../report.md`, the only real report file on this task).** Key verbatim lines:
> "The representability lane had been stuck for ~7 sessions on a hypothesis it never needed. ... But every downstream consumer goes through `DivFamZar`, whose predicate is the *Zariski-local* `IsLocallyCertified` — a span-⊤ family of base localizations each carrying an ordinary certificate. The impossibility ruled out one spelling of the goal, not the goal."
> "The distinction that matters: localizing the **pieces** destroys finiteness (I-0209 is right about that), but localizing the **base** keeps the divisor scheme finite over it, and that is exactly what the consumer predicate is built from."
> "**Honest caveats**: the two remaining certificate obligations are real geometry, not packaging — and the syzygy file proves the kernel-spanning one is *equivalent* to the flatness being sought, so no cleverer submodule choice will evade it. The objective is not complete."
(Cost of that session: `tokens_in 68219684, tokens_out 46519, cost_usd 377.5832699999999`.)

---

## 3. Task comments on `ajcr-w4-rep-free`

`horizon task show ajcr-w4-rep-free --json` does **not** emit comments; they live at `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/tasks/comments/ajcr-w4-rep-free/{C-0001,C-0002,C-0003}.md`. Task state: `status: running`, `priority: normal`, `created_at: 2026-07-25T06:04:25.679374+00:00` (author Axel), `updated_at: 2026-07-25T13:24:44.862581+00:00`, `inbox_refs: [I-0320]`.

### C-0001 — `at: 2026-07-25T07:18:54.312921+00:00` (run 0047, session 0002-horizon-ajcr-w4-rep-free, round 0/8)
> Found and removed the lane's actual blocking point. The DD-R certificate lane had been grinding a GLOBAL certificate (IsCertified over the chart ring R_Z) whose no-leak input is false for refined pieces (I-0209) -- but no consumer needs it: every DD-R interface goes through DivFamZar, whose predicate is the Zariski-local IsLocallyCertified. Landed 5 kernel-checked commits relaxing the gate: span-top production rule, pointwise gate via quasi-compactness of Spec R, adaptation-free form, the support tube in Away-chart form, and the no-leak clause derived from support containment. Roadmap subtree restructured from one opaque blocker into 4 leaves (zar-gate done; tube-fibre, away-kerspan, away-assemble pending). Memory I-0320.

### C-0002 — `at: 2026-07-25T13:02:50.152749+00:00` (run 0047, session 0014-horizon-ajcr-w4-rep-free, round 6/8)
> Round 6: reframed the certificate obligation and removed a whole class of attempted routes, with everything kernel-checked (lake env lean per file; full lake build green, 9071 jobs).
>
> 1. TESTED THE OBVIOUS ESCAPE AND PROVED IT BOUNDED. The pointwise gate accepts any adaptation, so one
> can choose a SUPPORT-SEPARATED one; that really does trivialize the hard part (the Cech difference
> becomes literally zero, so both flat-cokernel clauses AND the kernel-spanning hypothesis are free --
> isCertified_of_separated). But the premise is essentially always false, now a theorem:
> supportLocus_disjoint_chart_inter_of_separated. Both pinned charts carry a partition of unity, so a
> support point of V0 cap V1 lies in a piece of EACH chart. Separation therefore holds only for divisors
> confined to the two vertical fibres of pi. Also refuted the specific shape the tube-fibre leaf was
> chasing (not_exists_unique_support_piece).
>
> 2. IDENTIFIED THE REAL CONDITION. Proved both directions that the assembler's per-piece no-leak clause
> IS the Z-clopen principle of I-0209: the piece trace is always open in the support, so leak-freeness is
> exactly clopen-ness of the trace in the divisor scheme. This explains why several sessions of fibre
> analysis never closed it -- the clause is not fibrewise.
>
> 3. BUILT THE MISSING BRICK'S ALGEBRAIC CORE. Cutting by an idempotent yields a direct summand
> (multiplication by e is a linear section), so the quotient inherits projectivity AND flatness with no
> finiteness input. The flat version is the one that applies, since piece section rings are known flat
> (not projective) over R. Assembled the chain: clopen trace => no-leak => Module.Finite colength, plus
> landed fibrewise regularity => the entire (c1) input, with no fibre containment and no Cech-cokernel
> flatness.
>
> 4. FOUND AND FIXED A BUILD GAP: the five DivSchemeCertZar* files from this run's earlier sessions were
> unreachable from the root module, so plain  had never elaborated any of them. One import
> fixed it (9043 -> 9071 jobs, green, nothing broken). Recorded as I-0324 with a rule.
>
> WHAT REMAINS: production of the clopen packet -- exactly I-0209's W-as-algebra extraction. Every other
> link now exists, including the mathlib translations (PrimeSpectrum.isClopen_iff_zeroLocus,
> exists_idempotent_basicOpen_eq_of_isClosed). New roadmap leaf certificate.leak-image carries the plan;
> tube-fibre re-scoped since its stated goal is refuted. Objective NOT complete. Memories I-0323, I-0324,
> I-0325.

*(Note: the file literally reads `exists_idempotent_basicOpen_eq_of_isClopen` — transcribed above as in the file; and "plain  had never elaborated" has a dropped word, present in the source.)*

### C-0003 — `at: 2026-07-25T14:06:14.338720+00:00` (run 0048, session 0002-horizon-ajcr-w4-rep-free, round 0/8)
> RUN 0048 ROUND 0 — the certificate lane's satisfiability question is answered, in Lean.
>
> THREE THEOREMS (commits 49866bdd1, 206967379, 40f357de8; three new files in the default build, all kernel-checked warning-free by lake env lean):
> 1. The assembler's per-piece hnoLeak clause FORCES the chart traces supportLocus cap V_b to be closed in the relative curve — a statement with no adaptation and no pieces in it. Because a FinCoverData has a partition of unity on EACH pinned chart, the union of a chart's piece traces IS the chart trace, and a finite union of closed sets is closed. So refining the cover provably cannot help, and shrinking the base only restates the condition over the smaller base.
> 2. 'Swallow or miss' (every piece contains the whole support or misses it) produces hnoLeak and clause (c1) with no fibre, tube or idempotent; a missing piece has a UNIT equation so its colength vanishes outright.
> 3. THE VERDICT: leak-freeness makes each piece trace clopen in the support, so a CONNECTED divisor with a leak-free adaptation satisfies supportLocus subset V_0 or supportLocus subset V_1. IsCertified is therefore satisfiable for a connected divisor only if the divisor avoids pi^-1(0) or pi^-1(infinity) — and base localization cannot repair it, since it does not disconnect the divisor (Spec R[x]/(x^2-t) over k[t] is connected over every basic open).
>
> WHAT THIS CHANGES. Seven rounds were spent proving hypotheses of an interface whose satisfiability had never been checked, for the adaptation (exists_divisorAdaptation ...).some — about which nothing is known. The obligation is now one design question: does the Z(diamond) chart confine its divisors to a single pinned chart? spec-dd-r.md ADDENDUM 1 item 2 asserts it does ('honestly certified over each Z-chart ring') but never proved it. If yes, the rest is bookkeeping via ofAnchors and the Cech complex collapses, retiring the hinj wall (hinj IS clause (c4)) rather than solving it. If no, the atlas needs a carve, or IsCertified/DivFamZar must be redesigned — a functor blind to chart-crossing divisors is not the divisor functor.
>
> Roadmap re-based: chart-trace DONE; tube-fibre, leak-image REJECTED; away-assemble DONE as written; away-kerspan BLOCKED (likely an artifact); new chart-avoid (urgent), swallow-adapt, cert-collapse (urgent), cert-assemble. Also quotient-bridge DONE, ddq BLOCKED, flattening-fallback REOPENED (empty rejection note, factually wrong rationale), plus dat-c.c9-chartlocus (urgent) and build-reach. Design of record: informal/spec-dd-r.md ADDENDUM 2. Memory: I-0327.

---

## 4. Inbox — OPEN items matching the keywords

`horizon inbox list --json` returns 332 items. Filtering OPEN items whose body matches `certificate | noLeak | no-leak | kerspan | hinj | chart trace | swallow | tube | supportLeak` gives exactly 10. All carry label `agent-ready`; none have a `subject` field (it is `None` — the first body line is the de facto subject).

| id | kind | created | updated |
|---|---|---|---|
| I-0209 | memory | 2026-07-17T09:48:15 | 2026-07-25T13:58:39 |
| I-0308 | issue | 2026-07-20T07:09:15 | 2026-07-25T07:57:12 |
| I-0320 | memory | 2026-07-25T07:16:01 | 2026-07-25T07:26:02 |
| I-0324 | issue | 2026-07-25T12:50:23 | 2026-07-25T14:07:53 |
| I-0327 | memory | 2026-07-25T13:58:20 | 2026-07-25T14:06:34 |
| I-0328 | issue | 2026-07-25T14:01:39 | — |
| I-0329 | issue | 2026-07-25T14:01:55 | 2026-07-25T14:02:10 |
| I-0330 | memory | 2026-07-25T14:02:25 | — |
| I-0331 | issue | 2026-07-25T14:02:42 | — |
| I-0332 | info | 2026-07-25T14:08:08 | — |

First lines, verbatim:

- **I-0332** (info): "TWO TEAMS CONVERGED ON THE SAME DD-R VERDICT INDEPENDENTLY (2026-07-25; run 0047 session 0014 and a later run's session 0002, both on task ajcr-w4-rep-free)." Its closing paragraph is load-bearing and I quote it in full: *"STILL MINE AND STILL NEEDED, not covered by their work: the pullback transport supportLocus_pullback / unitLocus_pullback (DivSchemeCertZarTransport.lean). Every support/no-leak/clopen lemma in the lane -- theirs included -- is stated for a system on relCurve C R, while the pointwise gate consumes the PULLED system over Localization.Away r. Without the transport none of these verdicts can be composed with the gate. It is now landed and in the default build (9075 jobs green)."* — i.e. **transport brick (1) of `cert-assemble` may already be landed** by the concurrent lane.
- **I-0327** (memory): "THE DD-R CERTIFICATE'S NO-LEAK CLAUSE IS A CHART-DESIGN CONDITION, NOT A FIBRE CONDITION / (proved in Lean 2026-07-25, run 0048, commits 49866bdd1 + 206967379; standing constraint for the certificate lane)." Contains the explicit **counterexample**: *"It is FALSE for a general degree-g divisor — model: V(t x^2 + x y + t y^2) in P^1 over k[t] has a DOMAIN section ring (no nontrivial idempotent after any base shrink) and fibre {0, infinity} at t = 0, so no adaptation of it can ever be certified."* And the rule: *"RULE: before proving a clause of `IsCertified`, ask which adaptation you are proving it FOR."*
- **I-0331** (issue): "sep-nogo leaf is marked done but its only positive theorem is provably inapplicable to the target system" / "Roadmap leaf AJCR.w4-rep.datum.dat-d.ddr.certificate.sep-nogo was set to done in run 0047 s0014." — recommends re-labelling `sep-nogo` as rejected; also warns *"isCertified_of_separated carries [Module.Flat R A.ovlProd] as an instance hypothesis ... hsep kills only the OFF-diagonal overlap colengths, and the diagonal ones (pieces i inf pieces i, not defeq to pieces i) still need flatness from somewhere."* **This directly bears on cert-collapse's diagonal-overlap step.**
- **I-0330** (memory): "The idempotent brick cannot be applied to a colength module directly: colength ideals are generated by NONZERODIVISORS, never by 1-e" / "Recorded 2026-07-25 after reviewing run 0047 s0014."
- **I-0329** (issue): "isClopen_trace/supportLeak pair is not the iff its docstring and commit claim (Picard/DivSchemeCertZarLeak.lean:191,207)" / "isClopen_trace_of_supportLeak_eq_empty concludes IsClopen (val -1 pieces), but supportLeak_eq_empty_of_isClopen_trace only HYPOTHESISES IsClosed, not IsClopen."
- **I-0328** (issue): "DD-R certificate lane: 9 sessions, zero landed lemmas that any DivFamZar consumer can reach" / "Reviewed run 0047 session 0014 (task ajcr-w4-rep-free). All 9 declarations added this session in Picard/DivSchemeCertZarSep.lean and Picard/DivSchemeCertZarLeak.lean are correct and sorry-free, but grep confirms NOT ONE of them (nor any of the 6 pointwise-gate lemmas from session 0002) is referenced outside the DivSchemeCertZar* tower itself." Also: *"The tower is a 1276-line island: it was not even in the default build until fd46fcf83 this session. Rounds 1-5 of run 0047 (sessions 0004/0006/0008/0010/0012, ~206 USD) produced NO Lean commits at all; every Lean commit of the run comes from rounds 0 and 6."* and *"Recommend the next session prove the transport lemma FIRST and immediately land the composition end-to-end (even conditionally on hnoLeak) so that at least one DivFamZar producer exists, rather than adding another certificate-side lemma."*
- **I-0324** (issue): "BUILD-REACHABILITY TRAP: new Picard files can be invisible to plain `lake build` (found 2026-07-25, run 0047 r6)." / "The project's defaultTarget is the root module AlgebraicJacobian.lean, so `lake build` with no"
- **I-0209** (memory): "THE Z-CLOPEN CERTIFICATE PRINCIPLE (DD-1/DD-2 lanes, 2026-07-17 — three independent sightings in one day; treat as a standing design constraint for every DAT-D brick)." / "A DivisorAdaptation piece carries an R-finite-projective colength — clause (c1) of IsCertified — IFF the piece's trace on the divisor scheme Z = V(D) (finite flat over Spec R) is CLOPEN in Z. ... Canonical counterexample: R = k[u], zero-section divisor, cleared piece D(u-tilde): colength = R_u."
- **I-0308** (issue): "COMPLETE REPRESENTABILITY (Wave 4 / divRep) — START HERE" / "**GOAL:** land `divRep`, then the datum tail, concluding `AJCR.w4-rep`."

### I-0320 in full (as requested)

Metadata: `kind: memory`, `status: open`, `labels: [agent-ready]`, `audience: horizon`, `author: horizon`, `owner_task: ""`, `read_by: [ajc-optimize]`, `created_at: 2026-07-25T07:16:01.324965+00:00`, `updated_at: 2026-07-25T07:26:02.977950+00:00`, `comments: []`, provenance `run 0047 / session 0002-horizon-ajcr-w4-rep-free / round 0 of 8 / task ajcr-w4-rep-free`.

> THE DD-R CERTIFICATE GATE WAS OVER-STRONG FOR ~7 SESSIONS (adjudicated 2026-07-25, run 0047).
>
> The DD-R certificate lane (AJCR.w4-rep.datum.dat-d.ddr.certificate) was attacking
> `(D.divisorAdaptation hD).IsCertified g` -- a certificate over the WHOLE chart ring R_Z --
> via `divisorAdaptation_isCertified_of_noLeak_kernel_spanning(_degree)` (DivSchemeCertUniv.lean:144,
> DivSchemeCertSeed.lean:61). Its `hnoLeak` input is FALSE for arbitrary extracted pieces (I-0209),
> so the lane was permanently blocked on an unprovable hypothesis.
>
> NO CONSUMER EVER NEEDED THAT. Every DD-R consumer goes through `DivFamZar`
> (DivisorFamilyZar.lean:242), whose membership predicate is `IsLocallyCertified`
> (DivisorFamilyZar.lean:71): certified families over `Localization.Away (g i)` for SOME span-top
> family g, divisor-equal to the pulled system. Check the chain: divRepPullAt (DivRepAffKit.lean:90),
> DivRepAffinePullback.pull (:168), divRepClassifyZar (DivRepClassifyZar.lean:244) -- all take
> DivFamZar, never IsCertified over R.
>
> LANDED THE RELAXATION (commits 2709f44d9, b959b798b, 612b5fae0, f868c9425; files
> Picard/DivSchemeCertZarSeed.lean, DivSchemeCertZarPointwise.lean, DivSchemeCertZarTube.lean;
> all kernel-checked warning-free by lake env lean):
> 1. isLocallyCertified_of_forall_exists_away -- span-top production rule.
> 2. isLocallyCertified_of_forall_prime_exists_away -- POINTWISE gate, via quasi-compactness of
>    Spec R (exists_fin_span_eq_top_of_forall_prime): an away certificate at every prime suffices.
> 3. isLocallyCertified_of_forall_prime_exists_certified_adaptation -- the adaptation is FREE
>    (exists_divisorAdaptation), so only the certificate over the shrunken base remains.
> 4. exists_basicOpen_supportTube / exists_notMem_supportLocus_subset_of_fibre -- the support tube
>    (SupportTube.lean:166) refined to a basic open, i.e. the Away shape the gate consumes.
> 5. isLocallyCertified_of_isCertified -- the old global gate is a special case, so this is a
>    genuine weakening, not a parallel track.
>
> RULE: before grinding a certificate/finiteness hypothesis in this project, check what the actual
> CONSUMER's predicate is. The project has both a global (IsCertified) and a Zariski-local
> (IsLocallyCertified) notion, and the downstream interfaces were built on the local one.

---

## Three things I'd flag from this sweep

1. **The task's `roadmap_refs` are stale.** `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/tasks/items/ajcr-w4-rep-free.yaml` still points at `tube-fibre` (now rejected), `away-kerspan` (now blocked/low) and `away-assemble` (now done). The live chain is `chart-avoid -> swallow-adapt -> cert-collapse -> cert-assemble`.
2. **I-0332 says `supportLocus_pullback` / `unitLocus_pullback` are already landed** in `DivSchemeCertZarTransport.lean` by the concurrent lane (9075 jobs green) — that is transport brick (1) of `cert-assemble`, and I-0328's "cheapest unblocking step". Worth checking on disk before re-proving it.
3. **Run 0047 rounds 1–5 (sessions 0004–0012) cost ~206 USD for zero commits and zero reports**, all five ending on the same harness terminator string. The only two productive sessions on this task (0047 r0, 0047 r6) both left their record as a *task comment*, not a report; r6 was killed before writing one.
