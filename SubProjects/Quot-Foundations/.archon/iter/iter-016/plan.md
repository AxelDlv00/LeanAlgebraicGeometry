# Iter 016 — Plan (Quot-Foundations)

## TL;DR

Blueprint + strategy + consult iter with a **2-lane prover dispatch** (FBC, GF) via the same-iter
fast path, and a **major QUOT route pivot** done structurally (no QUOT prover this iter — sanctioned
sequencing). Entry: iter-015 closed 0 sorries but landed real content (QUOT +3 axiom-clean decls, FBC
Seam-2 scaffold, GF abstract-T descent helper) and surfaced three chapter must-fix findings that
closed the HARD GATE on all three live lanes. All three mandatory critics fired: **progress-critic** =
FBC CONVERGING, GF CONVERGING, **QUOT CHURNING** (corrective = structural refactor / route pivot);
**strategy-critic** = Route 2 **SOUND** ("cleaner-than-canonical") + 4 must-fix (SNAP-S1 challenge,
format DRIFTED, 2 minor wordings) — all addressed in STRATEGY.md; **blueprint-reviewer** re-run this
iter to clear the fast-path gate. The decisive move was the **mathlib-analogist** consult, which
converted QUOT's hard `isDefEq`/`whnf` dead end (G2–G4 quotient/subtype graded `Decomposition`,
non-terminating at 2M heartbeats) into **Route 2: an ambient subquotient induction** that makes the
runaway *structurally impossible* (every object is `Naux ⊓ ℳn` in a fixed ambient `M`, the shape G1
proved safe), eliminating G2/G3/G4 and reducing G5 to ambient bookkeeping.

## State at entry (iter-015 outcomes)

- **FBC 4→4** — Seam 2 (`base_change_mate_fstar_reindex`, sorry) leg-identification scaffold landed +
  Γ-split; prover hit the exact conjugate-calculus coherence gap and recorded the validated recipe
  (`conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` + Seam 1; transparent-coherence collapse).
  Seam 3, affine-iso, FBC-B still sorry.
- **GF 4→5** (+1) — L5 `exists_free_localizationAway_polynomial` steps 1,2,5 wired; steps 3–4 isolated
  to a new abstract-`T` helper `free_localizationAway_of_away_tower` (the OreLocalization instance
  diamond blocked the IH application on the concrete quotient). CHURNING signature, but the helper is
  the explicit closure target.
- **QUOT 4→4** (+3 axiom-clean decls: D5, G1a `homogeneousSubmodule_inf_iSupIndep`, G1b
  `homogeneousSubmodule_iSup_inf_eq`) — G2–G4 BLOCKED by the subtype/quotient-module `isDefEq`
  pathology (`memory/graded-quotient-module-isdefeq-pathology.md`), confirmed non-terminating.
- GR / RegroupHelper: DONE (0 sorry).

## Critic dispositions

- **progress-critic `iter016`** — FBC CONVERGING (5→5→4→4; Seam-1 COMPLETE a real structural advance;
  no helper churn; throughput SLIPPING → revise FBC est, done), GF CONVERGING (the +1 helper is a
  deliberate decomposition vehicle, not churn; close it, no more helpers), **QUOT CHURNING**
  (4 graded-API stubs static across the K=4 window; G2–G4 non-termination is a kernel-level dead end —
  primary corrective = **structural refactor / route pivot**; the proposed analogist-consult + pivot +
  blueprint surgery IS the correct response). dispatch-sanity OK (2 prover files + 1 structural action;
  QUOT deferral justified). Advisories acted on: FBC est revised; partial-success bars pre-declared
  (below); QUOT iter-017 entry criterion = a named elaboration-terminating ambient formulation
  (Route 2 supplies it).
- **strategy-critic `iter016`** — Route 2 **SOUND** (checked against verbatim Stacks 00K1; the
  4-term degreewise sequence even subsumes Stacks' nilpotent case split — "cleaner than canonical");
  FBC/GF/QUOT-defs/QUOT-repr all SOUND; 5 Mathlib prereqs verified. Must-fix (all addressed in
  STRATEGY.md this iter):
  1. **SNAP-S1 CHALLENGE** — named the cohomology-free f.g. lemma `lem:sectionGradedModule_fg` =
     **Serre/Hartshorne II.5.17 (ch II)** giving `M = Γ_*(F)` so `dim M_m = dim Γ(F_s⊗L_s^m)` in all
     degrees, with the explicit "never via the only-left-exact `F↦⊕Γ(F⊗L^m)`, so no H¹ re-enters".
  2. **Format DRIFTED** — scrubbed all ~10 per-iter-narrative sites to present tense; trimmed
     18.5 KB → ~15.8 KB (condensed redundant SNAP/Mathlib-gaps prose, tightened FBC/GF/QUOT-defs
     route paragraphs). Residual is irreducible strategic detail across 8 phases.
  3. **FBC Seam-2 framing** — resolved the contradiction: Seam 2 is a *distinct construction* (the
     generic-pullback-square reindex) that is *not itself* an adjunction-unit identity but *uses* the
     same conjugate calculus to feed Seam 1.
  4. **QUOT-defs qcoh bridge** — reworded "OFF the critical path" → "goal-required (via
     `thm:grassmannian_representable`), deferred in sequencing".
- **blueprint-reviewer `iter016`** — re-run this iter (fast path) after the 3 writer rounds +
  blueprint-clean; verdict folded into the gate decision below.

## Decision made

### 1. QUOT route pivot to Route 2 (ambient subquotient induction)
- **Why:** the iter-014 plan (build `K=ker x`, `C=M/xM` as graded `R/(x)`-modules) forces a
  `DirectSum.IsInternal`/`Decomposition` on a quotient/subtype carrier, which is *definitionally*
  `Bijective (coeAddMonoidHom)` and sends `whnf` into a non-terminating reduction over the derived
  carrier (2M-heartbeat repros). This is a kernel-level dead end, not a proof gap — budget cannot fix
  it. The analogist verified the only sound escape is to never leave the ambient `M`: range the
  Stacks-00K1 induction over pairs `N'≤N` of ambient homogeneous submodules with commuting degree-+1
  endos, conclude `IsRatHilb` of the ambient difference `dim(N⊓ℳn) − dim(N'⊓ℳn)`. ker/coker of a
  degree-1 endo stay ambient subquotient pairs ⇒ no derived-carrier object ever forms.
- **LOC/risk trade-off:** eliminates G2/G3/G4 (~big quotient-ring build, all blocked) and reduces G5
  to ambient FG bookkeeping; reuses the landed G1 + D5 + the `IsRatHilb` toolkit. Residual = 6 ordered
  ambient lemma-groups (~150–280 LOC, 2–3 iters). The prover's conclusion-only Hilbert restatement
  was rejected by the analogist (Q2′ does NOT escape the blocker — the IH *hypothesis* must also be
  derived-carrier-free); Route 2 (subquotient-class IH) is the sound realization.
- **Cheapest reversal signal:** if the iter-017 prover hits a *new* `isDefEq` trap on any ambient
  `Naux ⊓ ℳn` family (it should not — G1 proved that shape safe), fall back to
  `DirectSum.Decomposition.ofLinearMap` (documented Route-1 fallback) for the specific object.

### 2. No QUOT prover this iter — structural pivot only (writer + clean + gate-clearing review)
- **Why:** Route 2 is a brand-new induction architecture (6 new blocks). Dispatching a prover on a
  freshly-rewritten large blueprint in the SAME iter is the low-quality-prover-work failure the HARD
  GATE exists to prevent. The progress-critic explicitly endorses deferral as "prerequisite
  sequencing, not avoidance," and asked for a named elaboration-terminating formulation as the
  iter-017 entry criterion — Route 2 provides exactly that. The iter is far from idle: 2 provers + a
  major pivot + 3 writer rounds + clean + 4 consults.

### 3. Dispatch FBC + GF provers via the same-iter fast path
- Both are CONVERGING with concrete closure recipes; their writer rounds (Seam 2/3 mechanism; GF
  helper block + Step-4 fix) addressed the iter-015 must-fix findings. After blueprint-clean + the
  scoped re-review return them complete+correct, they enter objectives this iter (fast path).
- **Pre-declared partial-success bars** (progress-critic advisory):
  - FBC: closing Seam 2 alone is success (drops to ~2–3 sorries; Seam 3 may slip).
  - GF: closing `free_localizationAway_of_away_tower` + wiring L5 steps 3–4 is success (L4/assembly
    may slip to iter-017).

## Subagents dispatched (8)

- progress-critic `iter016`, strategy-critic `iter016` — verdicts above.
- mathlib-analogist `quot-graded-quotient` (api-alignment) — Route 2 verdict + ordered residual build
  list; persistent file `analogies/quot-hilbert-function-route.md`.
- blueprint-writer `fbc-seams` (Seam 2/3 mechanism), `gf-tower-descent` (helper block + Step-4 fix +
  2 Mathlib anchors), `quot-route2` (the major re-skeleton: G1 split, G2/G3/G4 dropped, 5 Route-2
  blocks, proof rewritten) — all COMPLETE, leandag clean.
- blueprint-clean `iter016` — pure (one FBC copy-edit artifact fixed); `% RECIPE`/`% LEAN DEPS`
  comments + `\mathlibok` anchors preserved.
- blueprint-reviewer `iter016` — gate-clearing whole-blueprint re-review (fast path).

## Coverage debt

- iter-015's 3 unmatched `lean_aux` nodes cleared by the writers: GF helper now has
  `lem:gf_away_tower_descent`; the two QUOT G1 halves now have the split blocks
  `lem:graded_homogeneousSubmodule_iSupIndep` / `_iSup_eq`. Writers report leandag `isolated: 0`,
  `unknown_uses: []`.
- The 5 new Route-2 QUOT `\lean{}` pins point at decls the iter-017 prover creates (tex precedes Lean,
  as designed).

## Gate result (blueprint-reviewer `iter016`, fast path)

- **FBC-A prover: PASS** (`complete: true, correct: true`, 0 must-fix) — Seam 2/3 mechanisms concrete.
- **GF-alg prover: PASS** (`complete: true, correct: true`, 0 must-fix) — `lem:gf_away_tower_descent`
  correctly stated, Step 4 consistently repointed.
- **QUOT iter-017 prover: CONDITIONAL PASS** — all 5 Route 2 blocks complete+correct, `(⊤,⊥)` bridge
  recovers `dim_κ Mₙ`, no dangling G2/G3/G4 refs, well-formed pins. Sole finding = the pre-existing
  `thm:grassmannian_representable` weakened pin (documented deferred open question), NOT a Route 2
  blocker. leandag clean (167 nodes, 0 isolated, 0 unknown_uses).
- ⟹ FBC + GF enter `## Current Objectives` this iter via the fast path; QUOT prover deferred to iter-017.

## Unstarted-phase proposals (blueprint-reviewer) — deferral rationale

- **FBC-B globalization** (no chapter): DEFER — it consumes `lem:affine_base_change_pushforward`
  which is still sorry (FBC-A in progress this iter). Author the globalization chapter once FBC-A
  lands (FBC-B is the NEXT phase row).
- **SNAP-S1 Snapper / `def:hilbert_polynomial`** (no sketch): DEFER — gated on the rationality engine
  (Route 2, in build) + the `def:sectionGradedRing` sheaf bridge (its own NEXT phase row). The
  cohomology-free f.g. input `lem:sectionGradedModule_fg` (Serre/Hartshorne II.5.17) is now named in
  STRATEGY.md; author the SNAP-S1/S3 chapter when the rationality engine reaches the frontier.
- **GR-repr Yoneda upgrade** (`thm:relative_spec_univ` → `RepresentableBy`): DEFER — QUOT-repr is
  BLOCKED 6–12 iters out; this is the known weakened-pin item, tracked in task_pending. Not on the
  current frontier.

## Tool substitutions

- None. (No LLM API key in env — `archon-informal-agent.py` unavailable — but the mathlib-analogist
  subagent supplied the QUOT structural verdict, so no substitution was needed.)
