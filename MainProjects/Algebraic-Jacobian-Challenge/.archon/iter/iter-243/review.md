# Iter-243 (Archon canonical) — review

## Outcome at a glance

- **The "Lane 1 lands its PRIMARY δ_sheaf comparison map axiom-clean; both lanes then confirm their
  remaining targets Mathlib-scale and hand off precisely" iter.** Two prover lanes, both `partial`:
  - **`Picard/TensorObjSubstrate.lean`** (mathlib-build, A.1.c critical path): **2 axiom-clean
    declarations LANDED** — the PRIMARY `pullbackTensorMap` (= δ_sheaf, `lem:pullback_tensor_map`,
    L1220), the sheaf-level comparison map `f^*(M⊗N) ⟶ f^*M ⊗ f^*N` for general `M,N`, plus the
    helper `pullbackValIso` (L1203). Deliverables 2 (`IsInvertible.isLocallyTrivial`) and 3
    (`IsInvertible.pullback`) left absent, **no sorry pinned**, with a verified-precise handoff.
    File sorry **2 → 2** (the two pre-existing deferred sorries untouched).
  - **`Cohomology/FlatBaseChange.lean`** (engine, affine close): **0 declarations added.** The aux
    brick `pushforwardBaseChangeMap_naturality` was built to the final naturality square and then
    **removed (no sorry)** when it hit the SheafOfModules functor `.map`-of-composite defeq wall.
    Both named obligations confirmed Mathlib-scale. File sorry **2 → 2**.
- **Canonical critical-path counter: flat.** No pre-existing canonical sorry eliminated. BUT Lane 1
  closed a fully-new axiom-clean theorem on the critical path (`pullbackTensorMap` — the sheaf-level
  carrier of the δ comparison the iter-241 KB said had "no canonical map to even state the iso").
  `sync_leanok` iter 243, sha `ca65ebef`, **+3 / −0** on `Picard_TensorObjSubstrate.tex`.
- **Build GREEN** both files. **Axioms re-verified first-hand:** `pullbackTensorMap` →
  `{propext, Classical.choice, Quot.sound}` (the `lean_verify` "opaque" flag at L488 is the word in a
  prose comment — not laundering). **Blueprint-doctor CLEAN** (no orphan chapters, all `\ref`/`\uses`
  resolve, no `axiom` decls).

## The defining tension — the critical-path counter has now been flat for FIVE iters, and BOTH lanes are route-blocked behind confirmed-absent Mathlib constructions

iters 239–243 have produced a steady stream of axiom-clean bricks (sheafify-monoidal isos, the
affine push+pull tilde dictionary, presheaf lax/oplax δ, and now the sheaf-level δ_sheaf) but the
Picard group's own canonical sorries (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) and
the FlatBaseChange affine-close sorries have not moved since iter-238. This iter sharpens *why*: with
δ_sheaf now in hand, Lane 1's critical path passes entirely through deliverable 2
(`IsInvertible.isLocallyTrivial`), and the prover's first-hand Mathlib scout confirms that is
**Mathlib-scale** — specifically the absence of finite-presentation spreading-out for `SheafOfModules`
on a scheme (Mathlib has it only at the CommRing/LocalizedModule level, and M's finite presentation
is not even part of the SheafOfModules data). Lane 2's affine close is the same shape: the
bespoke-map↔`tilde(cancelBaseChange)` bridge is a multi-hundred-LOC unwind that the standing #37189
bump supplies in-tree.

**Honest framing for iter-244:** both lanes are now strategic decisions, not proof-search rounds.
Re-dispatching either verbatim produces a sixth flat iter. The productive moves are
(Lane 1) a dedicated mathlib-build sub-lane for finite-presentation spread-out OR a Mathlib bump for
AG-level invertible⇒locally-free, gated on a `mathlib-analogist` confirmation of absence at the pin;
and (Lane 2) take the #37189 bump (the progress-critic ts243 watch-signal fired). Neither prover
churned or pinned a sorry this iter — both did the disciplined thing under the no-sorry-pin invariant.

## Reversing signals — read against outcomes

- **Lane 1:** the iter-242 review predicted deliverable 2 would be confirmed Mathlib-scale and that
  the "local-trivialization pivot" was the productive move. This iter's prover empirically confirmed
  the Mathlib-scale verdict AND landed the δ_sheaf carrier the pivot needs — but also showed the
  pivot itself is gated on the SAME finite-presentation spread-out, so it is not the cheap escape the
  iter-242 framing hoped. The honest update: the local-trivialization route does NOT sidestep the
  Mathlib-scale build; it routes through it.
- **Lane 2:** the standing "if both obligations come back blocked with no in-tree reduction → take
  #37189, NOT another in-tree round" watch-signal **fired this iter**. The prover attempted exactly
  one within-reach aux brick, confirmed the defeq wall, removed it, and recommended the bump. This is
  the trip-wire working as designed — iter-244 must honour it.

## Marker / laundering audit
- `pullbackTensorMap` axiom-clean (re-verified). No `\leanok` laundering: the three `sync_leanok`
  additions are the script's deterministic verdict on this iter's tree (sha `ca65ebef`).
- Added one `% NOTE:` to `lem:isinvertible_implies_locallytrivial` recording the iter-243
  Mathlib-scale confirmation (two precise absent ingredients). No `\mathlibok` (no pure re-export).

## Subagent findings
Both review subagents dispatched (the .lean files received prover work) and returned
**0 must-fix-this-iter**:
- **lean-vs-blueprint-checker (ts243-tensorobj) — CLEAN.** `pullbackTensorMap` faithful to
  `lem:pullback_tensor_map`; `IsInvertible.{isLocallyTrivial,pullback}` correctly pinned-but-absent.
  Suggested symmetric `% NOTE:` on `lem:isinvertible_pullback` — ADDED this review.
- **lean-auditor (ts243) — MEDIUM (documentation rot only).** New decls genuine, no hidden sorry, no
  leftover scaffolding. 3 stale-comment items in `TensorObjSubstrate.lean` (2 major, 1 minor — all
  `.lean` docstring/header fixes the file's prover must make next iter; review cannot edit `.lean`):
  the `tensorObj_assoc_iso` docstring still describes the dead flatness route (proof is unconditional
  since iter-238), the header still lists `isLocallyInjective_whiskerLeft_of_W` as an open sorry
  (closed iter-237 per KB — verify vs `Vestigial.lean`), and 39-iter-stale iter tags on
  `addCommGroup_via_tensorObj`. `FlatBaseChange.lean` audited fully clean. Landed in
  `recommendations.md` for the next plan agent to assign a cleanup pass.
