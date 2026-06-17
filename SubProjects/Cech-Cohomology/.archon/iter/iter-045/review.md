# iter-045 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (dead `CechAcyclic.affine`,
  frozen P5b `CechHigherDirectImage`). Prover file `QcohTildeSections.lean` is 0-sorry.
- **Build:** GREEN. `lake env lean … QcohTildeSections.lean` exit 0 (only pre-existing `Sheaf.val`
  deprecation warnings); all 5 new decls `#print axioms` = `{propext, Classical.choice, Quot.sound}`
  (prover `lean_verify`, consistent with lean-auditor's fresh audit).
- **Lanes planned 1, ran 1** (`mathlib-build`). **+5 axiom-clean decls, 0 new sorries.** Named target
  `tile_section_localization` BLOCKED (left absent, not papered).
- **dag-query:** gaps = 0, unmatched = 6 (1 pre-existing dead + 5 new this iter). `sync_leanok` ran
  iter-045 (sha `ce13455`, +14/−0). **blueprint-doctor:** no structural findings.

## Headline — math complete, blocked on Lean engineering (W1–W3); a false `\leanok` on the keystone leaf caught + removed
The planner dispatched the final keystone leaf `tile_section_localization`. The prover landed every
remaining ingredient (notably the `V=D(f̄)` scalar-tower compat `tile_scalar_compat'` — the planner's
flagged NEW sub-need) axiom-clean, and confirmed the load-bearing map identity is `rfl`. But the full
assembly does not compile, blocked on three compounding **Lean-engineering** walls (NOT mathematics):
W1 (`Spec`-dependent `letI`/`have` hoists to a noncomputable aux def, codegen fails), W2 (`IsScalarTower
R R_g` won't elaborate — `SMul R` unsynthesised), W3 (`isDefEq` timeout at 4M heartbeats). The prover
made two concrete attempts, reproduced W1/W2 verbatim, and correctly left the target absent with a
precise in-file decomposition rather than papering a sorry. The keystone route has landed axiom-clean
decls every prover iter (040:+4, 041:+3, 042:+1, 043:+2, 044:+5, 045:+5).

## This iter's analysis
- **No forced mathematics; clean stop.** The `mathlib-build` no-sorry invariant held. 5 helpers closed;
  the named target was scouted, its blocker kernel-confirmed, and left absent (the honest stopping point).
- **The decisive correctness finding (most important of the iter):** the blueprint block
  `lem:tile_section_localization` carried `\leanok` on both statement and proof despite the Lean decl
  being **absent** (only a commented-out sketch exists). `sync_leanok` (removed=0) did not clear it — the
  commented-out `lemma tile_section_localization` text fooled the analyzer. This false marker poisons the
  DAG: the keystone leaf and its entire downstream cone (kernel comparison → keystone → Route B → 02KG
  tops → P5a → P5b) would read as proved. **Review removed both false `\leanok`** (authorized override,
  certain via three independent confirmations) and added `% NOTE`s. The root-cause fix (mangle the
  commented sketch so it doesn't re-fool sync) is flagged HIGH-2 for the planner — the override is fragile
  until the source is changed.
- **The obstruction shape changed from math to engineering.** Through iter-044 the friction was genuine
  mathematics (section-comparison non-definitionality → reduced to a ring identity). iter-045's blocker is
  pure Lean plumbing (noncomputable-instance hoisting, TC synthesis, defeq performance). This shifts the
  right corrective from blueprint expansion to a mathlib-analogist / design-shape reconsideration (HIGH-1).
- **Soundness independently confirmed.** lean-auditor `iter045`: all 5 decls axiom-clean; the `congr 1` /
  `convert … using 2` closures are genuine thin-cat subsingleton equalities, NOT the spurious-rfl trap;
  `maxHeartbeats 1000000` justified. Review's marker actions rest on the checker + auditor + first-hand
  grep of the comment block.

## Markers / coverage
- **Manual marker edits (this iter):**
  - `lem:tile_section_localization` — **removed `\leanok`** (statement + proof) + `% NOTE` on each
    (decl absent; sync fooled by commented sketch). Authorized override; certain.
  - `lem:tile_section_localization` Step-4 prose — `% NOTE` recording that the `V=D(f̄)` analogue is now
    formalized as `tile_scalar_compat'` (the prose still says "required").
- **No `\leanok` added** (sync owns additions). **No `\mathlibok`** (project theorems). **No `\lean{}`
  rename** (the 5 new decls need NEW blocks — coverage debt).
- **Coverage debt = 6 unmatched** (1 pre-existing dead + 5 new). The 5 new are cleared by the
  recommendations MED-1 blueprint-writer item.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor `iter045`,
  lean-vs-blueprint-checker `qts`. See `recommendations.md` for findings.)
