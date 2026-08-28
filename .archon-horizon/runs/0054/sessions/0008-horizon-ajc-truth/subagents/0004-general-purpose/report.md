Audit complete. All measurements are read-only; I edited nothing.

## Important caveat on measurement stability

The tree is being edited live by a sibling session. During my audit, `README.md`, `TO_USER.md`, `scripts/axiom-frontier.lean` and the campaign plan were all rewritten under me by ledger commit `f62c6b4e9` ("the frontier IS re-measured through the root path"), and the AJC line count moved from 131,191 → 131,240 while I worked. Findings below are against the **current** on-disk state as of 00:51 (2026-07-28) unless noted.

## Findings, ranked by severity

### 1. README internal contradiction: 24 vs 26 sorry carriers (HIGH)

`README.md:89-93`:
> "The probe's §2 lists all 24 carriers by module ... note that two of the 24 hold their `sorry` in a *field*"

The real value is **26**, and the same README says so 50 lines earlier (`README.md:38`: "**26 `sorry`** over 11 modules"). `TO_USER.md:21-22` also says 26 ("the probe's §2 lists all 26"). The probe's own §2 (`scripts/axiom-frontier.lean:144-145`) says 26 total = 2 instances + 24 non-instances. So README:91-93 has conflated "the other 24 non-instance carriers" with the total, and its "two of the 24" phrasing is doubly wrong: the two field-held carriers (`cech_pushforward_baseChange_natIso`, `twisted_cech_nerve_iso`) are 2 of the 24 non-instances, which happens to be right, but the sentence reads as 24 being the total.

My independent comment-stripping measurement confirms **26 over 11 modules**, and the §2 enumeration matches exactly, module for module and name for name. I verified all 20 named non-leaf declarations exist.

Same error, uncorrected, in roadmap node `AJC.jacobian.reachability` summary: "**24 sorry-bodied declarations**, of which exactly two are instances" — that says 24 total *and* 2 instances, which contradicts itself against the 26/11 figure the same roadmap gives at `roadmap.md:20` and `roadmap.md:85`.

### 2. README line count 131,165 is stale; no recipe reproduces it (HIGH)

`README.md:38`: "**185 modules, 131,165 lines**"

Module count 185 is correct. The line count is not reproducible by any recipe:

| recipe | value |
|---|---|
| `find AlgebraicJacobian -name '*.lean' -exec cat {} + \| wc -l` (README's own recipe, line 44) | **131,240** |
| same + `AlgebraicJacobian.lean` (238 lines) | 131,478 |
| all `.lean` incl. `scripts/` | 132,015 |
| **ledger HEAD as of my check** | 131,191 |

131,165 matched the tree at approximately 00:35 and was already stale by 00:47. Both `RiemannRoch/Adelic/ResidueField.lean` and `Jacobian.lean` were modified during my audit. This number cannot be stabilized while sibling sessions are landing; the README's own advice ("re-measure rather than quoting them") is the right disposition, but the headline still publishes a bare figure. Note the header says "measured 2026-07-27" while the frontier bullet below it says "measured 2026-07-28" — the State section is dated a day behind its own contents.

### 3. Roadmap denominator is 181, disk is 185 (MEDIUM)

`roadmap.md:78`: "26 open `sorry` in 11 of 181 modules"
`roadmap.md:85`: "*170 of the 181 modules are sorry-free*"
`roadmap.md:133`: "66 of 181 modules still open with a bare `import Mathlib`"

Real: **185** modules on disk and 185 in ledger HEAD. So it is **174 of 185** sorry-free (185 − 11), and **66 of 185** umbrella-importing. The 66 is correct in absolute terms (I measured 66 files matching `^import Mathlib$`); only the denominator is stale. The 26/11 numerator is right.

### 4. Blueprint claims not verifiable as stated; two are wrong (MEDIUM)

Roadmap `AJC.maintenance.blueprint` summary:

- "**623-page LuaLaTeX PDF**" — `blueprint/src/print.log:7700` says `Output written on print.pdf (624 pages, 3923824 bytes)`. Off by one.
- "**zero multiply-defined labels**" — 14 duplicated `\label{...}` exist across `blueprint/src/chapters/*.tex` (`cor:sm`, `prp:pic0`, `th:qpp&p`, `definition-pic`, `df:aPf`, `df:Pfs`, `df:Psch`, `equation-extended`, `lemma-invertible`, `lemma-constructions-invertible`, `lemma-points-exactness`, `lemma-stalk-tensor-product`, `lemma-tensor-product-pullback`, `rmk:Jac`). All 14 are inside LaTeX comments (`%` lines quoting source text, duplicated between `Picard_IdentityComponent.tex` and `Picard_Pic0AbelianVariety.tex`), so LaTeX does not see them and `print.log` is genuinely clean of "multiply defined". The claim is true as a build property, false as a source property. Low practical impact but the number is grep-falsifiable.
- "ZERO errors, ZERO unresolved references" — confirmed: `print.log` has 0 lines matching `^! `, 0 undefined-reference warnings. The 747 overfull boxes claim is exact.
- "**1933 blueprint nodes, 4629 lean nodes**" — current hgraph has **1,935 tex** and **4,657 lean** nodes (6,604 files total). Drifted, direction consistent with growth.

### 5. Probe/README/TO_USER frontier numbers were correct only after a mid-audit commit (MEDIUM — resolved during audit, flagged for the pattern)

When I started, all three documents published "107 `#print axioms` lines; 105 last measured green, 69 clean, 36 carrying `sorryAx`" with an explicit red-build caveat. Mid-audit, commit `f62c6b4e9` replaced these with "**107 declarations: 70 clean and 37 carrying `sorryAx`**, measured 2026-07-28 with the root build green at 8,744 jobs."

- The **107** is exactly right: I counted 107 lines matching `^#print axioms` in `scripts/axiom-frontier.lean` (note: a naive `grep -c '#print axioms'` gives **114**, because 7 more occurrences appear in prose/comments — the anchored count is the correct one).
- The **70/37** split I could not independently verify, per instruction not to run a full build. Corroborating evidence that the build did go green: all 185 modules have an `.olean` newer than their source, zero missing, zero stale, and zero `.trace.nobuild` markers anywhere in `.lake`. `ResidueField.olean` (483 KB, 00:45) now exists, where at 00:35 only a `.trace.nobuild` was present. So the red build described in my task brief was real and has since cleared.
- **Residual overclaim**: `README.md:36` still dates the State section "measured 2026-07-27" while embedding a 2026-07-28 measurement, and `README.md:38` still asserts "a warm `lake build AlgebraicJacobian` **green** at 8,744 jobs" as a bare present-tense fact with no measurement date, unlike the frontier bullet which now dates it. Given the tree changed twice in the 15 minutes I was auditing, a bare "green" assertion on a live tree is the exact class of claim that cannot be true for long.

### 6. Reachability numbers are all correct (NO FINDING — verified)

I ran the python snippet embedded verbatim at `scripts/axiom-frontier.lean:23-37` from the project root:

```
98 of 185 project modules reachable from the headline
```

- "**98 reachable modules**" (README:130, TO_USER:41, probe:39, roadmap node) — **correct**.
- "185 on disk" — **correct**.
- "**zero unrooted**" / "the whole committed tree is reachable from the project root" (TO_USER:42) — **correct**. Seeding the walk with `['AlgebraicJacobian']` reaches 186 (185 modules + the root file itself); the set difference against the on-disk module list is empty. I also confirmed every on-disk module is committed in ledger HEAD, so "committed tree" and "on-disk tree" coincide here.
- "up from 8" — not independently checkable (historical).

### 7. "Quot endgame" framing is clean (NO FINDING — verified)

No document advertises the Quot route as current. `README.md:14-18` explicitly says it is "**not** the path being built" and gives the reason (non-expressible quasi-projectivity hypothesis, lemma false without it) while noting the substrate is retained and consumed. `informal/pic-representability-campaign.md:4-10` says the same as "route of record" with the Quot endgame "retained as mathematics but not the path being built." `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:47-55` matches: "The Lean development therefore pursues the Milne–Kollár route ... not the path currently being formalised." `§sec:fga_pic_milne_kollar` exists at line 414 as claimed. The route-comparison claim that both routes need a Hironaka-defeated hypothesis appears at `Picard_FGAPicRepresentability.tex:664` as claimed.

One nuance worth noting: `README.md:15-16` says quasi-projectivity "is not expressible at the pinned Mathlib revision," while the blueprint says "not expressible in the formalisation at present." The README's phrasing attributes the limitation to Mathlib specifically; the blueprint's is weaker and more defensible. Minor.

### 8. Rational-point decision is presented correctly as an open human decision (NO FINDING — verified)

Presented as open and unresolved in all five places the roadmap claims: inbox `I-0372`, roadmap node `AJC.picrep.rational-point` (status **blocked**, title "DECISION: the rational-point hypothesis"), `README.md:98-115`, `TO_USER.md:3-12`, and the blueprint. Both branches are described accurately:

- Branch 1 (represent plain `Pic^♯`, carry `C(k) ≠ ∅`): correctly labeled strictly weaker, with correct counterexamples (`Picard_FGAPicRepresentability.tex:86-89` cites a pointless conic and a genus-2 curve over ℚ).
- Branch 2 (étale-sheafify, drop the hypothesis): correctly attributed to Kleiman, correctly justified (sheafification supplies étale-locally what the section supplies globally), and correctly noted that Mathlib v4.31 carries the étale topology so this is a design choice not a platform limit.

The narrowing is also accurate and load-bearing: the leaf formerly bundled geometric integrality, that half is now the theorem `geometricallyIntegral_of_curve` (`AlgebraicJacobian/Jacobian.lean:250`), and the leaf `hasRationalPoint_of_curve` is correctly described as **false in general, to be replaced rather than proved**. Neither branch is assumed anywhere I looked.

### 9. Smaller numeric drifts (LOW)

- `roadmap.md:141`: "Retire the **199** heartbeat overrides (**157** `maxHeartbeats`, **42** `synthInstance`)". Real: **158** `set_option maxHeartbeats` + **42** `set_option synthInstance.maxHeartbeats` = **200**. Also **15** `maxSynthPendingDepth` (the "depth overrides" mentioned but not counted).
- `roadmap.md:131`: "Normalize the copyright header of all **164** modules". All **185** modules now carry `Copyright (c) 2026`; 164 was the count when the pass ran.
- `roadmap.md:145`: "24 `sorry` notices are honest and stay" — should be 26, same off-by-two as finding 1. The "138 mechanical Lean warnings" figure I could not verify without a build.
- `README.md:59` calls `instHasPicScheme` "the sole producer of `HasPicScheme`" — verified correct; it is the only instance, and the other `HasPicScheme` references are consumers via `HasPicScheme.has_pic_scheme` or unrelated Prop-class pattern citations.
- Toolchain claim "Lean and Mathlib both pinned at `v4.31.0`" (`README.md:164`) — verified: `lean-toolchain` is `leanprover/lean4:v4.31.0`, mathlib manifest `inputRev` is `v4.31.0`.

### 10. Claims I could not verify (stated for completeness)

- The 70/37 clean/leaking split (requires the full build I was told not to run).
- "8,744 jobs" (build-log figure, no log on disk).
- 138 mechanical warnings.
- Historical figures ("up from 8", "down from 86", the 16.6 s / 7 GB vs 3.5 s / 2.0 GB import-cost measurement).
- Roadmap node `AJC.jacobian.reachability` is marked **done** while its own summary embeds numbers that the ledger has since revised; `AJC.maintenance.blueprint` is **pending** with a 624-vs-623 page error. The roadmap also emits a consistency warning of its own: `AJC.jacobian.assembly` is pending while every sub-item is done.

## Bottom line

The prose is unusually disciplined about the *epistemics* of its numbers — it publishes recipes, distinguishes measured from asserted, and names six specific ways a clean axiom line can mislead. Its verifiable structural claims (98 reachable, 185 on disk, 0 unrooted, 107 probe lines, 26 sorries over 11 modules, the exhaustive §2 carrier enumeration, route-of-record framing, both rational-point branches) all check out exactly.

The defects are arithmetic and staleness, concentrated in three spots: the **24-vs-26 carrier count** (README:91-93 and the reachability roadmap node, contradicting the same documents elsewhere), the **131,165 line count** (no recipe reproduces it; real value 131,240 and moving), and the **181 module denominator** in the roadmap (real 185). Plus the 624-vs-623 page count and the "zero multiply-defined labels" claim, which is true of the build and false of the sources.
