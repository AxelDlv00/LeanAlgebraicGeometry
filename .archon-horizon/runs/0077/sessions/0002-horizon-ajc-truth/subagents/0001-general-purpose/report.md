## Ground truth: verified, with two corrections

All five points check out at HEAD, with caveats:

- `instHasPicScheme` is gone from the Lean tree. Only `instHasPicSchemeEt` exists (`AlgebraicJacobian/Picard/FGAPicRepresentability.lean:366`), and `picSchemeOfHasRationalPoint` is a `theorem` at `:503`. **But** the generated artifacts still carry the dead name: `blueprint/lean_decls:2081` lists `AlgebraicGeometry.Scheme.instHasPicScheme`, and every `blueprint/web/chap-*.html` TOC carries `Sorry 5 — instHasPicScheme (L236)` (~10 files). Those are generated, not prose — flagging so you know a blueprint rebuild is part of the fix.
- Sole sorry-bodied instance: confirmed by a scan of all 270 `instance` declarations for `sorry` in the body — `instHasPicSchemeEt`, body `⟨(fgaPicardRepresentability C).1⟩`.
- `pullback_preservesFiniteLimits` is a plain `theorem` (`Cohomology/CechHigherDirectImageUnconditional.lean:974`); the `sorry` sits in `pullback_preservesMonomorphisms` (`:954`).
- `hasRationalPoint_of_curve` is deleted; only `hasRationalPoint_of_curve_of_isAlgClosed` survives (`Jacobian.lean:360`).

---

## (A) Rational-point question presented as an OPEN DECISION

All in `informal/pic-representability-campaign.md`, in the front-matter block that a reader hits first, and one hgraph node pair.

- `informal/pic-representability-campaign.md:22` — "Neither branch is assumed anywhere in this plan."
- `:21` — "Open with the human as inbox `I-0372`, roadmap node `AJC.picrep.rational-point`."
- `:31` — "What the owner must decide is only the rational point, and that half is genuinely false in general rather than merely unproved."
- `:43` — "Neither branch is chosen, and nothing below assumes one; what is now settled is that the general-field leaf is the only place the decision bites."
- `:36-38` — "It narrowed again on 2026-07-28, in a direction that **bounds** the decision rather than settling it." (the 2026-07-28 date is the decision date; this sentence denies the settlement)
- `:337-340` — "So: neither branch has its representability theorem… The decision (`I-0372`) is the owner's and neither branch is assumed anywhere"
- `hgraph/nodes/e13e74f8a8db.md:17` (docstring of the DELETED `hasRationalPoint_of_curve`) — "Neither is chosen (the decision is recorded as an open owner decision; see `README.md` and `informal/pic-representability-campaign.md`)". Node has `stale: true` but the body is served as-is.
- `hgraph/nodes/e13e74f8a8db.md:49` and `hgraph/nodes/196ef3926e2c.md:26` — "This delimits the open decision precisely… Both remain recorded, neither is assumed." The second node is `lean_status: lean_ok`, NOT marked stale, and is the node for the live theorem `hasRationalPoint_of_curve_of_isAlgClosed`.
- `hgraph/nodes/2e6dac58a720/comment-1.md:16` — "It must be REPLACED by whichever branch of I-0372 the human picks… never discharged."
- `hgraph/nodes/54a1d8cf5f23/comment-1.md:22` — "whose leaf A must be REPLACED per the human's I-0372 decision, never proved."
- `hgraph/nodes/03d8650bd571.md:25` (mirrors `scripts/axiom-frontier.lean:488`) — "§0c Branch (1) of the open decision I-0372"
- `hgraph/nodes/b584927c08ef.md:15` — "which is the whole of the open decision I-0372"

Blueprint is clean here: `Picard_FGAPicRepresentability.tex:121-123` says "it is *settled*: formulation (1), by owner decision of 2026-07-28", and `Jacobian.tex:325` says "a settled choice, not an open branch".

## (B) Quot / quotient endgame in the present tense

Correctly labelled off-path (not stale): `Picard_QuotScheme.tex:4484-4493`, `:8416-8419`, `Picard_FGAPicRepresentability.tex:56-64`, `Picard_FlatteningStratification.tex:2744-2747`, `README.md:14-18`, `informal/pic-representability-campaign.md:6-10`.

Stale or reader-misleading:

1. **`blueprint/src/chapters/Picard_QuotScheme.tex` has no up-front off-path notice in rendered prose.** The only off-path statement in the chapter's opening is a LaTeX comment at `:6-20` — `% WHICH ROUTE THIS SERVES… % That route is not the one being formalised` — invisible in both `web/` and `print/`. The first rendered text, `\section{Setup and motivation}` (`:32-51`), presents the construction with no route caveat: "each of which Grothendieck proved is representable by a projective \(S\)-scheme. This chapter develops the foundations of that picture". A reader of the rendered blueprint meets ~4,480 lines of Quot material before the first visible off-path line (`:4484`).
2. **`blueprint/src/content.tex:28` orders `Picard_QuotScheme` before `Picard_FGAPicRepresentability` (`:33`)**, so the chapter that explains the route choice comes *after* the retained-off-path engine. `content.tex` carries no ordering rationale or off-path annotation at all — it is a bare `\input` list. The reader's first encounter with representability strategy is the Quot chapter.
3. `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:31` — "It is the route of the proof written out under \cref{thm:fga_pic_representability} below." Qualified two paragraphs later, but the sentence itself reads present-tense-strategic.
4. `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:1238` (§`subsec:sorry_has_pic_scheme`) — "Either route of \cref{sec:fga_pic_setup} establishes it, and they consume different inputs", then `:1252-1266` writes out the quotient route's four steps and inputs in the present tense alongside the Milne–Kollár ones, ending "Both routes rest on the same divisor and comparison substrate, and the rational-point hypothesis enters both in the same way."
5. `hgraph/nodes/3b59ae27f454.md:18` — "Castelnuovo--Mumford boundedness in the Quot endgame" (no off-path marker; the correctly-marked counterpart is `hgraph/nodes/e9ca6d3bc2b6/comment-1.md:17`, which says "Engine of the abandoned quotient endgame").

## (C) Stale synthesis-leak / sorried-instance claims

- `scripts/axiom-frontier.lean:447` — "**producer is the `sorry`-bodied `instHasPicScheme` (§2).** Over a general field that gate hides *behind* leaf A" (in §0b, the section that is *itself* about measuring the gate). Also `:415` "it makes `instHasPicScheme` fire instead of being assumed", `:86` "the synthesised gate `instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`", `:497` same phrase in §0c, `:1167` "`HasPicScheme` is what exposes `instHasPicScheme`", `:1206` "the only producer is the `sorry`-bodied `instHasPicScheme`" (§8 header), `:1296` "Unlike the `picSharp` gate above". `:538-539` is the *correct* statement (both demoted), so the file contradicts itself.
- Mirrored verbatim in hgraph: `hgraph/nodes/03d8650bd571.md:33`, `:74`, `:703`, `:742`; `hgraph/nodes/c3243a90cbe8.md:462`, `:501`.
- `hgraph/nodes/196ef3926e2c.md:48-52` — "the witness still rests on five obligations — `Scheme.instHasPicScheme`, `Pic0.smooth`, `Pic0.proper`, and leaves B and C… and that `sorry`-bodied instance is its sole producer". This node is `lean_ok` and not flagged stale.
- `hgraph/nodes/e13e74f8a8db.md` docstring — "`Scheme.instHasPicScheme` takes `[HasRationalPoint C]` and is correct to do so"; also `hgraph/nodes/b584927c08ef.md:15`, `hgraph/nodes/4d414128ae21.md:39` ("the FGA-campaign ambient form (`instHasPicScheme`)").
- `hgraph/nodes/54a1d8cf5f23/comment-1.md:20` — "the sorry-bodied instance is its sole producer" (referring to `def:inst_has_pic_scheme`).
- `informal/pic-representability-campaign.md:123` — "Target: `instHasPicScheme` — …`FGAPicRepresentability.lean:259-263` (re-verified 2026-07-27: `⟨sorry⟩` body at :263… under … `[HasRationalPoint C]`)". Also `:1` and `:2` (title: "Campaign plan for `instHasPicScheme`"), `:41`, `:110`, `:180`, `:294` ("**G5 — Discharge `instHasPicScheme`.**… at `FGAPicRepresentability.lean:309`"), `:328`, `:330`, `:657` ("`instHasPicScheme` remains a single `⟨sorry⟩`"), `:685`, `:713`, `:732` ("line drifts recorded (instHasPicScheme now :313/:317)").
- `informal/pic-representability-campaign.md:350` — the janitor correction: "This bullet used to name `pullback_preservesFiniteLimits` as the *second* of exactly two sorried instances in the tree. That is stale on both halves and **the fbc half is measured here**". The gate half is explicitly left uncorrected ("is left for that lane to restate"), so the false half persists in the ~12 sites listed above.
- `informal/README.md:9-10` — "the plan of record for `instHasPicScheme` (D3 Milne–Kollár route…)".
- Blueprint label/heading names still encode the dead instance: `Picard_FGAPicRepresentability.tex:1096` `\label{def:inst_has_pic_scheme}` pinning `\lean{...picSchemeOfHasRationalPoint}`, and `:1233` `\label{subsec:sorry_has_pic_scheme}`. Referenced 12× across `Jacobian.tex` and `Picard_FGAPicRepresentability.tex`. `README.md:210-211` already flags this: "`def:inst_has_pic_scheme` pins `picSchemeOfHasRationalPoint`, which reports `sorryAx` at HEAD."
- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:845` — "This is **the standing hypothesis of the chapter**" (of `HasRationalPoint`). Contradicts `:126`, which says the hypothesis "is now the mark of a conditional milestone rather than a standing convention of the chapter". Mirrored at `hgraph/nodes/d5d54738512f.md:19`.

`README.md:71-78` and `TO_USER.md:35-48` are current and correct on this trap.

## (D) Conditional witnesses presented as the headline

No file presents `...OfHasRationalPoint` or `...OfIsAlgClosed` as the headline. Explicit "not the headline" labels are in place at `blueprint/src/chapters/Jacobian.tex:162-178`, `:330-337`, `Picard_FGAPicRepresentability.tex:108-118`, `:1103-1110`, `README.md:132-146`, `TO_USER.md:14-19`, `hgraph/nodes/b584927c08ef.md` ("**This is a CONDITIONAL milestone and NOT the headline**").

Two adjacent problems, neither a headline claim:

- `blueprint/src/chapters/Jacobian.tex:363-372` — the proof of `def:picardJacobianWitnessOfIsAlgClosed` lists its obligations as "representability (\cref{def:inst_has_pic_scheme})", i.e. the `Pic^♯` gate rather than `fgaPicardRepresentability`; consistent with the conditional statement but it routes the reader to the stale label.
- `hgraph/nodes/54a1d8cf5f23/comment-1.md:18` — "picardJacobianWitness supplies leaf A from hasRationalPoint_of_curve, which is FALSE over a general base field. So its consequences are vacuously true." This describes the *headline* as resting on the deleted false leaf. Node `updated: 2026-07-29T13:44:21`; the comment was not revised.

## (E) Axiom-frontier and reachability figures — every carrier

Four distinct frontier triples, four distinct build-job counts:

| file:line | exact quote | jobs claimed |
|---|---|---|
| `scripts/axiom-frontier.lean:65` | "**126 probed, 84 clean, 42 carrying `sorryAx`**" | "green at 8746 jobs" |
| `hgraph/nodes/8b4d723fc7f5.md:54` | identical text (mirror of the above) | "8746 jobs" |
| `informal/pic-representability-campaign.md:320-321` | "(126 declarations, 84 clean, 42 carrying `sorryAx`, with the root build green at 8,746 jobs)" | 8,746 |
| `README.md:85-87` | "147 declarations: 95 clean and 52 carrying `sorryAx`, measured 2026-07-28 with `lake build AlgebraicJacobian.Jacobian` green at 8,657 jobs" | 8,657 (note: **headline target**, not root) |
| `TO_USER.md:30-31` | "it probes 162 declarations, 108 clean and 54 carrying `sorryAx` as last measured (2026-07-28, `lake build AlgebraicJacobian` green at 8,773 jobs)" | 8,773 |
| `scripts/axiom-frontier.lean:1096` | "(156 probes, 35 `sorryAx`)" — a *scratch-path* sub-measurement, no clean figure | none |
| `hgraph/nodes/03d8650bd571.md:632` | identical "(156 probes, 35 `sorryAx`)" mirror | none |

Historical/derived variants inside the same sentences, which also move if you re-measure: `scripts/axiom-frontier.lean:66` and `hgraph/nodes/8b4d723fc7f5.md:55-57` — "(125/84/41 before §0c added the branch-(1) assembly; 113/72/41 before §6f…; 107/70/37 before the two leaf-A lines…)".

Sibling-probe frontier figures (separate scripts, separate scopes):
- `scripts/axiom-frontier.lean:862` and mirrors `hgraph/nodes/03d8650bd571.md:398`, `hgraph/nodes/c3243a90cbe8.md:157` — "`scripts/ajcrr-fibervanishing-axioms.lean`: 41/41 clean, control firing."

`\leanok`-audit figures (a second family, same rot risk):
- `scripts/axiom-frontier.lean:130-133` — "proof-level: 1078 marks pinning 1073 declarations = 930 public + 143 private, 0 unresolved, ZERO carrying `sorryAx` / statement-level: 1567 marks pinning 1560 declarations = 1372 public + 188 private, 0 unresolved, 34 carrying `sorryAx`, across 34 nodes"
- `hgraph/nodes/8b4d723fc7f5.md:119-122` — identical mirror
- `README.md:213-217` — "**proof-level, 1073 pinned declarations across 1078 marks = 930 public + 143 `private`, zero carrying `sorryAx`; statement-level, 1560 declarations across 1567 marks = 1372 public + 188 `private`, of which 34 carry `sorryAx`.**"
- `scripts/axiom-frontier.lean:325` and `hgraph/nodes/ea22aef24403.md:134` — "143 of the 1073 proof-level pins (188 of 1560 at statement level) name `private` declarations"
- `scripts/axiom-frontier.lean:122` and `hgraph/nodes/8b4d723fc7f5.md:111` — "it intersected the marks with §0–§8, which name 126 declarations" (a *third* dependency on the 126)
- `scripts/leanok-audit.sh:39` — "disagreement (1552 vs 1560)"; `:53` — "188 statement-level pins are private"

**"N of M modules reachable from the headline":**
- `scripts/axiom-frontier.lean:36` — the recipe line `print(f'{len(seen)} of {total} project modules reachable from the headline')`
- `scripts/axiom-frontier.lean:39` — "Re-measured 2026-07-28: **98 reachable modules of 187 on disk**, and zero unrooted, up from 8 before `picardJacobianWitness` was wired to `Scheme.Pic0Scheme`."
- `hgraph/nodes/8b4d723fc7f5.md:25` and `:28` — identical mirrors of both lines
- `TO_USER.md:76-77` — "`picardJacobianWitness` is built from `Pic⁰_{C/k}` and **reaches 98 project modules, up from 8**; the whole committed tree is reachable from the project root."
- `hgraph/nodes/9898e8e9a9a0.md:53` — "was taken inside this file's import cone (**99 modules**)… while the root cone (**215 modules**) contains it"

I re-measured the reachability figures now: **290 modules on disk, 270 reachable from `AlgebraicJacobian`, 141 reachable from `AlgebraicJacobian.Jacobian`.** So "98 of 187" is stale on both halves, and the "zero unrooted" clause contradicts `README.md:60`.

**Unrooted-module counts:**
- `README.md:60-62` — "**Currently violated in 20 modules** (re-measured 2026-07-29 by walking `import AlgebraicJacobian` from the root module: **269 of 289** in the root cone, 20 outside it)." (my measurement: 270 of 290)
- `README.md:68` — "The count has moved 6 → 14 → 18 → 19 → 20 over five measurements"
- `README.md:38` — "**288 modules, 165,477 lines** (re-measured 2026-07-29… up from 284/163,544 earlier the same morning)" (now 290 / 165,645)
- `README.md:40-41` — "green at 8,746 jobs when last measured… it was **26 over 10 modules** at the last census"
- `README.md:243-245` — "`RiemannRoch/Ledger/` (**56 files**)… Partly rooted (**37 of 56**, via `WeilDivisor.lean`); the remaining **19** are outside the root cone" (contradicts the 20 at `:60`)
- `README.md:109` — "**99 modules** still open with a bare `import Mathlib` (measured 2026-07-29 07:03, up from 81)"
- `scripts/axiom-frontier.lean:39` — "**zero unrooted**" (contradicts README)
- `scripts/ajcrr-fibervanishing-axioms.lean:22` — "Measured 2026-07-29: `import AlgebraicJacobian` **reaches 257 of 274 modules**, and these eight are among the 17 it does not"
- `scripts/ajcrr-genusfieldinvariance-axioms.lean:30` and mirror `hgraph/nodes/c68983f49c2f.md:19` — "**262 modules are reachable** from `AlgebraicJacobian.lean`"
- `scripts/ajcrr-sectiondrop-axioms.lean:16` — "measured from the root *file* `AlgebraicJacobian.lean` (**closure 251 modules**, 2026-07-28)"

**Sorry-carrier counts (a fifth family that moves with the frontier):**
- `scripts/axiom-frontier.lean:542-543` and mirror `hgraph/nodes/03d8650bd571.md:78-79` — "**28 `sorry`-bodied declarations** over 11 modules, of which **21 theorem + 7 def + 0 instance**"
- `scripts/axiom-frontier.lean:604` and mirror `hgraph/nodes/03d8650bd571.md:140` — "**21 theorem + 7 def + 0 instance = 28**"
- `scripts/axiom-frontier.lean:561` — "the **24 non-instance carriers** as of the measurement above were" followed by a per-module list that still names the deleted `hasRationalPoint_of_curve` (`:564`); mirrored at `hgraph/nodes/03d8650bd571.md:100`
- `TO_USER.md:47` — "of the tree's **28 `sorry` carriers**, zero are instances"
- `informal/pic-representability-campaign.md:322` — "the carrier list from `lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u` (**26 over 11 modules**)" (README says 26 over 10)

Nothing in `blueprint/src/**/*.tex` or `hgraph/edges/**` carries an axiom-frontier count, a reachability figure, or an unrooted count. All 6,802 edge files are clean; the blueprint's only numeric exposure is via generated `blueprint/web/` and `blueprint/lean_decls`.
