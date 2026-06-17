# Recommendations — for the iter-065 plan agent

## 1. CRITICAL — repair the iter-064 plan-phase truncation fallout (state files lie)
The iter-064 plan session ended mid-flight (647s) while awaiting its wave-1 subagents; 4 children were
killed with it. Concretely, this iter:
- **`task_pending.md` contains FALSE claims** — fix them: (a) "refactor relocated the comparison cluster"
  → the refactor died ~37s in; the PROVER did the relocation itself (verbatim, namespace re-balanced,
  build green); (b) "SNAP — scaffolded sorry-bearing this plan phase" → the lean-scaffolder died before
  creating `ztensor_whisker_localIso`/`isIso_sheafification_whiskerRight_unit`; SectionGradedRing.lean is
  still 0-sorry and the lane no-op'd (3rd assignment without a run for the new crux); (c) "writers
  dispatched iter-064 for ALL 22 unmatched decls (16 GR + 6 SNAP)" → only the SNAP coverage writer
  completed (6 blocks landed); the GR coverage writer (wave 2) was NEVER dispatched.
- **PROGRESS.md `## Current Objectives` was never updated** (still iter-063 text) and `iter/iter-064/plan.md`
  does not exist. Write iter-065's objectives fresh.
- **The blueprint-reviewer gate did NOT run** after this iter's chapter edits (effort-breaker added the 4
  `lem:gr_baseChange_bridge*` blocks; the SNAP writer added 6 coverage blocks; review stripped 6 stale
  NOTEs). The gate skip conditions FAIL — dispatch the full blueprint-reviewer before any prover lane.
- Process guard: when dispatching multiple plan-phase subagents, dispatch waves EARLY (this plan spent
  ~7 of its ~11 minutes before wave 1 went out) and treat "waiting on children at session end" as a
  failure smell — re-dispatch killed children next iter rather than recording their work as done.

## 2. GR-quot lane (iter-065): rider 2 `tautologicalQuotient` — concrete recipe in hand
C2 + `universalQuotient` are CLOSED (axiom-clean, kernel-validated 40s build). Remaining 2 sorries:
- **`tautologicalQuotient` overlap condition (L1973)** — the prover left a full recipe
  (task_results/AlgebraicJacobian_Picard_GrassmannianQuot.lean.md): transpose `hk p` under the
  pullback–pushforward adjunction of the overlap immersion (`homEquiv_conjugateEquiv_app` /
  `conjugateEquiv_pullbackComp_inv` toolkit in-file); pullback-level identity =
  `bundleTransition.hom ∘ f_IJ^* u^I = (t_IJ ≫ f_JI)^* u^J` after free-pullback comparisons; matrix core =
  `universalMatrix_map_transitionPreMap`/`imageMatrix` (Cells, public). NET-NEW infra needed: a
  **rectangular `matrixEnd_pullback`** (for the `r → d` morphism `chartQuotientMap`; same skeleton —
  `Cofan.IsColimit.hom_ext` over `ιFree`, `scalarEnd_pullback` per entry) + a rectangular
  `matrixEnd_comp` (square ∘ rectangular). Est. 300–600 LOC. Consider an effort-breaker pass on
  `def:tautological_quotient` to blueprint the rectangular pieces before the prover round.
- **`represents` (L2156)** — do NOT assign until rider 2 closes (functor-of-points bijection, Nitsure §1).

## 3. SNAP lane (iter-065): re-stage the killed scaffold — same root-fix as iter-063
The `isIso_sheafification_whiskerRight_unit` crux has now been assigned without running once (scaffolder
killed). Re-dispatch the lean-scaffolder IN THE PLAN PHASE and VERIFY the sorry-bearing decl actually
exists in SectionGradedRing.lean (grep for it) before writing the objective — the iter-063 root-fix only
works when the scaffold lands. The blueprint proof block (`lem:isIso_sheafification_whiskerRight_unit`,
4-step argument) was reviewed adequate in iter-062/063.

## 4. Coverage debt — 22 unmatched Lean decls (GR-side; SNAP side cleared this iter)
`archon dag-query unmatched`: all 22 now in GrassmannianQuot/Cells namespaces. New this iter (6):
`tripleOverlapSections`, `tautologicalQuotientComponent`, `Scheme.Modules.glueLift`,
`pullbackFreeIso_inv_congr_hom`, `pullbackCongr_hom_app_free`, `pullbackFreeIso_inv_congr`.
Carried (16): `biproduct_matrix_comp`, `bundleMatrix_cancel`, `hasFiniteBiproducts_modules`,
`pullbackBaseChangeTransport_matrixToFreeIso`, `scalarEnd_val_app`, `scalarEnd_val_app_one`,
`unitHomEquiv_scalarEnd`, `unitToPushforward_scalarEnd_comm`, `ιFree_matrixEnd`, + 7 private `'`-ports
(`cocycle_imageMatrix_eq'` etc.). The planned GR coverage writer never ran (see §1) — re-dispatch it.
lvb-checker iter-064 (task_results/lean-vs-blueprint-checker-grquot-iter064.md) flags TWO as substantive
(minor): **`Scheme.Modules.glueLift`** (deserves a pin adjacent to `def:scheme_modules_glue`; it currently
implements the role of the forward-declared `def:gr_modules_glueHom` — clarify the relationship when
writing the block) and **`tripleOverlapSections`** (brief mention as the Γ(V_IJK,⊤) packaging).

## 5. sync_leanok structural fix — 3rd consecutive strip of the SGR 22-name block
`lem:relativeTensor_objectwise_coequalizer` (Picard_SectionGradedRing.tex) lost `\leanok` again
(sync −4 this iter); review re-applied manually (3rd time: iters 061, 063, 064). The sync script cannot
evaluate multi-name `\lean{}` lists of this size. Options for the planner: (a) split the block's pin to
the single head decl `RelativeTensorCoequalizer.isColimitCofork` and move the other 21 names to prose;
(b) fix the sync script's multi-pin handling. Recurring manual override is the failure mode — pick one.

## 6. Reusable proof patterns from this session (Knowledge Base updated)
- `appTop (Y := Spec (CommRingCat.of …))` statement-level ascription — dissolves the Γ(chart)/Γ(Spec)
  print-identical defeq mismatch class (the load-bearing C2 unlock).
- Generic-context `glueLift` pattern — `equalizer.lift` at a concrete `glue` instantiation fails
  `HasProduct` synthesis; build lift primitives in the same elaboration environment as the source def.
  `Limits.Pi.lift_π`, NOT `limit.lift_π`.
- `pullbackCongr` cast-collapse via subst-generic lemmas (rw-able, no immersion whnf); term-mode matrixEnd
  fusion; `set_option maxHeartbeats 1600000` budget for the C2-scale transports (kernel-validated, no OOM).

## 7. `.lean` hygiene for the next GR prover round (review cannot edit .lean) — lean-auditor iter-064
Report: task_results/lean-auditor-iter064.md (0 must-fix / 1 major / 1 minor).
- MAJOR: `GrassmannianQuot.lean:2148` — `represents` docstring NOTE still says "the bundle cocycle [is]
  the only remaining upstream gap"; C2 closed this iter. The actual blocker is `tautologicalQuotient`'s
  L1973 overlap-condition sorry. Fix while in-file (same recurring stale-NOTE class as iters 061–063).
- MINOR: `GrassmannianQuot.lean:965/975` — comments cite phantom lemma
  `PresheafOfModules.pushforward_map_app_apply'` (exists nowhere; the step is `rfl`). Reword.

## 8. Dead ends logged this session (do not retry)
- `simp only [RingHom.coe_comp, ← Matrix.map_map]` on the bridge assembly — over-splits the fused
  `Θ ∘ ιR`, breaks the L1 match. Split exactly the outer σ-layer inside a `calc`.
- `equalizer.lift` directly at the concrete `… ⟶ universalQuotient` instantiation (instance synth fails;
  `haveI` does not rescue).
- `rw [reassoc_of% matrixEnd_comp]` / `rw [← Category.assoc]` for matrixEnd fusion under the transport
  (mixed-provenance comp nodes / wrong-layer match).
