# Iter 029 — Review (Quot-Foundations)

## Verdict
Build GREEN — both prover-edited modules `lake build` exit 0 (expected `sorry` + linter warnings only).
The 1 new declaration `lean_verify` = `{propext, Classical.choice, Quot.sound}`. blueprint-doctor: **0
findings**. `sync_leanok` ran on the current tree (iter 29, sha 989fb48; +9 `\leanok`, 0 removed; chapters
= Picard_GrassmannianCells, Picard_QuotScheme). dag `gaps=0`, `unmatched=1` (the one new QUOT helper).

**Low-yield iter: net 0 active sorry (FBC 4→4, QUOT 4→4), +1 axiom-clean declaration.** Of the 3 dispatched
lanes, FBC produced a *diagnostic + cleanup* round (no sorry closed), QUOT added 1 helper (no sorry closed),
and **GR landed nothing** (no edits, no task_result). The iter's genuine value is two-fold: (1) FBC's `_legs`
crux now has a **conclusive negative result** that rules out the entire keyed-rewriting tactic family — every
future FBC dispatch must use a whole-term `exact`/`convert` assembly, not `rw`/`simp`/`erw`/`conv`; (2) the
two iter-028 lean-auditor must-fix docstrings were fixed and the 3 atoms de-privatized (pins now resolve).

## Overall progress this iter (active `sorry` per file)
- **FBC 4 → 4 (no sorry closed; definitive diagnosis + riders).** `base_change_mate_fstar_reindex_legs`
  (@1446) **conclusively walled** for all keyed rewriting: `rw [e2]` of a `rfl`-true literal copy of the
  goal's own factor STILL fails (`kabstract` cannot see through the `X.Modules` category/comp instance
  diamond); `rw [Category.comp_id]` cannot even find `?f ≫ 𝟙`. Established the full defeq map (factor-2 /
  G3 = `rfl`-trivial; G1/G2/G4 = genuine isos). Route pinned: one hand-built ~100–150 LOC proof term,
  splice clean terms via `congrArg`/`.trans`, close with ONE `exact`. Riders (all compile): removed dead
  `hpfc`; de-privatized 3 atoms; fixed 2 false "sorry-free" docstrings → "transitively sorry-backed".
  `gstar_transpose` (@1818) untouched (gated on `_legs`). affine (@1999) / FBC-B (@2021) untouched.
- **QUOT 4 → 4 (+1 axiom-clean).** `exists_finite_basicOpen_cover_le_quasicoherentData` (@730) — the
  topological finite-cover front of `lem:exists_isIso_fromTildeΓ_basicOpen_cover`. gap1
  (`isIso_fromTildeΓ_of_isQuasicoherent`) NOT added — blocked on the per-element presentation **transport**
  (`(M.over (q.X i)).Presentation → M|_{D(r)}` presentation); no Mathlib `over`↔pullback /
  restriction-to-`Spec R_r` bridge, and stating `q.presentation i` times out synthInstance. A genuine
  multi-iter sub-build; three routes (cover-transport / stalk / section-MV) all funnel through it.
- **GR 0 → 0 (no output).** `mathlib-build` cocycle/glued-scheme lane produced no edits this iter.
- **GF 1 (untouched).** Gated on gap1.

## Critic / auditor dispositions
- **lean-auditor `iter029`** (FBC+QUOT) — **CLEAN**, 0 critical/major, 1 minor (editorial "definitive"
  in the FBC diagnosis box). Confirmed docstring fixes honest, new QUOT helper genuine.
- **lean-vs-blueprint-checker `fbc`** — **PASS**, 0 must-fix; 1 major (stale `% NOTE:` @1541–1546 claiming
  the 3 atoms still `private`/mangled). **Resolved this iter** — I removed the NOTE. 45/45 pins resolve.
- **lean-vs-blueprint-checker `quot`** — faithful, 0 must-fix; 2 major (coverage debt for the new helper;
  `lem:exists_isIso_fromTildeΓ_basicOpen_cover` pin points at a non-existent stronger decl) + 2 minor (2
  private decls pinned public; `def:modules_annihilator` `\uses` overstated). All routed to recommendations.

## What shaped iter-030 (live frontiers)
1. **FBC: assign the `_legs` assembly proof term — NOT another rewriting recipe.** The keyed-rewriting
   family is conclusively dead (proven this iter). If the term-mode assembly *itself* fails to fire (vs
   budget exhaustion), escalate to an effort-breaker per-atom split. This is the standing CHURNING tripwire.
2. **QUOT: build the modules restriction-to-basic-open transport BEFORE re-touching gap1.** Recommend a
   mathlib-analogist consult on whether any Mathlib over↔pullback bridge exists, then an effort-breaker
   to split the transport.
3. **Coverage: 1 unmatched node** (`exists_finite_basicOpen_cover_le_quasicoherentData`) + the broken
   `lem:exists_isIso_fromTildeΓ_basicOpen_cover` pin both need a blueprint-writer round on
   Picard_QuotScheme.tex.
4. **GR produced no output** — confirm `def:gr_glued_scheme` is prover-ready before re-dispatching the lane.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor + per-file
  lean-vs-blueprint-checker on the two prover-touched files.)
