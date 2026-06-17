# Iter 021 — Plan (Quot-Foundations)

## TL;DR

A **frontier-prove + enabling-refactor** iter. Entry: iter-020 closed the QUOT SNAP-S2 keystone
axiom-clean (last live QUOT math leaf) and route-swapped FBC so `gstar_transpose` is the new live crux.
This iter: (1) honored the **standing user PARALLELISM directive** by file-splitting `QuotScheme.lean`
(1696→423 lines) into a new `GradedHilbertSerre.lean` (1287 lines, 0 sorries, keystone axiom-clean) +
de-privatizing the 11-decl IsRatHilb toolkit (clears recurring M1) + removing the iter-020 stale-comment
major; (2) cleared the leandag coverage debt by blueprinting the 2 new GradedModule helpers; (3)
dispatched the **two live frontier prover lanes** — GF (close the L4 finiteness leaf @754 + cascade) and
FBC (prove `gstar_transpose` @1525). Both blueprint chapters cleared the HARD GATE this iter
(blueprint-reviewer `iter021`). The progress-critic returned GF **STUCK** (a deferral-phrase metric
artifact) and FBC **UNCLEAR** — I honored the critic's must-fix (close @754 now) and explicitly rebut the
STUCK-as-pivot reading below.

## State at entry (iter-020 outcomes, verified this iter)

- **FBC 4 sorries** — `gstar_transpose` @1525 (live crux, first attempt), affine @1698, FBC-B @1720, +
  dead `fstar_reindex_legs` @1421 (orphaned, harmless). `domain_read` route built axiom-clean iter-020.
- **GF 3 sorries** — L4 finiteness leaf @754 (deferred for budget; collapsing lemma scouted), B/𝔭
  cascade @1810 (bottoms at L4+L5), GF-geo @1898 (gated). Injectivity crux closed iter-019; dévissage
  2/3 closed iter-020.
- **QUOT** — keystone `gradedModule_hilbertSeries_rational` axiom-clean; only 4 protected stubs remain
  (gated on QUOT-defs predicate builds — not yet proveable). Stale comment @1510 (iter-020 major).
- Build GREEN all modules (iter-020 verified).

## Subagents dispatched (3; all returned)

- **progress-critic `iter021`** — FBC **UNCLEAR** (route swap reset; 0 prover data on the new crux; no
  recurring blocker; proceed/watch), GF **STUCK** (the deferral phrase "@754 unchanged / deliberate
  budget scope-call" in iters 018/019/020 triggered the STUCK rule). Must-fix: close @754 THIS iter (no
  further deferral) — already the GF objective. Both OVER_BUDGET (administrative — refresh estimates).
  Dispatch sanity OK (2 lanes).
- **blueprint-reviewer `iter021`** — GF HARD GATE **PASSED** (the iter-020 `complete:false` was a
  `\leanok`-completeness observation, NOT a prose gap; Step 3a–3c + B/𝔭 cascade prose adequate to
  dispatch). FBC HARD GATE **PASSED** (`gstar_transpose` complete+correct, 3-step counit-factorization
  recipe; deps all `\leanok`/`\mathlibok`). QUOT 2 new helper blocks well-formed; covers-split coherent;
  one minor (`finrank_comap_subtype` referenced via `% NOTE:` not `\uses{}`) — FIXED this iter by wiring
  it into its consumer's `\uses{}`. leandag 0 unknown_uses / 0 broken refs.
- **refactor `quot-split`** — COMPLETE. `QuotScheme.lean` 1696→423 lines (Quot/Grassmannian/predicate
  layer + 4 protected stubs); NEW `GradedHilbertSerre.lean` (1287 lines, graded Hilbert–Serre layer, 0
  sorries, keystone axiom-clean `{propext, Classical.choice, Quot.sound}`); 11 decls de-privatized; stale
  comment removed; root `AlgebraicJacobian.lean` imports the new module; both modules build clean. No
  signature/label/name changes; no protected-decl moves.

## Decision made

### GF STUCK — honor the corrective, rebut the pivot (NOT a silent override)
The progress-critic's GF STUCK fires on the mechanical rule "deferral phrase repeated K iters." Its own
must-fix #1 is "close @754 this iter" — which is **exactly** this iter's GF objective, so I am NOT
ignoring it. I rebut only the STUCK→*pivot-the-route* implication, on these signals:
- **The deferral was budget, not attempt-failure.** In iters 018/019/020 the prover never *attempted and
  failed* @754 — it deferred it each time to spend budget on the genuinely-hard adjacent crux
  (injectivity), then documented a pre-scouted collapsing lemma. That is the opposite of churning a wall.
- **The route is converging on hard evidence:** L5 closed (017), the 5-iter injectivity crux closed
  axiom-clean (019), dévissage 2/3 obligations closed (020). Each iter eliminated a real blocker.
- **iter-021 is the FIRST genuine attempt** with a concrete collapsing tool
  (`IsIntegral.exists_multiple_integral_of_isLocalization`, which replaces the manual
  `gf_clear_one_denominator` Finset-fold in ONE call) + the soundness-checked `g0→g0·g1` witness.
- **Soundness pre-check done** (the prover's iter-020 analysis): the `g0`-only finiteness is
  generically FALSE-typed; the `g0·g1` witness is the correct, true statement. So budget is not being
  poured into a false target.
Corrective concretely taken THIS iter (beyond "another prove round"): the enabling structural refactor
(file-split) + a rich Lean-level recipe pinned in `analogies/gf-generic-rank-ses.md` (§"L4 finiteness
leaf … iter-021 close recipe"). If iter-021's prove pass does NOT close @754, the iter-022 corrective is
an **effort-breaker** on @754 (witness-refine / per-generator clearing / finite_adjoin assembly) — not a
reworded re-dispatch.

### File-split now (standing user directive)
Deferred 3+ iters with rationale "splitting mid-assembly risks churn." The keystone landed iter-020 →
that rationale is void. Splitting now honors the persistent user directive, clears M1 (QUOT toolkit),
removes the stale-comment major, and sets up parallel SNAP-S1 / QUOT-defs P2 lanes for iter-022. Chose a
2-file split (graded layer vs Quot-defs layer) with a `% archon:covers` consolidation (no new chapter).
Import-independent from the GF/FBC proves, so any QUOT instability cannot block the frontier lanes.

## FBC dead-code: deferred (not removed this iter)
The critic suggested "remove the dead `fstar_reindex` sorry first." I deferred it: FBC has a prover lane
this iter (gstar_transpose), so a same-file refactor would conflict, and folding structural deletion into
the deep categorical prove risks it. The dead `fstar_reindex_legs`/`_fstar_reindex` (+5 superseded
blueprint blocks) are harmless (orphaned, referenced only in comments). Removal is queued for an
FBC-no-prover slot (iter-022), Lean + blueprint together.

## Subagent skips

- strategy-critic: SKIP. The strategy ROUTES and decomposition are UNCHANGED this iter — no route swap,
  no fork, no new phase. Edits to STRATEGY.md were status-cell refreshes only (FBC post-swap baseline,
  GF-alg iters-left 2→1, SNAP S2-DONE marker) — exactly the bounded-accumulation updates the rules
  permit without a strategy change. The last strategy-critic (iter-016) governed the still-current
  decomposition; nothing it would re-examine has moved. Re-running it on unchanged routes is the hollow
  dispatch the skip affordance exists to avoid.
- blueprint-clean: SKIP. No chapter under active prover work was edited this iter (GF/FBC chapters
  untouched). The only blueprint edits were 2 trivial-helper coverage blocks + a covers-line in the QUOT
  chapter, which feeds NO prover this iter; the blocks are pure math (no Lean leakage). blueprint-reviewer
  `iter021` confirmed they are well-formed.

## What shaped iter-022 (live frontiers)

1. **GF** — if @754 + cascade close: GF-alg is DONE; open GF-geo `genericFlatness` @1898 (blueprint
   section for the finite-affine-cover assembly owed first) + de-private the 11 GF Nagata helpers (M1
   remainder) in the no-prover slot. If @754 still open: effort-break it.
2. **FBC** — if `gstar_transpose` closes: affine reduction @1698 → FBC-B @1720, + the dead-code-removal
   refactor (Lean + the 5 superseded blueprint blocks) in the no-prover slot.
3. **QUOT** — file-split done → open QUOT-defs P2 (rank-r local-freeness re-sign of the 4 stubs) and
   SNAP-S1 `def:sectionGradedRing` lanes in parallel with GF/FBC.

## Anomalies / debt

- **11 GF `private` Nagata helpers** carry public `\lean{}` pins → sync_leanok can't resolve them
  (recurring M1, flagged 018–021). Owed: a de-private refactor in a GF-no-prover iter.
- Both routes OVER_BUDGET administratively — estimates refreshed in STRATEGY this iter.
