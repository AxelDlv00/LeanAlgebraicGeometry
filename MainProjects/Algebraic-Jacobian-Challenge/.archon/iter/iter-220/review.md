# Iter-220 (Archon canonical) — review

## Outcome at a glance

- **The "sub-step 2 lands; presheaf internal hom ASSEMBLED" iter.** The funded Decision-1 sheaf
  internal-hom build (committed iter-219, ~6–12 iters, elapsed 2) hit its explicitly-stated iter-220
  success bar: `PresheafOfModules.InternalHom.internalHom` is **BUILT axiom-clean** via
  `PresheafOfModules.ofPresheaf`. **12 new declarations**, all `{propext, Classical.choice,
  Quot.sound}` (re-verified first-hand on `internalHom`; L1633 "opaque" = known docstring false
  positive).
- **Sorry trajectory:** iter-219 **80** → iter-220 **80** (net **0**). File code sorries **3 → 3**
  (L632, L1733, L1777 untouched). Expected for a mathlib-build iter: it adds the missing ingredient,
  it does not close a critical-path residual. `sync_leanok` ran (iter-220, sha `11c427a0`, **+3/−0**,
  `Picard_TensorObjSubstrate.tex` only — the value + slice-value + restriction blocks).
- **Build GREEN; blueprint-doctor clean** (no orphans, all `\ref`/`\uses` resolve, no `axiom` decls).
- **HARD-BAR landing:** assigned PRIMARY (build the restriction maps + ASSEMBLE `internalHom`,
  axiom-clean) is **MET**. PRIMARY GOAL (A.2.c via the group law) not reached; path concrete and
  ungated (dual → eval → sheafify → inverse → group law → RPF).

## What actually landed (the math)

iter-219 built the per-object value module (`homModule`/`internalHomObjModule`). iter-220 built the
**restriction maps** and **assembled the presheaf internal hom**. Two genuinely hard pieces, both
axiom-clean:

1. **Functoriality of `restrictionMap` (the `Over.map` pseudofunctor coherence).** `Over.mapId_eq`/
   `Over.mapComp_eq` are propositional, not defeq, so `map_id`/`map_comp` are not `rfl`. After ~6
   failed attempts (dependent-motive `rw`, `eqToHom ▸ rfl`, non-existent `naturality_apply`), cracked
   by a private helper `hom_app_heq φ (h : X = Y) : HEq (φ.app X) (φ.app Y)` (`subst h; rfl`) +
   `eq_of_heq`. Reusable for any `pushforward₀ (Over.map -)` functoriality.
2. **`restrictionMap_globalSMul` (semilinearity core).** Scalar equality across the two slice bases,
   load-bearing step the `Over.w` triangle `(mkIdTerminal.from (Over.map g).obj Y).left =
   (mkIdTerminal.from Y).left ≫ g`; reduces via `erw [← CommRingCat.comp_apply, ← R.map_comp]`.

Assembly gotchas banked: `ofPresheaf` forces a single-universe base (`internalHom` stated over
`{D : Type u}[Category.{u,u} D]` = the `Opens X` site); explicit `@ofPresheaf` to bypass the
CommRingCat/RingCat carrier diamond (`letI` kernel-rejected); `AddCommGrpCat.of`/`.ofHom` + `hom_ext`+
`AddMonoidHom.ext` for the `Ab`-presheaf functoriality.

## Review subagents

- **lean-auditor ts220** (`logs/iter-220/lean-auditor-ts220-report.md`): 0 must-fix. 12-decl block
  axiom-clean, sorry-free. 3 major (stale L37–45 status block; stale L1122 docstring; missing
  `@[implicit_reducible]` on `internalHomObjModule` L1117) + 4 minor (3 `erw` fragility, 14×
  deprecated `Sheaf.val`). → recommendations HIGH.
- **lean-vs-blueprint-checker ts220** (`logs/iter-220/lean-vs-blueprint-checker-ts220-report.md`):
  4/4 pinned decls faithful (signatures + proof strategy match, no fake/weakened statements). 1
  must-fix = the `\lean{}` name mismatch on `def:presheaf_internal_hom` — **RESOLVED THIS ITER** by my
  marker correction. 2 minor blueprint-adequacy items for the next sub-steps. No mathematical
  divergence.

## Process correctness

- The planner continued the funded build (no new strategy fork; STRATEGY.md unchanged) and rebutted
  the progress-critic's CHURNING-by-rule on the grounds that the lane is tracked by sub-step
  retirement vs the ~6–12 iter estimate, not sorry trajectory — and that the helpers ARE the target
  construction. iter-220's outcome vindicates that: the named sub-step retired on its success bar,
  axiom-clean, with both review subagents judging the work genuine.
- Honest non-closure: the prover did NOT push a forbidden dual-shaped helper-sorry (the iter-214 d.1
  anti-pattern it was warned against); it stopped at the natural sub-step-2 boundary and delivered a
  precise sub-step 3–5 decomposition.

## Risk to name for iter-221

The build is still multi-iter (sub-steps 3–5 remain: dual alias, evaluation, sheafification, then the
inverse). Two cheap items should be cleared BEFORE the next prover round (HARD GATE + instance
hygiene): split `lem:internal_hom_isSheaf` into sheaf-condition + dual-object pins (blueprint-writer),
and add `@[implicit_reducible]` to `internalHomObjModule` + refresh the two stale docstrings. See
`proof-journal/sessions/session_220/recommendations.md`.

## Subagent skips

- (none — both highly-recommended review subagents dispatched: lean-auditor, lean-vs-blueprint-checker.)
