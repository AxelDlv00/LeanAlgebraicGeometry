# iter-049 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (`CechHigherDirectImage.lean:679`
  protected P5b main theorem; `CechAcyclic.lean:110` dead `affine`). New file `AffineSerreVanishing.lean`
  is 0-sorry.
- **Build:** GREEN. Review re-verified first-hand: `lean_verify` on
  `affine_serre_vanishing_of_tildeVanishing` AND `affine_cech_vanishing_qcoh_of_tildeVanishing` =
  `{propext, Classical.choice, Quot.sound}` (the `local instance` warning is the intentional
  `hasExtModules` reactivation, not a soundness flag). Full `lake build` 8332 jobs exit 0.
- **Lanes planned 2, ran 1.** Lane 1 (`AffineSerreVanishing.lean`) PARTIAL: **+4 axiom-clean decls,
  0 new sorries.** Lane 2 (`cechAugmented_exact`, `CechHigherDirectImage.lean`) was dispatched but
  produced **no prover output** (single prover log on disk).
- **dag-query:** gaps = 0, unmatched = 5 (1 pre-existing dead + 4 new this iter). `sync_leanok` ran
  iter-049 (sha `6acf2d5`, +0/−2). blueprint-doctor: no structural findings.

## Headline — the full Lane-1 (02KG) assembly typechecks end-to-end, reduced to ONE residual
The prover built the entire Serre-vanishing-on-affines assembly **conditional on a single explicit
hypothesis** `htilde`, and closed the first sub-leaf of that residual. Both blueprint targets
(`affine_cech_vanishing_qcoh` seed, `affine_serre_vanishing` top) now bottom out at exactly the same
crisp obligation: positive-degree section Čech vanishing of the tilde sheaf `~M` over a standard cover
of a **proper** distinguished open `D(f)`. The two reduction lemmas (`_of_tildeVanishing` forms) plus the
reusable coefficient-iso transport (`cechCohomology_isZero_of_iso`) and the `R_f` spanning leaf
(`affine_cover_span_localizationAway`) are all axiom-clean. This is honest partial progress — no `sorry`;
the gap is a named hypothesis argument, confirmed by lean-auditor to be genuinely non-vacuous.

## This iter's analysis
- **No forced mathematics, no papering.** The `mathlib-build` no-sorry invariant held; the residual is
  threaded as an explicit `htilde` argument, not a hidden hole. lean-auditor `iter049` confirmed `htilde`
  is non-vacuous (the reductions are not vacuously true) and that no kernel-soundness trap was used.
- **The decisive finding (now in the Knowledge Base):** the 02KG seed is NOT the one-step "transport along
  `F ≅ ~M`" the blueprint sketch implies. The standard cover is of a **proper** `D(f)`, so
  `sectionCech_affine_vanishing` (which needs `span = ⊤`, a cover of all `Spec R`) does not apply directly;
  the missing step is **change of base to `R_f = Localization.Away f`**, exactly the Stacks 02KG "Write
  `U = Spec(A)`" move. The prover's reduction makes this gap a single visible leaf, and closed its first
  sub-piece (`affine_cover_span_localizationAway`, the `R_f` spanning condition).
- **Soundness independently confirmed three ways:** (1) review's first-hand `lean_verify` (kernel verdict);
  (2) lean-auditor `iter049` (0 must-fix/0 major); (3) lean-vs-blueprint `iter049-asv` confirmed the Lean is
  faithful scaffolding (no placeholders).
- **A real blueprint gap surfaced (planner domain, no soundness impact):** the
  `lem:affine_cech_vanishing_qcoh` proof sketch is incomplete — it omits the `R_f` change-of-base the Lean
  `htilde` makes explicit, and never mentions `affine_cover_span_localizationAway`. The two blueprint-named
  targets' `\lean{}` pins are aspirational (point at decls that do not yet exist). Flagged for the planner;
  I added `% NOTE` annotations on both blocks.
- **Process gap:** the planner dispatched 2 lanes but only 1 prover ran. Lane 2 (P5a `cechAugmented_exact`,
  independent of 02KG) produced no output — re-dispatch next iter and investigate the single-prover launch.

## Markers / coverage
- **Manual marker edits (2 `% NOTE`):** `lem:affine_serre_vanishing` and `lem:affine_cech_vanishing_qcoh`
  in `Cohomology_CechHigherDirectImage.tex` — record the reduced `_of_tildeVanishing` forms, the aspirational
  pins, and (on the seed) the proof-sketch must-fix. No `\leanok` touched; no `\lean{}` rename (the pins are
  correct target names, not renames). No `\mathlibok` (project theorems).
- **Coverage debt = 5 unmatched** (1 pre-existing dead `CechAcyclic.affine` + 4 new public decls). The 4
  new decls are listed in `recommendations.md` with their Lean dependencies for the planner to blueprint.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor `iter049`,
  lean-vs-blueprint-checker `iter049-asv`.)
