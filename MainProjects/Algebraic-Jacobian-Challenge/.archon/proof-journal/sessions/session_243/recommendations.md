# Recommendations — after iter-243

## Top priority: BOTH active lanes are now route-blocked behind confirmed Mathlib-scale constructions

This is the defining fact for the next plan. Neither lane is a proof-search gap any longer; both
have been reduced — with first-hand Mathlib scouting — to genuinely-absent constructions. Re-dispatching
either lane verbatim as a `prove`/`mathlib-build` round on the SAME target will produce another flat
iter. The decision points below are strategic, not tactical.

### Lane 1 (`Picard/TensorObjSubstrate.lean`, A.1.c critical path) — `IsInvertible.isLocallyTrivial`
- **Status:** deliverable 1 (`pullbackTensorMap`/δ_sheaf) LANDED axiom-clean this iter; deliverables 2
  and 3 BLOCKED, 3 only on 2. The critical path now passes entirely through deliverable 2.
- **The blocker (precise, do NOT re-derive):** two absent scheme-level ingredients —
  (1) stalk-invertibility plumbing (~150 LOC, no single lemma), and (2) **finite-presentation
  spreading-out for `SheafOfModules` on a scheme** (the hard one; Mathlib has it only at the
  CommRing/LocalizedModule level, and M's finite presentation is not even part of the SheafOfModules
  data — it must first be derived from invertibility via QC/finite-type infra the bare carrier lacks).
- **Recommended next move (pick one, do NOT just re-dispatch):**
  - (a) **Open a dedicated mathlib-build sub-lane for ingredient (2)** — finite-presentation
    spread-out over `SheafOfModules`/tilde. This is the substantive engine build; blueprint it first.
  - (b) **Mathlib bump** supplying an `AlgebraicGeometry`-level "invertible ⇒ locally free of rank 1".
    Check whether the pinned Mathlib (or a near bump) has anything in
    `Mathlib.AlgebraicGeometry.*`/`Mathlib.RingTheory.PicardGroup` that lifts to schemes before
    committing to the in-tree build.
  - **Before either:** dispatch `mathlib-analogist` (api-alignment) on ingredient (2) to confirm the
    spread-out really is absent at the pin and to fix the target signature shape — this is exactly the
    "absent construction, blueprint a sub-build" situation the analogist de-risks.
- **Do NOT** ask a prover to write the ~150-LOC stalk-invertibility fragment alone: it reaches no
  blueprint pin and leaves blocker (2) fully intact (the prover correctly declined it this iter).

### Lane 2 (`Cohomology/FlatBaseChange.lean`) — `affineBaseChange_pushforward_iso`
- **Status:** both named obligations (`base_change_map_affine_local`,
  `pushforward_base_change_mate_cancelBaseChange`) BLOCKED, Mathlib-scale, no quick in-tree sub-step.
  The aux brick `pushforwardBaseChangeMap_naturality` was attempted and died on the SheafOfModules
  functor `.map`-of-composite defeq wall (both `rw` no-match and `erw` whnf-explosion).
- **progress-critic ts243 watch-signal TRIGGERED** (both obligations blocked, no in-tree reduction).
  **The documented fallback is the `#37189` Mathlib bump** (`isIso_fromTildeΓ_pushforward`), which
  supplies in-tree exactly the bespoke-map↔`tilde(cancelBaseChange)` bridge that is obligation 2.
- **Recommended next move:** take the #37189 bump (the standing decision since iter-240's
  `algebraize` route note). If staying in-tree is preferred, the ONLY paths with any hope are:
  (i) restore a working informal-agent key so the mate-unwind can be sketched, then (ii) tackle the
  naturality bricks strictly section-wise via `pushforwardComp_*_app_app = id` to dodge the
  functor-defeq wall before the square-restriction compatibility — but this is high-risk and the
  prover already showed the section-wise route hits the same defeq-display wall.
- **DO NOT re-dispatch** another `rw`/`erw` round on `Functor.map_comp`/`Functor.comp_map`/
  `NatTrans.naturality_assoc` applied to `pushforward`/`pullback` `.map`-of-composite terms — `rw`
  does not match (defeq-not-syntactic), `erw` whnf-explodes. This is now a recorded dead end.

## Dead ends — do not retry (reusable across the project)
- **SheafOfModules functor `.map`-of-composite is NOT syntactically rewritable.** `rw` of
  `Functor.map_comp` / `Functor.comp_map` / `NatTrans.naturality_assoc` on `(pushforward/pullback …)
  .map`-of-composite fails with "did not find an occurrence of the pattern"; `erw` whnf-explodes
  (200000-heartbeat timeout). Use `erw [Functor.map_comp_assoc]` only for the single unit-composite
  split that works; everything else must go section-wise — and even section-wise, the
  `pushforwardComp_*_app_app = id` rewrites hit the same defeq-display wall (`simp` "unused",
  `rw` no-match, `aesop_cat` stalls).
- **`cancelBaseChange` will not orient standalone** to the blueprint's affine objects (`R'` is not an
  `A`-module in the affine setup); a standalone wrapper guesses the wrong module objects → low value.

## Reusable proof patterns discovered / reconfirmed
- **The `φ'` let-coercion to unstick stuck monoidal-instance accessors.** When
  `Functor.OplaxMonoidal.δ`/`μ` (or any monoidal accessor) reports "typeclass instance problem is
  stuck" because the `MonoidalCategory` instance is keyed on the CommRingCat `forget₂`-form while the
  hom presents the RingCat form, introduce
  `let φ' : (… ⋙ forget₂ CommRingCat RingCat) ⟶ (… ⋙ forget₂ CommRingCat RingCat) := φ.hom` and use
  `φ'` at the accessor; the surrounding `≫`-composition bridges `φ.hom ≟ φ'` and `⊗ₚ ≟ ⊗` by defeq
  with no manual `change`. (This is the third iter in a row this trick lands a comparison map —
  iter-242 lax/oplax, iter-243 δ_sheaf.)
- **`tensorObj_unit_iso` reflective-counit idiom** for "sheafify-then-pullback ≅ abstract pullback"
  helpers: `(sheafificationCompPullback φ).symm.app M.val ≪≫ (pullback f).mapIso (asIso(...).counit.app M)`.

## Review-subagent findings (iter-243)

Both review subagents returned with **0 must-fix-this-iter**. Reports:
`task_results/lean-auditor-ts243.md`, `task_results/lean-vs-blueprint-checker-ts243-tensorobj.md`.

### lean-vs-blueprint-checker (ts243-tensorobj) — CLEAN
- `pullbackTensorMap` confirmed faithful to `lem:pullback_tensor_map` (signature + proof match,
  general M,N comparison map, not weakened). `IsInvertible.{isLocallyTrivial,pullback}` correctly
  pinned-but-absent (no placeholder sorry). No signature/pin mismatch. (The suggested symmetric
  `% NOTE:` on `lem:isinvertible_pullback` has been ADDED this review.)

### lean-auditor (ts243) — MEDIUM (documentation rot in TensorObjSubstrate.lean; .lean edits — assign to the file's prover)
The two new decls (`pullbackTensorMap`, `pullbackValIso`) are genuine and hidden-sorry-free; no
leftover scaffolding from the removed `pushforwardBaseChangeMap_naturality` brick. Three stale-comment
items, ALL in `TensorObjSubstrate.lean` (none affect correctness; the prover must fix — review cannot
edit `.lean`):
- **(major) L323–340** — `tensorObj_assoc_iso` docstring still describes the OLD flatness-based route
  ("genuine residual is now the flatness…", the `W_whiskerLeft/Right_of_flat` paragraph). The actual
  proof is UNCONDITIONAL (uses `W_whiskerRight_of_W`/`W_whiskerLeft_of_W` since iter-238). Excise the
  flatness text from the public-facing docstring.
- **(major) L43–45 + L302–303** — file header and `tensorObj_assoc_iso` docstring claim
  `isLocallyInjective_whiskerLeft_of_W` is a remaining sorry-residual; the KB ([[ts237-whiskering-sorry-closed]])
  records it closed axiom-clean at iter-237. Verify against `Vestigial.lean` and update the header +
  docstring (or add a cross-file note if Vestigial's open sorry is a different decl).
- **(minor) L1254–1255** — `addCommGroup_via_tensorObj` docstring cites "iter-202/204+" (39+ iters
  stale); update to the current open status without the outdated iter tags.

`FlatBaseChange.lean` audited fully clean (both sorry-bearing theorems honestly documented, all
sorry-free decls genuine).

## Environment blocker (carry forward)
- **Informal-agent down (401).** `MOONSHOT_API_KEY` invalid since iter-234; no other provider key set.
  Both lanes this iter wanted a second opinion on a multi-hundred-LOC unwind and could not get one.
  A fresh key would materially help the in-tree Lane-2 path; surface to the user.
