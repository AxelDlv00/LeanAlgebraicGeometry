# Iter 007 — Plan (Quot-Foundations)

## TL;DR

Effort-break + open-third-lane iter. Processed the iter-006 prover results (both PARTIAL, sorry
unchanged 4/4): FBC's `map_smul'` one-liner was definitively REFUTED as mathematically unsound (the
two A-module tensor carriers are different types, not a reducibility diamond), and `generator_trace_eq`
got only an `ext x` reduction; GF landed the strong-induction-generalizing-N skeleton but the
generic-rank SES dévissage stayed Mathlib-absent. Both lean-vs-blueprint checkers + the iter-006
review converged: **the cruxes are now monolithic Mathlib-absent constructions that need blueprint
decomposition before any further prover dispatch** (FBC carried a live must-fix on the regroupEquiv
prescription; both GF residues under-specified). progress-critic `iter007`: **CHURNING×2** (FBC
higher severity, GF at STUCK boundary), corrective = blueprint expansion, dispatch=OK. strategy-critic
`iter007`: **SOUND** on all three routes.

This iter: (1) dispatched a mathlib-analogist that resolved the generic-rank Lean API AND surfaced the
real root cause of the GF stall — **the induction must generalize the base domain `A`, not just `N`**;
(2) two blueprint-writers decomposed the FBC and GF cruxes into 6 concretely-typed sub-lemmas + fixed
the FBC must-fix; (3) blueprint-clean + full blueprint-reviewer → **HARD GATE PASS** for all three
lanes; (4) refactor created+wired `GrassmannianCells.lean`; (5) opened the QUOT-defs frontier as the
third parallel PROVER lane (2 files) — the only prover work this iter, since FBC/GF are correctly
deferred for decomposition. Build GREEN throughout.

## State at entry

- iter-006 prover: FBC 4→4 (one-liner refuted, `ext x` landed); GF 4→4 (strong-induction skeleton
  landed, dévissage residue remains). Build green.
- Reviews of record (iter-006): lean-auditor + 2 lean-vs-blueprint-checkers — 0 must-fix on the LEAN
  side, but the FBC checker raised 1 **blueprint** must-fix (the regroupEquiv one-liner prescription is
  wrong) + majors on both files' under-specified residues.

## Critic dispositions

- **progress-critic (`iter007`): CHURNING×2, dispatch=OK.** FBC-A escalated — the blueprint carried a
  provably-wrong `map_smul'` prescription (the "[verified by prover]" annotation was pin-specific and
  misdirected the iter-006 prover); sorry net +1 over the window; OVER_BUDGET (5 iters vs 3–5 est).
  GF-alg at the STUCK boundary (generic-rank SES blocker ×3 prover iters; held off STUCK only by the
  iter-006 strong-induction advance). Named corrective for both: **blueprint decomposition into
  concretely-typed sub-lemmas** + "iter-008 MUST dispatch FBC/GF or it crosses into avoidance." The
  QUOT-defs opening was explicitly confirmed as genuine parallelism, not avoidance.
- **strategy-critic (`iter007`): SOUND, 0 CHALLENGE/REJECT.** FBC direct-on-sections IS the canonical
  i=0 skeleton (Stacks 02KH part 2); GF Nitsure §4 dévissage is the textbook decomposition; QUOT graded-
  Hilbert encoding is sound + Čech-independent for this leg; 3 parallel ACTIVE lanes is correct, not
  over-extension. Two housekeeping must-fixes (non-blocking): format DRIFTED (iter-003 narrative) and
  confirm the re-signed signatures match the parent cone. Good find: `Mathlib.RingTheory.Flat.Equalizer`
  exists → FBC-B less risky than billed.
- **blueprint-reviewer (`iter007`): HARD GATE PASS** for all three lanes — FBC iter-006 must-fix
  RESOLVED, 6 new sub-lemmas well-formed, QUOT-defs frontier cleared. One advisory (fixed this iter):
  the 2 FBC sub-lemmas were proof-level-`\uses` only → added to statement-level `\uses{}`.

## Decision made

### Defer FBC/GF prover, open QUOT-defs as the third lane; decompose the cruxes via blueprint
- **Option chosen:** no prover on FBC/GF this iter (blueprint being decomposed); the 2 gate-cleared
  QUOT-defs frontier files become the iter's prover lanes; both cruxes decomposed into sub-lemma chains
  for iter-008.
- **Why:** both checkers + the progress-critic agree the cruxes are Mathlib-absent monoliths whose
  blueprints needed decomposition (FBC had a live must-fix); re-dispatching the monoliths is exactly the
  churn the critic exists to catch. The QUOT-defs frontier was gate-cleared at iter-006 and is genuine
  idle-capacity parallelism (critic-confirmed). This satisfies the standing PARALLELISM directive
  (third lane, split across two files) AND the standing REFERENCE-DRIVEN directive (every sub-lemma is
  anchored to Nitsure §4 / Stacks "Affine base change", with verbatim quotes).
- **Trade-off:** one plan-only iter on FBC/GF (no sorry closed there), but the alternative — a 3rd
  monolith re-dispatch — burns a prover iter for guaranteed PARTIAL. The cheap signal that would reverse
  this: if iter-008's sub-lemma stubs turn out un-closeable, GF reclassifies STUCK and pivots.
- **iter-008 commitment:** FBC + GF prover dispatch is MANDATORY (recorded in PROGRESS + task_pending).

### GF base-domain generalization (strategy-modifying, accepted)
The mathlib-analogist found the iter-006 "generalize N" skeleton is necessary but INSUFFICIENT: the
reindex inverts `g ∈ A`, so `T_g` is finite over `MvPolynomial (Fin m') A_g` — base ring `A_g`, not
`A` — and `IH m' _ T_g` doesn't typecheck unless the induction also reverts `A` into the motive. This
is the real cause of the iter-006 stall (not the rank API). Recorded in STRATEGY.md (GF route) + the
blueprint `% LEAN PROOF STRUCTURE` note + `analogies/gf-generic-rank-ses.md`. It is a reversion change,
not a public-signature change.

## Subagents dispatched (this iter)

- progress-critic `iter007` (read-only) — CHURNING×2.
- strategy-critic `iter007` (read-only) — SOUND.
- mathlib-analogist `gf-genrank` (api-alignment) — resolved generic-rank API + base-domain finding;
  persistent `analogies/gf-generic-rank-ses.md`.
- blueprint-writer `fbc-decomp` — fixed regroupEquiv must-fix + 3 FBC sub-lemmas + thin assembly.
- blueprint-writer `gf-decomp` — 3 GF sub-lemmas + L5/L4 thin assemblies + base-domain note.
- blueprint-clean `iter007` — stripped Lean-tactic prose from the FBC regroupEquiv proof (recipe
  preserved in-code + writer report); GF prose already clean.
- blueprint-reviewer `iter007` — HARD GATE PASS, all three lanes.
- refactor `scaffold-grcells` — created+wired `Picard/GrassmannianCells.lean` (affineChart stub, build
  green +1 sorry).

## Subagent skips

- (none material) — all three highly-recommended plan-phase critics ran (progress-critic,
  strategy-critic, blueprint-reviewer). strategy-critic was run rather than skipped because the last
  COMPLETED strategy-critic verdict was iter-003 (iter-005's directive produced no report), so the
  "prior verdict SOUND" skip precondition could not be established, and this iter makes a real
  resource-allocation shift (opening the third lane).

## Notes / risks forward

- FBC route (b) fallback: if the iter-008 prover's route-(a) `TensorProduct.ext`-at-full-carrier still
  fights the opaque `Module R'` instance, dispatch a writer to add the small ModuleCat base-change-square
  helper block (writer `fbc-decomp` is primed to author it).
- GF STUCK risk: GF is at the STUCK boundary; the iter-008 sub-lemmas MUST produce closeable
  obligations. The shared variable-drop engine (L4 ↔ reindex) is the one genuinely novel Mathlib-absent
  build — if it stalls, effort-break it sentence-by-sentence (fine granularity).
- Blueprint-clean removed the Lean lemma-name recipe from the FBC regroupEquiv visible prose (purity);
  it survives in the `.lean` in-code comment at the sorry + the writer report — the iter-008 prover
  reads its own file, so the recipe is available.
