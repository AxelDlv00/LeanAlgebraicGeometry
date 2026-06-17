# Iter-049 plan — 01I8 CLOSED (iter-048); FAN-OUT to 02KG (critical) + P5a augmented resolution

## Entering state (verified)
iter-048's one `mathlib-build` lane SOLVED the objective: `isIso_fromTildeΓ_of_quasicoherent` landed
axiom-clean (`#print axioms` = {propext, Classical.choice, Quot.sound}), registered as an `instance` ⟹
**`qcoh_iso_tilde_sections` is now UNCONDITIONAL for quasi-coherent `F`.** This is the terminal milestone of
the Route-B / 01I8 section-localization program (iters 040→048, ~14 iters, the single hardest sub-route).
+1 private helper `isIso_fromTildeΓ_app_basicOpen`. `QcohTildeSections.lean` 0-sorry. Project inline-sorry = 2
(both frozen/superseded: `CechHigherDirectImage.lean:679` protected P5b, `CechAcyclic.lean:110` dead `affine`).
lean-auditor `iter048` + lean-vs-blueprint `iter048-qts`: 0 must-fix. Build GREEN.

## What I did this phase
1. Processed iter-048 lane → task_done (+2 axiom-clean, 01I8 CLOSED); cleared the prover result file;
   refreshed task_pending header + PROGRESS to iter-049.
2. **Verified the post-01I8 frontier.** leandag ready frontier = {`affine_cech_vanishing_qcoh`,
   `cech_augmented_resolution`, `cech_free_eval_prepend_homotopy`, `tilde_restrict_basicOpen`}. Triaged:
   - `affine_cech_vanishing_qcoh` (`AffineSerreVanishing.lean`) — 02KG seed, decl does NOT exist (file header
     hands it + `affine_serre_vanishing` off). CRITICAL PATH. → Lane 1.
   - `cech_augmented_resolution` (`cechAugmented_exact`, `CechHigherDirectImage.lean`) — P5a, decl does NOT
     exist anywhere, INDEPENDENT of 02KG (only needs `qcoh_iso_tilde_sections`). → Lane 2.
   - `cech_free_eval_prepend_homotopy` — has **NO `\lean{}` pin by design** (blueprint says "not a separate
     Lean declaration"); it is a math-only node in the DONE `FreePresheafComplex.lean`. NOT a lane. DROPPED.
   - `tilde_restrict_basicOpen` — DORMANT Route-P (PROGRESS off-limits). DROPPED.
3. **Blueprint HARD GATE (blueprint-reviewer `iter049`, whole-blueprint, MANDATORY):** CLEARS for all three
   build targets (`affine_cech_vanishing_qcoh`, `affine_serre_vanishing`, `cech_augmented_resolution`),
   0 must-fix. Two "soon" items: (a) `cech_augmented_resolution` proof sketch had an unnamed "refinement to
   standard cover" step — reviewer recommended aligning with the Stacks stalk-at-prime quote; (b) 2 cosmetic
   `\uses`/`\lean` items on `lem:qcoh_isIso_fromTildeGamma` (review-domain, deferred).
4. **Acted on "soon" (a) BEFORE dispatch** (writer-before-prover discipline): blueprint-writer `cechaug`
   rewrote the `lem:cech_augmented_resolution` proof to the stalk-at-prime / "one `f_i` is a unit"
   contracting-homotopy argument (consistent with the in-block Stacks quote; added a verbatim
   `% SOURCE QUOTE PROOF:` from `references/stacks-coherent.tex`); blueprint-clean `cechaug` purified it
   (stripped Lean-name leakage + project-history phrasing; SOURCE QUOTE verified vs source). leandag: no broken
   edges. Lane 2's source-of-truth is now clean.
5. Updated STRATEGY: moved 01I8 row → `## Completed`; 02KG row → ACTIVE (ungated iter-049); P5a row notes
   `cechAugmented_exact` is independent + dispatched; refreshed the 01I8 Mathlib-gap bullet to DONE.
6. Wrote PROGRESS `## Current Objectives` with the two `mathlib-build` lanes (both carry the `_SCAFFOLD_RE`
   token on the `.lean`-path line: Lane 1 `declarations for`/`does not yet exist`, Lane 2 `does not yet exist`).

## Decisions made

### D1 — TWO lanes this iter (Lane 1 critical, Lane 2 independent P5a). Not one, not three.
The 01I8 close opened the cone. There are exactly TWO genuinely-ready, independent build targets:
- **Lane 1 (firm, critical path): `AffineSerreVanishing.lean`** — `affine_cech_vanishing_qcoh` + `affine_serre_vanishing`. Same file ⟹ one prover, sequential (seed→top). The cover-system fields are all pre-built; the only new input is the now-unconditional `qcoh_iso_tilde_sections`. Low risk, high value (everything downstream — P5a Ext-bridges, P5b — gates on `affine_serre_vanishing`).
- **Lane 2 (parallel, P5a infra): `CechHigherDirectImage.lean`** — `cechAugmented_exact`. INDEPENDENT of 02KG (its `\uses` = cech_nerve + cech_acyclic_affine + qcoh_iso_tilde_sections, all done). Deep (effort ~1054): likely needs the augmented-complex object constructed + a sheaf-complex-exact-on-stalks criterion. mathlib-build mode is chosen precisely so a partial result hands off a precise decomposition rather than papering — productive parallelism either way.
**Why not a 3rd lane:** the other two frontier nodes are non-lanes (`cech_free_eval_prepend_homotopy` has no Lean pin; `tilde_restrict_basicOpen` is dormant Route-P). The P5a Ext-bridges all consume `affine_serre_vanishing`, which won't exist until Lane 1 lands — dispatching them now would be dishonest frontier work. So two lanes is the honest maximum.
**Reversal signal:** if Lane 2 churns (no augmented-complex object materializes, the stalkwise-exactness criterion proves to need large new Mathlib infra), pull it next iter and serialize it AFTER `affine_serre_vanishing` lands (the P5b interface is clearer then), keeping only the critical 02KG→P5a-Ext spine.

### D2 — Lane 2 lives in `CechHigherDirectImage.lean` (the protected P5b file), NOT a new file.
`cechAugmented_exact` is exactness of the augmented Čech nerve `coverCechNerveOverAug`/`CechNerve` — all of
which already live in `CechHigherDirectImage.lean` (P2). A new file would duplicate imports for no isolation
benefit (the infra it builds on is in-file). The protected surface is the single signature
`cech_computes_higherDirectImage`; the directive explicitly forbids touching it or the line-679 sorry, and
mathlib-build adds only its own (sorry-free) decls. This is forward progress toward the P5b unblock, NOT the
blocked P5b assembly itself.

## Subagent skips
- progress-critic: the only active route (01I8 / Route B) just COMPLETED in the prior iter (sorry-of-the-route
  → 0, route closed iter-048); the two new lanes (02KG, P5a) are fresh build objectives with no prover
  trajectory to assess. Dispatcher skip condition "the only active route just completed in the prior iter" is
  met. No churning/stuck route exists.
- strategy-critic: STRATEGY.md edits this iter are phase-completion bookkeeping (move the DONE 01I8 row to
  `## Completed`; activate the already-planned, previously-validated 02KG/P5a/P5b rows) + estimate refresh —
  NOT a route swap, decomposition change, or new fork. Route A and its 02KG→P5a→P5b decomposition were
  validated in earlier strategy-critic passes and are unchanged. Will dispatch at the genuine next strategic
  fork: the P5b assembly design (EnoughInjectives connector + Route-A final assembly). [Not a clean SHA-skip
  since the file changed; recorded rationale per the autonomy + "no hollow dispatch" guidance.]

## Tool substitutions
- none.

## Notes for next iter
- If `affine_serre_vanishing` lands → P5a Ext-bridges (`Hⁿ(f⁻¹V,G)` + open-immersion/affine vanishing) unblock
  (they consume it). If Lane 2 handed off a decomposition → set the next augmented-resolution sub-step.
- Blueprint soon-cleanups (review-domain, non-blocking): the 2 cosmetic `\uses`/`\lean` items on
  `lem:qcoh_isIso_fromTildeGamma`; re-route/delete dormant `lem:qcoh_localized_sections`; refresh
  `rem:o1i8_decomposition`.
