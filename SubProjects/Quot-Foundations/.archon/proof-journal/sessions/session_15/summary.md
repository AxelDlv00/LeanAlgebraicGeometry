# Session 15 — Review of iter-015

## Metadata

- Iteration: 015 · Session: session_15 · Model: claude-opus-4-8
- Lanes dispatched (3, import-independent): FBC Seam 2 cascade [prove], GF L5 assembly [prove],
  QUOT graded-API G1–G5 [mathlib-build].
- **Build: GREEN.** `lake build` of all three modified modules → EXIT 0 (re-verified first-hand).
- **Active sorry per file (before → after):** FBC 4→4 · GF 4→**5** (+1 new helper) · QUOT 4→4
  (+3 axiom-clean graded-API decls, additive) · GR 0 · RegroupHelper 0. **Total 12 → 13 (+1).**
- **Sorries closed this iter: 0.** New axiom-clean *content* landed (3 QUOT decls + 1 FBC scaffold
  + 1 GF helper signature), but no target sorry was eliminated. Judge by content + the genuine
  Mathlib wall hit on QUOT, not by count.

## Per-lane

### FBC — `Cohomology/FlatBaseChange.lean` (Seam 2 → Seam 3 cascade) — PARTIAL

Target: Seam 2 `base_change_mate_fstar_reindex` (sorry @1197) → Seam 3
`base_change_mate_gstar_transpose` (@1242) → `affineBaseChange_pushforward_iso`.

- **Landed:** the leg-identification scaffold inside Seam 2's body, mirroring
  `base_change_mate_codomain_read`. Introduced `e := pullbackSpecIso R A R'` and derived
  `hfst : pullback.fst = e.hom ≫ Spec.map inclA`, `hsnd : pullback.snd = e.hom ≫ Spec.map inclR'`
  (with `inclA := includeLeftRingHom`, `inclR' := includeRight`), plus the `Γ`-image split via
  `rw [Functor.map_comp ×3]`. File stays clean; **sorry remains**.
- **Wall:** the residual is the `conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` coherence
  over the generic pullback square — the same conjugate-calculus family that closed Seam 1 in
  iter-014, but the **blueprint sketch omits the mechanism** (lvb-fbc must-fix). A raw re-dispatch
  churns; the chapter needs the mechanism spelled out first.
- Seam 3 not reached (gated behind Seam 2 in the cascade). Its sorry transitively pollutes
  `base_change_mate_section_identity`, `_generator_trace`, `pushforward_base_change_mate_cancelBaseChange`.

### GF — `Picard/FlatteningStratification.lean` (L5 IH+descent) — PARTIAL (helper churn)

Target: the L5 `exists_free_localizationAway_polynomial` IH+descent residue.

- **Landed:** a NEW top-level helper `free_localizationAway_of_away_tower` (descent of generic
  freeness across a tower of `Away` localisations: free over `(T_g)_h` ⟹ free over `T_f` for a
  single `f ∈ A`), itself `sorry` with a detailed proof plan (witness `f := g·a` via
  `IsLocalization.surj`). L5 now reduces to an IH+descent step routed through this helper.
- **Wall:** four failed inline assemblies (see milestones) before factoring out the helper — the
  IH application fought a `Module A_g`-action instance mismatch across the reindex, and the
  doubly-localised type `(T_g)_h` **cannot even be stated** for the concrete quotient `N⧸range φ`
  (OreLocalization / `Submodule.Quotient` instance diamond). The escape was to phrase the IH+descent
  output directly in single-localisation form.
- **Net:** +1 helper sorry, 0 closed → **the progress-critic's CHURNING signature** (helpers
  accrete, residual does not shrink). Cold-build heartbeat fragility surfaced here too (see below).

### QUOT — `Picard/QuotScheme.lean` (graded-module API, Stacks 00K1) — PARTIAL (3 decls + hard wall)

Target: graded-module API G1–G5 + D5 to unblock the 4 public skeleton stubs.

- **Landed, axiom-clean** (`#print axioms` = `{propext, Classical.choice, Quot.sound}`, re-verified):
  - `degreewise_finrank_diff` (D5, @670) — clean pass, pin correct (lvb-quot).
  - `homogeneousSubmodule_inf_iSupIndep` (G1(a) independence half, @633, public).
  - `homogeneousSubmodule_iSup_inf_eq` (G1 supremum half, @649, private).
- **Wall (now a Known Blocker):** the bundled G1 `homogeneousSubmodule_isInternal` —
  `DirectSum.IsInternal (fun i => (ℳ i).comap p.subtype)` over the **subtype carrier `↥p`** — trips a
  `(deterministic) timeout at isDefEq/whnf` that survives `maxHeartbeats` bumps to 2M. G2–G4 hit the
  same pathology. The escape: state the two G1 halves in the **ambient `M`** (both then elaborate).
  Memory `graded-quotient-module-isdefeq-pathology.md` records this.
- The 4 public skeleton stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
  `Grassmannian.representable`) are unchanged (downstream-blocked).

## Cross-cutting findings

- **Cold-build vs warm-LSP heartbeat gap.** `FlatteningStratification.lean` elaborates clean under the
  warm LSP but a cold `lake env lean <file>` tripped `timeout at whnf` near `algRB2 := ρ.toAlgebra`
  (~L1146). `lake build <module>` (authoritative) succeeds. Bumping `maxHeartbeats` to 4M did NOT help
  and shifted the failure. Trust `lake build`, not `lake env lean`, for this file.
- **sync_leanok removed 25 `\leanok`, added 1** (sha `48f7838`, iter 15 — matches current tree). Per
  the established pattern (PROJECT_STATUS Known-blocker note from iter-013/014), a mass `\leanok`
  removal that does not contradict `lean_verify` on the green tree is a **sync recalibration artifact**
  (the broken QUOT G1 pin `homogeneousSubmodule_decomposition` + the renamed/split decls account for
  several), NOT laundering or regression. The prover's diffs were near-purely additive
  (FlatteningStratification +1347/−1); no existing proof was touched. Flagged for the planner, not raised
  as CRITICAL.
- **blueprint-doctor: CLEAN** — no orphan chapters, no broken `\ref`/`\uses`, no `axiom` declarations.

## Review subagents dispatched (4; all returned)

- **lean-auditor `iter015`** — 4 must-fix / 5 major / 3 minor. Must-fix = the 4 QUOT public skeleton
  stubs carrying "iter-176 file-skeleton" excuse-comments (openly-disclosed placeholders, pre-existing).
  Notable: dead `RegroupHelper` import in FBC; cross-project `STATUS(iter-234)` numbers in FBC; the GF
  4M heartbeat ceiling confirmed insufficient on cold builds; **minor correctness flag — the GF helper
  proof-plan's `hf0 hf0` would give freeness at `f²` not `f`** (verify when proving). Report:
  `task_results/lean-auditor-iter015.md`.
- **lean-vs-blueprint-checker `fbc`** — 31 decls, all `\lean`-pinned with matching signatures; 4 direct
  sorries. **Must-fix (blueprint adequacy):** Seam 2 and Seam 3 sketches omit the actual cruxes
  (`conjugateEquiv_pullbackComp_inv`+`unit_conjugateEquiv` for Seam 2; `pullback_spec_tilde_iso`/counit
  naturality for Seam 3). Report: `task_results/lean-vs-blueprint-checker-fbc.md`.
- **lean-vs-blueprint-checker `gf`** — 23/24 substantive decls pinned. **Must-fix:** new helper
  `free_localizationAway_of_away_tower` has NO blueprint entry; Step 4 of `lem:gf_polynomial_core`
  cites the wrong lemma for the tower-descent case. Report: `task_results/lean-vs-blueprint-checker-gf.md`.
- **lean-vs-blueprint-checker `quot`** — D5 clean; both G1 sub-lemmas correct. **Broken pin:**
  `\lean{...homogeneousSubmodule_decomposition}` names a non-existent decl (prover split it). I added a
  `% NOTE:` (see below); planner does the blueprint surgery. Report:
  `task_results/lean-vs-blueprint-checker-quot.md`.

## Blueprint markers updated (manual)

- `Picard_QuotScheme.tex`, `lem:graded_homogeneousSubmodule_decomposition`: added `% NOTE:` — the
  pinned `homogeneousSubmodule_decomposition` does not exist; the prover landed the two halves
  separately (`homogeneousSubmodule_inf_iSupIndep` public + `homogeneousSubmodule_iSup_inf_eq` private)
  and could not assemble the bundled `Decomposition` (isDefEq pathology). Directed the planner to split
  the G1 block / retarget the pin. (I did NOT silently retarget to a partial decl — the block claims the
  full internal decomposition, which is not yet landed.)

No `\leanok` touched (sync's domain). No `\mathlibok` candidates this iter (all new decls are
project-proved, not Mathlib re-exports). No stale `\notready` found on a landed block.

## Recommendations

See `recommendations.md`. Headline: GF + QUOT both need a **blueprint-writer round before the next
prover** (GF helper block + Step-4 fix; QUOT G1 split + pins for the 2 sub-lemmas), and the
QUOT bundled-`IsInternal` form is now a hard **do-not-retry** blocker pending a mathlib-analogist
consult. FBC needs the Seam 2/3 mechanism written into the chapter before re-dispatch.
